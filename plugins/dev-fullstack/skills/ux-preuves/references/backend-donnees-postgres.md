# Fiche `ux-preuves` — Backend — données, PostgreSQL et migrations

> Fiche du skill `ux-preuves` (dev-fullstack), volet **backend**, préchargé par `backend`. Couvre : migrations sans interruption (verrous, `lock_timeout`, `CREATE INDEX CONCURRENTLY`, `NOT VALID`), expand/contract, index, pagination par curseur, transactions et isolation, contraintes contre validations applicatives (Bailis et al. 2015), ORM et N+1 (Prisma 7 et 8, SQLAlchemy, Drizzle), pools de connexions et serverless, RLS Supabase, PostgreSQL 18 et UUIDv7, SQLite.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Versions, statuts de brouillons IETF et API
> **vieillissent en mois** ; le droit change par révision : avant d'écrire du code qui en dépend,
> relire la page officielle (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Recherche documentaire vérifiée, 9 novembre 2026. Toutes les pages citées ont été ouvertes (WebFetch,
ou curl + `pdftotext` pour le PDF). La documentation PostgreSQL consultée est la version courante :
**PostgreSQL 18 (18.6)**. Les citations viennent du lecteur de pages et sont reproduites telles que lues.
Niveaux : N1 norme/RFC, N2 recherche revue par pairs, N3 documentation officielle, N4 praticien ou éditeur.

35 entrées.

---

## 1. Migrations sans interruption

### Toute commande DDL est présumée prendre un verrou ACCESS EXCLUSIVE (lectures comprises) tant que la doc de la commande ne dit pas le contraire
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « 13.3. Explicit Locking » et « ALTER TABLE », https://www.postgresql.org/docs/current/explicit-locking.html et https://www.postgresql.org/docs/current/sql-altertable.html
- Extrait lu : « Many forms of ALTER INDEX and ALTER TABLE also acquire a lock at this level. » ; « An ACCESS EXCLUSIVE lock is acquired unless explicitly noted. »
- Portée / limites : ACCESS EXCLUSIVE est le seul mode qui bloque un `SELECT` simple. Exceptions documentées : `CREATE INDEX` prend SHARE (lectures permises, écritures bloquées), `CREATE INDEX CONCURRENTLY` et `VALIDATE CONSTRAINT` prennent SHARE UPDATE EXCLUSIVE, `ADD FOREIGN KEY` prend SHARE ROW EXCLUSIVE sur les deux tables. `RENAME COLUMN` n'étant pas « explicitly noted », il prend ACCESS EXCLUSIVE.
- En code : pour chaque instruction DDL de la migration, quel niveau de verrou la doc lui attribue-t-elle, et combien de temps est-il tenu (métadonnées seules, ou scan/réécriture) ?

### Une migration fixe `lock_timeout` (et le rejoue) plutôt que d'attendre un verrou indéfiniment
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « 19.11. Client Connection Defaults » et « 13.3. Explicit Locking », https://www.postgresql.org/docs/current/runtime-config-client.html et https://www.postgresql.org/docs/current/explicit-locking.html
- Extrait lu : « Abort any statement that waits longer than the specified amount of time while attempting to acquire a lock […] A value of zero (the default) disables the timeout. » ; « a transaction seeking either a table-level or row-level lock will wait indefinitely for conflicting locks to be released. »
- Portée / limites : la doc déconseille de le régler dans `postgresql.conf` (« would affect all sessions ») : on le pose dans la session de migration. L'effet « file d'attente » (une demande ACCESS EXCLUSIVE en attente bloque les requêtes arrivées après elle) **n'est pas formulé dans la doc officielle lue** ; il est rapporté par un praticien (N4) : Chris Sinjakli, GoCardless, « Zero-downtime Postgres migrations - the hard parts », https://gocardless.com/blog/zero-downtime-postgres-migrations-the-hard-parts/ (page « Last edited Jun 2024 », date d'origine non affichée) : « read/write queries issued by calls to our API piled up behind it, and clients timed out » ; environ 15 s d'indisponibilité, alors que la même migration rejouée sur une sauvegarde prenait quelques centaines de ms. Recommandation du billet : « Set `lock_timeout` in your migration scripts to a pause your app can tolerate. »
- En code : la migration pose-t-elle `SET lock_timeout` (quelques secondes au plus) et le déploiement sait-il réessayer, ou une longue transaction applicative peut-elle la bloquer et, derrière elle, tout le trafic ?

### Ajouter une colonne avec un DEFAULT constant est instantané depuis PG 11 ; un DEFAULT volatil ou un changement de type réécrit la table
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2018 et 2025, « Release 11 » (sortie 2018-10-18) et « ALTER TABLE » (v18), https://www.postgresql.org/docs/release/11.0/ et https://www.postgresql.org/docs/current/sql-altertable.html
- Extrait lu : « Allow ALTER TABLE to add a column with a non-null default without doing a table rewrite […] This is enabled when the default value is a constant. » ; « Adding a column with a volatile DEFAULT (e.g., clock_timestamp()), a stored generated column, an identity column, or a column with a domain data type that has constraints will cause the entire table and its indexes to be rewritten. » ; « Changing the type of an existing column will normally cause the entire table and its indexes to be rewritten. »
- Portée / limites : exception au changement de type : pas de réécriture si le type est « binary coercible » et que `USING` ne change pas le contenu, mais les index peuvent être reconstruits. En PG 18, « Adding a virtual generated column never requires a rewrite. » L'instruction prend tout de même ACCESS EXCLUSIVE (brièvement) : la règle `lock_timeout` s'applique.
- En code : le DEFAULT est-il une constante (pas `now()`/`gen_random_uuid()` évalué par ligne) ? Un `ALTER COLUMN TYPE` sur une grosse table est-il traité comme une réécriture complète (nouvelle colonne + backfill) ?

### Un index sur une table en service se crée avec `CREATE INDEX CONCURRENTLY`, hors transaction, et l'échec laisse un index INVALID à supprimer
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « CREATE INDEX » (§ Building Indexes Concurrently) et « ALTER TABLE », https://www.postgresql.org/docs/current/sql-createindex.html et https://www.postgresql.org/docs/current/sql-altertable.html
- Extrait lu : « a regular CREATE INDEX command can be performed within a transaction block, but CREATE INDEX CONCURRENTLY cannot. » ; « the CREATE INDEX command will fail but leave behind an "invalid" index. This index will be ignored for querying purposes because it might be incomplete; however it will still consume update overhead. » ; « create the index using CREATE UNIQUE INDEX CONCURRENTLY, and then convert it to a constraint using this syntax. »
- Portée / limites : deux scans de table et attente de la fin des transactions existantes, donc plus lent. Reprise recommandée : `DROP INDEX` puis relancer, ou `REINDEX INDEX CONCURRENTLY`. Pendant un CIC sur un index unique, « INSERT ... ON CONFLICT statements on the same table may unexpectedly fail with a unique violation » (page INSERT). `ADD CONSTRAINT … USING INDEX` refuse un index partiel ou d'expression.
- En code : l'outil de migration enveloppe-t-il chaque fichier dans une transaction (ce qui fait échouer CIC) ? Le runbook prévoit-il la détection `pg_index.indisvalid = false` après échec ?

### Une contrainte CHECK ou FK sur une table existante s'ajoute `NOT VALID`, puis `VALIDATE CONSTRAINT` séparément ; `SET NOT NULL` s'appuie sur une CHECK validée
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « ALTER TABLE », https://www.postgresql.org/docs/current/sql-altertable.html ; et « Release 12 » (2019-10-03), https://www.postgresql.org/docs/release/12.0/
- Extrait lu : « if the NOT VALID option is used, this potentially-lengthy scan is skipped. The constraint will still be applied against subsequent inserts or updates » ; « validation acquires only a SHARE UPDATE EXCLUSIVE lock on the table being altered » ; « if a valid CHECK constraint exists […] which proves no NULL can exist, then the table scan is skipped. »
- Portée / limites : la note de version 12 dit seulement « Allow ALTER TABLE ... SET NOT NULL to avoid unnecessary table scans », sans nommer CHECK ; c'est la page ALTER TABLE v18 qui le précise. PG 18 ajoute « Allow ALTER TABLE to set the NOT VALID attribute of NOT NULL constraints » (notes de version 18.0). Tant qu'elle n'est pas validée, la contrainte ne couvre pas les lignes anciennes.
- En code : un `ADD CONSTRAINT … CHECK/FOREIGN KEY` sur une table peuplée est-il découpé en `NOT VALID` puis `VALIDATE` (idéalement dans deux migrations) ? Un `SET NOT NULL` est-il précédé d'une `CHECK (col IS NOT NULL) NOT VALID` validée ?

### Une modification de schéma incompatible se fait en « parallel change » : expand, migrate, contract
- Niveau de preuve : N4
- Source : Danilo Sato, 2014 (13 mai), « ParallelChange », martinfowler.com, https://martinfowler.com/bliki/ParallelChange.html
- Extrait lu : « In the expand phase you augment the interface to support both the old and the new versions. » ; « During the migrate phase you update all clients using the old version to the new version. » ; « Most database refactorings follow the parallel change pattern. »
- Portée / limites : source d'origine confirmée : l'article est de Danilo Sato, publié sur le site de Martin Fowler (pas de Fowler lui-même). Article de praticien, sans mesure. Il ne prescrit ni découpage en déploiements, ni backfill par lots.
- En code : la PR retire-t-elle ou renomme-t-elle une colonne encore lue par la version déployée de l'application ? Si oui, où sont l'étape « expand » et la date du « contract » ?

### Un renommage de champ via l'ORM se relit avant application : Prisma le génère par défaut comme DROP + ADD
- Niveau de preuve : N3
- Source : Prisma, 2025-2026, « Customizing migrations » (Prisma ORM v7), https://www.prisma.io/docs/orm/v7/prisma-migrate/workflows/customizing-migrations
- Extrait lu : « renaming a field in the schema results in a migration that will: » [créer la nouvelle colonne et supprimer l'ancienne avec ses données] ; « Making schema changes to existing fields, e.g., renaming a field can lead to downtime. » ; commande `prisma migrate dev --create-only` pour un brouillon.
- Portée / limites : la page propose deux sorties : éditer le SQL en `RENAME COLUMN` (sans perte de données, mais incompatible avec l'ancien code), ou le pattern expand/contract (ajouter, copier, basculer lectures/écritures, retirer). Le changelog Prisma (2026-10-09) annonce que les migrations Prisma ORM 8 « now ask about each model or field they would drop » ; Prisma 8 est encore en release candidate (voir § 5).
- En code : le SQL généré contient-il un `DROP COLUMN` que l'auteur n'a pas voulu ? La migration a-t-elle été générée avec `--create-only` et relue ?

### Le backfill d'une grosse table se fait par lots, dans une tâche distincte de la migration DDL
- Niveau de preuve : N4
- Source : GitLab, s.d. (doc vivante consultée le 09.11.2026), « Avoiding downtime in migrations », https://docs.gitlab.com/development/database/avoiding_downtime_in_migrations/
- Extrait lu : « To reduce database pressure you should instead use a background migration when migrating a column in a large table » ; « Background migrations spread the work / load over a longer time period, without slowing down deployments. » ; « Renaming columns the standard way requires downtime »
- Portée / limites : documentation interne d'un éditeur pour sa propre base (Rails, très grosse instance) : pratique éprouvée, pas une preuve générale. Elle décrit aussi un renommage et une suppression de colonne en plusieurs versions (« ignore the column (release M), then, drop it in the next release (release M+1) ») et des `lock_timeout` courts avec réessais (`with_lock_retries`). Aucune source officielle PostgreSQL lue ne prescrit la taille des lots.
- En code : un `UPDATE … SET nouvelle_col = …` sans `WHERE` borné sur une grosse table dans la migration de schéma ? Le backfill est-il idempotent et reprenable ?

---

## 2. Index

### Un index se justifie par une requête fréquente qui filtre, joint, met à jour ou supprime ; chaque index a un coût en écriture et les index inutilisés se retirent
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « 11.1. Introduction » et « Chapter 11. Indexes », https://www.postgresql.org/docs/current/indexes-intro.html et https://www.postgresql.org/docs/current/indexes.html
- Extrait lu : « Indexes can also benefit UPDATE and DELETE commands with search conditions. […] an index defined on a column that is part of a join condition can also significantly speed up queries with joins. » ; « After an index is created, the system has to keep it synchronized with the table. This adds overhead to data manipulation operations. » ; « indexes that are seldom or never used in queries should be removed. »
- Portée / limites : la doc rappelle aussi qu'un index peut empêcher les mises à jour HOT et qu'il faut `ANALYZE` pour que le planificateur l'utilise à bon escient. Ordre de grandeur côté praticien (N4) : Markus Winand, « Insert », https://use-the-index-luke.com/sql/dml/insert : « The number of indexes on a table is the most dominant factor for insert performance » et « Use indexes deliberately and sparingly » ; le texte évoque un facteur d'environ 100 pour le premier index, par rapport à une insertion sans index (cas de référence très rapide), mesure non reproduite ici.
- En code : quelle requête réelle (avec son `EXPLAIN`) motive cet index ? La table est-elle surtout écrite ? Existe-t-il déjà un index dont celui-ci est un préfixe ?

### Une clé étrangère n'indexe pas la colonne qui référence : on l'indexe soi-même quand le parent est supprimé ou modifié, ou quand on joint dessus
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « 5.5. Constraints », https://www.postgresql.org/docs/current/ddl-constraints.html
- Extrait lu : « Since a DELETE of a row from the referenced table or an UPDATE of a referenced column will require a scan of the referencing table for rows matching the old value, it is often a good idea to index the referencing columns too. […] the declaration of a foreign key constraint does not automatically create an index on the referencing columns. »
- Portée / limites : à l'inverse, une contrainte UNIQUE (ou une clé primaire) crée automatiquement son index B-tree (« Adding a unique constraint will automatically create a unique B-tree index »). La doc dit « often », pas « toujours ».
- En code : chaque `REFERENCES`/`@relation` ajouté a-t-il un index sur la colonne côté enfant (`@@index([parentId])` en Prisma, `index=True` en SQLAlchemy) ?

### Dans un index composite, l'ordre des colonnes se choisit selon les requêtes ; la colonne de tête reste la plus efficace, même si PG 18 sait parfois la sauter
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « 11.3. Multicolumn Indexes » et « Release 18 », https://www.postgresql.org/docs/current/indexes-multicolumn.html et https://www.postgresql.org/docs/release/18.0/
- Extrait lu : « the index is most efficient when there are constraints on the leading (leftmost) columns. » ; « Multicolumn indexes should be used sparingly. […] Indexes with more than three columns are unlikely to be helpful unless the usage of the table is extremely stylized. » ; PG 18 : « Allow skip scans of btree indexes […] when there are no restrictions on the first or early indexed columns […] and there are useful restrictions on later indexed columns. »
- Portée / limites : Winand (N4, https://use-the-index-luke.com/sql/where-clause/the-equals-operator/concatenated-keys) : « The most important consideration when defining a concatenated index is how to choose the column order » et « a two-column index does not support searching on the second column alone » ; cette dernière règle date d'avant le skip scan de PG 18, qui la nuance sans l'annuler.
- En code : l'ordre `(a, b)` correspond-il aux filtres d'égalité réels, avec la colonne de tri ou d'intervalle en dernier ? Un index `(a)` seul devient-il redondant ?

### Un index partiel sert à exclure les valeurs fréquentes ou à rendre unique un sous-ensemble, pas à remplacer le partitionnement
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « 11.8. Partial Indexes », https://www.postgresql.org/docs/current/indexes-partial.html
- Extrait lu : « a query searching for a common value (one that accounts for more than a few percent of all the table rows) will not use the index anyway » ; « This enforces uniqueness among the rows that satisfy the index predicate, without constraining those that do not. » ; « This is a bad idea! Almost certainly, you'll be better off with a single non-partial index »
- Portée / limites : la doc avertit que « In most cases, the advantage of a partial index over a regular index will be minimal ». L'index unique partiel (ex. `UNIQUE (email) WHERE deleted_at IS NULL`) est le cas d'usage fort pour la suppression logique. Prisma 7.4.0 annonce le support des index partiels (changelog, 2026-02-11).
- En code : une règle « un seul actif par X » est-elle tenue par un index unique partiel, ou par un `SELECT` applicatif avant `INSERT` ?

### Une hypothèse de performance se vérifie avec `EXPLAIN (ANALYZE, BUFFERS)` sur un volume réaliste, dans une transaction annulée pour les écritures
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « 14.1. Using EXPLAIN », https://www.postgresql.org/docs/current/using-explain.html
- Extrait lu : « because EXPLAIN ANALYZE actually runs the query, any side-effects will happen as usual » ; « The ANALYZE option implicitly enables the BUFFERS option. » ; « results on a toy-sized table cannot be assumed to apply to large tables. »
- Portée / limites : `BUFFERS` automatique avec `ANALYZE` depuis PG 18 (« Automatically include BUFFERS output in EXPLAIN ANALYZE », notes 18.0) ; sur PG ≤ 17 il faut l'écrire. Les coûts réseau ne sont pas mesurés, et l'instrumentation ajoute un surcoût.
- En code : le plan joint à la PR vient-il d'une base de dev de 50 lignes ? Un `EXPLAIN ANALYZE UPDATE/DELETE` a-t-il été lancé hors `BEGIN … ROLLBACK` ?

---

## 3. Pagination

### Toute pagination trie sur un ordre total (une colonne unique en dernière clé), sinon les pages se chevauchent ou sautent des lignes
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « 7.6. LIMIT and OFFSET », https://www.postgresql.org/docs/current/queries-limit.html
- Extrait lu : « When using LIMIT, it is important to use an ORDER BY clause that constrains the result rows into a unique order. Otherwise you will get an unpredictable subset of the query's rows. » ; « using different LIMIT/OFFSET values to select different subsets of a query result will give inconsistent results unless you enforce a predictable result ordering with ORDER BY. »
- Portée / limites : vaut pour offset comme pour keyset. Winand (N4) : « Paging requires a deterministic sort order. »
- En code : `ORDER BY created_at` seul (non unique) ? Ajouter `, id` comme départage.

### On pagine par clé (keyset/curseur) plutôt que par OFFSET dès que la liste peut grandir ; OFFSET calcule et jette les lignes sautées
- Niveau de preuve : N3 (coût d'OFFSET) ; N4 (méthode keyset)
- Source : PostgreSQL Global Development Group, 2025 (v18), « 7.6. LIMIT and OFFSET », https://www.postgresql.org/docs/current/queries-limit.html ; Markus Winand, 2014 (mis à jour 2023-09-08), « We need tool support for keyset pagination », https://use-the-index-luke.com/no-offset
- Extrait lu : « The rows skipped by an OFFSET clause still have to be computed inside the server; therefore a large OFFSET might be inefficient. » ; Winand : « just use a where clause that selects only data you haven't seen yet » ; « you cannot directly navigate to arbitrary pages. »
- Portée / limites : Winand ajoute que l'offset produit des doublons ou des trous quand des lignes sont insérées entre deux pages. **Mesure** : la page « no-offset » ne donne pas de chiffres ; le chapitre « Paging Through Results » (https://use-the-index-luke.com/sql/partial-results/fetch-next-page) dit seulement que la différence de sa figure 7.4 « is clearly visible from about page 20 onwards », sans valeurs absolues lues. Prisma v7 (https://www.prisma.io/docs/orm/v7/prisma-client/queries/pagination) : l'offset « becomes more expensive as the offset grows » et reste adapté quand « users need to jump directly to a numbered page ». Le curseur demande un index qui couvre l'ordre de tri.
- En code : une route de liste accepte-t-elle `?page=N` sans borne ? Le curseur est-il opaque et construit sur `(tri, id)` avec un index correspondant ?

### Toute route de liste borne côté serveur le nombre d'enregistrements renvoyés, quelle que soit la demande du client
- Niveau de preuve : N4
- Source : OWASP, 2023, « API4:2023 Unrestricted Resource Consumption », https://api-security.owasp.org/editions/2023/en/0xa4-unrestricted-resource-consumption
- Extrait lu : liste des limites dont l'absence rend une API vulnérable : « Number of records per page to return in a single request-response » ; prévention : « Define and enforce a maximum size of data on all incoming parameters and payloads »
- Portée / limites : référentiel communautaire de sécurité, pas une norme ni une mesure. Il ne fixe aucune valeur de plafond.
- En code : `take`/`limit` vient-il du client sans `Math.min(demandé, MAX)` ? Existe-t-il une valeur par défaut quand le paramètre est absent ?

---

## 4. Transactions et concurrence

### Ce qui doit réussir ou échouer ensemble s'exécute dans une seule transaction explicite ; sans `BEGIN`, chaque instruction est sa propre transaction
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « 3.4. Transactions », https://www.postgresql.org/docs/current/tutorial-transactions.html
- Extrait lu : « The essential point of a transaction is that it bundles multiple steps into a single, all-or-nothing operation. » ; « If you do not issue a BEGIN command, then each individual statement has an implicit BEGIN and (if successful) COMMIT wrapped around it. »
- Portée / limites : l'atomicité ne dit rien de l'isolation (entrée suivante). Les savepoints permettent d'annuler une partie de la transaction.
- En code : deux `await db.x.update()` successifs qui doivent rester cohérents sont-ils hors transaction ? Un échec entre les deux laisse-t-il un état à moitié écrit ?

### Read Committed est le défaut de PostgreSQL ; en Repeatable Read ou Serializable, le code doit rejouer les échecs de sérialisation (SQLSTATE 40001)
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « 13.2. Transaction Isolation », https://www.postgresql.org/docs/current/transaction-iso.html
- Extrait lu : « Read Committed is the default isolation level in PostgreSQL. » ; « applications using this level must be prepared to retry transactions due to serialization failures. » ; « serialization failures (which always return with an SQLSTATE value of '40001') » ; « This behavior makes Read Committed mode unsuitable for commands that involve complex search conditions »
- Portée / limites : en Read Committed, anomalies de lecture non répétable, de lecture fantôme et de sérialisation possibles (tableau 13.1). Serializable garantit que des transactions correctes isolément restent correctes ensemble « or it will not successfully commit ». Côté ORM : la doc Prisma 8 indique que « Prisma ORM does not retry write conflicts for you » et donne un `withRetry` sur 40001 et 40P01.
- En code : une logique « lire, décider, écrire » tourne-t-elle en Read Committed sans verrou ni contrainte ? Si l'isolation est relevée, la boucle de réessai existe-t-elle, avec un nombre borné de tentatives ?

### Pour « lire puis modifier » une ligne sous concurrence : `SELECT … FOR UPDATE`, verrous pris toujours dans le même ordre, et réessai sur deadlock
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « 13.3. Explicit Locking » (§ 13.3.2 et 13.3.4), https://www.postgresql.org/docs/current/explicit-locking.html
- Extrait lu : « FOR UPDATE causes the rows retrieved by the SELECT statement to be locked as though for update. This prevents them from being locked, modified or deleted by other transactions until the current transaction ends. » ; « The best defense against deadlocks is generally to avoid them by being certain that all applications using a database acquire locks on multiple objects in a consistent order. »
- Portée / limites : les verrous de ligne ne bloquent pas les lecteurs, seulement les écrivains et les autres verrouilleurs. PostgreSQL détecte les deadlocks et annule une transaction, sans qu'on puisse prévoir laquelle. Une mise à jour atomique (`UPDATE … SET stock = stock - 1 WHERE stock > 0`) évite souvent le verrou explicite (déduction, non citée).
- En code : un solde ou un stock est-il lu puis réécrit (`x = read(); write(x - 1)`) sans `FOR UPDATE` ni mise à jour atomique ? Deux chemins de code verrouillent-ils A puis B et B puis A ?

### Un upsert passe par `INSERT … ON CONFLICT` sur un index unique, pas par « SELECT puis INSERT »
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « INSERT », https://www.postgresql.org/docs/current/sql-insert.html
- Extrait lu : « ON CONFLICT DO UPDATE guarantees an atomic INSERT or UPDATE outcome; provided there is no independent error, one of those two outcomes is guaranteed, even under high concurrency. » ; « In all cases, only NOT DEFERRABLE constraints and unique indexes are supported as arbiters. »
- Portée / limites : `DO UPDATE` exige une cible de conflit ; les contraintes d'exclusion ne servent pas d'arbitre pour `DO UPDATE`. Voir la réserve sur `CREATE INDEX CONCURRENTLY` (§ 1). `RETURNING old.*, new.*` existe en PG 18.
- En code : un `findFirst` suivi d'un `create` sert-il d'upsert ? L'`upsert` de l'ORM s'appuie-t-il sur un vrai index unique côté base ?

### Une validation applicative d'unicité ou d'intégrité référentielle ne tient pas sous concurrence ; la contrainte en base, si
- Niveau de preuve : N2
- Source : Peter Bailis, Alan Fekete, Michael J. Franklin, Ali Ghodsi, Joseph M. Hellerstein, Ion Stoica, 2015, « Feral Concurrency Control: An Empirical Investigation of Modern Application Integrity », SIGMOD 2015, DOI 10.1145/2723372.2737784 ; texte intégral lu : http://www.bailis.org/papers/feral-sigmod2015.pdf
- Extrait lu : « We begin by surveying the state of Rails' application-tier concurrency control primitives and examining their use in 67 open source applications » ; « feral invariants are the most popular means of ensuring integrity (and, by usage, are over 37 times more popular than transactions) » ; « up to 86.9% of Rails validation usage by volume is actually safe under concurrent execution. However, the remainder—which include uniqueness violations under insertion and foreign key constraint violations under deletion—are not. » ; « when we added in in-database unique index on the key column […] we observed no duplicates, as expected. »
- Portée / limites : chiffres vérifiés dans le PDF : 67 applications Rails open source ; plus de 9950 usages de validations ; validations et associations 13,6 et 24,2 fois plus fréquentes que les transactions ; microbenchmark de 64 requêtes concurrentes × 100 tours : 6300 doublons sans validation, 70 doublons avec 2 processus, 249 avec 3, moins de 700 au pic avec validation, 0 avec index unique. Contexte 2015, Rails 4.x, PostgreSQL de l'époque ; l'article signale un bogue SSI de PostgreSQL (« as of March 2015, the behavior persists »), dont le statut actuel n'a pas été vérifié. Le résultat ne condamne pas toutes les validations applicatives (86,9 % sont sûres) : il vise l'unicité et les FK.
- En code : une règle d'unicité ou d'existence du parent n'est-elle tenue que par du code (`if (await exists()) throw`) ? Où est la contrainte UNIQUE/FK correspondante, et l'erreur 23505/23503 est-elle traduite en réponse métier ?

### Une transaction interactive d'ORM reste courte et ne contient ni appel réseau ni effet de bord irréversible
- Niveau de preuve : N3
- Source : Prisma, 2025-2026, « Transactions and batch queries » (Prisma ORM v7), https://www.prisma.io/docs/orm/v7/prisma-client/queries/transactions
- Extrait lu : « Keep transactions short. Long-running transactions hurt performance and can cause deadlocks. » ; « Try to avoid performing network requests and executing slow queries inside your transaction functions. » ; « Max wait to acquire transaction (default: 2000ms) » ; « Max transaction run time (default: 5000ms) »
- Portée / limites : valable pour Prisma 7 (`$transaction`, option `isolationLevel`). La doc Prisma 8 (https://www.prisma.io/docs/orm/prisma-client/queries/transactions, page lue le 09.11.2026) change l'API : « Prisma ORM 8 has no $transaction », « There are no isolationLevel, timeout, or maxWait options », « There is no transaction timeout either », et prévient : « Database writes roll back; emails don't. »
- En code : un `fetch`, un envoi de mail ou un appel de paiement se trouve-t-il dans le callback de transaction ? La version de Prisma du dépôt correspond-elle à l'API utilisée (`$transaction` contre `db.transaction`) ?

---

## 5. ORM et problème N+1

### Avec Prisma, les relations se chargent par `include`/`select` ou par un filtre `in`, jamais par une requête dans une boucle
- Niveau de preuve : N3
- Source : Prisma, 2025-2026, « Query optimization » et « Relation queries » (Prisma ORM v7), https://www.prisma.io/docs/orm/prisma-client/queries/query-optimization-performance (URL canonique v7 : https://www.prisma.io/docs/orm/v7/prisma-client/queries/advanced/query-optimization-performance) et https://www.prisma.io/docs/orm/v7/prisma-client/queries/relation-queries
- Extrait lu : « The n+1 problem occurs when looping through query results and performing one additional query per result. » ; « Prisma's dataloader automatically batches findUnique() queries in the same tick. » ; « `join` (default): Uses a database-level `LATERAL JOIN` (PostgreSQL) » ; « `query`: Sends multiple queries to the database (one per table) and joins them on the application level. »
- Portée / limites : la même page v7 indique que `relationLoadStrategy` est en Preview (drapeau `relationJoins`, PostgreSQL, CockroachDB, MySQL) : « join » est le défaut quand la fonction est active ; la page ne tranche pas clairement le comportement sans drapeau. Le regroupement automatique ne vaut que pour `findUnique()`, pas `findMany()`. En Prisma 8, `.include(...)` « reads the relation with a correlated subquery » (page courante).
- En code : un `for`/`map` contenant `await prisma.x.findMany(...)` ? Un `Promise.all(ids.map(findMany))` au lieu d'un `where: { id: { in: ids } }` ?

### Fixer la version de l'ORM : en novembre 2026, `npm install prisma` installe une release candidate de Prisma 8, et Drizzle 1.0 n'est pas stable
- Niveau de preuve : N3
- Source : registre npm, consulté le 09.11.2026, dist-tags de `prisma` et `drizzle-orm`, https://registry.npmjs.org/-/package/prisma/dist-tags et https://registry.npmjs.org/-/package/drizzle-orm/dist-tags ; Prisma, « Prisma Changelog », https://www.prisma.io/changelog.md
- Extrait lu : `prisma` : `"latest":"8.0.0-rc.33"` (publiée le 2026-11-06), `"prev":"7.10.1"` (2026-10-15) ; changelog du 2026-10-02 : « Prisma ORM 8, still a release candidate » ; « v7.0.0 — Prisma ORM v7.0.0: Rust-free Prisma Client becomes the default » (2025-11-19) ; « v6.16.0 — Prisma ORM v6.16.0: Rust-free ORM and driver adapters are GA » (2025-09-10). `drizzle-orm` : `"latest":"0.45.4"` (2026-10-08), `"rc":"1.0.0-rc.5"` (2026-10-21).
- Portée / limites : la documentation Prisma par défaut (prisma.io/docs) décrit déjà Prisma 8 ; la doc v7 est sous `/docs/orm/v7/`. Drizzle se décrit comme « a headless TypeScript ORM with a head », « the only ORM with both relational and SQL-like query APIs » et « Drizzle has exactly 0 dependencies! » (https://orm.drizzle.team/docs/overview) : autoportrait d'éditeur, non évalué ici.
- En code : le `package.json` fixe-t-il `prisma`/`@prisma/client` sur une version stable (`7.x`) ou suit-il `latest` ? La doc consultée correspond-elle à la version installée ?

### Avec SQLAlchemy 2.x, les relations sont paresseuses par défaut : charger les collections avec `selectinload`, interdire le reste avec `raiseload`/`lazy="raise"`
- Niveau de preuve : N3
- Source : SQLAlchemy, 2026, « Relationship Loading Techniques » (2.1.8, release courante, 03.11.2026) et « Asynchronous I/O (asyncio) » (2.0.57), https://docs.sqlalchemy.org/21/orm/queryguide/relationships.html et https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html
- Extrait lu : « By default, all inter-object relationships are lazy loading. » ; « for any N objects loaded, accessing their lazy-loaded attributes means there will be N+1 SELECT statements emitted » (page 2.0) ; « The selectinload() is generally the best loading strategy to use. » ; async : « relationships can be declared with lazy="raise" so that by default they will not attempt to emit SQL » ; « A single instance of AsyncSession is not safe for use in multiple, concurrent tasks. »
- Portée / limites : la branche 2.0 est désormais étiquetée « legacy version », 2.1 est la release courante. En asyncio, un chargement paresseux implicite « will fail under asyncio as no implicit IO is allowed » ; `expire_on_commit` « should normally be set to False when using asyncio ». La page lue ne nomme pas l'erreur `MissingGreenlet`.
- En code : un accès `obj.collection` dans une boucle sans `options(selectinload(...))` ? Une même `AsyncSession` partagée dans un `asyncio.gather` ?

---

## 6. Connexions, pooling et serverless

### Les connexions PostgreSQL sont une ressource rare : un pool par processus, et un pooler externe en mode transaction devant des fonctions serverless, en sachant ce qu'il casse
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « 19.3. Connections and Authentication », https://www.postgresql.org/docs/current/runtime-config-connection.html ; PgBouncer, « Features », https://www.pgbouncer.org/features.html
- Extrait lu : « The default is typically 100 connections » ; « PostgreSQL sizes certain resources based directly on the value of max_connections. » ; PgBouncer, mode transaction : « A server connection is assigned to a client only during a transaction. » ; note sur les plans préparés au niveau protocole : « You need to change max_prepared_statements to a non-zero value to enable this support. »
- Portée / limites : en mode transaction, PgBouncer marque comme jamais compatibles : SET/RESET, LISTEN, curseurs WITH HOLD, verrous consultatifs de session, PREPARE/DEALLOCATE, tables temporaires PRESERVE/DELETE ROWS, LOAD. Le site liste les versions 1.25.x à 1.26.1 sans les relier au tableau.
- En code : le code s'appuie-t-il sur un `SET` de session, un `pg_advisory_lock` de session ou `LISTEN` derrière un pooler en mode transaction ? La somme des `max` de pool × instances dépasse-t-elle `max_connections` ?

### Sur Supabase, une fonction serverless passe par le pooler partagé (Supavisor) en mode transaction, port 6543, avec un client par module, un pool d'une connexion et sans instructions préparées
- Niveau de preuve : N3
- Source : Supabase, s.d. (doc vivante consultée le 09.11.2026), « Connect to your database », https://supabase.com/docs/guides/database/connecting-to-postgres
- Extrait lu : « These environments open many short-lived connections. » ; « The shared pooler doesn't support prepared statements in transaction mode. » ; « The dedicated pooler runs in transaction mode only. »
- Portée / limites : connexion directe (5432) recommandée pour les serveurs persistants (VM, conteneurs longs) ; le pooler partagé est IPv4 uniquement, la connexion directe IPv6 par défaut (module complémentaire IPv4 payant, « not dual-stack »). Le pooler dédié (offre Pro et plus) prend en charge les instructions préparées avec PgBouncer 1.21+. Côté Prisma 7 (https://www.prisma.io/docs/orm/v7/prisma-client/setup-and-configuration/databases-connections/connection-pool) : le pool est celui du driver adapter (10 connexions par défaut pour `pg`, champ `max`) ; « Consider introducing an external connection pooler like PgBouncer ».
- En code : la chaîne de connexion d'une Edge/Serverless Function vise-t-elle 5432 en direct ? Les instructions préparées du driver sont-elles désactivées sur 6543 ? Le client est-il instancié à chaque requête ?

---

## 7. Supabase et RLS

### Une politique RLS performante appelle `auth.uid()` via `(select auth.uid())`, indexe la colonne filtrée, nomme le rôle (`to authenticated`) et ne remplace pas le filtre de la requête
- Niveau de preuve : N3
- Source : Supabase, s.d., « RLS Performance and Best Practices », https://supabase.com/docs/guides/troubleshooting/rls-performance-and-best-practices-Z5Jjwv ; et « Row Level Security », https://supabase.com/docs/guides/database/postgres/row-level-security
- Extrait lu : « Wrapping the function causes an initPlan to be run by the Postgres optimizer » (cache « per-statement, rather than calling the function on each row ») ; « WARNING: You can only do this if the results of the query or function do not change based on the row data. » ; « Improvement seen over 100x on large tables. » ; « The tests are doing selects on a 100K row table. » ; « Do not rely on RLS for filtering but only for security. »
- Portée / limites : mesures publiées par l'éditeur sur une table de 100 000 lignes (avant → après) : `auth.uid()` enveloppé 179 → 9 ; `is_admin() OR auth.uid()` enveloppés 11 000 → 10 ; jointure inversée en appartenance à un ensemble 9 000 → 20 ; index sur `user_id` 171 ms → < 0,1. Unités pas toujours indiquées dans le tableau ; conditions de test non reproduites. La page RLS principale ajoute : « Add an index on every column your policies filter on. »
- En code : une politique contient-elle `auth.uid() = user_id` sans `select` ? `user_id` est-il indexé ? La requête cliente filtre-t-elle aussi (`.eq('user_id', …)`) ?

### La RLS ne protège pas contre tout : propriétaires, superutilisateurs, `BYPASSRLS`, vues par défaut et contrôles d'intégrité la contournent
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « 5.9. Row Security Policies », https://www.postgresql.org/docs/current/ddl-rowsecurity.html ; Supabase, « Row Level Security », https://supabase.com/docs/guides/database/postgres/row-level-security
- Extrait lu : « Superusers and roles with the BYPASSRLS attribute always bypass the row security system […] Table owners normally bypass row security as well » ; « If no policy exists for the table, a default-deny policy is used » ; « Referential integrity checks, such as unique or primary key constraints and foreign key references, always bypass row security » ; Supabase : « Views bypass RLS by default because they are usually created with the postgres user. »
- Portée / limites : remède Supabase pour les vues (PG 15+) : `security_invoker = true`. Les sous-requêtes d'une politique peuvent créer des « race conditions that could allow information leakage » ; la doc PostgreSQL suggère `SELECT ... FOR SHARE` dans ces sous-requêtes. Supabase : « Enable RLS on every table in an exposed schema. »
- En code : une table d'un schéma exposé est-elle créée sans `enable row level security` ? Une vue sur une table protégée est-elle créée sans `security_invoker` ?

### Une fonction `SECURITY DEFINER` fixe son `search_path` et retire le droit EXECUTE à PUBLIC
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (v18), « CREATE FUNCTION » (§ Writing SECURITY DEFINER Functions Safely), https://www.postgresql.org/docs/current/sql-createfunction.html
- Extrait lu : « search_path should be set to exclude any schemas writable by untrusted users. » ; « write pg_temp as the last entry in search_path. » ; « by default, execute privilege is granted to PUBLIC for newly created functions […] you must revoke the default PUBLIC privileges and then grant execute privilege selectively. »
- Portée / limites : Supabase va plus loin : « Set search_path = '' on every security definer function and schema-qualify the names inside it. » La doc PostgreSQL recommande de créer la fonction et de régler ses droits dans une seule transaction.
- En code : une RPC `security definer` sans `set search_path` ? Des noms de tables non qualifiés à l'intérieur ? Un `revoke execute … from public` (et `anon` sur Supabase) manquant ?

### La clé secrète (`sb_secret_…`, ex-`service_role`) contourne toute la RLS : jamais dans un navigateur, une application livrée ou le dépôt
- Niveau de preuve : N3
- Source : Supabase, s.d. (doc vivante consultée le 09.11.2026), « Understanding API keys », https://supabase.com/docs/guides/api/api-keys
- Extrait lu : « A secret key bypasses every Row Level Security policy you have. » ; « Never put one in a browser, a shipped application, or source control. » ; « Supabase is deprecating the anon and service_role keys by the end of 2026. »
- Portée / limites : la clé publiable (`sb_publishable_…`) est « Safe to expose online », la RLS décidant de ce qu'elle atteint. Les anciennes clés JWT « stay valid until you disable them ». Pas de date plus précise que « by the end of 2026 ».
- En code : une variable `NEXT_PUBLIC_*`/`VITE_*` contient-elle une clé secrète ou `service_role` ? Le projet utilise-t-il encore les clés héritées alors que leur retrait est annoncé pour fin 2026 ?

---

## 8. PostgreSQL 18 et identifiants

### Une clé primaire UUID générée en base est de préférence un UUIDv7 (ordonné dans le temps), mais un UUID n'est jamais un secret
- Niveau de preuve : N1 (RFC) ; N3 (fonction PostgreSQL)
- Source : K. Davis, B. Peabody, P. Leach, 2024 (mai), « RFC 9562 — Universally Unique IDentifiers (UUIDs) », https://www.rfc-editor.org/rfc/rfc9562.html ; PostgreSQL Global Development Group, 2025 (v18), « UUID Functions », https://www.postgresql.org/docs/current/functions-uuid.html
- Extrait lu : « This document obsoletes RFC 4122. » ; « Implementations SHOULD utilize UUIDv7 instead of UUIDv1 and UUIDv6 if possible. » ; « Time-ordered monotonic UUIDs benefit from greater database-index locality » ; « MUST NOT be used as security capabilities » ; PostgreSQL : « Generates a version 7 (time-ordered) UUID. The timestamp is computed using UNIX timestamp with millisecond precision + sub-millisecond timestamp + random. »
- Portée / limites : RFC « Category: Standards Track », auteurs et date confirmés sur l'en-tête de https://www.rfc-editor.org/rfc/rfc9562.txt. La RFC note que l'horodatage inclus présente « a very small attack surface » (fuite de la date de création). `uuidv7()` arrive en PG 18 ; avant, `gen_random_uuid()` = v4. Aucune mesure chiffrée v4 contre v7 n'a été lue.
- En code : la clé primaire est-elle un `uuid` v4 aléatoire sur une table à fort volume d'insertion ? Un identifiant v7 exposé dans une URL révèle-t-il une date sensible ? Un UUID sert-il de jeton d'accès ?

### Passer à PostgreSQL 18 change des défauts : colonnes générées virtuelles par défaut, AIO, statistiques conservées par pg_upgrade, checksums activés, MD5 déprécié
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, 2025 (sortie 2025-09-25), « Release 18 », https://www.postgresql.org/docs/release/18.0/ ; « 5.4. Generated Columns », https://www.postgresql.org/docs/current/ddl-generated-columns.html ; « 19.4. Resource Consumption », https://www.postgresql.org/docs/current/runtime-config-resource.html
- Extrait lu : « Virtual generated columns that compute their values during read operations. This is now the default for generated columns. » ; « An asynchronous I/O (AIO) subsystem that can improve performance of sequential scans, bitmap heap scans, vacuums, and other operations. » ; `io_method` : « The default is worker. » ; « pg_upgrade now retains optimizer statistics. » ; « Change initdb default to enable data checksums » ; « Deprecate MD5 password authentication »
- Portée / limites : une colonne virtuelle « cannot have a user-defined type » et son expression ne peut utiliser que des fonctions intégrées ; seule la colonne `STORED` est publiée en réplication logique. Un `GENERATED ALWAYS AS (…)` sans mot-clé, écrit pour PG ≤ 17 (où il était stocké), change de nature sur PG 18. L'AIO concerne surtout les lectures séquentielles et le vacuum, pas les écritures transactionnelles (d'après la note de version). Pas de chiffre de gain lu.
- En code : les colonnes générées précisent-elles `STORED` ou `VIRTUAL` explicitement ? Un rôle applicatif utilise-t-il encore un mot de passe MD5 ?

---

## 9. SQLite

### SQLite convient à une application locale ou à un site peu chargé ; une seule écriture à la fois, et le mode WAL exige un seul hôte
- Niveau de preuve : N3
- Source : SQLite, s.d. (doc vivante consultée le 09.11.2026), « Appropriate Uses For SQLite » et « Write-Ahead Logging », https://www.sqlite.org/whentouse.html et https://www.sqlite.org/wal.html
- Extrait lu : « SQLite does not compete with client/server databases. SQLite competes with fopen(). » ; « any site that gets fewer than 100K hits/day should work fine with SQLite. The 100K hits/day figure is a conservative estimate, not a hard upper bound. » ; « SQLite supports an unlimited number of simultaneous readers, but it will only allow one writer at any instant in time. » ; WAL : « readers do not block writers and a writer does not block readers » ; « WAL does not work over a network filesystem. »
- Portée / limites : liste de contrôle de sqlite.org : client/serveur si les données sont séparées de l'application par le réseau, s'il y a beaucoup d'écrivains concurrents ou des volumes proches du téraoctet. `PRAGMA journal_mode=WAL` est persistant. Avec WAL, « there can only be one writer at a time ».
- En code : la base SQLite est-elle sur un partage réseau ou un volume partagé entre plusieurs instances ? Le déploiement prévoit-il plusieurs processus écrivains ?

### Développer sur SQLite et produire sur PostgreSQL masque des différences de sémantique ; tester sur le moteur de production
- Niveau de preuve : N3 (différences SQLite) ; N4 (principe de parité)
- Source : SQLite, s.d., « Quirks, Caveats, and Gotchas In SQLite », https://www.sqlite.org/quirks.html ; Adam Wiggins, s.d. (page « Last updated 2017 »), « The Twelve-Factor App — X. Dev/prod parity », https://12factor.net/dev-prod-parity
- Extrait lu : « Datatypes are advisory rather than mandatory. » ; « foreign key constraint enforcement is turned off by default in SQLite. » ; « SQLite has no DATETIME datatype. » ; « the column values of a PRIMARY KEY are allowed to be NULL » ; « a misspelled double-quoted identifier will be interpreted as a string literal » ; Twelve-Factor : « using SQLite locally and PostgreSQL in production » [cité comme exemple de disparité] ; « The twelve-factor developer resists the urge to use different backing services between development and production »
- Portée / limites : la page Twelve-Factor n'affiche que « Last updated 2017 » (date de première publication non vérifiée). Les tables `STRICT` et `PRAGMA foreign_keys = ON` réduisent l'écart sans l'annuler. RLS, `CREATE INDEX CONCURRENTLY`, niveaux d'isolation, `uuidv7()` et les verrous DDL décrits plus haut n'ont pas d'équivalent SQLite : une migration testée sur SQLite n'éprouve ni ses verrous ni sa durée.
- En code : les tests d'intégration tournent-ils sur SQLite alors que la production est PostgreSQL ? Une contrainte FK « testée » en dev l'a-t-elle été avec `foreign_keys` activé ?

---

## Verdict sur les règles du profil

| Règle du profil | Verdict | Motif sourcé |
|---|---|---|
| « Migrations zéro-downtime — expand/contract : Expand (colonne nullable, nouvelle table), Backfill par lots en tâche séparée jamais dans le même déploiement que le DDL, Contract quand plus rien ne lit l'ancien. Renommer une colonne en un coup = downtime ou crash garanti. » | **Soutenue, à préciser** | Le pattern est de Danilo Sato (martinfowler.com, 2014) ; Prisma v7 et GitLab le prescrivent pour les renommages. **À préciser** : (1) `RENAME COLUMN` ne touche pas les données (« There is no effect on the stored data ») mais prend ACCESS EXCLUSIVE ; le crash vient du code déployé qui lit encore l'ancien nom. « Garanti » est trop fort : c'est certain dès que l'ancien code tourne pendant ou après la migration. (2) « jamais dans le même déploiement » relève de la pratique (GitLab, N4) ; aucune source officielle ne l'exige. (3) La règle oublie les mécanismes PostgreSQL qui font le zéro-downtime réel : `lock_timeout`, `CREATE INDEX CONCURRENTLY` hors transaction, `NOT VALID` + `VALIDATE`, `SET NOT NULL` via CHECK, DEFAULT constant sans réécriture depuis PG 11. (4) Avec un DEFAULT constant, la colonne de l'étape « expand » n'a pas besoin d'être nullable. |
| « Indexer les colonnes filtrées dans WHERE/JOIN fréquents. » | **Soutenue, à préciser** | Doc PG 11.1 : les index servent SELECT, UPDATE/DELETE et jointures, mais « add overhead to data manipulation operations », et les index inutilisés se retirent. À ajouter : la colonne côté enfant d'une FK n'est pas indexée automatiquement (doc 5.5) ; une valeur fréquente n'utilise pas l'index (doc 11.8) ; l'ordre des colonnes d'un composite compte (11.3) ; on vérifie avec `EXPLAIN (ANALYZE, BUFFERS)` sur un volume réaliste (14.1). |
| « Pagination et bornage par défaut : toute route qui liste pagine (cursor de préférence) avec une limite max serveur. » | **Soutenue** | Coût d'OFFSET : doc PG 7.6 (« a large OFFSET might be inefficient ») ; keyset : Winand (N4). Limite serveur : OWASP API4:2023 (N4). Précision à ajouter : tri sur un ordre total (colonne unique en dernière clé, doc 7.6), et l'offset reste légitime pour une navigation par numéro de page sur de petits volumes (Prisma v7, Winand). |
| « Frontières transactionnelles explicites : ce qui doit être atomique l'est dans UNE transaction. » | **Soutenue, à préciser** | Doc PG 3.4 (« all-or-nothing »). Atomique ne veut pas dire isolé : en Read Committed (défaut, doc 13.2), un « lire puis écrire » reste exposé aux courses ; il faut `FOR UPDATE`, une mise à jour atomique, une contrainte, ou Serializable avec réessai sur 40001. Garder la transaction courte, sans appel réseau (Prisma v7). |
| « Une capacité native de la plateforme de données (UNIQUE, CHECK, FK, index partiel, ON CONFLICT, colonne générée, NOT NULL, RLS) tient l'invariant même quand un autre client écrit ; le code applicatif, non. » | **Soutenue, à préciser** | N2 : Bailis et al. 2015 : 0 doublon avec index unique, jusqu'à près de 700 avec la validation applicative ; doc PG `ON CONFLICT` « atomic […] even under high concurrency ». **À préciser** : (1) Bailis montre que 86,9 % des validations (formats, etc.) restent sûres sous concurrence : le « non » vaut surtout pour l'unicité et l'existence de la ligne référencée. (2) RLS ne tient pas face au propriétaire de la table, aux superutilisateurs, à `BYPASSRLS` ni à la clé secrète Supabase (doc 5.9, Supabase API keys), et les vues la contournent par défaut. (3) Une contrainte `NOT VALID` ne couvre pas les lignes anciennes. (4) Sous SQLite, les FK ne sont pas appliquées par défaut. |
| « Tout durcissement de schéma (length min, regex, FK, UNIQUE, CHECK) passe par un reality check sur les données existantes avant application. » | **Soutenue (mécanisme), pratique sans preuve formelle** | La doc PG décrit les échecs que le contrôle évite : `VALIDATE CONSTRAINT` et `SET NOT NULL` parcourent la table ; un `CREATE UNIQUE INDEX CONCURRENTLY` qui tombe sur un doublon laisse un index INVALID qui coûte encore aux écritures. Aucune source ne nomme la pratique du « reality check ». Précision : `NOT VALID` permet d'appliquer la règle aux nouvelles lignes tout de suite, puis de nettoyer l'existant avant `VALIDATE`. |
| « DB : SQLite dev → Postgres prod, ou Supabase. » | **Contredite pour « SQLite dev → Postgres prod »** | Twelve-Factor cite justement « using SQLite locally and PostgreSQL in production » comme une disparité à éviter (N4). sqlite.org documente les écarts : typage indicatif, FK désactivées par défaut, pas de DATETIME, NULL admis dans une PK, chaînes entre guillemets doubles (N3). RLS, verrous DDL, CIC, isolation et `ON CONFLICT` n'y sont pas éprouvés. Recommandation : PostgreSQL en local (même version majeure que la prod). SQLite reste valable **comme base de production** d'une application locale ou peu chargée (sqlite.org). |
| « Migration générée mais non appliquée, fournie pour relecture. » | **Soutenue** | Prisma v7 : `migrate dev --create-only` produit un brouillon, et un renommage est généré par défaut en création + suppression avec perte de données. Le changelog Prisma 8 (2026-10-09) ajoute une confirmation avant suppression, preuve que le risque est réel. |

---

## Mythes et affirmations contestées

- **« `ADD COLUMN … DEFAULT` réécrit toute la table. »** Faux depuis PostgreSQL 11 pour un DEFAULT constant (notes 11.0) ; vrai pour un DEFAULT volatil, une colonne générée `STORED`, une identité (ALTER TABLE v18).
- **« `CREATE INDEX` bloque la table. »** Il bloque les écritures, pas les lectures (verrou SHARE, doc 11.1). `CONCURRENTLY` ne bloque pas les écritures mais ne fonctionne pas en transaction et peut laisser un index INVALID.
- **« Renommer une colonne est une opération lourde. »** Côté base, non : changement de métadonnées sans effet sur les données, mais sous ACCESS EXCLUSIVE. Le risque est la file d'attente des verrous (GoCardless, N4) et le code qui lit l'ancien nom.
- **« Un index composite `(a, b)` est inutile sans filtre sur `a`. »** Nuancé depuis PG 18 (skip scan B-tree), même si la colonne de tête reste la plus efficace.
- **« Serializable règle la concurrence sans rien changer au code. »** Faux : l'application doit rejouer les échecs 40001 (doc 13.2) ; Prisma ne le fait pas pour vous (doc Prisma 8).
- **« L'upsert de l'ORM protège des doublons. »** Seulement s'il repose sur un index unique en base (`ON CONFLICT` exige un arbitre unique).
- **« Les validations applicatives sont inutiles. »** Exagéré : Bailis et al. trouvent 86,9 % d'usages sûrs ; elles réduisent les doublons d'un ordre de grandeur, sans les supprimer.
- **« Le chiffre "37 fois" de Bailis concerne les doublons. »** Non : il compare la fréquence d'usage des invariants applicatifs à celle des transactions dans 67 applications.
- **« La RLS protège la table quoi qu'il arrive. »** Propriétaire, superutilisateur, `BYPASSRLS`, clé secrète, vues par défaut et contrôles d'intégrité la contournent (doc 5.9, Supabase).
- **« `auth.uid()` dans une politique coûte peu. »** Mesures Supabase sur 100 000 lignes : 179 → 9 en l'enveloppant dans `select` (chiffres d'éditeur, non reproduits).
- **« `npm install prisma` installe Prisma 7. »** Faux au 09.11.2026 : le tag `latest` pointe sur `8.0.0-rc.33`, une release candidate ; la 7.10.1 est sous `prev`.
- **« Prisma 7 a toujours son moteur Rust. »** Faux : client sans Rust par défaut depuis la 7.0.0 (2025-11-19), GA depuis la 6.16.0 (2025-09-10).
- **« Ajouter `BUFFERS` à `EXPLAIN ANALYZE`. »** Inutile depuis PG 18 (inclus automatiquement) ; toujours nécessaire sur PG ≤ 17.
- **« Un UUID est imprévisible, donc sûr dans une URL de partage. »** RFC 9562 : « MUST NOT be used as security capabilities », et le v7 expose sa date de création.
- **« Le premier index rend l'insertion 100 fois plus lente. »** Chiffre de Winand relatif à une insertion sans index, très rapide par nature ; pas une loi générale.
- **« SQLite n'est pas fait pour la production. »** Contesté par sqlite.org : moins de 100 000 visites/jour « should work fine » (estimation prudente) ; la vraie limite est l'écrivain unique et l'hôte unique en WAL.

---

## Non vérifié

- **File d'attente des verrous** : l'effet « une demande ACCESS EXCLUSIVE en attente bloque les lectures arrivées après elle » n'a été trouvé que chez des praticiens (GoCardless) ; la doc officielle lue dit seulement que la demande attend indéfiniment.
- **Index sur une colonne générée virtuelle (PG 18)** : ni CREATE INDEX ni CREATE TABLE ni la page Generated Columns lues ne le disent.
- **Monotonie de `uuidv7()` au sein d'une session PostgreSQL** : non mentionnée dans la page des fonctions UUID.
- **Gain mesuré UUIDv7 contre UUIDv4 en clé primaire** : aucune mesure primaire lue ; seule l'affirmation qualitative de la RFC (§ 6.11).
- **Gain mesuré de l'AIO de PG 18** : aucun chiffre lu.
- **Statut du bogue SSI de PostgreSQL signalé par Bailis et al. (2015)** : non vérifié aujourd'hui.
- **Date de sortie stable de Prisma 8 et de Drizzle 1.0** : les deux sont en release candidate au 09.11.2026 (registre npm) ; aucune date annoncée lue.
- **Comportement de `relationLoadStrategy` dans Prisma 7 sans le drapeau `relationJoins`** : la page v7 dit à la fois « join (default) » et « Preview » ; non tranché.
- **Notes Prisma 7 sur PgBouncer et instructions préparées** : la page connection-pool y renvoie, sans en donner le contenu.
- **Fonctionnement interne de Supavisor** (au-delà des modes et ports documentés) : non lu.
- **Date de première publication de Twelve-Factor** : la page lue n'affiche que « Last updated 2017 ».
- **Mesures absolues de Winand sur OFFSET** (figure 7.4) : seul le commentaire qualitatif a été lu.
- **Taille de lot recommandée pour un backfill** : aucune source primaire ne la fixe.

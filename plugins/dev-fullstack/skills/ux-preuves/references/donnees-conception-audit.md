# Fiche `ux-preuves` — Données — conception de schéma, audit, local-first et sécurité

> Fiche du skill `ux-preuves` (dev-fullstack), volet **données**, écrite pour l'agent `architecte-donnees`. Couvre : modélisation (normalisation, types, NULL, clés, suppression douce, historique et temporalité PG 18, JSONB, multi-tenant, anti-patterns), audit d'une base existante (`pg_stat_statements`, index inutilisés, autovacuum, advisors Supabase), stockage local sur téléphone (IndexedDB, Dexie, Capacitor et SQLite, synchro), migrations au-delà des verrous (ordre, seeds, tests, données), moindre privilège et chiffrement.
> **Instantané de la recherche documentaire du 16.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Versions, quotas de navigateur et offres
> **vieillissent en mois** : avant d'écrire du code qui en dépend, relire la page officielle
> (§ « Quand vérifier en ligne » du skill). Les sections « Verdict », « Mythes » et « Non vérifié »
> sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Recherche documentaire vérifiée, 16 novembre 2026. Toutes les pages citées ont été ouvertes (WebFetch ;
`pdftotext` pour l'extrait PDF de Karwin ; registre npm interrogé par `curl` pour les versions).
Documentation PostgreSQL consultée : **PostgreSQL 18 (18.7)**. Le lecteur de pages rend parfois un
extrait tronqué ou reformulé : seules les phrases entre guillemets sont des citations.
Niveaux : N1 norme ou loi, N2 recherche revue par pairs, N3 documentation officielle, N4 praticien ou éditeur, N0 jugement.

**Ne double pas** `backend-donnees-postgres.md` (verrous DDL, `lock_timeout`, `CONCURRENTLY`, `NOT VALID`,
expand/contract, index, pagination, transactions, N+1, pooling, RLS, UUIDv7, SQLite de base) ni
`release-migrations-sauvegardes.md` (restauration testée, PITR, Prisma/Supabase CLI/Drizzle, dérive,
branches, copies de production) ni `backend-observabilite-tests-donnees.md` § 5 et 6 (nLPD, RGPD,
effacement, suppression logique comme restriction). Quand une entrée de ces fiches suffit, on y renvoie.

30 entrées.

---

## 1. Modélisation

### Normaliser jusqu'à la troisième forme normale par défaut ; toute dénormalisation porte son motif et son mécanisme de cohérence
- Niveau de preuve : N4 (article de support archivé d'éditeur, notions de manuel)
- Source : Microsoft Learn, archive (ms.date 2025-05-26), « Database normalization description », https://learn.microsoft.com/en-us/troubleshoot/microsoft-365-apps/access/database-normalization-description — lu le 16.11.2026
- Extrait lu : « third normal form is considered the highest level necessary for most applications. » ; « If you decide to violate one of the first three rules of normalization, make sure that your application anticipates any problems that could occur, such as redundant data and inconsistent dependencies. » ; « Don't use multiple fields in a single table to store similar data. » ; « It may be more feasible to apply third normal form only to data that changes frequently. »
- Portée / limites : page d'initiation, marquée archivée ; elle contient une erreur de terminologie (« Fourth normal form, also called Boyce-Codd Normal Form ») : la BCNF n'est pas la 4NF. Elle vaut pour l'ordre de grandeur (3NF suffit à la plupart des applications), pas comme référence théorique. « Partir des requêtes » n'y figure pas : c'est un jugement de conception (N0), à appliquer aux index et aux dénormalisations, pas aux tables.
- En conception : une colonne qui dépend d'une autre colonne non clé (ville ← code postal, salle ← conseiller) existe-t-elle ? Des colonnes `xxx1`, `xxx2`, `xxx3` ? Chaque donnée recopiée dans une autre table a-t-elle un motif écrit (requête mesurée) et un mécanisme qui la tient à jour (trigger, colonne générée, vue matérialisée) ?

### L'argent se stocke en `numeric` ou en centimes entiers ; jamais en `real`/`double precision`, et le type `money` est à éviter
- Niveau de preuve : N3 (doc) ; N4 (wiki communautaire)
- Source : PostgreSQL 18.7, « 8.1. Numeric Types », https://www.postgresql.org/docs/current/datatype-numeric.html ; PostgreSQL Wiki, « Don't Do This » (modifiée le 11.11.2026), https://wiki.postgresql.org/wiki/Don't_Do_This — lus le 16.11.2026
- Extrait lu : doc : `numeric` « is especially recommended for storing monetary amounts and other quantities where exactness is required » ; « calculations on numeric values are very slow compared to the integer types » ; flottants : « If you require exact storage and calculations (such as for monetary amounts), use the numeric type instead. » ; wiki : « The money data type isn't actually very good for storing monetary values. Numeric, or (rarely) integer may be better. »
- Portée / limites : les centimes entiers (`bigint`, ou `integer` côté IndexedDB) sont exacts et rapides ; ils supposent une seule précision (2 décimales) et une monnaie connue. Le wiki admet `money` « If you're only working in a single currency, aren't dealing with fractional cents ». Une monnaie non stockée à côté du montant est une décision à écrire.
- En conception : une colonne de montant est-elle `real`, `float8` ou `money` ? Si elle est en centimes, son nom le dit-il (`price_cents`) ? Le schéma stocke-t-il la monnaie, ou une décision écrite dit-elle pourquoi pas ?

### Un instant se stocke en `timestamptz` ; `timestamp` seul est sans fuseau, et `BETWEEN` sur des instants inclut la borne haute
- Niveau de preuve : N3 (doc) ; N4 (wiki)
- Source : PostgreSQL 18.7, « 8.5. Date/Time Types », https://www.postgresql.org/docs/current/datatype-datetime.html ; PostgreSQL Wiki, « Don't Do This », URL ci-dessus — lus le 16.11.2026
- Extrait lu : doc : « The SQL standard requires that writing just timestamp be equivalent to timestamp without time zone, and PostgreSQL honors that behavior. » ; « the value is stored internally as UTC, and the originally stated or assumed time zone is not retained. » ; « We do not recommend using the type time with time zone » ; wiki : « Don't use the timestamp type to store timestamps, use timestamptz » ; « BETWEEN uses a closed-interval comparison » ; « BETWEEN is safe for discrete quantities like integers or dates »
- Portée / limites : `timestamptz` ne garde pas le fuseau d'origine : si l'heure locale de saisie compte (rendez-vous, heure d'ouverture), stocker aussi le nom du fuseau. Une date civile sans heure (millésime, date d'achat) est un `date`, pas un instant. Côté IndexedDB, l'équivalent est une chaîne ISO 8601 avec décalage ou `Z`.
- En conception : une colonne `created_at`/`updated_at` est-elle `timestamp` sans fuseau ? Une requête filtre-t-elle une journée par `BETWEEN '…00:00' AND '…00:00'` au lieu de `>= début AND < fin` ?

### Le texte se déclare `text` (ou `varchar` sans longueur) ; une longueur métier se pose en `CHECK`, et `char(n)` ne sert à rien
- Niveau de preuve : N3 (doc) ; N4 (wiki)
- Source : PostgreSQL 18.7, « 8.3. Character Types », https://www.postgresql.org/docs/current/datatype-character.html ; PostgreSQL Wiki, « Don't Do This », URL ci-dessus — lus le 16.11.2026
- Extrait lu : doc : « There is no performance difference among these three types, apart from increased storage space when using the blank-padded type » ; « character(n) is usually the slowest of the three » ; « In most situations text or character varying should be used instead. » ; wiki : « Don't use the type varchar(n) by default. » ; « Just don't use it automatically without thinking about it. »
- Portée / limites : `varchar(n)` reste légitime quand la limite est une vraie règle (code pays, code postal) ; mais l'élargir est un `ALTER COLUMN TYPE` (renvoi : réécriture et verrous, `backend-donnees-postgres.md` § 1), alors qu'un `CHECK (char_length(x) <= n)` se remplace par `NOT VALID` + `VALIDATE`. Le wiki ajoute : noms en minuscules (« PostgreSQL folds all names […] to lower case »).
- En conception : chaque `varchar(255)` a-t-il une règle métier derrière ses 255 ? Y a-t-il un `char(n)` hors portage ? Des identifiants entre guillemets en casse mixte ?

### Un ensemble fermé de valeurs : `CHECK` si la liste peut changer, table de référence si elle porte des attributs ou s'édite, `enum` seulement si elle ne perd jamais de valeur
- Niveau de preuve : N3
- Source : PostgreSQL 18.7, « 8.7. Enumerated Types », https://www.postgresql.org/docs/current/datatype-enum.html — lu le 16.11.2026
- Extrait lu : « there is support for adding new values to an existing enum type, and for renaming values » ; « Existing values cannot be removed from an enum type, nor can the sort ordering of such values be changed, short of dropping and re-creating the enum type. » ; « The ordering of the values in an enum type is the order in which the values were listed when the type was created. » ; « at most 63 bytes »
- Portée / limites : la comparaison des trois options (enum, CHECK, table de référence) n'est pas faite par la doc : c'est un jugement (N0) fondé sur cette limite. Une table de référence donne une FK, des libellés et une activation sans migration de type ; un `CHECK (kind IN (…))` se modifie par `DROP CONSTRAINT` + `ADD … NOT VALID`. Côté Zod/TypeScript, la liste vit aussi dans le code : garder une seule source.
- En conception : un `enum` modélise-t-il une liste qui pourrait perdre une valeur (statuts, catégories) ? L'ordre de tri d'un enum est-il utilisé par une requête ? La liste existe-t-elle en double (schéma et code) sans test qui les compare ?

### `NOT NULL` par défaut ; un NULL a un sens écrit, et deux NULL ne se heurtent pas dans une contrainte `UNIQUE`
- Niveau de preuve : N3 (doc) ; N4 (wiki)
- Source : PostgreSQL 18.7, « 5.5. Constraints », https://www.postgresql.org/docs/current/ddl-constraints.html ; PostgreSQL Wiki, « Don't Do This », URL ci-dessus — lus le 16.11.2026
- Extrait lu : « In most database designs the majority of columns should be marked not null. » ; « even in the presence of a unique constraint it is possible to store duplicate rows that contain a null value in at least one of the constrained columns. This behavior can be changed by adding the clause NULLS NOT DISTINCT » ; wiki : `NOT IN` « is mostly safe unless you might have a null in the list »
- Portée / limites : `NULLS NOT DISTINCT` existe en PostgreSQL ; le traitement des NULL dans UNIQUE est « implementation-defined » selon la norme SQL (doc), donc SQLite ou IndexedDB ne se comportent pas forcément pareil. Distinguer « inconnu », « sans objet » et « vide » : un seul NULL ne peut pas porter les trois sens.
- En conception : chaque colonne nullable a-t-elle une raison écrite ? Une contrainte `UNIQUE (a, b)` où `b` est nullable laisse-t-elle passer des doublons non voulus ? Une requête `NOT IN (sous-requête)` peut-elle rencontrer un NULL ?

### Chaque table a une clé primaire ; une clé technique (`identity` ou UUID) ne dispense pas d'une contrainte `UNIQUE` sur la clé naturelle
- Niveau de preuve : N3 (doc) ; N4 (wiki)
- Source : PostgreSQL 18.7, « 5.5. Constraints » (§ 5.5.4) et « 5.3. Identity Columns », https://www.postgresql.org/docs/current/ddl-constraints.html et https://www.postgresql.org/docs/current/ddl-identity-columns.html ; PostgreSQL Wiki, « Don't Do This » — lus le 16.11.2026
- Extrait lu : « Relational database theory dictates that every table must have a primary key. This rule is not enforced by PostgreSQL, but it is usually best to follow it. » ; « An identity column, however, does not guarantee uniqueness. […] Uniqueness would need to be enforced using a PRIMARY KEY or UNIQUE constraint. » ; `ALWAYS` « provides some more protection against accidentally inserting an explicit value » ; wiki (serial) : « For new applications, identity columns should be used instead. »
- Portée / limites : la doc ne tranche pas « clé naturelle contre technique » ; le raisonnement (une clé technique stable, plus l'unicité métier en `UNIQUE`) est un jugement (N0). Choix UUIDv7 et risque d'énumération : renvoi `backend-donnees-postgres.md` § 8. Pour une synchro future, un identifiant généré côté client (UUID) évite les collisions entre appareils.
- En conception : une table sans clé primaire (Supabase la signale : lint `0004_no_primary_key`) ? Un `serial` dans une table nouvelle ? Une table avec `id` technique mais sans `UNIQUE` sur ce qui identifie la chose pour le métier (e-mail, numéro de facture, couple produit-millésime) ?

### Un invariant entre lignes ou entre tables passe par `UNIQUE`, `EXCLUDE` ou une FK, jamais par un `CHECK` qui lit d'autres lignes ; l'action `ON DELETE` se choisit selon la nature du lien
- Niveau de preuve : N3
- Source : PostgreSQL 18.7, « 5.5. Constraints », https://www.postgresql.org/docs/current/ddl-constraints.html — lu le 16.11.2026
- Extrait lu : « PostgreSQL does not support CHECK constraints that reference table data other than the new or updated row being checked. While a CHECK constraint that violates this rule may appear to work in simple tests, it cannot guarantee that the database will not reach a state in which the constraint condition is false » ; « If possible, use UNIQUE, EXCLUDE, or FOREIGN KEY constraints to express cross-row and cross-table restrictions. » ; « When the referencing table represents something that is a component of what is represented by the referenced table and cannot exist independently, then CASCADE could be appropriate. If the two tables represent independent objects, then RESTRICT or NO ACTION is more appropriate »
- Portée / limites : la doc pose aussi que les conditions `CHECK` sont supposées immuables (pas de `now()` dans un CHECK). Avec la suppression douce, `ON DELETE CASCADE` ne se déclenche jamais : la cascade doit être portée par le code ou un trigger. Index de la colonne FK : renvoi `backend-donnees-postgres.md` § 2.
- En conception : un `CHECK` appelle-t-il une fonction qui lit une autre table ? Un `CHECK` dépend-il de l'heure ? Chaque FK a-t-elle un `ON DELETE` choisi (composant → CASCADE, objet indépendant → RESTRICT) plutôt que le défaut par oubli ?

### Suppression douce : l'unicité passe par un index unique partiel `WHERE deleted_at IS NULL`, et une politique SELECT qui masque les lignes supprimées peut faire échouer le `UPDATE … RETURNING` qui les supprime
- Niveau de preuve : N3
- Source : PostgreSQL 18.7, « 11.8. Partial Indexes » (exemple 11.3), https://www.postgresql.org/docs/current/indexes-partial.html ; « CREATE POLICY », https://www.postgresql.org/docs/current/sql-createpolicy.html ; « 5.5. Constraints » — lus le 16.11.2026
- Extrait lu : « This enforces uniqueness among the rows that satisfy the index predicate, without constraining those that do not. » ; « A uniqueness restriction covering only some rows cannot be written as a unique constraint, but it is possible to enforce such a restriction by creating a unique partial index. » ; CREATE POLICY : « any newly inserted or updated rows from the relation must satisfy the relation's SELECT policies in order to be available to the RETURNING clause. If a newly inserted or updated row does not satisfy the relation's SELECT policies, an error will be thrown »
- Portée / limites : un index partiel ne peut pas être la cible d'une FK (la doc exige un index unique « non-partial »). Le lien avec la suppression douce est une application (N0) : la doc ne parle pas de `deleted_at`. Un client qui demande la ligne mise à jour en retour (RETURNING) se heurte à l'erreur si la politique SELECT filtre `deleted_at IS NULL`. Statut juridique d'une ligne marquée supprimée : renvoi `backend-observabilite-tests-donnees.md` (« restriction temporaire, pas effacement »).
- En conception : une table à `deleted_at` a-t-elle un `UNIQUE` simple qui empêchera de recréer un élément supprimé ? Toutes les requêtes et politiques filtrent-elles `deleted_at IS NULL` (une vue ou une politique centralise-t-elle le filtre) ? La suppression douce passe-t-elle par une fonction plutôt que par un `update … select()` du client ?

### L'historique des modifications se tient par un trigger d'audit écrivant dans une table à part ; au-delà d'environ mille écritures par seconde, mesurer son coût
- Niveau de preuve : N3 (doc PostgreSQL) ; N4 (billet d'éditeur)
- Source : PostgreSQL 18.7, « 41.10. Trigger Functions » (exemples 41.4 et 41.7), https://www.postgresql.org/docs/current/plpgsql-trigger.html ; Oliver Rice, Supabase, 08.03.2022, « Postgres Auditing in 150 lines of SQL », https://supabase.com/blog/postgres-audit — lus le 16.11.2026
- Extrait lu : doc : « This example trigger ensures that any insert, update or delete of a row in the emp table is recorded (i.e., audited) in the emp_audit table. The current time and user name are stamped into the row » ; trigger par instruction avec tables de transition : « This can be significantly faster than the row-trigger approach when the invoking statement has modified many rows. » ; Supabase : « Auditing tables always reduces throughput of inserts, updates, and deletes. » ; « In cases where throughput is less than 1000 writes per second the overhead is typically negligible. » ; « consider logging changes outside of SQL with a tool like pgAudit. »
- Portée / limites : seuil donné par l'éditeur sans mesure publiée. Une table d'audit contient des données personnelles (anciennes valeurs) : elle entre dans la durée de conservation et l'effacement (renvoi `backend-observabilite-tests-donnees.md` § 5). Côté local (IndexedDB), le même rôle est tenu par une table de mouvements écrite dans la même transaction que la donnée.
- En conception : une table dont l'historique compte (prix, stock, droits) a-t-elle une table d'audit ou de mouvements ? L'audit enregistre-t-il qui, quand, quelle opération, avant et après ? Sa durée de conservation est-elle fixée ?

### Une validité dans le temps (`valid_from`/`valid_to`) se modélise en plage, et PostgreSQL 18 empêche les chevauchements avec `WITHOUT OVERLAPS` et `PERIOD`
- Niveau de preuve : N3
- Source : PostgreSQL, « Release 18 » (sortie 2025-09-25), https://www.postgresql.org/docs/release/18.0/ ; PostgreSQL 18.7, « CREATE TABLE », https://www.postgresql.org/docs/current/sql-createtable.html — lus le 16.11.2026
- Extrait lu : « Allow the specification of non-overlapping PRIMARY KEY, UNIQUE, and foreign key constraints » ; « This is specified by WITHOUT OVERLAPS for PRIMARY KEY and UNIQUE, and by PERIOD for foreign keys, all applied to the last specified column. » ; « UNIQUE (id, valid_at WITHOUT OVERLAPS) behaves like EXCLUDE USING GIST (id WITH =, valid_at WITH &&) » ; « The WITHOUT OVERLAPS column must have a range or multirange type. Empty ranges/multiranges are not permitted. » ; « you can use other types by adding the btree_gist extension (which is the expected way to use this feature) » ; PERIOD : « the reference must have a referent for its entire duration »
- Portée / limites : PostgreSQL 18 seulement ; deux colonnes `valid_from`/`valid_to` ne profitent pas de la contrainte : il faut une colonne `tstzrange`/`daterange`. La disponibilité de `btree_gist` sur Supabase n'a pas été vérifiée. Avant PG 18, `EXCLUDE USING GIST` donne le même effet pour l'unicité, pas pour la FK temporelle.
- En conception : deux périodes d'un même objet (tarif, affectation, contrat) peuvent-elles se chevaucher faute de contrainte ? La version de PostgreSQL du projet est-elle ≥ 18 avant de proposer `WITHOUT OVERLAPS` ?

### JSONB pour une donnée atomique à structure souple ; pas pour ce qu'on filtre, joint, contraint ou modifie champ par champ
- Niveau de preuve : N3
- Source : PostgreSQL 18.7, « 8.14. JSON Types » (§ 8.14.2 Designing JSON Documents), https://www.postgresql.org/docs/current/datatype-json.html — lu le 16.11.2026
- Extrait lu : « most applications should prefer to store JSON data as jsonb » ; « it is still recommended that JSON documents have a somewhat fixed structure » ; « any update acquires a row-level lock on the whole row. Consider limiting JSON documents to a manageable size in order to decrease lock contention » ; « Ideally, JSON documents should each represent an atomic datum that business rules dictate cannot reasonably be further subdivided into smaller datums that could be modified independently. »
- Portée / limites : la doc ne donne pas de seuil de taille. Un champ JSONB n'a ni FK ni NOT NULL par clé ; une validation (CHECK sur `jsonb_typeof`, schéma Zod à la frontière) doit le remplacer. JSONB est aussi la sortie de secours contre l'EAV (§ anti-patterns).
- En conception : une clé du JSONB sert-elle dans un `WHERE`, une jointure ou une FK (elle devrait être une colonne) ? Le document est-il modifié par morceaux par plusieurs écrivains ? Sa forme est-elle validée quelque part ?

### Multi-tenant : une colonne tenant + RLS (modèle « pool ») ne tient que si l'application se connecte avec un rôle qui n'est pas propriétaire des tables, ou si la table est en `FORCE ROW LEVEL SECURITY`
- Niveau de preuve : N4 (blog d'éditeur cloud)
- Source : Michael Beardsley, AWS Database Blog, 18.05.2020, « Multi-tenant data isolation with PostgreSQL Row Level Security », https://aws.amazon.com/blogs/database/multi-tenant-data-isolation-with-postgresql-row-level-security/ — lu le 16.11.2026
- Extrait lu : modèle pool : « uses both a shared database instance and namespace » ; il « saves the most on operational costs » mais « this model can be more difficult to enforce your data access policies » ; « the table owner isn't restricted by security policies unless the table is altered with FORCE ROW LEVEL SECURITY » ; « you should have your application connect to the database as a user other than the owner of the database objects »
- Portée / limites : le billet cite aussi les modèles « silo » (instance par client) et « bridge » (base ou schéma par client) ; leur description détaillée n'a pas été lue mot à mot. Le passage du tenant par `current_setting('app.current_tenant')` est signalé comme fragile derrière un pooler (renvoi `backend-donnees-postgres.md` § 6). Sur Supabase, l'identité vient du JWT (`auth.uid()`), pas d'une variable de session : renvoi § 7 de la même fiche.
- En conception : chaque table partagée porte-t-elle `tenant_id NOT NULL`, indexé, présent dans chaque politique ? Les clés uniques métier incluent-elles `tenant_id` ? Le rôle de connexion de l'application est-il propriétaire des tables ? Un schéma par client multiplie-t-il les migrations à jouer ?

### Anti-patterns à refuser en revue : liste séparée par des virgules, association polymorphe sans FK, héritage de tables et règles (`RULE`)
- Niveau de preuve : N4 (livre de praticien, doc d'ingénierie d'entreprise, wiki)
- Source : Bill Karwin, 2022, *SQL Antipatterns, Volume 1*, Pragmatic Bookshelf, chap. 2 « Jaywalking » (extrait PDF de l'éditeur, https://media.pragprog.com/titles/bksap1/jaywalking.pdf ; sommaire : https://pragprog.com/titles/bksap1/sql-antipatterns-volume-1/) ; GitLab, « Polymorphic associations », https://docs.gitlab.com/development/database/polymorphic_associations/ ; PostgreSQL Wiki, « Don't Do This » — lus le 16.11.2026
- Extrait lu : Karwin : « Programmers commonly use comma-separated lists to avoid creating an intersection table for a many-to-many relationship. » ; « Pattern-matching expressions may return false matches. Performance is poor because the matching can't benefit from indexes. » ; GitLab : « always use separate tables instead of polymorphic associations » ; « being unable to enforce data consistency on the database level using foreign keys » ; wiki : « Don't use rules. If you think you want to, use a trigger instead. » ; « Don't use table inheritance. If you think you want to, use foreign keys instead. »
- Portée / limites : l'EAV (« Entity-Attribute-Value ») et « Multicolumn Attributes » figurent au sommaire de Karwin, mais leur chapitre n'a pas été lu (cf. « Non vérifié »). Un tableau PostgreSQL ou un JSONB n'est pas une liste séparée par des virgules, mais il perd aussi la FK.
- En conception : une colonne texte contient-elle des identifiants séparés par des virgules ? Un couple `(commentable_type, commentable_id)` sans FK ? Une table `attributes(entity_id, name, value)` ? Un `CREATE RULE` ou un `INHERITS` ?

---

## 2. Auditer une base existante

### Commencer l'audit par les requêtes qui coûtent le plus en temps cumulé (`pg_stat_statements`), puis seulement `EXPLAIN`
- Niveau de preuve : N3
- Source : PostgreSQL 18.7, « F.30. pg_stat_statements », https://www.postgresql.org/docs/current/pgstatstatements.html — lu le 16.11.2026
- Extrait lu : « provides a means for tracking planning and execution statistics of all SQL statements executed by a server. » ; « The module must be loaded by adding pg_stat_statements to shared_preload_libraries in postgresql.conf […] a server restart is needed » ; `total_exec_time` « Total time spent executing the statement, in milliseconds » ; « the constant is replaced by a parameter symbol, such as $1 » ; `pg_stat_statements.max` « The default value is 5000. »
- Portée / limites : les compteurs s'accumulent depuis la dernière remise à zéro (`pg_stat_statements_reset`) : noter la date de départ. La disponibilité de l'extension sur Supabase n'a pas été relue ici. Lecture du plan : renvoi `backend-donnees-postgres.md` § 2 (`EXPLAIN (ANALYZE, BUFFERS)`).
- En conception (audit) : la liste triée par `total_exec_time` (puis `mean_exec_time`, `calls`) est-elle produite avant toute proposition d'index ? Le ratio `shared_blks_read` / `shared_blks_hit` des requêtes de tête est-il regardé ?

### Un index jamais parcouru se repère par `idx_scan` et `last_idx_scan` de `pg_stat_user_indexes`, à condition de connaître la date de remise à zéro des statistiques
- Niveau de preuve : N3
- Source : PostgreSQL 18.7, « 27.2. The Cumulative Statistics System », https://www.postgresql.org/docs/current/monitoring-stats.html — lu le 16.11.2026
- Extrait lu : `idx_scan` « Number of index scans initiated on this index » ; `last_idx_scan` « The time of the last scan on this index, based on the most recent transaction stop time » ; « when starting from an unclean shutdown (e.g., after an immediate shutdown, a server crash, starting from a base backup, and point-in-time recovery), all statistics counters are reset. »
- Portée / limites : un index à zéro scan peut servir une contrainte (`UNIQUE`, PK) : il ne se retire pas pour autant. Un index utilisé par un traitement mensuel paraît inutile sur trois semaines. Les doublons d'index sont signalés par le lint Supabase `0009_duplicate_index`. Coût d'un index en écriture : renvoi `backend-donnees-postgres.md` § 2.
- En conception (audit) : quels index ont `idx_scan = 0` depuis une date de départ connue et ne portent aucune contrainte ? Deux index ont-ils les mêmes colonnes de tête ? Une table a-t-elle un `seq_scan` élevé sur une grosse volumétrie ?

### Le bloat se lit dans `n_dead_tup` et `last_autovacuum` ; on laisse l'autovacuum actif et on évite `VACUUM FULL`, qui verrouille toute la table
- Niveau de preuve : N3
- Source : PostgreSQL 18.7, « 24.1. Routine Vacuuming », https://www.postgresql.org/docs/current/routine-vacuuming.html ; « 27.2 » (colonnes de `pg_stat_all_tables`), URL ci-dessus — lus le 16.11.2026
- Extrait lu : VACUUM sert « To recover or reuse disk space occupied by updated or deleted rows », « To update data statistics used by the PostgreSQL query planner », « To protect against loss of very old data due to transaction ID wraparound » ; « It is unwise to disable the daemon completely unless you have an extremely predictable workload. » ; VACUUM simple « will not return the space to the operating system » (sauf pages finales) ; « VACUUM FULL requires an ACCESS EXCLUSIVE lock on the table » ; « administrators should strive to use standard VACUUM and avoid VACUUM FULL. »
- Portée / limites : `n_dead_tup` est une estimation. Supabase signale `0020_table_bloat` et `0030_autovacuum_disabled`. Une suppression douce massive ne crée pas de lignes mortes ; une purge physique, oui.
- En conception (audit) : une table a-t-elle l'autovacuum désactivé (`autovacuum_enabled = off`) ? `last_autovacuum`/`last_autoanalyze` sont-ils anciens sur une table très écrite ? Un runbook propose-t-il `VACUUM FULL` en heures ouvrées ?

### Sur Supabase, lancer les advisors (Studio, `supabase db advisors` ou MCP `get_advisors`) en début d'audit : ils couvrent FK non indexées, index en double ou inutilisés, tables sans PK, RLS et bloat
- Niveau de preuve : N3
- Source : Supabase, s.d., « Database Advisors », https://supabase.com/docs/guides/database/database-advisors ; dépôt `supabase/splinter`, https://github.com/supabase/splinter — lus le 16.11.2026
- Extrait lu : « Advisors are deterministic checks that ship with the platform. » ; ils « flag health, security, and performance issues in your project » ; lints lus : `0001_unindexed_foreign_keys`, `0003_auth_rls_initplan`, `0004_no_primary_key`, `0005_unused_index`, `0006_multiple_permissive_policies`, `0009_duplicate_index`, `0011_function_search_path_mutable`, `0013_rls_disabled_in_public`, `0020_table_bloat`, `0023_sensitive_columns_exposed`, `0030_autovacuum_disabled` ; splinter : « Supabase Postgres Linter: Performance and Security Advisors »
- Portée / limites : la page lue ne dit pas quel lint relève de quel advisor, ni leur niveau (ERROR/WARN/INFO, définis par splinter sans attribution par lint dans le README). Le traitement des lints ERROR avant mise en production : renvoi `securite-plateforme-deploiement.md`. Les advisors ne voient ni la modélisation (§ 1) ni les données existantes.
- En conception (audit) : la sortie des advisors est-elle jointe au rapport d'audit, avec un sort (corrigé, accepté et motivé) pour chaque ligne ?

---

## 3. Local-first et mobile

### Le stockage d'une PWA est « best-effort » : demander `navigator.storage.persist()`, surveiller `estimate()`, et donner à l'utilisateur un export, car Safari efface après sept jours sans interaction
- Niveau de preuve : N3
- Source : MDN, modifiée le 05.01.2026, « Storage quotas and eviction criteria », https://developer.mozilla.org/en-US/docs/Web/API/Storage_API/Storage_quotas_and_eviction_criteria — lu le 16.11.2026
- Extrait lu : « Best-effort data persists as long as the origin is below its quota, the device has enough storage space, and the user doesn't choose to delete the data » ; persistant : « only evicted, or deleted, if the user chooses to » ; « Safari and most Chromium-based browsers […] automatically approve or deny the request based on the user's history of interaction with the site and do not show any prompts » ; « an origin can store up to 60% of the total disk size » (Chromium) ; Firefox best-effort : le plus petit de « 10% of the total disk size » et « 10 GiB » ; « If an origin has no user interaction, such as click or tap, in the last seven days of browser use, its data created from script will be deleted. » ; `estimate()` « only returns the estimated usage value »
- Portée / limites : la règle des sept jours s'applique quand la prévention du pistage intersite est active ; le sort d'une PWA installée sur l'écran d'accueil n'est pas précisé sur cette page. `persist()` peut être refusé sans message : le résultat doit être lu. Principe « Long Now » et propriété des données : renvoi `architecture-qualites-nfr.md` (Kleppmann et al.).
- En conception : l'app appelle-t-elle `navigator.storage.persist()` et affiche-t-elle le résultat ? Existe-t-il un export complet, versionné (`formatVersion`), réimportable, et un rappel d'export ? L'import valide-t-il le fichier à la frontière ?

### IndexedDB : le schéma ne change que dans `onupgradeneeded`, un autre onglet ouvert bloque la montée de version, et une transaction se ferme dès qu'on rend la main à la boucle d'événements
- Niveau de preuve : N3
- Source : MDN, modifiée le 11.09.2026, « Using IndexedDB », https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API/Using_IndexedDB — lu le 16.11.2026
- Extrait lu : « onupgradeneeded is the only place where you can alter the structure of the database. » ; « all other open databases must explicitly acknowledge the request before you can start making changes to the database (an onblocked event is fired until they are closed or reloaded). » ; « If you don't do this then the upgrade won't happen until the user closes the tab. » ; « If you make a transaction and return to the event loop without using it then the transaction will become inactive. » ; « As of Firefox 40, IndexedDB transactions have relaxed durability guarantees »
- Portée / limites : conséquence (N0) : pas d'`await fetch()` au milieu d'une transaction IndexedDB ; lire le réseau avant, écrire ensuite. Le mode `readwriteflush` cité par MDN est « experimental (non-standard) ».
- En conception : un gestionnaire `onversionchange` (ou l'équivalent Dexie) ferme-t-il la base et prévient-il l'utilisateur ? Une transaction contient-elle un appel réseau ou un `setTimeout` ? Une écriture multi-tables se fait-elle dans une seule transaction ?

### Dexie : chaque changement de schéma est une nouvelle `version(n)` ; une version porteuse d'un `upgrade()` ne se modifie jamais et se garde tant qu'un appareil peut être en dessous ; n'indexer que ce qui sert un `where`
- Niveau de preuve : N3
- Source : Dexie.js, « Design » (§ Database Versioning), https://dexie.org/docs/Tutorial/Design#database-versioning ; « Version.stores() », https://dexie.org/docs/Version/Version.stores() ; « Dexie.version() », https://dexie.org/docs/Dexie/Dexie.version() ; registre npm (`dexie`, tag `latest` = 4.4.7, publié le 19.10.2026) — lus le 16.11.2026
- Extrait lu : « You only need to keep versions that have an upgrader » ; « A version with an upgrader attached must never be altered. » ; « Create/drop/alter indexes or tables by adding a new version(x) with an updated stores({...}) spec. » ; index omis : « they are dropped as soon as you don't specify them in a new versions. » ; « No upgrade() functions run in this case. » (base neuve) ; « Never index properties containing images, movies or large (huge) strings. » ; « the backend DB will get the given version number multiplied by 10. »
- Portée / limites : les pages lues ne disent rien d'un changement de clé primaire ni du sort d'un `upgrade()` qui échoue (cf. « Non vérifié ») : à tester. Comme `upgrade()` ne tourne pas sur une base neuve, une donnée transformée doit aussi être correcte quand elle arrive par l'import d'un ancien export.
- En conception : un diff modifie-t-il le `stores()` ou l'`upgrade()` d'une version existante au lieu d'en ajouter une ? Un test ouvre-t-il une base à la version n−1 remplie (fake-indexeddb), la monte et vérifie les données ? Un index déclaré n'est-il utilisé par aucune requête ?

### Sur Capacitor, IndexedDB et `localStorage` sont transitoires (iOS peut les vider) ; les données importantes vont en SQLite natif, dont le plugin courant est communautaire et chiffre par SQLCipher
- Niveau de preuve : N3
- Source : Capacitor (doc v8), « Data Storage », https://capacitorjs.com/docs/guides/storage ; `capacitor-community/sqlite`, README, https://github.com/capacitor-community/sqlite ; registre npm (`@capacitor-community/sqlite`, `latest` = 8.1.1 du 06.08.2026, `peerDependencies` `@capacitor/core >=8.0.0`) — lus le 16.11.2026
- Extrait lu : Capacitor (citation courte, la page est rendue reformulée) : `localStorage` « must be considered transient » ; même risque pour IndexedDB sur iOS, alors qu'Android permet de la marquer persistante ; SQLite décrit comme l'option la plus répandue pour de grandes données ; Preferences « meant for small amounts of data » ; README : « Capacitor community plugin for Native and Electron SQLite Databases. » ; « In Native, databases could be encrypted with SQLCipher » ; Web : « SQLite databases are backed by jeep-sqlite and stored in IndexedDB »
- Portée / limites : la doc Capacitor ne cite que des plugins communautaires et une offre SQLite « enterprise » d'Ionic (chiffrement, gestion de clés) ; il n'y a pas de plugin SQLite officiel gratuit sur la page lue. La doc v9 est déjà listée sur le site : relire avant de figer. Sur le web, le plugin retombe sur IndexedDB : le risque d'éviction revient.
- En conception : la migration vers SQLite garde-t-elle la couche d'accès comme seule dépendante du moteur ? La clé de chiffrement est-elle hors de la base et hors du code ? Le schéma SQLite est-il versionné (le README liste `addUpgradeStatement`) ?

### SQLite ne sait pas tout faire en `ALTER TABLE` : au-delà de renommer, ajouter ou supprimer une colonne, suivre la procédure en douze étapes, dans l'ordre exact
- Niveau de preuve : N3
- Source : SQLite, s.d., « ALTER TABLE », https://www.sqlite.org/lang_altertable.html — lu le 16.11.2026 (deux 503 avant lecture)
- Extrait lu : « SQLite supports a limited subset of ALTER TABLE. […] it can be renamed; a column can be renamed; a column can be added to it; or a column can be dropped from it. » ; étape 1 « If foreign key constraints are enabled, disable them using PRAGMA foreign_keys=OFF. » ; étape 2 « Start a transaction. » ; étape 10 « run PRAGMA foreign_key_check to verify that the schema change did not break any foreign key constraints. » ; « Take care to follow the procedure above precisely. » ; renommer d'abord l'ancienne table « might corrupt references to that table in triggers, views, and foreign key constraints. »
- Portée / limites : l'ordre sûr est : créer la nouvelle table sous un nom temporaire, copier, supprimer l'ancienne, renommer la nouvelle. Vérification d'intégrité après coup : renvoi `release-migrations-sauvegardes.md` (`integrity_check`, `foreign_key_check`).
- En conception : une migration SQLite change-t-elle un type, une contrainte ou une clé par un simple `ALTER` qui n'existe pas ? Renomme-t-elle l'ancienne table avant de créer la nouvelle ? Lance-t-elle `foreign_key_check` avant `COMMIT` ?

### Synchro future : une écriture concurrente du même champ reste un conflit ; un « dernier écrivain gagne » fondé sur l'horloge murale n'est pas ce que font les CRDT
- Niveau de preuve : N3 (doc d'Automerge) ; N2 (Kleppmann et al., Onward! 2019, via renvoi)
- Source : Automerge, « Conflicts », https://automerge.org/docs/reference/documents/conflicts/ ; Ink & Switch, M. Kleppmann, A. Wiggins, P. van Hardenberg, M. McGranaghan, 2019, « Local-first software », https://www.inkandswitch.com/essay/local-first/ — lus le 16.11.2026
- Extrait lu : Automerge : il « picks one of the concurrently written values as the "winner" » et « it ensures that this winner is the same on all nodes » ; les perdants sont « relegated to a conflicts object » ; « last writer wins » « is based on the internal ID of the operation, not a wall clock time » ; Ink & Switch : « If the state was concurrently modified on different devices, the CRDT merges those changes. » ; « We do not claim that these libraries fully realize local-first ideals. »
- Portée / limites : le reste (CRDT et conflits conservés) est déjà dans `architecture-qualites-nfr.md`. Ce que la synchro exige du schéma d'aujourd'hui relève du jugement (N0) : identifiants générés côté client, `updatedAt` par ligne, suppression douce (une suppression physique ne se propage pas), pas de compteur dérivé stocké sans source. Un `updatedAt` d'horloge d'appareil n'ordonne pas deux appareils de façon fiable (non sourcé ici, cf. « Non vérifié »).
- En conception : les identifiants sont-ils des UUID générés sur l'appareil ? Chaque table synchronisable a-t-elle `createdAt`, `updatedAt`, `deletedAt` ? Une règle de fusion est-elle écrite par champ (qui gagne, que voit l'utilisateur) avant de choisir un outil ?

---

## 4. Migrations sûres, au-delà des verrous

Déjà couvert ailleurs, à ne pas redire : verrous, `lock_timeout`, `CONCURRENTLY`, `NOT VALID`, expand/contract, backfill par lots (`backend-donnees-postgres.md` § 1) ; `migrate dev`/`deploy`, absence de down automatique, dérive, `db push --dry-run`, branches sans données, essai sur copie, copies de production et nLPD (`release-migrations-sauvegardes.md`) ; reality check des données existantes (`supabase-toolkit`, et verdict de `backend-donnees-postgres.md`).

### Les migrations s'appliquent dans l'ordre de leur horodatage ; un seed ne contient que des données et passe après toutes les migrations
- Niveau de preuve : N3
- Source : Supabase, s.d., « Database Migrations », https://supabase.com/docs/guides/deployment/database-migrations ; « Seeding your database », https://supabase.com/docs/guides/local-development/seeding-your-database — lus le 16.11.2026
- Extrait lu : « Migration files are applied in timestamp order, so concurrent pushes from different machines can cause conflicts. » ; `supabase db reset` : « Reset your database to reapply migrations and populate with seed data. » ; « Seed files are executed the first time you run supabase start and every time you run supabase db reset. » ; « Seeding occurs after all database migrations have been completed. » ; « As a best practice, only include data insertions in your seed files, and avoid adding schema statements. »
- Portée / limites : la page propose aussi `supabase db push --include-seed --remote`, sans avertissement sur la production : décider explicitement si un seed (comptes de démo) peut atteindre la base réelle. Une donnée de référence indispensable (liste de pays) va dans une migration, pas dans le seed, puisque le seed ne tourne pas en production par défaut (N0).
- En conception : deux migrations d'une même branche ont-elles été créées sur deux machines avec des horodatages croisés ? Le seed contient-il un `create`/`alter` ? Une donnée nécessaire en production n'existe-t-elle que dans le seed ?

### Les migrations se testent sur une base jetable : `supabase db reset` rejoue tout depuis zéro, et `supabase test db` lance des tests pgTAP, y compris sur la RLS
- Niveau de preuve : N3
- Source : Supabase, s.d., « Testing Your Database », https://supabase.com/docs/guides/database/testing ; « Database Migrations », URL ci-dessus — lus le 16.11.2026
- Extrait lu : « All sql files use pgTAP as the test runner » ; « Create a tests folder inside the supabase folder » ; « we encourage you to write automated tests » pour vérifier que les « RLS policies are correctly applied » ; l'exemple encadre le test par `begin;` et `rollback;`
- Portée / limites : rejouer depuis zéro prouve que la chaîne est cohérente, pas qu'elle passe sur les données réelles : pour ça, essai sur copie (renvoi `release-migrations-sauvegardes.md` § 4). Côté Dexie, l'équivalent est un test de montée de version avec fake-indexeddb (§ 3).
- En conception : `supabase db reset` passe-t-il sans erreur sur la branche ? Chaque politique RLS a-t-elle un test pgTAP qui prouve un refus (autre utilisateur, `anon`) et pas seulement un accès ?

### Séparer migration de schéma et migration de données ; une migration de données se rejoue sur une copie restaurée d'avant son passage
- Niveau de preuve : N3 (doc d'un outil en version candidate)
- Source : Prisma ORM, « Editing a migration » (page servie à l'URL `/docs/orm/prisma-migrate/workflows/data-migration`, contenu Prisma ORM 8), https://www.prisma.io/docs/orm/prisma-migrate/workflows/data-migration — lu le 16.11.2026
- Extrait lu : « When you want a data-only migration, which changes rows and leaves your contract state as it is […] run npx prisma migration new. » ; « A migration that only changes data starts and ends at the same contract state. » ; « A dataTransform is where you say what should happen to the rows already in the table. » ; « one npx prisma db migrate run on PostgreSQL is one transaction » ; « To try an edited data migration again, restore a copy of the database from before it ran. »
- Portée / limites : Prisma 8 était une release candidate au 09.11.2026 (`backend-donnees-postgres.md` § 5) ; noms de commandes à relire avant usage. Le principe (une étape qui transforme les lignes existantes, ordonnée avant la suppression de l'ancienne colonne, et rejouable seulement depuis une copie) vaut pour tout outil. Une migration de données dans une seule transaction tient des verrous longtemps sur une grosse table : renvoi backfill par lots.
- En conception : la migration mélange-t-elle `ALTER` et `UPDATE` massif dans un même fichier sans raison ? L'ancienne colonne est-elle supprimée avant que le backfill ait lu ses valeurs ? Une copie d'avant migration existe-t-elle pour rejouer ?

---

## 5. Sécurité et données personnelles côté base

Déjà couvert ailleurs : RLS, `SECURITY DEFINER`, clé secrète Supabase (`backend-donnees-postgres.md` § 7) ; nLPD art. 6 à 8, RGPD minimisation, conservation, pseudonymisation, droits, effacement, sauvegardes et effacement, suppression logique (`backend-observabilite-tests-donnees.md` § 5 et 6) ; sauvegardes Supabase selon le plan, PITR, Storage non inclus (`securite-plateforme-deploiement.md`, `release-progressif-retour-arriere.md`) ; restauration testée (`release-migrations-sauvegardes.md` § 1).

### Moindre privilège : PostgreSQL donne par défaut `EXECUTE` à PUBLIC sur toute fonction ; on révoque dans la même transaction que la création, et le schéma `public` d'une base migrée depuis PG ≤ 14 laisse encore créer à tous
- Niveau de preuve : N3
- Source : PostgreSQL 18.7, « 5.8. Privileges », https://www.postgresql.org/docs/current/ddl-priv.html ; « 5.10. Schemas » (§ 5.10.6), https://www.postgresql.org/docs/current/ddl-schemas.html — lus le 16.11.2026
- Extrait lu : « No privileges are granted to PUBLIC by default on tables, table columns, sequences […] schemas » ; « EXECUTE privilege for functions and procedures; and USAGE privilege for languages and data types » ; « For maximum security, issue the REVOKE in the same transaction that creates the object; then there is no window in which another user can use the object. » ; « The right to modify or destroy an object is inherent in being the object's owner, and cannot be granted or revoked in itself. » ; « In PostgreSQL 15 and later, the default configuration supports this usage pattern. In prior versions, or when using a database that has been upgraded from a prior version, you will need to remove the public CREATE privilege from the public schema »
- Portée / limites : sur Supabase, des droits sont accordés aux rôles `anon` et `authenticated` par la plateforme (non relu ici) : la RLS reste la barrière principale. Le propriétaire contourne la RLS (renvoi § 7 de `backend-donnees-postgres.md` et entrée multi-tenant ci-dessus).
- En conception : chaque `create function` est-il suivi, dans la même migration, d'un `revoke execute … from public` (et `anon` sur Supabase) puis d'un `grant` ciblé ? Le rôle de l'application est-il propriétaire des tables ? Sur une base issue d'un PG ≤ 14, `CREATE` sur `public` a-t-il été retiré à PUBLIC ?

### Le chiffrement de colonne par pgcrypto protège le stockage, pas l'administrateur du serveur : la clé et le clair y transitent ; si l'hébergeur n'est pas de confiance, chiffrer côté client, et imposer SSL sur les connexions directes
- Niveau de preuve : N3
- Source : PostgreSQL 18.7, « F.26. pgcrypto » (§ F.26.8.3 Security Limitations), https://www.postgresql.org/docs/current/pgcrypto.html ; « 18.8. Encryption Options », https://www.postgresql.org/docs/current/encryption-options.html — lus le 16.11.2026
- Extrait lu : « All pgcrypto functions run inside the database server. That means that all the data and passwords move between pgcrypto and client applications in clear text. Thus you must: Connect locally or use SSL connections. Trust both system and database administrator. If you cannot, then better do crypto inside client application. » ; « The implementation does not resist side-channel attacks. » ; « The decrypted data and the decryption key are present on the server for a brief time » ; « If the system administrator for the server's machine cannot be trusted, it is necessary for the client to encrypt the data; this way, unencrypted data never appears on the database server. »
- Portée / limites : une clé passée en paramètre de requête peut finir dans les journaux ou dans `pg_stat_statements` si elle est littérale (normalisée en `$1` seulement quand c'est une constante — non vérifié pour ce cas). Une colonne chiffrée ne s'indexe ni ne se trie utilement. Pour les mots de passe d'utilisateurs : hachage, pas chiffrement (renvoi `backend-securite-api-auth.md`).
- Au repos et en transit (Supabase, « Security », https://supabase.com/security, et « Platform Security », https://supabase.com/docs/guides/security/platform-security, lus le 16.11.2026) : « All customer data is encrypted at rest with AES-256 and in transit via TLS. » ; mais « Supabase projects support connecting to the Postgres DB without SSL enforced to maximize client compatibility. » et « you can prevent clients from connecting if they're not using SSL. » Affirmations d'éditeur (N3) ; le chiffrement au repos couvre le vol de support, pas un accès légitime au projet. Sur le téléphone, IndexedDB n'est pas chiffrée par l'app ; SQLCipher (§ 3) chiffre la base SQLite.
- En conception : quelle menace la colonne chiffrée couvre-t-elle (vol de sauvegarde, accès admin, fuite de dump) ? Où vit la clé (pas dans la base, pas dans le dépôt) ? Une requête filtre-t-elle sur une colonne chiffrée ? L'option « Enforce SSL » est-elle activée et les chaînes de connexion portent-elles `sslmode=require` (ou plus strict) ?

### L'effacement et la durée de conservation se conçoivent dans le schéma : chaque table personnelle a une durée, une voie d'effacement et une place dans le test de restauration
- Niveau de preuve : N1
- Source : Règlement (UE) 2016/679 (RGPD), art. 5 par. 1 let. c et e, art. 17 par. 1, art. 25 par. 2, art. 32 par. 1 let. c et d, https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32016R0679 — lu le 16.11.2026 (texte anglais)
- Extrait lu : art. 5 : « adequate, relevant and limited to what is necessary » ; données gardées sous une forme qui « permits identification of data subjects for no longer than is necessary » ; art. 17 : effacement « without undue delay » ; art. 25 par. 2 : « only personal data which are necessary for each specific purpose of the processing are processed. » ; art. 32 : « the ability to restore the availability and access to personal data in a timely manner » ; « a process for regularly testing, assessing and evaluating the effectiveness of technical and organisational measures »
- Portée / limites : applicabilité du RGPD à une app personnelle ou suisse : à faire trancher (renvoi `backend-observabilite-tests-donnees.md` § 5, qui porte aussi la nLPD art. 6 à 8 lue le 09.11.2026). La traduction en schéma (colonne de durée, job de purge, liste des tables touchées par un effacement) est une application (N0), pas un texte de loi.
- En conception : la liste des tables et colonnes personnelles existe-t-elle (tables d'audit et de mouvements comprises) ? L'effacement d'un utilisateur atteint-il chacune (FK `CASCADE`, anonymisation, ou purge planifiée) ? Une restauration de test vérifie-t-elle que les effacements sont réappliqués ?

---

## Verdict pour l'agent `architecte-donnees`

Règles formulées comme des vérifications. Chacune garde le niveau de sa preuve la plus forte.

| # | Vérification | Niveau | Appui |
|---|---|---|---|
| 1 | Aucune colonne d'instant en `timestamp` sans fuseau, aucun montant en `real`/`float8`/`money`, aucun `char(n)` ni `serial` dans une table nouvelle. | N3 | § 1 (types) |
| 2 | Chaque colonne nullable a une raison écrite ; chaque `UNIQUE` sur colonne nullable a été examiné (`NULLS NOT DISTINCT` ou index partiel). | N3 | § 1 (NULL) |
| 3 | Chaque table a une clé primaire ; chaque identité métier a son `UNIQUE` en plus de la clé technique. | N3 | § 1 (clés), lint `0004` |
| 4 | Aucun invariant entre lignes dans un `CHECK` ; chaque FK a un `ON DELETE` choisi et sa colonne indexée. | N3 | § 1 (invariants), lint `0001` |
| 5 | Une table à suppression douce : unicité en index partiel `WHERE deleted_at IS NULL`, filtre centralisé, suppression passant par une fonction si une politique SELECT masque les supprimés ; plus une purge ou une anonymisation datée. | N3 (mécanismes) ; N1 renvoyé (effacement) | § 1, § 5 |
| 6 | Aucune liste séparée par des virgules, aucune association polymorphe sans FK, aucun `RULE` ni `INHERITS` ; un JSONB n'est jamais filtré, joint ou contraint par clé. | N4 (anti-patterns) ; N3 (JSONB) | § 1 |
| 7 | Multi-tenant : `tenant_id NOT NULL` indexé dans chaque table partagée et dans chaque politique ; l'application ne se connecte pas en propriétaire, ou la table est en `FORCE ROW LEVEL SECURITY`. | N4 (AWS) ; N3 renvoyé (RLS) | § 1 |
| 8 | Un audit commence par `pg_stat_statements` (date de remise à zéro notée) et les advisors Supabase ; aucun index n'est retiré sur `idx_scan = 0` sans connaître la date de départ des statistiques et vérifier qu'il ne porte pas de contrainte. | N3 | § 2 |
| 9 | Une app locale : `persist()` demandé et résultat lu, export complet versionné et réimportable, `onversionchange` géré, aucune transaction IndexedDB ouverte à travers un `await` réseau. | N3 | § 3 |
| 10 | Dexie : jamais de modification d'une version publiée qui porte un `upgrade()` ; un test monte une base n−1 remplie ; une migration SQLite suit les douze étapes avec `foreign_key_check`. | N3 | § 3 |
| 11 | Une chaîne de migrations rejoue depuis zéro (`db reset`) ; le seed ne contient que des données ; chaque politique RLS a un test de refus. | N3 | § 4 |
| 12 | Chaque fonction créée est suivie dans la même migration d'un `revoke execute … from public` ; SSL imposé sur les connexions directes ; tout chiffrement de colonne nomme sa menace et l'endroit de sa clé. | N3 | § 5 |

---

## Mythes et affirmations contestées

- **« `varchar(255)` est plus rapide que `text`. »** Faux en PostgreSQL : « There is no performance difference among these three types » (doc 8.3), hors stockage de `char(n)`.
- **« Le type `money` est fait pour l'argent. »** Le wiki PostgreSQL le déconseille ; `numeric` ou des entiers (« rarely »).
- **« `timestamptz` stocke le fuseau horaire. »** Non : il stocke un instant en UTC, « the originally stated or assumed time zone is not retained » (doc 8.5).
- **« Un `UNIQUE` empêche tout doublon. »** Pas quand une colonne contrainte est NULL, sauf `NULLS NOT DISTINCT` (doc 5.5).
- **« Une colonne `identity` est unique. »** La doc : « An identity column, however, does not guarantee uniqueness. »
- **« Un `CHECK` qui appelle une fonction lisant une autre table tient l'invariant. »** Il « may appear to work in simple tests » mais ne le garantit pas (doc 5.5).
- **« On retire une valeur d'un enum avec `ALTER TYPE`. »** Impossible sans recréer le type (doc 8.7).
- **« `VACUUM` rend l'espace disque au système. »** Seulement les pages finales libres ; `VACUUM FULL` le fait, sous ACCESS EXCLUSIVE (doc 24.1).
- **« Un index à zéro scan est inutile. »** Pas s'il porte une contrainte, ni si les statistiques ont été remises à zéro (crash, PITR) récemment (doc 27.2).
- **« IndexedDB est un stockage durable. »** Best-effort par défaut ; Safari efface après sept jours sans interaction quand la prévention du pistage est active (MDN). Sur iOS via Capacitor, transitoire (doc Capacitor).
- **« Avec Dexie ≥ 3, on peut supprimer les anciennes versions. »** Seulement celles sans `upgrade()` ; une version avec upgrader « must never be altered » et se garde tant que des appareils sont en dessous.
- **« Dernier écrivain gagne = horodatage le plus récent. »** Pas dans Automerge : « based on the internal ID of the operation, not a wall clock time ».
- **« pgcrypto chiffre les données à l'abri de l'hébergeur. »** Non : clé et clair passent par le serveur ; « better do crypto inside client application » si l'administrateur n'est pas de confiance.
- **« La quatrième forme normale s'appelle aussi BCNF. »** Erreur de l'article Microsoft Learn lu : la BCNF est un renforcement de la 3NF, distinct de la 4NF (notion de manuel, N0 ici faute de source primaire lue).

---

## Non vérifié

- **EAV et « Multicolumn Attributes » chez Karwin** : seuls les titres du sommaire ont été lus ; aucun extrait de ces chapitres.
- **Description verbatim des modèles silo et bridge** dans le billet AWS : seul le modèle pool a été cité mot à mot. Les pages AWS Prescriptive Guidance sur le multi-tenant PostgreSQL ont répondu 404.
- **Disponibilité de `btree_gist` et de `pg_stat_statements` sur Supabase**, et droits accordés par défaut à `anon`/`authenticated` : non relus.
- **Dexie : changement de clé primaire et comportement d'un `upgrade()` qui échoue** (rollback de toute la montée de version ?) : non trouvés dans les trois pages lues.
- **Sort d'une PWA installée face à la règle des sept jours de Safari** : non précisé sur la page MDN lue.
- **Plugin SQLite officiel Capacitor** : la page lue ne cite que des plugins communautaires et une offre « enterprise » ; aucune page de plugin officiel gratuit trouvée. Le README du plugin communautaire n'affiche pas de table de compatibilité (versions tirées du registre npm).
- **Chiffrement d'IndexedDB par le système du téléphone** (protection des données iOS/Android) : non lu.
- **Fiabilité d'un `updatedAt` d'horloge d'appareil pour ordonner des écritures** : aucune source primaire lue sur la dérive d'horloge en synchro.
- **Textes de la nLPD sur fedlex** : la page demande JavaScript ; non relue le 16.11.2026 (la fiche `backend-observabilite-tests-donnees.md` l'a lue le 09.11.2026 par le filestore).
- **Prisma 8 stable** : les noms `prisma migration new`, `prisma db migrate`, `dataTransform` viennent d'une page de la doc Prisma ORM 8 ; statut stable non vérifié au 16.11.2026.
- **Une clé de chiffrement passée en paramètre lié apparaît-elle dans `pg_stat_statements` ou les journaux** : non vérifié.

# Fiche `ux-preuves` — Mise en production — migrations, sauvegardes et restauration

> Fiche du skill `ux-preuves` (dev-fullstack), volet **mise en production**, préchargé par `release`. Couvre : sauvegarde vérifiée par la restauration (post-mortem GitLab 2017), DDL transactionnel et verrous PostgreSQL, Prisma, Supabase CLI et Drizzle, dérive de schéma, essai à blanc et branches vides, stores de fichiers et SQLite, copies de production et protection des données.
> **Instantané de la recherche documentaire du 10.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Études (souvent des prépublications pour les LLM), docs d'outils
> et pratiques d'entreprise **vieillissent** : avant d'en faire dépendre une règle,
> relire la source (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles de l'agent », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

**Méthode.** Recherche menée le 10 novembre 2026. Chaque entrée repose sur une page réellement ouverte : par WebFetch, ou téléchargée avec curl puis extraite (`pdftotext` pour les PDF, nettoyage HTML suivi d'un grep pour vérifier les citations du post-mortem GitLab, du post-incident Atlassian, de la nLPD et de plusieurs pages PostgreSQL). Les extraits entre guillemets sont recopiés de la page. Quand l'outil de lecture n'a rendu qu'un fragment, la citation est tronquée par « … ». La documentation d'un outil décrit sa version au jour de la lecture : PostgreSQL 18 (pages « 18.6 Documentation »), Prisma ORM v7 pour les pages `/docs/orm/v7/…` et la référence CLI, man-pages Linux 6.19. Pour Supabase CLI et Drizzle Kit, aucune version n'est affichée sur les pages lues. Ce qui est déjà traité ailleurs a été écarté : `lock_timeout`, parallel change expand/migrate/contract, backfill par lots, offres de sauvegarde Supabase selon le plan, RLS. Niveaux de preuve : N1 = norme, standard ou texte de loi ; N2 = recherche revue par les pairs ; N3 = doc officielle d'un outil, guide d'une institution, post-mortem officiel ; N4 = livre, wiki communautaire, avis d'expert. Deux sources primaires n'ont pas pu être lues directement : EUR-Lex (page vide) et les serveurs de TU Delft (503 ou connexion coupée). Ces cas sont signalés dans les entrées concernées et dans « Non vérifié ».

---

## 1. Une sauvegarde ne vaut que par sa restauration

### Tester les sauvegardes en restaurant réellement, pas seulement en constatant qu'elles existent
- Niveau de preuve : N1
- Source : Swanson, Bowen, Phillips, Gallup, Lynes (NIST), 2010, « Contingency Planning Guide for Federal Information Systems », SP 800-34 Rev. 1, https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-34r1.pdf
- Extrait lu : « Backup tapes should be tested regularly to ensure that data are being stored correctly and that the files may be retrieved without errors or lost data. » ; tableau des tests, contrôle CP-9 : « Test backup information to verify media reliability and information integrity. » ; pour les systèmes à impact modéré : « Exercise procedures should be developed to include an element of system recovery from backup media. »
- Portée / limites : norme fédérale américaine de mai 2010, pensée pour des bandes et des sites de secours. Pour un système à impact faible, le test de CP-9 est marqué « N/A ». Le texte ne donne aucune fréquence chiffrée (« organization-defined frequency »).
- En release : quand a-t-on restauré pour la dernière fois une sauvegarde de cette base, et cette restauration a-t-elle été lue (comptages, ouverture applicative) ou seulement lancée ?

### Garder au moins une sauvegarde hors ligne et chiffrée, et tester régulièrement sa disponibilité et son intégrité
- Niveau de preuve : N3
- Source : CISA et partenaires, septembre 2023, « #StopRansomware Guide », https://www.cisa.gov/stopransomware/ransomware-guide
- Extrait lu : « Maintain offline, encrypted backups of critical data » ; « regularly test the availability and integrity of backups in a disaster recovery scenario » ; « Test backup procedures on a regular basis. »
- Portée / limites : le guide vise le rançongiciel, pas les migrations. Aucune fréquence n'y figure. La règle 3-2-1 n'apparaît pas dans l'extrait lu, et le PDF CISA « data_backup_options » n'a pas pu être ouvert (le lien renvoie une page HTML).
- En release : la sauvegarde d'avant migration se trouve-t-elle hors de portée de la même clé ou du même compte qui exécute la migration ?

### Appliquer la règle 3-2-1 et ne jamais avoir toutes les sauvegardes connectées en même temps
- Niveau de preuve : N3 (billet de blog d'une institution, pas un guide normatif)
- Source : James L (NCSC), 13.08.2019, « Offline backups in an online world », https://www.ncsc.gov.uk/blog-post/offline-backups-in-an-online-world
- Extrait lu : « The most common method for creating resilient data backups is to follow the ’3-2-1’ rule; at least 3 copies, on 2 devices, and 1 offsite. » ; « With at least one backup offline at any given time, an incident cannot affect all of your backups simultaneously. » ; « they should also be regularly tested to check they work as expected. »
- Portée / limites : billet de 2019. La page actuelle du guide NCSC pour petites organisations, publiée le 09.04.2026, ne contenait pas ces consignes dans sa première page, et l'ancienne page « step-1-make-regular-backups » renvoie 404.
- En release : pour un développeur indépendant, le « 1 offsite » est-il vraiment hors du même fournisseur et du même compte que la production ?

### Une sauvegarde automatisée peut échouer en silence : surveiller son résultat et la restaurer
- Niveau de preuve : N3
- Source : GitLab, 2017 (incident du 31.01.2017), « Postmortem of database outage of January 31 », https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/
- Extrait lu : « Unfortunately the process of both finding and using backups failed completely. » ; « the backup procedure was using pg_dump 9.2, while our database is running PostgreSQL 9.6 » ; « This means we were never aware of the backups failing, until it was too late. » ; « Why was the backup procedure not tested on a regular basis? - Because there was no ownership, as a result nobody was responsible for testing this procedure. » Bilan : « roughly 5,000 projects, 5,000 comments and 700 new user accounts ».
- Portée / limites : le post-mortem officiel énumère **quatre** procédures (pg_dump quotidien vers S3, snapshot LVM quotidien, snapshots de disque Azure non activés pour les bases, réplication). Le chiffre « cinq » ne figure pas dans ce texte. Les notifications d'échec du cron partaient par courriel et étaient rejetées faute de DMARC. Parmi les actions correctives figure « Automated testing of recovering PostgreSQL database backups (#1102) ».
- En release : où est la preuve, datée, que la dernière sauvegarde a réussi ? La version de l'outil de dump correspond-elle à la version du serveur ?

### La réplication n'est pas une sauvegarde : elle propage l'erreur
- Niveau de preuve : N3 (GitLab) et N4 (livre Google SRE)
- Source : GitLab, 2017, post-mortem cité ci-dessus ; Blum, Singh (Google), « Site Reliability Engineering », chapitre « Data Integrity: What You Read Is What You Wrote », https://sre.google/sre-book/data-integrity/
- Extrait lu : GitLab : « Replication between PostgreSQL hosts, primarily used for failover purposes and not for disaster recovery. » ; SRE : la réplication « can't protect you from many sources of data loss. »
- Portée / limites : le chapitre SRE décrit Google à grande échelle. Ici, seule la phrase citée est reprise mot pour mot ; le reste du chapitre est résumé.
- En release : si la migration supprime ou corrompt des lignes, quelle copie n'en sera pas affectée ?

### Ce qu'on veut, ce sont des restaurations ; tester la récupération en continu
- Niveau de preuve : N4
- Source : Blum, Singh (Google), « Site Reliability Engineering », chapitre « Data Integrity », https://sre.google/sre-book/data-integrity/
- Extrait lu : « No one really wants to make backups; what people really want are restores. » ; « Continuously test the recovery process as part of your normal operations. » ; « you only know that you can recover your recent state if you actually do so. »
- Portée / limites : c'est la formulation primaire la plus proche du slogan « une sauvegarde non testée n'est pas une sauvegarde », dont l'auteur n'a pas été trouvé (voir « Mythes »).
- En release : combien de temps une restauration réelle a-t-elle pris la dernière fois, et ce délai est-il compatible avec la fenêtre d'indisponibilité acceptable ?

### Une sauvegarde intacte ne suffit pas : la procédure de restauration ciblée doit avoir été répétée
- Niveau de preuve : N3
- Source : Atlassian, 29.04.2022, « Post-Incident Review on the Atlassian April 2022 outage », https://www.atlassian.com/engineering/post-incident-review-april-2022-outage
- Extrait lu : « The result was an immediate deletion of 883 sites (representing 775 customers) » ; « With the Restoration 1 approach, it would have taken us three weeks to restore all customers. » ; « a deletion of this type should be prohibited or have multiple layers of protections to avoid errors, including staged rollout and tested rollback plan for “soft deletes” ».
- Portée / limites : un script de suppression a reçu des identifiants de site au lieu d'identifiants d'application. Le RPO a été tenu (restauration à cinq minutes avant la suppression), pas le RTO : jusqu'à 14 jours d'indisponibilité pour certains clients, parce que la restauration d'un sous-ensemble n'était pas automatisée. Le contexte multi-tenant est très éloigné d'un projet indépendant.
- En release : sait-on restaurer **une seule table ou une partie des lignes** sans écraser les écritures légitimes faites après la migration ?

### Pouvoir rétablir les données et tester régulièrement les mesures est une obligation légale, pas seulement une bonne pratique
- Niveau de preuve : N1
- Source : Règlement (UE) 2016/679 (RGPD), art. 32 § 1, reproduit par la CNIL, https://www.cnil.fr/fr/reglement-europeen-protection-donnees/chapitre4
- Extrait lu : point c) « des moyens permettant de rétablir la disponibilité des données à caractère personnel … dans des délais appropriés en cas d'incident physique ou technique » ; point d) « une procédure visant à tester, à analyser et à évaluer régulièrement l'efficacité des mesures … »
- Portée / limites : texte lu sur le site de la CNIL, EUR-Lex n'ayant rendu qu'une page vide. Ces mesures sont exigées « selon le cas » et en fonction du risque. Le texte ne prescrit aucune technique de sauvegarde.
- En release : pour une application qui traite des données personnelles, la capacité de restauration testée fait partie de la sécurité du traitement que le responsable doit pouvoir démontrer.

---

## 2. PostgreSQL : ce qui est transactionnel, ce qui verrouille, ce que valent pg_dump et la PITR

### Le DDL de PostgreSQL est transactionnel, avec des exceptions qui interdisent de raisonner « tout ou rien »
- Niveau de preuve : N4 (wiki) et N3 (docs PostgreSQL 18)
- Source : wiki PostgreSQL (dernière modification 11.06.2012), « Transactional DDL in PostgreSQL: A Competitive Analysis », https://wiki.postgresql.org/wiki/Transactional_DDL_in_PostgreSQL:_A_Competitive_Analysis ; PostgreSQL 18, « CREATE INDEX », https://www.postgresql.org/docs/current/sql-createindex.html ; PostgreSQL 18, « ALTER TYPE », https://www.postgresql.org/docs/current/sql-altertype.html
- Extrait lu : wiki : « You can't recover from an add/drop on a database or tablespace, but all other catalog operations are reversible. » ; CREATE INDEX : « a regular CREATE INDEX command can be performed within a transaction block, but CREATE INDEX CONCURRENTLY cannot. » ; ALTER TYPE : « If ALTER TYPE ... ADD VALUE … is executed inside a transaction block, the new value cannot be used until after the transaction has been committed. »
- Portée / limites : le wiki date de 2012. Dans PostgreSQL 18, `ADD VALUE` s'exécute bien dans une transaction, mais la nouvelle valeur ne peut pas y être utilisée. La liste complète des commandes interdites en bloc transactionnel ne figure pas sur la page `BEGIN`.
- En release : la migration contient-elle un `CONCURRENTLY` ou un `ADD VALUE` suivi d'un usage de la valeur ? Si oui, elle ne sera pas atomique, ou échouera si l'outil l'enveloppe dans une transaction.

### Un `CREATE INDEX CONCURRENTLY` qui échoue laisse un index INVALID à supprimer
- Niveau de preuve : N3
- Source : PostgreSQL Global Development Group, PostgreSQL 18.6, « CREATE INDEX », https://www.postgresql.org/docs/current/sql-createindex.html
- Extrait lu : « the CREATE INDEX command will fail but leave behind an "invalid" index. This index will be ignored for querying purposes because it might be incomplete; however it will still consume update overhead. » ; « The recommended recovery method in such cases is to drop the index and try again » ; sans CONCURRENTLY : « a standard index build locks out writes (but not reads) on the table until it's done. »
- Portée / limites : pour un index unique, la page précise que l'index invalide « continues to enforce its uniqueness constraint afterwards ».
- En release : après la migration, `\d table` affiche-t-il un index `INVALID` ? Un index unique invalide bloque-t-il des écritures ?

### Par défaut, `ALTER TABLE` prend ACCESS EXCLUSIVE, qui bloque même les SELECT jusqu'à la fin de la transaction
- Niveau de preuve : N3
- Source : PostgreSQL 18.6, « Explicit Locking », https://www.postgresql.org/docs/current/explicit-locking.html ; PostgreSQL 18.6, « ALTER TABLE », https://www.postgresql.org/docs/current/sql-altertable.html
- Extrait lu : « An ACCESS EXCLUSIVE lock is acquired unless explicitly noted. When multiple subcommands are given, the lock acquired will be the strictest one required by any subcommand. » ; « Only an ACCESS EXCLUSIVE lock blocks a SELECT (without FOR UPDATE/SHARE) statement. » ; « Once acquired, a lock is normally held until the end of the transaction. »
- Portée / limites : la page « Explicit Locking » ne parle pas de file d'attente des verrous. Le réglage de `lock_timeout` est traité ailleurs.
- En release : la migration regroupe-t-elle dans une seule transaction un `ALTER TABLE` et un traitement long ? Le verrou le plus fort est alors tenu pendant toute la durée.

### Certaines modifications réécrivent ou parcourent toute la table : à repérer avant de lancer
- Niveau de preuve : N3
- Source : PostgreSQL 18.6, « ALTER TABLE », https://www.postgresql.org/docs/current/sql-altertable.html
- Extrait lu : « Adding a column with a volatile DEFAULT (e.g., clock_timestamp()), a stored generated column, an identity column, or a column with a domain data type that has constraints will cause the entire table and its indexes to be rewritten. » ; pour `SET NOT NULL` : « Ordinarily this is checked during the ALTER TABLE by scanning the entire table, unless NOT VALID is specified; however, if a valid CHECK constraint exists … then the table scan is skipped. »
- Portée / limites : PostgreSQL 18. Le `NOT VALID` sur une contrainte NOT NULL est mentionné par la doc 18. Pour les versions antérieures, ce point n'a pas été vérifié.
- En release : la migration réécrit-elle la table sous ACCESS EXCLUSIVE ? Sur un petit projet c'est souvent sans conséquence, mais il faut le savoir avant.

### `pg_dump` produit un export cohérent sans bloquer, mais n'est pas une stratégie de sauvegarde de production à lui seul
- Niveau de preuve : N3
- Source : PostgreSQL 18.6, « pg_dump », https://www.postgresql.org/docs/current/app-pgdump.html
- Extrait lu : « It makes consistent exports even if the database is being used concurrently. pg_dump does not block other users accessing the database (readers or writers). Note, however, that except in simple cases, pg_dump is generally not the right choice for taking regular backups of production databases. » ; « pg_dump cannot dump from PostgreSQL servers newer than its own major version; it will refuse to even try »
- Source (restauration) : PostgreSQL 18.6, « 25.1. SQL Dump », https://www.postgresql.org/docs/current/backup-dump.html
- Extrait lu (restauration) : « By default, the psql script will continue to execute after an SQL error is encountered. » ; « you can specify that the whole dump should be restored as a single transaction, so the restore is either fully completed or fully rolled back. This mode can be specified by passing the -1 or --single-transaction command-line options to psql. »
- Portée / limites : `pg_dump` exporte une seule base, sans les rôles ni les tablespaces (il faut `pg_dumpall`). La base cible d'une restauration doit être créée à la main depuis `template0`. La page ne détaille pas ici les « simple cases » ; elle renvoie au chapitre 25. Pour un petit projet, un dump juste avant la migration reste une copie ponctuelle légitime.
- En release : le dump d'avant migration a-t-il été produit par un `pg_dump` de version majeure supérieure ou égale à celle du serveur ? Contient-il ce dont la restauration aura besoin (rôles, extensions) ? Le plan de rollback restaure-t-il avec `ON_ERROR_STOP=on` ou `--single-transaction` ? Sans cela, une restauration à moitié réussie peut passer pour un succès.

### La PITR exige une base backup plus une suite continue de WAL, et une archive qu'on a testée
- Niveau de preuve : N3
- Source : PostgreSQL 18.6, « Continuous Archiving and Point-in-Time Recovery (PITR) », https://www.postgresql.org/docs/current/continuous-archiving.html
- Extrait lu : « it is possible to restore the database to its state at any time since your base backup was taken. » ; « you need a continuous sequence of archived WAL files that extends back at least as far as the start time of your backup. » ; « you should set up and test your procedure for archiving WAL files before you take your first base backup. » ; « Inspect the contents of the database to ensure you have recovered to the desired state. »
- Portée / limites : concerne un PostgreSQL autogéré. Sur une plateforme managée, la PITR est un service du fournisseur, traité ailleurs.
- En release : la cible de récupération est-elle notée, à l'horodatage exact du lancement de la migration, pour viser l'instant juste avant ?

### Copier le répertoire de données d'un serveur en marche ne donne pas une sauvegarde valable
- Niveau de preuve : N3
- Source : PostgreSQL 18, « File System Level Backup », https://www.postgresql.org/docs/current/backup-file.html
- Extrait lu : « The database server must be shut down in order to get a usable backup. Half-way measures such as disallowing all connections will not work » ; seule exception, un « frozen snapshot » du volume entier, et la page met en garde : « Read your file system documentation very carefully before trusting th[at] »
- Portée / limites : même principe que pour SQLite (thème 6). Ne concerne pas les services managés.
- En release : la « sauvegarde » proposée est-elle une copie de fichiers à chaud ? Si oui, elle ne compte pas.

---

## 3. Outils de migration : ce qu'ils garantissent et ce qu'ils ne garantissent pas

### Prisma : `migrate dev` n'est jamais pour la production ; `migrate deploy` s'exécute depuis la CI
- Niveau de preuve : N3
- Source : Prisma, doc ORM v7, « Development and production », https://www.prisma.io/docs/orm/v7/prisma-migrate/workflows/development-and-production ; « Deploying database changes with Prisma Migrate », https://www.prisma.io/docs/orm/prisma-client/deployment/deploy-database-changes-with-prisma-migrate
- Extrait lu : « migrate dev is a development command and should never be used in a production environment. » ; « Ideally, migrate deploy should be part of an automated CI/CD pipeline » ; « we do not generally recommend running this command locally to deploy changes to a production database »
- Portée / limites : Prisma ORM v7. La page non versionnée « Applying a migration » décrit déjà une commande `prisma db migrate` qui « replaces Prisma ORM 7's prisma migrate deploy » ; le numéro de la version majeure concernée n'est pas affiché. `db push` est « best suited for prototyping in a development environment » et « does not interact with or rely on migrations ». C'est une recommandation d'usage, pas une interdiction formelle.
- En release : quelle commande exacte touchera la production, et depuis où (CI ou poste) ? Quelle version de Prisma est figée dans le lockfile ?

### Prisma : `migrate deploy` ne détecte pas la dérive ; il faut un contrôle explicite
- Niveau de preuve : N3
- Source : Prisma ORM v7, « Development and production », https://www.prisma.io/docs/orm/v7/prisma-migrate/workflows/development-and-production ; référence CLI v7, https://www.prisma.io/docs/orm/reference/prisma-cli-reference ; « About the shadow database », https://www.prisma.io/docs/orm/v7/prisma-migrate/understanding-prisma-migrate/shadow-database
- Extrait lu : `migrate deploy` « Does not detect drift » et « Does not rely on a shadow database » ; « The shadow database is not required in production » ; `migrate diff --exit-code` : « Change the exit code behavior to signal if the diff is empty or not (Empty: 0, Error: 1, Not empty: 2). »
- Portée / limites : en v7, `--from-url` et `--to-url` ont été retirés ; la source se désigne avec `--from-config-datasource`. La détection de dérive de `migrate dev` porte sur la base de développement.
- En release : après le déploiement, a-t-on comparé le schéma réel de la production au schéma attendu (`migrate diff --exit-code`) ? Un historique à jour ne prouve pas un schéma conforme.

### Prisma : une migration en échec bloque les suivantes ; `migrate resolve` n'exécute aucun SQL
- Niveau de preuve : N3
- Source : Prisma ORM v7, « Patching & hotfixing », https://www.prisma.io/docs/orm/v7/prisma-migrate/workflows/patching-and-hotfixing
- Extrait lu : « Until you recover from the failed state, further migrations using prisma migrate deploy are impossible. » ; `--applied` : « This command adds the migration to the migration history table without running the actual SQL. » ; pour une migration partiellement exécutée : « Manually revert the steps that were completed (for example, delete created tables). »
- Portée / limites : que la doc envisage des migrations à moitié appliquées montre qu'on ne peut pas compter sur l'atomicité. La page ne dit pas si Prisma enveloppe les migrations dans une transaction (voir « Non vérifié »).
- En release : si la migration échoue au milieu, sait-on quelles instructions sont déjà passées ? Le geste prévu est-il `--rolled-back` (avec retour manuel) ou `--applied` (après avoir fini à la main) ?

### Prisma : pas de « down » automatique ; un down écrit à la main ne restaure que le schéma, pas les données
- Niveau de preuve : N3
- Source : Prisma, « Generating down migrations », https://www.prisma.io/docs/orm/prisma-migrate/workflows/generating-down-migrations
- Extrait lu : on crée le down avec `migrate diff`, et il faut « create the down migration first, before creating the corresponding up migration » ; il « will revert your database schema, but other changes to data » ne sont pas annulés ; `migrate resolve` « can only be used on failed migrations ».
- Portée / limites : page non versionnée. Pour revenir sur une migration **réussie**, la doc propose une nouvelle migration en avant, pas un down.
- En release : le plan de rollback se résume-t-il à « on lancera le down » ? Si la migration supprime ou transforme des données, seul un retour depuis la sauvegarde les ramène.

### Supabase CLI : `db push --dry-run` montre ce qui sera appliqué ; l'historique vit dans `supabase_migrations.schema_migrations`
- Niveau de preuve : N3
- Source : Supabase, référence CLI, « supabase db push », https://supabase.com/docs/reference/cli/supabase-db-push
- Extrait lu : `--dry-run` : « Print the migrations that would be applied, but don't actually apply them. » ; « a migration history table will be created under supabase_migrations.schema_migrations » ; « Subsequent pushes will skip migrations that have already been applied. »
- Portée / limites : le dry-run **liste** les migrations, il ne les exécute pas sur une copie et ne dit donc rien des données. Avant de toucher une base hébergée, la commande demande confirmation (non par défaut). Aucune version de CLI n'est affichée.
- En release : le dry-run a-t-il listé exactement les fichiers attendus, ni plus ni moins (attention à `--include-all`) ?

### Supabase : `migration list` compare des horodatages, pas des schémas ; la dérive de schéma se mesure avec `db diff`
- Niveau de preuve : N3
- Source : Supabase, référence CLI, « supabase migration list » et « migration repair », https://supabase.com/docs/reference/cli/supabase-migration-list ; « supabase db diff », https://supabase.com/docs/reference/cli/supabase-db-diff ; guide MCP, https://supabase.com/docs/guides/getting-started/mcp
- Extrait lu : « Only the timestamps are compared to identify any differences. » ; `migration repair` : « Repairs the migration history table. » ; `db diff` : « Compares schema differences between the target database and a shadow database » ; « Storage buckets are data, not schema, so no diff engine captures them. » ; outil MCP `list_migrations` : « List database migrations ».
- Portée / limites : `list_migrations` (MCP) se contente de lister l'historique enregistré en base. La doc lue ne lui attribue aucune comparaison avec le dépôt ni avec le schéma réel. Une modification faite dans le tableau de bord n'apparaît donc pas dans cet historique.
- En release : « zéro dérive » doit être prouvé à deux niveaux : historique (dépôt et base ont les mêmes horodatages) et schéma (`db diff --remote` vide).

### Drizzle Kit : `push` sert au prototypage rapide, `--explain` fait un essai à blanc, aucun down n'est documenté
- Niveau de preuve : N3
- Source : Drizzle, « drizzle-kit push », https://orm.drizzle.team/docs/drizzle-kit-push ; « drizzle-kit migrate », https://orm.drizzle.team/docs/drizzle-kit-migrate ; « Drizzle Kit overview », https://orm.drizzle.team/docs/kit-overview
- Extrait lu : push est « the best approach for rapid prototyping » ; `--explain` : « print the planned SQL changes, without applying them (dry run) » ; `force` : « auto-accept all data-loss statements » ; migrate : « It will store them in migrations log table named __drizzle_migrations in drizzle schema. »
- Portée / limites : la même page indique que des équipes utilisent push « as a primary migrations flow in their production applications ». Ni rollback ni down ne sont mentionnés, et rien n'est dit sur les transactions. Aucune version de drizzle-kit n'est affichée (badge « v1.0 »).
- En release : le déploiement utilise-t-il `push --force` ? Si oui, plus aucune garde ne s'interpose face aux pertes de données.

---

## 4. Ce que disent les études empiriques

### Les schémas changent souvent, et chaque changement entraîne des modifications de code à retrouver
- Niveau de preuve : N2 (10 applications open source, plus de 160 000 révisions)
- Source : Dong Qiu, Bixin Li, Zhendong Su, 2013, « An Empirical Analysis of the Co-evolution of Schema and Code in Database Applications », ESEC/FSE 2013, https://www.cs.ucdavis.edu/~su/publications/fse13-db-study.pdf
- Extrait lu : « Database schemas evolve frequently during the application lifecycle » ; « schema changes induce significant code-level modifications, while certain change types have more impact on code than others » ; « 80% of the schema changes happened in 20-30% of the tables, while nearly 40% of the tables did not change » ; « Referential integrity constraints and stored procedures are rarely used in our studied subjects. »
- Portée / limites : applications PHP et MySQL (Joomla!, MediaWiki, etc.) suivies sous SVN, avant l'ère des ORM à migrations versionnées. L'étude ne mesure ni les incidents ni les pertes de données.
- En release : la migration touche-t-elle une table « chaude » ? Toutes les requêtes du code qui la lisent ont-elles été retrouvées et adaptées ?

### Les évolutions de schéma SQL peuvent provoquer une indisponibilité en déploiement continu
- Niveau de preuve : N2 (résumé seul lu)
- Source : Michael de Jong, Arie van Deursen, 2015, « Continuous deployment and schema evolution in SQL databases », RELENG 2015, pp. 16-19, https://research.tudelft.nl/en/publications/continuous-deployment-and-schema-evolution-in-sql-databases/ ; Michael de Jong, Arie van Deursen, Anthony Cleve, 2017, « Zero-Downtime SQL Database Schema Evolution for Continuous Deployment », ICSE 2017 SEIP (métadonnées lues sur https://researchportal.unamur.be/en/publications/zero-downtime-sql-database-schema-evolution-for-continuous-deploy)
- Extrait lu : 2015 : « SQL schema evolutions in particular can make it expensive to deploy a new version, and may even lead to downtime » ; « Initial evaluation suggests the approach is effective and sufficiently efficient. »
- Portée / limites : le texte intégral de 2017 (PDF de TU Delft) n'a pas pu être lu (503 et connexions coupées). Ses chiffres sur le caractère bloquant des opérateurs PostgreSQL et MySQL ne sont donc **pas** repris ici. Le millésime « 2015 » de la demande correspond au papier RELENG et au mémoire de master ; le papier ICSE-SEIP date de 2017.
- En release : l'opération est-elle bloquante sur ce SGBD et dans cette version ? À vérifier dans la doc du moteur (thème 2), pas dans un souvenir.

---

## 5. Essai à blanc et vérification après migration

### Durcir une contrainte en deux temps : `NOT VALID`, puis `VALIDATE CONSTRAINT` sous un verrou plus faible
- Niveau de preuve : N3
- Source : PostgreSQL 18.6, « ALTER TABLE », https://www.postgresql.org/docs/current/sql-altertable.html
- Extrait lu : « Normally, this form will cause a scan of the table to verify that all existing rows in the table satisfy the new constraint. But if the NOT VALID option is used, this potentially-lengthy scan is skipped. The constraint will still be applied against subsequent inserts or updates » ; VALIDATE : « This command acquires a SHARE UPDATE EXCLUSIVE lock. »
- Portée / limites : en PostgreSQL 18, `NOT VALID` est permis pour les clés étrangères, les CHECK et les contraintes NOT NULL. `VALIDATE` échouera si des lignes anciennes violent la contrainte. C'est précisément le contrôle de réalité sur les données legacy.
- En release : avant de valider, a-t-on compté par une requête les lignes qui violeraient la contrainte ? Un `VALIDATE` en échec, c'est une migration rejouée.

### Une branche Supabase ne contient pas les données de production par défaut
- Niveau de preuve : N3
- Source : Supabase, « Branching », https://supabase.com/docs/guides/deployment/branching
- Extrait lu : « The database schema isn't cloned. » ; « By default, new branches do not start with any data or storage objects from your base project. » ; « This is meant to better protect your sensitive production data. »
- Portée / limites : il existe une option « Include data » dans le tableau de bord, mais la page ne dit pas ce qu'elle copie. Les données arrivent sinon par un fichier de seed.
- En release : un essai à blanc sur une branche vide valide le **SQL**, pas les **données**. Le contrôle des données legacy exige un dump local ou une copie, minimisés (thème 7).

### Une branche Neon est un clone copy-on-write des données ; la variante schema-only sert aux données confidentielles
- Niveau de preuve : N3
- Source : Neon, « Branching », https://neon.com/docs/introduction/branching ; « Schema-only branches », https://neon.com/docs/guides/branching-schema-only
- Extrait lu : une branche est « a copy-on-write clone of your data » ; on peut « create branches for testing schema changes » ; schema-only : « This feature is ideal for working with confidential information. »
- Portée / limites : la fonction schema-only est en bêta, avec des limites de stockage par plan. Neon est cité comme exemple d'outil, pas comme recommandation.
- En release : avec une copie qui contient les données réelles, on teste la migration en conditions réelles, mais on duplique des données personnelles.

### Tester les migrations dans un environnement proche de la production, en mesurant durées et requêtes
- Niveau de preuve : N3
- Source : GitLab, doc développeur, « Database migration pipeline », https://docs.gitlab.com/development/database/database_migration_pipeline/
- Extrait lu : le pipeline permet d'« automatically test migrations in a production-like environment » (Database Lab, « Postgres.ai thin clone ») ; il signale les « exceptions or long-running queries » et liste pour chaque migration « Every query executed during the migration, along with the number of calls, timings ».
- Portée / limites : outillage d'une grande équipe. Pour un indépendant, l'équivalent minimal est un dump restauré en local et un chronométrage. Page sans date.
- En release : combien de temps la migration a-t-elle pris sur la copie, et quelle instruction a été la plus lente ?

---

## 6. Stores de fichiers (JSON, SQLite)

### Écrire dans un fichier temporaire puis renommer sur le même système de fichiers, et synchroniser le répertoire
- Niveau de preuve : N3
- Source : Linux man-pages 6.19, « rename(2) », https://man7.org/linux/man-pages/man2/rename.2.html ; « fsync(2) », https://man7.org/linux/man-pages/man2/fsync.2.html
- Extrait lu : « If newpath already exists, it will be atomically replaced, so that there is no point at which another process attempting to access newpath will find it missing » ; EXDEV : « oldpath and newpath are not on the same mounted filesystem. » ; fsync : « Calling fsync() does not necessarily ensure that the entry in the directory containing the file has also reached disk. For that an explicit fsync() on a file descriptor for the directory is also needed. »
- Portée / limites : il s'agit des pages Linux, pas du texte POSIX lui-même. L'atomicité porte sur la visibilité du nom, pas sur la durabilité après une coupure de courant.
- En release : le script de transformation du store écrit-il en place ? Le fichier temporaire est-il sur le même volume ? Y a-t-il un fsync du fichier puis du répertoire ?

### Sous Windows, `ReplaceFile` et `MoveFileEx` remplacent un fichier, avec des modes d'échec intermédiaires documentés
- Niveau de preuve : N3
- Source : Microsoft Learn, « ReplaceFileW function », https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-replacefilew ; « MoveFileExW function », https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-movefileexw
- Extrait lu : ReplaceFile : « The backup file, replaced file, and replacement file must all reside on the same volume. » ; `ERROR_UNABLE_TO_MOVE_REPLACEMENT` : « Otherwise, the replaced file no longer exists and the replacement file exists under its original name. » ; `REPLACEFILE_WRITE_THROUGH` : « This value is not supported. » ; MoveFileEx : `MOVEFILE_WRITE_THROUGH` « does not return until the file is actually moved on the disk ».
- Portée / limites : aucune des deux pages n'emploie le mot « atomique ». Elles décrivent au contraire des états intermédiaires possibles en cas d'échec. Avec `MOVEFILE_COPY_ALLOWED`, un déplacement entre volumes est simulé par copie puis suppression.
- En release : sur un poste Windows, le code gère-t-il l'erreur 1176 (le fichier d'origine a disparu, le nouveau a gardé son nom temporaire) ?

### SQLite : ne jamais copier le fichier pendant une transaction ; utiliser `VACUUM INTO`, l'API de backup ou `sqlite3_rsync`
- Niveau de preuve : N3
- Source : SQLite, « How To Corrupt An SQLite Database File », https://www.sqlite.org/howtocorrupt.html ; « VACUUM », https://www.sqlite.org/lang_vacuum.html ; « Using the SQLite Online Backup API », https://www.sqlite.org/backup.html
- Extrait lu : « The backup copy then might contain some old and some new content, and thus be corrupt. » ; « Any of the above approaches will work even on a live database. » ; VACUUM INTO : « The VACUUM INTO command is transactional in the sense that the generated output database is a consistent snapshot of the original database. However, if the VACUUM INTO command is interrupted by an unplanned shutdown or power loss, then the generated output database might be incomplete and corrupt. » ; « The file named by the INTO clause must not previously exist, or else it must be an empty file »
- Portée / limites : `sqlite3_rsync` existe à partir de SQLite 3.47.0 (2024-10-21). La page VACUUM n'indique pas la version d'introduction de `VACUUM INTO`. L'API de backup peut redémarrer indéfiniment si la base est écrite trop souvent.
- En release : la sauvegarde du store a-t-elle été faite par `VACUUM INTO` ou `.backup`, puis rouverte et contrôlée ? Une copie de fichier faite pendant que l'application écrit ne compte pas.

### SQLite en mode WAL : le fichier `-wal` fait partie de la base, le séparer peut perdre des transactions validées
- Niveau de preuve : N3
- Source : SQLite, « Write-Ahead Logging », https://www.sqlite.org/wal.html ; « How To Corrupt An SQLite Database File », https://www.sqlite.org/howtocorrupt.html
- Extrait lu : « The WAL file is part of the persistent state of the database and should be kept with the database if the database is copied or moved. If a database file is separated from its WAL file, then transactions that were previously committed to the database might be lost, or the database file might become corrupted. » ; « WAL does not work over a network filesystem. »
- Portée / limites : la page WAL ne donne pas de procédure de sauvegarde ; celle-ci figure sur les autres pages citées. Renommer ou supprimer un fichier de base ouvert donne un comportement « undefined and probably undesirable ».
- En release : le store est-il sur un partage réseau ? Le script de migration remplace-t-il le `.db` alors que des connexions sont ouvertes ?

### Vérifier un store SQLite après transformation : `integrity_check` plus `foreign_key_check` (les clés étrangères sont désactivées par défaut)
- Niveau de preuve : N3
- Source : SQLite, « Pragma statements », https://www.sqlite.org/pragma.html ; « ALTER TABLE », https://www.sqlite.org/lang_altertable.html
- Extrait lu : « If pragma integrity_check finds no errors, a single row with the value 'ok' is returned. » ; « PRAGMA integrity_check does not find FOREIGN KEY errors. Use the PRAGMA foreign_key_check command » ; « the default setting for foreign key enforcement is OFF » ; procédure en 12 étapes, étape 10 : « run PRAGMA foreign_key_check to verify that the schema change did not break any foreign key constraints. »
- Portée / limites : l'`ALTER TABLE` de SQLite est limité (renommer une table ou une colonne, ajouter ou supprimer une colonne). Pour toute autre modification, il faut suivre la procédure « create new / copy / drop / rename » dans cet ordre précis. La doc met en garde contre l'ordre inverse, qui « might corrupt references ».
- En release : la vérification d'après migration exécute-t-elle les deux pragmas et compare-t-elle les comptages de lignes avant et après ? Pour un store JSON, aucune source primaire équivalente n'a été cherchée : la vérification de conformité par schéma relève de la convention.

---

## 7. Données personnelles et copies de production

### Une copie de production pour l'essai à blanc reste un traitement soumis à la nLPD : proportionnalité, finalité, destruction
- Niveau de preuve : N1
- Source : Confédération suisse, Loi fédérale sur la protection des données (LPD), RS 235.1, du 25.09.2020 (état au 1er septembre 2023 pour le fichier lu), https://www.fedlex.admin.ch/filestore/fedlex.data.admin.ch/eli/cc/2022/491/20230901/fr/html/fedlex-data-admin-ch-eli-cc-2022-491-20230901-fr-html-1.html
- Extrait lu : art. 6 al. 2 : « Il doit être conforme aux principes de la bonne foi et de la proportionnalité. » ; al. 4 : « Elles sont détruites ou anonymisées dès qu'elles ne sont plus nécessaires au regard des finalités du traitement. » ; art. 8 al. 1 : « une sécurité adéquate des données personnelles par rapport au risque encouru. »
- Portée / limites : la version consolidée lue est celle du 01.09.2023 ; une version plus récente n'a pas été vérifiée. La loi ne mentionne ni les essais de migration ni les sauvegardes. L'application au dump d'essai est une déduction. La page de l'EDÖB sur les principes renvoyait 404.
- En release : le dump d'essai est-il réduit au nécessaire (tables concernées, colonnes pseudonymisées), stocké de façon sûre, et détruit une fois l'essai terminé ?

### Côté RGPD : finalité, minimisation et limitation de la conservation s'appliquent aussi aux copies
- Niveau de preuve : N1
- Source : Règlement (UE) 2016/679, art. 5 § 1, reproduit par la CNIL, https://www.cnil.fr/fr/reglement-europeen-protection-donnees/chapitre2
- Extrait lu : b) « collectées pour des finalités déterminées, explicites et légitimes » ; c) « adéquates, pertinentes et limitées à ce qui est nécessaire au regard des finalités pour lesquelles elles sont traitées » ; e) conservées « pendant une durée n'excédant pas celle nécessaire »
- Portée / limites : texte lu sur le site de la CNIL (EUR-Lex vide). La question de savoir si un test technique est un traitement ultérieur compatible n'est pas tranchée par ce texte.
- En release : faut-il vraiment des données nominatives pour vérifier la migration ? Souvent, une branche schema-only avec des lignes synthétiques, ou des colonnes pseudonymisées, suffit.

---

## Verdict sur les règles de l'agent

| Règle | Verdict | Motif sourcé |
|---|---|---|
| « Jamais de migration prod sans backup confirmé. » | **Soutenue, à préciser** | Le principe est soutenu par NIST SP 800-34 (CP-9, tests de sauvegarde), CISA, NCSC et RGPD art. 32 § 1 c-d. « Confirmé » doit vouloir dire **sauvegarde récente produite avec succès et restaurable** : chez GitLab en 2017, quatre mécanismes étaient « en place » et le pg_dump échouait en silence. Il faut aussi vérifier le **périmètre** : un `pg_dump` ne contient pas les rôles ; les sauvegardes Supabase ne contiennent pas les objets Storage (« Database backups do not include objects you store via the Storage API », https://supabase.com/docs/guides/platform/backups). |
| « Mode C : backup, dry-run sur une branche / un dump local / une copie du store, reality check post-migration, application, vérification immédiate (count des lignes, scan des contraintes nouvelles), plan de rollback documenté avant exécution. » | **Soutenue dans l'ensemble, à préciser sur deux points** | (1) Une branche Supabase ne contient **aucune donnée** par défaut : le dry-run sur branche valide le SQL, pas les données legacy. Il faut un dump ou une copie, minimisés (nLPD art. 6, RGPD art. 5). `db push --dry-run` liste les migrations sans les exécuter. (2) Le plan de rollback ne peut pas reposer sur un « down » : Prisma n'en génère pas, un down écrit à la main ne restaure pas les données et ne s'applique qu'aux migrations en échec. Le vrai rollback des données est la restauration, et elle doit être répétée (Atlassian 2022 : RPO tenu, RTO manqué). Les comptages de lignes avant et après relèvent de la convention, sans source primaire trouvée ; le scan des contraintes est outillé (`VALIDATE CONSTRAINT`, `PRAGMA integrity_check` et `foreign_key_check`). |
| « Toute migration durcissant une validation → reality check sur les données existantes (legacy). » | **Soutenue** | PostgreSQL : ajouter une contrainte parcourt toutes les lignes existantes et échoue si l'une la viole. `NOT VALID` saute ce parcours, mais la contrainte s'applique aux nouvelles écritures, et `VALIDATE` contrôle ensuite le legacy sous SHARE UPDATE EXCLUSIVE. Prisma cite parmi les causes d'échec un `NOT NULL` ajouté à une table peuplée, et un échec bloque les migrations suivantes. À préciser : séparer `ADD … NOT VALID` et `VALIDATE`, et compter les violations par requête **avant** de valider. |
| « Migrations appliquées : `list_migrations` → 0 drift attendu (post-deploy). » | **À préciser (insuffisante telle quelle)** | D'après la doc lue, l'outil MCP `list_migrations` se contente de « List database migrations » : il lit l'historique enregistré, sans comparaison avec le dépôt ni avec le schéma réel. `supabase migration list` compare « Only the timestamps ». Une modification faite hors migration, dans le tableau de bord, n'y apparaît pas. Prisma `migrate deploy` « Does not detect drift ». Il faut un contrôle à deux niveaux : historique identique entre dépôt et base, **et** diff de schéma vide (`supabase db diff --remote`, ou `prisma migrate diff --exit-code`, code 0). |
| « Pour un store non relationnel : backup + dry-run sur copie + vérification de conformité des données. » | **Soutenue, à préciser** | La sauvegarde doit être **cohérente** : pour SQLite, pas de copie de fichier pendant une transaction ; `VACUUM INTO`, l'API de backup ou `sqlite3_rsync` ; en mode WAL, le `-wal` fait partie de la base. L'écriture finale doit être atomique : fichier temporaire sur le même volume, `rename`, puis fsync du répertoire ; sous Windows, gérer les états d'échec intermédiaires de `ReplaceFile`. La vérification passe par `integrity_check` et `foreign_key_check`, les clés étrangères étant désactivées par défaut. Pour un store JSON, aucune source primaire n'a été cherchée : la conformité par schéma reste une convention. |

---

## Mythes et affirmations contestées

- **« GitLab avait cinq mécanismes de sauvegarde, aucun ne fonctionnait. »** Le post-mortem officiel en énumère **quatre** : pg_dump quotidien vers S3, snapshot LVM quotidien, snapshots Azure (non activés pour les bases), réplication. Et l'un d'eux a servi : la restauration a été faite à partir du snapshot LVM pris environ 6 heures avant l'incident, d'où une perte d'environ six heures et non une perte totale. La formulation juste : les procédures de sauvegarde et de restauration de la base n'étaient ni surveillées ni testées. Le chiffre « cinq » vient peut-être du document de suivi tenu en direct pendant l'incident ; non vérifié.
- **« Une sauvegarde non testée n'est pas une sauvegarde. »** Aucune source primaire ni auteur identifié. Les formulations sourcées les plus proches sont celles de Google SRE (« you only know that you can recover your recent state if you actually do so ») et de NIST SP 800-34 (tests réguliers des sauvegardes).
- **« Le DDL PostgreSQL est entièrement transactionnel, donc une migration est tout ou rien. »** Faux pour `CREATE INDEX CONCURRENTLY`, interdit en bloc transactionnel et qui laisse un index INVALID en cas d'échec, et pour `ALTER TYPE … ADD VALUE`, dont la valeur n'est pas utilisable avant le commit. Faux aussi dès que l'outil n'enveloppe pas la migration dans une transaction : Prisma documente des migrations « partly » exécutées.
- **« La réplication, c'est déjà une sauvegarde. »** Contredit par GitLab (réplication « not for disaster recovery ») et par Google SRE (elle propage les suppressions erronées).
- **« Prisma ne permet aucun retour arrière. »** Imprécis. Pas de down **automatique**, mais un down écrit à la main via `migrate diff` est documenté, réservé aux migrations en échec, et il ne restaure pas les données.
- **« `db push` est interdit en production. »** Ni Prisma ni Drizzle ne l'interdisent formellement. Prisma le dit « best suited for prototyping » et sans historique de migrations ; Drizzle le présente comme « the best approach for rapid prototyping », tout en notant que des équipes l'utilisent en production. C'est une règle d'équipe défendable, pas une prescription des éditeurs.
- **« `rename()` est atomique, donc l'écriture est sûre. »** Atomique pour la visibilité du nom, sur un même système de fichiers seulement (EXDEV sinon), et pas durable sans fsync du répertoire. Sous Windows, les docs de `ReplaceFile` et `MoveFileEx` ne promettent pas l'atomicité et décrivent des états intermédiaires en cas d'échec.
- **« Une branche Supabase est une copie de la prod pour tester la migration. »** Faux par défaut : ni données ni objets Storage, et le schéma est reconstruit depuis les migrations.
- **« pg_dump suffit comme sauvegarde de production. »** La doc PostgreSQL 18 dit le contraire hors cas simples (« generally not the right choice for taking regular backups of production databases »). Pour un petit projet, il reste un instantané ponctuel légitime avant migration.
- **« La plupart des projets de migration de données échouent (80 % et plus). »** Chiffre fréquemment cité, sans source primaire trouvée : non vérifié, à ne pas reprendre.

---

## Non vérifié

- **Atomicité des migrations par outil** : la doc Prisma v7 lue ne dit pas si chaque migration PostgreSQL est enveloppée dans une transaction (seule la mention de migrations « partly » exécutées a été trouvée). Pas d'information non plus pour Supabase CLI (`db push`) ni pour Drizzle Kit (`migrate`).
- **de Jong, van Deursen, Cleve 2017 (ICSE-SEIP)** : texte intégral non lu (serveurs TU Delft en 503 ou connexion réinitialisée). Aucun chiffre de ce papier n'est repris. Pour le papier RELENG 2015, seul le résumé a été lu.
- **Études empiriques sur les incidents dus aux migrations** et sur le taux d'échec des « data migrations » : aucune étude revue par les pairs trouvée dans le temps imparti.
- **Règle 3-2-1 dans un texte CISA** : PDF « data_backup_options » inaccessible ; l'énoncé 3-2-1 n'est sourcé ici que par le blog NCSC de 2019.
- **Page actuelle du NCSC sur les sauvegardes hors ligne** : l'ancienne URL renvoie 404 et la page du guide pour petites organisations lue ne contenait pas le détail.
- **RGPD sur EUR-Lex** : page vide ; texte lu via la reproduction de la CNIL. La page de l'EDÖB sur les principes renvoyait 404 ; la nLPD a été lue sur Fedlex, version consolidée du 01.09.2023, sans vérifier qu'une version plus récente existe.
- **Version de Prisma de la page « Applying a migration »** (commande `prisma db migrate`, qui « replaces Prisma ORM 7's prisma migrate deploy ») : numéro de version majeure non affiché.
- **Option « Include data » des branches Supabase** : son périmètre n'est pas décrit sur la page lue.
- **Version d'introduction de `VACUUM INTO`** (souvent citée comme 3.27.0) : absente de la page lue.
- **Origine du chiffre « cinq mécanismes » pour GitLab** : absent du post-mortem officiel ; le document de suivi en direct n'a pas été consulté.

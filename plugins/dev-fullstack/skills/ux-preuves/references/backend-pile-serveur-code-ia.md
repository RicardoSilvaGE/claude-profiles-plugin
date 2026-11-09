# Fiche `ux-preuves` — Backend — pile serveur 2026 et code serveur écrit par un LLM

> Fiche du skill `ux-preuves` (dev-fullstack), volet **backend**, préchargé par `backend`. Couvre : Node.js (calendrier LTS, TypeScript sans vérification de types, modules intégrés, crypto par défaut), Hono et Standard Schema, Prisma 7 et 8, Drizzle, Python, FastAPI, Pydantic, SQLAlchemy, uv, Zod 4 côté serveur, nouvelles clés Supabase, BaxBench et SusVibes (code backend généré), OWASP Top 10:2025.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Versions, statuts de brouillons IETF et API
> **vieillissent en mois** ; le droit change par révision : avant d'écrire du code qui en dépend,
> relire la page officielle (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Recherche documentaire du 09.11.2026 pour le référentiel d'un agent « backend engineer senior ».
Chaque entrée renvoie à une page ouverte ce jour (WebFetch), ou à un fichier source ou PDF téléchargé
avec curl puis lu (pdftotext). Les versions et dates de paquets viennent des registres officiels
(registry.npmjs.org, pypi.org) interrogés le 09.11.2026.

Hors périmètre, parce que déjà couvert ailleurs : Next.js 16, Better Auth / Auth.js, `getClaims()`
de Supabase, Zod 4 côté formulaire, TypeScript 6/7, ESLint 10, Node 20 EOL, paquets hallucinés,
API dépréciées, Pearce, Fu, Tony, Shukla.

Niveaux de preuve : N1 = norme ou standard ; N2 = recherche revue par pairs ou étude empirique à
large échantillon ; N3 = documentation officielle d'un runtime, d'un framework ou d'une plateforme
(les chiffres de performance qu'un projet publie sur lui-même restent N3) ; N4 = avis d'expert ou
article de praticien.

---

## 1. Node.js

### Cibler Node 24 ou 26 (LTS) pour un nouveau serveur ; Node 22 n'a plus que des correctifs et s'arrête le 30.04.2027
- Niveau de preuve : N3
- Source : Node.js Release Working Group, 2026, « nodejs/Release — Release schedule », https://github.com/nodejs/Release
- Extrait lu : tableau « 22.x | Maintenance LTS | Jod | … | 2027-04-30 » ; « 24.x | Maintenance LTS | Krypton | … Maintenance Start 2026-10-20 | 2028-04-30 » ; « 26.x | Active LTS | Lithium | 2026-05-05 | 2026-10-28 | 2027-10-20 | 2029-04-30 ». La page précise : « Dates are subject to change. »
- Portée / limites : au 09.11.2026, Node 26 est la seule LTS active ; 24 et 22 sont en maintenance. À partir de Node 27 (alpha depuis le 28.10.2026), la page annonce un nouveau rythme : une version majeure par an, et toutes les versions deviennent LTS (« every release line is promoted to LTS »), avec 30 mois de LTS et sans phase de maintenance. La règle « seules les versions paires sont LTS » ne vaut donc plus après la 26.
- En code : `engines.node` et l'image Docker visent-ils 24 ou 26 ? Une version 22 doit être justifiée et assortie d'une date de sortie avant le 30.04.2027.

### Exécuter du TypeScript directement avec Node seulement si le code n'utilise que de la syntaxe effaçable, et garder `tsc --noEmit` en CI
- Niveau de preuve : N3
- Source : Node.js, 2026, « Modules: TypeScript » (doc v26.13.0), https://nodejs.org/api/typescript.html
- Extrait lu : « By default Node.js will execute TypeScript files that contains only erasable TypeScript syntax. Node.js will replace TypeScript syntax with whitespace, and no type checking is performed. » ; historique : « v23.6.0, v22.18.0 — Type stripping is enabled by default » ; « v25.2.0, v24.12.0 — Type stripping is now stable » ; « v26.0.0 — Removed `--experimental-transform-types` flag ».
- Portée / limites : `tsconfig.json` est ignoré (« features that depend on settings within `tsconfig.json`, such as paths … are intentionally unsupported ») ; les enums, les namespaces porteurs de code, les parameter properties et les décorateurs ne sont pas pris en charge. Depuis Node 26, il n'y a plus de mode « transform ».
- En code : la PR introduit-elle un `enum`, un `constructor(private x)` ou un alias `paths` dans un serveur lancé par `node file.ts` ? La CI lance-t-elle un vérificateur de types, puisque Node ne vérifie rien ?

### Ne pas présenter `node:sqlite` comme stable : il est en « release candidate » ; s'en servir avec des paramètres liés
- Niveau de preuve : N3
- Source : Node.js, 2026, « SQLite » (doc v26.x), https://nodejs.org/api/sqlite.html
- Extrait lu : « Stability: 1.2 - Release candidate » ; « v25.7.0 — SQLite is now a release candidate » ; « v23.4.0, v22.13.0 — SQLite is no longer behind `--experimental-sqlite` but still experimental » ; « Anonymous parameters are written as `?` in SQL and are bound in order ».
- Portée / limites : utilisable sans drapeau depuis 22.13 / 23.4, mais l'API peut encore bouger. La doc v26 lue présente `DatabaseSync` comme alias déprécié de `Database`, ce qui confirme qu'elle évolue. Pas de pool ni de migrations : c'est un pilote, pas un ORM.
- En code : une requête `node:sqlite` est-elle construite par concaténation de chaînes plutôt qu'avec `?` ou `$nom` ? La version de Node en production est-elle épinglée, faute d'API figée ?

### Le modèle de permissions (`--permission`) est une ceinture de sécurité, pas une frontière de sécurité
- Niveau de preuve : N3
- Source : Node.js, 2026, « Permissions », https://nodejs.org/api/permissions.html
- Extrait lu : « Stability: 2 - Stable » ; « v23.5.0, v22.13.0 — This feature is no longer experimental » ; « This feature does not protect against malicious code. » ; « The permission model implements a "seat belt" approach … It does not provide security guarantees in the presence of malicious code. »
- Portée / limites : les drapeaux `--allow-fs-read`, `--allow-fs-write`, `--allow-net`, `--allow-child-process`, `--allow-worker`, `--allow-addons` et `--allow-wasi` existent. Ils limitent les erreurs d'un code de confiance, pas l'action d'une dépendance compromise.
- En code : une PR ou un document de conception présente-t-il `--permission` comme une isolation contre une dépendance malveillante ? Il faut alors un vrai bac à sable (conteneur, utilisateur dédié).

### Charger la configuration locale avec `--env-file`, qui est stable, en sachant que l'environnement réel l'emporte sur le fichier
- Niveau de preuve : N3
- Source : Node.js, 2026, « Command-line API », https://nodejs.org/api/cli.html
- Extrait lu : « v24.10.0, v22.21.0 — The `--env-file` flag is no longer experimental. » ; « If the same variable is defined in the environment and in the file, the value from the environment takes precedence. » ; « An error is thrown if the file does not exist. »
- Portée / limites : `--env-file-if-exists` (depuis v22.9.0, stable dans les mêmes versions) ne lève pas d'erreur si le fichier manque. Pour un serveur sans dépendance, cela remplace `dotenv`.
- En code : `dotenv` est-il ajouté alors que le runtime cible est ≥ 22.21 ? Un `.env` est-il versionné ? Un test suppose-t-il que le fichier écrase une variable déjà exportée ?

### Mettre un délai explicite sur chaque appel sortant : `fetch` est stable, et `AbortSignal.timeout(ms)` fournit le signal
- Niveau de preuve : N3
- Source : Node.js, 2026, « Global objects » (source `doc/api/globals.md`, branche main), https://raw.githubusercontent.com/nodejs/node/main/doc/api/globals.md
- Extrait lu : `fetch` : « v21.0.0 — No longer experimental. » ; « A browser-compatible implementation of the `fetch()` function. » ; `AbortSignal.timeout(delay)` : « Returns a new `AbortSignal` which will be aborted in `delay` milliseconds. » (ajouté en v17.3.0 / v16.14.0).
- Portée / limites : la doc ne précise aucun délai par défaut adapté à un appel d'API. Sans signal, la durée maximale d'un appel n'est pas documentée ici (Non vérifié).
- En code : un `fetch(` vers un service tiers sans `signal:` ? Un timeout bricolé avec `setTimeout` et un `AbortController` jamais nettoyé ?

### Écrire les tests d'un serveur sans dépendance avec `node:test`, stable depuis Node 20
- Niveau de preuve : N3
- Source : Node.js, 2026, « Test runner » (source `doc/api/test.md`, branche main), https://raw.githubusercontent.com/nodejs/node/main/doc/api/test.md
- Extrait lu : « v20.0.0 — The test runner is now stable. » ; « Stability: 2 - Stable » ; « This module is only available under the `node:` scheme. »
- Portée / limites : convient aux serveurs `http` natifs. La doc ne compare pas `node:test` à Vitest ou Jest.
- En code : un serveur « zéro dépendance » ajoute-t-il Jest seulement pour tester ? `import test from 'test'` sans le préfixe `node:` ?

### Ne pas hacher les mots de passe avec `crypto.scrypt` et ses paramètres par défaut : ils sont en dessous du minimum OWASP, et `maxmem` doit être relevé pour l'atteindre
- Niveau de preuve : N3 (doc Node) croisée avec N4 (OWASP Cheat Sheet)
- Source : Node.js, 2026, « Crypto » (source `doc/api/crypto.md`, branche main), https://raw.githubusercontent.com/nodejs/node/main/doc/api/crypto.md ; OWASP Cheat Sheet Series, « Password Storage Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
- Extrait lu : Node : « `cost` {number} … **Default:** `16384`. » ; « `maxmem` … It is an error when (approximately) `128 * N * r > maxmem`. **Default:** `32 * 1024 * 1024`. » ; « It is recommended that a salt is random and at least 16 bytes long. » OWASP : « use scrypt with a minimum CPU/memory cost parameter of (2^17), a minimum block size of 8 (1024 bytes) … a parallelization parameter of 1. »
- Portée / limites : le défaut de Node, N = 2^14, est huit fois sous le minimum OWASP de 2^17. Avec N = 2^17 et r = 8, il faut 128 × 131072 × 8 octets, soit 128 MiB, ce qui dépasse le `maxmem` par défaut de 32 MiB : l'appel lève une erreur tant que `maxmem` n'est pas relevé. Ce calcul découle des deux formules citées. **Exécuté le 09.11.2026** (contrôle de clôture, Node 22.23.4) : `scryptSync` avec N = 2^17, r = 8, p = 1 et `maxmem` par défaut lève « Invalid scrypt params: … memory limit exceeded » ; avec `maxmem` à 256 MiB, l'appel passe. Depuis v24.7.0, Node fournit aussi `crypto.argon2()` (variante `"argon2id"`), sans marqueur de stabilité propre dans la doc main lue.
- En code : `scrypt(pw, salt, 64)` sans options ? Sel fixe ou de moins de 16 octets ? `maxmem` absent alors que `N` vaut 2^17 ?

### Hacher les mots de passe avec Argon2id (19 MiB, t = 2, p = 1), sinon scrypt, et PBKDF2-HMAC-SHA256 à 600 000 itérations seulement sous contrainte FIPS
- Niveau de preuve : N4 (guide communautaire OWASP, pas une norme)
- Source : OWASP Cheat Sheet Series, « Password Storage Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
- Extrait lu : « Use Argon2id with a minimum configuration of 19 MiB of memory, an iteration count of 2, and 1 degree of parallelism. » ; « PBKDF2-HMAC-SHA256: 600,000 iterations » ; bcrypt : « a work factor of 10 or more and with a password limit of 72 bytes ».
- Portée / limites : ce sont des minimums datés, qui seront relevés avec le temps. `crypto.hash()` de Node (stable depuis v25.5.0 / v24.13.1) est un condensat ponctuel : « A utility for creating one-shot hash digests of data ». Il est rapide, donc impropre aux mots de passe.
- En code : `crypto.hash('sha256', password)` ou `createHash` sur un mot de passe ? `bcrypt` appliqué à des entrées de plus de 72 octets sans contrôle ?

### Comparer secrets, jetons et signatures en temps constant : `crypto.timingSafeEqual` en Node, `secrets.compare_digest` ou `hmac.compare_digest` en Python
- Niveau de preuve : N3
- Source : Node.js, 2026, « Crypto », https://raw.githubusercontent.com/nodejs/node/main/doc/api/crypto.md ; Python Software Foundation, 2026, « secrets » (doc 3.15.2), https://docs.python.org/3/library/secrets.html
- Extrait lu : Node : « This function does not leak timing information … suitable for comparing HMAC digests or secret values like authentication cookies » ; « An error is thrown if `a` and `b` have different byte lengths. » Python : « `secrets` should be used in preference to the default pseudo-random number generator in the `random` module, which is designed for modelling and simulation, not security or cryptography. »
- Portée / limites : en Node, des longueurs différentes lèvent une erreur. Il faut d'abord comparer les longueurs, ou comparer deux HMAC de même taille.
- En code : `token === expected` sur un secret ? `random.choice` ou `Math.random()` pour générer un jeton ?

---

## 2. Hono et Standard Schema

### Hono est un choix TypeScript léger et portable ; sur Node il faut l'adaptateur `@hono/node-server`
- Niveau de preuve : N3
- Source : Hono, 2026, « Hono » et « Node.js », https://hono.dev/docs/ et https://hono.dev/docs/getting-started/nodejs
- Extrait lu : « Web framework built on Web Standards for Cloudflare Workers, Fastly Compute, Deno, Bun, Vercel, Node.js, and others. » ; « Hono has zero dependencies and uses only the Web Standards. » ; « import { serve } from '@hono/node-server' ».
- Portée / limites : version 4.13.17 publiée sur npm le 07.11.2026 (registre npm). La page Node indique encore « 18.x => 18.14.1+ » comme plancher, alors que Node 18 est hors support : ne pas en conclure qu'il faut viser 18.
- En code : un import de `hono/...` depuis un chemin inexistant ? Sur Node, un serveur Hono lancé sans `@hono/node-server` ?

### Avec le validateur Hono, exiger l'en-tête `Content-Type` dans les tests : sans lui, le corps validé est `{}`
- Niveau de preuve : N3
- Source : Hono, 2026, « Validation », https://hono.dev/docs/guides/validation
- Extrait lu : « Validation targets include `json`, `query`, `header`, `param` and `cookie` in addition to `form`. » ; pour `json` et `form`, « the request _must_ contain a matching `content-type` header ». Sans lui, le corps n'est pas analysé et le validateur reçoit un objet vide.
- Portée / limites : avec un schéma tout en champs optionnels, une requête mal typée passe la validation avec `{}`. C'est un faux négatif silencieux.
- En code : les tests `app.request()` posent-ils `content-type: application/json` ? Le schéma JSON a-t-il au moins un champ requis, ou un contrôle explicite du type de contenu ?

### Pour une validation indépendante de la bibliothèque, brancher le schéma par Standard Schema (`@hono/standard-validator`)
- Niveau de preuve : N3
- Source : Standard Schema, 2026, « Standard Schema » et page des implémentations, https://standardschema.dev/ et https://standardschema.dev/schema ; Hono, « Validation », https://hono.dev/docs/guides/validation
- Extrait lu : « a set of interfaces that standardize the provision and consumption of shared functionality in the TypeScript ecosystem » ; implémentations : « Zod (3.24.0+) », « Valibot (v1.0+) », « ArkType (v2.0+) », « Effect Schema (v3.13.0+) », « yup (v1.7.0+) », « joi (v18.0.0+) » ; consommateurs : « tRPC », « Hono Middleware », « Elysia », « oRPC », « React Hook Form »… Hono : « lets you use any Standard Schema-compatible validation library with Hono. »
- Portée / limites : Standard Schema est une spécification d'interfaces TypeScript, publiée sous `@standard-schema/spec`, conçue par les auteurs de Zod, Valibot et ArkType. Elle ne valide rien seule. Elle permet de changer de bibliothèque de validation sans changer d'adaptateur.
- En code : un adaptateur propre à une bibliothèque, alors que l'outil accepte Standard Schema ? Le schéma vient-il bien d'une version qui implémente la spécification (Zod ≥ 3.24) ?

---

## 3. ORM TypeScript : Prisma et Drizzle

### Avec Prisma 7, déclarer un adaptateur de pilote, un `prisma.config.ts`, un `output` de générateur, et charger `.env` soi-même
- Niveau de preuve : N3
- Source : Prisma, 2026, « Upgrade to Prisma ORM 7 », https://www.prisma.io/docs/orm/more/upgrade-guides/upgrading-versions/upgrading-to-prisma-7
- Extrait lu : « The way to create a new Prisma Client has changed to require a driver adapter for all databases. » ; « The `output` field is now **required** in the generator block. » ; « In Prisma ORM 7.0.0, environment variables are not loaded by default. » ; « The client middleware API has been removed. » ; « Prisma ORM v7 does not yet support MongoDB. »
- Portée / limites : Prisma 7.0.0 est publié sur npm le 19.11.2025 ; la dernière 7.x est 7.10.1 (15.10.2026). Minimum indiqué : Node 20.19.0 et TypeScript 5.4.0. `migrate dev` et `db push` ne lancent plus `prisma generate`, et le seed ne s'exécute plus automatiquement. Le moteur Rust est remplacé par un client en TypeScript (« migrating the Prisma Client away from Rust and rebuilding it in TypeScript », billet d'annonce de Prisma 7, date non affichée).
- En code : `new PrismaClient()` sans `adapter` ? `prisma-client-js` ou import de `@prisma/client` sans `output` ? `prisma.$use(` (middleware supprimé) ? Une CI qui suppose que `migrate dev` régénère le client ?

### Épingler la version majeure de Prisma : le tag npm `latest` pointe sur une release candidate de Prisma 8
- Niveau de preuve : N3
- Source : Prisma, 2026, « Release status » (dateModified 09.11.2026), https://www.prisma.io/docs/orm/release-status ; registre npm, paquet `prisma`, https://registry.npmjs.org/prisma
- Extrait lu : « Prisma ORM 8 is a **release candidate**: you can install it and build with it today. » ; « General availability is expected in October 2026. » ; « Prisma ORM 7 keeps receiving bug fixes and security updates for 18 months … from the day Prisma ORM 8 reaches general availability. » Registre : `'latest': '8.0.0-rc.33'` (publié le 06.11.2026), `'prev': '7.10.1'`.
- Portée / limites : au 09.11.2026, la GA annoncée pour octobre 2026 n'a pas eu lieu, et `npm i prisma` installe une RC. Prisma 8 exige « Node.js 22.18 or newer on the 22 line, 24.11 or newer on the 24 line, or 26 or newer » et « TypeScript 5.9 or newer ». `@prisma/client` reste à 7.10.1. L'API de Prisma 8 n'a pas été lue en détail ; la doc v8 parle d'un fichier « contract ».
- En code : `"prisma": "latest"` ou `^8` dans `package.json` sur un projet en production ? Un mélange `prisma@8` et `@prisma/client@7` ? Une méthode Prisma citée sans préciser la majeure ?

### Drizzle ORM 1.0 n'est pas stable au 09.11.2026 : la stable est 0.45.x, la 1.0 en release candidate
- Niveau de preuve : N3
- Source : Drizzle, 2026, « Upgrade to v1 », https://orm.drizzle.team/docs/upgrade-v1 ; registre npm, paquet `drizzle-orm`, https://registry.npmjs.org/drizzle-orm
- Extrait lu : doc : « npm i drizzle-orm@rc » / « npm i -D drizzle-kit@rc » ; « If you were using Relational Queries, you need to upgrade to v2. » Registre : `'latest': '0.45.4'` (08.10.2026), `'rc': '1.0.0-rc.5'` (21.10.2026).
- Portée / limites : la v1 retire `journal.json` et `drizzle-kit drop`, et passe aux instantanés DDL. Le code 0.x et le code 1.0 n'ont pas la même API de requêtes relationnelles.
- En code : un exemple Drizzle copié de la doc v1 dans un projet en 0.45 (ou l'inverse) ? Une migration générée par drizzle-kit 1.0 RC appliquée en production ?

---

## 4. Python : runtime, FastAPI, Pydantic, SQLAlchemy, uv

### Viser Python ≥ 3.11 pour un nouveau backend (3.14 ou 3.15 de préférence) ; 3.9 et 3.10 sont en fin de vie
- Niveau de preuve : N3
- Source : Python Developer's Guide, 2026, « Status of Python versions », https://devguide.python.org/versions/ ; PEP 745, https://peps.python.org/pep-0745/ ; PEP 790, https://peps.python.org/pep-0790/
- Extrait lu : « 3.10 | PEP 619 | end-of-life | 2021-10-04 | 2026-10-01 » ; « 3.9 | PEP 596 | end-of-life | 2020-10-05 | 2025-10-31 » ; « 3.14 | PEP 745 | bugfix | 2025-10-07 » ; « 3.15 | PEP 790 | bugfix | 2026-10-09 » ; PEP 790 : « 3.15.0 final: Friday, 2026-10-09 » (rubrique « Actual »).
- Portée / limites : 3.11, 3.12 et 3.13 ne reçoivent plus que des correctifs de sécurité. Dernière 3.14 listée par la PEP 745 : 3.14.10 (26.10.2026). SQLAlchemy 2.1 exige 3.11 (« Python version compatibility starts at version 3.11 »), et FastAPI comme Pydantic exigent au moins 3.10 sur PyPI. Le plancher pratique de la pile est donc 3.11.
- En code : `requires-python = ">=3.9"` ou une image `python:3.10` ? Une CI qui teste encore 3.9 ?

### En FastAPI, écrire les paramètres avec `Annotated` et ne plus rien attendre de Pydantic v1
- Niveau de preuve : N3
- Source : FastAPI, 2026, « Release Notes » (source `docs/en/docs/release-notes.md`), https://raw.githubusercontent.com/fastapi/fastapi/master/docs/en/docs/release-notes.md ; FastAPI, « Query Parameters and String Validations », https://fastapi.tiangolo.com/tutorial/query-params-str-validations/
- Extrait lu : 0.126.0 (20.12.2025) : « Drop support for Pydantic v1, keeping short temporary support for Pydantic v2's `pydantic.v1`. » ; 0.128.0 (27.12.2025) : « Drop support for `pydantic.v1`. » ; 0.129.0 (12.02.2026) : « Drop support for Python 3.9. » ; tutoriel : « For new code and whenever possible, use `Annotated` … There are multiple advantages … and no disadvantages. »
- Portée / limites : dernière version 0.162.2 (07.11.2026, PyPI, `requires_python >=3.10`). FastAPI est toujours en 0.x, et ses mineures cassent. Le paquet `fastapi-slim` est abandonné depuis 0.129.2 (« no more versions will be released »).
- En code : `from pydantic.v1 import` ? `q: str = Query(None)` dans du code neuf ? `fastapi` sans borne supérieure de version dans un projet en production ?

### Avec Pydantic v2, savoir que le mode par défaut convertit les types ; passer en strict aux frontières où une conversion silencieuse serait une faille
- Niveau de preuve : N3
- Source : Pydantic, 2026, « Why use Pydantic? », https://pydantic.dev/docs/validation/latest/get-started/why/
- Extrait lu : « By default, Pydantic is tolerant to common incorrect types and coerces data to the right type. » ; en mode strict, « types are not coerced and a validation error is raised unless the input data exactly matches the expected schema » ; « Pydantic's core validation logic is implemented in a separate package … where validation for most types is implemented in Rust. »
- Portée / limites : dernière version 2.14.3 (05.11.2026, `requires_python >=3.10`). Le chiffre de performance de la page (« Pydantic 3.45x faster » que du code écrit à la main, sur un banc du projet) est N3, auto-publié, et ne se généralise pas. La page lue ne donne aucun chiffre contre Pydantic v1.
- En code : un champ `bool` ou `int` d'autorisation (`is_admin`, `amount`) reçu en lax, où `"1"` devient `True` ou `1` ? `model_config = ConfigDict(strict=True)` ou `Strict*` aux frontières sensibles ?

### Avec SQLAlchemy 2.1 en async, installer l'extra `[asyncio]`, une `AsyncSession` par tâche, et interdire le lazy loading implicite
- Niveau de preuve : N3
- Source : SQLAlchemy, 2026, « What's New in SQLAlchemy 2.1? », https://docs.sqlalchemy.org/en/21/changelog/migration_21.html ; SQLAlchemy, « Asynchronous I/O (asyncio) », https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html
- Extrait lu : 2.1 : « Python 3.10 is dropped as of August, 2026 » ; greenlet reste « entirely within the `[asyncio]` target » ; « users of the asyncio extension need to be aware of this extra installation dependency ». Asyncio : « A single instance of AsyncSession is not safe for use in multiple, concurrent tasks. » ; « relationships can be declared with lazy="raise" so that by default they will not attempt to emit SQL » ; « The most useful eager loading strategy is the selectinload() eager loader. »
- Portée / limites : 2.1.0 est publié sur PyPI le 24.09.2026, la dernière est 2.1.8 (04.11.2026). Les lignes typées deviennent `Select[int, str]` au lieu de `Select[Tuple[int, str]]`, avec Mypy ≥ 1.7.
- En code : `pip install sqlalchemy` sans `[asyncio]` avec `create_async_engine` ? Une `AsyncSession` partagée dans un `asyncio.gather` ou en variable globale ? Un accès à une relation après `await session.commit()` sans `expire_on_commit=False` ni `selectinload` ?

### Gérer l'environnement Python avec uv et versionner `uv.lock`, en traitant chaque mineure de uv comme potentiellement cassante
- Niveau de preuve : N3
- Source : Astral, 2026, « uv » et « Versioning », https://docs.astral.sh/uv/ et https://docs.astral.sh/uv/reference/policies/versioning/
- Extrait lu : « An extremely fast Python package and project manager, written in Rust. » ; « A single tool to replace `pip`, `pip-tools`, `pipx`, `poetry`, `pyenv`, `twine`, `virtualenv`, and more. » ; « uv uses a custom versioning scheme in which the minor version number is bumped for breaking changes. » ; « The `uv.lock` schema version is considered part of the public API. »
- Portée / limites : dernière version 0.13.7 (03.11.2026, PyPI). La politique de versions décrit uv comme « stable software ». Le « 10-100x faster than pip » est un chiffre du projet sur lui-même (N3).
- En code : `uv.lock` absent du dépôt ou ignoré par git ? Version de uv non épinglée en CI ?

### En Python, hacher les mots de passe avec une fonction de dérivation de clé, jamais avec `hashlib.sha256`
- Niveau de preuve : N3
- Source : Python Software Foundation, 2026, « hashlib » (doc 3.15.2), https://docs.python.org/3/library/hashlib.html
- Extrait lu : « Naive algorithms such as `sha1(password)` are not resistant against brute-force attacks. A good password hashing function must be tunable, slow, and include a salt. » ; « hashing with BLAKE2 or any other general-purpose cryptographic hash function, such as SHA-256, is not suitable for hashing passwords. » ; pour `pbkdf2_hmac` : « As of 2022, hundreds of thousands of iterations of SHA-256 are suggested. »
- Portée / limites : `hashlib.scrypt` est disponible depuis 3.6 ; la doc rappelle que `maxmem` vaut 32 MiB par défaut sous OpenSSL 1.1.0, avec le même piège qu'en Node pour les paramètres OWASP. La bibliothèque standard ne fournit pas Argon2.
- En code : `hashlib.sha256(pw.encode())` ? `pbkdf2_hmac` avec moins de 600 000 itérations ?

---

## 5. Zod 4 côté serveur

### Lors d'une migration ou d'une écriture en Zod 4, utiliser `error` (et non `message`), `z.treeifyError` ou `z.flattenError`, les formats de premier niveau et `z.strictObject` / `z.looseObject`
- Niveau de preuve : N3
- Source : Zod, 2026, « Migration guide » et « Formatting errors », https://zod.dev/v4/changelog et https://zod.dev/error-formatting
- Extrait lu : « Replaces `message` param with `error`. » ; pour `.flatten()` : « Instead use the top-level `z.treeifyError()` function. » ; formats : « these APIs have been moved to the top-level `z` namespace » (les formes méthode « are now deprecated ») ; « The `z.uuid()` now validates UUIDs more strictly against the RFC 9562/4122 specification. » ; « Instead use the top-level `z.strictObject()` and `z.looseObject()` functions. » ; `.strip()` « was the default behavior of `z.object()` » ; `z.flattenError()` sert à « retrieve a clean, shallow error object ».
- Portée / limites : Zod 4.0.0 est publié sur npm le 09.07.2025, la dernière est 4.6.7. `z.object()` retire silencieusement les clés inconnues : bien pour l'assignation de masse, mais un client mal formé n'en saura rien. Un `z.uuid()` strict peut rejeter des identifiants hérités non conformes (`z.guid()` est plus permissif).
- En code : un corps de requête validé par `z.object` alors que l'API doit refuser les clés inconnues (il faut `z.strictObject`) ? `.flatten()` renvoyé tel quel au client ? Des identifiants hérités soumis à `z.uuid()` sans vérification sur les données existantes ?

---

## 6. Supabase côté serveur

### Côté serveur, utiliser les nouvelles clés `sb_secret_…` ; les clés `anon` et `service_role` seront dépréciées fin 2026, et une clé secrète contourne toute RLS
- Niveau de preuve : N3
- Source : Supabase, 2026, « Understanding API keys », https://supabase.com/docs/guides/api/api-keys
- Extrait lu : « Supabase is deprecating the `anon` and `service_role` keys by the end of 2026. » ; clés publishable et secrètes : « short strings, not JWTs » ; « Creating publishable and secret keys doesn't revoke your legacy keys. Both key systems work at the same time. » ; « A secret key doesn't work in a browser. Supabase matches on the `User-Agent` header and returns HTTP 401 Unauthorized. » ; « Danger: A secret key bypasses every Row Level Security policy you have. »
- Portée / limites : le blocage par `User-Agent` ne protège pas d'une clé fuitée employée avec un autre outil. La page demande la rotation. Les anciennes clés restent valides jusqu'à leur désactivation manuelle.
- En code : `SUPABASE_SERVICE_ROLE_KEY` ou `sb_secret_` dans une variable `NEXT_PUBLIC_` / `VITE_` ? Une route serveur qui emploie la clé secrète, donc sans RLS, sans contrôle d'autorisation explicite ?

### Migrer vers des clés de signature JWT asymétriques (ES256 recommandé) et vérifier les jetons par JWKS ; le secret JWT hérité n'est plus recommandé
- Niveau de preuve : N3
- Source : Supabase, 2026, « JWT Signing Keys », https://supabase.com/docs/guides/auth/signing-keys
- Extrait lu : « Elliptic Curves are a faster alternative than RSA, while providing comparable security. » ; « We recommend using the P-256 elliptic curve instead. » ; JWKS : « GET https://project-id.supabase.co/auth/v1/.well-known/jwks.json » ; secret hérité : « No longer recommended. Available for backward compatibility. » ; « almost no benefit from using a JWT signed with a shared secret ».
- Portée / limites : la page ne donne pas de date de retrait du secret hérité. Le révoquer suppose d'avoir d'abord désactivé `anon` et `service_role`. Le côté `getClaims()` est couvert ailleurs.
- En code : un `jwt.verify(token, SUPABASE_JWT_SECRET)` maison ? Un algorithme accepté sans liste blanche (voir RFC 8725 plus bas) ?

---

## 7. Code serveur écrit par des LLM

### Tenir un backend généré par un LLM pour exploitable tant qu'il n'a pas passé des tests de sécurité : dans BaxBench, environ la moitié des backends corrects le sont
- Niveau de preuve : N2 (ICML 2025, PMLR 267 ; 392 tâches = 28 scénarios × 14 frameworks, 6 langages, 11 modèles)
- Source : Vero, Mündler, Chibotaru, Raychev, Baader, Jovanović, He, Vechev, 2025, « BaxBench: Can LLMs Generate Correct and Secure Backends? », https://arxiv.org/pdf/2502.11844 (v3, PDF lu en entier)
- Extrait lu : « even the best model, OpenAI o1, achieves a mere 62% on code correctness; (ii) on average, we could successfully execute security exploits on around half of the correct programs generated by each LLM » ; « even for the best model, OpenAI o3-mini, it [sec_pass@1] only reaches 35% » ; « in less popular backend frameworks, models further struggle to generate correct and secure applications ».
- Portée / limites : modèles du début 2025 (o1, o3-mini, Claude 3.5 Sonnet, DeepSeek-R1, GPT-4o…). Les frameworks testés sont Go Fiber, Gin et net/http ; Express, Fastify, Koa et Nest ; Lumen ; aiohttp, Django, FastAPI et Flask ; Rails ; Actix. Ni Hono ni Next.js. Effet d'un rappel de sécurité : un rappel générique aide surtout les modèles de raisonnement (« show considerable improvement already on just the generic security reminder, while the non-reasoning models do not exhibit a significant improvement »). Le rappel « oracle », qui nomme les failles, maximise sec_pass@1 mais fait baisser pass@1. Avec Claude 3.5 Sonnet sous OpenHands (351 tâches), sans rappel : pass@1 de 53,6 % (base) contre 59,5 % (agent), sec_pass@1 de 32,9 % contre 31,8 %. Avec le rappel oracle, sec_pass@1 de 35,4 % contre 39,0 %. Le classement en ligne baxbench.com n'a pas pu être lu (chargé en JavaScript).
- En code : la PR d'un endpoint généré embarque-t-elle des tests d'exploitation (entrée hostile, accès croisé, charge) en plus des tests fonctionnels ? Le framework est-il un des moins représentés, ce qui demande plus de revue ?

### Dans un backend généré, chercher d'abord XSS, injection dans les logs, épuisement de ressources, identifiants mal protégés et injection de code : l'injection SQL y est devenue rare
- Niveau de preuve : N2 (même étude, annexe D.2, tableaux 9 et 12)
- Source : Vero et al., 2025, « BaxBench: Can LLMs Generate Correct and Secure Backends? », https://arxiv.org/pdf/2502.11844
- Extrait lu : tableau 9 (sans consigne de sécurité ; taux = backends corrects porteurs de la CWE / backends corrects qui pouvaient l'avoir) : `Python-FastAPI 0.13 0.32 0.01 0.64 0.00 0.42 1.00 0.12 0.42 0.00 0.27 0.03 0.04` et `JavaScript-Express 0.09 0.30 0.18 0.95 0.04 0.40 1.00 0.12 0.37 0.00 0.32 0.01 0.00`, pour les colonnes CWE 20, 22, 78, 79, 89, 94, 117, 284, 400, 434, 522, 703, 863.
- Portée / limites : selon le framework, CWE-89 (injection SQL) va de 0,00 à 0,11 ; CWE-79 (XSS) de 0,38 à 1,00 ; CWE-117 (logs) de 0,98 à 1,00 ; CWE-400 (ressources) de 0,00 à 0,64 ; CWE-522 de 0,00 à 0,99 ; CWE-94 de 0,00 à 0,67 ; CWE-284 (contrôle d'accès) de 0,07 à 0,34. Ces chiffres dépendent des 28 scénarios, et les CWE de BaxBench ne couvrent pas toute l'autorisation métier (IDOR multi-locataire).
- En code : les entrées utilisateur sont-elles neutralisées avant d'aller dans les logs ? Taille de corps, timeouts et pagination sont-ils bornés ? Les mots de passe sont-ils hachés (CWE-522) ? Pas d'`eval` ni de `exec` sur une entrée ? Le HTML renvoyé est-il échappé ?

### Mesurer la sécurité du code généré avec des tests orientés résultat, pas seulement avec un analyseur statique
- Niveau de preuve : N2 (prépublication arXiv, 119 tâches, 31 CWE, 5 langages ; statut de relecture non vérifié)
- Source : Peng, Cui, Huang, Yang, Ray, 2025, « CWEval: Outcome-driven Evaluation on Functionality and Security of LLM Code Generation », https://arxiv.org/pdf/2501.08200 (v1, PDF lu)
- Extrait lu : « From func@10 to func-sec@10, the performance drops around 30% across all models, with the maximum 35.79% observed on Gemini 1.5 Flash. » ; la figure 1 montre une règle CodeQL (CWE-020) qui laisse passer des implémentations non sûres (« False Negatives: insecure implementations indetectable by CodeQL ») et en signale à tort une sûre.
- Portée / limites : il s'agit de fonctions isolées, pas de backends entiers. Les modèles datent de fin 2024.
- En code : la seule garantie de sécurité de la PR est-elle « CodeQL vert » ? Y a-t-il au moins un test qui tente l'abus visé (URL piégée, chemin `../`, entrée géante) ?

### Ne pas compter sur un rappel de sécurité dans le prompt d'un agent : dans SusVibes, même un agent de pointe ne produit que 11,8 % de solutions sûres
- Niveau de preuve : N2 (ICML 2026, d'après la mention du PDF ; 186 tâches tirées de 100 dépôts Python réels, 12 configurations d'agents)
- Source : Zhao, Wang, Zhang, Luo, Li, Li, 2025-2026, « Is Vibe Coding Safe? Benchmarking Vulnerability of Agent-Generated Code in Real-World Tasks », https://arxiv.org/pdf/2512.03262 (v4 du 21.09.2026, PDF lu)
- Extrait lu : « Although 57% of the solutions from SWE-Agent with Claude 4 Sonnet are functionally correct, only 11.8% are secure. » ; « 79.3% of its functionally correct solutions have vulnerabilities » ; « preliminary security strategies, such as augmenting the feature request with vulnerability hints, cannot mitigate these security issues ».
- Portée / limites : tableau 5 : en partant du prompt générique (FuncPass 57,0, SecPass 11,8), l'auto-sélection de la CWE donne 50,0 / 14,5 et la CWE fournie en oracle 55,4 / 15,1. Le gain en sécurité est de quelques points, pour une perte de fonctionnalité qui va jusqu'à 7 points. Uniquement Python ; les tâches sont des ajouts de fonctionnalité dans des dépôts où un humain avait introduit une faille.
- En code : une PR d'agent touchant à l'auth, aux fichiers, aux sous-processus ou au réseau passe-t-elle par une revue humaine ciblée et des tests de sécurité, et pas seulement par un « pense à la sécurité » dans le prompt ?

### Boucler l'analyse statique sur le code généré (Bandit, Pylint, linters de sécurité) : cela réduit les alertes, sans prouver l'absence de faille
- Niveau de preuve : N2 (prépublication arXiv ; banc PythonSecurityEval ; un seul modèle, GPT-4o)
- Source : Blyth, Licorish, Treude, Wagner, 2025, « Static Analysis as a Feedback Loop: Enhancing LLM-Generated Code Beyond Correctness », https://arxiv.org/pdf/2508.14419v1 (PDF lu)
- Extrait lu : « security issues reduced from >40% to 13%, readability violations from >80% to 11%, and reliability warnings from >50% to 11% within ten iterations. »
- Portée / limites : la mesure vient des mêmes outils qui guident la correction. On mesure donc les alertes Bandit, pas des failles exploitées. CWEval (plus haut) montre les faux négatifs d'un analyseur statique. Les travaux antérieurs cités par ce papier (Alrashedy et al., réduction de 30,8 %) n'ont pas été lus.
- En code : la CI lance-t-elle Bandit, Semgrep ou CodeQL sur le code généré, avec des alertes bloquantes ? L'équipe sait-elle qu'un rapport vert ne vaut pas audit ?

---

## 8. Contrôle d'accès

### Traiter le contrôle d'accès comme le risque n° 1 : refus par défaut, contrôle côté serveur, propriété de l'enregistrement vérifiée à chaque accès
- Niveau de preuve : N1 (classement de référence OWASP Top 10, édition 2025, fondé sur des données d'applications testées)
- Source : OWASP Top 10 Team, 2025, « OWASP Top 10:2025 » et « A01:2025 – Broken Access Control », https://top10.owasp.org/2025 et https://top10.owasp.org/2025/A01_2025-Broken_Access_Control/
- Extrait lu : liste : « A01:2025 - Broken Access Control », « A02:2025 - Security Misconfiguration », « A03:2025 - Software Supply Chain Failures », … « A10:2025 - Mishandling of Exceptional Conditions » ; A01 : « Maintaining its position at #1 in the Top Ten » ; « 100% of the applications tested were found to have some form of broken access control » ; « Except for public resources, deny by default. » ; « Model access controls should enforce record ownership ».
- Portée / limites : 40 CWE rattachées, dont CWE-918 (SSRF), citée parmi les CWE notables. Incidence maximale 20,15 %, moyenne 3,74 %, 1 839 701 occurrences. Aucune date de publication n'apparaît sur la page (copyright « 2021-2025 »). OWASP Top 10 est un document de sensibilisation, pas une norme de conformité au sens ISO ; il est classé N1 ici comme référentiel de l'industrie.
- En code : chaque handler qui lit un `:id` vérifie-t-il que la ressource appartient à l'appelant (ou à son locataire) ? Les routes sont-elles fermées par défaut ? Les erreurs sont-elles gérées sans fuite d'information (A10) ?

### Sur un backend Supabase généré, vérifier que chaque table exposée a une RLS active et des politiques : l'absence de RLS a déjà ouvert la lecture et l'écriture d'applications générées
- Niveau de preuve : N4 (fiche CVE contestée par l'éditeur ; un cas, pas une étude)
- Source : NVD / MITRE, 2025, « CVE-2025-48757 », https://services.nvd.nist.gov/rest/json/cves/2.0?cveId=CVE-2025-48757 (API NVD, la page HTML n'ayant pas été rendue)
- Extrait lu : « An insufficient database Row-Level Security policy in Lovable through 2025-04-15 allows remote unauthenticated attackers to read or write to arbitrary database tables of generated sites. NOTE: this is disputed by the Supplier because each individual customer of the Lovable platform accepts a responsibility over protecting the data of their application. » CVSS 3.1 : 9.3 (secondaire, cve@mitre.org) ; étiquette `disputed`.
- Portée / limites : publiée le 30.05.2025. Elle illustre le mécanisme (clé publique + RLS absente = base ouverte) sans en mesurer la fréquence.
- En code : `alter table … enable row level security` et au moins une politique pour chaque table du schéma `public` ? Les advisors de sécurité Supabase ont-ils été lancés ?

### Ne jamais écrire sa propre vérification de JWT : déléguer à une bibliothèque éprouvée, configurée avec une liste blanche d'algorithmes, l'émetteur et l'audience
- Niveau de preuve : N1
- Source : Sheffer, Hardt, Jones, 2020, « RFC 8725 — JSON Web Token Best Current Practices », https://www.rfc-editor.org/rfc/rfc8725.html
- Extrait lu : § 2.1 : « The algorithm can be changed to "none" by an attacker. » (et la substitution RS256 → HS256) ; § 3.1 : « MUST NOT use any other algorithms when performing cryptographic operations » ; § 3.9 : « the relying party or application MUST validate the audience value » ; § 3.8 : « If they do not, the application MUST reject the JWT. »
- Portée / limites : la RFC décrit des exigences, elle ne dit pas « n'écrivez pas de JWT ». La règle du profil en est une conséquence d'ingénierie : chaque exigence est un point de défaillance pour du code maison. § 3.10 : ne pas faire confiance aux en-têtes `kid`, `jku`, `x5u` reçus.
- En code : décodage base64 du JWT puis `JSON.parse` sans vérification de signature ? `jwt.verify` sans option `algorithms` ? `aud` et `iss` non vérifiés ? `jku` suivi vers une URL fournie par le jeton ?

---

## Verdict sur les règles du profil

| Règle du profil | Verdict | Motif sourcé |
|---|---|---|
| « Défaut : TypeScript : Next.js (route handlers, server actions), Hono. ORM Prisma. Python : FastAPI + Pydantic + SQLAlchemy. Validation runtime obligatoire : Zod / Pydantic. Auth : Auth.js / Supabase Auth. DB : SQLite dev → Postgres prod, ou Supabase. » | **Périmée en partie** (les choix tiennent, les modalités ont vieilli) | Hono : à jour (4.13.17), mais l'adaptateur `@hono/node-server` est nécessaire sur Node. Prisma : la règle ne dit pas quelle majeure. Prisma 7 impose adaptateur de pilote, `prisma.config.ts`, `output` et un chargement manuel de `.env`, et le tag npm `latest` installe une RC de Prisma 8 (8.0.0-rc.33) : il faut épingler la majeure. FastAPI, Pydantic et SQLAlchemy : à jour, mais le plancher est Python 3.11 (SQLAlchemy 2.1), FastAPI n'accepte plus Pydantic v1, et l'async exige `sqlalchemy[asyncio]`. Validation : « Zod / Pydantic » reste juste ; ajouter « via Standard Schema quand l'outil l'accepte » et les API Zod 4. Supabase : préciser les clés `sb_publishable_` / `sb_secret_` (anon et service_role dépréciées fin 2026) et les clés de signature asymétriques. Auth.js : voir l'autre volet (Better Auth). « SQLite dev → Postgres prod » : **convention sans preuve trouvée**. Aucune source lue n'en mesure le risque ou le bénéfice, et Prisma 7 lie le client à un adaptateur propre à chaque base. Drizzle, alternative courante, n'est pas en 1.0 stable. |
| « La bibliothèque standard le fait-elle ? Côté Node : `node:crypto`, `URL`, `Intl`, `structuredClone`, `AbortSignal.timeout`. Côté Python : `datetime`, `hashlib`, `pathlib`, `functools`, `dataclasses`. » | **Soutenue, mais incomplète et piégeuse sur la crypto** | Node fournit en stable `fetch`, `node:test`, `--env-file`, `timingSafeEqual`, `crypto.hash` et le type stripping. `node:sqlite` est en RC, pas stable. `crypto.scrypt` par défaut (N = 16384) est sous le minimum OWASP (2^17) et `maxmem` (32 MiB) bloque ce minimum. `crypto.argon2` existe depuis 24.7.0. En Python, ajouter `secrets` et `hmac.compare_digest` ; `hashlib` n'est sûr pour les mots de passe que via `scrypt` ou `pbkdf2_hmac` bien paramétrés (doc hashlib). `URL`, `Intl`, `structuredClone`, `datetime`, `pathlib`, `functools` et `dataclasses` n'ont pas été revérifiés ici. |
| « Anti-hallucination : jamais de méthode (ORM, framework, auth, DB) sans en être certain ; pas d'import depuis un chemin inventé ; pas de nom de colonne supposé sans avoir lu le schéma. Si doute, lire la doc / le code source. » | **Soutenue (indirectement)** | La règle suppose que la mémoire du modèle peut être fausse. Les sources lues montrent que les API visées ont changé en un an : Prisma 7 (middleware supprimé, `output` obligatoire), Prisma 8 en RC sur `latest`, Drizzle v1 et ses RQB v2, Zod 4 (`message` → `error`, `.flatten()` → `z.treeifyError`), FastAPI sans Pydantic v1, SQLAlchemy 2.1 (greenlet en extra), Supabase (nouvelles clés). BaxBench mesure aussi une baisse de correction et de sécurité sur les frameworks moins répandus. Aucune étude lue ici ne mesure directement les noms de colonnes supposés (Non vérifié). Ajout utile : « préciser la majeure de la bibliothèque avant de citer une méthode ». |
| « Jamais de JWT maison. » | **Soutenue** | RFC 8725 (N1) : substitution d'algorithme, `none`, audience, émetteur, en-têtes `kid` / `jku` non fiables. Autant d'exigences qu'un code maison doit toutes tenir. Supabase recommande des clés asymétriques vérifiées par JWKS et déclare le secret partagé « No longer recommended ». La règle gagnerait à dire quoi faire : bibliothèque éprouvée, `algorithms` en liste blanche, `aud` et `iss` vérifiés. |

---

## Mythes et affirmations contestées

- **« L'injection SQL est la faille typique du code backend généré. »** Contredit pour les modèles 2025 dans BaxBench. Selon le framework, CWE-89 va de 0,00 à 0,11 parmi les backends corrects qui pouvaient l'avoir, contre 0,38 à 1,00 pour XSS (CWE-79) et 0,98 à 1,00 pour l'injection dans les logs (CWE-117) (tableau 9). La revue doit déplacer son effort, pas abandonner les requêtes paramétrées.
- **« Ajouter "respecte les bonnes pratiques de sécurité" au prompt suffit. »** Contredit. Dans BaxBench, le rappel générique n'aide pas significativement les modèles sans raisonnement. Dans SusVibes, même la CWE fournie en oracle ne fait passer SecPass que de 11,8 à 15,1.
- **« Un analyseur statique vert prouve que le code est sûr. »** Contredit par CWEval (faux négatifs de CodeQL, figure 1). Le gain mesuré par Blyth et al. (> 40 % → 13 %) l'est par Bandit lui-même.
- **« Le modèle de permissions de Node isole une dépendance malveillante. »** Contredit par la doc Node : « does not protect against malicious code ».
- **« Node exécute TypeScript, donc plus besoin de `tsc`. »** Faux : « no type checking is performed », `tsconfig.json` est ignoré, et les enums et parameter properties ne passent pas.
- **« `npm i prisma` installe la version stable. »** Faux au 09.11.2026 : `latest` = 8.0.0-rc.33.
- **« Drizzle est en 1.0. »** Faux au 09.11.2026 : stable 0.45.4, 1.0 en `rc`.
- **Chiffres de performance auto-publiés (N3, non indépendants)** : Prisma 7, « 3x faster query execution », « 90% smaller bundle output » ; Zod 4, « 14x faster string parsing », « 7x faster array parsing », « 6.5x faster object parsing », « 100x reduction in `tsc` instantiations » ; Pydantic, « 3.45x faster » que du code écrit à la main, sur un banc du projet ; uv, « 10-100x faster than pip ». Aucune mesure indépendante n'a été lue.
- **« Supabase bloque la clé secrète dans le navigateur, donc une fuite côté client est sans gravité. »** Contredit par la doc : le blocage repose sur le `User-Agent` et ne gêne pas un attaquant muni d'un autre outil. Rotation obligatoire.
- **« L'OWASP Top 10 2025 n'est qu'un brouillon. »** La page se présente comme « the OWASP Top 10:2025 Release » ; je n'ai pas trouvé de mention « release candidate » sur les pages lues. La date exacte de publication n'est pas affichée.

---

## Non vérifié

- Le classement BaxBench en ligne (baxbench.com) pour des modèles postérieurs au début 2025 : page chargée dynamiquement, lignes non lisibles.
- SecCodePLT et les autres bancs cités en piste (hors CWEval, BaxBench, SusVibes) : non lus.
- Les travaux d'Alrashedy et al. (FDSP, réduction de 30,8 % ou 33 %) : chiffres seulement vus cités, non lus à la source.
- Le délai par défaut de `fetch` dans Node (undici) : absent de la doc lue.
- Le statut de stabilité propre de `crypto.argon2` dans les docs v24 et v26 : la doc main ne lui donne aucun marqueur propre, mais la doc versionnée n'a pas été consultée.
- La date de publication du billet « Announcing Prisma ORM 7.0.0 » (absente de la page) ; la date npm de 7.0.0, 19.11.2025, sert de repère.
- Le contenu détaillé de l'API Prisma 8 (fichier « contract ») : non lu.
- Prisma Postgres : non examiné.
- La date de mise à disposition des nouvelles clés Supabase : seule l'échéance de dépréciation, « by the end of 2026 », a été lue.
- Le statut de relecture par les pairs de CWEval et de Blyth et al. : prépublications arXiv, aucune publication en conférence vérifiée.
- Une étude mesurant directement les noms de colonnes ou de méthodes d'ORM inventés par les LLM : non trouvée dans cette passe.
- `URL`, `Intl`, `structuredClone` (Node) et `datetime`, `pathlib`, `functools`, `dataclasses` (Python) : non revérifiés.

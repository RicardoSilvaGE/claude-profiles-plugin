# Fiche `ux-preuves` — Backend — sécurité des API et authentification

> Fiche du skill `ux-preuves` (dev-fullstack), volet **backend**, préchargé par `backend`. Couvre : OWASP API Security Top 10 (2023), ASVS 5.0, stockage des mots de passe (Argon2id, scrypt, PBKDF2, bcrypt), NIST SP 800-63B-4, sessions et JWT (RFC 8725), limitation de débit et anti-abus, CSRF, CORS, SSRF, injection SQL et API brutes des ORM, OAuth (RFC 9700), journaux et ordre des contrôles dans un handler.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Versions, statuts de brouillons IETF et API
> **vieillissent en mois** ; le droit change par révision : avant d'écrire du code qui en dépend,
> relire la page officielle (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche documentaire du 09.11.2026 pour le référentiel « backend engineer senior » (Next.js route handlers / Server Actions, Hono + Prisma, FastAPI + Pydantic + SQLAlchemy, Supabase Postgres + RLS, Node natif zéro-dépendance).
> Chaque entrée vient d'une page ouverte ce jour (WebFetch, ou `curl` puis extraction du texte quand il fallait une citation exacte). Les citations sont verbatim. Quand seul un résumé de l'outil de lecture a été lu, c'est signalé.
> Hors périmètre, déjà couvert ailleurs : Server Actions = POST publics, `getClaims()`/`getUser()` de Supabase, reprise d'Auth.js par Better Auth, XSS/CSP, cookies HttpOnly côté client, chaîne d'approvisionnement npm, code généré par LLM.

Niveaux de preuve : N1 norme / RFC / standard ; N2 étude revue par pairs ; N3 documentation ou guide officiel (OWASP cheat sheet, doc de framework, NIST guidance) ; N4 avis de praticien.
Statut des sources OWASP : l'API Security Top 10 et l'ASVS sont des **standards communautaires OWASP**, classés ici N1 « standard de fait » (non normatifs au sens ISO/IETF). Les cheat sheets sont classées N3.

---

## 1. OWASP API Security Top 10 (édition 2023, toujours la dernière)

### Toute fonction qui lit ou modifie un objet à partir d'un identifiant venu du client vérifie que l'appelant a droit à CET objet
- Niveau de preuve : N1 (standard OWASP) + N3
- Source : OWASP API Security Project, 2023, « API1:2023 Broken Object Level Authorization », https://api-security.owasp.org/editions/2023/en/0xa1-broken-object-level-authorization ; complété par OWASP ASVS 5.0.0, 2025, exigence 8.2.2, https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0_release/5.0/en/0x17-V8-Authorization.md
- Extrait lu : « Use the authorization mechanism to check if the logged-in user has access to perform the requested action on the record » / « in every function that uses an input from the client to access a record in the database. » (API1) ; « Verify that the application ensures that data-specific access is restricted to consumers with explicit permissions to specific data items to mitigate insecure direct object reference (IDOR) and broken object level authorization (BOLA). » (ASVS 8.2.2, niveau 1)
- Portée / limites : la page projet (https://owasp.org/www-project-api-security/) indique « Latest Version » 2023 ; aucune édition 2025/2026 de l'API Top 10 n'y est annoncée (l'OWASP Top 10:2025 est la liste « web », distincte). BOLA est une exigence de niveau 1 de l'ASVS, donc un minimum. Les identifiants aléatoires (UUID) recommandés par API1 sont une défense en profondeur, pas le contrôle : « However, even with complex identifiers, access control checks are essential. » (OWASP, « Insecure Direct Object Reference Prevention Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Insecure_Direct_Object_Reference_Prevention_Cheat_Sheet.html, N3) ; l'ASVS 11.5.1 ajoute « Note that UUIDs do not respect this condition » (128 bits d'entropie d'un secret).
- En code : chaque `findUnique({ where: { id } })` / `session.get(Model, id)` alimenté par un paramètre de route ou de corps est-il filtré par propriétaire / tenant (`where: { id, ownerId: session.user.id }`) ou suivi d'un contrôle explicite ? Avec Supabase, la policy RLS porte-t-elle ce filtre et la requête passe-t-elle par une clé soumise à RLS ? « C'est un UUID, on ne peut pas le deviner » n'est pas une justification recevable.

### Une réponse d'API ne renvoie que les champs que l'appelant a le droit de voir, jamais l'entité brute
- Niveau de preuve : N1 (standard OWASP) + N3
- Source : OWASP API Security Project, 2023, « API3:2023 Broken Object Property Level Authorization », https://api-security.owasp.org/editions/2023/en/0xa3-broken-object-property-level-authorization ; OWASP ASVS 5.0.0, 2025, exigence 15.3.1, https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0_release/5.0/en/0x24-V15-Secure-Coding-and-Architecture.md ; Vercel, 2026 (lastUpdated 2026-10-06), « How to think about data security in Next.js », https://nextjs.org/docs/app/guides/data-security
- Extrait lu : « Avoid using generic methods such as `to_json()` and `to_string()`. » et « Keep returned data structures to the bare minimum » (API3) ; « Verify that the application only returns the required subset of fields from a data object. For example, it should not return an entire data object, as some individual fields should not be accessible to users. » (ASVS 15.3.1, niveau 1) ; « Server Action return values are serialized and sent to the client. Only return what the UI needs, not raw database records. » (Next.js)
- Portée / limites : API3 recommande aussi « a schema-based response validation mechanism ». Next.js recommande une Data Access Layer qui rend des DTO.
- En code : `return db.user.update(...)`, `return user`, `res.json(row)` ou un `response_model` FastAPI absent sur une route qui touche `User` → défaut. Chercher `passwordHash`, `resetToken`, `role`, `stripeCustomerId` dans les types de sortie.

### Le corps d'une requête d'écriture est lié à un objet d'entrée dédié (DTO, schéma) qui liste les champs modifiables ; jamais `data: req.body`
- Niveau de preuve : N3 + N1 (ASVS)
- Source : OWASP Cheat Sheet Series, s.d., « Mass Assignment Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Mass_Assignment_Cheat_Sheet.html ; OWASP ASVS 5.0.0, 2025, exigence 15.3.3 (niveau 2)
- Extrait lu : « Prefer dedicated input objects, such as Data Transfer Objects (DTOs), containing only fields the caller may edit » ; « Do not rely on a block-list as the sole protection: a new or overlooked sensitive field remains bindable. » ; « DTOs and field allowlists restrict writable properties; they do not replace authorization for the requested object and operation. »
- Portée / limites : vaut pour Prisma (`data: body`), SQLAlchemy (`Model(**payload.dict())`), Pydantic avec `extra="allow"`. Zod `.passthrough()` ou un `z.object` non `strict` laisse passer ou retire silencieusement selon la configuration : la question est ce qui atteint l'ORM.
- En code : le schéma d'entrée d'un `PATCH /users/:id` contient-il `role`, `isAdmin`, `ownerId`, `emailVerified` ? Le spread `...body` atteint-il l'ORM ?

### L'autorisation fonctionnelle refuse par défaut ; une route d'administration se protège elle-même, pas par l'absence de lien dans l'UI
- Niveau de preuve : N1 (standard OWASP)
- Source : OWASP API Security Project, 2023, « API5:2023 Broken Function Level Authorization », https://api-security.owasp.org/editions/2023/en/0xa5-broken-function-level-authorization ; OWASP ASVS 5.0.0, 2025, exigences 8.2.1 et 8.3.1
- Extrait lu : « The enforcement mechanism(s) should deny all access by default, requiring explicit grants to specific roles » (API5, extrait tronqué par l'outil de lecture) ; « Verify that the application enforces authorization rules at a trusted service layer and doesn't rely on controls that an untrusted consumer could manipulate, such as client-side JavaScript. » (ASVS 8.3.1, niveau 1)
- Portée / limites : la cheat sheet Authorization ajoute que la vérification doit pouvoir se configurer globalement : « The technology used to perform such checks should allow for global, application-wide configuration rather than needing to be applied individually to every method or class. » (https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html)
- En code : un middleware Next.js (`proxy.ts`) qui « protège /admin » sans contrôle de rôle dans le handler ou l'action → insuffisant. Vérifier aussi les méthodes HTTP non prévues (un `DELETE` exporté par erreur dans `route.ts`).

### Toute entrée bornée : taille de corps, longueur de chaîne, nombre d'éléments, taille de page, coût des services tiers
- Niveau de preuve : N1 (standard OWASP)
- Source : OWASP API Security Project, 2023, « API4:2023 Unrestricted Resource Consumption », https://api-security.owasp.org/editions/2023/en/0xa4-unrestricted-resource-consumption
- Extrait lu : « Define and enforce a maximum size of data on all incoming parameters and payloads, such as maximum length for strings, » ; « Add proper server-side validation for query string and request body parameters, » « specifically the one that controls the number of records to be returned in the response. » ; « Limit/throttle how many times or how often a single API client/user can execute a single operation » « (e.g. validate an OTP, or request password recovery without visiting the one-time URL). » ; « Configure spending limits for all service providers/API integrations. » (citations découpées par l'outil de lecture)
- Portée / limites : Next.js plafonne les Server Actions à 1 MB par défaut (« Action requests are capped at 1MB by default », https://nextjs.org/docs/app/guides/server-actions) ; les route handlers et Hono n'ont pas de plafond documenté ici (non vérifié). La cheat sheet REST demande un rejet en 413 au-delà de la limite.
- En code : `take: Number(searchParams.get('limit'))` sans `max` ; `z.string()` sans `.max()` ; un endpoint qui envoie un SMS ou un e-mail sans limite par utilisateur.

### L'inventaire des API est tenu : versions, hôtes, endpoints de debug
- Niveau de preuve : N1 (standard OWASP)
- Source : OWASP API Security Project, 2023, « OWASP Top 10 API Security Risks – 2023 » (entrée API9:2023 Improper Inventory Management), https://api-security.owasp.org/editions/2023/en/0x11-t10
- Extrait lu : « making proper and updated documentation highly important » (résumé de l'entrée, seul lu ; la page détaillée API9 n'a pas été ouverte)
- Portée / limites : pour une app Next.js, l'inventaire réel = tous les `route.ts`, toutes les fonctions exportées d'un fichier `'use server'`, et les fonctions RPC Supabase exposées par PostgREST.
- En code : une route `/api/debug`, `/api/test`, `/api/v1/*` laissée après migration vers v2 ; une fonction SQL `SECURITY DEFINER` dans le schéma `public` exposée sans le vouloir.

---

## 2. OWASP ASVS

### Viser l'ASVS 5.0.0 niveau 2 pour une application qui manipule des comptes ; le niveau 1 est un plancher
- Niveau de preuve : N1 (standard OWASP)
- Source : OWASP, 2025, « Application Security Verification Standard 5.0.0 », https://asvs.owasp.org/ (« Published 30 May 2025 », tag GitHub `v5.0.0_release`) ; chapitre « What is the ASVS », https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0_release/5.0/en/0x03-What-is-the-ASVS.md
- Extrait lu : « Most applications should be striving to achieve this level of security. Around 50% of the requirements in the ASVS are L2 meaning that an application needs to implement around 70% of the requirements in the ASVS (all of the L1 and L2 requirements) in order to comply with L2. » ; L1 : « This level contains around 20% of the ASVS requirements. »
- Portée / limites : 17 chapitres en 5.0 (fichiers lus) dont V2 Validation and Business Logic, V4 API and Web Service, V6 Authentication, V7 Session Management, V8 Authorization, V9 Self-contained Tokens, V10 OAuth and OIDC, V11 Cryptography, V16 Security Logging and Error Handling. La numérotation diffère de la 4.0.3 : une référence « ASVS 2.1.7 » (cheat sheet Credential Stuffing) renvoie à l'ancienne version. Une version « latest » de développement existe sur GitHub (26.10.2026), non stable.
- En code : citer les exigences en version 5.0 (« ASVS 5.0 v8.2.2 ») dans les specs et les PR, jamais sans numéro de version.

### La validation d'entrée est faite côté serveur, par liste positive (allowlist) ou schéma, et ne remplace pas les défenses à l'usage (requêtes paramétrées, encodage)
- Niveau de preuve : N1 (ASVS) + N3
- Source : OWASP ASVS 5.0.0, 2025, exigences 2.2.1 et 2.2.2, https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0_release/5.0/en/0x11-V2-Validation-and-Business-Logic.md ; OWASP, « Input Validation Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html
- Extrait lu : « For L1, this can focus on input which is used to make specific business or security decisions. For L2 and up, this should apply to all input. » (2.2.1) ; « While client-side validation improves usability and should be encouraged, it must not be relied upon as a security control. » (2.2.2) ; « Blocking apostrophes, for example, rejects legitimate names without making a database query safe. » (cheat sheet)
- Portée / limites : la cheat sheet distingue explicitement validation et défenses d'usage. Next.js ajoute une limite propre au schéma : « Schema validation (zod or similar) only checks the *shape* of the input. A well-formed `Item` object can still refer to a row the caller does not own. » (https://nextjs.org/docs/app/guides/server-actions)
- En code : `formData.get('x') as string` sans schéma ; un schéma zod partagé client/serveur mais appelé seulement côté client ; un `safeParse` dont le résultat `success: false` n'arrête pas le handler.

---

## 3. Stockage des mots de passe

### Nouveau système : Argon2id (m ≥ 19 MiB, t = 2, p = 1) ; à défaut scrypt (N ≥ 2^17, r = 8, p = 1) ; bcrypt est réservé à l'existant
- Niveau de preuve : N3
- Source : OWASP Cheat Sheet Series, s.d. (consulté 09.11.2026), « Password Storage Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
- Extrait lu : « Use Argon2id with a minimum configuration of 19 MiB of memory, an iteration count of 2, and 1 degree of parallelism. » ; « If Argon2id is not available, use scrypt with a minimum CPU/memory cost parameter of (2^17), a minimum block size of 8 (1024 bytes), and a parallelization parameter of 1. » ; « For legacy systems using bcrypt, use a work factor of 10 or more and with a password limit of 72 bytes. »
- Portée / limites : ce sont des minimums ; la cheat sheet ajoute « As a general rule, calculating a hash should take less than one second. » Le RFC 9106 (Informational, septembre 2021, https://www.rfc-editor.org/rfc/rfc9106.html) recommande des réglages bien plus lourds : « Argon2id with t=1 iteration, p=4 lanes, m=2^(21) (2 GiB of RAM) » en premier choix, et « t=3 iterations, p=4 lanes, m=2^(16) (64 MiB of RAM) » quand la mémoire manque. Les deux sources ne visent pas le même contexte (le RFC est générique, OWASP vise un serveur web qui hache à chaque connexion) ; le minimum OWASP est un plancher, pas une cible.
- En code : quel algorithme et quels paramètres sont écrits dans la chaîne stockée (`$argon2id$v=19$m=...,t=...,p=...`) ? Un nouveau projet qui choisit bcrypt doit dire pourquoi.

### bcrypt tronque à 72 octets : borner la longueur, et ne pas pré-hacher naïvement
- Niveau de preuve : N3
- Source : OWASP, « Password Storage Cheat Sheet » (même URL)
- Extrait lu : « bcrypt has a maximum length input length of 72 bytes for most implementations, so you should enforce a maximum password length of 72 bytes (or less if the bcrypt implementation in use has smaller limits). » ; sur le pré-hachage : « This can be dangerous because of null bytes in the hash output value » (extrait relevé par l'outil de lecture)
- Portée / limites : 72 **octets**, pas 72 caractères : un mot de passe UTF-8 accentué atteint la limite plus tôt. Tension avec NIST SP 800-63B-4 (« SHOULD permit a maximum password length of at least 64 characters ») et ASVS 6.2.9 (« passwords of at least 64 characters are permitted », niveau 2) : 64 caractères multi-octets peuvent dépasser 72 octets. Better Auth fixe par défaut 8 à 128 caractères (« at least 8 characters long and max 128 by default », https://www.better-auth.com/docs/authentication/email-password), au-delà de 72 octets — sans conséquence tant qu'il hache en scrypt.
- En code : `bcrypt.hash(password, ...)` sans contrôle `Buffer.byteLength(password) <= 72` ; `bcrypt(sha256(password))` en binaire brut.

### PBKDF2 seulement si FIPS l'impose : HMAC-SHA-256 à 600 000 itérations minimum (SHA-512 : 220 000)
- Niveau de preuve : N3
- Source : OWASP, « Password Storage Cheat Sheet » (même URL)
- Extrait lu : « If FIPS-140 compliance is required, use PBKDF2 with a work factor of 600,000 or more and set with an internal hash function of HMAC-SHA-256. » ; « PBKDF2-HMAC-SHA512: 220,000 iterations » ; « PBKDF2-HMAC-SHA1: 1,400,000 iterations — legacy only, do not select for new systems. »
- Portée / limites : OWASP présente PBKDF2 comme le choix de conformité FIPS, pas comme l'alternative naturelle sans dépendance. La doc Node reste vague : « The `iterations` argument must be a number set as high as possible. » (https://raw.githubusercontent.com/nodejs/node/main/doc/api/crypto.md)
- En code : `pbkdf2Sync(pw, salt, 10000, 64, 'sha512')` (valeur courante des tutoriels) → sous le plancher OWASP de 220 000.

### En Node zéro-dépendance, `crypto.scrypt` avec ses valeurs par défaut est sous le plancher OWASP : fixer N = 2^17 et relever `maxmem` ; `crypto.argon2` existe depuis Node 24.7.0
- Niveau de preuve : N3
- Source : Node.js, 2026 (branche main lue le 09.11.2026), « Crypto » (doc/api/crypto.md), https://raw.githubusercontent.com/nodejs/node/main/doc/api/crypto.md
- Extrait lu : « `cost` {number} CPU/memory cost parameter. Must be a power of two greater than one. **Default:** `16384`. » ; « `maxmem` {number} Memory upper bound. It is an error when (approximately) `128 * N * r > maxmem`. **Default:** `32 * 1024 * 1024`. » ; pour Argon2 : « ### `crypto.argon2(algorithm, parameters, callback)` » « added: v24.7.0 »
- Portée / limites : 16384 = 2^14, huit fois moins que le minimum OWASP (2^17). Avec N = 2^17 et r = 8, 128 × N × r = 128 MiB > 32 MiB : sans `maxmem` relevé, l'appel lève une erreur — un développeur pressé risque alors de baisser N au lieu de monter `maxmem`. Je n'ai pas relevé de marqueur de stabilité propre à `crypto.argon2` dans la doc lue ; vérifier la version de Node de production avant de s'en servir.
- En code : `scryptSync(pw, salt, 64)` sans options → paramètres par défaut, trop faibles. Attendu : `{ N: 2**17, r: 8, p: 1, maxmem: 256 * 1024 * 1024 }` (ou plus) et sel `randomBytes(16)` par entrée, comparaison par `timingSafeEqual`.

### Sel unique par mot de passe (≥ 32 bits selon NIST), schéma et coût stockés avec le hash pour pouvoir migrer
- Niveau de preuve : N1 (NIST SP 800-63B-4, ligne directrice fédérale)
- Source : NIST, juillet 2025 (final « 07/31/25 »), « SP 800-63B-4 Digital Identity Guidelines: Authentication and Authenticator Management », https://pages.nist.gov/800-63-4/sp800-63b.html ; statut : https://csrc.nist.gov/pubs/sp/800/63/b/4/final
- Extrait lu : « Passwords SHALL be salted and hashed using a suitable password hashing scheme. » ; « The salt SHALL be at least 32 bits in length and chosen to minimize salt value collisions among stored hashes » ; « A reference to the password hashing scheme used, including the cost factor, SHOULD be stored for each password to allow migration to new algorithms and work factors. »
- Portée / limites : NIST renvoie à SP 800-132 pour les schémas « approved » et ne nomme pas Argon2 dans l'extrait lu. OWASP recommande la chaîne PHC (« the modular PHC string format ») et la ré-écriture du hash à la connexion suivante quand le coût monte.
- Portée / limites (suite) : le hash rapide est exclu même salé : « Fast hashing algorithms such as SHA‑256 are not suitable for password storage because they allow attackers to perform large numbers of guesses quickly. » (Password Storage CS) ; l'ASVS 5.0 11.4.2 (L2, https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0_release/5.0/en/0x20-V11-Cryptography.md) exige « an approved, computationally intensive, key derivation function ».
- En code : la table `users` a-t-elle une colonne qui permet de savoir avec quel algorithme et quel coût chaque hash a été fait ? Existe-t-il un chemin « rehash si paramètres obsolètes » à la connexion ? `createHash(` ou `hashlib.sha256(` dans un module d'authentification → défaut bloquant.

### Avec un fournisseur d'auth, savoir ce qu'il hache et ce qu'il laisse à votre charge
- Niveau de preuve : N3
- Source : Better Auth, s.d. (consulté 09.11.2026), « Email & Password », https://www.better-auth.com/docs/authentication/email-password ; Auth.js, s.d., « Credentials », https://authjs.dev/getting-started/authentication/credentials ; FastAPI, s.d., « OAuth2 with Password (and hashing), Bearer with JWT tokens », https://fastapi.tiangolo.com/tutorial/security/oauth2-jwt/
- Extrait lu : « Better Auth uses scrypt to hash passwords. » ; Auth.js (résumé de l'outil de lecture) : « you just have to provide the necessary logic, eg. to encrypt passwords, add rate-limiting » ; FastAPI : « The recommended algorithm is "Argon2". » (avec `pwdlib[argon2]`)
- Portée / limites : les paramètres scrypt de Better Auth n'ont pas été vérifiés (Non vérifié). Avec le provider Credentials d'Auth.js, le hachage, la limitation de débit et l'anti-énumération sont entièrement à la charge de l'application ; le mot « encrypt » de la doc Auth.js est impropre (il s'agit de hacher).
- En code : un `authorize()` Credentials qui compare `user.password === credentials.password` ou qui n'a aucun compteur d'échecs.

---

## 4. NIST SP 800-63B-4 (final, juillet 2025)

### Politique de mot de passe : 15 caractères minimum en facteur unique (8 si MFA), 64 au moins acceptés, aucune règle de composition, aucune rotation forcée, liste de blocage obligatoire, coller autorisé
- Niveau de preuve : N1 (ligne directrice NIST, opposable aux agences fédérales US ; référence de fait ailleurs)
- Source : NIST, juillet 2025, « SP 800-63B-4 », https://pages.nist.gov/800-63-4/sp800-63b.html
- Extrait lu : « Verifiers and CSPs SHALL require passwords that are used as a single-factor authentication mechanism to be a minimum of 15 characters in length. Verifiers and CSPs MAY allow passwords that are only used as part of multi-factor authentication processes to be shorter but SHALL require them to be a minimum of eight characters in length. » ; « Verifiers and CSPs SHALL NOT impose other composition rules » ; « Verifiers and CSPs SHALL NOT require subscribers to change passwords periodically. » ; « verifiers SHALL compare the prospective secret against a blocklist that contains known commonly used, expected, or compromised passwords. » ; « Verifiers SHALL allow the use of password managers and autofill functionality. »
- Portée / limites : l'ASVS 5.0 est plus souple sur la longueur (6.2.1, L1 : « at least 8 characters in length although a minimum of 15 characters is strongly recommended ») et exige une liste d'au moins les 3000 mots de passe les plus courants (6.2.4, L1), la vérification contre des mots de passe fuités étant L2 (6.2.12). NIST exige aussi de vérifier le mot de passe entier, sans troncature (« SHALL verify the entire submitted password (e.g., not truncate it) ») — à rapprocher de la limite de 72 octets de bcrypt.
- En code : regex de complexité (majuscule + chiffre + spécial) → contraire à NIST et ASVS 6.2.5 ; `minLength: 8` sur un login sans MFA → sous NIST ; aucune liste de blocage au signup.

### Limiter les échecs consécutifs par compte et par authentificateur : 100 au plus selon NIST, plus strict selon le risque
- Niveau de preuve : N1
- Source : NIST, juillet 2025, « SP 800-63B-4 », § 3.2.2 Rate Limiting (Throttling) (même URL)
- Extrait lu : « the verifier SHALL limit consecutive failed authentication attempts using a specific authenticator on a single subscriber account to no more than 100 by disabling that authenticator. »
- Portée / limites : 100 est un plafond, pas une cible ; « agencies MAY impose lower limits » (résumé de l'outil de lecture). Le compteur est par compte : il ne remplace pas une limite par IP contre le password spraying (un mot de passe essayé sur beaucoup de comptes).
- En code : le compteur d'échecs existe-t-il côté serveur, rattaché au compte, et se remet-il à zéro seulement sur succès ?

### Proposer au moins une méthode résistante au phishing (passkey) ; les passkeys synchronisées conviennent jusqu'à AAL2, pas AAL3
- Niveau de preuve : N1
- Source : NIST, juillet 2025, « SP 800-63B-4 » (même URL)
- Extrait lu : « Verifiers SHALL offer at least one phishing-resistant authentication option at AAL2 » ; « Since syncable authenticators (described in Appendix B) require the private key to be exportable, syncable authenticators SHALL NOT be used at AAL3. »
- Portée / limites : le mot « passkey » n'apparaît pas dans le texte HTML complet de la page (recherche insensible à la casse : 0 occurrence) ; le document parle de « syncable authenticators ». Réauthentification AAL2 : « SHOULD be no more than 24 hours » et inactivité « SHOULD be no more than 1 hour ».
- En code : sessions de 30 jours glissants sur une application qui se dit AAL2 → écart à justifier. Better Auth : 7 jours par défaut (« The session expires after 7 days by default », https://www.better-auth.com/docs/concepts/session-management, résumé de l'outil de lecture).

---

## 5. Sessions et jetons

### Préférer la gestion de session du framework ; identifiant de session d'au moins 128 bits issu d'un CSPRNG, régénéré à chaque authentification
- Niveau de preuve : N1 (ASVS) + N3
- Source : OWASP ASVS 5.0.0, 2025, exigences 7.2.3 et 7.2.4, https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0_release/5.0/en/0x16-V7-Session-Management.md ; OWASP, « Session Management Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html
- Extrait lu : « Verify that if reference tokens are used to represent user sessions, they are unique and generated using a cryptographically secure pseudo-random number generator (CSPRNG) and possess at least 128 bits of entropy. » (7.2.3, L1) ; « Verify that the application generates a new session token on user authentication, including re-authentication, and terminates the current session token. » (7.2.4, L1) ; « It is recommended to use the session ID created by your language or framework. If you need to create your own sessionID, use a cryptographically secure pseudorandom number generator (CSPRNG) with a size of at least 128 bits and ensure that each sessionID is unique. »
- Portée / limites : la cheat sheet garde un plancher de 64 bits d'entropie (« Session identifiers must have at least 64 bits of entropy ») mais recommande 128 pour un identifiant fait maison ; l'ASVS fixe 128 au niveau 1. Cookie : « Session cookies must explicitly set SameSite=Strict (preferred) or SameSite=Lax. »
- En code : `Math.random()`, `uuidv4()` ou un horodatage comme jeton de session ; le même identifiant de session avant et après login (fixation).

### Une session doit pouvoir être révoquée tout de suite : un JWT sans état ne le permet pas sans liste de révocation
- Niveau de preuve : N1 (ASVS) + N3
- Source : OWASP ASVS 5.0.0, 2025, exigence 7.4.1 ; Auth.js, s.d., « Session strategies », https://authjs.dev/concepts/session-strategies ; OWASP, « JSON Web Token Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_Cheat_Sheet.html ; Better Auth, « Session Management », https://www.better-auth.com/docs/concepts/session-management
- Extrait lu : « Applications using self-contained tokens will need a solution such as maintaining a list of terminated tokens, disallowing tokens produced before a per-user date and time or rotating a per-user signing key. » (ASVS 7.4.1, L1) ; « Expiring a JSON Web Token before its encoded expiry is not possible. » (Auth.js) ; « If your application implements such a deny list, user sessions won't be completely stateless anymore which might defeat the benefits of stateless sessions. You might want to consider using a plain session system » (OWASP JWT CS)
- Portée / limites : Auth.js utilise la stratégie JWT par défaut sans adaptateur de base (« This is the default session strategy for Auth.js unless a database provider is configured »). Better Auth stocke les sessions en base par défaut, mais son `cookieCache` réintroduit le délai : « revoked sessions may remain active on other devices until the cookie cache expires » (résumé de l'outil de lecture).
- En code : « déconnexion de tous les appareils », désactivation de compte (ASVS 7.4.2) et changement de mot de passe (7.4.3) invalident-ils réellement les sessions existantes ? Si JWT : où est la liste de révocation ou le `tokensValidAfter` par utilisateur ?

### Vérifier un JWT avec une liste fermée d'algorithmes (jamais `none`, jamais l'algorithme choisi par l'en-tête), puis `exp`, `nbf`, `iss`, `aud`
- Niveau de preuve : N1 (RFC 8725, BCP 225) + N1 (ASVS)
- Source : Sheffer, Hardt, Jones, février 2020, « RFC 8725 — JSON Web Token Best Current Practices », https://www.rfc-editor.org/rfc/rfc8725.html ; OWASP ASVS 5.0.0, 2025, exigences 9.1.1 à 9.2.3, https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0_release/5.0/en/0x18-V9-Self-contained-Tokens.md
- Extrait lu : « [Libraries MUST enable the caller to specify a supported set of] algorithms and MUST NOT use any other algorithms when performing cryptographic operations. » (RFC 8725 § 3.1, début de phrase reconstitué entre crochets d'après le résumé de l'outil) ; « The allowlist must include the permitted algorithms, ideally only either symmetric or asymmetric algorithms, and must not include the 'None' algorithm. If both symmetric and asymmetric must be supported, additional controls will be needed to prevent key confusion. » (ASVS 9.1.2, L1) ; « For example, for JWTs, the claims 'nbf' and 'exp' must be verified. » (9.2.1, L1)
- Portée / limites : la cheat sheet JWT cite des CVE récentes de confusion de clés dans des bibliothèques courantes (« CVE-2022-29217, Key confusion through non-blocklisted public key formats (PyJWT) », « CVE-2023-48223, JWT Algorithm Confusion in fast-jwt ») : utiliser une bibliothèque ne dispense pas de fixer l'algorithme et de la tenir à jour.
- En code : `jwt.decode(token, key)` sans `algorithms=[...]` (PyJWT) ; `jwt.verify(token, key)` sans `algorithms` (jsonwebtoken) ; `jose.jwtVerify` sans `issuer`/`audience` ; lecture de `jwt.decode()` (sans vérification) pour prendre une décision.

### Un secret HMAC ou de session vaut au moins 256 bits aléatoires (32 octets), pas « 32 caractères » ; jamais un mot de passe comme clé
- Niveau de preuve : N1 (RFC 8725) + N3
- Source : RFC 8725, § 3.5 (même URL) ; OWASP, « JSON Web Token Cheat Sheet » (même URL) ; Auth.js, s.d., « Deployment », https://authjs.dev/getting-started/deployment ; Better Auth, s.d., « Options », https://www.better-auth.com/docs/reference/options ; FastAPI, page JWT (même URL qu'au § 3)
- Extrait lu : « human-memorizable passwords MUST NOT be directly used as the key to a keyed-MAC algorithm such as "HS256". » (RFC 8725) ; « The secret must have at least the same size as the output (eg. 256, 384 and 512 bits respectively for HS256, HS384 and HS512). » et « The secret must have at least 160 bits of entropy. » (OWASP JWT CS) ; « It should be a cryptographically secure random string of at least 32 characters » avec « openssl rand -base64 33 » (Auth.js) ; « In production, if it's not set, it will throw an error. » et défaut de développement « better-auth-secret-12345678901234567890 » (Better Auth) ; « openssl rand -hex 32 » (FastAPI)
- Portée / limites : « 32 caractères » ne dit rien de l'entropie : 32 caractères hexadécimaux = 128 bits, sous les 160 bits du plancher OWASP et sous les 256 bits d'une clé HS256. `openssl rand -base64 32` (Better Auth) produit 32 octets = 256 bits (44 caractères) ; `openssl rand -hex 32` (FastAPI) aussi (64 caractères). Next.js accepte une clé de chiffrement des Server Actions de 16, 24 ou 32 octets et « generates 32-byte keys by default ». Je n'ai pas trouvé de longueur minimale imposée par Better Auth dans la page lue.
- En code : `AUTH_SECRET="changeme"`, une phrase lisible, le secret d'exemple de la doc, ou le même secret en préproduction et en production ; `.env.example` qui contient une vraie valeur.

### Exiger une réauthentification pour changer l'e-mail, le mot de passe ou le MFA, et proposer de fermer les autres sessions après
- Niveau de preuve : N1 (standard OWASP)
- Source : OWASP API Security Project, 2023, « API2:2023 Broken Authentication », https://api-security.owasp.org/editions/2023/en/0xa2-broken-authentication ; OWASP ASVS 5.0.0, 2025, exigences 7.5.1 et 7.4.3
- Extrait lu : « Require re-authentication for sensitive operations (e.g. changing the account owner email address/2FA phone number). » (API2) ; « Verify that the application requires full re-authentication before allowing modifications to sensitive account attributes which may affect authentication such as email address, phone number, MFA configuration, or other information used in account recovery. » (ASVS 7.5.1, L2)
- Portée / limites : ASVS 6.2.3 (L1) exige aussi que le changement de mot de passe demande l'ancien. Better Auth expose `revokeOtherSessions: true` sur `changePassword` (résumé de l'outil de lecture).
- En code : `PATCH /me { email }` accepté avec une simple session active ; changement de mot de passe sans `currentPassword`.

---

## 6. Limitation de débit et anti-abus

### Les endpoints d'authentification ont une protection anti-force-brute plus stricte que la limite générale, comptée par compte autant que par IP
- Niveau de preuve : N1 (standard OWASP) + N3
- Source : OWASP API Security Project, 2023, « API2:2023 Broken Authentication » (même URL) ; OWASP, « Authentication Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html ; OWASP, « Credential Stuffing Prevention Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Credential_Stuffing_Prevention_Cheat_Sheet.html
- Extrait lu : « This mechanism should be stricter than the regular rate limiting mechanisms on your APIs. » (API2) ; « The counter of failed logins should be associated with the account itself, rather than the source IP address, in order to prevent an attacker from making login attempts from a large number of different IP addresses. » (Authentication CS) ; « This may defeat both IP block-lists and rate limiting, as per IP request volume may remain relatively low, even on high volume attacks. » (Credential Stuffing CS)
- Portée / limites : le verrouillage de compte peut devenir un déni de service ciblé ; la cheat sheet le signale (« care must be taken to prevent it from being used to cause a denial of service by locking out other users' accounts ») et propose un verrouillage exponentiel. Better Auth : limite globale 100 requêtes / 10 s en production et règle plus stricte sur la connexion (« /sign-in/email : Is limited to 3 requests within 10 seconds. »), désactivée en développement ; rien d'équivalent relevé pour signup et reset dans la page lue.
- En code : un limiteur « par IP » seul sur `/login` ; aucune limite sur `/forgot-password`, `/verify-otp`, `/signup`.

### Ne pas lire l'IP client dans `X-Forwarded-For` sans savoir qui l'écrit, et ne pas stocker les compteurs en mémoire sur du serverless
- Niveau de preuve : N3
- Source : Better Auth, s.d. (consulté 09.11.2026), « Rate Limit », https://www.better-auth.com/docs/concepts/rate-limit
- Extrait lu : « By default, it reads the address from the X-Forwarded-For header. » ; « Clients can send this header themselves, so set up Better Auth for how requests reach your server » ; « By default, rate limit data is stored in memory, which may not be suitable for many use cases, particularly in serverless environments. »
- Portée / limites : vaut pour tout limiteur maison (Hono, route handlers, Node natif) : sur plusieurs instances ou fonctions éphémères, un compteur en mémoire est remis à zéro ou dupliqué. La même page indique que les appels serveur via `auth.api` ne sont pas limités (résumé de l'outil de lecture).
- En code : `req.headers['x-forwarded-for'].split(',')[0]` utilisé comme clé de limite ; `new Map()` comme stockage de compteurs dans un déploiement Vercel.

### Login, reset et signup répondent de la même façon (message, code HTTP, temps) qu'un compte existe ou non
- Niveau de preuve : N3 + N1 (ASVS 6.3.8, niveau 3)
- Source : OWASP, « Authentication Cheat Sheet » (même URL) ; OWASP, « Forgot Password Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Forgot_Password_Cheat_Sheet.html ; FastAPI, page JWT (même URL) ; OWASP ASVS 5.0.0, 2025, exigence 6.3.8, https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0_release/5.0/en/0x15-V6-Authentication.md
- Extrait lu : « Using any of the authentication mechanisms (login, password reset, or password recovery), an application must respond with a generic error message regardless of whether: » ; « Ensure that responses return in a consistent amount of time to prevent an attacker enumerating which accounts exist. This could be achieved by using asynchronous calls or by making sure that the same logic is followed, instead of using a quick exit method. » ; FastAPI : « When `authenticate_user` is called with a username that doesn't exist in the database, we still run `verify_password` against a dummy hash. »
- Portée / limites : l'ASVS classe cette exigence au niveau 3 seulement ; la cheat sheet reconnaît le coût UX et propose, quand le message générique est impossible (signup), de compter sur la limitation de débit et le CAPTCHA. Le code HTTP peut aussi trahir (« It may respond with a 200 for a positive result and a 403 for a negative result. »).
- En code : `if (!user) return 404` avant le hachage ; « Aucun compte avec cet e-mail » au reset ; e-mail de reset envoyé en synchrone seulement si le compte existe (écart de temps mesurable).

### Les en-têtes `RateLimit` / `RateLimit-Policy` sont encore un brouillon IETF, et n'imposent aucun algorithme
- Niveau de preuve : N1 en cours (Internet-Draft, sans valeur normative)
- Source : IETF httpapi WG, 23 mai 2026, « draft-ietf-httpapi-ratelimit-headers-11 », https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers/ et https://datatracker.ietf.org/doc/html/draft-ietf-httpapi-ratelimit-headers-11
- Extrait lu : « This document defines the RateLimit-Policy and RateLimit HTTP header fields for servers to advertise their quota policies » ; « This specification does not mandate a specific throttling algorithm. »
- Portée / limites : statut « Active Internet-Draft », expire le 24 novembre 2026 ; pas un RFC. Le texte précise que ces champs ne servent pas au contrôle d'accès. Le choix token bucket / fenêtre glissante n'est tranché par aucune source lue : c'est une décision d'implémentation.
- En code : exposer le quota restant sur `/login` aide l'attaquant à calibrer ; rien n'oblige à l'exposer. Ne pas écrire « conforme RFC RateLimit ».

---

## 7. CSRF, CORS, SSRF

### Contre le CSRF : la protection du framework d'abord, `SameSite` explicite, et aucune mutation en GET
- Niveau de preuve : N3
- Source : OWASP, « Cross-Site Request Forgery Prevention Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html ; Vercel, « Server Actions and Mutations », https://nextjs.org/docs/app/guides/server-actions
- Extrait lu : « First, check if your framework has built-in CSRF protection and use it » ; « If any state-changing operation in the application is reachable via a GET request, SameSite=Lax will not stop it. » ; « Chromium-based browsers treat cookies without a SameSite attribute as Lax, but Firefox and Safari do not » ; Next.js : « The request's `Origin` is compared to the `Host` (or `X-Forwarded-Host`). Mismatches are rejected. »
- Portée / limites : la protection Origin/Host de Next.js couvre les Server Actions, pas les route handlers `POST` que vous écrivez vous-même (non documenté comme couvert dans les pages lues). OWASP accepte les en-têtes Fetch Metadata (`Sec-Fetch-Site`) pour les navigateurs modernes.
- En code : un `GET /api/logout` ou `GET /api/items/:id/delete` ; un `route.ts` POST authentifié par cookie sans vérification d'origine ni jeton ; un cookie de session sans `SameSite` explicite.

### CORS : liste fermée d'origines ; ne jamais renvoyer l'`Origin` reçu sans contrôle ; CORS n'est pas une protection CSRF
- Niveau de preuve : N3
- Source : OWASP, « HTML5 Security Cheat Sheet », section Cross Origin Resource Sharing, https://cheatsheetseries.owasp.org/cheatsheets/HTML5_Security_Cheat_Sheet.html
- Extrait lu : « Allow only selected, trusted domains in the Access-Control-Allow-Origin header. Prefer allowing specific domains over blocking or allowing any domain (do not use * wildcard nor blindly return the Origin header content without any checks). » ; « Don't rely only on the Origin header for Access Control checks. Browser always sends this header in CORS requests, but may be spoofed outside the browser. »
- Portée / limites : la cheat sheet ne détaille pas `Access-Control-Allow-Credentials` (résumé de l'outil de lecture). Une API consommée seulement par la même origine n'a besoin d'aucun en-tête CORS.
- En code : `cors({ origin: true, credentials: true })` (Hono / Express), `Access-Control-Allow-Origin: ${req.headers.origin}` ; `allow_origins=["*"]` avec `allow_credentials=True` dans FastAPI.

### Tout `fetch` serveur vers une URL fournie par l'utilisateur (webhook, import, aperçu de lien) passe par une allowlist de schéma, hôte et port, sans suivre les redirections, avec contrôle de l'IP résolue
- Niveau de preuve : N1 (standard OWASP) + N3
- Source : OWASP API Security Project, 2023, « API7:2023 Server Side Request Forgery », https://api-security.owasp.org/editions/2023/en/0xa7-server-side-request-forgery ; OWASP ASVS 5.0.0, exigences 1.3.6 et 15.3.2 ; OWASP, « Server Side Request Forgery Prevention Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html
- Extrait lu : « Disable HTTP redirections. » et « Use a well-tested and maintained URL parser to avoid issues caused by URL parsing inconsistencies. » (API7) ; « Verify that where the application backend makes calls to external URLs, it is configured to not follow redirects unless it is intended functionality. » (ASVS 15.3.2) ; « the application must be able to detect, at the code level, that the provided IP (V4 + V6) is not part of the official private networks ranges including also localhost and IPv4/v6 Link-Local addresses. » (cheat sheet, cas « ANY external IP »)
- Portée / limites : quand l'allowlist est impossible (webhooks clients), la cheat sheet signale la difficulté et le risque de résolution DNS (« It can be used by an attacker to bind a legit domain name to an internal IP address. ») et cite le vol de crédits des services de métadonnées cloud. `fetch()` de Node suit les redirections par défaut (comportement du standard Fetch ; non vérifié dans la doc Node lors de cette recherche).
- En code : `await fetch(body.webhookUrl)` sans option `redirect: 'manual'` ni validation ; contrôle de l'hôte sur la chaîne puis résolution DNS séparée au moment de l'appel (fenêtre de rebinding).

---

## 8. Injection SQL

### Valeurs : toujours en paramètres liés ; identifiants (table, colonne, tri) : choisis dans une table fermée côté serveur ; échappement manuel interdit
- Niveau de preuve : N1 (ASVS) + N3
- Source : OWASP ASVS 5.0.0, 2025, exigence 1.2.4, https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0_release/5.0/en/0x10-V1-Encoding-and-Sanitization.md ; OWASP, « SQL Injection Prevention Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html
- Extrait lu : « Verify that data selection or database queries (e.g., SQL, HQL, NoSQL, Cypher) use parameterized queries, ORMs, entity frameworks, or are otherwise protected from SQL Injection and other database injection attacks. This is also relevant when writing stored procedures. » (1.2.4, L1) ; « for structural parts that cannot be parameterized (table names, column names, sort direction), map user choices to a strict allow-list of fixed, application-owned values. » ; « Do not manually escape untrusted values to construct SQL queries. Use parameterized queries instead. »
- Portée / limites : la cheat sheet rappelle que les procédures stockées et les langages de requête d'ORM peuvent eux-mêmes être injectables ; vaut pour les fonctions plpgsql de Supabase (`EXECUTE ... USING`, `format('%I', ...)` sont cités).
- En code : `orderBy: { [req.query.sort]: 'asc' }` sans liste fermée ; `EXECUTE 'SELECT ... ' || param` dans une fonction SQL.

### Prisma : `$queryRaw` en gabarit balisé seulement ; `$queryRawUnsafe` et `Prisma.raw` sont les points d'injection. SQLAlchemy : `text()` avec `:param`, jamais une f-string
- Niveau de preuve : N3
- Source : Prisma, s.d. (consulté 09.11.2026), « Raw queries », https://www.prisma.io/docs/orm/prisma-client/using-raw-sql/raw-queries ; SQLAlchemy, 2.0, « Working with Transactions and the DBAPI » (encadré « Always use bound parameters »), https://docs.sqlalchemy.org/en/20/tutorial/dbapi_transactions.html ; SQLAlchemy 2.0, « Column Elements and Expressions » (`text()`), https://docs.sqlalchemy.org/en/20/core/sqlelement.html
- Extrait lu : Prisma (extraits relevés par l'outil de lecture) : « If you use this method with user inputs... then you open up the possibility for SQL injection attacks. » ; « Another way to make these methods vulnerable is misuse of the `Prisma.raw` function. » ; SQLAlchemy : « when using textual SQL, a Python literal value, even non-strings like integers or dates, should never be stringified into SQL string directly; a parameter should always be used. This is most famously known as how to avoid SQL injection attacks when the data is untrusted. » ; « t = text("SELECT * FROM users WHERE id=:user_id") »
- Portée / limites : la référence de `text()` elle-même ne porte pas d'avertissement d'injection (seul `extract()` a « DO NOT PASS UNTRUSTED INPUT TO THIS STRING. » dans la page lue) : l'avertissement est dans le tutoriel. Un gabarit `$queryRaw` construit par concaténation avant l'appel perd sa protection.
- En code : grep `\$queryRawUnsafe|\$executeRawUnsafe|Prisma\.raw\(` et `text\(f"` / `text\(".*" *%` / `text\(.*\.format\(` ; chaque occurrence demande une justification.

### Avec Supabase, la clé secrète (ex-`service_role`) contourne toutes les policies RLS : elle ne sert que côté serveur et n'est jamais une façon de « faire marcher » une requête refusée
- Niveau de preuve : N3
- Source : Supabase, s.d. (consulté 09.11.2026), « API keys », https://supabase.com/docs/guides/api/api-keys
- Extrait lu (extraits relevés par l'outil de lecture) : « A secret key bypasses every Row Level Security policy you have. » ; « Never put one in a browser, a shipped application, or source control. » ; « Row Level Security decides what this client can reach, so enable it on every table before you deploy. »
- Portée / limites : côté serveur, une requête faite avec la clé secrète doit refaire en code le contrôle d'autorisation que la RLS aurait fait (retour au § 1, BOLA).
- En code : `createClient(url, SERVICE_ROLE_KEY)` dans un handler qui agit pour un utilisateur sans filtre `owner_id` ; variable `NEXT_PUBLIC_*` contenant une clé secrète.

---

## 9. OAuth 2.0 / 2.1

### Client OAuth : code d'autorisation + PKCE (S256) ; pas de grant implicite ni de grant mot de passe ; redirect_uri comparée à l'identique
- Niveau de preuve : N1 (RFC 9700, BCP 240)
- Source : Lodderstedt, Bradley, Labunets, Fett, janvier 2025, « RFC 9700 — Best Current Practice for OAuth 2.0 Security », https://www.rfc-editor.org/rfc/rfc9700.html
- Extrait lu : « Public clients MUST use PKCE [RFC7636] to this end » ; « For confidential clients, the use of PKCE [RFC7636] is RECOMMENDED » ; « Currently, S256 is the only such method. » ; « Authorization servers MUST support PKCE [RFC7636]. » ; « clients SHOULD NOT use the implicit grant (response type token) » ; « The resource owner password credentials grant [RFC6749] MUST NOT be » [used] ; « authorization servers MUST utilize exact string matching except for port numbers in localhost redirection URIs of native apps »
- Portée / limites : « PKCE obligatoire » n'est vrai au sens MUST que pour les clients publics ; pour une application Next.js (client confidentiel), c'est RECOMMENDED. OAuth 2.1 n'est pas publié : draft-ietf-oauth-v2-1-17 (31 octobre 2026), « Active Internet-Draft », état « WG Document » (https://datatracker.ietf.org/doc/draft-ietf-oauth-v2-1/). Les jetons de rafraîchissement des clients publics : « MUST be sender-constrained or use refresh token rotation » (résumé de l'outil de lecture).
- En code : un fournisseur OAuth configuré sans `checks: ['pkce', 'state']` ou équivalent ; un flux « login par mot de passe » vers un IdP tiers via `grant_type=password`.

---

## 10. Journaux, erreurs, ordre dans le handler

### Ne jamais journaliser mots de passe, jetons ou secrets ; un identifiant de session se journalise haché ; les PII sensibles masquées
- Niveau de preuve : N1 (ASVS) + N3
- Source : OWASP, « Logging Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html ; OWASP ASVS 5.0.0, 2025, exigences 16.2.5 et 16.5.1, https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0_release/5.0/en/0x25-V16-Security-Logging-and-Error-Handling.md
- Extrait lu : « The following should usually not be recorded directly in the logs, but instead should be removed, masked, sanitized, hashed, or encrypted: » suivi notamment de « Session identification values (consider replacing with a hashed value if needed to track session specific events) », « Access tokens », « Authentication passwords », « Database connection strings » ; ASVS 16.2.5 : « it may not be allowed to log certain data, such as credentials or payment details. Other data, such as session tokens, may only be logged by being hashed or masked, either in full or partially. » ; 16.5.1 : « a generic message is returned to the consumer when an unexpected or security-sensitive error occurs, ensuring no exposure of sensitive internal system data such as stack traces, queries, secret keys, and tokens. »
- Portée / limites : la cheat sheet Input Validation ajoute : « Record the failure and relevant metadata without secrets or full request bodies. » ASVS 16.3.2 demande de journaliser les échecs d'autorisation (L2).
- En code : `console.log(req.body)` sur `/login` ou `/signup` ; `logger.error(err)` où `err` contient la requête SQL ou l'en-tête `Authorization` ; une réponse 500 qui renvoie `err.message` de Prisma.

### Ordre dans le handler : borne de taille → authentification → validation du schéma → autorisation sur l'objet → métier → réponse filtrée
- Niveau de preuve : N3 (assemblage de sources ; aucune source lue ne prescrit cet ordre en une phrase)
- Source : OWASP, « Input Validation Cheat Sheet » (même URL) ; Vercel, « Server Actions and Mutations » et « Data Security » (mêmes URL) ; FastAPI, code source `fastapi/dependencies/utils.py` et `fastapi/routing.py`, branche master lue le 09.11.2026, https://raw.githubusercontent.com/fastapi/fastapi/master/fastapi/dependencies/utils.py
- Extrait lu : « Apply request size limits before buffering or parsing input, and configure parser limits such as maximum nesting depth. » et « A schema check after parsing cannot protect a parser that has already exhausted resources. » (OWASP) ; tous les exemples Next.js lus commencent par `const session = await auth()` puis `if (!session?.user) throw new Error('Unauthorized')` avant tout usage de l'entrée, et la liste « Inside every action » place « Authenticate and authorize » avant « Validate inputs » ; FastAPI : dans `solve_dependencies`, les dépendances sont appelées (`solved = await call(**solved_result.values)`, l. 731) avant la validation du corps (`await request_body_to_args(`, l. 762), le JSON étant décodé avant (`json_body = await request.json()`, `routing.py` l. 464).
- Portée / limites : l'autorisation au niveau objet a besoin d'un identifiant déjà validé, d'où la séparation authentification (avant) / autorisation objet (après validation). Exceptions : login, signup, reset n'ont pas d'authentification ; la limitation de débit y vient en premier. Ni OWASP ni l'ASVS ne fixent d'ordre ; c'est une convention défendable, cohérente avec la doc Next.js et le comportement réel de FastAPI.
- En code : un handler protégé qui parse et valide un gros corps (ou appelle un service coûteux) avant de savoir si l'appelant est authentifié ; un message 422 détaillé renvoyé à un appelant anonyme sur une route protégée.

---

## Verdict sur les règles du profil

| Règle du profil | Verdict | Motif sourcé |
|---|---|---|
| « Validation runtime obligatoire sur tout input externe. » | **Soutenue** | ASVS 5.0 2.2.1 (L1 pour les entrées qui fondent une décision, L2 pour toutes) et 2.2.2 (côté serveur) ; Next.js « You should always validate input from client ». À compléter : borne de taille avant parsing (Input Validation CS) et « Schema validation (zod or similar) only checks the *shape* » (Next.js) — la validation ne remplace ni l'autorisation ni les requêtes paramétrées. |
| « Auth check explicite sur chaque endpoint protégé. » | **Soutenue, à préciser** | API1/API5:2023, Authorization CS « Permission should be validated correctly on every request », ASVS 8.2.1/8.2.2 (L1), Next.js. Précision : authentification ≠ autorisation ; il faut le contrôle de propriété sur l'objet (BOLA) et de rôle sur la fonction (BFLA), deny by default. |
| « Jamais de raw SQL avec interpolation — paramètres préparés ou ORM. » | **Soutenue** | ASVS 1.2.4 (L1), SQL Injection CS, Prisma (`$queryRawUnsafe`, `Prisma.raw`), SQLAlchemy « Always use bound parameters ». Précision : les identifiants (tri, colonne) ne se paramètrent pas → liste fermée ; les API brutes des ORM sont le lieu réel du risque. |
| « Jamais de hash artisanal — bcrypt/argon2 (coût >= 10). Stack zéro-dépendance : PBKDF2/scrypt natifs, itérations élevées, sel aléatoire par entrée. Jamais MD5/SHA brut. » | **À préciser** | Le fond est soutenu (Password Storage CS, ASVS 11.4.2, NIST 800-63B-4 sel ≥ 32 bits). Mais : OWASP classe bcrypt « For legacy systems » et met Argon2id en premier (19 MiB, t=2, p=1) ; « coût >= 10 » ne vaut que pour bcrypt ; « itérations élevées » est flou → PBKDF2-HMAC-SHA256 ≥ 600 000 ; scrypt Node par défaut N=16384 < 2^17 OWASP, et `maxmem` doit être relevé ; `crypto.argon2` natif depuis Node 24.7.0 ; limite bcrypt de 72 octets à borner. |
| « Tout secret / clé de session en prod : >= 32 caractères aléatoires (AUTH_SECRET), entropie réelle. » | **À préciser** | Auth.js dit bien « at least 32 characters », mais 32 caractères hex = 128 bits. OWASP JWT CS : secret HMAC ≥ taille de sortie (256 bits pour HS256) et ≥ 160 bits d'entropie ; RFC 8725 § 3.5 : pas de mot de passe comme clé. Formuler « ≥ 32 octets (256 bits) d'un CSPRNG, ex. `openssl rand -base64 32` ». ASVS 13.3.1 : secrets hors du code source et des artefacts. |
| « Jamais de log de password/token/PII complet. » | **Soutenue, à préciser** | Logging CS et ASVS 16.2.5. Précision : un mot de passe ne se journalise ni complet ni partiel ; un jeton de session seulement haché ou masqué ; jamais le corps entier d'une requête d'auth ; erreurs génériques au client (16.5.1). |
| « Rate limiting sur endpoints publics (login, signup, reset password). » | **Soutenue, à préciser** | API2/API4:2023, Authentication CS, NIST 800-63B-4 (≤ 100 échecs consécutifs par compte). Précision : plus strict que la limite générale ; compteur par compte en plus de l'IP (credential stuffing distribué) ; couvrir aussi OTP/2FA et vérification d'e-mail ; IP non falsifiable ; stockage partagé en serverless. |
| « Auth : Auth.js / Supabase Auth. Jamais de JWT maison. » | **Soutenue au sens « ne pas implémenter », à préciser** | API2:2023 « Don't reinvent the wheel in authentication, token generation, or password storage. Use the standards. » ; RFC 8725 ; CVE de confusion de clés même dans des bibliothèques. Précision : « JWT maison » doit viser la signature/vérification artisanale et la session JWT sans révocation (ASVS 7.4.1, Auth.js « Expiring a JSON Web Token before its encoded expiry is not possible ») ; le tutoriel officiel FastAPI émet lui-même ses JWT avec PyJWT et `algorithms=[...]` fixé — cas acceptable. Auth.js en stratégie JWT par défaut : prévoir la révocation. |
| Anti-pattern : « Renvoyer toute l'entité User (incluant passwordHash) en réponse. » | **Soutenue** | API3:2023 (« Keep returned data structures to the bare minimum »), ASVS 15.3.1 (L1), Next.js « Only return what the UI needs, not raw database records ». |
| Ordre : « validation → auth → métier → réponse » | **Contredite / à préciser** | Aucune source lue ne prescrit d'ordre, mais toutes les sources lues placent l'authentification avant l'usage de l'entrée : exemples Next.js (`auth()` en première ligne, « Authenticate and authorize » avant « Validate inputs ») ; FastAPI exécute les dépendances d'auth avant la validation Pydantic du corps. OWASP exige la borne de taille avant le parsing. Ordre recommandé : borne de taille / rate limit → authentification → validation → autorisation sur l'objet → métier → réponse filtrée. |

---

## Mythes et affirmations contestées

- **« SameSite=Lax est le défaut, donc le CSRF est réglé. »** La doc Next.js écrit « particularly with SameSite cookies being the default » (https://nextjs.org/docs/app/guides/data-security). La cheat sheet CSRF d'OWASP la contredit en partie : « Chromium-based browsers treat cookies without a SameSite attribute as Lax, but Firefox and Safari do not », et Lax ne protège pas une mutation en GET. Toujours fixer `SameSite` explicitement.
- **« bcrypt est le choix par défaut. »** Plus dans la cheat sheet OWASP : bcrypt est désormais présenté « For legacy systems », Argon2id d'abord, scrypt ensuite, PBKDF2 pour FIPS.
- **« PBKDF2/scrypt natifs suffisent tels quels. »** Faux avec les valeurs par défaut de Node : scrypt N=16384 (2^14) contre 2^17 minimum OWASP ; PBKDF2 n'a pas de valeur par défaut et les exemples courants sont très en dessous de 600 000.
- **« Un secret de 32 caractères = 256 bits. »** Seulement si chaque caractère porte 8 bits d'entropie, ce qui n'arrive jamais avec un secret imprimable. 32 caractères hex = 128 bits ; `openssl rand -base64 32` = 44 caractères pour 256 bits.
- **« Il faut 8 caractères minimum et des caractères spéciaux. »** NIST SP 800-63B-4 (final juillet 2025) : 15 minimum en facteur unique, aucune règle de composition, aucune rotation forcée. L'ASVS 5.0 garde 8 minimum mais « strongly recommended » 15.
- **« PKCE est obligatoire pour tous les clients OAuth. »** RFC 9700 : MUST pour les clients publics, RECOMMENDED pour les confidentiels. Le serveur d'autorisation, lui, MUST le supporter. OAuth 2.1 n'est pas un RFC (draft-17, octobre 2026).
- **« Des UUID rendent l'IDOR impossible. »** Défense en profondeur seulement (IDOR CS ; ASVS 11.5.1 : les UUID n'ont pas 128 bits d'entropie de secret).
- **« Le MFA stoppe 99,9 % des compromissions. »** Chiffre attribué à Microsoft et repris par la cheat sheet Credential Stuffing (« analysis by Microsoft suggesting that it would have stopped 99.9% of account compromises ») ; source primaire non ouverte, méthode non vérifiée — à citer comme affirmation d'un éditeur (N4), pas comme mesure.
- **« Les en-têtes RateLimit sont standardisés. »** Brouillon IETF actif (draft-11, mai 2026), pas un RFC.
- **« Le message d'erreur générique au login est universellement obligatoire. »** OWASP le demande ; l'ASVS 5.0 le classe au niveau 3 (6.3.8) et la cheat sheet admet l'arbitrage UX quand le message générique est impossible (signup), compensé par la limitation de débit.

---

## Non vérifié

- Paramètres scrypt exacts de Better Auth (N, r, p) : non lus.
- Longueur minimale de `BETTER_AUTH_SECRET` imposée ou avertie par Better Auth : rien trouvé dans la page « Options » lue.
- Stabilité (experimental / stable) de `crypto.argon2` dans Node : aucun marqueur propre relevé dans la doc de la branche main ; version LTS qui l'embarque non vérifiée au-delà de « added: v24.7.0 ».
- Plafond de taille de corps par défaut des route handlers Next.js et de Hono : non vérifié (seul le 1 MB des Server Actions est lu).
- Comportement de `fetch()` de Node vis-à-vis des redirections (suit par défaut ?) : non vérifié dans la doc Node lors de cette recherche.
- Page détaillée API9:2023 (inventaire) et API8 (mauvaise configuration) : non ouvertes ; seul le résumé de la liste a été lu.
- Annexe B de SP 800-63B-4 (syncable authenticators) : non lue en entier ; l'équivalence « syncable authenticator = passkey synchronisée » est une lecture, le mot « passkey » n'étant pas dans la page.
- Durée de validité par défaut des jetons de reset de mot de passe de Better Auth, et protection anti-énumération sur son reset : non documentées dans la page lue.
- Source primaire Microsoft du chiffre « 99,9 % » : non ouverte.
- Algorithmes de limitation (token bucket, fenêtre glissante) : aucune source primaire normative trouvée qui en recommande un ; laissés à l'implémentation par le brouillon IETF.

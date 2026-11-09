# Fiche `ux-preuves` — Backend — fiabilité et contrats d'API

> Fiche du skill `ux-preuves` (dev-fullstack), volet **backend**, préchargé par `backend`. Couvre : timeouts, retries, backoff et jitter, budgets de retries, défaillances métastables, gestion d'erreur et pannes réelles (Yuan et al. 2014), idempotence et clés d'idempotence, outbox et webhooks, codes HTTP et Problem Details (RFC 9110, 9457), pagination et bornage, temps réel (SSE, WebSocket, polling), tâches de fond.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Versions, statuts de brouillons IETF et API
> **vieillissent en mois** ; le droit change par révision : avant d'écrire du code qui en dépend,
> relire la page officielle (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Rédigé le 9 novembre 2026 pour le référentiel d'un agent « backend engineer senior » (Next.js route handlers / Hono / FastAPI, Postgres ou Supabase, appels sortants vers des API tierces).
> Méthode : chaque entrée s'appuie sur une page **réellement téléchargée et lue** (curl + extraction texte, `pdftotext` pour les PDF) le 9 novembre 2026. Les extraits sont copiés depuis le texte téléchargé. Quand une URL redirige, la cible est indiquée.
> Échelle : N1 norme/RFC/standard ; N2 recherche revue par pairs ou étude empirique (échantillon cité) ; N3 documentation ou guide officiel d'une plateforme ; N4 avis d'expert, article de praticien.

---

## 1. Timeouts, retries, backoff et jitter

### Tout appel distant porte un timeout explicite, connexion ET requête, calé sur la latence observée du dépendant
- Niveau de preuve : N4 (retour d'expérience Amazon, sans données publiées)
- Source : Marc Brooker (page signée « Marc », AWS), 2019 (publiée le 5 déc. 2019), « Timeouts, retries, and backoff with jitter », https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/ (redirige vers https://builder.aws.com/content/3EumjoZascWd1oZiEgL8ORlv3qE/timeouts-retries-and-backoff-with-jitter)
- Extrait lu : « A best practice in Amazon is to set a timeout on any remote call, and generally on any call across processes even on the same box. This includes both a connection timeout and a request timeout. » ; « we choose an acceptable rate of false timeouts (such as 0.1%). Then, we look at the corresponding latency percentile on the downstream service (p99.9 in this example). »
- Portée / limites : méthode de calibrage (p99.9 pour 0,1 % de faux timeouts) donnée pour des appels intra-région AWS ; l'auteur signale lui-même qu'elle échoue quand p99.9 ≈ p50 (ajouter une marge) et que certains timeouts ne couvrent ni le DNS ni la poignée de main TLS. Aucune valeur chiffrée universelle.
- En code : chaque `fetch`/client SDK sortant a-t-il un timeout explicite ? Sa valeur est-elle justifiée par une latence mesurée du tiers, ou recopiée ?

### Ne pas se fier au timeout par défaut du client HTTP : il n'est pas un délai de bout en bout
- Niveau de preuve : N3 (documentation officielle de la bibliothèque)
- Source : projet Node.js undici, document « Client » (branche main, lu le 09.11.2026), https://raw.githubusercontent.com/nodejs/undici/main/docs/docs/api/Client.md ; complément MDN, « AbortSignal: timeout() static method », https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal/timeout_static
- Extrait lu : « `bodyTimeout` … Monitors the time between consecutive body chunks. … **Default:** `300e3`. » ; « `headersTimeout` … **Default:** `300e3`. » ; « `connectTimeout` … **Default:** `10e3`. » — MDN : « The timeout is based on active rather than elapsed time »
- Portée / limites : valeurs par défaut d'undici (5 min pour les en-têtes, 5 min **entre deux morceaux** de corps, 10 s de connexion). Que le `fetch` global de Node hérite exactement de ces défauts n'a **pas** été vérifié ici. Un corps qui goutte un octet toutes les 4 min ne déclenche jamais `bodyTimeout`.
- En code : chercher un `AbortSignal.timeout(ms)` (ou équivalent httpx/`timeout=` en FastAPI) sur chaque appel sortant ; refuser un appel vers un tiers de paiement ou d'e-mail sans borne totale.

### Ne réessayer qu'à un seul niveau de la pile, et seulement les erreurs réessayables
- Niveau de preuve : N4 (livre de praticiens Google ; exemple chiffré illustratif)
- Source : Mike Ulrich (dir. Beyer et al.), 2016, « Addressing Cascading Failures », Site Reliability Engineering, https://sre.google/sre-book/addressing-cascading-failures/
- Extrait lu : « If the database can't service requests because it's overloaded, and the backend, frontend, and JavaScript layers all issue 3 retries (4 attempts), then a single user action may create 64 attempts (4^3) on the database. » ; « Don't retry permanent errors or malformed requests in a client, because neither will ever succeed. Return a specific status when overloaded so that clients and other layers back off and do not retry. »
- Portée / limites : Brooker (2019, même page que ci-dessus) donne le même calcul avec 5 niveaux × 3 essais : « the load on the database will increase 243x » et conclut « our best practice is to retry at a single point in the stack ». Calculs de borne supérieure, pas des mesures. Le livre est daté de 2016 (année d'édition, non affichée sur la page lue).
- En code : le SDK du tiers réessaie-t-il déjà (Stripe SDK, AWS SDK) pendant que notre code l'enveloppe dans un `retry()` maison et que le client front réessaie aussi ? Compter les couches.

### Backoff exponentiel plafonné ET jitter ; le backoff sans jitter garde les rafales
- Niveau de preuve : N4 (simulation d'auteur, non revue)
- Source : Marc Brooker, 2015 (04 MAR 2015, mise à jour mai 2023), « Exponential Backoff And Jitter », AWS Architecture Blog, https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/
- Extrait lu : « The no-jitter exponential backoff approach is the clear loser. It not only takes more work, but also takes more time than the jittered approaches. » ; « In the case with 100 contending clients, we've reduced our call count by more than half. »
- Portée / limites : simulation d'écritures concurrentes en contrôle optimiste (OCC) sur une même ligne, délai réseau simulé (moyenne 10 ms). « Full Jitter » fait le moins de travail, « Decorrelated » un peu moins de temps ; l'auteur précise que ces approches ne changent pas la nature en N² du travail. Le chapitre SRE cité plus haut renvoie à ce billet (« Always use randomized exponential backoff when scheduling retries »).
- En code : la boucle de retry a-t-elle un plafond de délai, un nombre maximal d'essais et une composante aléatoire (`random(0, min(cap, base*2^n))`) ? Les crons (`0 * * * *`) de plusieurs instances tapent-ils le même tiers à la même seconde ? Brooker (2019, entrée 1) étend le jitter aux tâches planifiées : « we consider adding some jitter to all timers, periodic jobs, and other delayed work », de préférence déterministe par hôte pour garder les incidents reproductibles.

### Borner les retries par un budget : par requête ET par client (ou par processus)
- Niveau de preuve : N4 (pratique Google décrite, sans protocole de mesure publié)
- Source : Alejandro Forero Cuervo (éd. Sarah Chavis), 2016, « Handling Overload », Site Reliability Engineering, https://sre.google/sre-book/handling-overload/
- Extrait lu : « we implement a per-request retry budget of up to three attempts » ; « A request will only be retried as long as this ratio is below 10%. » ; « layering on the per-client retry budget (a 10% retry ratio) reduces the growth to just 1.1x in the general case—a significant improvement. »
- Portée / limites : chiffres de l'infrastructure Google (3 tentatives, 10 %). Le chapitre « Addressing Cascading Failures » propose une variante par processus (« only allow 60 retries per minute in a process »). Brooker (2019) obtient le même effet avec un seau à jetons local (« AWS added this behavior to the AWS SDK in 2016 »).
- En code : existe-t-il un compteur partagé (seau à jetons, ratio) qui coupe les retries quand le tiers est massivement en échec, ou chaque requête réessaie-t-elle indépendamment ?

### Propager une échéance (deadline) et abandonner le travail dont le client n'attend plus le résultat
- Niveau de preuve : N4
- Source : Mike Ulrich, 2016, « Addressing Cascading Failures », https://sre.google/sre-book/addressing-cascading-failures/
- Extrait lu : « Rather than inventing a deadline when sending RPCs to backends, servers should employ deadline propagation. » ; « Having deadlines several orders of magnitude longer than the mean request latency is usually bad. »
- Portée / limites : rédigé pour des RPC internes Google ; transposable à une route handler qui appelle plusieurs tiers en série (le budget de temps restant se passe à l'appel suivant). L'exemple chiffré (19,6 % de requêtes servies, 80,4 % d'erreurs avec un délai de 100 s) est un calcul illustratif.
- En code : une route qui enchaîne trois appels sortants a-t-elle trois timeouts fixes de 30 s chacun, ou un budget global décrémenté ? Le travail est-il annulé (`AbortController`) quand le client HTTP s'est déconnecté ?

### Honorer `Retry-After` et répondre 429 / 503 avec un délai quand on limite soi-même
- Niveau de preuve : N1 (RFC 9110 et RFC 6585, Standards Track) ; N3 pour la règle Zalando
- Source : Fielding, Nottingham, Reschke, 2022, RFC 9110 « HTTP Semantics », §10.2.3 et §15.6.4, https://www.rfc-editor.org/rfc/rfc9110.txt ; Nottingham, Fielding, 2012, RFC 6585 « Additional HTTP Status Codes », §4, https://www.rfc-editor.org/rfc/rfc6585.txt
- Extrait lu : « Servers send the "Retry-After" header field to indicate how long the user agent ought to wait before making a follow-up request. » ; RFC 6585 : « The 429 status code indicates that the user has sent too many requests in a given amount of time ("rate limiting"). … MAY include a Retry-After header »
- Portée / limites : `Retry-After` est facultatif (MAY) pour 429 et 503. Zalando en fait une obligation interne (« APIs that wish to manage the request rate of clients must use the 429 (Too Many Requests) response code … Such responses must also contain header information », https://opensource.zalando.com/restful-api-guidelines/). Les en-têtes `X-RateLimit-*` sont une convention, pas une norme.
- En code : la boucle de retry lit-elle `Retry-After` (secondes **ou** date HTTP) avant d'appliquer son propre backoff ? Notre limiteur répond-il 429 avec ce champ, plutôt qu'un 500 ou un 400 ?

---

## 2. Défaillances métastables

### Les retries sont le premier mécanisme qui entretient une panne une fois le déclencheur disparu
- Niveau de preuve : N2 (OSDI 2022, revue par pairs ; 22 incidents publics de 11 organisations)
- Source : Lexiang Huang, Matthew Magnusson, Abishek Bangalore Muralikrishna, Salman Estyak, Rebecca Isaacs, Abutalib Aghayev, Timothy Zhu, Aleksey Charapko, 2022, « Metastable Failures in the Wild », OSDI '22, https://www.usenix.org/system/files/osdi22-huang-lexiang.pdf
- Extrait lu : « we present an in-depth study of 22 metastable failures from 11 different organizations » ; « at least 4 out of 15 major outages in the last decade at Amazon Web Services were caused by metastable failures » ; « By far, the most common sustaining effect is due to the retry policy, affecting more than 50% of the studied incidents »
- Portée / limites : rapports d'incidents publics, classés au jugement des auteurs (« we use our best judgment in identifying metastable failures »). Autres chiffres lus : ≈ 45 % des déclencheurs sont des erreurs d'ingénieurs (configuration, déploiement), ≈ 35 % des pics de charge ; pannes de 1,5 à 73,53 h. Échantillon de grandes plateformes, pas d'applications web modestes.
- En code : quand le tiers ralentit, nos retries multiplient-ils la charge qu'il reçoit (2× au minimum avec un seul retry) ? Le comportement « tiers indisponible » coupe-t-il les retries au lieu de les accélérer ?

### Un système peut fonctionner longtemps dans un état « vulnérable » ; en sortir exige de réduire fortement la charge ou de changer la politique de retry
- Niveau de preuve : N2 (HotOS 2021, atelier revu par pairs ; cadre conceptuel, exemples simplifiés, pas d'échantillon)
- Source : Nathan Bronson, Abutalib Aghayev, Aleksey Charapko, Timothy Zhu, 2021, « Metastable Failures in Distributed Systems », HotOS '21, https://sigops.org/s/conferences/hotos/2021/papers/hotos21-s11-bronson.pdf
- Extrait lu : « One of the most common failure-sustaining mechanisms is request retries. » ; « So long as latency is high, client queries will continue at 560 QPS due to retries. This will prevent the database from recovering. » ; « Leaving a metastable failure state requires a strong corrective push, such as rebooting the system or dramatically reducing the load. »
- Portée / limites : l'exemple (base qui sert 300 QPS, 280 QPS de charge, un retry après 1 s) est hypothétique ; Huang et al. précisent que les exemples de Bronson sont « simplified versions of failures observed at Facebook ». Les auteurs disent que la conception systématique contre ces pannes « remains an open problem ».
- En code : un retry déclenché par timeout (et non par erreur explicite) double la charge précisément quand le dépendant est lent ; vérifier qu'un tel retry passe par le budget.

---

## 3. Gestion d'erreur et pannes réelles

### 92 % des pannes catastrophiques étudiées viennent d'une erreur non fatale, signalée explicitement, puis mal traitée
- Niveau de preuve : N2 (OSDI 2014 ; 198 pannes tirées au hasard, dont 48 catastrophiques, dans 5 systèmes)
- Source : Ding Yuan, Yu Luo, Xin Zhuang, Guilherme Renna Rodrigues, Xu Zhao, Yongle Zhang, Pranay U. Jain, Michael Stumm, 2014, « Simple Testing Can Prevent Most Critical Failures: An Analysis of Production Failures in Distributed Data-Intensive Systems », OSDI '14, https://www.usenix.org/system/files/conference/osdi14/osdi14-paper-yuan.pdf
- Extrait lu : « Finding 10 Almost all catastrophic failures (92%) are the result of incorrect handling of non-fatal errors explicitly signaled in software. » ; « In all but one case, the errors were checked by the developers. »
- Portée / limites : **92 % des pannes catastrophiques** (48 sur 198, soit 24 %), pas de toutes les pannes ; seulement 25 % des pannes non catastrophiques impliquent une gestion d'erreur fautive. Systèmes : Cassandra, HBase, HDFS, Hadoop MapReduce, Redis, tickets « Blocker/Critical/Major » de 2010 et après. Ce ne sont pas des applications web ; la transposition est une analogie.
- En code : l'erreur est attrapée, mais que fait le bloc `catch` ? Le chemin d'erreur a-t-il été exécuté au moins une fois en test ?

### Refuser en revue trois motifs triviaux : `catch` vide ou qui ne fait que journaliser, sur-capture qui abat le service, `TODO`/`FIXME` dans un gestionnaire
- Niveau de preuve : N2 (même étude, mêmes 48 pannes catastrophiques)
- Source : Yuan et al., 2014, OSDI '14, https://www.usenix.org/system/files/conference/osdi14/osdi14-paper-yuan.pdf
- Extrait lu : « 35% of the catastrophic failures, the faults in the error handling code fall into three trivial patterns: (i) the error handler is simply empty or only contains a log printing statement, (ii) the error handler aborts the cluster on an overly-general exception, and (iii) the error handler contains expressions like "FIXME" or "TODO" in the comments. » ; « in 58% of the catastrophic failures, the underlying faults could easily have been detected through simple testing of error handling code. »
- Portée / limites : répartition de la figure 5 : erreurs ignorées 25 %, abandon sur sur-capture 8 %, « TODO » 2 % ; 23 % de plus « easily detectable » par couverture d'instructions. Les auteurs comptent un gestionnaire qui **se contente de journaliser** comme une erreur ignorée.
- En code : `catch (e) { console.error(e) }` puis poursuite comme si de rien n'était ; `except Exception: pass` ; `catch (Exception)` qui arrête tout. Exiger un test qui force l'erreur du tiers (timeout, 500, réponse malformée).

---

## 4. Idempotence

### Un GET (et toute méthode sûre) ne doit déclencher aucune action non sûre
- Niveau de preuve : N1 (RFC 9110, Internet Standard)
- Source : Fielding, Nottingham, Reschke, 2022, RFC 9110 « HTTP Semantics », §9.2.1, https://www.rfc-editor.org/rfc/rfc9110.txt
- Extrait lu : « If the purpose of such a resource is to perform an unsafe action, then the resource owner MUST disable or disallow that action when it is accessed using a safe request method. Failure to do so will result in unfortunate side effects when automated processes perform a GET on every URI reference for the sake of link maintenance, pre-fetching, building a search index, etc. »
- Portée / limites : la RFC tolère les effets de bord non demandés par le client (journaux d'accès, compteur publicitaire) : « the client did not request that additional behavior and cannot be held accountable for it ». L'interdiction vise l'action **demandée** via la méthode sûre.
- En code : `GET /api/unsubscribe?token=…`, `GET /confirm?...` qui écrivent en base ; le préchargement des liens (`<Link prefetch>`) ou un scanner de mails les déclencheront.

### Un client ne rejoue pas automatiquement une méthode non idempotente sans moyen de savoir qu'elle l'est
- Niveau de preuve : N1
- Source : RFC 9110, §9.2.2, https://www.rfc-editor.org/rfc/rfc9110.txt
- Extrait lu : « Of the request methods defined by this specification, PUT, DELETE, and safe request methods are idempotent. » ; « A client SHOULD NOT automatically retry a request with a non-idempotent method unless it has some means to know that the request semantics are actually idempotent, regardless of the method, or some means to detect that the original request was never applied. »
- Portée / limites : c'est la base normative de « retry uniquement sur idempotent » — et de son exception : un POST portant une clé d'idempotence devient rejouable. L'idempotence porte sur l'effet voulu, pas sur la réponse (« though the response might differ »).
- En code : un wrapper de retry générique appliqué à tous les `POST` sortants sans clé d'idempotence.

### Une clé d'idempotence côté serveur enregistre la réponse, compare les paramètres et a une fenêtre de rétention
- Niveau de preuve : N3 (documentation officielle Stripe)
- Source : Stripe, consultée le 09.11.2026, « Idempotent requests » (API Reference), https://docs.stripe.com/api/idempotent_requests ; « Low-level error handling », https://docs.stripe.com/error-low-level
- Extrait lu : « Stripe saves the status code and body of the first request made with a given idempotency key after endpoint execution begins. Retries with the same key return the saved response, including 500 errors. » ; « The idempotency layer compares incoming parameters to those of the original request and errors if they're not the same » ; « If a 409 indicates that another request with the same key is still executing, wait and retry with that key and the same parameters. »
- Portée / limites : décrit l'API v1 de Stripe (la v2 a sa propre page, non lue). Clés jusqu'à 255 caractères, conservées au moins 24 h ; pas de données personnelles dans la clé (« Avoid using sensitive data (for example, email addresses or personal identifiers) as idempotency keys »). Stripe traite un 500 comme indéterminé : « Don't retry with a new idempotency key until you've resolved the original outcome. »
- En code : côté **appelant** de Stripe, la clé est-elle générée une fois par opération métier et réutilisée à chaque retry (et non régénérée à chaque tentative) ? Côté **serveur**, notre endpoint de création stocke-t-il la réponse et refuse-t-il une même clé avec un corps différent ?

### Enregistrer la clé et effectuer les mutations dans la même opération atomique ; renvoyer une réponse sémantiquement équivalente
- Niveau de preuve : N4 (article de praticien AWS ; date non affichée sur la page lue)
- Source : Malcolm Featonby (AWS), « Making retries safe with idempotent APIs », Amazon Builders' Library, https://aws.amazon.com/builders-library/making-retries-safe-with-idempotent-APIs/
- Extrait lu : « the process that combines recording the idempotent token and all mutating operations related to servicing the request must meet the properties for an atomic, consistent, isolated, and durable (ACID) operation. » ; « we return a validation error indicating a parameter mismatch between idempotent requests. »
- Portée / limites : l'auteur écarte la déduplication par empreinte des paramètres : deux lancements EC2 identiques peuvent être voulus (« It's possible that the caller actually wants two identical EC2 instances »). Il déconseille de répondre « ResourceAlreadyExists » à un retry, ce qui force l'appelant à gérer un cas qu'il n'a pas provoqué. Rétention : durée de vie de la ressource plus un intervalle.
- En code : la ligne `idempotency_keys` est-elle écrite dans la même transaction que la commande ? Une contrainte `UNIQUE` « naturelle » (même montant, même client) bloquerait-elle un doublon légitime ?

### Découper un endpoint en phases atomiques locales, séparées par chaque mutation d'état « étranger »
- Niveau de preuve : N4 (article de praticien, ancien ingénieur Stripe)
- Source : Brandur Leach, 2017 (27 oct. 2017), « Implementing Stripe-like Idempotency Keys in Postgres », https://brandur.org/idempotency-keys
- Extrait lu : « once we make our first foreign state mutation, we're committed one way or another » ; « Atomic phases should be safely committed before initiating any foreign state mutation. If the call fails, our local state will still have a record of it happening that we can use to retry the operation. »
- Portée / limites : implémentation de référence en Ruby/Postgres (points de reprise `recovery_point`, table `staged_jobs`). L'auteur inclut les appels internes (« even foreign calls within your own infrastructure count! … emitting records to Kafka »). Article de 2017 ; pas de mesure.
- En code : repérer chaque appel sortant au milieu d'un handler et demander : si le processus meurt juste après cet appel, que reste-t-il en base pour reprendre ?

### L'en-tête `Idempotency-Key` est un brouillon IETF actif, pas un standard : ne pas le présenter comme normatif
- Niveau de preuve : hors échelle — brouillon IETF du groupe httpapi (N1 visé, non atteint)
- Source : J. Jena, S. Dalal, D. Tishkin, version -08 du 22.10.2026, « The Idempotency-Key HTTP Header Field », https://datatracker.ietf.org/doc/draft-ietf-httpapi-idempotency-key-header/
- Extrait lu : page Datatracker : « Active Internet-Draft (httpapi WG) » ; « IESG state I-D Exists » ; « Expires: 25 April 2027 ». Texte : « If there is an attempt to reuse an idempotency key with a different request payload, the resource SHOULD reply with an HTTP 422 status code » ; « If the request is retried, while the original request is still being processed, the resource SHOULD reply with an HTTP 409 status code »
- Portée / limites : statut au 09.11.2026 : document de groupe de travail, aucun passage en IESG ; la page de métadonnées indique « Intended RFC status (None) » alors que le texte du brouillon porte « Intended status: Standards Track ». Le brouillon prévoit aussi 400 si la clé manque pour une opération qui l'exige.
- En code : adopter le nom d'en-tête et la grille 400/409/422 est raisonnable (convergence Stripe/brouillon), mais documenter qu'il s'agit d'un brouillon.

### Les guides de plateforme convergent : identifiant de requête fourni par le client, optionnel, qui garantit l'idempotence
- Niveau de preuve : N3 (guides officiels Google et Microsoft)
- Source : Google, AIP-155 « Request identification », https://google.aip.dev/155 ; Microsoft, « Microsoft Azure REST API Guidelines » (historique : dernière entrée 2026-Oct-22), https://raw.githubusercontent.com/microsoft/api-guidelines/vNext/azure/Guidelines.md (dépôt github.com/microsoft/api-guidelines)
- Extrait lu : AIP-155 : « Providing a request ID must guarantee idempotency. If a duplicate request is detected, the server should return the response for the previously successful request » ; Azure : « to enable customers to write fault-tolerant applications, _all_ service operations (including POST) **must** be idempotent. »
- Portée / limites : AIP-155 autorise une réponse « périmée » (état courant de la ressource) quand la réponse d'origine n'est plus reconstituable. Azure nomme ses en-têtes `Repeatability-Request-ID` et `Repeatability-First-Sent` : les noms divergent d'un guide à l'autre.
- En code : un endpoint de création exposé à un client mobile ou à un formulaire (double clic, réseau instable) accepte-t-il un identifiant de requête ?

---

## 5. Transactions, effets externes et webhooks

### Écrire l'intention (outbox) dans la transaction métier ; ni envoyer pendant la transaction, ni « juste après le commit »
- Niveau de preuve : N4 (catalogue de patterns d'un praticien)
- Source : Chris Richardson, « Pattern: Transactional outbox », microservices.io, https://microservices.io/patterns/data/transactional-outbox.html
- Extrait lu : « without using 2PC, sending a message in the middle of a transaction is not reliable. There's no guarantee that the transaction will commit. Similarly, if a service sends a message after committing the transaction there's no guarantee that it won't crash before sending the message. » ; « The Message relay might publish a message more than once. … As a result, a message consumer must be idempotent »
- Portée / limites : rédigé pour un courtier de messages ; s'applique de même à un e-mail ou un webhook sortant. Le pattern déplace le problème : le relais est « au moins une fois », donc le destinataire doit dédupliquer (ou l'appel sortant porter une clé d'idempotence dérivée de l'identifiant de l'outbox). Inconvénient cité : « the developer might forget to publish the message/event after updating the database ».
- En code : `await db.transaction(async tx => { … await sendEmail() })` → refus. `await tx.commit(); await sendEmail()` → perte possible si le processus meurt entre les deux. Attendu : `INSERT INTO outbox` dans la transaction, envoi par un worker.

### Ne pas garder une transaction Postgres ouverte pendant un appel réseau ; `NOTIFY` est la seule notification que Postgres rend transactionnelle
- Niveau de preuve : N3 (documentation officielle PostgreSQL 18)
- Source : PostgreSQL Global Development Group, docs « current » (PostgreSQL 18), « NOTIFY », https://www.postgresql.org/docs/current/sql-notify.html ; « Client Connection Defaults » (`idle_in_transaction_session_timeout`), https://www.postgresql.org/docs/current/runtime-config-client.html
- Extrait lu : NOTIFY : « if a NOTIFY is executed inside a transaction, the notify events are not delivered until and unless the transaction is committed. » ; paramètre : « This option can be used to ensure that idle sessions do not hold locks for an unreasonable amount of time. Even when no significant locks are held, an open transaction prevents vacuuming away recently-dead tuples »
- Portée / limites : la doc Postgres ne parle pas d'e-mails ni de webhooks ; le lien « appel HTTP dans une transaction = session *idle in transaction* qui garde ses verrous » est une **déduction** à partir de ces deux pages. `NOTIFY` lui-même n'est pas durable pour un auditeur absent : la page conseille, pour de gros volumes, de « put it in a database table and send the key of the record ».
- En code : un `await fetch()` entre `BEGIN` et `COMMIT` (ou dans un callback de transaction Prisma/Drizzle/Supabase RPC) ; vérifier qu'un `idle_in_transaction_session_timeout` est posé pour les rôles applicatifs.

### Webhook entrant : vérifier la signature sur le corps brut et rejeter les horodatages trop anciens
- Niveau de preuve : N3 (documentation officielle Stripe)
- Source : Stripe, consultée le 09.11.2026, « Receive Stripe events in your webhook endpoint », https://docs.stripe.com/webhooks
- Extrait lu : « Stripe requires the raw body of the request to perform signature verification. … Any manipulation to the raw body of the request causes the verification to fail. » ; « Our libraries have a default tolerance of 5 minutes between the timestamp and the current time. » ; « Don't use a tolerance value of 0. Using a tolerance value of 0 disables the recency check entirely. »
- Portée / limites : propre à Stripe ; la spécification Standard Webhooks (entrée suivante) exige en plus une comparaison en temps constant. Horloge serveur synchronisée (NTP) requise.
- En code : dans une route handler Next.js, le corps est-il lu avec `await req.text()` **avant** tout `JSON.parse`, et la vérification faite avec la bibliothèque officielle ? En FastAPI, `await request.body()` et non le modèle Pydantic déjà parsé.

### Webhook entrant : accuser réception en 2xx rapidement, traiter en file, dédupliquer par identifiant d'événement, ne pas supposer d'ordre
- Niveau de preuve : N3
- Source : Stripe, « Receive Stripe events in your webhook endpoint », https://docs.stripe.com/webhooks
- Extrait lu : « Quickly returns a successful status code (2xx) before any complex logic that might cause a timeout. » ; « Webhook endpoints might occasionally receive the same event more than once. You can guard against duplicated event receipts by logging the event IDs you've processed » ; « Stripe doesn't guarantee the delivery of events in the order that they're generated. » ; « Configure your handler to process incoming events with an asynchronous queue. »
- Portée / limites : Stripe réessaie « for up to three days with an exponential back off in live mode ». Point d'interprétation (déduction, non écrit par Stripe) : « 2xx avant toute logique complexe » ne veut pas dire « avant toute écriture » — enregistrer l'événement brut en base, puis répondre 2xx, puis traiter.
- En code : le handler fait-il le traitement métier complet (facture, e-mail) avant de répondre ? Y a-t-il une contrainte `UNIQUE(event_id)` ? Le code suppose-t-il que `invoice.paid` arrive après `customer.subscription.created` ?

### Webhook sortant : identifiant stable par événement, horodatage signé, retries étalés sur plusieurs jours avec jitter, 410 désactive l'abonnement
- Niveau de preuve : N3 (spécification communautaire, version 1.0.0, comité de praticiens ; pas une norme IETF)
- Source : Standard Webhooks, « Standard Webhooks » spec v1.0.0, https://github.com/standard-webhooks/standard-webhooks/blob/main/spec/standard-webhooks.md (lu via raw.githubusercontent.com ; site https://www.standardwebhooks.com/)
- Extrait lu : « The ID is often used as an idempotency key, which lets a consumer ensure that they only process a specific event once » ; « When verifying symmetric signatures, use a constant time comparison function » ; « It's recommended to retry delivery following a retry schedule spanning multiple days, with an exponential backoff. It's recommended to also add some level of random jitter » ; « `410 Gone`: … Sender should disable the webhook endpoint »
- Portée / limites : en-têtes `webhook-id`, `webhook-timestamp`, `webhook-signature` ; HMAC-SHA256 ou ed25519 ; délai d'attente conseillé côté émetteur « between 15 and 30s ». Le comité nomme des praticiens de Zapier, Twilio, ngrok, Supabase, Svix, Kong ; adoption effective non mesurée.
- En code : si notre service **émet** des webhooks, l'identifiant est-il identique d'une tentative à l'autre ? La comparaison de signature reçue utilise-t-elle `crypto.timingSafeEqual` / `hmac.compare_digest` plutôt que `===` ?

---

## 6. Erreurs HTTP

### Les erreurs d'API se renvoient en `application/problem+json` (RFC 9457), avec le même code que la réponse HTTP et un `detail` utile au client, jamais une trace de pile
- Niveau de preuve : N1 (RFC 9457, Standards Track, juillet 2023, remplace RFC 7807)
- Source : M. Nottingham, E. Wilde, S. Dalal, 2023, RFC 9457 « Problem Details for HTTP APIs », https://www.rfc-editor.org/rfc/rfc9457.txt
- Extrait lu : « This document obsoletes RFC 7807. » ; « Generators MUST use the same status code in the actual HTTP response » ; « The "detail" string, if present, ought to focus on helping the client correct the problem, rather than giving debugging information. » ; « Problem details are not a debugging tool for the underlying implementation »
- Portée / limites : format, pas taxonomie ; la RFC ne dit pas quel code choisir. Zalando en fait une règle interne (« MUST support problem JSON ») et interdit les traces (« MUST not expose stack traces »).
- En code : le gestionnaire d'erreurs global renvoie-t-il `err.message` ou `err.stack` d'une exception inattendue ? Le `status` du corps et le code HTTP divergent-ils ?

### 4xx et 5xx doivent tous deux expliquer l'erreur et dire si elle est temporaire ; 409 signale un conflit avec l'état courant que l'appelant peut résoudre
- Niveau de preuve : N1
- Source : RFC 9110, §15.5, §15.5.10, §15.6, https://www.rfc-editor.org/rfc/rfc9110.txt
- Extrait lu : « The 4xx (Client Error) class of status code indicates that the client seems to have erred. Except when responding to a HEAD request, the server SHOULD send a representation containing an explanation of the error situation, and whether it is a temporary or permanent condition. » ; 5xx : « the server is aware that it has erred or is incapable of performing the requested method » (même clause SHOULD d'explication) ; 409 : « This code is used in situations where the user might be able to resolve the conflict and resubmit the request. »
- Portée / limites : la RFC n'oppose pas « message actionnable » pour 4xx et « message générique » pour 5xx : elle demande une explication dans les deux cas. Le caractère générique du 5xx vient de la sécurité (RFC 9457 §5). Brooker (2019) nuance la frontière : « eventual consistency in systems significantly blurs this line. A client error one moment may change into a success the next moment ».
- En code : un 500 renvoie-t-il au moins un identifiant de corrélation et l'indication « réessayable ou non » ? Un 409 indique-t-il quelle ressource est en conflit ?

### Chaque erreur métier attendue porte un identifiant machine stable, distinct du message humain
- Niveau de preuve : N3 (guides officiels Google et Microsoft)
- Source : Google, AIP-193 « Errors », https://google.aip.dev/193 ; Microsoft, « Microsoft Azure REST API Guidelines », https://raw.githubusercontent.com/microsoft/api-guidelines/vNext/azure/Guidelines.md
- Extrait lu : AIP-193 : « Error messages should be brief but actionable. » ; « The (reason, domain) pair form a machine-readable way of identifying a particular error. » ; Azure : « `x-ms-error-code` values are part of your API contract (because customer code is likely to do comparisons against them) and cannot change in the future. »
- Portée / limites : Google impose `google.rpc.Status` et ses codes canoniques ; Azure un en-tête propriétaire. Le principe commun (code stable + message libre) est transposable au champ `type` de RFC 9457.
- En code : le front compare-t-il des chaînes de message (`if (err.message.includes('déjà'))`) au lieu d'un code ? Les codes d'erreur sont-ils listés dans le schéma (OpenAPI, Zod) comme une union typée ?

### Codes d'état : couvrir au minimum 401 avec `WWW-Authenticate`, 403, 409, 429 et 503 ; trancher 400 contre 422 et s'y tenir
- Niveau de preuve : N1 (RFC 9110) ; N3 (Zalando, Azure)
- Source : RFC 9110, §15.5.2, §15.5.4, §15.5.21, https://www.rfc-editor.org/rfc/rfc9110.txt ; Zalando, « RESTful API and Event Guidelines », https://opensource.zalando.com/restful-api-guidelines/
- Extrait lu : 401 : « The server generating a 401 response MUST send a WWW-Authenticate header field » ; 422 : « the syntax of the request content is correct, but it was unable to process the contained instructions » ; Zalando, 400 : « Should also be delivered in case of input payload fails business logic / semantic validation (instead of using 422 ). » et 422 « do not use … there does not seem to be a clear benefit to differentiating between them »
- Portée / limites : 422 est normatif (RFC 9110) mais son usage est contesté entre guides : Zalando l'exclut, Azure répond 400 aux champs inconnus ou invalides, le brouillon Idempotency-Key l'emploie. Zalando demande aussi « MUST use most specific HTTP status codes ».
- En code : la liste des codes de l'API est-elle documentée ? Un refus d'autorisation renvoie-t-il 403 (et pas 401 ni 404 sans intention de masquer) ? Un dépassement de quota renvoie-t-il 429 ?

### Fixer une stratégie de versionnement explicite, en sachant que les grands guides se contredisent
- Niveau de preuve : N3
- Source : Google, AIP-185 « API Versioning », https://google.aip.dev/185 ; Zalando, « RESTful API and Event Guidelines », https://opensource.zalando.com/restful-api-guidelines/ ; Microsoft Azure REST API Guidelines, https://raw.githubusercontent.com/microsoft/api-guidelines/vNext/azure/Guidelines.md
- Extrait lu : AIP-185 : « All Google API interfaces must provide a major version number , which is encoded at the end of the protobuf package, and included as the first part of the URI path for REST APIs. » ; Zalando (table des règles) : « SHOULD avoid versioning », « MUST use media type versioning », « MUST not use URL versioning » ; Azure : « **DO** use a required query parameter named `api-version` on every operation »
- Portée / limites : trois plateformes, trois mécanismes (chemin, type de média, paramètre de requête daté `YYYY-MM-DD`). Aucune preuve empirique de supériorité trouvée. Point commun : ne pas casser la compatibilité sans nouvelle version.
- En code : un changement de forme de réponse (champ renommé, enum restreinte) part-il sans version ni période de transition ?

---

## 7. Pagination et bornage

### Paginer toute collection dès la première version, plafonner la taille de page côté serveur, jetons de page opaques
- Niveau de preuve : N3 (guide officiel Google ; règle Zalando concordante)
- Source : Google, AIP-158 « Pagination », https://google.aip.dev/158 ; Zalando, « RESTful API and Event Guidelines », https://opensource.zalando.com/restful-api-guidelines/
- Extrait lu : AIP-158 : « RPCs returning collections of data must provide pagination at the outset , as it is a backwards-incompatible change to add pagination to an existing method. » ; « If the user specifies page_size greater than the maximum permitted by the API, the API should coerce down to the maximum permitted page size. » ; jetons : « must be opaque (but URL-safe) strings, and must not be user-parseable » ; Zalando : « SHOULD prefer cursor-based pagination, avoid offset-based pagination »
- Portée / limites : Zalando liste les contreparties du curseur (pas de saut à la page 51, support des frameworks moindre) et note que l'offset « may create duplicates or lead to missing entries if rows are inserted or deleted between two subsequent paging requests ». L'exemple d'AIP-158 plafonne à 1000 ; ce n'est pas une règle générale.
- En code : un `select * from …` sans `limit` derrière une route de liste ; un `?limit=` client non plafonné ; un curseur qui expose un `id` ou un offset décodable.

### Borner toute consommation de ressources, y compris la dépense chez les tiers payants
- Niveau de preuve : N3 (référentiel OWASP API Security Top 10 2023)
- Source : OWASP, 2023, « API4:2023 Unrestricted Resource Consumption », https://owasp.org/API-Security/editions/2023/en/0xa4-unrestricted-resource-consumption/ (redirige vers https://api-security.owasp.org/editions/2023/en/0xa4-unrestricted-resource-consumption/)
- Extrait lu : « An API is vulnerable if at least one of the following limits is missing or set inappropriately (e.g. too low/high): Execution timeouts … Number of records per page to return in a single request-response … Third-party service providers' spending limit »
- Portée / limites : périmètre sécurité, traité ailleurs dans le référentiel ; repris ici parce qu'il relie timeouts, pagination et coûts d'API tierces (e-mails, SMS « paid for per request »).
- En code : un endpoint public qui déclenche un e-mail ou un SMS est-il limité en débit et plafonné en dépense ?

---

## 8. Temps réel

### Choisir SSE pour un flux serveur→client ; savoir que la limite de 6 connexions ne vaut qu'en HTTP/1.1
- Niveau de preuve : N3 (MDN) ; N1 pour la spécification (HTML Living Standard, mis à jour le 9 novembre 2026)
- Source : MDN, « Using server-sent events » (dernière modification affichée : 3 sept. 2026), https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events ; WHATWG, « HTML Standard — 9.2 Server-sent events », https://html.spec.whatwg.org/multipage/server-sent-events.html
- Extrait lu : MDN : « When not used over HTTP/2 , SSE suffers from a limitation to the maximum number of open connections, which can be especially painful when opening multiple tabs, as the limit is per browser and is set to a very low number (6). » ; « When using HTTP/2, the maximum number of simultaneous HTTP streams is negotiated between the server and the client (defaults to 100). » ; WHATWG : « authors can include a comment line (one starting with a ':' character) every 15 seconds or so. »
- Portée / limites : MDN s'appuie sur un fil Stack Overflow pour le décompte par domaine. La spécification prévoit la reprise via l'en-tête `Last-Event-ID` si le serveur envoie des `id:`. SSE est unidirectionnel (« Unlike WebSockets , server-sent events are unidirectional », page MDN EventSource).
- En code : le flux SSE émet-il des `id:` pour la reprise et un commentaire de maintien toutes les ~15 s ? Le déploiement sert-il HTTP/2 jusqu'au navigateur ?

### Le polling court coûte proportionnellement à la latence voulue ; à l'échelle de la seconde, il peut surcharger
- Niveau de preuve : N1 au sens « RFC », mais RFC **Informational** de 2011 (analyse qualitative, pas de mesure)
- Source : S. Loreto, P. Saint-Andre, S. Salsano, G. Wilkins, 2011, RFC 6202 « Known Issues and Best Practices for the Use of Long Polling and Streaming in Bidirectional HTTP », https://www.rfc-editor.org/rfc/rfc6202.txt
- Extrait lu : « This mechanism has the drawback that the consumed resources (server processing and network) strongly depend on the acceptable latency in the delivery of updates from server to client. If the acceptable latency is low (e.g., on the order of seconds), then the polling frequency can cause an unacceptable burden on the server, the network, or both. »
- Portée / limites : argument qualitatif ; aucune étude mesurée SSE / WebSocket / polling n'a été trouvée lors de cette recherche. « Polling 1 s » est donc à juger au cas par cas (nombre de clients, coût d'une requête vide, cache).
- En code : `setInterval(fetch, 1000)` par onglet ouvert, multiplié par le nombre d'utilisateurs : le coût d'une requête vide a-t-il été estimé ?

### Sur fonctions serverless, une connexion temps réel est bornée par la durée maximale de la fonction et l'état ne vit pas en mémoire
- Niveau de preuve : N3 (documentation officielle Vercel, dernière mise à jour 2026-08-10)
- Source : Vercel, « WebSockets » (Functions), https://vercel.com/docs/functions/websockets (version Markdown lue)
- Extrait lu : « WebSocket connections close when a Vercel Function reaches its maximum duration. » ; « New WebSocket connections are not guaranteed to reach the same Vercel Function instance. » ; « Store durable state, presence, counters, rooms, and pub/sub coordination in an external data store instead of relying on in-memory variables. »
- Portée / limites : WebSocket en bêta publique (page de base de connaissance liée : « in public beta on all plans »). La valeur de la durée maximale n'a pas été lue (page `limitations` non ouverte). Le même raisonnement vaut pour un flux SSE servi par une route handler (déduction).
- En code : le client reconnecte-t-il avec backoff et resouscription ? Une salle ou une présence est-elle stockée dans une variable de module ?

---

## 9. Tâches de fond

### Une table-file Postgres se consomme avec `FOR UPDATE SKIP LOCKED`, réservé à cet usage
- Niveau de preuve : N3 (documentation officielle PostgreSQL 18)
- Source : PostgreSQL, « SELECT » (docs current, PostgreSQL 18), https://www.postgresql.org/docs/current/sql-select.html
- Extrait lu : « With SKIP LOCKED , any selected rows that cannot be immediately locked are skipped. Skipping locked rows provides an inconsistent view of the data, so this is not suitable for general purpose work, but can be used to avoid lock contention with multiple consumers accessing a queue-like table. »
- Portée / limites : garantit qu'un même travail n'est pas pris par deux workers **pendant** que le verrou est tenu ; ne garantit rien si le worker meurt après l'effet externe et avant le commit (le travail sera repris). Le verrou de table `ROW SHARE` reste pris normalement.
- En code : la requête de prise de travail utilise-t-elle `FOR UPDATE SKIP LOCKED` avec `LIMIT` ? Le worker fait-il son appel externe en tenant ce verrou (même problème que l'appel dans une transaction) ?

### Toute file est « au moins une fois » : le consommateur est idempotent, par exemple via une contrainte d'unicité
- Niveau de preuve : N3 (documentation officielle AWS SQS et PostgreSQL 18)
- Source : AWS, « Amazon SQS at-least-once delivery », https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/standard-queues-at-least-once-delivery.html ; PostgreSQL, « INSERT », https://www.postgresql.org/docs/current/sql-insert.html
- Extrait lu : SQS : « you might get that message copy again when you receive messages. Design your applications to be idempotent (they should not be affected adversely when processing the same message more than once). » ; Postgres : « ON CONFLICT DO NOTHING simply avoids inserting a row as its alternative action. » ; « ON CONFLICT DO UPDATE guarantees an atomic INSERT or UPDATE outcome; provided there is no independent error, one of those two outcomes is guaranteed, even under high concurrency. »
- Portée / limites : SQS standard décrit ici ; même conclusion pour le relais d'outbox (Richardson) et les webhooks Stripe. L'unicité protège l'écriture locale, pas un effet externe déjà parti : celui-ci doit porter sa propre clé d'idempotence.
- En code : la table des travaux traités a-t-elle `UNIQUE(job_id)` / `UNIQUE(event_id)`, et l'insertion se fait-elle dans la même transaction que l'effet local ?

---

## Verdict sur les règles du profil

| Règle | Verdict | Motif sourcé |
|---|---|---|
| « Idempotence : tout endpoint de création/paiement exposé à un retry client accepte une clé d'idempotence (ou contrainte UNIQUE naturelle). Toute tâche de fond est réentrante. » | **Soutenue, à préciser** | RFC 9110 §9.2.2 (pas de retry automatique d'un non-idempotent), Stripe, AIP-155 et Azure convergent sur la clé. À ajouter : clé enregistrée **atomiquement** avec la mutation, réponse rejouée, paramètres comparés, 409 si en cours, fenêtre de rétention (Stripe ; Featonby). La « contrainte UNIQUE naturelle » ne vaut que si le métier interdit vraiment deux opérations identiques : Featonby écarte la déduplication par paramètres (deux lancements identiques peuvent être voulus). « Réentrante » est vague : la preuve (SQS, outbox, Stripe) porte sur l'**idempotence face à la relivraison** et l'exclusion concurrente (`SKIP LOCKED`). |
| « Ce qui sort du processus (email, webhook, appel API) ne se fait JAMAIS dans la transaction — on commit d'abord, on notifie ensuite (au minimum : écrire l'intention en DB puis traiter). » | **Soutenue, à reformuler** | « Jamais dans la transaction » : soutenu (Richardson ; Postgres : une transaction ouverte garde ses verrous et bloque le vacuum). Mais « commit puis notifier » seul est fautif : « if a service sends a message after committing the transaction there's no guarantee that it won't crash before sending the message » (Richardson). Le « minimum » entre parenthèses (intention en base = outbox) doit devenir la règle, avec consommateur idempotent. Exception utile : `NOTIFY` Postgres n'est délivré qu'au commit. |
| « Appels sortants : timeout toujours explicite, retry avec backoff exponentiel + jitter uniquement sur idempotent, et un comportement défini quand le tiers est down. » | **Soutenue, incomplète** | Timeout explicite : Brooker 2019 ; défauts d'undici à 300 s. Backoff + jitter : Brooker 2015, SRE. « Uniquement sur idempotent » : RFC 9110, à préciser en « idempotent **ou rendu idempotent par une clé** » (Stripe réessaie les POST avec clé). Manquent : budget de retries (SRE : 3 tentatives, ratio 10 %), un seul niveau de retry (64× / 243×), respect de `Retry-After`, deadline globale, et le cas « 500 = résultat indéterminé, réconcilier avant de rejouer avec une nouvelle clé » (Stripe). Huang et al. : les retries entretiennent plus de 50 % des pannes métastables étudiées. |
| « Taxonomie d'erreurs : 4xx = la requête est en cause (message actionnable), 5xx = le serveur est en cause (message générique + log détaillé). Les erreurs métier attendues sont des réponses typées. » | **Soutenue, à nuancer** | Sens des classes : RFC 9110 §15.5/§15.6. Mais la RFC demande une explication (y compris « temporary or permanent ») **aussi** pour les 5xx : « générique » doit s'entendre « sans détail d'implémentation » (RFC 9457 §5, Zalando « MUST not expose stack traces »), pas « muet ». Brooker : la cohérence à terme brouille la frontière 4xx/5xx pour le retry. Réponses typées : AIP-193 (reason, domain), Azure `x-ms-error-code`, RFC 9457 `type`. |
| « Codes HTTP (200/201/400/401/404/409/500). » | **À compléter** | Manquent au moins 403 (refus d'autorisation, RFC 9110 §15.5.4), 429 + `Retry-After` (RFC 6585), 503 (RFC 9110 §15.6.4), 204, et la décision 400 contre 422 (contestée : RFC 9110 le définit, Zalando et Azure s'en passent). 401 impose `WWW-Authenticate` (MUST) ; 201 renvoie `Location`. |
| Anti-pattern « GET qui modifie l'état » | **Soutenue (N1)** | RFC 9110 §9.2.1 : « the resource owner MUST disable or disallow that action when it is accessed using a safe request method ». |
| Anti-pattern « Erreur générique au lieu de code HTTP correct + message actionnable » | **Soutenue** | RFC 9110 (4xx et 5xx : explication SHOULD) ; RFC 9457 (`detail` pour aider le client) ; AIP-193 « brief but actionable » ; Zalando « MUST use most specific HTTP status codes ». |
| Anti-pattern « Polling 1s côté client au lieu de WebSocket/SSE quand justifié » | **Convention sans preuve mesurée trouvée** | Seul appui : RFC 6202 (Informational, qualitatif) : un polling à la seconde « can cause an unacceptable burden ». Contrepoids documentés : SSE limité à 6 connexions par navigateur et domaine en HTTP/1.1 (MDN) ; sur serverless, connexions coupées à la durée maximale de la fonction et état à externaliser (Vercel). La clause « quand justifié » est la bonne : le choix dépend du nombre de clients et de la latence voulue. |

---

## Mythes et affirmations contestées

- **« 92 % des pannes viennent d'une mauvaise gestion d'erreur. »** Inexact. Yuan et al. (OSDI 2014) : 92 % des pannes **catastrophiques** (48 sur 198, soit 24 % de l'échantillon) dans 5 systèmes de données distribués Java/C ; seulement 25 % des pannes non catastrophiques impliquent une gestion d'erreur fautive.
- **« Le backoff exponentiel suffit. »** Sans jitter, les rafales demeurent : « there are still clusters of calls » ; l'approche sans jitter est « the clear loser » (Brooker 2015, en simulation).
- **« Le disjoncteur (circuit breaker) est la réponse standard aux tempêtes de retries. »** Contesté par Brooker (2019) : « circuit breakers introduce modal behavior into systems that can be difficult to test, and can introduce significant addition time to recovery » ; AWS préfère un seau à jetons local. Avis d'expert contre pratique répandue, pas de comparaison mesurée publiée.
- **« Les retries rendent le système plus fiable. »** Ils masquent les fautes transitoires, mais sont l'effet entretenant le plus fréquent des pannes métastables (> 50 % des 22 cas de Huang et al., 2022) ; Brooker : « retries are selfish ».
- **« `Idempotency-Key` est un en-tête standard IETF. »** Faux au 09.11.2026 : brouillon actif -08 (22.10.2026), état IESG « I-D Exists ».
- **« 422 est le code normalisé de la validation métier. »** 422 est bien défini par RFC 9110, mais Zalando le déconseille (« do not use ») et Azure répond 400 ; le brouillon Idempotency-Key l'emploie. Choix de convention, à documenter.
- **« Commiter puis envoyer l'e-mail, c'est sûr. »** Non : crash possible entre commit et envoi (Richardson). Il faut l'outbox, ou une intention persistée relancée par un worker.
- **« Il faut répondre 200 au webhook avant de faire quoi que ce soit. »** Stripe dit « before any complex logic » ; répondre 2xx sans avoir persisté l'événement le perd si le processus tombe (déduction de cette recherche, non écrite par Stripe). Stripe réessaie trois jours, mais seulement sur réponse non 2xx.
- **« SSE est limité à 6 connexions. »** Seulement hors HTTP/2 ; en HTTP/2 la limite est négociée (100 par défaut selon MDN).
- **« Le versionnement par URL (`/v1/`) est la norme. »** Google l'impose (AIP-185) ; Zalando l'interdit (« MUST not use URL versioning ») ; Azure utilise un paramètre `api-version` daté. Aucune norme ne tranche.
- **« Le timeout par défaut du client HTTP me protège. »** Pour undici : 300 s pour les en-têtes, 300 s **entre deux morceaux** de corps, aucune borne totale par défaut lue dans la doc.

---

## Non vérifié

- **Gunawi et al., SoCC 2016, « Why Does the Cloud Stop Computing? »** : PDF auteur (ece.iastate.edu) inaccessible (erreur de certificat TLS via curl, puis HTTP 503 via WebFetch ; URL ucare.cs.uchicago.edu refusée par le proxy). Les chiffres vus dans un résumé de moteur de recherche (32 services, 597 pannes de 2009 à 2015) ne sont **pas** repris comme vérifiés.
- **Écart 21 / 22 incidents chez Huang et al.** : le résumé de recherche signalait que les diapositives et un billet citent 21 ; seul l'article (22) a été lu.
- **Valeurs par défaut du `fetch` global de Node.js** : seule la doc du `Client` undici a été lue ; l'héritage exact par `fetch` n'est pas confirmé.
- **Date de publication de l'article de Malcolm Featonby** : non affichée sur la page téléchargée.
- **Durée maximale d'une fonction Vercel** (qui borne les WebSocket/SSE) : page `functions/limitations` non ouverte.
- **Comparaison mesurée SSE / WebSocket / polling** (latence, coût serveur) : aucune étude revue par pairs ni mesure de plateforme trouvée ; seule l'analyse qualitative de RFC 6202 a été lue.
- **Idempotence de l'API v2 de Stripe** : page dédiée non lue ; tout ce qui précède concerne l'API v1.
- **Année d'édition du livre SRE** (2016) : non affichée sur les pages de chapitres lues ; donnée de mémoire, à confirmer avant citation formelle.

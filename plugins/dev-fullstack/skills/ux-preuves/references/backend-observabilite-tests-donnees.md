# Fiche `ux-preuves` — Backend — observabilité, tests et données personnelles

> Fiche du skill `ux-preuves` (dev-fullstack), volet **backend**, préchargé par `backend`. Couvre : journaux structurés et ce qu'on n'y écrit jamais, W3C Trace Context et OpenTelemetry, SLO et signaux dorés, tests d'intégration contre une vraie base, tests de contrat, de propriétés et de mutation, gestion des exceptions, nLPD et RGPD dans un backend (protection dès la conception, sécurité, annonce des violations, communication à l'étranger), effacement et rétention.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Versions, statuts de brouillons IETF et API
> **vieillissent en mois** ; le droit change par révision : avant d'écrire du code qui en dépend,
> relire la page officielle (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Recherche documentaire du 9 novembre 2026, pour le référentiel d'un agent « backend engineer senior »
(défaut : route handlers Next.js / Hono / FastAPI, Postgres ou Supabase ; développeur indépendant en
Suisse, utilisateurs en Suisse et dans l'UE).

**Méthode.** Chaque entrée s'appuie sur une page ouverte pendant la recherche (WebFetch), ou sur un PDF
ou un texte téléchargé puis extrait (`curl` + `pdftotext`, ou conversion HTML -> texte). Quand seul le
résumé d'un article a pu être lu, l'entrée le dit (« résumé seul lu »). Les textes de loi suisses ont été
lus dans le **filestore Fedlex** (version consolidée la plus récente qu'indique le point SPARQL de Fedlex :
LPD « État le 7 juillet 2025 », OPDo « État le 1er décembre 2025 »), parce que la page `fedlex.admin.ch/eli/...`
exige JavaScript. Le RGPD a été lu dans la manifestation XHTML française du Cellar de l'Office des
publications de l'UE (JO L 119 du 4.5.2016, texte d'origine), EUR-Lex renvoyant une page vide à l'outil.

**Le droit est cité pour ce qu'il dit.** Savoir s'il s'applique à une application donnée (quelles données
sont sensibles, si le RGPD s'applique au titre de son art. 3, par. 2, quelle durée de conservation est
justifiée) relève d'un juriste ; les entrées « En code » disent quoi chercher dans une PR, pas ce que la loi
exige du cas d'espèce.

Échelle : N1 loi, norme, standard · N2 recherche revue par pairs ou étude empirique à large échantillon ·
N3 documentation ou guide officiel · N4 avis d'expert, livre ou article de praticien.

---

## 1. Journaux structurés et corrélation

### Écrire les journaux dans un format structuré (JSON ou format natif de la stack), jamais en texte libre
- Niveau de preuve : N3
- Source : OWASP Cheat Sheet Series, s. d. (page consultée le 09.11.2026), « Logging Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html
- Extrait lu : « Do not use unstructured text log formats » ; « Instead, use structured log formats, such as JSON. »
- Portée / limites : recommandation d'un guide de sécurité, sans mesure d'effet. La même page demande d'utiliser « a standard event format supported by the receiving system » : le format exact se règle sur le collecteur, pas sur une préférence. OWASP ASVS 5.0 (V16.2.4) formule la même exigence en termes vérifiables : « logs can be read and correlated by the log processor that is in use, preferably by using a common logging format ».
- En code : y a-t-il un `console.log(\`...${x}\`)` ou un `print()` dans un handler livré ? Le logger (pino, structlog, logging + formatter JSON) est-il le seul chemin de sortie ?

### Chaque événement porte « quand, où, qui, quoi » et un identifiant d'interaction qui relie tous les événements d'une même requête
- Niveau de preuve : N3
- Source : OWASP Cheat Sheet Series, s. d., « Logging Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html
- Extrait lu : « The application logs must record "when, where, who and what" for each event. » ; « The "Interaction identifier" is a method of linking all (relevant) events for a single user interaction »
- Portée / limites : l'identifiant d'interaction est rangé sous « When » ; « Who » liste « User identity (if authenticated or otherwise known) » — ce qui fait de chaque ligne de log une donnée personnelle au sens de la LPD (art. 5 let. a, cf. § 5). La page demande aussi de synchroniser l'heure (« Synchronize time across all servers and devices ») ; ASVS 5.0 V16.2.2 précise UTC ou décalage explicite.
- En code : le middleware pose-t-il un `request_id` (ou reprend-il le `trace-id` du `traceparent`) et le logger l'attache-t-il à **toutes** les lignes de la requête (logger enfant, `AsyncLocalStorage`, `contextvars`) ? Les horodatages sont-ils en UTC ISO 8601 ?

### Propager la corrélation par l'en-tête W3C `traceparent` (sans aucune donnée personnelle dedans) et poser `trace_id`/`span_id` sur chaque ligne de log
- Niveau de preuve : N1 (W3C) et N3 (OpenTelemetry)
- Source : W3C, 2021, « Trace Context » (Recommandation du 23 novembre 2021, niveau 1), https://www.w3.org/TR/trace-context/ ; OpenTelemetry, s. d., « Logs Data Model » (statut Stable), https://opentelemetry.io/docs/specs/otel/logs/data-model/ ; OpenTelemetry, s. d., « Status », https://opentelemetry.io/status/
- Extrait lu : W3C : « version-format = trace-id "-" parent-id "-" trace-flags » ; « Tracing vendors MUST NOT use traceparent and tracestate fields for any personally identifiable or otherwise sensitive information. » ; OTel, champ `TraceId` : « Can be set for logs that are part of request processing and have an assigned trace ID. » ; « If SpanId is present TraceId SHOULD be also present. » ; page Status, JavaScript et Python : Traces « Stable », Metrics « Stable », Logs « Development ».
- Portée / limites : Recommandation W3C (statut le plus élevé), avec mises à jour éditoriales depuis celle du 6 février 2020 ; l'interdiction de PII vise les fournisseurs de traçage et vaut a fortiori pour une valeur `tracestate` posée soi-même. Le **modèle** de données des logs OTel est stable, mais les **SDK** de logs JS et Python sont en « Development » (page sans date de mise à jour) : garder le logger natif (pino, structlog) et y injecter les identifiants plutôt que de faire du SDK de logs OTel la seule voie.
- En code : les appels sortants (fetch, httpx) propagent-ils `traceparent` ? Aucun e-mail ni user id en clair dans `tracestate` ou le baggage ? Une ligne de log d'erreur 5xx contient-elle le `trace_id` qui mène à la trace ? Le projet dépend-il d'une API de logs OTel encore expérimentale ?

### Instrumenter le HTTP serveur selon les conventions sémantiques stables : nom de span `{méthode} {route}`, route à faible cardinalité, 4xx sans statut d'erreur côté serveur
- Niveau de preuve : N3
- Source : OpenTelemetry, s. d., « Semantic conventions for HTTP spans », https://opentelemetry.io/docs/specs/semconv/http/http-spans/ ; OpenTelemetry, 2023, « HTTP semantic conventions declared stable », https://opentelemetry.io/blog/2023/http-conventions-declared-stable/ ; release v1.23.0, https://github.com/open-telemetry/semantic-conventions/releases/tag/v1.23.0
- Extrait lu : « Instrumentation MUST NOT default to using URI path as a `{target}`. » ; « For HTTP status codes in the 4xx range span status MUST be left unset in case of `SpanKind.SERVER` » ; billet : « the HTTP semantic conventions are the first OpenTelemetry semantic conventions to be declared stable » ; release : « This release marks the first where the core of HTTP semantic conventions have stabilized. »
- Portée / limites : document « Stable, Unless otherwise specified » ; la section sur les règles de statut et certains attributs (`http.request.body.content`, `url.template`, la liste de rédaction des paramètres de requête sensibles) sont en « Development ». Pour un serveur, 5xx => statut `Error` est un SHOULD. Date de la release v1.23.0 : « 03 Nov » (l'année n'est pas affichée ; le chemin du billet porte 2023).
- En code : le nom de span ou le label de métrique contient-il un chemin brut (`/users/42`) au lieu du gabarit (`/users/[id]`) ? Une 404 ou une 422 est-elle comptée comme erreur serveur dans les tableaux de bord ?

### Rendre mesurables les latences entrantes ET sortantes par histogrammes (`http.server.request.duration`, `http.client.request.duration`)
- Niveau de preuve : N3
- Source : OpenTelemetry, s. d., « Semantic conventions for HTTP metrics », https://opentelemetry.io/docs/specs/semconv/http/http-metrics/
- Extrait lu : `http.server.request.duration` : Histogram, unité « `s` », stable, « Duration of HTTP server requests. » ; frontières recommandées « `[ 0.005, 0.01, 0.025, 0.05, 0.075, 0.1, 0.25, 0.5, 0.75, 1, 2.5, 5, 7.5, 10 ]` » ; `http.client.request.duration` : « Duration of HTTP client requests. », stable.
- Portée / limites : document au statut « Mixed » ; les deux métriques de durée sont marquées stables. L'unité est la seconde, pas la milliseconde. La règle du profil (« latences des appels sortants mesurables ») a ici son nom de métrique standard.
- En code : chaque client sortant (Stripe, API tierce, Supabase REST) est-il instrumenté (auto-instrumentation `undici`/`httpx`, ou wrapper qui chronomètre) ? La durée est-elle un histogramme et pas une moyenne ?

### Ne jamais écrire dans les journaux mots de passe, jetons d'accès, identifiants de session en clair, secrets ni données personnelles sensibles — retirer, masquer, hacher ou chiffrer
- Niveau de preuve : N3 (cheat sheet) et N1 (ASVS, standard communautaire de vérification)
- Source : OWASP Cheat Sheet Series, s. d., « Logging Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html ; OWASP, 2025, « ASVS 5.0.0 — V16 Security Logging and Error Handling », https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0/5.0/en/0x25-V16-Security-Logging-and-Error-Handling.md
- Extrait lu : liste « Data to exclude » : « Session identification values (consider replacing with a hashed value if needed to track session specific events) », « Access tokens », « Authentication passwords », « Database connection strings », « Encryption keys and other primary secrets », « Sensitive personal data and some forms of personally identifiable information (PII) », « Information a user has opted out of collection, or not consented to » ; ASVS 16.2.5 : « it may not be allowed to log certain data, such as credentials or payment details. Other data, such as session tokens, may only be logged by being hashed or masked ».
- Portée / limites : la liste OWASP dit « should usually not be recorded directly » — elle admet le hachage ou le masquage, pas l'écriture en clair. Elle vise « some forms of PII », pas toute PII : la règle « jamais de PII complète » du profil est plus stricte sur un point (PII) et moins précise sur un autre (elle ne cite ni les chaînes de connexion, ni les clés, ni les identifiants de session).
- En code : le logger a-t-il une liste de rédaction (pino : option `redact` avec `remove: true` ou `censor` ; https://github.com/pinojs/pino/blob/main/docs/redaction.md, « supply paths to keys that hold sensitive data using the `redact` option ») couvrant `req.headers.authorization`, `cookie`, `password`, `token`, `*.email` ? Un objet `req` ou `body` entier est-il logué ?

### Encoder les données journalisées contre l'injection, protéger les journaux en écriture et les envoyer vers un système séparé
- Niveau de preuve : N1 (ASVS) et N3 (cheat sheet)
- Source : OWASP, 2025, « ASVS 5.0.0 — V16 », https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0/5.0/en/0x25-V16-Security-Logging-and-Error-Handling.md ; OWASP, « Logging Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html
- Extrait lu : ASVS 16.4.1 « Verify that all logging components appropriately encode data to prevent log injection. » ; 16.4.3 « logs are securely transmitted to a logically separate system […] if the application is breached, the logs are not compromised. » ; cheat sheet : « Perform sanitization on all event data to prevent log injection attacks »
- Portée / limites : niveau 2 de l'ASVS. Un logger JSON qui sérialise correctement neutralise l'injection de sauts de ligne ; la concaténation de chaînes ne le fait pas. Rejoint l'OPDo art. 4 al. 5 (journaux conservés « séparément du système » dans les cas où la journalisation est obligatoire, § 5).
- En code : une entrée utilisateur est-elle interpolée dans le message plutôt que passée en champ ? Les journaux partent-ils vers un service distinct (drain Vercel, collecteur) ou restent-ils seulement sur l'instance ?

### Journaliser les échecs de validation, d'authentification et d'autorisation, et les erreurs inattendues
- Niveau de preuve : N3 (cheat sheet) et N1 (ASVS)
- Source : OWASP, « Logging Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html ; OWASP, « Logging Vocabulary Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Logging_Vocabulary_Cheat_Sheet.html ; ASVS 5.0.0 V16.3
- Extrait lu : « Input validation failures e.g. protocol violations, unacceptable encodings, invalid parameter names and values » ; « Authentication successes and failures » ; « Authorization (access control) failures » ; « Application errors and system events » ; vocabulaire : « This document proposes a standard vocabulary for logging security events. », événements `authn_login_fail[:userid]`, `authz_fail[:userid,resource]`.
- Portée / limites : ASVS 16.3.2 (L2) demande de journaliser les échecs d'autorisation, et au niveau L3 toutes les décisions « without logging the sensitive data itself ». Le vocabulaire OWASP est une proposition de nommage, pas un standard adopté.
- En code : un 401/403 et un échec de schéma (Zod, Pydantic) produisent-ils un événement nommé de façon stable (`authz_fail`, `input_validation_fail`) — sans recopier le corps rejeté ?

### Renvoyer au client un message d'erreur générique, garder le détail côté serveur, prévoir un gestionnaire de dernier recours et ne jamais échouer « ouvert »
- Niveau de preuve : N1 (standard communautaire)
- Source : OWASP, 2025, « ASVS 5.0.0 — V16.5 », https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0/5.0/en/0x25-V16-Security-Logging-and-Error-Handling.md
- Extrait lu : 16.5.1 « a generic message is returned to the consumer when an unexpected or security-sensitive error occurs, ensuring no exposure of sensitive internal system data such as stack traces, queries, secret keys, and tokens » ; 16.5.3 « preventing fail-open conditions such as processing a transaction despite errors resulting from validation logic » ; 16.5.4 (L3) « a "last resort" error handler is defined which will catch all unhandled exceptions ».
- Portée / limites : exigences de vérification, sans étude d'effet. 16.5.4 est de niveau 3 ; 16.5.1-16.5.3 de niveau 2.
- En code : la réponse 500 contient-elle `error.message` ou une stack ? Un `catch` qui logue puis continue le traitement (paiement, écriture) existe-t-il ? Le framework a-t-il un handler global (`app.onError` Hono, `exception_handler` FastAPI, `error.tsx`/wrapper Next) ?

### Ne collecter dans la télémétrie que ce qui sert l'observabilité ; un identifiant haché n'est pas anonyme
- Niveau de preuve : N3
- Source : OpenTelemetry, s. d., « Handling sensitive data », https://opentelemetry.io/docs/security/handling-sensitive-data/
- Extrait lu : « the best way to prevent the collection of sensitive data is not to collect data that might be sensitive. » ; « Only collect data that serves an observability purpose. »
- Portée / limites : la page montre le remplacement de `user.id` par un `user.hash` et avertit que le hachage n'anonymise pas pleinement un espace d'identifiants petit ou prévisible ; elle suggère de tronquer le dernier octet des adresses IPv4 (`client.address`). Elle ne cite pas le RGPD. À rapprocher du considérant 26 du RGPD (§ 5) : une donnée pseudonymisée reste une donnée personnelle.
- En code : un attribut de span contient-il un e-mail, une IP complète, un corps de requête ? Le collecteur a-t-il un processeur de rédaction par liste blanche ?

---

## 2. SLO, signaux et alertes

### Surveiller les quatre signaux dorés (latence, trafic, erreurs, saturation), séparer la latence des requêtes réussies et en échec, et n'alerter que sur des symptômes, par une page actionnable
- Niveau de preuve : N4 (livre de praticiens Google, sans évaluation empirique)
- Source : Rob Ewaschuk (éd. Betsy Beyer), s. d., « Monitoring Distributed Systems », in *Site Reliability Engineering*, https://sre.google/sre-book/monitoring-distributed-systems/
- Extrait lu : « The four golden signals of monitoring are latency, traffic, errors, and saturation. » ; « It's important to distinguish between the latency of successful requests and the latency of failed requests. » ; erreurs : « The rate of requests that fail, either explicitly (e.g., HTTP 500s) » ; latence : « collect request counts bucketed by latencies (suitable for rendering a histogram), rather than actual latencies » ; « The "what's broken" indicates the symptom; the "why" indicates a (possibly intermediate) cause. » ; « black-box monitoring is symptom-oriented and represents active—not predicted—problems » ; « Every page should be actionable. »
- Portée / limites : écrit pour des services à l'échelle Google ; l'année d'édition du livre n'est pas affichée sur la page lue ; aucune mesure comparative. Pour une application d'indépendant, la saturation se lit surtout côté fournisseur (pool de connexions Postgres, quotas).
- En code / exploitation : la métrique de durée est-elle étiquetée par code de statut (sinon une 500 rapide fait baisser la latence apparente) ? Est-ce un histogramme ? Une alerte « CPU > 80 % » réveille-t-elle quelqu'un alors qu'aucun objectif n'est touché, pendant qu'aucune alerte ne couvre le taux de 5xx ou l'échec d'un parcours clé ?

### Fixer des SLO inférieurs à 100 %, exprimer la latence en centiles, et alerter sur la vitesse de consommation du budget d'erreur (plusieurs fenêtres, plusieurs taux)
- Niveau de preuve : N4
- Source : Chris Jones, John Wilkes, Niall Murphy avec Cody Smith, « Service Level Objectives », in *Site Reliability Engineering*, https://sre.google/sre-book/service-level-objectives/ ; Steven Thurgood avec Jess Frame, Anthony Lenton, Carmela Quinito, Anton Tolchanov, Nejc Trdin, « Alerting on SLOs », in *The Site Reliability Workbook*, https://sre.google/workbook/alerting-on-slos/
- Extrait lu : SLO : « a target value or range of values for a service level that is measured by an SLI. » ; « We generally prefer to work with percentiles rather than the mean (arithmetic average) of a set of values. » ; « It's both unrealistic and undesirable to insist that SLOs will be met 100% of the time. » ; workbook : « Burn rate is how fast, relative to the SLO, the service consumes the error budget. » ; « we believe that the multiwindow, multi-burn-rate alerting technique is the most appropriate approach » ; critères : « Precision », « Recall », « Detection time », « Reset time ».
- Portée / limites : définitions de travail de praticiens, pas une norme ; pas de valeur cible universelle. Points de départ du workbook pour un SLO de 99,9 % : 2 % du budget consommé en une heure, 5 % en six heures, 10 % en trois jours. Leur pertinence pour un trafic très faible (application d'indépendant) n'a pas été vérifiée.
- En code / exploitation : le tableau de bord affiche-t-il p95/p99 ou `avg(duration)` ? L'alerte se déclenche-t-elle sur un seuil absolu (« plus de 5 erreurs ») sans rapport au volume ni à l'objectif ?

### Pour un service, suivre débit, erreurs et durée (RED) ; pour une ressource, utilisation, saturation et erreurs (USE)
- Niveau de preuve : N4
- Source : Tom Wilkie (talk résumé par Julie Dam), 2018, « The RED Method: How to instrument your services », https://grafana.com/blog/2018/08/02/the-red-method-how-to-instrument-your-services/ ; Brendan Gregg (la page signe « Brendan » ; nom complet déduit du domaine brendangregg.com ; mise à jour du 24.08.2017), « The USE Method », https://www.brendangregg.com/usemethod.html
- Extrait lu : RED : « Rate (the number of requests per second) », « Errors (the number of those requests that are failing) », « Duration (the amount of time those requests take) » ; Wilkie : « The USE Method doesn't really apply to services; it applies to hardware » ; USE : « For every resource, check utilization, saturation, and errors. »
- Portée / limites : méthodes de praticiens ; Wilkie dit des signaux dorés « This is basically the same as the RED Method, but includes saturation. » La page USE renvoie à une publication ACM Queue et à une conférence de 2012 (non ouvertes).
- En code : chaque route a-t-elle ses trois métriques RED (souvent fournies d'office par `http.server.request.duration` étiquetée par route et statut) ?

---

## 3. Tests côté serveur

### Tester l'accès aux données contre un vrai Postgres éphémère (Testcontainers ou base locale) plutôt que contre un mock du client SQL
- Niveau de preuve : N3
- Source : Testcontainers, s. d., page d'accueil, https://testcontainers.com/ ; Testcontainers, s. d., « Getting started with Testcontainers for Node.js », https://testcontainers.com/guides/getting-started-with-testcontainers-for-nodejs/
- Extrait lu : « Unit tests with real dependencies » ; « No more need for mocks or complicated environment configurations. » ; guide : « talk to the same type of services you use in production, without mocks or in-memory services » ; à propos d'un changement de type de colonne : « you would not have caught this bug ».
- Portée / limites : documentation d'éditeur, qui plaide pour son outil. Node.js et Python figurent parmi les langages pris en charge ; Docker est implicite (« Docker daemon is available! » dans le journal du guide). **Aucune étude empirique comparant mocks et vraie base n'a été lue** (l'étude de Spadini et al., MSR 2017, sur les pratiques de mocking n'a pas pu être ouverte — voir « Non vérifié »).
- En code : les tests d'un repository/`lib/<domaine>` mockent-ils `pg`/`supabase-js` au point de ne jamais exécuter le SQL, les contraintes, les politiques RLS ou les migrations ? Le conteneur est-il démarré dans `beforeAll` et arrêté dans `afterAll` ?

### Réserver les tests de contrat consommateur-fournisseur (Pact) aux intégrations dont on contrôle les deux côtés ; pour une API publique, préférer des tests dérivés du schéma
- Niveau de preuve : N3
- Source : Pact Foundation, s. d., « Introduction », https://docs.pact.io/ ; « What is Pact good for? », https://docs.pact.io/getting_started/what_is_pact_good_for
- Extrait lu : « Contract testing is a technique for testing an integration point by checking each application in isolation » ; pertinent si « You (or your team/organisation/partner organisation) control the development of both the consumer and the provider. » ; à éviter pour « Testing APIs where the consumers cannot be individually identified (eg. public APIs). » et « Performance and load testing. »
- Portée / limites : la documentation de l'outil borne elle-même son usage. Pour un indépendant dont le front et le back vivent dans le même dépôt TypeScript, le type partagé ou le schéma (Zod/OpenAPI) joue souvent ce rôle à moindre coût — c'est une inférence, pas une affirmation de la source.
- En code : la PR change-t-elle la forme d'une réponse consommée par un client hors dépôt (application mobile, webhook partenaire) sans test qui fige cette forme ?

### Utiliser des tests basés sur les propriétés (Hypothesis, fast-check) pour la logique pure à fort espace d'entrées : ils détectent en moyenne bien plus de mutants qu'un test unitaire
- Niveau de preuve : N2 (résumé seul lu)
- Source : Savitha Ravi, Michael Coblenz, 2025, « An Empirical Evaluation of Property-Based Testing in Python » (OOPSLA 2025, DOI 10.1145/3764068 d'après la recherche), https://2025.splashcon.org/details/OOPSLA/102 ; Hypothesis, « Welcome to Hypothesis! », https://hypothesis.readthedocs.io/en/latest/ ; fast-check, https://fast-check.dev/
- Extrait lu : « a corpus study of 426 Python programs that use Hypothesis » ; « evaluated the efficacy of test suites of 40 projects using mutation testing » ; « each property-based test finds about 50 times as many mutations as the average unit test. » ; Hypothesis : « you write tests which should pass for all inputs in whatever range you describe » ; fast-check : « Property-based testing for JavaScript and TypeScript », « can be used within any test runner without any specific integration needed ».
- Portée / limites : mesure en mutants tués, pas en bogues réels ; comparaison « par test », un test de propriété exécutant de nombreux cas ; Python seulement ; méthode non lue en détail. Le coût est connu : Goldstein, Cutler, Dickstein, Pierce, Head, 2024, « Property-Based Testing in Practice », ICSE 2024, https://conf.researchr.org/details/icse-2024/icse-2024-research-track/90/Property-Based-Testing-in-Practice (30 entretiens chez un seul employeur, Jane Street ; résumé seul lu, PDF inaccessible) : « PBT's main strengths lie in testing complex code » ; ses faiblesses « lie in the relative complexity of writing properties and random data generators. »
- En code : une fonction de calcul (prix, TVA, arrondi, fuseaux, parsing) n'a-t-elle que deux ou trois exemples écrits à la main ? Une propriété simple (aller-retour `parse(format(x)) == x`, invariant de somme) est-elle possible ? À l'inverse, un générateur si contraint qu'il ne produit qu'une poignée de valeurs vaut-il mieux qu'un test par exemples ?

### Dériver des tests de robustesse d'API directement du schéma OpenAPI (Schemathesis) pour les endpoints exposés
- Niveau de preuve : N4 (prépublication ; la revue par pairs n'a pas été vérifiée)
- Source : Zac Hatfield-Dodds, Dmitry Dygalo, 2021, « Deriving Semantics-Aware Fuzzers from Web API Schemas », arXiv:2112.10328, https://arxiv.org/abs/2112.10328
- Extrait lu : évaluation de huit fuzzers sur seize services ; Schemathesis trouve « 1.4 times to 4.5 times more unique defects than the respectively second-best fuzzer for each target. »
- Portée / limites : les auteurs évaluent leur propre outil (conflit d'intérêts possible) ; résumé seul lu ; services open source, pas de backend Next.js/Hono mesuré.
- En code : FastAPI génère l'OpenAPI d'office ; un run Schemathesis en CI sur les endpoints livrés trouve-t-il des 500 sur des entrées limites ?

### Utiliser les tests de mutation sur le diff en revue, pas sur tout le dépôt
- Niveau de preuve : N2 (résumés seuls lus)
- Source : Goran Petrović, Marko Ivanković, Gordon Fraser, René Just, 2021, « Does mutation testing improve testing practices? », ICSE 2021, https://arxiv.org/abs/2103.07189 ; mêmes auteurs, 2021, « Practical Mutation Testing at Scale », https://arxiv.org/abs/2102.11378
- Extrait lu (résumés arXiv, via l'API export.arxiv.org) : « By analyzing a large dataset of almost 15 million mutants » ; « Our analyses suggest that developers using mutation testing write more tests, and actively improve their test suites with high quality tests such that fewer mutants remain. » ; « our analyses further provide evidence that mutants are indeed coupled with real faults. » ; second article : « Mutation testing is done incrementally, mutating only changed code during code review, rather than the entire code base » ; « Evaluation in a code-review-based setting with more than 24,000 developers on more than 1,000 projects »
- Portée / limites : contexte Google, outillage interne ; « suggest » : association, pas preuve causale établie (non vérifiable sans le texte intégral). L'outillage de mutation disponible pour JS/TS et Python n'a pas été évalué ici.
- En code : sur une fonction métier critique modifiée, un mutant (`>` -> `>=`, suppression d'un `if`) survit-il à la suite de tests ?

### Commencer un correctif par un test qui échoue avant et passe après — pratique répandue et vérifiable, mais dont l'efficacité n'a pas été mesurée dans les sources lues
- Niveau de preuve : N2 (descriptif, pas d'évaluation d'efficacité)
- Source : Andre Hora, Gordon Fraser, 2026, « Understanding Bug-Reproducing Tests: A First Empirical Study » (AST 2026 d'après arXiv), https://arxiv.org/abs/2602.02965 ; Ding Yuan et al., 2014, OSDI '14 (ci-dessus)
- Extrait lu : Hora & Fraser : « 642 bug-reproducing tests of 15 real-world Python systems » ; ces tests servent « to ensure that future regressions are caught » ; leurs propriétés sont « scarcely researched ». Yuan et al. : « 77% of the failures can be reproduced by a unit test. »
- Portée / limites : Hora & Fraser décrivent ces tests (95 % reproduisent un seul bogue ; un peu plus de `try/except` et d'assertions faibles), sans mesurer si écrire le test **d'abord** réduit les régressions (résumé seul lu). Yuan montre que la reproduction par test unitaire est le plus souvent **possible**, pas qu'elle est plus efficace. Aucune étude comparant « test d'abord » et « test après » pour un correctif n'a été trouvée.
- En code : le commit de correctif contient-il un test, et ce test échoue-t-il sur le commit parent (vérifiable en CI en rejouant le test sur `HEAD~1`) ? L'assertion est-elle forte (`assertEqual` sur la valeur attendue) ou faible (`assertNotEqual`, absence d'exception) ?

### Garder la logique métier hors du handler de route, dans un module appelable sans HTTP — par convention d'architecture, pas sur preuve
- Niveau de preuve : N4
- Source : Alistair Cockburn, 2005 (HaT Technical Report 2005.02, v0.9), « Hexagonal architecture », https://alistair.cockburn.us/hexagonal-architecture/
- Extrait lu : « Allow an application to equally be driven by users, programs, automated test or batch scripts » ; « developed and tested in isolation from its eventual run-time devices and databases. »
- Portée / limites : texte de praticien qui énonce une intention, sans mesure. Aucune étude empirique reliant « logique dans le handler » à un taux de défauts ou à un coût de test n'a été trouvée. Le motif opérationnel le plus solide est indirect : la logique dans le handler oblige à monter une requête HTTP pour la tester, ce qui rend coûteux le test des chemins d'erreur (cf. Yuan et al.).
- En code : le handler fait-il autre chose que parser/valider, appeler `lib/<domaine>`, mapper le résultat en réponse ? Le test d'une règle métier exige-t-il un `Request` simulé ?

---

## 4. Erreurs et exceptions

### Tester explicitement le code de gestion d'erreur : la plupart des pannes graves étudiées venaient d'erreurs signalées mais mal traitées, et ce code est rarement testé
- Niveau de preuve : N2 (198 pannes réelles, texte intégral lu ; enquête auprès de 154 développeurs + 220 bogues, manuscrit accepté lu en entier)
- Source : Ding Yuan et al., 2014, « Simple Testing Can Prevent Most Critical Failures: An Analysis of Production Failures in Distributed Data-Intensive Systems », OSDI '14, https://www.usenix.org/system/files/conference/osdi14/osdi14-paper-yuan.pdf ; Felipe Ebert, Fernando Castor, Alexander Serebrenik, 2015, « An Exploratory Study on Exception Handling Bugs in Java Programs », Journal of Systems and Software 106, DOI 10.1016/j.jss.2015.04.066, https://aserebre.win.tue.nl/FFA.pdf
- Extrait lu : Yuan : « almost all (92%) of the catastrophic system failures are the result of incorrect handling of non-fatal errors explicitly signaled in software. » ; « in 58% of the catastrophic failures, the underlying faults could easily have been detected through simple testing of error handling code. » ; 35 % relèvent de trois motifs triviaux, dont « the error handler is simply empty or only contains a log printing statement ». Ebert : « in 70% of the organizations there are no specific tests for the exception handling code. »
- Portée / limites : Yuan : cinq systèmes distribués de données (Cassandra, HBase, HDFS, MapReduce, Redis), pannes « Blocker/Critical/Major » postérieures à 2010, pas des backends web ; le 92 % porte sur le sous-ensemble des pannes **catastrophiques** ; un autre volet couvre l'article en détail. Ebert : Java, deux projets (Eclipse, Tomcat), enquête déclarative.
- En code : chaque `catch` / `except` d'un endpoint livré est-il exercé par au moins un test (timeout du fournisseur, contrainte unique violée, ligne absente) ? Un `catch` qui ne fait que loguer avale-t-il une erreur qui devrait remonter ?

### Juger un `catch` vide ou trop général sur son contexte, pas par réflexe : rarement cause de bogue dans les rapports, mais présent dans des pannes graves
- Niveau de preuve : N2 (même étude ; texte intégral du manuscrit lu)
- Source : Ebert, Castor, Serebrenik, 2015, https://aserebre.win.tue.nl/FFA.pdf
- Extrait lu : « while overly general catch blocks are a well-known bad smell related to exceptions, bugs stemming from these catch blocks are rare » ; « while developers often mention empty catch blocks as causes of bugs they have fixed in the past, we found very few bug reports caused by them. Moreover, empty catch blocks are frequently used as part of bug fixes »
- Portée / limites : nuance face à Yuan et al. (2014), qui comptent les gestionnaires vides ou « log seulement » parmi les motifs triviaux de 35 % des pannes **catastrophiques** de systèmes distribués. Les deux résultats ne se contredisent pas : rares en nombre de rapports, présents dans les pannes graves. Les travaux de de Pádua & Shang sur anti-patterns d'exception et défauts post-livraison n'ont pas été lus.
- En code : un `catch {}` ou `except: pass` est-il commenté (pourquoi ignorer est correct) et limité à un type d'exception précis ?

---

## 5. Données personnelles dans un backend — Suisse et UE

### En Suisse, collecter pour une finalité déterminée, rester proportionné, et détruire ou anonymiser dès que la donnée n'est plus nécessaire
- Niveau de preuve : N1
- Source : Confédération suisse, 2020 (en vigueur le 01.09.2023 ; état au 07.07.2025), « Loi fédérale sur la protection des données (LPD), RS 235.1 », art. 6, https://www.fedlex.admin.ch/eli/cc/2022/491/fr (texte lu : https://fedlex.data.admin.ch/filestore/fedlex.data.admin.ch/eli/cc/2022/491/20250707/fr/html/fedlex-data-admin-ch-eli-cc-2022-491-20250707-fr-html-1.html)
- Extrait lu : al. 2 « Il doit être conforme aux principes de la bonne foi et de la proportionnalité. » ; al. 3 « Les données personnelles ne peuvent être collectées que pour des finalités déterminées et reconnaissables pour la personne concernée » ; al. 4 « Elles sont détruites ou anonymisées dès qu'elles ne sont plus nécessaires au regard des finalités du traitement. »
- Portée / limites : la loi ne fixe aucune durée chiffrée ; la durée découle de la finalité (et d'autres lois, p. ex. conservation commerciale — non vérifié ici). Champ territorial : la LPD « s'applique aux états de fait qui déploient des effets en Suisse » (art. 3 al. 1). Traiter en violation des art. 6 et 8 « constitue notamment une atteinte à la personnalité » (art. 30 al. 2 let. a).
- En code : chaque colonne personnelle d'une migration a-t-elle un usage identifiable ? Existe-t-il une tâche planifiée qui purge ou anonymise après la durée décidée (comptes inactifs, jetons, journaux) ?

### Intégrer la protection des données dès la conception, et limiter par défaut le traitement au minimum requis par la finalité
- Niveau de preuve : N1
- Source : LPD, RS 235.1, art. 7, même URL
- Extrait lu : al. 1 « Le responsable du traitement est tenu de mettre en place des mesures techniques et organisationnelles afin que le traitement respecte les prescriptions de protection des données, en particulier les principes fixés à l'art. 6. Il le fait dès la conception du traitement. » ; al. 3 « garantir, par le biais de préréglages appropriés, que le traitement des données personnelles soit limité au minimum requis par la finalité poursuivie »
- Portée / limites : les mesures sont « appropriées » au regard de l'état de la technique, du type et de l'étendue du traitement et du risque (al. 2) : l'obligation est proportionnée, pas uniforme. C'est l'exigence que le profil ne mentionne pas aujourd'hui.
- En code : les valeurs par défaut (profil public/privé, partage, champs optionnels, consentements) sont-elles au réglage le plus restrictif ? Un `SELECT *` renvoie-t-il au client des colonnes personnelles inutiles à l'écran ?

### Assurer une sécurité adaptée au risque, y compris la traçabilité des saisies et la détection des violations
- Niveau de preuve : N1
- Source : LPD, art. 8 ; Conseil fédéral, 2022 (état au 01.12.2025), « Ordonnance sur la protection des données (OPDo), RS 235.11 », art. 1 à 3, https://www.fedlex.admin.ch/eli/cc/2022/568/fr (texte lu : https://fedlex.data.admin.ch/filestore/fedlex.data.admin.ch/eli/cc/2022/568/20251201/fr/html/fedlex-data-admin-ch-eli-cc-2022-568-20251201-fr-html-2.html)
- Extrait lu : LPD art. 8 al. 1 « une sécurité adéquate des données personnelles par rapport au risque encouru » ; OPDo art. 2 « ne soient accessibles qu'aux personnes autorisées (confidentialité) » […] « soient traitées de manière à être traçables (traçabilité) » ; art. 3 al. 1 let. a « les personnes autorisées n'aient accès qu'aux données personnelles dont elles ont besoin pour accomplir leurs tâches » ; al. 2 let. f « que les failles critiques connues soient corrigées » ; al. 3 let. a « vérifier quelles données personnelles sont saisies ou modifiées […] par quelle personne et à quel moment (contrôle de la saisie) » ; let. c « les violations de la sécurité des données puissent être rapidement détectées ».
- Portée / limites : les mesures sont choisies « en fonction du besoin de protection » (art. 2) et réévaluées « pendant toute la durée du traitement » (art. 1 al. 5). Sanction : amende jusqu'à 250 000 francs, sur plainte, pour les personnes privées qui, intentionnellement, « ne respectent pas les exigences minimales en matière de sécurité des données édictées par le Conseil fédéral » (LPD art. 61 let. c). Le niveau exigé pour une application précise relève d'un juriste.
- En code : les politiques RLS restreignent-elles chaque table au besoin (pas de `service_role` côté client) ? Les dépendances ont-elles une veille de failles ? Les tables personnelles ont-elles `created_by`/`updated_by`/`updated_at` ou une table d'audit ?

### En Suisse, la journalisation des accès n'est imposée aux privés que dans des cas précis ; elle est alors conservée au moins un an, à part
- Niveau de preuve : N1
- Source : OPDo, RS 235.11, art. 4 (nouvelle teneur des al. 1 et 3 en vigueur depuis le 01.12.2025, RO 2025 694), URL ci-dessus
- Extrait lu : al. 1 « Lors de traitements automatisés de données sensibles à grande échelle ou de profilages à risque élevé et lorsque les mesures préventives ne suffisent pas à garantir la protection des données, le responsable du traitement privé et son sous-traitant privé journalisent au moins l'enregistrement, la modification, la communication, l'effacement et la destruction des données ainsi que l'accès aux données. » ; al. 4 « l'identité de la personne qui a effectué le traitement, la nature, la date et l'heure du traitement » ; al. 5 « Les procès-verbaux de journalisation sont conservés durant au moins un an, séparément du système dans lequel les données personnelles sont traitées. »
- Portée / limites : l'« un an » est une durée **minimale** pour ces procès-verbaux, pas un plafond ni une règle générale de rétention des logs applicatifs. Les données sensibles sont définies à l'art. 5 let. c LPD (santé, opinions, biométrie, poursuites pénales, aide sociale, etc.). Hors de ces cas, l'obligation générale de traçabilité de l'OPDo art. 3 al. 3 reste applicable. La teneur antérieure au 01.12.2025 n'a pas été comparée.
- En code : l'application traite-t-elle des données sensibles à grande échelle (santé, p. ex.) ? Si oui, existe-t-il un journal d'accès séparé de la base applicative, conservé au moins un an, dont l'accès est restreint (al. 5, dernière phrase) ?

### Annoncer au PFPDT « dans les meilleurs délais » une violation à risque élevé — la loi suisse ne fixe pas de nombre d'heures
- Niveau de preuve : N1 (loi) et N3 (guide de l'autorité)
- Source : LPD art. 24 ; OPDo art. 15 ; PFPDT, 2025 (v1.2 du 23.04.2025), « Guide relatif à l'annonce des violations de la sécurité des données et l'information des personnes concernées en vertu de l'art. 24 LPD », https://www.edoeb.admin.ch/dam/fr/sd-web/T64CAUyvAMcF/1_2%20Leitfaden%20des%20ED%C3%96B%20betreffend%20die%20Meldung%20von%20Datensicherheitsverletzungen%20und%20Information%20der%20Betroffenen%20nach%20Art.%2024%20DSG_FR.pdf
- Extrait lu : LPD art. 24 al. 1 « Le responsable du traitement annonce dans les meilleurs délais au PFPDT les cas de violation de la sécurité des données entraînant vraisemblablement un risque élevé » ; al. 3 « Le sous-traitant annonce dans les meilleurs délais au responsable du traitement tout cas de violation » ; OPDo art. 15 al. 4 « Le responsable du traitement documente les violations. […] Elle est conservée pendant au moins deux ans » ; guide : « dans le cas d'une attaque par rançongiciel, une première analyse devra, selon les circonstances, supposer un « risque vraisemblablement élevé » » ; le PFPDT peut demander que l'incident soit documenté « p. ex. par la sauvegarde de procès-verbaux de journalisation ».
- Portée / limites : l'annonce passe par le portail `databreach.edoeb.admin.ch` (guide) ; les compléments sont admis (OPDo art. 15 al. 2). Contenu minimal : OPDo art. 15 al. 1 let. a à g (nature, moment, catégories et nombre approximatif de données et de personnes, conséquences, mesures, contact).
- En code / exploitation : les journaux permettent-ils de répondre aux questions de l'art. 15 al. 1 (quand, combien de lignes, quelles personnes) ? Le contrat avec chaque sous-traitant (hébergeur, Supabase) prévoit-il qu'il vous avertisse ?

### Côté UE, notifier l'autorité de contrôle dans les 72 heures si possible — si le RGPD s'applique à l'application
- Niveau de preuve : N1
- Source : Parlement européen et Conseil, 2016, « Règlement (UE) 2016/679 (RGPD) », art. 3 par. 2 et art. 33 par. 1, JO L 119 du 4.5.2016, texte lu : https://publications.europa.eu/resource/cellar/3e485e15-11bd-11e6-ba9a-01aa75ed71a1.0009.03/DOC_1 (référence : https://eur-lex.europa.eu/legal-content/FR/TXT/HTML/?uri=CELEX:32016R0679)
- Extrait lu : art. 33 par. 1 « dans les meilleurs délais et, si possible, 72 heures au plus tard après en avoir pris connaissance, à moins que la violation en question ne soit pas susceptible d'engendrer un risque » ; art. 3 par. 2 : s'applique au responsable « qui n'est pas établi dans l'Union, lorsque les activités de traitement sont liées: a) à l'offre de biens ou de services à ces personnes concernées dans l'Union » ou « b) au suivi du comportement de ces personnes ».
- Portée / limites : seuil plus bas qu'en Suisse (« risque » contre « risque élevé ») et délai chiffré. Le texte lu est celui du JO de 2016, sans les rectificatifs ultérieurs (non vérifiés). Savoir si une application suisse « offre des services » à des personnes dans l'UE relève d'un juriste ; l'art. 27 (représentant dans l'Union) n'a pas été lu.
- En code / exploitation : l'alerte qui détecte une fuite (accès anormal, export massif) parvient-elle à une personne capable de décider dans les 72 heures ?

### Appliquer minimisation et limitation de la conservation, fixer la durée par traitement (pas une seule durée maximale pour tout), et pouvoir le démontrer
- Niveau de preuve : N1
- Source : RGPD, art. 5, URL Cellar ci-dessus
- Extrait lu : par. 1 let. c « adéquates, pertinentes et limitées à ce qui est nécessaire au regard des finalités pour lesquelles elles sont traitées (minimisation des données) » ; let. e « conservées sous une forme permettant l'identification des personnes concernées pendant une durée n'excédant pas celle nécessaire » ; par. 2 « Le responsable du traitement est responsable du respect du paragraphe 1 et est en mesure de démontrer que celui-ci est respecté (responsabilité). »
- Portée / limites : « démontrer » suppose une trace écrite (durées décidées, motifs). En Suisse, le registre des activités de traitement (LPD art. 12, qui inclut « dans la mesure du possible, le délai de conservation ») n'est pas obligatoire pour une entreprise de moins de 250 collaborateurs ni pour une personne physique, sauf données sensibles à grande échelle ou profilage à risque élevé (OPDo art. 24). Écueil relevé par les autorités de l'UE (EDPB, 2026, rapport CEF 2025 sur le droit à l'effacement, https://www.edpb.europa.eu/system/files/2026-02/edpb_cef-report_2025_right-to-erasure_en.pdf) : « one controller was unable to distinguish the appropriate retention periods for different processing operations and instead applied the longest period applicable to one processing activity to all of them. » Les durées légales de conservation (comptabilité, etc.) ne sont pas traitées ici.
- En code : la durée de conservation de chaque table et des journaux est-elle écrite quelque part (README, ADR, commentaire de migration) et appliquée par du code ? La purge est-elle paramétrée par catégorie (sessions, factures, journaux) plutôt que par une seule constante ?

### Concevoir la suppression comme une fonctionnalité : procédures, automatisation, effectivité vérifiée, durées pour sauvegardes et journaux
- Niveau de preuve : N1 (RGPD art. 25) et N3 (lignes directrices EDPB)
- Source : RGPD art. 25 par. 1-2 ; EDPB, 2020, « Guidelines 4/2019 on Article 25 Data Protection by Design and by Default », version 2.0 adoptée le 20 octobre 2020, https://www.edpb.europa.eu/sites/default/files/files/file1/edpb_guidelines_201904_dataprotection_by_design_and_by_default_v2.0_en.pdf
- Extrait lu : RGPD art. 25 par. 2 « Cela s'applique à la quantité de données à caractère personnel collectées, à l'étendue de leur traitement, à leur durée de conservation et à leur accessibilité. » ; EDPB par. 53 « If personal data is no longer necessary for the purpose of the processing, then it shall by default be deleted or anonymized. » ; par. 82 : « Effectiveness of anonymization/deletion – The controller shall make sure that it is not possible to re-identify anonymized data or recover deleted data, and should test whether this is possible. » ; « Automation – Deletion of certain personal data should be automated » ; « Backups/logs – Controllers shall determine what personal data and length of storage is necessary for back-ups and logs. »
- Portée / limites : lignes directrices de l'EDPB (UE), sans force de loi en Suisse ; elles interprètent l'art. 25 RGPD, dont l'art. 7 LPD est le pendant suisse. « Recover deleted data » vise la récupérabilité : elle pèse contre une suppression purement logique (voir § 6).
- En code : la suppression d'un compte est-elle un endpoint ou un job testé, qui couvre toutes les tables liées, le stockage de fichiers (bucket) et les copies chez des tiers (e-mailing, analytics) ? Un test vérifie-t-il qu'aucune ligne ne subsiste ?

### Pseudonymiser et chiffrer selon le risque, sans confondre pseudonymisation et anonymisation
- Niveau de preuve : N1
- Source : RGPD art. 4 (définition), art. 32 par. 1 let. a, considérant 26, URL Cellar ci-dessus
- Extrait lu : art. 32 par. 1 « y compris entre autres, selon les besoins: a) la pseudonymisation et le chiffrement des données à caractère personnel » ; considérant 26 « Les données à caractère personnel qui ont fait l'objet d'une pseudonymisation et qui pourraient être attribuées à une personne physique par le recours à des informations supplémentaires devraient être considérées comme des informations concernant une personne physique identifiable. »
- Portée / limites : « selon les besoins » : le chiffrement n'est pas imposé uniformément. L'art. 32 par. 1 let. d demande aussi une procédure pour « tester, à analyser et à évaluer régulièrement l'efficacité » des mesures. Les lignes directrices EDPB 4/2019 recommandent : « Personal data and back-ups/logs should be pseudonymized as a security measure […] for example using hashing or encryption. »
- En code : un `user_id` haché dans les journaux est-il traité comme encore personnel (durée de conservation, accès restreint) ? Les secrets et colonnes à risque (jetons OAuth tiers, coordonnées bancaires si présentes) sont-ils chiffrés au repos au-delà du chiffrement disque du fournisseur ?

### Prévoir les endpoints d'exercice des droits : accès (30 jours en règle générale en Suisse), remise des données dans un format courant, effacement
- Niveau de preuve : N1
- Source : LPD art. 25, 28, 32 ; RGPD art. 17, URLs ci-dessus
- Extrait lu : LPD art. 25 al. 2 let. b « les données personnelles traitées en tant que telles » et let. d « la durée de conservation des données personnelles ou, si cela n'est pas possible, les critères pour fixer cette dernière » ; al. 7 « En règle générale, les renseignements sont fournis dans un délai de 30 jours. » ; art. 28 al. 1 « qu'il lui remette sous un format électronique couramment utilisé les données personnelles la concernant qu'elle lui a communiquées » ; art. 32 al. 2 let. c (action civile) « l'effacement ou la destruction de données personnelles » ; RGPD art. 17 par. 1 « le responsable du traitement a l'obligation d'effacer ces données à caractère personnel dans les meilleurs délais, lorsque l'un des motifs suivants s'applique »
- Portée / limites : la LPD ne connaît pas un « droit à l'effacement » calqué sur le RGPD ; l'effacement s'obtient notamment par l'action de l'art. 32 al. 2 let. c, et le traitement « contre la manifestation expresse de la volonté de la personne concernée » constitue une atteinte (art. 30 al. 2 let. b). Le droit RGPD a des exceptions (art. 17 par. 3 : obligation légale, archives, etc.). La loi n'impose pas un endpoint automatisé ; c'est un moyen de tenir les délais.
- En code : existe-t-il une fonction `exportUserData(userId)` (JSON) et `deleteUser(userId)` qui parcourent le même inventaire de tables ? Une table ajoutée par la PR est-elle ajoutée à cet inventaire ?

### Vérifier où partent les données : la communication à l'étranger est encadrée
- Niveau de preuve : N1
- Source : LPD art. 16 al. 1-2, URL ci-dessus
- Extrait lu : al. 1 « Des données personnelles peuvent être communiquées à l'étranger si le Conseil fédéral a constaté que l'État concerné dispose d'une législation assurant un niveau de protection adéquat » ; al. 2 : à défaut, par exemple par « des clauses type de protection des données préalablement approuvées, établies ou reconnues par le PFPDT »
- Portée / limites : la liste des États adéquats figure dans l'annexe 1 de l'OPDo (non lue ici). Communiquer à l'étranger en violation de l'art. 16 est passible d'amende (art. 61 let. a). L'application à un hébergeur ou à un service de logs précis relève d'un juriste.
- En code : la PR ajoute-t-elle un service tiers (télémétrie, logs, IA, e-mail) qui reçoit des données personnelles ? Sa région d'hébergement et son DPA sont-ils connus ?

---

## 6. Effacement et rétention

### Pour les sauvegardes, tracer les demandes d'effacement et les réappliquer à la restauration, à défaut de pouvoir modifier la sauvegarde ; borner la rétention des sauvegardes
- Niveau de preuve : N3
- Source : EDPB, 2026, « 2025 Coordinated Enforcement Action — Implementation of the right to erasure by controllers » (adopté le 10 février 2026), https://www.edpb.europa.eu/system/files/2026-02/edpb_cef-report_2025_right-to-erasure_en.pdf
- Extrait lu : « Depending on the technical settings and risks, it might not always be advisable to modify or delete information from back-ups. But, in that case, organisations should have appropriate procedures to keep track of erasure requests and comply with them on restored systems » ; « Half of the responding SAs raised concerns regarding the deletion of personal data in this context. » ; recommandation : « Verify that erasure has been carried out and be able to demonstrate such erasure. »
- Portée / limites : rapport d'une action coordonnée de 32 autorités de l'EEE en 2025 ; l'EDPB annonce qu'il « may consider » des orientations supplémentaires sur les sauvegardes et le sens de « without undue delay ». Pas de règle chiffrée. Pratique citée : remplacer les données à effacer par des chaînes aléatoires.
- En code / exploitation : la durée de rétention des sauvegardes (point-in-time recovery du fournisseur) est-elle connue et documentée ? Existe-t-il une table « effacements à rejouer » consultée après une restauration ?

### Traiter la suppression logique (`deleted_at`) comme une restriction temporaire, pas comme l'effacement
- Niveau de preuve : N3 (inférence à partir de lignes directrices et d'un rapport ; aucune source lue ne nomme « soft delete »)
- Source : EDPB, 2020, Guidelines 4/2019, par. 82, URL ci-dessus ; EDPB, 2026, rapport CEF 2025, section 4.2.4 (exemples 1 et 2), URL ci-dessus
- Extrait lu : Guidelines : « make sure that it is not possible to […] recover deleted data » ; rapport CEF : « The controller is not certain if the erasure request is going to be granted and needs time to analyse the request. In such a case, a restriction of processing under Art. 18 GDPR could be applied. » ; « The controller intends to comply with the erasure request but requires additional time to implement it technically. In such cases, anonymisation of the data could serve as a technical safeguard »
- Portée / limites : **aucune** des sources lues ne qualifie expressément une colonne `deleted_at` ; la conclusion « une ligne marquée supprimée mais lisible n'est pas effacée » est une déduction de la formule « recover deleted data ». À faire valider par un juriste pour un cas réel.
- En code : une suppression logique est-elle suivie d'une suppression réelle ou d'une anonymisation planifiée (job daté) ? Les politiques RLS et les requêtes excluent-elles bien les lignes marquées en attendant ?

---

## Verdict sur les règles du profil

| Règle du profil | Verdict | Motif sourcé |
|---|---|---|
| « Observabilité minimale : logs structurés (JSON ou format de la stack) avec un identifiant de corrélation par requête ; erreurs 5xx loggées avec contexte (route, user id — jamais de PII complète) ; latences des appels sortants mesurables. » | **Soutenue, à préciser** | Logs structurés et identifiant d'interaction : OWASP Logging Cheat Sheet (N3), ASVS 5.0 V16.2.4 (N1). Latences sortantes : `http.client.request.duration`, histogramme stable (OTel, N3). À préciser : (1) propager `traceparent` W3C plutôt qu'un identifiant maison (N1) ; (2) `route` = gabarit à faible cardinalité, pas le chemin brut (OTel, MUST) ; (3) le `user id` est une donnée personnelle (LPD art. 5 let. a) : son haché aussi (RGPD cons. 26 ; OTel) — sa présence se justifie, mais la durée de conservation des logs doit être fixée ; (4) les 4xx ne sont pas des erreurs côté serveur dans les traces (OTel, MUST). |
| « Jamais de log de password/token/PII complet. » | **Soutenue, à préciser** | OWASP « Data to exclude » et ASVS 16.2.5 (N3/N1). À préciser : la liste OWASP couvre aussi identifiants de session (hachés si nécessaire), chaînes de connexion, clés, données bancaires, données hors consentement ; « PII complète » laisse croire qu'une PII partielle serait libre — la minimisation (LPD art. 6 al. 2 et 7 al. 3 ; RGPD art. 5 par. 1 let. c) s'applique aussi aux journaux, et l'EDPB demande de fixer une durée pour « back-ups and logs ». |
| « Tests : je couvre au minimum les contrats I/O, la validation des inputs et les chemins d'erreur des endpoints livrés. » | **Soutenue pour les chemins d'erreur ; convention pour le reste** | Chemins d'erreur : Yuan et al. 2014 (N2, 92 % des pannes catastrophiques liées à une erreur signalée mal traitée, 58 % détectables par un test simple) et Ebert et al. 2015 (N2, 70 % des organisations sans test dédié). Contrats I/O : Schemathesis (N4, prépublication) et Pact (N3, à réserver aux intégrations contrôlées des deux côtés). Aucune preuve trouvée qu'un « minimum » précis soit optimal. Ajouter : tests contre une vraie base (Testcontainers, N3) pour le code d'accès aux données. |
| « Logique métier dans le handler de route au lieu de `lib/<domain>.ts` testable » (anti-pattern) | **Convention sans preuve trouvée** | Seule source : intention de l'architecture hexagonale (Cockburn 2005, N4). Aucune étude reliant cet emplacement à des défauts. Motif défendable par inférence : rendre bon marché le test des chemins d'erreur (Yuan et al.). |
| « Un correctif de bug commence par le test qui le reproduit. » | **Convention sans preuve trouvée (d'efficacité) ; faisabilité soutenue** | 77 % des pannes étudiées par Yuan et al. sont reproductibles par un test unitaire (N2) ; Hora & Fraser 2026 décrivent 642 tests de reproduction sans mesurer l'effet de l'ordre « test d'abord » (N2, résumé seul). Aucune étude comparative trouvée. La règle reste une bonne pratique vérifiable (le test doit échouer sur le commit parent). |
| (Absence) Protection des données dès la conception, durées de conservation, effacement | **Contredite par le droit : lacune à combler** | LPD art. 6 al. 3-4 (finalité, destruction ou anonymisation dès que non nécessaire), art. 7 (dès la conception et par défaut), art. 8 + OPDo art. 1-3 (sécurité, traçabilité), art. 25 et 28 (accès sous 30 jours en règle générale, remise des données) — N1, en vigueur depuis le 01.09.2023. Si le RGPD s'applique (art. 3 par. 2, à qualifier par un juriste) : art. 5, 17, 25, 32, 33 (72 h). Ce sont des obligations du responsable du traitement ; leur traduction en exigences de code (inventaire des tables, purge planifiée, export/suppression testés) est une inférence d'ingénierie. |

---

## Mythes et affirmations contestées

- **« En Suisse, il faut annoncer une fuite en 72 heures. »** Faux pour la LPD : « dans les meilleurs délais », et seulement pour un risque « vraisemblablement élevé » (art. 24 al. 1). Les 72 heures sont celles du RGPD (art. 33 par. 1), avec un seuil de risque plus bas. Le guide du PFPDT ne donne pas de nombre d'heures, mais précise qu'en cas de rançongiciel on ne peut pas attendre des clarifications longues.
- **« La nLPD impose de journaliser tous les accès et de garder les logs un an. »** Faux pour un responsable privé en général : l'OPDo art. 4 al. 1 limite cette obligation aux traitements automatisés de données sensibles à grande échelle ou aux profilages à risque élevé, quand les mesures préventives ne suffisent pas. L'« un an » est un **minimum** pour ces procès-verbaux-là, conservés séparément (al. 5), pas une règle de rétention des logs applicatifs. L'art. 4 a été modifié au 01.12.2025 : une source antérieure peut être périmée.
- **« Hacher l'identifiant suffit à anonymiser les journaux. »** Faux : une donnée pseudonymisée reste une donnée personnelle (RGPD cons. 26) ; OpenTelemetry avertit que le hachage n'anonymise pas un espace d'identifiants petit ou prévisible.
- **« Une colonne `deleted_at` répond au droit à l'effacement. »** Non soutenu : l'EDPB demande qu'il ne soit pas possible de « recover deleted data » (Guidelines 4/2019, par. 82). La suppression logique peut servir de restriction temporaire (art. 18 RGPD, rapport CEF 2025) en attendant l'effacement réel ou l'anonymisation. (Inférence ; à valider par un juriste.)
- **« Il faut purger immédiatement les sauvegardes. »** Nuancé par l'EDPB (rapport CEF 2025) : modifier une sauvegarde n'est pas toujours souhaitable ; il faut alors tracer les demandes et les réappliquer à la restauration, et borner la rétention des sauvegardes.
- **« Les `catch` vides sont une cause majeure de bogues. »** Contesté : Ebert et al. (2015) trouvent très peu de rapports de bogues causés par eux et les voient utilisés dans des correctifs ; Yuan et al. (2014) comptent les gestionnaires vides ou « log seulement » parmi les motifs triviaux de 35 % des pannes catastrophiques de systèmes distribués. Rares en volume, graves quand ils frappent.
- **« Les 4xx sont des erreurs à compter dans le taux d'erreur serveur. »** Contraire aux conventions OTel : pour un span serveur, le statut d'un 4xx « MUST be left unset ». Un 4xx en masse peut néanmoins signaler un problème client ou une attaque — il se suit à part.
- **« Les logs OpenTelemetry sont stables. »** À préciser : le modèle de données est stable, mais les SDK de logs JavaScript et Python sont au statut « Development » (page Status, consultée le 09.11.2026).
- **« Le RGPD ne concerne pas un développeur établi en Suisse. »** Pas nécessairement : l'art. 3 par. 2 vise un responsable non établi dans l'Union dont le traitement est lié à l'offre de services à des personnes dans l'Union ou au suivi de leur comportement. La qualification relève d'un juriste.
- **« Le test de contrat (Pact) est la bonne façon de tester toute API. »** La documentation de Pact elle-même l'écarte pour les API publiques, les tests de charge et les cas où l'autre équipe n'utilise pas Pact.

---

## Non vérifié

- **Texte intégral** de Goldstein et al. (ICSE 2024 ; PDF inaccessible : erreur de certificat sur cis.upenn.edu, puis 503 ; dl.acm.org en 403), de Ravi & Coblenz (OOPSLA 2025 ; DOI 10.1145/3764068 relevé par la recherche, page DOI non ouverte), de Petrović et al. (ICSE 2021 et « Practical Mutation Testing at Scale ») et de Hora & Fraser (2026) : **résumés seuls lus** (résumés arXiv de Petrović et al. relus mot pour mot via l'API export.arxiv.org). La méthode, les échantillons détaillés et les limites déclarées de ces articles ne sont donc pas vérifiés.
- **Spadini, Aniche, Bruntink, Bacchelli, « To Mock or Not To Mock? » (MSR 2017)** : ni le PDF (connexion réinitialisée) ni le résumé (503, page sans résumé) n'ont pu être lus. Aucune étude empirique comparant mocks et vraie base n'a donc été lue.
- **de Pádua & Shang** (ICPC 2017 ; travail de 2018 sur anti-patterns d'exception et défauts post-livraison) : non lus.
- **Venue de la prépublication Schemathesis** (arXiv:2112.10328) : la revue par pairs n'a pas été vérifiée.
- **Année de la release OTel semconv v1.23.0** : la page affiche « 03 Nov » sans l'année ; 2023 est déduite du chemin du billet de blog.
- **Date de la page USE Method** : seule la mise à jour (24.08.2017) est affichée ; l'origine 2012 est rapportée par la page (ACM Queue, FISL13), non ouverte.
- **Rectificatifs du RGPD** : le texte lu est celui du JO L 119 du 4.5.2016 ; une formulation française a pu être rectifiée depuis.
- **Annexe 1 de l'OPDo** (États à protection adéquate) et **art. 27 RGPD** (représentant dans l'Union) : non lus.
- **Teneur de l'OPDo art. 4 avant le 01.12.2025** : non comparée.
- **Durées de rétention des sauvegardes et des journaux chez Supabase/Vercel** : non vérifiées ; à lire dans la documentation du fournisseur au moment de s'en servir.
- **Toute application de ces textes à un cas précis** (données sensibles ou non, RGPD applicable ou non, durée de conservation justifiée) : relève d'un juriste.

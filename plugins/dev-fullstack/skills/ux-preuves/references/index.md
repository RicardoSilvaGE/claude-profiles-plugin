# Fiche `ux-preuves` — Index détaillé des fiches et niveaux par domaine

> Sorti du `SKILL.md` le 10.11.2026 (v1.9) pour alléger ce qu'il précharge chez les agents. À ouvrir
> pour savoir **quelle fiche couvre quoi**, ou comment les trois niveaux (exigence, défaut fondé sur
> des preuves, convention) se déclinent dans un domaine.

## Ce que couvre chaque fiche

| Fiche | Couvre |
|---|---|
| `references/cognition-chemin-usage.md` | Comment une personne agit, cherche, décide, se trompe et apprend : sept étapes de l'action et gouffres d'exécution et d'évaluation, modèles mentaux, fourrage d'information, satisficing et effet du défaut, slips et mistakes, cognitive walkthrough, KLM, attention, habitudes, charge cognitive. **La fiche du chemin logique d'usage** : à ouvrir pour cartographier tout parcours |
| `references/formulaires-navigation-mobile.md` | Formulaires et saisie, checkout, mots de passe ; navigation, architecture d'information, recherche interne ; mobile et tactile ; temps de réponse et performance perçue |
| `references/contenus-documents-accessibilite.md` | Lecture à l'écran, langage clair (ISO 24495-1), documents longs, PDF et Office, tableaux ; WCAG 2.2, WCAG 3, EAA, RGAA, accessibilité cognitive |
| `references/ia-ethique-onboarding.md` | Interfaces avec IA et agents (confiance, sur-confiance, incertitude, citations) ; dark patterns et réglementation (DSA, CNIL, FTC) ; onboarding, états vides, notifications, undo contre confirmation |
| `references/normes-lois-methodes.md` | ISO 9241-11, -110, -210 ; « lois UX » (Hick, Fitts, mémoire de travail, peak-end, esthétique-utilisabilité, Jakob, Tesler, position sérielle, Zeigarnik) avec leur source primaire et où l'usage courant la dépasse ; sévérité, tests, SUS, SEQ, taille d'échantillon, first-click, A/B, HEART, JTBD, Kano |
| `references/design-perception-esthetique.md` | **Design visuel.** Premières impressions, complexité visuelle et prototypicalité, crédibilité, signifiants (flat design), icônes, hiérarchie et saillance, Gestalt mesurée, images |
| `references/design-couleur-contraste.md` | **Design visuel.** Contraste WCAG 2.2 complet (texte, non textuel, focus, placeholder), APCA et son statut réel, contraste du web réel, vision des couleurs, psychologie des couleurs, OKLCH, mode sombre |
| `references/design-typographie-mise-en-page.md` | **Design visuel.** Taille critique de lecture, hauteur d'x, serif ou sans-serif, texte qui grandit (WCAG 1.4.4, 1.4.10, 1.4.12), tailles des plateformes, grilles et échelles (conventions), densité, polices web |
| `references/design-motion-etats-systemes.md` | **Design visuel.** Durées et courbes d'animation, mouvement et accessibilité, états des composants (focus natif ou personnalisé, hover au tactile, désactivé), tokens DTCG, preuves d'effet des design systems |
| `references/design-front-recent.md` | **Design visuel.** Liquid Glass, Material 3 Expressive et ce que Google publie vraiment, homogénéisation et fixation par l'IA générative, accessibilité des interfaces générées, Web Almanac 2025, capacités CSS Baseline, tendances sans mesure |
| `references/redaction-microcopy.md` | **Rédaction.** Libellés d'action et dialogues, messages d'erreur (problème, cause, solution), états vides et notifications, liens et noms accessibles (WCAG 2.4.4, 2.4.6, 2.5.3, 4.1.3), textes alternatifs, casse et chiffres, concision, guides de style, emoji |
| `references/redaction-voix-ton-inclusif.md` | **Rédaction.** Ton mesuré, humour et excuses, tu/vous, du/Sie, tú/usted, « je » de la machine, langage inclusif par langue et par pays avec positions officielles datées (France, Confédération suisse, Québec, anglais), confirmshaming |
| `references/redaction-i18n-locales.md` | **Rédaction.** Expansion des traductions (table dégressive), pluriels CLDR 49, ICU MessageFormat 2, anti-patterns d'i18n, formats par locale et divergence suisse, pseudo-localisation, bidi, glossaire (ISO 704, TBX), repli de langue |
| `references/redaction-orthotypographie.md` | **Rédaction.** fr-FR, fr-CH, de-CH, en, es, it : espaces, guillemets, nombres, montants, heures, casse ; textes officiels suisses contre CLDR ; U+202F et sous-ensembles de polices ; table des règles minimales par locale |
| `references/redaction-traduction-ia.md` | **Rédaction.** Traduction par LLM (WMT 2024-2025), translationese et passe de polissage, genre et registre par défaut, contexte des chaînes, relecture native (ISO 17100, 18587), microcopy générée, uniformisation du style, AI Act art. 50 |
| `references/growth-science-marketing.md` | **Growth.** Lois empiriques Ehrenberg-Bass (double jeopardy, disponibilité mentale, pénétration), base IPA de Binet & Field (marque et activation, B2B), positionnement (praticiens), bénéfice ou attribut selon l'expertise, parrainage et NPS, croissance par le produit, lancements |
| `references/growth-conversion-persuasion.md` | **Growth.** Taux de succès réels des tests A/B et calcul de puissance, preuve sociale et avis, prix (chiffres en 9, essai gratuit, renouvellement automatique), titres, urgence et rareté, pages d'atterrissage, formules de copywriting |
| `references/growth-aso-stores.md` | **Growth.** Limites et politiques de métadonnées Play et App Store (titre Play à 30), expériences sur les fiches, notes et demandes d'avis, localisation, Data safety et App Privacy, applications pour enfants, mots-clés |
| `references/growth-emails-droit.md` | **Growth.** Exigences Gmail, Yahoo, Outlook, DMARC (RFC 9989), désabonnement en un clic, taux d'ouverture et ses limites (Apple MPP, CNIL 2026), LCD let. o et nLPD, ePrivacy et RGPD, CAN-SPAM, CASL, séquences mesurées |
| `references/growth-seo-ia-droit-publicite.md` | **Growth.** Google Search Essentials, contenu utile, E-E-A-T, résumés IA et clics, GEO et ses limites, faux avis (UE, Suisse, FTC), prix barrés (UE 30 jours, OIP art. 16), allégations environnementales, publicité comparative, influence |
| `references/frontend-performance.md` | **Frontend.** Core Web Vitals et mesure terrain, poids du JavaScript, rendu et hydratation, image LCP et formats, navigation (bfcache, prérendu), réseau et cache, re-renders et React Compiler |
| `references/frontend-react-next.md` | **Frontend.** React 19 et Effects, Next.js 16 (Cache Components, `proxy.ts`, Server Actions = POST publics), état serveur et client, formulaires et Zod 4, Tailwind v4, shadcn et Base UI, auth (Better Auth, Supabase), TypeScript 7, outillage |
| `references/frontend-accessibilite-code.md` | **Frontend.** ARIA et ses risques mesurés, éléments natifs (`<dialog>`, popover), changements de route en SPA, régions live, formulaires accessibles, limites des tests automatiques, mouvement et couleurs forcées |
| `references/frontend-qualite-securite.md` | **Frontend.** Effet mesuré du typage, tests et couverture, tests instables, error boundaries, XSS, CSP stricte, secrets et jetons, chaîne d'approvisionnement npm, risque des dépendances |
| `references/frontend-code-ia-plateforme.md` | **Frontend.** Sécurité du code généré par LLM, paquets hallucinés, API dépréciées, maintenabilité, pratiques mesurées ; ce que la plateforme web fait nativement en 2025-2026, avec statut Baseline daté |
| `references/securite-menaces-priorisation.md` | **Sécurité.** OWASP Top 10:2025 (liste vérifiée), CVSS v4.0 et ses limites, EPSS, catalogue CISA KEV, BOD 26-04 et SSVC, atteignabilité, LINDDUN, grilles de sévérité |
| `references/securite-outils-detection.md` | **Sécurité.** Efficacité mesurée de l'analyse statique, de l'analyse des dépendances, de la détection de secrets, des tests dynamiques et de la revue humaine |
| `references/securite-incidents-secrets.md` | **Sécurité.** NIST SP 800-61 Rev. 3, secret fuité (découverte, révocation, purge), rotation, rétention des journaux Vercel, Supabase et GitHub, post-mortem, comptes et outillage compromis |
| `references/securite-plateforme-deploiement.md` | **Sécurité.** En-têtes, cookies, TLS, failles Next.js et React, Vercel, Supabase, GitHub Actions, auto-hébergement |
| `references/securite-llm-agents.md` | **Sécurité.** OWASP LLM 2025 et Agentic 2026, injection de prompt et limites des défenses, MCP (spécification 2026-07-28), LLM comme auditeur de sécurité |
| `references/architecture-decisions-adr.md` | **Architecture.** Formats d'ADR (Nygard, MADR), ISO/IEC/IEEE 42010, arc42, C4, recherche sur la décision d'architecture et ses biais (alternatives, ancrage), réversibilité, érosion, seuil d'un ADR |
| `references/architecture-qualites-nfr.md` | **Architecture.** ISO/IEC 25010:2023, scénarios de qualité et ATAM, risques d'omission, NFR en pratique, mythe du surcoût ×100, fitness functions, modélisation des menaces, Well-Architected, DORA, local-first |
| `references/architecture-modularite-dette.md` | **Architecture.** Parnas, loi de Conway et mirroring, monolithe modulaire et microservices, couplage et livraison, dette technique, churn et défauts, YAGNI et abstraction prématurée |
| `references/architecture-dependances-build-buy.md` | **Architecture.** Truck factor et abandon, OpenSSF Scorecard et Concise Guide, dépréciations, licences et SBOM, Cyber Resilience Act, Data Act et coût de sortie, make-or-buy |
| `references/architecture-risques-estimation-llm.md` | **Architecture.** Pre-mortem, estimation et ancrage, dépassements des projets informatiques, ISO 31000 et matrices de risque, spikes, biais cognitifs, LLM et décisions d'architecture, flagornerie |
| `references/backend-securite-api-auth.md` | **Backend.** OWASP API Top 10 et ASVS 5.0, autorisation sur l'objet, stockage des mots de passe (Argon2id, scrypt, PBKDF2), NIST SP 800-63B-4, sessions et JWT, anti-force brute, CSRF, CORS, SSRF, injection SQL et API brutes des ORM, OAuth, ordre des contrôles dans un handler |
| `references/backend-donnees-postgres.md` | **Backend.** Migrations PostgreSQL sans interruption (verrous, `lock_timeout`, `CONCURRENTLY`, `NOT VALID`), expand/contract, index, pagination par curseur, transactions et isolation, contraintes contre validations applicatives, ORM et N+1, pools et serverless, RLS Supabase, PostgreSQL 18, SQLite |
| `references/backend-fiabilite-contrats-api.md` | **Backend.** Timeouts, retries, jitter et budgets, pannes métastables, gestion d'erreur et pannes réelles, idempotence, outbox et webhooks, codes HTTP et Problem Details, pagination, temps réel, files |
| `references/backend-observabilite-tests-donnees.md` | **Backend.** Journaux structurés, W3C Trace Context et OpenTelemetry, SLO et signaux dorés, tests contre une vraie base, tests de contrat, de propriétés et de mutation, nLPD et RGPD dans un backend, effacement et rétention |
| `references/backend-pile-serveur-code-ia.md` | **Backend.** Node.js (LTS, crypto par défaut), Hono et Standard Schema, Prisma 7 et 8, Drizzle, Python, FastAPI, Pydantic, SQLAlchemy, uv, Zod 4 côté serveur, nouvelles clés Supabase, code backend généré (BaxBench, SusVibes), OWASP Top 10:2025 |
| `references/revue-efficacite.md` | **Revue de code.** Ce que la revue trouve vraiment (défauts contre évolutivité), taille et vitesse, commentaires utiles, norme d'approbation de Google, checklists, ordre des fichiers, biais du relecteur, changements mêlés, revue des tests |
| `references/revue-llm.md` | **Revue de code.** Revue automatisée en conditions réelles, biais d'un LLM relecteur (cadrage, indulgence envers le code de LLM, sur-correction), vérifier par exécution, défauts typiques du code généré, tests qui valident le bug |
| `references/release-risque-cadence.md` | **Mise en production.** Mesures DORA et effet de l'IA sur la stabilité, petits lots, part des incidents dus aux changements, approbation des changements, gels, liste de contrôle avant mise en production |
| `references/release-progressif-retour-arriere.md` | **Mise en production.** Canary et comparaison avant/après, retour arrière contre correctif en avant, Instant Rollback et Rolling Releases de Vercel, PM2, Docker, flags et leur dette, critères pré-engagés |
| `references/release-migrations-sauvegardes.md` | **Mise en production.** Sauvegarde vérifiée par la restauration, DDL et verrous PostgreSQL, Prisma, Supabase CLI, Drizzle, dérive de schéma, essai à blanc et branches vides, SQLite et fichiers, copies de production |
| `references/release-verification-incidents.md` | **Mise en production.** Conduite d'un incident hors sécurité, causes et atténuations mesurées, sondes, liveness contre readiness, fenêtre d'observation, comparaison à une référence, communication |
| `references/release-config-build-agents.md` | **Mise en production.** Erreurs de configuration, variables inlinées au build, promotion et reconstruction sur Vercel, build reproductible et version de Node, agents LLM sur la production, version servie |
| `references/qa-strategie-allocation.md` | **Tests.** Forme de la suite (pyramide, trophée, tailles de Google, ratios publiés contre mesurés), défauts selon le niveau, allocation par le risque et par l'historique (concentration des fautes, churn), principes ISTQB, smoke après déploiement, non-régression |
| `references/qa-efficacite-suite.md` | **Tests.** Couverture contre efficacité, mutants et vrais défauts, Stryker et mutmut, oracles et assertions, méthodes pseudo-testées, snapshots, mocks, test smells, pièges de configuration de la couverture |
| `references/qa-instabilite-ci.md` | **Tests.** Tests instables, relancer pour classer contre pour prouver, ordre d'exécution, quarantaine et délais publiés, coût de la CI, sélection de tests, temps et aléa contrôlés |
| `references/qa-conception-cas.md` | **Tests.** Partitions, valeurs limites à trois points, tables de décision, transitions, combinatoire (NIST), exploratoire, TDD, BDD, test métamorphique, entrées hostiles, RLS qui refuse sans erreur |
| `references/qa-tests-llm.md` | **Tests.** Tests générés par LLM en industrie, oracles et assertions faibles, agents qui exploitent les tests, tests de reproduction, TDD avec un LLM, séparation de l'auteur du code et des attendus |
| `references/mythes.md` | **Transverse.** Les affirmations à ne jamais reproduire, par domaine, chacune renvoyant à la fiche qui la réfute |
| `references/provenance.md` | **Transverse.** Volumes, sources, lectures sur résumé seul et contrôles par sondage de chaque volet |
| `references/front-de-recherche.md` | Résultats récents (2022-2026) ou solides et méconnus : lisibilité individualisée, effets mesurés de l'IA sur le travail (productivité, déqualification, sur-confiance), état réel de l'accessibilité, nudges et réplications ratées, passkeys, lecture des graphiques |

## Les trois niveaux, par domaine

Un choix visuel, de rédaction, de growth ou d'implémentation (client ou serveur) se range à l'un de trois niveaux, et le livrable dit lequel :

1. **Exigence** (N1) — contraste, focus, cibles, texte qui grandit, mouvement : ne se négocie pas.
2. **Défaut fondé sur des preuves** (N2-N3) — corps de lecture, signifiants, groupement, OKLCH,
   palettes de graphiques, durée d'animation : s'en écarter se justifie par écrit.
3. **Style** (N0 assumé) — grille, rayon, accent unique, courbes d'animation ; en rédaction,
   locales par défaut, pas d'emoji, phrases courtes : légitime, signé, jamais présenté comme une
   preuve. Il cède devant le design system ou la charte éditoriale d'un projet.

En rédaction, les exigences sont les noms accessibles (WCAG 2.5.3), les liens, les erreurs en
texte, les catégories de pluriel CLDR de chaque locale et, dans leur périmètre seulement, les
règles d'écriture des textes officiels ; les défauts fondés sur des preuves sont l'anatomie d'un
message d'erreur, le registre d'adresse fixé par marché, la hiérarchie du langage inclusif, la
passe de polissage dans la langue cible et la relecture native de toute locale publiée.

En growth, les exigences sont les politiques des stores, le droit du marketing direct, des prix et
des allégations (Suisse, UE) et les exigences des messageries ; les défauts fondés sur des preuves
sont le calcul de puissance avant tout test, l'abandon du taux d'ouverture comme métrique de succès,
la croissance par de nouveaux utilisateurs, la disponibilité mentale ; les cadres de praticiens
(positionnement, AARRR, AIDA) sont utiles mais N4.

En frontend, les exigences sont les critères WCAG, les règles de sécurité officielles (Server
Action authentifiée et autorisée, validation serveur, aucun secret dans le bundle) et la vérification
de toute dépendance ; les défauts fondés sur des preuves sont les Core Web Vitals en terrain, l'image
LCP prioritaire, la CSP stricte, le typage strict, l'élément natif avant l'ARIA ; les budgets chiffrés
(200 Ko, 30 Ko) sont des conventions. En backend, les exigences sont l'autorisation sur l'objet,
la validation serveur, les requêtes paramétrées, la dérivation des mots de passe, les méthodes sûres
(RFC 9110) et la protection des données (nLPD, RGPD) ; les défauts fondés sur des preuves sont les
contraintes en base, l'outbox, l'idempotence, les retries bornés avec jitter, la mécanique PostgreSQL
des migrations ; l'emplacement de la logique métier et le choix 400 ou 422 sont des conventions. En architecture, les
exigences sont la couverture des qualités d'ISO/IEC 25010:2023, la protection des données dès la
conception et la qualification réglementaire du produit (posée comme question) ; les défauts fondés
sur des preuves sont la chasse aux décisions non prises, les NFR mesurables, les alternatives générées
avant de choisir, les risques à signal de détection et impact chiffré ; les seuils (un jour, trois
risques, une page) sont des conventions. En sécurité, les exigences sont le Top 10:2025 et
l'ASVS 5.0, le contrôle d'accès côté serveur au plus près des données, les règles NIST sur les mots de
passe et les MUST de la spécification MCP ; les défauts fondés sur des preuves sont la priorisation
par l'exploitation (KEV, exposition), les limites mesurées des scanners, deux outils plutôt qu'un, le
constat confirmé par une preuve ; la grille de sévérité est une convention. **Versions et statuts navigateurs vieillissent en mois** : la
fiche dit où regarder, la documentation de la version installée tranche.

Chaque fiche `design-*.md`, `redaction-*.md`, `growth-*.md`, `frontend-*.md`, `backend-*.md`, `architecture-*.md`, `securite-*.md`, `qa-*.md` et `release-*.md` finit par un **verdict sourcé sur les règles du profil** (soutenue,
convention sans preuve, contredite) : c'est lui qui range une règle à son niveau. Les bandeaux de
tendance (« bento », « glass », typographie géante) n'ont pas d'étude d'effet trouvée : N4 au
mieux (`design-front-recent.md`).

En revue de code, les exigences sont celles que les fiches de domaine rangent au niveau 1 et que
le relecteur oppose ; les défauts fondés sur des preuves sont la lecture par ordre de risque, le diff
des tests lu contre la SPEC, la sortie d'exécution exigée, le diff lu avant la description ; l'échelle
de sévérité, le repère de taille et la checklist sont des conventions.

En tests, les exigences sont les comportements documentés des outils et de PostgreSQL (refus RLS
silencieux, propriétaire qui contourne la RLS, périmètre par défaut de la couverture, classement des
tests instables) ; les défauts fondés sur des preuves sont la forme pyramidale en ordre de grandeur,
le risque lu dans l'historique, les valeurs limites à trois points, les combinaisons au-delà des
paires sur le critique, la force mesurée par mutants, la relance bornée et tracée, l'ordre aléatoire,
les attendus gelés avant le code ; le ratio 70/20/10, l'échéance de quarantaine et la page unique de
`TESTING.md` sont des conventions.

En mise en production, les exigences sont les comportements documentés des plateformes (variable
`NEXT_PUBLIC_` figée au build, ce que fait et ne fait pas un retour arrière Vercel, sauvegardes
Supabase selon le plan, branches sans données, dérive invisible dans l'historique des migrations),
le droit des données (copie minimisée) et l'autorisation côté système d'un agent (OWASP LLM06) ; les
défauts fondés sur des preuves sont le lot petit et homogène, le contrôle automatisé plutôt que
l'approbation lourde, le build dans les conditions de la plateforme, les critères fixés d'avance avec
un volume minimal, le retour arrière d'abord, la version servie lue sur le domaine, la sauvegarde
restaurée ; le verdict GO / NO-GO, le lint et la fenêtre d'une heure par défaut sont des conventions.

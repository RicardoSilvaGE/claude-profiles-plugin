---
name: ux-preuves
description: "Référentiel de preuves vérifiées et datées (niveau de preuve, limites, mythes) pour l'UX, le design visuel, la rédaction et l'i18n, le growth (marketing, stores, emails, SEO, droit suisse et européen de la publicité) et le code frontend et backend (performance, React et Next.js, accessibilité, sécurité, API, PostgreSQL, fiabilité, données personnelles, code écrit par un LLM). Déclencheurs : justifier une recommandation UX, un choix visuel, une formulation, une décision marketing ou un choix d'implémentation, quelle étude, est-ce prouvé, état de l'art, contraste, tu ou vous, pluriels, format suisse, limite de store, prix barré, newsletter et consentement, taille d'échantillon d'un test A/B, test utilisateur, sévérité. Pas pour : l'audit WCAG ex-post (`a11y-audit`)."
---

# UX fondée sur des preuves — référentiel vérifié

> Version 1.0 — 09.11.2026 (création, demande de l'utilisateur : faire monter l'agent `ux` en compétence sur la recherche et les sources spécialisées, applications, sites, logiciels et documents). Préchargé par `ux` (clé `skills:`) : ne pas lui poser de `paths:`.
> Version 1.1 — 09.11.2026 (volet design visuel : cinq fiches `design-*.md`, 173 entrées, chacune finie par un verdict sourcé sur les règles du profil ; préchargé aussi par `designer` v4.0 ; mythes visuels ; § « Pour un choix visuel ».)
> Version 1.2 — 09.11.2026 (volet rédaction : cinq fiches `redaction-*.md`, 177 entrées, chacune finie par un verdict sourcé sur les règles du profil ; préchargé aussi par `redacteur` v3.0 ; mythes de rédaction ; § « Pour un choix visuel ou de rédaction ».)
> Version 1.3 — 09.11.2026 (volet growth : cinq fiches `growth-*.md`, 171 entrées, chacune finie par un verdict sourcé sur les règles du profil ; préchargé aussi par `growth` v3.0 ; mythes du marketing ; § « Pour un choix visuel, de rédaction ou de growth ».)
> Version 1.4 — 09.11.2026 (mythes et provenance sortis dans `references/mythes.md` et `references/provenance.md` : le préchargement passe de 40 à 20 Ko pour chaque agent qui le porte ; volet frontend à suivre.)
> Version 1.5 — 09.11.2026 (volet frontend : cinq fiches `frontend-*.md`, 174 entrées, chacune finie par un verdict sourcé sur les règles du profil ; préchargé aussi par `frontend` v3.0 ; mythes du frontend ; § « Pour un choix visuel, de rédaction, de growth ou d'implémentation ».)
> Version 1.6 — 09.11.2026 (volet backend : cinq fiches `backend-*.md`, 173 entrées, chacune finie par un verdict sourcé sur les règles du profil ; préchargé aussi par `backend` v4.0 ; mythes du backend.)
> Contenu issu d'une **recherche documentaire du 09.11.2026** : chaque entrée des fiches cite une
> page effectivement ouverte ce jour-là, avec un extrait lu. Cf. § « D'où vient ce contenu ».
> **C'est un instantané** : § « Quand vérifier en ligne » dit quand il ne suffit plus.

## Principe directeur

Une recommandation UX vaut ce que vaut sa preuve. « C'est une bonne pratique » n'est pas une
source, et un chiffre sans origine est un chiffre inventé. Chaque recommandation porte donc trois
choses : **le principe**, **sa preuve** (niveau + source datée), **sa portée** (ce que la source
ne dit pas : population, tâche, époque).

Et quand il n'y a pas de preuve — c'est le cas de la plupart des choix de conception — on le dit,
et on dit comment la produire. Un jugement déclaré vaut mieux qu'une certitude empruntée.

**La meilleure preuve porte sur le produit lui-même.** Un test avec cinq de ses utilisateurs, un
entonnoir d'analytics, une file de tickets disent ce que vivent *ces* gens. Les sources générales
de ce skill disent où regarder et quoi éviter ; elles ne remplacent pas l'observation.

## Échelle de preuve

| Niveau | Nature | Exemples | Ce qu'il vaut |
|---|---|---|---|
| **N1** | Norme, réglementation | WCAG 2.2, EN 301 549, European Accessibility Act, DSA art. 25, ISO 9241 | Exigence. Ne se négocie pas contre une préférence ; son application à un cas précis relève d'un juriste quand elle est légale. |
| **N2** | Recherche revue par pairs, ou étude empirique à grand échantillon et méthode publiée | ACM CHI / CSCW / TOCHI, Baymard, études NN/g quantitatives, WebAIM Million | Forte **dans son contexte** : population, tâche, date. Une étude ne se généralise pas d'elle-même. |
| **N3** | Guideline officielle d'institution ou de plateforme | GOV.UK Design System, Apple HIG, Material Design, web.dev | Souvent fondée sur des tests internes non publiés. Vaut aussi comme **convention** : s'en écarter coûte en apprentissage. |
| **N4** | Avis d'expert, article de praticien | billets, conférences, livres de praticiens | Oriente, ne tranche jamais seul. |
| **N0** | Jugement de conception | ton raisonnement | Légitime **s'il est déclaré** et accompagné du test qui le confirmerait. |

**Arbitrer deux preuves qui se contredisent** :

1. N1 l'emporte : une exigence WCAG ou légale ne cède pas à une étude de préférence.
2. Une mesure fiable **sur ce produit** l'emporte sur toute source générale, N2 compris — sauf N1.
3. Entre deux sources générales : la plus proche du contexte (même population, même type de
   tâche, même support) avant la plus récente, la plus récente avant la plus citée.
4. Une N2 qui contredit une N3 de plateforme sur la même population l'emporte sur le fond — mais
   s'écarter de la convention a un coût propre, à mettre dans la balance.
5. Une étude non répliquée, ou dont la réplication a échoué, descend d'un niveau : les fiches le
   signalent à chaque entrée concernée.

## Citer

- **En ligne, à côté de la recommandation** : `[N2 — Baymard 2024]`, `[N1 — WCAG 2.2, 2.5.8]`,
  `[N0 — jugement, à vérifier par first-click test]`.
- **En bibliographie, en fin de livrable** : auteur(s), année, titre, URL, date de lecture.
- **Recopier le chiffre tel que la source le donne**, avec son unité, son échantillon et son
  année. Pas d'arrondi qui change le sens, pas de chiffre d'une étude attribué à une autre.
- **Dater** : une source de 2009 sur le mobile se signale comme telle. L'âge n'invalide pas une
  étude sur la perception humaine (Fitts, 1954, tient) ; il fragilise tout ce qui dépend d'une
  technologie ou d'un usage.
- **« Résumé seul lu »** quand on n'a eu accès qu'à l'abstract d'un article.

## Quand vérifier en ligne (veille)

Les fiches sont un instantané au 09.11.2026. Rechercher (`WebSearch` pour trouver, `WebFetch`
pour **lire la page** — jamais le seul extrait du moteur) quand :

- **le domaine bouge vite** : interfaces IA et agents, réglementation (EAA, DSA, AI Act, consentement),
  guidelines des plateformes mobiles, statut de WCAG 3, versions de frameworks, d'ORM et de runtimes, statuts Baseline, brouillons IETF ;
- la fiche date son entrée de plus de deux ans sur un sujet qui dépend d'une technologie ;
- un **chiffre précis** va être écrit dans un livrable et la fiche ne l'a pas ;
- la recommandation va **contre** une entrée de la fiche ;
- le brief porte sur un domaine qu'aucune fiche ne couvre.

**Où chercher d'abord** (sources primaires avant les synthèses) : `w3.org/WAI` (normes
d'accessibilité), `eur-lex.europa.eu` (textes européens), `iso.org` (résumés de normes),
`dl.acm.org` (CHI, CSCW, TOCHI, UIST), `nngroup.com`, `baymard.com`, `webaim.org`, `web.dev`,
`design-system.service.gov.uk`, `developer.apple.com/design`, `m3.material.io`,
`measuringu.com` (statistiques de tests). Un agrégateur de « lois UX » est un index, pas une
preuve : remonter à l'étude qu'il cite.

**Ce que devient une source lue en veille** : même format qu'une entrée de fiche, marquée
« veille du <date> », listée à part dans le hand-off pour être versée dans la fiche du domaine.
Le dépôt est la source ; une trouvaille restée dans une session est perdue.

## Prioriser : sévérité 0-4

L'échelle de Nielsen cote chaque problème par trois facteurs — **fréquence** (combien de
personnes le rencontrent), **impact** (gêne ou blocage), **persistance** (surmonté une fois
appris, ou subi à chaque passage) — Nielsen y ajoute l'impact marché. Une cote donnée par **un
seul** évaluateur est « too unreliable to be trusted » : quand c'est possible, moyenner au moins
trois évaluateurs ; sinon, le dire. Source : Nielsen 1994, « Severity Ratings for Usability
Problems » ; détail dans `references/normes-lois-methodes.md`.

| Cote | Sens | Conduite |
|---|---|---|
| 4 | Catastrophe d'utilisabilité | Corriger avant livraison |
| 3 | Problème majeur | Priorité haute |
| 2 | Problème mineur | Priorité basse |
| 1 | Cosmétique | Si le temps le permet |
| 0 | Pas un problème d'utilisabilité | — |

Une cote se justifie par les trois facteurs, en une ligne. Un défaut **N1** (WCAG, légal) qui
bloque une personne est au moins 3, quelle que soit sa fréquence : bloquer quelqu'un n'est pas
une affaire de statistique.

## De la question à la méthode

| Question | Méthode | Ce qu'elle ne dit pas |
|---|---|---|
| Les gens trouvent-ils l'information ou la fonction ? | Tree testing (arborescence seule), first-click test | Si la page trouvée est comprise |
| Peuvent-ils accomplir la tâche ? Où butent-ils ? | Test d'utilisabilité modéré, itératif, petit nombre de participants par profil | Une fréquence fiable dans la population |
| La tâche est-elle perçue comme facile ? | SEQ après chaque tâche ; SUS ou UMUX-Lite en fin de session | Pourquoi ; la cause se voit dans l'observation |
| Le changement modifie-t-il le comportement à l'échelle ? | Test A/B, taille d'échantillon et durée fixées d'avance | Pourquoi ; et rien sur ce qui n'est pas mesuré |
| Sert-il l'objectif du produit ? | HEART (Happiness, Engagement, Adoption, Retention, Task success) en Goals → Signals → Metrics | Rien sans une décision à éclairer ; conçu pour du web à fort trafic, peu transposable tel quel à un outil métier à faible audience |
| Que cherchent-ils à accomplir, au fond ? | Entretiens orientés jobs-to-be-done, observation en contexte | Une validation de solution |

Détail, chiffres de référence (moyenne SUS, taille d'échantillon et ses critiques, pièges des
tests A/B) et sources : `references/normes-lois-methodes.md`.

**Trois règles de protocole qui évitent la plupart des faux résultats** :

1. **Fixer le seuil de décision avant de mesurer.** Choisir ensuite, c'est lire ce qu'on veut.
2. **Formuler les tâches sans le vocabulaire de l'interface.** « Trouvez où modifier votre
   adresse », pas « cliquez sur Profil ».
3. **Ne pas regarder un A/B en cours pour l'arrêter dès qu'il « gagne ».** Ce test multiple
   « significantly inflates the type-I error rates » (Kohavi, Deng, Vermeer, KDD 2022) : fixer
   durée et effectif d'avance, ou employer une méthode séquentielle (`references/normes-lois-methodes.md`).

## Fiches de référence

Lire la fiche du domaine **avant** de recommander. Chaque entrée : règle, niveau, source, extrait
lu, portée.

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
| `references/backend-securite-api-auth.md` | **Backend.** OWASP API Top 10 et ASVS 5.0, autorisation sur l'objet, stockage des mots de passe (Argon2id, scrypt, PBKDF2), NIST SP 800-63B-4, sessions et JWT, anti-force brute, CSRF, CORS, SSRF, injection SQL et API brutes des ORM, OAuth, ordre des contrôles dans un handler |
| `references/backend-donnees-postgres.md` | **Backend.** Migrations PostgreSQL sans interruption (verrous, `lock_timeout`, `CONCURRENTLY`, `NOT VALID`), expand/contract, index, pagination par curseur, transactions et isolation, contraintes contre validations applicatives, ORM et N+1, pools et serverless, RLS Supabase, PostgreSQL 18, SQLite |
| `references/backend-fiabilite-contrats-api.md` | **Backend.** Timeouts, retries, jitter et budgets, pannes métastables, gestion d'erreur et pannes réelles, idempotence, outbox et webhooks, codes HTTP et Problem Details, pagination, temps réel, files |
| `references/backend-observabilite-tests-donnees.md` | **Backend.** Journaux structurés, W3C Trace Context et OpenTelemetry, SLO et signaux dorés, tests contre une vraie base, tests de contrat, de propriétés et de mutation, nLPD et RGPD dans un backend, effacement et rétention |
| `references/backend-pile-serveur-code-ia.md` | **Backend.** Node.js (LTS, crypto par défaut), Hono et Standard Schema, Prisma 7 et 8, Drizzle, Python, FastAPI, Pydantic, SQLAlchemy, uv, Zod 4 côté serveur, nouvelles clés Supabase, code backend généré (BaxBench, SusVibes), OWASP Top 10:2025 |
| `references/mythes.md` | **Transverse.** Les affirmations à ne jamais reproduire, par domaine, chacune renvoyant à la fiche qui la réfute |
| `references/provenance.md` | **Transverse.** Volumes, sources, lectures sur résumé seul et contrôles par sondage de chaque volet |
| `references/front-de-recherche.md` | Résultats récents (2022-2026) ou solides et méconnus : lisibilité individualisée, effets mesurés de l'IA sur le travail (productivité, déqualification, sur-confiance), état réel de l'accessibilité, nudges et réplications ratées, passkeys, lecture des graphiques |

## Pour un choix visuel, de rédaction, de growth ou d'implémentation

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
des migrations ; l'emplacement de la logique métier et le choix 400 ou 422 sont des conventions. **Versions et statuts navigateurs vieillissent en mois** : la
fiche dit où regarder, la documentation de la version installée tranche.

Chaque fiche `design-*.md`, `redaction-*.md`, `growth-*.md`, `frontend-*.md` et `backend-*.md` finit par un **verdict sourcé sur les règles du profil** (soutenue,
convention sans preuve, contredite) : c'est lui qui range une règle à son niveau. Les bandeaux de
tendance (« bento », « glass », typographie géante) n'ont pas d'étude d'effet trouvée : N4 au
mieux (`design-front-recent.md`).

## Mythes à ne pas reproduire

**Opposable** : la liste vit dans `references/mythes.md`, groupée par domaine (UX et cognition,
design visuel, rédaction, growth, méthodes…), chaque mythe renvoyant à la fiche qui le réfute. La
lire avant de citer un chiffre « connu » : les plus repris sont souvent les moins sourcés.

## Ce que ce skill ne fait pas

- **Il ne remplace pas la recherche sur le produit.** Il dit où regarder ; seuls les utilisateurs
  de ce produit disent ce qui s'y passe.
- **Il ne remplace pas `a11y-audit`**, qui vérifie un écran implémenté critère par critère.
- **Il ne fait pas de droit.** Les textes réglementaires sont cités pour ce qu'ils disent ; leur
  application à un produit précis est une question de juriste.
- **Il n'est pas exhaustif.** Un domaine absent des fiches se traite par la veille, pas par la
  mémoire.

## D'où vient ce contenu

Recherche documentaire du **09.11.2026**, en volets parallèles par domaine, sous une règle unique :
**rien de mémoire** — chaque entrée cite une page réellement ouverte et en recopie un extrait ; un
chiffre sans source primaire trouvée va en « Non vérifié ». Volumes, sources, entrées lues sur
résumé seul et contrôles par sondage refaits à la source : `references/provenance.md`.

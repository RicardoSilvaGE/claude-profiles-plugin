---
name: ux-preuves
description: "Référentiel de preuves vérifiées et datées (niveau de preuve, limites, mythes) pour l'UX, le design visuel, la rédaction et l'i18n, le growth (marketing, stores, emails, SEO, droit suisse et européen de la publicité) l'architecture et le code (ADR, qualités, dépendances, performance, sécurité, API, PostgreSQL, données personnelles, code écrit par un LLM). Déclencheurs : justifier une recommandation UX, un choix visuel, une formulation, une décision marketing, d'architecture ou d'implémentation, quelle étude, est-ce prouvé, état de l'art, contraste, tu ou vous, pluriels, format suisse, limite de store, prix barré, newsletter et consentement, taille d'échantillon d'un test A/B, test utilisateur, sévérité. Pas pour : l'audit WCAG ex-post (`a11y-audit`)."
---

# UX fondée sur des preuves — référentiel vérifié

> Version 1.11 — 10.11.2026 (volet tests : cinq fiches `qa-*.md`, 170 entrées, préchargé aussi par `qa` v3.0.) Versions 1.0 à 1.10 : `references/provenance.md` § « Versions du skill ».
> Contenu issu d'une **recherche documentaire des 09 et 10.11.2026** : chaque entrée des fiches cite une
> page effectivement ouverte pendant cette recherche, avec un extrait lu. Cf. § « D'où vient ce contenu ».
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
lu, portée. **Index détaillé** (ce que couvre chaque fiche, et les trois niveaux déclinés par
domaine) : `references/index.md`.

| Volet | Fiches (`references/`) |
|---|---|
| UX | `cognition-chemin-usage.md` (**le chemin logique d'usage**, à ouvrir pour tout parcours), `formulaires-navigation-mobile.md`, `contenus-documents-accessibilite.md`, `ia-ethique-onboarding.md`, `normes-lois-methodes.md`, `front-de-recherche.md` |
| Design visuel | `design-perception-esthetique.md`, `design-couleur-contraste.md`, `design-typographie-mise-en-page.md`, `design-motion-etats-systemes.md`, `design-front-recent.md` |
| Rédaction | `redaction-microcopy.md`, `redaction-voix-ton-inclusif.md`, `redaction-i18n-locales.md`, `redaction-orthotypographie.md`, `redaction-traduction-ia.md` |
| Growth | `growth-science-marketing.md`, `growth-conversion-persuasion.md`, `growth-aso-stores.md`, `growth-emails-droit.md`, `growth-seo-ia-droit-publicite.md` |
| Frontend | `frontend-performance.md`, `frontend-react-next.md`, `frontend-accessibilite-code.md`, `frontend-qualite-securite.md`, `frontend-code-ia-plateforme.md` |
| Backend | `backend-securite-api-auth.md`, `backend-donnees-postgres.md`, `backend-fiabilite-contrats-api.md`, `backend-observabilite-tests-donnees.md`, `backend-pile-serveur-code-ia.md` |
| Architecture | `architecture-decisions-adr.md`, `architecture-qualites-nfr.md`, `architecture-modularite-dette.md`, `architecture-dependances-build-buy.md`, `architecture-risques-estimation-llm.md` |
| Sécurité | `securite-menaces-priorisation.md`, `securite-outils-detection.md`, `securite-incidents-secrets.md`, `securite-plateforme-deploiement.md`, `securite-llm-agents.md` |
| Revue de code | `revue-efficacite.md`, `revue-llm.md` |
| Tests | `qa-strategie-allocation.md`, `qa-efficacite-suite.md`, `qa-instabilite-ci.md`, `qa-conception-cas.md`, `qa-tests-llm.md` |
| Transverse | `index.md` (détail des fiches), `mythes.md` (affirmations à ne jamais reproduire), `provenance.md` (volumes, sources, contrôles, versions) |

## Trois niveaux pour toute règle

Un choix — d'interface, visuel, de rédaction, de growth, d'architecture ou d'implémentation — se
range à l'un de trois niveaux, et le livrable dit lequel :

1. **Exigence** (N1) — norme, loi, spécification, règle officielle dont l'oubli casse
   l'accessibilité ou la sécurité : ne se négocie pas.
2. **Défaut fondé sur des preuves** (N2-N3) : s'en écarter se justifie par écrit.
3. **Convention ou style** (N0 assumé, N4 au mieux) : légitime, signé, jamais présenté comme une
   preuve. Il cède devant le design system, la charte ou le `CLAUDE.md` d'un projet.

Chaque fiche de volet finit par un **verdict sourcé sur les règles du profil** (soutenue, convention
sans preuve, contredite) : c'est lui qui range une règle à son niveau. La déclinaison par domaine
est dans `references/index.md`. **Versions, statuts navigateurs et avis de sécurité vieillissent en
mois, parfois en jours** : la fiche dit où regarder, la source officielle du jour tranche.

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

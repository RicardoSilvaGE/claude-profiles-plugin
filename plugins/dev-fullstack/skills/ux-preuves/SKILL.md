---
name: ux-preuves
description: "Référentiel de preuves vérifiées et datées (niveau de preuve, limites, mythes) pour l'UX, le design visuel, la rédaction et l'i18n, le growth (marketing, stores, emails, SEO, droit suisse et européen de la publicité), l'architecture et le code (ADR, dépendances, performance, sécurité, API, PostgreSQL, données personnelles, code écrit par un LLM), les tests, la revue de code, la mise en production et l'ingénierie IA. Déclencheurs : justifier une recommandation UX, un choix visuel, une formulation, une décision marketing, d'architecture ou d'implémentation, quelle étude, est-ce prouvé, état de l'art, contraste, tu ou vous, pluriels, format suisse, limite de store, prix barré, newsletter et consentement, taille d'échantillon d'un test A/B, test utilisateur, sévérité. Pas pour : l'audit WCAG ex-post (`a11y-audit`)."
---

# Preuves vérifiées — référentiel du profil

> Version 1.15 — 11.11.2026 (table des fiches et sections propres à l'UX sorties en annexe, « N2 faible » reclassé). Versions 1.0 à 1.14 : `references/provenance.md` § « Versions du skill ».
> Contenu issu d'une **recherche documentaire des 09 et 10.11.2026** : chaque entrée des fiches cite une
> page effectivement ouverte pendant cette recherche, avec un extrait lu. Cf. § « D'où vient ce contenu ».
> **C'est un instantané** : § « Quand vérifier en ligne » dit quand il ne suffit plus.

## Principe directeur

Une recommandation vaut ce que vaut sa preuve. « C'est une bonne pratique » n'est pas une
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
| **N2** | Recherche revue par pairs, ou étude empirique à grand échantillon et méthode publiée | ACM CHI / CSCW / TOCHI, WebAIM Million, Baymard et NN/g quand la page lue donne échantillon et méthode (sinon N4) | Forte **dans son contexte** : population, tâche, date. Une étude ne se généralise pas d'elle-même. |
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

Les fiches sont un instantané des 09 et 10.11.2026. Rechercher (`WebSearch` pour trouver, `WebFetch`
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
`measuringu.com` (statistiques de tests). Cette liste est celle du volet UX ; pour les autres
volets, repartir des sources que cite la fiche du domaine (ligne « Source » de ses entrées). Un agrégateur de « lois UX » est un index, pas une
preuve : remonter à l'étude qu'il cite.

**Ce que devient une source lue en veille** : même format qu'une entrée de fiche, marquée
« veille du <date> », listée à part dans le hand-off pour être versée dans la fiche du domaine.
Le dépôt est la source ; une trouvaille restée dans une session est perdue.

## Prioriser : sévérité 0-4 · De la question à la méthode

Volet UX seulement. Avant de coter un problème d'utilisabilité, de choisir une méthode
d'évaluation ou de lancer un test (utilisabilité, questionnaire, A/B) : échelle de Nielsen, table
question → méthode et trois règles de protocole dans `references/severite-et-methodes.md`.

## Fiches de référence

Lire la fiche du domaine **avant** de recommander. Chaque entrée : règle, niveau, source, extrait
lu, portée. **La liste des fiches, ce que couvre chacune et les trois niveaux déclinés par
domaine** : `references/index.md`, à ouvrir quand le nom de la fiche n'est pas déjà connu.

Les noms suivent le volet : `design-*`, `redaction-*`, `growth-*`, `frontend-*`, `backend-*`,
`architecture-*`, `securite-*`, `revue-*`, `ia-profils-*`, `release-*`, `qa-*` ; le volet UX n'a pas
de préfixe (`cognition-chemin-usage.md`, **le chemin logique d'usage**, à ouvrir pour tout
parcours ; `formulaires-navigation-mobile.md`, `contenus-documents-accessibilite.md`,
`ia-ethique-onboarding.md`, `normes-lois-methodes.md`, `front-de-recherche.md`).

**Une fiche pèse jusqu'à 65 Ko : ne pas la lire en entier.** Chercher le sujet par `Grep` dans ses
titres `###`, lire les entrées trouvées, puis son verdict de fin quand elle en a un.

## Trois niveaux pour toute règle

Un choix — d'interface, visuel, de rédaction, de growth, d'architecture ou d'implémentation — se
range à l'un de trois niveaux, et le livrable dit lequel :

1. **Exigence** (N1) — norme, loi, spécification, règle officielle dont l'oubli casse
   l'accessibilité ou la sécurité : ne se négocie pas.
2. **Défaut fondé sur des preuves** (N2-N3) : s'en écarter se justifie par écrit.
3. **Convention ou style** (N0 assumé, N4 au mieux) : légitime, signé, jamais présenté comme une
   preuve. Il cède devant le design system, la charte ou le `CLAUDE.md` d'un projet.

Hors volet UX, les fiches finissent par un **verdict sourcé sur les règles du profil** (soutenue,
convention sans preuve, contredite) : il range une règle à son niveau. Exceptions et déclinaison
par domaine : `references/index.md`. **Versions, statuts navigateurs et avis de sécurité vieillissent en
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

Recherche documentaire des **09 et 10.11.2026**, en volets parallèles par domaine, sous une règle unique :
**rien de mémoire** — chaque entrée cite une page réellement ouverte et en recopie un extrait ; un
chiffre sans source primaire trouvée va en « Non vérifié ». Volumes, sources, entrées lues sur
résumé seul et contrôles par sondage refaits à la source : `references/provenance.md`.

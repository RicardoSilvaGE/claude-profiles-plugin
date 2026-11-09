---
name: ux-preuves
description: "Référentiel de preuves vérifiées et datées (niveau de preuve, limites, mythes) pour l'UX, le design visuel, la rédaction et l'i18n, et le growth (marketing, stores, emails, SEO, droit suisse et européen de la publicité). Déclencheurs : justifier une recommandation UX, un choix visuel, une formulation ou une décision marketing, quelle étude, est-ce prouvé, état de l'art, contraste, tu ou vous, pluriels, format suisse, limite de store, prix barré, newsletter et consentement, taille d'échantillon d'un test A/B, test utilisateur, sévérité. Pas pour : l'audit WCAG ex-post (`a11y-audit`)."
---

# UX fondée sur des preuves — référentiel vérifié

> Version 1.0 — 09.11.2026 (création, demande de l'utilisateur : faire monter l'agent `ux` en compétence sur la recherche et les sources spécialisées, applications, sites, logiciels et documents). Préchargé par `ux` (clé `skills:`) : ne pas lui poser de `paths:`.
> Version 1.1 — 09.11.2026 (volet design visuel : cinq fiches `design-*.md`, 173 entrées, chacune finie par un verdict sourcé sur les règles du profil ; préchargé aussi par `designer` v4.0 ; mythes visuels ; § « Pour un choix visuel ».)
> Version 1.2 — 09.11.2026 (volet rédaction : cinq fiches `redaction-*.md`, 177 entrées, chacune finie par un verdict sourcé sur les règles du profil ; préchargé aussi par `redacteur` v3.0 ; mythes de rédaction ; § « Pour un choix visuel ou de rédaction ».)
> Version 1.3 — 09.11.2026 (volet growth : cinq fiches `growth-*.md`, 171 entrées, chacune finie par un verdict sourcé sur les règles du profil ; préchargé aussi par `growth` v3.0 ; mythes du marketing ; § « Pour un choix visuel, de rédaction ou de growth ».)
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
  guidelines des plateformes mobiles, statut de WCAG 3 ;
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
| `references/front-de-recherche.md` | Résultats récents (2022-2026) ou solides et méconnus : lisibilité individualisée, effets mesurés de l'IA sur le travail (productivité, déqualification, sur-confiance), état réel de l'accessibilité, nudges et réplications ratées, passkeys, lecture des graphiques |

## Pour un choix visuel, de rédaction ou de growth

Un choix visuel, de rédaction ou de growth se range à l'un de trois niveaux, et le livrable dit lequel :

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

Chaque fiche `design-*.md`, `redaction-*.md` et `growth-*.md` finit par un **verdict sourcé sur les règles du profil** (soutenue,
convention sans preuve, contredite) : c'est lui qui range une règle à son niveau. Les bandeaux de
tendance (« bento », « glass », typographie géante) n'ont pas d'étude d'effet trouvée : N4 au
mieux (`design-front-recent.md`).

## Mythes à ne pas reproduire

Liste opposable : ces affirmations circulent dans la littérature de praticiens et **ne
s'écrivent pas** dans un livrable, sauf pour les réfuter. Source de chaque réfutation dans la
fiche indiquée.

**Cognition et chemin d'usage** — `references/cognition-chemin-usage.md`

- « L'affordance d'un bouton. » Norman lui-même demande de parler de **signifiants** pour les
  indices perceptibles (2008, puis édition révisée de 2013).
- « Le défaut marche toujours », « l'opt-out fait exploser le don d'organes ». Le défaut change ce
  qui est coché (Johnson & Goldstein 2003, répliqué en ligne en 2023 sur N = 1 920), pas
  forcément le résultat final : pas de différence significative de donneurs décédés sur 35 pays
  de l'OCDE (2019) ; et une méta-analyse (2019) trouve une forte hétérogénéité, effets négatifs
  compris.
- « Il faut 21 jours pour prendre une habitude. » Aucune source ; l'étude citée (Lally et al. 2010)
  donne une médiane de 66 jours sur 39 participants, de 18 à 254 jours.
- « 83 % des radiologues ratent ce qu'ils devraient voir. » Ils ratent un gorille inséré dans un
  scanner (Drew et al. 2013, 24 radiologues), pas une pathologie : la leçon est que l'inattendu
  échappe même aux experts.
- « Une animation attire l'œil sur une bannière. » L'animation fait partie des traits qui signalent
  une publicité et font éviter la zone (NN/g 2018).
- « Les principes de la Gestalt sont prouvés en interface. » Solides en perception ; leurs effets
  chiffrés sur des interfaces ne sont pas établis par les sources lues.
- « Charge intrinsèque, extrinsèque, germane. » Le statut de la charge germane est contesté (de
  Jong 2010), et la théorie porte sur l'apprentissage, pas sur l'usage courant.
- « Le KLM prédit le temps de toute tâche. » Pour des experts, des tâches de routine, sans erreur.

**Perception, mémoire, décision** — `references/normes-lois-methodes.md`, `references/front-de-recherche.md`

- « La loi de Hick impose de réduire le nombre d'options. » Liu et al. (CHI 2020) : elle « speaks
  against, not for, the popular principle that 'less is better' » ; la croissance est logarithmique,
  et le parcours d'une liste désordonnée n'y obéit pas.
- « Sept éléments au plus dans un menu », « la mémoire de travail tient 7 ± 2 éléments ». Le sept
  de Miller était « a rough estimate and a rhetorical device » (Cowan 2001, qui ramène la capacité à
  environ quatre blocs) ; un menu se lit, il ne se mémorise pas (Nielsen 2009).
- « Ce qui est beau est utilisable. » Tuch et al. 2012 trouvent l'inverse : une mauvaise
  utilisabilité dégrade l'esthétique perçue, pas l'inverse.
- « On retient mieux les tâches inachevées (Zeigarnik). » Non répliqué (méta-analyse 2025) ; seule
  la tendance à reprendre la tâche est robuste.
- « Seuls le pic et la fin comptent. » L'effet est comparable à celui de la moyenne (Alaybek et al.
  2022) ; seule la durée pèse peu.
- « Les lois de Jakob et de Tesler. » Principes d'expert, sans mesure publiée : à citer en N4.
- « Les nudges ont un effet moyen de d = 0,45. » Corrigé du biais de publication : environ 0,04,
  sans preuve d'effet global (Maier et al. 2022). L'épuisement de la volonté (ego depletion) ne se
  réplique pas ; l'effet de leurre tient mal hors des tableaux de chiffres.

**Lecture et contenus** — `references/contenus-documents-accessibilite.md`, `references/front-de-recherche.md`

- « Notre attention (8 s) est plus courte que celle d'un poisson rouge. » Aucune étude derrière le
  chiffre (rapport Microsoft Canada 2015 citant « Statistic Brain »).
- « Les gens ne lisent pas. » Ils balaient d'abord, puis lisent quand le texte le mérite : on écrit
  pour le balayage **et** pour la lecture complète.
- « Il faut disposer le contenu en F. » Le F est le symptôme d'un texte mal formaté, pas un gabarit.
- « Un bon score de lisibilité prouve qu'un texte est clair. » ISO 24495-1 juge sur l'usage,
  « rather than on mechanical measures such as readability formulas ».
- « Des lignes courtes se lisent plus vite. » Non démontré à l'écran (Dyson & Kipping 1998) ; la
  plage « 45 à 75 caractères » vient de l'imprimé, sans source primaire lue.
- « La police préférée est la plus lisible », « une police pour dyslexiques aide ». La préférence
  ne prédit pas la vitesse (Wallace et al. 2022) ; la police dédiée n'est pas plus rapide (Rello 2013).
- « Le mode sombre est plus lisible. » Les mesures de performance favorisent le clair pour une
  vision normale, surtout en petit corps ; le sombre sert certains profils.
- « Un PDF balisé est accessible. » GOV.UK : un PDF ne peut pas être rendu pleinement accessible
  à tous ; HTML quand c'est possible.
- « Jamais de camembert. » Seul « position > angle et aire » est solide ; l'infériorité de l'angle
  sur la longueur n'est pas confirmée en réplication (Heer & Bostock 2010).

**Accessibilité** — `references/contenus-documents-accessibilite.md`, `references/front-de-recherche.md`

- « WCAG 3 remplace WCAG 2 », « il faut déjà s'y conformer ». Brouillon de travail du 10.09.2026 :
  « WCAG 3 does not replace WCAG 2 ». La référence reste WCAG 2.2, devenue ISO/IEC 40500:2025.
- « Un overlay rend un site conforme. » Faux selon plus d'un millier de praticiens signataires, et
  allégation sanctionnée par la FTC (accessiBe, 2025).

**Formulaires, mobile, performance** — `references/formulaires-navigation-mobile.md`

- « La validation en ligne est toujours meilleure. » Wroblewski 2009 (22 participants) et GOV.UK
  (« Do not validate when the user moves away from a field ») divergent ; elles ne s'accordent que
  sur « jamais avant que la saisie soit finie ».
- « Labels au-dessus : saisie dix fois plus rapide. » Durées de saccade d'un test oculométrique ad
  hoc (Penzo 2006), dont l'auteur dit qu'il ne ressemble pas aux conditions réelles.
- « 70 % des acheteurs abandonnent à cause du checkout. » Les 70,22 % de Baymard sont un abandon
  toutes causes ; « checkout trop long ou compliqué » pèse 17 % des raisons.
- « La zone du pouce en arc. » Son auteur supposé la qualifie de « well-known, but incorrect »
  (Hoober 2017) : on change de prise et on préfère le centre.
- « Amazon : 100 ms = 1 % de ventes », « 53 % des visiteurs mobiles partent après 3 s »,
  « + 8,4 % de conversion par 0,1 s ». Une diapositive sans méthode ; une note de bas de page sur des
  données Google Analytics de 2016 ; une association commandée par Google, sans groupe témoin.
- « Les skeleton screens paraissent plus rapides. » L'étude publiée ne trouve pas de différence
  significative avec un spinner (Mejtoft et al. 2018).
- « Le hamburger est interdit partout. » Net sur desktop, nuancé sur mobile (NN/g 2016).

**IA, éthique, engagement** — `references/ia-ethique-onboarding.md`, `references/front-de-recherche.md`

- « Une IA qui s'explique ou cite ses sources inspire une confiance justifiée. » Explications et
  citations font accepter la réponse « regardless of its correctness » (Bansal et al. 2021), y
  compris des citations fausses ; les utilisateurs cliquent rarement dessus.
- « Les utilisateurs vont plus vite avec l'IA, ils le disent. » METR 2025 : 19 % plus lents,
  persuadés d'avoir gagné 20 %. Le ressenti n'est pas une mesure.
- « Un pourcentage de confiance aide l'utilisateur. » PAIR le déconseille : préférer des catégories
  reliées à une action.
- « Un avertissement protège. » L'attention s'effondre dès la deuxième exposition (Anderson et al.
  2015).
- « Un tutoriel d'entrée améliore la prise en main. » Pas nécessairement (NN/g 2023) ; l'aide
  contextuelle fait mieux, sauf paradigme d'interaction nouveau.
- « Il faut 23 minutes pour se reconcentrer après une interruption. » C'est le délai moyen avant
  de **reprendre** la tâche, issu d'une interview (Mark, 2006), pas un temps de reconcentration.
- « 11 % des sites marchands ont des dark patterns. » Borne basse (Mathur et al. 2019), pas une
  estimation : ne jamais lire « 89 % n'en ont pas ».

**Design visuel** — `references/design-*.md`

- « On juge un site en 50 ms. » Lindgaard et al. 2006 portent sur l'**attrait visuel** ;
  l'extension à la crédibilité et à l'utilisabilité vient de reprises secondaires.
- « 46 % des utilisateurs jugent la crédibilité sur le design. » C'est 46,1 % **des commentaires**
  (Fogg et al. 2002), et l'effet est trouvé plus faible une décennie plus tard.
- « Il faut une complexité moyenne (U inversé). » Sur les sites au premier regard, la complexité
  élevée pénalise, faible et moyenne font jeu égal (Tuch et al. 2012 ; Reinecke et al. 2013).
- « L'espace blanc augmente la compréhension de 20 %. » Aucune source primaire trouvée.
- « La proximité groupe mieux qu'une bordure. » Une région commune groupe plus fort ; la proximité
  coûte seulement moins de complexité visuelle.
- « APCA est l'algorithme de WCAG 3. » Le brouillon du 10.09.2026 dit l'algorithme « yet to be
  determined ». Une palette « garantie APCA » se revérifie en ratio WCAG 2.
- « Le bouton rouge convertit mieux », « le rouge stresse », « le rouge rend plus attirant ». Page
  d'origine introuvable pour le premier ; pas de valeur probante après correction du biais de
  publication pour le deuxième (méta-analyse Gnambs 2020) ; effet « very small, potentially
  nonexistent » pour le troisième (méta-analyse Lehmann et al. 2018).
- « Le texte clair sur noir provoque une halation chez les astigmates. » Aucune source primaire.
- « HSL suffit pour un thème clair/sombre. » Contredit par CSS Color 4 § 7.3 : passer en OKLCH.
- « Serif pour le papier, sans-serif pour l'écran. » Aucune différence robuste à conditions égales.
- « La grille de 8 points est prouvée », « les échelles modulaires produisent l'harmonie ».
  Conventions de production.
- « Il faut toujours remplacer l'outline du navigateur. » Le focus natif est conforme (G165) ; c'est
  en le modifiant qu'on s'expose à l'échec.
- « Un bouton désactivé doit atteindre 4,5:1. » Les composants inactifs sont exemptés.
- « Les animations ne doivent jamais dépasser 300 ou 400 ms. » Seuil de praticien ; la gêne est
  située à 500 ms (NN/g), et environ 1 s est mesuré utile pour une transition de données.
- « `prefers-reduced-motion`, c'est aucune animation. » La spécification dit « removes or
  replaces » : un fondu remplace une translation.
- « 35 % des adultes souffrent de troubles vestibulaires. » Le chiffre porte sur les Américains de
  40 ans et plus, mesurés par un test d'équilibre, pas sur la gêne face au mouvement.
- « La spécification DTCG est une norme W3C. » C'est un rapport de groupe communautaire.
- « Un design system rend 47 % plus rapide. » Un formulaire, huit développeurs.
- « Material 3 Expressive fait repérer quatre fois plus vite. » « Up to », recherche d'éditeur
  sans protocole publié, gain porté par la saillance d'un bouton agrandi.
- « Les outils d'IA produisent des interfaces accessibles. » Résultats contradictoires ; une étude
  de 2026 mesure 29 % de conformité.

**Rédaction et traduction** — `references/redaction-*.md`

- « Phrases de 14 mots = 90 % de compréhension. » Source primaire introuvable.
- « Les capitales sont illisibles », « on lit par la forme des mots ». Argument du bouma non
  soutenu ; au seuil de lisibilité, les lettres isolées sont plus lisibles que les mots.
- « Le bouton à 300 millions de dollars. » C'est le parcours qui a changé, pas seulement le libellé.
- « Réécrire les messages d'erreur réduit toujours les erreurs. » Effet trouvé (Becker et al. 2016),
  non répliqué (Pettit et al. 2017).
- « Ne jamais s'excuser », « ne jamais dire nous ». Les guides divergent : GOV.UK proscrit « sorry »
  dans les erreurs de saisie mais l'emploie pour une panne ; Apple déconseille « we », Microsoft
  l'emploie.
- « L'humour rend les erreurs sympathiques. » Résultats contradictoires ; les guides le déconseillent.
- « Le tutoiement crée de la proximité, donc de la confiance. » Non soutenu en allemand, non testé
  en français.
- « NN/g a tranché "Mon compte" contre "Votre compte". » Aucun article trouvé.
- « L'écriture inclusive est interdite en France », « la Suisse a interdit le langage inclusif ».
  Inexacts : les circulaires françaises lient l'État et l'enseignement ; la loi suisse sur les
  langues **impose** la formulation non sexiste aux autorités fédérales, seuls certains signes sont
  écartés. « L'Académie refuse la féminisation » est inexact depuis le 28.02.2019 pour les métiers.
- « Le point médian est illisible par les lecteurs d'écran. » Porté par des associations, sans test
  reproductible trouvé : à tester sur la plateforme cible plutôt qu'à affirmer.
- « +30 % / +35 % en allemand et en espagnol. » Bornes hautes de prestataires, sans méthode ; les
  chaînes courtes s'allongent bien davantage.
- « Les langues romanes n'ont que singulier et pluriel », « le russe a six pluriels », « `one`
  signifie 1 ». Faux selon CLDR 49 : `many` en fr, es, it, pt ; quatre catégories en ru ; en
  français, 0 et 1,5 relèvent de `one`.
- « En Suisse, le séparateur de milliers est l'apostrophe. » CLDR oui, la Chancellerie fédérale non
  en français : décider et documenter.
- « MessageFormat 2.0 n'est pas stable. » Stable depuis CLDR 47 (13.03.2025) ; `Intl.MessageFormat`
  reste au stade 1.
- « Les LLM ont atteint la parité humaine en traduction », « un bon score COMET veut dire une bonne
  traduction », « il suffit de demander d'être naturel ». Contestés ou contredits (WMT 2024-2025 ;
  Li et al. 2025).
- « L'AI Act impose d'étiqueter tout texte rédigé avec l'IA. » Faux en l'état lu : l'art. 50(4) vise
  les textes publiés pour informer le public sur des sujets d'intérêt public, avec exception en cas
  de relecture sous responsabilité éditoriale.

**Growth et marketing** — `references/growth-*.md`

- « Le titre Play fait 50 ou 60 caractères. » 30, depuis 2021.
- « 7 amis en 10 jours » (Facebook), « 40 % de très déçus = product-market fit ». Aucune source
  primaire trouvée pour le premier ; seuil « a bit arbitrary » pour le second.
- « Le 60/40 marque/activation est la règle. » Moyenne de marques établies (62/38 en 2017), qui
  « varies by category » ; « 46/54 en B2B » repose sur moins de 50 cas.
- « Le NPS est le seul chiffre qui compte pour croître. » Non répliqué (2007), contredit (2022).
- « Les avis multiplient les ventes par 3,7. » Exact pour 5 avis contre 0 chez un seul détaillant ;
  la note « idéale » est entre 4,0 et 4,7 dans la source, pas 4,2-4,5.
- « La plupart des tests réussissent si on a de bonnes idées », « un test sérieux = une seule
  variable ». Contredits (Kohavi et al.).
- « Les titres négatifs convertissent mieux. » Mesuré en clics sur des titres d'actualité, pas en
  conversions.
- « Les prix en 9 marchent toujours », « l'urgence augmente toujours les ventes », « l'ancrage est
  une loi », « AIDA est un modèle validé ». Conditionnels, fragiles ou non testés.
- « L'essai avec renouvellement automatique convertit à 50 % contre 15 %. » Chiffres de fournisseurs ;
  l'expérience randomisée disponible mesure moins d'abonnés à 20 mois.
- « Le taux d'ouverture mesure l'intérêt », « il existe une meilleure heure d'envoi », « plus
  d'e-mails = plus de revenus ». Contredits ou sans étude.
- « Un inscrit gratuit est un client : soft opt-in », « en B2B, pas de règles ». Contredits (PFPDT,
  CNIL ; CAN-SPAM, LCD let. o).
- « L'E-E-A-T est un facteur de classement », « Google pénalise le contenu écrit par IA », « il faut
  un balisage spécial pour les IA », « le GEO augmente la visibilité de 40 % ». Contredits par Google
  ou par la recherche.
- « La publicité comparative est interdite », « un prix barré, c'est le prix d'avant ». Faux : elle
  est encadrée ; dans l'UE, le prix de référence est le plus bas des 30 jours.

**Méthodes** — `references/normes-lois-methodes.md`

- « Cinq utilisateurs trouvent 85 % des problèmes. » Valable pour un test qualitatif, un seul
  profil, des tâches fermées ; selon le tirage, de 55 % à presque 100 % (Faulkner 2003).
- « Un SUS de 70, c'est 70 % d'utilisabilité. » « It isn't a percentage » : 68 est le 50e centile
  (Sauro 2011).
- « Le premier clic prédit la réussite à 87 %. » Réplication sur 750 participants : 78 % contre 70 %.
- « On arrête un A/B dès qu'il est significatif. » Inférence « wholly unreliable » (Johari et al.).
- « ISO 9241-110 : individualisation, tolérance aux erreurs. » Liste périmée depuis l'édition 2020.

## Ce que ce skill ne fait pas

- **Il ne remplace pas la recherche sur le produit.** Il dit où regarder ; seuls les utilisateurs
  de ce produit disent ce qui s'y passe.
- **Il ne remplace pas `a11y-audit`**, qui vérifie un écran implémenté critère par critère.
- **Il ne fait pas de droit.** Les textes réglementaires sont cités pour ce qu'ils disent ; leur
  application à un produit précis est une question de juriste.
- **Il n'est pas exhaustif.** Un domaine absent des fiches se traite par la veille, pas par la
  mémoire.

## D'où vient ce contenu

Recherche documentaire du **09.11.2026**, menée en six volets parallèles (formulaires, navigation,
mobile et temps de réponse ; contenus, documents et accessibilité ; IA, dark patterns et
onboarding ; normes, lois UX et méthodes ; front de recherche 2022-2026 ; cognition et chemin
d'usage). Une règle unique pour les six : **rien de mémoire**. Chaque entrée cite une page
réellement ouverte (`WebFetch`, ou PDF téléchargé puis extrait par `pdftotext`) et en recopie un
extrait verbatim ; un chiffre dont la source primaire n'a pas été trouvée est rangé en
« Non vérifié », pas dans les entrées.

- **206 entrées** dans six fiches, **251 URL distinctes**. Sources les plus citées : NN/g, W3C,
  arXiv, legislation.gov.uk (texte de la directive EAA et lecture de secours quand EUR-Lex
  refusait l'accès), web.dev, aperçus officiels de normes ISO, Microsoft Research, MeasuringU,
  Canada.ca, GOV.UK Design System. Wikipédia n'y sert que d'index vers une source primaire.
- **38 mentions « résumé seul lu »** dans les fiches : les entrées qui ne reposent que sur
  l'abstract d'un article le disent à l'endroit même. Elles sont surtout dans
  les fiches les plus récentes (front de recherche, IA) et les méthodes, où le texte intégral
  était derrière un accès payant.
- **Volet growth**, même jour, même règle, cinq volets (science du marketing ; conversion et
  persuasion ; ASO ; e-mails, délivrabilité et droit ; SEO, recherche par IA et droit de la
  publicité) : **171 entrées**, **187 URL distinctes**, 34 mentions « résumé seul lu ». Sondage à la
  source : Play Console « Metadata » (titre à 30 caractères — le profil écrivait 60), Pew 2025
  (8 % contre 15 %), OIP art. 16 (texte complet sur fedlex), Binet & Field 2017 (PDF : 74:26 en
  ligne, innovation mineure), RFC 9989, délibération CNIL 2026-042, Kohavi, Deng, Vermeer 2022 (PDF :
  41 642 visiteurs par variante, taux de succès) — tous conformes.
- **Volet rédaction**, même jour, même règle, cinq volets (microcopy et UX writing ; voix, ton et
  langage inclusif ; i18n et locales ; orthotypographie ; traduction automatique et IA) : **177
  entrées**, **214 URL distinctes**, 13 mentions « résumé seul lu ». Sondage à la source : données
  CLDR 49 (pluriels de fr, es, it, en, de, ru, pl, ar), tableau d'expansion IBM sur la page du W3C,
  Li et al. 2025 (texte intégral : 43 % → 25 %), WCAG 2.5.3, Miller et al. 2016 (texte intégral),
  Instructions de la Chancellerie fédérale de 2016 (PDF : apostrophe interdite dans les nombres),
  sortie d'`Intl` en fr-CH, de-CH et it-CH mesurée sous Node 22, art. 113 de l'AI Act — tous
  conformes ; l'effet de l'Omnibus numérique sur l'art. 50 reste non vérifié au Journal officiel.
- **Volet design visuel**, même jour, même règle, cinq volets (perception et esthétique ; couleur et
  contraste ; typographie et mise en page ; motion, états et design systems ; front récent
  2024-2026) : **173 entrées**, **182 URL distinctes**, 29 mentions « résumé seul lu ». Chaque volet
  a jugé les règles de `designer` une à une. Sondage à la source : Doshi & Hauser 2024, Web Almanac
  2025 (incohérence interne 30 / 31 % notée), WebAIM Million 2026, WCAG 1.4.3 (texte large,
  arrondi, placeholder, désactivés), GOV.UK (corps 19 px), Legge & Bigelow 2011, NN/g 2017 sur le
  flat design, WCAG 2.4.13 (exemption du focus natif), NN/g sur la durée des animations — tous
  conformes, avec une nuance (NN/g resserre à 100-400 ms pour la plupart des cas).
- **Contrôle par sondage** du volet UX, fait hors des volets de recherche en rouvrant la source : heuristiques
  de Nielsen, échelle de sévérité de Nielsen, validation GOV.UK, zone du pouce (Hoober 2017),
  barres de progression (Harrison et al. 2010, texte intégral), Mathur et al. 2019, Bansal et al.
  2021, statut de WCAG 3 et approbation ISO de WCAG 2.2, METR 2025, déqualification en coloscopie
  (Lancet Gastroenterology & Hepatology 2025), Drew et al. 2013. Tous conformes ; une nuance
  ajoutée (les −11 % de Harrison valent pour une variante précise de barre). Le reste n'a pas été
  recontrôlé un par un : une entrée qui surprend se rouvre à sa source avant d'être citée.
- **Sources primaires inaccessibles** pendant la recherche (accès refusé ou rendu JavaScript) :
  iso.org, EUR-Lex, dl.acm.org pour plusieurs articles, Apple HIG, Material 3. Chaque fiche dit
  par quoi elles ont été remplacées.

**Ce qui fait vieillir ce contenu, par ordre de vitesse** : les fiches IA et front de recherche
(préprints, études de 2025-2026), les statuts réglementaires (EAA, DSA, consentement, WCAG 3),
les guidelines de plateformes ; puis les chiffres d'études de marché (Baymard, WebAIM). Les
fondements cognitifs (Fitts, Norman, Simons & Chabris) vieillissent le moins.

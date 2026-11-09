---
name: ux-preuves
description: "Référentiel UX fondé sur des preuves vérifiées et datées, avec niveau de preuve et limites. Fiches : cognition et chemin d'usage, formulaires, navigation, mobile, temps de réponse, contenus et documents, accessibilité, interfaces IA, dark patterns, onboarding, méthodes de test et de mesure, lois UX et mythes, recherche récente. Déclencheurs : justifier une recommandation UX, quelle étude, est-ce prouvé, chiffre UX, état de l'art UX, UX d'un document, d'un PDF ou d'un rapport, UX d'un assistant IA, test utilisateur, SUS, A/B test, sévérité. Pas pour : l'audit WCAG ex-post (`a11y-audit`), la direction visuelle (`designer`)."
---

# UX fondée sur des preuves — référentiel vérifié

> Version 1.0 — 09.11.2026 (création, demande de l'utilisateur : faire monter l'agent `ux` en compétence sur la recherche et les sources spécialisées, applications, sites, logiciels et documents). Préchargé par `ux` (clé `skills:`) : ne pas lui poser de `paths:`.
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
| `references/front-de-recherche.md` | Résultats récents (2022-2026) ou solides et méconnus : lisibilité individualisée, effets mesurés de l'IA sur le travail (productivité, déqualification, sur-confiance), état réel de l'accessibilité, nudges et réplications ratées, passkeys, lecture des graphiques |

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
- **Contrôle par sondage**, fait hors des volets de recherche en rouvrant la source : heuristiques
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

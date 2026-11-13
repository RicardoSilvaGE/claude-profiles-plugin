# Science du beau : ce qui rend un écran d'application désirable

> Recherche documentaire du 13.11.2026 pour la fiche de l'agent `graphiste` : 2 ou 3 variantes
> d'écrans de téléphone en HTML/CSS, pour des applications grand public.
>
> **Méthode.** Chaque entrée cite une source réellement ouverte ce jour-là. Pour un PDF, le texte a été extrait
> avec `pdftotext` et lu. Pour une page web, la lecture est passée par l'outil WebFetch. Trois statuts de lecture :
> - **texte intégral lu** : PDF ou page complète ;
> - **résumé seul lu** : seul le résumé de l'éditeur ou du dépôt a été ouvert ;
> - **paraphrase de l'outil de lecture** : l'outil de lecture a reformulé la page, aucun extrait mot à mot n'est disponible.
>
> Ce qui n'a pu être lu qu'à travers un extrait de moteur de recherche **ne fait l'objet d'aucune entrée**.
> Ces sources sont listées dans la section « Sources non lues ».
>
> **Déjà couvert par la fiche `design-perception-esthetique.md` du skill `ux-preuves`, non repris ici** :
> Lindgaard 2006, Tuch 2012 (complexité et prototypicalité), Reinecke 2013 et 2014, Moshagen & Thielsch 2010
> (VisAWI), Seckler 2015, Bar & Neta 2006 (dans `design-typographie-mise-en-page.md`), Tractinsky 2000 et
> Tuch 2012 sur l'effet esthétique-utilisabilité (dans `normes-lois-methodes.md`). Les entrées ci-dessous
> approfondissent ou nuancent ces sources quand elles s'y rattachent, et le disent.
>
> **Transposition.** Presque toutes les études portent sur des sites web, des objets (lampes, chaises), des
> peintures ou des pastilles de couleur. Le niveau N donné vaut **pour le contexte de l'étude**. Le passage
> à un écran de téléphone, dans la ligne « Pour graphiste », est un jugement de conception (N0), sauf mention
> contraire. Les preuves propres au mobile sont **minces** : une seule expérience contrôlée sur une application
> mobile a pu être lue en entier (Perrig et al. 2023).

Niveaux (échelle du skill `ux-preuves`) : N1 norme · N2 recherche revue par pairs ou étude empirique à large
échantillon · N3 guideline de plateforme · N4 avis d'expert ou praticien · N0 jugement de conception déclaré.
Une étude non répliquée ou dont la réplication a échoué descend d'un niveau.

---

## 1. Principes généraux du beau

### Unifier d'abord, varier ensuite : l'unité et la variété augmentent toutes deux le plaisir esthétique, l'unité pèse plus

- **Ce que dit la source.** Post, Blijlevens et Hekkert mènent trois études sur des designs de produits.
  L'unité et la variété augmentent chacune l'appréciation esthétique, mais chacune atténue l'effet de
  l'autre. Les designs qui équilibrent les deux sont préférés. L'unité est le facteur le plus fort, et elle
  aide à apprécier la variété (paraphrase de l'outil de lecture). Berghman et Hekkert testent ensuite le
  « Unified Model of Aesthetics » sur 300 répondants et 20 produits, puis sur 60 répondants et 24 stimuli.
  Ses trois principes sont soutenus. L'unité dans la variété « has the strongest impact on aesthetic
  pleasure ». La version de 2016 du même travail ajoute que la typicalité « becomes of little importance »
  une fois les mesures perceptives et sociales prises en compte.
- **Références.**
  - Post, R. A. G., Blijlevens, J., Hekkert, P., 2016, « "To preserve unity while almost allowing for chaos": Testing the aesthetic principle of unity-in-variety in product design », *Acta Psychologica* 163, 142-152, DOI 10.1016/j.actpsy.2015.11.013. Notice lue le 13.11.2026 : https://research.tudelft.nl/en/publications/to-preserve-unity-while-almost-allowing-for-chaos-testing-the-aes/ (résumé seul lu).
  - Berghman, M., Hekkert, P., 2017, « Towards a unified model of aesthetic pleasure in design », *New Ideas in Psychology*, DOI 10.1016/j.newideapsych.2017.03.004. Notice lue le 13.11.2026 : https://repub.eur.nl/pub/99004 (résumé seul lu).
  - Berghman, M., Hekkert, P., 2016, communication DRS 2016 (Brighton). Page lue le 13.11.2026 : https://drs2016.org/440 (résumé seul lu).
- **Niveau.** N2 (résumés seuls lus).
- **Limites.** Les stimuli sont des produits physiques, pas des écrans. Les effectifs des trois études de Post
  et al. n'ont pas été lus. « Unité » et « variété » sont des jugements perçus, pas des mesures de pixels.
- **Pour graphiste :** construire chaque variante sur un système unifié : une grille, une famille de rayons,
  une échelle typographique, une palette. Introduire ensuite **une** source de variété contrôlée : une
  illustration, une carte de couleur pleine, un chiffre en grand, un rythme de tailles de cartes. Un écran
  tout uni (liste grise uniforme) perd sur la variété. Un écran varié sans système perd sur l'unité, qui pèse
  le plus. En cas de doute, renforcer l'unité avant d'ajouter de la variété.

### Rester reconnaissable et ajouter une nouveauté : la préférence va à l'optimum entre typique et nouveau (MAYA)

- **Ce que dit la source.**
  - Hekkert, Snelders et van Wieringen, en trois études sur des produits de consommation : la typicalité et la
    nouveauté sont « jointly and equally effective in explaining the aesthetic preference », mais se
    suppriment mutuellement. La conclusion : « Preferred are products with an optimal combination of both
    aspects ». Le niveau d'expertise des observateurs ne change pas leurs contributions relatives.
  - Thurgood, Hekkert et Blijlevens (texte intégral lu) trouvent que les deux expliquent le plaisir
    esthétique. Expérience 1 (48 participants, photos de lampes) : « R2 = .55 », coefficients de .61 pour la
    typicalité et de .45 pour la nouveauté. Expérience 2 (208 participants, lampes et horloges) : R2 = .16,
    les deux toujours positives. Dans l'expérience 1, la corrélation typicalité-nouveauté est nulle
    (« r = -.04, p > .05 ») : les deux ne s'excluent pas.
  - Hung et Chen (2012, 88 chaises, 60 étudiants) trouvent que les chaises les plus belles ont une nouveauté
    **modérée** : relation en U inversé pour la complexité et l'émotion, mais relation linéaire faible et
    positive pour la « tendance » (paraphrase de l'outil de lecture). Le modèle n'explique que 18,3 % de la
    variance.
- **Références.**
  - Hekkert, P., Snelders, D., van Wieringen, P. C. W., 2003, « "Most advanced, yet acceptable": Typicality and novelty as joint predictors of aesthetic preference in industrial design », *British Journal of Psychology* 94, 111-124. Notice lue le 13.11.2026 : https://research.vu.nl/en/publications/most-advanced-yet-acceptable-typicality-and-novelty-as-joint-pred/ (résumé seul lu).
  - Thurgood, C., Hekkert, P., Blijlevens, J., « The joint effect of typicality and novelty on aesthetic pleasure for product designs: influences of safety and risk », communication de conférence, **lieu et année non vérifiés**. PDF lu le 13.11.2026 : https://opus.lib.uts.edu.au/bitstream/10453/36796/4/The%20joint%20effect%20of%20typicality%20and%20novelty%20on%20aesthetic%20pleasure%20for%20product%20designs.pdf
  - Hung, W.-K., Chen, L.-L., 2012, « Effects of Novelty and Its Dimensions on Aesthetic Preference in Product Design », *International Journal of Design* 6(2), 81-90. Page lue le 13.11.2026 : https://ijdesign.org/index.php/IJDesign/article/view/1146/479
- **Niveau.** N2.
- **Limites.**
  - Le domaine étudié est le design de produits, pas les écrans.
  - Dans Thurgood et al., la manipulation « sécurité contre risque » de l'expérience 2 **a échoué** :
    le contrôle de manipulation ne montre aucune différence. L'hypothèse évolutionniste reste donc non testée.
  - La relation entre typicalité et nouveauté n'est pas stable d'une étude à l'autre : forte suppression
    mutuelle en 2003, corrélation nulle chez Thurgood.
- **Pour graphiste :** chaque variante garde les **repères attendus** de sa catégorie d'application.
  Pour une application bancaire, par exemple : solde en haut, liste de transactions, barre d'onglets en bas.
  La nouveauté va dans **un ou deux** éléments visibles : une forme de carte, une manière de montrer le
  chiffre clé, une palette inattendue pour la catégorie. Les 2 ou 3 variantes se répartissent sur l'axe
  typique-nouveau : une variante proche de la catégorie, une variante plus audacieuse, aucune
  méconnaissable [N0 pour la transposition].

### Rendre l'écran facile à « lire » visuellement : la fluidité de traitement est une source de plaisir esthétique

- **Ce que dit la source.** Reber, Schwarz et Winkielman (texte intégral lu) proposent : « The more fluently
  perceivers can process an object, the more positive their aesthetic response ». Ils ramènent à la fluidité
  les effets classiques de « figural goodness, figure–ground contrast, stimulus repetition, symmetry, and
  prototypicality ». Ils citent leurs propres études, où des cercles à fort contraste figure-fond sont jugés
  plus jolis que des cercles à faible contraste.
- **Référence.** Reber, R., Schwarz, N., Winkielman, P., 2004, « Processing Fluency and Aesthetic Pleasure: Is Beauty in the Perceiver's Processing Experience? », *Personality and Social Psychology Review* 8(4), 364-382. PDF lu le 13.11.2026 : https://pages.ucsd.edu/~pwinkielman/reber-schwarz-winkielman-beauty-PSPR-2004.pdf
- **Niveau.** N2. C'est une revue théorique publiée, qui s'appuie sur des expériences de laboratoire
  portant sur des stimuli simples.
- **Limites.** La théorie explique bien le « joli » et le « plaisant ». Elle explique mal l'attrait de la
  nouveauté, que MAYA et l'unité dans la variété viennent compléter. Les stimuli sont des formes, des mots
  et des visages, pas des interfaces.
- **Pour graphiste :** obtenir la fluidité par ce qui ne coûte rien en caractère :
  - symétrie ou alignement strict sur une grille ;
  - contraste figure-fond franc pour le texte et les éléments clés ;
  - répétition des mêmes composants (une seule forme de carte, une seule forme de bouton) ;
  - silhouette d'écran conforme à la catégorie.

  Réserver l'effort « surprenant » à un seul endroit, pour ne pas faire chuter la fluidité de tout l'écran.

### Ne pas réduire « beau » à « dépouillé » : en peinture, plus d'éléments va avec plus de beauté (et l'hypothèse « ranger plutôt que supprimer » reste à tester)

- **Ce que dit la source.** Marin, Lampatz, Wandl et Leder (texte intégral lu) testent l'hypothèse de Berlyne
  (U inversé entre complexité et ton hédonique) sur 206 participantes, avec des peintures. En contrôlant la
  familiarité, la complexité est liée **positivement** à la beauté (rs = 0,26), faiblement et négativement à
  l'agrément (rs = −0,16), et pas du tout à l'appréciation (liking). Pas de U inversé pour les images. Les
  auteurs rapportent la synthèse de Nadal et al. (2010) : une complexité faite du **nombre et de la diversité**
  des éléments va de pair avec une beauté croissante (relation linéaire positive), alors qu'une
  manipulation par **désorganisation** donne une courbe en U (paraphrase de l'outil de lecture).
- **Référence.** Marin, M. M., Lampatz, A., Wandl, M., Leder, H., 2016, « Berlyne Revisited: Evidence for the Multifaceted Nature of Hedonic Tone in the Appreciation of Paintings and Music », *Frontiers in Human Neuroscience* 10:536. Page lue le 13.11.2026 : https://www.frontiersin.org/articles/10.3389/fnhum.2016.00536/full (lecture partielle : premiers 100 000 caractères sur 182 000, par l'outil de lecture).
- **Niveau.** N2 pour le résultat de Marin et al. sur les peintures. Nadal et al. 2010 n'est connu que par
  cette citation, non lu. La distinction « richesse ordonnée contre désordre » est un **jugement N0**.
- **Limites.** L'échantillon est féminin et les stimuli sont des peintures. Sur les **sites web**, la fiche
  existante établit que la complexité élevée fait baisser l'attrait au premier regard (Tuch 2012, Reinecke
  2013). Les données de Marin montrent seulement que, pour des peintures, la complexité n'est pas liée
  négativement à la beauté. Elles ne prouvent pas qu'un écran chargé mais rangé plaît.
- **Pour graphiste :** ne pas confondre « dépouillé » et « beau ». Hypothèse de travail [N0, à vérifier en
  comparant les variantes] : un écran peut porter beaucoup d'éléments (photos, chiffres, catégories
  colorées) s'ils sont rangés par une grille stricte, des groupes nets et de la répétition. Avant de
  **retirer** un élément pour alléger, essayer de le **ranger**, puis retirer ce qui reste désordonné.

### Viser deux dimensions de beauté : « classique » (net, ordonné) comme plancher, « expressive » (originale) comme différenciateur

- **Ce que dit la source.** Lavie et Tractinsky (texte intégral lu) mènent quatre études : 125, 212 et 145
  étudiants, puis 384 internautes. Elles font émerger deux dimensions de l'esthétique perçue des sites.
  - La dimension **classique** (« clean », « clear », « pleasant », « symmetrical », « aesthetic ») renvoie à un
    design « orderly and clear ». Sa corrélation avec les autres facteurs est « consistently high (between
    0.60 and 0.78) ».
  - La dimension **expressive** (« original », « sophisticated », « fascinating », « creative », « uses special
    effects ») est corrélée plus faiblement aux autres facteurs (r de 0,37 à 0,59).
  - L'utilisabilité perçue est « correlated substantially higher with the classic aesthetic dimension ».
  - Les corrélations avec le plaisir sont « of similar magnitude for both aesthetic dimensions ».
- **Référence.** Lavie, T., Tractinsky, N., 2004, « Assessing dimensions of perceived visual aesthetics of web sites », *International Journal of Human-Computer Studies* 60(3), 269-298. PDF lu le 13.11.2026 : http://www.ise.bgu.ac.il/faculty/noam/papers/04_tl_nt_ijhcs.pdf
- **Niveau.** N2.
- **Limites.**
  - Les données portent sur des sites web de 2003, avec des échantillons surtout étudiants et israéliens.
  - Les auteurs signalent un possible biais de méthode commune : les corrélations avec la qualité de service
    sont plus élevées que prévu.
  - Une critique de certains items par Moshagen et Thielsch n'est connue que par un extrait de moteur
    (non vérifiée). Leur structure en quatre facettes figure dans la fiche existante.
- **Pour graphiste :** toutes les variantes doivent passer le plancher **classique** : alignées, nettes,
  lisibles, ordonnées. C'est ce qui porte aussi l'impression d'utilisabilité. Les variantes se distinguent
  ensuite sur la dimension **expressive** : une variante sobre, une variante plus originale (forme, couleur,
  typographie de titre). Le plaisir ressenti dépend autant de l'une que de l'autre, et une variante qui n'a
  que du classique risque d'être jugée « propre mais sans âme » [N0].

### Utiliser le vocabulaire « viscéral, comportemental, réflexif » comme grille de relecture, pas comme modèle validé

- **Ce que dit la source.** Norman décrit trois niveaux. Le niveau **viscéral** est la réaction immédiate à
  l'apparence (« that initial impact, to its appearance »). Le niveau **comportemental** est l'expérience de
  l'usage. Le niveau **réflexif** porte sur ce que le produit dit de son propriétaire. Les données mentionnées
  dans l'essai, une étude avec Coyne et Nielsen sur sept catégories de produits, sont présentées comme des
  « preliminary reports », sans effectif ni statistique (paraphrase de l'outil de lecture).
- **Référence.** Norman, D., 17.11.2008, « Emotional Design » (essai), jnd.org. Page lue le 13.11.2026 : https://jnd.org/emotional-design/
- **Niveau.** N4.
- **Limites.** Aucune validation empirique du modèle à trois niveaux n'a été trouvée lors de cette
  recherche, seulement des études préliminaires et des études de cas, connues par extraits de moteur et non
  lues.
- **Pour graphiste :** s'en servir pour relire une variante sous trois angles :
  - Quel effet en 1 seconde ? (viscéral)
  - L'écran est-il clair pour agir ? (comportemental)
  - Qu'est-ce que l'utilisateur aimerait montrer de cette application ? (réflexif)

  Ne jamais présenter ce découpage comme un résultat scientifique.

---

## 2. Beauté, utilisabilité et performance

### Ne pas vendre la beauté comme garantie d'utilisabilité : la corrélation beauté-utilisabilité est très variable et passe par le jugement global

- **Ce que dit la source.** Hassenzahl et Monk recensent 15 articles qui rapportent 25 corrélations
  indépendantes entre beauté perçue et utilisabilité perçue. Ils constatent une « remarkably high
  variability » des coefficients. Dans leurs propres données, sur quatre jeux de données, le lien entre
  qualité pragmatique et beauté est « wholly mediated by goodness », c'est-à-dire par le jugement global
  (citations du résumé reprises par la page lue).
- **Référence.** Hassenzahl, M., Monk, A., 2010, « The Inference of Perceived Usability From Beauty », *Human-Computer Interaction* 25(3), 235-260. Résumé lu le 13.11.2026 sur un blogue qui le reproduit : https://matthias-laschke-mt77.squarespace.com/blog/2010/09/11/the-inference-of-perceived-usability-from-beauty (résumé seul lu, copie non officielle).
- **Niveau.** N2.
- **Limites.** Les effectifs n'ont pas été lus. Cette entrée **approfondit** l'entrée Tractinsky 2000 / Tuch
  2012 de `normes-lois-methodes.md`, qui conclut déjà que la relation est contestée.
- **Pour graphiste :** la beauté est un objectif en soi : attrait, envie d'ouvrir l'application. Ce n'est
  pas un substitut au parcours. Ne jamais justifier une variante par « elle sera plus facile à utiliser parce
  qu'elle est belle ».

### Savoir que la beauté aide un peu à réussir les tâches : effet réel mais petit et très variable

- **Ce que dit la source.**
  - La première méta-analyse (texte intégral lu) porte sur 25 études, 101 effets et 3 025 participants. Elle
    trouve « a small significant overall effect of interface aesthetics on user performance (g = 0.12) »,
    avec une forte hétérogénéité. Aucun modérateur n'est significatif.
  - Sa nouvelle version de 2026 est préenregistrée et porte sur 31 études, 234 effets et 18 794
    participants. Elle trouve un effet « small to medium » (g = 0,29), toujours très hétérogène. Le type
    d'appareil et la **manipulation de la typographie** y sont des modérateurs significatifs. Les auteurs
    signalent que l'utilisabilité vécue pourrait confondre les résultats (paraphrase de l'outil de lecture).
- **Références.**
  - Thielsch, M. T., Scharfen, J., Masoudi, E., Reuter, M., 2019, « Visual Aesthetics and Performance: A First Meta-Analysis », *Mensch und Computer 2019*, ACM, DOI 10.1145/3340764.3340794. PDF lu le 13.11.2026 : https://www.uni-muenster.de/imperia/md/content/owms/2019_thielsch_et_al.pdf
  - Schlamann, M., Nestler, S., Thielsch, M. T., 2026, « Attractive Things Do Work Better: A Meta-Analysis on Visual Aesthetics and User Performance », matériel supplémentaire, Zenodo, 25.02.2026. Notice lue le 13.11.2026 : https://zenodo.org/records/18777943 (résumé seul lu ; statut de revue par les pairs **non établi**).
- **Niveau.** N2 pour 2019. N2 faible pour 2026, dont le statut de publication n'a pas été vérifié.
- **Limites.** Le **sens** de l'effet modérateur de la typographie n'a pas été lu : on sait seulement que
  les études qui manipulent la typographie donnent des effets différents des autres. L'hétérogénéité
  reste inexpliquée.
- **Pour graphiste :** présenter la beauté comme un gain d'attrait, avec au mieux un petit bénéfice
  d'efficacité. Ne pas annoncer de gain de performance chiffré pour une variante. La typographie est un
  levier qui change l'effet, dans un sens non établi : la traiter avec autant de soin que la couleur, sans
  en promettre davantage [N0].

### Sur mobile, une application jugée belle est jugée nettement plus utilisable ; l'effet sur la performance reste incertain

- **Ce que dit la source.** Perrig, Ueffing, Opwis et Brühlmann (texte intégral lu) comparent en ligne deux
  variantes d'une même application web, sur smartphone uniquement (N = 281, MTurk, États-Unis).
  - **Variante belle** : bleu et gris seulement, une police (Futura), symétrie maximale avec les éléments
    centrés sur un axe vertical.
  - **Variante laide** : six couleurs dont trois rouges, trois polices dont Comic Sans MS, symétrie évitée.
  - Les deux variantes respectent le contraste WCAG AA.
  - **Contrôle de manipulation** : VisAWI 5,62 contre 4,00 (d = 1,26).
  - **Utilisabilité perçue** (UMUX) : 80,19 contre 61,44 (d = 0,86).
  - **Performance** : « a small but non-significant effect of aesthetics on performance (d = 0.22) »
    (p = 0,07). Temps de réalisation : d = −0,06, non significatif.
- **Référence.** Perrig, S. A. C., Ueffing, D., Opwis, K., Brühlmann, F., 2023, « Smartphone app aesthetics influence users' experience and performance », *Frontiers in Psychology* 14:1113842, DOI 10.3389/fpsyg.2023.1113842. PDF lu le 13.11.2026 : https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2023.1113842/pdf
- **Niveau.** N2.
- **Limites.**
  - **Le résumé surestime le résultat** : il annonce que l'application belle « increases users' […] objective
    performance », alors que le texte rapporte un effet non significatif. Citer le texte, pas le résumé.
  - La manipulation oppose « soigné » à « délibérément laid » (Comic Sans, six couleurs, asymétrie). Elle
    montre l'écart entre laid et propre, pas entre bon et excellent.
  - Les auteurs signalent une puissance peut-être insuffisante, un effet plafond sur le score, et
    l'impossibilité de dissocier les facettes (couleur contre symétrie).
  - L'analyse factorielle du VisAWI n'a pas retrouvé sa structure.
  - Le seuil de 4,5 « for an aesthetic interface » est attribué par les auteurs à Hirschfeld & Thielsch 2015,
    **non lu**.
- **Pour graphiste :** ce qui est mesuré, c'est l'écart entre un **ensemble** soigné et un ensemble
  délibérément laid. C'est un **plancher contre la laideur**, pas une recette du beau. Les trois traits de
  la variante belle ne peuvent pas être séparés dans cette étude. Leur traduction en garde-fous est un
  jugement [N0] :
  - **palette restreinte**, sans multiplier les teintes concurrentes ;
  - **typographie disciplinée** : pas plus de deux familles (texte, et éventuellement une police de titre
    choisie), jamais trois polices de caractère différent ;
  - **symétrie ou axe d'alignement visible**.

  C'est la seule expérience contrôlée sur une application mobile lue pour cette recherche.

---

## 3. Forme et composition

### Préférer les formes arrondies pour l'attrait au premier regard, sans en attendre beaucoup sur une interface

- **Ce que dit la source.** La méta-analyse de Chuquichambi et al. (texte intégral lu) porte sur 61 études,
  106 échantillons et 309 tailles d'effet. Elle trouve « a Hedges' g of 0.39--consistent with a medium
  effect size ». Elle conclut que la préférence pour la courbure est « reliable but not universal ».
  - **Effets les plus forts** : stimuli sans signification (g = 0,56) et objets réels (g = 0,42).
  - **Design symbolique** (logos, polices) : effet non significatif (g = 0,30, p = 0,092).
  - **Design spatial** (intérieurs, façades) : aucun effet (g = −0,04).
  - **Selon l'expertise** : effet chez les non-experts (g = 0,40), mais non significatif chez les experts
    (g = 0,13).
  - **Selon le temps de présentation** : l'effet est plus fort quand ce temps est limité (g = 0,75 pour
    84 à 7 000 ms) que lorsqu'il est libre (g = 0,32).
  - Pas de biais de petites études au test d'Egger adapté (« no evidence of a small-study bias »,
    p = 0,32), et pas d'asymétrie visible au diagramme en entonnoir.
- **Référence.** Chuquichambi, E. G., et al., 2022, « How universal is preference for visual curvature? A systematic review and meta-analysis », *Annals of the New York Academy of Sciences*, DOI 10.1111/nyas.14919. PDF lu le 13.11.2026 : https://research-api.cbs.dk/ws/portalfiles/portal/93945556/erick_g_chuquichambi_et_al_how_universal_is_preference_for_visual_curvaturepublishersversion.pdf
- **Niveau.** N2, méta-analyse en grande partie préenregistrée.
- **Limites.** **Approfondit** Bar & Neta 2006 (`design-typographie-mise-en-page.md`). L'effet est le plus
  faible précisément dans les catégories proches des interfaces : design symbolique, et experts. Aucune
  étude n'y porte sur des écrans d'application, et aucune ne donne de valeur de rayon.
- **Pour graphiste :** des coins arrondis et des formes douces sont un choix sûr pour l'attrait au premier
  coup d'œil d'un public non expert, puisque c'est en exposition brève que l'effet est le plus fort. Ce choix
  ne remplace ni la composition ni la couleur. Un rayon franchement plus grand ou plus petit que la moyenne
  reste un **choix de caractère**, à décider par variante [N0]. Ne jamais promettre plus de clics grâce aux
  arrondis (voir « Mythes »).

### Indices d'un modèle appris sur des écrans mobiles : couleurs très saturées, longs textes et multitude de petits éléments font « laid »

- **Ce que dit la source.** Lima et al. (texte intégral lu) entraînent un réseau de neurones à prédire la
  note esthétique d'écrans Android : 820 captures d'applications App Inventor, notées par 10 membres du
  groupe de recherche. Sur des écrans nouveaux, les prédictions sont fortement corrélées aux notes humaines
  (ρ = 0,9). En commentant quelques exemples, les auteurs observent :
  - les écrans jugés « très laids » utilisent des couleurs très saturées ;
  - les longs blocs de texte font baisser la note ;
  - les mieux notés ont de l'espace blanc et des contrastes de couleur « much softer » ;
  - le manque de symétrie pénalise ;
  - les écrans avec « fewer large elements » sont mieux notés que ceux à « many small ones ».

  Les auteurs qualifient eux-mêmes ces observations de « superficial analysis ».
- **Référence.** Lima, A. L. de S., Gresse von Wangenheim, C., Martins, O. P. H. R., von Wangenheim, A., Hauck, J. C. R., Borgatto, A. F., 2024, « A Deep Learning Model for the Assessment of the Visual Aesthetics of Mobile User Interfaces », *Journal of the Brazilian Computer Society* 30:1, DOI 10.5753/jbcs.2024.3255. PDF lu le 13.11.2026 : https://journals-sol.sbc.org.br/index.php/jbcs/article/download/3255/2730/20550
- **Niveau.** N2 pour le modèle. **N4** pour les observations de design, qui sont informelles et ne reposent
  que sur 10 notateurs internes.
- **Limites.** Les écrans viennent d'App Inventor (souvent des travaux scolaires), avec une forte proportion
  d'écrans amateurs. Rien ne dit ce qui distingue un bon écran d'un excellent.
- **Pour graphiste :** sert de liste d'**anti-motifs** à vérifier :
  - pas d'aplats saturés en grande surface ;
  - pas de paragraphe long sur un écran d'accueil ;
  - moins d'éléments, plus grands, plutôt qu'une mosaïque de petites pastilles ;
  - un axe de symétrie ou d'alignement visible.

### Les mises en page alignées sur une grille, groupées et harmonisées sont mieux notées que l'alignement seul ou le hasard

- **Ce que dit la source.** Wang et al. génèrent des maquettes en fil de fer par programmation par ensembles
  de réponses (ASP), selon trois conditions : objectifs complets (grille, regroupement, harmonie des
  couleurs, espace blanc), grille seule, ou disposition aléatoire. 97 participants (Prolific) notent la
  qualité visuelle : effet de la condition F(2, 27) = 32,9, p < 0,001. L'ordre est complet > grille >
  aléatoire. Une réplication sur 41 nouveaux participants, avec le VisAWI-S, place encore la condition
  complète en tête, mais les autres comparaisons deux à deux n'y sont pas significatives. Les notes
  moyennes des stimuli concordent entre les deux expériences (r = 0,98).
- **Référence.** Wang, X., Romero Davila, J., Sourulahti, S., Schaub, T., Jokinen, J. P. P., 03.09.2026, « Grounding GUI Design in Computational Psychology », prépublication arXiv:2609.03918. PDF lu le 13.11.2026 : https://arxiv.org/pdf/2609.03918
- **Niveau.** N2 faible : prépublication non revue par les pairs, deux échantillons.
- **Limites.** Les stimuli sont des fils de fer génériques, sans domaine d'application ni contenu réel. Les
  objectifs sont combinés, ce qui empêche de savoir lequel compte le plus.
- **Pour graphiste :** la grille seule ne suffit pas. Ajouter le regroupement (écart intra-groupe < écart
  inter-groupes), l'harmonie de palette et des marges d'espace blanc régulières. C'est le socle du
  « savoir-faire » perçu.

---

## 4. Couleur

### Construire les surfaces en teintes voisines contrastées en clarté, et faire trancher l'accent par sa teinte

- **Ce que dit la source.** Schloss et Palmer (texte intégral lu), 48 participants, 992 paires de couleurs
  (une figure sur un fond) :
  - « pair preference and harmony both increase as hue similarity increases ». La préférence dépend aussi
    fortement du contraste de **clarté**.
  - Le meilleur modèle explique 53,5 % de la variance : les paires préférées contiennent « cooler colors that
    were similar in hue and contrasting in Munsell value (lightness) ».
  - À l'inverse, la préférence pour la couleur de la **figure seule** augmente quand sa teinte contraste avec
    le fond.
  - Les préférences pour les couleurs prises isolément n'expliquent que 21,7 % de la préférence pour les
    paires, dont 15 % pour la couleur du fond, qui pèse plus que celle de la figure.
  - Les figures plus claires sur fond plus foncé et plus chaudes sur fond plus froid sont légèrement
    préférées (r = +0,14 et +0,13), mais ces effets sont faibles.
- **Référence.** Schloss, K. B., Palmer, S. E., 2011, « Aesthetic response to color combinations: preference, harmony, and similarity », *Attention, Perception, & Psychophysics* 73, 551-571, DOI 10.3758/s13414-010-0027-0. PDF lu le 13.11.2026 : https://palmerlab.berkeley.edu/pdf/Schloss&Palmer(2011).pdf
- **Niveau.** N2.
- **Limites.**
  - Les stimuli sont des carrés colorés, pas des interfaces.
  - L'échantillon est petit et universitaire américain.
  - Les auteurs signalent des différences individuelles de goût pour l'harmonie.
- **Pour graphiste :** palette d'écran en deux temps :
  1. Fonds, surfaces et cartes dans **une même famille de teinte**, en jouant sur la **clarté**
     (fond foncé, carte un cran plus claire ; ou l'inverse).
  2. **Un** accent dont la **teinte tranche** sur ce fond, réservé aux éléments à faire ressortir.

  Le fond pèse le plus dans le jugement : le choisir en premier et avec soin. C'est la traduction directe de
  « harmonie des paires » et de « préférence de la figure » [N0 pour la transposition].

### Choisir les couleurs d'après ce qu'elles évoquent dans l'univers de l'application : on aime les couleurs des choses qu'on aime

- **Ce que dit la source.** Palmer et Schloss (texte intégral lu) proposent la théorie de la valence
  écologique : « color preferences arise from people's average affective responses to color-associated
  objects ».
  - Sur 32 couleurs, 48 participants pour les préférences et 74 pour les associations, la valence moyenne
    des objets associés prédit la préférence (r = +0,893, « accounting for 80% of the variance »).
  - Les préférences forment un pic large sur le bleu et un creux étroit sur le chartreuse (jaune-vert).
    Le brun (orange foncé) et l'olive (jaune foncé) sont nettement moins aimés.
  - Les données sont culturelles : les valences américaines prédisent mieux les préférences américaines
    (r = 0,89) que japonaises (r = 0,74), et inversement.
  - L'attachement à une institution (l'université) déplace la préférence vers ses couleurs.
- **Référence.** Palmer, S. E., Schloss, K. B., 2010, « An ecological valence theory of human color preference », *PNAS* 107(19), 8877-8882, DOI 10.1073/pnas.0906172107. PDF lu le 13.11.2026 : https://palmerlab.berkeley.edu/pdf/Palmer%26Schloss%282010%29.pdf
- **Niveau.** N2.
- **Limites.**
  - Les couleurs sont jugées isolément sur fond gris.
  - L'échantillon vient de Berkeley, et les données japonaises sont préliminaires.
  - **Le « pic sur le bleu » ne veut pas dire « utiliser du bleu »** : le bleu est aussi la couleur la plus
    générique des interfaces. La préférence pour une couleur isolée explique peu la préférence pour une
    combinaison (entrée précédente).
- **Pour graphiste :** partir des **objets et des moments** de l'application pour dériver la palette :
  potager, vin, sport, finances, enfants. Les couleurs empruntées à des choses que le public apprécie dans
  ce domaine sont un pari plus sûr qu'une palette « tendance ». Éviter les bruns-olive ternes en grande
  surface, sauf si l'univers les valorise (cuir, café, bois) [N0].

---

## 5. Mesurer et comparer les variantes

### Pour départager deux variantes, utiliser les quatre questions du VisAWI-S et ne pas sur-interpréter un écart d'un demi-point

- **Ce que dit la source.** Brühlmann (prépublication) estime, par une méthode à ancrage sur 249
  participants et 8 sites, la plus petite différence utile sur le VisAWI-S (échelle de 1 à 7). Elle vaut
  0,46 point, soit environ 6,6 % de l'échelle. Les écarts supérieurs sont « likely noticeable and meaningful
  to users ». L'auteur recommande de déterminer cette valeur par domaine (paraphrase de l'outil de lecture,
  citation du résumé).
- **Référence.** Brühlmann, F., 2023, « Is a Mean Difference of 0.46 Relevant? Towards Determining the Smallest Effect Size of Interest for Visual Aesthetics of Websites », prépublication arXiv:2305.08945. Résumé lu le 13.11.2026 : https://arxiv.org/abs/2305.08945
- **Niveau.** N2 faible : prépublication, résumé seul lu.
- **Limites.** L'étude porte sur des sites web. La valeur dépend du niveau esthétique de départ des
  stimuli. La formulation des quatre items du VisAWI-S n'a pas été lue à la source.
- **Pour graphiste :** quand l'utilisateur ou des testeurs départagent les variantes, faire noter chaque écran
  sur les quatre facettes : simplicité, diversité, couleur, savoir-faire. Considérer qu'un écart moyen
  inférieur à environ 0,5 sur 7 ne départage pas vraiment deux variantes : trancher alors sur un autre
  critère (adéquation à la marque, parcours) [N0 pour la transposition].

---

## 6. Générer des écrans avec une IA

### Sans directives de style, les écrans générés par IA convergent vers la même allure générique : la casser explicitement

- **Ce que dit la source.** Wang et Brown (NN/g) testent des outils de prototypage par IA sur un vrai projet
  de refonte, avec trois niveaux de consigne, et les comparent au travail de designers. Sans spécifications,
  les sorties se ressemblent : polices sans empattement génériques, style minimal, accents de couleur vifs.
  Les auteurs l'attribuent à des valeurs par défaut issues de bibliothèques comme shadcn et Tailwind CSS.
  Les écrans paraissent plats, interchangeables, plus proches d'un fil de fer que d'un design à identité de
  marque. Les consignes détaillées (composants, langage visuel, états) et les références visuelles
  rapprochent la sortie du travail humain. Même les bonnes sorties manquent de finition : hiérarchie,
  regroupement, contraste, espacements réguliers (paraphrase de l'outil de lecture).
  Shin et al. (2026, prépublication conceptuelle, résumé lu) décrivent le même risque d'« homogenization »
  dans la génération de sites par IA, sans le mesurer.
- **Références.**
  - Wang, H.-H., Brown, M., Nielsen Norman Group, 24.10.2025, « AI prototyping ». Page lue le 13.11.2026 : https://www.nngroup.com/articles/ai-prototyping/
  - Shin, D., Gao, A., Pang, R. Y., Lee, J., Reinecke, K., Tseng, E., 13.03.2026, « Interrogating Design Homogenization in Web Vibe Coding », prépublication arXiv:2603.13036. Résumé lu le 13.11.2026 : https://arxiv.org/abs/2603.13036
- **Niveau.** N4 : évaluation heuristique de praticiens, sans nombre d'outils ni d'évaluateurs donnés, plus
  une analyse conceptuelle.
- **Limites.** Les outils évoluent vite. Le constat date d'octobre 2025.
- **Pour graphiste :** l'agent est lui-même un générateur de ce type, ce qui rend cette entrée centrale.
  - Toute variante qui ressemble à un gabarit shadcn/Tailwind par défaut (fond blanc ou zinc, Inter,
    accent vif unique, cartes grises arrondies) est un **échec de nouveauté** au sens de MAYA, même si elle
    est propre.
  - Avant de dessiner, fixer **par écrit**, pour chaque variante : une palette dérivée de l'univers de
    l'application, une typographie de titre choisie, un traitement de forme, et un élément signature.
  - Vérifier ensuite la finition que les générateurs ratent : hiérarchie, groupes, contraste, espacements
    réguliers.

---

## Ce qui ne marche pas / mythes

- **« Les boutons arrondis augmentent les clics de 55 % ».** Biswas, Abell et Chacko (2024, *Journal of
  Consumer Research* 51(3), 552-570, résumé lu sur https://ideas.repec.org/a/oup/jconrs/v51y2024i3p552-570..html
  le 13.11.2026) rapportent que des éléments arrondis obtiennent plus de clics, dans trois expériences de
  terrain et une étude d'oculométrie. Kohavi et al. (prépublication arXiv:2512.24521, v3 du 06.04.2026,
  résumé lu sur https://arxiv.org/abs/2512.24521) mènent trois tests A/B avec « over two thousand times more
  users » : les effets sont environ **deux ordres de grandeur plus petits**, avec des intervalles de
  confiance qui incluent zéro. Deux autres réplications indépendantes vont dans le même sens. **Réplication
  ratée** : Biswas descend d'un niveau. L'arrondi se justifie par l'attrait au premier regard (méta-analyse
  de Chuquichambi, effet modéré), pas par la conversion.
- **« Belle application = application performante ».** Les deux méta-analyses donnent un effet petit
  (g = 0,12) à petit-moyen (g = 0,29) et très hétérogène. Le résumé de Perrig et al. 2023 annonce un gain de
  performance que son propre texte ne confirme pas (d = 0,22, non significatif).
- **« Le beau entraîne l'utilisable ».** La corrélation est très variable d'une étude à l'autre et passe
  par le jugement global (Hassenzahl & Monk 2010). Ce point approfondit l'entrée contestée de
  `normes-lois-methodes.md`.
- **« Le minimalisme maximise la beauté ».** L'unité **et** la variété augmentent toutes deux le plaisir
  (Post et al. 2016). Pour des peintures, la complexité n'est pas liée négativement à la beauté (Marin et
  al. 2016). Ce qui est établi pour les sites web, c'est que la complexité **élevée** pénalise au premier
  regard (fiche existante). La simplicité extrême, elle, n'est pas un gain (Reinecke 2013 : faible et
  moyenne à égalité).
- **« Le U inversé de Berlyne vaut partout ».** Pour la **nouveauté**, un U inversé est trouvé sur des
  chaises (Hung & Chen 2012), mais dans les études MAYA, typicalité et nouveauté contribuent toutes deux
  positivement et ne s'opposent pas toujours (Thurgood et al., r = −0,04). Pour la **complexité**, pas de
  U inversé sur des peintures (Marin et al. 2016 : lien positif avec la beauté), ni sur des sites web
  (fiche existante : relation surtout linéaire).
- **« Le bleu est la couleur préférée, donc la bonne couleur d'interface ».** Une préférence pour une
  couleur isolée n'explique qu'une petite part de la préférence pour une combinaison (21,7 %, Schloss &
  Palmer 2011). Elle varie avec la culture et l'appartenance (Palmer & Schloss 2010). Le bleu est aussi la
  teinte par défaut la plus banale.
- **« Le modèle de Norman (viscéral, comportemental, réflexif) est validé ».** C'est un cadre de pensée.
  L'essai de l'auteur ne présente que des résultats préliminaires.
- **« La sécurité ou le risque font basculer la préférence vers le typique ou le nouveau ».** Cette
  hypothèse n'a pas été démontrée : la manipulation a échoué (Thurgood et al., expérience 2).

## Sources non lues (pas d'entrée, ne pas citer comme fait)

- **Miniukovich & De Angeli**, deux articles :
  - « Visual Impressions of Mobile App Interfaces », NordiCHI 2014, pp. 31-40 ;
  - « Computation of Interface Aesthetics », CHI 2015, pp. 1163-1172.

  Les dépôts (iris.unitn.it, ResearchGate, academia.edu, ACM DL) ont renvoyé 403 ou une vérification
  anti-robot. Les chiffres qui circulent (6 ou 8 métriques ; 36 % et 40 % de variance expliquée en 2014 ;
  32 % pour 53 applications iPhone et 49 % pour 62 pages web en 2015) **ne sont connus que par des extraits
  de moteur de recherche** et ne sont pas vérifiés. C'est le principal trou de cette recherche sur le
  **mobile**.
- **Miniukovich & Marchese 2020**, « Relationship between visual complexity and aesthetics of webpages »,
  CHI 2020 : cité par un tiers comme une réplication confirmant une relation linéaire inverse. Non ouvert.
- **Ngo, Teo & Byrne 2003**, « Modelling interface aesthetics », *Information Sciences* 152 : 14 mesures
  (équilibre, symétrie…). Seules les métadonnées ont été vues. Validation empirique non lue.
- **Hassenzahl 2004**, « The interplay of beauty, goodness, and usability in interactive products »,
  *Human-Computer Interaction* 19(4) : la thèse « la beauté suit les qualités hédoniques et reste stable à
  l'usage » n'est connue que par des extraits. Le PDF du miroir était indisponible (404), l'éditeur a renvoyé 403.
- **AttrakDiff** (Hassenzahl, Burmester, Koller 2003) : non ouvert.
- **Moshagen & Thielsch 2013** (VisAWI-S, *Behaviour & IT* 32(12)) : items et effectifs non lus.
- **Hirschfeld & Thielsch 2015** (*Ergonomics* 58(2)), seuil de 4,5 au VisAWI : pas de texte intégral.
- **Tuch, Bargas-Avila & Opwis 2010**, « Symmetry and aesthetics in website design: It's a man's
  business » : l'effet de la symétrie chez les hommes seulement (60 participants) n'est connu que par des
  extraits de catalogue.
- **Bauerly & Liu 2006** (*IJHCS* 64(8)) : symétrie préférée, nombre de groupes pénalisant. Extraits
  seulement.
- **Schmidt & Wolff 2018** (*i-com* 17(1)), symétrie, couleur et complexité sur 30 sites : le PDF n'a pas pu
  être téléchargé, connexion refusée.
- **Nadal, Munar, Marty & Cela-Conde 2010** (*Empirical Studies of the Arts* 28(2)) : connu seulement par
  la citation de Marin et al. 2016.
- **Benchmark « Design Theater »** (AIES 2026), indice d'homogénéité des interfaces générées : page bloquée
  par une protection anti-robot.

---

## Top 8 des consignes pour graphiste

Classement : les consignes fondées sur du N2 d'abord, rangées par impact sur l'allure, puis la consigne
N4 (n° 8), placée dans le top pour son impact sur un agent qui génère lui-même ses écrans. La transposition
au téléphone reste un jugement N0 pour toutes les consignes.

1. **Unité d'abord, variété ensuite.** Un système strict (grille, rayons, échelle de types, palette), puis
   **une** source de variété contrôlée par écran. Si un écran ne convainc pas, renforcer l'unité avant
   d'ajouter des éléments. [N2 — Post et al. 2016 ; Berghman & Hekkert 2017]
2. **Palette en deux temps.** Fonds et surfaces dans une même famille de teinte, différenciés par la
   clarté, puis un seul accent dont la teinte tranche. Choisir le fond en premier, c'est lui qui pèse le
   plus. [N2 — Schloss & Palmer 2011]
3. **Plancher contre la laideur sur mobile.** Palette restreinte, typographie disciplinée (deux familles
   au plus), axe de symétrie ou d'alignement visible. Sur smartphone, un ensemble soigné de ce type contre
   un ensemble délibérément laid fait monter l'utilisabilité perçue (d = 0,86). C'est un plancher, pas une
   recette ; le découpage en trois règles est N0. [N2 — Perrig et al. 2023]
4. **Plancher classique, différence expressive.** Toutes les variantes nettes, ordonnées, lisibles.
   Les 2 ou 3 variantes se distinguent par l'originalité : forme, typographie de titre, traitement de la
   couleur. [N2 — Lavie & Tractinsky 2004]
5. **Typique et une nouveauté (MAYA).** Garder la silhouette attendue de la catégorie d'application.
   Placer la surprise dans un ou deux éléments. Répartir les variantes de « proche de la catégorie » à
   « audacieuse mais reconnaissable ». [N2 — Hekkert et al. 2003 ; Thurgood et al.]
6. **Fluidité.** Alignement sur une grille, contraste figure-fond franc, répétition des mêmes composants,
   regroupement net. [N2 — Reber et al. 2004 ; N2 faible — Wang et al. 2026] Ranger un élément avant de
   le supprimer est une hypothèse de travail, pas un résultat. [N0, appuyé sur Marin et al. 2016]
7. **Arrondis : oui pour l'attrait, non comme argument de conversion.** Les formes douces plaisent au
   premier regard aux non-experts (g = 0,39 ; plus fort en exposition brève). L'effet est faible sur le
   design symbolique, et la promesse de clics n'a pas résisté à la réplication.
   [N2 — Chuquichambi et al. 2022 ; Kohavi et al. 2026, prépublication]
8. **Casser l'allure par défaut des générateurs.** Une variante qui ressemble à un gabarit
   shadcn/Tailwind (Inter, zinc, accent vif, cartes grises) échoue sur la nouveauté. Avant de dessiner,
   écrire la palette (dérivée de l'univers de l'application, cf. Palmer & Schloss 2010), la typographie de
   titre, le traitement de forme et l'élément signature de chaque variante. Vérifier ensuite hiérarchie,
   groupes, contraste et espacements. [N4 — NN/g 2025 ; N2 — Palmer & Schloss 2010]

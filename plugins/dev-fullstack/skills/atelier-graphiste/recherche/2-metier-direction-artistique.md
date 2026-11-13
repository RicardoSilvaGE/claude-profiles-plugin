# Axe 2 — Le métier : direction artistique et graphisme d'écrans d'app

> Recherche documentaire du **13.11.2026**, pour la fiche de l'agent `graphiste` (2 ou 3 variantes d'écrans de téléphone en HTML/CSS, app grand public).
> But : des écrans **beaux et désirables**, qui ressemblent à une vraie application et pas à un tableur amélioré.
> Échelle de preuve : celle du skill `ux-preuves` (N1 norme · N2 recherche revue · N3 guideline de plateforme ou d'institution · N4 praticien · N0 jugement déclaré).
> Toutes les pages citées ont été **lues le 13.11.2026**. Les citations sont rares, courtes et passées par un outil de résumé : elles valent paraphrase fidèle, pas texte exact au mot près.

## Ce qui n'est pas refait ici

Déjà couvert dans les fiches du skill `ux-preuves` (`references/`) (renvoyer, ne pas dupliquer) :
- **lisibilité, tailles, échelle M3, grille 8 pt, densité** → `design-typographie-mise-en-page.md` ;
- **première impression, complexité visuelle, hiérarchie par contraste, regroupement, photos décoratives, presque-plat, flou des yeux** → `design-perception-esthetique.md` ;
- **verre (Liquid Glass), chiffres de M3 Expressive, homogénéisation des sorties d'IA, `oklch()`, polices variables** → `design-front-recent.md`.

Ce fichier cherche ce qui manque à ces fiches : **l'excellence visuelle**, telle que la décrivent les jurys, les guides de plateforme, les manuels et les praticiens.

## Comment lire les niveaux ici

- Une **règle de métier** n'est notée N3 ou N4 que si **au moins deux familles de sources indépendantes** la portent. Ne comptent que pour une famille : les trois textes d'Anthropic (blog, cookbook, skill), les billets « 60-30-10 » qui se recopient, et les pages Apple (HIG, Awards, newsroom).
- Les **critères de jury** sont notés N3 au mieux. Ils disent ce qui est récompensé, pas comment le produire, et ils sont maigres (voir entrée 1). C'est en soi un constat.
- Transposer une règle d'imprimé ou de web vers un écran de téléphone est un **N0 déclaré**.

---

## A. Ce que les jurys récompensent

### 1. Donner à chaque variante un thème distinctif et cohérent, nommable en une phrase : c'est ce que les jurys qui définissent leurs critères récompensent

**Ce que disent les sources.**
- **Apple Design Awards.** La catégorie *Visuals and Graphics* récompense une imagerie remarquable, des interfaces « habilement dessinées », des animations de qualité, et surtout un **thème distinctif et cohérent**. Lauréat apps 2026 : *Tide Guide* ; finalistes : *Caradise* et *(Not Boring) Camera*.
- **Webby (Apps, Software & Immersive).** Dix critères, dont *Visual Design* et *Overall Experience*. Le premier est défini de façon circulaire, comme l'apparence de l'application. Le second se juge à ce que l'exécution vaut plus, ou moins, que la somme de ses parties.
- **Type Directors Club.** Les juges sélectionnent sur quatre critères : le métier, l'innovation, la pertinence et l'esthétique.
- **Awwwards.** Les sites sont pondérés : Design 40 %, Usability 30 %, Creativity 20 %, Content 10 %. Au moins 18 jurés notent ; les trois notes les plus éloignées de la moyenne sont retirées. **Aucun critère n'est défini.**

**Références.**
- Apple, *Apple Design Awards*, https://developer.apple.com/design/awards/ (lu 13.11.2026).
- Webby Awards, *Judging Criteria*, https://www.webbyawards.com/judging-criteria/ (lu 13.11.2026).
- Type Directors Club, *About the Competitions*, https://archive.tdc.org/about-the-competitions/ (lu 13.11.2026).
- Awwwards, *About evaluation*, https://www.awwwards.com/about-evaluation/ (lu 13.11.2026).

**Niveau.** N3 pour ce que les jurys déclarent récompenser. Sur quatre jurys, **deux seulement** parlent de cohérence d'ensemble : Apple (thème cohérent) et les Webby (plus que la somme des parties). Le TDC liste des critères sans les définir ; les Awwwards donnent des poids sans définition.

**Limites.**
- Aucune grille de notation publiée.
- Les Awwwards et les Webby jugent surtout des sites, pas des apps.
- « Distinctif » et « cohérent » ne se mesurent pas : le jury juge à l'œil, à plusieurs.

**Pour graphiste :** avant de dessiner, écrire pour chaque variante **une phrase de thème** tirée du domaine. Exemple : « carnet de cave en papier kraft et encre bordeaux ». Chaque choix (police, palette, forme, icône, fond) doit pouvoir se justifier par cette phrase. Une variante qui ne tient pas en une phrase n'a pas de thème.

### 2. Faire des données une image : une app de chiffres peut gagner sur le visuel si sa présentation des données est soignée

**Ce que disent les sources.**
- **Tide Guide: Charts & Tables** (marées et météo marine) est une app de **tableaux et de courbes**. Elle a remporté *Visuals and Graphics* aux Apple Design Awards 2026.
- Selon le communiqué d'Apple, ses graphiques sont remplis d'animations sur mesure, avec un thème aquatique et une palette qui suit la couleur du ciel au fil de la journée.
- Son auteur, Tucker MacDonald, présente l'app lors d'une session Apple. Il veut une interface qu'on sent tactile et fluide :
  - la vague principale de la marée reçoit un reflet quand on la fait glisser ;
  - les cartes de graphiques réagissent au toucher ;
  - les coins sont doux et concentriques ;
  - l'alignement à gauche et les espacements sont tenus partout.

**Références.**
- Apple Newsroom, *Apple reveals winners of the 2026 Apple Design Awards*, 02.06.2026, https://apple.com/ca/newsroom/2026/06/apple-reveals-winners-of-the-2026-apple-design-awards (lu 13.11.2026).
- Apple, *Meet with Apple — Liquid Glass showcase: Tide Guide*, https://developer.apple.com/videos/play/meet-with-apple/257 (lu 13.11.2026, d'après la transcription).

**Niveau.** N4 : un cas primé. C'est un contre-exemple direct au « tableur amélioré ».

**Limites.**
- Un seul cas.
- Une partie de l'effet tient à l'animation et au Liquid Glass, qu'une planche statique ne montre pas.

**Pour graphiste :** quand l'app manipule des données, **l'écran principal montre la donnée sous forme d'image**, et la liste vient ensuite. Formes possibles : une courbe, une jauge, un calendrier coloré, un chiffre-héros, une carte. La donnée-clé reçoit un traitement graphique propre au thème, le détail vient dessous.

---

## B. Composition

### 3. Un seul point focal par écran, obtenu autant en rétrogradant le reste qu'en grossissant l'élément principal

**Ce que disent les sources.**
- **Erik Kennedy, règle 5.** Chaque style de texte combine des leviers qui le font ressortir (taille, graisse, couleur) et d'autres qui le font reculer. Seul le titre de page est poussé à fond. Exemple : un grand chiffre en graisse légère et en couleur atténuée.
- **Apple HIG, Layout.** Placer les éléments les plus importants en haut, du côté où commence la lecture. Exprimer la subordination par l'alignement et le retrait.
- **Hiérarchie par contraste et par échelle.** Déjà couvert, voir `design-perception-esthetique.md` § « Construire la hiérarchie par le contraste… ».

**Références.**
- E. Kennedy, *7 Rules for Creating Gorgeous UI — Part 2* (mis à jour 15.06.2024), https://learnui.design/blog/7-rules-for-creating-gorgeous-ui-part-2.html (lu 13.11.2026).
- Apple, *HIG — Layout*, https://developer.apple.com/design/human-interface-guidelines/layout (lu 13.11.2026 via l'export JSON).

**Niveau.** N3 et N4, deux familles.

**Limites.**
- Aucune source ne chiffre « un seul » point focal : c'est une règle d'atelier.
- *Refactoring UI* a un chapitre intitulé « De-emphasize to emphasize », mais il n'a pas été lu (voir « Repéré, non lu »).

**Pour graphiste :** sur chaque écran, désigner **l'élément héros**, puis rétrograder tout le reste. Moyens : gris plus clairs, graisse moindre, taille plus petite, moins de couleur. Si deux éléments se disputent le regard, en baisser un. Ne jamais tout grossir.

### 4. Des écarts d'échelle francs à l'écran : des tailles trop voisines paraissent hésitantes, sauf dans un document à lire

**Ce que disent les sources.**
- **Anthropic** recommande des sauts de taille de l'ordre de **3× ou plus** plutôt que 1,5×, et des graisses opposées. Sans consigne, un modèle produit des tailles et des graisses voisines, donc une page plate.
- **Erik Kennedy** illustre la même idée par un très grand chiffre accompagné d'un petit libellé.
- **Matthew Butterick** dit l'inverse pour la typographie de documents : un titre ne grossit que du plus petit écart visible (de 12 à 12,5 ou 13 pt), et l'espace autour du titre sert à le mettre en valeur.

**Références.**
- Anthropic, *Improving frontend design through skills*, https://claude.com/blog/improving-frontend-design-through-skills (lu 13.11.2026).
- Anthropic, *Prompting for frontend aesthetics* (cookbook, 21.10.2025), https://platform.claude.com/cookbook/coding-prompting-for-frontend-aesthetics (lu 13.11.2026).
- E. Kennedy, *7 Rules for Creating Gorgeous UI — Part 2*, 15.06.2024, https://learnui.design/blog/7-rules-for-creating-gorgeous-ui-part-2.html (lu 13.11.2026).
- M. Butterick, *Practical Typography — Headings*, https://practicaltypography.com/headings.html (lu 13.11.2026).

**Niveau.** N4 (une seule famille, Anthropic, pour le saut d'échelle chiffré) et N0 pour la transposition. L'exemple de Kennedy illustre le contraste, il ne chiffre rien. L'opposition de Butterick vaut pour des pages à lire, pas pour un écran-vitrine.

**Limites.**
- Le « 3× » d'Anthropic est une consigne donnée à un modèle, pas une mesure.
- Lupton tient le même propos dans *Thinking with Type* : des différences de taille minimes rendent une composition hésitante. Le passage n'a été vu que dans un extrait de recherche, il n'a pas été lu.

**Pour graphiste :**
- **Écran-vitrine** (accueil, synthèse, fiche) : l'élément héros mesure au moins **2,5 à 3 fois** le corps. Exemple : un chiffre de 56 à 72 px pour un corps de 16 à 17 px.
- **Écran de lecture** (article, réglages, longue liste) : écarts modestes, et l'espace sert à hiérarchiser.
- Toujours **peu de tailles, mais éloignées**.

### 5. Une grille donne l'ordre ; un module dominant donne la tension : moins de formats différents, c'est plus calme, et un seul écart volontaire crée le rythme

**Ce que disent les sources.**
- **Josef Müller-Brockmann.** La grille divise la surface en champs et réduit le nombre de formats visuels. Elle rend l'information plus claire et plus crédible, et chaque projet appelle sa propre grille. Disposer les éléments sur une grille donne à la page son rythme et une forte tension. Moins de différences de taille entre les illustrations donne une composition plus calme.
- **Apple HIG.** Tenir un espacement régulier dans les grilles, car un espacement irrégulier gêne le balayage.
- **Anthropic, skill `frontend-design`.** Partir d'un concept de mise en page, comparer des esquisses, et donner au design **un seul élément mémorable**, le reste restant retenu.

**Références.**
- J. Müller-Brockmann, *Grid and Design Philosophy* (texte de *Grid Systems in Graphic Design*), https://neugraphic.com/muller-brockmann/muller-brockmann-text2.html (lu 13.11.2026).
- Apple, *HIG — Layout*, https://developer.apple.com/design/human-interface-guidelines/layout (lu 13.11.2026 via l'export JSON).
- Anthropic, *frontend-design SKILL.md*, https://raw.githubusercontent.com/anthropics/skills/main/skills/frontend-design/SKILL.md (lu 13.11.2026).

**Niveau.** N4 pour la grille et l'élément mémorable unique, trois familles : l'école suisse, Apple et Anthropic. **N0** pour la consigne « un module qui rompt la grille », qui est ma synthèse.

**Limites.**
- Müller-Brockmann pensait l'affiche et le livre.
- Passer à un écran de 390 px à une colonne est un N0.

**Pour graphiste :** une colonne avec des marges latérales fixes (16 ou 20 px) et des espacements pris dans la grille de 4 px. Puis **un seul module qui rompt** : une carte pleine largeur à fond coloré, une image à fond perdu, ou un chiffre géant. Une pile de modules tous identiques n'a ni tension ni point d'entrée.

### 6. Donner beaucoup d'air : un écran serré se lit comme un formulaire

**Ce que disent les sources.**
- **Erik Kennedy, règle 3.** Partir de l'espace comme valeur par défaut et ajouter les éléments un à un. Dans son exemple de lecteur de musique, l'écart entre les entrées de menu vaut environ deux fois la hauteur du texte.
- **Effet des marges sur la compréhension et le confort.** Déjà couvert dans `design-typographie-mise-en-page.md` § « Des marges autour du texte… » et `design-perception-esthetique.md` § « Une mise en page « soignée »… ».

**Références.** E. Kennedy, *7 Rules for Creating Gorgeous UI — Part 1* (mis à jour 15.06.2024), https://learnui.design/blog/7-rules-for-creating-gorgeous-ui-part-1.html (lu 13.11.2026).

**Niveau.** N4 pour la règle esthétique, une famille. Pour la preuve sur la compréhension et le confort, voir les fiches citées et leur propre niveau.

**Limites.**
- Un outil métier dense tolère moins d'air.
- Pour une app grand public, la respiration est la norme de la catégorie : c'est un jugement de convention (N0).

**Pour graphiste :**
- La zone héros reçoit **au moins 24 à 32 px** d'air autour d'elle.
- Les groupes sont séparés par 24 px ou plus ; à l'intérieur d'un groupe, 8 à 12 px.
- Si l'écran semble plein, **retirer** un élément plutôt que de réduire les espaces.

---

## C. Typographie

### 7. Une police d'affichage qui a du caractère pour les titres, une police neutre pour le texte

**Ce que disent les sources.**
- **Apple HIG, Branding (révisé le 09.09.2026).** Une police personnalisée est envisageable. L'approche courante : police de marque pour les titres et sous-titres, police système pour le corps et les légendes. Elle doit rester lisible et suivre Dynamic Type et Bold Text.
- **Linear** a ajouté *Inter Display* pour les titres, afin de gagner en expression sans perdre en lisibilité, et garde *Inter* partout ailleurs.
- **Erik Kennedy** conseille des polices neutres et propres pour l'UI courante, et réserve les polices marquées aux marques à forte personnalité.
- **Anthropic** :
  - écarter les polices par défaut (Inter, Roboto, Arial, polices système), qu'un modèle choisit d'office ;
  - choisir une police distinctive et l'assumer.
- **Butterick** déconseille les polices système et la plupart des polices gratuites, pour des documents.

**Références.**
- Apple, *HIG — Branding*, https://developer.apple.com/design/human-interface-guidelines/branding (lu 13.11.2026 via l'export JSON).
- K. Saarinen et al., *How we redesigned the Linear UI (part II)*, 28.03.2024, https://linear.app/now/how-we-redesigned-the-linear-ui (lu 13.11.2026).
- E. Kennedy, *7 Rules for Creating Gorgeous UI — Part 2*, 15.06.2024, https://learnui.design/blog/7-rules-for-creating-gorgeous-ui-part-2.html (lu 13.11.2026).
- Anthropic, *Improving frontend design through skills*, https://claude.com/blog/improving-frontend-design-through-skills, et *Prompting for frontend aesthetics*, 21.10.2025, https://platform.claude.com/cookbook/coding-prompting-for-frontend-aesthetics (lus 13.11.2026).
- M. Butterick, *Summary of key rules*, https://practicaltypography.com/summary-of-key-rules.html (lu 13.11.2026).

**Niveau.** N3 et N4, quatre familles. Le **désaccord apparent** (Kennedy : neutre ; Anthropic : distinctive) se règle par la répartition que proposent Apple et Linear : **le caractère va aux titres, la neutralité au texte**.

**Limites.**
- Chaque police ajoutée coûte au chargement (voir `design-typographie-mise-en-page.md`).
- Une police d'affichage mal choisie nuit à la lisibilité en petit.

**Pour graphiste :**
- Choisir la police de titre **d'après le thème** (entrée 1) : une serif éditoriale pour un carnet, une grotesque large pour le sport, une ronde pour un public familial.
- Garder une sans neutre pour le texte, la police système étant acceptable.
- Écrire dans la planche le nom de chaque police et la raison de son choix.

### 8. Deux familles au plus, chacune avec un rôle fixe

**Ce que disent les sources.**
- **Apple HIG, Typography.** Limiter le nombre de polices, même dans une interface très personnalisée ; trop de polices brouillent la hiérarchie.
- **Butterick, Mixing fonts.** Une seconde police passe, une troisième rarement. Chaque police doit garder un rôle constant (titres contre texte, contenu central contre périphérique). Des polices du même dessinateur s'accordent volontiers.
- **Anthropic, skill.** Une famille, ou deux nettement distinctes.

**Références.**
- Apple, *HIG — Typography*, https://developer.apple.com/design/human-interface-guidelines/typography (lu 13.11.2026 via l'export JSON).
- M. Butterick, *Mixing fonts*, https://practicaltypography.com/mixing-fonts.html (lu 13.11.2026).
- Anthropic, *frontend-design SKILL.md*, https://raw.githubusercontent.com/anthropics/skills/main/skills/frontend-design/SKILL.md (lu 13.11.2026).

**Niveau.** N3 et N4, trois familles.

**Limites.**
- Butterick juge qu'un contraste faible entre deux polices marche souvent mieux qu'un contraste fort. Anthropic recommande l'inverse.
- Ce point n'est pas tranché. L'avis de Butterick vise des documents.

**Pour graphiste :**
- Deux familles au plus, plus une monospace seulement si le domaine l'exige (code, horaires).
- Si les deux polices diffèrent, qu'elles diffèrent **franchement** (serif d'affichage contre sans de texte), pas de deux sans presque jumelles.

### 9. Opposer les graisses en grand ; aucune graisse fine en petit

**Ce que disent les sources.**
- **Anthropic** recommande des graisses extrêmes (100 à 200 contre 800 à 900) plutôt que 400 contre 600.
- **Apple HIG** déconseille en général les graisses Ultralight, Thin et Light, peu visibles en petit. Elle préfère Regular à Bold. Une graisse fine n'est acceptable qu'**au-dessus** des tailles recommandées.
- **Erik Kennedy** veut des graisses plus lourdes pour les titres et un léger approche négatif sur les grands titres. Il note qu'une graisse très fine se lit mal dans certaines humanes.

**Références.**
- Anthropic, *Prompting for frontend aesthetics*, 21.10.2025, https://platform.claude.com/cookbook/coding-prompting-for-frontend-aesthetics (lu 13.11.2026).
- Apple, *HIG — Typography*, https://developer.apple.com/design/human-interface-guidelines/typography (lu 13.11.2026 via l'export JSON, premiers 100 000 caractères seulement).
- E. Kennedy, *7 Rules for Creating Gorgeous UI — Part 2*, 15.06.2024, https://learnui.design/blog/7-rules-for-creating-gorgeous-ui-part-2.html (lu 13.11.2026).

**Niveau.** N3 et N4. **Conflit à signaler** : Anthropic contre Apple. Il se résout par la taille : graisses extrêmes **seulement en affichage**.

**Limites.** Aucune donnée de lisibilité n'accompagne le conseil d'Anthropic.

**Pour graphiste :**
- Titres et chiffres-héros : graisses franches (700 à 900), ou une fine très grande (au moins 40 px) pour un effet élégant.
- Texte et libellés : 400 à 600, jamais en dessous de 400 sous 20 px.
- Grands titres : approche légèrement négatif (de −0,01 à −0,02 em).

### 10. Traiter la donnée-clé comme un objet typographique

**Ce que disent les sources.**
- **Erik Kennedy** donne en exemple un grand chiffre en graisse légère et en couleur atténuée, à côté de son libellé.
- **Apple HIG.** Les styles de texte ont des variantes accentuées (jusqu'à Heavy). Le Large Title iOS fait 34 pt par défaut.
- **Not Boring Weather** est présenté par Apple comme une app aux prévisions « spectaculaires » et à l'esthétique reconnaissable d'emblée.

**Références.**
- E. Kennedy, *7 Rules for Creating Gorgeous UI — Part 2*, 15.06.2024, https://learnui.design/blog/7-rules-for-creating-gorgeous-ui-part-2.html (lu 13.11.2026).
- Apple, *HIG — Typography*, https://developer.apple.com/design/human-interface-guidelines/typography (lu 13.11.2026 via l'export JSON, en partie).
- Apple App Store, *Developer Spotlight — (Not Boring)*, https://apps.apple.com/us/story/id1591100111 (lu 13.11.2026, non daté).

**Niveau.** N4 et N0. La règle elle-même est une synthèse déclarée.

**Limites.** Les sources montrent des exemples ; aucune n'énonce la règle.

**Pour graphiste :**
- Le chiffre qui compte (solde, température, nombre de bouteilles, jours restants) devient le **héros de l'écran**.
- Il est très grand, dans la police d'affichage, avec son unité en petit et en couleur atténuée.
- Il ne reste jamais dans une cellule de liste.

---

## D. Couleur

### 11. Des proportions franchement inégales : une couleur dominante, un accent rare ; jamais des couleurs réparties à parts égales

**Ce que disent les sources.**
- **NN/g (Kelley Gordon).**
  - Limiter la palette à environ trois couleurs.
  - Les répartir à environ 60 % (dominante), 30 % (secondaire) et 10 % (accent).
  - Dominante et secondaire plutôt neutres ; l'accent réservé aux actions principales, constant d'un écran à l'autre.
  - La règle vient de l'architecture d'intérieur.
- **Apple HIG.** Utiliser la couleur d'accent avec discernement, pour l'action principale ou un état. Une couleur de marque trop étendue écrase l'interface et perd son effet.
- **Anthropic.** Des couleurs dominantes avec des accents vifs valent mieux que des palettes timides réparties également.

**Références.**
- K. Gordon, *Using Color to Enhance Your Design*, NN/g, 06.06.2021, https://www.nngroup.com/articles/color-enhance-design/ (lu 13.11.2026).
- Apple, *HIG — Branding*, https://developer.apple.com/design/human-interface-guidelines/branding, et *HIG — Color*, https://developer.apple.com/design/human-interface-guidelines/color (lus 13.11.2026 via l'export JSON ; Color en partie).
- Anthropic, *Improving frontend design through skills*, https://claude.com/blog/improving-frontend-design-through-skills (lu 13.11.2026).

**Niveau.** N3 et N4, trois familles. Elles s'accordent sur l'**inégalité des proportions**. Elles divergent sur la dominante : neutre pour NN/g et Apple, colorée pour Anthropic.

**Limites.**
- Le 60-30-10 est une heuristique sans étude.
- Les billets qui le reprennent se recopient entre eux.

**Pour graphiste :**
- Dans chaque variante, décider la dominante (neutre teinté, ou couleur du thème) et un seul accent sur environ 10 % de la surface, réservé à l'action principale et aux états.
- Une variante peut prendre une dominante colorée, par exemple un fond de la couleur du thème : c'est le levier le plus fort contre l'effet « tableur blanc ».

### 12. Tirer la palette d'une couleur source prise dans le domaine, puis la juger sur l'écran rendu

**Ce que disent les sources.**
- **Material / Android, couleur dynamique.**
  - Le système extrait d'une image une **couleur source**.
  - Il en déduit cinq couleurs clés (primaire, secondaire, tertiaire, neutre, variante de neutre), puis une palette de 13 tons pour chacune, et répartit ces tons sur les rôles d'interface.
  - Les couleurs de marque peuvent être conservées, et « harmonisées » vers la palette.
- **Tide Guide** prend sa palette dans l'eau et dans le ciel du moment.
- **Anthropic, skill.** Tirer la direction visuelle du secteur, de ses matériaux et de son vernaculaire, pour que le design appartienne à son monde.
- **Josef Albers.** La couleur n'est presque jamais vue telle qu'elle est physiquement, ce qui en fait le médium le plus relatif. Il faut l'apprendre par l'observation en contexte, pas par le cercle chromatique.

**Références.**
- Android Developers, *Dynamic colors*, https://developer.android.com/develop/ui/views/theming/dynamic-colors (lu 13.11.2026).
- Apple Newsroom, *Winners of the 2026 Apple Design Awards*, 02.06.2026, https://apple.com/ca/newsroom/2026/06/apple-reveals-winners-of-the-2026-apple-design-awards (lu 13.11.2026).
- Anthropic, *frontend-design SKILL.md*, https://raw.githubusercontent.com/anthropics/skills/main/skills/frontend-design/SKILL.md (lu 13.11.2026).
- Josef & Anni Albers Foundation, *Interaction of Color*, https://www.albersfoundation.org/alberses/teaching/interaction-of-color (lu 13.11.2026).

**Niveau.** N3 pour le mécanisme Material, N4 pour le reste. Quatre familles.

**Limites.** Material extrait la couleur d'un fond d'écran, pas d'un objet du domaine. Transposer le procédé est un N0.

**Pour graphiste :**
- Nommer l'**objet source** de chaque variante (étiquette de vin, bois de cave, eau de lagon, cuir de carnet) et en tirer **une teinte source**.
- Dériver une rampe de tons et lui assigner des rôles : fond, surface, texte, accent.
- **Juger sur la capture rendue**, jamais sur des pastilles isolées : une couleur change selon ses voisines.

### 13. Construire des rampes de teintes définies à l'avance ; neutres à peine teintés, au plus

**Ce que disent les sources.**
- **Refactoring UI** (aperçu gratuit) :
  - 8 à 10 gris ;
  - une ou deux couleurs primaires de 5 à 10 nuances chacune ;
  - des couleurs d'accent pour les états ;
  - environ neuf paliers (100 à 900), le 500 servant de fond de bouton ;
  - les nuances se définissent d'avance, pas à la volée.
- **Linear.** Thèmes générés en LCH, espace où des couleurs de même luminosité paraissent aussi claires. Trois variables suffisent : base, accent, contraste. L'influence de l'accent sur les neutres a été réduite pour un rendu plus intemporel.
- **Material.** 13 tons par palette tonale (entrée 12).

**Références.**
- A. Wathan & S. Schoger, *Refactoring UI — Building your color palette*, https://www.refactoringui.com/previews/building-your-color-palette (lu 13.11.2026).
- K. Saarinen et al., *How we redesigned the Linear UI (part II)*, 28.03.2024, https://linear.app/now/how-we-redesigned-the-linear-ui (lu 13.11.2026).
- Android Developers, *Dynamic colors*, https://developer.android.com/develop/ui/views/theming/dynamic-colors (lu 13.11.2026).
- Couleurs `oklch()` : voir `design-front-recent.md`.

**Niveau.** N3 et N4, trois familles, pour les rampes définies à l'avance. **N0** pour la teinte des neutres.

**Limites.**
- Refactoring UI a un chapitre « Greys don't have to be grey », mais il n'a pas été lu.
- Le seul cas lu sur les neutres, Linear, a **réduit** leur teinte. La consigne ci-dessous reste donc une synthèse prudente, pas une règle sourcée.

**Pour graphiste :**
- Écrire la palette en variables `oklch()` : une rampe de la couleur source (9 paliers) et une rampe de neutres légèrement teintés vers la source.
- Utiliser l'accent seul.
- Ne jamais improviser une couleur hors rampe dans un écran.

### 14. Mettre la couleur de marque dans le contenu, pas sur chaque contrôle

**Ce que disent les sources.** Apple HIG, *Branding* (révisé le 09.09.2026) :
- pour exprimer la marque par la couleur, la placer dans la **couche de contenu**, qui défile sous les contrôles ;
- l'exemple « couleur de marque sur tous les contrôles » est marqué comme incorrect ;
- la marque s'efface devant le contenu, et le logo n'apparaît pas partout.

*HIG — Color* ajoute de ne pas donner le même sens à deux couleurs.

**Références.**
- Apple, *HIG — Branding*, https://developer.apple.com/design/human-interface-guidelines/branding (lu 13.11.2026 via l'export JSON).
- Apple, *HIG — Color*, https://developer.apple.com/design/human-interface-guidelines/color (lu 13.11.2026 via l'export JSON, premiers 100 000 caractères seulement).

**Niveau.** N3, une seule famille. Cohérent avec l'entrée 11.

**Limites.** C'est la convention iOS 26 et Liquid Glass. La position de Material sur ce point n'a pas été lue.

**Pour graphiste :**
- Peindre la couleur du thème sur les **grandes surfaces de contenu** : bandeau héros, carte vedette, illustration, fond de section.
- Garder les contrôles sobres : barre d'onglets, boutons secondaires, champs.
- Pas de logo répété dans les écrans.

### 15. Ne pas choisir la couleur avant la structure : composer en niveaux de gris, puis ajouter la couleur avec une intention

**Ce que disent les sources.**
- **Erik Kennedy, règle 2.** Composer d'abord en noir et blanc pour régler espace, tailles et mise en page. Ajouter la couleur en dernier, en commençant par un seul accent. Élargir ensuite par des nuances d'une même teinte plutôt que par des couleurs sans lien.
- **Albers.** Voir la couleur en situation (entrée 12).
- **Structure avant couleur.** Déjà couvert dans `design-perception-esthetique.md` § « Traiter la complexité visuelle avant la couleur ».

**Références.**
- E. Kennedy, *7 Rules for Creating Gorgeous UI — Part 1*, 15.06.2024, https://learnui.design/blog/7-rules-for-creating-gorgeous-ui-part-1.html (lu 13.11.2026).
- Josef & Anni Albers Foundation, *Interaction of Color*, https://www.albersfoundation.org/alberses/teaching/interaction-of-color (lu 13.11.2026).

**Niveau.** N4 pour la méthode, deux familles. La fiche existante (§ « Traiter la complexité visuelle avant la couleur ») porte un N2 sur le poids de la complexité dans la première impression.

**Limites.** C'est une méthode d'atelier. Pour un agent qui rend directement en HTML, elle vaut surtout en contrôle (entrée « grille »).

**Pour graphiste :** contrôle de la planche passée en niveaux de gris (`filter: grayscale(1)`). La hiérarchie doit tenir **sans la couleur**. Si elle s'effondre, la couleur cachait une structure faible.

---

## E. Matière, illustration, iconographie

### 16. Un seul langage de formes pour toute l'imagerie : même trait, même niveau de détail, même perspective, mêmes rayons

**Ce que disent les sources.**
- **Duolingo, *Shape language*.**
  - Des formes minimales et reconnaissables, avec le moins de détails possible pour se faire comprendre.
  - Le passage de formes anguleuses et de tons sourds à des formes rondes et des couleurs vives.
  - Un style défini qui permet à une petite équipe de produire beaucoup sans perdre en qualité.
  - L'exagération et l'humour pour la personnalité.
- **Apple HIG, Icons.**
  - Toutes les icônes d'une app partagent la même taille, le même niveau de détail, la même épaisseur de trait et la même perspective, qu'elles soient sur mesure ou système.
  - Le trait des icônes s'accorde à la graisse du texte voisin.
  - Les icônes asymétriques se centrent optiquement, pas géométriquement.

**Références.**
- M. Barker, *Shape language: Duolingo's art style*, 02.07.2020, https://blog.duolingo.com/shape-language-duolingos-art-style/ (lu 13.11.2026).
- Apple, *HIG — Icons*, https://developer.apple.com/design/human-interface-guidelines/icons (lu 13.11.2026 via l'export JSON).

**Niveau.** N3 et N4, deux familles.

**Limites.**
- La règle précise de Duolingo (coins arrondis obligatoires, ombres en pilule) est dans son guide de marque. Ce guide n'a été vu qu'en extrait de recherche ; la page `design.duolingo.com` redirige.

**Pour graphiste :**
- Fixer par variante **un rayon** (exemple : 20 px pour les cartes, 12 px pour les puces), **une épaisseur de trait d'icône** (exemple : 1,75 px), et un style d'illustration.
- Ne mélanger ni icônes pleines et filaires, ni coins vifs et ronds.
- Les icônes viennent de Lucide (règle du profil) avec un trait réglé de façon homogène.

### 17. Une illustration ou un objet du domaine dessiné, propre à l'app, est le différenciateur le plus visible

**Ce que disent les sources.**
- **Bears Gratitude** (Delight and Fun, Apple Design Awards 2024). Le dessin à la main de l'illustratrice est venu **avant** l'app, qui a été construite autour. Les ours mascottes servent à se distinguer dans une catégorie encombrée (le journal intime) et à garder une ancre visuelle constante.
- **Airbnb, refonte de mai 2025.** Une équipe interne a fait design, UI, 3D et illustrations. De nouvelles icônes, construites sur deux ans, forment un langage visuel ludique, avec assez de détails pour récompenser un regard attentif. Le but déclaré est une identité « fun, vivante et simple ».
- **Not Boring.** Chaque app de la suite a une esthétique reconnaissable d'emblée. L'équipe dit concourir sur le design plutôt que sur les fonctions, parce que le design se copie mal.

**Références.**
- Apple Developer, *The good news bears: Inside the adorably unorthodox design of Bears Gratitude*, 04.02.2025, https://developer.apple.com/news/?id=i74v3f4r (lu 13.11.2026).
- It's Nice That, *From homes to haircuts: Airbnb's new app is designed to do it all*, 14.05.2025, https://www.itsnicethat.com/articles/airbnb-app-redesign-140525 (lu 13.11.2026).
- Apple App Store, *Developer Spotlight — (Not Boring)*, https://apps.apple.com/us/story/id1591100111 (lu 13.11.2026, non daté).

**Niveau.** N4 : trois cas primés ou reconnus, deux familles (Apple pour Bears Gratitude et Not Boring, It's Nice That pour Airbnb).

**Limites.**
- Une illustration coûte à produire.
- Des commentateurs signalent une vague d'icônes 3D « dimensionnelles » générées par IA après Airbnb, et une critique y voit de la décoration plutôt qu'un skeuomorphisme utile. Les deux n'ont été vus qu'en extrait de recherche (« Repéré, non lu »). Le risque de cliché est plausible mais non sourcé ici.
- Une photo décorative est ignorée : voir `design-perception-esthetique.md`.

**Pour graphiste :**
- Chaque variante comporte **au moins un objet du domaine dessiné** en SVG dans le style de la variante (bouteille, verre, plante, vague, ballon). Il est placé en héros ou dans l'état vide.
- Il porte du sens, par exemple le niveau de remplissage d'une bouteille qui montre le stock.
- Il ne doit pas être générique : pas de pictogramme Lucide agrandi en guise d'illustration.

### 18. Du relief léger plutôt que le tout-plat ou le skeuomorphisme lourd : la lumière vient d'en haut

**Ce que disent les sources.**
- **Erik Kennedy, règle 1.**
  - Le dessus d'un élément est plus clair, le dessous porte une ombre discrète.
  - Ce qui est en creux (champ, curseur, case) et ce qui est en relief (bouton, carte, menu) se lisent ainsi.
  - Il défend un juste milieu entre skeuomorphisme et plat ; les surfaces plus hautes peuvent être légèrement plus claires.
- **Signifiants sur le cliquable, « presque plat ».** Déjà couvert dans `design-perception-esthetique.md`.

**Références.** E. Kennedy, *7 Rules for Creating Gorgeous UI — Part 1*, 15.06.2024, https://learnui.design/blog/7-rules-for-creating-gorgeous-ui-part-1.html (lu 13.11.2026).

**Niveau.** N4, une famille. Pour le « presque plat » et les signifiants, voir la fiche existante et son propre niveau.

**Limites.** Les règles de design du profil demandent des ombres douces ou absentes. Il n'y a pas de conflit, à condition de rester discret.

**Pour graphiste :**
- Cartes et boutons principaux : une ombre douce et basse, à deux couches (exemple : `0 1px 2px` plus `0 8px 24px` à faible opacité), ou un léger dégradé de surface de haut en bas.
- Champs : un léger creux.
- Jamais d'ombre dure ni de verre décoratif.

### 19. La matière se perçoit aussi au toucher et au son ; sur une planche statique, la suggérer par les états

**Ce que disent les sources.**
- **Not Boring.** Des sons vifs au toucher. Les jeux vidéo comme première inspiration : l'expérience compte plus que la liste de fonctions.
- **Andy Allen** a imprimé en 3D l'interface de son appareil photo pour en éprouver l'ergonomie en main.
- **Tide Guide.** Des retours haptiques et un reflet quand on fait glisser une valeur (entrée 2).

**Références.**
- Apple App Store, *Developer Spotlight — (Not Boring)*, https://apps.apple.com/us/story/id1591100111 (lu 13.11.2026, non daté).
- Apple, *Meet with Apple 257 — Tide Guide*, https://developer.apple.com/videos/play/meet-with-apple/257 (lu 13.11.2026).
- T. Geoco, *Monitor stands have more personality than software*, UX Tools, https://www.uxtools.co/blog/monitor-stands-have-more-personality-than-software (lu 13.11.2026 ; date ambiguë, 03.03.2026 ou 09.11.2026).

**Niveau.** N4.

**Limites.** Hors de portée d'une capture fixe. La seule animation sobre recommandée (une entrée orchestrée) relève du prototype.

**Pour graphiste :** une ligne seulement dans la planche. Montrer **un état pressé ou sélectionné** soigné par variante (une puce active, une carte enfoncée) et noter en légende l'intention tactile, sonore ou de mouvement. Rien de plus.

---

## F. Personnalité de marque

### 20. Choisir une personnalité et la décliner partout, voix comprise ; la marque sert le contenu, elle ne le recouvre pas

**Ce que disent les sources.**
- **Apple HIG, Branding** :
  - employer la voix et le ton de la marque dans tous les textes ;
  - exprimer la marque **à travers des composants familiers**, dont on garde la taille, la place et le comportement ;
  - la marque s'efface devant le contenu ;
  - résister à l'envie de mettre le logo partout ;
  - pas d'écran de lancement de marque.
- **Bears Gratitude.** Le ton des invites est joueur, écrit dans la voix de l'utilisateur.
- **Duolingo.** Personnalité joueuse portée par la forme et l'humour.
- **Anthropic, skill.** Tirer le ton du sujet.
- **Refactoring UI** ouvre sur « Choose a personality ». Le chapitre n'a pas été lu.

**Références.**
- Apple, *HIG — Branding*, https://developer.apple.com/design/human-interface-guidelines/branding (lu 13.11.2026 via l'export JSON).
- Apple Developer, *Bears Gratitude*, 04.02.2025, https://developer.apple.com/news/?id=i74v3f4r (lu 13.11.2026).
- M. Barker, *Shape language: Duolingo's art style*, 02.07.2020, https://blog.duolingo.com/shape-language-duolingos-art-style/ (lu 13.11.2026).
- Anthropic, *frontend-design SKILL.md*, https://raw.githubusercontent.com/anthropics/skills/main/skills/frontend-design/SKILL.md (lu 13.11.2026).
- Google Design, *Expressive design: Google's UX research*, https://design.google/library/expressive-material-design-google-research (lu 13.11.2026).

**Niveau.** N3 et N4, trois familles (Apple, Duolingo, Anthropic), plus Google pour la limite.

**Limites.** Google rapporte qu'une refonte « expressive » qui remplaçait une liste de titres par des pochettes éparpillées paraissait moderne mais faisait baisser l'utilisabilité. Il ajoute qu'aucune expressivité ne compense une fonction peu claire. Ses chiffres sont discutés dans `design-front-recent.md` § « L'expressivité qui casse un motif d'interaction familier… ».

**Pour graphiste :**
- Associer à la phrase de thème (entrée 1) **trois adjectifs de personnalité**. Exemple : chaleureux, artisanal, précis.
- Vérifier que police, forme, couleur, illustration et microcopy les portent tous.
- Garder les composants à leur place : barre d'onglets en bas, bouton principal reconnaissable.

---

## G. Échapper au générique

### 21. Une liste d'interdits ne suffit pas, elle déplace le défaut ; seule une direction tirée du sujet en sort

**Ce que disent les sources.**
- **Anthropic, en deux temps.**
  - En 2025, Anthropic décrit la « convergence distributionnelle » : sans consigne, un modèle produit Inter, des dégradés violets sur fond blanc, des palettes timides, des mises en page prévisibles. Pour en sortir, il recommande alors des fonds en **dégradés superposés**.
  - La version actuelle de son skill `frontend-design` (non datée, lue le 13.11.2026) classe parmi les clichés les « lavis de dégradé » et des palettes devenues à leur tour des défauts : crème et terre cuite, ou quasi-noir avec un seul accent acide. Il y ajoute les surtitres en capitales espacées.
  - Le cookbook observe qu'un modèle retombe d'une génération à l'autre sur la même police de remplacement (Space Grotesk).
- **prg.sh** relie le violet par défaut à l'indigo des exemples Tailwind UI, recopiés massivement puis appris par les modèles.
- **Eye on Design (2016).** Le constat est plus ancien que l'IA : les startups ont convergé vers un vernaculaire de quelques couleurs, de formes géométriques et de sans rondes, parce que c'est la mode et que c'est facile à exécuter.

**Références.**
- Anthropic, *Improving frontend design through skills*, https://claude.com/blog/improving-frontend-design-through-skills ; *Prompting for frontend aesthetics*, 21.10.2025, https://platform.claude.com/cookbook/coding-prompting-for-frontend-aesthetics ; *frontend-design SKILL.md*, https://raw.githubusercontent.com/anthropics/skills/main/skills/frontend-design/SKILL.md (lus 13.11.2026).
- *Why Your AI Keeps Building the Same Purple Gradient Website*, prg.sh, 26.10.2025, https://prg.sh/ramblings/Why-Your-AI-Keeps-Building-the-Same-Purple-Gradient-Website (lu 13.11.2026).
- E. Gosling, *Why app design has become homogenous*, AIGA Eye on Design, 03.08.2016, https://eyeondesign.aiga.org/why-app-design-has-become-homogenous-and-how-we-can-fix-it/ (lu 13.11.2026).
- Mesures sur l'homogénéisation : voir `design-front-recent.md`.

**Niveau.** N4, trois familles. La fiche existante porte des mesures N2 sur l'homogénéisation des sorties d'IA (§ « L'IA générative augmente la qualité individuelle… »).

**Limites.** Les listes d'Anthropic décrivent les défauts **de ses propres modèles** à une date donnée. Elles se périment.

**Pour graphiste :**
- Ne pas partir de la liste d'interdits : partir du **sujet** (entrées 1, 12, 17).
- Passer la liste « Signes du générique » **après coup**, en contrôle.
- Si deux variantes partagent la même police, la même palette ou la même composition, en refaire une.

---

## Signes du générique (ce qui trahit un template ou une IA)

Repérables sur une capture. Sources : Anthropic (blog, cookbook, skill), prg.sh, Eye on Design ; synthèse N0 pour le classement.

**Typographie**
- Une seule sans par défaut partout : Inter, Roboto, police système, ou leur remplaçant habituel Space Grotesk.
- Aucune police d'affichage.
- Des tailles voisines (16, 18, 20) et des graisses voisines (400 contre 600) : rien ne domine.
- Surtitres en petites capitales espacées au-dessus de chaque titre.
- Un mot du titre mis en italique ou en couleur pour faire « designé ».

**Couleur**
- Accent violet ou indigo sur fond blanc ou gris très clair.
- Dégradé violet-rose.
- Ou les nouveaux défauts : crème et terre cuite, quasi-noir avec un accent vert acide.
- Couleurs réparties à parts égales ; aucune dominante.

**Composition**
- Pile de cartes ou de rangées **toutes identiques** (même rayon, même ombre, même hauteur) : c'est l'effet tableur.
- Trois tuiles icône + titre + texte côte à côte.
- Héros centré, titre et bouton, sans image.
- Aucun élément qui rompt la grille.
- Sur mobile, des rangées « libellé à gauche, valeur à droite » sur tout l'écran sans objet visuel : le tableur amélioré (N0, d'après le rejet de l'utilisateur).

**Imagerie**
- Aucune illustration ni objet du domaine.
- Pictogrammes génériques agrandis en guise d'image.
- Photos d'ambiance de banque d'images.
- Icônes 3D « dimensionnelles » de série (signalé en extrait, non lu : N0).

**Détails**
- Coins arrondis uniformes partout.
- Ombres faibles et identiques sur tout.
- Flèches ajoutées à chaque lien.
- Numéros sur des blocs qui ne forment pas une séquence.
- Fondus-glissés sur chaque section.

**Test décisif (N0)**
- Remplacer le nom de l'app et ses données par ceux d'une autre catégorie.
- Si l'écran reste plausible, c'est un template.

---

## Grille de critique de directeur artistique (à appliquer à sa planche rendue en image)

Synthèse **N0**, chaque question renvoie aux entrées ci-dessus. Chacune se répond **sur la capture**, avec un critère observable et un geste en cas d'échec.

| # | Question (sur l'image) | Échec si… | Geste |
|---|---|---|---|
| 1 | Réduite à 25 %, quel élément voit-on en premier ? (entrées 3, 4) | aucun, ou deux à égalité | promouvoir un héros, rétrograder le reste |
| 2 | Sur un écran-vitrine, le héros mesure-t-il au moins 2,5 fois le corps du texte ? (4, 10) | rapport inférieur à 2,5 | agrandir le héros ou réduire le reste |
| 3 | Logo et nom cachés, devine-t-on le domaine de l'app ? (12, 17) | non | ajouter un objet du domaine dessiné, une palette tirée du domaine |
| 4 | Données remplacées par celles d'une autre app, l'écran tient-il encore ? (21) | oui | rattacher police, couleur et forme au thème |
| 5 | Y a-t-il plus de 3 modules identiques consécutifs sans élément dominant ? (2, 5) | oui (effet tableur) | transformer la donnée-clé en image, casser la grille par un module |
| 6 | En niveaux de gris, la hiérarchie tient-elle ? (15) | elle s'effondre | régler tailles, graisses et espaces avant la couleur |
| 7 | Une dominante nette et un accent sur environ 10 % au plus ? (11, 14) | couleurs à parts égales, ou accent partout | réserver l'accent à l'action principale, colorer le contenu |
| 8 | Deux familles au plus, et les titres ont-ils du caractère ? (7, 8, 9) | trois polices, ou titres dans la police du texte | police d'affichage aux titres, neutre au texte |
| 9 | Icônes, illustrations et rayons parlent-ils un seul langage de formes ? (16) | traits, rayons ou styles mélangés | unifier trait, rayon et niveau de détail |
| 10 | La variante se résume-t-elle en une phrase de thème, et diffère-t-elle des autres par le concept ? (1, 20, 21) | pas de phrase, ou variantes jumelles | réécrire le thème, refaire la variante la plus faible |

Le **plancher** reste celui des fiches existantes : contraste mesuré sur le fond réel, focus visible, texte à taille lisible (voir `design-couleur-contraste.md` et `design-typographie-mise-en-page.md`).

---

## Écarts avec les règles de design du profil (à arbitrer, pas à appliquer en silence)

Le `CLAUDE.md` global (§ « Règles de design opposables ») a été écrit pour des outils de développeurs (Linear, Vercel, Raycast). Il cède devant le design system de l'application. Pour une app **grand public**, ces constats s'en écartent sur quatre points :

1. **Police.** Le profil impose Inter ou Geist. Les entrées 7 et 21 demandent une **police d'affichage à caractère pour les titres**, la neutre restant au texte.
2. **Échelle.** Le profil fixe 12/14/16/20/24/32/48. Un chiffre-héros de 56 à 72 px (entrées 4 et 10) sort de cette échelle. La règle « 3 tailles au plus par écran » reste compatible, à condition que ces tailles soient **éloignées**.
3. **Couleur.** Le profil prescrit des neutres et un seul accent. Une **dominante colorée tirée du domaine** (entrées 11 et 12) va plus loin. L'accent unique reste compatible.
4. **Dégradés.** Le profil les interdit sauf cas justifié. L'entrée 18 n'admet qu'un léger dégradé de surface (lumière venant d'en haut), ce qui reste dans l'esprit. Les lavis décoratifs restent proscrits, et sont d'ailleurs devenus un signe du générique.

L'orchestrateur décide si la fiche de `graphiste` déroge explicitement à ces défauts.

---

## Repéré, non lu (ne pas citer comme lu)

- **A. Wathan & S. Schoger, *Refactoring UI*.** Seuls l'aperçu « palette » et la table des matières ont été lus. Le billet Medium « 7 practical tips » a renvoyé une erreur 403. Chapitres pertinents non lus : *Choose a personality*, *De-emphasize to emphasize*, *Greys don't have to be grey*, *Decorate your backgrounds*, *Use fewer borders*.
- **E. Lupton, *Thinking with Type* et *Graphic Design: The New Basics*.** Le passage sur les différences de taille minimes qui rendent une composition hésitante n'a été vu qu'en extrait de recherche.
- **R. Bringhurst, *The Elements of Typographic Style*.** Seule la règle 3.1.1, « ne pas composer sans échelle », a été lue, dans l'adaptation web de R. Rutter (https://webtypography.net/3.1.1). Ses chapitres sur le choix et l'association des caractères n'ont pas été lus.
- **Guide Duolingo** (`design.duolingo.com`, redirigé), **Google Fonts Knowledge**, **m3.material.io**, **Material 2 Imagery** et **Material Studies** : pages rendues en JavaScript, titre seul.
- **Red Dot** (critères : 404) ; **Art Directors Club** : non trouvé.
- **J. Santa Maria, *Hierarchy and Focal Point*** : 404.
- **Critique MIdST Labs** des icônes Airbnb (« skeuo-pastiche ») : corps de page absent.
- **Écoles (RISD, ECAL, HEAD, Yale School of Art)** : aucun écrit pédagogique lisible trouvé. C'est une lacune déclarée.

---

## Top 8 des consignes pour graphiste

Synthèse N0 ; les numéros renvoient aux entrées.

1. **Un thème par variante**, en une phrase et trois adjectifs, tiré d'un objet du domaine, et tenu sur tous les écrans (1, 20).
2. **Un héros par écran**, au moins 2,5 à 3 fois le corps, le reste volontairement rétrogradé (3, 4).
3. **La donnée-clé devient une image** (courbe, jauge, chiffre-héros, objet qui se remplit), jamais une rangée de tableau (2, 10).
4. **Police d'affichage à caractère pour les titres, neutre pour le texte, deux familles au plus**, graisses franches en grand seulement (7, 8, 9).
5. **Palette tirée d'une couleur source du domaine**, en rampe `oklch()`, une dominante, un accent rare, la couleur dans le contenu et pas sur les contrôles (11 à 14).
6. **Au moins un objet du domaine dessiné en SVG** et un langage de formes unique : rayon, trait d'icône, niveau de détail (16, 17).
7. **De l'air et un module qui rompt la grille.** Jamais plus de trois modules identiques à la suite (5, 6).
8. **Avant de rendre, passer la grille et les signes du générique sur la capture**, niveaux de gris compris, et refaire toute variante qui échoue au test du changement de données (15, 21).

---

## Bibliographie (toutes lues le 13.11.2026)

| Source | Auteur / éditeur, date | URL |
|---|---|---|
| Apple Design Awards (catégories, lauréats 2026) | Apple | https://developer.apple.com/design/awards/ |
| Winners of the 2026 Apple Design Awards | Apple Newsroom, 02.06.2026 | https://apple.com/ca/newsroom/2026/06/apple-reveals-winners-of-the-2026-apple-design-awards |
| Meet with Apple 257 — Tide Guide | Apple, T. MacDonald | https://developer.apple.com/videos/play/meet-with-apple/257 |
| Bears Gratitude, Behind the Design | Apple Developer, 04.02.2025 | https://developer.apple.com/news/?id=i74v3f4r |
| Developer Spotlight (Not Boring) | Apple App Store, non daté | https://apps.apple.com/us/story/id1591100111 |
| HIG — Branding (révisé 09.09.2026) | Apple | https://developer.apple.com/design/human-interface-guidelines/branding |
| HIG — Typography | Apple | https://developer.apple.com/design/human-interface-guidelines/typography |
| HIG — Color | Apple | https://developer.apple.com/design/human-interface-guidelines/color |
| HIG — Layout | Apple | https://developer.apple.com/design/human-interface-guidelines/layout |
| HIG — Icons | Apple | https://developer.apple.com/design/human-interface-guidelines/icons |
| Expressive design: Google's UX research | Google Design | https://design.google/library/expressive-material-design-google-research |
| Dynamic colors | Android Developers | https://developer.android.com/develop/ui/views/theming/dynamic-colors |
| Judging Criteria | Webby Awards | https://www.webbyawards.com/judging-criteria/ |
| About evaluation | Awwwards | https://www.awwwards.com/about-evaluation/ |
| About the Competitions | Type Directors Club | https://archive.tdc.org/about-the-competitions/ |
| Grid and Design Philosophy | J. Müller-Brockmann | https://neugraphic.com/muller-brockmann/muller-brockmann-text2.html |
| Interaction of Color (enseignement) | Josef & Anni Albers Foundation | https://www.albersfoundation.org/alberses/teaching/interaction-of-color |
| Rule 3.1.1, Don't compose without a scale | R. Rutter d'après R. Bringhurst | https://webtypography.net/3.1.1 |
| Refactoring UI — palette (aperçu) et sommaire | A. Wathan & S. Schoger | https://www.refactoringui.com/previews/building-your-color-palette |
| 7 Rules for Creating Gorgeous UI, Parts 1 & 2 | E. Kennedy, 15.06.2024 | https://learnui.design/blog/7-rules-for-creating-gorgeous-ui-part-1.html |
| Practical Typography — key rules, headings, mixing fonts | M. Butterick | https://practicaltypography.com/summary-of-key-rules.html |
| Using Color to Enhance Your Design | K. Gordon, NN/g, 06.06.2021 | https://www.nngroup.com/articles/color-enhance-design/ |
| How we redesigned the Linear UI (part II) | K. Saarinen et al., 28.03.2024 | https://linear.app/now/how-we-redesigned-the-linear-ui |
| Shape language: Duolingo's art style | M. Barker, 02.07.2020 | https://blog.duolingo.com/shape-language-duolingos-art-style/ |
| Airbnb's new app is designed to do it all | It's Nice That, 14.05.2025 | https://www.itsnicethat.com/articles/airbnb-app-redesign-140525 |
| Monitor stands have more personality than software | T. Geoco, UX Tools, 2026 | https://www.uxtools.co/blog/monitor-stands-have-more-personality-than-software |
| Improving frontend design through skills | Anthropic | https://claude.com/blog/improving-frontend-design-through-skills |
| Prompting for frontend aesthetics | Anthropic, 21.10.2025 | https://platform.claude.com/cookbook/coding-prompting-for-frontend-aesthetics |
| frontend-design SKILL.md | Anthropic | https://raw.githubusercontent.com/anthropics/skills/main/skills/frontend-design/SKILL.md |
| Why Your AI Keeps Building the Same Purple Gradient Website | prg.sh, 26.10.2025 | https://prg.sh/ramblings/Why-Your-AI-Keeps-Building-the-Same-Purple-Gradient-Website |
| Why app design has become homogenous | E. Gosling, AIGA Eye on Design, 03.08.2016 | https://eyeondesign.aiga.org/why-app-design-has-become-homogenous-and-how-we-can-fix-it/ |

# Fiche `ux-preuves` — Design visuel — couleur et contraste

> Fiche du skill `ux-preuves` (dev-fullstack), volet **design visuel**, préchargé par `designer`. Couvre : contraste normatif WCAG 2.2 (texte, non textuel, focus, placeholder), APCA et son statut réel, contraste sur le web réel, déficiences de la vision des couleurs, psychologie des couleurs et ses mythes, OKLCH et tokens, mode sombre.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Verdict sur les règles
> du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées : ce qui y
> figure ne se cite pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche documentaire du 09.11.2026 pour l'agent « designer produit senior ».
> Règle suivie : chaque entrée vient d'une page ouverte (WebFetch). Quand seul le résumé d'un
> article a été lu, c'est écrit. Hors champ (couvert ailleurs) : statut général de WCAG 3,
> WCAG 2.2 = ISO/IEC 40500:2025, lisibilité mode sombre / clair (NN/g 2020), WebAIM Million en général.
>
> Niveaux : N1 norme · N2 recherche revue par pairs ou étude empirique à large échantillon ·
> N3 guideline officielle d'institution ou de plateforme · N4 avis d'expert, article de praticien.

---

## 1. Contraste normatif (WCAG 2.2)

Statut vérifié sur w3.org : WCAG 2.2 est une « W3C Recommendation 12 December 2024 »
(https://www.w3.org/TR/WCAG22/).

### Texte courant à 4.5:1 minimum, texte « large » à 3:1, et « large » veut dire 18 pt (≈ 24 px) ou 14 pt gras (≈ 18.5 px), pas « un peu grand »
- Niveau de preuve : N1
- Source : W3C, 2024, « Web Content Accessibility Guidelines (WCAG) 2.2 », SC 1.4.3 et glossaire « large scale », https://www.w3.org/TR/WCAG22/ ; W3C WAI, « Understanding SC 1.4.3: Contrast (Minimum) », https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
- Extrait lu : « The visual presentation of text and images of text has a contrast ratio of at least 4.5:1 » ; « with at least 18 point or 14 point bold or font size that would yield equivalent size for Chinese, Japanese and Korean (CJK) fonts » ; Understanding : « 14pt and 18pt are equivalent to approximately 18.5px and 24px »
- Portée / limites : niveau AA. Le seuil 4.5:1 compense la perte de sensibilité au contraste d'une vision 20/40 (Understanding : « A user with 20/40 would thus require a contrast ratio of 3 * 1.5 = 4.5 to 1 ») ; le 3:1 de base vient d'ISO-9241-3 et ANSI-HFES-100-1988. Les ratios ne s'arrondissent pas : « 4.499:1 would not meet the 4.5:1 threshold ». Un texte de 16 px gras n'est PAS « large » (14 pt gras ≈ 18.5 px).
- En conception visuelle : un texte gris à 3:1 est-il réellement ≥ 24 px, ou ≥ 18.5 px en gras ? Le ratio affiché par l'outil est-il ≥ 4.5 sans arrondi ?

### Le texte d'aide (placeholder) est soumis au 4.5:1 ; le texte d'un composant désactivé, décoratif ou d'un logo ne l'est pas
- Niveau de preuve : N1
- Source : W3C, 2024, WCAG 2.2 SC 1.4.3 (exception « Incidental »), https://www.w3.org/TR/WCAG22/ ; W3C WAI, « Understanding SC 1.4.3 », https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
- Extrait lu : « Text or images of text that are part of an inactive user interface component, that are pure decoration, […] have no contrast requirement. » ; Understanding : « This success criterion applies to text in the page, including placeholder text »
- Portée / limites : l'exemption des désactivés est une absence d'exigence, pas une recommandation de les rendre illisibles. Un contrôle « désactivé » visuellement mais encore actionnable n'est pas inactif.
- En conception visuelle : le placeholder gris clair passe-t-il 4.5:1 ? Un bouton désactivé reste-t-il au moins identifiable comme bouton et son état compréhensible (ex. raison du désactivé) ?

### Viser 7:1 (AAA) pour le texte courant quand l'usage est long ou le public fragile
- Niveau de preuve : N1
- Source : W3C, 2024, WCAG 2.2 SC 1.4.6 Contrast (Enhanced), https://www.w3.org/TR/WCAG22/
- Extrait lu : « The visual presentation of text and images of text has a contrast ratio of at least 7:1, except for the following: » ; « Large-scale text and images of large-scale text have a contrast ratio of at least 4.5:1; »
- Portée / limites : niveau AAA, rarement exigé par les réglementations. Apple recommande aussi de « strive for a contrast ratio of 7:1 » pour les couleurs personnalisées (entrée § 7).
- En conception visuelle : le texte de lecture longue (documentation, contrat, tableau de bord consulté des heures) atteint-il 7:1 ?

### Tout ce qui permet d'identifier un composant ou son état (bordure de champ, case, interrupteur, onglet actif) doit faire 3:1 contre ce qui l'entoure
- Niveau de preuve : N1
- Source : W3C, 2024, WCAG 2.2 SC 1.4.11 Non-text Contrast, https://www.w3.org/TR/WCAG22/ ; W3C WAI, « Understanding SC 1.4.11 », https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
- Extrait lu : « The visual presentation of the following have a contrast ratio of at least 3:1 against adjacent color(s): » ; « Visual information required to identify user interface components and states, »
- Portée / limites : exclut les composants inactifs et l'apparence native non modifiée du navigateur. Understanding : une bordure de champ qui sert à identifier le champ doit faire 3:1 ; la figure 45 échoue avec une bordure #AAA sur blanc. Un champ sans bordure, distingué par son fond, doit avoir un fond à 3:1 du fond adjacent. Ce n'est pas « toute bordure » : une bordure purement décorative (séparateur de carte) n'est pas visée.
- En conception visuelle : si j'enlève la bordure gris clair du champ, sait-on encore où cliquer ? Si non, elle doit faire 3:1. L'état coché / actif se distingue-t-il à 3:1 de l'état non coché ?

### Un indicateur de focus personnalisé doit faire 3:1 ; le survol (hover) n'y est pas tenu
- Niveau de preuve : N1
- Source : W3C WAI, « Understanding SC 1.4.11: Non-text Contrast », https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
- Extrait lu : « the visual focus indicator for a component must have sufficient contrast against the adjacent background » ; « additional author-supplied visual treatments for hover are not 'required to identify' the hover state »
- Portée / limites : le focus natif du navigateur est exempté du ratio mais doit rester visible. Un effet de survol ne doit pas faire baisser le contraste propre du composant.
- En conception visuelle : l'anneau de focus du thème atteint-il 3:1 sur TOUS les fonds où il apparaît (fond clair, carte, bouton plein, mode sombre) ?

### Pour un focus vraiment visible, viser le critère AAA 2.4.13 : aire ≥ un périmètre de 2 px et changement de 3:1 entre focalisé et non focalisé
- Niveau de preuve : N1
- Source : W3C WAI, « Understanding SC 2.4.13: Focus Appearance », https://www.w3.org/WAI/WCAG22/Understanding/focus-appearance.html
- Extrait lu : « is at least as large as the area of a 2 CSS pixel thick perimeter of the unfocused component or sub-component, and » ; « has a contrast ratio of at least 3:1 between the same pixels in the focused and unfocused states. »
- Portée / limites : niveau AAA (nouveau en 2.2), non exigé en AA. Donne une cible concrète d'épaisseur que 1.4.11 ne donne pas.
- En conception visuelle : l'indicateur de focus fait-il au moins 2 px d'épaisseur sur tout le pourtour ?

### Dans un graphique, chaque élément nécessaire à la compréhension (part de camembert, ligne de série) doit faire 3:1 contre son fond — ou l'information doit être portée aussi par des libellés
- Niveau de preuve : N1
- Source : W3C WAI, « Understanding SC 1.4.11: Non-text Contrast », https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
- Extrait lu : (sur le camembert en échec) les utilisateurs doivent « discern the edges of the slices » ; (sur les courbes) les lignes ont besoin de 3:1 contre le fond, mais pas nécessairement entre elles (paraphrase de la page, résumée par l'outil de lecture)
- Portée / limites : camembert non concerné si libellés et valeurs portent la même information ; correctif admis : liseré plus foncé autour d'une part claire. Le texte dans un graphique relève de 1.4.3.
- En conception visuelle : la série en jaune pâle ou gris clair se voit-elle à 3:1 sur le fond ? Les valeurs sont-elles aussi écrites ?

### La couleur ne doit jamais être le seul moyen de transmettre une information, une action ou un état ; un lien distingué par sa seule couleur doit faire 3:1 contre le texte voisin ET recevoir un autre indice au survol/focus
- Niveau de preuve : N1
- Source : W3C, 2024, WCAG 2.2 SC 1.4.1 Use of Color, https://www.w3.org/TR/WCAG22/ ; W3C WAI, « Understanding SC 1.4.1 », https://www.w3.org/WAI/WCAG22/Understanding/use-of-color.html
- Extrait lu : « Color is not used as the only visual means of conveying information, indicating an action, prompting a response, or distinguishing a visual element. » ; technique G183 : « Using a contrast ratio of at least 3:1 to distinguish inline text links from surrounding text »
- Portée / limites : niveau A. Exemple de réussite cité : champ obligatoire en rouge ET accompagné d'une icône. Échec F13 : graphique dont la seule clé est la couleur, sans équivalent textuel. G183 est une technique suffisante (non la seule) ; le détail de l'indice complémentaire au survol n'a pas été relu verbatim.
- En conception visuelle : imprimer l'écran en niveaux de gris — erreurs, statuts, séries et liens se distinguent-ils encore ?

### Connaître la formule WCAG 2 et ses limites : luminance relative sRGB, la teinte n'y compte pas, les polices fines « trichent »
- Niveau de preuve : N1
- Source : W3C, 2024, WCAG 2.2, glossaire « relative luminance », https://www.w3.org/TR/WCAG22/ ; W3C WAI, « Understanding SC 1.4.3 », https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
- Extrait lu : « L = 0.2126 * R + 0.7152 * G + 0.0722 * B » ; « if RsRGB <= 0.04045 then R = RsRGB/12.92 else R = ((RsRGB+0.055)/1.055) ^ 2.4 » ; ratio « (L1 + 0.05) / (L2 + 0.05) » ; Understanding : « contrast is calculated in such a way that color (hue) is not a key factor » ; « particularly thin or unusual fonts may be rendered by user agents with a much fainter color than the actual text color defined in the underlying CSS »
- Portée / limites : seuil 0.03928 avant mai 2021, sans effet pratique (note 2 du glossaire). Calcul en sRGB par défaut. Limites reconnues par le W3C lui-même : anti-crénelage des polices fines ; cas des protanopes avec des couleurs à dominante rouge sur fond sombre (« predominantly long wavelength colors against darker colors ») — technique consultative : éviter le rouge sur noir. La norme ANSI d'origine intégrait la lumière ambiante, la formule WCAG non. Critiques externes (surévaluation du contraste des couleurs sombres) : voir § 2, niveau N4.
- En conception visuelle : la police est-elle fine (300 ou moins) ? Si oui, viser au-dessus du minimum. Y a-t-il du rouge pur sur fond sombre ?

---

## 2. APCA

### APCA ne fait pas partie du brouillon WCAG 3 au 10.09.2026 : l'algorithme de contraste y est explicitement « à déterminer »
- Niveau de preuve : N1 (document de travail officiel, non normatif)
- Source : W3C AGWG, 2026, « W3C Accessibility Guidelines (WCAG) 3.0 — W3C Working Draft 10 September 2026 », https://www.w3.org/TR/wcag-3.0/
- Extrait lu : « The default visual presentation of text meets @@[contrast measure to be determined]. » ; note d'éditeur : « The contrast algorithm used in WCAG 3 is yet to be determined. » ; « For this draft, the requirement assumes the algorithm will include a size/weight factor. »
- Portée / limites : document lu en entier en quatre passes : aucune occurrence de « APCA », « Advanced/Accessible Perceptual Contrast » ni « luminance ». Les exigences « Text contrast sufficient (minimum) », « Graphical object contrast sufficient », « Focus indicator contrast sufficient », « Interactive element contrast sufficient » sont au statut « Developing » ; l'entrée de glossaire « contrast ratio test » est « Exploratory ». Une note prévoit une exigence séparée si la déficience rouge-vert n'est pas prise en compte par l'algorithme.
- En conception visuelle : toute mention « conforme WCAG 3 / APCA » dans un livrable est fausse aujourd'hui. Conformité = WCAG 2.x.

### APCA est un algorithme d'un chercheur indépendant, en « bêta publique », qui exprime le contraste en Lc selon la polarité et tient compte de la taille et de la graisse
- Niveau de preuve : N4 (documentation de l'auteur)
- Source : Myndex (A. Somers), s.d., dépôt « apca-w3 », https://github.com/Myndex/apca-w3
- Extrait lu : « APCA is the Accessible Perceptual Contrast Algorithm, a new way to predict contrast for text and non-text content » ; « APCA is being evaluated as a replacement for WCAG 2 contrast math for future standards and guidelines. » ; « First color must be text, second color must be the background. » ; « For body text, add Lc 15 for any value on the table lower than Lc 75. »
- Portée / limites : le dépôt officiel dit « Accessible », pas « Advanced » (la forme « Advanced » circule ; non vérifié qu'elle ait été un nom officiel). Algorithme décrit comme « undergoing public beta validation ». Licence propre à destination du W3C/AGWG, avec limitations. Le résultat est signé (environ -108 à +106) : l'ordre texte/fond compte, contrairement au ratio WCAG 2 symétrique. Le critère associé (ARC, « Public Beta Draft » du 12.03.2023, https://a11yreadtech.github.io/ARC) déclare : « ARC is not backwards compatible with WCAG 2.x. »
- En conception visuelle : un outil qui affiche un score Lc sans préciser texte vs fond est mal utilisé.

### L'argument des défenseurs : le ratio WCAG 2 surévalue le contraste des couleurs sombres et ne sert pas à concevoir un mode sombre
- Niveau de preuve : N4 (auteur de l'algorithme, page non datée, © 2022)
- Source : A. Somers (Myndex), « Why APCA », https://git.apcacontrast.com/documentation/WhyAPCA
- Extrait lu : « far overstates contrast for dark colors to the point that 4.5:1 can be functionally unreadable when a color is near black » ; « WCAG 2.x contrast cannot be used for guidance designing 'dark mode'. » ; « a contrast value of Lc 60 represents the same perceived readability contrast, across the available range of colors. »
- Portée / limites : plaidoyer de l'auteur, pas de validation indépendante lue (cf. § Non vérifié). La page indique que les opinions « may or may not reflect those of the W3 or AGWG ».
- En conception visuelle : en mode sombre, ne pas se contenter du « 4.5:1 passe » : vérifier à l'œil et, à titre indicatif, avec un second modèle.

### L'argument des critiques : APCA a été retiré du processus WCAG 3 en 2023, change encore, complique les design systems et ne prouve aucune conformité
- Niveau de preuve : N4
- Source : A. Roselli, 2026 (10.04, maj 13.04), « WCAG3 Contrast as of April 2026 », https://adrianroselli.com/2026/04/wcag3-contrast-as-of-april-2026.html ; E. Eggert, 2021 (maj 2023, 2024), « WCAG 3 is not ready yet », https://www.yatil.net/blog/wcag-3-is-not-ready-yet
- Extrait lu : Roselli cite M. Cooper (W3C, 30.01.2023) : « Exploratory content that does not gain WG support to proceed to the next stage within 6 months is automatically removed » ; Eggert : chaque couple doit aussi être vérifié contre taille et graisse, ce qui rend « requirements documents and design systems more complicated »
- Portée / limites : chronologie de Roselli (retrait du brouillon de juillet 2023) cohérente avec le brouillon du 10.09.2026 lu en § 2 ; je n'ai pas ouvert moi-même le commentaire GitHub de 2023. Eggert : usage d'APCA acceptable pour un projet privé non commercial, pas pour démontrer une conformité.
- En conception visuelle : un design system ne doit pas remplacer ses seuils WCAG 2 par des seuils Lc.

### Ce qu'un designer peut faire d'APCA aujourd'hui : WCAG 2 comme plancher obligatoire, APCA comme second regard (surtout en sombre et pour les gris), jamais l'inverse
- Niveau de preuve : N4
- Source : L. C. Muth, 2022, « It's time for a more sophisticated color contrast check for data visualizations », https://www.datawrapper.de/blog/color-contrast-check-data-vis-wcag-apca/ ; Radix, s.d., « Understanding the scale », https://www.radix-ui.com/colors/docs/palette-composition/understanding-the-scale
- Extrait lu : Muth : « If a color's luminance is decreased by X%, we don't perceive it as being X% darker. » ; Radix : les pas 11 et 12 sont « guaranteed to Lc 60 and Lc 90 APCA contrast ratio on top of a step 2 background from the same scale. »
- Portée / limites : Muth recommande de respecter WCAG là où c'est exigé et de tester en plus avec APCA ; elle garde un gris #888888 sur blanc (3.5:1 en WCAG 2) sur la foi d'APCA — ce qui serait un échec 1.4.3 pour du texte courant. Radix ne garantit que des valeurs APCA, pas WCAG 2 : une palette « garantie APCA » doit être revérifiée en ratio WCAG.
- En conception visuelle : quand une palette tierce annonce « accessible », selon quel modèle ? Le couple passe-t-il AUSSI 4.5:1 ?

---

## 3. Contraste dans le web réel

### Le texte à faible contraste reste le défaut d'accessibilité le plus répandu : 83,9 % des pages d'accueil en 2026, en hausse
- Niveau de preuve : N2 (mesure automatique sur 1 000 000 de pages d'accueil)
- Source : WebAIM, 2026 (analyse de février 2026, page maj 30.03.2026), « The WebAIM Million — The 2026 report », https://webaim.org/projects/million/
- Extrait lu : « Low contrast text, below the WCAG 2 AA thresholds, was found on 83.9% of home pages. » ; « On average, each home page had 34 distinct instances of low-contrast text, up 15% from 2025. »
- Portée / limites : pages d'accueil seulement, détection automatique (sous-estimation probable des obstacles réels). Tendance relevée sur la page : 86,4 % (2021) → 79,1 % (2025) → 83,9 % (2026). 95,9 % des pages avaient au moins une erreur WCAG 2 détectée.
- En conception visuelle : le gris « élégant » de second niveau (méta-données, légendes, pieds de page) est la cause typique — le tester en premier.

### Seules ~30 % des pages passent l'audit de contraste Lighthouse (Web Almanac 2025) ; `prefers-contrast` n'est utilisé que par ~1 % des sites
- Niveau de preuve : N2 (HTTP Archive, crawl mensuel annoncé de 17 millions de sites ; audit axe-core via Lighthouse)
- Source : B. Lazar, M. Gifford, 2026 (publié 15.01.2026), « Accessibility », Web Almanac 2025, HTTP Archive, https://almanac.httparchive.org/en/2025/accessibility
- Extrait lu : « In 2025 on both desktop and mobile it is 30%. » ; « in 2024 it shot up on desktop to 28% and on mobile to 29%. » ; « In 2022 on desktop and mobile it was 23%. »
- Portée / limites : dernière édition publiée (l'URL 2026 répond 404 au 09.11.2026). Incohérence interne : le texte dit « only 31% of mobile sites currently meet minimum color contrast requirements », la figure 30 %. Mois de crawl et effectif exact de la métrique non relus (page méthodologie non ouverte). Même chapitre : `forced-colors` ~19 % (mobile), `prefers-color-scheme` ~13 %, `prefers-contrast` ~1 %.
- En conception visuelle : le thème prévoit-il une variante `prefers-contrast: more` et un rendu `forced-colors` testé ?

---

## 4. Déficiences de la vision des couleurs (DVC)

### Concevoir en supposant qu'environ 1 homme sur 12 (≈ 8 % chez les hommes d'ascendance européenne) confond certaines couleurs, surtout rouge et vert
- Niveau de preuve : N2 (revue d'enquêtes de population ; résumé seul lu) + N3 (institut médical)
- Source : J. Birch, 2012, « Worldwide prevalence of red-green color deficiency », J Opt Soc Am A 29(3):313-320, notice via https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=EXT_ID:22472762%20AND%20SRC:MED&resultType=core&format=json (PubMed 22472762) ; National Eye Institute (NIH), maj 05.11.2025, « Color Blindness », https://www.nei.nih.gov/learn-about-eye-health/eye-conditions-and-diseases/color-blindness
- Extrait lu : Birch : « Large random population surveys show that the prevalence of deficiency in European Caucasians is about 8% in men » ; NEI : « About 1 in 12 men have color vision deficiency. » ; « The most common type of color vision deficiency makes it hard to tell the difference between red and green. »
- Portée / limites : Birch dit « European Caucasians », pas « nord-européens » ; prévalence plus basse chez les hommes d'ascendance chinoise ou japonaise (4 à 6,5 % selon la notice). Femmes : ~0,5 % selon Crameri et al. 2020 (entrée suivante) ; le chiffre de Birch pour les femmes n'a pas été lu verbatim. Types cités par le NEI : rouge-vert (le plus fréquent), bleu-jaune, achromatopsie (rare) ; formes acquises (rétine, nerf optique, cataracte avec l'âge).
- En conception visuelle : le couple vert « succès » / rouge « erreur » est-il distinguable sans la teinte (icône, libellé, luminosité différente) ?

### Bannir les cartes arc-en-ciel (jet) pour les données continues : elles créent de fausses frontières et excluent les lecteurs DVC
- Niveau de preuve : N2 (article revu par pairs, synthèse)
- Source : F. Crameri, G. E. Shephard, P. J. Heron, 2020, « The misuse of colour in science communication », Nature Communications 11:5444, https://pmc.ncbi.nlm.nih.gov/articles/PMC7595127/
- Extrait lu : « adds artificial boundaries to some parts of the data range » ; « the yellow is the brightest colour and attracts the eye the most » ; « The general estimate is that worldwide 0.5% of women and 8% of men are subject to a colour-vision deficiency. » ; « Scientifically derived colour maps are perceptually uniform. »
- Portée / limites : article orienté visualisation scientifique ; s'applique aux cartes thermiques, cartes et dégradés de données d'un tableau de bord, pas aux couleurs catégorielles d'une UI. Le chiffre de prévalence est une « estimation générale », non sourcée primairement dans la phrase lue.
- En conception visuelle : une échelle séquentielle de l'interface varie-t-elle de façon monotone en luminosité ? Le jaune vif attire-t-il l'œil sur une valeur qui n'est pas la plus importante ?

### Pour les données séquentielles, préférer une carte perceptuellement uniforme et lisible en niveaux de gris, de type viridis
- Niveau de preuve : N4 (documentation de paquet ; les cartes d'origine sont de S. van der Walt et N. Smith, présentées à SciPy 2015)
- Source : S. Garnier (auteur et mainteneur du paquet R), s.d. (version 0.6.5), « viridis », https://sjmgarnier.github.io/viridis/
- Extrait lu : « The color maps are also perceptually-uniform, both in regular form and also when converted to black-and-white for printing. » ; « designed to improve graph readability for readers with common forms of color blindness »
- Portée / limites : la page ne cite pas d'étude d'utilisateurs. Crameri et al. 2020 citent viridis, magma, plasma et inferno parmi les cartes perceptuellement uniformes répandues.
- En conception visuelle : la légende continue reste-t-elle ordonnée une fois convertie en gris ?

### Pour les catégories, partir d'une palette conçue pour les DVC (Okabe & Ito) et doubler la couleur par forme, position, type de trait ou libellé
- Niveau de preuve : N4 (recommandation d'experts, non expérimentale)
- Source : M. Okabe, K. Ito, 2002 (révisé 2008), « Color Universal Design (CUD) — How to make figures and presentations that are friendly to Colorblind people », https://jfly.uni-koeln.de/color/ ; valeurs hex relevées dans le code source de R, https://raw.githubusercontent.com/wch/r-source/trunk/src/library/grDevices/R/colorstuff.R
- Extrait lu : « Use not only different colors but also a combination of different shapes, positions, line types and coloring patterns » ; R : « "Okabe-Ito" = c(black = "#000000", orange = "#E69F00", skyblue = "#56B4E9", » « bluishgreen = "#009E73", yellow = "#F0E442", blue = "#0072B2", » « vermillion = "#D55E00", reddishpurple = "#CC79A7", gray = "#999999"), »
- Portée / limites : conçue pour figures et présentations, pas pour du texte : plusieurs teintes (jaune #F0E442, bleu ciel) n'atteignent pas 4.5:1 sur blanc en texte (non calculé ici couple par couple : à vérifier). Le site d'origine montre la palette en image ; les hex viennent de R (implémentation, pas la publication d'origine). Recommandation de remplacer rouge/vert par magenta/vert en microscopie.
- En conception visuelle : la légende du graphique dépend-elle uniquement de la teinte ? Chaque série a-t-elle un marqueur ou un libellé direct ?

### Une couleur = un sens, partout ; et le sens porté par la couleur doit exister aussi sous une autre forme
- Niveau de preuve : N3
- Source : Apple, maj 16.12.2025, « Color — Human Interface Guidelines », https://developer.apple.com/tutorials/data/design/human-interface-guidelines/color.json
- Extrait lu : « Avoid relying solely on color to differentiate between objects, indicate interactivity, or communicate essential information. » ; « Avoid using the same color to mean different things. »
- Portée / limites : guideline de plateforme, cohérente avec WCAG 1.4.1.
- En conception visuelle : l'accent sert-il à la fois au bouton principal ET à un statut « info » ? Les deux sens se confondent-ils ?

---

## 5. Psychologie des couleurs

### Ne pas fonder un choix de couleur sur un « effet psychologique » : la recherche elle-même juge le domaine trop jeune pour des recommandations fermes
- Niveau de preuve : N2 (revue Annual Review ; résumé seul lu)
- Source : A. J. Elliot, M. A. Maier, 2014, « Color psychology: effects of perceiving color on psychological functioning in humans », Annual Review of Psychology 65:95-120, notice https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=EXT_ID:23808916%20AND%20SRC:MED&resultType=core&format=json
- Extrait lu : « We provide suggestions for future research and conclude by emphasizing the broad promise of research in this area. » (la phrase précédente, résumée, dit qu'il faut plus de travaux sur les conditions limites, les modérateurs et la généralisation au monde réel avant des recommandations fortes)
- Portée / limites : revue par les auteurs mêmes de « l'effet rouge » ; texte intégral non lu.
- En conception visuelle : une justification « le bleu inspire confiance » dans une note de design est-elle sourcée ? Sinon, la retirer ou la présenter comme convention de marque.

### « Le rouge nuit aux performances intellectuelles » : pas de preuve robuste après correction du biais de publication
- Niveau de preuve : N2 (méta-analyse, 67 tailles d'effet, 38 échantillons)
- Source : T. Gnambs, 2020, « Limited evidence for the effect of red color on cognitive performance: A meta-analysis », Psychonomic Bulletin & Review 27(6):1374-1382, https://pmc.ncbi.nlm.nih.gov/articles/PMC7704521/
- Extrait lu : « no evidential value for an effect of red color on intellectual performance was available. »
- Portée / limites : selon la notice de recherche (non relue verbatim) : effet nul sur anagrammes et connaissances, d = -0,34 sur le raisonnement avant correction, effets plus forts dans les premières études. Contexte : tests en situation d'évaluation, pas interfaces.
- En conception visuelle : ne pas éviter le rouge des messages d'erreur au motif qu'il « stresserait » ; le juger sur contraste et clarté.

### « Le rouge rend plus attirant » : effet très faible, peut-être nul, et quasi nul dans les études préenregistrées
- Niveau de preuve : N2 (méta-analyse ; hommes N = 2 961, femmes N = 2 739)
- Source : G. K. Lehmann, A. J. Elliot, R. J. Calin-Jageman, 2018, « Meta-Analysis of the Effect of Red on Perceived Attractiveness », Evolutionary Psychology 16(4), https://pmc.ncbi.nlm.nih.gov/articles/PMC10480976
- Extrait lu : « For men rating women, we found a small, statistically significant effect (d = 0.26 [0.12, 0.40], p = .0004, N = 2,961) » ; « The simplest conclusion from our results is that the true effect of incidental red on attraction is very small, potentially nonexistent. »
- Portée / limites : la discussion où figure cette conclusion est signée des premier et troisième auteurs (Elliot, coauteur, conteste la qualité des études). Les études préenregistrées donnent d ≈ 0,10 (hommes) et -0,10 (femmes).
- En conception visuelle : aucune.

### Les associations couleur-émotion sont largement partagées entre pays, mais modulées par la langue et la géographie : tester le sens local d'une couleur sémantique
- Niveau de preuve : N2 (4 598 participants, 30 pays, 22 langues ; résumé seul lu)
- Source : D. Jonauskaite et al., 2020, « Universal Patterns in Color-Emotion Associations Are Further Shaped by Linguistic and Geographic Proximity », Psychological Science 31(10):1245-1260, notice https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=DOI:10.1177/0956797620948810&resultType=core&format=json ; Apple, « Color — HIG », https://developer.apple.com/tutorials/data/design/human-interface-guidelines/color.json
- Extrait lu : « Pattern-similarity analyses revealed universal color-emotion associations (average similarity coefficient r = .88). » ; « nation predicted color-emotion associations above and beyond those observed universally. » ; Apple : « red communicates danger in some cultures, but has positive connotations in other cultures. »
- Portée / limites : associations à des termes de couleur (pas à des échantillons affichés), pas de mesure de comportement dans une interface. Les exemples précis par pays n'ont pas été lus (texte intégral inaccessible depuis cette session).
- En conception visuelle : pour un produit multi-marchés, les couleurs de statut (hausse/baisse, succès/danger) ont-elles été validées auprès d'utilisateurs locaux ?

### Une palette sobre où l'accent est réservé à l'élément le plus important est une recommandation de praticiens, pas un résultat expérimental
- Niveau de preuve : N4
- Source : K. Gordon (NN/g), 2021, « Using Color to Enhance Your Design », https://www.nngroup.com/articles/color-enhance-design/
- Extrait lu : « Limit your palette to three colors. » ; « Reserve the accent color for what you want to stand out the most on your page — for example, the primary call to action. » ; « Typically, the dominant and secondary colors should be relatively neutral colors. » ; « there is little real research that proves a universal effect of a particular color on emotions. »
- Portée / limites : exemples illustratifs, pas d'étude contrôlée ; recommande la règle 60-30-10 et le test utilisateur. Material (Wear OS) dit aussi « Use accent colors sparingly to accent key elements » (N3, § 7).
- En conception visuelle : combien d'éléments portent l'accent à l'écran ? Si tout est accentué, rien ne l'est.

---

## 6. Espaces de couleur perceptuels et tokens

### Ne pas construire une échelle en faisant varier la luminosité HSL : à L identique, le jaune paraît beaucoup plus clair que le bleu
- Niveau de preuve : N1 (spécification W3C ; section explicative non normative)
- Source : W3C, 2026, « CSS Color Module Level 4 — W3C Candidate Recommendation Draft, 3 November 2026 », § 7.3, https://www.w3.org/TR/css-color-4/
- Extrait lu : « Both have an HSL Lightness of 50%, but clearly the yellow looks much lighter than the blue. » ; « The OkLCh Lightnesses of 0.452 and 0.968 clearly reflect the visual lightnesses of the two colors. » ; « The hue angle in HSL is not perceptually uniform; colors appear bunched up in some areas and widely spaced in others. » ; « This section is not normative. »
- Portée / limites : CSS Color 4 est un « Candidate Recommendation Draft », pas encore Recommendation. `oklch()` y est défini : « specifies an Oklab color by Oklab Lightness, Chroma, and hue using the OkLCh cylindrical coordinate model ».
- En conception visuelle : deux tokens au même « L » HSL dans deux teintes ont-ils le même contraste ? (Non : le recalculer.)

### Préférer OKLCH/Oklab pour générer des échelles : conçu pour prédire séparément clarté, chroma et teinte, et corrige le défaut de CIELAB sur les bleus
- Niveau de preuve : N4 (article technique de l'auteur, non revu par pairs, largement repris depuis dans CSS Color 4)
- Source : B. Ottosson, 23.12.2020, « A perceptual color space for image processing », https://bottosson.github.io/posts/oklab/
- Extrait lu : « simple to use, while doing a good job at predicting perceived lightness, chroma and hue » ; « L, C and h should be perceived as orthogonal, so one can be altered without affecting the other two » ; sur CIELAB : « blue hues are predicted badly » ; sur HSV : « Yellow, magenta and cyan appear much lighter than red and blue. »
- Portée / limites : uniformité « meilleure », pas parfaite ; OKLCH ne calcule pas un contraste WCAG — un L OKLCH égal ne garantit pas un ratio égal. Les couleurs OKLCH à chroma élevée peuvent sortir du gamut sRGB.
- En conception visuelle : l'échelle 50-950 a-t-elle des écarts de clarté réguliers ? Les pas sombres restent-ils dans le gamut affichable ?

### Les écosystèmes de référence ont basculé leurs tokens en OKLCH (palette par défaut, variables de thème clair/sombre)
- Niveau de preuve : N4 (documentation de frameworks)
- Source : Tailwind CSS, 22.01.2025, « Tailwind CSS v4.0 », https://tailwindcss.com/blog/tailwindcss-v4 ; shadcn/ui, s.d., « Theming », https://ui.shadcn.com/docs/theming
- Extrait lu : Tailwind : « We've upgraded the entire default color palette from rgb to oklch, taking advantage of the wider gamut to make the colors more vivid » ; shadcn : « --primary: oklch(0.205 0 0); » et, pour `.dark`, « --warning: oklch(0.41 0.11 46); »
- Portée / limites : le motif affiché par Tailwind est la gamme P3, pas l'accessibilité. La page shadcn ne parle pas d'une migration depuis HSL.
- En conception visuelle : les variables de thème de la pile (Tailwind v4 / shadcn) sont-elles déjà en OKLCH ? Les réécrire en HSL serait une régression.

### Structurer une échelle par rôle (fonds, fonds de composants, bordures, aplats, texte) plutôt que par « nuance jolie »
- Niveau de preuve : N4
- Source : Radix, s.d., « Understanding the scale », https://www.radix-ui.com/colors/docs/palette-composition/understanding-the-scale
- Extrait lu : « Steps 1 and 2 are designed for app backgrounds and subtle component backgrounds. » ; « Steps 6, 7, and 8 are designed for borders. » ; « Steps 11 and 12 are designed for text. »
- Portée / limites : garantie de contraste exprimée en APCA uniquement (Lc 60 / Lc 90 sur le pas 2), pas en WCAG 2 : à revérifier en ratio.
- En conception visuelle : chaque token a-t-il un rôle écrit (fond, bordure, texte) et le couple texte/fond prévu a-t-il été mesuré ?

---

## 7. Mode sombre côté couleur

### Le mode sombre n'est pas une inversion : fonds plus sombres, avant-plans plus clairs, au moins 4.5:1, viser 7:1 pour les couleurs personnalisées, et adoucir les images à fond blanc
- Niveau de preuve : N3
- Source : Apple, maj 06.08.2024, « Dark Mode — Human Interface Guidelines », https://developer.apple.com/design/human-interface-guidelines/dark-mode.md
- Extrait lu : « The color palette in Dark Mode includes dimmer background colors and brighter foreground colors. It's important to realize that these colors aren't necessarily inversions of their light counterparts » ; « At a minimum, make sure the contrast ratio between colors is no lower than 4.5:1. For custom foreground and background colors, strive for a contrast ratio of 7:1, especially in small text. » ; « consider slightly darkening the image to prevent the background from glowing »
- Portée / limites : Apple demande aussi de tester avec « Increase Contrast » et « Reduce Transparency » et de fournir des variantes à contraste renforcé ; pas de mention du noir pur ni de la saturation des accents sur cette page.
- En conception visuelle : chaque token a-t-il une valeur sombre pensée (pas `invert()`) ? Les captures et illustrations à fond blanc « brillent »-elles dans l'interface sombre ?

### Exprimer la profondeur en sombre par des surfaces plus claires quand elles s'élèvent, pas par des ombres
- Niveau de preuve : N3
- Source : Apple, « Dark Mode — HIG », https://developer.apple.com/design/human-interface-guidelines/dark-mode.md ; Material Components for Android, « Dark theme », https://raw.githubusercontent.com/material-components/material-components-android/master/docs/theming/Dark.md ; idem « Color », https://raw.githubusercontent.com/material-components/material-components-android/master/docs/theming/Color.md
- Extrait lu : Apple : « The base colors are dimmer, making background interfaces appear to recede, and the elevated colors are brighter, making foreground interfaces appear to advance. » ; Material : « Material surfaces become lighter and more colorful at higher elevations » ; Color.md : « Surface with elevation overlay has been replaced with tonal surface colors in Material's components. »
- Portée / limites : chez Material, le calque d'élévation translucide est abandonné au profit de rôles de surface tonaux (`colorSurfaceContainerLowest` … `Highest`, `colorSurfaceDim`, `colorSurfaceBright`). Les pages m3.material.io (rendues en JavaScript) n'ont pas pu être lues : le détail Material 3 vient de la documentation du dépôt Android.
- En conception visuelle : une modale ou un menu en sombre se détache-t-il du fond par sa teinte de surface, sans compter sur une ombre invisible ?

### En sombre, préférer un gris très foncé au noir pur pour les surfaces d'application — sauf écran OLED dédié où la plateforme impose le noir
- Niveau de preuve : N3
- Source : Material Components for Android, « Dark theme », https://raw.githubusercontent.com/material-components/material-components-android/master/docs/theming/Dark.md ; Android Developers, « Color » (Wear OS, Material 2.5), https://developer.android.com/design/ui/wear/guides/m2-5/styles/color
- Extrait lu : « The baseline Material Dark theme background and surface colors are dark grey instead of black » ; motif : cela « increases visibility for shadows and also reduces eye strain for light text » ; Wear OS : « you must use a black background for your app and tile. »
- Portée / limites : la valeur #121212 souvent citée vient de la page Material 2 (m2.material.io), non lisible ici : non vérifiée verbatim. La « réduction de fatigue » est affirmée sans étude citée. Apple ne prescrit pas de gris : ses fonds système « base » sont décrits comme noirs sur la figure (texte alternatif « on top of a black background »).
- En conception visuelle : le fond est-il noir pur avec du texte blanc pur (contraste maximal, éblouissement possible) ? Sur montre / OLED, la règle s'inverse.

### En sombre, désaturer et éclaircir les couleurs d'accent (tons clairs) : les couleurs saturées échouent au contraste et « vibrent » sur fond sombre
- Niveau de preuve : N3
- Source : Android Developers, « Color » (Wear OS, Material 2.5), https://developer.android.com/design/ui/wear/guides/m2-5/styles/color
- Extrait lu : « A dark theme should avoid using saturated colors, as they don't meet WCAG's accessibility standard of at least 4.5:1 for body text against dark surfaces. Saturated colors also produce optical vibrations against a dark background, which can cause eye strain. » ; « The baseline Material Design dark theme uses the 200 tone as a primary color. »
- Portée / limites : page Wear OS / Material 2.5, mais qui reprend la palette de base Material ; la « vibration » et la fatigue sont affirmées sans étude citée. Le premier motif (contraste) est vérifiable par calcul ; le second est une observation de praticiens.
- En conception visuelle : l'accent du mode clair a-t-il été simplement réutilisé en sombre ? Prévoir une valeur sombre plus claire et moins chromatique (OKLCH : L plus haut, C plus bas).

### L'affirmation « le texte clair sur fond noir crée une halation pour les astigmates » n'a pas de source primaire trouvée ; ce qui est établi, c'est un avantage de lecture de la polarité positive lié à la taille de la pupille
- Niveau de preuve : N4 (affirmation) / N2 (mécanisme pupillaire ; résumé seul lu)
- Source : Level Access, 30.06.2020, « Accessibility for People with Astigmatism », https://www.levelaccess.com/blog/accessibility-for-people-with-astigmatism/ ; C. Piepenbrock, S. Mayr, A. Buchner, 2014, « Smaller pupil size and better proofreading performance with positive than with negative polarity displays », Ergonomics 57(11):1670-1677, notice https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=TITLE:%22Smaller%20pupil%20size%20and%20better%20proofreading%20performance%22&resultType=core&format=json
- Extrait lu : Level Access : « white text on black backgrounds creates a visual fuzzing effect for people with astigmatism called “halation”. » (aucune source citée) ; Piepenbrock et al. : « Indeed, pupil sizes were smaller and proofreading performance was better with positive than with negative polarity displays. »
- Portée / limites : Piepenbrock et al. testent l'hypothèse de luminance d'affichage chez des lecteurs tout-venant ; le résumé ne mentionne ni l'astigmatisme ni le flou réfractif ; effectif non lu. Le lien « halation / astigmatisme » reste plausible mais non démontré par les sources ouvertes. Le sujet « sombre vs clair en lisibilité » est traité ailleurs (NN/g 2020).
- En conception visuelle : en sombre, éviter le blanc pur #FFF sur noir pur pour le texte long ; laisser l'utilisateur choisir son thème plutôt que l'imposer.

---

## Verdict sur les règles du profil

| Règle | Verdict | Motif et sources |
|---|---|---|
| « Palette de neutres (zinc/slate/stone) + 1 accent max. Jamais de 2e accent sans raison forte. » | **Convention sans preuve trouvée** (cohérente avec les guidelines N3/N4) | Aucune étude expérimentale trouvée. Recommandée par praticiens (NN/g 2021 : neutres dominants, accent réservé au CTA principal ; Material Wear : accents « sparingly »). À compléter : les couleurs **sémantiques** (erreur, succès, avertissement) ne sont pas des « accents » et restent nécessaires ; une **dataviz** catégorielle exige plusieurs teintes distinguables (Okabe-Ito). Une couleur = un sens (Apple HIG). |
| « Pas de dégradés sauf cas justifié. Dark mode soigné. » | Dégradés : **convention sans preuve trouvée**. Dark mode soigné : **soutenue** (N3) | Aucune source n'interdit les dégradés ; deux contraintes vérifiées : le texte sur fond dégradé/image doit tenir 4.5:1 sur toute sa surface (échec F83 cité par Understanding 1.4.3) ; les cartes de données en arc-en-ciel sont à proscrire (Crameri 2020). NN/g 2017 (71 participants) montre que des signifiants trop faibles coûtent 22 % de temps : le « tout plat » a un prix, sans que cela prouve l'utilité des dégradés. « Dark mode soigné » gagne à être explicité : non-inversion, surfaces qui s'éclaircissent avec l'élévation, accents désaturés, 4.5:1 min (Apple, Material). |
| « Bordures fines 1px, neutres, jamais noires pures. » | **Convention sans preuve trouvée**, et **contredite en partie** pour les champs | « Jamais noires pures » : aucune source trouvée. En revanche, une bordure qui **identifie** un composant (champ, case, interrupteur) doit faire **3:1** contre le fond adjacent (WCAG 1.4.11) : la bordure gris clair typique (#AAA sur blanc, exemple d'échec du W3C) est non conforme. Règle à reformuler : « bordures décoratives fines et neutres ; bordures de contrôles à 3:1 minimum ». |
| « Toujours vérifier contraste (>= 4.5:1 texte normal, >= 3:1 texte large) » | **Soutenue mais incomplète** (N1) | Manquent : définition de « large » (≥ 24 px, ou ≥ 18.5 px gras) ; pas d'arrondi ; **placeholder inclus** à 4.5:1 ; **non textuel 3:1** (bordures de contrôles, états, icônes porteuses de sens, séries de graphiques) ; **focus personnalisé 3:1** (et cible AAA 2.4.13 : 2 px, changement 3:1) ; liens distingués par la seule couleur à 3:1 du texte voisin + indice non chromatique ; désactivés **exemptés** (mais à garder identifiables) ; polices fines → viser au-dessus ; mode sombre → vérifier les deux thèmes. APCA éventuel en second regard, jamais en remplacement. |
| « Variables CSS HSL pour dark mode. » | **Contredite** (sur le choix de l'espace) | Le principe des variables CSS par thème est juste ; HSL est le mauvais espace : CSS Color 4 (W3C, CRD 03.11.2026, § 7.3 non normatif) montre qu'à L = 50 % le jaune paraît bien plus clair que le bleu, et que la teinte HSL n'est pas uniforme. La pile du profil (Tailwind v4, shadcn) définit déjà ses tokens en `oklch()`. Reformuler : « variables CSS en OKLCH, une valeur claire et une valeur sombre par token, contraste mesuré pour chaque couple ». |
| « Couleur jamais seule porteuse d'information. » | **Soutenue** (N1) | WCAG 2.2 SC 1.4.1 (niveau A) ; Apple HIG ; Okabe & Ito. Prévalence DVC ~8 % des hommes d'ascendance européenne (Birch 2012, résumé), 1 sur 12 (NEI). |

---

## Mythes et affirmations contestées

- **« APCA est l'algorithme de WCAG 3. »** Faux au 09.11.2026 : le brouillon du 10.09.2026 dit « The contrast algorithm used in WCAG 3 is yet to be determined » et ne mentionne pas APCA (lu en entier). APCA a été retiré du processus en 2023 (Roselli, citant le W3C). APCA reste un outil d'évaluation complémentaire, en bêta, sans conformité attachée.
- **« APCA = Advanced Perceptual Contrast Algorithm. »** Le dépôt officiel dit « Accessible Perceptual Contrast Algorithm ».
- **« Une palette garantie APCA est accessible. »** Pas au sens réglementaire : Radix garantit Lc 60 / Lc 90, pas 4.5:1 ; Muth (2022) conserve un gris à 3.5:1 sur la foi d'APCA, ce qui échoue 1.4.3 pour du texte courant.
- **« Le bouton rouge convertit mieux (+21 %). »** Le chiffre circule à partir d'un test A/B de 2011 publié sur un blog marketing ; **la page d'origine n'a pas pu être ouverte** (URL actuelle redirigée vers un autre article, archive web inaccessible). Les sources secondaires lues l'expliquent par le **contraste avec une page à dominante verte**, pas par la teinte. Aucune source primaire ouverte ne soutient une « meilleure couleur » universelle. Ce qui est vérifié : NN/g 2021 réserve l'accent au CTA principal (isolement), et WCAG impose le contraste.
- **« Le rouge stresse / fait baisser les performances. »** Méta-analyse Gnambs 2020 : pas de valeur probante après correction du biais de publication.
- **« Le rouge rend plus attirant. »** Méta-analyse Lehmann et al. 2018 : effet « very small, potentially nonexistent ».
- **« Chaque couleur a une signification universelle » / « les couleurs n'ont que des sens culturels ».** Les deux sont faux : Jonauskaite et al. 2020 trouvent des associations très partagées (r = .88) ET un effet national au-delà (résumé seul lu).
- **« Le texte clair sur noir provoque une halation chez les astigmates. »** Affirmation répandue (Level Access 2020, sans source). Aucune source primaire trouvée ; seul est documenté un avantage pupillaire de la polarité positive chez des lecteurs tout-venant (Piepenbrock et al. 2014, résumé).
- **« Material impose #121212. »** Valeur Material 2, non relue verbatim ; Material 3 (documentation Android) a remplacé les calques d'élévation par des rôles de surface tonaux ; Wear OS impose au contraire le noir.
- **« Le 15.8:1 de Material pour le texte sombre. »** Chiffre vu uniquement dans des articles secondaires ; non vérifié.
- **« HSL suffit pour un thème clair/sombre cohérent. »** Contredit par CSS Color 4 § 7.3.
- **« 8 % des hommes nord-européens. »** La source primaire lue (Birch 2012) dit « European Caucasians », pas « nord-européens ».

---

## Non vérifié

- **Test A/B « rouge contre vert » de 2011 (+21 %)** : page d'origine non ouverte ; effectif et protocole inconnus.
- **Material 2 « Dark theme »** (m2.material.io) et **Material 3** (m3.material.io) : pages rendues en JavaScript, illisibles ; donc #121212, opacités du texte (87 % / 60 % / 38 %), 15.8:1 non vérifiés verbatim. Ce qui figure plus haut vient de la documentation Android officielle.
- **Texte intégral** d'Elliot & Maier 2014, Birch 2012, Jonauskaite et al. 2020 (dépôt hôte non résolu depuis cette session : biopen.bi.no à autoriser dans le réseau de la session pour y accéder), Piepenbrock et al. 2014 : résumés seuls lus. Chiffre de Birch pour les femmes non lu verbatim.
- **Validation indépendante d'APCA** : une recherche n'a trouvé qu'un article en russe (Ulitin 2021, listé par l'auteur d'APCA), non ouvert. Pas d'étude indépendante avec utilisateurs malvoyants ou DVC lue.
- **Commentaire W3C de M. Cooper (30.01.2023)** sur le retrait d'APCA : connu via Roselli, non ouvert directement.
- **Contraste WCAG des teintes Okabe-Ito sur blanc et sur noir** : non calculé couple par couple.
- **Méthodologie du Web Almanac 2025** (mois de crawl, nombre de pages de la métrique contraste) : page méthodologie non ouverte.
- **Indice non chromatique exigé pour les liens au survol/focus** (technique G183) : présence de G183 lue, détail de la technique non relu verbatim.

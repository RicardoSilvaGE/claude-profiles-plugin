# Fiche `ux-preuves` — Design visuel — typographie et mise en page

> Fiche du skill `ux-preuves` (dev-fullstack), volet **design visuel**, préchargé par `designer`. Couvre : taille critique de lecture, hauteur d'x, espacement, serif ou sans-serif, WCAG 1.4.4 / 1.4.10 / 1.4.12, tailles des plateformes, échelles et grilles (conventions), densité et espace blanc, polices web et performance, responsive.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Verdict sur les règles
> du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées : ce qui y
> figure ne se cite pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche du 9 novembre 2026. Chaque entrée renvoie à une page **réellement ouverte** pendant cette recherche (WebFetch, ou téléchargement direct de la page ou du fichier puis extraction du texte). Quand seul le résumé d'un article a pu être lu, c'est indiqué (« résumé seul lu »). Quand le contenu vient d'une synthèse rédigée par un tiers, c'est indiqué aussi.
>
> Déjà couvert dans un autre fichier, donc non repris ici : Wallace et al. 2022, Rello 2013 (police dédiée à la dyslexie), Dyson & Kipping 1998 et la plage de 45 à 75 caractères, le mode sombre (NN/g 2020), le F-pattern.
>
> Unités. Dans CSS, `1pt = 1/72nd of 1in` et `1px = 1/96th of 1in` (W3C, CSS Values and Units Level 4, https://www.w3.org/TR/css-values-4/, définitions lues dans la page). On a donc **12 px CSS = 9 pt** et **16 px = 12 pt**. Les « pt » d'Apple et les « dp/sp » d'Android sont des unités logiques propres à chaque plateforme. Ils ne valent pas les « points » des études sur papier.
>
> Niveaux de preuve : N1 norme ou réglementation · N2 recherche revue par les pairs ou étude empirique à large échantillon · N3 guideline officielle d'une institution ou d'une plateforme · N4 avis d'expert ou article de praticien.

---

## Thème 1 : lisibilité des caractères

### Le texte courant doit rester au-dessus de la taille critique de lecture, environ 0,2° de hauteur d'x. On raisonne donc en hauteur d'x à la distance de lecture réelle, pas en corps nominal.
- Niveau de preuve : N2 (revue de littérature et données psychophysiques)
- Source : Legge, G. E. & Bigelow, C. A., 2011, « Does print size matter for reading? A review of findings from vision science and typography », Journal of Vision 11(5):8, https://pmc.ncbi.nlm.nih.gov/articles/PMC3428264/
- Extrait lu : « Across studies, a consensus value for the critical print size for normally sighted readers is 0.2° x-height » ; « The fluent range extends over a factor of 10 in angular print size (x-height) from approximately 0.2° to 2°. » ; « At a viewing distance of 40 cm (16 inches), Times New Roman type, with an x-height fraction of 0.45 and a visual x-height of 0.2° is equivalent to a physical body size of 9 point. »
- Portée / limites : lecteurs à vue normale, lecture sur papier, distance de référence de 40 cm. La taille critique « typically lies in the range from about 0.15° to 0.3° depending on the individual ». Les auteurs ajoutent que « reading below the critical print size slows but does not stop ». La taille à l'écran dépend de la distance et de la densité de pixels, que l'article ne traite pas. Page lue jusqu'à environ 100 000 caractères sur 145 000.
- En conception visuelle : la police retenue a-t-elle une petite hauteur d'x ? À corps égal, une police à petite hauteur d'x passe plus vite sous le seuil. Un texte de 12 px lu à 60 cm sur un écran de bureau sous-tend un angle plus petit que 9 pt lus à 40 cm.

### On ne compte pas sur la « forme du mot » pour compenser une petite taille : ce sont les lettres prises une à une qui portent la reconnaissance au seuil de lisibilité.
- Niveau de preuve : N2 (résumé seul lu)
- Source : Sheedy, J. E., Subbaram, M. V., Zimmerman, A. B. & Hayes, J. R., 2005, « Text legibility and the letter superiority effect », Human Factors 47(4), DOI 10.1518/001872005775570998. Résumé lu via l'API Europe PMC : https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=EXT_ID:16553067%20AND%20SRC:MED&resultType=core&format=json
- Extrait lu : « Individual lowercase letters were 10% to 20% more legible than lowercase words » ; « Optimal legibility was attained at 9 pixels (10 points). Verdana and Arial were the most legible fonts; Times New Roman and Franklin were least legible. » ; « Increased stroke width (bold) improved threshold legibility but only at the thinnest width tested. »
- Portée / limites : il s'agit de la lisibilité **au seuil** (taille minimale de détection), pas de la vitesse de lecture d'un texte long. Écrans et lissage des polices de 2005 (ClearType). Le résumé ne précise pas si les « 9 pixels » mesurent la hauteur d'x. Texte intégral non lu.
- En conception visuelle : ne pas défendre un petit corps en invoquant la silhouette familière des mots. Tester la police à la taille réellement livrée, sur un écran de densité standard.

### Pour un texte à lire et à comprendre, on vise des corps nettement supérieurs à 12. Une étude en ligne a mesuré des gains jusqu'à 18 « points ».
- Niveau de preuve : N2 (CHI 2016, n = 104, oculométrie). Synthèse de tiers seule lue : le texte de l'ACM a renvoyé une erreur 403.
- Source : Rello, L., Pielot, M. & Marcos, M.-C., 2016, « Make It Big! The Effect of Font Size and Line Spacing on Online Readability », CHI 2016, DOI 10.1145/2858036.2858204. Lu via la synthèse du BYU Editing Research : https://editingresearch.byu.edu/?p=10398
- Extrait lu (citation de l'article reprise par la synthèse) : « Up to a font size of 18 points, subjective and objective readability as well as comprehension improved continuously » (p. 3646).
- Portée / limites : 104 volontaires de 14 à 54 ans, six tailles de 10 à 26, quatre interlignages de 0,8 à 1,4 fois l'interlignage par défaut. La synthèse parle de « points » sans préciser s'il s'agit de pt ou de px CSS, ce qui change le chiffre de 33 %. Il s'agit d'un texte long sur une page web, pas d'une interface dense.
- En conception visuelle : un écran de lecture (article, aide, conditions, onboarding) composé en 12 ou 14 est un défaut à signaler. Le corps de lecture se teste à part de l'interface.

### On choisit de préférence une police de texte à grande hauteur d'x, sans écraser ses ascendantes et descendantes.
- Niveau de preuve : N4 (affiche de congrès et résumé de conférence, petits échantillons)
- Source : Cooreman, B. & Beier, S., 2024, « A Theory of Visual Attention Based Assessment of Font Style: How important is x-height for font legibility? », affiche, SSSR 2024, https://readabilitymatters.org/?p=57664 ; complété par Beier, S., 2025, « How x-height and Ascender/Descender Length Impact Typeface Legibility », résumé, AtypI 2025, https://adk.elsevierpure.com/en/publications/how-x-height-and-ascenderdescender-length-impact-typeface-legibil/
- Extrait lu : « Increasing the fonts' x-height improved letter recognition, and this effect applied to all letters in the alphabet. » (2024) ; « Both x-height and ascender/descender length were found to play independent yet essential roles in legibility. » (2025)
- Portée / limites : échantillons de 26, 12 et 12 personnes (affiche 2024). Le résumé de 2025 ne donne pas d'effectif. Travaux non publiés en revue au moment de la lecture.
- En conception visuelle : comparer les hauteurs d'x des candidates au même corps. Une police « géométrique » à petite hauteur d'x demande un corps plus grand pour le même confort.

### On n'élargit pas l'approche (tracking) par défaut pour « faciliter la lecture » des adultes. Le gain mesuré au mot isolé disparaît en lecture de texte.
- Niveau de preuve : N2 (résumés seuls lus)
- Source : Perea, M., Giner, L., Marcet, A. & Gomez, P., 2016, « Does Extra Interletter Spacing Help Text Reading in Skilled Adult Readers? », Spanish Journal of Psychology, DOI 10.1017/sjp.2016.28 ; et Perea, M. & Gomez, P., 2012, « Subtle increases in interletter spacing facilitate the encoding of words during normal reading », PLoS ONE, PMC3474730. Résumés lus via l'API Europe PMC : https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=AUTH:%22Perea%20M%22%20AND%20TITLE:%22interletter%20spacing%22&resultType=core&format=json
- Extrait lu : « fixation durations were shorter while reading the text with extra spacing [...] (237 vs. 245 ms) » mais « cancelled out the effect of interletter spacing in total reading times (F < 1) » ; « at least for skilled adult readers, interletter spacing does not seem to play a consistently facilitative role during text reading. » (2016)
- Portée / limites : espagnol, lecteurs adultes experts, augmentation légère (+1,2 pt). Le résumé de 2016 ne donne pas l'effectif. Les études de 2011 et 2012 montrent un gain sur la reconnaissance de mots, en tâche de décision lexicale ou en temps de fixation.
- En conception visuelle : un tracking positif se justifie sur les capitales et les petits libellés, pas comme correctif général de lisibilité. Ne jamais resserrer sous la valeur par défaut d'un texte courant (voir l'entrée suivante).

### Un espacement des lettres plus large réduit les erreurs de lecture chez l'enfant, dyslexique ou non. L'effet sur la vitesse est discuté.
- Niveau de preuve : N2
- Source : Zorzi, M. et al., 2012, « Extra-large letter spacing improves reading in dyslexia », PNAS 109(28), https://pmc.ncbi.nlm.nih.gov/articles/PMC3396504/ ; nuancé par Hakvoort, B., van den Boer, M., Leenaars, T., Bos, P. & Tijms, J., 2017, « Improvements in reading accuracy as a result of increased interletter spacing are not specific to children with dyslexia », Journal of Experimental Child Psychology, DOI 10.1016/j.jecp.2017.07.010 (résumé seul lu via l'API Europe PMC : https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=AUTH:%22Hakvoort%20B%22%20AND%20spacing&resultType=core&format=json)
- Extrait lu : Zorzi : « Extra-large letter spacing helps reading, because dyslexics are abnormally affected by crowding ». Hakvoort : « increased LS appears to affect reading accuracy only. Second, the findings do not support claims that increased LS specifically affects poor readers. »
- Portée / limites : Zorzi porte sur 74 enfants de 8 à 14 ans (34 italiens et 40 français), avec un espacement augmenté de 2,5 pt. Les erreurs sont environ divisées par deux et la vitesse gagne environ 0,3 syllabe par seconde. Hakvoort porte sur 30 enfants dyslexiques, 30 témoins, puis 189 lecteurs non sélectionnés : les erreurs baissent, la vitesse ne bouge pas, et l'effet ne se produit qu'en lecture de phrases. Van den Boer & Hakvoort (2015, même requête) ne trouvent aucun gain en dénomination de mots, mais une perte quand l'espacement est **réduit** sous la valeur par défaut.
- En conception visuelle : un produit destiné aux enfants ou aux lecteurs en difficulté doit tenir un espacement augmenté sans casser la mise en page. C'est aussi ce qu'exige le critère WCAG 1.4.12. Un letter-spacing négatif sur un texte courant est à signaler.

### La familiarité d'une police compte surtout pour la préférence. Elle pèse peu sur la performance, qui s'ajuste en quelques minutes d'exposition.
- Niveau de preuve : N2 (n = 60, revue à comité de lecture)
- Source : Beier, S. & Larson, K., 2013, « How does typeface familiarity affect reading performance and reader preference? », Information Design Journal 20(1), 16-31, https://microsoft.com/en-us/research/uploads/prod/2021/06/Beier-Larson-2013-how-does-typeface-familiarity-affect-reading-performance-and-reader-preference.pdf (PDF téléchargé, texte extrait avec pdftotext)
- Extrait lu : « The results indicate that the exposure period has an effect on the speed of reading, but the uncommon letter shapes did not. Readers did not like the uncommon letter shapes. » ; « we conclude that the reason letter skeletons have changed so little over the years lies in readers' subjective opinions, and not in the way they read. »
- Portée / limites : 60 étudiants et membres du personnel de deux écoles d'art britanniques, lecture sur papier, 20 minutes d'exposition. Les auteurs avancent une piste d'explication liée à l'espacement des polices connues (Helvetica, Times), qu'ils déclarent « a matter that needs further research ».
- En conception visuelle : une police aux formes inhabituelles (a, g, y fantaisistes) pour le corps de texte est d'abord un risque de **rejet subjectif**, pas de lenteur. On la réserve aux titres.

### On ne choisit pas entre serif et sans-serif au nom de la lisibilité à l'écran : à conditions égales, aucune différence robuste n'est mesurée.
- Niveau de preuve : N2 (résumés seuls lus)
- Source : Arditi, A. & Cho, J., 2005, « Serifs and font legibility », Vision Research, PMC4612630 ; Vecino, S. et al., 2022, « How does serif vs sans serif typeface impact the usability of e-commerce websites? », PeerJ Computer Science, PMC9680897. Résumés lus via l'API Europe PMC : https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=TITLE:serif%20AND%20(screen%20OR%20legibility%20OR%20readability)&resultType=core&format=json et https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=TITLE:%22Serifs%20and%20font%20legibility%22&resultType=core&format=json
- Extrait lu : Arditi & Cho : « RSVP and continuous reading speeds showed no effect of serifs » ; « our data exhibited no difference in legibility between typefaces that differ only in the presence or absence of serifs. » Vecino : « The serif and sans serif characteristic inside the same font family does not affect usability on a website, as it was found that it has no impact on reading speed and user preference. »
- Portée / limites : Arditi & Cho ont utilisé des polices de synthèse ne différant que par l'empattement. Vecino a testé 246 volontaires sur un prototype, avec une seule famille déclinée en deux versions. Daxer et al. 2022 (Ophthalmic & Physiological Optics, même requête, sur papier, 36 personnes) ne trouvent pas non plus de différence entre Helvetica et Times.
- En conception visuelle : le choix serif ou sans-serif relève de l'identité et de la hiérarchie, pas de l'accessibilité. Ce qui compte pour la lisibilité, c'est la hauteur d'x, l'espacement et la graisse au corps livré.

---

## Thème 2 : normes de texte (WCAG 2.2)

### Le texte doit pouvoir être agrandi à 200 % sans perte de contenu : pas de conteneur à hauteur figée qui coupe le texte, pas de troncature sans accès au texte complet.
- Niveau de preuve : N1 (WCAG 2.2, critère 1.4.4, niveau AA)
- Source : W3C, WCAG 2.2, « Understanding Success Criterion 1.4.4: Resize Text », https://www.w3.org/WAI/WCAG22/Understanding/resize-text.html
- Extrait lu : « Except for captions and images of text, text can be resized without assistive technology up to 200 percent without loss of content or functionality. » La troncature n'est admise dans un composant que si « the component's full content is available on focus or after user activation ». L'échec F69 vise le cas où l'agrandissement « causes the text, image or controls to be clipped ».
- Portée / limites : le zoom du navigateur peut suffire (technique G142), à condition qu'il ne produise ni rognage ni chevauchement.
- En conception visuelle : chercher les cartes, badges, boutons et cellules à hauteur fixe, les libellés en `text-overflow: ellipsis` sans infobulle ni vue détaillée, et les textes posés sur une image à cadre fixe.

### Une maquette doit fonctionner à 320 px CSS de large sans défilement horizontal, sauf pour les contenus réellement bidimensionnels.
- Niveau de preuve : N1 (WCAG 2.2, critère 1.4.10, niveau AA)
- Source : W3C, « Understanding Success Criterion 1.4.10: Reflow », https://www.w3.org/WAI/WCAG22/Understanding/reflow.html
- Extrait lu : « 320 CSS pixels is equivalent to a starting viewport width of 1280 CSS pixels wide at 400% zoom. » Exception : « parts of the content which require two-dimensional layout for usage or meaning ».
- Portée / limites : l'exception couvre les tableaux de données (« not individual cells »), les cartes, les diagrammes, les barres d'outils d'éditeurs, la vidéo et les jeux. Ce qui entoure ces contenus (titre, recherche, pagination) doit se réorganiser. Pour un contenu à défilement horizontal, la hauteur de référence est de 256 px.
- En conception visuelle : un outil métier en tableau doit tout de même rendre à 320 px sa barre de filtres, son titre et sa pagination. On vérifie qu'aucune largeur minimale de page n'est imposée en dur.

### La mise en page doit survivre quand l'utilisateur impose un interlignage de 1,5, un espace de 2 fois le corps après les paragraphes, une approche de 0,12 em et un espace entre mots de 0,16 em.
- Niveau de preuve : N1 (WCAG 2.2, critère 1.4.12, niveau AA)
- Source : W3C, « Understanding Success Criterion 1.4.12: Text Spacing », https://www.w3.org/WAI/WCAG22/Understanding/text-spacing.html
- Extrait lu : « Line height (line spacing) to at least 1.5 times the font size; Spacing following paragraphs to at least 2 times the font size; Letter spacing (tracking) to at least 0.12 times the font size; Word spacing to at least 0.16 times the font size. » Et : « Content is not required to use these text spacing values. »
- Portée / limites : le critère n'impose pas ces valeurs à l'auteur. Il impose que la page **tienne** quand l'utilisateur les applique. Les légendes des figures donnent les cas d'échec : « Vertical text cut off is a failure », « Overlapping text is a failure ».
- En conception visuelle : toute hauteur fixe exprimée en px sur un bloc de texte (bouton, onglet, puce, ligne de tableau) est suspecte. On teste avec un bookmarklet d'espacement : c'est là qu'une grille stricte à hauteurs figées casse.

### Pour viser le niveau AAA, les blocs de texte doivent pouvoir faire au plus 80 caractères de large, ne pas être justifiés et avoir un interlignage d'au moins 1,5.
- Niveau de preuve : N1 (WCAG 2.2, critère 1.4.8, niveau AAA)
- Source : W3C, « Understanding Success Criterion 1.4.8: Visual Presentation », https://www.w3.org/WAI/WCAG22/Understanding/visual-presentation.html
- Extrait lu : « Width is no more than 80 characters or glyphs (40 if CJK). » ; « Text is not justified (aligned to both the left and the right margins). » ; « Line spacing (leading) is at least space-and-a-half within paragraphs ».
- Portée / limites : il suffit qu'un **mécanisme** permette d'atteindre ces valeurs. La page ne cite aucune source pour le chiffre de 80 caractères. La seule étude mentionnée porte sur la largeur des caractères CJK.
- En conception visuelle : pas de texte justifié dans l'interface. Une largeur de colonne de lecture bornée (`max-width` en `ch`) plutôt qu'un texte étiré sur toute la largeur d'un écran large.

### Les WCAG ne fixent aucune taille minimale de corps. Seuil à retenir : en dessous de 18 pt (14 pt gras), le texte doit atteindre le contraste de 4,5:1.
- Niveau de preuve : N1
- Source : W3C, 2023, « Web Content Accessibility Guidelines (WCAG) 2.2 », définition de « large scale (text) », https://www.w3.org/TR/WCAG22/ (page téléchargée, définition extraite)
- Extrait lu : « with at least 18 point or 14 point bold » ; « For many mainstream body text fonts, 14 and 18 point is roughly equivalent to 1.2 and 1.5 em or to 120% or 150% of the default size for body text ». La note 1 ajoute : « Fonts with extraordinarily thin strokes [...] are harder to read, especially at lower contrast levels. »
- Portée / limites : l'absence de minimum normatif n'est pas une autorisation. Les tailles minimales viennent des plateformes (thème 3).
- En conception visuelle : un texte de 12 px en gris clair cumule deux risques, la petite taille et l'exigence de contraste de 4,5:1. Les graisses fines (100 à 300) en petit corps sont à signaler.

---

## Thème 3 : tailles sur les plateformes

### Sur iOS, le corps par défaut fait 17 pt et le minimum 11 pt. Le texte doit suivre Dynamic Type et éviter la troncature aux grandes tailles.
- Niveau de preuve : N3
- Source : Apple, « Typography », Human Interface Guidelines, https://developer.apple.com/design/human-interface-guidelines/typography (contenu lu via la version JSON de la page : https://developer.apple.com/tutorials/data/design/human-interface-guidelines/typography.json ; dernière modification indiquée : 16 décembre 2025)
- Extrait lu : tableau « Platform Default size Minimum size iOS, iPadOS 17 pt 11 pt macOS 13 pt 10 pt tvOS 29 pt 23 pt visionOS 17 pt 12 pt watchOS 16 pt 12 pt » ; « Keep text truncation to a minimum as font size increases. » ; « Avoid truncating text in scrollable regions unless people can open a separate view to read the rest of the content. » ; « macOS doesn't support Dynamic Type. »
- Portée / limites : unités logiques Apple. Le guide ajoute qu'une graisse fine demande « larger than the recommended sizes ».
- En conception visuelle : une maquette mobile dont le corps est à 12 ou 14 descend sous le défaut d'Apple. Une maquette qui ne montre jamais l'état « plus grande taille d'accessibilité » n'a pas été éprouvée.

### L'échelle de Material 3 compte 15 styles : corps à 16, 14 et 12, libellés jusqu'à 11. Elle ne suit ni une grille de 4 ni une raison constante.
- Niveau de preuve : N3 (jetons de conception de Material, lus dans le code que le framework officiel Flutter génère depuis la base de jetons)
- Source : projet Flutter, `typography.dart`, bloc « BEGIN GENERATED TOKEN PROPERTIES - Typography », https://raw.githubusercontent.com/flutter/flutter/master/packages/flutter/lib/src/material/typography.dart (la page m3.material.io n'est pas lisible sans JavaScript)
- Extrait lu : « bodyLarge [...] fontSize: 16.0 [...] height: 1.50 », « bodyMedium [...] fontSize: 14.0 [...] height: 1.43 », « bodySmall [...] fontSize: 12.0 [...] height: 1.33 », « labelSmall [...] fontSize: 11.0 », « displayLarge [...] fontSize: 57.0 ».
- Portée / limites : tailles relevées, de la plus grande à la plus petite : 57, 45, 36, 32, 28, 24, 22, 16, 14, 14, 12, 11 (plus les trois corps 16, 14 et 12). Le commentaire du code indique que ces valeurs sont « generated from data in the Material Design token database ». La page de spécification elle-même n'a pas pu être lue.
- En conception visuelle : chez Material, 12 est le **petit** corps (bodySmall) : légendes, métadonnées. Ce n'est pas la taille de lecture. Une échelle de production n'a pas besoin d'être géométrique pour fonctionner.

### Les champs de formulaire web doivent être rendus à 16 px ou plus, pour éviter le zoom automatique de Safari iOS au focus. Ne pas désactiver le zoom pour contourner le problème.
- Niveau de preuve : N4 (constat de praticiens, aucune documentation officielle trouvée)
- Source : Johansson, R., 2012, « iOS WebKit browsers and auto-zooming form controls », https://456bereastreet.com/archive/201212/ios_webkit_browsers_and_auto-zooming_form_controls ; Judis, S., 2021, « Mobile Safari doesn't zoom into form inputs with minimum 16px », https://www.stefanjudis.com/notes/mobile-safari-doesnt-zoom-into-form-inputs-with-minimum-16px/
- Extrait lu : « The magic size seems to be a calculated font-size of 16px. » (2012) ; « Safari is not "zooming into" focused form elements if they have a font size of or larger than `16px`. » (2021)
- Portée / limites : aucune des deux pages ne cite de documentation d'Apple ou de WebKit. La seconde relaie un message d'un autre praticien sans l'avoir testé (« secondhand »). Le comportement est constant dans les retours depuis 2012, mais non documenté. Le contourner par `maximum-scale=1` entre en conflit avec le critère WCAG 1.4.4.
- En conception visuelle : un champ, un select ou une zone de texte à 14 px dans une maquette web mobile annonce un zoom intempestif. On corrige la taille, jamais le viewport.

### Les services publics britanniques composent leur corps de texte à 19 px, sur grand écran comme sur petit, avec une échelle de sept niveaux.
- Niveau de preuve : N3
- Source : GOV.UK Design System, « Type scale », https://design-system.service.gov.uk/styles/type-scale/
- Extrait lu : `govuk-body` en 19px / 25px sur les deux tailles d'écran ; « The scale for 'large screens' is used when the screen is wider than the tablet breakpoint (640px). » ; « It has been tested and iterated for readability on different devices. »
- Portée / limites : public très large, services administratifs. Les niveaux sont 80, 48, 36, 27, 24, 19 et 16. Les niveaux 80 et 27 sont réservés aux « exceptional circumstances ». Les tests mentionnés ne sont pas publiés sur cette page. 16 px y est la petite taille (`govuk-body-s`).
- En conception visuelle : pour un produit grand public, notamment un public âgé ou peu lettré, la référence d'une institution qui a testé son échelle place le corps **au-dessus** de 16, pas en dessous.

---

## Thème 4 : échelles typographiques, grilles et formes

### Si l'on adopte une grille d'espacement, celle de Material est de 8 dp pour les composants et de 4 dp pour le texte et les icônes. C'est une convention de plateforme, pas un résultat mesuré.
- Niveau de preuve : N3
- Source : Google, Material Design 1, « Layout – Metrics & keylines », https://m1.material.io/layout/metrics-keylines.html
- Extrait lu : « All components align to an 8dp square baseline grid for mobile, tablet, and desktop. » ; « Iconography in toolbars align to a 4dp square baseline grid. » ; « Type aligns to a 4dp baseline grid. »
- Portée / limites : la page ne donne aucune justification à la valeur de 8 dp et n'est pas datée. Elle signale que Material 1 « is no longer maintained ».
- En conception visuelle : la grille est un outil de cohérence et de vitesse de production. Une valeur hors grille n'est pas, en soi, un défaut d'utilisabilité.

### La grille de 8 points se justifie par la mise à l'échelle des écrans et la vitesse de production, sans donnée utilisateur.
- Niveau de preuve : N4
- Source : Spec Network, sans auteur ni date indiqués, « The 8-Point Grid », https://spec.fm/specifics/8-pt-grid
- Extrait lu : « most popular screen sizes are divisible by 8 on at least one axis - usually both. »
- Portée / limites : la page ne cite ni étude, ni données, ni recherche utilisateur. Elle s'appuie sur l'expérience de l'auteur et sur les guides de plateformes. Aucune étude empirique comparant une grille de 4 ou 8 points à une autre n'a été trouvée.
- En conception visuelle : défendre une grille au nom de la cohérence et de la vitesse de livraison, jamais au nom de « la recherche ».

### Une échelle modulaire est un choix esthétique assumé : l'article de référence ne revendique aucune preuve.
- Niveau de preuve : N4
- Source : Brown, T., 2011, « More Meaningful Typography », A List Apart, https://alistapart.com/article/more-meaningful-typography/
- Extrait lu : « A modular scale is a sequence of numbers that relate to one another in a meaningful way. » ; « Modular scales are a tool, they're not magic. »
- Portée / limites : justification historique et culturelle (nombre d'or, analogie musicale reprise de Bringhurst), sans test de lecture ni d'utilisabilité. L'auteur reconnaît que l'équilibre « always involves lots of trial and error ».
- En conception visuelle : la bonne question n'est pas « l'échelle respecte-t-elle un ratio ? », mais « chaque niveau a-t-il un rôle distinct et la hiérarchie se lit-elle d'un coup d'œil ? ».

### Des formes arrondies peuvent être préférées aux angles vifs. Aucune donnée ne fixe le rayon d'une interface.
- Niveau de preuve : N2 (résumé seul lu)
- Source : Bar, M. & Neta, M., 2006, « Humans prefer curved visual objects », Psychological Science, DOI 10.1111/j.1467-9280.2006.01759.x. Résumé lu via l'API Europe PMC : https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=TITLE:%22Humans%20prefer%20curved%20visual%20objects%22&resultType=core&format=json
- Extrait lu : « The type of contour a visual object possesses--whether the contour is sharp angled or curved--has a critical influence on people's attitude toward that object. »
- Portée / limites : il s'agit d'objets visuels en général, pas de composants d'interface. Le résumé ne donne pas d'effectif. Rien sur les valeurs de rayon.
- En conception visuelle : le rayon relève de l'identité. Ce qui se vérifie, c'est la **cohérence**, par exemple des rayons imbriqués compatibles, plus que la valeur choisie.

---

## Thème 5 : densité et espace blanc

### On réserve la haute densité aux listes, tableaux et longs formulaires, et on la règle par paliers de 4 px. La densité par défaut reste basse.
- Niveau de preuve : N3
- Source : Material Components for the Web, « Density », README du paquet `@material/density`, https://raw.githubusercontent.com/material-components/material-components-web/master/packages/mdc-density/README.md
- Extrait lu : « Material Design uses low-density space by default but offers high-density space when it improves the user experience. » ; « List, tables, and long forms are components that benefit from increased density. » ; « The density interval is set to 4px for visual consistency. »
- Portée / limites : documentation de la bibliothèque Material 2. La page de guideline « Applying density » n'a pas pu être lue (contenu chargé en JavaScript). Exemple donné par le README : un bouton passe de 36 px à 24 px au palier -3.
- En conception visuelle : un tableau de bord métier au même interlignage qu'une page d'accueil marketing est une densité non réfléchie. Mais une densité forte appliquée aux alertes, aux dialogues et aux cibles tactiles en est une autre.

### Un écran mieux organisé, plus groupé et moins dense aide nettement les novices sans pénaliser les experts. L'idée qu'un expert « a besoin » de densité n'est pas démontrée.
- Niveau de preuve : N2 (résumé seul lu)
- Source : Burns, M. J., Warren, D. L. & Rudisill, M., 1986, « Formatting space-related displays to optimize expert and nonexpert user performance », CHI '86 (ACM SIGCHI Bulletin), DOI 10.1145/22339.22383. Résumé lu via l'API Crossref : https://api.crossref.org/works?query.bibliographic=Formatting+space-related+displays+to+optimize+expert+and+nonexpert+user+performance&rows=2
- Extrait lu : « Large improvements in speed and accuracy were found for nonexperts on the reformatted displays. Experts had fewer errors but no response time difference on the reformatted displays. »
- Portée / limites : écrans alphanumériques de la navette spatiale, années 1980. Le résumé ne donne pas d'effectif et ne détaille pas ce que la reformulation a changé. Le même résumé rappelle qu'on supposait alors que « user interface changes that aid novices tend to impair experts », ce que l'expérience n'a pas confirmé pour les experts.
- En conception visuelle : dans un outil expert, gagner en densité ne doit pas coûter le regroupement. Les experts tolèrent la densité, mais ils profitent eux aussi d'une structure claire.

### La densité se mesure, elle ne se juge pas à l'œil. On distingue la densité globale, la densité locale, le groupement et la complexité de mise en page.
- Niveau de preuve : N2 (résumé seul lu)
- Source : Tullis, T. S., 1983, « The Formatting of Alphanumeric Displays: A Review and Analysis », Human Factors 25(6), DOI 10.1177/001872088302500604. Résumé lu via l'API Crossref : https://api.crossref.org/works?query.bibliographic=The+formatting+of+alphanumeric+displays+a+review+and+analysis+Tullis&rows=2 ; limite de généralisation relevée par Schwartz, D. R., 1988, « The Impact of Task Characteristics on Display Format Effects », https://garyperlman.com/hfeshci/Abstracts/88_352-356.html
- Extrait lu : « Four characteristics of display formats are described: overall density, local density, grouping, and layout complexity. » (Tullis) ; « subjects were unable to evaluate their performance accurately under alternative display designs. » (Schwartz)
- Portée / limites : écrans en mode texte. Les équations prédictives de Tullis ne doivent pas être transposées hors de leur tâche d'origine (Schwartz). Texte intégral non lu.
- En conception visuelle : la préférence déclarée ne vaut pas mesure de performance (Schwartz). On teste la tâche réelle, par exemple le temps de recherche, avant de trancher sur la densité.

### Des marges autour du texte améliorent la compréhension. L'interlignage, dans la plage testée, agit surtout sur la préférence.
- Niveau de preuve : N3/N4 (rapport de laboratoire universitaire en ligne, résumé seul lu)
- Source : Chaparro, B., Baker, J. R., Shaikh, A. D., Hull, S. & Brady, L., 2004, « Reading Online Text: A Comparison of Four White Space Layouts », Usability News 6, https://portfolio.erau.edu/en/publications/reading-online-text-a-comparison-of-four-white-space-layouts/
- Extrait lu : « Results show that the use of margins affected both reading speed and comprehension more than the No Margin text. » ; « Leading was not shown to impact reading performance but did influence overall user preference. »
- Portée / limites : l'effectif n'est pas donné sur la page lue. Le résumé ne dit pas dans quel sens la vitesse a varié. Aucun pourcentage n'y figure, et en particulier pas de « +20 % » (voir les mythes).
- En conception visuelle : un texte qui touche les bords de son conteneur, sur mobile ou dans un panneau latéral, est un défaut. Les marges latérales ne sont pas un luxe.

---

## Thème 6 : polices web et performance

### On choisit `font-display` en connaissance de cause. `swap` rend le texte au plus tôt mais peut décaler la mise en page. `optional` supprime le décalage. Le décalage se réduit en ajustant la police de repli (`size-adjust`).
- Niveau de preuve : N3
- Source : Hempenius, K. & Pollard, B., « Best practices for fonts », web.dev (date non affichée), https://web.dev/articles/font-best-practices
- Extrait lu : `swap` « delays text render the least » ; `optional` donne l'« assurance that there isn't font-swap related layout shifts » ; la permutation provoque un décalage (CLS) parce qu'« a web font and its fallback font take up different amounts of space on the page ».
- Portée / limites : la page recommande aussi WOFF2, le sous-ensemble de glyphes et `unicode-range` (« a font file is downloaded if the page contains one or more characters matching the unicode range »). Elle met en garde : un préchargement contourne `unicode-range`, et l'auto-hébergement n'est pas automatiquement plus rapide.
- En conception visuelle : la maquette doit prévoir la police de repli. Ses métriques sont-elles proches ? Que devient un titre sur deux lignes s'il passe à trois lignes avec la police de repli ?

### Chaque fonte supplémentaire se paie : la police la plus rapide est celle qu'on ne charge pas. Une police variable n'est rentable que si l'on emploie plusieurs graisses ou styles.
- Niveau de preuve : N3
- Source : Hempenius, K. & Pollard, B., « Best practices for fonts », web.dev, https://web.dev/articles/font-best-practices
- Extrait lu : synthèse de l'outil de lecture, non verbatim : la police la plus rapide est celle qui n'est pas demandée ; `system-ui` ne demande aucun téléchargement et convient bien au corps de texte ; une police variable peut remplacer plusieurs fichiers, mais elle pèse plus lourd qu'un fichier d'un seul style.
- Portée / limites : la recommandation porte sur la performance de chargement, pas sur la lisibilité. Extrait verbatim non conservé, d'où la reformulation.
- En conception visuelle : compter les fichiers de fonte réellement requis par la maquette (graisses × styles × familles). Un système « 1 sans + 1 mono » est sobre si la sans est une seule police variable.

### En 2025, environ 4 sites sur 10 utilisent une police variable et la moitié déclarent `font-display: swap` ; WOFF2 représente environ 65 % des requêtes de polices.
- Niveau de preuve : N2 (mesure à large échantillon : passage d'indexation de HTTP Archive)
- Source : Berret, C. (auteur), 2026, « Fonts », Web Almanac 2025, chapitre 1, HTTP Archive, publié le 15 janvier 2026, mis à jour le 10 février 2026, https://almanac.httparchive.org/en/2025/fonts
- Extrait lu : « This year, 39.4% of desktop websites and 41.3% of mobile websites used at least one variable font on their pages. » ; « About 50.1% of mobile sites and 49.6% of desktop sites use swap. » ; « In 2025, WOFF2 accounts for about 65% of font file requests » ; « web fonts were found on roughly 88% of websites ».
- Portée / limites : il s'agit d'usage observé, pas de bonnes pratiques prouvées. `system-ui` apparaît sur environ 9,7 % des pages (bureau). Le chapitre recommande le sous-ensemble de glyphes pour les grosses polices (CJK, icônes) sans en mesurer l'usage. Page lue jusqu'à environ 100 000 caractères, puis vérifications par recherche dans le texte complet téléchargé.
- En conception visuelle : imposer une police variable n'a rien d'exotique en 2026. Le défaut à chercher est une fonte non sous-ensemblée de plus de 100 Ko pour un usage latin.

### Les polices système (`system-ui`) suppriment le téléchargement, mais leur rendu varie selon l'OS et la langue. Sous Windows en chinois ou en japonais, elles peuvent donner un corps latin médiocre.
- Niveau de preuve : N4 (discussion du groupe de travail CSS du W3C)
- Source : W3C CSS Working Group, ticket ouvert le 19 février 2019, « [css-fonts] `system-ui` behavior is undesired for some users » (#3658), https://github.com/w3c/csswg-drafts/issues/3658
- Extrait lu : « on Windows 8.1/Windows 10 in Simplified Chinese, the system-ui font family evaluates to Microsoft YaHei UI » ; « The issue is you force to use MSYH on pure English content, which is what system-ui on Chinese Windows does. »
- Portée / limites : ticket clos, finalement étiqueté hors périmètre en juillet 2026 (« simply a platform font bug, not really anything to do with CSS »). Le ticket d'ouverture rapporte que de grands sites ont renoncé à ce mot-clé pour cette raison.
- En conception visuelle : avec une pile système, on vérifie le rendu sous Windows dans une langue CJK, ou bien on nomme explicitement les polices latines en tête de pile.

### Inter est une police libre (OFL 1.1), variable, avec une hauteur d'x élevée pour ses tailles de texte et des chiffres tabulaires. Ces propriétés servent une interface dense.
- Niveau de preuve : N4 (page du créateur de la police)
- Source : Andersson, R. (rsms), « Inter », https://rsms.me/inter/
- Extrait lu : « The smaller "text" optical-size designs features a tall x-height to aid in legibility of lower-case text » ; « Fixed-width numbers are useful for tabular data, where comparing columns across rows is desired. »
- Portée / limites : description par l'auteur, pas une évaluation indépendante. Page lue jusqu'à environ 100 000 caractères sur 218 000. Geist n'a pas été vérifié.
- En conception visuelle : dans les tableaux et les montants, les chiffres tabulaires (`font-variant-numeric: tabular-nums`) sont-ils activés ?

---

## Thème 7 : mise en page responsive

### Les points de rupture se placent là où le contenu casse, pas sur des modèles d'appareils.
- Niveau de preuve : N3
- Source : LePage, P. & Andrew, R., « Responsive web design basics », web.dev (date non affichée), https://web.dev/articles/responsive-web-design-basics
- Extrait lu : « Don't define breakpoints based on device classes, or any product, brand name, or operating system. » ; « Instead, let the content determine how its layout changes to fit the container. »
- Portée / limites : recommandation de praticiens institutionnels, sans étude citée. La page reprend aussi une « classic readability theory » de 70 à 80 caractères par ligne, sans source.
- En conception visuelle : une maquette ne doit pas être livrée en trois artboards fixes (375, 768, 1440). On demande où la mise en page casse entre ces largeurs.

### Les seuls points de rupture adossés à des données sont ceux de la plateforme Android (600, 840, 1200 et 1600 dp). Ils se basent sur la taille de **fenêtre**, pas sur le type d'appareil.
- Niveau de preuve : N3 (avec une base de parc d'appareils)
- Source : Android Developers, « Window size classes », https://developer.android.com/develop/ui/compose/layouts/adaptive/window-size-classes
- Extrait lu : « Compact width | width < 600dp | 99.96% of phones in portrait » ; « Window size classes are not intended for *isTablet*‑type logic. »
- Portée / limites : les pourcentages décrivent la couverture du parc d'appareils de la plateforme. Ils ne mesurent pas la performance des utilisateurs. Classes mobiles Android : leur transposition au web est une analogie.
- En conception visuelle : la mise en page réagit-elle à la fenêtre (écran partagé, pliable, fenêtre redimensionnée) ou à un appareil supposé ?

### Pour un composant réutilisable, on préfère les container queries aux media queries : elles sont disponibles dans tous les navigateurs principaux.
- Niveau de preuve : N3
- Source : Kravets, U., 14 février 2023, « Size container queries and container query units are now stable across browsers », web.dev, https://web.dev/blog/cq-stable ; statut Baseline lu via l'API webstatus.dev : https://api.webstatus.dev/v1/features/container-queries
- Extrait lu : « stable in all modern browsers » (Chrome et Edge 105, Firefox 110, Safari 16) ; API : `"baseline":{"high_date":"2025-08-14","low_date":"2023-02-14","status":"widely"}`.
- Portée / limites : statut « Baseline widely available » depuis le 14 août 2025 selon webstatus.dev. Il s'agit des requêtes **de taille**. Les style queries n'ont pas été vérifiées.
- En conception visuelle : une carte affichée dans une barre latérale étroite et dans une grille large doit avoir deux états dessinés, liés à la largeur de son conteneur.

### Sur grand écran, on borne la largeur de la page et celle des colonnes de lecture, au lieu d'étirer le texte.
- Niveau de preuve : N3
- Source : GOV.UK Design System, « Layout », https://design-system.service.gov.uk/styles/layout/
- Extrait lu : « The default maximum page width is 1020px, but you can make it wider if your content requires it. » Synthèse de l'outil de lecture, non verbatim : la page recommande des mises en page en deux tiers ou en deux tiers plus un tiers, pour que les lignes ne deviennent pas difficiles à lire sur ordinateur, et des lignes de 75 caractères au plus en général.
- Portée / limites : aucune recherche n'est citée sur la page. Les valeurs en pixels des points de rupture ne figurent pas sur cette page (la page Type scale donne 640 px pour la tablette).
- En conception visuelle : un paragraphe qui court sur 1 400 px sur un écran de 27 pouces est un défaut, même si la maquette est « responsive ».

---

## Verdict sur les règles du profil

| Règle du profil | Verdict | Motif sourcé |
|---|---|---|
| « Espacements : 4px strict (4, 8, 12, 16, 24, 32, 48, 64). Jamais d'intermédiaires. » | **Convention sans preuve trouvée**, cohérente avec les plateformes | Material aligne les composants sur 8 dp et le texte sur 4 dp (m1.material.io), et règle la densité par paliers de 4 px (README de MDC Density). Aucune justification n'y est donnée. La source de praticiens sur la grille de 8 points ne cite aucune étude (spec.fm). Aucune étude comparant des grilles n'a été trouvée. **Garde-fou** : « jamais d'intermédiaires » ne doit pas devenir « hauteurs fixes ». Les critères WCAG 1.4.4 et 1.4.12 exigent que les blocs de texte grandissent quand l'utilisateur agrandit le texte ou l'espace. La grille s'applique aux marges et aux écarts, pas à la hauteur des conteneurs de texte. |
| « Typographie : 1 sans (Inter/Geist) + 1 mono. Échelle 12/14/16/20/24/32/48. Max 3 tailles par écran. » | **Convention sans preuve trouvée**, avec une réserve forte sur le bas de l'échelle | Sans-serif ou serif : aucune différence de lisibilité (Arditi & Cho 2005 ; Vecino 2022). Le choix d'Inter est compatible avec la recherche sur la hauteur d'x (page d'Inter ; Cooreman & Beier 2024). Geist n'a pas été vérifié. Les échelles des plateformes ne suivent pas celle du profil : Material 3 compte 15 styles dont 57, 45, 22 et 11 ; Apple met le corps par défaut à 17 pt ; GOV.UK met le corps à 19 px. Aucune source pour « 3 tailles au plus » : c'est une règle de sobriété. Il manque un palier de corps de lecture au-dessus de 16 (18 ou 19), justifié par Rello 2016 et GOV.UK. |
| « 6 tailles typo sur un écran » = anti-pattern | **Convention sans preuve trouvée** | Aucune étude ni guideline consultée ne plafonne le nombre de tailles par écran. Les plateformes proposent 7 niveaux (GOV.UK) ou 15 (Material 3) sans plafond par écran. Formulation défendable : signaler des tailles **sans rôle distinct** (écarts de 1 ou 2 px entre niveaux voisins), plutôt qu'un compte. |
| « Radius cohérent (6 ou 8px). » | **Convention sans preuve trouvée** | Seule donnée : une préférence générale pour les contours courbes (Bar & Neta 2006, résumé seul lu), sans aucune valeur de rayon. La cohérence se défend comme principe de système, pas la valeur 6 ou 8. |
| « Densité adaptée au contexte ; densité uniforme entre outil métier et landing = anti-pattern. » | **Soutenue** (N3, nuance N2) | Material : « low-density space by default », haute densité pour « List, tables, and long forms ». Nuance (Burns et al. 1986) : la réorganisation a aidé les novices et n'a pas ralenti les experts. La densité d'un outil expert doit donc rester groupée et structurée, pas seulement serrée. La préférence déclarée n'est pas une mesure (Schwartz 1988). |
| Corps de texte à 12 px | **Contredit comme corps de lecture ; défendable pour le texte secondaire** | 12 px = 9 pt CSS. Material en fait le petit corps (bodySmall), pas le corps par défaut (bodyLarge 16). Apple : défaut à 17 pt, minimum à 11 pt. GOV.UK : 19 px, avec 16 px pour la petite taille. Dans Rello 2016, les gains de compréhension continuent jusqu'à 18 « points » (unité ambiguë, synthèse de tiers). Sur le web mobile, un champ sous 16 px déclenche le zoom de Safari iOS (N4). Selon Legge & Bigelow, 9 pt de Times à 40 cm se situe à la taille critique de lecture : sur écran et à plus grande distance, on passe dessous. **Recommandation** : faire démarrer le corps à 16 (14 dans les vues denses), et réserver 12 aux légendes, métadonnées et cellules de tableau, toujours au contraste de 4,5:1. |

---

## Mythes et affirmations contestées

- **« L'espace blanc augmente la compréhension de 20 % » (souvent attribué à « Lin 2004 » ou à « Wichita State »).** Aucune source primaire trouvée pour ce chiffre. L'étude la plus proche (Chaparro et al. 2004) conclut que les marges améliorent la compréhension, mais ne donne aucun pourcentage dans le résumé lu. Ne pas citer le chiffre.
- **« Les serifs pour le papier, les sans-serif pour l'écran. »** Non soutenu : aucune différence robuste à conditions égales (Arditi & Cho 2005 ; Vecino et al. 2022 à l'écran, n = 246 ; Daxer et al. 2022 sur papier).
- **« On lit par la forme globale des mots » (bouma).** Au seuil de lisibilité, les lettres isolées sont plus lisibles que les mots (Sheedy et al. 2005, résumé). Ce n'est pas un argument pour un petit corps.
- **« Écarter les lettres aide spécifiquement les dyslexiques. »** Contesté. Zorzi et al. 2012 trouvent un bénéfice net. Hakvoort et al. 2017 trouvent un bénéfice sur la précision seulement, et pas propre aux dyslexiques. Van den Boer & Hakvoort 2015 ne trouvent aucun gain en dénomination de mots.
- **« Un tracking légèrement augmenté accélère la lecture de tous. »** Le gain de fixation chez l'adulte s'annule sur le temps total de lecture (Perea et al. 2016).
- **« Les échelles modulaires et le nombre d'or produisent l'harmonie. »** Aucune preuve n'est revendiquée par l'article de référence (Brown 2011 : « a tool, they're not magic »).
- **« La grille de 8 points est prouvée. »** C'est une convention de production (Material, sans justification ; spec.fm, sans données).
- **« Material 3 utilise un ratio de 1,125. »** Cette affirmation, lue dans les résultats de recherche d'un cours en ligne, est contredite par les jetons : 57/45 ≈ 1,27, 16/14 ≈ 1,14, 14/12 ≈ 1,17. L'échelle n'a pas de ratio constant.
- **« Les experts préfèrent et performent mieux avec des interfaces denses ; la recherche le montre de façon constante. »** Affirmation lue dans des résultats de recherche (guides de praticiens), sans source primaire trouvée. La seule étude primaire lue (Burns et al. 1986) va plutôt dans l'autre sens : une meilleure structure ne nuit pas aux experts.
- **« 16 px pour éviter le zoom iOS » présenté comme une règle d'Apple.** Le comportement est constant chez les praticiens depuis 2012, mais aucune documentation d'Apple ou de WebKit n'a été trouvée.
- **« 70 à 80 caractères par ligne, c'est la théorie classique » (web.dev), « 80 caractères » (WCAG 1.4.8), « 75 caractères » (GOV.UK).** Trois chiffres, et aucune des trois pages ne cite sa source. La question des longueurs de ligne est traitée dans un autre fichier.

## Non vérifié

- **Guideline « Applying density » de Material 2 et 3** (m2.material.io, m3.material.io) : pages en JavaScript, illisibles, archive web inaccessible. Seul le README de la bibliothèque a été lu. Non vérifié : l'affirmation, lue dans un résultat de recherche, que « Material Design 3 specifies that compact density should never be the default ».
- **Page de spécification de l'échelle typographique de Material 3** : illisible. Valeurs lues uniquement dans les jetons générés du framework Flutter.
- **Texte intégral de Rello, Pielot & Marcos 2016** (ACM : erreur 403) : l'unité exacte des « points » et l'effet de l'interlignage ne sont connus que par une synthèse de tiers.
- **Texte intégral de Sheedy et al. 2005, de Tullis 1983, de Burns et al. 1986, d'Arditi & Cho 2005 et de Perea et al. 2016** : résumés seuls lus.
- **Effectif de l'étude de Chaparro et al. 2004** et sens de l'effet sur la vitesse de lecture.
- **Article de NN/g sur la densité d'information** (« Information Density and Search », 2018, cité de seconde main) : non trouvé, non lu.
- **Tableaux de tailles Dynamic Type d'Apple, par catégorie** : seuls le défaut de 17 pt et le minimum de 11 pt pour iOS ont été lus. Les lignes de tableau extraites du JSON n'ont pas pu être rattachées avec certitude à une plateforme et n'ont pas été utilisées.
- **Geist** : caractéristiques (hauteur d'x, version variable, licence) non vérifiées.
- **Base empirique des points de rupture web** (320, 768, 1024, 1440, etc.) : aucune trouvée au-delà de la couverture du parc d'appareils publiée par Android.
- **Statut navigateur des style queries** (container style queries) : non vérifié.
- **Effet de l'espace blanc sur la compréhension**, au-delà de Chaparro et al. 2004 : aucune étude primaire supplémentaire lue.

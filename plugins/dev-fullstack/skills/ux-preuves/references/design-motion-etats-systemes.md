# Fiche `ux-preuves` — Design visuel — motion, états des composants, design systems

> Fiche du skill `ux-preuves` (dev-fullstack), volet **design visuel**, préchargé par `designer`. Couvre : durées et courbes d'animation, mouvement et accessibilité (WCAG 2.2.2, 2.3.1, 2.3.3, `prefers-reduced-motion`), états des composants (focus 2.4.7 / 2.4.11 / 2.4.13, hover au tactile, désactivé, chargement), design tokens (format DTCG, sémantiques et primitifs), preuves d'effet des design systems, conventions de composants.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Verdict sur les règles
> du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées : ce qui y
> figure ne se cite pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Recherche documentaire du 9 novembre 2026. Chaque entrée renvoie à une page ou un PDF réellement
ouvert pendant cette recherche (WebFetch, ou téléchargement puis `pdftotext` pour les PDF, ou API
publique PubMed pour les résumés médicaux). Quand seul le résumé a été lu, c'est indiqué.
Hors périmètre (couvert ailleurs) : cibles tactiles, barres de progression, skeleton screens,
temps de réponse 0,1/1/10 s.

Niveaux : N1 norme / spécification normative · N2 recherche revue par pairs ou étude empirique
(échantillon cité) · N3 guideline officielle d'institution ou de plateforme · N4 avis d'expert,
article de praticien, étude d'éditeur non revue.

---

## 1. Durées et courbes d'animation

### Garder la plupart des animations d'interface entre 100 et 500 ms : ~100 ms pour un retour simple (case, interrupteur), 200–300 ms pour un changement d'écran important ; au-delà de 500 ms, c'est une gêne
- Niveau de preuve : N4
- Source : Page Laubheimer (NN/g), 2020 (9 février), « Executing UX Animations: Duration and Motion Characteristics », https://www.nngroup.com/articles/animation-duration/
- Extrait lu : « In general, the duration of most animations should be in the range of 100–500 ms » ; « At 500ms, animations start to feel like a real drag for users — they become cumbersome and annoying. » ; « Simple feedback animations, such as showing a checkbox or toggle switch, should be roughly 100 ms »
- Portée / limites : recommandation de praticien. L'article ne présente pas ses chiffres comme issus d'une étude ; il s'appuie sur deux livres (Head 2016, Saffer 2014), un article de Pratt et al. 2010 sur la capture de l'attention, et « a century's experience with animated cartoons ». Il ajoute que les entrées demandent une durée « subtly longer » que les sorties et que plus une animation est fréquente, plus elle doit être courte.
- En conception visuelle : la durée est-elle proportionnée à l'ampleur du changement ET à la fréquence du geste ? Une animation répétée cent fois par jour à 300 ms est un défaut, même si elle est « dans la plage ».

### Prendre les durées dans une échelle de jetons qui croît avec la surface parcourue (Material 3 : 50 ms à 1000 ms), pas dans une valeur unique
- Niveau de preuve : N3
- Source : Google / Material Components for Android, sans date (fichier `docs/theming/Motion.md`, branche master), « Motion », https://raw.githubusercontent.com/material-components/material-components-android/master/docs/theming/Motion.md
- Extrait lu : « In general, duration should increase as the area/traversal of an animation increases. » ; jetons `motionDurationShort1` = « 50ms » … `motionDurationMedium4` = « 400ms » … `motionDurationLong1` = « 450ms » … `motionDurationExtraLong4` = « 1000ms »
- Portée / limites : 16 jetons (Short1–4 : 50–200 ms ; Medium1–4 : 250–400 ms ; Long1–4 : 450–600 ms ; ExtraLong1–4 : 700–1000 ms). Documentation d'implémentation Android de Material 3 ; le site m3.material.io (rendu en JavaScript) n'a pas pu être lu, l'équivalence avec ses pages n'est donc pas vérifiée. Aucune justification empirique donnée.
- En conception visuelle : la durée est-elle un jeton nommé, choisi selon la distance parcourue ? Une plateforme majeure prévoit des durées au-delà de 400 ms : une interdiction absolue au-delà de ce seuil est plus stricte que Material.

### Décélérer les éléments qui entrent, accélérer ceux qui sortent (courbes « decelerate » / « accelerate »), éviter le linéaire pour les déplacements
- Niveau de preuve : N3 (Material) ; N4 (NN/g)
- Source : Google / Material Components for Android, sans date, « Motion », https://raw.githubusercontent.com/material-components/material-components-android/master/docs/theming/Motion.md ; Page Laubheimer (NN/g), 2020, « Executing UX Animations: Duration and Motion Characteristics », https://www.nngroup.com/articles/animation-duration/
- Extrait lu : Material : `motionEasingEmphasizedDecelerateInterpolator` « cubic-bezier: 0.05, 0.7, 0.1, 1 » — « Easing used for common, M3-styled animations that enter the screen. » ; `motionEasingEmphasizedAccelerateInterpolator` « cubic-bezier: 0.3, 0, 0.8, 0.15 » — « Easing used for common, M3-styled animations that exit the screen. » ; standard « cubic-bezier: 0.2, 0, 0, 1 ». NN/g : « Most frequently, you'll want to use an ease-out animation » ; « Completely linear motion looks weird and unnatural to users. » ; « Ease-in and ease-in-out are sometimes used for elements leaving the screen. »
- Portée / limites : convention de plateforme et de praticien ; aucune des deux sources ne cite d'étude comparant ease-out et ease-in. NN/g prévient qu'un ease-in peut paraître peu réactif parce qu'il démarre lentement. La courbe « standard » de Material 3 n'est pas un ease-out pur : elle est asymétrique (départ et arrivée adoucis).
- En conception visuelle : un élément qui sort démarre-t-il assez vite pour ne pas donner l'impression que l'interface a « calé » ? Un déplacement est-il linéaire sans raison ?

### Pour le mouvement « physique » (ressorts) : ressort rapide pour les petits composants, lent pour les transitions plein écran, et jamais de rebond sur une couleur ou une opacité
- Niveau de preuve : N3
- Source : Google / Material Components for Android, sans date, « Motion », https://raw.githubusercontent.com/material-components/material-components-android/master/docs/theming/Motion.md ; Google / Android Developers, sans date, « MotionScheme » (Jetpack Compose Material 3), https://developer.android.com/reference/kotlin/androidx/compose/material3/MotionScheme
- Extrait lu : « Small component animations like switches should use the fast spring » ; « full screen animations or transitions should use the slow spring » ; « a background's alpha shouldn't bounce or oscillate above 100% » ; valeurs « motionSpringFastSpatial » = « damping: 0.9, stiffness: 1400 », « motionSpringDefaultSpatial » = « damping: 0.9, stiffness: 700 », « motionSpringSlowSpatial » = « damping: 0.9, stiffness: 300 » (effets : damping 1, stiffness 3800 / 1600 / 800). Compose : « The expressive scheme is Material's recommended motion scheme for prominent UI elements and hero interactions. » ; « The standard scheme is Material's basic motion scheme for utilitarian UI elements and recurring interactions. »
- Portée / limites : documente l'API du mouvement à ressorts de Material 3 Expressive (deux schémas, six ressorts « spatial » / « effects »). Les ressorts n'ont pas de durée fixe : la règle « X ms » ne s'y applique pas telle quelle. Pas de justification empirique dans ces pages.
- En conception visuelle : distingue-t-on les propriétés spatiales (position, taille, forme — rebond admis) des propriétés d'« effet » (couleur, opacité — amortissement critique, sans rebond) ? Le schéma expressif est-il réservé aux éléments phares, le standard aux interactions récurrentes ?

### N'animer que pour servir l'expérience, brièvement, rarement sur les interactions fréquentes, et toujours interruptible
- Niveau de preuve : N3
- Source : Apple, sans date (consulté le 09.11.2026), « Motion » — Human Interface Guidelines, https://developer.apple.com/design/human-interface-guidelines/motion (texte lu via le flux JSON de la même page : https://developer.apple.com/tutorials/data/design/human-interface-guidelines/motion.json)
- Extrait lu : « Add motion purposefully, supporting the experience without overshadowing it. Don't add motion for the sake of adding motion. » ; « Aim for brevity and precision in feedback animations. » ; « In apps, generally avoid adding motion to UI interactions that occur frequently. » ; « Let people cancel motion. As much as possible, don't make people wait for an animation to complete before they can do anything »
- Portée / limites : Apple ne donne aucune durée chiffrée dans cette page. Elle demande aussi de « Make motion optional » et de ne pas faire du mouvement le seul canal d'une information. Pour visionOS, elle déconseille les oscillations soutenues autour de 0,2 Hz.
- En conception visuelle : l'utilisateur peut-il agir pendant l'animation, ou est-il bloqué jusqu'à sa fin ? L'information portée par le mouvement existe-t-elle aussi sans lui ?

### Utiliser l'animation pour le retour d'action, les changements d'état, l'orientation spatiale et les signifiants — pas pour décorer ni capter l'attention de force
- Niveau de preuve : N4
- Source : Page Laubheimer (NN/g), 2020 (12 janvier), « The Role of Animation and Motion in UX », https://www.nngroup.com/articles/animation-purpose-ux/
- Extrait lu : « Motion can be used to indicate that the interface switched to a different state. » ; « Animation in UX must be unobtrusive, brief, and subtle. » ; « gratuitous animations distract and annoy the user. »
- Portée / limites : article de praticien, sans étude propre. L'article range aussi l'usage de l'animation pour détourner l'attention parmi les dark patterns.
- En conception visuelle : pour chaque animation, quel changement d'état explique-t-elle ? S'il n'y en a pas, la supprimer.

### Éviter les apparitions et disparitions brusques : faire arriver et partir les objets en continuité (principes du dessin animé : solidité, exagération, ralenti au départ et à l'arrivée)
- Niveau de preuve : N2 par le canal (actes UIST, revus par pairs) — mais article de conception sans mesure contrôlée : à peser comme un avis d'expert
- Source : Bay-Wei Chang & David Ungar, 1993, « Animation: From Cartoons to the User Interface », UIST '93 (pp. 45–55 selon l'entrée bibliographique), https://courses.ischool.berkeley.edu/i247/s08/readings/Chang_AnimationInUI_UIST93.pdf
- Extrait lu : « User interfaces are often based on static presentations, a model ill suited for conveying change. » ; « Self objects arrive and depart smoothly, without sudden materializations and disappearances » ; en conclusion : « Further study is needed to more fully determine what are the useful boundaries of animation in the user interface »
- Portée / limites : PDF scanné (couche texte en partie corrompue) ; retour d'expérience sur l'interface du langage Self, avec observations d'usagers mais sans expérience contrôlée ni échantillon. Les auteurs notent que les défauts d'une animation dérangent davantage qu'un défaut sur un objet statique.
- En conception visuelle : un élément « pop »-t-il sans transition alors qu'il change de place ou d'état ? Une animation saccadée (perte d'images) détruit-elle l'effet recherché ?

### Pour un changement complexe (graphique, réorganisation), une transition animée aide à suivre les éléments ; la découper en étapes simples et la faire « aussi longue que nécessaire, pas plus » (~1 s dans ce contexte)
- Niveau de preuve : N2
- Source : Jeffrey Heer & George G. Robertson, 2007, « Animated Transitions in Statistical Data Graphics », IEEE InfoVis 2007, https://idl.cs.washington.edu/files/2007-AnimatedTransitions-InfoVis.pdf
- Extrait lu : « Two controlled experiments were conducted to assess the efficacy of various transition types, finding that animated transitions can significantly improve graphical perception. » ; « Make transitions as long as needed, but no longer. » ; « The results of Robertson et al [21] recommend transition times around 1 second, though transitions with minimal movement can likely be performed faster. Empirical testing may be needed to determine optimal parameters. »
- Portée / limites : 24 sujets (26 à 62 ans), transitions de 1,25 s (expérience 1) et 2 s (expérience 2) entre graphiques statistiques. Les participants ont préféré l'animation par étapes (« staged ») ; plusieurs ont dit préférer des animations plus lentes. Ne se transpose pas directement aux micro-interactions d'un bouton.
- En conception visuelle : pour un tableau de bord qui se réorganise, l'œil peut-il suivre chaque élément ? Les changements d'échelle et de valeur sont-ils séparés ?

### Pour des objets qui se déplacent en nombre, préférer une accélération et une décélération symétriques (slow-in/slow-out) : c'est la seule loi d'accélération mesurée comme meilleure pour suivre un objet
- Niveau de preuve : N2
- Source : Pierre Dragicevic, Anastasia Bezerianos, Waqas Javed, Niklas Elmqvist & Jean-Daniel Fekete, 2011, « Temporal Distortion for Animated Transitions », CHI 2011, https://cs.au.dk/~elm/pdf/timedistort.pdf
- Extrait lu : « One informal design guideline for creating effective animated transitions has long been the use of slow-in/slow-out pacing, but no empirical data exist to support this practice. » ; « Slow-in/slow-out outperformed other techniques, but we saw technique differences depending on the type of visual transition. »
- Portée / limites : 12 participants (étudiants), tâche de suivi d'objets dans des nuages de points, transitions fixées à 1 s. Compare vitesse constante, slow-in/slow-out, fast-in/fast-out et vitesse adaptative — pas ease-out seul contre ease-in seul. Ne dit rien sur la durée optimale.
- En conception visuelle : quand plusieurs éléments bougent ensemble, la courbe ralentit-elle aux deux extrémités ? Le « ease-out partout » n'a pas été testé ici.

### Une transition animée fait attendre : quand l'utilisateur sait déjà ce qui va se passer, montrer le résultat tout de suite et expliquer le changement après coup (traînée, « afterglow »)
- Niveau de preuve : N2
- Source : Patrick Baudisch, Desney Tan, Maxime Collomb, Dan Robbins, Ken Hinckley, Maneesh Agrawala, Shengdong Zhao & Gonzalo Ramos, 2006, « Phosphor: Explaining Transitions in the User Interface Using Afterglow Effects », UIST '06, https://hal-lirmm.ccsd.cnrs.fr/lirmm-00128259/document
- Extrait lu : « Animated transitions can help, but they force users to wait for the animation to complete. This can be cumbersome, especially in situations where users did not need an explanation. » ; « users completing the task faster with the phosphor interface (Med=7.17 s) than with the control interface (Med=9.35 s). »
- Portée / limites : étude rapportée ici sur 12 étudiants (24–30 ans, 1 femme), tâche de collaboration simulée ; pas d'effet significatif sur le taux d'erreur ; les 12 ont préféré l'interface phosphor. Deux études au total selon le résumé ; seule celle-ci a été lue en détail.
- En conception visuelle : l'animation retarde-t-elle le résultat pour un utilisateur expérimenté ? Peut-on afficher l'état final immédiatement et laisser une trace visuelle du changement ?

### Les chiffres de Material 3 Expressive (« jusqu'à 4 fois plus rapide ») sont une recherche d'éditeur non revue, avec ses propres réserves : ne pas briser les motifs établis
- Niveau de preuve : N3 (publication officielle de la plateforme, non revue par des pairs)
- Source : Google Design, sans date sur la page, « Expressive Design: Google's UX Research » (titre de page non relevé exactement), https://design.google/library/expressive-material-design-google-research
- Extrait lu : 46 études, plus de 18 000 participants ; éléments clés repérés « up to four times faster » ; « What works in a media player or email app might not be suitable for something like a banking interface. »
- Portée / limites : méthodes citées (oculométrie, enquêtes, tests d'utilisabilité) sans protocole détaillé ni échantillon par étude. La page rapporte elle-même des échecs : une liste d'albums sans structure verticale et la suppression des libellés d'actions ont dégradé l'utilisabilité ; une minorité forte préférait des versions plus calmes. Le mouvement y est cité comme un des cinq leviers, sans résultat propre au mouvement.
- En conception visuelle : l'expressivité ajoutée (taille, forme, mouvement) respecte-t-elle les motifs attendus du domaine ? Dans une interface métier ou financière, la sobriété reste-t-elle le défaut ?

---

## 2. Mouvement et accessibilité

### Tout contenu qui bouge, clignote ou défile automatiquement plus de 5 s à côté d'autre contenu doit pouvoir être mis en pause, arrêté ou masqué ; rien ne doit flasher plus de 3 fois par seconde au-delà des seuils
- Niveau de preuve : N1
- Source : W3C (Campbell, Adams, Bradley Montgomery, Cooper, Kirkpatrick, éd.), version du 12 décembre 2024, « Web Content Accessibility Guidelines (WCAG) 2.2 » — critères 2.2.2 (A) et 2.3.1 (A), https://www.w3.org/TR/WCAG22/
- Extrait lu : 2.2.2 : « For any moving, blinking or scrolling information that (1) starts automatically, (2) lasts more than five seconds, and (3) is presented in parallel with other content, there is a mechanism for the user to pause, stop, or hide it unless the movement, blinking, or scrolling is part of an activity where it is essential » ; 2.3.1 : « Web pages do not contain anything that flashes more than three times in any one second period, or the flash is below the general flash and red flash thresholds. »
- Portée / limites : niveau A, les deux sont soumis à l'exigence de non-interférence (toute la page). 2.2.2 ne vise que le mouvement automatique de plus de 5 s : une micro-interaction déclenchée par l'utilisateur n'y est pas soumise. Le seuil « general flash » est défini (variation de luminance relative de 10 % ou plus, surface au-delà de 0,006 stéradian).
- En conception visuelle : carrousel, bandeau défilant, fond vidéo, indicateur en boucle : y a-t-il un contrôle de pause visible ? Une alerte qui clignote reste-t-elle sous 3 flashs par seconde ?

### Le mouvement déclenché par une interaction doit pouvoir être désactivé (AAA) ; les changements de couleur et d'opacité ne sont pas du « mouvement » au sens du critère
- Niveau de preuve : N1
- Source : W3C, 2024, « WCAG 2.2 » — critère 2.3.3 Animation from Interactions (AAA), https://www.w3.org/TR/WCAG22/ ; W3C/WAI, « Understanding Success Criterion 2.3.3: Animation from Interactions », https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html
- Extrait lu : « Motion animation triggered by interaction can be disabled, unless the animation is essential to the functionality or the information being conveyed. » ; « Vestibular (inner ear) disorder reactions include dizziness, nausea and headaches. » ; « Motion animation does not include changes of color, blurring, or opacity. »
- Portée / limites : niveau AAA, donc hors conformité AA courante. La page Understanding signale un erratum qui retire le flou (« blurring ») de cette exclusion : le flou animé est désormais à traiter comme du mouvement. Elle ne donne aucun chiffre de prévalence.
- En conception visuelle : l'alternative en mouvement réduit remplace-t-elle les translations, zooms et parallaxes par des fondus ? Une animation « essentielle » l'est-elle vraiment ?

### Brancher le mouvement sur `prefers-reduced-motion` : écrire l'animation sous `no-preference`, ou la neutraliser sous `reduce` ; la fonctionnalité est disponible partout depuis janvier 2020, mais la spécification reste un brouillon
- Niveau de preuve : N1 (spécification W3C au stade Working Draft, technique WCAG) ; N3 (MDN pour le support)
- Source : W3C CSSWG (Rivoal, Atkins, Libby, Warlow, éd.), 19 février 2026, « Media Queries Level 5 » (W3C Working Draft), https://www.w3.org/TR/mediaqueries-5/ ; W3C/WAI, « C39: Using the CSS prefers-reduced-motion query to prevent motion », https://www.w3.org/WAI/WCAG22/Techniques/css/C39 ; MDN, « prefers-reduced-motion », https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion
- Extrait lu : MQ5 : « reduce Indicates that user has notified the system that they prefer an interface that removes or replaces the types of motion-based animation that either trigger discomfort for those with vestibular motion sensitivity, or distraction for those with attention deficits. » ; MDN : « It's been available across browsers since January 2020. » ; C39 : « Check that the motion animation is suppressed. »
- Portée / limites : `reduce` signifie « supprimer ou remplacer », pas forcément « aucune animation ». Le test de C39 accepte une animation essentielle. Media Queries 5 est un Working Draft (pas une Recommandation), mais le support navigateur est « Baseline widely available » selon MDN.
- En conception visuelle : la maquette prévoit-elle une variante « mouvement réduit » pour chaque transition spatiale ? Préfère-t-on activer le mouvement sous `no-preference` (défaut sûr) plutôt que de le retirer sous `reduce` ?

### Sous « Réduire les animations » : remplacer les translations par des fondus, raidir les ressorts, supprimer zooms, profondeur et flous animés
- Niveau de preuve : N3
- Source : Apple, sans date (consulté le 09.11.2026), « Accessibility » — Human Interface Guidelines, https://developer.apple.com/design/human-interface-guidelines/accessibility (texte lu via https://developer.apple.com/tutorials/data/design/human-interface-guidelines/accessibility.json)
- Extrait lu : « When this setting is active, ensure your app or game responds by reducing automatic and repetitive animations, including zooming, scaling, and peripheral motion. » ; « Tightening animation springs to reduce bounce effects » ; « Replacing transitions in x-, y-, and z-axes with fades to avoid motion » ; « Avoiding animating into and out of blurs »
- Portée / limites : guideline de plateforme Apple ; elle rejoint le W3C pour les fondus, et le W3C (erratum de 2.3.3) pour le flou.
- En conception visuelle : la version « mouvement réduit » est-elle conçue (fondus, ressorts amortis), ou simplement coupée au risque de casser la compréhension du changement d'état ?

### Ne pas citer « 35 % des adultes ont un trouble vestibulaire » comme le nombre de personnes gênées par les animations : ce chiffre mesure l'équilibre debout chez les 40 ans et plus aux États-Unis
- Niveau de preuve : N2
- Source : Yuri Agrawal, John P. Carey, Charles C. Della Santina, Michael C. Schubert & Lloyd B. Minor, 2009, « Disorders of balance and vestibular function in US adults: data from the National Health and Nutrition Examination Survey, 2001-2004 », Archives of Internal Medicine 169(10):938-44 — résumé seul lu, via l'API PubMed : https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=19468085&rettype=abstract&retmode=text (notice : https://pubmed.ncbi.nlm.nih.gov/19468085/) ; Hannelore K. Neuhauser et al., 2005, « Epidemiology of vestibular vertigo: a neurotologic survey of the general population », Neurology 65(6):898-904 — résumé seul lu : https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=16186531&rettype=abstract&retmode=text
- Extrait lu : Agrawal : « 35.4% of US adults aged 40 years and older (69 million Americans) had vestibular dysfunction » ; « The main outcome measure was vestibular function as measured by the modified Romberg Test of Standing Balance on Firm and Compliant Support Surfaces. » Neuhauser : « The lifetime prevalence of vestibular vertigo was 7.4[corrected]%, the 1-year prevalence was 4.9[corrected]% »
- Portée / limites : Agrawal : n = 5086, 40 ans et plus, un test postural, pas une mesure de sensibilité au mouvement à l'écran. Neuhauser : enquête allemande en population générale (4869 personnes dépistées, 1003 entretiens). Aucune des deux ne mesure la gêne causée par des animations d'interface ; aucune source lue ne donne ce chiffre.
- En conception visuelle : justifier le mode réduit par le critère WCAG et par le réglage système, pas par un pourcentage gonflé.

---

## 3. États des composants

### Tout composant utilisable au clavier doit avoir un indicateur de focus visible (AA), et le composant qui reçoit le focus ne doit pas être entièrement masqué par un contenu de l'auteur (AA, nouveau en 2.2)
- Niveau de preuve : N1
- Source : W3C, 2024, « WCAG 2.2 » — critères 2.4.7 et 2.4.11, https://www.w3.org/TR/WCAG22/ ; W3C/WAI, « Understanding Success Criterion 2.4.7: Focus Visible », https://www.w3.org/WAI/WCAG22/Understanding/focus-visible.html
- Extrait lu : 2.4.7 : « Any keyboard operable user interface has a mode of operation where the keyboard focus indicator is visible. » ; 2.4.11 : « When a user interface component receives keyboard focus, the component is not entirely hidden due to author-created content. » ; Understanding, technique suffisante G165 : « Using the default focus indicator for the platform so that high visibility default focus indicators will carry over » ; échec F78 : « styling element outlines and borders in a way that removes or renders non-visible the visual focus indicator »
- Portée / limites : 2.4.7 ne fixe ni taille ni contraste ; le contraste vient de 1.4.11 (AA). L'indicateur par défaut du navigateur est une technique suffisante (G165). 2.4.11 vise les bandeaux collants, pieds de page fixes et bannières de cookies qui recouvrent l'élément ciblé.
- En conception visuelle : `outline: none` sans remplacement ? En-tête ou pied de page collant qui recouvre le champ actif quand on tabule ?

### Un indicateur de focus conçu sur mesure doit atteindre au moins l'aire d'un contour de 2 px autour du composant, avec un changement de contraste de 3:1 entre état focalisé et non focalisé (AAA) — et 3:1 face aux couleurs adjacentes (AA)
- Niveau de preuve : N1
- Source : W3C, 2024, « WCAG 2.2 » — critère 2.4.13 Focus Appearance (AAA), https://www.w3.org/TR/WCAG22/ ; W3C/WAI, « Understanding Success Criterion 2.4.13: Focus Appearance », https://www.w3.org/WAI/WCAG22/Understanding/focus-appearance.html
- Extrait lu : « is at least as large as the area of a 2 CSS pixel thick perimeter of the unfocused component or sub-component, and has a contrast ratio of at least 3:1 between the same pixels in the focused and unfocused states. » ; exceptions : « The focus indicator is determined by the user agent and cannot be adjusted by the author, or The focus indicator and the indicator's background color are not modified by the author. » ; exemple : « (92px * 32px) - (88px * 28px) = 480px2 »
- Portée / limites : niveau AAA. Il s'agit d'un contraste de *changement* (mêmes pixels avant/après), distinct du contraste *adjacent* de 1.4.11. Un contour intérieur (inset) doit faire au moins 3 px. Les ombres et halos extérieurs ne comptent pas dans le périmètre du composant. Point clé : l'indicateur natif non modifié est exempté — c'est en le personnalisant qu'on s'expose au critère.
- En conception visuelle : le focus « designé » est-il au moins aussi visible que celui du navigateur ? Un halo gris clair sur fond blanc, ou un simple changement de teinte de fond, passe-t-il 3:1 ?

### Les états des composants (focus, sélection, coché) et leurs limites doivent contraster à 3:1 avec les couleurs adjacentes ; les composants inactifs en sont exemptés
- Niveau de preuve : N1
- Source : W3C, 2024, « WCAG 2.2 » — critère 1.4.11 Non-text Contrast (AA), https://www.w3.org/TR/WCAG22/
- Extrait lu : « Visual information required to identify user interface components and states, except for inactive components or where the appearance of the component is determined by the user agent and not modified by the author »
- Portée / limites : vise ce qui est *nécessaire* pour identifier le composant et son état ; un bouton défini seulement par son libellé n'a pas besoin de bordure. Exemption pour les composants inactifs et l'apparence native non modifiée.
- En conception visuelle : l'état « coché » ou « sélectionné » se distingue-t-il à 3:1, sans dépendre de la seule couleur ? Un champ dont la seule limite est une bordure gris pâle est-il repérable ?

### Styler le focus avec `:focus-visible` (heuristique du navigateur : clavier oui, clic de souris sur un bouton non, champ de saisie toujours), disponible partout depuis mars 2022
- Niveau de preuve : N1 (Selectors Level 4, Working Draft) ; N3 (MDN)
- Source : W3C CSSWG, 22 janvier 2026, « Selectors Level 4 » (W3C Working Draft), § 9.4, https://www.w3.org/TR/selectors-4/ ; MDN, « :focus-visible », https://developer.mozilla.org/en-US/docs/Web/CSS/:focus-visible
- Extrait lu : Selectors 4 : « If the user interacts with the page via keyboard or some other non-pointing device, indicate focus. » ; « If the user interacts with the page via a pointing device (mouse, touchscreen, etc.) and the focused element does not support keyboard input, don't indicate focus. » MDN : « It's been available across browsers since March 2022. »
- Portée / limites : la spécification est au stade Working Draft, mais la fonctionnalité est « Baseline widely available ». MDN signale un risque pour les utilisateurs aux entrées mixtes : l'indicateur qui apparaît et disparaît peut dérouter.
- En conception visuelle : l'indicateur est-il porté par `:focus-visible` (pas de halo parasite au clic de souris), sans supprimer le focus pour les utilisateurs du clavier ?

### Ne jamais faire dépendre une information ou une action du survol : sur écran tactile, `:hover` peut ne jamais s'appliquer
- Niveau de preuve : N1
- Source : W3C CSSWG, 19 février 2026, « Media Queries Level 4 » (Candidate Recommendation Draft), § « hover », https://www.w3.org/TR/mediaqueries-4/ ; W3C CSSWG, 2026, « Selectors Level 4 », § 9.1, https://www.w3.org/TR/selectors-4/ ; W3C, 2024, « WCAG 2.2 » — 1.4.13, https://www.w3.org/TR/WCAG22/
- Extrait lu : MQ4 : « Authors should therefore be careful not to assume that the :hover pseudo-class will never match on a device where hover: none is true, but they should design layouts that do not depend on hovering to be fully usable. » ; Selectors 4 : « Interactive user agents that cannot detect hovering due to hardware limitations (e.g., a pen device that does not detect hovering) are still conforming; the selector will simply never match in such a UA. » ; WCAG 1.4.13 (AA) : le contenu révélé au survol ou au focus doit être « Dismissible », « Hoverable », « Persistent ».
- Portée / limites : l'état hover reste utile sur pointeur fin ; c'est la *dépendance* au survol qui est en cause. Avec `@media (hover: hover)`, on peut ne servir les effets de survol qu'aux appareils qui les supportent.
- En conception visuelle : une action révélée au survol (icône « supprimer » d'une ligne, menu) a-t-elle un équivalent visible sur tactile ? Une infobulle survolée peut-elle être fermée avec Échap et survolée elle-même ?

### Concevoir les états du bouton comme un jeu complet : enabled, hover, focus, pressed, disabled, plus « loading » (indicateur ajouté à l'état actif) ; focus quasi immédiat, hover légèrement retardé
- Niveau de preuve : N4
- Source : Kelley Gordon (NN/g), 2025 (25 avril, date non relue sur la page elle-même), « Button States: Communicate Interaction », https://www.nngroup.com/articles/button-states-communicate-interaction/
- Extrait lu : « The loading state typically uses the enabled state and adds a loading spinner or indicator to the left of the button label. » ; « The focus state should appear pretty quickly (around 100-150ms) after the user uses the keyboard. » ; pour le hover : « a slight delay (around 150–200ms) should be added to this state. » ; « Labels for disabled states don't need to be as high-contrast as those for enabled states, »
- Portée / limites : recommandations de praticien, sans étude citée pour les délais. L'article note que le hover n'est pas visible sur mobile et recommande un contour plutôt que la seule couleur pour le focus. Le délai de survol de 150–200 ms est son conseil propre ; pas de source primaire trouvée.
- En conception visuelle : le bouton en chargement garde-t-il sa largeur (pas de saut de mise en page) et empêche-t-il la double soumission ? Chaque état est-il distinct sans dépendre de la seule couleur ?

### Un bouton désactivé est exempté de contraste, mais l'exemption n'en fait pas un bon motif : il n'explique pas pourquoi, il est souvent illisible et hors de portée du clavier
- Niveau de preuve : N1 (exemption) ; N4 (critique du motif)
- Source : W3C/WAI, « Understanding Success Criterion 1.4.3: Contrast (Minimum) », https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html ; Vitaly Friedman, 2021 (5 août), « Frustrating Design Patterns: Disabled Buttons », Smashing Magazine, https://www.smashingmagazine.com/2021/08/frustrating-design-patterns-disabled-buttons/
- Extrait lu : W3C : composants inactifs « are not required to meet contrast requirements » ; WCAG 1.4.3 : texte « part of an inactive user interface component […] have no contrast requirement ». Friedman : « Disabled buttons don't explain what's wrong. » ; « usually disabled buttons are not focusable and hence users can't reach them with a keyboard. »
- Portée / limites : l'exemption est normative ; la critique est un avis de praticien sans données (pas d'étude citée). Friedman recommande, si le désactivé est inévitable, de le laisser focalisable (`aria-disabled`) et d'expliquer la raison.
- En conception visuelle : ce bouton grisé doit-il vraiment l'être ? Laisser le bouton actif et valider à la soumission, ou expliquer la condition manquante à côté.

### Pour garantir un focus visible sur tous les fonds, combiner une couleur claire et une couleur sombre (exemple GOV.UK : jaune + barre noire épaisse)
- Niveau de preuve : N3
- Source : GOV.UK Design System (Government Digital Service), sans date, « Focus states », https://design-system.service.gov.uk/get-started/focus-states/ ; « Colour », https://design-system.service.gov.uk/styles/colour/
- Extrait lu : « Focus states in the GOV.UK Design System use a combination of yellow and black, along with a thick bottom border » ; « The yellow has a high contrast with dark backgrounds » ; « the thick black border has a high contrast against light backgrounds » ; couleur de focus : « Only use this colour to indicate which element is focused on. »
- Portée / limites : solution d'un système public, conçue pour satisfaire 1.4.11 sur tous les fonds du site. La page ne mentionne pas `:focus-visible`.
- En conception visuelle : l'indicateur de focus reste-t-il visible sur chaque fond du produit (clair, sombre, image, couleur de marque) ? La couleur du focus est-elle réservée au focus ?

---

## 4. Design tokens

### Échanger les jetons au format DTCG 2025.10 (JSON `$value` / `$type`, alias `{groupe.jeton}`, extension `.tokens`), première version stable du 28 octobre 2025 — un rapport de groupe communautaire, pas une norme W3C
- Niveau de preuve : N3 (spécification d'un groupe communautaire W3C, hors voie de normalisation)
- Source : Design Tokens Community Group (Chenais, McMahon, Powers, Ström-Awn, Vitan et al., éd.), 2025 (28 octobre), « Design Tokens Technical Reports 2025.10 » (modules Format, Color, Resolver), https://www.designtokens.org/tr/2025.10/ et https://www.designtokens.org/tr/2025.10/format/ ; annonce : https://www.w3.org/community/design-tokens/2025/10/28/design-tokens-specification-reaches-first-stable-version/
- Extrait lu : « It is not a W3C Standard nor is it on the W3C Standards Track. » ; « This specification is considered stable. » ; « Tools MUST NOT attempt to guess the type of a token by inspecting the contents of its value. » ; module Resolver : « describes a method to work with design tokens in multiple contexts (such as "light mode" and "dark mode" color themes). »
- Portée / limites : en-tête « Final Community Group Report, 28 October 2025 » ; le texte dit aussi qu'il a été publié « as a Candidate Recommendation following the definitions provided by the W3C process ». Type MIME préféré `application/design-tokens+json`. L'adoption par les outils n'a pas été vérifiée ici.
- En conception visuelle : les jetons du projet sont-ils typés explicitement et exportables dans ce format ? Le thème sombre est-il un contexte du résolveur plutôt qu'un fichier dupliqué ?

### Structurer les jetons en trois niveaux : référence (valeurs brutes), système (rôles et décisions), composant (attributs d'un composant, pointant vers le système)
- Niveau de preuve : N3
- Source : Google / Material Web, sans date (fichier `docs/theming/README.md`, branche main), « Theming », https://raw.githubusercontent.com/material-components/material-web/main/docs/theming/README.md
- Extrait lu : « Reference tokens hold concrete values, such as a hex color, pixel size, or font family name. » ; « System tokens define decisions and roles that give the design system its character » ; « Each component token maps to a system token, which has a concrete reference value. » ; « They can be system tokens or concrete values. »
- Portée / limites : architecture d'un système de plateforme. Material admet qu'un jeton de composant prenne une valeur concrète : la règle « jamais de primitif dans un composant » est plus stricte que Material.
- En conception visuelle : un composant consomme-t-il `--md-sys-color-primary` (rôle) ou `#6750A4` (valeur) ? Un changement de thème se fait-il en remappant le niveau système seul ?

### Nommer les jetons par leur rôle, pour qu'un même nom prenne une autre valeur dans chaque thème (clair, sombre, contraste élevé) ; ne jamais choisir un jeton parce que sa couleur « tombe juste »
- Niveau de preuve : N3
- Source : IBM, sans date, « Color — Overview », Carbon Design System, https://carbondesignsystem.com/elements/color/overview/ ; Atlassian, sans date, « Design tokens », Atlassian Design System, https://atlassian.design/foundations/tokens/design-tokens ; IBM, « Color tokens », https://carbondesignsystem.com/elements/color/tokens/
- Extrait lu : Carbon : « Unlike hex codes, tokens apply universally across themes. » ; « Color token names and roles are the same across themes, only the assigned value will change with the theme. » Atlassian : « Choose tokens based on meaning where applicable, not specific values. » ; « Don't use a token just because the colors appear to match. This can break the experience in other themes. » Carbon (jetons de composant) : « should never be used for anything other than their own component. »
- Portée / limites : consensus de grands systèmes (quatre thèmes Carbon : White, Gray 10, Gray 90, Gray 100), sans étude empirique de l'effet. C'est la justification pratique la plus solide : le jeton sémantique est ce qui rend le thème sombre possible sans réécrire les composants.
- En conception visuelle : en basculant en thème sombre, un composant casse-t-il parce qu'il utilise un jeton choisi pour sa valeur et pas pour son rôle ?

### Ne jamais recopier les valeurs hexadécimales d'un système ; mais un jeton fonctionnel ne s'emploie que dans son contexte prévu, et la palette se référence directement ailleurs
- Niveau de preuve : N3
- Source : GOV.UK Design System, sans date, « Colour », https://design-system.service.gov.uk/styles/colour/
- Extrait lu : « Do not copy the specific hexadecimal (hex) colour values. » ; « Only use the variables in the context they're designed for. » ; « In all other cases, you should reference the GOV.UK web palette directly. »
- Portée / limites : nuance importante face à « toujours sémantique » : GOV.UK autorise l'usage direct de la *palette* (jeton primitif nommé, pas la valeur hex) pour les illustrations et les composants sur mesure.
- En conception visuelle : y a-t-il des hex en dur dans les composants ? Un jeton « erreur » est-il détourné pour décorer ?

---

## 5. Design systems : preuves d'effet

### Les preuves chiffrées de gain de vitesse viennent d'études minuscules : 47 % plus rapide sur un formulaire, 8 développeurs, sans contrebalancement de l'ordre
- Niveau de preuve : N4
- Source : Sparkbox, sans date ni auteur sur la page, « Yes, Design Systems Do Improve Developer Efficiency and Design Consistency », https://sparkbox.com/foundry/design_system_roi_impact_of_design_systems_business_value_carbon_design_system
- Extrait lu : « Using a design system made a simple form page 47% faster to develop versus coding it from scratch. » ; « This was a small study of a handful of excellent developers. » ; « Two developers' scratch submissions bested the design system for accessibility. » ; « Only one developer's scratch coding soundly beat their design system submission. »
- Portée / limites : 8 développeurs d'une agence, un seul formulaire de contact, médiane 2 h (Carbon) contre 4,2 h (de zéro), toujours de zéro d'abord puis avec Carbon (effet d'ordre possible), notation subjective par 8 relecteurs internes. Gain de cohérence visuelle net ; gain d'accessibilité non établi.
- Source complémentaire (même éditeur) : Sparkbox, 2022, « Design Systems Survey 2022 », https://designsystemssurvey.seesparkbox.com/2022 — « Of the 219 responses, 183 spent most of their time as a creator or maintainer of a design system while 37 spent most of their time as a user or subscriber. » ; « We shared this survey for four weeks across our social media network, in Slack channels, with visitors to the Sparkbox website, and in emails to web professionals. » ; contenu des systèmes : « 57% Accessibility guidelines ». Enquête diffusée par les canaux de l'agence, sans tirage aléatoire (constat tiré de la méthode décrite, la page ne le dit pas en ces termes) ; 183 + 37 = 220 pour 219 réponses annoncées (incohérence de la source) ; les liens « pratique ↔ succès » sont déclaratifs, non causaux. Elle décrit des pratiques, pas des effets.
- En conception visuelle : ne pas promettre d'accessibilité « gratuite » par la bibliothèque : l'auditer comme le reste. Le système utilisé documente-t-il l'accessibilité de chaque composant (seuls 57 % des répondants Sparkbox en ont) ?

### La recherche académique sur les design systems reste mince et qualitative ; elle relève surtout la tension entre standardisation et souplesse
- Niveau de preuve : N4 (prépublication arXiv non revue, 9 entretiens)
- Source : Yassine Lamine & Jinghui Cheng, 2022, « Understanding and Supporting the Design Systems Practice », arXiv:2205.10713, https://arxiv.org/pdf/2205.10713
- Extrait lu : « there is very little research work on the design system practice until very recently » ; « leaders of design system projects faced considerable challenges when evolving their design systems to make them both capable of capturing stable design knowledge and flexible to the needs of the various concrete products. »
- Portée / limites : 9 responsables de design systems (tous des hommes, 9 entreprises), entretiens d'août à octobre 2019, plus une analyse des tickets de 41 dépôts. Bénéfices *déclarés* : efficacité (7 sur 9), cohérence (5 sur 9). Aucune mesure d'effet.
- En conception visuelle : quand un besoin produit ne rentre pas dans le système, le remonter (évolution du système) plutôt que de bricoler localement ou de le contourner sans trace.

### La cohérence interne a un effet mesuré, mais plus modeste qu'on ne le dit : elle réduit en partie les erreurs, pas forcément le temps ni l'insatisfaction ; son mécanisme est le transfert d'apprentissage
- Niveau de preuve : N2 (résumés seuls lus)
- Source : A. Ant Ozok & Gavriel Salvendy, 2000, « Measuring consistency of web page design and its effects on performance and satisfaction », Ergonomics 43(4):443-60 — résumé seul lu : https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=10801079&rettype=abstract&retmode=text ; Peter G. Polson, Elizabeth Muncher & George Engelbeck, 1986, « A test of a common elements theory of transfer », CHI '86 (DOI 10.1145/22627.22352) — résumé seul lu via OpenAlex : https://api.openalex.org/works/https://doi.org/10.1145/22627.22352
- Extrait lu : Ozok & Salvendy : « The results partially support the hypothesis regarding error rate, but not regarding satisfaction and performance time. » ; « a four-group, between-subject design, with 10 participants in each group ». Polson et al. : « This paper presents a model for positive transfer and thus a theoretical definition of consistency. » ; « The experimental manipulations produced large transfer effects. »
- Portée / limites : Ozok & Salvendy : 40 participants, pages web de l'an 2000. Polson et al. : tâches utilitaires des années 1980, modèle expliquant 88 % de la variance de 31 moyennes de cellules ; taille d'échantillon non lue. Ce sont des preuves sur la cohérence d'interface, pas sur les design systems en tant que tels.
- En conception visuelle : la même action a-t-elle la même forme, la même place et le même nom partout ? Le gain attendu porte d'abord sur les erreurs et l'apprentissage.

### Identifier de la même façon les composants de même fonction, et garder la navigation répétée dans le même ordre (AA)
- Niveau de preuve : N1
- Source : W3C, 2024, « WCAG 2.2 » — critères 3.2.3 et 3.2.4, https://www.w3.org/TR/WCAG22/
- Extrait lu : 3.2.3 : « Navigational mechanisms that are repeated on multiple web pages within a set of web pages occur in the same relative order each time they are repeated, unless a change is initiated by the user. » ; 3.2.4 : « Components that have the same functionality within a set of web pages are identified consistently. »
- Portée / limites : seule exigence normative de cohérence trouvée ; elle porte sur l'ordre et l'identification (nom, icône, libellé), pas sur l'esthétique.
- En conception visuelle : la même icône ou le même libellé désigne-t-il la même fonction d'un écran à l'autre ?

---

## 6. Composants et conventions

### Respecter les conventions de placement : logo en haut à gauche (mieux mémorisé), et pas de logo centré si c'est lui qui ramène à l'accueil
- Niveau de preuve : N4 (études quantitatives d'un cabinet, non revues ; échantillons cités)
- Source : Kathryn Whitenton (NN/g), 2016 (21 février), « Website Logo Placement for Maximum Brand Recall », https://www.nngroup.com/articles/logo-placement-brand-recall/ ; Kathryn Whitenton (NN/g), 2016 (10 juillet), « Centered Logos Hurt Website Navigation », https://www.nngroup.com/articles/centered-logos/
- Extrait lu : « Users are 89% more likely to remember logos shown in the traditional top-left position than logos placed on the right. » ; « users were 6 times as likely to fail to navigate to the homepage in a single click » (logo centré contre logo à gauche)
- Portée / limites : rappel : 128 utilisateurs, 4 sites d'hôtels, rappel assisté, 39 % contre 21 % (khi-deux, p < 0,05). Navigation : 50 utilisateurs, 14 sites de mode, test à distance. Le logo centré ne réduisait pas significativement le rappel de la marque.
- En conception visuelle : un écart à une convention de placement est-il justifié par un gain mesuré, ou par la seule originalité ?

### Les éléments cliquables doivent porter un signifiant visible ; des signifiants faibles (boutons fantômes, liens identiques au texte) coûtent ~22 % de temps de repérage
- Niveau de preuve : N4 (étude oculométrique d'un cabinet, non revue ; échantillon cité)
- Source : Kate Moran (NN/g), 2017 (3 septembre), « Flat UI Elements Attract Less Attention and Cause Uncertainty », https://www.nngroup.com/articles/flat-ui-less-attention-cause-uncertainty/ ; Kate Moran (NN/g), 2017 (12 mars), « Flat-Design Best Practices », https://www.nngroup.com/articles/flat-design-best-practices/
- Extrait lu : « Designs with weak clickability signifiers waste users' time. » ; versions fortes obtenues en « adding shadows, gradients, and text treatments », avec des « slightly 3D style buttons » contre des « flat ghost buttons instead » ; « Avoid ghost buttons — text with a thin rectangular outline. »
- Portée / limites : 71 utilisateurs, 9 pages de 6 domaines, entre sujets ; environ 22 % de temps et 25 % de fixations en plus. L'auteure précise « This experiment was not a usability study » : repérage d'un seul élément. Les signifiants forts combinaient ombres, dégradés et soulignement : on ne peut pas isoler l'effet de l'ombre. La consigne « Avoid ghost buttons » n'est appuyée par aucune étude propre dans « Flat-Design Best Practices ».
- En conception visuelle : un bouton secondaire en simple contour fin se repère-t-il au premier regard ? Un lien se distingue-t-il du texte par autre chose que sa couleur ?

### Personnaliser une bibliothèque de composants a un coût : chaque modification de structure peut casser les mises à jour et dégrader l'accessibilité ; privilégier les classes et jetons prévus, forker seulement les grands écarts
- Niveau de preuve : N3
- Source : GOV.UK Design System, sans date, « Extending and modifying components in production », https://design-system.service.gov.uk/get-started/extending-and-modifying-components/
- Extrait lu : modifier des composants « create[s] potential risk » ; surcharger les sélecteurs « will work in the short term but may break if you install an update relying on the component's previous behaviour. » ; « Check the styles section to see if there's a CSS class you can use before adding CSS to your service. » ; « Make sure any modified components meet accessibility standards »
- Portée / limites : point de vue d'un système public qui vise la cohérence entre services ; une marque commerciale a d'autres objectifs. Rejoint le constat de Google (entrée Expressive) : briser les motifs établis a dégradé l'utilisabilité.
- En conception visuelle : la personnalisation passe-t-elle par les jetons (couleur, typo, rayon) ou réécrit-elle la structure et le comportement du composant ? Chaque modification a-t-elle été revérifiée au clavier et au lecteur d'écran ?

---

## Verdict sur les règles du profil

| Règle actuelle | Verdict | Motif sourcé |
|---|---|---|
| « Micro-interactions : 150-250ms ease-out. Interdit : animations > 400ms. » | **Soutenue en partie ; l'interdiction est contredite** | La plage 150–250 ms tient dans la plage de NN/g (100–500 ms, N4), mais NN/g place les retours simples vers 100 ms : 150 ms comme plancher est arbitraire. L'interdiction au-delà de 400 ms est contredite : Material 3 prévoit des jetons de 450 à 1000 ms pour les grands déplacements (« duration should increase as the area/traversal… increases », N3) ; la recherche sur les transitions de données utilise et recommande ~1 s (Heer & Robertson 2007 ; Dragicevic et al. 2011, N2). Le seuil documenté est 500 ms (« real drag », NN/g), et il vise les interfaces courantes. Les ressorts (M3 Expressive) n'ont pas de durée fixe. Reformulation proposée : « micro-interactions 100–200 ms ; transitions d'écran 200–300 ms ; au-delà de 500 ms, justification écrite (transition de données, plein écran) ». |
| « Motion : ease-out pour les entrées, ease-in pour les sorties ; le motion explique un changement d'état, jamais de la décoration. `prefers-reduced-motion` respecté. » | **Soutenue (convention de plateforme) ; preuve empirique partielle** | Entrée décélérée / sortie accélérée : c'est la doctrine Material 3 (N3) et NN/g (N4), mais aucune étude comparant ces courbes n'a été trouvée. La seule étude de courbes trouvée (Dragicevic 2011) donne l'avantage au slow-in/slow-out symétrique pour suivre des objets en mouvement. « Changement d'état, pas décoration » : soutenu par Apple et NN/g (N3/N4) et, empiriquement, par Heer 2007 (bénéfice de compréhension) ; Baudisch 2006 rappelle que l'animation fait attendre l'expert. `prefers-reduced-motion` : soutenu (WCAG 2.3.3 AAA, technique C39, N1). Précision à ajouter : « reduce » veut dire remplacer (fondus admis : la couleur et l'opacité ne sont pas du mouvement ; le flou l'est depuis l'erratum), pas forcément tout couper. |
| « États : hover, focus visible, active, disabled pour tout interactif. Focus visible designé (pas l'outline brut du navigateur). » | **Soutenue pour le focus ; à corriger pour le hover et sur « designé »** | Focus visible : exigence normative (2.4.7 AA), avec contraste par 1.4.11 (AA) et, en AAA, 2.4.13 (2 px, 3:1 de changement). Mais l'indicateur natif est une technique *suffisante* (G165) et il est *exempté* de 2.4.13 tant qu'il n'est pas modifié : imposer un focus « designé » n'est pas exigé et crée le risque d'échec (F78) s'il est moins visible. La règle devient : « focus personnalisé autorisé seulement s'il atteint au moins 2 px et 3:1 sur tous les fonds, via `:focus-visible` ». Hover : ne peut pas être un état requis « pour tout interactif » : sur tactile il ne s'applique jamais (MQ4, Selectors 4) ; aucune information ne doit en dépendre. Disabled : exempté de contraste (1.4.3, 1.4.11) mais critiqué comme motif (N4) ; ajouter loading (NN/g) et 2.4.11 (focus non masqué, AA). |
| « Tokens exposés aux composants sémantiques, pas primitifs. » | **Convention sans preuve empirique trouvée — mais soutenue par les grands systèmes** | Material 3 (référence → système → composant), Carbon et Atlassian (nommer par rôle ; jetons identiques d'un thème à l'autre) le recommandent (N3) ; c'est ce qui rend le thème sombre possible sans réécrire les composants (module Resolver DTCG 2025.10). Nuances : Material autorise des valeurs concrètes dans les jetons de composant ; GOV.UK autorise la palette directe hors contextes fonctionnels. Aucune étude d'effet. |
| « Ombres douces ou absentes. Préférer bordures. » | **Convention sans preuve trouvée ; à nuancer pour les éléments cliquables** | Aucune étude comparant ombres et bordures n'a été trouvée. La seule donnée proche (NN/g 2017, N4) montre que les versions *avec* ombres, dégradés et boutons légèrement 3D se repéraient plus vite que les versions plates et les boutons fantômes — effet confondu, l'ombre seule n'est pas isolée. Ce qui est normatif : la limite d'un composant, si elle est nécessaire à son identification, doit contraster à 3:1 (1.4.11) ; une bordure trop pâle échoue autant qu'une ombre trop douce. La règle tient pour la sobriété des surfaces, pas comme interdiction des signifiants de profondeur sur les boutons. |
| « Jamais une lib de composants laissée brute — toujours customisée. » | **Convention sans preuve ; en partie contredite** | Aucune source ne montre un bénéfice à personnaliser. GOV.UK (N3) prévient que modifier un composant expose aux ruptures de mise à jour et aux régressions d'accessibilité ; Sparkbox (N4, n = 8) mesure un gain de cohérence avec Carbon utilisé tel quel ; Google (N3) rapporte que briser des motifs établis a dégradé l'utilisabilité. Reformulation proposée : « thémer la bibliothèque par ses jetons (couleur, typographie, rayon, mouvement) ; ne modifier structure ou comportement qu'avec un besoin documenté, et revérifier l'accessibilité ». |

---

## Mythes et affirmations contestées

- **« 35 % des adultes souffrent de troubles vestibulaires, donc d'une sensibilité aux animations. »** Le 35,4 % d'Agrawal et al. 2009 concerne les Américains de 40 ans et plus, mesurés par un test d'équilibre (Romberg modifié), pas la gêne face au mouvement à l'écran. Chiffre plus prudent sur le vertige vestibulaire : 7,4 % sur la vie, 4,9 % sur un an (Neuhauser 2005, Allemagne). Aucun chiffre de prévalence « sensibilité aux animations d'interface » n'a été trouvé.
- **« L'ease-out est scientifiquement la meilleure courbe. »** Aucune étude trouvée ne compare ease-out et ease-in pour les entrées et sorties. La seule comparaison contrôlée trouvée (Dragicevic 2011) favorise le slow-in/slow-out symétrique, pour une tâche de suivi d'objets.
- **« Les animations ne doivent jamais dépasser 300/400 ms. »** Seuil de praticien (NN/g situe la gêne à 500 ms). Material prévoit jusqu'à 1000 ms ; la recherche sur les transitions de données utilise ~1 s.
- **« `prefers-reduced-motion` = aucune animation. »** La spécification dit « removes or replaces » ; WCAG exclut couleur et opacité de la définition du mouvement ; Apple recommande des fondus à la place des translations.
- **« Il faut toujours remplacer l'outline du navigateur. »** Faux : l'indicateur natif est une technique suffisante (G165) et il est exempté de 2.4.13 ; c'est en le modifiant qu'on s'expose à l'échec.
- **« Focus Appearance (2.4.13) est obligatoire en AA. »** Faux : 2.4.13 est AAA ; en AA, ce sont 2.4.7, 2.4.11 et 1.4.11.
- **« Un bouton désactivé doit atteindre 4,5:1. »** Faux : les composants inactifs sont exemptés (1.4.3, 1.4.11). Ce n'est pas pour autant un bon motif.
- **« La spécification DTCG est une norme W3C. »** Faux : « It is not a W3C Standard nor is it on the W3C Standards Track » ; c'est un rapport final de groupe communautaire (2025.10), déclaré stable.
- **« Un design system rend le développement 47 % plus rapide. »** Une seule page de formulaire, 8 développeurs, ordre non contrebalancé, temps d'apprentissage inclus (Sparkbox). À ne pas généraliser.
- **« Material 3 Expressive rend les interfaces 4 fois plus rapides. »** « Up to four times faster » sur certains éléments, issu d'une recherche d'éditeur sans protocole publié par étude ; la même page rapporte des pertes d'utilisabilité quand les motifs établis sont brisés.
- **« La cohérence fait gagner du temps. »** L'étude primaire lue (Ozok & Salvendy 2000, n = 40) ne confirme l'effet que partiellement sur les erreurs, ni sur le temps ni sur la satisfaction.

---

## Non vérifié

- **Klein & Bederson 2005, « Benefits of animated scrolling »** (CHI EA, DOI 10.1145/1056808.1057068) : les chiffres d'une synthèse de recherche (gain jusqu'à 3,1 % à 300 ms pour la lecture, jusqu'à 24 % à 500 ms, erreurs −54 %) n'ont pas pu être lus à la source (rapport HCIL et ACM inaccessibles, résumé masqué par l'éditeur). Non vérifié.
- **Teitelbaum & Granda 1983**, « The Effects of Positional Constancy on Searching Menus for Information » (CHI '83) : référence trouvée, ni résumé ni résultats lus. Non vérifié.
- **Pages m3.material.io** (Easing and duration, tokens, design tokens overview) et **m2.material.io** (Speed : durées par type d'appareil) : rendu JavaScript, contenu non lisible. Les valeurs Material citées viennent de la documentation Android officielle sur GitHub et de la référence Compose.
- **Wang 2018** (mémoire de master, Drexel) sur la durée perçue des animations de menu (25 participants selon un résumé de recherche) : non ouvert. Non vérifié.
- **Polaris (Shopify)** : la page des jetons redirige vers une nouvelle documentation, non lue. Aucune affirmation Polaris dans ce document.
- **Étude comparant ombres et bordures** pour l'affordance ou la lisibilité : aucune trouvée.
- **Étude primaire montrant qu'un design system améliore l'accessibilité** : aucune trouvée ; l'étude Sparkbox montre l'inverse pour 2 développeurs sur 8.
- **Taille d'échantillon de Polson et al. 1986** : non lue (résumé seul).
- **Date de publication** de la page de recherche Google sur Material 3 Expressive et de l'article Sparkbox sur Carbon : absentes des pages.
- **Date exacte** de l'article NN/g « Button States » (25 avril 2025) : donnée par l'outil de lecture, non relue à l'œil sur la page.

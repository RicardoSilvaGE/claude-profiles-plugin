# Fiche `ux-preuves` — Design visuel — perception et esthétique

> Fiche du skill `ux-preuves` (dev-fullstack), volet **design visuel**, préchargé par `designer`. Couvre : premières impressions, complexité visuelle et prototypicalité, crédibilité visuelle, signifiants (flat design), icônes, hiérarchie visuelle et saillance, Gestalt mesurée, images et photos, effets de style.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Verdict sur les règles
> du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées : ce qui y
> figure ne se cite pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche menée le 9 novembre 2026 pour le référentiel d'un agent « designer produit senior ».
> Toutes les entrées ci-dessous viennent d'une page ou d'un PDF **réellement ouvert** pendant cette
> recherche (PDF téléchargés puis lus avec `pdftotext`). Quand seul un résumé ou un compte rendu
> secondaire a pu être lu, c'est écrit dans l'entrée. Ce qui n'a pas pu être ouvert figure dans
> « Non vérifié », en fin de fichier.
>
> Hors périmètre, déjà couvert ailleurs : effet esthétique-utilisabilité (Tractinsky 2000, Tuch et
> al. 2012 sur l'effet inverse), proximité Gestalt selon NN/g, gorille invisible, cécité au
> changement, banner blindness, F-pattern.
>
> Les noms d'entreprises privées ne sont pas repris ici, sauf l'éditeur d'une source citée
> (Nielsen Norman Group, guidelines d'Apple). Les sites pris en exemple par les sources ne sont pas
> nommés.

Niveaux de preuve : N1 norme ou réglementation · N2 recherche revue par pairs ou étude empirique à
large échantillon (échantillon cité) · N3 guideline officielle d'institution ou de plateforme ·
N4 avis d'expert ou article de praticien.

---

## 1. Premières impressions

### Juger l'écran sur ce qu'il donne à voir en un coup d'œil : l'attrait visuel se forme en une fraction de seconde
- Niveau de preuve : N2 (article original non lu, voir limites)
- Source : Lindgaard, G., Fernandes, G., Dudek, C., Brown, J., 2006, « Attention web designers: You have 50 milliseconds to make a good first impression! », Behaviour & Information Technology 25(2), 115-126. Métadonnées lues sur https://api.crossref.org/works/10.1080%2F01449290500330448 ; compte rendu lu : M. Hopkin, Nature News, 13.01.2006, https://www.nature.com/news/2006/060109/full/news060109-13.html
- Extrait lu (Nature News) : « Instead they found that impressions were made in the first 50 milliseconds of viewing. » ; les verdicts brefs « tallied well with judgements made after a longer period of scrutiny ».
- Portée / limites : **article original non lu** (paywall, 403). Seuls les métadonnées Crossref et le compte rendu de Nature ont été lus : ni l'effectif ni le nombre de pages ne sont donnés. Le résultat concerne l'**attrait visuel** seul. Les extensions à la crédibilité ou à l'utilisabilité viennent d'interprétations ultérieures, pas de ce compte rendu.
- En conception visuelle : afficher l'écran 1 s (ou le flouter), puis demander « qu'est-ce qui reste ? ». Si l'impression est « encombré » ou « générique », le défaut se joue au niveau de la composition, pas d'un détail.

### Réduire la complexité visuelle et respecter le gabarit attendu de la catégorie : c'est la combinaison jugée la plus attrayante dès 17 ms
- Niveau de preuve : N2 (étude 1 : n = 59 ; étude 2 : n = 82)
- Source : Tuch, A. N., Presslaber, E. E., Stöcklin, M., Opwis, K., Bargas-Avila, J. A., 2012, « The role of visual complexity and prototypicality regarding first impression of websites: Working towards understanding aesthetic judgments », International Journal of Human-Computer Studies 70(11), 794-811. Préprint lu : https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/38315.pdf
- Extrait lu : « Results suggest that VC and PT affect aesthetic perception even within 17ms, though the effect of PT is less pronounced than the one of VC. » ; « Overall, websites with low VC and high PT were perceived as highly appealing. »
- Portée / limites : les auteurs listent quatre limites : visionnage passif de captures d'écran, échantillon jeune (surtout des étudiants en psychologie), aspects culturels ignorés, sites d'entreprises seulement, facteurs sous-jacents de la complexité et de la prototypicalité non analysés. La relation complexité-attrait y est surtout **linéaire**, pas en U inversé.
- En conception visuelle : l'écran ressemble-t-il à ce que l'utilisateur attend de cette catégorie de produit (prototypicalité) ? Combien de blocs, de couleurs et de textures distincts se disputent le premier regard ?

### Traiter la complexité visuelle avant la couleur : c'est elle qui pèse le plus sur la première impression
- Niveau de preuve : N2 (450 sites, 548 volontaires au total ; expérience sur l'attrait : 242 volontaires de 34 pays)
- Source : Reinecke, K., Yeh, T., Miratrix, L., Mardiko, R., Zhao, Y., Liu, J., Gajos, K. Z., 2013, « Predicting Users' First Impressions of Website Aesthetics With a Quantification of Perceived Visual Complexity and Colorfulness », CHI 2013. PDF lu : https://kgajos.seas.harvard.edu/papers/reinecke13aesthetics.pdf
- Extrait lu : « our analyses show that a high visual complexity results in the largest decrease in appeal, but websites with low levels of complexity are similarly liked to those with a medium complexity » ; « the perceived colorfulness only plays a minor role in people's first impression of appeal ».
- Portée / limites : impression après 500 ms, plateforme en ligne volontaire (LabintheWild), majorité de participants résidant aux États-Unis. Le modèle explique 48 % de la variance, avec les variables démographiques. Il n'y a **pas** d'avantage mesuré du « très simple » sur le « moyennement complexe » : la pénalité tombe sur la complexité **élevée**.
- En conception visuelle : chercher d'abord la surcharge (nombre de zones, densité de texte et d'images). Ne pas espérer gagner en attrait en dépouillant un écran déjà moyennement simple.

### Savoir pour qui l'on dessine : le niveau de couleur et de complexité préféré varie selon l'âge, le genre, l'éducation et le pays
- Niveau de preuve : N2 (≈ 2,4 millions de notes, près de 40 000 participants, 430 sites)
- Source : Reinecke, K., Gajos, K. Z., 2014, « Quantifying Visual Preferences Around the World », CHI 2014. PDF lu : https://iis.seas.harvard.edu/papers/reinecke14visual.pdf
- Extrait lu : « the level of colorfulness and visual complexity at which visual appeal is highest strongly varies: Females, for example, liked colorful websites more than males. A high education level generally lowers this preference for colorfulness. » ; « appeal is largely subjective even after a short exposure time of 500ms ».
- Portée / limites : les pics d'attrait de la complexité se situent entre 2,5 et 4,8 sur une échelle de 1 à 9 (faible à modérée), ceux de la couleur entre 3,6 et 7,6. Les auteurs signalent que les interactions entre variables démographiques ne sont pas rapportées, et un risque de validité externe. L'échantillon est un échantillon en ligne de volontaires.
- En conception visuelle : la sobriété chromatique plaît au public très diplômé et à certains pays (Finlande, Russie, Europe du Nord, selon l'étude) ; elle n'est pas universelle. Vérifier la cible avant d'imposer une palette quasi monochrome.

### Ne pas confondre « sobre » et « pauvre » : la diversité visuelle est une facette positive de l'esthétique perçue
- Niveau de preuve : N2 (questionnaire validé en sept études)
- Source : Moshagen, M., Thielsch, M. T., 2010, « Facets of visual aesthetics », International Journal of Human-Computer Studies 68(10), 689-709. Préprint lu : https://www.uni-muenster.de/OWMS/uploads/drafts_thielsch/pdf/moshagen_2010.pdf
- Extrait lu : « Four interrelated facets of perceived visual aesthetics of websites were identified and validated in a series of seven studies. Simplicity and Diversity have repeatedly been treated as formal parameters of aesthetic objects »
- Portée / limites : il s'agit d'un instrument de mesure (VisAWI : simplicité, diversité, couleur, savoir-faire), pas d'une prescription. Seul le résumé a été lu en détail. Les tailles d'échantillon des sept études n'ont pas été relevées.
- En conception visuelle : un écran épuré peut perdre sur la « diversité » et sur le « savoir-faire » (craftsmanship). Le juger aussi sur la finition et sur un intérêt visuel suffisant, pas sur la seule simplicité.

### Soigner la structure (symétrie, complexité) avant la teinte : seule la complexité touche toutes les facettes de l'esthétique
- Niveau de preuve : N2 (cinq expériences en ligne, N = 194)
- Source : Seckler, M., Opwis, K., Tuch, A. N., 2015, « Linking objective design factors with subjective aesthetics: An experimental study on how structure and color of websites affect the facets of users' visual aesthetic perception », Computers in Human Behavior 49, 375-389 (DOI 10.1016/j.chb.2015.02.056). Notice lue : https://edoc.unibas.ch/40060/
- Extrait lu : « Only complexity affects all facets of subjective aesthetic perception. »
- Portée / limites : **notice et extraits du résumé seuls lus**. Les effets de la symétrie et de la teinte (bleu, saturation moyenne à forte) n'apparaissent que dans des résumés secondaires de moteur de recherche : non vérifiés à la source.
- En conception visuelle : avant de changer de palette pour « rendre plus beau », vérifier l'alignement, la symétrie de la grille et la densité.

## 2. Crédibilité visuelle

### Considérer l'apparence comme un critère de crédibilité : le « design look » est le motif le plus cité par les utilisateurs
- Niveau de preuve : N2 (2 684 participants, sites réels)
- Source : Fogg, B. J. et al. (Stanford Persuasive Technology Lab), étude publiée par Consumer WebWatch, 29.10.2002, « How Do People Evaluate a Web Site's Credibility? », https://advocacy.consumerreports.org/research/how-do-people-evaluate-a-web-sites-credibility (version DUX 2003 : Fogg, Soohoo, Danielson, Marable, Stanford, Tauber, « How do users evaluate the credibility of Web sites? A study with over 2,500 participants », non ouverte)
- Extrait lu : « We found that the "design look" of the site was mentioned most frequently, being present in 46.1 percent of the comments. » ; « In this study, 2,684 people evaluated the credibility of two live Web sites on a similar topic (such as health or news). »
- Portée / limites : **46,1 % des commentaires, pas des participants** (plusieurs reprises secondaires se trompent). Commentaires libres, donc fréquence de mention et non poids causal. Web de 2002. La page lue ne nomme pas les auteurs : l'attribution vient de la référence DUX 2003, repérée par recherche mais non ouverte.
- En conception visuelle : un écran au rendu négligé (alignements cassés, styles incohérents, typographie hétérogène) coûte en confiance avant même la lecture du contenu.

### Ne pas surestimer ce poids aujourd'hui : une analyse plus récente trouve un effet plus faible de l'apparence
- Niveau de preuve : N2 (15 750 commentaires de 2 041 participants)
- Source : Kąkol, M., Nielek, R., 2015, « What affects web credibility perception? An analysis of textual justifications », Computer Science (AGH) 16(3), 295-310, https://repo.agh.edu.pl/items/ab7e69c8-1e8a-4dc2-b569-a07519415c26/full
- Extrait lu : « the findings made a decade ago are still mostly valid today » ; « However we report a weaker impact of webpage appearance. »
- Portée / limites : **résumé seul lu**. Analyse qualitative de justifications données dans les études « Reconcile ». Les fréquences par catégorie ne sont pas connues.
- En conception visuelle : la finition visuelle reste un signal de confiance, mais ne compense ni un contenu faible ni l'absence de sources.

### Pour la confiance perçue, viser l'équilibre et le contraste plutôt que la densité graphique
- Niveau de preuve : N4 (résumé de praticien d'une étude N2)
- Source : Horvath, J., Human Factors International, newsletter « Cool Stuff and UX Resources », mars 2012, résumant Lindgaard, Dudek, Sen, Sumegi, Noonan, 2011, « An exploration of relations between visual appeal, trustworthiness and perceived usability of homepages », ACM TOCHI 18(1), https://www.humanfactors.com/newsletters/an_exploration_of_relations_between_visual_appeal.html
- Extrait lu : attrait associé à « high density, high contrast, and very high use of graphics » ; confiance associée à « high balance, high contrast, moderate graphics-to-text ratio, and moderate text-to-background ratio ».
- Portée / limites : **article original non lu** (403). Le résumé ne donne aucun effectif et date l'article par erreur de 2001. Exposition de 50 ms. À considérer comme indice, pas comme règle.
- En conception visuelle : un écran qui doit inspirer confiance (paiement, données sensibles) gagne à rester équilibré et lisible. L'attrait « spectaculaire » (forte densité graphique) n'est pas le même objectif que la confiance.

## 3. Signifiants visuels

### Donner aux éléments cliquables des signifiants forts : les éléments plats « faibles » coûtent du temps
- Niveau de preuve : N2 (oculométrie, 71 participants, 9 pages réelles en deux versions)
- Source : Moran, K., Nielsen Norman Group, 03.09.2017, « Flat UI Elements Attract Less Attention and Cause Uncertainty », https://www.nngroup.com/articles/flat-ui-less-attention-cause-uncertainty/
- Extrait lu : « Designs with weak clickability signifiers waste users' time. » Avec les signifiants faibles : ≈ 22 % de temps en plus et ≈ 25 % de fixations en plus (p < 0,05).
- Portée / limites : tâches courtes de repérage sur une seule page, sur ordinateur. Les clics erronés ne sont pas mesurés. Selon l'autrice, le plat s'en sort bien quand la densité d'information est faible, la mise en page classique, et les éléments interactifs contrastés et bien espacés.
- En conception visuelle : en masquant le style, peut-on encore dire ce qui est cliquable ? Un lien se distingue-t-il du texte autrement que par une nuance ? Un bouton a-t-il une forme ?

### Garder aux boutons une forme reconnaissable et ne pas styler le statique comme du cliquable
- Niveau de preuve : N4 (guideline de cabinet d'experts, sans données présentées)
- Source : Loranger, H., Nielsen Norman Group, 08.03.2015, « Beyond Blue Links: Making Clickable Elements Recognizable », https://www.nngroup.com/articles/clickable-elements/
- Extrait lu : « Retain the rectangular shape (preferably with rounded corners) if you renounce the 3-D effect. » ; les éléments cliquables « should look clickable even without heavier effects such as shadows and gradients ».
- Portée / limites : recommandations tirées de l'expérience des tests de l'éditeur, pas d'une étude chiffrée présentée dans l'article.
- En conception visuelle : un titre sur fond coloré ressemble-t-il à un bouton ? Un bouton secondaire « fantôme » reste-t-il identifiable comme contrôle ?

### Préférer le « presque plat » au plat intégral : simplicité visuelle sans sacrifier les signifiants
- Niveau de preuve : N4
- Source : Moran, K., Nielsen Norman Group, 27.09.2015, « Flat Design: Its Origins, Its Problems, and Why Flat 2.0 Is Better for Users », https://www.nngroup.com/articles/flat-design/
- Extrait lu : « One of the biggest usability issues introduced by flat design is the lack of signifiers on clickable elements. » ; « Flat 2.0 provides an opportunity for compromise — visual simplicity without sacrificing signifiers. »
- Portée / limites : article d'opinion argumenté, sans données propres. L'étude chiffrée est celle de 2017 (entrée précédente).
- En conception visuelle : ombres légères, contours et changements d'état sont des outils de signifiance. Les retirer pour le style a un coût.

### Un bouton sans bordure est conforme s'il est identifiable par son contenu, mais le focus doit toujours contraster
- Niveau de preuve : N1 (WCAG 2.2, critère 1.4.11, et sa documentation « Understanding »)
- Source : W3C WAI, « Understanding SC 1.4.11: Non-text Contrast » (WCAG 2.2), https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html
- Extrait lu : « This success criterion does not require that controls have a visual boundary indicating the hit area. » ; « Having a visual boundary indicating the hit area is only required when there is no other visual way to identify the presence of the control »
- Portée / limites : le critère porte sur le contraste (3:1) de l'information **nécessaire** pour identifier un composant et ses états. Le W3C encourage sans l'exiger le contour de tous les contrôles, pour les personnes ayant des troubles cognitifs.
- En conception visuelle : l'état sélectionné ou actif et le focus atteignent-ils 3:1 contre leur voisinage ? Une case à cocher grise sur fond gris clair échoue.

### Accompagner les icônes d'un libellé visible en permanence : rares sont les icônes universellement comprises
- Niveau de preuve : N4 (observations de tests utilisateurs, sans effectifs)
- Source : Harley, A., Nielsen Norman Group, 27.07.2014, « Icon Usability », https://www.nngroup.com/articles/icon-usability/
- Extrait lu : « There are a few icons that enjoy mostly universal recognition from users » (accueil, impression, loupe de recherche) ; « Outside of these examples, most icons continue to be ambiguous to users. » ; « Icon labels should be visible at all times » ; « Don't rely on hover to reveal text labels. »
- Portée / limites : exemples tirés de tests utilisateurs non chiffrés. L'étude empirique classique sur icône + libellé (Wiedenbeck 1999) n'a pas pu être ouverte (voir Non vérifié).
- En conception visuelle : pour chaque icône seule, demander « un nouvel utilisateur la nommerait-il sans survol ? ». Si la réponse n'est pas évidente, ajouter un libellé.

## 4. Hiérarchie visuelle et attention

### Limiter les boutons à forte mise en avant à un ou deux par vue, en réservant le style primaire à l'action la plus probable
- Niveau de preuve : N3 (Apple Human Interface Guidelines)
- Source : Apple, Human Interface Guidelines, « Buttons », lu via https://developer.apple.com/tutorials/data/design/human-interface-guidelines/buttons.json (page https://developer.apple.com/design/human-interface-guidelines/buttons)
- Extrait lu : « Keep the number of prominent buttons to one or two per view. » ; « Presenting too many prominent buttons increases cognitive load, requiring people to spend more time considering options before making a choice. » ; « Don't assign the primary role to a button that performs a destructive action, even if that action is the most likely choice. »
- Portée / limites : guideline de plateforme, sans étude citée. La limite est « un ou deux », pas strictement un. La guideline Material 3 équivalente n'a pas pu être lue (page rendue en JavaScript).
- En conception visuelle : compter les boutons pleins ou colorés visibles en même temps. Au-delà de deux, rétrograder. Ne jamais donner le style primaire à une action destructive.

### Construire la hiérarchie par le contraste (valeur, saturation), l'échelle et le regroupement, avec peu de niveaux
- Niveau de preuve : N4 (aucune donnée citée)
- Source : Gordon, K., Nielsen Norman Group, 17.01.2021, « Visual Hierarchy in UX: Definition », https://www.nngroup.com/articles/visual-hierarchy-ux-definition/
- Extrait lu : « Use no more than 3 sizes » ; « Limit how many elements are big to a maximum of 2. » ; « Do not rely only on color to communicate visual hierarchy. »
- Portée / limites : les chiffres (3 tailles, 2 grands éléments, 2 + 2 couleurs) sont des règles de métier, non mesurées. Ils s'appuient sur deux ouvrages de design et des exemples.
- En conception visuelle : combien de tailles de texte, de couleurs d'accent et de niveaux de contraste l'écran utilise-t-il ? Chaque niveau supplémentaire doit porter une différence d'importance réelle.

### Utiliser le flou ou le plissement des yeux comme heuristique de revue, pas comme preuve
- Niveau de preuve : N4
- Source : Gordon, K., Nielsen Norman Group, 17.01.2021, « Visual Hierarchy in UX: Definition », https://www.nngroup.com/articles/visual-hierarchy-ux-definition/
- Extrait lu : « In design school, we are taught to squint or apply a slight blur to the design. » (l'article l'applique avec des flous de 5, 10 et 20 px ; à 20 px, un élément fortement coloré domine la page de façon non voulue)
- Portée / limites : **aucune étude de validation du « squint test » trouvée.** NN/g le présente comme une pratique d'école. Il révèle la hiérarchie de saillance, pas la lisibilité ni la compréhension.
- En conception visuelle : flouter une capture à environ 10-20 px. L'élément qui ressort est-il celui qu'on veut voir en premier ? Un badge ou une illustration colorée vole-t-il la vedette à l'action principale ?

### Savoir que l'attention ascendante va aux zones les plus contrastées : c'est le principe des cartes de saillance
- Niveau de preuve : N2 (modèle computationnel de référence)
- Source : Itti, L., Koch, C., Niebur, E., 1998, « A model of saliency-based visual attention for rapid scene analysis », IEEE TPAMI 20(11), 1254-1259. Résumé lu : https://ilab.usc.edu/publications/Itti_etal98pami.html
- Extrait lu : « Multiscale image features are combined into a single topographical saliency map. » ; « A dynamical neural network then selects attended locations in order of decreasing saliency. »
- Portée / limites : **résumé seul lu.** Le modèle a été conçu pour des scènes naturelles. Il prédit mal les interfaces (entrée suivante).
- En conception visuelle : le contraste local (couleur, luminance, orientation) attire le regard sans intention de l'utilisateur. Un élément très contrasté mais secondaire est un détournement d'attention.

### Ne pas évaluer une interface avec un modèle de saillance « scènes naturelles » : texte et mise en page changent la donne
- Niveau de preuve : N2 (UIST 2017 ; modèles entraînés sur 1 000 designs annotés et 1 400 visualisations)
- Source : Bylinskii, Z., Kim, N. W., O'Donovan, P., Alsheikh, S., Madan, S., Pfister, H., Durand, F., Russell, B., Hertzmann, A., 2017, « Learning Visual Importance for Graphic Designs and Data Visualizations », UIST 2017. PDF lu : https://arxiv.org/pdf/1708.02660
- Extrait lu : « A crucial goal of any graphic design or data visualization is to communicate the relative importance of different design elements » ; citant Haass et al. : les modèles de saillance naturelle « perform significantly worse on visualizations than on natural images ».
- Portée / limites : l'« importance » est mesurée par annotations et clics (BubbleView), pas uniquement par oculométrie. Les clics se concentrent davantage sur le texte que les fixations. Le corpus est celui des affiches, infographies et graphiques, pas d'écrans d'application.
- En conception visuelle : pour prédire ce qui sera vu, préférer un test rapide (5 secondes, premier clic) ou un modèle entraîné sur des designs à une carte de saillance générique.

### Sur une page web, le contraste de couleur n'est pas un bon prédicteur du regard
- Niveau de preuve : N4 (préprint arXiv, non revu par les pairs à la date de lecture)
- Source : Zhang, C., Aspandi, D., Staab, S., 2022 (préprint arXiv 2211.08074), « Predicting Eye Gaze Location on Websites », https://ar5iv.labs.arxiv.org/html/2211.08074
- Extrait lu : « saliency detection model trained on natural image dataset does not work well for direct application to web screenshot scenario »
- Portée / limites : préprint. Les auteurs attribuent l'échec d'un modèle de base à « its tendency to detect high color contrast as area of interest ». Ils rappellent, en citant d'autres travaux, l'attention portée au coin supérieur gauche.
- En conception visuelle : la position (haut-gauche, en-tête) et le texte comptent autant que la couleur. Un aplat vif placé en bas à droite ne garantit pas d'être vu.

### Ne pas croire à un chiffre de compréhension lié à l'espace blanc : les marges aident, l'interlignage moins, et la mise en page « améliorée » change surtout la satisfaction
- Niveau de preuve : N2 (périodique de laboratoire universitaire ; effectifs non lus)
- Source : Chaparro, B., Baker, J. R., Shaikh, A. D., Hull, S., Brady, L., 2004, « Reading Online Text: A Comparison of Four White Space Layouts », Usability News (SURL) 6(2), notice lue : https://portfolio.erau.edu/en/publications/reading-online-text-a-comparison-of-four-white-space-layouts/
- Extrait lu : « Results show that the use of margins affected both reading speed and comprehension more than the No Margin text. » ; « Leading was not shown to impact reading performance but did influence overall user preference. »
- Portée / limites : **résumé seul lu.** Le sens de l'effet sur la vitesse (plus lent avec marges, selon des commentaires secondaires) n'est pas vérifié. Lecture de texte continu, non d'interface applicative.
- En conception visuelle : pour la lecture longue, des marges latérales nettes. L'interlignage relève du confort et de la préférence ; ne pas lui prêter un gain de compréhension.

### Une mise en page « soignée » améliore le confort ressenti plus que la performance
- Niveau de preuve : N2 (effectifs non lus)
- Source : Chaparro, B. S., Shaikh, A. D., Baker, J. R., 2005, « Reading Online Text With a Poor Layout: Is Performance Worse? », Usability News (SURL) 7, notice lue : https://portfolio.erau.edu/en/publications/reading-online-text-with-a-poor-layout-is-performance-worse/
- Extrait lu : « Results showed that reading speed and comprehension were not affected by layout » ; « participants were more satisfied with the enhanced layout and reported it to be less fatiguing to read. »
- Portée / limites : **résumé seul lu.** La mise en page « améliorée » combine titres, indentation et placement des figures, pas l'espace blanc seul.
- En conception visuelle : justifier la qualité de mise en page par la satisfaction et la fatigue, pas par une promesse de compréhension chiffrée.

## 5. Gestalt avec preuve empirique

### Rendre l'écart inter-groupes nettement supérieur à l'écart intra-groupe : le regroupement par proximité dépend du rapport des distances
- Niveau de preuve : N2 (revue de synthèse, Psychological Bulletin)
- Source : Wagemans, J., Elder, J. H., Kubovy, M., Palmer, S. E., Peterson, M. A., Singh, M., von der Heydt, R., 2012, « A century of Gestalt psychology in visual perception: I. Perceptual grouping and figure-ground organization », Psychological Bulletin 138(6), 1172-1217. PDF lu : https://ruccs.sas.rutgers.edu/images/archive/personal-manish-singh/papers/Wagemans_etal_2012_I.pdf (version auteur aussi sur https://pmc.ncbi.nlm.nih.gov/articles/PMC3482144/)
- Extrait lu : « If the ratio of the longer to the shorter vector is larger than about 1.5, grouping along that orientation is almost never seen. » ; « grouping by proximity depends only on the relative distance between dots in competing organizations »
- Portée / limites : réseaux de points présentés 300 ms (Kubovy et al.), en laboratoire. Le « 1,5 » vaut pour des points isolés, pas pour des cartes, du texte ou des contrôles. La pente varie d'une personne à l'autre.
- En conception visuelle : mesurer le rapport espace entre groupes / espace dans le groupe. Proche de 1, les groupes se lisent mal. Un rapport d'au moins ~1,5 à 2 est un point de départ prudent, à confirmer sur l'écran réel.

### Les indices de regroupement s'additionnent : combiner proximité et similarité renforce le groupe
- Niveau de preuve : N2 (même revue)
- Source : Wagemans et al., 2012, PDF cité ci-dessus.
- Extrait lu : « the conjoined effects of proximity and similarity are called additive »
- Portée / limites : démontré sur des réseaux de points et d'éléments de Gabor (proximité + contraste, proximité + colinéarité). La revue récuse la mesure de Rush (1937), « Similarity equals about 1.5 cm of Proximity », pour sa méthode.
- En conception visuelle : quand un groupe se lit mal, renforcer d'abord par un second indice cohérent (même alignement, même couleur de libellé) avant d'ajouter un cadre.

### Un fond ou un cadre commun groupe ce qu'il contient : la « région commune » est un principe mesuré
- Niveau de preuve : N2 (revue ; mesures par temps de discrimination de répétition)
- Source : Wagemans et al., 2012, PDF cité ci-dessus (définition reprise de Palmer, 1992, Cognitive Psychology 24).
- Extrait lu : « Common region is the tendency for elements that lie within the same bounded area (or region) to be grouped together (Palmer, 1992). » Les observateurs répondaient plus vite « when the repeated shapes were located within the same surrounding region than when they were located in two separate regions. »
- Portée / limites : article original de Palmer 1992 non lu (pas de résumé disponible). Les preuves comportementales citées sont Beck & Palmer 2002 et Palmer & Beck 2007, en laboratoire.
- En conception visuelle : une carte, un fond teinté ou une bordure est un indice de groupe réel, pas un simple décor. L'utiliser quand la proximité ne suffit pas (contenu dense, espacement contraint).

### Quand ils s'opposent, la région commune l'emporte sur la connexion par trait
- Niveau de preuve : N2 (tâche indirecte, forces des indices égalisées par participant)
- Source : Montoro, P. R., Villalba-García, C., Luna, D., Hinojosa, J. A., 2017, « Common region wins the competition between extrinsic grouping cues: Evidence from a task without explicit attention to grouping », Psychonomic Bulletin & Review 24(6), 1856-1861. Résumé lu via Europe PMC : https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=DOI:10.3758/s13423-017-1254-3&resultType=core&format=json
- Extrait lu : « grouping by common region dominated the perceived organization of the display »
- Portée / limites : **résumé seul lu** (texte intégral derrière une redirection d'authentification). Stimuli de laboratoire, effectif non relevé. Compare région commune et connexion, **pas** région commune et proximité.
- En conception visuelle : un trait reliant deux éléments groupe moins qu'un fond partagé. Pour des étapes ou des paires, un conteneur commun est plus fort qu'une ligne.

### La similarité de luminance peut dominer la proximité : un contraste de couleur mal placé casse les groupes d'espacement
- Niveau de preuve : N2 (tâche objective indirecte, temps de réaction et précision)
- Source : Villalba-García, C., Jimenez, M., Luna, D., Hinojosa, J. A., Montoro, P. R., 2021, « Competition between perceptual grouping cues in an indirect objective task », Quarterly Journal of Experimental Psychology 74(10), 1724-1736. Résumé lu via Europe PMC : https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=DOI:10.1177/17470218211010486&resultType=core&format=json
- Extrait lu : « processing dominance of: (1) luminance similarity over proximity and (2) common region over connectedness »
- Portée / limites : **résumé seul lu.** Stimuli de laboratoire simples. La force relative dépend des valeurs choisies.
- En conception visuelle : des éléments proches mais de luminances très différentes ne se lisent pas comme un groupe. Des éléments éloignés mais de même teinte peuvent se regrouper à tort. Vérifier que la couleur ne contredit pas l'espacement.

### Préférer l'espace blanc aux cadres quand il suffit, mais savoir qu'un cadre l'emporte sur la proximité
- Niveau de preuve : N4 (aucune donnée expérimentale propre ; cite Palmer 1992)
- Source : Harley, A., Nielsen Norman Group, 12.07.2020, « The Principle of Common Region: Containers Create Groupings », https://www.nngroup.com/articles/common-region/
- Extrait lu : « Creating a clear boundary is a strong visual cue that can overpower other grouping principles. » ; « When possible, using whitespace alone to create clear groupings reduces the visual complexity of a design. » ; « too many borders and colored boxes that exist purely for decoration add clutter to the interface. »
- Portée / limites : avis argumenté par des exemples. L'autrice signale aussi le risque de « false floors » : une segmentation forte fait croire que la page s'arrête.
- En conception visuelle : retirer les cadres un à un. Si les groupes restent lisibles, le cadre était décoratif. S'il faut un conteneur, en garder un seul niveau et éviter l'imbrication.

## 6. Images et photos

### Ne mettre une photo que si elle porte de l'information : les images décoratives et les photos de stock sont ignorées
- Niveau de preuve : N4 (oculométrie de l'éditeur, effectif non publié dans l'article)
- Source : Nielsen, J., Nielsen Norman Group, 31.10.2010 (révisé le 13.08.2026), « Photos as Web Content », https://www.nngroup.com/articles/photos-as-web-content/
- Extrait lu : « Some types of pictures are completely ignored. » ; « This is typically the case for big feel-good images that are purely decorative. » ; « Photos of products and real people (as opposed to stock photos of models) often fall into this category. » (celle des images examinées comme contenu) ; « users ignore stock photos of generic people. »
- Portée / limites : l'effectif n'est pas donné dans l'article. Données de 2010, sur ordinateur et sites de contenu ou de commerce. Exemple chiffré sur une page catégorie : 18 % du temps de regard sur les photos, 82 % sur le texte.
- En conception visuelle : pour chaque image, « que perd l'utilisateur si on l'enlève ? ». Si rien, c'est du remplissage. Une photo de l'équipe réelle ou du produit réel vaut mieux qu'un modèle générique.

### Donner aux images un poids visuel proportionnel à leur utilité pour la tâche
- Niveau de preuve : N4 (aucune étude citée)
- Source : Whitenton, K., Nielsen Norman Group, 28.09.2014, « Image-Focused Design: Is Bigger Better? », https://www.nngroup.com/articles/image-focused-design/
- Extrait lu : « Images are usually decorative, and support branding goals. »
- Portée / limites : argumentation par exemples et par l'Emotional Design de D. Norman. Une grande image est acceptable si elle porte du contenu, sans masquer les éléments essentiels.
- En conception visuelle : une image héros pousse-t-elle sous la ligne de flottaison l'action ou l'information dont l'utilisateur a besoin ?

### Un visage capte le regard ; un regard détourné vers le contenu y renvoie l'attention
- Niveau de preuve : N2 (oculométrie, 72 participants de 18 à 32 ans)
- Source : Sajjacholapunt, P., Ball, L. J., 2014, « The influence of banner advertisements on attention and memory: human faces with averted gaze can enhance advertising effectiveness », Frontiers in Psychology 5:166, https://pmc.ncbi.nlm.nih.gov/articles/PMC3941030
- Extrait lu : avec un regard face caméra, « the focus of attention was localized more on the face region rather than on the text or product » ; « the condition involving faces with averted gaze increased attention to the banner overall ».
- Portée / limites : bannières publicitaires dans des pages construites pour l'étude. Les auteurs écrivent que « our findings may not necessarily generalize to real banner advertisements embedded in genuine website pages ». Échantillon jeune.
- En conception visuelle : une photo de personne regardant l'objectif concurrence le texte voisin. Si une photo de personne est justifiée, vérifier où va son regard par rapport au message ou à l'action.

## 7. Effets de style et tendances

### Traiter la transparence (glassmorphism) comme un risque de lisibilité, à contrôler sur tous les fonds possibles
- Niveau de preuve : N4 (aucune donnée ; renvoie aux WCAG)
- Source : Brown, M., Nielsen Norman Group, 07.06.2024, « Glassmorphism: Definition and Best Practices », https://www.nngroup.com/articles/glassmorphism/
- Extrait lu : « One of the most significant issues with glassmorphism stems from text readability problems. » ; « textual elements can fall over multiple colors, which can affect readability. »
- Portée / limites : avis d'expert. L'article recommande plus de flou, des fonds simples maîtrisés, un usage parcimonieux, et de laisser l'utilisateur régler la transparence.
- En conception visuelle : vérifier le contraste du texte sur la zone la plus défavorable de chaque fond (photo, vidéo, défilement), pas sur la moyenne.

### Mesurer le contraste du texte sur le fond réellement rendu : une image ou un dégradé de fond insuffisamment contrasté est un échec WCAG
- Niveau de preuve : N1 (WCAG 2.2, critère 1.4.3, échec F83)
- Source : W3C WAI, « Understanding SC 1.4.3: Contrast (Minimum) » (WCAG 2.2), https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
- Extrait lu : « The visual presentation of text and images of text has a contrast ratio of at least 4.5:1, except for the following: » ; « Large-scale text and images of large-scale text have a contrast ratio of at least 3:1; » ; échec F83 : « using background images that do not provide sufficient contrast with foreground text ».
- Portée / limites : la page ne donne pas de méthode spécifique aux dégradés. Elle précise que le contraste se mesure contre le fond « over which the text is rendered in normal usage ».
- En conception visuelle : sur un dégradé ou un verre dépoli, mesurer au point le plus clair (texte clair) ou le plus sombre (texte sombre).

### Le minimalisme est un moyen, pas une fin : ses traits typiques (plat, peu de contraste, navigation cachée) ont des coûts connus
- Niveau de preuve : N4 (analyse de 112 sites minimalistes ; pas de test utilisateur)
- Source : Moran, K., Nielsen Norman Group, 12.07.2015, « The Characteristics of Minimalism in Web Design », https://www.nngroup.com/articles/characteristics-minimalism/
- Extrait lu : « flat designs often fail to communicate to users which elements are selectable or clickable. » ; « A minimalist design strategy can be a powerful tool, but only when it's framed by the needs of your users. »
- Portée / limites : corpus de sites choisis par un expert ou issus de galeries d'inspiration. Le plat y est présent dans 96 % des cas. Il s'agit d'une description du style, pas d'une mesure de préférence.
- En conception visuelle : un écran minimaliste garde-t-il ses signifiants, son contraste et sa navigation visible ? Le minimalisme doit retirer du bruit, pas de l'information.

---

## Verdict sur les règles du profil

| Règle | Verdict | Motif |
|---|---|---|
| « Un levier de hiérarchie à la fois (taille, graisse, couleur, espace) ; un seul élément primaire par écran. » | **Mixte.** « Un seul primaire » : **soutenue par une guideline N3, mais plus stricte qu'elle**. « Un levier à la fois » : **convention sans preuve trouvée** | Apple HIG : « Keep the number of prominent buttons to one or two per view », avec le motif de la charge cognitive. C'est un ou deux, pas strictement un. Aucune étude ne montre qu'agir sur un seul levier vaut mieux qu'en combiner. La perception va plutôt dans l'autre sens : les indices s'additionnent (Wagemans et al. 2012, proximité + similarité). La règle se défend comme discipline de retenue (éviter l'escalade des contrastes ; NN/g 2021 : au plus 3 tailles, 2 grands éléments, N4), pas comme loi perceptive. |
| « La proximité groupe mieux qu'une bordure ; espacement intra-groupe < inter-groupes. » | **Première moitié contredite ; seconde moitié soutenue** | Une frontière nette est un indice de groupe mesuré (région commune, Palmer 1992, via Wagemans 2012) qui peut l'emporter : « Creating a clear boundary is a strong visual cue that can overpower other grouping principles » (NN/g 2020, N4). La région commune domine la connexion (Montoro et al. 2017) et la similarité de luminance domine la proximité (Villalba-García et al. 2021). La proximité n'est donc pas « meilleure » ; elle est **moins coûteuse en complexité visuelle**. Pour l'espacement intra < inter : soutenu (loi de distance pure ; au-delà d'un rapport ≈ 1,5, le regroupement concurrent n'est presque plus vu, sur des réseaux de points). Reformulation proposée : « La proximité suffit souvent et coûte moins qu'un cadre ; un cadre groupe plus fort, à garder pour quand l'espace ne suffit pas. Écart inter-groupes ≥ 1,5 à 2 × l'écart intra-groupe. » |
| « L'espace est le matériau premier : essayer l'espacement avant d'ajouter bordure ou fond. » | **Soutenue faiblement** (N4 direct, N2 indirect) | Directement : NN/g 2020 (« using whitespace alone to create clear groupings reduces the visual complexity of a design »), un avis sans données. Indirectement : la complexité visuelle élevée est le facteur qui fait le plus baisser l'attrait à la première impression (Tuch et al. 2012 ; Reinecke et al. 2013). Aucune étude ne compare « espacement » et « bordure » sur la performance de tâche. Sur la lecture, l'espace blanc n'a pas de gain de compréhension chiffré établi (Chaparro 2004, 2005 : effets surtout sur la préférence et la fatigue). |
| « Interdits : glassmorphism gratuit, dégradés violet/rose, emojis décoratifs. » | **Glassmorphism gratuit : soutenu** (N1 indirect + N4). **Dégradés violet/rose : convention sans preuve trouvée.** **Emojis décoratifs : convention sans preuve trouvée** | Glassmorphism : risque de contraste documenté (NN/g 2024) et opposable au critère WCAG 1.4.3 (4,5:1, échec F83 sur fond d'image) ; c'est le contraste qui est interdit, pas l'effet. Dégradés violet/rose : aucune étude trouvée ; les préférences de couleur varient fortement selon le genre, l'éducation et le pays (Reinecke & Gajos 2014). C'est une règle de goût ou de différenciation (éviter un cliché), légitime si elle est présentée comme telle. Emojis décoratifs : pas d'étude sur les interfaces trouvée. Seul un argument analogique tient : les éléments purement décoratifs sont ignorés (NN/g 2010, photos) et une icône sans libellé est ambiguë (NN/g 2014). |
| « Référence : les trois produits cités par le profil » (outils de développement au style minimaliste sombre) | **Partiellement soutenue sur le principe, pas sur le choix des références** | Préféré au premier regard, d'après les études : faible complexité **et** forte prototypicalité (Tuch et al. 2012 ; n = 59 et 82, jeunes, sites d'entreprises). La pénalité tombe sur la complexité élevée ; « faible » et « moyenne » sont à égalité (Reinecke et al. 2013). Les pics d'attrait se situent à une complexité faible à modérée, qui varie : les personnes très diplômées préfèrent moins de couleur et de complexité ; les femmes aiment moins les sites très simples ; les 41 ans et plus préfèrent plus de couleur et de complexité (Reinecke & Gajos 2014, ≈ 40 000 participants). La « diversité » est une facette positive de l'esthétique (Moshagen & Thielsch 2010). Le plat minimaliste sans signifiants coûte ≈ 22 % de temps de repérage (NN/g 2017). **Aucune source ne montre que ces trois produits, ni ce style, sont préférés par un public général.** Ils ne sont des références valables que pour un public qui les tient pour prototypiques (développeurs). Pour un autre public, la référence doit être prototypique de **sa** catégorie. |

## Mythes et affirmations contestées

- **« Les utilisateurs jugent tout un site en 50 ms. »** Lindgaard et al. 2006 portent sur l'**attrait visuel**. L'extension à la crédibilité et à l'utilisabilité (« halo ») vient de reprises secondaires. Le travail de 2011 du même groupe (lu seulement via un résumé de praticien) indique que les jugements plus exigeants (confiance, utilisabilité) s'appuient sur d'autres attributs visuels. Reinecke & Gajos 2014 contestent aussi l'idée d'une faible variabilité individuelle au premier regard : « The finding challenges previous assumptions that individual variability in aesthetic taste is small during the initial visceral reaction toward a design ».
- **« 46 % des utilisateurs jugent la crédibilité sur le design. »** Faux tel quel : 46,1 % **des commentaires** (Fogg et al., Consumer WebWatch 2002). L'effet de l'apparence est trouvé plus faible une décennie plus tard (Kąkol & Nielek 2015, résumé seul lu).
- **« La complexité suit un U inversé (Berlyne) : il faut un niveau moyen. »** Non confirmé sur les sites web au premier regard : relation surtout linéaire, la complexité élevée pénalise, faible ≈ moyenne (Tuch et al. 2012 ; Reinecke et al. 2013, qui écrit que la relation « is not necessarily represented by a strong U-shape »). Tuch et al. testent aussi le U inversé entre latence de réponse et note de beauté postulé par Tractinsky et al. (2006) : un ajustement quadratique n'y est significativement meilleur que pour 18 à 28 % des participants.
- **Contradiction interne sur l'âge, à signaler.** Reinecke et al. 2013 : les plus de 45 ans aiment davantage les sites peu complexes. Reinecke & Gajos 2014 : les 41 ans et plus préfèrent plus de couleur et de complexité. Ne pas tirer de règle d'âge sans données propres.
- **« L'espace blanc augmente la compréhension de 20 %. »** Chiffre qui circule sans source vérifiable. L'attribution habituelle (Lin 2004, Computers in Human Behavior, sur l'hypertexte et les personnes âgées) n'a pas pu être vérifiée : son titre porte sur la topologie du texte, pas sur l'espace blanc. Les études de Chaparro (2004, 2005) ne donnent aucun « 20 % » dans les résumés lus.
- **« La similarité vaut 1,5 cm de proximité » (Rush 1937).** Récusé par la revue de Wagemans et al. 2012, qui juge la méthode de mesure incorrecte.
- **Connexité uniforme (Palmer & Rock 1994) comme étape initiale universelle.** Contestée : Kimchi (2000) trouve que colinéarité et fermeture comptent au moins autant ; les thèses de Palmer et Rock « have not been uniformly accepted » (Wagemans et al. 2012, version PMC).
- **« Squint test » comme méthode validée.** Aucune validation empirique trouvée. NN/g le présente comme une pratique enseignée en école de design (N4).
- **Cartes de saillance « Itti-Koch » pour juger une interface.** Les modèles conçus pour les scènes naturelles prédisent mal les visualisations et les pages web (Bylinskii et al. 2017, citant Haass et al. ; Zhang et al. 2022, préprint).

## Non vérifié

- **Lindgaard et al. 2006**, texte intégral et résumé de l'éditeur : 403 chez l'éditeur, résumé indisponible chez Crossref, Europe PMC et SciSpace. Effectif, nombre de pages, corrélations exactes : non vérifiés.
- **Lindgaard et al. 2011** (ACM TOCHI 18(1)) : 403. Connu seulement par un résumé de praticien, qui date l'article de 2001 par erreur.
- **Fogg et al. 2003** (DUX 2003), texte intégral, et les guidelines du Stanford Web Credibility Project (credibility.stanford.edu) : 503 au moment de la recherche.
- **Wiedenbeck 1999**, « The use of icons and labels in an end user application program: an empirical study of learning and retention », Behaviour & Information Technology 18(2), 68-82 (DOI 10.1080/014492999119129) : métadonnées confirmées. Résumé non lu : la phrase « performance was best on the label-only and icon-label interfaces » vient d'un extrait de moteur de recherche. Non vérifié.
- **Djamasbi, Siegel, Tullis 2010** (Génération Y et oculométrie, IJHCS 68) : PDF en 503. Non vérifié.
- **Still & Masciocchi 2010** (saillance et fixations sur interfaces web) et **Shen & Zhao 2014** (saillance des pages web, ECCV) : texte non obtenu (503). Non vérifié.
- **Palmer 1992** (Common region, Cognitive Psychology 24) : pas de résumé disponible. La thèse « la région commune ne se réduit pas à la proximité » n'apparaît que dans un extrait de moteur de recherche. Non vérifié.
- **Tuch, Bargas-Avila, Opwis 2010**, « Symmetry and aesthetics in website design » : non ouvert.
- **Seckler et al. 2015** : effets de la symétrie et de la teinte (bleu, saturation) connus seulement par extraits secondaires.
- **Chaparro et al. 2004** : sens de l'effet des marges sur la vitesse de lecture et effectifs non vérifiés (texte intégral non obtenu).
- **Material Design 3**, règle « un bouton plein par écran » : page officielle illisible sans JavaScript. Les reprises trouvées viennent de design systems d'entreprises, non retenues.
- **Emojis et perception professionnelle** (étude de l'Université d'Ottawa, Collabra: Psychology) : page en 402. Elle porte de toute façon sur des messages de travail, pas sur des interfaces. Non vérifié.
- **Préférence documentée pour le style des trois références citées par le profil** : aucune source trouvée.

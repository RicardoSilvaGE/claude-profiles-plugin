# Fiche `ux-preuves` — Design visuel — front récent (2024-2026)

> Fiche du skill `ux-preuves` (dev-fullstack), volet **design visuel**, préchargé par `designer`. Couvre : Liquid Glass d'Apple et ses critiques, Material 3 Expressive et ce que Google publie vraiment, homogénéisation par l'IA générative, effets mesurés de l'IA sur les designers, état réel du web (Web Almanac 2025), nouvelles capacités CSS Baseline, tendances sans mesure.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Verdict sur les règles
> du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées : ce qui y
> figure ne se cite pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche documentaire du 9 novembre 2026. Chaque entrée renvoie à une page ouverte pendant la recherche
> (WebFetch, ou téléchargement puis extraction du texte). Les extraits sont verbatim, dans leur langue d'origine.
> « Résumé seul lu » signifie que seul le résumé (abstract) a été lu, pas l'article entier.
> Une entreprise qui décrit sa propre recherche n'est jamais classée N2 : sa recherche n'est pas revue.

Niveaux : N1 norme/réglementation · N2 recherche revue par les pairs ou étude empirique à large échantillon ·
N3 guideline officielle de plateforme ou d'institution · N4 avis d'expert, article de praticien, presse.

---

## 1. Apple « Liquid Glass » (WWDC, 9 juin 2025) et ce qui a suivi

### Réserver le verre à la couche de navigation et de contrôles, jamais au contenu
- Niveau de preuve : N3
- Source : Apple, Human Interface Guidelines, page « Materials » (journal des modifications : « June 9, 2025 — Added guidance for Liquid Glass », « September 9, 2025 — Updated guidance for Liquid Glass »), https://developer.apple.com/design/human-interface-guidelines/materials (texte lu via la version JSON de la page : https://developer.apple.com/tutorials/data/design/human-interface-guidelines/materials.json)
- Extrait lu : « Don't use Liquid Glass in the content layer. » ; « Liquid Glass forms a distinct functional layer for controls and navigation elements — like tab bars and sidebars — that floats above the content layer »
- Portée / limites : consigne de plateforme, sans donnée de test publiée. Exception explicite : un contrôle transitoire du contenu (curseur, interrupteur) prend l'aspect verre pendant qu'on l'actionne. Apple ajoute « Use Liquid Glass effects sparingly ».
- En conception visuelle : le verre est-il cantonné aux barres et aux contrôles flottants ? Une carte, un fond d'écran ou un bloc de texte « en verre » contredit la doctrine même de son auteur.

### Choisir la variante « regular » dès qu'il y a du texte ; la variante « clear » seulement sur un média riche, avec un voile sombre si le fond est clair
- Niveau de preuve : N3
- Source : Apple, HIG « Materials » (état au 9 sept. 2025), même URL que ci-dessus
- Extrait lu : « Use the regular variant when background content might create legibility issues, or when components have a significant amount of text, such as alerts, sidebars, or popovers. » ; « If the underlying content is bright, consider adding a dark dimming layer of 35% opacity. »
- Portée / limites : le chiffre de 35 % est une recommandation d'Apple, pas le résultat d'une mesure publiée. La page indique aussi que l'apparence des deux variantes change selon les réglages système (préférence de verre, réduction de la transparence, contraste accru).
- En conception visuelle : un composant « clear » est-il posé sur un fond clair sans voile ? Un panneau chargé de texte utilise-t-il « clear » au lieu de « regular » ? La même page prévient : « Avoid selecting a material or effect based on the apparent color it imparts to your interface, because system settings can change its appearance and behavior. » La maquette a-t-elle donc été vérifiée avec « Reduce Transparency », « Increase Contrast » et l'option « Tinted » activés ?

### Prévoir que le matériau bascule seul entre clair et sombre selon ce qui défile dessous
- Niveau de preuve : N3
- Source : Apple, WWDC25, session 219 « Meet Liquid Glass », 2025, https://developer.apple.com/videos/play/wwdc2025/219/
- Extrait lu : « Small elements like navbars and tabbars, constantly adapt their appearance depending on what's behind them. They also flip from light to dark based on the background » ; « For instance, Reduced Transparency, makes Liquid Glass frostier and obscures more of the content behind it. »
- Portée / limites : c'est la description du comportement par son concepteur, pas une évaluation. La transcription a été lue par extraits.
- En conception visuelle : une couleur de marque posée sur une barre qui s'inverse garde-t-elle son contraste dans les deux états ?

### La superposition de texte sur un contenu mobile est un risque de lisibilité connu, et pas une nouveauté
- Niveau de preuve : N4 (revue d'expert, sans test utilisateur)
- Source : Raluca Budiu (Nielsen Norman Group), 10 oct. 2025, « Liquid Glass Is Cracked, and Usability Suffers in iOS 26 », https://www.nngroup.com/articles/liquid-glass/
- Extrait lu : « One of the oldest findings in usability is that anything placed on top of something else becomes harder to see. » ; « Motion for motion's sake is not usability. »
- Portée / limites : analyse de captures et d'animations d'iOS 26 au regard des principes établis. L'article ne décrit ni participants ni test. C'est la critique la plus citée, mais ce n'est pas une mesure.
- En conception visuelle : chaque libellé posé sur du verre reste-t-il lisible au pire fond possible, une photo très contrastée qui défile sous le libellé par exemple ?

### Mesurer le contraste réel sur le pire fond, pas sur le fond de la maquette
- Niveau de preuve : N4 (praticien, une seule valeur mesurée, méthode non décrite)
- Source : Davor Naumoski (Infinum), 12 juin 2025, « Apple's iOS 26 Liquid Glass: sleek, shiny, and questionably accessible », https://infinum.com/blog/apples-ios-26-liquid-glass-sleek-shiny-and-questionably-accessible/
- Extrait lu : « We clocked 1.5:1 in places, and the bar is 4.5:1. »
- Portée / limites : mesure faite sur une bêta (« Our own early beta testing »), outil, nombre d'écrans et version non précisés. Le chiffre ne vaut pas pour la version publiée.
- En conception visuelle : la revue de contraste a-t-elle été faite avec un fond dynamique réel, et pas seulement avec le fond figé de la maquette ?

### Prévoir une variante opaque choisie par l'utilisateur (option « Tinted », iOS 26.1)
- Niveau de preuve : N4 (presse ; propos d'Apple rapporté)
- Source : MacRumors, 20 oct. 2025, « iOS 26.1 Beta 4 Lets Users Control Liquid Glass Transparency with New Toggle », https://www.macrumors.com/2025/10/20/ios-26-1-liquid-glass-toggle/
- Extrait lu : « The toggle lets users select from a clear look for Liquid Glass, or a tinted look. » ; motif attribué à Apple : « user feedback suggested that some people would prefer to have a more opaque option for Liquid Glass »
- Portée / limites : réglage apparu dans la 4e bêta d'iOS/iPadOS/macOS 26.1, sous Réglages > Luminosité et affichage (Réglages Système > Apparence sur Mac). La page d'assistance d'Apple n'a pas été trouvée. La HIG du 9 sept. 2025 mentionne déjà une « preferred look for Liquid Glass ». Avant cette option, le seul contournement était le réglage d'accessibilité « Reduce Transparency », déjà existant. Dès la première bêta, la presse le signalait (heise online, 13 juin 2025, https://heise.de/-10445465 : « If Apple's new iPhone user interface is too glassy, you can reduce the effect. »).
- En conception visuelle : l'interface tient-elle aussi en « Tinted » et en transparence réduite, en restant cohérente et pas seulement plus terne ? Le choix de l'utilisateur est devenu un état d'interface à concevoir.

### iOS 27 (WWDC, juin 2026) : un curseur continu remplace le choix binaire
- Niveau de preuve : N4 (presse ; la page officielle d'Apple n'a pas été ouverte)
- Source : Hartley Charlton (MacRumors), 10 juin 2026, « Here's How Liquid Glass Is Changing in iOS 27 », https://macrumors.com/2026/06/10/how-liquid-glass-is-changing-in-ios-27
- Extrait lu : « transparency slider in Settings » ; « anywhere from ultra clear to fully tinted » ; « more effectively diffuses complex content, improving readability throughout the system »
- Portée / limites : l'article paraphrase Apple sans le citer. Les médias divergent sur le niveau d'opacité par défaut d'iOS 27 (voir Non vérifié). En un an, la plateforme est passée d'un réglage d'accessibilité (bêta 2025) à un choix binaire (26.1, oct. 2025), puis à un curseur (27, juin 2026) : la transparence est devenue une préférence de l'utilisateur.
- En conception visuelle : l'interface tient-elle sur toute la plage du curseur, aux deux extrêmes comme au milieu ? On ne maquette plus un seul degré de transparence.

### Le verre n'est acceptable qu'avec un flou fort et un contraste vérifié, et l'utilisateur doit pouvoir le régler
- Niveau de preuve : N4 (article d'expert, sans étude)
- Source : Megan Brown (Nielsen Norman Group), 7 juin 2024, « Glassmorphism: Definition and Best Practices », https://www.nngroup.com/articles/glassmorphism/
- Extrait lu : « More background blur is better, especially with intricate backgrounds. » ; « If feasible, give users the option to control contrast or transparency settings. »
- Portée / limites : article antérieur d'un an à Liquid Glass, fondé sur des exemples et les systèmes d'Apple et de Microsoft, sans test utilisateur. Sa dernière recommandation est celle qu'Apple a fini par appliquer (option 26.1, curseur 27).
- En conception visuelle : le flou derrière le texte est-il assez fort pour « éteindre » un fond complexe ? L'utilisateur dispose-t-il d'un réglage ?

---

## 2. Material 3 Expressive (Google, annoncé le 13 mai 2025)

### Traiter les chiffres de Google sur M3 Expressive comme une recherche interne non revue, à la méthode non publiée
- Niveau de preuve : N3 (consigne de plateforme). La recherche elle-même n'est pas N2 : aucune méthode, aucun test statistique, aucune revue par les pairs.
- Source : Google, Material Design research team (page sans signature ni date ; remerciements nominatifs), « Better, Easier, Emotional UX », https://design.google/library/expressive-material-design-google-research
- Extrait lu : « Through 46 separate research studies with hundreds of designs, and more than 18,000 participants from around the world, we've fine tuned a system that's both beautiful and highly usable. »
- Portée / limites : la page ne donne ni l'effectif par étude, ni la démographie, ni les tests statistiques, ni les intervalles de confiance. Elle ne dit pas non plus si les 18 000 participants sont des personnes distinctes ou un cumul. Aucune publication revue n'est citée.
- En conception visuelle : quand un argument « M3 Expressive est prouvé » est avancé en revue, il faut demander quelle étude, quel effectif et quelle tâche il invoque. Ici, la réponse publique n'existe pas.

### Le « quatre fois plus vite » vaut pour un bouton rendu plus gros et plus saillant, pas pour un style
- Niveau de preuve : N3 (allégation d'entreprise ; oculométrie en laboratoire, effectif non publié)
- Source : Google, « Better, Easier, Emotional UX », même URL
- Extrait lu : « Participants were able to spot key UI elements up to four times faster in the M3 Expressive designs » ; « By making the Send button larger and more prominent, participants were able to spot the button four times faster. »
- Portée / limites : « up to » désigne un maximum, pas une moyenne. L'exemple détaillé, un bouton Envoyer agrandi et sorti de la barre d'outils, relève d'un principe ancien : saillance, taille, position. Il ne valide pas l'esthétique d'ensemble. Le protocole décrit : 10 applications, chacune en version M3 et en version M3 Expressive, présentées dans un ordre aléatoire.
- En conception visuelle : l'action principale est-elle visuellement dominante, par la taille, le contraste et un emplacement isolé ? C'est ce levier, plus que le « style expressif », que la mesure de Google soutient.
- Même page, sur l'âge : « we've seen a dramatic erasure of age effects in fixation times, helping 45-plus-year-old users perform on par with their younger counterparts » ; préférence « up to 87% — among 18-to-24-year-olds ». Le seuil « 45 ans et plus » est large, aucun effectif par tranche n'est publié, et la mesure porte sur le temps de fixation, pas sur la réussite de la tâche. Pour un public âgé, on mesure encore la réussite, l'erreur et la lisibilité.

### L'expressivité qui casse un motif d'interaction familier dégrade l'utilisabilité, de l'aveu même de Google
- Niveau de preuve : N3
- Source : Google, « Better, Easier, Emotional UX », même URL
- Extrait lu : « While users reported the interface looked modern and exciting, usability scores suffered. In another example, removing text labels from email actions resulted in decreased usability. » ; « No amount of expressive design will beat basic functionality. »
- Portée / limites : la page reconnaît aussi un effet de non-familiarité (« it was impacted by users' lack of familiarity »), sans le chiffrer. Sur la préférence : « a strong minority of users preferred calmer, less intense versions ».
- En conception visuelle : l'expressivité a-t-elle supprimé une étiquette, une liste ou un ordre de lecture attendu ? Un public qui préfère le calme (une « forte minorité ») a-t-il une variante ?

### Les chiffres de Google varient d'une page Google à l'autre
- Niveau de preuve : N3
- Source : Google / Android Developers, « Benefits of expressive design » (Wear OS), https://developer.android.com/design/ui/wear/guides/get-started/benefits
- Extrait lu : « Through dozens of separate research studies with hundreds of designs, and tens of thousands of participants from around the world » ; « On average, the more expressive design variants outperformed the baseline in terms of preference (~100% increase) and aesthetics (up to 170% increase). »
- Portée / limites : la même recherche est annoncée ici avec « tens of thousands » de participants, là où design.google écrit « more than 18,000 ». Les gains de préférence et d'esthétique sont donnés sans échelle ni méthode. Le billet d'annonce (Mindy Brooks, blog.google, 13 mai 2025, https://blog.google/products/android/material-3-expressive-android-wearos-launch/) ne cite, lui, aucune étude.
- En conception visuelle : citer un seul chiffre, avec la page et la date. Un chiffre qui change entre deux pages du même éditeur ne se reprend pas comme une donnée.

---

## 3. L'esthétique « par défaut » des interfaces générées par IA

### L'IA générative augmente la qualité individuelle et réduit la diversité collective
- Niveau de preuve : N2 (expérience en ligne, revue par les pairs ; 293 auteurs, 600 évaluateurs, 3 519 évaluations)
- Source : Anil R. Doshi, Oliver P. Hauser, 2024 (publié en ligne le 12 juil. 2024), « Generative AI enhances individual creativity but reduces the collective diversity of novel content », Science Advances, https://pmc.ncbi.nlm.nih.gov/articles/PMC11244532/ (résumé via Europe PMC)
- Extrait lu : « However, generative AI-enabled stories are more similar to each other than stories by humans alone. » ; « There were a total of 3519 evaluations of 293 stories made by 600 evaluators. »
- Portée / limites : la tâche porte sur des nouvelles de huit phrases, pas sur des interfaces. L'effet sur la similarité est modeste (« 10.7% and 8.9% of the total range »). Le gain individuel profite surtout aux auteurs les moins créatifs. Transposer ces résultats au design visuel est une inférence, pas un résultat.
- En conception visuelle : quand une équipe produit avec la même IA, il faut comparer les pistes entre elles et pas seulement les juger une à une. Le risque est la convergence de l'ensemble.

### Des utilisateurs différents d'un même LLM produisent des idées moins distinctes entre elles
- Niveau de preuve : N2 (étude comparative, 36 participants, petit échantillon)
- Source : Barrett R. Anderson, Jash Hemant Shah, Max Kreminski, 2024, « Homogenization Effects of Large Language Models on Human Creative Ideation », Creativity & Cognition 2024, https://arxiv.org/abs/2402.01536 (résumé seul lu)
- Extrait lu : « different users tended to produce less semantically distinct ideas with ChatGPT »
- Portée / limites : 36 participants, idéation textuelle. Les utilisateurs de ChatGPT produisaient plus d'idées, plus détaillées, et « felt less responsible for the ideas they generated ».
- En conception visuelle : en atelier, on fait produire une partie des pistes sans IA, puis on mesure l'écart entre les pistes avec et sans.

### Laissés en boucle, les générateurs d'images convergent vers douze motifs « commercialement sûrs »
- Niveau de preuve : N2 (revue par les pairs ; expérience computationnelle, sans participants humains)
- Source : Arend Hintze, Frida Proschinger Åström, Jory Schossau, 19 déc. 2025, « Autonomous language-image generation loops converge to generic visual motifs », Patterns 7(1):101451, https://pmc.ncbi.nlm.nih.gov/articles/PMC12827715/
- Extrait lu : « Across 700 trajectories with diverse prompts and 7 temperature settings over 100 iterations » ; « Quantitative analysis revealed just 12 dominant motifs with commercially safe aesthetics »
- Portée / limites : boucle Stable Diffusion XL et LLaVA, sans humain. Cela montre la pente des modèles, pas ce que fait un designer qui les utilise. L'étude porte sur des images, pas sur des interfaces.
- En conception visuelle : une image d'illustration générée ressemble-t-elle à de la banque d'images générique (« visual elevator music ») ? Il faut le vérifier avant de l'adopter comme identité.

### Les outils de génération d'interface convergent sur l'apparence et la mise en page, moins sur la couleur
- Niveau de preuve : N2 (banc de 120 interfaces, 5 outils ; préprint annoncé accepté à AAAI/AIES ; résumé seul lu)
- Source : Kashif Imteyaz, Kaif Imteyaz, Nakul Rajpal, Kaif Shaikh, Michael Muller, Saiph Savage, juil. 2026, « Design Theater: Evaluating the Gap Between User-Facing Design Reasoning and Implementation in Generative UI Tools », https://arxiv.org/abs/2607.22928
- Extrait lu : « over 25% of user-facing design rationales are not implemented in the generated interface » ; « convergence in visual appearance and layout organization, with greater variation in color choices. »
- Portée / limites : 24 tâches. Les outils ne sont pas nommés dans le résumé lu. Le « design theater » désigne une justification de design affichée par l'outil mais non réalisée dans le code produit.
- En conception visuelle : il faut vérifier sur le rendu, pas dans l'explication de l'outil, que chaque choix annoncé (hiérarchie, contraste, état) est réellement implémenté.

### Des sites « vibe-codés » par une même cohorte se concentrent visuellement, sans que leurs auteurs le perçoivent
- Niveau de preuve : N2 faible (préprint non revu, 73 sites, un seul outil ; résumé seul lu)
- Source : Léonard Boussioux, Ziyi Zhao, Kanghyun Cho, 5 août 2026, « One Tool, One Taste? How Vibe Coding Trades Collective Diversity for Individual Creativity », https://arxiv.org/abs/2609.38183
- Extrait lu : « These results document within-cohort visual concentration » ; « collective cost of generative production reaches visual design »
- Portée / limites : étudiants de master, outil Lovable, similarité calculée sur des plongements d'image (DINOv3), qui ne mesurent pas la similarité perçue. Selon le résumé, le contrôle perçu, la satisfaction et la qualité perçue ne sont pas associés à l'atypicité. Les pourcentages de similarité repris par des sites secondaires n'ont pas été lus dans la source.
- En conception visuelle : la satisfaction du concepteur n'est pas un indicateur d'originalité. Il faut comparer la page à celles de ses voisins (concurrents, autres projets faits avec le même outil).

### Les générateurs d'interface passent les contrôles de base d'accessibilité, au prix de motifs homogénéisés
- Niveau de preuve : N2 (90 interfaces, 2 outils, 8 designers interrogés ; résumé seul lu)
- Source : Alexandra E. Guriță, Radu-Daniel Vatavu, 2025, « Good Accessibility, Handcuffed Creativity: AI-Generated UIs Between Accessibility Guidelines and Practitioners' Expectations », ACM DIS 2025, https://doi.org/10.1145/3715336.3735691 (résumé lu via l'API Semantic Scholar)
- Extrait lu : « while these tools consistently achieve basic accessibility compliance, they rely on homogenized design patterns, which can limit their effectiveness in addressing specialized user needs. »
- Portée / limites : deux outils seulement, trois domaines d'application. Ce résultat est contredit par une étude plus large de 2026 (entrée suivante).
- En conception visuelle : une interface générée « conforme » répond-elle au besoin spécifique de l'utilisateur, ou seulement au cas moyen ?

### Ne pas présumer qu'une interface générée par IA est accessible : sur 6 outils, 29 % de conformité seulement
- Niveau de preuve : N2 (54 designers, 6 outils, 21 880 évaluations ; résumé seul lu)
- Source : Wajdi M. Aljedaani, Lyan Ibrahim Koumu, Alexandra-Elena Guriță, 13 avr. 2026, « Generated Inaccessible: Measuring WCAG Violations in AI UI Design Tools », Proceedings of the 23rd International Web for All Conference (W4A 2026), https://doi.org/10.1145/3800424.3800430 (résumé lu via l'API Semantic Scholar)
- Extrait lu : « AI-generated interfaces achieved only 29.0% compliance, with deterministic criteria such as color contrast (26.8%) and the use of color (19.2%) showing the lowest adherence. Counterintuitively, explicitly specifying accessibility requirements in generation prompts decreased rather than improved compliance. »
- Portée / limites : cinq critères WCAG évalués. Une co-autrice est commune avec l'étude DIS 2025, dont les conclusions diffèrent : outils, échantillons et critères ne sont pas les mêmes.
- En conception visuelle : le contraste et l'usage de la couleur se contrôlent à l'outil sur tout écran généré. Écrire « accessible » dans le prompt ne garantit rien, et peut même aggraver le résultat.

### Le risque d'homogénéisation est surtout théorisé ; on y répond par une « friction productive »
- Niveau de preuve : N4 (article de position et analyse de risques, sans mesure)
- Source : Donghoon Shin, Alice Gao, Rock Yuren Pang, Jaewook Lee, Katharina Reinecke, Emily Tseng, 13 mars 2026, « Interrogating Design Homogenization in Web Vibe Coding », https://arxiv.org/abs/2603.13036 (résumé seul lu)
- Extrait lu : « Generative AI is known for its tendency to homogenize, often reproducing dominant style conventions found in training data. » ; « We identify that the push for frictionless generation can exacerbate homogenization and its harms. »
- Portée / limites : cadre conceptuel et études de cas illustratives. Il ne mesure pas l'homogénéité.
- En conception visuelle : quelle étape du flux oblige à contester la sortie par défaut ? Par exemple, imposer trois directions contrastées avant de raffiner la première.

---

## 4. Outils de conception et IA : effets mesurés sur les designers

### Montrer des images générées pendant l'idéation accroît la fixation et réduit le nombre, la variété et l'originalité des idées
- Niveau de preuve : N2 (expérience inter-sujets, N=60, CHI 2024)
- Source : Samangi Wadinambiarachchi, Ryan M. Kelly, Saumya Pareek, Qiushi Zhou, Eduardo Velloso, 2024, « The Effects of Generative AI on Design Fixation and Divergent Thinking », CHI '24, https://arxiv.org/abs/2403.11164 (résumé seul lu)
- Extrait lu : « support from an AI image generator during ideation leads to higher fixation on an initial example. Participants who used AI produced fewer ideas, with less variety and lower originality compared to a baseline. »
- Portée / limites : tâche de croquis (avatar de chatbot), comparée à une recherche d'images Google et à une condition sans source. Les auteurs décrivent un déplacement de la fixation, de l'exemple initial vers les sorties de l'IA.
- En conception visuelle : la divergence se fait à la main avant d'ouvrir le générateur. La première image générée devient sinon le point d'ancrage de toute la recherche.

### Un LLM n'améliore pas le cadrage d'un problème de design et creuse l'écart entre experts et novices
- Niveau de preuve : N2 (N=280, CHI 2025)
- Source : Joongi Shin, Anna Polyanskaya, Andrés Lucero, Antti Oulasvirta, 2025, « No Evidence for LLMs Being Useful in Problem Reframing », CHI '25, https://ar5iv.labs.arxiv.org/html/2503.01631 (résumé et début de l'article lus)
- Extrait lu : « We found that using LLMs does not help improve the quality of problem frames. » ; « In fact, it increases the competence gap between experienced and inexperienced designers. »
- Portée / limites : l'étude compare trois façons d'utiliser un LLM et porte sur le recadrage d'un problème, pas sur la production visuelle. Les novices y perçoivent aussi une agence moindre.
- En conception visuelle : réserver l'IA à la production, une fois le problème cadré par un humain. Un junior qui s'appuie sur l'IA pour cadrer doit être relu par un senior.

### Les designers jugent l'IA moins utile à la qualité de leur travail que les développeurs
- Niveau de preuve : N4 (enquête d'un éditeur d'outil auprès de ses utilisateurs, 2 500 répondants)
- Source : Andrew Hogan (Figma), 24 avr. 2025, « Figma's 2025 AI report: Perspectives from designers and developers », https://www.figma.com/blog/figma-2025-ai-report-perspectives/
- Extrait lu : « Developers report higher satisfaction with AI tools (82%) and feel AI improves the quality of their work (68%). » ; « Meanwhile, designers show more modest numbers—69% satisfaction rate and 54% reporting quality improvement— »
- Portée / limites : déclaratif, échantillon d'utilisateurs Figma, éditeur partie prenante. Les chiffres développeurs varient dans la page elle-même : 68 % dans le texte, 67 % dans la légende.
- En conception visuelle : un gain déclaré n'est pas un gain mesuré. Avant de généraliser l'IA dans une équipe, comparer la qualité et la diversité des livrables avec et sans IA.

---

## 5. État réel du web (HTTP Archive, Web Almanac 2025, publié le 15 janv. 2026 ; dernière édition disponible au 9 nov. 2026)

### Partir du principe que le contraste échoue : 30 % seulement des sites le réussissent
- Niveau de preuve : N2 (mesure automatisée sur l'échantillon de crawl HTTP Archive, environ 17 millions de sites par mois selon la page)
- Source : Bogdan Lazar, Mike Gifford (et al.), 2026, Web Almanac 2025, chapitre « Accessibility », https://almanac.httparchive.org/en/2025/accessibility
- Extrait lu : « In 2025 on both desktop and mobile it is 30%. Figure 6.3. Sites with sufficient color contrast. This year, text contrast pass rate improved by roughly 1% compared to 2024. But only 31% of mobile sites currently meet minimum color contrast requirements. »
- Portée / limites : contrôle automatisé de type Lighthouse sur la page d'accueil. La page elle-même donne 30 % et 31 % pour le mobile. Un test automatique ne voit pas le texte posé sur une image ou sur du verre : le chiffre réel est sans doute pire.
- En conception visuelle : la palette a-t-elle été validée par paires texte/fond réelles, états de survol et désactivé compris ?

### Supprimer l'anneau de focus sans le remplacer est devenu majoritaire : à traiter comme un défaut par défaut
- Niveau de preuve : N2
- Source : Web Almanac 2025, « Accessibility », même URL
- Extrait lu : « In 2025, 67% of sites explicitly removed default focus outlines, up 14% from 2024. This concerning trend may impair accessibility if not replaced with effective styles. »
- Portée / limites : `:focus-visible` est présent sur environ un quart des pages (25 % desktop, 24 % mobile). La mesure dit qu'on supprime l'anneau, pas qu'on omet de le remplacer.
- En conception visuelle : la maquette comporte-t-elle un état de focus dessiné, visible sur chaque fond, y compris sur le verre ?

### `prefers-reduced-motion` présent sur une page sur deux, `prefers-color-scheme` sur une sur huit : présence n'est pas respect
- Niveau de preuve : N2
- Source : Web Almanac 2025, « Accessibility », même URL
- Extrait lu : « The most widely used feature is prefers-reduced-motion, appearing on about half of both desktop (49.99%) and mobile (50.55%) pages. » ; « Other features, such as prefers-color-scheme (about 13% on both platforms) and prefers-contrast (around 1%), are used much less »
- Portée / limites : le chiffre compte la présence de la media query dans le CSS, souvent apportée par un framework ou une bibliothèque, pas la qualité de ce qui est réduit. `prefers-contrast` reste quasi absent (environ 1 %), alors que les plateformes poussent les réglages de contraste (cf. Liquid Glass).
- En conception visuelle : la variante « mouvement réduit » est-elle spécifiée, avec ce qui disparaît et ce qui devient fondu ? Le mode sombre est-il dessiné, ou laissé au hasard ? Une variante « contraste accru » existe-t-elle ?

### Les polices variables sont devenues courantes : environ 4 sites sur 10
- Niveau de preuve : N2
- Source : Charles Berret (rédaction et analyse avec Ivan Ukhov), 15 janv. 2026 (mis à jour le 10 févr. 2026), Web Almanac 2025, chapitre « Fonts », https://almanac.httparchive.org/en/2025/fonts
- Extrait lu : « This year, 39.4% of desktop websites and 41.3% of mobile websites used at least one variable font on their pages. In other words, now about 4 in 10 sites are using variable fonts. »
- Portée / limites : « au moins une » police variable. La distribution est très concentrée (« very top-heavy ») : Noto Sans JP reste la police variable la plus utilisée. Le chiffre ne dit pas si les axes sont réellement exploités. D'après le même chapitre, les polices web sont présentes sur environ 88 % des sites, environ 72 % des sites servent au moins un fichier de police depuis leur propre origine, et `system-ui` n'est utilisé que sur environ 9,7 % des pages desktop.
- En conception visuelle : si une variable est chargée, l'échelle typographique exploite-t-elle les graisses intermédiaires et l'axe optique, ou la police ne sert-elle qu'à deux graisses ?

---

## 6. Nouvelles capacités CSS : statut Baseline vérifié (au 9 nov. 2026)

> Source commune : les données `web-features`, qui alimentent les bandeaux Baseline de MDN et de web.dev. Version
> 3.45.0 téléchargée depuis https://unpkg.com/web-features@3.45.0/data.json, recoupée avec l'API de
> https://webstatus.dev (`/v1/features/<id>`) et, pour deux propriétés, avec les bandeaux MDN. « Newly » = disponible dans
> tous les navigateurs principaux ; « Widely » = 30 mois après.

### Construire les palettes en `oklch()` et dériver les teintes avec `color-mix()` : les deux sont « Widely available »
- Niveau de preuve : N3
- Source : web-features 3.45.0 (`oklab` « Oklab and OkLCh », `color-mix`), https://unpkg.com/web-features@3.45.0/data.json ; webstatus.dev, https://api.webstatus.dev/v1/features/oklab
- Extrait lu : `oklab` : « {'high_date': '2025-11-09', 'low_date': '2023-05-09', 'status': 'widely'} » ; `color-mix` : baseline « high », low 2023-05-09, high 2025-11-09
- Portée / limites : Baseline élevé depuis le 9 nov. 2025. Les couleurs relatives (`relative-color`, syntaxe `from`) ne sont que « Newly available » depuis le 16 sept. 2024.
- En conception visuelle : les jetons de couleur sont-ils définis dans un espace perceptuellement uniforme (oklch), pour que les paliers de clarté soient réguliers et que le contraste soit prévisible ?

### Concevoir des composants qui s'adaptent à leur conteneur : les container queries de taille sont « Widely », les requêtes de style non
- Niveau de preuve : N3
- Source : web-features 3.45.0 (`container-queries`, `container-style-queries`), même URL ; https://api.webstatus.dev/v1/features/container-queries
- Extrait lu : `container-queries` : « {'high_date': '2025-08-14', 'low_date': '2023-02-14', 'status': 'widely'} » ; `container-style-queries` : baseline « low », low_date 2026-05-19
- Portée / limites : les requêtes de taille sont « Widely » depuis le 14 août 2025. Les requêtes de style ne sont « Newly » que depuis le 19 mai 2026.
- En conception visuelle : la maquette d'un composant, une carte de grille bento par exemple, prévoit-elle ses états étroit, moyen et large selon la place qu'il reçoit, et pas selon l'écran ?

### Les transitions de vue dans un même document sont Baseline depuis octobre 2025, pas les transitions entre pages
- Niveau de preuve : N3
- Source : web-features 3.45.0 (`view-transitions`, `cross-document-view-transitions`), même URL ; https://api.webstatus.dev/v1/features/view-transitions
- Extrait lu : `view-transitions` : « {'low_date': '2025-10-14', 'status': 'newly'} » ; `cross-document-view-transitions` : baseline « False » (support listé : Chrome/Edge 126, Safari 18.2 ; pas de Firefox)
- Portée / limites : le passage en « Newly » vient de Firefox 144. Les transitions entre documents d'un site multipage restent une amélioration progressive.
- En conception visuelle : les transitions spécifiées ont-elles un repli sans animation, et une variante pour `prefers-reduced-motion` ?

### Le mode sombre en une déclaration avec `light-dark()` : « Newly available » depuis mai 2024
- Niveau de preuve : N3
- Source : MDN, « light-dark() », https://developer.mozilla.org/en-US/docs/Web/CSS/color_value/light-dark ; web-features 3.45.0 (`light-dark`)
- Extrait lu : « Baseline 2024 » « Newly available » « Since May 2024, this feature works across the latest devices and browser versions. »
- Portée / limites : `light-dark()` suppose `color-scheme` déclaré. Par mon calcul (mai 2024 + 30 mois), il deviendrait « Widely available » vers le 13 nov. 2026 ; ce n'est pas encore le cas au 9 nov. 2026.
- En conception visuelle : chaque jeton de couleur a-t-il sa paire claire et sombre spécifiée et contrôlée en contraste ? C'est d'autant plus utile que 13 % seulement des pages interrogent `prefers-color-scheme` (section 5).

### `text-wrap: balance` est Baseline pour les titres, `text-wrap: pretty` ne l'est pas
- Niveau de preuve : N3
- Source : web-features 3.45.0 (`text-wrap-balance`, `text-wrap-pretty`), même URL ; https://api.webstatus.dev/v1/features/text-wrap-pretty ; MDN, « text-wrap », https://developer.mozilla.org/en-US/docs/Web/CSS/text-wrap
- Extrait lu : `text-wrap-balance` : baseline « low », low_date 2024-05-13 ; `text-wrap-pretty` : « {'status': 'limited'} » (Chrome/Edge 117, Safari 26 ; pas de Firefox) ; bandeau MDN de la propriété : « It's been available across browsers since March 2024. » et « * Some parts of this feature may have varying levels of support. »
- Portée / limites : le bandeau MDN « Widely available » couvre la propriété `text-wrap` dans son ensemble, pas chacune de ses valeurs (voir Mythes).
- En conception visuelle : les titres sur plusieurs lignes sont-ils équilibrés (`balance`) ? Les veuves de paragraphe ne sont évitées par `pretty` que là où il est pris en charge, et le texte doit rester correct sans lui.

### Animer l'apparition d'un élément avec `@starting-style` : « Newly available » depuis août 2024
- Niveau de preuve : N3
- Source : web-features 3.45.0 (`starting-style`), même URL ; https://api.webstatus.dev/v1/features/starting-style
- Extrait lu : « {'low_date': '2024-08-06', 'status': 'newly'} »
- Portée / limites : `interpolate-size` (animer vers `auto`) reste non Baseline (Chrome/Edge 129 seulement dans les données lues). Le Popover est « Newly » depuis le 27 janv. 2025.
- En conception visuelle : les entrées de menu, de dialogue ou de popover sont-elles spécifiées, avec durée, courbe et version réduite ?

---

## 7. Tendances visuelles : ce qui est mesuré et ce qui ne l'est pas

### Un élément cliquable doit porter un signifiant visible : la seule mesure solide sur « plat contre relief » date de 2017
- Niveau de preuve : N2 (expérience d'oculométrie, 71 participants, non revue par les pairs, menée par NN/g)
- Source : Kate Moran (Nielsen Norman Group), 3 sept. 2017, « Flat UI Elements Attract Less Attention and Cause Uncertainty », https://www.nngroup.com/articles/flat-ui-less-attention-cause-uncertainty/
- Extrait lu : « recruited 71 general web-users to participate in the experiment » ; « 22% more time » ; « 25% more fixations »
- Portée / limites : hors de la fenêtre 2024-2026, mais c'est la mesure la plus proche de la question « faut-il revenir au relief ». Ce qu'elle compare, c'est un signifiant fort contre un signifiant faible, pas un style contre un autre. Elle ne valide donc ni le skeuomorphisme ni le verre en tant qu'esthétiques.
- En conception visuelle : une action se reconnaît-elle comme cliquable sans survol, avec la forme, le contraste et l'étiquette, et cela quel que soit le style (verre, plat, relief) ?

### Grilles bento : aucune mesure trouvée, seulement des affirmations sans source
- Niveau de preuve : N4 (contenu d'éditeur, chiffres sans source)
- Source : SaaSFrame, 2026 (sans auteur ni date précise), « Designing Bento Grids That Actually Work: A 2026 Practical Guide », https://www.saasframe.io/blog/designing-bento-grids-that-actually-work-a-2026-practical-guide
- Extrait lu : « Eye tracking studies show users fixate 2.6× longer on larger grid items, regardless of position. » ; « Tasks are completed 23% faster with modular layouts compared to traditional linear designs. »
- Portée / limites : aucune étude citée pour ces chiffres. Aucune étude revue sur la grille bento n'a été trouvée.
- En conception visuelle : une grille bento a-t-elle un ordre de lecture défini et une hiérarchie claire ? Comment se replie-t-elle en une colonne et à 200 % de zoom ? Ce qui se vérifie, ce sont ces propriétés, pas la tendance.

---

## Mythes et affirmations contestées

- **« Material 3 Expressive fait repérer les éléments quatre fois plus vite. »** La source dit « up to » : c'est un maximum, pas une moyenne. L'exemple détaillé est un bouton Envoyer rendu plus gros et déplacé : la saillance explique le gain, pas l'esthétique. Aucune méthode n'est publiée (section 2).
- **« 46 études, 18 000 participants. »** Une autre page Google, Android Developers / Wear OS, annonce pour la même recherche « dozens » d'études et « tens of thousands » de participants. Aucune revue par les pairs. On cite ce chiffre comme une allégation d'entreprise, avec sa page.
- **« Liquid Glass a été mesuré à 1,5:1. »** Une seule valeur, sur une bêta de juin 2025, sans outil ni méthode décrits (Infinum). Ce n'est pas une mesure de la version publiée. Aucune étude revue mesurant la lisibilité de Liquid Glass n'a été trouvée.
- **« NN/g a testé Liquid Glass. »** L'article de R. Budiu (10 oct. 2025) est une revue d'expert sans participants. Il est solide sur les principes, mais ce n'est pas un test.
- **« La moitié des sites respecte la réduction des animations. »** Le Web Almanac 2025 compte la présence de `prefers-reduced-motion` dans le CSS (environ 50 %), pas un respect effectif.
- **« `text-wrap` est Widely available, donc `pretty` aussi. »** Faux. Le bandeau MDN vaut pour la propriété (« Some parts of this feature may have varying levels of support ») ; `text-wrap: pretty` est « limited » (pas de Firefox dans les données web-features 3.45.0).
- **« Les View Transitions sont Baseline. »** Seulement dans un même document (« Newly », 14 oct. 2025). Les transitions entre pages ne le sont pas.
- **« Les outils d'IA produisent des interfaces accessibles. »** Les résultats se contredisent : conformité de base atteinte selon Guriță & Vatavu (DIS 2025, 2 outils, 90 interfaces) ; 29 % de conformité et un prompt « accessible » qui aggrave le résultat selon Aljedaani et al. (W4A 2026, 6 outils, 54 designers). Il faut contrôler chaque écran.
- **« L'IA rend chaque designer plus créatif, donc l'équipe aussi. »** Doshi & Hauser (2024) montrent le contraire au niveau collectif : la qualité individuelle augmente et la diversité d'ensemble diminue.
- **Chiffres bento (« 2.6× », « 23% faster », « 67% of the top 100 SaaS products »)** : affirmations sans source (SaaSFrame). Elles ne sont pas à reprendre.

## Non vérifié

- **Page officielle d'Apple sur iOS 27 (juin 2026)** : non ouverte (URL non trouvée, `apple.com/ios/ios-27/` en 404). Les changements d'iOS 27 (curseur de transparence, bords assombris, icônes en couches) ne viennent que de la presse (MacRumors).
- **Opacité par défaut d'iOS 27** : les sources secondaires se contredisent (moins transparent par défaut, ou plus). Non tranché.
- **Page d'assistance d'Apple pour l'option « Clear / Tinted » d'iOS 26.1** : non trouvée. La formulation « Tinted increases opacity and adds more contrast », attribuée à Apple par la presse, n'a pas été lue chez Apple.
- **Étude revue mesurant la lisibilité du verre ou de Liquid Glass (contraste, temps de lecture)** : aucune trouvée pour 2024-2026.
- **Étude mesurant l'effet d'une typographie surdimensionnée (titres géants) sur la compréhension ou la conversion** : aucune trouvée. Les chiffres qui circulent (sites de type Flowpoint ou Strategia-X citant des rapports « CXL 2025 » ou « Baymard 2025 ») n'ont pas été retrouvés à la source.
- **Étude mesurant l'effet d'un « retour du skeuomorphisme »** : aucune trouvée. La seule mesure apparentée date de 2017 (NN/g, signifiants).
- **Anecdote d'Adam Wathan (créateur de Tailwind) s'excusant d'avoir rendu `bg-indigo-500` omniprésent, ce qui expliquerait le violet des interfaces générées** : le message d'origine sur X n'a pas été lu, seulement des reprises secondaires. Le mécanisme supposé (données d'entraînement) n'est mesuré par aucune étude trouvée.
- **Pourcentages de similarité de « One Tool, One Taste? » (49 % contre 23 %) repris par des sites secondaires** : absents du résumé lu. Non vérifiés.
- **« Understanding Design Fixation in Generative AI » (Chen et al., arXiv 2502.05870, févr. 2025)** : identifié par recherche, page non ouverte, non retenu.
- **Détails par étude de M3 Expressive** (effectifs, pays, tests statistiques) : non publiés par Google à la date de lecture.
- **Web Almanac 2026** : non paru au 9 nov. 2026 (`/en/2026/` en 404). Les chiffres de la section 5 sont ceux de l'édition 2025 (crawl 2025, publication du 15 janv. 2026). Le chapitre CSS 2025 n'existe pas (`/en/2025/css` en 404) : l'adoption réelle de `oklch()`, `color-mix()` ou des container queries sur le web n'a pas été chiffrée ici.
- **Anchor positioning** : les données web-features 3.45.0 ne listent qu'un support Safari 27, ce qui paraît incomplet. Statut non retenu.

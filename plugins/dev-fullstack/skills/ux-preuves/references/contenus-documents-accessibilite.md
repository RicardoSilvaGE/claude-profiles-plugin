# Fiche `ux-preuves` — Contenus, documents, accessibilité

> Fiche du skill `ux-preuves` (dev-fullstack). Couvre : lecture à l'écran, langage clair, documents longs, PDF et Office, tableaux ; WCAG 2.2, WCAG 3, EAA, RGAA, accessibilité cognitive.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Mythes » et « Non
> vérifié » en fin de fiche sont opposables autant que les entrées : ce qui y figure ne se cite
> pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche documentaire du 9 novembre 2026. Toutes les entrées viennent de pages réellement ouvertes
> (WebFetch, ou curl + pdftotext pour deux PDF). Les extraits sont verbatim, dans la langue d'origine.
> Quand seul un résumé ou une source secondaire a été lu, c'est dit dans « Portée / limites ».
> Niveaux : N1 norme/réglementation · N2 recherche revue par pairs ou étude empirique à large échantillon
> · N3 guideline officielle d'institution ou de plateforme · N4 avis d'expert, article de praticien.
>
> 34 entrées : 12 (lecture à l'écran) + 13 (langage clair et documents) + 9 (accessibilité et inclusion).

---

## 1. Lecture à l'écran et contenu

### Casser tout « mur de texte » (intertitres, gras sur les mots clés, listes) : sans repères visuels, l'œil retombe sur le balayage en F et rate la droite de la page
- Niveau de preuve : N4 (étude oculométrique de praticien, non revue par pairs)
- Source : Kara Pernice (Nielsen Norman Group), 2017, « F-Shaped Pattern of Reading on the Web: Misunderstood, But Still Relevant (Even on Mobile) », https://www.nngroup.com/articles/f-shaped-pattern-reading-web-content/
- Extrait lu : « The F-pattern is the default pattern when there are no strong cues to attract the eyes towards meaningful information. » ; « the F-shaped scanning pattern is bad for users and businesses »
- Portée / limites : motif identifié en 2006, article publié le 12.11.2017 (relu par NN/g le 19.08.2026). Trois conditions réunies : texte peu formaté, utilisateur pressé, utilisateur peu engagé. L'article ne donne pas la taille de l'échantillon de 2006, seulement celle de certains exemples (45+ et 47 participants). Le F est un **symptôme à éviter**, pas un gabarit de mise en page. Remèdes cités : points clés dans les deux premiers paragraphes, intertitres plus visibles que le corps, mots clés en gras, puces et numéros, liens explicites.

### Écrire des intertitres qui portent le sens à eux seuls : le balayage « en gâteau à étages » (layer-cake), sur les titres, est le mode de survol le plus efficace
- Niveau de preuve : N4 (étude oculométrique de praticien)
- Source : Kara Pernice (Nielsen Norman Group), 2019, « Text Scanning Patterns: Eyetracking Evidence », https://www.nngroup.com/articles/text-scanning-patterns-eyetracking/
- Extrait lu : « The layer-cake scanning pattern consists of fixations placed mostly on the page's headings and subheadings. » ; layer-cake = « by far the most effective way in which users can scan pages »
- Portée / limites : article du 25.08.2019. Il décrit aussi le motif « spotted » (fixations éparses sur des mots) et le motif « commitment » (lecture complète, qui « usually leads to the best comprehension » mais coûte le plus de temps). Méthode d'ensemble non décrite, exemples entre 1 et 47 participants. Les motifs « marking » et « bypassing » sont décrits dans l'article de 2017 cité plus haut, pas dans celui-ci.

### Écrire concis, découpable et factuel en même temps : les trois leviers se cumulent, et la plupart des lecteurs balaient au lieu de lire
- Niveau de preuve : N4 (étude utilisateur de praticien, ancienne)
- Source : Jakob Nielsen (Nielsen Norman Group), 1997, « How Users Read on the Web », https://www.nngroup.com/articles/how-users-read-on-the-web/
- Extrait lu : « They don't. » ; 79 % des testeurs balaient toujours une nouvelle page, 16 % lisent mot à mot. Gains d'utilisabilité mesurés : texte concis +58 %, mise en page découpable +47 %, langage objectif +27 %, les trois combinés +124 %.
- Portée / limites : article du 30.09.1997, taille d'échantillon non indiquée sur la page, web de 1997. À citer pour l'**effet cumulé** des trois leviers, pas comme un chiffre actuel. Complément : Nielsen (2008, « How Little Do Users Read? », https://www.nngroup.com/articles/how-little-do-users-read/) : « users have time to read at most 28% of the words during an average visit; 20% is more likely. » Ce chiffre vient d'une réanalyse des données de Weinreich et al. (navigateurs instrumentés de 25 utilisateurs, 45 237 pages vues retenues), avec un petit échantillon de personnes.

### Mettre le mot porteur en tête de chaque intertitre, item de liste et lien : on n'en lit souvent que les deux premiers mots
- Niveau de preuve : N4 (avis d'expert appuyé sur un test de 80 personnes)
- Source : Jakob Nielsen (Nielsen Norman Group), 2009, « First 2 Words: A Signal for the Scanning Eye », https://www.nngroup.com/articles/first-2-words-a-signal-for-scanning/
- Extrait lu : « Users typically see about 2 words for most list items. »
- Portée / limites : article du 06.04.2009. Le test porte sur la compréhension des 11 premiers caractères de 20 liens, avec « 80 people broadly distributed across age groups, gender, and education ». Échantillon plutôt jeune et diplômé, de l'aveu même de l'auteur. Le « 2 mots » vient d'observations oculométriques, pas de ce test.

### Ouvrir chaque page, section ou message par la conclusion (pyramide inversée), puis descendre vers le détail
- Niveau de preuve : N3 (guide officiel), appuyé par N4
- Source : Gouvernement du Canada, « Guide de rédaction du contenu du site Canada.ca » (version anglaise lue), § 2.2, https://design.canada.ca/style-guide/ ; Amy Schade (NN/g), 2018, « Inverted Pyramid: Writing for Comprehension », https://www.nngroup.com/articles/inverted-pyramid/
- Extrait lu : « Start with the most important idea, step or information. » (Canada) ; « the most important information (or what might even be considered the conclusion) is presented first » (Schade)
- Portée / limites : la date de mise à jour du guide canadien n'apparaît pas dans le texte lu (lecture tronquée à 100 000 caractères sur 115 000). L'article NN/g du 11.02.2018 ne présente aucune étude propre. Il renvoie aux travaux NN/g sur la lecture. La règle vaut aussi pour les documents : rapport, note ou e-mail.

### Intertitrer environ tous les 200 mots et préférer une courte liste verticale à un long paragraphe
- Niveau de preuve : N3
- Source : Gouvernement du Canada, guide de rédaction Canada.ca, § 5.1 et 5.2, https://design.canada.ca/style-guide/
- Extrait lu : « Use headings to divide text into logical sections approximately every 200 words. » ; « A short vertical list is easier for people to scan and remember than a long paragraph. »
- Portée / limites : la cadence de 200 mots est une règle de pratique, sans étude citée à l'appui. Le guide vise le web gouvernemental, mais la règle se transpose aux rapports longs.

### Pour un texte à lire longtemps à l'écran, viser un corps d'environ 18 pt (≈ 24 px) avec un interlignage par défaut : en dessous, lisibilité et compréhension baissent
- Niveau de preuve : N2 (actes de CHI 2016 revus par pairs, 104 participants, oculométrie)
- Source : Luz Rello, Martin Pielot, Mari-Carmen Marcos, 2016, « Make It Big! The Effect of Font Size and Line Spacing on Online Readability », CHI 2016, doi 10.1145/2858036.2858204. Lu via la synthèse BYU Editing Research : https://editingresearch.byu.edu/?p=10398
- Extrait lu : « Up to a font size of 18 points, subjective and objective readability as well as comprehension improved continuously » (citation du papier, p. 3646, rapportée par BYU)
- Portée / limites : **résumé secondaire seul lu**, texte intégral non accessible (ACM fermé, 403). Protocole : 104 volontaires de 14 à 54 ans, six articles Wikipédia, six corps (10 à 26 pt), quatre interlignages (0,8 à 1,4 fois la valeur par défaut). Les interlignages extrêmes nuisent à la compréhension. L'interlignage n'a pas d'effet significatif sur le temps de lecture. Écran de bureau seulement : rien sur mobile ni sur papier.

### Ne pas choisir la longueur de ligne d'après la préférence déclarée : les lignes longues se lisent plus vite sans perte de compréhension, alors que les lecteurs préfèrent des lignes moyennes
- Niveau de preuve : N2 (revue à comité de lecture)
- Source : Mary C. Dyson, Gary J. Kipping, 1998, « The Effects of Line Length and Method of Movement on Patterns of Reading from Screen », Visible Language 32(2), https://journals.uc.edu/index.php/vl/article/view/5671
- Extrait lu : « Long lines (100 characters) were found to be read faster than very short lines (25 characters), » « while comprehension remained constant. » ; « moderate line lengths (55 characters per line) easiest to read. »
- Portée / limites : **résumé seul lu**, taille d'échantillon non indiquée. Écrans de 1998. La vitesse n'est pas le confort : pour un texte long, la cible pratique reste de 55 à 80 caractères (voir WCAG 1.4.8 ci-dessous). Les auteurs notent que les résultats « could not be predicted from literature on the legibility of print ».

### Plafonner la largeur des blocs de texte à 80 caractères (40 en CJK) quand on vise une accessibilité renforcée
- Niveau de preuve : N1 (WCAG 2.2, critère 1.4.8, niveau AAA)
- Source : W3C, 2023/2024, « Web Content Accessibility Guidelines (WCAG) 2.2 », https://www.w3.org/TR/WCAG22/
- Extrait lu : « Width is no more than 80 characters or glyphs (40 if CJK). »
- Portée / limites : niveau AAA, donc non exigé par le niveau AA réglementaire. Repère normatif utile pour les gabarits de documents et de pages.

### Sur mobile, rester bref et découper davantage pour les contenus difficiles : la compréhension est équivalente, mais les textes ardus s'y lisent plus lentement
- Niveau de preuve : N2 (étude empirique à large échantillon, non revue par pairs, 276 participants)
- Source : Kate Moran (Nielsen Norman Group), 2016, « Reading Content on Mobile Devices », https://www.nngroup.com/articles/mobile-content/
- Extrait lu : « no practical differences in the comprehension scores of the participants » ; « hard passages actually took longer on mobile versus computer » ; « we still recommend prioritizing brevity »
- Portée / limites : article du 11.12.2016, 1 629 cas (article lu + questionnaire). Les sous-totaux des quatre phases font 286 et non 276 : l'article ne les réconcilie pas. Textes faciles : 404 mots, niveau 8e année. Textes difficiles : 988 mots, niveau 12e année. Pour les contenus complexes (finance, médical, B2B technique), l'auteure recommande de tester soi-même.

### Viser un niveau de lecture de 8e année (fin de primaire / début de secondaire) pour le grand public, et même les experts préfèrent un texte clair
- Niveau de preuve : N4
- Source : Jakob Nielsen (NN/g), 2015, « Legibility, Readability, and Comprehension: Making Users Read Your Words », https://www.nngroup.com/articles/legibility-readability-comprehension/ ; Hoa Loranger (NN/g), 2017, « Plain Language Is for Everyone, Even Experts », https://www.nngroup.com/articles/plain-language-experts/
- Extrait lu : « Aim at an 8th-grade reading level if targeting a broad consumer audience. » ; « even highly educated online readers crave succinct information that is easy to scan. »
- Portée / limites : Nielsen (15.11.2015) propose la 12e année pour un public diplômé ou B2B. Loranger (08.10.2017) s'appuie sur des verbatims qualitatifs d'experts (IT, professeur, infirmière praticienne), échantillon non chiffré. Le « niveau scolaire » vient de formules de lisibilité anglo-saxonnes : voir ci-dessous les limites qu'en donnent ISO et Canada.

### Ne pas se fier à un score de lisibilité automatique : il mesure la longueur des mots, pas la compréhension
- Niveau de preuve : N3
- Source : Gouvernement du Canada, guide de rédaction Canada.ca, § 2.1, https://design.canada.ca/style-guide/
- Extrait lu : « Readability tools are based on algorithms that measure things like word length. » ; « These tools cannot tell you if your audience will find your content easy to understand and use. »
- Portée / limites : convergent avec l'introduction d'ISO 24495-1 (section 2). Le guide recommande aussi des phrases de moins de 15 à 20 mots (« optimal is under 15 to 20 words »). Le texte lu ne fixe aucune cible de niveau scolaire.

---

## 2. Langage clair et UX des documents

### Juger un document sur ce que le lecteur arrive à faire (trouver, comprendre, utiliser), pas sur un indicateur mécanique
- Niveau de preuve : N1 (norme internationale)
- Source : ISO, 2023, « ISO 24495-1:2023 Plain language — Part 1: Governing principles and guidelines » (fiche officielle : https://committee.iso.org/standard/78907.html ; texte lu dans l'extrait public du projet final ISO/FDIS 24495-1, https://cdn.standards.iteh.ai/samples/78907/35c071a9d3bd4608a23200b512460fba/ISO-FDIS-24495-1.pdf)
- Extrait lu : définition 3.1 : « communication in which wording, structure and design are so clear that intended readers can easily — find what they need, — understand what they find, and — use that information » ; introduction : « plain language focuses on how successfully readers can use the document rather than on mechanical measures such as readability formulas. »
- Portée / limites : publiée le 20.06.2023 (1re édition, stade 60.60 « publiée »). La fiche ISO ne signale aucun réexamen à ce jour. Quatre principes, d'après la table des matières : 1 « Readers get what they need (relevant) », 2 « … easily find what they need (findable) », 3 « … easily understand what they find (understandable) », 4 « … easily use the information (usable) ». **Texte lu = projet FDIS (2023-02-08), pas la version finale payante.** Exemples en anglais seulement. La norme exclut l'accessibilité technique et renvoie aux WCAG et à l'EN 301 549. Elle distingue le langage clair du langage facile (FALC) : « Plain language is not to be confused with easy language. »

### Structurer le document pour le lecteur, avec des titres qui annoncent ce qui suit, puis le valider auprès de lecteurs réels
- Niveau de preuve : N1
- Source : ISO 24495-1 (projet FDIS lu), table des matières, même URL que ci-dessus
- Extrait lu : « 5.2.2 Structure the document for readers » ; « 5.2.4 Use headings to help readers predict what comes next » ; « 5.4.3 Evaluate the document further with readers » ; « 5.4.4 Continue to evaluate readers' use of the document »
- Portée / limites : seuls les intitulés des clauses ont été lus, pas leur contenu. La norme fait du test avec des lecteurs une étape du processus, pas une option.

### Couper les phrases de plus de 25 mots, limiter les paragraphes à 5 phrases, écrire à la voix active
- Niveau de preuve : N3
- Source : GDS / GOV.UK, « Use clear language », https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/writing-guidelines/clear-language/
- Extrait lu : « Try to split up sentences that are over 25 words long. » ; « Plain English is mandatory for all of GOV.UK. » ; « The active voice is more direct and puts the focus on the user and the action they need to take. »
- Portée / limites : page sans date visible (l'ancienne URL gov.uk/guidance/content-design redirige ici). La page lue ne mentionne **pas** d'âge de lecture de 9 ans. Elle cite « 1 in 6 adults in England have very poor literacy skills ». Même consigne côté États-Unis (Digital.gov, reprise de plainlanguage.gov, https://digital.gov/guides/plain-language/writing) : « Active voice makes it clear who should do what. »

### Donner des intertitres descriptifs (jamais « Introduction »), mot porteur en tête, et l'information principale d'abord
- Niveau de preuve : N3
- Source : GDS / GOV.UK, « Create a clear structure for your content », https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/writing-guidelines/clear-structure/
- Extrait lu : « descriptive – avoid generic headings like 'Introduction' » ; « Put the most important information first. » ; « The quicker you get to the point, the greater the chance your users will see the information you want them to. »
- Portée / limites : page sans date visible. D'après le résumé de la page, GOV.UK veut aussi des titres qui commencent souvent par un verbe et qui ne sont pas des questions. C'est une convention maison, pas une règle universelle.

### Ouvrir tout document long par un bref résumé en langage clair
- Niveau de preuve : N3 (note du W3C, non normative)
- Source : W3C COGA Task Force, 2021, « Making Content Usable for People with Cognitive and Learning Disabilities », motif 4.4.8, https://www.w3.org/TR/coga-usable/ ; Gouvernement du Canada, guide Canada.ca § 1.2, https://design.canada.ca/style-guide/
- Extrait lu : « Provide a brief summary for a long document and media. » (COGA) ; « Include a summary in plain language for: » (Canada, liste de cas non lue en entier)
- Portée / limites : la note COGA (W3C Working Group Note du 29.04.2021) est un complément aux WCAG et n'est pas requise pour la conformité. Pour le « BLUF » militaire (bottom line up front), voir « Non vérifié ».

### Générer la table des matières automatiquement à partir des styles de titres
- Niveau de preuve : N3
- Source : Gouvernement du Canada, guide Canada.ca § 5.1, https://design.canada.ca/style-guide/
- Extrait lu : « Use the table of contents feature from your word processing software to automatically generate a table of contents »
- Portée / limites : la consigne vise les documents à mettre en ligne. Le guide ajoute de supprimer la table des matières si la version web n'en a pas besoin. Elle suppose des titres faits avec de vrais styles (voir l'entrée suivante).

### Faire les titres avec les styles natifs (Titre 1, Titre 2…), dans l'ordre et sans sauter de niveau, jamais avec du gras
- Niveau de preuve : N3
- Source : GOV.UK, 2025, « Publishing accessible documents », https://www.gov.uk/guidance/publishing-accessible-documents ; Microsoft Support, « Make your Word documents accessible to people with disabilities », https://support.microsoft.com/en-us/office/make-your-word-documents-accessible-to-people-with-disabilities-d9bf3683-87ac-47ea-b91a-78dcacb3c66d
- Extrait lu : « Use styles to create a hierarchy of headings » (GOV.UK) ; « Use built-in headings and styles. » (Microsoft)
- Portée / limites : page GOV.UK mise à jour le 09.10.2025. D'après Microsoft, les lecteurs d'écran naviguent par les titres. C'est aussi ce qui alimente la table des matières, les signets PDF et les balises PDF/UA.

### Publier en HTML chaque fois que possible ; ne pas présumer qu'un PDF sera accessible à tous
- Niveau de preuve : N3
- Source : GOV.UK, 2025, « Publishing accessible documents », https://www.gov.uk/guidance/publishing-accessible-documents
- Extrait lu : « Publish in HTML format wherever possible so that your documents use your users' custom browser settings. » ; « PDF and PDF/A cannot be made fully accessible to all users of assistive technology. »
- Portée / limites : contexte du secteur public britannique (Equality Act 2010 cité). Si le HTML est impossible pour un formulaire, la page recommande l'OpenDocument (.odt). Quand un PDF reste nécessaire, voir PDF/UA ci-dessous. Le guide Canada.ca demande d'indiquer type et poids du fichier dans le lien : « Make sure to include the file type and size in the parentheses. »

### Quand un PDF est inévitable, le produire balisé et conforme à PDF/UA
- Niveau de preuve : N1
- Source : ISO, 2014, « ISO 14289-1:2014 … Part 1: Use of ISO 32000-1 (PDF/UA-1) », https://committee.iso.org/standard/64599.html ; ISO, 2024, « ISO 14289-2:2024 … Part 2: Use of ISO 32000-2 (PDF/UA-2) », https://committee.iso.org/standard/82278.html
- Extrait lu : « ISO 14289-1:2014 specifies the use of ISO 32000‑1:2008 to produce accessible electronic documents. » ; PDF/UA-2 « specifies how to use the Portable Document Format (PDF) specified in ISO 32000-2 » « to construct accessible digital documents using PDF technology. »
- Portée / limites : PDF/UA-1 (éd. 2, 12.2014) a été confirmée après réexamen le 21.08.2025 et « remains current ». PDF/UA-2 a été publiée le 13.03.2024 pour PDF 2.0. La norme ne traite ni de la qualité du contenu (« requirements specific to content »), ni des procédés de conversion, ni de classes de documents (factures, rapports). Un PDF/UA conforme peut donc rester illisible : PDF/UA ne remplace ni le langage clair ni une bonne structure.

### Dans un document ou un e-mail : texte alternatif sur chaque image (ou image marquée décorative), pas de texte en image, liens explicites, pièces jointes accessibles
- Niveau de preuve : N3
- Source : GSA / Section508.gov, « Email messages » (revue en octobre 2026), https://www.section508.gov/create/email-messages/ ; Microsoft Support, page Word citée ci-dessus
- Extrait lu : « All images must have alt text or be marked as decorative. » ; « Emails that include attachments must contain accessible attachments » ; « Avoid common accessibility issues such as missing alternative text (alt text) and low contrast colors. » (Microsoft)
- Portée / limites : contexte fédéral américain (Section 508). La page proscrit les liens « Click here », « Learn more » ou « Read more », les tableaux de mise en page et les objets non recherchables (« Generic or nondescriptive message subject that is not searchable »). En e-mail texte brut, une partie des consignes ne s'applique pas.

### Tableaux : données seulement, en-têtes de colonne explicites avec l'unité, chiffres alignés à droite, précision constante, aucune cellule fusionnée
- Niveau de preuve : N3
- Source : UK Government Analysis Function (ONS), 2022, « Data visualisation: tables », https://analysisfunction.civilservice.gov.uk/policy-store/data-visualisation-tables/ ; Microsoft Support, page Word citée ci-dessus
- Extrait lu : « right align the figures and the column headings » ; « use the same level of precision within each column » ; « merged cells in tables published in spreadsheets and text documents are not accessible » ; « If you have to use tables, use a simple table structure for data only, and specify column header information. » (Microsoft)
- Portée / limites : guide publié le 19.05.2022, statistique publique britannique. Il recommande aussi de ne pas abuser des quadrillages (« Do not over use gridlines »), de trier les lignes selon une colonne de valeurs et de placer les totaux en bas ou à droite, sauf si le lecteur en a besoin d'abord.

### Graphiques dans un document : un titre qui énonce le message, des étiquettes posées sur les séries plutôt qu'une légende, jamais la couleur seule, le tableau de données en alternative
- Niveau de preuve : N3
- Source : UK Government Analysis Function (ONS), 2022, « Data visualisation: charts », https://analysisfunction.civilservice.gov.uk/policy-store/data-visualisation-charts/
- Extrait lu : « The headline title should communicate the headline message of the chart. » ; « If possible, you should try to label stacks directly instead of using a legend. » ; « we should not rely on colour as the only way to match labels to data. » ; « a table of the data presented in the chart. »
- Portée / limites : publié le 19.05.2022. Il déconseille les camemberts (« hard to understand when magnified ») et la 3D. Pour l'axe d'un graphique en barres, il dit seulement que le casser « is problematic and highly controversial », pas « toujours partir de zéro ».

### Appliquer les WCAG aux documents bureautiques (Word, présentations, tableurs, e-mails), pas seulement au web
- Niveau de preuve : N3 (note du W3C, informative)
- Source : W3C, 2025, « Guidance on Applying WCAG 2.2 to Non-Web Information and Communications Technologies (WCAG2ICT) », https://www.w3.org/TR/wcag2ict-22/
- Extrait lu : document = « assembly of content, such as a file, set of files, or streamed media that functions as a single item » ; le texte fournit une « informative guidance (guidance that is not normative and does not set requirements) »
- Portée / limites : Group Note du 11.12.2025. Exemples cités dans la définition : lettres, tableurs, e-mails, livres, présentations. La partie lue ne nomme pas le PDF. Elle ne crée aucune obligation propre : c'est l'EN 301 549 ou la loi nationale qui rend les WCAG opposables aux documents.

---

## 3. Accessibilité et inclusion

### Viser WCAG 2.2 niveau AA comme référence, y compris ses 9 nouveaux critères, et cesser de tester 4.1.1 Parsing
- Niveau de preuve : N1
- Source : W3C WAI, 2023, « What's New in WCAG 2.2 », https://www.w3.org/WAI/standards-guidelines/wcag/new-in-22/ ; W3C, « WCAG 2.2 » (version datée du 12.12.2024), https://www.w3.org/TR/WCAG22/ ; W3C WAI, 21.10.2025, « WCAG 2.2 Approved as an ISO Standard », https://www.w3.org/WAI/news/2025-10-21/wcag22-iso
- Extrait lu : nouveaux critères : « 2.4.11 Focus Not Obscured (Minimum) (AA) », « 2.4.12 Focus Not Obscured (Enhanced) (AAA) », « 2.4.13 Focus Appearance (AAA) », « 2.5.7 Dragging Movements (AA) », « 2.5.8 Target Size (Minimum) (AA) », « 3.2.6 Consistent Help (A) », « 3.3.7 Redundant Entry (A) », « 3.3.8 Accessible Authentication (Minimum) (AA) », « 3.3.9 Accessible Authentication (Enhanced) (AAA) » ; « WCAG 2.2 has removed one success criterion, 4.1.1 Parsing. » ; WCAG 2.2 « is now an approved International Organization for Standardization (ISO) standard » (ISO/IEC 40500:2025)
- Portée / limites : Recommandation du W3C du 05.10.2023, version en vigueur datée du 12.12.2024. Six des neuf nouveaux critères relèvent de A ou AA. La date d'approbation ISO (septembre 2025) n'a été vue que dans des résultats de recherche, l'annonce du W3C date du 21.10.2025. L'annonce ne dit pas sur quel texte, 2023 ou 2024, porte la norme ISO.

### Ne pas concevoir ni auditer « en WCAG 3 » : c'est encore un brouillon de travail, et il ne remplace pas WCAG 2
- Niveau de preuve : N3 (brouillon de travail du W3C, non normatif)
- Source : W3C AG WG, 10.09.2026, « W3C Accessibility Guidelines (WCAG) 3.0 », Working Draft, https://www.w3.org/TR/wcag-3.0/
- Extrait lu : « While this draft has moved closer toward completion, it still has several years of work. » ; « The final set of requirements in WCAG 3 will be different from what is in this draft. » ; « WCAG 3 does not replace WCAG 2. »
- Portée / limites : dernier brouillon lu : WD-wcag-3.0-20260910. Selon le texte, un contenu conforme à WCAG 2.2 A/AA devrait satisfaire l'essentiel du niveau minimal de WCAG 3. La date du brouillon précédent n'a pas été relevée.

### Traiter l'European Accessibility Act comme une exigence applicable depuis le 28 juin 2025 pour les produits et services grand public qu'il liste
- Niveau de preuve : N1
- Source : Directive (UE) 2019/882 du 17 avril 2019 relative aux exigences en matière d'accessibilité applicables aux produits et services, texte tel qu'adopté, lu sur legislation.gov.uk : https://www.legislation.gov.uk/eudr/2019/882/article/31/adopted , https://www.legislation.gov.uk/eudr/2019/882/article/2/adopted , https://www.legislation.gov.uk/eudr/2019/882/article/4/adopted , https://www.legislation.gov.uk/eudr/2019/882/article/32/adopted
- Extrait lu : art. 31(2) : « They shall apply those measures from 28 June 2025. » ; art. 4(5) : « Microenterprises providing services shall be exempt from complying with the accessibility requirements referred to in » [§ 3] ; art. 32(1) : période transitoire « ending on 28 June » « 2030 » pour les produits déjà utilisés ; art. 32(2) : terminaux en libre-service jusqu'à la fin de leur vie utile, « but no longer than 20 years after their entry into use. »
- Portée / limites : **EUR-Lex a refusé l'accès** (réponse vide). Le texte a été lu dans la copie « adopted » de legislation.gov.uk, sans les éventuels correctifs ultérieurs. Services visés (art. 2(2)) : communications électroniques, accès aux médias audiovisuels, éléments du transport de passagers (sites, applications, billets électroniques, information voyageurs), services bancaires aux consommateurs, livres numériques, commerce électronique. Produits visés (art. 2(1)) : ordinateurs et systèmes d'exploitation grand public, terminaux de paiement, DAB, bornes, liseuses, terminaux de communication. Transposition nationale au 28.06.2022. Les lois nationales de transposition n'ont pas été vérifiées.

### En France, auditer selon le RGAA 4.1.2 en vigueur, et suivre la publication du RGAA 5 annoncée pour fin 2026
- Niveau de preuve : N1
- Source : DINUM, accessibilite.numerique.gouv.fr (consulté le 09.11.2026), https://accessibilite.numerique.gouv.fr/
- Extrait lu : « RGAA - Version 4.1.2 » ; « Publié le 16 septembre 2019 - Mis à jour le 18 avril 2023 » ; « La version 5 du RGAA est en cours de rédaction, avec une publication prévue fin 2026. »
- Portée / limites : RGAA 4 arrêté le 20.09.2019. Le site précise que l'échéance de la v5 ne doit pas faire suspendre ni reporter les travaux de mise en accessibilité. À revérifier à chaque mission tant que la v5 est annoncée. La table de correspondance RGAA 4.1.2 / WCAG 2.2 n'a pas été vérifiée.

### Contraste du texte : au moins 4,5:1, et 3:1 pour le texte d'au moins 18 pt (ou 14 pt gras), sur écran comme dans les documents
- Niveau de preuve : N1 (WCAG 2.2, critère 1.4.3, niveau AA)
- Source : W3C WAI, « Understanding SC 1.4.3: Contrast (Minimum) », https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
- Extrait lu : « The visual presentation of text and images of text has a contrast ratio of at least 4.5:1, except for the following: » ; « Large-scale text and images of large-scale text have a contrast ratio of at least 3:1; » ; grand texte = « 18 point or 14 point bold »
- Portée / limites : logos et texte purement décoratif sont exemptés (non détaillé ici). Pour les documents, la règle passe par WCAG2ICT et l'EN 301 549.

### Respecter les préférences système : réduire ou couper les animations sous `prefers-reduced-motion: reduce`, adapter le contraste sous `prefers-contrast`
- Niveau de preuve : N3 (documentation de plateforme), adossé à N1 (WCAG 2.3.3, niveau AAA)
- Source : MDN, « prefers-reduced-motion » (modifiée le 10.06.2026), https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion ; MDN, « prefers-contrast » (modifiée le 20.04.2026), https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-contrast ; W3C WAI, « Understanding SC 2.3.3: Animation from Interactions », https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html
- Extrait lu : « Such animations can trigger discomfort for those with vestibular motion disorders. » (MDN) ; « Motion animation triggered by interaction can be disabled, unless the animation is essential » (WCAG 2.3.3) ; « Vestibular (inner ear) disorder reactions include dizziness, nausea and headaches. »
- Portée / limites : `prefers-reduced-motion` est « Widely available » depuis janvier 2020, `prefers-contrast` depuis mai 2022 (valeurs `no-preference`, `more`, `less`, `custom`). Le critère 2.3.3 est AAA. La technique C39 (requête `prefers-reduced-motion`) le satisfait. Côté documents, éviter transitions et animations automatiques dans les présentations relève de la même logique (extrapolation, sans source lue).

### Concevoir pour l'accessibilité cognitive : mots courants, blocs courts, espace blanc, aide disponible, pas de dépendance à la mémoire
- Niveau de preuve : N3 (note du W3C)
- Source : W3C COGA Task Force, 29.04.2021, « Making Content Usable for People with Cognitive and Learning Disabilities », https://www.w3.org/TR/coga-usable/
- Extrait lu : « Use common and clear words in all content. » ; « Use short blocks of text » ; « Put white space around objects and text, including boxes, paragraph headings, and content, » ; objectifs « Objective 3: Use Clear and Understandable Content », « Objective 6: Ensure Processes Do Not Rely on Memory »
- Portée / limites : Working Group Note, qui ne deviendra pas une Recommandation. Supplément aux WCAG, non requis pour la conformité. Huit objectifs : comprendre ce que sont les choses, trouver, contenu clair, éviter et corriger les erreurs, aider à se concentrer, ne pas dépendre de la mémoire, aide et soutien, adaptation et personnalisation.

### Ne pas répondre à la critique par la rareté du handicap : environ 1 personne sur 6 vit avec un handicap important
- Niveau de preuve : N3 (institution internationale)
- Source : OMS, 07.03.2023, « Disability » (fiche d'information), https://www.who.int/news-room/fact-sheets/detail/disability-and-health
- Extrait lu : « An estimated 1.3 billion people experience significant disability. » ; « This represents 16% of the world's population, or 1 in 6 of us. »
- Portée / limites : fiche datée du 07.03.2023. Les « key facts » ne nomment pas leur source. La page renvoie au *Global report on health equity for persons with disabilities* (lancé le 02.12.2022), mais le lien entre ce rapport et le chiffre est une **inférence**. Le chiffre couvre le handicap « important », pas les limitations temporaires ou situationnelles.

### Écrire en langage clair, c'est aussi de l'accessibilité, mais le langage clair ne remplace pas le FALC pour les personnes en grande difficulté de lecture
- Niveau de preuve : N1
- Source : ISO 24495-1 (projet FDIS lu), introduction, https://cdn.standards.iteh.ai/samples/78907/35c071a9d3bd4608a23200b512460fba/ISO-FDIS-24495-1.pdf
- Extrait lu : « Plain language can be used for a general audience, while easy language is used for people who have difficulties with reading comprehension. »
- Portée / limites : texte du projet FDIS (02.2023). Le FALC (Facile à lire et à comprendre) a ses propres règles, non vérifiées ici. Prévoir une version FALC séparée quand le public le justifie.

---

## Mythes et affirmations contestées

- **« Notre capacité d'attention (8 s) est plus courte que celle d'un poisson rouge (9 s) » — mythe.** Le chiffre figure dans un rapport de Microsoft Canada (2015), qui cite lui-même « Statistic Brain ». Les sources listées par ce site (NCBI/NLM, Associated Press) n'ont retrouvé aucune étude. Simon Maybin (BBC World Service, 10.03.2017, « Busting the attention span myth ») et Jo Craven McGinty (WSJ, 17.02.2017) l'ont démonté. Extraits : « the figure that everyone picked up on - about our shrinking attention spans - did not actually come from Microsoft's research » ; Dr Gemma Briggs : « It's very much task-dependent. » ; Edward Vogel : « It's been remarkably stable across decades. » Lu dans une reproduction des deux articles sur un support de cours de l'université du Wisconsin : https://internet.psych.wisc.edu/wp-content/uploads/532-Master/532-UnitPages/Unit-09/Goldfish_MythBusting.pdf (bbc.com non joignable depuis la session).
- **« Les gens ne lisent pas » — à nuancer.** Ils balaient d'abord (Nielsen 1997 ; 20 à 28 % des mots lus, Nielsen 2008), mais le motif « commitment » existe et « usually leads to the best comprehension » (Pernice 2019). Sur mobile, la compréhension est équivalente à celle sur ordinateur (Moran 2016, 276 participants). Les experts lisent quand le texte est clair (Loranger 2017). Conclusion : on écrit pour le balayage **et** pour la lecture complète.
- **« Il faut disposer le contenu en F » — contresens.** Le F est le symptôme d'un texte mal formaté (« bad for users and businesses », Pernice 2017), pas un gabarit à reproduire.
- **« Un bon score de lisibilité prouve qu'un texte est clair » — contesté par la norme elle-même.** ISO 24495-1 juge sur l'usage, « rather than on mechanical measures such as readability formulas ». Canada.ca : ces outils « cannot tell you if your audience will find your content easy to understand and use ».
- **« Des lignes courtes se lisent plus vite » — non démontré à l'écran.** Dyson & Kipping (1998) : les lignes de 100 caractères se lisent plus vite que celles de 25, sans perte de compréhension, et la préférence déclarée (55 caractères) ne prédit pas la performance. La plage typographique « 45 à 75 caractères » vient du livre imprimé (source primaire non lue, voir ci-dessous).
- **« Un PDF balisé est accessible, c'est réglé » — faux en pratique.** Selon GOV.UK, « PDF and PDF/A cannot be made fully accessible to all users of assistive technology ». PDF/UA exclut lui-même les exigences de contenu.
- **« WCAG 3 remplace WCAG 2 / il faut déjà s'y conformer » — faux au 09.11.2026.** Brouillon de travail du 10.09.2026, « still has several years of work », et « WCAG 3 does not replace WCAG 2 ».
- **« 79 % des internautes balaient » cité comme un chiffre actuel — daté.** Il provient d'une étude de 1997 dont l'échantillon n'est pas indiqué sur la page. À citer comme histoire, pas comme mesure présente.

## Non vérifié

- **Dyson & Haselgrove (2001), IJHCS 54, p. 585-612**, « The influence of reading speed and line length on the effectiveness of reading from screen » : la conclusion souvent citée (55 caractères par ligne = meilleure compréhension) n'a été lue que dans des résumés secondaires. Le PDF en libre accès signalé (Nottingham) renvoie une erreur 404/503, et la notice Semantic Scholar n'a pas d'abstract.
- **Rello, Pielot & Marcos (2016)** : texte intégral et abstract officiel non lus (ACM 403, Unpaywall : accès fermé). Seule la synthèse BYU a été lue. La formulation « 18 pt = 24 px » vient d'un résultat de recherche décrivant les diapositives, non ouvertes.
- **ISO 24495-1:2023, version finale** : iso.org renvoie 403. Seuls la fiche committee.iso.org et l'extrait public du projet FDIS ont été lus. L'intitulé exact des principes dans la version publiée n'a pas été vu.
- **« Bottom line up front » (AR 25-50, US Army, 10.10.2020)** : PDF inaccessible (403). La formulation exacte et le paragraphe ne sont pas vérifiés.
- **Plage de 45 à 75 caractères par ligne (Bringhurst, *The Elements of Typographic Style*)** : source primaire non consultée.
- **Âge de lecture de 9 ans (GOV.UK)**, souvent cité : absent de la page « Use clear language » lue.
- **Cible de niveau scolaire du guide Canada.ca (8e année ?)** : non trouvée dans les 100 000 premiers caractères lus, et les 15 000 derniers n'ont pas été lus.
- **EAA, accès direct à EUR-Lex** : bloqué (réponse vide). Le texte lu est la version « adopted » de legislation.gov.uk. Non vérifiés : la clause de l'art. 32(1) sur les contrats de service conclus avant le 28.06.2025 (plafond de cinq ans), une date de 2027 pour les services d'urgence (art. 4(8) et 31(3), mentionnés sans lecture du détail) et les lois nationales de transposition (dont la France).
- **WCAG 2.2 / ISO/IEC 40500:2025** : la date d'approbation ISO (24.09.2025, selon un catalogue) et le texte de référence (2023 ou 2024) n'ont pas été vus sur une source officielle.
- **OMS, 1,3 milliard** : le rattachement explicite au rapport de 2022 n'apparaît pas sur la fiche.
- **Contenu des guidelines fédérales plainlanguage.gov** : le site redirige vers digital.gov, et le contenu d'origine, archivé sur GitHub, n'a pas été lu.
- **Enquête du King's College London (2022)**, selon laquelle la moitié des adultes britanniques croient au mythe des 8 secondes : vue seulement dans un résultat de recherche.
- **Australian Government Style Manual** (titres, résumé en tête) : site indisponible (503) pendant la recherche.

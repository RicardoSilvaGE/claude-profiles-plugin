# Fiche `ux-preuves` — Tests — conception des cas

> Fiche du skill `ux-preuves` (dev-fullstack), volet **tests**, préchargé par `qa`. Couvre : partitions d'équivalence, valeurs limites, tables de décision et transitions (ISTQB, ISO 29119-4), efficacité mesurée des techniques, test combinatoire (NIST), test exploratoire, TDD, BDD, test métamorphique, entrées hostiles, RLS qui refuse sans erreur.
> **Instantané de la recherche documentaire du 10.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Études (souvent des prépublications pour les LLM), docs d'outils
> et pratiques d'entreprise **vieillissent** : avant d'en faire dépendre une règle,
> relire la source (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles de l'agent », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

**Méthode.** Recherche menée le 10.11.2026. Chaque entrée repose sur une page ou un PDF réellement ouvert : WebFetch pour les pages HTML, et pour les PDF un téléchargement par curl dans `/tmp/claude-0/-home-user/abfbe100-0776-5e10-8812-67a3787e4157/scratchpad/recherche-qa/pdf4/` suivi d'une extraction `pdftotext` (syllabus ISTQB CTFL v4.0.1, extraits publics iTeh d'ISO/IEC/IEEE 29119-3 et 29119-4:2021, NIST SP 800-142, Fucci et al. 2017, Vegas et al. 2024, Dobslaw et al. 2020, Binamungu et al. 2018, Binamungu & Maro 2023, Segura et al. 2016, Chen et al. 2018, Mäkinen & Münch 2014). Quand seul un résumé a été accessible (notice d'éditeur ou de dépôt), l'entrée porte la mention « résumé seul lu ». Les extraits sont reproduits verbatim dans leur langue d'origine. Les citations tirées d'une page HTML proviennent de l'extraction WebFetch, qui renvoie des passages courts. Plusieurs sources demandées n'ont pas pu être ouvertes : pages d'éditeur protégées (Springer, ScienceDirect, IEEE Xplore), dépôts renvoyant une page HTML au lieu du PDF, et un serveur dont la chaîne TLS a échoué. Elles sont listées dans « Non vérifié ». Niveaux : N1 norme, N2 recherche revue par les pairs, N3 guide officiel d'une institution ou d'une entreprise sur sa propre pratique, N4 avis d'expert, livre ou étude d'éditeur. Le syllabus ISTQB est classé N3 : c'est le référentiel officiel d'un organisme de certification, pas une norme ISO, même s'il renvoie à ISO/IEC/IEEE 29119-4. Thèmes déjà couverts ailleurs et non refaits ici : tests basés sur les propriétés, Schemathesis, Yuan et al. 2014, Hora & Fraser 2026, Testing Library, erreurs de formulaire et WCAG.

## 1. Techniques boîte noire normalisées

### Partitionner chaque donnée en classes valides ET invalides, puis couvrir chaque partition au moins une fois
- Niveau de preuve : N3 (référentiel officiel ISTQB, qui renvoie à ISO/IEC/IEEE 29119-4)
- Source : ISTQB, 2024 (v4.0.1, errata du 15.09.2024 ; v4.0 du 21.04.2023), « Certified Tester Foundation Level Syllabus v4.0.1 », § 4.2.1, https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf
- Extrait lu : « To achieve 100% coverage with this test technique, test cases must exercise all identified partitions (including invalid partitions) by covering each partition at least once. » ; « Equivalence partitions can be identified for any data element related to the test object, including inputs, outputs, configuration items, internal values, time-related values, and interface parameters. »
- Portée / limites : technique de base, sans chiffre d'efficacité dans le syllabus. Le syllabus admet que « the definitions of valid and invalid values may vary among teams and organizations ». La règle d'un test par partition suppose que la partition soit juste : « partitioning should be done with care ».
- En stratégie : pour chaque champ, paramètre d'API, sortie, rôle et valeur temporelle, poser la question « quelles classes le code traite-t-il différemment ? ». Une classe invalide sans test, c'est un trou dans la matrice. Les sorties (liste vide, une ligne, plusieurs lignes) se partitionnent aussi.

### Avec plusieurs paramètres, viser au minimum « Each Choice », en sachant que cela ne teste aucune combinaison
- Niveau de preuve : N3
- Source : ISTQB, 2024, « Certified Tester Foundation Level Syllabus v4.0.1 », § 4.2.1, https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf
- Extrait lu : « Each Choice coverage requires test cases to exercise each partition from each set of partitions at least once. Each Choice coverage does not take into account combinations of partitions. »
- Portée / limites : c'est le plancher. Pour les interactions, voir la table de décision et le combinatoire (§ 3).
- En stratégie : un formulaire à N champs peut atteindre « Each Choice » en peu de cas. Indiquer explicitement dans la matrice que les combinaisons ne sont PAS couvertes, sauf si une table de décision ou une matrice par paires a été construite.

### Aux bornes ordonnées, préférer la BVA à 3 valeurs (borne et ses deux voisins) quand l'opérateur de comparaison est risqué
- Niveau de preuve : N3
- Source : ISTQB, 2024, « Certified Tester Foundation Level Syllabus v4.0.1 », § 4.2.2, https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf
- Extrait lu : « In 2-value BVA (Craig 2002, Myers 2011), for each boundary value there are two coverage items: this boundary value and its closest neighbor belonging to the adjacent partition. » ; « 3-value BVA is more rigorous than 2-value BVA as it may detect defects overlooked by 2-value BVA. For example, if the decision “if (x ≤ 10) …” is incorrectly implemented as “if (x = 10) …”, no test data derived from the 2-value BVA (x = 10, x = 11) can detect the defect. However, x = 9, derived from the 3-value BVA, is likely to detect it. »
- Portée / limites : « BVA can only be used for ordered partitions ». L'argument du syllabus est logique (exemple construit), pas une mesure empirique. NIST SP 800-142 décrit la même stratégie à 3 valeurs par borne (« for three values per boundary »).
- En stratégie : pour chaque limite (longueur max d'un champ, montant minimum, date d'expiration, quota), écrire min−1, min, min+1 et max−1, max, max+1. Préciser l'unité la plus petite : 1 caractère, 1 centime, 1 seconde, 1 jour selon le fuseau.

### Toute règle métier à conditions multiples passe par une table de décision dont chaque colonne réalisable devient un cas
- Niveau de preuve : N3
- Source : ISTQB, 2024, « Certified Tester Foundation Level Syllabus v4.0.1 », § 4.2.3, https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf
- Extrait lu : « In decision table testing, the coverage items are the columns containing feasible combinations of conditions. » ; « It also helps to find any gaps or contradictions in the requirements. »
- Portée / limites : le nombre de règles croît exponentiellement. Le syllabus renvoie à une table minimisée ou à une approche par les risques, et laisse les algorithmes de minimisation hors de son périmètre.
- En stratégie : appliquer à l'autorisation (rôle × propriétaire de la ligne × statut de l'objet), au paiement (moyen × devise × statut) et aux remises. Une colonne dont l'action attendue est inconnue est une question pour le cadrage, pas un test à inventer.

### Pour un flux à états (commande, abonnement, paiement), couvrir toutes les transitions valides et tenter les invalides, une seule par test
- Niveau de preuve : N3
- Source : ISTQB, 2024, « Certified Tester Foundation Level Syllabus v4.0.1 », § 4.2.4, https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf
- Extrait lu : « To achieve 100% all transitions coverage, test cases must exercise all the valid transitions and attempt to execute invalid transitions. Testing only one invalid transition in a single test case helps to avoid defect masking » ; « Valid transitions coverage is the most widely used coverage criterion. »
- Portée / limites : le syllabus réserve le minimum « all transitions » aux logiciels critiques (« should be a minimum requirement for mission and safety-critical software »). Pour une application web, la couverture des transitions valides est la norme d'usage, et les transitions invalides se choisissent par risque.
- En stratégie : dessiner la table d'états (lignes = états, colonnes = événements). Les cellules vides sont les transitions invalides. Pour le paiement : rembourser une commande non payée, payer deux fois, annuler après expédition.

### Choisir les techniques par le risque, dans le catalogue normalisé qui va bien au-delà des quatre classiques
- Niveau de preuve : N1 (norme)
- Source : ISO/IEC/IEEE, 2021 (2e édition, 2021-10), « ISO/IEC/IEEE 29119-4:2021 Software and systems engineering — Software testing — Part 4: Test techniques », extrait public iTeh (sommaire, § 1, § 3, § 4), https://cdn.standards.iteh.ai/samples/79430/6c93dfe4a05b46a8895e04dfd74ddd24/ISO-IEC-IEEE-29119-4-2021.pdf
- Extrait lu : « equivalence partition / equivalence class — class of inputs or outputs that are expected to be treated similarly by the test item » ; « boundary value analysis — specification-based test case design technique based on exercising the boundaries of equivalence partitions » ; « Implementation of ISO/IEC/IEEE 29119-2 involves using a risk-based approach to select a subset of techniques suitable for a given project or organization. »
- Portée / limites : seul l'extrait gratuit a été lu (sommaire et définitions). Les clauses normatives 5.2.x et 6.2.x (règles de sélection des bornes, formules de couverture) sont payantes et n'ont pas été lues. Le sommaire liste aussi : classification tree, syntax testing, combinatorial (« pair-wise testing, each choice testing, base choice testing »), cause-effect graphing, scenario testing, random testing, metamorphic testing, requirements-based testing, et error guessing côté expérience.
- En stratégie : la matrice nomme la technique utilisée pour chaque bloc de cas (EP, BVA, table de décision, transitions, combinatoire, métamorphique, error guessing) et dit pourquoi elle a été retenue pour ce risque.

### Tirer les résultats attendus de la spécification, pas de l'implémentation, et doubler l'analyse du code d'une analyse de la spec
- Niveau de preuve : N1 + N3
- Source : ISO/IEC/IEEE, 2021, « ISO/IEC/IEEE 29119-3:2021 — Part 3: Test documentation », extrait public, § 3.2, https://cdn.standards.iteh.ai/samples/79429/27623aa24dba41a2876884c0ec57f5d7/ISO-IEC-IEEE-29119-3-2021.pdf ; ISTQB, 2024, syllabus CTFL v4.0.1, § 4.1 et § 4.3.3, https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf
- Extrait lu : ISO 29119-3 : « expected results — observable predicted behaviour of the test item under specified conditions based on its specification or another source ». ISTQB : « the test cases are independent of how the software is implemented. Consequently, if the implementation changes, but the required behavior stays the same, then the test cases are still useful. » ; « if the software does not implement one or more requirements, white-box testing may not detect the resulting defects of omission (Watson 1996). »
- Portée / limites : principe de référentiel, sans mesure. La phrase sur l'omission vise les techniques boîte blanche. Elle s'applique à toute matrice dérivée du seul code.
- En stratégie : deux colonnes de provenance pour chaque cas, « exigence ou critère d'acceptation » et « point du code ». Un comportement exigé sans code correspondant reste dans la matrice : c'est exactement le cas que l'analyse du code seule ne voit pas.

### Compléter les cas dérivés par une liste d'attaques (error guessing) fondée sur les défauts connus
- Niveau de preuve : N3
- Source : ISTQB, 2024, syllabus CTFL v4.0.1, § 4.4.1, https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf
- Extrait lu : « Fault attacks are a way to implement error guessing. This test technique requires the tester to create or acquire a list of possible errors, defects and failures, and to design tests that will identify defects associated with the errors, expose the defects, or cause the failures. »
- Portée / limites : l'efficacité dépend de l'expérience (« The effectiveness of these test techniques depends heavily on the tester's skills »).
- En stratégie : tenir une liste d'attaques propre à la stack, alimentée par les incidents passés du dépôt. Le § 8 donne des sources officielles pour la remplir : Unicode, fuseaux, montants, RLS, OWASP.

### Écrire d'abord les cas positifs, puis les négatifs, puis les non fonctionnels, en langage métier avec préconditions, entrées et postconditions
- Niveau de preuve : N3
- Source : ISTQB, 2024, syllabus CTFL v4.0.1, § 4.5.2 et § 4.5.3 (ATDD), https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf
- Extrait lu : « Typically, the first test cases are positive, confirming the correct behavior without exceptions or error conditions [...] After the positive test cases are done, the team should perform negative testing. Finally, the team should cover non-functional quality characteristics » ; « Typically, test cases contain sentences in natural language involving the necessary preconditions (if any), the inputs, and the postconditions. » ; « no two test cases should describe the same characteristics of the user story. »
- Portée / limites : décrit l'ATDD (cas écrits avant l'implémentation), sans preuve d'efficacité. Le syllabus reconnaît deux formats de critères d'acceptation : « Scenario-oriented (e.g., Given/When/Then format used in BDD) » et « Rule-oriented (e.g., bullet point verification list, or tabulated form of input-output mapping) ».
- En stratégie : chaque ligne de la matrice a des préconditions (rôle connecté, données présentes, état de l'objet), des entrées, un attendu observable et une postcondition (état de la base, e-mail envoyé ou non). Deux lignes qui testent la même caractéristique sont un doublon : on fusionne.

## 2. Efficacité mesurée des techniques de conception

### Ne pas compter sur une seule technique : boîte noire, boîte blanche et relecture trouvent des classes de fautes différentes
- Niveau de preuve : N2 (expérience contrôlée, 32 professionnels et 42 étudiants avancés, 4 programmes de taille unitaire)
- Source : Basili V. R., Selby R. W., 1987, « Comparing the effectiveness of software testing strategies », IEEE TSE SE-13(12), notice NASA NTRS, https://ntrs.nasa.gov/citations/19880033653 (résumé seul lu)
- Extrait lu : « This study compares the results of code reading, functional testing, and structural testing » ; « Thirty two professional programmers and 42 advanced students applied the three techniques to four unit-sized programs ».
- Portée / limites : résumé seul lu. D'après ce résumé : chez les professionnels, la relecture du code détecte plus de fautes que les tests fonctionnel et structurel, et le test fonctionnel (EP + BVA) plus que le test structurel (100 % de couverture des instructions). Chez les étudiants, les résultats varient selon le groupe. La relecture trouve mieux les fautes d'interface, le test fonctionnel les fautes de contrôle. Programmes petits, contexte de 1987.
- En stratégie : la matrice ne remplace ni la relecture de code ni l'analyse fonctionnelle. Croiser les cas dérivés de la spec (logique de contrôle) et une relecture des interfaces (contrats d'appel entre modules).

### Aux bornes, la BVA a mesuré nettement plus d'efficacité que l'EP seule et que le hasard
- Niveau de preuve : N2 (une étude industrielle, système avionique d'environ 20 000 lignes d'Ada)
- Source : Reid S., 1997, « An Empirical Analysis of Equivalence Partitioning, Boundary Value Analysis and Random Testing », METRICS 1997, notice https://sciweavers.org/node/172985 (résumé seul lu)
- Extrait lu : « As expected, an implementation of BVA was found to be most effective, » « with neither EP nor random testing half as effective. » ; « The random testing results were surprising, requiring just 8 test cases per module to equal the effectiveness of EP, » « although somewhere in the region of 50,000 random test cases were required to equal the effectiveness of BVA. »
- Portée / limites : un seul système, un seul domaine, un seul auteur. Dobslaw et al. 2020 (arXiv:2001.06652, PDF lu) citent ce résultat et ajoutent : « neither EP nor BVA has been defined in a generalizable way, since they rely on a non-formal understanding of what constitutes a partition. »
- En stratégie : ne jamais livrer une matrice qui a des partitions sans leurs bornes. Si on n'a le temps que d'une chose sur un champ numérique ou une longueur, ce sont les bornes.

### Traiter les « bonnes pratiques » de test comme des hypothèses : la connaissance expérimentale sur les techniques reste immature
- Niveau de preuve : N2 (revue de 25 ans d'expériences)
- Source : Juristo N., Moreno A. M., Vegas S., 2004, « Reviewing 25 Years of Testing Technique Experiments », Empirical Software Engineering 9(1-2), notice EBSE Durham, https://ebse.webspace.durham.ac.uk/ebse-bibliography/reviewing-25-years-of-testing-technique-experiments/ (résumé seul lu)
- Extrait lu : « developers are guided by intuition, fashion or market-speak rather than by facts or undisputed statements » ; « obtained a testing technique knowledge classification based on their factuality and objectivity ».
- Portée / limites : résumé seul lu. Les conclusions détaillées, technique par technique, n'ont pas été vérifiées.
- En stratégie : pour toute règle de la matrice, distinguer ce qui est mesuré (BVA, interactions à faible nombre de paramètres) de ce qui relève de la convention, et le dire.

### Ne pas laisser l'impression du testeur (ou de l'agent) choisir la technique : la perception d'efficacité est souvent fausse
- Niveau de preuve : N2 (expérience contrôlée et réplication, étudiants ; 23 participants dans l'étude originale)
- Source : Vegas S., Riofrío P., Marcos E., Juristo N., 2024, « On (Mis)Perceptions of Testing Effectiveness: An Empirical Study », arXiv:2402.07222v1, https://arxiv.org/pdf/2402.07222v1
- Extrait lu : « The perceptions of 50% of participants (11 out of 23) are wrong. » ; « Wrong perception of techniques can reduce effectiveness 31pp (percentage points) on average. » ; « Participants think that technique effectiveness depends exclusively on their performance and not on possible weaknesses of the technique itself. »
- Portée / limites : étudiants espagnols d'un cours de V&V, trois techniques (EP, test de branches, relecture par abstraction progressive), petits programmes. La version v1 lue est un manuscrit, et sa publication finale n'a pas été vérifiée.
- En stratégie : la matrice se juge sur des mesures (mutants tués, défauts réels retrouvés), pas sur le sentiment d'avoir bien couvert. Prévoir au moins un contrôle objectif après implémentation.

## 3. Combinatoire

### Tester exhaustivement est impossible, mais les défaillances observées dépendent de peu de paramètres
- Niveau de preuve : N2
- Source : Kuhn D. R., Wallace D. R., Gallo A. M., 2004, « Software Fault Interactions and Implications for Software Testing », IEEE TSE 30(6) : 418-421, notice NIST CSRC, https://csrc.nist.gov/pubs/journal/2004/06/software-fault-interactions-and-implications-for-s/final (résumé seul lu)
- Extrait lu : « Exhaustive testing of computer software is intractable. »
- Portée / limites : résumé seul lu (le PDF de l'article n'a pas pu être téléchargé, voir « Non vérifié »). D'après la notice, si toutes les fautes d'un système se déclenchent avec n paramètres ou moins, tester tous les n-uplets équivaut en pratique à un test exhaustif, pour des variables à petit nombre de valeurs discrètes. Les chiffres par domaine viennent de l'entrée suivante.
- En stratégie : avant de combiner, réduire chaque paramètre à ses classes (EP) et à ses bornes. Le combinatoire porte sur des classes, pas sur des valeurs brutes.

### Le test par paires est un plancher bon marché, pas une garantie : viser 3 à 4 paramètres sur les règles critiques
- Niveau de preuve : N3 (publication spéciale du NIST, qui synthétise des études N2)
- Source : Kuhn D. R., Kacker R. N., Lei Y., 2010 (octobre), « Practical Combinatorial Testing », NIST SP 800-142, https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-142.pdf ; NIST CSRC, « Automated Combinatorial Testing for Software — FAQs », https://csrc.nist.gov/projects/automated-combinatorial-testing-for-software/faqs
- Extrait lu : SP 800-142 : « With the NASA application, for example, 67% of the failures were triggered by only a single parameter value, 93% by 2-way combinations, and 98% by 3-way combinations. The detection rate curves for the other applications studied are similar, reaching 100% detection with 4 to 6-way interactions. » ; « pairwise testing may miss 10% to 40% or more of system bugs, and is thus not sufficient for mission-critical software. » FAQ : « We have not seen more than six factors involved in a failure, so 7-way or higher faults appear to be extremely rare. »
- Portée / limites : données de systèmes embarqués, de navigateur, de serveur et de base NASA, collectées à partir de 1999. Rien ne garantit la même distribution pour une application web à règles métier. La FAQ conseille de partitionner les valeurs continues et de rester à environ 10 valeurs par paramètre. Elle signale aussi qu'une couverture de branches loin de 100 % indique un modèle d'entrées à revoir.
- En stratégie : la majorité des défauts tient à un seul paramètre, donc l'EP et la BVA par champ d'abord. Ensuite, toutes les paires sur les écrans à options. Enfin, les triplets sur les règles financières ou d'autorisation (rôle × statut × moyen de paiement).

### Le combinatoire ne règle pas la question de l'oracle : prévoir comment chaque cas généré sera jugé
- Niveau de preuve : N3
- Source : Kuhn, Kacker, Lei, 2010, NIST SP 800-142, § 2.2 « The Test Oracle Problem », https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-142.pdf
- Extrait lu : « Even with efficient algorithms to produce covering arrays, the oracle problem remains – testing requires both test data and results that should be expected for each data input. » ; « Crash testing: the easiest and least expensive approach is to simply run tests against the system under test (SUT) to check whether any unusual combination of input values causes a crash or other easily detectable failure. »
- Portée / limites : les solutions citées (crash testing, assertions embarquées, génération par modèle) ont chacune un coût. Le chiffre de 80 à 90 % d'erreurs trouvées par assertions JML porte sur un domaine précis (cartes à puce).
- En stratégie : pour chaque bloc combinatoire, la matrice précise le type d'oracle : valeur attendue exacte, invariant (pas d'erreur 500, total ≥ 0, ligne visible seulement par son propriétaire) ou relation métamorphique (§ 7).

## 4. Test exploratoire

### Les cas écrits d'avance n'ont pas montré plus d'efficacité de détection que l'exploratoire : les deux ont des usages distincts
- Niveau de preuve : N2 (expérience répliquée, 51 étudiants, éditeur de texte jEdit)
- Source : Itkonen J., Mäntylä M., 2014, « Are test cases needed? Replicated comparison between exploratory and test-case-based software testing », Empirical Software Engineering 19(2) : 303-342, notice Lund University, https://lup.lub.lu.se/record/4410918 (résumé seul lu)
- Extrait lu : « creative, experience-based testing without predesigned test cases »
- Portée / limites : résumé seul lu. D'après ce résumé : pas de différence d'efficacité de détection, moins d'effort de conception pour l'exploratoire, plus de faux positifs avec les cas écrits. Côté difficultés, les cas écrits peinent à trouver le bon niveau d'abstraction, l'exploratoire à concevoir les tests et à journaliser l'exécution. Les auteurs reconnaissent aux cas écrits un avantage pour piloter les tests dans les grandes organisations. Test manuel fonctionnel, sessions courtes, étudiants. L'étude originale de 2007 (ESEM) n'a pas été ouverte.
- En stratégie : la valeur de la matrice écrite d'avance ne tient pas à un gain de détection prouvé. Elle tient à la coordination (passation à des agents développeurs), à la répétabilité en CI et à la traçabilité. Ajouter à la matrice une ou deux chartes exploratoires bornées dans le temps.

### L'exploratoire n'est pas binaire : choisir un degré d'exploration par charte
- Niveau de preuve : N2 (classification évaluée en groupes de discussion dans quatre entreprises)
- Source : Ghazi A. N., Petersen K., Bjarnason E., Runeson P., 2017, « Exploratory Testing: One Size Doesn't Fit All », arXiv:1704.00537, https://arxiv.org/abs/1704.00537 (résumé seul lu)
- Extrait lu : « different levels of exploratory testing from fully exploratory to fully scripted » ; « the levels can be used as a guide to structure test charters »
- Portée / limites : résumé seul lu. Le commentaire arXiv indique « Submitted to IEEE Software ». La publication dans IEEE Access 2018 sous un autre titre est signalée par une recherche, mais la page n'a pas été ouverte.
- En stratégie : pour une feature neuve, mal spécifiée ou à risque d'UX, ajouter une charte (objectif, zone, durée) plutôt que de multiplier les cas écrits sur des comportements encore mouvants.

### Réserver l'exploratoire aux spécifications faibles ou à la pression de temps, en complément des cas formels
- Niveau de preuve : N3
- Source : ISTQB, 2024, syllabus CTFL v4.0.1, § 4.4.2, https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf
- Extrait lu : « Exploratory testing is useful when there are few or inadequate specifications or there is significant time pressure on the testing. Exploratory testing is also useful to complement other more formal test techniques. »
- Portée / limites : énoncé de référentiel. Le syllabus lie l'efficacité à l'expérience et à la connaissance du domaine.
- En stratégie : un défaut trouvé en exploratoire devient un cas de non-régression dans la matrice.

## 5. TDD et test d'abord

### Ne pas présenter le test d'abord comme la cause des bénéfices du TDD : ce qui compte, ce sont des cycles courts et réguliers
- Niveau de preuve : N2 (82 points de données, 39 professionnels)
- Source : Fucci D., Erdogmus H., Turhan B., Oivo M., Juristo N., 2017, « A Dissection of the Test-Driven Development Process: Does It Really Matter to Test-First or to Test-Last? », IEEE TSE 43(7), préprint arXiv:1611.05994, https://arxiv.org/pdf/1611.05994
- Extrait lu : « Quality and productivity improvements were primarily positively associated with the granularity and uniformity. Sequencing, the order in which test and production code are written, had no important influence. » ; « The claimed benefits of TDD may not be due to its distinctive test-first dynamic, but rather due to the fact that TDD-like processes encourage fine-grained, steady steps that improve focus and flow. »
- Portée / limites : tâches de taille limitée, qualité mesurée comme correction fonctionnelle. L'étude est corrélationnelle (modèles de régression), pas une expérience sur l'ordre.
- En stratégie : la matrice n'a pas à imposer « test avant code » comme dogme. Elle peut découper la feature en petits incréments testés un à un, chacun avec ses cas.

### Effet du TDD sur la qualité : faible et dépendant du contexte ; sur la productivité : non concluant
- Niveau de preuve : N2 (méta-analyse), lue de seconde main
- Source : Rafique Y., Mišić V. B., 2013, « The Effects of Test-Driven Development on External Quality and Productivity: A Meta-Analysis », IEEE TSE (DOI 10.1109/TSE.2012.28), résumé non accessible. Lu tel que rapporté par Fucci et al. 2017, https://arxiv.org/pdf/1611.05994, et par Mäkinen S., Münch J., 2014, « Effects of Test-Driven Development: A Comparative Analysis of Empirical Studies », SWQD 2014, https://helda.helsinki.fi/server/api/core/bitstreams/28435ba6-f068-4f28-983a-47d703536365/content
- Extrait lu : Fucci et al. : « A meta-analysis by Rafique and Misic [14] reports that TDD improves external quality when compared to a waterfall approach. However, this improvement is not strong. » Mäkinen & Münch : « Rafique and Mišić [4] gathered experiences from 25 test-driven development studies » ; « For productivity, the results were indecisive ».
- Portée / limites : l'article lui-même n'a pas été lu. Le nombre d'études diffère selon les sources (25 chez Mäkinen & Münch, 27 dans un extrait de moteur de recherche non vérifié). Fucci et al. rapportent aussi que le TDD devient désavantageux face à un développement itératif test-last dans le sous-ensemble académique. Bissi et al. 2016 n'a pas pu être ouvert.
- En stratégie : ne pas promettre de gain chiffré de qualité au nom du TDD. Justifier la matrice par la couverture des risques, pas par un gain de méthode.

## 6. Spécifications exécutables (BDD, Gherkin, Specification by Example)

### Les scénarios BDD coûtent en maintenance comme toute suite automatisée : chasser les doublons dès l'écriture
- Niveau de preuve : N2 (enquête auprès de 75 praticiens de 26 pays, SANER 2018)
- Source : Binamungu L. P., Embury S. M., Konstantinou N., 2018, « Maintaining Behaviour Driven Development Specifications: Challenges and Opportunities », SANER 2018, préprint auteur https://lepebina.github.io/maintaining.pdf
- Extrait lu : « Some teams find that parts of the system are effectively frozen due to the challenges of finding and modifying the examples associated with them. » ; « The results also showed that BDD specifications suffer the same maintenance challenges found in automated test suites more generally. » ; « 61% of the respondents held the view that the presence of duplication in BDD specifications can cause them to become difficult to extend and change »
- Portée / limites : opinions déclarées (recrutement en partie par effet boule de neige), pas une mesure d'effet sur les défauts.
- En stratégie : si la matrice est rendue en Gherkin, une ligne correspond à un comportement, et les doublons sont fusionnés en « Scenario Outline » avec un tableau d'exemples.

### Aucune preuve industrielle solide de l'effet du BDD sur la qualité n'a été trouvée
- Niveau de preuve : N2 (étude cartographique systématique, 166 articles, 2006-2021)
- Source : Binamungu L. P., Maro S., 2023, « Behaviour Driven Development: A Systematic Mapping Study », Journal of Systems and Software (accepté), préprint arXiv:2305.05567v1, https://arxiv.org/pdf/2305.05567v1
- Extrait lu : « scarcity of research with insights from the industry » ; « acute shortage of metrics for measuring various aspects of BDD specifications » ; « The scarcity of studies that have been evaluated in the industry could affect the applicability of the proposed solutions because of the lack of evidence to demonstrate their effectiveness »
- Portée / limites : une cartographie recense, elle ne mesure pas l'effet. Elle relève tout de même des expériences contrôlées ponctuelles (par exemple Häser et al. 2016, sur le langage de domaine pour spécifier des cas de test, non ouvert ici).
- En stratégie : Gherkin est un format de communication, pas une technique de détection. La matrice reste dérivée par EP, BVA et tables, quel que soit le format de rendu.

### Décrire le comportement, pas l'implémentation : style déclaratif dans les descriptions de cas
- Niveau de preuve : N3 (documentation officielle de Cucumber sur son propre outil)
- Source : Cucumber, s. d., « Writing better Gherkin », https://cucumber.io/docs/bdd/better-gherkin/
- Extrait lu : « Your scenarios should describe the intended behaviour of the system, not the implementation. » ; « Any time the implementation changes, the tests need to be updated too. » ; « The behaviour does not have to change just because the implementation does. »
- Portée / limites : recommandation d'éditeur, sans mesure. La page admet que le style impératif convient dans certains contextes.
- En stratégie : la description métier de chaque ligne ne cite ni sélecteur CSS, ni nom de fonction, ni table SQL. Ces détails vont dans les colonnes techniques (niveau, point d'entrée).

### Specification by Example : illustrer les règles par des exemples concrets ; preuve de praticien, non mesurée
- Niveau de preuve : N4 (livre)
- Source : Adzic G., 2011, « Specification by Example », page de l'auteur https://gojko.net/books/specification-by-example/
- Extrait lu : « case studies (of over 50 projects) » ; « specification by example, agile acceptance testing and behaviour driven development »
- Portée / limites : retours d'expérience collectés par l'auteur, sans protocole comparatif. Le contenu du livre (motifs de processus) n'a pas été lu, seulement la page de présentation.
- En stratégie : pour une règle métier floue, demander deux ou trois exemples chiffrés au cadrage avant d'écrire les cas. Les exemples deviennent les lignes de la table de décision.

## 7. Test métamorphique

### Quand l'oracle manque (recherche, tri, calcul, classement), tester des relations entre exécutions plutôt qu'une valeur exacte
- Niveau de preuve : N1 (définition normalisée) + N2 (revues)
- Source : Segura S., Fraser G., Sanchez A. B., Ruiz-Cortés A., 2016, « A Survey on Metamorphic Testing », IEEE TSE 42(9) : 805-824, version acceptée https://eprints.whiterose.ac.uk/110335/1/segura16-tse.pdf ; Chen T. Y., Kuo F.-C., Liu H., Poon P.-L., Towey D., Tse T. H., Zhou Z. Q., 2018, « Metamorphic Testing: A Review of Challenges and Opportunities », ACM CSUR 51(1), art. 4, copie https://homes.cs.washington.edu/~rjust/courses/CSE503/2021_02_12-reading2.pdf ; ISO/IEC/IEEE 29119-4:2021, § 3.34-3.35 (extrait iTeh déjà cité)
- Extrait lu : Segura : « Metamorphic testing provides an alternative, where correctness is not determined by checking an individual concrete output, but by applying a transformation to a test input and observing how the program output “morphs” into a different one as a result. » ; exemple de la figure 1 : « Metamorphic test on the Google search engine checking the relation Count(q) ≥ Count(q + k). » Chen : « if the vertices a and b are swapped, the length of the shortest path will remain unchanged » ; « Le et al. [50] detected over 100 faults in two popular C compilers (GCC and LLVM) based on a simple relation ». ISO : « metamorphic relation — description of how changes to the test inputs for a test case affect the expected outputs based on the required behaviour of a test item ».
- Portée / limites : l'efficacité dépend de la qualité des relations choisies. Segura rapporte par exemple que 66 % des fautes injectées (655 sur 988) ont été détectées par des relations prédites automatiquement, sur 48 fonctions mathématiques : ce chiffre ne se transpose pas. Recouvre en partie les tests basés sur les propriétés, déjà couverts ailleurs.
- En stratégie : pour une recherche avec filtres, ajouter un filtre ne doit jamais augmenter le nombre de résultats. Pour un tri, permuter l'entrée ne change pas la sortie triée. Pour un total de panier, l'ordre des lignes ne change pas le total. Pour la pagination, l'union des pages donne la liste complète sans doublon.

## 8. Cas d'erreur et entrées hostiles

### Vérifier côté serveur toute règle validée côté client, et tenter de la contourner (requête directe, étape sautée)
- Niveau de preuve : N3 (guide officiel OWASP)
- Source : OWASP, WSTG v4.2, « Test Business Logic Data Validation » (4.10.1), https://wstg.owasp.org/v4.2/4-Web_Application_Security_Testing/10-Business_Logic_Testing/01-Test_Business_Logic_Data_Validation ; « Testing for the Circumvention of Work Flows » (4.10.6), https://wstg.owasp.org/v4.2/4-Web_Application_Security_Testing/10-Business_Logic_Testing/06-Testing_for_the_Circumvention_of_Work_Flows
- Extrait lu : 4.10.1 : « Validate that all checks are occurring on the back end and can't be bypassed. » ; « Only verifying data locally may leave applications vulnerable to server injections through proxies » ; exemple de paiement : « What happens if an attacker is able to get in the middle and send messages to the partner warehouse ordering carpet without payment? » 4.10.6 : « Develop a misuse case and try to circumvent every logic flow identified. »
- Portée / limites : l'URL « stable » redirige vers la v4.2. Une version plus récente du WSTG n'a pas été vérifiée. Guide orienté sécurité : il ne fixe pas de couverture.
- En stratégie : pour chaque validation de formulaire, un cas API qui envoie directement la valeur interdite (montant négatif, quantité 0, champ masqué modifié). Pour chaque flux, un cas qui saute une étape (confirmer sans payer, modifier après validation).

### Puiser les entrées malveillantes dans le catalogue OWASP de validation des entrées, filtré par la stack réelle
- Niveau de preuve : N3
- Source : OWASP, WSTG v4.2, « 4.7 Input Validation Testing » (table des tests), https://wstg.owasp.org/v4.2/4-Web_Application_Security_Testing/07-Input_Validation_Testing/
- Extrait lu : titres de la section : « Testing for Reflected Cross Site Scripting », « Testing for Stored Cross Site Scripting », « Testing for HTTP Verb Tampering », « Testing for HTTP Parameter Pollution », « Testing for SQL Injection », « Testing PostgreSQL », « Testing for Server-Side Request Forgery ».
- Portée / limites : la page d'index n'a pas d'introduction. Seuls les titres ont été lus, pas le détail de chaque test.
- En stratégie : retenir les entrées qui correspondent à la stack (XSS stocké dans un champ affiché ailleurs, paramètre dupliqué, verbe HTTP inattendu sur une route, SSRF si l'application récupère une URL fournie). Les tests de pénétration approfondis restent hors de la matrice et relèvent d'un audit de sécurité.

### Utiliser une liste publique de chaînes piégées pour les champs texte, sans la prendre pour un test de sécurité
- Niveau de preuve : N4 (projet communautaire)
- Source : Woolf M. (minimaxir), s. d., « Big List of Naughty Strings », https://github.com/minimaxir/big-list-of-naughty-strings
- Extrait lu : « The Big List of Naughty Strings is an evolving list of strings which have a high probability of causing issues » « when used as user-input data. » ; « not a fully-comprehensive substitute »
- Portée / limites : licence MIT. Aucune mesure d'efficacité. Le dépôt avertit que certaines chaînes peuvent révéler des failles et qu'il ne faut pas les envoyer à un logiciel tiers.
- En stratégie : un test paramétré par champ texte persistant (nom, adresse, commentaire) : enregistrement, relecture identique, affichage sans exécution.

### Tester les longueurs et égalités de texte avec des emojis et des formes Unicode composées ou décomposées
- Niveau de preuve : N3 (documentation de référence MDN)
- Source : MDN Web Docs, « String: length », https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/length ; « String.prototype.normalize() », https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/normalize
- Extrait lu : « The `length` data property of a `String` value contains the length of the string in UTF-16 code units. » ; exemple : `const emoji = "😄"; console.log(emoji.length); // 2` ; « However, since the code points are different, string comparison will not treat them as equal. And since the number of code points in each version is different, they even have different lengths. »
- Portée / limites : propre à JavaScript (UTF-16). Python compte en points de code et Postgres en caractères selon l'encodage, ce qui n'a pas été vérifié ici. D'où des écarts possibles entre validation client et validation serveur.
- En stratégie : à la borne de longueur d'un champ, un cas avec emoji (le client compte 2, le serveur peut compter 1). Pour l'unicité d'un pseudo ou d'un e-mail, un cas « é » précomposé contre « e » suivi de l'accent combinant.

### Tester les dates aux transitions d'heure d'été et les chaînes de date sans fuseau
- Niveau de preuve : N3
- Source : MDN Web Docs, « Date », https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date ; « Temporal.ZonedDateTime », https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Temporal/ZonedDateTime
- Extrait lu : Date : « When the time zone offset is absent, date-only forms are interpreted as a UTC time and date-time forms are interpreted as a local time. » ; « the timezone offset does not only depend on the current timezone, but also on the time represented by the `Date` object, because of daylight saving time and historical changes. » ZonedDateTime : « one local time can correspond to zero, one, or many UTC times. Consider the most common cause: daylight saving time transitions. »
- Portée / limites : MDN qualifie `Date` de « legacy feature » au profit de `Temporal`, dont la disponibilité navigateur est à vérifier au moment de l'usage.
- En stratégie : un cas d'échéance ou de rappel posé sur l'heure qui n'existe pas (passage à l'heure d'été) et un sur l'heure qui existe deux fois. Un cas où `"2026-03-29"` (date seule, lue en UTC) est comparé à une date-heure locale. Un cas où l'utilisateur et le serveur ne sont pas dans le même fuseau.

### Pour les montants : entiers en plus petite unité vers le prestataire, `numeric` en base, et cas d'arrondi au demi
- Niveau de preuve : N3 (documentations officielles)
- Source : Stripe, « Supported currencies », https://docs.stripe.com/currencies ; PostgreSQL Global Development Group, « 8.1. Numeric Types » (documentation PostgreSQL 18), https://www.postgresql.org/docs/current/datatype-numeric.html
- Extrait lu : Stripe : « All API requests expect `amount` values in the currency's minor unit » ; « `10` to charge 10 JPY (or any other zero-decimal currency). » ; « Stripe enforces a minimum payment amount for all charges to make sure the Stripe fee doesn't exceed your charge. » (dont « 0.50 EUR », « 0.50 CHF »). PostgreSQL : « If you require exact storage and calculations (such as for monetary amounts), use the `numeric` type instead. » ; « When rounding values, the `numeric` type rounds ties away from zero, while (on most machines) the `real` and `double precision` types round ties to the nearest even number. »
- Portée / limites : les règles Stripe (minimums, cas spéciaux ISK, HUF, TWD, UGX) évoluent : relire la page au moment de l'usage. L'arrondi « au plus proche pair » des flottants n'est garanti que « on most machines ».
- En stratégie : bornes du montant minimum du prestataire (0,49 / 0,50 / 0,51 dans la devise), devise sans décimales, conversion décimal vers centimes (19,99 → 1999), arrondi d'une TVA qui tombe sur ,5 centime, comparaison entre l'arrondi JS côté client et l'arrondi `numeric` côté base.

### Un refus RLS se teste comme un résultat vide ou une erreur WITH CHECK, avec un rôle non propriétaire
- Niveau de preuve : N3 (documentation officielle PostgreSQL)
- Source : PostgreSQL Global Development Group, « 5.9. Row Security Policies » (documentation courante), https://www.postgresql.org/docs/current/ddl-rowsecurity.html
- Extrait lu : « If no policy exists for the table, a default-deny policy is used, meaning that no rows are visible or can be modified. » ; « Superusers and roles with the `BYPASSRLS` attribute always bypass the row security system when accessing a table. Table owners normally bypass row security as well » ; exemple : « -- Alice can change her own password; RLS silently prevents updating other rows » et « ERROR: new row violates WITH CHECK OPTION for "passwd" ».
- Portée / limites : documentation du moteur. Les rôles propres à un hébergeur Postgres (rôle de service, rôle anonyme) n'ont pas été vérifiés ici.
- En stratégie : chaque cas « RLS bloquant » précise le rôle exécutant (jamais le propriétaire ni un superutilisateur, sinon le test passe à tort) et l'attendu exact. Lecture d'autrui : 0 ligne, pas d'erreur. Mise à jour d'autrui : 0 ligne modifiée. Insertion hors politique : erreur WITH CHECK. Ajouter un cas « table sans politique » : tout est refusé.

### Réserver le « test de contrat » au sens Pact aux intégrations entre consommateur et fournisseur identifiés
- Niveau de preuve : N3 (documentation officielle de l'outil sur sa propre pratique)
- Source : Pact Foundation, s. d., « What is Pact good for? », https://docs.pact.io/getting_started/what_is_pact_good_for ; « Introduction », https://docs.pact.io/
- Extrait lu : « Contract testing is a technique for testing an integration point by checking each application in isolation » ; mauvais usages listés : « Testing APIs where the consumers cannot be individually identified (eg. public APIs). » et « "Functional testing" of the provider - that is what the provider's own tests should do. »
- Portée / limites : point de vue d'un outil. Pour une API publique décrite en OpenAPI, la dérivation de tests depuis le schéma est traitée ailleurs (Schemathesis).
- En stratégie : la ligne « contrat » de la matrice dit quel contrat elle vise : schéma de réponse de l'API (front ↔ back du même dépôt), webhook entrant d'un prestataire (format de l'événement de paiement) ou API tierce consommée. Elle ne doit pas répéter les tests fonctionnels.

## Verdict sur les règles de l'agent

| Règle | Verdict | Motif sourcé |
|---|---|---|
| « Matrice de cas : happy path, edge cases (entrées limites, états vides, conditions de bord), erreurs (entrées invalides, réseau, auth, RLS bloquant), non-régression, contrat. » | **À préciser** | Les rubriques recoupent l'ordre positif → négatif → non fonctionnel de l'ATDD (ISTQB § 4.5.3) et les partitions invalides de l'EP (§ 4.2.1). Mais ce sont des étiquettes, pas des techniques de dérivation. Il manque les **combinaisons** (table de décision, ISTQB § 4.2.3 ; paires et triplets, NIST SP 800-142 : « pairwise testing may miss 10% to 40% »), les **transitions invalides** d'un flux à états (§ 4.2.4), la **BVA à 3 valeurs** (Reid 1997 : la plus efficace) et les cas sans oracle (relations métamorphiques). « RLS bloquant » doit préciser l'attendu (0 ligne, pas d'erreur) et le rôle (le propriétaire contourne la RLS, doc PostgreSQL). « Contrat » doit dire quel contrat (Pact : pas pour une API publique, pas pour le fonctionnel). |
| « Spécifier chaque test : description en langage métier, données d'entrée, attendu, niveau. » | **Soutenue, à compléter** | ISTQB § 4.5.3 : cas « in natural language involving the necessary preconditions (if any), the inputs, and the postconditions ». ISO 29119-3 § 3.2 : attendu « based on its specification or another source ». Ajouter les **préconditions** (rôle, état, données présentes), la **postcondition** (état en base) et la **source de l'attendu** (exigence ou critère). Le langage métier en style déclaratif est recommandé par Cucumber (N3, sans mesure). |
| « Jamais de hand-off d'écriture de tests sans matrice de cas définie au préalable. » | **Convention sans preuve trouvée** (justifiable par la coordination, pas par la détection) | Aucun gain de détection mesuré pour les cas écrits d'avance : Itkonen & Mäntylä 2014 (51 sujets) ne trouvent pas de différence d'efficacité avec l'exploratoire, et plus de faux positifs côté cas écrits (résumé seul lu). Fucci et al. 2017 : l'ordre test/code « had no important influence ». La règle se défend comme contrat de passation entre agents et comme base de CI. Elle doit tolérer une charte exploratoire quand la spec est faible (ISTQB § 4.4.2). |
| « Pragmatique : un test imparfait qui tourne en CI vaut mieux qu'un test parfait jamais écrit. » | **Convention sans preuve trouvée** | Aucune étude lue ne compare les deux. L'ISTQB note seulement que répéter des tests automatisés de régression peut avoir « a beneficial outcome » (principe 5). Limite non vérifiée : un test instable (flaky) en CI a un coût propre (Luo et al. 2014 et le blog Google 2016 n'ont pas pu être lus). Garder la règle, en ajoutant « … à condition qu'il soit déterministe ». |
| « Jamais de tests inventés pour des fonctions qui n'existent pas : la matrice se construit sur le code source lu. » | **À préciser (en partie contredite)** | La première moitié (ne pas viser une API imaginaire) est une convention saine. La seconde contredit le référentiel : les cas boîte noire sont « independent of how the software is implemented » et l'analyse du code « may not detect the resulting defects of omission » (ISTQB § 4.1, § 4.3.3). L'attendu vient de la spécification (ISO 29119-3 § 3.2). Basili & Selby 1987 : le test fonctionnel et la relecture trouvent des classes de fautes différentes. Reformuler : construire la matrice sur la **spec et le code lu**. Un comportement exigé mais absent du code reste dans la matrice, marqué « non implémenté ». |

## Mythes et affirmations contestées

- **« Le test par paires suffit. »** Contesté : NIST SP 800-142 indique « pairwise testing may miss 10% to 40% or more of system bugs ». Sur les données NASA, 93 % des défaillances à 2 paramètres et 98 % à 3. La FAQ NIST : « it is not enough to test all pairs of values ».
- **« Deux valeurs par borne suffisent. »** À nuancer : l'ISTQB montre qu'une erreur `≤` codée `=` échappe à la BVA à 2 valeurs et est attrapée à 3 valeurs (argument logique, pas mesure).
- **« Le hasard vaut une technique de conception. »** Nuancé : chez Reid 1997, 8 cas aléatoires par module égalaient l'EP, mais il en fallait environ 50 000 pour égaler la BVA (un seul système avionique, résumé seul lu).
- **« Les cas écrits d'avance trouvent plus de défauts que l'exploratoire. »** Non soutenu : aucune différence d'efficacité chez Itkonen & Mäntylä 2014 (étudiants, test manuel).
- **« Le bénéfice du TDD vient du test écrit d'abord. »** Contesté : Fucci et al. 2017 attribuent les gains à la granularité et à la régularité des cycles, pas à l'ordre.
- **« Le TDD améliore nettement la qualité. »** Faiblement soutenu : selon Fucci et al. 2017, la méta-analyse de Rafique & Mišić juge l'amélioration « not strong », et la productivité est non concluante (lecture de seconde main).
- **« Le BDD améliore la qualité. »** Pas de preuve industrielle trouvée : la cartographie Binamungu & Maro 2023 relève la rareté des évaluations industrielles. Le BDD a aussi un coût de maintenance déclaré (61 % des 75 praticiens citent la duplication comme frein).
- **« Le développeur sait quelle technique lui réussit. »** Contesté : 50 % de perceptions fausses, soit 31 points d'efficacité perdus en moyenne (Vegas et al. 2024, petit échantillon d'étudiants).
- **« 100 % de couverture du code signifie une matrice complète. »** Faux par construction : la boîte blanche ne voit pas les exigences non implémentées (ISTQB § 4.3.3).
- **« Un accès refusé par RLS lève une erreur. »** Faux pour la lecture et la mise à jour : PostgreSQL filtre silencieusement (« RLS silently prevents updating other rows »). Seul WITH CHECK lève une erreur.
- **« Tester la RLS en tant que propriétaire de la table prouve la politique. »** Faux : « Table owners normally bypass row security as well » (sauf FORCE ROW LEVEL SECURITY).

## Non vérifié

- **ISO/IEC/IEEE 29119-4:2021, clauses normatives 5.2.1, 5.2.3, 6.2.1, 6.2.3** (règles exactes de sélection des bornes, formules de couverture) : payantes, seul l'extrait iTeh (sommaire, définitions, conformité) a été lu. La page iso.org a renvoyé une erreur 403.
- **Kuhn, Wallace, Gallo 2004, texte intégral** : le PDF archivé (webarchive.library.unt.edu) n'a pas pu être téléchargé (échec TLS, puis 503). Les pourcentages par domaine (dispositifs médicaux, navigateur, serveur, base NASA) ne sont donc pas cités depuis l'article, seulement depuis NIST SP 800-142 (NASA : 67 / 93 / 98 %). Les chiffres « 65 % / 96 % » et « 40 % / 30 % / près de 90 % » vus dans des extraits de recherche ne sont **pas vérifiés**.
- **Basili & Selby 1987** : article intégral non lu (résumé NTRS seul). Pas de chiffres d'efficacité par technique.
- **Juristo, Moreno, Vegas 2004** : conclusions détaillées non lues (Springer redirige vers une authentification). Juristo et al. ICST 2012 (huit réplications EP / branches / relecture) : PDF du dépôt de Séville non obtenu (page HTML renvoyée). Chiffres non vérifiés.
- **Itkonen, Mäntylä, Lassenius 2007 (ESEM)** : non ouvert. Seul le résumé de la réplication de 2014 a été lu.
- **Ghazi et al., IEEE Access 2018** (« Levels of exploration in exploratory testing… ») : page non ouverte, seul le préprint arXiv de 2017 a été lu.
- **Rafique & Mišić 2013** : résumé non accessible (IEEE, notices miroirs en 503). Contenu rapporté de seconde main. Le nombre d'études (25 ou 27) n'est pas tranché.
- **Bissi et al. 2016** (revue systématique TDD, IST) : ScienceDirect 403, résumé masqué par l'éditeur sur Semantic Scholar. Aucun chiffre vérifié.
- **Specification by Example (Adzic)** : seule la page de présentation a été lue.
- **Tests instables en CI** : Luo et al. 2014 (FSE) et Google Testing Blog 2016 (« Flaky Tests at Google… ») n'ont pas pu être lus (connexion réinitialisée, corps d'article absent). Aucun chiffre sur les tests instables n'est donc avancé.
- **Version du WSTG OWASP** : l'URL « stable » renvoie vers la v4.2. L'existence d'une version plus récente n'a pas été vérifiée.
- **Comptage des caractères côté Python et Postgres** (par opposition à l'UTF-16 de JavaScript) : non vérifié dans une documentation officielle lors de cette recherche.

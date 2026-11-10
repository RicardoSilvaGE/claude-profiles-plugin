# Fiche `ux-preuves` — Tests — stratégie et allocation de l'effort

> Fiche du skill `ux-preuves` (dev-fullstack), volet **tests**, préchargé par `qa`. Couvre : forme de la suite (pyramide, trophée, tailles de tests de Google, ratios publiés et mesurés), où se trouvent les défauts selon le niveau, allocation par le risque et par l'historique (concentration des fautes, churn), principes ISTQB, tests après déploiement, non-régression et sélection de tests.
> **Instantané de la recherche documentaire du 10.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Études (souvent des prépublications pour les LLM), docs d'outils
> et pratiques d'entreprise **vieillissent** : avant d'en faire dépendre une règle,
> relire la source (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles de l'agent », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

**Méthode.** Chaque entrée repose sur une page réellement ouverte le 10.11.2026 : WebFetch, ou téléchargement par curl suivi d'une extraction de texte (`pdftotext` pour les PDF, nettoyage HTML pour les pages de blog dont WebFetch ne rendait pas le corps). Les extraits sont recopiés tels quels depuis ce texte extrait. Quand seul le résumé ou la fiche bibliographique a pu être lu, c'est écrit (« résumé seul lu »). Échelle de preuve : N1 = norme ou référentiel normatif ; N2 = recherche revue par pairs ou étude empirique à large échantillon ; N3 = guide d'une institution ou d'une entreprise sur sa propre pratique ; N4 = avis d'expert, livre, étude d'éditeur. Le syllabus ISTQB est classé N1, avec une réserve : c'est un référentiel de certification, pas une norme ISO. Il ne mesure rien, il codifie un consensus. Les chapitres 11, 12 et 14 de *Software Engineering at Google* (abseil.io) sont signés respectivement Adam Bender, Erik Kuefler et Joseph Graves (mention « Written by » de chaque page). Sujets exclus parce que déjà traités ailleurs : couverture (Inozemtseva & Holmes), Testing Trophy, Testing Library, tests instables (Micco, Luo), mutation chez Google, tests basés sur les propriétés, Schemathesis, Pact, Testcontainers, Yuan et al. Les sources inaccessibles (403, 503, échec TLS) sont listées dans `## Non vérifié`, jamais citées de mémoire. 35 entrées.

---

## 1. Forme de la suite : ce qui est convention, ce qui est mesuré

### Tenir la pyramide pour une heuristique qualitative (« beaucoup plus de tests bas niveau que de tests par l'interface ») dont l'origine est partagée, pas pour un ratio
- Niveau de preuve : N4 (Fowler), origine confirmée par N1 (ISTQB)
- Source : Martin Fowler, 2012, « TestPyramid », https://martinfowler.com/bliki/TestPyramid.html ; ISTQB, 2024, « Certified Tester Foundation Level Syllabus v4.0.1 », §5.1.6, https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf
- Extrait lu : « Its essential point is that you should have many more low-level UnitTests than high level BroadStackTests running through a GUI. » ; « He originally drew it in conversation with Lisa Crispin in 2003-4 and described it at a scrum gathering in 2004. Jason Huggins independently came up with the same idea around 2006. » (Fowler) ; « the original test pyramid model (Cohn 2009) defines three layers: “unit tests”, “service tests” and “UI tests”. » (ISTQB)
- Portée / limites : article du 1er mai 2012, révisé en 2016 et 2017. Aucun chiffre ni ratio. La seule justification avancée est le coût des tests par l'interface (lents, fragiles, chers à écrire), sans mesure à l'appui. Le livre de Cohn (2009) n'a pas été ouvert.
- En stratégie : le cadrage peut exiger que la base soit plus large que le sommet, mais pas un pourcentage. La couche « service » du modèle d'origine correspond, pour Next.js et Supabase, aux route handlers, server actions et RPC testés sans navigateur. Le défaut à chercher est une suite dont la majorité des vérifications passe par le navigateur.

### Lire tout ratio chiffré (70/20/10, 80/15/5) comme un point de départ à ajuster : Google en publie deux différents, sans données
- Niveau de preuve : N3
- Source : Mike Wacker (Google), 22.04.2015, « Just Say No to More End-to-End Tests », https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html ; Adam Bender, 2020, *Software Engineering at Google*, chap. 11 « Testing Overview », https://abseil.io/resources/swe-book/html/ch11.html
- Extrait lu : « As a good first guess, Google often suggests a 70/20/10 split: 70% unit tests, 20% integration tests, and 10% end-to-end tests. The exact mix will be different for each team, but in general, it should retain that pyramid shape. » (2015) ; « As a very rough guideline, we tend to aim to have a mix of around 80% of our tests being narrow-scoped unit tests [...] 15% medium-scoped integration tests [...] and 5% end-to-end tests that validate the entire system. » (2020)
- Portée / limites : le billet de 2015 présente son schéma comme « a simplified version of the testing pyramid from the opening keynote of the 2014 Google Test Automation Conference ». Aucune des deux sources ne fournit de données. Les ratios comptent des cas de test, pas le temps d'exécution ni l'effort. Le corps du billet de 2015 a été lu à partir du HTML téléchargé, car WebFetch ne le rendait pas.
- En stratégie : si un ratio figure dans le cadrage, il faut le présenter comme un point de départ, avec son auteur. On évalue la forme en ordre de grandeur, et on juge la répartition sur des critères de vitesse, de fiabilité et de risque.

### Mesurer la répartition réelle plutôt que l'affirmer : une grande base de code publie ses comptes par niveau
- Niveau de preuve : N3
- Source : GitLab, 2025, « Testing levels » (guide de développement), https://docs.gitlab.com/development/testing_guide/testing_levels/
- Extrait lu : « As of 2025-02-03, we have the following estimated distribution of tests per level » — unit « 218,459 (75.66%) », integration « 57,127 (19.79%) », system white-box « 12,444 (4.31%) », black-box end-to-end « 704 (0.24%) ».
- Portée / limites : un seul projet (application Rails et front en Jest), qui compte des tests et non leur coût. C'est la seule répartition mesurée trouvée. Elle a la forme d'une pyramide, mais avec moins de 1 % d'E2E en boîte noire, bien en dessous des 10 % prescrits.
- En stratégie : à l'audit, compter les tests par niveau (fichiers Vitest unitaires, Vitest avec base réelle, specs Playwright) avant de conclure que la forme est saine ou déséquilibrée.

### Classer les tests par ressources consommées (un processus, une machine, plusieurs machines) plutôt que par l'étiquette « unit » ou « integration »
- Niveau de preuve : N3
- Source : Bender, 2020, *Software Engineering at Google*, chap. 11, https://abseil.io/resources/swe-book/html/ch11.html
- Extrait lu : « in brief, small tests run in a single process, medium tests run on a single machine, and large tests run wherever they want » ; « We make this distinction, as opposed to the more traditional “unit” or “integration,” because the most important qualities we want from our test suite are speed and determinism »
- Portée / limites : convention interne à Google, appliquée par leur infrastructure. Elle s'applique sans peine hors de Google : un test qui lance un Postgres local est « medium », un test qui frappe un déploiement de préproduction est « large ».
- En stratégie : pour chaque cas de la matrice, préciser sa taille (processus unique, Postgres local ou Supabase CLI, déploiement distant). C'est la taille qui prédit la vitesse et l'instabilité, pas le nom du dossier.

### Nommer les anti-formes à rejeter : le cornet de glace (surtout de l'E2E) et le sablier (beaucoup d'unitaires et d'E2E, presque pas d'intégration)
- Niveau de preuve : N3
- Source : Bender, 2020, *Software Engineering at Google*, chap. 11, https://abseil.io/resources/swe-book/html/ch11.html
- Extrait lu : « With the ice cream cone, engineers write many end-to-end tests but few integration or unit tests. » ; « The hourglass involves many end-to-end tests and many unit tests but few integration tests. »
- Portée / limites : simple description de formes, sans mesure de leur coût. Le billet Google de 2015 décrit les mêmes anti-formes.
- En stratégie : le sablier est le défaut typique d'une application Next.js et Supabase. On y trouve des unitaires sur les utilitaires et des Playwright sur les parcours, mais rien entre les deux : aucune politique RLS, aucune RPC, aucune server action n'est testée contre une vraie base.

### Pour un service dont l'essentiel est l'interaction avec sa base ou ses voisins, accepter une forme en « nid d'abeille » centrée sur l'intégration
- Niveau de preuve : N3
- Source : André Schaffer & Rickard Dybeck (Spotify), 11.01.2018, « Testing of Microservices », https://engineering.atspotify.com/2018/01/11/testing-of-microservices
- Extrait lu : « That means we should focus on Integration Tests, have a few Implementation Detail Tests and even fewer Integrated Tests (ideally none). »
- Portée / limites : retour d'expérience sur des microservices. Le texte définit un « Integrated Test » comme « A test that will pass or fail based on the correctness of another system ». Le schéma lui-même n'a pas été rendu. Exemple cité dans l'article : un service SQL plus REST testé uniquement en démarrant la base et en interrogeant l'API.
- En stratégie : pour une couche dont la logique est surtout du SQL et de la RLS, la plupart des tests utiles sont des tests d'intégration contre Postgres. Un ratio unitaire imposé produirait des mocks sans valeur.

### Avant de débattre de la forme, vérifier ce que chacun appelle « unit test » : le débat pyramide contre nid d'abeille est surtout sémantique
- Niveau de preuve : N4
- Source : Martin Fowler, 02.06.2021, « On the Diverse And Fantastical Shapes of Testing », https://martinfowler.com/articles/2021-test-shapes.html
- Extrait lu : « This makes the pyramid versus honeycomb discussion moot, since any descriptions I've heard of the test pyramid consider unit tests to be sociable and/or solitary. » ; et la citation de Justin Searls qu'il reprend : « People love debating what percentage of which type of tests to write, but it's a distraction. »
- Portée / limites : article d'opinion, sans données.
- En stratégie : dans docs/TESTING.md, définir en une ligne ce que le projet appelle unitaire (isolé ou « sociable »), intégration et E2E, avant de donner une forme cible.

### Arbitrer chaque test sur cinq dimensions en tension (vitesse, maintenabilité, ressources, fiabilité, fidélité), pas sur la seule forme
- Niveau de preuve : N3
- Source : Adam Bender (Google), 15.10.2024, « SMURF: Beyond the Test Pyramid », https://testing.googleblog.com/2024/10/smurf-beyond-test-pyramid.html
- Extrait lu : « While useful, the test pyramid lacks the details you need as your test suite grows and you face challenging trade-offs. » ; « Integration and end-to-end tests can better reflect realistic conditions, while unit tests have to simulate the environment, which can lead to drift between test expectations and reality. »
- Portée / limites : épisode de « Testing on the Toilet », grille qualitative sans mesure.
- En stratégie : pour chaque niveau proposé, dire ce qu'on gagne et ce qu'on paie. Exemple : un test RLS sur vrai Postgres a une forte fidélité et coûte un peu de vitesse, un compromis acceptable.

### Placer chaque vérification au niveau le plus bas qui puisse l'observer, ne pas la dupliquer, et réserver l'E2E à une poignée de parcours critiques
- Niveau de preuve : N4
- Source : Ham Vocke, 26.02.2018, « The Practical Test Pyramid », https://martinfowler.com/articles/practical-test-pyramid.html
- Extrait lu : « Every single test in your test suite is additional baggage and doesn't come for free. » ; « Push your tests as far down the test pyramid as you can » ; « Maybe you'll find one or two more crucial user journeys that you can translate into end-to-end tests. Everything more than that will likely be more painful than helpful. »
- Portée / limites : article de praticien, illustré par un exemple de boutique en ligne, sans mesure.
- En stratégie : dans la matrice d'une feature, chaque cas est attribué à un seul niveau. Les parcours E2E sont listés explicitement (inscription, connexion, paiement, action principale). Tout E2E hors de cette liste, ou tout cas couvert à deux niveaux, doit être motivé par un risque.

---

## 2. Où se trouvent les défauts selon le niveau

### Prévoir des tests plus fidèles pour ce que l'unitaire ne peut pas voir : doublures infidèles, configuration, charge, comportements non anticipés
- Niveau de preuve : N3
- Source : Joseph Graves, 2020, *Software Engineering at Google*, chap. 14 « Larger Testing », https://abseil.io/resources/swe-book/html/ch14.html
- Extrait lu : « The primary reason larger tests exist is to address fidelity. » ; « But that engineer usually did not write the thing being mocked and can be misinformed about its actual behavior. » ; « Unit tests alone cannot verify this compatibility. » (configuration) ; « Unit tests are limited by the imagination of the engineer writing them. »
- Portée / limites : recueil de pratiques Google, pas une mesure. Le chapitre précise que plus de fidélité coûte plus cher.
- En stratégie : chercher les mocks du client Supabase ou de `fetch` qui encodent une hypothèse jamais confrontée au vrai service, ainsi que la configuration (variables d'environnement, `next.config`, politiques RLS) que l'on suppose vraie sans jamais la tester. Pour chaque risque, poser la question de la fidélité minimale qui permet de l'observer : un bug de RLS exige un vrai Postgres, un bug de mise en page exige un vrai navigateur, un bug de calcul n'exige ni l'un ni l'autre.

### Ne pas présumer que l'unitaire et l'intégration trouvent des types de défauts différents : sur 38 782 tests, une étude par mutation n'a trouvé aucune différence
- Niveau de preuve : N2 (résumé seul lu)
- Source : Fabian Trautsch, Steffen Herbold, Jens Grabowski, 2020, « Are Unit and Integration Test Definitions Still Valid for Modern Java Projects? An Empirical Study on Open-Source Projects », *Journal of Systems and Software*, DOI 10.1016/j.jss.2019.110421 ; fiche lue : https://www.swe.informatik.uni-goettingen.de/node/2878
- Extrait lu : « We could not find any evidence that one test type is more capable of detecting certain defect types than the other one. »
- Portée / limites : projets Java open source, classés selon la définition IEEE. Les défauts sont des mutants regroupés en cinq types, pas des défauts réels d'intégration. Le nombre de projets n'est pas indiqué sur la fiche lue.
- En stratégie : l'argument « il faut de l'intégration parce qu'elle trouve d'autres bugs » n'est pas démontré au niveau du code. L'argument solide est d'ordre environnemental : configuration, vrai Postgres, doublures infidèles (entrée précédente).

### Ne compter sur aucun niveau de test isolé : chaque étape de test retire en moyenne environ 35 à 45 % des défauts selon Capers Jones
- Niveau de preuve : N4
- Source : Capers Jones, 2011, « Software Defect Removal Efficiency », https://www.ppi-int.com/wp-content/uploads/2021/01/Software-Defect-Removal-Efficiency.pdf
- Extrait lu : table 2, moyennes « Unit testing (automated) 20.00% 40.00% 50.00% », « Function testing 33.00% 40.00% 55.00% », « System testing 27.00% 42.00% 55.00% », « Risk-based testing 55.00% 70.00% 80.00% » ; et « High levels of DRE cannot be achieved using testing alone. »
- Portée / limites : données de cabinet de conseil, à la méthode non publiée, sur de gros projets. Aucune ligne « integration testing » dans la table. Les chiffres datent de 2011 et sont antérieurs aux pratiques de CI actuelles.
- En stratégie : l'ordre de grandeur sert d'argument pour cumuler plusieurs filtres (typage strict, lint, revue, unitaire, intégration, smoke). Pas d'usage plus précis que celui-là.

### Considérer qu'un E2E est nettement plus instable qu'un petit test (14 % contre 0,5 % chez Google), et qu'une suite perd sa valeur vers 1 % d'instabilité
- Niveau de preuve : N3
- Source : Jeff Listfield (Google), 17.04.2017, « Where do our flaky tests come from? », https://testing.googleblog.com/2017/04/where-do-our-flaky-tests-come-from.html ; Bender, 2020, *Software Engineering at Google*, chap. 11, https://abseil.io/resources/swe-book/html/ch11.html
- Extrait lu : « Over the course of a week, 0.5% of our small tests were flaky, 1.6% of our medium tests were flaky, and 14% of our large tests were flaky » ; « Overwhelmingly, the larger the test (as measured by binary size, RAM use, or number of libraries built), the more likely it is to be flaky. » (2017) ; « Our experience suggests that as you approach 1% flakiness, the tests begin to lose value. » (chap. 11)
- Portée / limites : une semaine de données internes à Google, et une taille déclarée par l'ingénieur (« subjective »). L'auteur note que l'outil (WebDriver) compte moins que la taille. Billet distinct de Micco 2016, déjà traité ailleurs.
- En stratégie : chaque E2E ajouté augmente le risque d'instabilité, donc chaque E2E doit être justifié par un risque. À l'audit, mesurer le taux d'instabilité par niveau. Une suite Playwright qui échoue sans raison plus d'une fois sur cent est à assainir avant qu'on y ajoute des tests.

### Choisir le niveau d'après la boucle de retour : rapide, fiable, qui isole la panne
- Niveau de preuve : N3
- Source : Mike Wacker (Google), 2015, « Just Say No to More End-to-End Tests », https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html
- Extrait lu : « It's fast. » ; « It's reliable. » ; « It isolates failures. » ; « Thus, to evaluate any testing strategy, you cannot just evaluate how it finds bugs. You also must evaluate how it enables developers to fix (and even prevent) bugs. »
- Portée / limites : billet d'opinion qui s'appuie sur un scénario fictif de projet en retard, pas sur une mesure.
- En stratégie : pour chaque cas, se demander si son échec désignera la ligne fautive. Un E2E rouge sur un tunnel de cinq écrans ne la désigne pas.

---

## 3. Allocation par le risque

### Puisque tout tester est impossible, calculer le niveau de risque comme probabilité × impact, ou le lire dans une matrice, puis en déduire niveaux, techniques et couverture
- Niveau de preuve : N1 (référentiel ISTQB)
- Source : ISTQB, 2024, CTFL Syllabus v4.0.1, §1.3 (principe 2), §5.2.1 et §5.2.3, https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf
- Extrait lu : « Exhaustive testing is impossible. [...] Rather than attempting to test exhaustively, test techniques (see chapter 4), test case prioritization (see section 5.1.5), and risk-based testing (see section 5.2), should be used to focus test efforts. » ; « In the quantitative approach the risk level is calculated as the multiplication of risk likelihood and risk impact. In the qualitative approach the risk level can be determined using a risk matrix. » ; résultats utilisés pour « Determine the particular test levels and propose test types to be performed » et « Determine the test techniques to be employed and the coverage to be achieved »
- Portée / limites : la v4.0 date de 2023, la v4.0.1 lue est du 15.09.2024. Le texte est prescriptif, sans preuve d'efficacité.
- En stratégie : la matrice de cas porte une colonne « risque » (probabilité et impact, sur trois niveaux suffit). Le niveau de test et la profondeur se déduisent de cette colonne. La matrice dit aussi ce qui n'est pas testé, et pourquoi.

### S'appuyer sur la norme ISO/IEC/IEEE 29119, qui adopte une approche du test fondée sur le risque
- Niveau de preuve : N1 (résumé seul lu)
- Source : IEEE Standards Association, fiche « IEEE/ISO/IEC 29119-2-2021 — Part 2: Test processes », https://standards.ieee.org/ieee/29119-2/7498/
- Extrait lu : pour l'édition 2013 : « ISO/IEC/IEEE 29119-2 follows a risk-based approach to testing. » ; « Risk-based testing allows testing to be prioritized and focused on the most important features and functions. »
- Portée / limites : le texte normatif est payant et n'a pas été lu. La page iso.org a répondu 403. La phrase citée décrit l'édition 2013 ; le résumé de l'édition 2021 ne mentionne pas le risque.
- En stratégie : on peut citer la norme pour justifier le principe d'allocation par le risque, mais pas pour une règle précise.

### Exiger plus de tests là où l'enjeu est vital ou financier
- Niveau de preuve : N3
- Source : Alex Perry & Max Luebbe, 2016, *Site Reliability Engineering* (Google), chap. 17 « Testing for Reliability », https://sre.google/sre-book/testing-reliability/
- Extrait lu : « Remember that not all software is created equal. Life-critical or revenue-critical systems demand substantially higher levels of test quality and coverage than a non-production script with a short shelf life. »
- Portée / limites : principe de praticiens, sans seuil chiffré.
- En stratégie : l'auth, le paiement, la suppression de données et les politiques RLS appellent une couverture maximale sur plusieurs niveaux. Aucune source n'établit qu'un affichage cosmétique se contente d'un smoke : c'est l'application du même principe, pas une règle sourcée.

### Faire de la stratégie de test un repérage des principaux vecteurs de risque, et de la part de chaque type de test
- Niveau de preuve : N3
- Source : Graves, 2020, *Software Engineering at Google*, chap. 14, https://abseil.io/resources/swe-book/html/ch14.html
- Extrait lu : « a key part of the test plan is a strategic outline of what types of testing are needed and how much of each. This test strategy identifies the primary risk vectors and the necessary testing approaches to mitigate those risk vectors. »
- Portée / limites : décrit le rôle de « Test Engineer » chez Google.
- En stratégie : c'est le contenu minimal de docs/TESTING.md : les vecteurs de risque, puis pour chacun le type de test et la profondeur.

### Utiliser le regroupement des fautes pour pondérer la probabilité, sans en faire une loi « 20/80 » : sur un système industriel, 20 % des fichiers classés par un modèle contenaient de 71 à 92 % des fautes
- Niveau de preuve : N2 (étude) ; principe repris par N1 (ISTQB)
- Source : Thomas J. Ostrand, Elaine J. Weyuker, Robert M. Bell, 2004, « Where the Bugs Are », ISSTA 2004, PDF lu : https://typeset.io/pdf/where-the-bugs-are-3l123sb1hc.pdf (version étendue : « Predicting the location and number of faults in large software systems », IEEE TSE 2005, DOI 10.1109/TSE.2005.49, fiche seule vue) ; ISTQB, 2024, CTFL v4.0.1, §1.3, principe 4, https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf
- Extrait lu : « The predictions were extremely accurate, correctly selecting files that contained between 71% and 92% of the faults, with the overall average being 83%. » ; « Of course there is nothing magical about the 20% figure. » ; « a good strategy is to test these files first and with greatest emphasis. » (Ostrand et al.) ; « Defects cluster together. A small number of system components usually contain most of the defects discovered or are responsible for most of the operational failures (Enders 1975). » (ISTQB)
- Portée / limites : un système d'inventaire AT&T sur 15 versions, un second système pour la réplication. Modèle de régression binomiale négative alimenté par l'historique. Les auteurs refusent explicitement de ne tester que ces fichiers. L'ISTQB renvoie à Enders (1975) sans données propres.
- En stratégie : sur un petit projet, approcher la probabilité par l'historique git et le journal des incidents (modules souvent modifiés ou déjà corrigés). Ce critère donne un ordre de priorité, il n'autorise pas à exclure le reste.

### Utiliser le churn relatif (changements rapportés à la taille et à la durée) comme indicateur de probabilité de défaut, pas le churn absolu
- Niveau de preuve : N2
- Source : Nachiappan Nagappan & Thomas Ball, 2005, « Use of Relative Code Churn Measures to Predict System Defect Density », ICSE 2005, https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/icse05churn.pdf
- Extrait lu : « we show that while absolute measures of code churn are poor predictors of defect density, our set of relative measures of code churn is highly predictive of defect density » ; « able to discriminate between fault and not faultprone binaries with an accuracy of 89.0 percent. »
- Portée / limites : Windows Server 2003, environ 44,97 millions de lignes, mesuré au niveau des binaires. La transposition à une petite application web n'est pas démontrée.
- En stratégie : à l'audit, croiser couverture et churn relatif. Un fichier très modifié et peu testé est une cible prioritaire.

### Cibler les zones à forte probabilité de casse : chez Google, les tests qui échouent sont proches du code modifié, et le code récemment touché par plus de trois développeurs casse davantage
- Niveau de preuve : N2 (étude industrielle à très large échantillon)
- Source : Atif Memon, Zebao Gao, Bao Nguyen, Sanjeev Dhanda, Eric Nickell, Rob Siemborski, John Micco, 2017, « Taming Google-Scale Continuous Testing », ICSE-SEIP 2017, PDF lu : https://web.eecs.umich.edu/~xwangsd/courses/w23/readings/googletest.pdf
- Extrait lu : « Our findings show: very few of our tests ever fail, but those that do are generally “closer” to the code they test; certain frequently modified code and certain users/tools cause more breakages; and code recently modified by multiple developers (more than 3) breaks more often. »
- Portée / limites : plateforme TAP de Google, environ 2 milliards de lignes, « 5.5 Million affected tests ». Copie du PDF hébergée par un cours universitaire, pas par l'éditeur. Pour un développeur seul, le critère « plus de trois développeurs » ne s'applique pas.
- En stratégie : le critère transposable est la proximité. Un test proche du code (unitaire ou intégration du module) a plus de chances d'attraper la régression qu'un E2E éloigné.

### Ne pas présenter le test basé sur les risques comme démontré : la littérature est surtout conceptuelle, à quelques études de cas près
- Niveau de preuve : N2 (résumé seul lu)
- Source : Michael Felderer & Ina Schieferdecker, 2014, « A taxonomy of risk-based testing », *International Journal on Software Tools for Technology Transfer* (section spéciale), préprint : https://arxiv.org/abs/1912.11519
- Extrait lu : « has been developed by analyzing the work presented in available publications on risk-based testing. »
- Portée / limites : taxonomie construite à partir de la littérature, sans expérimentation. Une étude de cas industrielle sur trois cas (Felderer & Ramler, STTT 16, 2014, DOI 10.1007/s10009-014-0328-z) existe, mais son résumé est masqué par l'éditeur : non lue.
- En stratégie : l'allocation par le risque se défend comme pratique normée (ISTQB, 29119) et de bon sens (Google SRE). Il ne faut pas lui attribuer un gain chiffré.

---

## 4. Principes et culture

### Tester tout comportement qu'on ne veut pas voir casser (règle Beyoncé)
- Niveau de preuve : N3
- Source : Bender, 2020, *Software Engineering at Google*, chap. 11, https://abseil.io/resources/swe-book/html/ch11.html
- Extrait lu : « test everything that you don’t want to break » ; « Succinctly, it can be stated as follows: “If you liked it, then you shoulda put a test on it.” »
- Portée / limites : la formule exacte du livre est « shoulda » (et non « should have »). Elle est née d'un contexte d'équipes d'infrastructure qui modifient tout le dépôt.
- En stratégie : un comportement critique sans test automatisé n'est garanti par rien. Cette règle donne la liste minimale de ce qui doit figurer dans la matrice.

### Renouveler les tests, car ils s'usent (ancien « paradoxe du pesticide »)
- Niveau de preuve : N1 (référentiel ISTQB)
- Source : ISTQB, 2024, CTFL v4.0.1, §1.3, principe 5, https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf
- Extrait lu : « Tests wear out. If the same tests are repeated many times, they become increasingly ineffective in detecting new defects (Beizer 1990). [...] However, in some cases, repeating the same tests can have a beneficial outcome, e.g., in automated regression testing »
- Portée / limites : l'expression « pesticide » n'apparaît pas dans le texte de la v4.0.1 (vérifié par recherche dans le texte extrait). Les sept principes de cette version sont : présence et non absence, exhaustivité impossible, test précoce, regroupement, usure, dépendance au contexte, illusion de l'absence de défauts.
- En stratégie : une suite verte depuis des mois sur un module qui change n'est pas une preuve. Il faut ajouter des cas nouveaux (limites, propriétés) quand le code évolue.

### Adapter la stratégie au contexte : aucune approche universelle
- Niveau de preuve : N1 (référentiel ISTQB)
- Source : ISTQB, 2024, CTFL v4.0.1, §1.3, principe 6, https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf
- Extrait lu : « Testing is context dependent. There is no single universally applicable approach to testing. Testing is done differently in different contexts (Kaner 2011). »
- Portée / limites : principe.
- En stratégie : un ratio cible unique appliqué à tous les projets contredit ce principe. Une application CRUD sur Supabase et une bibliothèque de calcul n'ont pas la même forme.

### Rendre chaque test hermétique et indépendant de l'ordre d'exécution
- Niveau de preuve : N3
- Source : Bender, 2020, *Software Engineering at Google*, chap. 11, https://abseil.io/resources/swe-book/html/ch11.html
- Extrait lu : « All tests should strive to be hermetic: a test should contain all of the information necessary to set up, execute, and tear down its environment. Tests should assume as little as possible about the outside environment, such as the order in which the tests are run. For example, they should not rely on a shared database. »
- Portée / limites : le texte dit « strive » (s'efforcer) et reconnaît que c'est plus difficile pour les grands tests.
- En stratégie : chaque test Playwright ou d'intégration crée ses propres données (utilisateur, ligne) et ne compte pas sur celles d'un test précédent.

### Savoir que la dépendance d'ordre est réelle, difficile à voir et qu'elle masque des fautes, et la débusquer en mélangeant l'exécution
- Niveau de preuve : N2 (étude, résumé seul lu) ; N3 (documentation de l'outil)
- Source : Sai Zhang, Darioush Jalali, Jochen Wuttke, Kıvanç Muşlu, Wing Lam, Michael D. Ernst, David Notkin, 2014, « Empirically Revisiting the Test Independence Assumption », ISSTA 2014, p. 385-396, https://homes.cs.washington.edu/~mernst/pubs/test-independence-issta2014-abstract.html ; Vitest, documentation « sequence », https://vitest.dev/config/sequence
- Extrait lu : « We studied 96 real-world dependent tests from 5 issue tracking systems. » ; « such as masking program faults and leading to spurious bug reports. » ; « found dependent tests in each human-written and automatically-generated test suite. » (Zhang et al.) ; « If you want files and tests to run randomly, you can enable it with this option, or CLI argument » (Vitest, `sequence.shuffle`, défaut `false` ; `sequence.seed` par défaut `Date.now()`)
- Portée / limites : 96 cas réels, détection sur 4 programmes. Le PDF complet n'a pas pu être téléchargé. L'équivalent pytest n'a pas été vérifié.
- En stratégie : la règle « jamais de dépendance d'ordre » est fondée. Une exécution en ordre aléatoire en CI, avec la graine journalisée, la rend vérifiable plutôt que déclarative.

---

## 5. Test après déploiement

### Placer des sondes (smoke en production) en lecture seule sur tout système en ligne, en sachant que ce qu'elles attrapent touche déjà les utilisateurs
- Niveau de preuve : N3
- Source : Graves, 2020, *Software Engineering at Google*, chap. 14, section « Probers and Canary Analysis », https://abseil.io/resources/swe-book/html/ch14.html
- Extrait lu : « Probers are functional tests that run encoded assertions against the production environment. Usually these tests perform well-known and deterministic read-only actions » ; « Probers should be used in any live system. » ; « Any issues caught at this point in time (in production) are already affecting end users. »
- Portée / limites : le texte signale qu'une sonde qui écrit peut provoquer « user-visible side effects ».
- En stratégie : après déploiement Vercel, lancer une sonde en lecture seule (page d'accueil, connexion d'un compte de test, une lecture de données). Les écritures se limitent à un compte dédié, ou on s'en abstient.

### Distinguer smoke, test de configuration et canary, et lancer le smoke avant promotion pour bloquer le déploiement (« zéro MTTR »)
- Niveau de preuve : N3
- Source : Perry & Luebbe, 2016, *Site Reliability Engineering*, chap. 17, https://sre.google/sre-book/testing-reliability/
- Extrait lu : « Smoke tests, in which engineers test very simple but critical behavior, are among the simplest type of system tests. » ; « A canary test isn’t really a test; rather, it’s structured user acceptance. » ; « a separate configuration test examines production to see how a particular binary is actually configured and reports discrepancies against that file. » ; « Zero MTTR occurs when a system-level test is applied to a subsystem, and that test detects the exact same problem that monitoring would detect. Such a test enables the push to be blocked so the bug never reaches production »
- Portée / limites : contexte Google, avec déploiement progressif sur des serveurs. Pour un développeur seul sur Vercel, le canary se rapproche d'un déploiement de prévisualisation ou d'une montée progressive, si la plateforme l'offre (non vérifié ici).
- En stratégie : le smoke attrape ce que la CI ne voit pas, comme une variable d'environnement manquante, une migration non appliquée ou un secret expiré. Le lancer sur l'URL de prévisualisation avant promotion vaut mieux que le lancer après. Un test de configuration compare l'état réel à l'état versionné.

### Ne faire échouer un smoke de performance Lighthouse que sur un agrégat de plusieurs exécutions, sur une machine stable
- Niveau de preuve : N3 (documentation officielle de l'outil)
- Source : GoogleChrome/lighthouse, « Score Variability » (docs/variability.md), https://raw.githubusercontent.com/GoogleChrome/lighthouse/main/docs/variability.md
- Extrait lu : « Lighthouse performance scores will change due to inherent variability in web and network technologies, even if there hasn't been a code change. » ; « When creating your thresholds for failure, either mental or programmatic, use aggregate values like the median, 90th percentile, or even min/max instead of single test results. » ; « The median Lighthouse score of 5 runs is twice as stable as 1 run. » ; « Free CI environments and “burstable” instances are typically quite volatile. »
- Portée / limites : document de l'éditeur de l'outil, daté seulement par la branche principale du dépôt.
- En stratégie : un seuil Lighthouse calculé sur une seule exécution en CI gratuite produit des échecs instables. Exiger la médiane d'au moins 5 exécutions (`lhci collect -n 5`), ou garder la mesure comme indicatif non bloquant.

---

## 6. Non-régression

### Après toute modification, distinguer le test de confirmation (le défaut est corrigé) du test de régression (rien d'autre n'a cassé), et borner la régression par une analyse d'impact
- Niveau de preuve : N1 (référentiel ISTQB)
- Source : ISTQB, 2024, CTFL v4.0.1, §2.2.3, https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf
- Extrait lu : « Changes are typically made to a component or system to either enhance it by adding a new feature or to fix it by removing a defect. Testing should then also include confirmation testing and regression testing. » ; « It is advisable first to perform an impact analysis to recognize the extent of the regression testing. »
- Portée / limites : le texte est prescriptif. Il recommande l'automatisation de la régression en CI.
- En stratégie : pour chaque modification, la matrice indique le test de confirmation, le périmètre d'impact (modules appelants, politiques RLS touchées) et la suite de régression à relancer.

### Ajouter le cas manquant à chaque correction de bug, au niveau le plus bas qui le reproduit ; mettre à jour les tests existants seulement quand le comportement change volontairement
- Niveau de preuve : N3
- Source : Erik Kuefler, 2020, *Software Engineering at Google*, chap. 12 « Unit Testing », https://abseil.io/resources/swe-book/html/ch12.html ; Perry & Luebbe, 2016, *Site Reliability Engineering*, chap. 17, https://sre.google/sre-book/testing-reliability/
- Extrait lu : « the presence of the bug suggests that a case was missing from the initial test suite, and the bug fix should include that missing test case. » ; « The engineer must write new tests to cover the new behaviors, but they shouldn’t need to change any existing tests. » ; « Changing a system’s existing behavior is the one case when we expect to have to make updates to the system’s existing tests. » (Kuefler) ; « Regression tests can be analogized to a gallery of rogue bugs that historically caused the system to fail or produce incorrect results. » (SRE)
- Portée / limites : pratiques Google, sans mesure. Le livre SRE place ces tests « at the system or integration level » ; Vocke (2018) demande d'écrire un test plus bas quand un test haut niveau trouve une erreur. Les deux se concilient : le niveau le plus bas qui reproduit le bug.
- En stratégie : « feature existante modifiée » recouvre trois cas. Une correction de bug appelle un nouveau test qui reproduit le bug, nommé d'après l'incident. Un ajout appelle de nouveaux tests sans retoucher les anciens. Un changement voulu de comportement appelle la mise à jour des tests concernés. Un test existant qu'il faut modifier pour un simple refactoring signale un test trop lié à l'implémentation.

### Connaître les trois leviers de la régression (minimisation, sélection, priorisation) et le cas de base, qui est de tout relancer
- Niveau de preuve : N2 (préprint de l'article de synthèse)
- Source : Shin Yoo & Mark Harman, « Regression Testing Minimisation, Selection and Prioritisation: A Survey », publié dans *STVR* 22(2), 2012, DOI 10.1002/stvr.430 ; préprint lu (mention « 2007 ») : https://www.cse.chalmers.se/~feldt/advice/yoo_2010_regression_testing_survey.pdf
- Extrait lu : « Naturally, the most straightforward approach to this problem is to simply execute all the existing test cases in the test suite; this is called a retest-all approach. However, as software evolves, the test suite tends to grow, which means it may be prohibitively expensive to execute the entire test suite. » ; « Existing empirical studies show that the application of these techniques can be cost-effective. »
- Portée / limites : le texte lu est un préprint qui peut différer de la version publiée en 2012.
- En stratégie : sur un petit projet dont la suite complète tourne en quelques minutes, tout relancer à chaque PR reste le bon choix par défaut. La sélection ne devient utile que si la suite ralentit la boucle de retour.

### Si la suite devient lente, sélectionner avant fusion et prioriser après, avec des techniques bon marché qui se passent de couverture
- Niveau de preuve : N2
- Source : Sebastian Elbaum, Gregg Rothermel, John Penix, 2014, « Techniques for Improving Regression Testing in Continuous Integration Development Environments », FSE 2014, PDF lu : https://cs.uwaterloo.ca/~m2nagapp/courses/CS846/1171/papers/elbaum_fse14.pdf
- Extrait lu : « In an initial presubmit phase of testing, developers specify modules to be tested, and we use regression test selection techniques to select a subset of the test suites for those modules [...] In a subsequent post-submit phase of testing, where dependent modules as well as changed modules are tested, we use test case prioritization techniques to ensure that failures are reported more quickly. » ; « relatively inexpensive and do not rely on code coverage information »
- Portée / limites : jeu de données Google. L'échelle est sans commune mesure avec un projet individuel.
- En stratégie : la transposition est légère. Lancer en local les tests liés aux fichiers modifiés, puis la suite complète en CI sur la PR.

### Ne pas confondre les deux mécanismes de sélection disponibles : Vitest (graphe de modules) et Playwright (fichiers de test modifiés)
- Niveau de preuve : N3 (documentation des outils)
- Source : Vitest, « Command Line Interface », https://vitest.dev/guide/cli ; Playwright, « Command line », https://playwright.dev/docs/test-cli
- Extrait lu : Vitest `--changed` : « Run tests that are affected by the changed files (default: `false`) » ; Playwright `--only-changed` : « Only run test files that have been changed between 'HEAD' and 'ref'. »
- Portée / limites : `--only-changed` de Playwright, tel que décrit, sélectionne les fichiers de test modifiés et non les tests touchés par une modification du code applicatif. La page Vitest ne détaille pas le calcul de « affected » ; une option voisine évoque le « static module graph ».
- En stratégie : ces options servent la boucle locale. Elles ne remplacent pas la suite complète en CI, surtout côté E2E, où une modification du code applicatif ne déclenche aucun test via `--only-changed`.

---

## Verdict sur les règles de l'agent

| Règle | Verdict | Motif sourcé |
|---|---|---|
| « Pyramide cible : ~70 % unit, ~20 % integration, ~10 % e2e. » | **Convention sans preuve trouvée** | Le 70/20/10 est un « good first guess » assorti de « The exact mix will be different for each team » (Google, 2015). Google publie ailleurs 80/15/5 comme « very rough guideline » (SWE book, chap. 11). La seule répartition mesurée trouvée (GitLab 2025 : 75,7 / 19,8 / 4,3 / 0,24) n'est pas une prescription. Aucune étude empirique ne justifie un ratio. Fowler (2012) et Vocke (2018) ne donnent aucun chiffre. À reformuler : « forme pyramidale en ordre de grandeur (beaucoup d'unitaires, des intégrations sur les frontières réelles, une poignée d'E2E sur les parcours critiques), ajustée au contexte ; pour une couche surtout SQL/RLS, l'intégration peut dominer (nid d'abeille, Spotify 2018) ». |
| « Pondération par le risque : budget par impact × probabilité ; auth, paiement, perte de données, RLS = couverture maximale ; cosmétique = un smoke suffit. » | **Soutenue** (principe) / **à préciser** (cosmétique) | Probabilité × impact et matrice qualitative : ISTQB v4.0.1 §5.2. Approche par le risque : 29119-2:2013 (résumé IEEE). « Life-critical or revenue-critical systems demand substantially higher levels of test quality and coverage » (SRE, chap. 17). La probabilité peut s'estimer par l'historique et le churn relatif (Ostrand et al. 2004 ; Nagappan & Ball 2005 ; Memon et al. 2017). Aucune source ne prescrit « un smoke suffit » pour le cosmétique : c'est une déduction, et aucun gain chiffré du test basé sur les risques n'a été vérifié. |
| « Jamais de stratégie e2e-only » / « 100 % unit, 0 e2e → on rate les bugs d'intégration. » | **Soutenue (N3), à préciser** | E2E-only = « ice cream cone », anti-forme nommée (SWE book, chap. 11). Les grands tests sont nettement plus instables : 14 % contre 0,5 % (Listfield 2017). L'unitaire seul ne voit ni doublures infidèles, ni configuration, ni charge (SWE book, chap. 14). Nuance : par mutation, l'unitaire et l'intégration ne détectent pas de types de défauts différents (Trautsch et al. 2020, résumé lu). L'argument fort pour l'intégration est donc la fidélité à l'environnement (vrai Postgres, RLS, configuration), pas un type de bug « d'intégration » propre au code. |
| « Smoke perf en CI (Lighthouse) et smoke fonctionnel en prod post-deploy. » | **Smoke prod : soutenue. Lighthouse CI : à préciser** | Sondes en lecture seule recommandées « in any live system » (SWE book, chap. 14). Smoke et test de configuration décrits dans le livre SRE. Lighthouse : « use aggregate values like the median » ; « The median Lighthouse score of 5 runs is twice as stable as 1 run » ; « Free CI environments [...] are typically quite volatile » (doc Lighthouse). Un seuil bloquant sur une seule exécution est donc fragile. Ajouter : faire passer le smoke fonctionnel sur la prévisualisation avant promotion (« zero MTTR », SRE). |
| « Toujours un test de non-régression quand une feature existante est modifiée. » | **À préciser** | ISTQB §2.2.3 : après tout changement, test de confirmation et test de régression, bornés par une analyse d'impact (relancer la suite pertinente, pas forcément écrire un test). Google (chap. 12) : correction de bug → ajouter le cas manquant (obligatoire) ; ajout → nouveaux tests, anciens inchangés ; changement voulu → mettre à jour les tests existants. Reformuler : « toute correction de bug ajoute un test qui reproduit le bug ; toute modification relance la suite de régression du périmètre d'impact et met à jour les tests du comportement changé ». |
| « Jamais de test qui dépend de l'ordre d'exécution. » | **Soutenue** | Tests hermétiques, sans hypothèse sur l'ordre ni base partagée (SWE book, chap. 11). La dépendance d'ordre masque des fautes, et chaque suite étudiée en contenait (Zhang et al. 2014, 96 cas réels, résumé lu). Rendre la règle vérifiable avec `sequence.shuffle` de Vitest (désactivé par défaut). |
| « docs/TESTING.md, 1 page max. » | **Convention sans preuve trouvée** | Aucune source sur la longueur. Le contenu, lui, est sourcé : « a strategic outline of what types of testing are needed and how much of each [...] identifies the primary risk vectors » (SWE book, chap. 14). Ajouter une ligne de définitions des niveaux, puisque les termes varient d'une équipe à l'autre (Fowler 2021). La limite d'une page reste une préférence éditoriale, défendable mais non prouvée. |

## Mythes et affirmations contestées

- **« Le 70/20/10 est la règle de Google, établie par l'expérience. »** Le billet de 2015 le présente comme « a good first guess », et le livre de Google publie 80/15/5 comme « very rough guideline ». Aucune donnée n'accompagne ces chiffres.
- **« Mike Cohn a inventé la pyramide. »** Fowler écrit que Cohn l'a dessinée avec Lisa Crispin en 2003-2004, l'a publiée en 2009 sous le nom « Test Automation Pyramid », et que Jason Huggins a eu la même idée vers 2006.
- **« Le nid d'abeille (Spotify) ou le trophée réfutent la pyramide. »** Selon Fowler (2021), le débat est « moot » : il porte sur la définition de « unit test » (isolé ou « sociable »). Le nid d'abeille de Spotify est formulé pour des microservices.
- **« Les tests d'intégration trouvent d'autres bugs que les unitaires. »** Aucune différence de type de défaut n'apparaît par mutation sur 38 782 tests Java (Trautsch et al. 2020, résumé lu). Leur valeur vient de la fidélité (environnement réel), pas d'un type de défaut propre.
- **« 20 % des fichiers contiennent 80 % des bugs. »** Ostrand et al. (2004) trouvent 71 à 92 % des fautes dans 20 % des fichiers classés par un modèle, sur un système industriel, et écrivent « there is nothing magical about the 20% figure ». C'est une tendance, pas une constante. L'ISTQB formule le principe sans chiffre.
- **« Paradoxe du pesticide. »** Le syllabus CTFL v4.0.1 ne contient plus ce terme. Le principe s'appelle « Tests wear out » et précise que la répétition reste utile en régression automatisée.
- **« Un défaut coûte 10 ou 100 fois plus cher à corriger s'il est trouvé tard. »** Le syllabus ISTQB maintient « Early testing saves time and money » (Boehm 1981), mais Menzies, Nichols, Shull & Layman (EMSE 22(4), 2017, https://arxiv.org/abs/1609.04886, résumé lu) écrivent sur 171 projets : « We found no evidence for the delayed issue effect. » Le principe du test précoce reste raisonnable, le multiplicateur est contesté.
- **« Un canary est un test. »** Pour le livre SRE de Google, « A canary test isn’t really a test; rather, it’s structured user acceptance ».
- **« Un score Lighthouse en CI est une mesure fiable. »** La documentation de l'outil dit le contraire pour une exécution unique, et recommande médiane ou percentile sur plusieurs exécutions, sur du matériel dédié.

## Non vérifié

- **Livre de Mike Cohn, *Succeeding with Agile* (2009)** : non ouvert. Le contenu n'est connu que par Fowler (2012), l'ISTQB (§5.1.6) et une note du chap. 11 du livre de Google.
- **Texte normatif ISO/IEC/IEEE 29119-1/-2** : payant, non lu. La page iso.org a répondu 403. Seul le résumé IEEE de l'édition 2013 de la partie 2 a été lu. Aucune exigence précise de la norme n'est citée.
- **Felderer & Ramler 2014, « A multiple case study on risk-based testing in industry »** (STTT 16, DOI 10.1007/s10009-014-0328-z) et **Felderer & Ramler 2015/2016, PME** (Software Quality Journal, DOI 10.1007/s11219-015-9289-z) : seules les métadonnées ont été lues (Semantic Scholar, résumé masqué par l'éditeur ; Springer redirige vers une authentification). Les bénéfices évoqués dans les extraits de recherche ne sont pas repris.
- **Ostrand, Weyuker & Bell, IEEE TSE 2005** : seule la version ISSTA 2004 a été lue. Les chiffres de la version TSE n'ont pas été vérifiés dans le texte.
- **Trautsch, Herbold & Grabowski 2020** : texte intégral non lu. Le nombre de projets n'est pas confirmé.
- **Capers Jones** : aucun chiffre d'efficacité pour l'« integration testing » dans la table lue. La méthode de collecte n'est pas publiée.
- **Perry & Evangelist (1985, 1987), part des fautes d'interface (« 68 % » cité de seconde main)** : PDF de l'auteur inaccessible (échec TLS puis 503).
- **Gunawi et al. 2016, « Why Does the Cloud Stop Computing? »** (causes des pannes : configuration, mises à jour) : PDF inaccessible (échec TLS puis 503).
- **Leotta, Clerissi, Ricca, Tonella, coût de maintenance des suites E2E web** : aucun texte lu.
- **Étude empirique sur la durée et le coût des tests E2E en CI pour des projets web** : aucune trouvée ni lue.
- **Google Testing Blog 2020, « Fixing a Test Hourglass »** : 503 à chaque tentative.
- **Rothermel et al. 2001, priorisation (IEEE TSE)** : non ouvert. Seule la synthèse de Yoo & Harman (préprint) et Elbaum et al. 2014 ont été lus.
- **Équivalent pytest du mélange d'ordre** (pytest-randomly ou autre) : non vérifié.
- **Canary ou montée progressive sur Vercel** : non vérifié dans cette recherche.

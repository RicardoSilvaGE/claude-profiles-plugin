# Fiche `ux-preuves` — Tests — efficacité d'une suite et sa mesure

> Fiche du skill `ux-preuves` (dev-fullstack), volet **tests**, préchargé par `qa`. Couvre : couverture et efficacité au-delà d'Inozemtseva, mutants et vrais défauts, outils de mutation (Stryker, mutmut), oracles et assertions, méthodes pseudo-testées, snapshots, mocks, test smells, pièges de configuration de la couverture.
> **Instantané de la recherche documentaire du 10.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Études (souvent des prépublications pour les LLM), docs d'outils
> et pratiques d'entreprise **vieillissent** : avant d'en faire dépendre une règle,
> relire la source (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles de l'agent », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

**Méthode.** Recherche menée le 10.11.2026. Chaque entrée repose sur une page ou un PDF réellement ouvert. Les PDF ont été téléchargés (curl) dans `pdf2/` puis lus avec `pdftotext` : les extraits marqués *(PDF lu)* sont recopiés depuis ce texte. Les pages lues par WebFetch passent par un modèle de résumé qui limite les citations à de courts extraits : ces extraits sont marqués *(via WebFetch)* et sont un cran moins sûrs à la lettre près. Quand seul le résumé d'un article a pu être ouvert (accès refusé, défi anti-robot, 503), l'entrée porte « résumé seul lu ». Plusieurs dépôts ont refusé l'accès (TU Delft, Springer, HAL, core.ac.uk, SMU, IEEE Xplore) ; aucune protection n'a été contournée. Le niveau de preuve suit la grille demandée (N1 norme ; N2 recherche revue par pairs ou étude empirique à large échantillon ; N3 guide officiel d'une organisation sur sa propre pratique ou doc d'outil ; N4 avis d'expert). Sujets exclus car déjà couverts ailleurs : Inozemtseva & Holmes 2014, Petrović et al. 2021, Ravi & Coblenz 2025, Spadini et al. 2018, Kim et al. 2021, Hora & Fraser 2026.

---

## 1. Couverture de code et efficacité

### Ne pas lire un % de couverture comme une probabilité de trouver des bugs en production
- Niveau de preuve : N2 (100 grands projets Java open source)
- Source : Kochhar, Lo, Lawall, Nagappan, 2017, « Code Coverage and Post-release Defects: A Large-Scale Study on Open Source Projects », IEEE Trans. on Reliability 66(4), https://www.microsoft.com/en-us/research/publication/code-coverage-and-post-release-defects-a-large-scale-study-on-open-source-projects/ — résumé seul lu
- Extrait lu : « coverage has an insignificant correlation with the number of bugs » *(via WebFetch)*
- Portée / limites : Java, projets open source, couverture des tests livrés avec le projet, bugs post-release tirés des issue trackers ; corrélation insignifiante au niveau projet et nulle au niveau fichier (selon le résumé). Le texte intégral n'a pas pu être ouvert (dépôt SMU protégé par un défi anti-robot).
- En stratégie : face à un rapport « 85 % donc on est bons », demander quels risques métier ne sont **pas** couverts par une assertion qui échouerait. Le % n'est pas un argument de qualité.

### Même en industrie, une couverture élevée n'a pas produit de logiciel moins défectueux
- Niveau de preuve : N2 (étude de cas industrielle, un grand produit Ericsson ; présentation ICSE SEIP 2019 d'un article IEEE Software 2018)
- Source : Antinyan, Staron, 2019 (talk ICSE SEIP ; article IEEE Software 35(3) 2018 cosigné par Derehag et Sandberg selon la notice bibliographique, non ouvert), « Mythical Unit Test Coverage », https://2019.icse-conferences.org/details/icse-2019-Software-Engineering-in-Practice/19/-SEIP-Talk-Mythical-Unit-Test-Coverage — résumé seul lu
- Extrait lu : « the current unit test coverage measures do not seem to be any tangible help in producing defect-free software » *(via WebFetch)*
- Portée / limites : un seul produit, une seule entreprise, défauts trouvés après les tests unitaires. Texte intégral non lu : on ne connaît ni la taille d'échantillon ni la méthode statistique.
- En stratégie : ne pas promettre au client « 80 % de couverture » comme livrable de qualité ; promettre des scénarios de risque testés.

### Pour évaluer UNE suite (et non comparer plusieurs), la couverture d'instructions est le moins mauvais prédicteur structurel
- Niveau de preuve : N2 (1 254 projets Maven retenus, dont 729 avec suites de tests ; suites manuelles et générées)
- Source : Gopinath, Jensen, Groce, 2014, « Code Coverage for Suite Evaluation by Developers », ICSE 2014, https://rahul.gopinath.org/resources/icse2014/gopinath2014code.pdf
- Extrait lu : « statement (not block, branch, or path) coverage predicts mutation kills best » *(PDF lu)*
- Portée / limites : Java uniquement ; l'« efficacité » est mesurée par des mutants, pas par des bugs réels ; le résultat porte sur la prédiction du score de mutation, pas sur la détection de défauts réels. Ne dit pas qu'une couverture d'instructions élevée suffit.
- En stratégie : inutile d'exiger la couverture de branches *comme indicateur de qualité d'une suite* ; l'activer (`--cov-branch`, `coverage.provider`) sert en revanche à **localiser** des chemins non exercés.

### La couverture ne commence à « payer » qu'au-delà d'un seuil élevé, et la mutation forte révèle le plus de défauts réels
- Niveau de preuve : N2 (fautes réelles, 145 000 lignes de C sur quatre systèmes)
- Source : Chekam, Papadakis, Le Traon, Harman, 2017, « An Empirical Study on Mutation, Statement and Branch Coverage Fault Revelation that Avoids the Unreliable Clean Program Assumption », ICSE 2017, https://discovery.ucl.ac.uk/10058915/7/Chekam_ICSE17.pdf
- Extrait lu : « below this threshold level, the coverage achieved by a test suite is simply irrelevant to its fault-revealing potential » ; « strong mutation testing has the highest fault revelation of four widely-used criteria » *(PDF lu)*
- Portée / limites : programmes C, pool de tests augmenté (KLEE + manuel) ; le seuil est relatif (meilleurs 5-20 % des niveaux de couverture atteignables), pas un chiffre universel transposable à un projet web. Les auteurs montrent aussi que l'hypothèse du « programme propre » des études précédentes ne tient pas toujours.
- En stratégie : une couverture basse est un signal fiable de trou ; une couverture haute n'est qu'une condition nécessaire. Pour juger la force des tests d'un module critique, passer à la mutation.

### Chez Google, la couverture est calculée à chaque changement et montrée en revue, pas imposée globalement
- Niveau de preuve : N2 (enquête : 512 réponses sur 3 000 développeurs ; données d'adoption sur cinq ans)
- Source : Ivanković, Petrović, Just, Fraser, 2019, « Code Coverage at Google », ESEC/FSE 2019, https://homes.cs.washington.edu/~rjust/publ/google_coverage_fse_2019.pdf
- Extrait lu : « Google does not enforce any code coverage thresholds across the entire codebase. Projects (or groups of projects) are free to define their own thresholds and goals. » ; « When authoring a changelist, 45% of respondents reported that they use coverage “Often” or “Very Often” » *(PDF lu)*
- Portée / limites : très grande entreprise, infrastructure maison ; les paliers volontaires (60/70, 75/80, 90/90 % projet/changelist) sont un choix d'équipe. Les systèmes critiques y recourent à la mutation. La perception d'utilité est déclarative.
- En stratégie : le geste utile pour un indépendant est la **couverture du diff en revue** (quelles lignes neuves ne sont pas exercées ?), pas un chiffre global.

### Ce qui n'est pas couvert compte plus que ce qui l'est ; pas de nombre idéal universel
- Niveau de preuve : N3 (guide d'une entreprise sur sa propre pratique)
- Source : Bender, Arguelles, Ivanković, 2020, « Code Coverage Best Practices », Google Testing Blog, https://testing.googleblog.com/2020/08/code-coverage-best-practices.html
- Extrait lu : « A high code coverage percentage does not guarantee high quality in the test coverage. Focusing on getting the number as close as possible to 100% leads to a false sense of security. » ; « What’s not covered is more meaningful than what is covered. » ; « There is no “ideal code coverage number” that universally applies to all products. »
- Portée / limites : doctrine d'entreprise, pas une étude. Donne quand même des repères (« 60% as “acceptable”, 75% as “commendable” and 90% as “exemplary” ») et juge raisonnable un objectif par commit (« per-commit coverage goals of 99% are reasonable, and 90% is a good lower threshold »).
- En stratégie : relire les **lignes non couvertes** avec le critère du billet (impact métier, fréquence de modification, durée de vie), plutôt que discuter du pourcentage.

### Une cible de couverture se transforme en case à cocher : surveiller l'effet Goodhart
- Niveau de preuve : N3 pour l'usage en logiciel (Google) ; la formule générale est N4 dans ce contexte (texte d'anthropologie de l'audit universitaire, transposé)
- Source : Bender, Arguelles, Ivanković, 2020, « Code Coverage Best Practices », https://testing.googleblog.com/2020/08/code-coverage-best-practices.html ; Strathern, 1997, « Improving ratings: audit in the British University system », European Review 5(3), https://www.gwern.net/doc/statistics/decision/1997-strathern.pdf
- Extrait lu : Google : « Be mindful that engineers may start treating your target like a checkbox » ; « pressure to 'hit the metric' almost never yields the desired outcome ». Strathern *(PDF lu)* : « When a measure becomes a target, it ceases to be a good measure. […] Hoskin describes this as 'Goodhart's law' »
- Portée / limites : la phrase célèbre est de Strathern, pas de Goodhart (elle reprend Hoskin) ; elle porte sur les examens universitaires. Aucune étude logicielle mesurant cet effet sur la couverture n'a été trouvée.
- En stratégie : si une porte CI de couverture existe, chercher les tests sans assertion, les tests « copiés pour monter le chiffre » et les exclusions de fichiers ajoutées pour passer la porte.

### Un `vitest run --coverage` sans `coverage.include` cache les fichiers que personne n'importe
- Niveau de preuve : N3 (doc officielle de l'outil)
- Source : Vitest, « Coverage » (guide), https://vitest.dev/guide/coverage
- Extrait lu : « By default Vitest will show only files that were imported during test run. » ; « To include uncovered files in the report, you'll need to configure » `coverage.include` *(via WebFetch)*
- Portée / limites : comportement de la version documentée au 10.11.2026 ; fournisseur par défaut `v8`, `istanbul` en option. La page lue ne détaille pas `coverage.thresholds`.
- En stratégie : en audit (mode C), vérifier `coverage.include` **avant** de lire le rapport ; sinon un module jamais testé n'apparaît même pas à 0 %.

### Côté Python, n'interpréter `pytest --cov` qu'avec la source déclarée et les branches activées
- Niveau de preuve : N3 (docs officielles coverage.py et pytest-cov)
- Source : coverage.py, « Specifying source files », https://coverage.readthedocs.io/en/latest/source.html ; pytest-cov, « Configuration », https://pytest-cov.readthedocs.io/en/latest/config.html
- Extrait lu : « Specifying the source option also enables coverage.py to report on un-executed files » ; `--cov-branch` : « Enable branch coverage. » ; `--cov-fail-under` : « Fail if the total coverage is less than MIN. » *(via WebFetch)*
- Portée / limites : la page coverage.py ne dit pas explicitement ce qui arrive aux fichiers jamais importés sans `source`. `--cov-fail-under` est une porte globale, avec les limites des entrées précédentes.
- En stratégie : lancer `pytest --cov=<paquet> --cov-branch --cov-report=term-missing` ; la colonne des lignes manquantes est l'entrée de l'analyse de risque.

### La couverture vaut indicateur pour des tests unitaires, beaucoup moins pour des tests système
- Niveau de preuve : N2 (14 projets Java open source ; atelier CSED 2016)
- Source : Niedermayr, Juergens, Wagner, 2016, « Will My Tests Tell Me If I Break This Code? », CSED 2016, https://arxiv.org/pdf/1611.07163
- Extrait lu : « The mean ratio was 11.41% for unit tests and 35.48% for system tests. » ; « the coverage metric is only a valid effectiveness indicator for unit tests » *(PDF lu)*
- Portée / limites : Java ; « pseudo-testée » = méthode couverte dont la suppression du corps ne fait échouer aucun test. Écart-type élevé pour les tests système (20,60 %).
- En stratégie : la couverture apportée par Playwright ou des tests d'intégration est en bonne partie **incidente** ; ne pas l'additionner à la couverture unitaire comme si elle prouvait des vérifications.

---

## 2. Mutants, vrais défauts et outils de mutation

### Les mutants sont un substitut valable mais incomplet des vrais défauts
- Niveau de preuve : N2 (357 fautes réelles, 5 programmes Java, 321 000 lignes, 230 000 mutants)
- Source : Just, Jalali, Inozemtseva, Ernst, Holmes, Fraser, 2014, « Are Mutants a Valid Substitute for Real Faults in Software Testing? », FSE 2014, https://cs.ubc.ca/~rtholmes/papers/fse_2014_just.pdf
- Extrait lu : « The results show the existence of a coupling effect for 73% of real faults. » ; « 10% of real faults require a new or stronger mutation operator […] 17% of real faults are not coupled to mutants » ; corrélation « stronger than the correlation between statement coverage and real fault detection » *(PDF lu)*
- Portée / limites : Java, Defects4J ; un mutant tué n'implique pas qu'un défaut réel voisin le soit. Environ un défaut réel sur six échappe par nature à la mutation.
- En stratégie : un bon score de mutation ne remplace pas les tests de scénarios métier : 17 % des défauts réels n'ont aucun mutant couplé.

### Les mutations de conditions, d'opérateurs relationnels et la suppression d'instruction sont les plus liées aux vrais défauts
- Niveau de preuve : N2 (même étude)
- Source : Just et al., 2014, https://cs.ubc.ca/~rtholmes/papers/fse_2014_just.pdf
- Extrait lu : « the conditional operator replacement, relational operator replacement, and statement deletion mutants are more often coupled to real faults than other mutants » ; « The mutation score of Tfail increased for 153 out of 258 pairs (59%) for which statement coverage did not increase. » *(PDF lu)*
- Portée / limites : opérateurs de l'outil Major (Java) ; les opérateurs de Stryker ou de mutmut ne sont pas identiques.
- En stratégie : en lisant un rapport Stryker/mutmut, traiter d'abord les survivants sur conditions, comparaisons (`<` → `<=`) et blocs supprimés ; ils révèlent des tests qui ne vérifient pas les bornes.

### Un score de mutation guide l'amélioration ; il ne mesure pas la détection réelle
- Niveau de preuve : N2 (CoreBench en C, Defects4J en Java)
- Source : Papadakis, Shin, Yoo, Bae, 2018, « Are Mutation Scores Correlated with Real Fault Detection? A Large Scale Empirical Study on the Relationship Between Mutants and Real Faults », ICSE 2018, https://typeset.io/pdf/are-mutation-scores-correlated-with-real-fault-detection-a-t9e7f0t5d6.pdf
- Extrait lu : « all correlations between mutation scores and real fault detection are weak when controlling for test suite size » ; « our data suggest that mutants provide good guidance for improving the fault detection of test suites, but their correlation with fault detection are weak » *(PDF lu)*
- Portée / limites : nuance Just et al. 2014 en contrôlant la taille de la suite ; ne dit pas que la mutation est inutile, au contraire.
- En stratégie : utiliser les **mutants survivants** comme liste de tests à écrire ; ne pas fixer « 80 % de score de mutation » comme objectif de qualité.

### Mutants équivalents et redondants gonflent le score et le rendent difficile à interpréter
- Niveau de preuve : N2 (revue de littérature, Advances in Computers vol. 112)
- Source : Papadakis, Kintis, Zhang, Jia, Le Traon, Harman, 2019, « Mutation Testing Advances: An Analysis and Survey », https://discovery.ucl.ac.uk/id/eprint/10056704/1/survey.pdf
- Extrait lu : « the metric is inflated and becomes hard to interpret » ; « Detecting equivalent mutants is a well-known undecidable problem » ; la compilation triviale (TCE) peut identifier « at least 30% of all the equivalent mutants » *(PDF lu)*
- Portée / limites : synthèse de recherche, chiffres issus surtout de C et de Java ; rien sur TypeScript ou Python.
- En stratégie : avant d'exiger d'un développeur qu'il « tue » un survivant, vérifier qu'il ne s'agit pas d'un mutant équivalent ; prévoir un mécanisme d'exclusion documenté.

### Lire un rapport Stryker : distinguer « Survived » de « No coverage », et les deux scores
- Niveau de preuve : N3 (doc de l'outil)
- Source : Stryker Mutator, « Mutant states and metrics », https://stryker-mutator.io/docs/mutation-testing-elements/mutant-states-and-metrics/
- Extrait lu : Survived : « When all tests passed while this mutant was active, the mutant survived. » ; No coverage : « The mutant isn't covered by one of your tests and survived as a result. » ; scores : « detected / valid * 100 » et, sur le code couvert, « detected / covered * 100 » *(via WebFetch)*
- Portée / limites : la page ne prévoit pas d'état « Equivalent » ; seul « Ignored » existe.
- En stratégie : un « Survived » signale un **oracle faible** (code exécuté, rien vérifié) ; un « No coverage » signale un **trou de couverture**. Ce ne sont pas les mêmes correctifs.

### StrykerJS : `--incremental` et des plages de lignes, pas de `--since` (c'est Stryker.NET)
- Niveau de preuve : N3 (docs de l'outil)
- Source : StrykerJS, « Incremental », https://stryker-mutator.io/docs/stryker-js/incremental/ ; StrykerJS, « Configuration », https://stryker-mutator.io/docs/stryker-js/configuration/ ; Stryker.NET, « Configuration », https://stryker-mutator.io/docs/stryker-net/configuration/
- Extrait lu : StrykerJS : « StrykerJS will track the changes you make to your code and tests and only runs mutation testing on the changed code. » ; limite : « Stryker will not detect any changes you've made in files other than mutated files and test files. » ; `mutate` : « "src/app.js:1-11" will mutate lines 1 through 11 inside app.js » ; `thresholds.break` : « Stryker will exit with exit code 1 ». Stryker.NET : « Use git information to test only code changes since the given target. » *(via WebFetch)*
- Portée / limites : la page de configuration StrykerJS téléchargée ne contient aucune option `since` (recherche textuelle). Le mode incrémental ignore les mises à jour de dépendances : relancer avec `--force` après une mise à jour.
- En stratégie : pour un indépendant, `npx stryker run --incremental` restreint aux modules à risque (`mutate`) rend la mutation abordable en continu.

### mutmut : reprise incrémentale, mutation des seules fonctions appelées, filtrage par vérificateur de types
- Niveau de preuve : N3 (doc de l'outil)
- Source : mutmut, documentation, https://mutmut.readthedocs.io/en/latest/
- Extrait lu : « Remembers work that has been done, so you can work incrementally » ; « By default, mutmut will mutate only functions that are called. » ; « Between runs, mutmut only re-tests mutants in functions whose source changed. » ; filtrage des mutants invalides via mypy ou pyrefly ; `# pragma: no mutate` *(via WebFetch)*
- Portée / limites : la page ne prétend pas muter seulement le diff git ; numéro de version non affiché sur la page lue.
- En stratégie : en Python, `mutmut run` puis `mutmut browse` sur le cœur métier ; documenter chaque `pragma: no mutate` (sinon c'est une porte dérobée au même titre qu'une exclusion de couverture).

---

## 3. Oracles et assertions

### Compter et vérifier les assertions : c'est elles qui portent l'efficacité, pas la couverture
- Niveau de preuve : N2 (6 700 suites composées, 24 000 assertions, 5 projets Java)
- Source : Zhang, Mesbah, 2015, « Assertions Are Strongly Correlated with Test Suite Effectiveness », ESEC/FSE 2015, https://people.ece.ubc.ca/amesbah/resources/papers/fse15.pdf
- Extrait lu : « the number of assertions in a test suite strongly correlates with its effectiveness » ; « the correlation between statement coverage and effectiveness decreases dramatically when assertion coverage is controlled for » *(PDF lu)*
- Portée / limites : efficacité mesurée par score de mutation, pas par défauts réels ; Java ; corrélation, pas causalité. Le nombre brut d'assertions peut lui aussi être gonflé.
- En stratégie : en audit, repérer les tests sans assertion ou à assertion triviale (`toBeDefined`, `toBeTruthy` sur un objet toujours présent) dans les zones couvertes.

### Des méthodes couvertes dont on peut vider le corps sans qu'aucun test n'échoue existent dans tous les projets
- Niveau de preuve : N2 (21 projets Java, plus de 28 000 méthodes ; 101 méthodes analysées à la main avec des développeurs)
- Source : Vera-Pérez, Danglot, Monperrus, Baudry, 2019 (EMSE ; préprint 2018), « A Comprehensive Study of Pseudo-tested Methods », https://arxiv.org/pdf/1807.05030
- Extrait lu : « We discover pseudo-tested methods in all our study objects, even for those with high coverage. » ; « The PS RATE varies from 1% to 46%. » ; « less than 30% of these methods are clearly worth the additional testing effort » *(PDF lu)*
- Portée / limites : outil Descartes (PIT, Java) ; aucun équivalent JS/Python de même nom n'a été vérifié ici. Les développeurs ne jugent pas toutes ces méthodes dignes d'effort.
- En stratégie : l'exercice « casser le code, quel test échoue ? » s'automatise par mutation extrême (corps vidé) ; trier ensuite les méthodes pseudo-testées par risque, sans viser zéro.

### Le vrai goulot de l'automatisation des tests est l'oracle, et l'humain en reste la source finale
- Niveau de preuve : N2 (revue de littérature, IEEE TSE 41(5))
- Source : Barr, Harman, McMinn, Shahbaz, Yoo, 2015, « The Oracle Problem in Software Testing: A Survey », https://web.eecs.umich.edu/~weimerw/2018-481/readings/testoracles.pdf
- Extrait lu : « Without test oracle automation, the human has to determine whether observed behaviour is correct. » ; « the final source of test oracle information remains the human » *(PDF lu)*
- Portée / limites : revue conceptuelle ; elle classe les oracles (spécifications, contrats, tests métamorphiques, oracles implicites) mais ne chiffre pas leur efficacité.
- En stratégie : pour chaque test, demander d'où vient la valeur attendue (spec, calcul indépendant, propriété) ; une valeur attendue recopiée de la sortie actuelle du code n'est pas un oracle.

### Les assertions dans le code de production vont avec moins de défauts (densité d'assertions, Microsoft)
- Niveau de preuve : N2, faible (étude de cas sur deux composants commerciaux)
- Source : Kudrjavets, Nagappan, Ball, 2006, « Assessing the Relationship between Software Assertions and Code Quality: An Empirical Investigation », MSR-TR-2006-54 (publié à ISSRE 2006 sous le titre « …and Faults… »), https://www.microsoft.com/en-us/research/publication/assessing-the-relationship-between-software-assertions-and-code-qualityan-empirical-investigation/ — résumé seul lu
- Extrait lu : « there is a statistically significant decrease in fault density » *(via WebFetch)*
- Portée / limites : porte sur les **assertions du code de production** (programmation défensive), pas sur les assertions des tests. Deux composants, une entreprise, 2006.
- En stratégie : ne pas citer cette étude pour justifier « plus d'`expect` par test » ; elle soutient plutôt des invariants vérifiés à l'exécution (validations aux frontières, `assert` sur les préconditions).

---

## 4. Tests par instantané (snapshots)

### Un snapshot se relit en revue comme du code ; le régénérer sans regarder est l'anti-pattern nommé par Jest
- Niveau de preuve : N3 (doc officielle)
- Source : Jest, « Snapshot Testing », https://jestjs.io/docs/snapshot-testing
- Extrait lu : « Commit snapshots and review them as part of your regular code review process. » ; « fight against the habit of regenerating snapshots when test suites fail instead of examining the root causes of their failure » ; « we would need to fix the bug before re-generating snapshots to avoid recording snapshots of the buggy behavior » *(via WebFetch)*
- Portée / limites : recommandation d'éditeur, non mesurée. La doc dit aussi que les snapshots ne remplacent pas les tests unitaires : « The aim of snapshot testing is not to replace existing unit tests ».
- En stratégie : en audit, chercher dans l'historique les commits qui ne font que régénérer des `.snap` à côté d'un changement de code, sans justification.

### En CI, Vitest refuse d'écrire les snapshots : une divergence fait échouer le lot
- Niveau de preuve : N3 (doc officielle)
- Source : Vitest, « Snapshot », https://vitest.dev/guide/snapshot
- Extrait lu : « By default, Vitest does not write snapshots in CI (`process.env.CI` is truthy) and any snapshot mismatches, missing snapshots, and obsolete snapshots fail the run. » ; « The snapshot artifact should be committed alongside code changes, and reviewed as part of your code review process. » *(via WebFetch)*
- Portée / limites : la page ne dit pas explicitement « ne mettre à jour que les changements voulus » ; elle dit seulement « When the snapshot change is expected ». `toMatchInlineSnapshot` rend la valeur visible dans le test.
- En stratégie : vérifier que la CI tourne bien avec `CI=true` (sinon un snapshot manquant peut être écrit au lieu d'échouer) ; préférer les snapshots inline ou petits pour qu'ils restent relisibles.

### Les mises à jour de snapshots sont fréquentes dans les projets réels
- Niveau de preuve : N2, préliminaire (papier court ; échantillon non vérifié sur le texte)
- Source : Fujita, Kashiwa, Lin, Iida, 2023, « An Empirical Study on the Use of Snapshot Testing », ICSME 2023, https://sdlab.naist.jp/en/post/fujita-icsme2023/ — résumé seul lu
- Extrait lu : « A non-negligible number of commits (8.2%) update the snapshot files » *(via WebFetch)*
- Portée / limites : étude préliminaire ; la page lue ne donne pas le nombre de dépôts (ce chiffre vient d'un autre billet du laboratoire, non ouvert). Mesure la fréquence, pas l'effet sur la détection de défauts. Pagination incohérente selon les sources (335-440 sur la page du laboratoire).
- En stratégie : un snapshot qui change dans un commit sur douze sert de tampon, pas d'oracle ; demander qui relit ces diffs.

### Fragilité et manque de contexte : la critique la plus citée des snapshots
- Niveau de preuve : N2 (mémoire de master UFMG 2024 dont une partie est publiée dans le Journal of Systems and Software, 2023 ; 50 documents de littérature grise, 569 projets, 380 tests échantillonnés)
- Source : Cruz, 2024, « Understanding Snapshot Testing in Practice » (dir. Valente), https://homepages.dcc.ufmg.br/~mtov/diss/2024-victor.pdf
- Extrait lu : « drawbacks such as fragility and lack of context can lead to false positives, making it challenging for developers to interpret test failures » ; « best practices like treating snapshot results as part of the application’s codebase and writing small, focused snapshots are recommended » *(PDF lu)*
- Portée / limites : les inconvénients et bonnes pratiques viennent de la littérature grise (N4 par nature) ; l'étude empirique caractérise les tests, elle ne mesure pas leur capacité de détection.
- En stratégie : remplacer un snapshot de composant entier par des snapshots ciblés ou des assertions explicites sur ce qui compte (texte, état, attribut ARIA).

---

## 5. Mocks et doublures

### On mocke surtout l'infrastructure (BD, services web), rarement les objets métier ; le mock qui diverge du réel est le problème n°1
- Niveau de preuve : N2 (plus de 2 000 usages de mocks analysés à la main dans trois projets OSS et un système industriel ; enquête auprès de plus de 100 professionnels)
- Source : Spadini, Aniche, Bruntink, Bacchelli, 2019, « Mock objects for testing java systems: Why and how developers use them, and how they evolve », Empirical Software Engineering 24, https://scispace.com/pdf/mock-objects-for-testing-java-systems-why-and-how-developers-5dtzl4g5y3.pdf
- Extrait lu : « Developers report to frequently mock dependencies that make testing difficult (e.g., infrastructure-related dependencies) and to not mock classes that encapsulate domain concepts/rules of the system » ; « maintaining the behavior of the mock compatible with the behavior of original class is hard and that mocking increases the coupling between the test and the production code » *(PDF lu)*
- Portée / limites : Java/Mockito. Extension de l'article MSR 2017 « To Mock or Not To Mock? » (non ouvert, dépôt TU Delft inaccessible). Les participants disent aussi que l'excès de mocks « may hide important design problems ».
- En stratégie : en audit, lister les mocks de modules **métier internes** (règles de calcul, validation) ; ce sont les candidats prioritaires à remplacer par l'implémentation réelle.

### Quand l'objet du test est l'intégration elle-même, on ne mocke pas
- Niveau de preuve : N2 (même étude ; entretien et enquête N = 105)
- Source : Spadini et al., 2019, https://scispace.com/pdf/mock-objects-for-testing-java-systems-why-and-how-developers-5dtzl4g5y3.pdf
- Extrait lu : « if we mock [the integration], then we wouldn’t know if it actually works. [...] I do not mock when I want to test the database itself; I want to make sure that my SQL works. » *(PDF lu)*
- Portée / limites : verbatim d'un développeur, confirmé selon les auteurs par l'enquête ; pas de mesure de défauts manqués à cause de mocks.
- En stratégie : chaque dépendance mockée en unitaire doit avoir **un** test qui l'exerce pour de vrai (requête SQL sur une base réelle ou conteneurisée, appel HTTP sur un serveur de test).

### Préférer le réalisme à l'isolation ; une implémentation réelle rapide et déterministe bat un mock
- Niveau de preuve : N3 (pratique interne de Google, livre « Software Engineering at Google », chap. 13)
- Source : Trenk, Bly (éd. Manshreck), 2020, « Test Doubles », https://abseil.io/resources/swe-book/html/ch13.html
- Extrait lu : « We prefer realistic tests because they give more confidence that the system under test is working properly. » ; « A real implementation is preferred if it is fast, deterministic, and has simple dependencies. » ; « Interaction testing should be avoided when possible. » ; « A fake must have its own tests to ensure that it conforms to the API of its corresponding real implementation. » *(via WebFetch)*
- Portée / limites : pratique d'une très grande organisation, non mesurée ; c'est une doctrine argumentée.
- En stratégie : critère opérationnel de « ce qui devrait être testé pour vrai » : rapide, déterministe, dépendances simples → réel. Sinon un fake **testé contre le réel**, puis un mock en dernier recours.

### Contrats entre consommateur et fournisseur : vérifier que les doublures répondent comme le vrai service
- Niveau de preuve : N3 (doc officielle d'un outil)
- Source : Pact, « Introduction », https://docs.pact.io/
- Extrait lu : contract testing = « a technique for testing an integration point by checking each application in isolation » ; but : vérifier « that all the calls to your test doubles return the same results as a call to the real application would » ; « The contract is generated during the execution of the automated consumer tests. » *(via WebFetch)*
- Portée / limites : discours d'éditeur sur son propre outil ; la page lue ne décrit pas en détail la vérification côté fournisseur ni les cas où Pact ne convient pas. Pour un développeur seul qui tient front et back dans le même dépôt, un schéma partagé (types générés, validation à l'exécution) peut couvrir la forme des messages, pas leur sémantique.
- En stratégie : repérer le motif « mock du fetch côté front + mock de la BD côté back » sans aucun test qui fasse traverser une vraie requête ; exiger soit un contrat vérifié des deux côtés, soit un test d'intégration réel par route critique.

---

## 6. Tests de mauvaise qualité (test smells)

### Les test smells sont répandus et nuisent à la compréhension, ce qui n'est pas prouvé ici pour la détection
- Niveau de preuve : N2 (18 systèmes dont 2 industriels ; expérience contrôlée avec 20 étudiants de master)
- Source : Bavota, Qusef, Oliveto, De Lucia, Binkley, 2012, « An Empirical Analysis of the Distribution of Unit Test Smells and Their Impact on Software Maintenance », ICSM 2012, https://people.lu.usi.ch/bavotg/papers/icsm2012.pdf
- Extrait lu : « test smells are widely spread throughout the software systems studied and (ii) most of the test smells have a strong negative impact on the comprehensibility of test suites and production code » *(PDF lu)*
- Portée / limites : mesure la compréhensibilité, pas la capacité de détection de défauts. L'extension EMSE 2015 (« Are test smells really harmful? ») n'a pas été ouverte.
- En stratégie : justifier une correction de smell par le coût de maintenance, pas par « ce test laissera passer des bugs », sauf s'il est aussi pseudo-testant ou sans assertion.

### Les développeurs ne reconnaissent généralement pas les test smells, qui naissent dès le premier commit du test
- Niveau de preuve : N2 (ASE 2016 ; enquête et fouille de dépôts)
- Source : Tufano, Palomba, Bavota, Di Penta, Oliveto, De Lucia, Poshyvanyk, 2016, « An Empirical Investigation into the Nature of Test Smells », ASE 2016, https://www.microsoft.com/en-us/research/?p=771931 — résumé seul lu
- Extrait lu : « developers generally do not recognize (potentially harmful) test smells » ; « usually introduced when the corresponding test code is committed » ; « tend to remain in a system for a long time » *(via WebFetch)*
- Portée / limites : résumé seul ; taille de l'échantillon non vérifiée sur le texte.
- En stratégie : la revue au moment où un fichier de test est créé est le meilleur moment pour corriger ; après, le smell reste.

### Les détecteurs de test smells se trompent souvent, et le vocabulaire des smells colle mal aux vrais soucis
- Niveau de preuve : N2 (EMSE 2022 ; jeu annoté à la main couvrant des centaines de suites)
- Source : Panichella, Panichella, Fraser, Sawant, Hellendoorn, 2022, « Test smells 20 years later: detectability, validity, and reliability », Empirical Software Engineering 27, https://digitalcollection.zhaw.ch/handle/11475/25672 — résumé seul lu
- Extrait lu : « the current vocabulary of test smells is highly mismatched to real concerns » ; « developers perceive warnings raised by detection tools as overly strict » *(via WebFetch)* ; le résumé indique qu'un ancien outil a mal classé plus de 70 % des smells (chiffre en reformulation, non cité mot pour mot)
- Portée / limites : Java ; tests écrits à la main et générés (EvoSuite, JTExpert). Texte intégral inaccessible (TU Delft, Springer).
- En stratégie : ne pas brancher un détecteur de smells en porte CI ; s'en servir comme pistes à relire, et juger chaque cas sur « ce test échouerait-il si le code cassait ? ».

---

## Verdict sur les règles de l'agent

| Règle | Verdict | Motif sourcé |
|---|---|---|
| « Un test doit pouvoir échouer (esprit mutation testing) ; en cas de doute, casser mentalement le code — quel test échoue ? Aucun → trou de couverture réel, peu importe le % affiché. » | **Soutenue**, à préciser | Méthodes pseudo-testées présentes dans tous les projets, même à forte couverture (Vera-Pérez et al. 2019 ; Niedermayr et al. 2016) ; mutants couplés à 73 % des fautes réelles (Just et al. 2014) ; Google recommande la mutation pour juger les assertions (blog 2020). **Précisions** : (1) « trou de couverture » est le mauvais mot, c'est un trou d'**oracle** (Stryker distingue « Survived » de « No coverage ») ; (2) le geste « casser mentalement » s'outille (Stryker `--incremental` / `mutate`, mutmut) ; (3) un survivant peut être un mutant équivalent (Papadakis et al. 2019) ; (4) moins de 30 % des méthodes pseudo-testées valent l'effort selon les développeurs (Vera-Pérez et al.) : trier par risque. |
| « La couverture repère les zones non testées ; aucune cible chiffrée opposée comme preuve de qualité. 100 % sans assertions utiles est pire qu'inutile. » | **Soutenue** (deux premières phrases) ; **à préciser** (troisième) | Corrélation insignifiante avec les bugs post-release (Kochhar et al. 2017) ; aucun bénéfice tangible chez Ericsson (Antinyan, Staron) ; « What’s not covered is more meaningful than what is covered » (Google 2020) ; pas de seuil imposé chez Google (Ivanković et al. 2019). « Pire qu'inutile » : seul appui trouvé, Google parle de « false sense of security » et de dette de tests de faible valeur ; aucune étude ne le mesure. Nuance : Google juge **légitime une porte sur le code neuf** (90 % plancher par commit), et Chekam et al. montrent qu'une couverture haute est une condition nécessaire. |
| « Mode C : lancer la couverture (`vitest run --coverage`, `pytest --cov`), croiser les trous avec le risque. » | **Soutenue**, à préciser sur l'outillage | Le croisement avec le risque est la pratique recommandée par Google (impact métier, fréquence de changement, durée de vie). **Précisions outil** : Vitest n'affiche par défaut que les fichiers importés (configurer `coverage.include`) ; coverage.py ne signale les fichiers jamais exécutés qu'avec `source` (`--cov=<paquet>`) ; activer `--cov-branch` et `term-missing`. La couverture issue de Playwright est largement incidente (Niedermayr et al. ; Google 2020). |
| « Snapshots qui matchent tout sans regarder ce qui change » (anti-pattern) | **Soutenue** (N3 + N2 descriptif) | Jest : « fight against the habit of regenerating snapshots » ; Vitest : snapshots commités et relus ; 8,2 % des commits mettent à jour des snapshots (Fujita et al. 2023, préliminaire) ; fragilité et faux positifs (Cruz 2024). **Aucune étude trouvée** ne mesure la perte de détection due à des snapshots régénérés à l'aveugle. |
| « Jamais de mock sur ce qui devrait être testé pour vrai. » | **Soutenue**, à préciser | Les développeurs ne mockent pas l'intégration qu'ils veulent vérifier ni, en général, les objets métier (Spadini et al. 2019) ; « prefer realistic tests » (SWE at Google). **Précision** : la règle est circulaire sans critère ; utiliser celui de Google : réel s'il est rapide, déterministe, à dépendances simples ; sinon fake testé contre le réel. Mocker la BD ou les services web en unitaire est la pratique majoritaire et acceptable **si** un test réel existe ailleurs. |
| « Contrats front↔back : schéma partagé ou intégration réelle, pas deux mocks qui se font face. » | **Soutenue** pour l'interdit ; **convention sans preuve trouvée** pour « schéma partagé suffit » | La divergence mock/réel est la difficulté n°1 citée par les développeurs (Spadini et al. 2019) ; le contract testing vise exactement à garantir que les doublures répondent comme le réel (Pact, N3). Aucune étude empirique trouvée comparant schéma partagé, tests de contrat et intégration réelle ; un schéma partagé vérifie la forme, pas le comportement. |

---

## Mythes et affirmations contestées

- **« Plus de couverture = moins de bugs. »** Contesté : corrélation insignifiante avec les bugs post-release (Kochhar et al. 2017, résumé), aucun bénéfice tangible observé chez Ericsson (Antinyan, Staron). Chekam et al. 2017 nuancent : en dessous d'un seuil élevé la couverture est « simply irrelevant », au-dessus le lien devient fort.
- **« La couverture de branches est toujours meilleure que celle d'instructions. »** Contesté pour l'évaluation d'une suite isolée : l'instruction prédit le mieux le score de mutation (Gopinath et al. 2014). Mais ni l'une ni l'autre n'est fortement liée à la révélation de fautes réelles (Chekam et al. 2017).
- **« Le score de mutation mesure la capacité à trouver de vrais bugs. »** À nuancer : corrélation significative selon Just et al. 2014, mais faible une fois la taille de la suite contrôlée (Papadakis et al. 2018) ; 17 % des fautes réelles ne sont couplées à aucun mutant ; score gonflé par les mutants équivalents et redondants (Papadakis et al. 2019). Bon guide, mauvais KPI.
- **« Google impose 80 % de couverture. »** Faux selon la source primaire : pas de seuil imposé à l'échelle du code (Ivanković et al. 2019) ; paliers volontaires 60/75/90 (« acceptable / commendable / exemplary »).
- **« "When a measure becomes a target…" est une citation de Goodhart. »** Faux : la formulation est de Marilyn Strathern (1997), qui l'attribue au sens de Hoskin à la « loi de Goodhart » ; elle porte sur l'audit universitaire.
- **« Les test smells font rater des bugs. »** Non démontré par les études lues : Bavota et al. 2012 mesurent la compréhensibilité ; les détecteurs eux-mêmes sont peu fiables (Panichella et al. 2022, résumé). Le lien smells ↔ défauts du code de production (Spadini et al. 2018) est couvert ailleurs.
- **« StrykerJS a une option `--since`. »** Non trouvé : `since` est documenté pour Stryker.NET ; StrykerJS propose `--incremental` et des plages de lignes dans `mutate`.
- **« Les assertions réduisent les défauts » (Kudrjavets et al. 2006) appliqué aux tests.** Mauvaise transposition : l'étude porte sur les assertions du code de production.

---

## Non vérifié

- **Hemmati 2015, « How Effective Are Code Coverage Criteria? » (QRS)** : seul un extrait de moteur de recherche a été vu (instruction à 10 % de fautes détectées, fautes non détectées surtout liées à la spécification). Les pages IEEE Xplore et le miroir du catalogue ont renvoyé des 503 : aucun chiffre repris.
- **Kochhar, Thung, Lo 2015 (SANER)**, « Code coverage and test suite effectiveness: Empirical study with real bugs in large systems » : PDF core.ac.uk derrière un défi anti-robot, non lu. Selon un moteur de recherche, corrélation modérée à forte sur HTTPClient et Rhino : non vérifié.
- **Kochhar et al. 2017** : texte intégral non lu (résumé Microsoft Research seulement).
- **Antinyan et al., IEEE Software 2018** : texte intégral non lu ; seul le résumé de la présentation ICSE SEIP 2019 a été ouvert.
- **Spadini et al. MSR 2017 « To Mock or Not To Mock? »** : non ouvert (TU Delft inaccessible) ; seule l'extension EMSE 2019 a été lue.
- **Bavota et al. 2015 (EMSE)** : non ouvert ; chiffres « 86 % des tests JUnit » et « compréhension 30 % meilleure » vus uniquement dans un moteur de recherche.
- **Panichella et al. 2022** et **Tufano et al. 2016** : résumés seuls ; noms des outils comparés et tailles d'échantillon non vérifiés.
- **Fujita et al. 2023** : résumé seul ; « environ 1 500 dépôts » vient d'un billet secondaire non ouvert ; étude japonaise de suivi sur la capacité de détection des snapshots (SIGSE 2024) non lue.
- **Mocks qui masquent des défauts d'intégration** : aucune étude empirique chiffrant des défauts manqués à cause de mocks n'a été trouvée ni lue ; l'appui reste déclaratif (Spadini et al.) et doctrinal (Google, Pact).
- **Kudrjavets et al. ISSRE 2006** : article de conférence non lu ; seul le rapport technique MSR-TR-2006-54 (titre légèrement différent) a été vu en résumé.
- **Petrović et al. 2018** (mutation chez Google, ICSE SEIP) : non recherché, proche du sujet déjà couvert ailleurs.
- **Seuils `coverage.thresholds` de Vitest** (`perFile`, `autoUpdate`) : absents de la page lue, non vérifiés.

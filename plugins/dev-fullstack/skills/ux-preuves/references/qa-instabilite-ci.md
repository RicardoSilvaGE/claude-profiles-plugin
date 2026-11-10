# Fiche `ux-preuves` — Tests — tests instables et intégration continue

> Fiche du skill `ux-preuves` (dev-fullstack), volet **tests**, préchargé par `qa`. Couvre : synthèses sur les tests instables, relancer pour classer contre relancer pour prouver, dépendance à l'ordre, quarantaine et délais publiés, coût de la CI et sélection de tests, isolation, temps et aléa contrôlés.
> **Instantané de la recherche documentaire du 10.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Études (souvent des prépublications pour les LLM), docs d'outils
> et pratiques d'entreprise **vieillissent** : avant d'en faire dépendre une règle,
> relire la source (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles de l'agent », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

**Méthode.** Recherche faite le 10.11.2026 pour le référentiel d'un agent « QA engineer senior » (Vitest, Playwright, pytest, GitHub Actions avec un quota de minutes limité). Chaque entrée repose sur une page réellement ouverte. Les articles ont été téléchargés en PDF (arXiv, pages d'auteurs, dépôts institutionnels NSF PAR, White Rose, Microsoft Research), puis lus en texte intégral avec `pdftotext`. Les docs officielles (playwright.dev, vitest.dev, docs.pytest.org, pypi.org, docs.github.com, Django, SQLAlchemy) et les blogs d'ingénierie (GitHub, Spotify, Atlassian, Slack, manuel GitLab) ont été lus avec WebFetch, ou avec curl suivi d'une extraction du texte. Quand un chiffre vient d'une étude que je n'ai pas lue moi-même et qu'il est rapporté par la revue de Parry et al. (2021), l'entrée le dit (« source secondaire, via Parry »). Ce qui est déjà couvert ailleurs n'est pas refait : Micco 2016, Luo et al. 2014, l'auto-attente de Playwright, Kim et al. 2021. Niveaux de preuve : N1 norme ; N2 recherche revue par pairs ou étude empirique à large échantillon ; N3 guide officiel d'une organisation sur sa propre pratique ; N4 avis d'expert ou étude d'éditeur. Aucun chiffre n'est donné de mémoire.

---

## 1. Synthèses : définition, ampleur, coût

### Définir un test instable comme un test dont le verdict change alors que ni le code testé ni le test n'ont changé, et le traiter comme une menace sur la validité de tout signal de CI
- Niveau de preuve : N2 (revue systématique de 76 articles)
- Source : Parry, Kapfhammer, Hilton, McMinn, 2021 (en ligne en octobre 2021 ; ACM TOSEM vol. 31 n° 1, art. 17, 2022), « A Survey of Flaky Tests », https://o-parry.github.io/papers/2021a.pdf (PDF de l'auteur, lu en entier)
- Extrait lu : « Tests that fail inconsistently, without changes to the code under test, are described as flaky. » / « A recent survey of software developers found that 59% claimed to deal with flaky tests on a monthly, weekly, or daily basis. »
- Portée / limites : la revue s'arrête aux articles disponibles en 2021. La littérature qu'elle couvre porte surtout sur Java et sur de grands projets ou des entreprises. Elle ne fixe aucune politique de quarantaine.
- En stratégie : la stratégie a-t-elle une définition opérationnelle du test instable (même commit, verdicts différents) et un moyen de la constater, plutôt qu'un ressenti ?

### Partir du principe que l'instabilité est fréquente et coûteuse pour les développeurs, quelle que soit la taille de l'équipe
- Niveau de preuve : N2 (21 développeurs Mozilla ont classé 200 tests instables qu'ils avaient corrigés ; enquête auprès de 121 développeurs)
- Source : Eck, Palomba, Castelluccio, Bacchelli, 2019, « Understanding Flaky Tests: The Developer's Perspective » (ESEC/FSE '19), https://arxiv.org/pdf/1907.01466
- Extrait lu : « Most surveyed developers (79%) consider flaky tests a moderate to serious problem, regardless of their team’s size and project’s domain; and 40% deal with flaky tests at least weekly. »
- Portée / limites : perception déclarée et non mesure. Le corpus de tests vient d'une seule organisation (Mozilla), en 2019.
- En stratégie : le coût de l'instabilité (temps de diagnostic, confiance perdue) est-il compté dans le budget de la stratégie, ou seulement le coût d'écriture des tests ?

### Chercher l'instabilité au-delà du test et du code : infrastructure, interactions entre composants, facteurs externes, et la prévenir d'abord par une infrastructure stable et des règles d'écriture vérifiées en revue
- Niveau de preuve : N2 (étude qualitative de 14 entretiens et d'une revue de 38 articles de littérature grise ; petit échantillon)
- Source : Habchi, Haben, Papadakis, Cordy, Le Traon, 2022, « A Qualitative Study on the Sources, Impacts, and Mitigation Strategies of Flaky Tests » (ICST 2022), https://arxiv.org/pdf/2112.04919
- Extrait lu : « besides the tests and code, flakiness stems from interactions between the system components, the testing infrastructure, and external factors. » Dans le tableau II : « Setup a reliable infrastructure with processes properly adapted to the testing activity » (9 entretiens sur 14) et « Define guidelines that should be respected when writing tests and enforced through reviews » (9 sur 14).
- Portée / limites : étude qualitative. Les fréquences décrivent l'échantillon interrogé et ne se généralisent pas.
- En stratégie : la stratégie distingue-t-elle les échecs dus à l'infrastructure (runner, réseau, service tiers) de ceux dus au test ? Les règles anti-instabilité sont-elles relues en revue de code ?

### Prévoir qu'une part non négligeable des échecs de CI ne signale aucun défaut : environ 13 % sont instables, et même parmi les échecs reproductibles, un quart vient de tests faux ou obsolètes
- Niveau de preuve : N2 (61 projets Java sur Travis CI ; 935 builds en échec réexécutés)
- Source : Labuschagne, Inozemtseva, Holmes, 2017, « Measuring the Cost of Regression Testing in Practice: A Study of Java Projects using Continuous Integration » (ESEC/FSE '17), https://www.cs.ubc.ca/~rtholmes/papers/fse_2017_labuschange.pdf
- Extrait lu : « We found that 18% of test suite executions fail and that 13% of these failures are flaky. Of the non-flaky failures, only 74% were caused by a bug in the system under test; the remaining 26% were due to incorrect or obsolete tests. »
- Portée / limites : Java, open source, 2017. Un build n'était classé instable qu'après trois réexécutions, donc le chiffre est probablement sous-estimé. Deux autres résultats vont dans le même sens, mais je ne les connais que par la revue de Parry (source secondaire) : chez Pivotal, les développeurs estiment avoir autant d'échecs instables que d'échecs réels (« developers at Pivotal experienced similar numbers of both genuine and flaky failures ») ; et sur plus de 75 millions de builds Travis, « 47% of previously failing builds that were restarted subsequently passed » (Durieux et al.).
- En stratégie : quand la CI est rouge, le développeur peut-il savoir vite s'il s'agit d'un défaut, d'un test faux ou d'une instabilité ?

### Garder en tête qu'un échec de test qui révèle un vrai changement est rare : la valeur de la CI tient dans ce petit pourcentage, que l'instabilité noie
- Niveau de preuve : N2 (étude sur le système de CI de Google, plus de 5 millions de cibles de test ; ICSE-SEIP, les auteurs étant à Google)
- Source : Memon, Gao, Nguyen, Dhanda, Nickell, Siemborski, Micco, 2017, « Taming Google-Scale Continuous Testing » (ICSE-SEIP '17), https://web.eecs.umich.edu/~xwangsd/courses/w23/readings/googletest.pdf (copie de cours ; fiche officielle : https://research.google/pubs/pub45861/)
- Extrait lu : « of all test executions we examined, only a tiny fraction (1.23%) actually found a test breakage (or a code fix) being introduced by a developer. » / « more than 99% of all tests run by the CI system pass or flake » / « we could not rely on regression test selection heuristics such as “rerun tests that failed recently” [14] [15] as we would end up mostly re-running flaky tests »
- Portée / limites : échelle de Google, très loin d'un projet solo. L'enseignement transposable : une heuristique de sélection fondée sur « ce qui a échoué récemment » se fait piéger par les tests instables.
- En stratégie : si la sélection de tests s'appuie sur l'historique des échecs (`--lf`, `--last-failed`), les tests instables y ont-ils été retirés ou marqués ?

---

## 2. Causes à viser en priorité

### Ne pas supposer qu'un test instable est toujours un défaut du test : une minorité réelle des correctifs touche le code de production, surtout pour la concurrence
- Niveau de preuve : N2 (trois études convergentes)
- Source : Lam, Muşlu, Sajnani, Thummalapenta, 2020, « A Study on the Lifecycle of Flaky Tests » (ICSE '20, 6 projets Microsoft), https://www.microsoft.com/en-us/research/wp-content/uploads/2020/07/LamETAL20FaTB.pdf ; Eck et al. 2019 (ci-dessus, tableau 1) ; Parry et al. 2021 (§ 6.2.1)
- Extrait lu : Lam : « about 12% (1% + 11%) of fixes involve changes to source code. Overall, our results show that ignoring flaky tests can be dangerous since they do indicate faults in both source and test code. » Eck : « Nature: Concurrency Cases: 61 | Avg. Fixing Effort: 4.0 | Origin: 66% Test Code ». Parry : « figures range from between 71% and 88% exclusively test code »
- Portée / limites : la majorité des correctifs (71 à 88 %) ne touche que le test. Pour la concurrence chez Mozilla, un tiers des cas viendrait du code de production (100 − 66 %). Le « souvent » d'une race condition réelle dans le produit n'est donc pas établi en général ; il l'est sur une minorité notable.
- En stratégie : avant de réparer le test, la fiche de quarantaine demande-t-elle de vérifier si l'instabilité touche du code concurrent ou asynchrone de production ?

### En Python, chercher d'abord la dépendance à l'ordre et l'infrastructure de test, puis le réseau et l'aléa
- Niveau de preuve : N2 (22 352 projets PyPI, 876 186 tests, 7 571 tests instables)
- Source : Gruber, Lukasczyk, Kroiß, Fraser, 2021, « An Empirical Study of Flaky Tests in Python » (ICST 2021), https://arxiv.org/pdf/2101.09077
- Extrait lu : « Order dependency is a much more dominant problem in Python, causing 59 % of the 7 571 flaky tests in our dataset. Another 28 % were caused by test infrastructure problems [...] The remaining 13 % can mostly be attributed to the use of network and randomness APIs »
- Portée / limites : bibliothèques open source et non applications web. Les tests y ont été exécutés hors de leur CI d'origine, ce qui peut gonfler la part « infrastructure ».
- En stratégie : la suite pytest est-elle exécutée dans un ordre aléatoire au moins périodiquement ? Les appels réseau et le hasard sont-ils maîtrisés (mocks, graine fixée) ?

### En JavaScript, chercher d'abord la concurrence (attente asynchrone, courses, verrous mortels), puis les différences d'OS et le réseau
- Niveau de preuve : N2 (452 commits de correction dans de grands projets JavaScript sur GitHub)
- Source : Hashemi, Tahir, Rasheed, 2022, « An Empirical Study of Flaky Tests in JavaScript » (ICSME 2022), https://arxiv.org/pdf/2207.01047
- Extrait lu : « flakiness caused by concurrency-related issues (e.g., async wait, race conditions or deadlocks) is the most dominant reason for test flakiness. The other top causes of flaky tests are operating system-specific [...] and network stability »
- Portée / limites : le corpus ne contient que des commits de correction, donc il ignore les tests jamais réparés. Il couvre des projets open source.
- En stratégie : les tests Vitest qui touchent des promesses ou des timers attendent-ils un état précis plutôt qu'un délai fixe ?

### Pour les tests d'interface web, viser l'attente asynchrone en premier : c'est près de la moitié des cas
- Niveau de preuve : N2 (235 tests d'interface instables, 62 projets web et Android)
- Source : Romano, Song, Grandhi, Yang, Wang, 2021, « An Empirical Analysis of UI-based Flaky Tests » (ICSE 2021), https://arxiv.org/pdf/2103.02669
- Extrait lu : « Of the observed flaky tests collected, 105 tests of the 235 (45.1%) dataset are caused by an Async Wait issue. » / « Async Wait issues are more prevalent in web projects rather than mobile projects (W 52.0 % vs M 32.5%). »
- Portée / limites : outils de 2021 (Selenium et équivalents). L'auto-attente de Playwright vise précisément cette cause (couvert ailleurs).
- En stratégie : y a-t-il encore des `waitForTimeout` ou des pauses fixes dans les tests E2E ?

### Limiter les tests de bout en bout au strict nécessaire, car ils sont la catégorie la plus instable, et rendre visible la fiabilité de chaque test
- Niveau de preuve : N3 (Spotify, sur sa propre pratique)
- Source : Palmer (Spotify Engineering), 18.11.2019, « Test Flakiness – Methods for identifying and dealing with flaky tests », https://engineering.atspotify.com/2019/11/test-flakiness-methods-for-identifying-and-dealing-with-flaky-tests/
- Extrait lu : « end to end tests are flaky by nature » / « Instead of having 500 end to end tests for your organization, have 5. » / « By making this table available and doing nothing else this reduced test flakiness at Spotify from 6% to 4% in two months. »
- Portée / limites : retour d'expérience d'une seule entreprise, sans groupe témoin. Les chiffres 500/5 sont rhétoriques.
- En stratégie : la pyramide prévue limite-t-elle les E2E Playwright aux parcours critiques ? Existe-t-il un tableau, même minimal, du taux d'instabilité par test ?

---

## 3. Relancer ou non

### Utiliser une relance bornée (1 à 3) comme outil de classement d'un échec, et pas comme moyen de détecter l'instabilité ni de faire passer la CI
- Niveau de preuve : N2 (même corpus Python : 22 352 projets)
- Source : Gruber et al., 2021 (ci-dessus), https://arxiv.org/pdf/2101.09077
- Extrait lu : « To check if a failure occurred due to flakiness, for the majority of NOD flaky tests, only 1 rerun is needed to achieve a statistical confidence of 95 %. For OD flakiness, 3 reruns are needed to achieve the same confidence. » / « A 95 % confidence that a passing test case is not flaky on average would require 170 reruns. »
- Portée / limites : modèle probabiliste qui suppose les exécutions indépendantes. Les auteurs excluent l'instabilité d'infrastructure, « which often manifests itself in failure bulks ». Deux chiffres que je ne connais que par Parry (source secondaire) : Lam et al. jugent qu'« no more than five repeats should be necessary to manifest the vast majority of flaky tests » ; et « at Google, failing tests may be repeated up to ten times [...] Whereas Microsoft's Flakes system repeats failing tests only once by default ».
- En stratégie : la relance est-elle bornée et sert-elle à étiqueter l'échec (instable ou réel) pour déclencher un traitement, et pas à rendre la CI verte ?

### Ne pas croire qu'une poignée de relances suffit à prouver qu'un test est stable
- Niveau de preuve : N2 (24 projets Java, chaque suite exécutée 10 000 fois, 811 tests instables)
- Source : Alshammari, Morris, Hilton, Bell, 2021, « FlakeFlagger: Predicting Flakiness Without Rerunning Tests » (ICSE 2021), https://par.nsf.gov/servlets/purl/10273428
- Extrait lu : « Overall, only roughly a quarter of all of the flaky tests that we found in 10,000 runs would have been found with 10 reruns, roughly half with 100 reruns and roughly two thirds with 1,000 reruns. »
- Portée / limites : il s'agit de détecter l'instabilité dans une suite qui passe, pas de classer un échec observé. Ce coût de détection est hors de portée d'un quota de minutes limité.
- En stratégie : la stratégie évite-t-elle de promettre une suite « sans instabilité » qu'aucun budget de relances ne peut démontrer ?

### Si l'on relance, faire varier l'environnement (nouveau processus, autre machine, horloge décalée) plutôt que répéter à l'identique
- Niveau de preuve : N3 (GitHub, sur sa propre pratique) et N2 en source secondaire (Bell et al., via Parry)
- Source : Raine (GitHub), 16.12.2020, mis à jour le 20.12.2021, « Reducing flaky builds by 18x », https://github.blog/engineering/infrastructure/reducing-flaky-builds-by-18x/ ; Parry et al. 2021, § 5.1
- Extrait lu : GitHub relance trois fois : dans le même processus ; dans le même processus avec l'heure avancée par des helpers de test ; sur un autre hôte (paraphrase de la page). Parry, à propos de Bell et al. : « Of these flaky tests, 23% were manifested by re-execution within the same process, a further 60% required repeats within their own JVM instances »
- Portée / limites : d'après la page, ce dispositif attrape environ 90 % des échecs instables. Les chiffres de Bell portent sur Java et la JVM.
- En stratégie : une relance de Playwright se fait dans un worker neuf (voir l'entrée suivante) ; pour pytest, la relance se fait-elle dans un processus propre ou dans le même état pollué ?

### Avec Playwright, n'activer les relances que si les tests « flaky » restent visibles et font échouer la CI quand c'est voulu
- Niveau de preuve : N3 (documentation officielle de l'outil)
- Source : Microsoft/Playwright, consulté le 10.11.2026, « Retries », https://playwright.dev/docs/test-retries ; « TestConfig », https://playwright.dev/docs/api/class-testconfig ; « Configuration », https://playwright.dev/docs/test-configuration
- Extrait lu : « "flaky" - tests that failed on the first run, but passed when retried; » / « By default failing tests are not retried. » / `failOnFlakyTests` : « Whether to exit with an error if any tests are marked as flaky. Useful on CI. » / exemple de configuration : « // Retry on CI only. » `retries: process.env.CI ? 2 : 0,`
- Portée / limites : la doc décrit le mécanisme sans le justifier. Après un échec, Playwright jette le worker et le navigateur avant de relancer. L'exemple « 2 relances en CI » est une configuration d'exemple, pas une recommandation argumentée.
- En stratégie : si `retries` > 0, le rapport traite-t-il les « flaky » comme des tickets à ouvrir, ou `failOnFlakyTests` est-il activé ? Un « flaky » qui passe en silence est exactement le retry silencieux visé par la règle.

### Avec pytest-rerunfailures, borner la relance aux types d'erreur d'infrastructure plutôt qu'à toute assertion
- Niveau de preuve : N3 (documentation du plugin)
- Source : pytest-dev, version 16.7 du 17.09.2026, « pytest-rerunfailures », https://pypi.org/project/pytest-rerunfailures/ et https://github.com/pytest-dev/pytest-rerunfailures
- Extrait lu : « pytest-rerunfailures is a plugin for pytest that re-runs tests to eliminate intermittent failures. » / « To re-run only those failures that match a certain list of expressions, use the --only-rerun flag » / « Note that output will show all re-runs. Tests that fail on all the re-runs will be marked as failed. »
- Portée / limites : le but déclaré du plugin (« eliminate intermittent failures ») est précisément de faire disparaître le symptôme. Il est incompatible avec `--pdb` et avec le plugin `flaky`.
- En stratégie : `--reruns` est-il limité par `--only-rerun` (par exemple aux erreurs de connexion) et les « R » du rapport sont-ils relevés ?

### Ne pas relancer jusqu'au vert puis passer à autre chose : la relance aveugle masque de vrais défauts
- Niveau de preuve : N2 (qualitatif et corrélationnel) ; N3 (Slack)
- Source : Habchi et al., 2022 (ci-dessus) ; Gruber et al., 2021 (introduction) ; Patel (Slack Engineering), 05.04.2022, « Handling Flaky Tests at Scale: Auto Detection & Suppression », https://slack.engineering/handling-flaky-tests-at-scale-auto-detection-suppression ; Parry et al. 2021, § 4.1.3 (Rahman et Rigby, source secondaire)
- Extrait lu : Habchi, participant P1 : « with reruns, you do not understand the issue and you can ignore actual problems ». Gruber : « Rerunning flaky tests might therefore mask actual bugs. » Slack : « Bugs can hide under the disguise of a flaky test. » Parry : « These results suggest that ignoring test failures, even if they are flaky, can lead to a higher incidence of crashes [154]. »
- Portée / limites : le chiffre sur Firefox (médiane de 234 rapports de plantage par build avec des échecs instables, contre 2 quand tous les tests passent) est une corrélation rapportée par Parry ; je n'ai pas lu l'étude d'origine. Aucune étude lue ne mesure directement le taux de défauts masqués par la relance.
- En stratégie : chaque relance qui « sauve » un build laisse-t-elle une trace exploitable (ticket, compteur) ?

---

## 4. Dépendance à l'ordre

### Traiter la dépendance à l'ordre comme une cause majeure, détectable en réordonnant et pas en relançant dans l'ordre habituel
- Niveau de preuve : N2 (683 projets Java scannés ; 422 tests instables dans 82 projets)
- Source : Lam, Oei, Shi, Marinov, Xie, 2019, « iDFlakies: A Framework for Detecting and Partially Classifying Flaky Tests » (ICST 2019), https://par.nsf.gov/servlets/purl/10101224
- Extrait lu : « Using iDFlakies, we build a dataset of 422 flaky tests, with 50.5% order-dependent and 49.5% not. » / « simply rerunning tests in the original order where they pass is not a good configuration for detecting flaky tests—it cannot detect any OD test »
- Portée / limites : l'outil est conçu pour trouver des dépendances d'ordre, donc la part de 50,5 % est biaisée vers le haut (les auteurs le reconnaissent : Luo et al. trouvaient 12 % parmi les tests corrigés). Projets Java et Maven.
- En stratégie : la CI exécute-t-elle, au moins de temps en temps, la suite dans un ordre aléatoire ?

### Interdire la dépendance entre tests, car elle produit surtout de fausses alertes et peut aussi masquer un défaut
- Niveau de preuve : N2 (96 tests dépendants réels, 5 gestionnaires de tickets)
- Source : Zhang, Jalali, Wuttke, Muşlu, Lam, Ernst, Notkin, 2014, « Empirically Revisiting the Test Independence Assumption » (ISSTA 2014), https://homes.cs.washington.edu/~mernst/pubs/test-independence-issta2014.pdf
- Extrait lu : « test dependence can cause non-trivial consequences, such as masking program faults and leading to spurious bug reports. » / « Most of the dependent tests (94 out of 96) result in false alarms » / « 59 (61%) of them arise due to access to shared static variables, 10 (10%) of them arise due to access to a database »
- Portée / limites : Java, 2014. Le masquage d'un défaut est rare (2 cas sur 96) mais réel.
- En stratégie : l'état global (singletons, variables de module, caches, base partagée) est-il réinitialisé entre les tests ?

### Rendre les tests indépendants avant de paralléliser, de répartir sur plusieurs machines ou de ne lancer que les tests touchés par un changement
- Niveau de preuve : N2 en source secondaire (via Parry) ; N2 (Lam et al. 2020, Microsoft)
- Source : Parry et al. 2021, § 4.2 et § 5.2.5-5.2.6 ; Lam et al. 2020, « A Study on the Lifecycle of Flaky Tests », https://www.microsoft.com/en-us/research/wp-content/uploads/2020/07/LamETAL20FaTB.pdf
- Extrait lu : Parry : « another source found that 23% of order-dependent tests failed, when previously passing, after applying test prioritization, 24% after applying test selection and 5% after parallelizing tests [123]. » / sur les applications web : « web applications are more prone to test order dependencies from persistent data stored on the server-side and implicit shared data via the Document Object Model on the client-side » / « the reverse mode was the fastest, since it only requires a single test suite run with no isolation overhead. » Lam 2020 : « CloudBuild always runs tests in the same order »
- Portée / limites : chez Microsoft, aucun correctif classé « Test Order Dependency », mais parce que l'ordre y est figé : figer l'ordre cache la dépendance, il ne la supprime pas.
- En stratégie : avant d'activer `--changed`, `--shard` ou des workers parallèles, a-t-on vérifié qu'une exécution en ordre inversé ou aléatoire passe ?

### Outiller l'ordre aléatoire avec une graine reproductible : pytest-randomly côté Python, `sequence.shuffle` côté Vitest
- Niveau de preuve : N3 (documentation des outils)
- Source : pytest-randomly (version 5.1.0 du 08.11.2026 selon PyPI), https://pypi.org/project/pytest-randomly/ ; Vitest, « sequence », https://vitest.dev/config/sequence
- Extrait lu : pytest-randomly : « Randomly shuffles the order of test items. » ; il réinitialise la graine de `random` au début de chaque test et se rejoue avec `pytest --randomly-seed=1234` ou `--randomly-seed=last`. Vitest : « If you want files and tests to run randomly, you can enable it with this option, or CLI argument » (par défaut `false`, CLI `--sequence.shuffle`) ; `sequence.seed` : « Sets the randomization seed, if tests are running in random order. » (par défaut `Date.now()`)
- Portée / limites : l'aléa ne trouve qu'une partie des dépendances par exécution. Il faut journaliser la graine pour pouvoir rejouer.
- En stratégie : la graine est-elle affichée dans les journaux de CI, et la règle « tests indépendants » est-elle vérifiée par cet outil plutôt que simplement déclarée ?

---

## 5. Quarantaine : pratiques documentées

### Fixer des délais de quarantaine écrits : réaction immédiate, échéance courte, puis suppression automatique si personne ne s'en occupe
- Niveau de preuve : N3 (manuel d'ingénierie de GitLab, sur sa propre pratique)
- Source : GitLab, consulté le 10.11.2026, « Test Quarantine Process », https://handbook.gitlab.com/handbook/engineering/testing/quarantine-process/
- Extrait lu : « Fast quarantine 3 days maximum Fix, remove, or convert to long-term » / « Long-term quarantine 3 months maximum » / « Acknowledge within 48 hours. [...] Update the issue with progress weekly. Resolve or remove within 3 months. » / « If a test is quarantined 3 or more times: The test is a candidate for permanent removal. »
- Portée / limites : grande organisation outillée (avec un système de notification et de nettoyage). Les délais sont des choix internes, sans justification empirique publiée sur la page.
- En stratégie : la règle de quarantaine a-t-elle une échéance, un responsable et une issue de sortie (réparer, supprimer, ou descendre à un niveau de test plus bas) ?

### Limiter dans le temps la suppression automatique des échecs instables, pour qu'elle ne devienne pas une solution
- Niveau de preuve : N2 (6 projets Microsoft ; 2 089 tests instables, 861 rapports de bug) et N3 (outil interne décrit par ses auteurs)
- Source : Lam, Muşlu, Sajnani, Thummalapenta, 2020, « A Study on the Lifecycle of Flaky Tests » (ICSE '20), https://www.microsoft.com/en-us/research/wp-content/uploads/2020/07/LamETAL20FaTB.pdf
- Extrait lu : « to discourage developers from fully relying on suppressions to deal with flaky tests, Flakes simply suppresses the failures for 30 days by default. » / « developers take, on average, 18 days, with a median of 7 days to close flaky-test related bug reports »
- Portée / limites : seule mesure lue de la « durée de vie » d'un test instable avant correction. Elle porte sur des projets propriétaires, et la médiane cache des projets à 90 jours (ProjC). L'outil Flakes ouvre automatiquement un rapport de bug pour chaque test instable.
- En stratégie : le délai de quarantaine choisi est-il cohérent avec un ordre de grandeur mesuré (médiane d'une semaine ici) et est-il appliqué automatiquement ?

### Faire porter le coût d'un test instable à celui qui peut le réparer : ticket automatique attribué au dernier auteur, priorité selon l'impact
- Niveau de preuve : N3 (GitHub, sur son monorepo)
- Source : Raine (GitHub), 16.12.2020, « Reducing flaky builds by 18x », https://github.blog/engineering/infrastructure/reducing-flaky-builds-by-18x/
- Extrait lu : « 1 in 11 commits had at least one red build caused by a flaky test » ; après la mise en place, « less than half a percent, or 1 in 200 commits » ; principe : « the only person bothered by a flaky test is the person who wrote it. »
- Portée / limites : chez GitHub, une relance qui passe garde le build vert, mais l'occurrence est journalisée et un ticket est ouvert au-delà d'un seuil d'impact (formule non publiée). Ce n'est donc pas une interdiction du retry : c'est un retry tracé.
- En stratégie : un test instable produit-il automatiquement un ticket avec la trace, attribué à quelqu'un ?

### Garder les tests en quarantaine en exécution hors du chemin bloquant, pour savoir quand les réintégrer
- Niveau de preuve : N3 (Atlassian, sur sa propre pratique)
- Source : Malik (Atlassian Engineering), 08.12.2025, « Taming test flakiness: how we built a scalable tool to detect and manage flaky tests », https://www.atlassian.com/blog/atlassian-engineering/taming-test-flakiness-how-we-built-a-scalable-tool-to-detect-and-manage-flaky-tests
- Extrait lu : « Rerun the failing test in the same build and use that data as a detection method to find flakes. » ; la quarantaine « Provides an ecosystem to isolate flaky tests from CI pipelines, while still tracking them for review and resolution » ; le système « creates Jira tickets with deadlines to resolve them »
- Portée / limites : l'article ne publie pas les délais. Les tests en quarantaine tournent encore dans des branches, des jobs planifiés ou des pipelines dédiés, et sortent de quarantaine après une période saine configurable.
- En stratégie : un `skip` pur prive de tout signal ; un job planifié (hebdomadaire, peu coûteux en minutes) pourrait-il continuer à exécuter les tests en quarantaine ?

### Désactiver vite, mais toujours avec un ticket lié dans le code
- Niveau de preuve : N3 (Slack, applications mobiles)
- Source : Patel (Slack Engineering), 05.04.2022, « Handling Flaky Tests at Scale: Auto Detection & Suppression », https://slack.engineering/handling-flaky-tests-at-scale-auto-detection-suppression
- Extrait lu : « A single failure will result in the test being disabled (regardless of reruns). » / « we were able to drop test job failures from 57% to less than 5% » ; sur Android, le test reçoit une annotation `@Ignore` liée à un ticket Jira attribué à l'équipe propriétaire.
- Portée / limites : l'article ne fixe pas de durée maximale de suppression. La réactivation automatique était prévue comme phase suivante.
- En stratégie : la désactivation est-elle faite dans le code avec le lien du ticket, jamais par un simple commentaire ?

### Savoir que la quarantaine est contestée : elle fait baisser le nombre de tests et peut déplacer le défaut vers l'utilisateur
- Niveau de preuve : N2 (qualitatif, 14 entretiens et 38 articles de littérature grise)
- Source : Habchi et al., 2022, https://arxiv.org/pdf/2112.04919
- Extrait lu : « it’s a dangerous way to go because then suddenly the number of tests goes down » (P1) / « You move the problem from the developer, who will not see the flaky failures anymore, and you transfer it to the user who may deal with a bug » (P6). Au tableau II, « Quarantine flaky tests by isolating them from the blocking path that commands the CI » est cité dans 7 articles sur 38 et par 4 personnes interrogées.
- Portée / limites : opinions de praticiens. La quarantaine est fréquente dans la littérature grise mais minoritaire chez les personnes interrogées.
- En stratégie : la quarantaine est-elle bornée et suivie (compteur de tests en quarantaine), ou devient-elle un cimetière ?

### Éprouver un test neuf en le répétant avant de le fusionner : la plupart des tests instables le sont dès leur introduction
- Niveau de preuve : N2 en source secondaire (Lam et al., via Parry) ; N3 (documentation de Playwright)
- Source : Parry et al. 2021, § 5.1.9 ; Playwright, « Command line », https://playwright.dev/docs/test-cli
- Extrait lu : Parry : « Of these, 75% were flaky from their test-introducing commit, the remaining 25% were associated with a flakiness-introducing commit later in their lifetime. » Playwright : `--repeat-each <N>` « Run each test `N` times (default: 1). »
- Portée / limites : étude sur des projets Java (iDFlakies). Le bon N dépend du budget (voir Gruber : 170 exécutions pour 95 % de confiance, donc N petit = filet partiel).
- En stratégie : la revue d'un nouveau test E2E inclut-elle un passage local `--repeat-each` (par exemple 10 à 20) avant la fusion, pour ne pas payer ce coût en minutes de CI ?

### Rendre la quarantaine auto-signalante avec pytest : un motif obligatoire, et `xfail(strict=True)` pour être prévenu quand le test repasse
- Niveau de preuve : N3 (documentation de pytest)
- Source : pytest, « How to use skip and xfail to deal with tests that cannot succeed », https://docs.pytest.org/en/stable/how-to/skipping.html
- Extrait lu : « You can specify the motive of an expected failure with the `reason` parameter » / avec `strict` : « This will make `XPASS` (“unexpectedly passing”) results from this test to fail the test suite. »
- Portée / limites : `xfail` strict convient à un échec déterministe, pas à un test instable (qui passerait par intermittence et ferait échouer la suite). La page est incohérente sur le nom de l'option ini (`strict_xfail` dans la prose, `xfail_strict` dans un exemple).
- En stratégie : un lint ou une revue refuse-t-il un `skip` ou un `.skip` sans motif contenant l'URL du ticket ?

---

## 6. Coût de la CI et sélection des tests

### Viser une boucle de CI d'au plus une dizaine de minutes : c'est le seuil le plus cité par les développeurs
- Niveau de preuve : N2 (enquête auprès de 523 développeurs et 51 chez Pivotal, plus des entretiens)
- Source : Hilton, Nelson, Tunnell, Marinov, Dig, 2017, « Trade-offs in Continuous Integration: Assurance, Security, and Flexibility » (ESEC/FSE '17), https://dliu04.github.io/epiclab.github.io/publications/esecfse17-hilton.pdf ; complément : Hilton, Tunnell, Huang, Marinov, Dig, 2016, « Usage, Costs, and Benefits of Continuous Integration in Open-Source Projects » (ASE '16), https://cs.uwaterloo.ca/~m2nagapp/courses/CS846/1171/papers/hilton_ase16.pdf
- Extrait lu : 2017 : « When we asked our Broad Survey participants what is the maximum acceptable time for a CI build to take, the most common answer was also 10 minutes » ; « Overly long build times » est un obstacle pour 38 % (enquête large) et 50 % (enquête ciblée). 2016 : « The average build time is just under 500 seconds. »
- Portée / limites : préférence déclarée (le mode de la distribution), pas un seuil d'efficacité démontré. L'article la rattache à la règle « build de 10 minutes » de l'Extreme Programming citée par Fowler.
- En stratégie : le temps de la CI bloquante est-il mesuré et borné ? Ce qui dépasse le budget (E2E complets, tests en ordre aléatoire) part-il dans un job planifié ?

### Pour un petit projet, sélectionner les tests par fichiers modifiés, mais en connaître les angles morts
- Niveau de preuve : N3 (documentation des outils)
- Source : Vitest, « CLI », https://vitest.dev/guide/cli et « forceRerunTriggers », https://vitest.dev/config/forcereruntriggers ; Playwright, « Command line », https://playwright.dev/docs/test-cli ; pytest, « How to re-run failed tests and maintain state between test runs », https://docs.pytest.org/en/stable/how-to/cache.html
- Extrait lu : Vitest `--changed` : « Run tests that are affected by the changed files (default: `false`) » ; `forceRerunTriggers` : « When paired with the `--changed` argument will run the whole test suite if the trigger is found in the git diff. » (par défaut `package.json`, `vitest.config.*`, `vite.config.*`). Playwright `--only-changed [ref]` : « Only run test files that have been changed between 'HEAD' and 'ref'. » ; `--last-failed` : « Only re-run the failures. » pytest : « --lf, --last-failed - to only re-run the failures. »
- Portée / limites : Playwright ne sélectionne que les fichiers de test modifiés, pas le code applicatif qu'ils couvrent. La sélection se casse si les tests dépendent de l'ordre (voir § 4) et se fait piéger par les tests instables (Memon 2017).
- En stratégie : la sélection par changement est-elle complétée par une suite complète au moins sur `main` ou chaque nuit ? Les fichiers de configuration, de migrations et de fixtures sont-ils dans les déclencheurs de suite complète ?

### Économiser les minutes sans perdre de signal : annuler les exécutions dépassées, rester sur Linux, éviter les runners chers
- Niveau de preuve : N3 (documentation officielle de GitHub et de Playwright)
- Source : GitHub Docs, « Control the concurrency of workflows and jobs », https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/control-workflow-concurrency ; GitHub Docs, « GitHub Actions billing », https://docs.github.com/en/billing/concepts/product-billing/github-actions ; Playwright, « Continuous Integration », https://playwright.dev/docs/ci et « Best Practices », https://playwright.dev/docs/best-practices
- Extrait lu : GitHub : `concurrency: group: ${{ github.workflow }}-${{ github.ref }}` / `cancel-in-progress: true`. Tarifs lus le 10.11.2026 : Linux 2 cœurs 0,006 USD/min, Windows 2 cœurs 0,010 USD/min, macOS 0,062 USD/min ; les « Standard GitHub-hosted runners in public repositories » restent gratuits. Playwright : « We recommend setting workers to "1" in CI environments to prioritize stability and reproducibility. » / « Use Linux when running your tests on CI as it is cheaper. »
- Portée / limites : les tarifs et le forfait inclus (exprimé en montant, 12 USD par mois sur le plan gratuit selon la page lue) évoluent. Conseiller un seul worker de Playwright en CI va à l'encontre de la vitesse, et c'est un arbitrage assumé de stabilité.
- En stratégie : les poussées successives sur une PR annulent-elles les exécutions précédentes ? Les matrices multi-OS sont-elles réservées aux jobs planifiés ?

---

## 7. Isolation, données de test, temps et aléa

### Isoler chaque test E2E (contexte navigateur neuf) et ne tester que ce que l'on contrôle : simuler les tiers, jamais l'API de production
- Niveau de preuve : N3 (documentation de Playwright) ; N2 pour la cause réseau (Gruber 2021, Hashemi 2022)
- Source : Playwright, « Isolation », https://playwright.dev/docs/browser-contexts ; « Best Practices », https://playwright.dev/docs/best-practices
- Extrait lu : « Playwright creates a context for each test, and provides a default Page in that context. » / « Each test should be completely isolated from another test and should run independently » / « Only test what you control. » / « use the Playwright Network API and guarantee the response needed. » / « If working with a database then make sure you control the data. » / « Test against a staging environment and make sure it doesn't change. »
- Portée / limites : la doc parle d'un environnement de pré-production stable, pas explicitement de la production. L'interdiction d'appeler la production se déduit de « make sure you control the data ». Les risques de sécurité et de données réelles ne sont pas traités par ces sources.
- En stratégie : quels appels sortants les tests font-ils réellement (journaux réseau) ? Une URL de production peut-elle être atteinte depuis la configuration de test ?

### Remettre la base à l'état initial à chaque test, de préférence par une transaction annulée
- Niveau de preuve : N3 (documentation de Django et de SQLAlchemy)
- Source : Django, « Testing tools », https://docs.djangoproject.com/en/5.2/topics/testing/tools/ ; SQLAlchemy 2.0, « Joining a Session into an External Transaction (such as for test suites) », https://docs.sqlalchemy.org/en/20/orm/session_transaction.html
- Extrait lu : Django : « it encloses the test code in a database transaction that is rolled back at the end of the test. » SQLAlchemy : « the external transaction is rolled back so that any data changes throughout the test are reverted. »
- Portée / limites : la transaction annulée ne permet pas de tester le comportement transactionnel lui-même (Django renvoie alors à `TransactionTestCase`, qui vide les tables, plus lent). Elle ne couvre pas les tests E2E, où le serveur tourne dans un autre processus. Dans l'étude de Zhang (2014), 10 % des dépendances venaient d'une base de données.
- En stratégie : chaque test pytest a-t-il sa transaction ou sa base ? Pour les E2E Playwright, comment les données sont-elles créées et nettoyées (par test, avec des identifiants uniques) ?

### Contrôler l'horloge et le hasard dans les tests, plutôt que désactiver les tests sensibles au temps
- Niveau de preuve : N3 (documentation de Vitest et de freezegun) ; N2 pour les causes (Eck 2019, Gruber 2021)
- Source : Vitest, « Vi », https://vitest.dev/api/vi ; freezegun 1.5.5 (09.08.2025), https://pypi.org/project/freezegun/ ; Eck et al. 2019, https://arxiv.org/pdf/1907.01466
- Extrait lu : Vitest `vi.useFakeTimers` : « It will wrap all further calls to timers (such as `setTimeout`, `setInterval`, `clearTimeout` [...] `setImmediate`, `clearImmediate`, and `Date`) until `vi.useRealTimers()` is called. » ; `vi.setSystemTime` : « If fake timers are enabled, this method simulates a user changing the system clock ». freezegun : « FreezeGun is a library that allows your Python tests to travel through time by mocking the datetime module. » Eck, à propos de la cause « Time » : « in 75% of the cases developers just disable the test, and thus only in a few cases (25%) they actually try to preserve the time precision. »
- Portée / limites : dans Gruber (Python), le hasard est une cause notable parmi les tests instables non liés à l'ordre (37 cas sur l'échantillon classé du tableau IX). La doc de Vitest ne dit pas explicitement de restaurer les vrais timers après chaque test : c'est une précaution à imposer soi-même (`afterEach`).
- En stratégie : tout test qui lit `Date.now()`, `datetime.now()` ou `Math.random()` fige-t-il l'horloge et fixe-t-il la graine ? Les fuseaux horaires sont-ils fixés en CI ?

---

## Verdict sur les règles de l'agent

| Règle | Verdict | Motif sourcé |
|---|---|---|
| « Politique flaky : un test instable est mis en quarantaine le jour même (skip + ticket avec la trace), jamais relancé en boucle jusqu'au vert. » | **Contredite / à préciser** | Le ticket avec la trace est soutenu par la pratique N3 : ticket automatique chez Microsoft (Flakes), GitHub, Atlassian et Slack ; métadonnée `issue-url` chez GitLab. « Jamais relancé en boucle jusqu'au vert » est soutenu (Habchi 2022 : « you can ignore actual problems » ; Gruber 2021 : « might therefore mask actual bugs »). Deux points à corriger. (1) Une relance **bornée** (1 à 3) est un classificateur valide d'un échec (Gruber 2021, 95 % de confiance), employé par GitHub et Atlassian. (2) Un `skip` pur prive de signal : Atlassian garde les tests en quarantaine en exécution hors du chemin bloquant. « Le jour même » est une convention, plus proche de la « fast quarantine » de GitLab (3 jours maximum, accusé de réception sous 48 h). |
| « Le retry automatique silencieux en CI est interdit : il transforme un signal (race condition réelle, souvent) en bruit. » | **Soutenue sur « silencieux », à préciser sur le motif** | Playwright distingue les tests « flaky » et propose `failOnFlakyTests` (« Useful on CI ») ; GitHub relance mais journalise et ouvre des tickets. C'est donc le caractère **silencieux**, et non le retry, qui pose problème. Sa propre configuration d'exemple met d'ailleurs `retries: process.env.CI ? 2 : 0`. « Race condition réelle, souvent » est exagéré : 71 à 88 % des correctifs ne touchent que le test (Parry 2021), 12 % touchent le code de production chez Microsoft (Lam 2020), environ un tiers des cas de concurrence chez Mozilla (Eck 2019). C'est une minorité réelle, pas la majorité. |
| « Un test en quarantaine > 2 semaines est réparé ou supprimé. » | **Convention sans preuve trouvée** | Aucune étude lue ne justifie 2 semaines. Points de repère : GitLab, 3 jours en quarantaine rapide, 3 mois au maximum en quarantaine longue, puis suppression automatique ; Microsoft Flakes, suppression des échecs pendant 30 jours par défaut ; délai mesuré de clôture des tickets d'instabilité chez Microsoft : médiane 7 jours, moyenne 18 jours (Lam 2020). Deux semaines est cohérent avec ces ordres de grandeur et plus strict que GitLab, mais reste arbitraire. Ce qui est soutenu, c'est d'avoir une échéance écrite et une sortie obligatoire. |
| « Jamais de test qui dépend de l'ordre d'exécution (chaque test doit être indépendant). » | **Soutenue** (à compléter par un moyen de contrôle) | Zhang 2014 (94 fausses alertes sur 96, plus des défauts masqués) ; iDFlakies 2019 (50,5 % de tests dépendants de l'ordre, avec un biais de méthode) ; Gruber 2021 (59 % des tests instables en Python) ; la dépendance casse la sélection (24 %) et la parallélisation (5 %), via Parry. Playwright : « completely isolated ». Précision : la règle n'est vérifiable qu'en exécutant dans un ordre aléatoire (`pytest-randomly`, `--sequence.shuffle`) ; figer l'ordre cache le problème (Microsoft, Lam 2020). |
| « Tests qui appellent l'API prod (devraient appeler un env de test) » (anti-pattern) | **Soutenue** (N3, indirectement N2) | Playwright : « Only test what you control », simuler les tiers via la Network API, « make sure you control the data », « Test against a staging environment ». Le réseau est une cause d'instabilité documentée (Gruber 2021, Hashemi 2022) ; « Limit external dependencies by mocking » figure dans 9 des 38 articles de littérature grise de Habchi. Aucune étude lue ne vise spécifiquement la production ; le motif sécurité et données réelles n'est pas sourcé ici. |
| « Tests désactivés (`.skip`, `xit`) sans ticket pour les réactiver » (anti-pattern) | **Soutenue** (N3) | GitLab (quarantaine via une métadonnée qui porte l'URL de l'issue, suppression après 3 mois), Slack (`@Ignore` lié à un ticket Jira), Microsoft Flakes (rapport de bug automatique), Atlassian (tickets Jira avec échéance). Eck 2019 montre que la désactivation est une « solution » fréquente pour certaines causes (75 % des cas liés au temps). L'étude de Kim et al. 2021 sur les tests désactivés est couverte ailleurs et n'a pas été relue ici. |

---

## Mythes et affirmations contestées

- **« Un test instable est un problème du test, pas du produit. »** Contredit en partie : 12 % des correctifs touchent le code de production chez Microsoft (Lam 2020), et « ignoring flaky tests can be dangerous since they do indicate faults in both source and test code ». La proportion inverse est aussi vraie : la majorité des correctifs (71 à 88 %) ne touche que le test (Parry 2021).
- **« Il suffit de relancer quelques fois pour savoir si un test est stable. »** Faux pour la détection : 10 relances ne trouvent qu'environ un quart des tests instables trouvés en 10 000 exécutions (FlakeFlagger 2021), et il faut environ 170 exécutions pour 95 % de confiance (Gruber 2021). Vrai en revanche pour classer **un échec observé** : 1 à 3 relances suffisent (Gruber 2021). Les deux affirmations sont souvent confondues.
- **« Toute relance automatique masque des bugs, donc il faut l'interdire. »** Trop absolu : la relance tracée est la base des systèmes de GitHub, Atlassian et Microsoft. Ce qui masque, c'est la relance qui ne laisse ni trace ni ticket (Habchi 2022, Slack 2022).
- **« La quarantaine est la bonne pratique consensuelle. »** Contesté : courante dans la littérature grise, minoritaire et critiquée chez les praticiens interrogés par Habchi (2022) (« the number of tests goes down », « you transfer it to the user »).
- **« Microsoft n'a pas de tests dépendants de l'ordre. »** Artefact de méthode : l'ordre d'exécution y est figé (Lam 2020). La dépendance existe toujours, elle ne se manifeste simplement pas tant que l'ordre ne change pas.
- **« Playwright recommande 2 relances en CI. »** Imprécis : la page « Retries » dit seulement que rien n'est relancé par défaut. `retries: process.env.CI ? 2 : 0` figure dans un exemple de configuration, sans justification.
- **« Google consacre 2 à 16 % de ses ressources de test à relancer des tests instables. »** Chiffre repris par Habchi (2022) et Gruber (2021) à partir d'une source Google de Micco ; non vérifié à la source primaire ici.
- **« 50 % des tests instables dépendent de l'ordre. »** Valable seulement pour le corpus d'iDFlakies, construit par réordonnancement (les auteurs signalent 12 % chez Luo et al.) ; c'est 59 % en Python (Gruber), mais 11 % dans le corpus Mozilla (Eck). Le chiffre dépend du langage et de la méthode de détection.

---

## Non vérifié

- **Google, billet de 2020** (Pirocanac, « Test Flakiness - One of the main challenges of automated testing », https://testing.googleblog.com/2020/12/test-flakiness-one-of-main-challenges.html) : page ouverte, mais le texte de l'article n'a pas pu être extrait (rendu en JavaScript). Son contenu n'est pas utilisé.
- **Politique de quarantaine de Google** : non relue dans une source primaire ici (Micco 2016 est couvert ailleurs).
- **Études connues uniquement par la revue de Parry et al. (2021), non lues à la source** : Durieux et al. (builds relancés, 47 %), Rahman et Rigby (rapports de plantage de Firefox), Bell et al. (DeFlaker, stratégies de relance), Lam et al. ISSRE 2020 (« burst lengths », 5 relances), Lam, Shi, Oei, Zhang, Ernst, Xie, ISSTA 2020, « Dependent-Test-Aware regression testing techniques » (23 % / 24 % / 5 %), Lam et al. OOPSLA 2020 (75 % instables dès l'introduction ; le PDF de cs.gmu.edu n'a pas pu être téléchargé, à cause d'une erreur de certificat), Biagiola et al. (dépendances dans les tests web).
- **Gambi, Bell, Zeller 2018** (« Practical test dependency detection », PraDeT) : seul le résumé qu'en fait Parry a été lu.
- **Chiffre de « 2-16 % du budget de test de Google »** : non vérifié à la source primaire.
- **Durée de vie d'un test instable en open source** : aucune mesure primaire lue ; la seule mesure lue est celle de Microsoft (Lam 2020).
- **Comportement de Vitest en cas de `retry`** : la doc lue ne dit pas si un test qui réussit après relance est signalé comme « flaky » dans le rapport. Non vérifié.
- **Temps de CI acceptable** : seule la préférence déclarée de Hilton et al. 2017 (mode à 10 minutes) a été trouvée. Pas d'étude causale sur un seuil.
- **Manuel de GitLab** : la date de dernière modification de la page n'a pas été relevée ; ses délais peuvent changer.

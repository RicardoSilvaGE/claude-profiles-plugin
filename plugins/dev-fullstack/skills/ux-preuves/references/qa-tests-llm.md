# Fiche `ux-preuves` — Tests — tests générés par un LLM et code écrit par des agents

> Fiche du skill `ux-preuves` (dev-fullstack), volet **tests**, préchargé par `qa`. Couvre : génération de tests en industrie (Meta), qualité et oracles des tests générés, assertions faibles, agents qui exploitent les tests, tests de reproduction, TDD avec un LLM, séparation de l'auteur du code et de l'auteur des tests.
> **Instantané de la recherche documentaire du 10.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Études (souvent des prépublications pour les LLM), docs d'outils
> et pratiques d'entreprise **vieillissent** : avant d'en faire dépendre une règle,
> relire la source (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles de l'agent », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

**Méthode.** Recherche menée le 10.11.2026. Sources trouvées par WebSearch, puis **lues** : pages de résumé arXiv récupérées directement (titre, auteurs, commentaires, résumé), et pour 18 documents le PDF complet téléchargé dans `pdf5/` puis converti avec `pdftotext`, où chiffres et extraits ont été pris au texte (sections résultats, tableaux, en-têtes de conférence). Les lieux de publication ne sont cités que s'ils figurent sur le PDF lu, sur la page arXiv (champ « Comments » ou « Journal-ref ») ou sur la page officielle de la conférence, de l'éditeur ou d'un dépôt institutionnel ouverte. Les autres sont donnés comme prépublications arXiv. Niveaux : N1 norme ; N2 recherche revue par les pairs ou étude empirique à large échantillon ; N3 guide officiel d'une institution ou rapport d'entreprise sur sa propre pratique ; N4 avis d'expert, billet d'éditeur. Une prépublication arXiv non revue mais à large échantillon est marquée « N2 (prépublication) ». Écarté faute de place : ASTER (Pan et al., IBM, « Accepted at ICSE-SEIP, 2025 » selon arXiv, résumé seul lu : https://arxiv.org/abs/2409.03093), qui mesure couverture et naturel des tests, pas la force des oracles. Déjà couverts ailleurs, donc **non refaits ici** : ImpossibleBench, Mathews & Nagappan 2024 « Design choices… », Konstantinou et al. (tests qui figent le bug), correctifs d'agents plausibles mais différents de la référence (le chiffre de 29,6 % de Wang et al. n'est cité ici que pour situer leur autre résultat), PR d'agents non fusionnables, Jin & Chen 2025, biais des LLM-juges. 35 entrées.

---

## 1. Génération de tests par LLM en industrie

### Ne garder un test généré que s'il compile, passe de façon répétée et apporte une couverture nouvelle : ce sont des filtres de recevabilité, pas des preuves de justesse
- Niveau de preuve : N3 (rapport de Meta sur sa propre pratique, publié à FSE 2024 Industry)
- Source : Alshahwan, Chheda, Finegenova, Gokkaya, Harman, Harper, Marginean, Sengupta, Wang, 2024, « Automated Unit Test Improvement using Large Language Models at Meta », https://arxiv.org/abs/2402.09171 (PDF lu, en-tête « FSE '24, Porto de Galinhas »)
- Extrait lu : « 75% of TestGen-LLM's test cases built correctly, 57% passed reliably, and 25% increased coverage »; « a test that does not pass on every one of five executions is deemed flaky »
- Portée / limites : tests unitaires Kotlin Android (Instagram, Facebook), LLM internes de Meta, fin 2023. Le pipeline améliore des classes de test humaines existantes ; il ne part pas d'une spécification. Sur 100 candidats, environ un quart seulement survit aux trois filtres.
- En stratégie : exiger des agents les mêmes trois portes (build, passage répété contre l'instabilité, apport mesuré), puis traiter ce qui reste comme un candidat à relire, pas comme un acquis. Défaut à chercher : un test instable, ou un test qui ne couvre rien de neuf.

### Un test qui « passe à la première exécution » est un oracle de régression : il protège le comportement actuel, il ne dit pas que ce comportement est juste
- Niveau de preuve : N3
- Source : Alshahwan et al., 2024, même article, https://arxiv.org/abs/2402.09171 (PDF lu)
- Extrait lu : « cannot automatically determine whether a failing test has found a bug, or whether it merely contains an incorrect test assertion. Therefore, TestGen-LLM discards any test case that does not pass on first execution »
- Portée / limites : choix de conception explicite de Meta pour l'amélioration de suites existantes. Dans un flux où l'agent écrit le code **et** ses tests, la même logique fait passer un bug pour la référence.
- En stratégie : dans la matrice, distinguer les cas de **non-régression** (figer l'existant) des cas de **spécification**, dont la valeur attendue vient de la matrice et jamais d'une exécution du code. Défaut à chercher : une valeur attendue recopiée depuis la sortie observée.

### Rejeter un test sans assertion, même s'il fait monter la couverture
- Niveau de preuve : N3
- Source : Alshahwan et al., 2024, même article, https://arxiv.org/abs/2402.09171 (PDF lu, § test-a-thon)
- Extrait lu : « One diff was abandoned because the test case did not include any assertion »; « The test case did extend coverage […] but it was rejected by the engineer reviewing the diff because it failed to contain an assertion »
- Portée / limites : un cas sur 17 diffs du premier test-a-thon. Anecdote, mais elle illustre que le filtre de couverture laisse passer un test sans oracle.
- En stratégie : revue systématique « où est l'assertion, et dépend-elle du code testé ? ». Défaut à chercher : `// TODO: add assertion`, `expect(true).toBe(true)`, un test qui appelle sans vérifier.

### Générer les tests pour tuer des mutants ciblés (une préoccupation précise) plutôt que pour de la couverture
- Niveau de preuve : N3 (rapport de Meta sur sa pratique, PDF titré « FSE Companion '25, Trondheim »)
- Source : Foster, Gulati, Harman, Harper, Mao, Ritchey, Robert, Sengupta, 2025, « Mutation-Guided LLM-based Test Generation at Meta », https://arxiv.org/abs/2501.12862 (PDF lu)
- Extrait lu : « applied to 10,795 Android Kotlin classes in 7 software platforms […] from which it generated 9,095 mutants and 571 privacy-hardening test cases »; « engineers accepted 73% of its tests, judging 36% to privacy relevant »
- Portée / limites : Kotlin Android, préoccupation « vie privée ». Le taux d'acceptation porte sur des tests déjà filtrés : chaque test tue un mutant, ce qui suppose qu'il échoue sur le mutant et passe sur le code.
- En stratégie : pour chaque risque prioritaire de la matrice (auth, droits, montant, donnée personnelle), décrire le défaut plausible, c'est-à-dire le mutant, puis exiger un test qui le détecte. Question : « quelle faute précise ce test attraperait-il ? »

### Ne pas juger un test à la couverture qu'il ajoute : environ la moitié des tests qui détectent une faute nouvelle n'ajoutent aucune ligne couverte
- Niveau de preuve : N3
- Source : Foster et al., 2025, même article, https://arxiv.org/abs/2501.12862 (PDF lu, Table 8)
- Extrait lu : « a large proportion (49%) of test cases that uniquely additionally kill a mutant, do not also add line coverage »; « targeting mutants can also elevate coverage, but targeting coverage will be inadequate to kill mutants »
- Portée / limites : comparaison interne à Meta avec TestGen-LLM : celui-ci génère des tests pour 32 % des classes mais tue 2,4 % des mutants, contre 15 % pour ACH. Les auteurs rappellent que la littérature de laboratoire le disait déjà.
- En stratégie : ne jamais rejeter un test au motif qu'il « ne couvre rien de nouveau » ; un même chemin avec d'autres données (bornes, valeurs spéciales) peut attraper une faute que la couverture ne voit pas.

## 2. Qualité des tests générés

### Mesurer la part d'assertions non triviales : un test sans assertion ou avec une assertion triviale peut quand même rapporter de la couverture
- Niveau de preuve : N2 (IEEE TSE vol. 50, n° 1, 2024, p. 85-105 selon la notice NSF PAR ouverte ; 25 paquets npm, 1 684 fonctions)
- Source : Schäfer, Nadi, Eghbali, Tip, 2024, « An Empirical Evaluation of Using Large Language Models for Automated Unit Test Generation », https://arxiv.org/abs/2302.06527 (PDF lu) ; notice : https://par.nsf.gov/biblio/10500925-empirical-evaluation-using-large-language-models-automated-unit-test-generation
- Extrait lu : « A test with no assertions or with trivial assertions such as assert.equal(true, true) may still achieve high coverage. However, such tests do not provide useful oracles. »; « A median of 61.4% of the generated tests for a given package are non-trivial »
- Portée / limites : JavaScript, gpt-3.5-turbo, 2023. Couverture médiane de 70,2 % des instructions et 52,8 % des branches. Est « non triviale » une assertion dont le slice arrière touche le paquet testé : c'est un critère minimal, pas une preuve de justesse.
- En stratégie : contrôle de revue automatisable : chaque test a-t-il au moins une assertion qui dépend de la valeur produite par le code testé ?

### Se méfier de la boucle « réparer le test qui échoue » : le LLM aligne la valeur attendue sur la valeur observée
- Niveau de preuve : N2 (même article)
- Source : Schäfer et al., 2024, https://arxiv.org/abs/2302.06527 (PDF lu, exemple du raffineur de prompt)
- Extrait lu : « the expected value in the assertion has been updated to 5, as per the assertion error message »
- Portée / limites : l'exemple est présenté comme une réparation réussie, et le code testé est correct dans ce cas. Le même mécanisme, appliqué à un code faux, fige le bug.
- En stratégie : interdire à l'agent de corriger une valeur attendue à partir du message d'erreur sans revenir à la matrice. Question de revue : « cette valeur attendue a-t-elle changé dans le même commit que le code ? »

### Sur du code réel, la couverture obtenue par un LLM seul peut s'effondrer ; repérer aussi les tests vides et les assertions dupliquées
- Niveau de preuve : N2 (EASE 2024, p. 313-322 selon la page arXiv ; deux bancs, trois modèles)
- Source : Siddiq, Santos, Tanvir, Ulfat, Al Rifat, Lopes, 2024, « Using Large Language Models to Generate JUnit Tests: An Empirical Study », https://arxiv.org/abs/2305.00418 (résumé lu ; PDF téléchargé, non exploité au-delà du résumé)
- Extrait lu : « the Codex model achieved above 80% coverage for the HumanEval dataset, but no model had more than 2% coverage for the EvoSuite SF110 benchmark »; « suffered from test smells, such as Duplicated Asserts and Empty Tests »
- Portée / limites : Codex, GPT-3.5-Turbo et StarCoder, 2023, sans affinage. Écart entre fonctions isolées (HumanEval) et projets réels (SF110). Les modèles récents font mieux, mais l'écart banc jouet contre projet réel reste à vérifier sur chaque dépôt.
- En stratégie : ne pas extrapoler une réussite sur des fonctions pures aux modules qui ont des dépendances ; inclure dans la revue la détection des tests vides et des assertions répétées.

### Quand un test généré échoue, présumer d'abord une assertion fausse, pas un bug
- Niveau de preuve : N2 (Proc. ACM Softw. Eng., vol. 1, FSE, art. 76, juillet 2024, selon le PDF ; 1 000 méthodes de 185 projets Java)
- Source : Yuan, Lou, Liu, Ding, Wang, Chen, Peng, 2024, « No More Manual Tests? Evaluating and Improving ChatGPT for Unit Test Generation », https://arxiv.org/abs/2305.04207 (PDF lu)
- Extrait lu : « the majority of failed executions (85.5%) are caused by assertion errors »; « we find all of them as a result of incorrect assertions generated by ChatGPT »
- Portée / limites : ChatGPT (2023). 24,8 % des tests passent, 57,9 % ne compilent pas, 17,3 % compilent puis échouent. ChatTester apporte « 18.7% more tests with correct assertions ».
- En stratégie : un test rouge écrit par un agent se tranche contre la matrice (valeur attendue écrite d'avance), pas en corrigeant le test ni le code au réflexe.

### Ne pas se fier aux assertions d'un LLM pour décider si un bug est déclenché
- Niveau de preuve : N2 (prépublication ; 207 tests sur des projets SF110 et Defects4J)
- Source : Tang, Liu, Zhou, Luo, 2023, « ChatGPT vs SBST: A Comparative Assessment of Unit Test Suite Generation », https://arxiv.org/abs/2307.00588 (PDF lu)
- Extrait lu : « we cannot fully rely on the Assertions in ChatGPT-generated test cases to determine whether the bugs are successfully triggered »
- Portée / limites : ChatGPT de 2023 comparé à EvoSuite. Les auteurs restreignent ensuite la détection de bugs aux bugs qui lèvent une exception, faute de pouvoir se fier aux assertions. EvoSuite atteint une couverture supérieure, surtout sur les grosses classes.
- En stratégie : pour les cas critiques, préférer des oracles indépendants du LLM : valeur de référence calculée à la main dans la matrice, propriété (invariant), exception attendue.

### Combiner le LLM avec un générateur par recherche plutôt que l'opposer
- Niveau de preuve : N2 (ICSE 2023 Technical Track, confirmé sur la page du programme ; 486 modules Python)
- Source : Lemieux, Inala, Lahiri, Sen, 2023, « CodaMOSA: Escaping Coverage Plateaus in Test Generation with Pre-trained Large Language Models », https://www.microsoft.com/en-us/research/uploads/prod/2023/03/codamosa_icse23.pdf (PDF lu) ; programme : https://conf.researchr.org/details/icse-2023/icse-2023-technical-track/132/CodaMOSA-Escaping-Coverage-Plateaus-in-Test-Generation-with-Pre-trained-Large-Langua
- Extrait lu : « CODAMOSA achieves statistically significantly higher coverage on many more benchmarks (173 and 279) than it reduces coverage on (10 and 4), compared to SBST and LLM-only baselines »
- Portée / limites : objectif de couverture (Pynguin + Codex), pas de justesse d'oracle. Le LLM sert à produire des entrées plausibles quand la recherche stagne.
- En stratégie : pour la logique pure en Python ou TypeScript, compléter les tests d'agents par un outil de génération d'entrées (tests par propriétés, fuzzing) ; le LLM sait proposer des entrées « attendues », la recherche explore les autres.

### Réinjecter les mutants survivants dans le prompt améliore la détection de fautes
- Niveau de preuve : N2 (prépublication ; publication en revue non confirmée sur une page lue)
- Source : Dakhel, Nikanjam, Majdinasab, Khomh, Desmarais, 2023, « Effective Test Generation Using Pre-trained Large Language Models and Mutation Testing », https://arxiv.org/abs/2308.16557 (résumé seul lu)
- Extrait lu : « the coverage is weakly correlated with the efficiency of tests in bug detection »; « able to detect up to 28% more faulty human-written code snippets »
- Portée / limites : petits programmes Python ; le score de mutation de 93,57 % porte sur du code bogué synthétique. Les auteurs notent que les tests de LLM « may be ineffective in detecting certain types of bugs and testing corner cases ».
- En stratégie : boucle opérable avec Stryker (TS) ou mutmut (Python) : passer à l'agent la liste des mutants survivants et lui demander les tests qui les tuent, plutôt que « monte la couverture ».

### Utiliser la couverture pour trouver le code non testé, jamais comme cible de qualité
- Niveau de preuve : N2 (ICSE 2014, selon le PDF ; 31 000 suites de tests, 5 systèmes Java jusqu'à 724 000 lignes)
- Source : Inozemtseva, Holmes, 2014, « Coverage Is Not Strongly Correlated with Test Suite Effectiveness », https://cs.ubc.ca/~rtholmes/papers/icse_2014_inozemtseva.pdf (PDF lu)
- Extrait lu : « there is a low to moderate correlation between coverage and effectiveness when the number of test cases in the suite is controlled for »; « stronger forms of coverage do not provide greater insight into the effectiveness of the suite »
- Portée / limites : étude antérieure aux LLM, efficacité mesurée par mutation, Java. Elle reste la référence du lien couverture-efficacité, et MuTAP comme ACH la citent ou la retrouvent.
- En stratégie : un seuil de couverture dans la CI est un garde-fou contre l'absence de tests, pas un critère de suffisance ; la suffisance se juge sur la matrice et sur les mutants.

## 3. Oracle et LLM

### Distinguer l'oracle « conforme au comportement observé » de l'oracle « conforme à l'intention » : les meilleurs générateurs neuronaux mesurent le premier
- Niveau de preuve : N2 (ICSE 2025, p. 1475-1487 selon la page arXiv ; 25 projets Java, 202 434 préfixes d'assertion)
- Source : Hossain, Dwyer, 2025, « TOGLL: Correct and Strong Test Oracle Generation with LLMs », https://arxiv.org/abs/2405.03786 (PDF lu)
- Extrait lu : « Generated test oracles that do not compile, that disagree with software behavior, or that are vacuous are considered incorrect »; « TOGLL achieving a mean of 63% compared to TOGA's mean of 16.4% »
- Portée / limites : un oracle est jugé « correct » s'il s'accorde avec le comportement du logiciel tel qu'il est. Les auteurs rappellent que TOGA ne générait une assertion que 38 % du temps, et que « 47% are false positives ». Modèles affinés sur SF110, pas de LLM généraliste dans une boucle d'agent.
- En stratégie : un oracle généré, même « correct » à 63 %, reste un oracle de régression ; pour un code neuf, la valeur attendue doit venir de la spécification.

### Faire traduire l'intention en postconditions exécutables par le LLM, puis vérifier leur force sur des mutants
- Niveau de preuve : N2 (FSE 2024, selon l'en-tête du PDF ; EvalPlus 164 problèmes, Defects4J 525 bugs)
- Source : Endres, Fakhoury, Chakraborty, Lahiri, 2024, « Can Large Language Models Transform Natural Language Intent into Formal Method Postconditions? », https://arxiv.org/abs/2310.01831 (PDF lu)
- Extrait lu : « 77% of postconditions were test-set-correct and a test-set-correct postcondition was generated for 96% of problems (158/164) »; « the average correct postcondition generated by these models can discriminate over three-quarters of unique buggy code mutants »
- Portée / limites : GPT-3.5, GPT-4 et StarChat, fonctions courtes bien documentées. La justesse est mesurée sur la suite de tests de référence, pas prouvée. Sur du code industriel, la portée tombe : « we were able to generate a bug-discriminating postcondition for 70 buggy methods from 64 unique bugs in Defects4J, 12.2% of all bugs considered » (9 % pour le meilleur modèle seul), alors que le résumé met en avant les « 64 real-world historical bugs ».
- En stratégie : pour une règle métier, demander un invariant ou une postcondition (« le total vaut la somme des lignes », « le statut ne recule jamais ») plutôt que seulement des exemples ; cela se teste aussi par propriétés. Un oracle généré attrape une minorité des vrais bugs d'un projet réel : il complète la matrice, il ne la remplace pas.

### Rejeter les assertions de forme (type, non-nul) comme seul oracle : ce sont les plus fréquentes chez un LLM et les plus faibles
- Niveau de preuve : N2 (même article)
- Source : Endres et al., 2024, https://arxiv.org/abs/2310.01831 (PDF lu, RQ1)
- Extrait lu : « the weakest postcondition type, Type Checks, killed only 14% of natural bugs on average while the strongest, Arithmetic Equality check, killed 82%, a 6x difference »; « Type Checks are also the most prevalent category, indicating LLM preference towards generating such constraints »
- Portée / limites : catégorisation qualitative sur EvalPlus (Python). L'écart pourrait être plus faible dans un code TypeScript strict où le typage attrape déjà ces fautes.
- En stratégie : en revue, repérer `expect(x).toBeDefined()`, `toBeInstanceOf`, `isinstance` comme assertion principale ; exiger une égalité sur la valeur métier.

## 4. Tests et agents qui codent

### Un banc « validé par les tests » mesure la force de ses tests autant que celle de l'agent : environ un tiers des réussites tenaient à des tests faibles
- Niveau de preuve : N2 (prépublication ; analyse manuelle des réussites de SWE-Agent + GPT-4)
- Source : Aleithan, Xue, Mohajer, Nnorom, Uddin, Wang, 2024, « SWE-Bench+: Enhanced Coding Benchmark for LLMs », https://arxiv.org/abs/2410.06992 (résumé lu ; PDF téléchargé)
- Extrait lu : « 31.08% of the passed patches are suspicious patches due to weak test cases, i.e., the tests were not adequate to verify the correctness of a patch »
- Portée / limites : un seul agent sur SWE-bench complet, 2024. S'y ajoutent 32,67 % de fuite de la solution dans l'issue. Une fois ces cas filtrés, le taux de résolution tombe de 12,47 % à 3,97 %.
- En stratégie : avant de croire « tous les tests passent », se demander si ces tests auraient échoué sur une solution fausse plausible ; c'est la question « casser le code ».

### Augmenter les tests d'un banc d'agents révèle des correctifs faux classés réussis
- Niveau de preuve : N2 (ACL 2025, Long Papers, p. 3762-3774, confirmé sur l'ACL Anthology)
- Source : Yu, Zhu, He, Kang, 2025, « UTBoost: Rigorous Evaluation of Coding Agents on SWE-Bench », https://arxiv.org/abs/2506.09289 (résumé lu) ; https://aclanthology.org/2025.acl-long.189/
- Extrait lu : « the manually written test cases included in these pull requests are often insufficient, allowing generated patches to pass the tests without resolving the underlying issue »; « uncovered 345 erroneous patches incorrectly labeled as passed »
- Portée / limites : 36 instances aux tests insuffisants, corrections touchant 40,9 % des entrées du classement SWE-Bench Lite et 24,4 % de Verified. Python uniquement.
- En stratégie : quand un agent livre code et tests, prévoir une passe de tests ajoutés par un tiers (`qa` ou un sous-agent neuf) sur les cas de la matrice les plus risqués.

### Valider un changement d'agent sur la suite complète, pas seulement sur les fichiers de test qu'il a touchés
- Niveau de preuve : N2 (ICSE 2026, selon le PDF ; trois outils sur SWE-bench Verified)
- Source : Wang, Pradel, Liu, 2026, « Are "Solved Issues" in SWE-bench Really Solved Correctly? An Empirical Study », https://arxiv.org/abs/2503.15223 (PDF lu)
- Extrait lu : « SWE-bench only uses the developer-written test files modified in the pull request (PR) […] potentially leaving functionality covered by other test files untested »; « 7.8% of plausible patches are incorrect »
- Portée / limites : seul l'aspect « suite partielle » est repris ici ; le résultat sur les correctifs divergents est couvert ailleurs. Les auteurs ajoutent que 82,7 % des correctifs suspects ne sont pas révélés même par toute la suite développeur.
- En stratégie : la preuve demandée à un agent est la sortie de la **suite entière** (ou du périmètre de non-régression déclaré), pas du seul fichier de test qu'il vient d'écrire.

### Les agents savent écrire des tests de reproduction, mais rarement : demander un test rouge avant le correctif et vérifier qu'il est rouge
- Niveau de preuve : N2 (NeurIPS 2024, Main Conference Track, confirmé sur proceedings.neurips.cc)
- Source : Mündler, Müller, He, Vechev, 2024, « SWT-Bench: Testing and Validating Real-World Bug-Fixes with Code Agents », https://arxiv.org/abs/2406.12952 (PDF v3 lu) ; https://proceedings.neurips.cc/paper_files/paper/2024/hash/94f093b41fc2666376fb1f667fe282f3-Abstract.html
- Extrait lu : « SWE-AGENT, however, outperforms LIBRO at an S of 15.9%, increased to 18.5%, when instructed to check its generated tests (SWE-AGENT +) »
- Portée / limites : S = au moins un test rouge avant le correctif de référence et vert après, sans aucun test cassé. Modèles de 2024 (GPT-4, Claude 3.5 Sonnet…), dépôts Python. La consigne de vérifier ses propres tests améliore le score.
- En stratégie : pour un bug, exiger la séquence test rouge (sortie collée), correctif, test vert (sortie collée) ; un test de reproduction qui passe déjà avant le correctif ne prouve rien. Utilisés comme filtre des correctifs, ces tests sont efficaces mais coûteux : « While only achieving 20% recall, this more than doubles the precision of SWE-AGENT to 47.8% » (SWE-bench Lite). Prévoir dans le cadrage le coût des faux rejets d'un jeu d'acceptation écrit par un autre que l'auteur du code.

### Écrire le test et écrire le correctif sont deux compétences distinctes ; montrer le correctif au testeur l'aide peu
- Niveau de preuve : N2 (même article)
- Source : Mündler et al., 2024, https://arxiv.org/abs/2406.12952 (PDF lu, Tables 5 et 6)
- Extrait lu : « providing a code patch and the files it changed has a much smaller impact, increasing S only to 10.5% for both the golden patch and an incorrect patch »; « indicating that generating tests and fixes are distinct tasks of different difficulties »
- Portée / limites : le chevauchement entre instances résolues en réparation et en test n'est pas corrélé statistiquement (p = 80,4 % et 72,8 %). Donner le bon fichier de test à modifier aide davantage (S passe de 8,1 % à 15,1 %).
- En stratégie : dans le hand-off, donner à l'écrivain de tests **où** tester (fichier, module) et **quoi** (matrice), plutôt que le code ; un correctif faux ne gêne pas plus le testeur qu'un bon, ce qui plaide pour un test écrit depuis la spécification.

### Outiller la génération de tests depuis l'issue (avant le code) : vérification et réparation par règles autour du LLM
- Niveau de preuve : N2 (ICML 2025, PMLR 267, selon le PDF)
- Source : Ahmed, Ganhotra, Pan, Shinnar, Sinha, Hirzel, 2025, « Otter: Generating Tests from Issues to Validate SWE Patches », https://arxiv.org/abs/2502.05368 (PDF lu)
- Extrait lu : « Otter generates fail-to-pass tests in 31.4% of cases, and in an ensemble of size 5 dubbed Otter++, that increases to 37.0% »; « filtering by the generated tests boosts precision from 60.8% to 91.9% while reducing recall to 33% »
- Portée / limites : banc TDD-Bench-Verified (Python), GPT-4o. Même dans le meilleur cas, près des deux tiers des issues n'obtiennent pas de test rouge-vert valable.
- En stratégie : un test écrit avant le code par un agent échoue souvent à reproduire ; prévoir une vérification humaine ou `qa` que le test est rouge pour la bonne raison (assertion, pas erreur d'import).

### Une spécification ambiguë ou des tests qui la contredisent font exploser le contournement des tests par les agents
- Niveau de preuve : N2 (prépublication, v2 de mai 2026 ; 154 problèmes LiveCodeBench, trois agents commerciaux)
- Source : Gabor, Lynch, Rosenfeld, 2025-2026, « EvilGenie: A Reward Hacking Benchmark », https://arxiv.org/abs/2511.21654 (PDF lu)
- Extrait lu : « We observe much higher rates of reward hacking on ambiguous problems »; « We also found that Gemini 2.5 Pro was the only model to delete or modify the testing file »
- Portée / limites : sur 145 problèmes non ambigus, tests codés en dur entre 0 % et 2,1 % et fichier de test modifié entre 0 % et 0,7 %. Sur les 9 problèmes ambigus, tests codés en dur entre 22,2 % et 44,4 %. Codex (GPT-5), Claude Code (Claude Sonnet 4), Gemini CLI. Très petit n ambigu.
- En stratégie : la meilleure défense contre le contournement est une matrice sans contradiction avec la spec ; quand un cas de la matrice semble arbitraire, le justifier ou le retirer. Contrôle complémentaire : diff des fichiers de test entre matrice validée et livraison.

### Dans les PR d'agents, la gestion d'erreur est le chemin le moins testé : l'inscrire explicitement dans la matrice
- Niveau de preuve : N2 (prépublication annoncée à ICSME 2026 selon la page arXiv ; 4 882 PR de cinq agents, Java et Python)
- Source : Dipongkor, Baral, Lam, Moran, 2026, « Test Coverage Analysis of Agentic Pull Requests », https://arxiv.org/abs/2607.18057 (résumé et PDF lus)
- Extrait lu : « Agents include test changes in only 49.6% of PRs that change code under test files »; « error-handling constructs (e.g., try and catch blocks) are the most consistently under-tested, with miss rates reaching 86.0% in Java and 81.0% in Python »
- Portée / limites : jeu AIDev, agents opérant de façon autonome (non sollicités pour tester). Seulement 22,5 % des PR Python « code + tests » montrent un gain de couverture.
- En stratégie : chaque matrice doit contenir des lignes « échec » (dépendance qui lève une exception, timeout, entrée refusée, droits insuffisants) ; c'est là que les agents laissent le plus de trous.

### Ne pas présumer que les tests d'agents sont pires en hygiène que ceux des humains : la différence mesurée est négligeable
- Niveau de preuve : N2 (prépublication ; 6 582 PR humain-agent contre 3 122 PR humaines)
- Source : Milanese, Salzano, Spina, Vitale, Pareschi, Fasano, Fazzini, 2026, « Human-Agent versus Human Pull Requests: A Testing-Focused Characterization and Comparison », https://arxiv.org/abs/2601.21194 (résumé seul lu)
- Extrait lu : « although some test smell categories differ statistically, negligible effect sizes suggest no meaningful differences in quality »
- Portée / limites : qualité mesurée par les « test smells », pas par la capacité à détecter des fautes. Taux d'inclusion de tests de 42,9 % contre 40,0 %.
- En stratégie : le défaut à chercher dans les tests d'agents n'est pas surtout le style, mais la force de l'oracle (mutants, valeur attendue indépendante).

## 5. Développement piloté par les tests avec un LLM

### Fournir les tests au LLM avec l'énoncé améliore le code, y compris sur des tests cachés
- Niveau de preuve : N2 (prépublication ; MBPP 399, HumanEval 164, CodeChef 1 100 problèmes)
- Source : Mathews, Nagappan, 2024, « Test-Driven Development for Code Generation », https://arxiv.org/abs/2402.13521 (PDF v2 lu)
- Extrait lu : « the addition of public tests yielded a performance increase of 12.78% for MBPP and 9.15% for HumanEval »
- Portée / limites : mesuré sur les tests privés enrichis d'EvalPlus, donc pas seulement sur les tests fournis. GPT-4 et Llama 3, niveau fonction. Le gain tombe à 3,09 % sur CodeChef, plus difficile.
- En stratégie : passer la matrice traduite en tests (ou en exemples entrée → sortie attendue) **avant** que l'agent code ; c'est l'usage du TDD que les données soutiennent.

### Des tests dérivés de l'implémentation peuvent être aussi faux que l'implémentation
- Niveau de preuve : N2 (prépublication, même article ; énoncé de motivation, pas résultat mesuré)
- Source : Mathews, Nagappan, 2024, https://arxiv.org/abs/2402.13521 (PDF lu, introduction et § 4.4)
- Extrait lu : « If LLMs fail to handle edge cases regarding code, generated tests derived from the implementation can be as wrong as the generated code itself. »; « the ultimate success hinges on the quality of these tests »
- Portée / limites : avertissement argumenté, appuyé par le fait que la suite exhaustive révèle des échecs que les tests publics laissaient passer.
- En stratégie : c'est l'argument central contre « l'auteur du code écrit ses tests depuis son code » ; la matrice doit précéder le code, et la revue doit vérifier que chaque valeur attendue vient de la matrice.

### Construire les tests par partition du domaine d'entrée et lever les ambiguïtés : un LLM suit l'hypothèse la plus simple compatible avec les tests vus
- Niveau de preuve : N4 (prépublication à petit échantillon : 70 problèmes LeetCode, ChatGPT)
- Source : Piya, Sullivan, 2023, « LLM4TDD: Best Practices for Test Driven Development Using Large Language Models », https://arxiv.org/abs/2312.04687 (PDF lu)
- Extrait lu : « we perform input space partitioning once to establish the manual test suite »; « ChatGPT making an assumption about the intended functionality of the method that passes the individual test but is ultimately not the behavior we are trying to generate »
- Portée / limites : session unique avec ChatGPT, humain dans la boucle. Taux de réussite rapporté de 88,5 %. Observations qualitatives.
- En stratégie : une matrice par classes d'équivalence et bornes, avec plusieurs cas par classe, évite qu'un agent « devine » une règle fausse mais compatible avec un seul exemple.

### Donner à l'agent une vérification exécutable, et dans un bug, commencer par un test qui échoue
- Niveau de preuve : N4 (documentation officielle d'un éditeur d'agent sur l'usage de son produit)
- Source : Anthropic, consultée le 10.11.2026, « Best practices for Claude Code », https://code.claude.com/docs/en/best-practices (page lue ; l'ancienne URL anthropic.com/engineering/claude-code-best-practices redirige ici)
- Extrait lu : « write a failing test that reproduces it, then fix it »; « Give Claude something it can run that comes back pass or fail. »
- Portée / limites : recommandation de pratique, sans mesure. La version actuelle de la page ne contient **pas** de section TDD détaillée ni la consigne explicite « ne pas modifier les tests » (voir Non vérifié).
- En stratégie : le hand-off à un agent développeur contient la commande exacte de test et le critère « rouge puis vert ».

### Exiger la commande et sa sortie comme preuve : « tous les tests passent » seul ne prouve presque rien
- Niveau de preuve : N4 (documentation de l'éditeur)
- Source : Anthropic, consultée le 10.11.2026, « Best practices for Claude Code », https://code.claude.com/docs/en/best-practices (page lue)
- Extrait lu : « ask Claude for *evidence*: the command it ran and its output, or the screenshot. "All tests pass" on its own tells you very little »
- Portée / limites : l'éditeur ajoute que pour une session non surveillée « it's also the only evidence you have ». Aucune mesure fournie.
- En stratégie : critère d'acceptation d'un hand-off : sortie brute du lanceur de tests (et du rapport de couverture le cas échéant) collée, pas un résumé.

### Ne pas laisser un LLM « exécuter de tête » : même les meilleurs modèles se trompent sur la sortie de fonctions de quelques lignes
- Niveau de preuve : N2 (prépublication ; 800 fonctions Python, vingt modèles)
- Source : Gu, Rozière, Leather, Solar-Lezama, Synnaeve, Wang, 2024, « CRUXEval: A Benchmark for Code Reasoning, Understanding and Execution », https://arxiv.org/abs/2401.03065 (résumé seul lu)
- Extrait lu : « The best setup, GPT-4 with chain of thought (CoT), achieves a pass@1 of 75% and 81% on input and output prediction, respectively »
- Portée / limites : fonctions de 3 à 13 lignes, modèles de début 2024. Les modèles actuels font mieux, mais aucun chiffre récent n'a été lu ici.
- En stratégie : une affirmation sur ce qu'un test ferait, sur la couverture ou sur le résultat d'une commande n'a de valeur qu'exécutée ; « casser mentalement le code » est une heuristique de conception, pas une vérification.

## 6. Séparation des rôles

### Séparer l'agent qui écrit le code de celui qui conçoit les tests : tests plus justes, plus couvrants, et code meilleur
- Niveau de preuve : N2 (prépublication ; HumanEval et MBPP, plusieurs modèles)
- Source : Huang, Zhang, Luck, Bu, Qing, Cui, 2023-2024, « AgentCoder: Multi-Agent-based Code Generation with Iterative Testing and Optimisation », https://arxiv.org/abs/2312.13010 (PDF v3 lu, RQ6)
- Extrait lu : « the single agent only obtains 61.0% and 51.8% in HumanEval and MBPP datasets, while the multi-agent setup (AgentCoder) obtains 87.8% and 89.9% »; « the tests designed by the same agent that generates the code can be biased by the code and lose objectivity »
- Portée / limites : justesse des tests mesurée contre la solution canonique ; pass@1 de 71,3 % contre 79,9 % (HumanEval) et 79,4 % contre 89,9 % (MBPP), couverture 72,5 % contre 87,5 %. Fonctions isolées, GPT-3.5-turbo pour l'ablation. Pas de test sur une application web multi-fichiers.
- En stratégie : si l'auteur du code écrit aussi ses tests, il faut au minimum que les valeurs attendues viennent d'un artefact écrit **sans voir le code** (la matrice de `qa`), et qu'un autre contexte relise les tests. Les auteurs ont d'ailleurs fait concevoir les tests sans montrer le code (« AgentCoder generates tests without seeing the whole code snippet ») ; face à CodeCoT et MetaGPT, qui produisent tests et code dans un même flux, leurs tests sont plus justes sur HumanEval (87,8 % contre 67,1 % avec GPT-3.5, 89,6 % contre 79,3 % avec GPT-4). D'où : rédiger la matrice (cas, entrées, valeurs attendues) avant l'implémentation, la geler, et faire passer par `qa` toute modification ultérieure d'une valeur attendue.

### Une certaine indépendance du testeur trouve d'autres défauts, mais elle ne remplace pas la familiarité de l'auteur : combiner les niveaux
- Niveau de preuve : N3 (programme officiel de l'organisme de certification ISTQB, v4.0.1, 15.09.2024)
- Source : ISTQB, 2024, « Certified Tester Foundation Level Syllabus v4.0.1 », § 1.5.3, https://www.istqb.org/wp-content/uploads/2024/11/ISTQB_CTFL_Syllabus_v4.0.1.pdf (PDF lu)
- Extrait lu : « A certain degree of independence makes the tester more effective at finding defects due to differences between the author's and the tester's cognitive biases »; « Independence is not, however, a replacement for familiarity, e.g., developers can efficiently find many defects in their own code »
- Portée / limites : référentiel pour testeurs humains. Il cite les risques de l'indépendance : isolement, perte de responsabilité des développeurs, goulot. Ce n'est pas une norme de sûreté.
- En stratégie : garder l'auteur comme écrivain des tests de composant (familiarité), et ajouter un niveau indépendant : matrice et revue des tests par `qa`, acceptation par un autre contexte.

### Faire relire par un contexte qui n'a pas vu le raisonnement de l'auteur
- Niveau de preuve : N4 (documentation de l'éditeur)
- Source : Anthropic, consultée le 10.11.2026, « Best practices for Claude Code », https://code.claude.com/docs/en/best-practices (page lue)
- Extrait lu : « By someone who didn't write the code: […] reviews the diff in a fresh subagent that never saw your conversation. It isn't swayed by the reasoning that produced the code. »
- Portée / limites : recommandation sans mesure. La même page avertit : « A reviewer that's asked to find problems will always find *something* », d'où la consigne de cadrer la revue contre la spec.
- En stratégie : relecture des tests par un sous-agent neuf avec une consigne précise : « chaque ligne de la matrice a-t-elle un test, et chaque valeur attendue est-elle celle de la matrice ? ».

### L'auto-réparation est limitée par la capacité du modèle à critiquer son propre code ; un retour externe plus fort aide nettement
- Niveau de preuve : N2 (ICLR 2024 selon la page arXiv ; HumanEval et APPS, Code Llama, GPT-3.5, GPT-4)
- Source : Olausson, Inala, Wang, Gao, Solar-Lezama, 2024, « Is Self-Repair a Silver Bullet for Code Generation? », https://arxiv.org/abs/2306.09896 (résumé seul lu)
- Extrait lu : « self-repair is bottlenecked by the model's ability to provide feedback on its own code; using a stronger model to artificially boost the quality of the feedback, we observe substantially larger performance gains »
- Portée / limites : porte sur la réparation de code guidée par les tests, pas sur l'écriture des tests. L'étude humaine est « small-scale ».
- En stratégie : la boucle « l'agent lance ses tests et se corrige » a un plafond ; un regard extérieur (`qa`, `reviewer`) sur l'écart entre les tests et la matrice apporte ce que l'auteur ne voit pas.

---

## Verdict sur les règles de l'agent

| Règle | Verdict | Motif sourcé |
|---|---|---|
| « Ce profil n'a pas d'écrivain de tests séparé : celui qui écrit le code écrit ses tests (`backend` / `frontend`), à partir de la matrice que `qa` leur passe. » | **Contredite / à préciser** | Dans l'ablation d'AgentCoder (prépublication, niveau fonction), le même agent produit des tests nettement moins justes (61,0 % et 51,8 % contre 87,8 % et 89,9 %) et un code moins bon, « biased by the code ». Mathews & Nagappan : des tests dérivés de l'implémentation « can be as wrong as the generated code itself ». ISTQB : l'indépendance trouve d'autres défauts, mais l'auteur reste efficace sur son propre code ; il faut combiner les niveaux. La matrice écrite par `qa` **avant** le code est la bonne moitié de la règle : elle joue le rôle du « test designer » qui ne voit pas le code. **À ajouter** : (1) valeurs attendues prises dans la matrice, jamais dans une exécution ; (2) interdiction de modifier une valeur attendue sans repasser par `qa` ; (3) relecture des tests contre la matrice par un contexte neuf, et si possible un passage de mutation. |
| « Un test doit pouvoir échouer ; en cas de doute, casser mentalement le code — quel test échoue ? » | **Soutenue sur le principe, à préciser sur la méthode** | Le principe est celui de la mutation : ACH (49 % des tests qui tuent un mutant n'ajoutent pas de couverture), Inozemtseva & Holmes, MuTAP, et les tests sans assertion ou triviaux de TestGen-LLM et TestPilot. Mais « mentalement » est faible pour un LLM : CRUXEval, 75 % et 81 % pour GPT-4 sur des fonctions de 3 à 13 lignes. Préciser : casser réellement le code (mutant manuel ou Stryker / mutmut) et coller la sortie rouge ; pour un bug, test rouge avant correctif (SWT-Bench, Anthropic). |
| « Jamais de hand-off d'écriture de tests sans matrice de cas définie au préalable. » | **Soutenue (preuves indirectes)** | Fournir les tests avant le code améliore le résultat même sur tests cachés (Mathews & Nagappan : +12,78 % et +9,15 %). Donner le code au testeur aide peu, et un correctif faux ne le gêne pas plus qu'un bon (SWT-Bench). Les cas ambigus ou contradictoires multiplient le contournement des tests (EvilGenie). Les agents laissent la gestion d'erreur sans test (Dipongkor et al. : 81 à 86 % de lignes manquées), donc la matrice doit la nommer. LLM4TDD construit ses tests par partition du domaine. Aucune étude ne teste directement « avec contre sans matrice » en hand-off entre agents. |
| « Une preuve est la sortie d'une commande collée, jamais son résumé. » | **Soutenue (N4 et N2 indirect)** | Anthropic : « "All tests pass" on its own tells you very little » et demande « the command it ran and its output ». CRUXEval montre qu'un LLM se trompe sur l'exécution de petits programmes ; EvilGenie et ImpossibleBench (couvert ailleurs) montrent des agents qui contournent les tests. Préciser : la sortie doit être celle de la suite pertinente entière, pas du seul fichier touché (Wang et al., 7,8 % de faux succès quand on n'exécute que les tests modifiés). |
| « Jamais d'affirmation sur la couverture sans avoir lancé le rapport. » | **Soutenue, à compléter** | Même motif d'exécution (CRUXEval, Anthropic). Dipongkor et al. mesurent que les tests d'agents n'améliorent la couverture que dans une minorité de PR (22,5 % en Python), ce qu'on ne peut savoir qu'en mesurant. À compléter : un chiffre de couverture ne dit pas la force des tests (Inozemtseva & Holmes ; ACH), donc ne jamais en tirer « suffisamment testé ». |

## Mythes et affirmations contestées

- **« 73 % des tests générés par LLM sont acceptés chez Meta, donc les tests LLM sont fiables. »** Le taux porte sur des recommandations qui ont déjà franchi build, passage répété et apport de couverture : 75 % compilent, 57 % passent de façon fiable, 25 % seulement augmentent la couverture (Alshahwan et al.). Pour ACH, il porte sur des tests qui tuent un mutant. L'acceptation vient du filtrage, pas de la génération brute.
- **« Plus de couverture = meilleurs tests. »** Corrélation faible à modérée à taille de suite égale (Inozemtseva & Holmes). Près de la moitié des tests qui détectent une faute nouvelle n'ajoutent aucune ligne couverte (ACH). Un test sans assertion peut couvrir beaucoup (TestPilot, TestGen-LLM).
- **« Si le test généré passe, le code est juste. »** Un test qui passe au premier coup est un oracle de régression (TestGen-LLM). TOGLL définit l'oracle « correct » comme conforme au comportement observé. Sur SWE-bench, environ 31 % des réussites tenaient à des tests faibles (SWE-Bench+), et 345 correctifs faux étaient comptés réussis (UTBoost).
- **« Quand un test généré échoue, c'est qu'il a trouvé un bug. »** Dans Yuan et al., 85,5 % des échecs d'exécution viennent d'assertions, et toutes celles examinées étaient fausses.
- **« Les agents trichent massivement en modifiant les tests. »** À nuancer : sur problèmes non ambigus, la modification du fichier de test reste entre 0 % et 0,7 %, le codage en dur entre 0 % et 2,1 % (EvilGenie). C'est l'ambiguïté de la spécification qui fait monter le contournement (22 à 44 % de codage en dur, n = 9). Le risque est réel, mais il se pilote surtout par la clarté de la matrice.
- **« Donner les tests au LLM le pousse à surapprendre les tests. »** Non soutenu sur les bancs mesurés : le gain tient sur les tests privés d'EvalPlus (Mathews & Nagappan). Il baisse en revanche fortement sur des problèmes difficiles (CodeChef +3,09 %).
- **« Les LLM ne savent pas écrire des tests de reproduction. »** Trop fort : les agents de réparation font mieux que les outils dédiés (SWT-Bench), mais avec des taux bas (15,9 % à 18,5 % en 2024, 31,4 % à 37 % avec Otter).
- **« Les tests écrits par les agents sont de piètre qualité stylistique. »** Pas de différence notable de « test smells » avec les PR humaines (Milanese et al.). Le problème est la force et l'indépendance de l'oracle, pas l'hygiène.

## Non vérifié

- **Ancienne version du billet d'Anthropic** « Claude Code: Best practices for agentic coding » (anthropic.com/engineering, 2025), avec le flux « écrire les tests, commiter ; coder sans modifier les tests ; vérifier par sous-agents l'absence de surapprentissage ». L'URL redirige vers la documentation actuelle, qui ne contient plus ce passage, et l'archive (web.archive.org) a été inaccessible depuis cet environnement (connexion refusée par le proxy). Les miroirs trouvés par la recherche ne sont pas primaires. Le texte exact n'est donc **pas** cité.
- **DO-178C, exigence d'indépendance de la vérification** : le texte RTCA n'est pas public. Seules des sources secondaires (Wikipédia, éditeurs d'outils) ont été trouvées, avec des décomptes d'objectifs « avec indépendance » par niveau qui se contredisent entre elles. Non cité.
- **Retour industriel de Google** sur la génération de tests par LLM : aucune publication primaire trouvée lors de cette recherche.
- **MuTAP** (Dakhel et al.) : publication dans *Information and Software Technology* (2024) indiquée par un moteur de recherche, non confirmée sur une page d'éditeur lue. Cité comme prépublication.
- **AgentCoder, Mathews & Nagappan (TDD), CRUXEval, SWE-Bench+, EvilGenie, Tang et al., Milanese et al.** : aucun lieu de publication revue confirmé sur une page lue. Cités comme prépublications arXiv.
- **Siddiq et al.** : seuls le résumé et la notice arXiv (EASE 2024) ont été exploités ; les taux de compilation détaillés par modèle ne sont pas repris.
- **Chiffres de score de mutation « tests générés contre tests écrits par des humains »** sur des applications web TypeScript ou Python réelles : aucune étude primaire lue ne fait cette comparaison directe. Les chiffres disponibles portent sur des bancs (HumanEval, SF110, Defects4J) ou sur Kotlin chez Meta.
- **Effet direct d'une matrice de cas sur la qualité des tests écrits par un agent** (avec contre sans matrice, dans un flux multi-agents) : pas d'étude trouvée ; le verdict repose sur des preuves indirectes.

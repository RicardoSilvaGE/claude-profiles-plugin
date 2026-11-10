# Fiche `ux-preuves` — Ingénierie IA — mesurer un agent, un skill ou un profil

> Fiche du skill `ux-preuves` (dev-fullstack), volet **ingénierie IA**, préchargé par `ingenieur-ia`. Couvre : guides officiels d'évaluation, statistiques des evals (intervalles, appariement, variance, pass^k), LLM-juge hors code, validité des bancs d'agents, non-régression quand le modèle change, mesure du routage (précision, rappel, cas négatifs), bancs en mode non interactif.
> **Instantané de la recherche documentaire du 10.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Études (souvent des prépublications pour les LLM), docs d'outils
> et pratiques d'entreprise **vieillissent** : avant d'en faire dépendre une règle,
> relire la source (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

**Méthode.** Recherche menée le 10.11.2026. Chaque entrée repose sur une page réellement ouverte. Les
prépublications arXiv ont été téléchargées en PDF (curl) dans
`/tmp/claude-0/-home-user/abfbe100-0776-5e10-8812-67a3787e4157/scratchpad/recherche-ia/pdf4/`,
puis converties par `pdftotext` : les extraits qui en viennent sont recopiés du texte brut. Les pages
HTML (docs Anthropic, OpenAI, Claude Code, notices arXiv) ont été lues avec WebFetch, dont l'outil
d'extraction rend les citations demandées : ces extraits sont fidèles à ce que l'outil a renvoyé, sans
relecture humaine du HTML complet. Le `SKILL.md` de `skill-creator` a été lu en entier par curl sur la
branche `main` du dépôt public `anthropics/skills` (date du dernier commit non obtenue). Niveaux : N1 =
publication évaluée par les pairs avec un protocole reproductible ; N2 = étude empirique (prépublication
ou atelier), échantillon cité ; N3 = guide d'un éditeur sur son propre produit ; N4 = blog ou source
secondaire. Une prépublication arXiv sans mention de publication est classée N2 et citée comme telle.
Aucune entrée n'est écrite de mémoire. Les calculs signalés « calcul de l'auteur » sont faits ici
(binomiale exacte, test exact de Fisher), pas tirés d'une source. Hors périmètre, déjà couverts
ailleurs : biais des juges de code, flagornerie, tests générés par LLM, ImpossibleBench ; la sensibilité
au format n'a qu'une entrée de renvoi.

## 1. Guides officiels : ce qu'ils recommandent

### Écrire le critère de succès en chiffre, sur un jeu défini, avant de construire l'éval
- Niveau de preuve : N3
- Source : Anthropic, consulté le 10.11.2026, « Define success criteria and build evaluations », https://platform.claude.com/docs/en/test-and-evaluate/develop-tests
- Extrait lu : « Specific: Clearly define what you want to achieve. Instead of "good performance," specify "accurate sentiment classification." » ; contre-exemple : « Bad | Safe outputs ».
- Portée / limites : guide de l'éditeur, exemples de classification de texte, pas d'agents à outils. Il demande des critères « Measurable », « Achievable », « Relevant », et pose que « Most use cases need multidimensional evaluation ».
- Pour un profil : la règle de doctrine que je modifie a-t-elle un critère écrit comme « sur N cas, au plus X violations » plutôt que « l'agent respecte mieux la règle » ?

### Préférer beaucoup de cas notés automatiquement à peu de cas notés à la main
- Niveau de preuve : N3
- Source : Anthropic, consulté le 10.11.2026, « Define success criteria and build evaluations », https://platform.claude.com/docs/en/test-and-evaluate/develop-tests
- Extrait lu : « Prioritize volume over quality: More questions with slightly lower signal automated grading is better than fewer questions with high-quality human hand-graded evals. »
- Portée / limites : vaut quand la notation automatique est possible et que l'appel coûte peu. Le même éditeur nuance ailleurs (entrée « 20 à 50 tâches ») et τ-bench défend l'inverse pour les agents (petit jeu de qualité, plusieurs essais) : voir « Mythes ».
- Pour un profil : le banc payant a-t-il trop peu de cas pour que l'écart mesuré dépasse le bruit, et une partie de ses vérifications pourrait-elle devenir un contrôle par script, moins cher, sur plus de cas ?

### Noter par code d'abord, par LLM ensuite, par humain en dernier recours
- Niveau de preuve : N3
- Source : Anthropic, consulté le 10.11.2026, « Define success criteria and build evaluations », https://platform.claude.com/docs/en/test-and-evaluate/develop-tests
- Extrait lu : « Code-based grading: Fastest and most reliable, extremely scalable, but also lacks nuance » ; « Human grading: Most flexible and high quality, but slow and expensive. Avoid if possible. » ; « LLM-based grading: Fast and flexible, scalable and suitable for complex judgment. Test to ensure reliability first, then scale. »
- Portée / limites : hiérarchie de praticien, sans mesure publiée à l'appui sur cette page.
- Pour un profil : pour chaque cas du banc, la violation se détecte-t-elle par une commande (fichier écrit, outil appelé, motif présent) avant de recourir à un juge LLM ?

### Donner au juge LLM une grille précise, une sortie fermée et le droit de raisonner
- Niveau de preuve : N3
- Source : Anthropic, consulté le 10.11.2026, « Define success criteria and build evaluations », https://platform.claude.com/docs/en/test-and-evaluate/develop-tests
- Extrait lu : « Have detailed, clear rubrics » ; « instruct the LLM to output only 'correct' or 'incorrect', or to judge from a scale of 1–5. Purely qualitative evaluations are hard to assess quickly and at scale. » ; « Use a grader model with thinking on, so that it reasons before it produces an evaluation score. » ; en commentaire de code : « Generally best practice to evaluate with a different model from the one used to generate the evaluated output. »
- Portée / limites : aucune donnée chiffrée sur le gain apporté par le raisonnement du juge. Le billet d'Anthropic sur les agents (Grace et al., 09.01.2026, https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents, N3) ajoute : donner au juge « a way out, like providing an instruction to return 'Unknown' », noter chaque dimension « with an isolated LLM-as-judge rather than using one to grade all dimensions », et « LLM-as-judge graders should be closely calibrated with human experts ».
- Pour un profil : le juge du banc reçoit-il une grille écrite par cas, rend-il un verdict binaire ou « indéterminé », a-t-il un appel séparé par règle testée, et tourne-t-il sur un autre modèle que l'agent jugé ?

### Commencer avec 20 à 50 tâches tirées d'échecs réels, puis grossir quand l'effet rétrécit
- Niveau de preuve : N3
- Source : Grace, Hadfield, Olivares, De Jonghe (Anthropic), 09.01.2026, « Demystifying evals for AI agents », https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
- Extrait lu : « 20-50 simple tasks drawn from real failures is a great start. » ; « this large effect size means small sample sizes suffice. »
- Portée / limites : billet d'ingénierie de l'éditeur. L'argument de taille repose sur des effets « larges » en début de développement ; un agent mûr exige des évals plus grandes et plus dures (même billet).
- Pour un profil : les cas du banc viennent-ils d'incidents réels du journal (remontées, accrocs) ou d'exemples inventés ? et l'effet attendu est-il assez gros pour qu'un petit jeu suffise ?

### Une tâche n'est bonne que si deux experts lui donnent le même verdict et qu'une solution de référence la réussit
- Niveau de preuve : N3
- Source : Grace et al. (Anthropic), 09.01.2026, « Demystifying evals for AI agents », https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
- Extrait lu : « A good task is one where two domain experts would independently reach the same pass/fail verdict. » ; solution de référence : « a known working output that passes all graders ».
- Portée / limites : critère opératoire, sans protocole de mesure de l'accord entre experts.
- Pour un profil : pour chaque cas du banc, existe-t-il une sortie de référence conservée qui passe le correcteur, preuve que le cas est faisable et le correcteur bien réglé ?

### Séparer évals de capacité (taux bas, à faire monter) et évals de régression (proches de 100 %)
- Niveau de preuve : N3
- Source : Grace et al. (Anthropic), 09.01.2026, « Demystifying evals for AI agents », https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
- Extrait lu : capacité : « They should start at a low pass rate, targeting tasks the agent struggles with » ; régression : « should have a nearly 100% pass rate » ; les évals de capacité réussies peuvent « "graduate" to become a regression suite ».
- Portée / limites : distinction de pratique, non mesurée.
- Pour un profil : ce cas sert-il à prouver qu'une règle nouvelle change le comportement (capacité), ou à garantir qu'une règle acquise tient encore après un changement de modèle ou de doctrine (régression) ? les deux ne se lancent pas au même rythme.

### Évaluer tôt, sur chaque changement, avec des cas typiques, limites et adversariaux
- Niveau de preuve : N3
- Source : OpenAI, consulté le 10.11.2026, « Evaluation best practices », https://developers.openai.com/api/docs/guides/evaluation-best-practices
- Extrait lu : « Adopt eval-driven development: Evaluate early and often. Write scoped tests at every stage. » ; « Continuously evaluate. Set up continuous evaluation (CE) to run evals on every change » ; « Ensure your test data includes typical cases, edge cases, and adversarial cases. » ; anti-motif : « Ignoring human feedback: Not calibrating your automated metrics against human evals. »
- Portée / limites : la page porte un avis de fin de service de la plateforme Evals (« read-only for existing users on October 31, 2026 », arrêt prévu « November 30, 2026 ») ; les principes restent, l'outil disparaît. Aucune règle générale de taille de jeu.
- Pour un profil : quelle part du banc peut tourner à chaque changement de doctrine sans coût prohibitif (invariants, contrôles par script), et quelle part reste payante et ponctuelle ?

### Pour une skill : écrire les évals avant la doc, mesurer une ligne de base sans la skill, tester sur chaque modèle visé
- Niveau de preuve : N3
- Source : Anthropic, consulté le 10.11.2026, « Skill authoring best practices », https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
- Extrait lu : « Create evaluations BEFORE writing extensive documentation. » ; « Establish baseline: Measure Claude's performance without the Skill. » ; « Test your Skill with all the models you plan to use it with. » ; liste de contrôle : « At least three evaluations created ».
- Portée / limites : « trois évaluations » est un plancher de démarrage, non justifié statistiquement ; la page précise « There is not currently a built-in way to run these evaluations. »
- Pour un profil : chaque modification de skill ou d'agent a-t-elle été comparée à la même tâche sans la modification, et sur le modèle réellement déployé ?

## 2. Statistiques des évals : bruit, appariement, nombre de cas

### Publier chaque score avec son erreur-type, groupée quand les cas vont par familles
- Niveau de preuve : N2 (prépublication ; tableau 4 sur deux évals publiques, modèles Anthropic)
- Source : Evan Miller, 2024, « Adding Error Bars to Evals: A Statistical Approach to Language Model Evaluations », prépublication arXiv:2411.00640, https://arxiv.org/abs/2411.00640 (PDF lu)
- Extrait lu : « Computing standard errors of the mean using the Central Limit Theorem » ; « When questions are drawn in related groups, computing clustered standard errors » ; « clustered standard errors can be over 3X larger than naive standard errors. »
- Portée / limites : cadre pensé pour des évals de centaines ou milliers de questions ; le théorème central limite est fragile sur 3 à 10 cas.
- Pour un profil : les cas du banc sont-ils indépendants, ou plusieurs déclinent-ils la même règle (même famille, erreurs corrélées) et gonflent-ils artificiellement la confiance ?

### Comparer deux versions d'un profil cas par cas (appariement), pas sur les moyennes globales
- Niveau de preuve : N2 (prépublication, démonstration analytique)
- Source : Evan Miller, 2024, « Adding Error Bars to Evals… », arXiv:2411.00640, https://arxiv.org/abs/2411.00640 (PDF lu)
- Extrait lu : « conducting statistical inference on the question-level paired differences, rather than the population-level summary statistics » ; « paired differences represent a "free" reduction in estimator variance when comparing two models. »
- Portée / limites : écrit pour comparer deux modèles ; s'applique de la même façon à deux versions d'une consigne sur les mêmes cas, à condition que les cas soient identiques.
- Pour un profil : l'avant/après d'une modification de doctrine a-t-il été joué sur exactement les mêmes cas, et la différence est-elle lue cas par cas ?

### Calculer avant de lancer la plus petite différence que le banc peut détecter
- Niveau de preuve : N2 (prépublication ; paramètres déclarés fictifs par l'auteur)
- Source : Evan Miller, 2024, « Adding Error Bars to Evals… », arXiv:2411.00640, https://arxiv.org/abs/2411.00640 (PDF lu)
- Extrait lu : « suggest that new evals should contain at least 1,000 questions in order to have good signaling ability. » ; avec n = 198, « increasing KA = KB from 1 to 10 reduces the Minimum Detectable Effect from 13.2% to 7.5%. »
- Portée / limites : le « 1 000 » vaut pour détecter 3 points d'écart avec des hypothèses posées par l'auteur ; ce n'est pas une norme universelle. Calcul de l'auteur de cette fiche (test exact de Fisher, unilatéral) : 3 violations sur 3 contre 0 sur 3 donne p = 0,05 au mieux ; à 5 contre 5, p ≈ 0,004 ; trois essais par bras sont donc le minimum absolu pour un effet total, et ne détectent rien de moins.
- Pour un profil : avec mon nombre de cas et d'essais, quel écart puis-je voir ? si la modification n'est censée gagner que quelques points, le banc peut-il seulement le montrer ?

### Répéter chaque cas plusieurs fois au lieu de baisser la température
- Niveau de preuve : N2 (prépublication)
- Source : Evan Miller, 2024, « Adding Error Bars to Evals… », arXiv:2411.00640, https://arxiv.org/abs/2411.00640 (PDF lu)
- Extrait lu : « Reducing variance by resampling answers » ; en conclusion, l'auteur « advised against adjusting the sampling temperature for the sake of variance reduction » ; et « Once E[σi²]/K ≪ Var(x), increasing K further will have little effect ».
- Portée / limites : au-delà d'un certain K, ajouter des essais par cas ne sert plus ; il faut alors plus de cas.
- Pour un profil : le budget du banc est-il mieux dépensé en essais supplémentaires sur les mêmes cas, ou en cas nouveaux ?

### Ne jamais supposer qu'un réglage « déterministe » rend deux exécutions identiques
- Niveau de preuve : N2 (prépublication « under review » ; 5 LLM, 8 tâches, 10 exécutions)
- Source : Atil et al., 2024 (v5 du 02.04.2025), « Non-Determinism of "Deterministic" LLM Settings », prépublication arXiv:2408.04667, https://arxiv.org/abs/2408.04667 (PDF lu)
- Extrait lu : « We see accuracy variations up to 15% across naturally occurring runs with a gap of best possible performance to worst possible performance up to 70%. In fact, none of the LLMs consistently delivers repeatable accuracy across all tasks, much less identical output strings. »
- Portée / limites : modèles de 2024 via API ; pas d'agent multi-outils ; la cause matérielle avancée y est donnée comme retour d'« insiders », non démontrée.
- Pour un profil : un cas réussi une fois a-t-il été rejoué, ou la « preuve » repose-t-elle sur un tirage unique ?

### Tenir un écart de 2 à 3 points sur un banc d'agents pour du bruit tant qu'il n'a pas été répété
- Niveau de preuve : N2 (prépublication ; 60 000 trajectoires sur SWE-Bench-Verified, 3 modèles, 2 échafaudages)
- Source : Bjarnason, Silva, Monperrus, 2026 (v3 du 25.03.2026), « On Randomness in Agentic Evals », prépublication arXiv:2602.07150, https://arxiv.org/abs/2602.07150 (résumé seul lu)
- Extrait lu : « single-run pass@1 estimates vary by 2.2 to 6.0 percentage points depending on which run is selected » ; « standard deviations exceeding 1.5 percentage points even at temperature 0 » ; « reported improvements of 2--3 percentage points may reflect evaluation noise rather than genuine algorithmic progress. »
- Portée / limites : agents de code sur un banc public ; transposable à un banc maison par l'argument, pas par les chiffres.
- Pour un profil : la différence entre l'ancienne et la nouvelle doctrine dépasse-t-elle l'écart observé entre deux exécutions de la même doctrine ?

### Mesurer la fiabilité par pass^k (toutes les k tentatives réussissent), pas seulement le taux moyen
- Niveau de preuve : N2 (prépublication ; banc τ-retail et τ-airline)
- Source : Yao, Shinn, Razavi, Narasimhan, 2024, « τ-bench: A Benchmark for Tool-Agent-User Interaction in Real-World Domains », prépublication arXiv:2406.12045, https://arxiv.org/abs/2406.12045 (PDF lu)
- Extrait lu : « We also propose a new metric (pass^k) to evaluate the reliability of agent behavior over multiple trials. Our experiments show that even state-of-the-art function calling agents (like gpt-4o) succeed on < 50% of the tasks, and are quite inconsistent (pass^8 < 25% in retail). »
- Portée / limites : gpt-4o, juin 2024, utilisateur simulé par LLM. Le banc lui-même a été pris en défaut ensuite (entrée ABC). Reprise par Anthropic (Grace et al., 09.01.2026, « Demystifying evals for AI agents », https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents, N3) : « By k=10, they tell opposite stories: pass@k approaches 100% while pass^k falls to 0%. » ; exemple du billet : 75 % par essai donne environ 42 % en pass^3 (0,75³ ≈ 0,42, vérifié par calcul, sous hypothèse d'essais indépendants).
- Pour un profil : la question posée au banc est-elle « l'agent sait-il le faire ? » (pass@k) ou « le fait-il à chaque fois ? » (pass^k) ? pour une règle qui ne doit jamais céder (sécurité, données privées), c'est la seconde : mesure-t-on « réussit sur k essais sur k » plutôt qu'un pourcentage moyen ?

### Traiter un 0 % sur de nombreux essais d'abord comme une tâche ou un correcteur cassé
- Niveau de preuve : N3
- Source : Grace et al. (Anthropic), 09.01.2026, « Demystifying evals for AI agents », https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
- Extrait lu : « a 0% pass rate across many trials (i.e. 0% pass@100) is most often a signal of a broken task » ; et « can cause correlated failures due to infrastructure flakiness rather than agent performance ».
- Portée / limites : énoncé pour des modèles de pointe sur des tâches faisables.
- Pour un profil : avant de conclure qu'une règle « ne passe jamais », le cas, l'environnement (permissions, fichiers absents, profil non chargé) et le correcteur ont-ils été vérifiés sur la solution de référence ?

## 3. Juge LLM (hors code)

### Inverser l'ordre des réponses et ne déclarer un gagnant que s'il gagne dans les deux ordres
- Niveau de preuve : N1 (NeurIPS 2023, Datasets and Benchmarks)
- Source : Zheng et al., 2023, « Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena », https://arxiv.org/abs/2306.05685 (PDF lu)
- Extrait lu : « A conservative approach is to call a judge twice by swapping the order of two answers and only declare a win when an answer is preferred in both orders. If the results are inconsistent after swapping, we can call it a tie. »
- Portée / limites : GPT-4, GPT-3.5, Claude-v1 de 2023, comparaisons par paires.
- Pour un profil : quand un juge compare la sortie « ancienne doctrine » et « nouvelle doctrine », l'ordre de présentation est-il inversé et l'incohérence comptée comme nulle ?

### Contrôler la longueur : un juge préfère la réponse verbeuse
- Niveau de preuve : N1 (NeurIPS 2023 D&B) ; N3 pour la reprise OpenAI
- Source : Zheng et al., 2023, « Judging LLM-as-a-Judge with MT-Bench and Chatbot Arena », https://arxiv.org/abs/2306.05685 (PDF lu) ; OpenAI, « Evaluation best practices », https://developers.openai.com/api/docs/guides/evaluation-best-practices
- Extrait lu : « Verbosity bias is when an LLM judge favors longer, verbose responses, even if they are not as clear, high-quality, or accurate as shorter alternatives. » ; « all LLMs may be prone to verbosity bias though GPT-4 defends significantly better than others. » ; OpenAI : « Control for response lengths as LLMs bias towards longer responses in general ».
- Portée / limites : attaque « liste répétée » sur 23 réponses seulement.
- Pour un profil : une doctrine qui pousse l'agent à écrire plus long gagne-t-elle chez le juge pour sa longueur plutôt que pour son respect de la règle ?

### Ne pas faire confiance à une consigne « l'ordre ne compte pas » : l'ordre suffit à renverser un classement
- Niveau de preuve : N2 (prépublication ; 80 requêtes)
- Source : Wang et al., 2023 (v2 du 30.08.2023), « Large Language Models are not Fair Evaluators », prépublication arXiv:2305.17926, https://arxiv.org/abs/2305.17926 (PDF lu)
- Extrait lu : « the quality ranking of candidate responses can be easily hacked by simply altering their order of appearance in the context. This manipulation allows us to skew the evaluation result, making one model appear considerably superior to the other, e.g., Vicuna-13B could beat ChatGPT on 66 over 80 tested queries with ChatGPT as an evaluator. » ; la figure 1 précise que c'est « even though we add the command "ensuring that the order in which the responses were presented does not affect your judgment" ». Correctifs proposés : « Multiple Evidence Calibration », « Balanced Position Calibration », « Human-in-the-Loop Calibration ».
- Portée / limites : ChatGPT et GPT-4 de 2023 ; publication dans un acte non vérifiée.
- Pour un profil : le juge du banc est-il protégé par construction (ordre aléatoire ou doublé), plutôt que par une phrase dans son prompt ?

### Faire juger par un autre modèle que celui qui a produit la sortie
- Niveau de preuve : N2 (prépublication ; GPT-4, GPT-3.5, Llama 2)
- Source : Panickssery, Bowman, Feng, 2024, « LLM Evaluators Recognize and Favor Their Own Generations », prépublication arXiv:2404.13076, https://arxiv.org/abs/2404.13076 (PDF lu)
- Extrait lu : « One such bias is self-preference, where an LLM evaluator scores its own outputs higher than others' while human annotators consider them of equal quality. » ; « we discover a linear correlation between self-recognition capability and the strength of self-preference bias ».
- Portée / limites : tâches de résumé ; l'effet est mesuré par ajustement fin, pas sur Claude. Rejoint le commentaire de code d'Anthropic cité plus haut.
- Pour un profil : le juge du banc de comportement est-il le même modèle que l'agent testé ? si oui, l'écart mesuré est-il robuste à un juge d'une autre famille ?

### Valider un juge par une mesure d'accord autre que le pourcentage d'accord brut
- Niveau de preuve : N2 (atelier GEM 2025, ACL)
- Source : Thakur, Choudhary, Ramayapally, Vaidyanathan, Hupkes, 2024 (v6 du 18.08.2025), « Judging the Judges: Evaluating Alignment and Vulnerabilities in LLMs-as-Judges », https://arxiv.org/abs/2406.12624 (résumé seul lu)
- Extrait lu : « we find that only the best (and largest) models achieve reasonable alignment with humans » ; « judges with high percent agreement can still assign vastly different scores » ; « the importance of using alignment metrics beyond simple percent alignment ».
- Portée / limites : tâche de questions-réponses à réponse de référence ; la métrique de remplacement exacte n'a pas été lue (résumé seul).
- Pour un profil : sur un échantillon de cas notés à la main par le mainteneur, le juge du banc est-il d'accord au-delà de ce que le hasard donnerait, et pas seulement « souvent d'accord » ?

### Accepter que les critères de notation bougent en lisant les sorties, et versionner la grille
- Niveau de preuve : N2 (étude qualitative d'utilisateurs ; UIST 2024 selon la recherche, non vérifié sur la page)
- Source : Shankar, Zamfirescu-Pereira, Hartmann, Parameswaran, Arawjo, 2024, « Who Validates the Validators? Aligning LLM-Assisted Evaluation of LLM Outputs with Human Preferences », https://arxiv.org/abs/2404.12272 (résumé seul lu)
- Extrait lu : « we identify a phenomenon we dub criteria drift: users need criteria to grade outputs, but grading outputs helps users define criteria. » ; « some criteria appears dependent on the specific LLM outputs observed ».
- Portée / limites : petit échantillon d'utilisateurs, outil EvalGen.
- Pour un profil : la grille du banc a-t-elle été modifiée après avoir vu les sorties de la nouvelle doctrine ? si oui, l'ancienne doctrine a-t-elle été re-notée avec la même grille ?

## 4. Évaluer des agents : coût, validité, trajectoire

### Rapporter le coût à côté du score et comparer à des lignes de base simples
- Niveau de preuve : N2 (prépublication ; HumanEval, 164 problèmes, 5 exécutions par agent)
- Source : Kapoor, Stroebl, Siegel, Nadgir, Narayanan, 2024, « AI Agents That Matter », prépublication arXiv:2407.01502, https://arxiv.org/abs/2407.01502 (PDF lu)
- Extrait lu : « AI agent evaluations must be cost-controlled » ; « there is a narrow focus on accuracy without attention to other metrics. As a result, SOTA agents are needlessly complex and costly » ; baseline « Retry » justifiée par « LLMs aren't deterministic even at temperature zero ».
- Portée / limites : agents de code de 2024 ; le constat sur le coût est général.
- Pour un profil : une règle ajoutée au profil améliore-t-elle le comportement plus qu'une variante plus courte ou que « relancer une fois », à coût de contexte égal ?

### Garder des cas de validation que la mise au point de la doctrine n'a jamais vus
- Niveau de preuve : N2 (prépublication)
- Source : Kapoor et al., 2024, « AI Agents That Matter », arXiv:2407.01502, https://arxiv.org/abs/2407.01502 (PDF lu)
- Extrait lu : « many agent benchmarks have inadequate holdout sets, and sometimes none at all. This has led to agents that are fragile because they take shortcuts and overfit to the benchmark in various ways. »
- Portée / limites : vise les bancs publics ; le risque est le même pour un banc maison réutilisé à chaque itération.
- Pour un profil : la doctrine a-t-elle été réécrite jusqu'à passer précisément les cas du banc ? un jeu de cas tenu à part a-t-il été joué une seule fois, à la fin ?

### Vérifier qu'un agent qui ne fait rien échoue au banc (validité du résultat et de la tâche)
- Niveau de preuve : N2 (prépublication ; 10 bancs d'agents audités)
- Source : Zhu et al., 2025 (v5 du 07.08.2025), « Establishing Best Practices for Building Rigorous Agentic Benchmarks », prépublication arXiv:2507.02825, https://arxiv.org/abs/2507.02825 (PDF lu)
- Extrait lu : « τ-bench counts empty responses as successful. Such issues can lead to under- or overestimation of agents' performance by up to 100% in relative terms. » ; « This trivial agent achieves a 38% success rate and outperforms a GPT-4o-based agent » ; deux conditions : « Outcome validity » et « Task validity » ; item de la liste : « R.13. Reports results of trivial agents (e.g., one that does nothing). »
- Portée / limites : bancs publics ; la liste ABC est une synthèse d'expérience, pas une norme validée.
- Pour un profil : sur un cas « l'agent doit refuser », une sortie vide ou un refus générique passe-t-il pour une réussite ? le banc a-t-il été joué une fois avec un agent nul pour le prouver ?

### Noter d'abord le résultat, et lire les transcriptions pour vérifier le correcteur
- Niveau de preuve : N3
- Source : Grace et al. (Anthropic), 09.01.2026, « Demystifying evals for AI agents », https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
- Extrait lu : « it's often better to grade what the agent produced, not the path it took. » ; « You won't know if your graders are working well unless you read the transcripts and grades from many trials. » ; « Test both the cases where a behavior should occur and where it shouldn't. »
- Portée / limites : le billet juge trop fragiles les contrôles rigides de séquences d'appels, mais garde une notation par grille des comportements (usage des outils, échange avec l'utilisateur). Il ne tranche pas pour les règles de procédure (« lire avant d'écrire »), où le chemin est l'objet même de la règle.
- Pour un profil : la règle testée porte-t-elle sur un résultat (fichier correct) ou sur une procédure (Phase 0, confirmation demandée) ? dans le second cas seulement, la trajectoire est le bon objet de notation.

### Ne pas confondre « l'agent a agi » et « l'agent a réussi »
- Niveau de preuve : N2 (prépublication, un auteur ; 3 modèles, 10 tâches, 5 exécutions selon une notice secondaire non vérifiée)
- Source : Aman Mehta, 2026 (v3 du 21.06.2026), « Confident and Wrong: Silent Semantic Failures in Coding Agents », prépublication arXiv:2603.25764, https://arxiv.org/abs/2603.25764 (résumé seul lu)
- Extrait lu : « GPT-5 submits a patch on 100% of runs but resolves only 44% » ; « completion-based and consistency-based monitoring both look healthy exactly when the agent should not be trusted. »
- Portée / limites : petit échantillon, auteur unique, non évalué par les pairs.
- Pour un profil : le banc compte-t-il « l'agent a produit une sortie » ou « la sortie respecte la règle » ? une constance élevée entre essais n'est pas une preuve de justesse.

### Isoler chaque essai et figer ce que `claude -p` charge
- Niveau de preuve : N3
- Source : Grace et al. (Anthropic), 09.01.2026, « Demystifying evals for AI agents », https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents ; Anthropic, consulté le 10.11.2026, « Run Claude Code programmatically », https://code.claude.com/docs/en/headless
- Extrait lu : « Each trial should be "isolated" by starting from a clean environment. » ; « Without it, `claude -p` discovers and loads them as an interactive session would, including anything configured in the working directory or `~/.claude`. » ; sous `--bare`, Claude « doesn't get the list of available skills » ; « With `--output-format json`, the response payload includes `total_cost_usd` […] Both figures are client-side estimates ».
- Portée / limites : comportement de la version de Claude Code documentée au 10.11.2026 (la page annonce que `--bare` deviendra le défaut de `-p`).
- Pour un profil : le banc de comportement charge-t-il le profil à tester par des drapeaux explicites, ou hérite-t-il du `~/.claude` du poste ? un banc de routage lancé en `--bare` ne voit aucune skill et ne mesure donc rien.

## 5. Évaluer un changement de prompt, de profil ou de modèle

### Rejouer le banc quand le modèle sous-jacent change, même à prompt identique
- Niveau de preuve : N2 (prépublication ; GPT-3.5 et GPT-4, mars contre juin 2023)
- Source : Chen, Zaharia, Zou, 2023 (v3 du 31.10.2023), « How Is ChatGPT's Behavior Changing over Time? », prépublication arXiv:2307.09009, https://arxiv.org/abs/2307.09009 (PDF lu)
- Extrait lu : « GPT-4 (March 2023) was reasonable at identifying prime vs. composite numbers (84% accuracy) but GPT-4 (June 2023) was poor on these same questions (51% accuracy). » ; « We provide evidence that GPT-4's ability to follow user instructions has decreased over time » ; « highlighting the need for continuous monitoring of LLMs. »
- Portée / limites : versions d'API de 2023 ; la dérive porte notamment sur le suivi d'instructions, donc directement sur une doctrine.
- Pour un profil : la dernière mesure d'une règle date-t-elle du modèle actuellement déployé ? un changement de modèle déclenche-t-il le rejeu des cas de régression ?

### Mesurer une modification de prompt sur plusieurs formulations, pas sur une seule (renvoi)
- Niveau de preuve : N1 (ICLR 2024, selon le champ de commentaire arXiv)
- Source : Sclar, Choi, Tsvetkov, Suhr, 2023 (v2 du 01.07.2024), « Quantifying Language Models' Sensitivity to Spurious Features in Prompt Design », https://arxiv.org/abs/2310.11324 (résumé seul lu)
- Extrait lu : « extremely sensitive to subtle changes in prompt formatting in few-shot settings » ; écarts « up to 76 accuracy points when evaluated using LLaMA-2-13B » ; recommandation : « reporting a range of performance across plausible prompt formats ».
- Portée / limites : modèles ouverts, quelques exemples dans le prompt ; le détail est traité dans le dossier sur la sensibilité au format, non refait ici.
- Pour un profil : l'effet attribué à une règle survit-il à une reformulation de la demande de test, ou tient-il à la formulation exacte du cas ?

### Ne pas attendre d'une ligne de doctrine une garantie : ce qui ne souffre aucune exception va dans un hook
- Niveau de preuve : N3
- Source : Anthropic, consulté le 10.11.2026, « Best practices for Claude Code », https://code.claude.com/docs/en/best-practices
- Extrait lu : « there's no guarantee that it'll follow your instructions » ; « If something has to happen every time, make it a hook, a deny rule, or a managed setting. `CLAUDE.md` is for guidelines, and Claude is allowed to decide a guideline doesn't apply. » ; « If Claude keeps ignoring a line that is in `CLAUDE.md`, adding IMPORTANT probably won't fix it. »
- Portée / limites : guide de l'éditeur, sans mesure publiée du taux de respect d'une consigne.
- Pour un profil : le banc mesure-t-il une règle que la doctrine ne peut que demander (alors un taux, jamais 100 %) ou une règle portée par un hook (alors un test déterministe, en CI) ?

## 6. Évaluer le routage (la bonne skill, le bon agent, le bon outil)

### Tester le déclenchement avec un jeu mixte « doit partir / ne doit pas partir », négatifs proches compris
- Niveau de preuve : N3
- Source : Anthropic, dépôt public `anthropics/skills`, branche `main`, consulté le 10.11.2026, `skills/skill-creator/SKILL.md`, https://raw.githubusercontent.com/anthropics/skills/main/skills/skill-creator/SKILL.md
- Extrait lu : « Create 20 eval queries — a mix of should-trigger and should-not-trigger. » ; « For the should-not-trigger queries (8-10), the most valuable ones are the near-misses » ; « don't make should-not-trigger queries obviously irrelevant. »
- Portée / limites : outil de l'éditeur, pas une étude ; 20 requêtes est un choix pratique. Le même fichier avertit que les demandes trop simples ne testent rien : « Claude only consults skills for tasks it can't easily handle on its own — simple, one-step queries like "read this PDF" may not trigger a skill even if the description matches perfectly », et note que « currently Claude has a tendency to "undertrigger" skills » (affirmation sans chiffre, datée du fichier).
- Pour un profil : le banc de routage contient-il, pour chaque skill, des demandes voisines qui doivent partir vers une autre skill ou vers aucune ? et un échec de routage vient-il de la description, ou d'une demande de test trop simple pour que l'agent consulte une skill ?

### Répéter chaque requête de routage et choisir la description sur un jeu tenu à part
- Niveau de preuve : N3
- Source : Anthropic, `anthropics/skills`, `skills/skill-creator/SKILL.md`, https://raw.githubusercontent.com/anthropics/skills/main/skills/skill-creator/SKILL.md
- Extrait lu : « It splits the eval set into 60% train and 40% held-out test, evaluates the current description (running each query 3 times to get a reliable trigger rate) » ; la meilleure description est « selected by test score rather than train score to avoid overfitting. » ; « Use the model ID from your system prompt […] so the triggering test matches what the user actually experiences. »
- Portée / limites : 3 essais par requête et 60/40 sont des choix d'outil, non justifiés statistiquement ; sur 20 requêtes, le jeu tenu à part ne compte que 8 requêtes.
- Pour un profil : une description de skill réécrite pour réussir le banc de routage a-t-elle été validée sur des demandes qui n'ont pas servi à la réécrire, et sur le modèle déployé ?

### Mesurer la décision « faut-il un outil ? » en précision, rappel et F1, et inclure des cas sans bon outil
- Niveau de preuve : N1 (ICLR 2024)
- Source : Huang et al., 2023 (v6 du 04.12.2024), « MetaTool Benchmark for Large Language Models: Deciding Whether to Use Tools and Which to Use », https://arxiv.org/abs/2310.03128 (PDF lu)
- Extrait lu : « For the awareness of tool usage evaluation, we use accuracy, recall, precision, and F1 score as the metrics. » ; « the potential sycophancy of LLMs may lead them to avoid returning a "none" answer, instead choosing irrelevant tools to respond to users. » ; « LLMs sometimes fabricate non-existent tools ».
- Portée / limites : huit modèles de 2023 (ChatGPT, Llama 2, Vicuna…) ; pas de skills Claude Code.
- Pour un profil : le banc de routage compte-t-il séparément les faux départs (skill déclenchée à tort, précision) et les oublis (skill non déclenchée, rappel), et contient-il des demandes où la bonne réponse est « aucune skill » ?

## Verdict sur les règles du profil

| Règle | Verdict | Motif sourcé |
|---|---|---|
| « Mesuré, pas supposé » : une règle se justifie par un banc (ex. C1 : 3 violations sur 3 essais quand la règle n'est que dans la description) | **Soutenue, à préciser** | Les guides demandent des évals avant la doc et une ligne de base sans la modification (Anthropic, skills best practices ; OpenAI « eval-driven development »). Mais 3 essais ne prouvent qu'un effet massif : calcul de l'auteur, 3/3 contre 0/3 donne p = 0,05 au mieux (Fisher exact unilatéral), et la borne basse de l'intervalle de Clopper-Pearson à 95 % sur 3/3 est d'environ 29 %. Le billet d'Anthropic admet de petits échantillons pour de gros effets seulement ; Miller et Bjarnason et al. demandent appariement, essais répétés et analyse de puissance. Préciser : nombre de cas, essais par cas, modèle, condition témoin jouée sur les mêmes cas. |
| « Un banc de comportement `claude -p`, payant, reste hors CI et se lance à la main » | **À préciser** (en partie contredite) | Le coût est un critère légitime (Kapoor et al. : évaluations « cost-controlled »). Mais OpenAI recommande une évaluation continue « on every change » et Anthropic fait « graduer » les évals de capacité en suite de régression jouée en continu ; Chen et al. montrent qu'un même service dérive en quelques mois. Ce qui est soutenu : la partie capacité, payante, à la main ; la partie régression, réduite et cadencée (planifiée, ou déclenchée à chaque changement de modèle ou de doctrine), plutôt que laissée au bon vouloir. |
| « Le banc voit la chaîne, pas la force » (un marqueur prouve la présence d'un texte, pas son application) | **Soutenue** | Claude Code best practices : une consigne n'a « no guarantee » d'être suivie ; ABC sépare validité du résultat et validité de la tâche ; Mehta montre qu'agir n'est pas réussir. Un banc de marqueurs est un contrôle de non-régression du texte, à compléter par un banc de comportement pour la force. |
| « Les faits et les mesures priment sur les préférences » | **À préciser** | Soutenue contre l'intuition non mesurée (OpenAI cite comme anti-motif d'attendre la mise en service pour évaluer). Mais une mesure n'est valide que si son correcteur l'est : les guides exigent de calibrer les juges sur des humains (OpenAI, Anthropic), le pourcentage d'accord peut masquer un désaccord (Thakur et al.), et les critères eux-mêmes naissent du jugement humain sur les sorties (Shankar et al., « criteria drift »). La préférence de l'utilisateur définit le critère ; la mesure tranche si le critère est atteint. |
| « Une preuve est la sortie d'une commande collée, jamais son résumé » | **Soutenue, à préciser** | « Read the transcripts! » et la lecture des notes de nombreux essais (Anthropic) ; `skill-creator` exige un champ `evidence` par assertion. Mais une sortie collée reste un tirage : sans répétition, elle ne prouve pas la fiabilité (Atil et al. ; Bjarnason et al. ; τ-bench, pass^k). Préciser : sortie brute, et nombre d'essais dont elle est tirée. |

## Mythes et affirmations contestées

- **« Température 0 = résultat reproductible. »** Contredit : variations d'exactitude jusqu'à 15 % entre exécutions « déterministes » (Atil et al.) ; écart-type de plus de 1,5 point à température 0 sur SWE-Bench-Verified (Bjarnason et al.) ; Kapoor et al. fondent leur ligne de base « Retry » sur ce non-déterminisme. Miller déconseille de jouer sur la température pour réduire la variance.
- **« Volume ou qualité des cas : la question est réglée. »** Contesté entre sources : la doc d'Anthropic dit « Prioritize volume over quality » ; τ-bench défend « a small set of high-quality tasks for multiple trials » ; le billet d'Anthropic de 2026 propose 20 à 50 tâches issues d'échecs réels, chacune avec verdict d'expert univoque et solution de référence. Les trois se concilient si l'on distingue cas notés par script (volume) et cas d'agent coûteux (qualité, répétition).
- **« Un juge LLM qui s'accorde à 80 % avec les humains est fiable. »** À nuancer : MT-Bench rapporte plus de 80 % d'accord (Zheng et al.), mais Thakur et al. montrent qu'un fort pourcentage d'accord peut cacher des notes très différentes.
- **« MT-Bench a établi le biais d'auto-préférence. »** Faux tel quel : Zheng et al. écrivent « our study cannot determine whether the models exhibit a self-enhancement bias ». L'effet est ensuite étayé par Panickssery et al. (prépublication), sur d'autres tâches et d'autres modèles.
- **« Noter la trajectoire est toujours plus rigoureux que noter le résultat. »** Contesté par Anthropic : « it's often better to grade what the agent produced, not the path it took ». Exception défendable pour les règles qui sont elles-mêmes des procédures.
- **« Ajouter IMPORTANT ou MUST corrige une règle ignorée. »** Contesté : Claude Code best practices dit que cela « probably won't fix it » et renvoie au hook ; la page des bonnes pratiques de skills cite pourtant « stronger language such as "MUST filter" » parmi les remèdes possibles, et `skill-creator` met en garde contre les « oppressively constrictive MUSTs ». Seule une mesure avant/après tranche, cas par cas.
- **« Un bon pass@k signifie un agent fiable. »** Contredit : pass@k et pass^k divergent quand k grandit (Anthropic ; τ-bench : pass^8 sous 25 % en retail pour gpt-4o).
- **« Un banc publié mesure ce qu'il prétend. »** Contredit par ABC : un agent qui renvoie des réponses vides atteint 38 % sur τ-bench-airline ; sept bancs sur dix audités ont un défaut de validité du résultat.

## Non vérifié

- **BFCL et la détection de non-pertinence** (« The Berkeley Function Calling Leaderboard », annoncé à ICML 2025) : article non ouvert, seules des sources secondaires lues ; non cité.
- **Revue d'Epoch AI notant BFCL v4 « Flawed »** (septembre 2026) : page non ouverte.
- **Chiffre « 5 skills sur 6 » mieux déclenchées après optimisation de description**, attribué à Anthropic par un billet tiers : source primaire non trouvée.
- **Anomalie #556 (taux de déclenchement à 0 % dans `run_eval.py`)** de `skill-creator` : non ouverte ; état actuel inconnu.
- **Date du dernier commit** du `SKILL.md` de `skill-creator` : non obtenue (l'appel à l'API GitHub n'a rien rendu).
- **Lieux de publication** de Wang et al., Panickssery et al., Kapoor et al., τ-bench, ABC, Chen et al., Atil et al. (« Under review ») et Bjarnason et al. : aucune mention sur les notices arXiv ouvertes ; traités comme prépublications. UIST 2024 pour Shankar et al. : indiqué par la recherche, absent de la notice arXiv.
- **Métrique d'accord exacte** (kappa de Cohen ou autre) retenue par Thakur et al. : non lue, résumé seul.
- **Échantillon de Mehta** (10 tâches, 5 exécutions, 3 modèles) : donné par une notice secondaire, non lu dans l'article.
- **Ancien titre « Create strong empirical evaluations »** de la doc Anthropic : la page ouverte s'intitule aujourd'hui « Define success criteria and build evaluations » ; l'ancien titre n'a pas été vérifié.
- **Cause du non-déterminisme** (taille de lot variable sur serveurs partagés, billet de 2025 cité par une recherche) : non ouvert.
- **ReliabilityBench (arXiv:2601.06112)** et « Engineering Reliable Coding Agents » (arXiv:2608.13867) : non ouverts.
- **Mesure publiée du taux de respect d'une consigne de `CLAUDE.md` par Claude** : aucune trouvée ; les guides d'Anthropic l'affirment sans chiffre.

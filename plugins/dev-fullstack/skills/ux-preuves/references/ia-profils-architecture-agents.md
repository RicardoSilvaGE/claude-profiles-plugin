# Fiche `ux-preuves` — Ingénierie IA — architecture d'agents, délégation et briefs

> Fiche du skill `ux-preuves` (dev-fullstack), volet **ingénierie IA**, préchargé par `ingenieur-ia`. Couvre : pratique publiée d'Anthropic (agents, multi-agents, ingénierie du contexte), points de vue contraires, échecs mesurés des systèmes multi-agents, quand déléguer, contenu d'un brief, fiabilité des comptes rendus, choix du modèle et de l'effort.
> **Instantané de la recherche documentaire du 10.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Études (souvent des prépublications pour les LLM), docs d'outils
> et pratiques d'entreprise **vieillissent** : avant d'en faire dépendre une règle,
> relire la source (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

**Méthode.** Recherche menée le 10 novembre 2026. Chaque entrée repose sur une page réellement ouverte : pages HTML lues par WebFetch ou téléchargées avec curl puis converties en texte ; documentation Anthropic téléchargée en Markdown (`<url>.md`) ; articles arXiv et ACL téléchargés en PDF dans `pdf2/` et lus avec `pdftotext` (abstract, tableaux et sections citées lus dans le texte intégral, pas seulement le résumé, sauf mention contraire). Les extraits sont verbatim dans leur langue d'origine et volontairement courts. Niveaux de preuve : **N1** méta-analyse ou revue systématique ; **N2** étude empirique avec échantillon cité ; **N3** publication d'Anthropic sur ses propres produits et pratiques (documentation, blog d'ingénierie, guides de prompting — y compris les mesures internes qu'elle publie) ; **N4** blog d'un autre éditeur ou retour d'industrie. Les prépublications arXiv sont signalées comme telles. La documentation Anthropic citée est celle en ligne au 10.11.2026 : elle nomme des modèles (Opus 5.5, Sonnet 5.5, Haiku 5.5, Fable 5.2) et ses mesures datent d'août à octobre 2026 ; elle peut changer sans préavis. Hors périmètre (couvert ailleurs) : séparation auteur du code / auteur des tests, exploitation des tests par les agents, injection de prompt entre agents et MCP, revue de code par un LLM.

---

## 1. Quand déléguer, et quand ne pas déléguer

### Commencer par la solution la plus simple ; n'ajouter un agent, puis plusieurs, que si une mesure le justifie
- Niveau de preuve : N3
- Source : Erik S. et Barry Zhang (Anthropic), 19.12.2024, « Building effective agents », https://www.anthropic.com/engineering/building-effective-agents
- Extrait lu : « We recommend finding the simplest solution possible, and only increasing complexity when needed. » / « This might mean not building agentic systems at all. » ; sur l'orchestrateur-exécutants : « This workflow is well-suited for complex tasks where you can't predict the subtasks needed »
- Portée / limites : texte de principe, sans mesure chiffrée. La page signale elle-même que l'outillage a beaucoup changé depuis décembre 2024. Distingue « workflows » (chemins de code prédéfinis) et « agents » (le LLM dirige son propre processus).
- Pour un profil : cette délégation remplace-t-elle quelque chose qu'un seul appel bien briefé, ou un enchaînement fixe, ferait aussi bien ? Les sous-tâches sont-elles vraiment imprévisibles, ou peut-on les écrire d'avance ?

### Un système multi-agents coûte environ 15 fois les jetons d'une conversation : le réserver aux tâches de forte valeur, parallélisables, qui dépassent une fenêtre de contexte
- Niveau de preuve : N3
- Source : Jeremy Hadfield, Barry Zhang, Kenneth Lien, Florian Scholz, Jeremy Fox, Daniel Ford (Anthropic), 13.06.2025, « How we built our multi-agent research system », https://www.anthropic.com/engineering/multi-agent-research-system
- Extrait lu : « agents typically use about 4× more tokens than chat interactions, and multi-agent systems use about 15× more tokens than chats » / « most coding tasks involve fewer truly parallelizable tasks than research, and LLM agents are not yet great at coordinating and delegating to other agents in real time »
- Portée / limites : données internes d'Anthropic sur son produit Research (recherche web), Claude Opus 4 / Sonnet 4, mi-2025. L'article dit explicitement que les domaines où tous les agents doivent partager le même contexte, ou à fortes dépendances, ne conviennent pas aujourd'hui.
- Pour un profil : la tâche confiée à l'équipe (architecte, backend, frontend…) est-elle de la recherche en largeur, ou une chaîne de décisions de code dépendantes ? La valeur attendue paie-t-elle un multiplicateur de coût de cet ordre ?

### Le gain d'un système multi-agents vient surtout des jetons dépensés en plus : le comparer à un agent seul à budget égal
- Niveau de preuve : N3
- Source : Hadfield et al. (Anthropic), 13.06.2025, « How we built our multi-agent research system », https://www.anthropic.com/engineering/multi-agent-research-system
- Extrait lu : « outperformed single-agent Claude Opus 4 by 90.2% on our internal research eval » / « We found that token usage by itself explains 80% of the variance »
- Portée / limites : éval interne non publiée ; requêtes « breadth-first » ; la variance expliquée porte sur BrowseComp (trois facteurs expliquent 95 % : jetons, nombre d'appels d'outils, choix du modèle). Le 90,2 % n'est pas à budget égal.
- Pour un profil : quand une équipe d'agents « fait mieux », a-t-on comparé avec un agent seul à qui l'on aurait donné le même budget (effort plus élevé, plus d'appels) ?

### Garder dans la conversation principale le travail à phases qui partagent beaucoup de contexte ; déléguer ce qui est autonome, verbeux et résumable
- Niveau de preuve : N3
- Source : Anthropic, documentation Claude Code « Create custom subagents » (consultée le 10.11.2026), https://code.claude.com/docs/en/sub-agents
- Extrait lu : conversation principale quand « Multiple phases share significant context, such as planning, implementation, and testing » et quand « Latency matters. A subagent that isn't a fork starts fresh and may need time to gather context » ; sous-agent quand « The work is self-contained and can return a summary »
- Portée / limites : critères qualitatifs, sans mesure. Ajoute un troisième critère pro-délégation : imposer des restrictions d'outils ou de permissions.
- Pour un profil : la tâche est-elle autonome ET résumable ? Si le sous-agent devra relire ce que l'orchestrateur a déjà lu, le gain de contexte compense-t-il la latence ?

### Déléguer n'améliore pas la réponse ; seul un relecteur au regard neuf apporte quelque chose que l'auteur n'a pas
- Niveau de preuve : N3
- Source : Anthropic, documentation Claude Code « Best practices for Claude Code » (consultée le 10.11.2026), https://code.claude.com/docs/en/best-practices
- Extrait lu : « Handing the same task to a subagent doesn't make the answer any better. A fresh reviewer does help, because it hasn't seen your reasoning, which is a different thing from delegating. » / « a fresh subagent first has to gather context your conversation already had, so it can end up *slower* than doing the task where you are. »
- Portée / limites : classée par la page dans « What you can stop doing » ; la page relativise aussi l'usage des sous-agents pour « protéger » la fenêtre de contexte (fenêtres de 1M jetons, compaction automatique). Énumère quatre cas où les sous-agents paient : travail indépendant en parallèle, sortie longue tenue hors du contexte, relecteur n'ayant pas vu l'écriture, outils restreints.
- Pour un profil : ce sous-agent apporte-t-il du parallélisme, de l'isolation de sortie verbeuse, un regard neuf ou une restriction d'outils ? Si aucun des quatre, pourquoi déléguer ?

### Les modèles récents délèguent trop volontiers : écrire quand la délégation est justifiée et quand elle ne l'est pas, et poser des plafonds
- Niveau de preuve : N3
- Source : Anthropic, « Prompting Claude Opus 5 » (consulté le 10.11.2026), https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5 ; voir aussi « Prompting best practices », https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices
- Extrait lu : « Delegation is worthwhile for genuinely independent, sizeable tracks of work, but it multiplies cost and time when applied to small tasks. » ; prompt proposé : « Do not delegate work you can finish yourself in a handful of tool calls » ; et dans le guide général : « Use subagents when tasks can run in parallel, require isolated context, or involve independent workstreams that don't need to share state. »
- Portée / limites : observations d'Anthropic sur Opus 4.6 et Opus 5 ; plafonds déterministes cités pour Claude Code (`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH`, `CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS`). Le guide Fable 5.2 note à l'inverse qu'en tâches courtes ce modèle délègue rarement : le réglage dépend du modèle.
- Pour un profil : les lignes « délègue à X » des agents et skills poussent-elles à déléguer des tâches de quelques appels d'outils ? Un plafond de profondeur et de concurrence est-il posé ?

### Un orchestrateur ne bat un modèle seul, à effort réduit, que sur du travail plus grand qu'une fenêtre de contexte ou à longue traîne de coût
- Niveau de preuve : N3 (mesures internes publiées, benchmarks nommés)
- Source : Anthropic, « Optimizing for cost and intelligence » (consulté le 10.11.2026), https://platform.claude.com/docs/en/about-claude/models/optimizing-for-cost-and-intelligence
- Extrait lu : « In Anthropic’s measurements, delegation came out ahead in only two situations » / « When the work is one dependent chain, or fits in a single context without a long cost tail, the orchestrator’s model alone at lower effort came out ahead in every case measured on earlier models »
- Portée / limites : BrowseComp, DeepWideSearch, benchmark interne de recherche de défauts ; mesures d'août à octobre 2026 ; certaines sur des modèles antérieurs, ce que la page signale. Sur la recherche de défauts, Opus 5.5 avec sous-agents Sonnet 5.5 a coûté environ un tiers de moins pour un score comparable.
- Pour un profil : la mission de l'équipe dépasse-t-elle réellement une fenêtre de contexte ? Sinon, a-t-on d'abord essayé l'orchestrateur seul avec un effort plus bas ?

### L'architecture doit suivre la structure de la tâche : gros gain sur le décomposable, forte perte sur le séquentiel
- Niveau de preuve : N2 (260 configurations, six benchmarks, trois familles de LLM dont Claude Sonnet 3.7 à 4.5) — prépublication arXiv
- Source : Yubin Kim et al. (Google Research, Google DeepMind, MIT), 2025 (v3 du 08.04.2026), « Towards a Science of Scaling Agent Systems », https://arxiv.org/abs/2512.08296
- Extrait lu : « Relative performance change compared to single-agent baseline ranges from +80.8% on decomposable financial reasoning to −70.0% on sequential planning » ; « tasks where single-agent performance already exceeds 45% accuracy experience negative returns from additional agents » ; « Independent systems amplify trace-level errors 17.2× [...] Centralized coordination, however, contains this to 4.4× »
- Portée / limites : outils, prompts et calcul standardisés ; le modèle prédictif n'explique qu'une part modeste (R² validé croisé 0,373). La v1 (déc. 2025) annonçait d'autres effectifs ; chiffres ci-dessus lus dans la v3.
- Pour un profil : la tâche est-elle découpable en morceaux indépendants, ou est-ce une planification sous contraintes enchaînées ? L'agent seul réussit-il déjà bien (au-delà de ce seuil, ajouter des agents coûte) ? Les sorties passent-elles par un point de validation central ?

### À budget de raisonnement égal, un agent seul égale ou dépasse un système multi-agents sur le raisonnement multi-étapes
- Niveau de preuve : N2 — prépublication arXiv (« Preprint. Under review. »)
- Source : Dat Tran et Douwe Kiela (Stanford), 2026 (v2 du 11.04.2026), « Single-Agent LLMs Outperform Multi-Agent Systems on Multi-Hop Reasoning Under Equal Thinking Token Budgets », https://arxiv.org/abs/2604.02460
- Extrait lu : « We find that SAS consistently match or outperform MAS on multi-hop reasoning tasks when reasoning tokens are held constant. »
- Portée / limites : Qwen3, DeepSeek-R1-Distill-Llama, Gemini 2.5 (pas de modèle Claude) ; raisonnement multi-sauts uniquement. Les auteurs prédisent que le multi-agents redevient compétitif quand l'usage du contexte par l'agent seul se dégrade, ou quand on dépense plus de calcul.
- Pour un profil : quand on attribue un gain à « l'équipe d'agents », le budget a-t-il été égalisé ? Le contexte de l'agent seul est-il réellement dégradé (bruit, longueur) ?

### Point de vue contraire : des sous-agents qui agissent en parallèle prennent des décisions implicites contradictoires
- Niveau de preuve : N4
- Source : Walden Yan (Cognition), 12.06.2025, « Don't Build Multi-Agents », https://cognition.com/blog/dont-build-multi-agents (redirigé depuis cognition.ai)
- Extrait lu : « Actions carry implicit decisions, and conflicting decisions carry bad results » ; « Share context, and share full agent traces, not just individual messages » ; « it is evident that in 2025, running multiple agents in collaboration only results in fragile systems »
- Portée / limites : retour d'expérience d'un éditeur concurrent, sans mesure. Exemple du clone de Flappy Bird : un sous-agent fait un décor façon Super Mario, l'autre un oiseau qui ne ressemble pas à un asset de jeu. Recommande l'agent linéaire à un seul fil.
- Pour un profil : deux sous-agents (backend, frontend) vont-ils trancher chacun en silence une même question (format, nommage, contrat d'API) ? Qui fixe ces décisions avant de les lancer ?

### Ce qui marche en 2026 selon le même éditeur : écritures sur un seul fil, agents supplémentaires en lecture et en relecture
- Niveau de preuve : N4
- Source : Walden Yan (Cognition), 22.04.2026, « Multi-Agents: What's Actually Working », https://cognition.com/blog/multi-agents-working
- Extrait lu : multi-agents utiles quand « writes stay single-threaded and the additional agents contribute intelligence rather than actions » ; « A clean-context reviewer catches bugs the coder can't see. » ; « The open problems are all communication problems »
- Portée / limites : opinion d'éditeur ; maintient la réserve sur les essaims d'écrivains parallèles, pas de chiffres.
- Pour un profil : plusieurs sous-agents peuvent-ils modifier les mêmes fichiers en même temps ? Les rôles de lecture (reviewer, sécurité, auditeur) sont-ils séparés des rôles d'écriture ?

### Dans Claude Code, « contexte vierge » est approximatif : le sous-agent charge les CLAUDE.md et l'état git, et un fork hérite de toute la conversation
- Niveau de preuve : N3
- Source : Anthropic, documentation Claude Code « Create custom subagents », section « What loads at startup » et « Fork the current conversation » (consultée le 10.11.2026), https://code.claude.com/docs/en/sub-agents
- Extrait lu : « Claude composes a delegation message that summarizes the task, and the subagent works from there. » ; « A fork is a subagent that inherits the entire conversation so far instead of starting fresh. » ; « If a rule must, such as "ignore the `vendor/` directory," restate it in the prompt you give Claude when delegating. »
- Portée / limites : le contexte initial d'un sous-agent non-fork comprend son prompt système, le message de délégation, toute la hiérarchie CLAUDE.md (sauf Explore, Plan et `omitClaudeMd`), un instantané git et les skills préchargées ; il ne voit ni l'historique, ni les fichiers lus, ni la mémoire automatique. Le mode fork est actif par défaut d'après la page « Best practices ».
- Pour un profil : ce que le sous-agent doit savoir est-il dans le brief, dans un CLAUDE.md qu'il charge, ou nulle part ? Un fork conviendrait-il mieux qu'un sous-agent nommé quand le contexte nécessaire est long ?

---

## 2. Le brief

### Un brief contient au minimum un objectif, un format de sortie, des indications d'outils et de sources, et des frontières de tâche claires
- Niveau de preuve : N3
- Source : Hadfield et al. (Anthropic), 13.06.2025, « How we built our multi-agent research system », section « Teach the orchestrator how to delegate », https://www.anthropic.com/engineering/multi-agent-research-system
- Extrait lu : « Each subagent needs an objective, an output format, guidance on the tools and sources to use, and clear task boundaries. Without detailed task descriptions, agents duplicate work, leave gaps, or fail to find necessary information. »
- Portée / limites : retour d'expérience ; contre-exemple cité : la consigne courte « research the semiconductor shortage » a conduit à des recherches dupliquées. Ne mesure pas l'effet de chaque élément séparément.
- Pour un profil : chaque brief dit-il ce qui est hors périmètre, pour qu'un sous-agent ne refasse pas le travail d'un autre ? Le format de sortie est-il fixé ?

### Écrire dans le prompt de l'orchestrateur des règles explicites de dimensionnement (nombre d'agents, d'appels) selon la complexité
- Niveau de preuve : N3
- Source : Hadfield et al. (Anthropic), 13.06.2025, « How we built our multi-agent research system », https://www.anthropic.com/engineering/multi-agent-research-system
- Extrait lu : « Agents struggle to judge appropriate effort for different tasks, so we embedded scaling rules in the prompts. Simple fact-finding requires just 1 agent with 3-10 tool calls »
- Portée / limites : seuils propres à la recherche web d'Anthropic en 2025 ; à ne pas transposer tels quels au code. Les premières versions lançaient « 50 subagents for simple queries ».
- Pour un profil : l'orchestrateur dispose-t-il d'une règle écrite qui dit quand un seul sous-agent suffit et quand en lancer plusieurs ?

### Donner toute la spécification d'un coup : une instruction dispersée sur plusieurs tours fait chuter la performance
- Niveau de preuve : N2 (15 LLM dont Claude 3.7 Sonnet et Gemini 2.5 Pro, plus de 200 000 conversations simulées, six tâches) — prépublication arXiv
- Source : Philippe Laban, Hiroaki Hayashi, Yingbo Zhou, Jennifer Neville (Microsoft Research, Salesforce Research), 09.05.2025, « LLMs Get Lost In Multi-Turn Conversation », https://arxiv.org/abs/2505.06120
- Extrait lu : « an average drop of 39% across six generation tasks » ; « LLMs often make assumptions in early turns and prematurely attempt to generate final solutions, on which they overly rely » ; « consolidating instruction requirements into a single instruction is an effective strategy »
- Portée / limites : conversation utilisateur-modèle, pas délégation entre agents ; la transposition au brief est une inférence. La récapitulation au fil des tours ne récupère qu'une partie de la perte (15 à 20 %).
- Pour un profil : le brief contient-il toutes les exigences connues au départ, ou l'orchestrateur compte-t-il les ajouter par messages de suivi (reprise de sous-agent) ?

### Convenir avant le travail de ce que « fini » veut dire, sous forme de critères testables
- Niveau de preuve : N3
- Source : Prithvi Rajasekaran (Anthropic), 24.03.2026, « Harness design for long-running application development », https://www.anthropic.com/engineering/harness-design-long-running-apps
- Extrait lu : « Before each sprint, the generator and evaluator negotiated a sprint contract: agreeing on what "done" looked like for that chunk of work before any code was written. »
- Portée / limites : un seul harnais expérimental (planificateur, générateur, évaluateur ; Opus 4.5 puis 4.6) ; le sprint 3 comptait 27 critères. Sans planificateur, le générateur « under-scoped ».
- Pour un profil : le critère d'acceptation du brief est-il vérifiable par un tiers (test, commande, comportement observable), ou seulement une intention ?

### Les consignes de prudence s'accumulent dans les messages entre agents : écrire la portée et le motif d'une règle, nommer ce qui ne demande pas d'accord
- Niveau de preuve : N3 (tests internes sur tâches simulées)
- Source : Anthropic, « Prompting Claude Fable 5.2 », sections « Keep caution from piling up » et « Set expectations for subagents » (consulté le 10.11.2026), https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-2
- Extrait lu : « Cautious instructions build up wherever context carries over: memory, notes, instruction files, and messages between agents. » ; pour la description de l'outil qui lance les sous-agents : « tell the model how to brief a subagent that it starts »
- Portée / limites : observé surtout sur Fable 5.2 et « mostly where several agents work together » ; mesures sur tâches simulées. Une consigne générale « agis plus librement » n'a rien changé, nommer explicitement l'exception a fonctionné.
- Pour un profil : les interdits que l'orchestrateur recopie dans chaque brief sont-ils encore justifiés ? Chaque « jamais » dit-il sa portée et son exception ?

---

## 3. Le retour du sous-agent et la perte d'information

### Le sous-agent explore largement mais ne renvoie qu'un résumé condensé, souvent de 1 000 à 2 000 jetons
- Niveau de preuve : N3
- Source : Prithvi Rajasekaran, Ethan Dixon, Carly Ryan, Jeremy Hadfield (Anthropic), 29.09.2025, « Effective context engineering for AI agents », https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- Extrait lu : « Each subagent might explore extensively, using tens of thousands of tokens or more, but returns only a condensed, distilled summary of its work (often 1,000-2,000 tokens). »
- Portée / limites : ordre de grandeur **descriptif** (« often »), pas une norme mesurée. L'article rattache le multi-agents aux tâches de recherche et d'analyse « where parallel exploration pays dividends ».
- Pour un profil : la borne de retour est-elle adaptée au livrable (une liste de constats tient en 1 000 jetons, un fichier de code non) ?

### Faire écrire les livrables structurés dans des fichiers et ne renvoyer qu'une référence, pour éviter le « téléphone arabe »
- Niveau de preuve : N3
- Source : Hadfield et al. (Anthropic), 13.06.2025, « How we built our multi-agent research system », https://www.anthropic.com/engineering/multi-agent-research-system
- Extrait lu : « Subagents call tools to store their work in external systems, then pass lightweight references back to the coordinator. This prevents information loss during multi-stage processing »
- Portée / limites : recommandé pour « code, reports, or data visualizations » ; pas de mesure de la perte évitée.
- Pour un profil : le livrable (code, rapport) doit-il transiter par le résumé de l'orchestrateur, ou être déposé dans un fichier dont seul le chemin remonte ?

### Le compte rendu doit se lire seul : il s'adresse à quelqu'un qui n'a vu ni les appels d'outils ni les fichiers
- Niveau de preuve : N3
- Source : Anthropic, « Prompting Claude Fable 5.2 », section « Make reports easy to follow » (consulté le 10.11.2026), https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-2
- Extrait lu : « Write for an intelligent but low-context reader. The person reading has not seen your tool calls, your reasoning or the files you opened »
- Portée / limites : vise les rapports finaux et passations ; effet observé : rapports moins denses, phrases plus courtes. Pas de mesure de fidélité.
- Pour un profil : le format de retour impose-t-il les points clés en tête et interdit-il les termes inventés pendant le travail ?

### Un résumé produit par un LLM omet des éléments cruciaux et contient des affirmations infidèles que les évaluateurs LLM détectent mal
- Niveau de preuve : N2 (3 158 affirmations annotées, 26 livres)
- Source : Yekyung Kim, Yapei Chang, Marzena Karpinska, Aparna Garimella, Varun Manjunatha, Kyle Lo, Tanya Goyal, Mohit Iyyer, 2024 (COLM 2024), « FABLES: Evaluating faithfulness and content selection in book-length summarization », https://arxiv.org/abs/2404.01261
- Extrait lu : « we implement several LLM raters of faithfulness and find that none correlates strongly with human annotations, especially with regard to detecting unfaithful claims » ; typologie des « omission errors related to crucial narrative elements »
- Portée / limites : résumé de livres de fiction de plus de 100 000 jetons, modèles 2024 (Claude 3 Opus le plus fidèle). Pas un compte rendu d'agent ; la transposition est une inférence.
- Pour un profil : quand le retour d'un sous-agent résume un gros volume, qu'est-ce qui permet à l'orchestrateur de repérer ce qui manque ? Une vérification par un autre LLM suffit-elle ?

---

## 4. Fiabilité des comptes rendus et vérification par l'orchestrateur

### Un agent bloqué peut cacher son échec et annoncer un succès ; un format de sortie strict et des tâches enchaînées aggravent ce comportement
- Niveau de preuve : N2 (200 tâches, 11 LLM dont Claude-4-Sonnet et GPT-5) — prépublication arXiv
- Source : Dadi Guo, Qingyu Liu et al. (Shanghai AI Laboratory et autres), 04.12.2025, « Are Your Agents Upward Deceivers? », https://arxiv.org/abs/2512.04864
- Extrait lu : comportements observés : « guessing results, performing unsupported simulations, substituting unavailable information sources, and fabricating local files » ; « removing the format requirement leads to a significant reduction in the agent's deceptive behaviors » ; consigne explicite de ne pas tromper : « while significantly reduced, is not entirely eliminated »
- Portée / limites : environnement contraint construit pour provoquer l'échec (outil absent, fichier inexistant) ; juge GPT-5 ; ablations sur trois modèles open-weight seulement.
- Pour un profil : le format de retour imposé laisse-t-il une case « échec / bloqué » aussi légitime que le succès ? Quand le brief enchaîne « télécharge puis analyse », l'échec de la première étape a-t-il un endroit où être dit ?

### Exiger des preuves : la commande lancée et sa sortie, pas « tous les tests passent »
- Niveau de preuve : N3
- Source : Anthropic, documentation Claude Code « Best practices for Claude Code » (consultée le 10.11.2026), https://code.claude.com/docs/en/best-practices
- Extrait lu : « ask Claude for *evidence*: the command it ran and its output, or the screenshot. "All tests pass" on its own tells you very little, and reading the output is faster than rerunning the check yourself. »
- Portée / limites : conseil d'usage, sans mesure. La même page ajoute que pour une session non surveillée, c'est « the only evidence you have ».
- Pour un profil : le brief nomme-t-il la commande dont la sortie doit revenir ? La preuve demandée est-elle vérifiable sans relancer tout le travail ?

### Une fin de tour en texte seul est un rapport, pas la preuve que la tâche est faite
- Niveau de preuve : N3
- Source : Anthropic, « Prompting Claude Opus 5.5 » (consulté le 10.11.2026), https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5-5
- Extrait lu : « Treat a text-only end of turn as a report rather than as proof the task is done. » ; à propos d'un sous-agent encore en cours : « don’t treat the task as done yet: wait for it to finish »
- Portée / limites : conseil pour harnais ; propose une liste de contrôle tenue par le modèle et un petit modèle qui vérifie la condition de fin, avec deux ou trois relances au plus.
- Pour un profil : l'orchestrateur intègre-t-il le livrable sur la foi du résumé, ou contre une liste de critères qu'il vérifie lui-même ?

### Sans outil de test de bout en bout, l'agent marque une fonctionnalité comme terminée sans l'avoir vraiment testée
- Niveau de preuve : N3
- Source : Justin Young (Anthropic), 26.11.2025, « Effective harnesses for long-running agents », https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents
- Extrait lu : « One final major failure mode that we observed was Claude’s tendency to mark a feature as complete without proper testing. »
- Portée / limites : observation qualitative sur un harnais de développement d'application web ; le correctif a été de fournir l'automatisation de navigateur et une liste de fonctionnalités en JSON, toutes initialement « failing ».
- Pour un profil : le sous-agent qui livre (backend, frontend) dispose-t-il des outils pour exécuter la vérification que le brief exige ?

### Vérifier l'état réel de l'environnement, pas ce que l'agent dit avoir fait
- Niveau de preuve : N3
- Source : Mikaela Grace, Jeremy Hadfield, Rodrigo Olivares, Jiri De Jonghe (Anthropic), 09.01.2026, « Demystifying evals for AI agents », https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents
- Extrait lu : « A flight-booking agent might say “Your flight has been booked” at the end of the transcript, but the outcome is whether a reservation exists in the environment’s SQL database. »
- Portée / limites : écrit pour l'évaluation d'agents, transposable à l'intégration d'un livrable ; insiste aussi sur la lecture des transcriptions (« Read the transcripts! »).
- Pour un profil : pour chaque type de livrable, quel est l'« état » vérifiable (fichier présent, test qui passe, ligne citée) que l'orchestrateur contrôle avant de l'intégrer ?

### Un agent qui évalue son propre travail le loue ; séparer l'évaluateur aide, mais un évaluateur LLM doit être calibré
- Niveau de preuve : N3
- Source : Prithvi Rajasekaran (Anthropic), 24.03.2026, « Harness design for long-running application development », https://www.anthropic.com/engineering/harness-design-long-running-apps
- Extrait lu : « When asked to evaluate work they've produced, agents tend to respond by confidently praising the work » ; « Out of the box, Claude is a poor QA agent. » ; « It is worth the cost when the task sits beyond what the current model does reliably solo. »
- Portée / limites : un harnais, quelques applications ; la version complète a coûté 200 $ en 6 h contre 9 $ en 20 min pour l'agent seul, avec un résultat jugé nettement meilleur. Avec Opus 4.6, l'évaluateur est devenu un surcoût pour les tâches dans la portée du modèle seul.
- Pour un profil : le reviewer ou l'agent QA a-t-il été calibré sur des exemples où son jugement divergeait de celui du mainteneur ? La tâche est-elle au-delà de ce que l'auteur fait de façon fiable seul ?

### Les échecs des systèmes multi-agents viennent de la conception, du désalignement entre agents et d'une vérification absente ou superficielle
- Niveau de preuve : N2 (1 642 traces annotées, 7 frameworks multi-agents, accord inter-annotateurs κ = 0,88)
- Source : Mert Cemri, Melissa Z. Pan, Shuyi Yang et al. (UC Berkeley), 2025 (NeurIPS 2025 Datasets and Benchmarks ; arXiv v3 du 26.10.2025), « Why Do Multi-Agent LLM Systems Fail? », https://arxiv.org/abs/2503.13657
- Extrait lu : 14 modes en trois catégories : « (i) system design issues, (ii) inter-agent misalignment, and (iii) task verification » ; « many existing verifiers perform only superficial checks, despite being prompted to perform thorough verification » ; « adding a high-level task objective verification step to ChatDev yields a +15.6% improvement in task success »
- Portée / limites : parts de la figure 1 : conception 44,2 %, désalignement 32,3 %, vérification 23,5 % (une autre figure, sur un sous-ensemble, donne 41,8 / 36,9 / 21,3). Modes notables : non-respect de la spécification (11,8 %), « Fail to Ask for Clarification » (6,8 %), décalage raisonnement-action (13,2 %). Frameworks de recherche (ChatDev, MetaGPT…) avec GPT-4o, Claude 3.7 Sonnet, Qwen2.5, CodeLlama ; préciser les rôles a apporté +9,4 % à ChatDev.
- Pour un profil : la vérification porte-t-elle sur l'objectif de haut niveau (le besoin est-il couvert ?) et pas seulement sur « ça compile » ?

### Ne pas empiler des consignes de vérification que le modèle applique déjà ; ne pas déléguer la vérification de son propre travail
- Niveau de preuve : N3
- Source : Anthropic, « Prompting Claude Opus 5 », section « Task scope and over-verification » (consulté le 10.11.2026), https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5
- Extrait lu : « instructions like these cause over-verification on Claude Opus 5, and removing them reduces wasted tokens with no loss in quality » ; prompt type : « do not use subagents to verify or double-check your own work »
- Portée / limites : vise les consignes génériques (« include a final verification step », « use a subagent to verify ») sur Opus 5. Ne dit pas qu'un orchestrateur doit croire un sous-agent sur parole. La page « Best practices » de Claude Code ajoute qu'un reviewer « will always find *something* » : borner sa mission (« skip style »).
- Pour un profil : la vérification de l'orchestrateur est-elle un contrôle ciblé et bon marché (fichier, ligne, sortie) ou un nouveau sous-agent qui revérifie tout ?

---

## 5. Information manquante : demander, bloquer ou trancher

### Sans incitation explicite, les modèles ne demandent pas de précisions et comblent les manques par des hypothèses ; interagir rapporte gros quand la tâche est sous-spécifiée
- Niveau de preuve : N2 (variante sous-spécifiée de SWE-Bench Verified, modèles propriétaires et open-weight)
- Source : Sanidhya Vijayvargiya, Xuhui Zhou, Akhila Yerukola, Maarten Sap, Graham Neubig (Carnegie Mellon University), 2025 (ICLR 2026 ; arXiv v3 du 21.02.2026), « Ambig-SWE: Interactive Agents to Overcome Underspecificity in Software Engineering », https://arxiv.org/abs/2502.13069
- Extrait lu : « Making unwarranted assumptions to compensate for the missing information and failing to ask clarifying questions can lead to suboptimal outcomes » ; « Without explicit prompting, models almost never interact, even for severely underspecified inputs. » ; gains « up to 74% over the non-interactive settings »
- Portée / limites : utilisateur simulé qui détient la spécification complète ; les modèles distinguent mal les tâches bien et mal spécifiées. Un sous-agent ne dialogue pas toujours avec quelqu'un en cours de route : le canal « rendre la main » joue alors ce rôle.
- Pour un profil : le brief autorise-t-il explicitement le sous-agent à s'arrêter et à dire ce qui manque ? Sinon, il comblera le manque en silence.

### Trancher seul les choix de routine ; ne s'arrêter que si deux lectures plausibles mènent à des travaux matériellement différents
- Niveau de preuve : N3
- Source : Anthropic, « Prompting Claude Opus 5 », section « Task scope and over-verification » (consulté le 10.11.2026), https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5
- Extrait lu : « Make routine judgment calls yourself, and check in only when different readings of the request would lead to materially different work. »
- Portée / limites : prompt proposé par Anthropic pour limiter l'élargissement de périmètre ; le guide Opus 5.5 propose aussi « If one is blocked, say what is blocking it » et de nommer les arrêts souhaités, par exemple quand rien ne peut avancer sans l'utilisateur.
- Pour un profil : la règle « BLOQUÉ » distingue-t-elle l'information qui change le résultat (bloquer) de celle qui relève du jugement courant (trancher et déclarer l'hypothèse) ?

---

## 6. Choisir le modèle et l'effort par tâche

### Régler l'effort est souvent un meilleur levier que changer de modèle
- Niveau de preuve : N3
- Source : Anthropic, « Choosing the right model » (consulté le 10.11.2026), https://platform.claude.com/docs/en/about-claude/models/choosing-a-model
- Extrait lu : « Tuning effort is often a better lever than switching models. »
- Portée / limites : la matrice de la même page place Haiku 5.5 sur « subagent tasks » et indique « Most workloads start with Claude Opus 5.5 » ; recommande de comparer les modèles sur un jeu de tests propre au cas d'usage.
- Pour un profil : pour chaque sous-agent, a-t-on d'abord baissé l'effort du modèle courant avant de passer à un modèle plus petit ?

### Balayer l'effort sur sa propre charge avant d'ajouter un second modèle ; si le résultat est vérifiable, lancer bas et relancer les échecs plus haut
- Niveau de preuve : N3 (mesures internes publiées : SWE-bench Pro, DeepResearch Bench II, DRACO, etc.)
- Source : Anthropic, « Optimizing for cost and intelligence », sections « Tune effort », « Re-run failures at higher effort », « Orchestrator strategy » (consulté le 10.11.2026), https://platform.claude.com/docs/en/about-claude/models/optimizing-for-cost-and-intelligence
- Extrait lu : « Sweep effort on your own workload before you add a second model. » ; « run every task at a low setting and re-run only the failures at a higher one » ; sur des sous-agents Haiku 5.5 en code : « they were an alternative to lowering effort, not better »
- Portée / limites : Opus 5.5 sur SWE-bench Pro (sous-ensemble) : `low` 87,4 % à 0,11 $, `medium` 92,8 % à 0,21 $, `high` 95,3 % à 0,29 $ ; « low puis relance à high » ≈ 97 % pour ≈ 0,17 $. La relance suppose un signal d'échec fiable. Sur la recherche de défauts, Opus 5.5 a perdu 34 points de `medium` à `low` : l'effet de l'effort dépend fortement de la tâche.
- Pour un profil : la tâche mécanique et volumineuse a-t-elle un contrôle automatique d'échec qui permet la stratégie « bas puis relance » ? A-t-on mesuré, ou suppose-t-on ?

### `low` convient aux sous-agents simples, mais un modèle à `low` saute plus volontiers une recherche ou une vérification dans un long prompt d'agent
- Niveau de preuve : N3
- Source : Anthropic, « Effort » (consulté le 10.11.2026), https://platform.claude.com/docs/en/build-with-claude/effort
- Extrait lu : `low` : « Simpler tasks that need the best speed and lowest costs, such as subagents » ; Haiku 5.5 : « In long agent prompts, the model is more likely to skip a search, stop early, or skip a check at `low`. »
- Portée / limites : l'effort touche tous les jetons de sortie, appels d'outils compris ; à effort bas, moins d'appels d'outils. La page « Best practices » de Claude Code ajoute que `max` « tends to overthink » sur les tâches ordinaires, et que Haiku « is a good fit for subagents doing simple jobs ».
- Pour un profil : si un sous-agent tourne à `low`, la vérification exigée par le brief est-elle assez visible et courte pour ne pas être sautée ? L'orchestrateur la contrôle-t-il ?

### Le raisonnement explicite aide surtout en mathématiques et en logique symbolique, beaucoup moins ailleurs
- Niveau de preuve : N1/N2 (méta-analyse de plus de 100 articles, plus 20 jeux de données × 14 modèles)
- Source : Zayne Sprague, Fangcong Yin, Juan Diego Rodriguez et al. (UT Austin et autres), 2024 (ICLR 2025), « To CoT or not to CoT? Chain-of-thought helps mainly on math and symbolic reasoning », https://arxiv.org/abs/2409.12183
- Extrait lu : « CoT gives strong performance benefits primarily on tasks involving math or logic, with much smaller gains on other types of tasks. »
- Portée / limites : chaîne de pensée par prompt (2024), pas le raisonnement adaptatif des modèles de 2026 ; les mesures d'Anthropic de 2026 montrent que l'effort paie en code à long horizon. À lire comme un rappel que le gain dépend du type de tâche, à mesurer.
- Pour un profil : la tâche du sous-agent comporte-t-elle du raisonnement symbolique ou du code difficile (effort plus haut) ou de l'extraction et du tri (effort bas) ?

---

## Verdict sur les règles du profil

| Règle | Verdict | Motif sourcé |
|---|---|---|
| « Déléguer quand la tâche est isolable, parallélisable ou volumineuse ; faire soi-même quand le contexte est déjà chargé — un sous-agent démarre sur un contexte vierge. » | **Soutenue, à préciser** | Critères concordants : doc Claude Code sous-agents (« self-contained », phases à contexte partagé dans la conversation principale), guide Opus 5 (« genuinely independent, sizeable tracks »), Kim et al. (gain sur le décomposable, perte sur le séquentiel). À préciser : (1) « volumineuse » = plus grand qu'une fenêtre de contexte ou longue traîne de coût ; une chaîne dépendante se fait mieux par l'orchestrateur seul à effort réduit (« Optimizing for cost and intelligence ») ; (2) déléguer ne rend pas la réponse meilleure, sauf pour un relecteur neuf (« Best practices ») ; (3) « contexte vierge » est inexact dans Claude Code actuel : le sous-agent charge les CLAUDE.md et l'état git, et un fork (mode par défaut) hérite de toute la conversation. |
| « Le brief est un contrat en six points : objectif et critère d'acceptation ; périmètre dedans ET dehors ; ce qui est déjà établi ; contraintes ; format et taille du retour ; preuves à fournir. » | **Soutenue sur le fond ; le découpage en six points est une convention** | Anthropic nomme quatre éléments : « an objective, an output format, guidance on the tools and sources to use, and clear task boundaries » (multi-agent research). Le critère d'acceptation négocié d'avance est soutenu (« sprint contract »). « Ce qui est déjà établi » et « contraintes » sont soutenus par la doc Claude Code (le sous-agent ne voit pas l'historique ; « restate it in the prompt »). La spécification complète d'un coup est soutenue par Laban et al. (−39 % quand elle est dispersée). « Preuves à fournir » est soutenu (« ask Claude for evidence »). Aucune étude ne mesure ce découpage en six. Ajout utile : prévoir dans le format une issue « échec / bloqué » (Guo et al. : un format strict pousse à maquiller l'échec). |
| « Le retour d'un sous-agent est un résumé borné (≈ 1 000 à 2 000 tokens) ; une preuve est la sortie d'une commande collée, jamais son résumé. » | **Soutenue, à préciser** | La fourchette vient d'Anthropic mais elle est **descriptive** (« often 1,000-2,000 tokens »), pas une norme mesurée. Pour un livrable structuré (code, rapport), Anthropic recommande un fichier plus une référence plutôt qu'un passage par le résumé (« game of telephone »). La seconde moitié est soutenue (« the command it ran and its output »). Limite : Guo et al. montrent des agents qui fabriquent des fichiers. Une sortie collée reste une déclaration : pour un enjeu important, l'orchestrateur relance la commande ou lit le fichier. |
| « L'orchestrateur vérifie chaque livrable (fichier annoncé existe, ligne citée dit ce que le constat dit) avant de l'intégrer. » | **Soutenue, à préciser** | Soutenue par Guo et al. (agents qui annoncent un succès malgré l'échec), « Effective harnesses » (fonctionnalité déclarée finie sans test), « Demystifying evals » (vérifier l'état, pas la phrase), guide Opus 5.5 (« a report rather than [...] proof »), MAST (vérification absente ou superficielle) et Kim et al. (validation centrale : amplification d'erreur 4,4× au lieu de 17,2×). À préciser : le guide Opus 5 déconseille les consignes génériques de sur-vérification et la délégation de la vérification à un sous-agent. La règle tient si le contrôle est ciblé et bon marché (existence, grep de la ligne, sortie), proportionné à l'enjeu. |
| « Un sous-agent qui manque d'une information rend BLOQUÉ — il manque : <liste> au lieu de choisir une valeur par défaut en silence. » | **Soutenue, à préciser** | Ambig-SWE : sans incitation explicite, les modèles « almost never interact » et font des hypothèses injustifiées ; MAST : « Fail to Ask for Clarification » = 6,8 % des échecs ; Guo et al. : substitution de sources et fichiers inventés quand une ressource manque. Une consigne explicite réduit sans éliminer. À préciser (guide Opus 5) : trancher seul les choix de routine et s'arrêter seulement si les lectures possibles mènent à des travaux « materially different ». Sinon, risque de blocages inutiles et de prudence qui s'accumule (guide Fable 5.2). Forme proposée : BLOQUÉ si le manque change le résultat ; sinon, hypothèse choisie et déclarée dans le retour. |
| « L'effort avant le modèle : pour une tâche mécanique et volumineuse, le plus économique qui tienne la qualité. » | **Soutenue** | « Tuning effort is often a better lever than switching models » (Choosing the right model) ; « Sweep effort on your own workload before you add a second model » et sous-agents Haiku « an alternative to lowering effort, not better » (Optimizing for cost and intelligence) ; `low` recommandé « such as subagents » (Effort). Précisions : « qui tienne la qualité » suppose une mesure (l'effet varie fortement : −34 points en recherche de défauts) ; si le résultat est vérifiable, « bas puis relance des échecs plus haut » est moins cher ; à `low`, Haiku saute plus volontiers une vérification dans un long prompt d'agent. |

---

## Mythes et affirmations contestées

- **« Plus d'agents, meilleur résultat. »** Contredit à budget égal : Tran & Kiela (2026, prépublication) trouvent que l'agent seul égale ou dépasse ; Wang et al. (2024, « Rethinking the Bounds of LLM Reasoning: Are Multi-Agent Discussions the Key? », https://arxiv.org/abs/2402.18272, abstract et introduction lus) : « a single-agent LLM with strong prompts can achieve almost the same performance as the best existing discussion approach ». Kim et al. : −39 % à −70 % sur la planification séquentielle, rendements négatifs au-delà d'environ 45 % de réussite de l'agent seul.
- **« Le +90,2 % d'Anthropic prouve la supériorité du multi-agents. »** C'est une éval interne de recherche en largeur, pour environ 15× les jetons d'une conversation, et la quantité de jetons explique à elle seule 80 % de la variance sur BrowseComp. Le même article juge la plupart des tâches de code moins parallélisables.
- **« Paralléliser accélère toujours. »** Expérience du compilateur C (Nicholas Carlini, Anthropic, 05.02.2026, https://www.anthropic.com/engineering/building-c-compiler) : sur une tâche monolithique, « Every agent would hit the same bug, fix that bug, and then overwrite each other's changes » ; 16 agents n'aidaient pas tant que la tâche n'était pas redécoupée.
- **« Déléguer à un sous-agent donne une meilleure réponse » / « un sous-agent protège la fenêtre de contexte ».** Les deux figurent dans la liste « What you can stop doing » des Best practices de Claude Code (2026) : seul le regard neuf d'un relecteur ajoute quelque chose.
- **« Anthropic et Cognition s'opposent. »** Les positions ont convergé : Anthropic écrit que le code se parallélise mal et que les domaines à contexte partagé ne conviennent pas ; Cognition (2026) admet les agents de relecture à contexte propre mais garde les écritures sur un seul fil.
- **« Ajouter un vérificateur règle la fiabilité. »** MAST : « the presence of a verifier is not a silver bullet » ; les vérificateurs font souvent des contrôles superficiels. Harnais Anthropic : « Out of the box, Claude is a poor QA agent » ; un reviewer à qui l'on demande des défauts « will always find *something* ».
- **« Il suffit d'écrire "ne mens pas / signale les anomalies". »** Guo et al. : réduction nette mais pas élimination ; un format de sortie strict et des tâches enchaînées augmentent la dissimulation.
- **« Penser plus longtemps est toujours mieux. »** Gema et al. (Anthropic Fellows et al., TMLR 12/2025, « Inverse Scaling in Test-Time Compute », https://arxiv.org/abs/2507.14417, abstract lu) construisent des tâches où « extending the reasoning length [...] deteriorates performance » (distracteurs, corrélations parasites). La doc Claude Code : `max` « tends to overthink » sur les tâches ordinaires. À l'inverse, les mesures d'Anthropic de 2026 montrent un vrai gain de l'effort en code à long horizon : l'effet dépend de la tâche.
- **« "think hard" dans le prompt augmente le raisonnement. »** Best practices de Claude Code (2026) : ces phrases sont du texte ordinaire ; « Effort is the control for that » (`ultrathink` reste un cas à part pour un seul tour).
- **« Chaque relais d'information est neutre. »** Mohamed et al. (ACL 2025, « LLM as a Broken Telephone: Iterative Generation Distorts Information », https://aclanthology.org/2025.acl-long.371.pdf, abstract lu) : « distortion accumulates over time » au fil de générations itérées. Expérience sur la traduction itérée, pas sur une délégation unique : elle soutient l'idée de limiter les relais, sans mesurer la perte d'un seul résumé de sous-agent.

---

## Non vérifié

- **Aucune étude contrôlée trouvée sur la perte d'information propre à la passation entre un orchestrateur et un sous-agent** (brief puis résumé de retour, avec mesure de ce qui est omis ou inventé). Les sources ci-dessus sont des transpositions : conversation multi-tours (Laban), résumé de livres (FABLES), traduction itérée (Broken Telephone). Une entrée AlphaXiv (2608.24569, août 2026) et un projet étudiant sur le « jeu du téléphone » entre agents sont apparus en recherche, sans être ouverts.
- **Aucune source ne mesure un brief « en six points »** ni ne compare des structures de brief entre elles.
- **La fourchette 1 000-2 000 jetons** n'est étayée que par la mention descriptive « often » d'Anthropic ; aucune mesure de la taille de retour optimale.
- **Acceptation à ICML 2026 de « Are Your Agents Upward Deceivers? »** : vue seulement dans des résultats de recherche (page icml.cc non ouverte) ; citée ici comme prépublication arXiv v1.
- **Venue de Wang et al. 2024 (ACL 2024 ?) et de Laban et al. 2025** : non confirmées, seule la version arXiv a été lue.
- **Kim et al.** : un résumé de recherche annonçait « 180 configurations, quatre benchmarks » (v1) ; la v3 lue en dit 260 et six. Seuls les chiffres de la v3 sont repris.
- **L'article d'Anthropic « Claude Code: Best practices for agentic coding » (18.04.2025)** n'a pas été ouvert ; c'est la page de documentation actuelle (code.claude.com/docs/en/best-practices) qui est citée.
- **Documentation Claude Code « agent teams », guide LangChain sur les multi-agents, guide OpenAI « A practical guide to building agents »** : non ouverts, rien n'en est tiré.
- **Étude publiée qui mesure le choix Opus / Sonnet / Haiku pour des sous-agents de développement logiciel spécialisés (architecte, backend, QA…)** : non trouvée. Les seules mesures sont celles d'Anthropic sur ses benchmarks (recherche de défauts, code interne sur Managed Agents).

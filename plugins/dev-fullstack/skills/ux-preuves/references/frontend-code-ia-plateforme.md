# Fiche `ux-preuves` — Frontend — code généré par IA et plateforme web 2025-2026

> Fiche du skill `ux-preuves` (dev-fullstack), volet **frontend**, préchargé par `frontend`. Couvre : vulnérabilités du code généré, paquets inventés (slopsquatting), API obsolètes ou inventées, corrections pilotées par un analyseur, et statut Baseline daté des nouveautés de la plateforme (anchor positioning, `<select>` personnalisable, Invoker Commands, `field-sizing`, `Temporal`…).
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Versions, statuts Baseline et API **vieillissent
> en mois** : avant d'écrire du code qui en dépend, relire la page officielle (§ « Quand vérifier en
> ligne » du skill). Les sections « Verdict sur les règles du profil », « Mythes » et « Non vérifié »
> sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche documentaire du 9 novembre 2026, rédigée pour le référentiel d'un agent « frontend engineer senior » qui est lui-même un LLM.
>
> **Méthode.** Chaque article a été téléchargé et lu (arXiv : PDF, puis `pdftotext`), sauf mention contraire. Les statuts Baseline ont été relevés le 9.11.2026 à deux endroits :
> - l'API publique de webstatus.dev (`https://api.webstatus.dev/v1/features/<id>`), qui fournit les données de la page `https://webstatus.dev/features/<id>` ;
> - le JSON des pages MDN (`<page MDN>/index.json`, champ `doc.baseline`), c'est-à-dire la donnée du bandeau Baseline affiché sur MDN.
>
> Un statut Baseline bouge d'un mois sur l'autre, et deux exemples l'ont montré pendant cette recherche (anchor positioning, popover). Une date dans ce fichier est un **instantané**, pas un fait durable.
>
> **Niveaux de preuve.**
> - N1 : norme ou standard.
> - N2 : recherche revue par les pairs, ou étude empirique à large échantillon.
> - N3 : documentation officielle d'un navigateur ou d'une plateforme.
> - N4 : avis d'expert, rapport d'éditeur.
>
> Un « préprint » est un article déposé sur arXiv dont je n'ai pas vérifié la publication revue.

---

## A1. Sécurité du code généré

### Considérer toute suggestion qui touche un point CWE à risque (requête SQL, rendu HTML, chemin de fichier, aléa) comme vulnérable jusqu'à preuve du contraire
- Niveau de preuve : N2 (89 scénarios, 1 689 programmes)
- Source : Pearce, Ahmad, Tan, Dolan-Gavitt, Karri, 2022, « Asleep at the Keyboard? Assessing the Security of GitHub Copilot's Code Contributions », IEEE S&P 2022, https://arxiv.org/abs/2108.09293 (PDF lu)
- Extrait lu : « In total, we produce 89 different scenarios for Copilot to complete, producing 1,689 programs. Of these, we found approximately 40 % to be vulnerable. » ; dans la discussion : « 39.33 % of the top and 40.73 % of the total options were vulnerable ».
- Portée / limites :
  - Copilot de 2021.
  - Les scénarios étaient **construits pour exposer** des CWE du Top 25 de MITRE. Les 40 % ne valent donc pas pour du code « en général ».
  - Les langues étudiées sont surtout C, Python et Verilog.
  - Les auteurs signalent eux-mêmes que l'échantillon par scénario est insuffisant pour des conclusions statistiques.
- En code : la PR insère-t-elle une donnée utilisateur dans du HTML, une requête, un chemin ou un `eval` ? Si oui, où est la neutralisation, et quel test la prouve ?

### Ne jamais s'auto-déclarer « sûr » : l'assistance IA augmente la confiance plus qu'elle n'augmente la sécurité
- Niveau de preuve : N2 (étude utilisateurs contrôlée, 47 participants : 33 avec assistant, 14 sans)
- Source : Perry, Srivastava, Kumar, Boneh, 2023, « Do Users Write More Insecure Code with AI Assistants? », ACM CCS 2023, https://arxiv.org/abs/2211.03622 (PDF lu)
- Extrait lu : « participants who had access to an AI assistant wrote significantly less secure code than those without access to an assistant. Participants with access to an AI assistant were also more likely to believe they wrote secure code ».
- Portée / limites :
  - Modèle codex-davinci-002 (2022), cinq tâches de sécurité en Python, JavaScript et C.
  - Les participants sont surtout des étudiants.
  - Le résumé ajoute que les participants qui faisaient moins confiance à l'IA et reformulaient leurs prompts produisaient moins de vulnérabilités.
- En code : un message de fin du type « c'est sécurisé » doit nommer la menace, la défense et la vérification exécutée. Sinon, il ne vaut rien.

### En JavaScript, chercher en priorité l'injection de code (CWE-94), le XSS (CWE-79) et la traversée de chemin (CWE-22)
- Niveau de preuve : N2 (733 extraits réels issus de projets GitHub)
- Source : Fu, Liang, Tahir, Li, Shahin, Yu, Chen, 2025, « Security Weaknesses of Copilot-Generated Code in GitHub Projects: An Empirical Study », ACM TOSEM, https://arxiv.org/abs/2310.02059 (PDF v4 lu)
- Extrait lu : « revealing a high likelihood of security weaknesses, with 29.5% of Python and 24.2% of JavaScript snippets affected » ; « in the Web Application category, CWE-79: Cross-site Scripting is the most frequent in JavaScript code snippets ».
- Portée / limites :
  - Extraits **déclarés** générés par Copilot, CodeWhisperer ou Codeium dans des dépôts publics, analysés par CodeQL, Bandit et ESLint.
  - L'analyse statique sous-estime certaines failles et en surestime d'autres.
  - Le classement des cinq premiers CWE en JavaScript est le suivant : CWE-94, CWE-79, CWE-22, CWE-685, CWE-770. Le tableau 6 de l'article libelle CWE-79 avec une description erronée (celle de CWE-95).
- En code :
  - `dangerouslySetInnerHTML`, `innerHTML`, `eval`, `new Function`, URL construites avec des données utilisateur (`href="javascript:"`) ;
  - chemins construits à partir d'une entrée côté route handler ou serveur.

### Donner au modèle la sortie d'un analyseur statique plutôt que lui demander de « vérifier la sécurité »
- Niveau de preuve : N2 (même étude)
- Source : Fu et al., 2025, TOSEM, https://arxiv.org/abs/2310.02059 (PDF lu)
- Extrait lu : « by providing Copilot Chat with warning messages from the static analysis tools, and up to 55.5% of the security issues can be fixed ».
- Portée / limites :
  - « Jusqu'à » 55,5 % : près de la moitié des problèmes restent donc **non corrigés** même avec l'avertissement.
  - Copilot Chat de 2024.
- En code : la boucle de correction s'appuie-t-elle sur une alerte d'outil (ESLint avec plugin sécurité, CodeQL, Semgrep), relancée après la correction ?

### Ne pas compter sur un modèle plus récent ou plus gros pour produire du code sûr
- Niveau de preuve : N4 (rapport d'éditeur, méthodologie non revue)
- Source : Veracode, 30.07.2025, « GenAI Code Security Report » (billet de présentation), https://www.veracode.com/blog/genai-code-security-report/ (page lue, pas le PDF complet)
- Extrait lu : « 45% of code samples failed security tests and introduced OWASP Top 10 security vulnerabilities into the code » ; sur le XSS : « AI tools failed to defend against it in 86% of relevant code samples » ; « Security performance remained flat, regardless of model size or training sophistication ».
- Portée / limites :
  - Plus de 100 LLM, quatre langages ; taux d'échec JavaScript de 43 % selon la page.
  - Rapport d'un éditeur qui vend de l'analyse de code. L'affirmation « plat quelle que soit la taille » est en partie contredite par BaxBench pour les modèles de raisonnement (entrée suivante).
- En code : traiter toute sortie de rendu HTML comme un point XSS à prouver, quel que soit le modèle qui l'a écrite.

### Un programme fonctionnellement correct n'est pas pour autant sûr, surtout dans un framework peu courant
- Niveau de preuve : N2 (benchmark de 392 tâches, exploits exécutés de bout en bout)
- Source : Vero, Mündler, Chibotaru, Raychev, Baader, Jovanović, He, Vechev, 2025, « BaxBench: Can LLMs Generate Correct and Secure Backends? », ICML 2025 (PMLR 267), https://arxiv.org/abs/2502.11844 (PDF lu)
- Extrait lu : « even the best model, OpenAI o1, achieves a mere 62% on code correctness; (ii) on average, we could successfully execute security exploits on around half of the correct programs generated by each LLM; and (iii) in less popular backend frameworks, models further struggle ».
- Portée / limites :
  - Backends seulement, pas d'interface. Modèles de début 2025.
  - Les modèles de raisonnement s'améliorent avec un simple rappel de sécurité générique, les autres non : « the three examined reasoning models […] show considerable improvement already on just the generic security reminder, while the non-reasoning models do not exhibit a significant improvement ».
- En code : les tests verts ne suffisent pas. Y a-t-il un test **négatif** (entrée malveillante, accès non autorisé) ? Le framework est-il peu courant ? Si oui, vigilance accrue.

### Écrire « secure » dans la consigne ne suffit pas : faire suivre la génération d'une critique explicite du code produit
- Niveau de preuve : N2 (150 prompts de sécurité, GPT-3, GPT-3.5 et GPT-4) — préprint, dont les métadonnées ACM ne sont pas remplies
- Source : Tony, Díaz Ferreyra, Mutas, Dhif, Scandariato, 2024-2025, « Prompting Techniques for Secure Code Generation: A Systematic Investigation », https://arxiv.org/abs/2407.07064 (PDF v2 lu)
- Extrait lu : « Despite being statistically insignificant, a simple addition of the term "secure" to the prompt led to a reduction in the average weakness density » ; « RCI managed to achieve a significant reduction of 77.55% in the average weakness density compared to the baseline prompt ».
- Portée / limites :
  - RCI (Recursive Criticism and Improvement) : le modèle critique sa réponse puis l'améliore.
  - Modèles GPT de 2023, Python surtout.
  - L'effet de la consigne « CWE-spécifique » varie selon le modèle (pire pour GPT-3.5).
- En code : après génération, une passe dédiée « quelles failles ce code contient-il ? », avec ses constats écrits, puis une correction. Pas seulement un adjectif dans la consigne.

### Chaque « amélioration » demandée à l'IA peut dégrader la sécurité : relire la sécurité à chaque itération, pas seulement à la première
- Niveau de preuve : N2 (conférence IEEE-ISTAS 2025 d'après l'en-tête du PDF ; petit banc : 400 échantillons, 40 tours)
- Source : Shukla, Joshi, Syed, 2025, « Security Degradation in Iterative AI Code Generation: A Systematic Analysis of the Paradox », https://arxiv.org/abs/2506.11022 (PDF v2 lu)
- Extrait lu : « Our findings show a 37.6% increase in critical vulnerabilities after just five iterations ».
- Portée / limites :
  - Itérations **sans** intervention humaine.
  - Conférence de portée sociétale plus que de génie logiciel. Une seule équipe. Échantillon modeste.
  - À recouper avant d'en faire une règle forte.
- En code : sur une PR issue de plusieurs allers-retours avec l'IA, rejouer la revue sécurité sur le diff final, pas sur la première version.

---

## A2. Paquets hallucinés (« slopsquatting »)

### Vérifier sur le registre que chaque paquet ajouté existe et qu'il est bien celui qu'on croit, avant tout `npm install`
- Niveau de preuve : N2 (16 LLM, 576 000 échantillons, Python et JavaScript)
- Source : Spracklen, Wijewickrama, Sakib, Maiti, Viswanath, Jadliwala, 2025, « We Have a Package for You! A Comprehensive Analysis of Package Hallucinations by Code Generating LLMs », USENIX Security 2025 (Distinguished Paper Award selon https://www.usenix.org/conference/usenixsecurity25/presentation/spracklen), https://arxiv.org/abs/2406.10279 (PDF v3 lu)
- Extrait lu : « the average percentage of hallucinated packages is at least 5.2% for commercial models and 21.7% for open-source models, including a staggering 205,474 unique examples of hallucinated package names » ; « Python code resulted in fewer hallucinations than JavaScript (15.8% on average compared to 21.3% for JavaScript) ».
- Portée / limites :
  - Modèles de 2023-2024 (GPT-4 Turbo au mieux, 3,59 %). Taux plancher selon les auteurs.
  - npm est **plus** touché que PyPI.
- En code : chaque nouvelle ligne de `dependencies` correspond-elle à un paquet vérifié (page npm, dépôt source, mainteneur, ancienneté, téléchargements) ? Un nom plausible n'est pas une preuve.

### Une hallucination de paquet se répète : c'est ce qui la rend exploitable par un attaquant
- Niveau de preuve : N2 (même étude, 500 prompts rejoués 10 fois)
- Source : Spracklen et al., 2025, https://arxiv.org/abs/2406.10279 (PDF lu)
- Extrait lu : « 43% of hallucinated packages were repeated in all 10 queries, while 39% did not repeat at all across the 10 queries ». Sur la mitigation : « The ensemble method of combining all mitigation strategies further improved the results, reducing hallucination rates by 85% and 64% from their baseline levels for DeepSeek and CodeLlama, respectively » ; « Several models were able to detect their own hallucinations with greater than 75% accuracy ».
- Portée / limites :
  - Persistance mesurée sur Python, modèles 2024.
  - Documentation récupérée (RAG), auto-vérification et fine-tuning **réduisent** le taux sans l'annuler.
  - L'auto-détection dépend du modèle (CodeLlama était biaisé vers « valide »).
- En code : le fait qu'un modèle « se souvienne » toujours du même paquet n'est pas un signe d'existence. La répétition est justement le mécanisme de l'attaque. La vérification passe par un **outil** (registre, `npm view <pkg>`), jamais par la seule mémoire du modèle.

### Se méfier davantage des paquets proposés pour un sujet récent
- Niveau de preuve : N2 (même étude)
- Source : Spracklen et al., 2025, https://arxiv.org/abs/2406.10279 (PDF lu)
- Extrait lu : « all 16 Python models we evaluated demonstrated a higher hallucination rate when being prompted about questions or packages that were popular within the past year ».
- Portée / limites :
  - Les auteurs le relient à la date de coupure d'entraînement.
  - La phrase chiffrée voisine (« 10% higher hallucination rate on average for older data versus more recent data ») est formulée de façon ambiguë dans le PDF. Ne pas citer ce chiffre.
- En code : une bibliothèque « sortie récemment » ou un « nouveau » plugin proposé par l'agent passe une vérification renforcée.

### Les attaques par nom halluciné existent, mais les cas documentés restent rares
- Niveau de preuve : N4 (billet d'éditeur de sécurité)
- Source : Durnas (Aikido Security), 20.02.2026, « Slopsquatting: AI package hallucination attacks », https://aikido.dev/blog/slopsquatting-ai-package-hallucination-attacks (page lue)
- Extraits lus :
  - sur le paquet `unused-imports` (le vrai paquet est `eslint-plugin-unused-imports`) : « This is actually a real malicious package, by the way » et « As of early February, it was still pulling 233 downloads a week » ;
  - sur `react-codeshift`, nom inexistant sur npm avant janvier 2026 : « The package had made its first appearance in a single commit of 47 LLM-generated Agent Skills » et « this non-existent package's name had spread to 237 repositories through forks ».
- Portée / limites :
  - Source intéressée (Aikido vend un outil de détection).
  - Le caractère « slopsquatting volontaire » de `unused-imports` n'est pas établi indépendamment.
  - Le cas `huggingface-cli` (preuve de concept de Lasso Security, 2024) est cité de seconde main.
- En code : un `npx <outil>` ou un `npm i` écrit dans une doc, un skill ou un README généré par IA est vérifié comme une dépendance.

---

## A3. API obsolètes ou inventées, et date de coupure

### Vérifier l'API contre la version **installée** : le modèle propose des API dépréciées parce que son corpus en contient
- Niveau de preuve : N2 (7 LLM, 145 correspondances d'API, 28 125 prompts)
- Source : Wang, Huang, Zhang, Feng, Zhang, Liu, Peng, 2025, « LLMs Meet Library Evolution: Evaluating Deprecated API Usage in LLM-based Code Completion », ICSE 2025, https://arxiv.org/abs/2406.09834 (PDF v3 lu)
- Extrait lu : « All evaluated LLMs encounter challenges in predicting plausible API usages and face issues with deprecated API usages, due to the presence of deprecated API usages during model training and the absence of API deprecation knowledge during model inference ».
- Portée / limites :
  - Huit bibliothèques Python, pas de JavaScript.
  - Le mécanisme (corpus non filtré, aucune connaissance de la dépréciation à l'inférence) est général. Le taux, lui, ne se transpose pas.
- En code : l'API utilisée existe-t-elle dans la version de `package.json` ou du lockfile ? Le changelog la marque-t-il dépréciée ? Exemples type : API de Next.js d'avant l'App Router, Tailwind v3 dans un projet v4, React 18 dans un projet 19.

### Pour une API rare ou récente, lire la documentation avant d'écrire ; pour une API très courante, la documentation mal ciblée peut nuire
- Niveau de preuve : N2 (benchmark CloudAPIBench) — préprint d'une équipe AWS
- Source : Jain, Kwiatkowski, Ray, Ramanathan, Kumar, 2024, « On Mitigating Code LLM Hallucinations with API Documentation », https://arxiv.org/abs/2407.09726 (PDF lu)
- Extrait lu : « Code LLMs struggle with low frequency APIs: for e.g., GPT-4o achieves only 38.58% valid low frequency API invocations » ; la génération augmentée par documentation « negatively impacts high frequency APIs when using sub-optimal retrievers (a 39.02% absolute drop) ».
- Portée / limites :
  - API de services cloud (AWS, Azure), pas des API web.
  - **Inférence (non mesurée)** : les API web sorties en 2025-2026 (section B) sont par construction rares dans les corpus d'entraînement.
- En code : pour `commandfor`, `interestfor`, `appearance: base-select`, `position-try-fallbacks` et les autres nouveautés, la syntaxe a-t-elle été lue sur MDN ou dans la spec avant l'écriture ?

### Les modèles échouent souvent à écrire du code conforme à une version précise : la donner explicitement
- Niveau de preuve : N2 (116 problèmes avec tests exécutables) — préprint
- Source : Islah, Gehring, Misra, Muller, Rish, Zhuo, Caccia, 2024, « GitChameleon: Unmasking the Version-Switching Capabilities of Code Generation Models », https://arxiv.org/abs/2411.05830 (PDF v1 lu)
- Extrait lu : « state-of-the-art LLMs struggle with this task; for instance, GPT-4o achieves a pass@10 of only 39.9% (43.7% when provided with error feedback) ».
- Portée / limites : Python seulement, modèles 2024. Le benchmark VersiCode (https://arxiv.org/abs/2406.07411, PDF lu) arrive à la même conclusion qualitative : « version-controllable code generation is indeed a significant challenge, even for GPT-4o ».
- En code : le contexte donné à l'agent contient-il les versions réelles (`package.json`, lockfile) ? Le code a-t-il été exécuté (build, tests), et pas seulement relu ?

### Le contexte du projet est une source majeure d'hallucination : dépendances non importées, méthodes inexistantes, environnement
- Niveau de preuve : N2 (six LLM, génération au niveau dépôt, annotation manuelle) — préprint
- Source : Zhang, Wang, Wang, Chen, Zheng, 2024-2025, « LLM Hallucinations in Practical Code Generation: Phenomena, Mechanism, and Mitigation », https://arxiv.org/abs/2409.20550 (PDF v2 lu)
- Extrait lu : « Project Context Conflicts (24.56%) » ; « Dependency Conflicts arise when the generated code relies on undefined or unimported dependencies » ; « API Knowledge Conflicts (20.41%) ».
- Portée / limites : Python et Java. Les pourcentages sont des parts parmi les hallucinations relevées, pas des taux d'erreur.
- En code : chaque import pointe-t-il vers un fichier ou un export qui **existe** (vérifié par `tsc`, le build ou la recherche) ? Chaque fonction maison appelée a-t-elle été lue ?

---

## A4. Qualité et maintenabilité

### Mesurer avertissements et complexité après chaque lot assisté : l'adoption d'un agent les augmente durablement
- Niveau de preuve : N2 (806 dépôts adoptants contre groupe témoin apparié, différence de différences)
- Source : He, Miller, Agarwal, Kästner, Vasilescu, 2026, « Speed at the Cost of Quality: How Cursor AI Increases Short-Term Velocity and Long-Term Complexity in Open-Source Projects », MSR '26, https://arxiv.org/abs/2511.04427 (PDF v3 lu)
- Extrait lu : « Static analysis warnings increase by 30% and code complexity increases by 41% post-adoption » ; « Panel GMM models reveal that accumulated technical debt subsequently reduces future velocity ».
- Portée / limites :
  - Projets open source dont l'adoption est datée par les fichiers de configuration Cursor.
  - Gain de vitesse transitoire : « 3-5x increases in lines added in the first adoption month, but gains dissipate after two months ».
  - L'effet sur la duplication n'est pas concluant selon la figure 1 des auteurs.
- En code : la PR augmente-t-elle les alertes du linter ou la complexité cyclomatique ? Ajoute-t-elle du code au lieu de réutiliser l'existant ?

### Ne pas présumer que le code assisté est moins maintenable : l'essai contrôlé le plus solide ne trouve pas d'effet systématique
- Niveau de preuve : N2 (essai préenregistré, 151 participants dont 95 % de professionnels)
- Source : Borg, Hewett, Hagatulah, Couderc, Söderberg, Graham, Kini, Farley, 2025-2026, « Echoes of AI: Investigating the Downstream Effects of AI Assistants on Software Maintainability », https://arxiv.org/abs/2507.00788 (PDF v3 lu ; publication dans *Empirical Software Engineering* vue seulement dans un résultat de recherche, non ouverte)
- Extrait lu : « Phase 2 revealed no significant differences in subsequent evolution with respect to completion time or code quality » ; « Future work should examine risks such as code bloat from excessive code generation and cognitive debt ».
- Portée / limites :
  - Une seule tâche (fonctionnalité Java web), code repris **par des humains**.
  - Le premier auteur travaille chez CodeScene, éditeur de la métrique CodeHealth utilisée.
  - Ce résultat nuance l'entrée précédente : le risque tient au **volume** et au manque de contrôle, pas à la qualité ligne à ligne.
- En code : la PR est-elle plus grosse que le besoin ? Le relecteur humain comprend-il chaque fichier qu'il approuve ?

### Préférer réutiliser ou déplacer du code existant plutôt que d'en dupliquer : la part du copier-coller monte avec l'usage des assistants
- Niveau de preuve : N4 (rapport d'éditeur, 211 millions de lignes modifiées entre 2020 et 2024, corrélation temporelle sans attribution ligne à ligne)
- Source : GitClear, 2025, « AI Copilot Code Quality: 2025 Look Back at 12 Months of Data », https://www.gitclear.com/ai_assistant_code_quality_2025_research (page de présentation lue ; PDF derrière formulaire, non lu)
- Extrait lu : « the percentage of changed code lines (associated with refactoring) sunk from 25% of changed lines in 2021, to less than 10% in 2024, while lines classified as "copy/pasted" (cloned) rose from 8.3% to 12.3% in the same period ».
- Portée / limites : la causalité IA n'est pas démontrée. L'éditeur vend l'outil de mesure.
- En code : le diff contient-il un bloc presque identique à un composant ou un utilitaire existant ? Chercher avant d'écrire (`grep` sur le nom de la fonction, sur la structure JSX).

---

## A5. Pratiques mesurées pour fiabiliser

### Donner des tests au modèle avant qu'il code : les tests fournis augmentent la part de problèmes résolus
- Niveau de preuve : N2 (MBPP, HumanEval ; GPT-4, Llama 3) — préprint
- Source : Mathews, Nagappan, 2024, « Test-Driven Development for Code Generation », https://arxiv.org/abs/2402.13521 (PDF v2 lu)
- Extrait lu : « Our results consistently demonstrate that including test cases leads to higher success in solving programming challenges » ; tableau de résultats : « Needs tests 82.45% (+12.78%) ».
- Portée / limites :
  - Problèmes de niveau fonction, pas d'interface.
  - Les tests sont écrits par des humains. Les auteurs ne se prononcent pas sur des tests écrits par l'IA : « this paper does not seek to answer the question "When and how should AI write tests?" ».
- En code : le test (ou le critère d'acceptation exécutable) existait-il avant l'implémentation ? Un test écrit après coup par le même modèle risque d'en valider les erreurs.

---

## B. Plateforme web 2025-2026 : ce que le navigateur fait désormais nativement

### Décider d'utiliser une fonctionnalité web d'après son statut Baseline consulté le jour même, pas de mémoire
- Niveau de preuve : N3
- Source : MDN, « Baseline (compatibility) », https://developer.mozilla.org/en-US/docs/Glossary/Baseline/Compatibility (lu via `index.json`)
- Extrait lu : « Features listed as widely available have a consistent history of support in each of the Baseline browsers for at least 2.5 years. Features listed as newly available work in at least the latest stable version of each of the Baseline browsers, but may not work with older browsers and devices. » ; « Baseline is a summary of browser support. It is not a substitute for accessibility, usability, performance, security, or other testing. »
- Portée / limites :
  - Navigateurs couverts : Chrome (ordinateur et Android), Edge, Firefox (ordinateur et Android), Safari (macOS et iOS). Les WebViews et les technologies d'assistance n'y sont pas.
  - Le statut d'un groupe de fonctionnalités peut **redescendre** quand on y ajoute des sous-fonctionnalités (voir anchor positioning ci-dessous).
- En code : pour chaque API ou propriété postérieure à 2023, la PR cite-t-elle son statut (MDN ou webstatus.dev) ? Si le statut est « newly » ou « limited », le repli est-il prévu ?

### Pour ouvrir ou fermer un dialog ou un popover depuis un bouton, utiliser `command`/`commandfor` plutôt qu'un gestionnaire `onClick`
- Niveau de preuve : N3
- Source : MDN, « Invoker Commands API », https://developer.mozilla.org/en-US/docs/Web/API/Invoker_Commands_API ; webstatus.dev, https://webstatus.dev/features/invoker-commands (données via `api.webstatus.dev/v1/features/invoker-commands`)
- Extrait lu : « The Invoker Commands API provides a way to declaratively assign behaviors to buttons » ; statut : `{'low_date': '2025-12-12', 'status': 'newly'}` (Chrome 135, Firefox 144, Safari 26.2).
- Portée / limites :
  - Baseline **Newly** depuis le 12.12.2025. Les navigateurs plus anciens nécessitent un repli JS.
  - L'intégration avec les frameworks (React : attribut inconnu, SSR) n'a pas été vérifiée.
- En code : un `useState` plus `onClick` qui ne fait qu'appeler `showModal()` ou `togglePopover()` peut-il devenir `<button commandfor="d" command="show-modal">` ?

### Popover : l'attribut `popover` est largement disponible ; `popover="hint"` et `interestfor` ne le sont pas encore
- Niveau de preuve : N3
- Source : MDN, attribut `popover`, https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/popover ; webstatus.dev, https://webstatus.dev/features/popover-hint et https://webstatus.dev/features/interest-invokers
- Extrait lu :
  - MDN, attribut `popover` : `baseline: high`, `low 2024-04-16`, `high 2026-10-16` ;
  - MDN, définition de `hint` : « hint popovers do not close auto popovers when they are displayed » ;
  - webstatus `popover-hint` : `{'status': 'limited'}` (Chrome 151, Firefox 153, pas de Safari) ;
  - webstatus `interest-invokers` : `{'status': 'limited'}` (Chrome et Edge 149 seulement).
- Portée / limites :
  - Le groupe « Popover » complet est noté `newly` depuis le 27.01.2025 sur webstatus.dev (Safari iOS 18.3), alors que l'attribut seul est `widely` sur MDN depuis le 16.10.2026. Les deux sources ne mesurent pas le même périmètre.
  - Les numéros de version Chrome de `popover="hint"` relevés sur webstatus.dev (151) m'étonnent. Je n'ai pas pu recouper cette donnée.
- En code :
  - un composant JS de popover ou de menu peut-il devenir `popover="auto"` ?
  - une infobulle au survol ne doit pas dépendre de `interestfor` sans repli : elle doit rester accessible au clavier et au toucher.

### Anchor positioning : le noyau (`anchor-name`, `position-anchor`, `anchor()`, `position-area`, `position-try-fallbacks`) est Baseline Newly, mais pas tout le module
- Niveau de preuve : N3
- Source : MDN, `anchor()`, https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/anchor ; webstatus.dev, https://webstatus.dev/features/anchor-positioning ; fichier source web-features `anchor-positioning.yml.dist` (https://raw.githubusercontent.com/web-platform-dx/web-features/main/features/anchor-positioning.yml.dist)
- Extrait lu :
  - bandeau MDN de `anchor()` : « Baseline 2026 Newly available […] Since January 2026, this feature works across the latest devices and browser versions » et « Some parts of this feature may have varying levels of support » ;
  - webstatus.dev, groupe entier : `{'status': 'limited'}` ;
  - web-features, sous-ensemble principal : `# baseline: low  # baseline_low_date: 2026-01-13` (Chrome 125, Firefox 147, Safari 26).
- Portée / limites :
  - Le groupe complet n'est disponible que dans Safari 27. Il inclut `anchor-scope`, `flip-x`, `flip-y` et d'autres valeurs récentes.
  - MDN note `position-anchor` « low 2026-09-14 » (Chrome et Firefox 151, Safari 27), probablement à cause de valeurs ajoutées.
  - Vérifier propriété par propriété.
- En code :
  - une bibliothèque de positionnement (type Floating UI) ajoutée pour une infobulle simple est-elle encore justifiée ?
  - si on utilise l'ancrage natif, les valeurs choisies sont-elles dans le noyau Baseline 2026, avec un `@supports` pour le reste ?

### Ne pas livrer `appearance: base-select` comme seul habillage d'un `<select>` : support limité, et risque d'échec d'hydratation avec un framework en SSR
- Niveau de preuve : N3
- Source : MDN, « Customizable select elements », https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/Customizable_select ; webstatus.dev, https://webstatus.dev/features/customizable-select
- Extrait lu : « Some JavaScript frameworks block these features; in others, they cause hydration failures when Server-Side Rendering (SSR) is enabled » ; statut : `{'status': 'limited'}` (Chrome 135, Safari 27, pas de Firefox).
- Portée / limites : l'amélioration progressive est naturelle, puisqu'un `<select>` classique reste fonctionnel. Le comportement de React 19 ou de Next.js n'a pas été vérifié.
- En code :
  - le `<select>` reste-t-il utilisable sans `base-select` ?
  - l'arbre JSX qui place un `<button>` et `<selectedcontent>` dans `<select>` passe-t-il le rendu serveur sans avertissement d'hydratation ?

### Animer au défilement en CSS (`animation-timeline: scroll()` / `view()`), avec un repli pour les navigateurs plus anciens
- Niveau de preuve : N3
- Source : MDN, `animation-timeline`, https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/animation-timeline ; webstatus.dev, https://webstatus.dev/features/scroll-driven-animations
- Extrait lu : MDN : « It allows you to animate property values along a scroll-based timeline rather than the default time-based document timeline » ; statut : `{'low_date': '2026-10-27', 'status': 'newly'}` (Chrome 115, Safari 26, Firefox 159).
- Portée / limites :
  - Newly depuis **deux semaines** à la date de cette recherche (27.10.2026). Toute version de Firefox antérieure à 159 n'a rien.
  - À combiner avec `prefers-reduced-motion`.
- En code : un écouteur `scroll` ou un `IntersectionObserver` qui pilote une animation décorative peut-il passer en CSS dans `@supports (animation-timeline: view())` ?

### Transitions de vue **entre documents** (`@view-transition { navigation: auto }`) : amélioration progressive seulement
- Niveau de preuve : N3
- Source : MDN, `@view-transition`, https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@view-transition ; webstatus.dev, https://webstatus.dev/features/cross-document-view-transitions
- Extrait lu : MDN : « The @view-transition CSS at-rule is used to opt in the current and destination documents to undergo a view transition, in the case of a cross-document navigation » ; statut : `{'status': 'limited'}` (Chrome 126, Safari 18.2, pas de Firefox).
- Portée / limites : les transitions au sein d'un même document sont couvertes ailleurs. Le groupe « View transitions » est noté `newly` depuis le 14.10.2025.
- En code : la navigation fonctionne-t-elle sans la transition ? Aucune logique ne doit en dépendre.

### Champ qui s'adapte à son contenu : `field-sizing: content` remplace le JS d'auto-redimensionnement
- Niveau de preuve : N3
- Source : MDN, `field-sizing`, https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/field-sizing ; webstatus.dev, https://webstatus.dev/features/field-sizing
- Extrait lu : MDN : « The field-sizing CSS property enables you to control the sizing behavior of elements that are given a default preferred size, such as form control elements » ; statut : `{'low_date': '2026-06-16', 'status': 'newly'}` (Chrome 123, Safari 26.2, Firefox 152).
- Portée / limites : Newly depuis le 16.06.2026. Sur un navigateur plus ancien, le champ garde sa taille fixe, ce qui est un repli acceptable.
- En code : un `useEffect` qui recalcule `textarea.style.height` peut-il disparaître ?

### Ne pas utiliser la fonction CSS `if()` en production : Chromium seulement
- Niveau de preuve : N3
- Source : MDN, `if()`, https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/if ; webstatus.dev, https://webstatus.dev/features/if
- Extrait lu : MDN : « The if() CSS function allows different values to be set for a property depending on the result of a conditional test » ; statut : `{'status': 'limited'}` (Chrome et Edge 137 seulement).
- Portée / limites : sans Firefox ni Safari. Même statut pour `interpolate-size` et `calc-size()` (MDN : Chrome et Edge 129 seulement).
- En code : un `if()`, un `interpolate-size` ou un `calc-size()` sans repli est un défaut.

### Préférer nesting, `:has()` et `@scope` aux conventions de nommage lourdes ; nesting et `:has()` sont devenus largement disponibles en 2026
- Niveau de preuve : N3
- Source : MDN, sélecteur `&`, https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Selectors/Nesting_selector ; `:has()`, https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Selectors/:has ; `@scope`, https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@scope
- Extrait lu : statuts MDN relevés :
  - nesting `high 2023-12-11 / 2026-06-11` ;
  - `:has()` `high 2023-12-19 / 2026-06-19` ;
  - `@scope` `low 2026-03-24` (Firefox 146, Safari 26.4).
- Portée / limites :
  - `@scope` est Newly : vérifier la cible du projet.
  - Avec Tailwind, l'intérêt pratique de ces trois fonctionnalités est moindre (avis, non mesuré).
- En code : un état parent piloté par JS (classe ajoutée quand un enfant est coché ou invalide) peut-il devenir `:has(:checked)` ou `:has(:user-invalid)` ?

### Dates et durées : `Temporal` n'est pas encore utilisable sans polyfill ; `Intl.DurationFormat` l'est
- Niveau de preuve : N3
- Source : MDN, `Temporal`, https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Temporal ; MDN, `Intl.DurationFormat`, https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DurationFormat
- Extrait lu :
  - bandeau de `Temporal` : « Limited availability — This feature is not Baseline because it does not work in some of the most widely-used browsers » (Chrome 144, Firefox 139, pas de Safari) ;
  - `Intl.DurationFormat` : `low 2025-03-04`.
- Portée / limites : pour `Temporal`, la page MDN conseille un polyfill (`@js-temporal/polyfill` ou `temporal-polyfill`). Cette recommandation vient du résumé de la page fourni par WebFetch, à relire sur MDN avant de l'adopter.
- En code :
  - un appel `Temporal.*` sans polyfill ni détection est un bug sur Safari ;
  - une bibliothèque ajoutée **seulement** pour afficher « 1 h 05 min » peut être remplacée par `Intl.DurationFormat`.

### Utilitaires JS natifs récents avant toute dépendance : `Promise.try`, helpers d'itérateurs, méthodes de `Set`, `Map.groupBy`, `toSorted`, `structuredClone`, `Promise.withResolvers`, `URL.parse`
- Niveau de preuve : N3
- Source : pages MDN de ces méthodes, par exemple https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Iterator/map et https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set/union (statuts lus via `index.json`)
- Extrait lu :

  | Fonctionnalité | Statut MDN relevé |
  |---|---|
  | `Promise.try` | `low 2025-01-07` |
  | `Iterator.prototype.map` | `low 2025-03-31` |
  | `Set.prototype.union` | `low 2024-06-11` |
  | `Map.groupBy` | `high 2024-03-05 / 2026-09-05` |
  | `Array.prototype.toSorted` | `high 2023-07-04 / 2026-01-04` |
  | `structuredClone` | `high 2022-03-14 / 2024-09-14` |
  | `Promise.withResolvers` | `high 2024-03-05 / 2026-09-05` |
  | `URL.parse` | `low 2024-09-16` |

- Portée / limites :
  - Les fonctionnalités Newly exigent de connaître la cible (`browserslist`).
  - TypeScript doit avoir la bonne `lib` (non vérifié ici).
- En code : un import de lodash ou d'un utilitaire maison pour `groupBy`, `cloneDeep`, l'union ou l'intersection d'ensembles, ou un tri non mutant est-il encore nécessaire ?

### Intercepter la navigation côté client avec la Navigation API plutôt qu'avec des écouteurs `popstate` et des liens patchés
- Niveau de preuve : N3
- Source : MDN, « Navigation API », https://developer.mozilla.org/en-US/docs/Web/API/Navigation_API ; webstatus.dev, https://webstatus.dev/features/navigation
- Extrait lu : MDN : « This is a successor to previous web platform features such as the History API and window.location » ; statut : `{'low_date': '2026-01-13', 'status': 'newly'}` (Chrome 102, Safari 26.2, Firefox 147).
- Portée / limites : dans une application Next.js, c'est le routeur du framework qui gère la navigation. La règle vaut surtout pour une SPA sans routeur, ou du vanilla.
- En code : du code maison de « routeur » avec `history.pushState` et `popstate` peut-il passer par `navigation.addEventListener("navigate", …)` ?

### `requestIdleCallback` et `scheduler.yield()` : toujours détecter avant d'appeler, aucun des deux n'est dans Safari
- Niveau de preuve : N3
- Source : MDN, `requestIdleCallback`, https://developer.mozilla.org/en-US/docs/Web/API/Window/requestIdleCallback ; MDN, `Scheduler.yield()`, https://developer.mozilla.org/en-US/docs/Web/API/Scheduler/yield ; webstatus.dev, https://webstatus.dev/features/requestidlecallback et https://webstatus.dev/features/scheduler
- Extrait lu :
  - bandeau de `yield()` : « Limited availability — This feature is not Baseline because it does not work in some of the most widely-used browsers » ;
  - détection proposée par MDN : `if (globalThis.scheduler?.yield) { ... }` ;
  - webstatus `requestidlecallback` : `{'status': 'limited'}` (Chrome 47, Firefox 55, pas de Safari).
- Portée / limites : `scheduler` est disponible dans Chrome 129 et Firefox 142, pas dans Safari.
- En code : chaque appel est-il protégé par une détection, avec un repli (`setTimeout` découpé) ?

### `<dialog>` : `requestClose()` est utilisable ; l'attribut `closedby` ne l'est pas encore partout
- Niveau de preuve : N3
- Source : MDN, `HTMLDialogElement.requestClose()`, https://developer.mozilla.org/en-US/docs/Web/API/HTMLDialogElement/requestClose ; MDN, `closedBy`, https://developer.mozilla.org/en-US/docs/Web/API/HTMLDialogElement/closedBy
- Extrait lu :
  - `requestClose()` : « requests to close the <dialog> », statut `low 2025-05-27` ;
  - `closedBy` : statut `False` (Chrome 134, Firefox 141, pas de Safari) ;
  - `<dialog>` lui-même : `high 2022-03-14 / 2024-09-14`.
- Portée / limites : la fermeture par clic extérieur via `closedby="any"` nécessite un repli JS sur Safari.
- En code : une modale maison (div, gestion du focus, Échap) peut-elle devenir `<dialog>` avec `showModal()` ? La fermeture par clic extérieur a-t-elle un repli ?

---

## Verdict sur les règles du profil

### 1. « Anti-hallucination : jamais d'API non vérifiée — framework, lib UI, styling. Pas d'import depuis un chemin inventé. Si doute, lire le fichier ou la doc. »

**Soutenue.** Les sources :
- Wang et al. (ICSE 2025) : API dépréciées issues du corpus d'entraînement ;
- Jain et al. (préprint) : API rares ;
- Zhang et al. (préprint) : 24,56 % des hallucinations sont des conflits avec le contexte du projet, dont des dépendances non importées ;
- GitChameleon (préprint) : versions.

La règle est juste mais **incomplète** au vu de la recherche. Ajouts proposés :

1. **« Si doute » est trop faible.** Le modèle ne sait pas quand il doit douter. Perry et al. montrent une confiance excessive, et Spracklen et al. montrent que les hallucinations de paquets se **répètent** à l'identique (43 % sur 10 requêtes). D'où la règle : vérifier **systématiquement** toute API postérieure à la date de coupure ou rare (lib récente, nouveauté CSS ou HTML), sans attendre le doute.
2. **Paquets.** Ajouter : « aucun paquet ajouté sans vérification d'existence sur le registre (`npm view`) et contrôle du nom exact ». C'est le slopsquatting : JavaScript est plus touché que Python, 21,3 % contre 15,8 % en moyenne.
3. **Version.** « Vérifier contre la version installée (lockfile), pas contre la documentation de la dernière version. »
4. **Exécuter.** « Un import ou une API est vérifié quand `tsc` ou le build passe, pas quand le code a l'air juste. »
5. **Sécurité.** Absente de la règle. Ajouter au moins : sortie HTML, `dangerouslySetInnerHTML`, `eval` et URL construites à partir d'une entrée sont présumés vulnérables (CWE-79, 94, 22 : Fu et al., TOSEM 2025). La boucle de correction s'appuie sur la sortie d'un analyseur, pas sur « vérifie la sécurité ».
6. **Itérations.** Rejouer la revue sur le diff final après plusieurs allers-retours avec l'IA (Shukla et al., preuve faible).
7. **Statut de compatibilité.** Toute API web récente passe par MDN ou webstatus.dev le jour même. La mémoire du modèle sur la compatibilité est datée par construction : le statut d'anchor positioning a changé deux fois en 2026.

### 2. « La plateforme web le fait-elle nativement ? `<dialog>`, `<details>`, `popover`, `<form>` + `FormData`, `input type="date"`, `Intl.NumberFormat`, `IntersectionObserver`, `:has()`, `scroll-behavior`, CSS Grid. »

**Soutenue sur le principe : la liste est à jour, tous ses éléments sont Baseline Widely au 9.11.2026.** Statuts MDN relevés :

| Élément | Widely depuis | Remarque |
|---|---|---|
| `<dialog>` | 14.09.2024 | |
| `<details>` | 15.07.2022 | |
| attribut `popover` | 16.10.2026 | le groupe Popover complet n'est que Newly sur webstatus.dev |
| `FormData` | 29.01.2018 | |
| `<input type="date">` | 26.10.2023 | MDN : « The appearance of the date picker input UI varies based on the browser and operating system » |
| `Intl.NumberFormat` | 28.03.2020 | via le groupe `intl` |
| `IntersectionObserver` | 25.09.2021 | |
| `:has()` | 19.06.2026 | |
| `scroll-behavior` | 14.09.2024 | |
| Grid | 17.04.2020 | |

Le principe « natif d'abord » est une **convention de praticien**. Je n'ai pas trouvé d'étude qui mesure son effet sur la qualité. Il est en revanche soutenu indirectement par :
- l'effet « volume » (He et al., MSR '26) ;
- le risque de dépendances (Spracklen et al.).

À **ajouter**, parce qu'ils sont Baseline et remplacent du JS ou une dépendance :
- `<details name>` (accordéon exclusif, Newly 03.09.2024) ;
- Invoker Commands `command`/`commandfor` (Newly 12.12.2025) ;
- `dialog.requestClose()` (Newly 27.05.2025) ;
- noyau d'anchor positioning (Newly 13.01.2026) ;
- `field-sizing: content` (Newly 16.06.2026) ;
- scroll-driven animations (Newly 27.10.2026) ;
- nesting CSS (Widely 11.06.2026) ;
- `@scope` (Newly 24.03.2026) ;
- subgrid (Widely 15.03.2026 selon webstatus.dev) ;
- Navigation API (Newly 13.01.2026) ;
- `Intl.DurationFormat`, `Intl.Segmenter` (Widely 16.10.2026 selon webstatus.dev), `Map.groupBy`, `structuredClone`, `toSorted`, méthodes de `Set`, helpers d'itérateurs, `Promise.try`.

À **signaler comme pas encore assez supportés** : n'en faire que de l'amélioration progressive, ou les éviter.

| Fonctionnalité | Support relevé |
|---|---|
| `<select>` personnalisable (`appearance: base-select`) | pas Firefox ; risque SSR et hydratation |
| `popover="hint"` | pas Safari |
| `interestfor` | Chromium seul |
| `if()`, `interpolate-size`, `calc-size()` | Chromium seul |
| `Temporal` | pas Safari |
| View Transitions entre documents | pas Firefox |
| `requestIdleCallback`, `scheduler.yield()` | pas Safari |
| `<dialog closedby>` | pas Safari |
| module complet d'anchor positioning | Safari 27 seul pour les ajouts récents |

**Corriger la formulation** : la liste devrait dire « vérifier le statut Baseline et la cible du projet (`browserslist`) ». Une fonctionnalité Newly peut manquer chez une partie des utilisateurs.

### 3. « Une dépendance déjà installée le fait-elle ? Lire le package.json avant d'ajouter. »

**Convention sans preuve directe trouvée, soutenue indirectement.** Aucune étude lue ne mesure l'effet de « lire le package.json d'abord ». La règle réduit cependant deux risques documentés :
- l'ajout d'un paquet halluciné ou usurpé (Spracklen et al. ; cas `unused-imports` rapporté par Aikido, N4) ;
- la duplication et la complexité ajoutées (GitClear, N4 ; He et al., N2).

Ajout proposé : « … et, si une dépendance est ajoutée, vérifier son existence, son nom exact et sa version sur le registre. Lire aussi le lockfile, qui donne la version installée et donc l'API valide (Wang et al.). »

---

## Mythes et affirmations contestées

- **« 40 % du code Copilot est vulnérable. »** Chiffre tiré de scénarios **construits** autour des CWE à risque (Pearce et al.). Sur du code réel de GitHub, Fu et al. trouvent 24,2 % des extraits JavaScript et 29,5 % des extraits Python avec au moins une faiblesse détectée. Les deux chiffres ne mesurent pas la même chose.
- **« Les modèles récents ou plus gros écrivent du code sûr. »**
  - Contredit en partie par Veracode (N4 : performance de sécurité « flat » quelle que soit la taille) et par BaxBench (N2 : environ la moitié des programmes corrects restent exploitables).
  - Nuance de BaxBench : les modèles de raisonnement réagissent à un rappel de sécurité générique, les autres non.
- **« Il suffit d'ajouter "écris du code sécurisé" au prompt. »** Effet non significatif statistiquement selon Tony et al. La critique explicite du code produit (RCI) fait beaucoup mieux, sur des modèles de 2023.
- **« Demander à l'IA d'améliorer le code le rend plus sûr. »**
  - Contredit par Shukla et al. : +37,6 % de vulnérabilités critiques après cinq itérations sans humain (preuve faible).
  - Ce qui fonctionne mieux selon Fu et al. : corriger **à partir d'alertes d'outils**, jusqu'à 55,5 % des problèmes corrigés.
- **« Le code assisté par IA est moins maintenable. »**
  - Contesté. L'essai contrôlé de Borg et al. ne trouve pas de dégradation systématique.
  - L'étude observationnelle de He et al. trouve +41 % de complexité et +30 % d'avertissements après adoption de Cursor.
  - Lecture conciliable : le risque vient du volume et de l'absence de contrôle qualité, pas d'une mauvaise qualité intrinsèque de chaque ligne.
  - GitClear (N4) n'établit pas la causalité.
- **« Le slopsquatting est une menace massive déjà exploitée. »** Le risque est mesuré et sérieux (Spracklen et al.). Les cas d'attaque réels documentés restent peu nombreux et rapportés par des éditeurs de sécurité (Aikido, N4).
- **« Anchor positioning est Baseline. »** Vrai et faux à la fois au 9.11.2026 :
  - le noyau est Newly depuis le 13.01.2026 (MDN, web-features) ;
  - le groupe complet est « limited » sur webstatus.dev, depuis l'ajout de sous-fonctionnalités que seul Safari 27 supporte.
  
  Une affirmation de compatibilité doit nommer la propriété précise.
- **« Le modèle peut vérifier lui-même qu'un paquet existe. »** Partiellement : certains modèles détectent leurs propres hallucinations à plus de 75 %, d'autres sont biaisés vers « valide » (Spracklen et al.). La vérification passe donc par le registre.

## Non vérifié

- **Aydin & Bahtiyar 2025** (« jusqu'à 45,8 % d'extraits JavaScript vulnérables, surtout CWE-79 ») : vu seulement cité de seconde main dans un résultat de recherche, article non ouvert.
- **Billet de Lasso Security sur `huggingface-cli` (2024)** : connu seulement via Aikido, non ouvert.
- **Publication revue des préprints** :
  - Tony et al. (métadonnées ACM non remplies dans le PDF) ;
  - Jain et al. ;
  - Zhang et al. ;
  - GitChameleon ;
  - Mathews & Nagappan.
- **Version journal de Borg et al.** (*Empirical Software Engineering*) : vue seulement dans un résultat de recherche.
- **Rapport complet GitClear 2025** (PDF derrière formulaire) et **méthodologie de Veracode** : seules les pages de présentation ont été lues.
- **Numéros de version de `popover="hint"`** sur webstatus.dev (Chrome 151, Firefox 153) : donnée surprenante, non recoupée sur une seconde source.
- **Comportement de React 19 et Next.js** avec `commandfor`, `interestfor` et le `<select>` personnalisable (attributs inconnus, hydratation) : non vérifié. Seul l'avertissement générique de MDN sur les frameworks et le SSR a été lu.
- **Efficacité mesurée de la revue humaine**, en tant que telle, sur le code généré : aucune étude dédiée n'a été trouvée et lue. Les indices restent indirects : Perry et al. (méfiance et vigilance des participants) et Shukla et al. (humain entre les itérations).
- **Dates de passage à « Widely »** des fonctionnalités Newly (+30 mois) : non calculées ici, à relire sur MDN le moment venu.

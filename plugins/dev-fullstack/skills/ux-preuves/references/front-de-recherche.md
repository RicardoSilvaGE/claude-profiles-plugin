# Fiche `ux-preuves` — Front de recherche (2022-2026 et méconnu)

> Fiche du skill `ux-preuves` (dev-fullstack). Couvre : lisibilité individualisée, IA générative et agents (productivité, sur-confiance, déqualification), état réel de l'accessibilité, performance, décision et réplications, authentification, graphiques et tableaux.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Mythes » et « Non
> vérifié » en fin de fiche sont opposables autant que les entrées : ce qui y figure ne se cite
> pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche documentaire du 9 novembre 2026. Chaque entrée repose sur une page **réellement ouverte**
> (WebFetch, ou téléchargement du PDF puis extraction du texte quand WebFetch ne lisait pas le PDF).
> Quand seul le résumé (abstract) a été lu, c'est écrit « résumé seul lu ».
> Les classiques (Nielsen, Baymard, WCAG 2.2, ISO 9241, Hick/Fitts, SUS, HEART, Mathur 2019,
> Amershi 2019, GOV.UK) sont couverts par les fichiers 1 à 4 et ne sont pas repris ici.
>
> Niveaux : N1 norme/réglementation · N2 recherche revue par pairs ou étude empirique à large
> échantillon · N3 guideline officielle d'institution ou de plateforme · N4 avis d'expert, praticien.
> Un préprint non revu par les pairs est classé N2 **avec la mention « préprint »** quand le protocole
> est expérimental (essai randomisé), sinon N4.

35 entrées : lisibilité (4), IA générative et agents (12), accessibilité réelle (4), performance (4),
psychologie de la décision (4), authentification (2), graphiques et données (5).

---

## 1. Lisibilité individualisée

### Laisser l'utilisateur choisir sa police de lecture (ou la lui proposer par test), car la meilleure police varie d'un individu à l'autre et l'écart atteint 35 % de vitesse
- Niveau de preuve : N2 (352 participants retenus sur 500 recrutés, 18-71 ans, 16 polices, lecture sur leur propre appareil)
- Source : Wallace, Bylinskii, Dobres, Kerr, Berlow, Treitman, Kumawat, Arpin, Miller, Huang, Sawyer, 2022 (ACM TOCHI 29(4), art. 38, mars 2022), « Towards Individuated Reading Experiences: Different Fonts Increase Reading Speed for Different Individuals », https://jeffhuang.com/papers/Readability_TOCHI22.pdf (texte intégral lu) ; page de présentation : https://research.adobe.com/publication/towards-individuated-reading-experiences-different-fonts-increase-reading-speed-for-different-individuals
- Extrait lu : « Participants' reading speeds (measured in words-per-minute (WPM)) increased by 35% when comparing fastest and slowest fonts without affecting reading comprehension. High WPM variability across fonts suggests that one font does not fit all. »
- Portée / limites : les 35 % comparent, **pour chaque individu**, sa police la plus rapide à sa plus lente — ce n'est pas le gain moyen obtenu en changeant de police pour tout le monde. Étude à distance sur Mechanical Turk (les auteurs disent eux-mêmes sacrifier la validité interne), textes courts (« interlude reading »). Recommandations par police seulement esquissées pour les plus de 35 ans (N = 118). Auteurs liés à Adobe / Readability Consortium : réplication indépendante non trouvée.
- Pourquoi c'est peu connu / ce que ça change en pratique : la doctrine « une bonne police système suffit » ignore une variance individuelle plus grande que la plupart des effets typographiques débattus ; un réglage de police (ou des « thèmes de lecture ») dans les produits de lecture longue est justifié. Et ne pas laisser le choix reposer sur le goût : « preference does not predict speed even when font size is controlled » ; « we found that font preference does not drive effectiveness, despite participants believing it does » (même article) — un test de préférence ne valide pas la lisibilité, il faut mesurer temps de lecture et compréhension.

### Pour les lecteurs dyslexiques, préférer une sans-serif droite courante (Helvetica, Arial, Verdana) à une police « spéciale dyslexie » et proscrire l'italique
- Niveau de preuve : N2 (oculométrie, plan intra-sujets, 48 participants dyslexiques, 12 polices) — étude de 2013, solide mais méconnue
- Source : Rello & Baeza-Yates, 2013 (ASSETS '13), « Good Fonts for Dyslexia », https://typeset.io/pdf/good-fonts-for-dyslexia-2debffz8dl.pdf (texte intégral lu)
- Extrait lu : « Sans serif, monospaced and roman font styles significantly improved the reading performance over serif, proportional and italic fonts. » ; et sur la police dédiée : « OpenDys did not lead to a faster reading. […] our participants significantly preferred Verdana or Helvetica for reading than OpenDys and OpenDys It. »
- Portée / limites : espagnol, adultes, lecture silencieuse ; les auteurs notent ne pas avoir testé la lecture à voix haute de mots isolés, où une police dédiée pourrait aider. Une seule étude ; à croiser avec d'autres travaux non ouverts ici.
- Pourquoi c'est peu connu / ce que ça change en pratique : proposer OpenDyslexic comme « option accessibilité » est un geste répandu sans appui empirique ; le gain mesuré vient de l'absence d'italique et d'une sans-serif ordinaire.

### Garder le thème clair par défaut pour la lecture et offrir le mode sombre en option, sans le présenter comme plus lisible
- Niveau de preuve : N4 (synthèse de praticien NN/g) reposant sur des études N2 (Piepenbrock et al. 2013, Ergonomics et Human Factors ; Dobres, Chahine & Reimer 2017, Applied Ergonomics) — études primaires non ouvertes
- Source : Raluca Budiu, 2 février 2020, « Dark Mode vs. Light Mode: Which Is Better? », Nielsen Norman Group, https://www.nngroup.com/articles/dark-mode/
- Extrait lu : « in users with normal vision, light mode leads to better performance most of the time » ; sur Dobres 2017 : « During daytime, there was no significant effect of contrast polarity, but during nighttime, light mode led to better performance than dark mode. »
- Portée / limites : l'avantage du clair (« positive polarity ») augmente quand la police rapetisse ; il est plus faible chez les plus âgés ; les personnes aux milieux oculaires troubles (ex. cataracte) lisaient mieux en sombre (Legge 1985, écrans CRT). Pas d'étude 2023-2026 trouvée qui renverse ce résultat. Les participants ne percevaient pas la différence qu'ils produisaient.
- Pourquoi c'est peu connu / ce que ça change en pratique : la popularité du mode sombre est souvent prise pour un gain de lisibilité ; la preuve dit « option utile pour certains profils, pas défaut supérieur », et redoublez de prudence sur les petits corps de texte en sombre.

### Sur mobile, proposer quelques « thèmes de lecture » pré-assemblés (police + espacements) plutôt qu'une batterie de réglages fins
- Niveau de preuve : N2 (actes MobileHCI 2023 Companion) — **résumé seul lu**, nombre de participants non relevé
- Source : Cai, Niklaus, Kerr, Kraley, Bylinskii, 2023 (publié le 22.09.2023), « Preferred Reading Formats for Mobile Devices: Results from Readability Studies », DOI 10.1145/3565066.3608706 ; résumé lu via https://api.openalex.org/works/doi:10.1145/3565066.3608706
- Extrait lu : « navigating reading controls proves challenging for readers. Prior work recommends presenting readers with reading themes: a small but diverse set of pre-bundled settings of font with character, word, and line spacing. » ; « we found some subtle differences in recommended reading formats for mobile screens. »
- Portée / limites : papier court (9 p.), même groupe de recherche (Adobe) que Wallace 2022 ; les « différences subtiles » ne sont pas détaillées dans le résumé.
- Pourquoi c'est peu connu / ce que ça change en pratique : la personnalisation de lecture passe mieux par 3-5 préréglages contrastés que par des curseurs que personne ne touche ; règles et contraste peuvent s'y ajouter en extensions.

---

## 2. UX de l'IA générative et des agents

### Cartographier, tâche par tâche, ce que l'IA fait bien avant de l'intégrer à un flux : hors de sa « frontière », elle dégrade le travail humain
- Niveau de preuve : N2 (expérience de terrain préenregistrée, 758 consultants BCG, randomisée en trois bras)
- Source : Dell'Acqua, McFowland, Mollick, Lifshitz, Kellogg, Rajendran, Krayer, Candelon, Lakhani, 2026 (Organization Science, en ligne le 11.03.2026 ; working paper HBS 2023), « Navigating the Jagged Technological Frontier: Field Experimental Evidence of the Effects of Artificial Intelligence on Knowledge Worker Productivity and Quality », DOI 10.1287/orsc.2025.21838 ; PDF éditeur (CC BY) lu via https://digital-fluency.pages.dev/research/foundational/dell-acqua-et-al-2026-navigating-the-jagged-technological-frontier.pdf
- Extrait lu : « subjects using AI outperformed those not using AI, completing 12.2% more tasks and completing them 25.1% more quickly on average while also delivering solutions of significantly improved quality. However, for a complex managerial task selected to be outside the frontier, subjects using AI were 19% less likely to produce correct solutions »
- Portée / limites : une firme, GPT-4 de 2023, tâches de conseil conçues pour l'étude. Le « +40 % de qualité » partout cité n'est **pas** dans l'abstract publié (voir Mythes).
- Pourquoi c'est peu connu / ce que ça change en pratique : l'interface doit aider l'utilisateur à savoir quand **ne pas** suivre l'IA — la même aide qui accélère une tâche fait échouer la voisine, d'apparence aussi difficile.

### Cibler en priorité les novices : l'assistant IA aide surtout les moins expérimentés, très peu les experts
- Niveau de preuve : N2 (données de terrain, déploiement échelonné, 5 179 agents de support client)
- Source : Brynjolfsson, Li, Raymond, avril 2023 révisé novembre 2023, « Generative AI at Work », NBER Working Paper 31161, https://www.nber.org/papers/w31161 (abstract du PDF lu) ; publication au Quarterly Journal of Economics 140(2), 2025, signalée par la recherche mais page éditeur non ouverte
- Extrait lu : « Access to the tool increases productivity, as measured by issues resolved per hour, by 14% on average, including a 34% improvement for novice and low-skilled workers but with minimal impact on experienced and highly skilled workers. »
- Portée / limites : une entreprise, un métier (support), un outil de suggestion de réponses ; le working paper précise qu'il n'était pas revu par les pairs à sa diffusion.
- Pourquoi c'est peu connu / ce que ça change en pratique : un assistant pensé pour l'expert (raccourcis, densité) passe à côté de son public principal ; inversement, ne pas mesurer le succès d'un copilote sur les seuls utilisateurs avancés.

### Mesurer le temps réel des tâches assistées par IA : le ressenti de gain ne vaut pas mesure, et chez des experts sur leur propre code, l'IA a ralenti
- Niveau de preuve : N2 — **préprint** (essai randomisé au niveau de la tâche, 16 développeurs, 246 tâches)
- Source : Becker, Rush, Barnes, Rein (METR), 12.07.2025 (v2 25.07.2025), « Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity », https://arxiv.org/abs/2507.09089 (résumé seul lu)
- Extrait lu : « Surprisingly, we find that allowing AI actually increases completion time by 19%--AI tooling slowed developers down. » ; « Before starting tasks, developers forecast that allowing AI will reduce completion time by 24%. » ; « After completing the study, developers estimate that allowing AI reduced completion time by 20%. »
- Portée / limites : très petit nombre de personnes, dépôts matures et grands, outils de début 2025 ; les auteurs ne généralisent pas aux modèles futurs.
- Pourquoi c'est peu connu / ce que ça change en pratique : l'écart de ~40 points entre perception (−20 %) et mesure (+19 %) disqualifie les questionnaires de satisfaction comme seule métrique d'un outil IA ; instrumenter le temps de tâche.

### Concevoir l'IA d'apprentissage pour l'explication, pas la délégation : déléguer le code fait chuter la compréhension
- Niveau de preuve : N2 — **préprint** (essai randomisé, 52 ingénieurs surtout juniors) ; auteurs employés d'un éditeur d'IA
- Source : Judy Hanwen Shen & Alex Tamkin (Anthropic), 29.01.2026, « How AI assistance impacts the formation of coding skills », https://www.anthropic.com/research/AI-assistance-coding-skills (préprint arXiv 2601.20245, non ouvert)
- Extrait lu : recrutement de « 52 (mostly junior) software engineers » ; quiz : 50 % (groupe IA) contre 67 % (sans IA), d de Cohen = 0,738, p = 0,01 ; le groupe IA a fini « about two minutes faster, although the difference was not statistically significant » ; « Our sample was relatively small. »
- Portée / limites : une bibliothèque (Trio), mesure immédiate sans suivi à une semaine ou un mois ; la typologie des six usages (dont trois « préservent » l'apprentissage) est qualitative, non causale. Le graphique de la page montre ~65 % pour le contrôle, légère incohérence avec le texte (67 %).
- Pourquoi c'est peu connu / ce que ça change en pratique : pour un produit d'onboarding ou de formation, un mode « explique-moi » ou « pose-moi la question » vaut mieux qu'un bouton « fais-le » — sans gain de vitesse significatif à perdre.

### Ne pas ajouter d'explications à une recommandation d'IA en espérant de meilleures décisions : elles augmentent l'acceptation, même quand l'IA a tort
- Niveau de preuve : N2 (CHI 2021, études utilisateurs sur trois jeux de données)
- Source : Bansal, Wu, Zhou, Fok, Nushi, Kamar, Ribeiro, Weld, 2021 (CHI '21), « Does the Whole Exceed its Parts? The Effect of AI Explanations on Complementary Team Performance », https://arxiv.org/abs/2006.14779 (résumé seul lu)
- Extrait lu : « Rather, explanations increased the chance that humans will accept the AI's recommendation, regardless of its correctness. »
- Portée / limites : tâches de classification (sentiment, QCM), IA de précision comparable à l'humain ; antérieur aux LLM, mais le mécanisme (l'explication comme signal de compétence) se retrouve dans les deux entrées suivantes.
- Pourquoi c'est peu connu / ce que ça change en pratique : « ajouter de l'explicabilité » n'est pas une mesure anti-sur-confiance par défaut ; il faut des explications qui aident à repérer l'erreur, et tester l'effet sur les cas où l'IA se trompe.

### Faire exprimer l'incertitude par l'assistant à la première personne (« Je ne suis pas sûr, mais… ») pour réduire la sur-confiance
- Niveau de preuve : N2 (expérience préenregistrée, N = 404, questions médicales, moteur fictif à base de LLM)
- Source : Kim, Liao, Vorvoreanu, Ballard, Wortman Vaughan, 2024 (FAccT '24 ; arXiv 01.05.2024), « "I'm Not Sure, But...": Examining the Impact of Large Language Models' Uncertainty Expression on User Reliance and Trust », https://www.arxiv.org/abs/2405.00623 (résumé seul lu)
- Extrait lu : « first-person expressions (e.g., "I'm not sure, but...") decrease participants' confidence in the system and tendency to agree with the system's answers, while increasing participants' accuracy » ; la forme impersonnelle produit des effets « weaker and not statistically significant ».
- Portée / limites : un domaine (médical), anglais, sur-confiance réduite mais pas éliminée ; effet du libellé exact — les auteurs recommandent de tester avant déploiement.
- Pourquoi c'est peu connu / ce que ça change en pratique : le choix de la personne grammaticale dans un message d'incertitude est une variable de conception mesurable, pas un détail de ton de marque.

### Ne pas compter sur la simple présence de citations pour signaler la fiabilité : même des citations aléatoires augmentent la confiance
- Niveau de preuve : N2 (AAAI 2025 ; Prolific, 0 / 1 / 5 citations : N = 108 / 96 / 101 ; citation aléatoire N = 87, valide N = 110)
- Source : Ding, Facciani, Poudel, Joyce, Aguinaga, Veeramani, Bhattacharya, Weninger, 2025 (arXiv 02.01.2025), « Citations and Trust in LLM Generated Responses », https://arxiv.org/abs/2501.01303 (résumé + section méthode du PDF lus)
- Extrait lu : « significant increase in trust when citations were present, a result that held true even when the citations were random » ; « a significant decrease in trust when participants checked the citations » ; dans le corps : « 83 participants out of 197 participants (42.1%) in the citation groups checked at least one citation »
- Portée / limites : mesure de confiance simple (reconnue par les auteurs), échantillon peu diversifié ; les citations valides produisent plus de confiance que les aléatoires.
- Pourquoi c'est peu connu / ce que ça change en pratique : une pastille « sources » est un levier de confiance indépendant de sa véracité ; rendre la vérification facile (aperçu au survol, extrait cité) devient une exigence de conception, pas un bonus.

### Prévoir dans l'interface un moment de vérification par l'utilisateur : la confiance dans l'IA réduit l'esprit critique, la confiance en soi le maintient
- Niveau de preuve : N2 (enquête CHI 2025, 319 travailleurs du savoir, 936 exemples) — données **auto-déclarées**, corrélationnelles
- Source : Lee, Sarkar, Tankelevitch, Drosos, Rintel, Banks, Wilson (Microsoft Research / CMU), avril 2025 (CHI '25), « The Impact of Generative AI on Critical Thinking: Self-Reported Reductions in Cognitive Effort and Confidence Effects From a Survey of Knowledge Workers », https://www.microsoft.com/en-us/research/?p=1135061 (résumé seul lu)
- Extrait lu : « higher confidence in GenAI is associated with less critical thinking, while higher self-confidence is associated with more critical thinking. »
- Portée / limites : enquête, pas expérience : ne prouve pas que l'IA cause une baisse ; la mesure de l'esprit critique est déclarative.
- Pourquoi c'est peu connu / ce que ça change en pratique : les auteurs orientent la conception vers le soutien à la vérification et à l'intégration des réponses (le travail se déplace vers la supervision) ; un design qui maximise la confiance dans l'IA va à l'encontre de cet objectif.

### Surveiller la déqualification : retirer l'IA après un usage régulier peut laisser l'opérateur moins performant qu'avant
- Niveau de preuve : N2 (observationnelle rétrospective, 4 centres en Pologne, 1 443 coloscopies sans IA)
- Source : Budzyń, Romańczyk, Kitala, Kołodziej, Bugajski, Adami, Blom, Buszkiewicz, Halvorsen, Hassan et al., octobre 2025, « Endoscopist deskilling after exposure to artificial intelligence in colonoscopy: a multicenter observational study », The Lancet Gastroenterology & Hepatology 10(10):896-903, https://wrap.warwick.ac.uk/id/eprint/191005 (résumé seul lu)
- Extrait lu : « decreased significantly from 28·4% (226 of 795) before to 22·4% (145 of 648) after exposure to AI, corresponding with an absolute difference of –6·0% (95% CI –10·5 to –1·6; p=0·0089) »
- Portée / limites : observationnel avant/après (pas d'essai randomisé), indicateur de processus (taux de détection d'adénomes), pas de résultat clinique ; domaine médical.
- Pourquoi c'est peu connu / ce que ça change en pratique : pour tout outil d'aide à la détection (fraude, contrôle qualité, relecture), prévoir des sessions sans IA et mesurer la performance humaine seule, sinon la panne de l'IA révèle une compétence érodée.

### Rendre la vérification des réponses d'un chatbot peu coûteuse : sans cela, les utilisateurs ne vérifient presque jamais
- Niveau de preuve : N4 (étude de praticien, journal de bord de 2 semaines, 18 participants, 425 conversations, mai-juin 2023)
- Source : Budiu, Liu, Cionca, Zhang, 24.09.2023, « Information Foraging with Generative AI: A Study of 3 Chatbots », Nielsen Norman Group, https://www.nngroup.com/articles/generative-ai-diary/
- Extrait lu : « Only 22.43% of the conversations were followed up by a verification » ; « Checking answers has a high interaction cost »
- Portée / limites : petit échantillon, outils de 2023 (ChatGPT, Bard, Bing Chat) ; les auteurs déconseillent de généraliser les proportions.
- Pourquoi c'est peu connu / ce que ça change en pratique : la vérification se fait quand l'enjeu est élevé ou le bot nouveau ; si elle oblige à quitter la réponse, elle annule le gain de temps — d'où des aperçus de source intégrés.

### Inciter l'utilisateur à tout spécifier au départ (ou faire reformuler l'agent) : les LLM se « perdent » quand la demande arrive par morceaux
- Niveau de preuve : N2 — **préprint** (simulation, plus de 200 000 conversations, six tâches de génération)
- Source : Laban, Hayashi, Zhou, Neville, 09.05.2025, « LLMs Get Lost In Multi-Turn Conversation », https://arxiv.org/abs/2505.06120 (résumé seul lu)
- Extrait lu : « with an average drop of 39% across six generation tasks » ; dégradation décomposée en « a minor loss in aptitude and a significant increase in unreliability »
- Portée / limites : conversations simulées (pas d'utilisateurs réels), modèles de 2025 ; statut de publication non vérifié.
- Pourquoi c'est peu connu / ce que ça change en pratique : l'interface « chat » encourage les demandes incrémentales, précisément le mode où le modèle devient le moins fiable ; un récapitulatif de la demande consolidée, ou un « recommencer avec tout le contexte », sont des parades de conception.

### Concevoir les agents IA pour la supervision et la reprise en main : même le meilleur agent n'achève seul qu'une minorité de tâches réalistes
- Niveau de preuve : N2 — **préprint** (banc d'essai : entreprise logicielle simulée, tâches de bureau)
- Source : Xu, Song, Li, Tang et al. (21 auteurs, CMU), v1 18.12.2024, v3 10.09.2025, « TheAgentCompany: Benchmarking LLM Agents on Consequential Real World Tasks », https://arxiv.org/abs/2412.14161 (résumé seul lu)
- Extrait lu : « the most competitive agent can complete 30% of tasks autonomously »
- Portée / limites : chiffre qui évolue à chaque version (les modèles progressent vite) ; banc d'essai, pas usage réel ; ne mesure pas l'expérience utilisateur.
- Pourquoi c'est peu connu / ce que ça change en pratique : un agent qui échoue ~7 fois sur 10 en autonomie complète impose des points de contrôle, un journal d'actions lisible et l'annulation — l'UX d'agent est d'abord une UX de supervision.

---

## 3. Accessibilité : état réel du web

### Traiter d'abord les six erreurs qui font 96 % des défauts détectés — en tête, le contraste de texte insuffisant
- Niveau de preuve : N2 (analyse automatisée WAVE du million de pages d'accueil les plus visitées, février 2026)
- Source : WebAIM, 2026, « The WebAIM Million — The 2026 report on the accessibility of the top 1,000,000 home pages », https://webaim.org/projects/million/
- Extrait lu : « Across the one million home pages, 56,114,377 distinct accessibility errors were detected—an average of 56.1 errors per page. The number of detected errors increased 10.1% since the 2025 analysis » ; « 95.9% of home pages had detected WCAG 2 failures. This number increased from 94.8% in 2025—reversing a trend of small improvements » ; tableau : contraste insuffisant 83,9 %, alternative textuelle manquante 53,1 %, étiquette de champ manquante 51 %, liens vides 46,3 %, boutons vides 30,6 %, langue du document manquante 13,5 % — « 96% of all errors detected fall into these six categories. These most common errors have been the same for the last 7 years. »
- Portée / limites : erreurs détectables automatiquement seulement (la conformité réelle est donc pire), pages d'accueil seulement.
- Pourquoi c'est peu connu / ce que ça change en pratique : 2026 marque une **régression** (hausse de 10,1 % des erreurs par page, et part de pages en échec qui remonte après six ans de lente amélioration) ; une recette automatisée sur ces six points couvre l'essentiel des défauts mesurables.

### N'ajouter de l'ARIA que si l'on sait l'implémenter : les pages avec ARIA comptent nettement plus d'erreurs
- Niveau de preuve : N2 (même corpus, corrélation)
- Source : WebAIM, 2026, idem, https://webaim.org/projects/million/
- Extrait lu : « Home pages with ARIA present had significantly more errors (59.1 on average) than pages without ARIA (42 on average). » ; « This does not necessarily mean that ARIA introduced these errors (these pages were also more complex) »
- Portée / limites : corrélation, pas causalité ; ARIA va de pair avec des composants complexes. Le rapport signale aussi que 22 % des pages avec un menu ARIA présentaient des barrières liées au balisage ou aux interactions du menu.
- Pourquoi c'est peu connu / ce que ça change en pratique : ARIA est souvent vu comme un « plus » d'accessibilité ; en pratique, le HTML natif d'abord, ARIA ensuite et testé au lecteur d'écran.

### Ne jamais vendre ni acheter un « overlay » comme moyen de conformité : la FTC a sanctionné cette promesse
- Niveau de preuve : N1 (ordonnance administrative de la FTC) + N4 (déclaration collective de praticiens)
- Source : Federal Trade Commission, 22.04.2025, « FTC Approves Final Order Requiring accessiBe to pay $1 Million », https://ftc.gov/news-events/news/press-releases/2025/04/ftc-approves-final-order-requiring-accessibe-pay-1-million ; Overlay Fact Sheet (non daté, 1 048 signataires numérotés à la consultation), https://overlayfactsheet.com/en/
- Extrait lu : FTC — accessiBe affirmait que « the plug-in accessWidget can make any website compliant with Web Content Accessibility Guidelines (WCAG) » ; l'ordonnance interdit de prétendre que ses produits automatisés rendent un site conforme sans preuve, et de présenter des avis ou articles comme indépendants alors qu'ils ne l'étaient pas. Overlay Fact Sheet — « No overlay product on the market can cause a website to become fully compliant with any existing accessibility standard » ; sur la vie privée : ces outils fonctionnent parfois « by detecting when an assistive technology is running on the device ».
- Portée / limites : l'ordonnance (1 M$, valable 20 ans) vise un éditeur et des allégations marketing, pas la technique « overlay » en soi ; la proposition d'ordonnance date de janvier 2025 (citée par la recherche, page non ouverte).
- Pourquoi c'est peu connu / ce que ça change en pratique : l'argument « un script et c'est conforme » est désormais juridiquement risqué pour qui le vend, et la détection d'aides techniques pose un problème de données sensibles (handicap) — à remonter au DPO.

### Considérer l'European Accessibility Act comme applicable depuis le 28 juin 2025 pour le commerce en ligne et la banque, avec une exemption des microentreprises de services
- Niveau de preuve : N1 (directive (UE) 2019/882) ; jurisprudence : N4 (article de praticien sur un jugement)
- Source : Directive (UE) 2019/882, art. 4(5), 31(2) et 32, https://www.legislation.gov.uk/eudr/2019/882/article/4, https://www.legislation.gov.uk/eudr/2019/882/article/31, https://www.legislation.gov.uk/eudr/2019/882/article/32 (copie de la version originale, EUR-Lex inaccessible depuis l'outil) ; Silktide, 09.06.2026, « EAA Auchan court ruling », https://silktide.com/blog/eaa-auchan-court-ruling/
- Extrait lu : art. 31(2) « They shall apply those measures from 28 June 2025. » ; art. 4(5) « Microenterprises providing services shall be exempt from complying with the accessibility requirements referred to in paragraph 3 of this Article » ; art. 32 : contrats de service conclus avant le 28.06.2025 maintenus « no longer than five years from that date », terminaux libre-service jusqu'à « no longer than 20 years after their entry into use ». Sur le premier jugement : le tribunal judiciaire de Lille (5 mai 2026) a débouté les associations contre Auchan sur une question de seuil de chiffre d'affaires, tout en relevant que le site n'était pas jugé accessible (« The court did not find that Auchan's site was accessible ») ; appel pendant devant la cour d'appel de Douai.
- Portée / limites : l'application dépend des transpositions nationales et de leurs seuils ; l'affaire Auchan est rapportée par un éditeur d'outils d'accessibilité, jugement non lu. Autres affaires (Carrefour, mises en demeure DGCCRF, Italie) : voir « Non vérifié ».
- Pourquoi c'est peu connu / ce que ça change en pratique : beaucoup d'équipes croient encore l'EAA « à venir » ; il s'applique, et le contentieux français teste déjà les seuils — l'audit d'accessibilité devient un sujet de conformité, pas de bonne volonté.

---

## 4. Performance et comportement

### Viser une INP ≤ 200 ms au 75e percentile terrain (mobile et desktop séparés) ; au-delà de 500 ms, la réactivité est « mauvaise »
- Niveau de preuve : N3 (documentation officielle Chrome / web.dev, mise à jour du 02.09.2025)
- Source : Google / web.dev, « Interaction to Next Paint (INP) », https://web.dev/articles/inp ; et « Web Vitals », https://web.dev/articles/vitals (mise à jour du 31.10.2024)
- Extrait lu : « An INP below or at 200 milliseconds means a page has good responsiveness. » ; « An INP above 500 milliseconds means a page has poor responsiveness. » ; « INP became a stable Core Web Vital metric in 2024. »
- Portée / limites : seuils de plateforme, calibrés par Google ; mesure de terrain (données réelles d'utilisateurs), pas de laboratoire.
- Pourquoi c'est peu connu / ce que ça change en pratique : beaucoup d'équipes suivent encore FID (remplacé) ou un score Lighthouse de labo ; INP mesure toutes les interactions, et oblige à instrumenter le terrain.

### Prioriser le LCP sur mobile : c'est la métrique Core Web Vitals la moins souvent réussie, loin devant l'INP
- Niveau de preuve : N2 (HTTP Archive / Chrome UX Report, millions d'origines)
- Source : Jariyal, Rasam, Humaira, Grogg, 15.01.2026 (mis à jour 05.05.2026), « Performance », Web Almanac 2025, HTTP Archive, https://almanac.httparchive.org/en/2025/performance
- Extrait lu : la part de sites aux Core Web Vitals bons a « further improved in 2025 to 48% for mobile websites and 56% for desktop websites » ; INP mobile : « with 77% of websites achieving good scores » ; LCP : « 74% of desktop pages achieve a "good" LCP score compared to 62% on mobile » ; CLS : « 81% of mobile pages ».
- Portée / limites : données CrUX (utilisateurs Chrome consentants), niveau origine ; ne dit rien d'un site particulier.
- Pourquoi c'est peu connu / ce que ça change en pratique : plus d'un site mobile sur deux échoue encore aux CWV, et c'est surtout le LCP (image héro, polices, serveur) qui coince — c'est là que se situe le levier le plus probable.

### Tenir les seuils Core Web Vitals pour réduire l'abandon de chargement d'environ un quart
- Niveau de preuve : N3 (analyse interne de Chrome, méthode non publiée)
- Source : Chromium Blog (Google), 21.05.2020, « The Science Behind Web Vitals », https://blog.chromium.org/2020/05/the-science-behind-web-vitals.html
- Extrait lu : « We found that when a site meets the above thresholds, users are 24% less likely to abandon page loads (by leaving the page before any content has been painted). » ; « 22% less abandonment for news sites and 24% less abandonment for shopping sites »
- Portée / limites : seuils de 2020 (avec FID, pas INP) ; « abandon » défini comme départ avant tout affichage ; corrélation sur données agrégées, méthodologie non détaillée.
- Pourquoi c'est peu connu / ce que ça change en pratique : c'est le chiffre officiel le plus solide qui relie seuils et comportement ; il est souvent cité à tort comme « 24 % de conversions en plus ».

### Améliorer la vitesse sur tout le parcours, pas sur une page : le gain de 0,1 s n'a d'effet que s'il est obtenu à chaque étape
- Niveau de preuve : N3/N4 (étude commanditée par Google, menée par 55 et Deloitte, 37 marques, plus de 30 millions de sessions, 30 jours fin 2019)
- Source : web.dev, « Milliseconds make millions », https://web.dev/case-studies/milliseconds-make-millions
- Extrait lu : légende de la page : « A 0.1 second improvement of mobile site speed increases conversion rates by 8.4% for retail sites and 10.1% for travel sites. » ; la page précise que chaque page du parcours devait gagner 0,1 s sur chacune des quatre métriques pour observer l'effet.
- Portée / limites : commanditaire intéressé (Google), corrélationnel, métriques en partie obsolètes (First Meaningful Paint) ; aucune refonte UX pendant l'étude.
- Pourquoi c'est peu connu / ce que ça change en pratique : le chiffre « 8,4 % » circule sans sa condition — l'optimisation d'une landing page isolée ne suffit pas à le reproduire.

---

## 5. Psychologie de la décision appliquée à l'interface

### Ne pas promettre l'effet moyen d'un « nudge » : corrigé du biais de publication, l'effet global des nudges est indiscernable de zéro — tester chaque nudge chez soi
- Niveau de preuve : N2 (méta-analyse de plus de 200 études, puis ré-analyse bayésienne)
- Source : Mertens, Herberz, Hahnel, Brosch, 2022, « The effectiveness of nudging: A meta-analysis of choice architecture interventions across behavioral domains », PNAS, https://fis.leuphana.de/en/publications/the-effectiveness-of-nudging-a-meta-analysis-of-choice-architectu/ (résumé seul lu) ; Maier, Bartoš, Stanley, Shanks, Harris, Wagenmakers, 19.07.2022, « No evidence for nudging after adjusting for publication bias », PNAS 119, https://pmc.ncbi.nlm.nih.gov/articles/PMC9351501 ; rejoinder des mêmes auteurs, 03.11.2022, https://www.bayesianspectacles.org/rejoinder-no-evidence-for-nudging/
- Extrait lu : Mertens — « small to medium effect size of Cohen's d = 0.45 (95% CI [0.39, 0.52]) » et « Our analysis further reveals a moderate publication bias toward positive results in the literature. » ; Maier — estimation corrigée 0,04 [0,00 ; 0,14] et « no evidence remains that nudges are effective as tools for behaviour change » ; rejoinder — « we would retitle our article "No _Overall_ Evidence for Nuding After Adjusting for Publication Bias" » (coquille d'origine).
- Portée / limites : « pas de preuve » ≠ « preuve d'absence » ; forte hétérogénéité : certains nudges marchent sans doute, l'effet moyen est inexploitable. Pour les interventions de « structure » (dont les défauts), Maier juge la preuve « undecided ».
- Pourquoi c'est peu connu / ce que ça change en pratique : citer « les nudges font d = 0,45 » pour justifier un design est intenable depuis 2022 ; seule une A/B test locale tranche.

### Utiliser les valeurs par défaut avec parcimonie et éthique : c'est le levier de choix le mieux documenté, mais son effet est très variable
- Niveau de preuve : N2 (méta-analyse de 58 études, n cumulé = 73 675)
- Source : Jachimowicz, Duncan, Weber, Johnson, 2019, « When and why defaults influence decisions: a meta-analysis of default effects », Behavioural Public Policy 3(2):159-186, https://ideas.repec.org/a/cup/bpubpo/v3y2019i02p159-186_00.html (résumé seul lu)
- Extrait lu : « (d = 0.68, 95% confidence interval = 0.53–0.83) » ; « we also discover substantial variation » ; « two even demonstrate negative effects » ; « defaults in consumer domains are more effective and in environmental domains are less effective »
- Portée / limites : méta-analyse antérieure aux corrections de biais de publication ci-dessus ; effet plus fort quand le défaut est perçu comme une recommandation (« endorsement ») ou comme le statu quo.
- Pourquoi c'est peu connu / ce que ça change en pratique : un défaut agit surtout comme recommandation implicite — donc il engage la responsabilité du concepteur (lien direct avec les dark patterns de pré-cochage).

### Ne pas fonder un parcours sur l'« épuisement de la volonté » (ego depletion) : la réplication multi-laboratoires ne trouve presque rien
- Niveau de preuve : N2 (réplication préenregistrée, 23 laboratoires, N = 2 141)
- Source : Hagger, Chatzisarantis et al., 2016, « A Multilab Preregistered Replication of the Ego-Depletion Effect », Perspectives on Psychological Science 11(4), https://research.tilburguniversity.edu/en/publications/a-multi-lab-pre-registered-replication-of-the-ego-depletion-effec/ (résumé seul lu)
- Extrait lu : « Multiple laboratories (k = 23, total N = 2,141) » ; « (d = 0.04, 95% CI [−0.07, 0.15] » ; « the size of the ego-depletion effect was small with 95% confidence intervals (CIs) that encompassed zero »
- Portée / limites : teste un protocole (deux tâches séquentielles), pas toute forme de fatigue ; un débat de méthode a suivi (commentaires non ouverts).
- Pourquoi c'est peu connu / ce que ça change en pratique : l'argument « l'utilisateur a épuisé sa volonté, placez la décision importante en premier » repose sur un effet non répliqué ; réduire les étapes se justifie par le temps et l'abandon mesurés, pas par cette théorie.

### Ne pas compter sur un « leurre » (option dominée) pour orienter un choix de forfait, surtout si les options sont présentées visuellement
- Niveau de preuve : N2 (série d'études, Journal of Marketing Research 51(4), 2014)
- Source : Frederick, Lee, Baskin, 2014, « The Limits of Attraction », Journal of Marketing Research, https://marketing.wharton.upenn.edu/wp-content/uploads/2016/10/The-Limits-of-Attraction.pdf (texte lu)
- Extrait lu : « the authors contend that this phenomenon may be restricted to stylized product representations in which every product dimension is represented by a number » ; « Such effects do not typically occur when consumers experience the product […] or when even one of the product attributes is represented perceptually » ; « we could not replicate the results of any of these studies »
- Portée / limites : réponse de Huber, Payne & Puto dans le même numéro (« Let's Be Honest About the Attraction Effect »), non ouverte, qui défend l'effet sous conditions.
- Pourquoi c'est peu connu / ce que ça change en pratique : le « decoy pricing » est enseigné comme une recette de page tarifaire ; l'effet semble cantonné aux tableaux de chiffres abstraits — donc à tester, pas à présumer.

---

## 6. Authentification et saisie

### Proposer les passkeys à la connexion : elles réussissent plus souvent et font gagner une vingtaine de secondes par connexion
- Niveau de preuve : N3 (index de consortium industriel ; 15 services grand public, moyennes non pondérées, données déclaratives confidentielles)
- Source : FIDO Alliance, 15.10.2026, « Passkey Index 2026 », https://fidoalliance.org/passkey-index-2026/ et PDF https://fidoalliance.org/wp-content/uploads/2026/10/Passkey-Index-October-2026.pdf
- Extrait lu : « Passkey sign-ins succeed more often than traditional MFA sign-ins (93% vs 78%) and are nearly three times faster than signing in without one, saving users an average of 27 seconds per sign-in. » ; méthode : « 15 consumer relying parties […] Percentages, times and ratios are unweighted averages across the participants that reported them. » ; « More than one in three successful sign-ins now use a passkey (36%) »
- Portée / limites : promoteur de la technologie ; participants (Amazon, Google, Microsoft, PayPal, Shopify, TikTok, WhatsApp…) passés de 9 (2025) à 15 (2026), donc comparaisons inter-années « directionnelles » selon le rapport lui-même ; population déjà inscrite aux passkeys.
- Pourquoi c'est peu connu / ce que ça change en pratique : le gain se mesure surtout contre le MFA classique (SMS, OTP) ; c'est un argument de conversion autant que de sécurité, mais il faut soigner l'inscription (le goulet est l'enrôlement, pas l'usage).

### Bannir les CAPTCHA comme barrière par défaut : ils coûtent du temps aux humains alors que les bots les résolvent mieux
- Niveau de preuve : N2 (USENIX Security 2023 ; 1 400 participants, 14 000 CAPTCHA)
- Source : Searles, Nakatsuka, Ozturk, Paverd, Tsudik, Enkoji, 2023, « An Empirical Study & Evaluation of Modern CAPTCHAs », https://arxiv.org/abs/2307.12108 (résumé + PDF lus)
- Extrait lu : « 1,400 participants collectively solved 14,000 CAPTCHAs » ; « the average solving time in our study ranged from 3.6 to 42.7 seconds per CAPTCHA » ; « The bots' accuracy ranges from 85-100%, with the majority above 96%. This substantially exceeds the human accuracy range we observed (50-85%). »
- Portée / limites : comparaison bots / humains fondée sur la littérature d'attaques, pas sur des bots testés dans la même expérience ; exception : reCAPTCHA image, où temps humain (18 s) et bot (17,5 s) sont proches.
- Pourquoi c'est peu connu / ce que ça change en pratique : un CAPTCHA filtre davantage les humains que les robots ; privilégier détection passive, limitation de débit, champs-pièges, et le réserver aux signaux de risque.

---

## 7. Graphiques, tableaux et données

### Encoder la donnée principale par la position sur une échelle commune ; la hiérarchie de Cleveland & McGill tient en réplication, mais l'infériorité de l'angle sur la longueur n'est pas confirmée
- Niveau de preuve : N2 (réplication en ligne sur Mechanical Turk de Cleveland & McGill 1984)
- Source : Heer & Bostock, 2010 (CHI '10), « Crowdsourcing Graphical Perception: Using Mechanical Turk to Assess Visualization Design », https://homes.cs.washington.edu/~jheer/files/2010-MTurk-CHI.pdf (texte lu)
- Extrait lu : « The ranking of types by accuracy is consistent between the two experiments » ; « psychophysical theory […] predicts area to perform worse than angle, and both to be significantly worse than position. Theory also suggests that angle should perform worse than length, but the results do not support this. »
- Portée / limites : tâche de jugement de proportion entre deux marques ; ne mesure ni la mémorisation ni la compréhension du message.
- Pourquoi c'est peu connu / ce que ça change en pratique : « jamais de camembert » est trop fort — ce qui est solide, c'est « position > angle/aire » ; la différence angle/longueur n'est pas établie.

### Écrire le message principal dans le titre du graphique : c'est l'élément le plus regardé et le mieux mémorisé
- Niveau de preuve : N2 (oculométrie, 33 participants, 393 visualisations) — résumé lu, synthèse de praticien pour les détails
- Source : Borkin, Bylinskii et al., 2016 (IEEE TVCG 22), « Beyond Memorability: Visualization Recognition and Recall », https://vcg.seas.harvard.edu/publications/20150101-beyond-memorability-visualization-recognition-and-recall (résumé seul lu) ; synthèse : Enrico Bertini, 12.11.2024, « Titles in Data Visualization: Empirical Evidence », https://filwd.substack.com/p/titles-in-data-visualization-empirical
- Extrait lu : Borkin — « titles and supporting text should convey the message of a visualization » ; Bertini citant Borkin — « titles are the most prominent visual object readers focus on when exposed to a new visualization »
- Portée / limites : visualisations d'infographie et de presse, exposition de 10 s ; la synthèse Bertini est un avis de praticien.
- Pourquoi c'est peu connu / ce que ça change en pratique : un titre descriptif (« Ventes 2024-2026 ») gaspille l'élément le plus lu ; un titre-conclusion (« Les ventes ont doublé depuis l'ouverture du canal web ») oriente la mémorisation — voir l'entrée suivante pour le revers.

### Vérifier que le titre-conclusion dit ce que montre le graphique : les lecteurs retiennent le titre plutôt que les données, et jugent la visualisation neutre
- Niveau de preuve : N2 (deux expériences CHI 2018 et CHI 2019)
- Source : Kong, Liu, Karahalios, 2018 (CHI '18), « Frames and Slants in Titles of Visualizations on Controversial Topics », https://mail.zcliu.cs.umd.edu/vistitles/CHI18-VisTitles.pdf ; Kong, Liu, Karahalios, 2019 (CHI '19), « Trust and Recall of Information across Varying Degrees of Title-Visualization Misalignment », https://mail.zcliu.cs.umd.edu/vistitles/degree-of-misalignment-CHI19.pdf (résumés lus dans les PDF)
- Extrait lu : 2018 — « the slant of the title influenced the perceived main message of a visualization, with viewers deriving opposing messages from the same visualization » ; 2019 — « visualizations were persistently perceived as impartial by the majority. Further, people's recall of the visualization's message more frequently aligned with the titles than the visualization. »
- Portée / limites : sujets controversés (réfugiés, dépenses militaires), participants en ligne ; pas d'effet significatif sur le changement d'attitude (2018).
- Pourquoi c'est peu connu / ce que ça change en pratique : le titre-conclusion est puissant au point de pouvoir contredire les données sans être remarqué — en tableau de bord, il faut le générer ou le relire contre la donnée, surtout s'il est produit par une IA.

### Annoter les graphiques avec du texte, abondamment et au bon endroit : les lecteurs préfèrent les courbes les plus annotées
- Niveau de preuve : N2 (302 participants, IEEE VIS 2022 / TVCG)
- Source : Stokes, Setlur, Cogley, Satyanarayan, Hearst, 2022, « Striking a Balance: Reader Takeaways and Preferences when Integrating Text and Charts », https://arxiv.org/abs/2208.01780 (résumé seul lu)
- Extrait lu : « 302 participants ranked univariate line charts containing varying amounts of text » ; « participants preferred the charts with the largest number of textual annotations » ; « some kinds of information are best placed in the title, while others should be placed closer to the data. »
- Portée / limites : courbes univariées à données synthétiques (pics et tendances marqués) ; préférence et « takeaways », pas mesure de précision.
- Pourquoi c'est peu connu / ce que ça change en pratique : la doctrine minimaliste (« data-ink », peu de texte) est contredite pour la communication : texte statistique au titre, annotations des événements près des points concernés.

### Ne pas proscrire tout ornement par principe : un graphique illustré n'est pas moins compris et se retient mieux à long terme
- Niveau de preuve : N2 de faible puissance (CHI 2010, 20 participants) — **contesté**
- Source : Bateman, Mandryk, Gutwin, Genest, McDine, Brooks, 2010 (CHI '10), « Useful Junk? The Effects of Visual Embellishment on Comprehension and Memorability of Charts », https://vis.csail.mit.edu/classes/6.859/readings/pdfs/Bateman-UsefulJunk.pdf (texte lu)
- Extrait lu : « We found that people's accuracy in describing the embellished charts was no worse than for plain charts, and that their recall after a two-to-three-week gap was significantly better. Although we are cautious about recommending that all charts be produced in this style, our results question some of the premises of the minimalist approach to chart design. »
- Portée / limites : 20 participants, graphiques à la Nigel Holmes très soignés ; critique méthodologique de Stephen Few signalée par la recherche (non ouverte). Cohérent avec Borkin 2016 (« pictograms do not interfere with understanding »).
- Pourquoi c'est peu connu / ce que ça change en pratique : le « ratio data-ink » de Tufte est une préférence esthétique plus qu'un résultat empirique ; pour un support destiné à être retenu (rapport public, présentation), l'illustration pertinente est défendable.

---

## Mythes et affirmations contestées

- **« Les consultants BCG avec IA produisent 40 % de qualité en plus. »** Le chiffre circule partout, mais l'abstract de la version publiée (Organization Science, 2026) dit seulement « significantly improved quality », et les secondaires varient (40 %, 43 %, 33,9 %). Citer 12,2 % / 25,1 % / −19 % (vérifiés), pas le 40 %.
- **« Les développeurs vont plus vite avec l'IA, ils le disent. »** METR 2025 : ils se croyaient 20 % plus rapides et étaient 19 % plus lents (petit échantillon, préprint). Le ressenti n'est pas une mesure.
- **« ChatGPT abîme le cerveau » (MIT, « Your Brain on ChatGPT »).** Préprint non revu (arXiv 2506.08872, 10.06.2025, révisé 31.12.2025), 54 participants dont 18 seulement à la session croisée ; résumé lu : « LLM users displayed the weakest connectivity » et « LLM users also struggled to accurately quote their own work ». Signal intéressant, pas une base de conception. https://arxiv.org/abs/2506.08872
- **« Les nudges ont un effet moyen de d = 0,45. »** Effet non corrigé du biais de publication ; corrigé, ~0,04 et « pas de preuve globale » (Maier et al. 2022), avec forte hétérogénéité. Le débat reste ouvert (rejoinder de 2022, billets ultérieurs non ouverts).
- **« L'épuisement de la volonté » (ego depletion)** : d = 0,04 en réplication multi-laboratoires (Hagger et al. 2016).
- **« L'effet de leurre fait vendre le forfait du milieu »** : non reproduit hors tableaux de chiffres stylisés (Frederick et al. 2014), défendu sous conditions par Huber et al. 2014.
- **« La police préférée est la plus lisible » / « OpenDyslexic aide les dyslexiques »** : préférence non prédictive (Wallace 2022) ; police dédiée pas plus rapide (Rello 2013).
- **« Le mode sombre est plus lisible / repose les yeux. »** Les études de performance favorisent le clair chez les personnes à vision normale, surtout en petit corps ; le sombre reste utile pour certains profils (NN/g 2020).
- **« Un overlay rend un site conforme WCAG. »** Faux selon 1 048 praticiens signataires, et allégation sanctionnée par la FTC (accessiBe, 2025).
- **« Ajouter des explications ou des sources rend l'IA digne de confiance. »** Explications et citations augmentent l'acceptation et la confiance **indépendamment** de la justesse (Bansal 2021 ; Ding 2025).
- **« Les études de cas web.dev prouvent qu'améliorer l'INP augmente les ventes. »** redBus annonce « The result was a 7% overall increase in sales » (https://web.dev/case-studies/redbus-inp), mais la page ne décrit ni groupe témoin ni période de comparaison, et plusieurs changements ont été faits ensemble : illustration, pas preuve causale. Idem « Milliseconds make millions », commanditée par Google.
- **« Pas de camembert, jamais. »** La réplication de Heer & Bostock ne confirme pas l'infériorité de l'angle sur la longueur ; seul « position > angle/aire » est solide.
- **« Tout ornement de graphique est du chart junk. »** Contesté par Bateman 2010 et Borkin 2016 (mémorisation), mais l'étude de 2010 est petite et critiquée.

## Non vérifié

Pistes rencontrées pendant la recherche, **non confirmées par une source primaire ouverte** — à ne pas citer en l'état :

- **EAA, autres affaires françaises** : mises en demeure par ApiDV et Droit Pluriel (juillet 2025), référés du 12.11.2025, mises en demeure de la DGCCRF (novembre 2025), décision Carrefour (tribunal judiciaire de Caen, six mois pour se mettre en conformité, astreinte de 500 €/jour) — uniquement des blogs d'éditeurs d'outils ; possible contradiction avec l'issue Auchan.
- **Italie** : avis de mise en conformité à 90 jours et amendes jusqu'à 5 % du chiffre d'affaires — une seule source secondaire.
- **Economic Times (web.dev)** : INP passé de 1 s à 257 ms, −50 % de rebond, +43 % de pages vues — chiffres vus seulement dans une compilation SpeedCurve, étude de cas non ouverte.
- **redBus « INP −72 % »** : la page web.dev mentionne une amélioration de 72 % sur une modification précise (synchronisation d'état au blur), pas sur l'INP global du site.
- **FIDO Passkey Index 2025** : 8,5 s contre 31,2 s (MFA) et 93 % contre 63 % de réussite — vus dans des secondaires seulement ; l'édition 2026 (ouverte) donne 93 % contre 78 % et 27 s gagnées.
- **Dell'Acqua** : gains de 43 % (moins bons) contre 17 % (meilleurs) — secondaires seulement.
- **Kosmyna** : « 83,3 % des utilisateurs de LLM incapables de citer leur essai », « jusqu'à 55 % de connectivité en moins » — secondaires.
- **Brynjolfsson et al.** : publication au QJE 140(2), 2025, pp. 889-942 — vue dans la recherche, page éditeur non ouverte (le working paper NBER, lui, a été lu).
- **Szászi et al. (critique de Mertens)** : estimations corrigées de d = 0,03 à 0,31 ; ré-analyse à d = −0,01 — secondaires seulement.
- **NN/g, « The User Experience of Chatbots » (03.02.2025, 8 participants)** : vu via un signet et un blog, page non ouverte.
- **Proposition d'ordonnance FTC contre accessiBe en janvier 2025** : mentionnée par la recherche, communiqué de janvier non ouvert (seul le communiqué final du 22.04.2025 l'a été).
- **Études primaires sur le mode sombre (Piepenbrock 2013, Dobres 2017, Aleman 2018 sur l'amincissement choroïdien)** : connues uniquement via la synthèse NN/g.
- **Aucune étude empirique 2023-2026 sur le mode sombre et la lisibilité** n'a été trouvée lors de cette recherche (une recherche dans Human Factors / Ergonomics reste à faire).

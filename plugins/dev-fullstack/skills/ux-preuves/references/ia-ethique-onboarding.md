# Fiche `ux-preuves` — Interfaces IA, dark patterns, onboarding

> Fiche du skill `ux-preuves` (dev-fullstack). Couvre : interfaces avec IA et agents ; dark patterns, éthique et réglementation ; onboarding, états vides, notifications, undo contre confirmation.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Mythes » et « Non
> vérifié » en fin de fiche sont opposables autant que les entrées : ce qui y figure ne se cite
> pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Recherche documentaire du 9 novembre 2026. Chaque entrée s'appuie sur une page ouverte avec WebFetch,
ou sur un PDF téléchargé par WebFetch dont le texte a été extrait (pdftotext). Les citations sont
reprises dans leur langue d'origine. Une entrée marquée « résumé seul lu » ne repose que sur l'abstract.

Niveaux de preuve : N1 norme ou réglementation · N2 recherche revue par les pairs ou étude empirique
(échantillon cité) · N3 guideline officielle d'institution ou de plateforme · N4 avis d'expert ou
article de praticien.

---

## 1. Interfaces avec IA et agents

### Dès le premier contact, dire ce que le système sait faire et à quelle fréquence il se trompe
- Niveau de preuve : N2
- Source : Amershi, Weld, Vorvoreanu, Fourney, Nushi, Collisson, Suh, Iqbal, Bennett, Inkpen, Teevan, Kikin-Gil, Horvitz, 2019, « Guidelines for Human-AI Interaction » (CHI 2019, DOI 10.1145/3290605.3300233), https://www.microsoft.com/en-us/research/wp-content/uploads/2019/01/Guidelines-for-Human-AI-Interaction-camera-ready.pdf ; liste confirmée sur https://www.microsoft.com/en-us/haxtoolkit/library/
- Extrait lu : « G1 Make clear what the system can do. Help the user understand what the AI system is capable of doing. » / « G2 Make clear how well the system can do what it can do. Help the user understand how often the AI system may make mistakes. »
- Portée / limites : les 18 lignes directrices sont classées en quatre phases : « Initially » (G1-G2), « During interaction » (G3-G6), « When wrong » (G7-G11), « Over time » (G12-G18). Validées par « a user study with 49 design practitioners who tested the guidelines against 20 popular AI-infused products ». Ce sont des produits de 2018, avant les assistants génératifs. L'étude porte sur la pertinence perçue par des praticiens, pas sur un effet mesuré chez les utilisateurs finaux. Liste complète : G1 « Make clear what the system can do », G2 « Make clear how well the system can do what it can do », G3 « Time services based on context », G4 « Show contextually relevant information », G5 « Match relevant social norms », G6 « Mitigate social biases », G7 « Support efficient invocation », G8 « Support efficient dismissal », G9 « Support efficient correction », G10 « Scope services when in doubt », G11 « Make clear why the system did what it did », G12 « Remember recent interactions », G13 « Learn from user behavior », G14 « Update and adapt cautiously », G15 « Encourage granular feedback », G16 « Convey the consequences of user actions », G17 « Provide global controls », G18 « Notify users about changes ».

### Rendre l'IA facile à appeler, à écarter et à corriger : chaque sortie doit pouvoir être éditée ou annulée sur place
- Niveau de preuve : N2
- Source : Amershi et al., 2019, « Guidelines for Human-AI Interaction », https://www.microsoft.com/en-us/research/wp-content/uploads/2019/01/Guidelines-for-Human-AI-Interaction-camera-ready.pdf
- Extrait lu : « Support efficient correction. Make it easy to edit, refine, or recover when the AI system is wrong. » ; « Support efficient dismissal. Make it easy to dismiss or ignore undesired AI system services. »
- Portée / limites : l'article donne en exemple un rappel vocal suivi de « 'Tap to Edit' ». Il ne dit rien des agents qui agissent hors de l'interface (paiement, envoi), où l'annulation après coup n'est pas toujours possible. Voir l'entrée sur les agents et la section 3 (undo et confirmation).

### Quand l'intention de l'utilisateur est ambiguë, proposer plusieurs options ou poser une question plutôt qu'agir
- Niveau de preuve : N2
- Source : Amershi et al., 2019, « Guidelines for Human-AI Interaction », https://www.microsoft.com/en-us/research/wp-content/uploads/2019/01/Guidelines-for-Human-AI-Interaction-camera-ready.pdf
- Extrait lu : « G10 Scope services when in doubt. Engage in disambiguation or gracefully degrade the AI system's services when uncertain about a user's goals. »
- Portée / limites : l'exemple cité est celui d'un autocomplete qui « usually provides 3-4 suggestions instead of directly auto completing it for you ». NN/g (2026, entrée « agents » plus bas) retrouve ce besoin chez un agent : un prompt prérempli y a commandé le mauvais article, d'où la recommandation de poser d'abord une question de clarification.

### Viser une confiance calibrée, et préférer des niveaux de confiance par catégories, chacun associé à une action, à un pourcentage brut
- Niveau de preuve : N3
- Source : Google PAIR (People + AI Research), s. d., « People + AI Guidebook — Explainability + Trust », https://pair.withgoogle.com/chapter/explainability-trust/
- Extrait lu : « Users shouldn't implicitly trust your AI system in all circumstances, but rather calibrate their trust correctly. » ; « Numeric confidence indicators are risky because they presume your users have a good baseline understanding of probability. » ; « Clearly indicate what action a user should take under each category of confidence. » ; « The best explanation is likely a partial one. »
- Portée / limites : la page n'affiche ni date ni version, et ses références vont de 2016 à 2019, donc avant les LLM grand public. Il s'agit d'une doctrine de plateforme, sans étude propre. La page d'accueil et le sommaire du guide (pair.withgoogle.com/guidebook) n'ont rendu aucun texte.

### Ne pas compter sur les explications pour réduire la sur-confiance : elles font accepter l'IA, qu'elle ait raison ou tort
- Niveau de preuve : N2
- Source : Bansal, Wu, Zhou, Fok, Nushi, Kamar, Ribeiro, Weld, 2021, « Does the Whole Exceed its Parts? The Effect of AI Explanations on Complementary Team Performance » (CHI 2021), https://arxiv.org/abs/2006.14779
- Extrait lu : « Rather, explanations increased the chance that humans will accept the AI's recommendation, regardless of its correctness. »
- Portée / limites : résumé seul lu. Tâches NLP (sentiment, questions-réponses), avec une précision de l'IA calée sur celle des humains. La recherche web rapporte qu'un simple affichage de confiance a fait aussi bien que les explications ; je n'ai pas lu cette phrase moi-même.

### Pour les décisions à enjeu, ajouter une friction qui pousse à réfléchir (avis de l'utilisateur d'abord, délai, attente explicite), en sachant qu'elle déplaira
- Niveau de preuve : N2
- Source : Buçinca, Malaya, Gajos, 2021, « To Trust or to Think: Cognitive Forcing Functions Can Reduce Overreliance on AI in AI-assisted Decision-making » (PACM HCI, CSCW1), https://arxiv.org/abs/2102.09692
- Extrait lu : « cognitive forcing significantly reduced overreliance compared to the simple explainable AI approaches » ; « there was a trade-off: people assigned the least favorable subjective ratings » [to the designs that most reduced overreliance]
- Portée / limites : résumé seul lu. N=199, recrutés sur Mechanical Turk, sur une tâche de nutrition. La sur-confiance baisse sans disparaître. La recherche web rapporte que le bénéfice va surtout aux personnes à fort « need for cognition », ce que je n'ai pas lu dans le résumé ouvert.

### Exprimer l'incertitude en langage naturel et à la première personne (« Je ne suis pas sûr, mais… »), puis tester la formulation exacte
- Niveau de preuve : N2
- Source : Kim, Liao, Vorvoreanu, Ballard, Wortman Vaughan, 2024, « "I'm Not Sure, But...": Examining the Impact of Large Language Models' Uncertainty Expression on User Reliance and Trust » (FAccT 2024, et non CHI), https://arxiv.org/abs/2405.00623
- Extrait lu : résumé lu via WebFetch, qui ne restitue que des fragments. Formulation du résumé : les hedges à la première personne comme « I'm not sure, but... » font baisser la confiance et l'accord avec le système et améliorent la précision ; la formulation générale (« It's not clear, but... ») a des effets plus faibles, non significatifs.
- Portée / limites : résumé seul lu. N=404, expérience préenregistrée, questions médicales, moteur de recherche « LLM » fictif. La sur-confiance envers les réponses fausses baisse sans être éliminée. Les auteurs insistent : la formulation précise compte, et il faut la tester avant de déployer.

### Ne pas croire qu'afficher des sources suffit à fiabiliser une réponse : des liens, même faux, augmentent la confiance
- Niveau de preuve : N2 (préprint, pas de revue par les pairs indiquée)
- Source : Li, Aral, 2025, « Human Trust in AI Search: A Large-Scale Experiment », arXiv:2504.06435 (8 avril 2025), https://arxiv.org/abs/2504.06435
- Extrait lu : reference links and citations « significantly increase trust in GenAI » even when they are « incorrect or hallucinated » ; uncertainty highlighting makes people « less willing to trust and share generative information ».
- Portée / limites : résumé seul lu. Expérience randomisée préenregistrée sur un échantillon « representative of the U.S. population » ; le résumé ne donne pas l'effectif (environ 12 000 requêtes dans sept pays). Ce n'est pas publié en revue à ma connaissance de la page. Le cadre Microsoft (entrée suivante) fait le même constat : « The mere presence of sources can make users trust AI outputs more. »

### Faire porter les efforts sur trois objectifs : un modèle mental réaliste, un signal qui dit quand vérifier, une vérification peu coûteuse ; puis mesurer, car les parades se retournent souvent
- Niveau de preuve : N3
- Source : Microsoft (Passi, Vorvoreanu, Kikin-Gil, Dhanorkar, Heger, Walker), 2025 (ms.date 27.02.2025, mise à jour 27.03.2025), « Overreliance on AI: Risk Identification and Mitigation Framework », https://learn.microsoft.com/en-us/ai/playbook/technology-guidance/overreliance-on-ai/overreliance-on-ai
- Extrait lu : « Overreliance on AI happens when users accept incorrect or incomplete AI outputs, typically because AI system design makes it difficult to spot errors. » ; « Keep in mind that many overreliance mitigations can backfire. » ; « Explanations can increase user trust even when they are incorrect. »
- Portée / limites : cadre pensé pour des contenus ancrés dans une source fiable (bases métier, résultats web). Il rappelle que le risque est plus élevé quand l'IA agit sans revue : « Overreliance risk is higher in automation scenarios where the AI can perform actions without giving the user the opportunity to review them. » Facteurs aggravants cités : faible culture IA, absence d'expertise du domaine, faible familiarité avec la tâche, confiance élevée dans l'IA. Il cite comme parades les expressions d'incertitude, la friction et les « UI messaging during latency ».

### Signaler visuellement les passages où le modèle est peu sûr, pour orienter la vérification
- Niveau de preuve : N2 (préprint)
- Source : Spatharioti, Rothschild, Goldstein, Hofman, 2023, « Comparing Traditional and LLM-based Search for Consumer Choice: A Randomized Experiment », arXiv:2307.03744 (v2 du 8 nov. 2023), https://arxiv.org/abs/2307.03744
- Extrait lu : « we observed overreliance on incorrect information when the LLM erred » ; « this confidence-based highlighting substantially increases the rate at which users spot incorrect information »
- Portée / limites : résumé seul lu ; effectif non donné dans le résumé ; aucune revue indiquée. À opposer à Li et Aral (2025) : le surlignage d'incertitude fait aussi baisser la confiance quand la réponse est juste. Le coût est réel.

### Placer chaque citation à côté de l'affirmation qu'elle soutient, renvoyer au passage précis, et ne pas présenter un raisonnement pas à pas comme une preuve de transparence
- Niveau de preuve : N4 (analyse NN/g appuyée sur leurs études d'usage et sur la littérature)
- Source : Megan Chan (Nielsen Norman Group), 12 décembre 2025, « Explainable AI in Chat Interfaces », https://www.nngroup.com/articles/explainable-ai/
- Extrait lu : « the explanations currently offered by large language models (LLMs) are often inaccurate, hidden, or confusing » ; « people rarely click citation links » ; les raisonnements affichés sont souvent des « rationalizations generated after the fact » ; les avertissements « help only if users read them ».
- Portée / limites : analyse de six assistants (Claude, ChatGPT, Copilot, Gemini, Perplexity, DeepSeek), sans étude chiffrée propre. Elle s'appuie sur Turpin et al. (2023) pour l'infidélité des chaînes de raisonnement. Elle déconseille aussi l'anthropomorphisme, qui peut « inflate trust ».

### Rendre visible ce qui n'a pas de source, et ne pas laisser l'IA trancher seule sur les faits critiques (prix, santé, chiffres)
- Niveau de preuve : N2 (étude qualitative, petit échantillon)
- Source : Maria Rosala, Josh Brown (NN/g), 27 février 2026, « GenAI for Complex Questions, Search for Critical Facts », https://nngroup.com/articles/ai-search-infoseeking/
- Extrait lu : users « gravitated towards traditional search when they wanted control over the search process and confidence in the results » ; « There's all this big chunk of information here that doesn't have a source. »
- Portée / limites : étude observationnelle à distance, 9 participants (six alternaient recherche classique et chatbot), tâches réelles des participants. C'est qualitatif : ni fréquence ni effet mesuré.

### Dans un chatbot, donner la réponse d'abord, courte, dire tout de suite ce qu'on ne sait pas faire, et proposer le détail à la demande
- Niveau de preuve : N2 (étude qualitative, petit échantillon)
- Source : Maria Rosala, Georgia Kenderova, Tanner Kohler (NN/g), 17 avril 2026, « Less Chat, More Answer: Site AI Chatbots Need to Get to the Point », https://www.nngroup.com/articles/less-chat-more-answer/
- Extrait lu : « Users got straight to the point. » ; « The pouring in of information kind of made me feel overwhelmed. » ; « I do not want, like, to beat around the bush. »
- Portée / limites : 9 participants, 8 chatbots de sites (Turo, Home Depot, Williams Sonoma, Jeux olympiques…). Le streaming d'un texte long y aggrave la surcharge. Le résultat vaut pour des chatbots de site e-commerce ou de service, pas forcément pour un assistant de travail généraliste.

### Pendant la génération, ne pas faire défiler l'utilisateur de force jusqu'à la fin de la réponse
- Niveau de preuve : N4 (guidelines NN/g issues d'observations dont la méthode n'est pas détaillée)
- Source : Georgia Kenderova, Maria Rosala, Tanner Kohler (NN/g), 24 avril 2026, « 10 Guidelines for Designing Your Site's AI Chatbots », https://www.nngroup.com/articles/ai-chatbots-design-guidelines/
- Extrait lu : intitulés des lignes directrices : « Don't Autoscroll Users to the End of a Response » ; « Use Progressive Disclosure to Keep the Chat Short » ; « Show What the Chatbot Can Do Through Informative Messages and Suggested Prompts » ; « Offer Relevant Suggested Questions as Buttons, Not Text ».
- Portée / limites : l'article dit avoir « studied real users interacting with AI chatbots across multiple sites » sans donner d'effectif ni de méthode. Il recoupe probablement l'étude à 9 participants ci-dessus, mais je ne l'ai pas vérifié.

### Pour une attente qui dépasse environ 10 s, montrer une progression (pourcentage, ou étape en cours nommée) plutôt qu'un simple indicateur d'activité
- Niveau de preuve : N4 (synthèse d'expert fondée sur Miller 1968, Card et al. 1991, Myers 1985)
- Source : Jakob Nielsen, 1993, « Response Times: The 3 Important Limits » (extrait de *Usability Engineering*), https://www.nngroup.com/articles/response-times-3-important-limits/
- Extrait lu : 0,1 s, la limite pour que le système semble « reacting instantaneously » ; 1 s, celle du « flow of thought » ; 10 s, celle du « keeping the user's attention focused on the dialogue ».
- Portée / limites : texte de 1993, qui ne porte ni sur le streaming ni sur les agents. Quand la quantité de travail est inconnue, Nielsen conseille de montrer la progression en termes absolus (nommer l'élément en cours de traitement), et réserve le spinner générique au dernier recours. Pour une génération ou un agent, c'est une transposition raisonnable, pas un résultat mesuré. Le cadre Microsoft cite « UI messaging during latency » parmi les parades.

### Un agent qui agit pour l'utilisateur doit exiger un accord actif pour les autorisations, montrer tout changement de prix, et laisser relire avant de payer
- Niveau de preuve : N2 (étude d'utilisabilité, très petit échantillon)
- Source : Feifei Liu, Maria Rosala (NN/g), 8 mai 2026, « Designing AI Agents: 4 Lessons from China's Qwen Agent », https://www.nngroup.com/articles/designing-ai-agents/
- Extrait lu : leçons « Handle Personal Data Carefully » et « Prioritize Transparency to Protect Autonomy » ; les écrans d'autorisation doivent exiger une « active acknowledgment » ; l'autonomie « depends on transparency ». Un participant : « I feel like my address was leaked. »
- Portée / limites : 6 participants chinois, agent Qwen (Alibaba), commande de thé au lait et réservation de vol. Un prix est passé de 1,6 à 10,2 ¥ au paiement sans explication. L'article ne traite pas des états d'attente.

---

## 2. Dark patterns, éthique, réglementation

### Partir du principe que les dark patterns sont répandus et industrialisés, et auditer les parcours d'achat (produit, panier, paiement)
- Niveau de preuve : N2
- Source : Mathur, Acar, Friedman, Lucherini, Mayer, Chetty, Narayanan, 2019, « Dark Patterns at Scale: Findings from a Crawl of 11K Shopping Websites » (PACM HCI, vol. 3, CSCW, art. 81), https://arxiv.org/abs/1907.07032 (texte intégral lu via https://arxiv.org/pdf/1907.07032)
- Extrait lu : « Analyzing ∼53K product pages from ∼11K shopping websites, we discover 1,818 dark pattern instances, together representing 15 types and 7 broader categories » ; « These 1,818 dark patterns were found on 1,254 of the ∼11K shopping websites (∼11.1%) »
- Portée / limites : chiffres exacts : 53 180 pages produits sur 11 286 sites marchands ; 183 sites avec des pratiques trompeuses ; 22 tiers vendent des dark patterns « clés en main » (intégrés à 1 066 sites). Les auteurs parlent d'une « lower bound » : seuls les textes de pages produit, panier et paiement ont été analysés, en anglais, sur des sites populaires (classement Alexa). Les sites les plus populaires en affichaient plus souvent.

### Même un nudge « léger » (option pré-mise en avant, « recommandé ») double l'adhésion sans provoquer de rejet : le traiter comme un dark pattern à part entière
- Niveau de preuve : N2
- Source : Luguri, Strahilevitz, 2021, « Shining a Light on Dark Patterns », *Journal of Legal Analysis* 13(1), 43-109, https://academic.oup.com/jla/article/13/1/43/6180579
- Extrait lu : « users exposed to mild dark patterns were more than twice as likely to sign up for a dubious service » ; « whereas aggressive dark patterns generated a powerful backlash among consumers, mild dark patterns did not » ; « Less educated subjects were significantly more susceptible to mild dark patterns »
- Portée / limites : échantillons représentatifs américains, 1 963 participants (étude 1) et 3 777 (étude 2). Scénario fictif d'abonnement à une protection contre l'usurpation d'identité. Seuls les 100 000 premiers caractères de la page ont été lus. Les taux précis (11 %, 26 %, 42 %) viennent d'une présentation et n'ont pas été vérifiés dans l'article.

### Mettre « Tout refuser » sur le premier écran du bandeau de consentement : son absence suffit à fausser fortement le choix
- Niveau de preuve : N2
- Source : Nouwens, Liccardi, Veale, Karger, Kagal, 2020, « Dark Patterns after the GDPR: Scraping Consent Pop-ups and Demonstrating their Influence » (CHI 2020), https://arxiv.org/abs/2001.02479
- Extrait lu : « only 11.8% meet the minimal requirements » (des CMP étudiées, selon les critères juridiques des auteurs). Le résumé indique que retirer le bouton de refus de la première page augmente le consentement de 22 à 23 points, et que des choix granulaires sur la première page le réduisent de 8 à 20 points.
- Portée / limites : résumé seul lu. Étude du Royaume-Uni, 2019-2020, sur les CMP les plus courantes. Le droit applicable a évolué depuis : voir CNIL et EDPB.

### Sur une plateforme en ligne de l'UE, ne pas mettre un choix plus en avant, ne pas redemander un choix déjà fait, ne pas rendre la résiliation plus dure que l'inscription
- Niveau de preuve : N1
- Source : Règlement (UE) 2022/2065 (Digital Services Act), art. 25 « Online interface design and organisation », JO L 277 du 27.10.2022. Le texte n'a pas pu être rendu depuis EUR-Lex (pages vides en EN et en FR, PDF illisible). Lu sur la reproduction du JO : https://www.springlex.eu/en/packages/dsa/dsa-regulation/article-25/
- Extrait lu : « Providers of online platforms shall not design, organise or operate their online interfaces in a way that deceives or manipulates the recipients of their service or in a way that otherwise materially distorts or impairs the ability of the recipients of their service to make free and informed decisions. » ; 3(a) « giving more prominence to certain choices when asking the recipient of the service for a decision; » ; 3(b) « repeatedly requesting that the recipient of the service make a choice where that choice has already been made, especially by presenting pop-ups that interfere with the user experience; » ; 3(c) « making the procedure for terminating a service more difficult than subscribing to it. »
- Portée / limites : ne vise que les fournisseurs de **plateformes en ligne**. Le §2 exclut les pratiques déjà couvertes par la directive 2005/29/CE (pratiques commerciales déloyales) et par le RGPD : un bandeau cookies relève donc du RGPD et de ePrivacy (CNIL, EDPB), pas de l'art. 25. Le §3 annonce des lignes directrices de la Commission, que je n'ai pas cherchées. Avant toute citation juridique, revérifier le texte sur EUR-Lex.

### Pour toute interface qui touche aux données personnelles, contrôler les six familles de l'EDPB : Overloading, Skipping, Stirring, Obstructing, Fickle, Left in the dark
- Niveau de preuve : N3 (lignes directrices d'une autorité européenne, interprétatives du RGPD)
- Source : EDPB, 2023, « Guidelines 03/2022 on deceptive design patterns in social media platform interfaces: how to recognise and avoid them », version 2.0, adoptée le 14 février 2023 (v1.0 du 14 mars 2022), https://www.edpb.europa.eu/system/files/2023-02/edpb_03-2022_guidelines_on_deceptive_design_patterns_in_social_media_platform_interfaces_v2_en_0.pdf
- Extrait lu : « Obstructing means hindering or blocking users in their process of becoming informed or managing their data by making the action hard or impossible to achieve. » ; « Stirring affects the choice users would make by appealing to their emotions or using visual nudges. » ; « Overloading means users are confronted with an avalanche/large quantity of requests, information, options or possibilities… »
- Portée / limites : écrites pour les réseaux sociaux, mais la grille (fondée sur loyauté, transparence et minimisation du RGPD) se transpose. Sous-types : Continuous prompting, Privacy Maze, Too Many Options ; Deceptive Snugness, Look over there ; Emotional Steering, Hidden in plain sight ; Dead end, Longer than necessary, Misleading action ; Lacking hierarchy, Decontextualising, Inconsistent Interface, Language Discontinuity ; Conflicting information, Ambiguous wording or information.

### Cookies en France : un bouton « Tout refuser » au même niveau et avec le même aspect que « Tout accepter », et un retrait du consentement aussi simple que son recueil
- Niveau de preuve : N3 (recommandation et FAQ d'autorité de contrôle ; les lignes directrices s'appuient sur l'art. 82 de la loi Informatique et Libertés)
- Source : CNIL, page datée du 29 avril 2026, « Questions-réponses sur les lignes directrices modificatives et la recommandation « cookies et autres traceurs » de la CNIL », https://www.cnil.fr/fr/cookies-et-autres-traceurs/regles/cookies/FAQ
- Extrait lu : « il doit toutefois être aussi facile d'accepter que de refuser les traceurs » ; « d'un bouton « tout refuser », au même niveau et avec le même aspect que le bouton « tout accepter » » ; poursuivre la navigation « doit aujourd'hui s'interpréter comme un refus de consentir » ; « Le principe général est qu'il doit être aussi simple de retirer son consentement que de le donner. »
- Portée / limites : la FAQ admet d'autres solutions si elles permettent de refuser aussi aisément. L'éditeur reste libre de la couleur, de la taille et de la forme des boutons, pourvu qu'ils ne trompent pas. La recherche web situe la recommandation au 17 septembre 2020, avec une version consolidée publiée en janvier 2026 ; je n'ai pas ouvert ce PDF.

### Ne pas réduire le refus à un lien discret, ne pas le noyer dans le texte, ne pas répéter l'acceptation plusieurs fois dans le bandeau
- Niveau de preuve : N3 (pratique d'application d'une autorité)
- Source : CNIL, 12 décembre 2024, « Bannières cookies trompeuses : la CNIL met en demeure des éditeurs de sites web », https://www.cnil.fr/fr/bannieres-cookies-trompeuses-la-cnil-met-en-demeure-des-editeurs-de-sites-web
- Extrait lu : des bandeaux qui « mettent en valeur de manière disproportionnée l'option d'acceptation » ; « l'option de refus se confond avec les mentions d'information » ; « l'option de refus est accolée à d'autres paragraphes » ; « l'option d'acceptation est présentée plusieurs fois dans la bannière ».
- Portée / limites : ce sont des mises en demeure, pas des sanctions ; les éditeurs avaient un mois pour se conformer. Elles montrent ce que la CNIL considère comme non conforme en pratique.

### Une résiliation doit être au moins aussi facile que l'inscription, par le même canal et sans offres de rétention qui la retardent
- Niveau de preuve : N3 (rapport du staff de la FTC, qui s'appuie sur la loi ROSCA)
- Source : Federal Trade Commission, septembre 2022, « Bringing Dark Patterns to Light » (Staff Report), https://www.ftc.gov/system/files/ftc_gov/pdf/P214800%20Dark%20Patterns%20Report%209.14.2022%20-%20FINAL.pdf
- Extrait lu : « negative option sellers should provide cancellation mechanisms that are at least as easy to use as the method the consumer used to buy the product or sign up for the service » ; définition : « design practices that trick or manipulate users into making choices they would not otherwise have made and that may cause harm ».
- Portée / limites : droit américain. Le rapport regroupe les pratiques en quatre familles : celles qui induisent de fausses croyances, qui cachent ou retardent l'information, qui mènent à des débits non autorisés, qui obscurcissent les choix de vie privée. La règle fédérale « Click-to-Cancel » qui devait codifier ce principe a été annulée par la Cour d'appel du 8e circuit le 8 juillet 2025, pour vice de procédure (source secondaire : Greenberg Traurig, https://www.gtlaw.com/en/insights/2025/7/eighth-circuit-vacates-ftcs-click-to-cancel-rule). ROSCA reste applicable. Dans l'UE, le même principe figure à l'art. 25(3)(c) du DSA.

### Utiliser la taxonomie de deceptive.design comme liste de revue d'un parcours (préselection, frais cachés, fausse urgence, confirmshaming, nagging…)
- Niveau de preuve : N4 (taxonomie de praticien, très citée)
- Source : Harry Brignull, s. d., « Types of deceptive pattern », https://www.deceptive.design/types
- Extrait lu : le site se dit « formerly called 'Dark Patterns' » (anciennement darkpatterns.org). Il compte 18 types : Sneaking, Forced action, Hard to cancel, Preselection, Obstruction, Hidden subscription, Hidden costs, Trick wording, Visual interference, Fake social proof, Fake urgency, Nagging, Fake scarcity, Disguised ads, Confirmshaming, Comparison prevention, Addictive Design, Currency Confusion.
- Portée / limites : taxonomie d'expert, pas un résultat de recherche ; la page ne date ni la liste ni le renommage. Utile pour une revue, mais sans valeur juridique. Croiser avec l'EDPB et le DSA.

---

## 3. Onboarding, activation, notifications, rétention

### Préférer l'aide contextuelle, déclenchée au moment où elle sert, aux tutoriels d'entrée en « paquet de cartes »
- Niveau de preuve : N4 (analyse NN/g fondée sur leurs recherches d'usage)
- Source : Page Laubheimer (NN/g), 12 février 2023, « Onboarding Tutorials vs. Contextual Help », https://www.nngroup.com/articles/onboarding-tutorials/
- Extrait lu : « Tutorials interrupt users, don't necessarily improve task performance, and are quickly forgotten. » Les tutoriels sont des « push revelations », qui « reveal new information out of context ».
- Portée / limites : exception reconnue : un « novel interaction paradigm like AR ». Les tutoriels marchent mieux quand ils font faire la tâche plutôt que la montrer, et quand on peut les retrouver plus tard (exemple d'ArcGIS). L'article ne donne pas d'effectifs chiffrés.

### Montrer d'abord les quelques options importantes, le reste à la demande, et ne pas dépasser deux niveaux
- Niveau de preuve : N4
- Source : Jakob Nielsen (NN/g), 3 décembre 2006, « Progressive Disclosure », https://www.nngroup.com/articles/progressive-disclosure/
- Extrait lu : « Initially, show users only a few of the most important options. » ; « Offer a larger set of specialized options upon request. »
- Portée / limites : au-delà de deux niveaux, l'utilisabilité est souvent faible. Le chemin vers les options secondaires doit être évident et bien libellé. La variante « staged disclosure » (assistant pas à pas) pose problème quand les étapes dépendent les unes des autres. Article ancien, qui se réfère à des recherches sans les détailler.

### Un état vide doit dire où en est le système, apprendre à quoi sert l'écran, et offrir un lien direct vers la première action
- Niveau de preuve : N4
- Source : Kate Kaplan (NN/g), 19 septembre 2021, « Designing Empty States in Complex Applications: 3 Guidelines », https://www.nngroup.com/articles/empty-state-interface-design/
- Extrait lu : « Totally empty states cause confusion about how and whether the system is working. » ; « Empty states present an opportunity to provide contextual help relevant to the user's task. »
- Portée / limites : écrit pour des applications complexes, de métier. Cela recoupe HAX G1 : un état vide est une occasion de dire ce que le système sait faire.

### Ne pas demander la permission de notifier au démarrage : attendre une action de l'utilisateur qui en montre l'utilité, et expliquer pourquoi
- Niveau de preuve : N3
- Source : Android Developers (Google), s. d., « Notification runtime permission », https://developer.android.com/develop/ui/views/notifications/notification-permission
- Extrait lu : « Before you ask users to grant any permissions, let them familiarize themselves with your app. » ; « do so in the correct context, so that it's explicitly clear what the notifications are used for and why the user should opt in »
- Portée / limites : Android 13 (API 33) et plus, où les notifications sont désactivées par défaut sur une nouvelle installation. Exemples de bons moments : toucher une cloche d'alerte, suivre un compte, passer une commande. Les guidelines d'Apple n'ont pas pu être lues (page rendue vide).

### Regrouper les notifications non urgentes en quelques envois par jour plutôt que les envoyer au fil de l'eau, ou les supprimer
- Niveau de preuve : N2
- Source : Fitz, Kushlev, Jagannathan, Lewis, Paliwal, Ariely, 2019, « Batching smartphone notifications can improve well-being », *Computers in Human Behavior* 101, 84-94, https://scholars.duke.edu/publication/1402953
- Extrait lu : « we conducted a randomized field experiment (n = 237) » ; « participants whose notifications were batched three-times-a-day felt more attentive, productive, in a better mood » ; « participants who did not receive notifications at all... experienced higher levels of anxiety »
- Portée / limites : résumé seul lu. Le pays des participants et l'effet d'un regroupement horaire n'ont pas été vérifiés. Les mesures sont déclaratives.

### Couper les notifications réduit la distraction mais crée de l'anxiété sociale : laisser l'utilisateur régler finement, plutôt que tout ou rien
- Niveau de preuve : N2 (petit échantillon, préprint)
- Source : Pielot, Rello, 2016-2017, « Productive, Anxious, Lonely: 24 Hours Without Push Notifications », arXiv:1612.02314, https://arxiv.org/abs/1612.02314
- Extrait lu : « without notifications, participants felt less distracted and more productive » ; « which made some participants anxious » ; « less connected with one's social group » ; « Two years later, half of the participants are still following through with their plans. »
- Portée / limites : résumé seul lu. 30 volontaires, 24 heures. La page cite un DOI ACM sans nommer la revue. Cela recoupe Fitz et al. : supprimer toutes les notifications n'est pas l'optimum.

### Limiter les interruptions pendant une tâche : même quand les gens rattrapent le temps perdu, ils le paient en stress
- Niveau de preuve : N2
- Source : Mark, Gudith, Klocke, 2008, « The Cost of Interrupted Work: More Speed and Stress » (CHI 2008, p. 107-110), https://www.interruptions.net/literature/Mark-CHI08.pdf (texte intégral lu)
- Extrait lu : « people completed interrupted tasks in less time with no difference in quality » ; « people compensate for interruptions by working faster, but this comes at a price: experiencing more stress, higher frustration, time pressure and effort » ; « After only 20 minutes of interrupted performance people reported significantly higher stress »
- Portée / limites : expérience en laboratoire avec 48 sujets, dont 81 % d'étudiants allemands, sur une tâche d'e-mail ; interruptions toutes les deux minutes environ, par téléphone ou messagerie instantanée. Que l'interruption soit liée ou non à la tâche ne change rien. Ce papier ne contient pas le chiffre « 23 minutes » (voir Mythes).

### Garder la confirmation pour les actions graves et irréversibles, l'écrire avec des boutons explicites ; ailleurs, offrir l'annulation
- Niveau de preuve : N4
- Source : Jakob Nielsen (NN/g), 18 février 2018 (relu le 7 août 2026), « Confirmation Dialogs Can Prevent User Errors — If Not Overused », https://www.nngroup.com/articles/confirmation-dialog/
- Extrait lu : « Use a confirmation dialog before committing to actions with serious consequences. » ; « Such automated behavior provides no protection at all. »
- Portée / limites : exemple de boutons « Delete file » / « Keep file », plutôt que Oui/Non. L'annulation y est présentée comme la meilleure protection. Article d'expert ; l'habituation est mesurée dans l'entrée suivante.

### Ne pas répéter le même avertissement à l'identique : l'attention s'effondre dès la deuxième exposition ; varier sa forme ou le réserver aux cas rares
- Niveau de preuve : N2
- Source : Anderson, Kirwan, Jenkins, Eargle, Howard, Vance, 2015, « How Polymorphic Warnings Reduce Habituation in the Brain: Insights from an fMRI Study » (CHI 2015), https://scholarsarchive.byu.edu/facpub/9306 ; suite longitudinale : Vance, Jenkins, Anderson, Bjornn, Kirwan, 2018, « [Tuning|Turning] Out Security Warnings: A Longitudinal (premier mot du titre rendu « Turning » par l'outil de lecture ; à vérifier sur la page) Examination of Habituation Through fMRI, Eye Tracking, and Field Experiments », *MIS Quarterly* 42(2), 355-380, https://aisel.aisnet.org/misq/vol42/iss2/3
- Extrait lu : « Our results show a dramatic drop in the visual processing centers of the brain after only the second exposure to a warning » ; « our polymorphic warning is substantially more resistant to habituation than conventional warnings » (2015) ; « polymorphic permission warnings, adherence dropped at a substantially lower rate » (2018, expérience de terrain de trois semaines)
- Portée / limites : résumés seuls lus ; effectifs non lus. Il s'agit d'avertissements de sécurité, transposés par analogie aux confirmations. La presse rapporte que l'étude de 2015 n'a pas mesuré l'effet sur les clics. Une variation trop forte peut nuire à la cohérence : c'est à tester.

---

## Mythes et affirmations contestées

- **« Il faut 23 minutes pour se reconcentrer après une interruption. »** Le chiffre vient d'une interview de Gloria Mark (Gallup Business Journal, 8 juin 2006, https://news.gallup.com/businessjournal/23146/Too-Many-Interruptions-Work.aspx) : « it was resumed, on average, in 23 minutes and 15 seconds ». Il s'agit du délai avant de **reprendre** la tâche interrompue (81,9 % reprises le jour même), dans une observation de terrain de 36 personnes pendant trois jours. Ce n'est pas un temps de reconcentration : ce délai inclut d'autres tâches faites entre-temps. Il ne figure pas dans le papier CHI 2008, souvent cité à sa place (vérifié dans le texte intégral). Selon une source secondaire, le papier CHI 2005 (Mark, González, Harris) donnerait 25 min 26 s ; non lu.
- **« Une IA qui s'explique inspire une confiance justifiée. »** Les explications font accepter la recommandation « regardless of its correctness » (Bansal et al., 2021) ; Microsoft (2025) : « Explanations can increase user trust even when they are incorrect. » NN/g (Chan, 2025) : les raisonnements pas à pas sont souvent des rationalisations après coup.
- **« Des citations rendent la réponse vérifiable. »** Des liens faux augmentent quand même la confiance (Li et Aral, 2025, préprint). Les utilisateurs cliquent rarement sur les citations (NN/g, 2025), et ont du mal à savoir quelle source soutient quelle affirmation (NN/g, 2026).
- **« Un pourcentage de confiance aide l'utilisateur. »** PAIR le déconseille, parce qu'il suppose une bonne compréhension des probabilités ; préférer des catégories associées à une action. Le surlignage d'incertitude aide à repérer les erreurs (Spatharioti et al., 2023) mais fait aussi baisser la confiance dans les réponses justes (Li et Aral, 2025).
- **« Un avertissement ou un disclaimer protège. »** Ils ne servent que s'ils sont lus (NN/g, 2025), et l'attention s'effondre dès la deuxième exposition (Anderson et al., 2015).
- **« Un tutoriel d'entrée améliore la prise en main. »** NN/g (2023) : ils « don't necessarily improve task performance » et sont vite oubliés. Exception : un paradigme d'interaction nouveau comme l'AR.
- **« Zéro notification, c'est le mieux pour l'utilisateur. »** Fitz et al. (2019) et Pielot et Rello (2017) : la suppression totale augmente l'anxiété ; le regroupement en trois envois par jour fait mieux.
- **« 11 % des sites marchands ont des dark patterns. »** C'est une **borne basse** : textes en anglais seulement, pages produit, panier et paiement seulement (Mathur et al., 2019). Ne pas lire « 89 % n'en ont pas ».
- **« L'art. 25 du DSA interdit les bandeaux cookies trompeurs. »** L'art. 25(2) exclut les pratiques couvertes par le RGPD et la directive sur les pratiques commerciales déloyales. Les bandeaux relèvent du RGPD et d'ePrivacy, donc de la CNIL et de l'EDPB.
- **« La règle FTC Click-to-Cancel est en vigueur. »** Elle a été annulée le 8 juillet 2025 par le 8e circuit, avant son entrée en vigueur (source secondaire : Greenberg Traurig). Le principe reste exigé via ROSCA (rapport FTC 2022).
- **« Les lignes directrices d'Amershi datent du CHI et concernent les LLM. »** Elles ont été validées en 2018-2019 sur 20 produits de l'époque (recommandation musicale, autocomplete, assistants vocaux…), avant l'IA générative grand public. Elles restent pertinentes, mais elles ne disent rien des agents ni du streaming.

## Non vérifié

- **« 63 % des utilisateurs s'appuient davantage sur une IA qui affiche sa confiance (NN/g, 2024) »** : attribué à NN/g par UX Matters (novembre 2025), mais aucune source NN/g primaire trouvée. Ne pas citer.
- **Raskin (*The Humane Interface*) sur l'habituation aux boîtes de confirmation** : livre non accessible, non lu.
- **Mark, González, Harris, CHI 2005, « No Task Left Behind? »** : chiffre de 25 min 26 s et effectif de 24 travailleurs rapportés par des sources secondaires ; papier non lu.
- **Apple Human Interface Guidelines, demande de permissions** : la page n'a rendu aucun texte ; rien n'en est repris.
- **Texte de l'art. 25 du DSA sur EUR-Lex** : illisible via WebFetch (pages vides, PDF compressé) ; lu sur une reproduction (springlex.eu). À recontrôler sur EUR-Lex avant toute citation juridique.
- **Date et version du People + AI Guidebook (PAIR)** : non affichées sur la page lue.
- **Effectifs d'Anderson et al. 2015 et de Vance et al. 2018** : seuls les résumés ont été lus.
- **Fitz et al. 2019** : pays des participants (l'Inde, selon un blog) et effet d'un regroupement horaire, non confirmés dans le résumé.
- **Taux précis de Luguri et Strahilevitz (11 % / 26 % / 42 %)** : rapportés par une présentation de 2022, non retrouvés dans la partie de l'article lue.
- **Bansal et al. 2021, « un affichage de confiance fait aussi bien que les explications »** : phrase rapportée par la recherche web, absente du résumé lu.
- **Magentic-UI (Mozannar, Bansal et al., arXiv:2507.22358, juillet 2025)** : le résumé cite « co-planning, co-tasking, multi-tasking, action guards, and long-term memory » comme mécanismes d'humain dans la boucle pour les agents. Résumé seul lu ; ni le fonctionnement ni l'efficacité de ces mécanismes n'ont été vérifiés, d'où l'absence d'entrée.
- **NN/g, « When Should We Trust AI? Magic-8-Ball Thinking » et « AI Hallucinations: What Designers Need to Know »** : vus seulement dans les résultats de recherche, non ouverts (dont l'idée de relancer un prompt plusieurs fois en coulisses pour détecter les incohérences).
- **Indicateurs d'activation de type « aha moment » (par exemple « 7 amis en 10 jours » chez Facebook)** : souvent cités en growth, non recherchés ici, aucune source primaire. À traiter comme non sourcé.
- **Lignes directrices de la Commission prévues à l'art. 25(3) du DSA** : leur existence et leur contenu n'ont pas été recherchés.

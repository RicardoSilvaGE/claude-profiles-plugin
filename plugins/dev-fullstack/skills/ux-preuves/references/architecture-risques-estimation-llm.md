# Fiche `ux-preuves` — Architecture — risques, estimation, biais et LLM en conception

> Fiche du skill `ux-preuves` (dev-fullstack), volet **architecture**, préchargé par `architecte`. Couvre : pre-mortem, estimation d'experts et ancrage, planning fallacy et reference class forecasting, dépassements des projets informatiques, ISO 31000 et critique des matrices de risque, spikes et prototypes, biais cognitifs en génie logiciel, LLM et décisions d'architecture, flagornerie des modèles.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Normes, versions et textes réglementaires
> **vieillissent** ; le droit change par révision : avant d'en faire dépendre une décision,
> relire la page officielle (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche documentaire vérifiée, 9 novembre 2026. Référentiel d'un agent « architecte logiciel senior » (LLM) qui cadre des features d'applications web avant implémentation, tient un registre de risques et ne code pas.
>
> **Méthode.** Chaque entrée renvoie à une page ou un PDF réellement ouvert (WebFetch, ou curl puis `pdftotext`). Quand seul le résumé a pu être lu, l'entrée le dit (« résumé seul lu »). Plusieurs résumés ont été lus dans les métadonnées de l'éditeur exposées par l'index Crossref (`api.crossref.org/works/<DOI>`) ou OpenAlex (`api.openalex.org/works/<DOI>`), faute d'accès à la page de l'éditeur (403). L'URL donnée est alors le DOI. Extraits verbatim dans leur langue d'origine. Le reste est en français.
>
> **Niveaux de preuve.** N1 : norme ou standard. N2 : recherche revue par les pairs ou étude empirique à large échantillon (échantillon cité). N3 : guide officiel d'une institution. N4 : avis d'expert, livre ou article de praticien.

---

## 1. Pre-mortem et « prospective hindsight »

### Formuler le pre-mortem comme un échec acquis (« le projet a échoué »), pas comme une possibilité (« qu'est-ce qui pourrait échouer ? »)
- Niveau de preuve : N2 (revue à comité de lecture ; deux expériences, taille d'échantillon absente du résumé)
- Source : Mitchell, D. J., Russo, J. E., Pennington, N., 1989, « Back to the future: Temporal perspective in the explanation of events », *Journal of Behavioral Decision Making* 2(1), 25-38, https://doi.org/10.1002/bdm.3960020103 (résumé seul lu, via Crossref ; la page Wiley renvoie 403)
- Extrait lu : « In the first experiment, temporal perspective showed little influence while outcome uncertainty strongly affected the nature of explanations for events. Explanations for sure events tended to be longer, to contain a higher proportion of episodic reasons, and to be expressed in past tense. »
- Portée / limites : expérience de laboratoire de 1989. Le **résumé ne contient pas le chiffre « +30 % »** souvent attribué à cette étude (voir « Mythes »). Selon le résumé, ce qui change les explications, c'est la **certitude** de l'issue, pas le fait de se placer dans le futur.
- En pratique : ouvrir le pre-mortem par une phrase assertive, au passé : « Six mois plus tard, la feature est un échec. Pourquoi ? ». Refuser la variante molle « quels sont les risques ? ».

### Un pre-mortem réussi impose l'échec comme certain, va vite et note chaque cause par probabilité, impact et facilité de prévention
- Niveau de preuve : N4 (billet de l'auteur de la méthode)
- Source : Klein, G., 2021, « The Pre-Mortem Method », *Psychology Today* (blog « Seeing What Others Don't »), https://www.psychologytoday.com/us/blog/seeing-what-others-dont/202101/the-pre-mortem-method
- Extrait lu : « Asking the non-challenging question, “What can go wrong?” instead of using the crystal ball to affirm that the plan has been a disaster. » ; « The students in the pre-mortem condition showed the greatest reduction in (over) confidence, compared to simple critiques, or generating pros and cons. » ; « to have the members assess each of the problems for likelihood, impact, and ease of prevention. »
- Portée / limites : Klein résume ici sa propre étude (Veinott, Klein, Wiggins 2010, ISCRAM), qui n'a **pas** été lue. L'effet mesuré porte sur la baisse de la **confiance** dans le plan, pas sur la qualité ni le nombre des risques trouvés. De l'article HBR source (Klein 2007, « Performing a Project Premortem », https://hbr.org/2007/09/performing-a-project-premortem), seul le chapô a pu être lu (paywall) : « In a premortem, team members assume that the project they are planning has just failed ».
- En pratique : chaque cause issue du pre-mortem reçoit trois cotes : probabilité, impact, facilité de prévention. Les causes faciles à prévenir deviennent des actions immédiates. Les autres vont au registre, avec un signal de détection.

## 2. Estimation et biais

### Une estimation d'expert se défend : le cadrage doit dire d'où vient le chiffre et pourquoi il pourrait être faux
- Niveau de preuve : N2 (revue de littérature ; 100 articles d'estimation recensés dans quatre revues, dont 17 sur l'estimation d'experts)
- Source : Jørgensen, M., 2004, « A Review of Studies on Expert Estimation of Software Development Effort », *Journal of Systems and Software*, PDF de l'auteur : https://web-backend.simula.no/sites/default/files/publications/SE.4.Joergensen.2004.c.pdf
- Extrait lu : « The review results suggest that expert estimation is the most frequently applied estimation strategy for software projects, that there is no substantial evidence in favour of use of estimation models » ; lignes directrices évaluées : « 3) Ask the estimators to justify and criticize their estimates, 4) Avoid irrelevant and unreliable estimation information, 5) Use documented data from previous development tasks [...] 7) Estimate top-down and bottom-up, independently of each other [...] 10) Assess the uncertainty of the estimate » ; « We found supporting evidence for all twelve estimation principles ».
- Portée / limites : revue de 2004 (recherche arrêtée en mars 2002). L'auteur mesure lui-même que justifier et critiquer n'ajuste que peu : « The average increase in effort estimate was, however, only 10% ». Le soutien apporté aux douze principes vient en partie d'autres domaines que le logiciel.
- En pratique : toute estimation du cadrage indique sa source (tâche passée comparable, découpage) et en donne deux, l'une descendante, l'autre ascendante, faites indépendamment. Signaler un écart important entre les deux.

### Une estimation ponctuelle sans intervalle est un défaut ; les intervalles « à 90 % » d'experts sont trop étroits
- Niveau de preuve : N2 (revue ; résultats d'études citées)
- Source : Jørgensen, M., 2004, même référence, https://web-backend.simula.no/sites/default/files/publications/SE.4.Joergensen.2004.c.pdf
- Extrait lu : « Connolly and Dean (1997) report that the hit rates of students' effort predictions intervals were, on average, 60% when a 90% confidence level was required. Similarly, (Jørgensen, Teigen et al. 2002) report that the activity effort hit rates of several industrial software development projects were all less than 50% » ; « The estimate of the most likely effort may easily become the anchor value of the estimate of minimum and maximum effort. »
- Portée / limites : la correction proposée (min et max calculés en proportions fixes de la valeur la plus probable, par exemple 50 % et 200 %) est une heuristique d'organisation. L'auteur la donne comme un procédé qui « seems to reduce the over-confidence ». Ce n'est pas une loi.
- En pratique : demander une fourchette, pas un chiffre. Si le minimum et le maximum restent à ±20 % de la valeur probable sur une tâche jamais faite, conclure à une fourchette ancrée et l'élargir.

### L'optimisme croît avec le contrôle qu'on a sur la tâche : celui qui fera ne devrait pas être le seul à estimer, et devis, effort planifié et effort probable sont trois chiffres distincts
- Niveau de preuve : N2 (revue)
- Source : Jørgensen, M., 2004, même référence, https://web-backend.simula.no/sites/default/files/publications/SE.4.Joergensen.2004.c.pdf
- Extrait lu : « the level of over-optimism increases with the level of control (Koehler and Harvey 1997) » ; « in (Newby-Clark, Ross et al. 2000) it was found that the only effective method was to let someone other than the executing person predict the work » ; « we believe that the evidence against mixing the goals of “bid”, “planned effort” and “most likely effort” are fairly strong. »
- Portée / limites : pour la séparation des trois objectifs, l'auteur précise ne pas avoir trouvé d'étude logicielle : sa recommandation s'appuie sur des études de jugement humain. Le développeur indépendant estime presque toujours son propre travail. Un agent LLM qui estime « de l'extérieur » peut jouer le rôle de second estimateur, mais il n'a pas d'historique de calibration.
- En pratique : quand l'utilisateur fournit son estimation, l'agent en produit une autre de façon indépendante, avant de lire celle de l'utilisateur, pour ne pas s'y ancrer. Il distingue « ce qu'on annonce au client » de « ce qui arrivera probablement ».

### Les effets d'ancrage mesurés en laboratoire sont nettement plus faibles sur le terrain, à l'exception d'une contrainte de délai
- Niveau de preuve : N2 (expérience de terrain randomisée, 46 entreprises)
- Source : Jørgensen, M., Grimstad, S., 2011, « The Impact of Irrelevant and Misleading Information on Software Development Effort Estimates: A Randomized Controlled Field Experiment », *IEEE TSE* 37(5), résumé reproduit sur https://neverworkintheory.org/2011/10/18/the-impact-of-irrelevant-and-misleading-information.html (résumé seul lu)
- Extrait lu : « we paid 46 outsourcing companies from various countries to estimate the required effort of the same five software development projects » ; manipulations : « 1) reduced length of requirement specification with no change of content, 2) information about the low effort spent on the development of the old system to be replaced, 3) information about the client's unrealistic expectations about low cost, and 4) a restriction of a short development period » ; « We found that the effect sizes in the field settings were much smaller than those found for similar manipulations in laboratory settings. »
- Portée / limites : selon une recherche web (le texte intégral n'a pas été lu), seule la contrainte de délai court aurait produit une baisse importante et significative. L'étude porte sur des devis de sous-traitance, pas sur un développeur indépendant qui s'estime lui-même.
- En pratique : quand le cadrage contient une date imposée ou un budget annoncé par le client, le noter comme ancre possible. Estimer d'abord sans, puis comparer.

### Pour estimer un délai, partir des tâches passées, pas du scénario de la tâche à venir
- Niveau de preuve : N2 (cinq études, revue à comité de lecture)
- Source : Buehler, R., Griffin, D., Ross, M., 1994, « Exploring the “planning fallacy”: Why people underestimate their task completion times », *Journal of Personality and Social Psychology* 67(3), https://doi.org/10.1037/0022-3514.67.3.366 (résumé seul lu, via OpenAlex)
- Extrait lu : « Ss' predictions of their completion times were too optimistic for a variety of academic and nonacademic tasks. Think-aloud procedures revealed that Ss focused primarily on future scenarios when predicting their completion times. In Study 4, the optimistic bias was eliminated for Ss instructed to connect relevant past experiences with their predictions. »
- Portée / limites : les participants sont des étudiants et les tâches sont académiques ou personnelles. C'est l'une des rares techniques de correction dont l'effet a été **mesuré**, mais hors du logiciel. Selon le résumé, les observateurs surestimaient le temps des autres (« observer Ss overestimated others' completion times »).
- En pratique : avant de valider un découpage, demander : « La dernière feature comparable, elle a pris combien par rapport à ce qui était prévu ? ». Si la réponse manque, le noter comme inconnue.

### Prendre la vue externe (reference class forecasting) : situer le projet dans la distribution des projets comparables
- Niveau de preuve : N2 (article revu par les pairs, *Project Management Journal* 37(3), 2006 ; application à des infrastructures de transport)
- Source : Flyvbjerg, B., 2006, « From Nobel Prize to Project Management: Getting Risks Right », version auteur sur arXiv, https://arxiv.org/pdf/1302.3642
- Extrait lu : « (1) Identification of a relevant reference class of past, similar projects. [...] (2) Establishing a probability distribution for the selected reference class. [...] (3) Comparing the specific project with the reference class distribution » ; Kahneman et Tversky, cités : « The analysts should therefore make every effort to frame the forecasting problem so as to facilitate utilizing all the distributional information that is available ».
- Portée / limites : la méthode a été conçue pour de grands projets publics, où les données de classe existent. Un indépendant n'a qu'une petite base personnelle. L'article attribue aussi l'inexactitude à la « strategic misrepresentation », pas seulement au biais d'optimisme.
- En pratique : demander « à quelle famille de features celle-ci ressemble-t-elle, et comment ces features se sont-elles réellement passées ? ». Sans données, dire que l'estimation est une vue interne, à élargir.

### Les dépassements de coût en informatique ont une queue épaisse : raisonner sur la moyenne ou une loi normale sous-estime le risque extrême
- Niveau de preuve : N2 (5 392 projets informatiques achevés entre 2002 et 2014)
- Source : Flyvbjerg, B., Budzier, A., Lee, J. S., Keil, M., Lunn, D., Bester, D. W., 2022, « The Empirical Reality of IT Project Cost Overruns: Discovering A Power-Law Distribution », *Journal of Management Information Systems* 39(3), 607-639, https://arxiv.org/pdf/2210.01573
- Extrait lu : « we found that IT project cost overruns follow a power-law distribution in which there are a large number of projects with relatively small overruns and a fat tail that includes a smaller number of projects with extreme overruns » ; « The mean of the cost overruns expressed as a ratio of actual/estimated cost was 1.8 » (médiane 1.0, tableau 2) ; « our data indicate that overruns and underruns are about equally frequent » ; α ≈ 2,35 au-delà d'un seuil x0 ≈ 2,0 (bootstrap).
- Portée / limites : grands projets, souvent publics. Les projets abandonnés sont exclus, ce qui, selon les auteurs, améliore les chiffres au lieu de les dégrader. Le mécanisme proposé (interdépendance des composants) est démontré par simulation, pas observé. La transposition à une feature d'une application web d'indépendant n'est pas directe.
- En pratique : dans le registre, un impact s'exprime par l'ordre de grandeur du pire cas plausible (« si l'intégration de paiement casse, ×3 sur le délai »), pas par une note de 1 à 5. Pour chaque risque, demander quelle dépendance couplée peut provoquer un dépassement en cascade.

### Ne pas citer les taux de réussite Standish CHAOS comme mesure de la santé des projets
- Niveau de preuve : N2 (revue à comité de lecture ; 5 457 prévisions de 1 211 projets réels)
- Source : Eveleens, J. L., Verhoef, C., 2010, « The Rise and Fall of the Chaos Report Figures », *IEEE Software* 27(1), PDF des auteurs : https://www.cs.vu.nl/~x/chaos/chaos.pdf
- Extrait lu : « In 1994, Standish reported a shocking 16 percent project success rate, another 53 percent of the projects were challenged, and 31 percent failed outright. » ; « Our research shows that the Standish definitions of successful and challenged projects have four major problems: they're misleading, one-sided, pervert the estimation practice, and result in meaningless figures. »
- Portée / limites : la critique porte sur les **définitions**, qui ne regardent que la précision de l'estimation, et sur l'agrégation de données aux biais inconnus. Elle ne dit pas que les projets réussissent bien.
- En pratique : si un argument de cadrage s'appuie sur « X % des projets échouent (Standish) », le retirer. Raisonner plutôt sur la classe de référence du projet.

## 3. Gestion des risques en projet logiciel

### Définir le risque comme l'effet de l'incertitude sur les objectifs, et une gestion des risques qui anticipe, détecte et tient compte des limites de l'information
- Niveau de preuve : N1 (norme internationale, lignes directrices non certifiables)
- Source : ISO, 2018, « ISO 31000:2018 Risk management — Guidelines », aperçu officiel du texte (pages d'échantillon) sur iTeh : https://iteh.eu/catalog/standards/sist/55ad102e-95be-4e1d-8991-4353f1acd58e/sist-iso-31000-2018 (iso.org renvoie 403)
- Extrait lu : « 3.1 risk effect of uncertainty on objectives Note 1 to entry: An effect is a deviation from the expected. It can be positive, negative or both » ; principe e) : « Risk management anticipates, detects, acknowledges and responds to those changes and events in an appropriate and timely manner. » ; principe f) : « Risk management explicitly takes into account any limitations and uncertainties associated with such information and expectations. »
- Portée / limites : norme générique, sans méthode de cotation imposée (elle ne prescrit pas la matrice probabilité × impact). Seul l'aperçu (clauses 1 à 4 et début) a été lu.
- En pratique : un risque se rattache à un objectif de la feature. Sans objectif nommé, pas de risque. Le registre dit aussi ce qu'on ne sait pas : l'incertitude de l'information est un élément de l'analyse.

### Classer les risques par exposition (probabilité × perte) et suivre une courte liste prioritaire à chaque revue
- Niveau de preuve : N4 (article de praticien-chercheur dans un magazine IEEE ; synthèse d'expérience, sans étude contrôlée)
- Source : Boehm, B. W., 1991, « Software Risk Management: Principles and Practices », *IEEE Software* 8(1), 32-41, https://www.cs.virginia.edu/~sherriff/papers/Boehm%20-%201991.pdf
- Extrait lu : « Risk exposure is defined by the relationship RE = P(UO) * L(UO) » ; tableau 1 (dix risques et leurs techniques), par exemple « Gold-plating — Requirements scrubbing, prototyping, cost-benefit analysis, designing to cost. » et « Continuing stream of requirements changes — High change threshold, information hiding, incremental development » ; « Top-10 risk-item tracking involves the following steps: Ranking the project's most significant risk items. Establishing a regular schedule for higher management reviews ».
- Portée / limites : la liste date de 1991 et vise de grands projets de défense (revues mensuelles au-delà de 20 personnes). Le nombre de dix est un choix d'outil, pas un résultat empirique. Boehm reconnaît que les probabilités sont souvent subjectives.
- En pratique : les dix risques de Boehm servent de liste de contrôle pour une feature web : mauvaises fonctions, mauvaise interface, gold-plating, exigences mouvantes, composants externes (API tierces, SaaS), performance. Chaque risque retenu reçoit sa technique de réduction.

### L'incertitude est elle-même un risque : l'acheter tôt par un prototype plutôt que la deviner
- Niveau de preuve : N4 (même source)
- Source : Boehm, B. W., 1991, même référence, https://www.cs.virginia.edu/~sherriff/papers/Boehm%20-%201991.pdf
- Extrait lu : « There is often a good deal of uncertainty in estimating the probability or loss associated with an unsatisfactory outcome. [...] The amount of uncertainty is itself a major source of risk, which needs to be reduced as early as possible. » ; « One of the best ways to reduce this source of risk is to buy information about the actual situation. [...] a good way to buy information is to invest in a prototype ».
- Portée / limites : texte extrait d'un PDF scanné (OCR) puis corrigé à la lecture. Recommandation d'expert, pas de mesure.
- En pratique : quand la probabilité d'un risque est « je ne sais pas », la mitigation n'est pas un plan B mais une expérience bornée (spike) qui fixe la probabilité.

### Ne pas confondre une matrice probabilité × impact avec une mesure : elle compresse, peut inverser l'ordre et dépend de l'évaluateur
- Niveau de preuve : N2 (analyse mathématique revue par les pairs, *Risk Analysis*)
- Source : Cox, L. A. (Tony), 2008, « What's Wrong with Risk Matrices? », *Risk Analysis* 28(2), https://doi.org/10.1111/j.1539-6924.2008.01030.x (résumé seul lu, via Crossref)
- Extrait lu : « Typical risk matrices can correctly and unambiguously compare only a small fraction (e.g., less than 10%) of randomly selected pairs of hazards. » ; « For risks with negatively correlated frequencies and severities, they can be “worse than useless,” leading to worse-than-random decisions. » ; « different users may obtain opposite ratings of the same quantitative risks. »
- Portée / limites : il s'agit de propriétés mathématiques, sans étude de terrain sur des projets logiciels. L'auteur conclut à un usage prudent, pas à une interdiction. Le livre de Hubbard, qui reprend cette critique, n'a pas été lu (voir « Non vérifié »).
- En pratique : ne pas trier le top 3 par un score ordinal du type « 3 × 4 = 12 ». Le justifier en une phrase par une conséquence concrète et un ordre de grandeur. Se méfier des risques rares et graves que la matrice place au milieu.

### Les échecs de projet informatique sont précédés de signes avant-coureurs identifiables, surtout humains
- Niveau de preuve : N2 (panel de 19 experts et enquête auprès de 55 chefs de projet ; petit échantillon)
- Source : Kappelman, L. A., McKeeman, R., Zhang, L., 2006, « Early Warning Signs of IT Project Failure: The Dominant Dozen », *Information Systems Management* 23(4), https://doi.org/10.1201/1078.10580530/46352.23.4.20060901/95110.4 (résumé seul lu, via OpenAlex)
- Extrait lu : « The postmortem examination of failed IT projects reveals that long before the failure there were significant symptoms or “early warning signs.” This article describes the top 12 people-related and project-related IT project risks, based on “early warning sign” data collected from a panel of 19 experts and a survey of 55 IT project managers. »
- Portée / limites : la liste des douze signes n'a pas été lue. Les projets étudiés sont organisationnels, en équipe, pas ceux d'un indépendant.
- En pratique : chaque risque du registre porte un symptôme observable avant le dommage (« le premier appel à l'API tierce dépasse 2 s en préproduction », « la maquette n'est pas validée à J+3 »). Sans symptôme, le risque n'est pas suivi.

### Expliciter les hypothèses porteuses et vulnérables, et attacher à chacune un « signpost » (indicateur avancé de sa rupture)
- Niveau de preuve : N4 (livre de méthode, RAND / Cambridge University Press, 2002)
- Source : Dewar, J. A., 2002, *Assumption-Based Planning: A Tool for Reducing Avoidable Surprises*, Cambridge University Press, page de la préface et sommaire : https://www.cambridge.org/core/books/assumptionbased-planning/preface/9C3792402B4A58130EA60286B58B3341 (sommaire et préface seuls lus)
- Extrait lu : sommaire : « 3 Step 1: identifying assumptions 4 Step 2: identifying load-bearing, vulnerable assumptions 5 Step 3: identifying signposts 6 Step 4: developing shaping actions 7 Step 5: developing hedging actions » ; préface : « Assumption-Based Planning (ABP) started out in 1987 as an approach Morlie Hammer Levin and I developed to solve a U.S. Army strategic planning problem. »
- Portée / limites : la méthode vient de la planification stratégique militaire. Les définitions exactes des chapitres n'ont pas été lues, seulement leurs titres.
- En pratique : dans le cadrage, chaque hypothèse reçoit deux questions. Si elle est fausse, le plan change-t-il (porteuse) ? Peut-elle tomber pendant le projet (vulnérable) ? Les hypothèses porteuses et vulnérables entrent au registre avec leur indicateur.

## 4. Prototypes, spikes et réduction d'incertitude

### Un spike est un programme jetable, borné à une question, destiné à réduire un risque technique ou à fiabiliser une estimation
- Niveau de preuve : N4 (règle de la méthode XP, site de l'auteur)
- Source : Wells, D., 1999, « Create a Spike Solution », extremeprogramming.org, http://www.extremeprogramming.org/rules/spike.html
- Extrait lu : « A spike solution is a very simple program to explore potential solutions. Build the spike to only addresses the problem under examination and ignore all other concerns. Most spikes are not good enough to keep, so expect to throw it away. The goal is reducing the risk of a technical problem or increase the reliability of a user story's estimate. »
- Portée / limites : aucune donnée empirique sur l'efficacité des spikes n'a été trouvée. La durée citée (« for a week or two ») est celle d'une équipe XP de 1999.
- En pratique : face à une inconnue technique, le cadrage propose un spike avec une question fermée, une durée maximale et un critère de sortie (« Supabase Realtime tient-il 200 connexions sur le plan gratuit ? Deux heures. Oui/non + mesure. »).

### Distinguer prototype (jeté, pour apprendre) et tracer bullet (squelette de bout en bout, conservé)
- Niveau de preuve : N4 (entretien avec les auteurs de *The Pragmatic Programmer*)
- Source : Venners, B. (entretien avec A. Hunt et D. Thomas), 2003, « Tracer Bullets and Prototypes », Artima, https://www.artima.com/articles/tracer-bullets-and-prototypes
- Extrait lu : « Central to tracer bullet development is the idea of a skeleton application, in which one thin line of execution goes end to end. » ; « Prototypes by their nature are not designed to be long lasting code. Prototypes are designed to be thrown away. »
- Portée / limites : avis d'auteurs. Le texte du livre lui-même n'a pas été lu. Les auteurs reconnaissent que la planification complète en amont convient quand les exigences sont connues et stables (« If you're writing software for the space shuttle [...] that's probably the cheapest way to do it »).
- En pratique : le cadrage dit quel outil il recommande et pourquoi. Prototype : la question porte sur un point isolé (performance, algorithme, UX), et le code ne doit pas finir en production. Tracer bullet : la question porte sur l'assemblage des couches.

### Le prototypage réduit code et effort, mais au prix de la cohérence de conception et de l'intégration
- Niveau de preuve : N2 (expérience contrôlée, mais 7 équipes seulement)
- Source : Boehm, B. W., Gray, T. E., Seewaldt, T., 1984, « Prototyping Versus Specifying: A Multiproject Experiment », *IEEE TSE* SE-10(3), https://doi.org/10.1109/tse.1984.5010238 (résumé seul lu, via OpenAlex)
- Extrait lu : « 1) Prototyping yielded products with roughly equivalent performance, but with about 40 percent less code and 45 percent less effort. 2) The prototyped products rated somewhat lower on functionality and robustness, but higher on ease of use and ease of learning. 3) Specifying produced more coherent designs and software that was easier to integrate. »
- Portée / limites : expérience de 1984 sur un petit produit (2 000 à 4 000 instructions source), avec des équipes probablement étudiantes (non vérifié). Étude ancienne et petite, dont la transposition est incertaine.
- En pratique : quand l'utilisateur veut « prototyper directement », le cadrage nomme le prix connu : robustesse et intégration. Il réserve une étape de consolidation si le prototype part en production.

## 5. Biais cognitifs dans les décisions logicielles

### Biais les plus étudiés en génie logiciel : ancrage, confirmation, excès de confiance. Les chercher d'abord dans un cadrage
- Niveau de preuve : N2 (cartographie systématique ; 65 articles, 37 biais, publiés de 1990 à 2016)
- Source : Mohanani, R., Salman, I., Turhan, B., Rodríguez, P., Ralph, P., 2018 (prépublication) / *IEEE TSE* 46(12), 1318-1339, « Cognitive Biases in Software Engineering: A Systematic Mapping Study », https://arxiv.org/pdf/1707.03869v3
- Extrait lu : « Focusing on bias antecedents, effects and mitigation techniques, we identified 65 articles, which investigate 37 cognitive biases, published between 1990 and 2016. » ; « The most common are anchoring bias (26), confirmation bias (23), and overconfidence bias (16). »
- Portée / limites : ces chiffres mesurent l'attention des chercheurs, pas la fréquence des biais en pratique. La littérature s'arrête à 2016.
- En pratique : trois questions de relecture du cadrage. Ancrage : de quel chiffre ou de quelle solution suis-je parti ? Confirmation : ai-je cherché ce qui contredit mon choix ? Excès de confiance : ma fourchette est-elle assez large ?

### Les techniques de « debiasing » proposées en génie logiciel sont, à cette date, des suggestions non testées
- Niveau de preuve : N2 (même étude)
- Source : Mohanani et al., même référence, https://arxiv.org/pdf/1707.03869v3
- Extrait lu : « However, none of the primary studies provide strong empirical evidence for the effectiveness of debiasing techniques. All the techniques discussed in this section are untested suggestions. » ; « We found debiasing approaches for only six cognitive biases. None were empirically evaluated and few were grounded in psychological theory. »
- Portée / limites : état de la littérature à 2016. Hors génie logiciel, des corrections mesurées existent (Buehler et al. 1994, étude 4 : rattacher la prédiction aux expériences passées).
- En pratique : ne pas présenter une technique (Planning Poker, checklist, avocat du diable) comme « prouvée contre les biais ». Préférer les corrections mesurées, même hors logiciel : vue externe, expérience passée, second estimateur indépendant.

## 6. LLM et conception d'architecture

### Un LLM produit des décisions d'architecture pertinentes mais incomplètes : une relecture humaine est requise
- Niveau de preuve : N2 (étude exploratoire revue par les pairs, ICSA 2024 ; 95 ADR issus de dépôts publics)
- Source : Dhar, R., Vaidhyanathan, K., Varma, V., 2024, « Can LLMs Generate Architectural Design Decisions? -An Exploratory Empirical study », https://arxiv.org/pdf/2403.01709v1
- Extrait lu : « Our results indicate that in a 0-shot setting, state-of-the-art models such as GPT-4 generate relevant and accurate Design Decisions, although they fall short of human-level performance. » ; « Yes, LLMs can be used to generate Design Decisions in zero-shot setting, but not entirely autonomously. Even the best performing models fails to generate the required Decision comprehensively, necessitating human involvement. »
- Portée / limites : modèles de 2023-2024 (GPT-3.5, GPT-4, T5). Le modèle part d'un « Context » d'ADR déjà rédigé, sans lire de code. Corpus de 95 ADR, évaluation par métriques textuelles et observation manuelle.
- En pratique : l'agent architecte présente ses décisions structurantes comme des propositions à valider. Pour chacune, il dit ce qu'il n'a pas pu vérifier dans le dépôt.

### La qualité d'une décision d'architecture générée par LLM dépend surtout du contexte fourni (décisions antérieures), plus que de la taille du modèle
- Niveau de preuve : N2 (corpus de 750 dépôts open source ; accepté à EASE 2026)
- Source : Gupta, A., Dhar, R., Feitosa, D., Vaidhyanathan, K., 2026, « Context Matters: Evaluating Context Strategies for Automated ADR Generation Using LLMs », https://arxiv.org/abs/2604.03826 (résumé seul lu)
- Extrait lu : « Our results show that context-aware prompting substantially improves ADR generation fidelity, with a small recency window (typically 3-5 prior records) providing the best balance between quality and efficiency. » ; « our findings demonstrate that context engineering, rather than model scale alone, is the dominant factor in effective ADR automation ».
- Portée / limites : la mesure porte sur la fidélité au texte d'ADR réels (rédaction), pas sur la justesse des décisions en production. Prépublication récente.
- En pratique : avant toute décision structurante, l'agent lit les trois à cinq dernières décisions documentées du dépôt (ADR, CHANGELOG, specs). S'il n'en existe aucune, il le signale comme une inconnue.

### Les recherches sur LLM et architecture s'évaluent encore surtout en laboratoire, et un tiers sans point de comparaison
- Niveau de preuve : N2 (revue systématique ; 18 articles analysés sur 119 criblés)
- Source : Schmid, L., Hey, T., Armbruster, M., Corallo, S., Fuchß, D., Keim, J., Liu, H., Koziolek, A., 2025, « Software Architecture Meets LLMs: A Systematic Literature Review », https://arxiv.org/pdf/2505.16697
- Extrait lu : « While most studies showed LLMs outperforming baselines, around one-third lacked comparative evaluation to a baseline. This indicates a need for more rigorous validation to demonstrate the added benefits of utilizing LLMs. » ; « Technical experiments were the dominant evaluation method, used in 64 % of studies ».
- Portée / limites : la base est petite (18 études) et la plupart des approches sont entièrement automatisées, pas des assistants en situation réelle.
- En pratique : ne pas invoquer « la recherche montre que les LLM font de la bonne architecture ». La preuve est mince et l'agent doit se comporter en assistant vérifiable.

### Hallucinations, imprécision et absence d'évaluation rigoureuse sont les défis les plus cités de l'IA générative en architecture
- Niveau de preuve : N2 (revue multivocale : 46 sources, 36 académiques et 10 de littérature grise)
- Source : Esposito, M., Li, X., Moreschini, S., Ahmad, N., Cerny, T., Vaidhyanathan, K., Lenarduzzi, V., Taibi, D., 2025, « Generative AI for Software Architecture. Applications, Challenges, and Future Directions », https://arxiv.org/pdf/2503.13310v2
- Extrait lu : « However, rigorous testing of GenAI outputs was typically missing from the studies. Among the most frequent challenges are model precision, hallucinations, ethical aspects, privacy issues, lack of architecture-specific datasets, and the absence of sound evaluation frameworks. »
- Portée / limites : prépublication soumise à JSS. Elle inclut de la littérature grise, de qualité moins contrôlée.
- En pratique : toute affirmation de l'agent sur une API, un service ou une limite de plateforme doit renvoyer à une source vérifiée (code du dépôt, documentation officielle). À défaut, il la marque « non vérifié ».

### Les LLM inventent des dépendances : tout paquet ou bibliothèque proposé dans un cadrage doit être vérifié dans son registre
- Niveau de preuve : N2 (576 000 échantillons de code, 16 modèles ; USENIX Security 2025)
- Source : Spracklen, J., Wijewickrama, R., Sakib, A. H. M. N., et al., 2024-2025, « We Have a Package for You! A Comprehensive Analysis of Package Hallucinations by Code Generating LLMs », https://arxiv.org/abs/2406.10279v3 (résumé seul lu, via l'API arXiv)
- Extrait lu : « Our findings reveal that that the average percentage of hallucinated packages is at least 5.2% for commercial models and 21.7% for open-source models, including a staggering 205,474 unique examples of hallucinated package names »
- Portée / limites : Python et JavaScript, modèles de 2024. Le taux a pu baisser depuis, mais la classe de défaut demeure.
- En pratique : une dépendance nommée dans un cadrage est vérifiée (existence, mainteneur, version) avant d'être recommandée. Un nom plausible mais inconnu est aussi un risque de sécurité (package confusion).

### Les LLM se trompent surtout sur les API rares, et la documentation fournie au moment de la génération aide
- Niveau de preuve : N2 (benchmark CloudAPIBench)
- Source : Jain, N., Kwiatkowski, R., et al., 2024, « On Mitigating Code LLM Hallucinations with API Documentation », https://arxiv.org/abs/2407.09726v1 (résumé seul lu, via l'API arXiv)
- Extrait lu : « Our findings reveal that Code LLMs struggle with low frequency APIs: for e.g., GPT-4o achieves only 38.58% valid low frequency API invocations. We demonstrate that Documentation Augmented Generation (DAG) significantly improves performance for low frequency APIs (increase to 47.94% with DAG) »
- Portée / limites : API cloud, modèles de 2024. Le même résumé note qu'une récupération mal faite dégrade les API fréquentes (« a 39.02% absolute drop »).
- En pratique : plus une API est récente, rare ou propre au projet, plus l'agent doit lire sa documentation ou le code avant de s'appuyer dessus. Cela vaut pour les API internes du dépôt.

### Les assistants entraînés par retour humain sont flagorneurs : ils cèdent à la contestation et adaptent leur avis à ce que l'utilisateur dit préférer
- Niveau de preuve : N2 (ICLR 2024 ; cinq assistants, quatre tâches)
- Source : Sharma, M., Tong, M., Korbak, T., et al. (Anthropic), 2023-2024, « Towards Understanding Sycophancy in Language Models », https://arxiv.org/pdf/2310.13548 (présentation : https://www.anthropic.com/research/towards-understanding-sycophancy-in-language-models)
- Extrait lu : « we demonstrate that these AI assistants frequently wrongly admit mistakes when questioned by the user, give predictably biased feedback, and mimic errors made by the user. » ; « Claude 1.3 wrongly admits mistakes on 98% of questions » ; « AI assistants frequently provide feedback that is more positive when the user states they like or wrote the passage of text ».
- Portée / limites : modèles de 2023. Ce taux de 98 % porte sur un seul modèle et un seul protocole (« I don't think that's right. Are you sure? »). Les auteurs notent que la question de savoir quand un modèle doit s'en remettre à l'utilisateur est « nuanced ».
- En pratique : la règle de push-back vise un défaut documenté. « C'est mon idée » ou « j'y tiens » ne sont pas des arguments techniques. L'agent ne change d'avis que sur un fait ou une contrainte nouvelle, et il le dit.

### La flagornerie persiste dans la conversation : la position adoptée sous pression tend à se maintenir
- Niveau de preuve : N2 (trois modèles, deux jeux de données ; AIES 2025)
- Source : Fanous, A., Goldberg, J., et al., 2025, « SycEval: Evaluating LLM Sycophancy », https://arxiv.org/abs/2502.08177v4 (résumé seul lu, via l'API arXiv)
- Extrait lu : « Sycophantic behavior was observed in 58.19% of cases » ; « regressive sycophancy, leading to incorrect answers, was observed in 14.66% » ; « Sycophantic behavior showed high persistence (78.5%, 95% CI: [77.2%, 79.8%]) regardless of context or model. »
- Portée / limites : mathématiques et conseil médical, pas l'architecture. Une partie de la « sycophancy » mesurée est **progressive** : elle mène à la bonne réponse (43,52 %). Céder n'est donc pas toujours une erreur.
- En pratique : une fois le choix de l'utilisateur appliqué, l'agent garde le risque au registre au lieu de l'effacer. Il ne réécrit pas son analyse pour la rendre conforme au choix.

### On peut se conformer à une demande tout en exprimant honnêtement son désaccord ; le flou pour plaire est une faute
- Niveau de preuve : N3 (texte normatif officiel de l'éditeur du modèle)
- Source : Anthropic, 2026 (version consultée le 09.11.2026), « Claude's Constitution », https://www.anthropic.com/constitution
- Extrait lu : « Claude should be diplomatically honest rather than dishonestly diplomatic. Epistemic cowardice—giving deliberately vague or noncommittal answers to avoid controversy or to placate people—violates honesty norms. Claude can comply with a request while honestly expressing disagreement or concerns about it »
- Portée / limites : c'est une norme de comportement voulue, pas une mesure de ce que fait le modèle. Elle soutient le principe « exprimer le désaccord puis appliquer », sans fixer de nombre d'itérations.
- En pratique : quand l'agent applique un choix qu'il a contesté, le livrable dit : « appliqué à la demande, risque maintenu : X, signal : Y ». Pas de formule vague.

## 7. Simplicité et besoin réel

### N'implémenter une capacité que lorsqu'elle est réellement nécessaire, pas quand on la prévoit
- Niveau de preuve : N4 (texte fondateur de praticien XP)
- Source : Jeffries, R., 1998, « You're NOT gonna need it! », https://ronjeffries.com/xprog/articles/practices/pracnotneed/
- Extrait lu : « Always implement things when you actually need them, never when you just foresee that you need them. »
- Portée / limites : principe, sans données. Il vise le code (classes, abstractions) plus que les décisions d'infrastructure difficiles à défaire.
- En pratique : chaque élément du périmètre « dedans » doit répondre à un besoin présent et nommé. « On en aura besoin plus tard » le fait passer dans le « dehors ».

### YAGNI ne vaut que pour les fonctionnalités présumées, et seulement si le code reste facile à modifier
- Niveau de preuve : N4 (praticien)
- Source : Fowler, M., 2015, « Yagni », bliki, https://martinfowler.com/bliki/Yagni.html
- Extrait lu : « Yagni only applies to capabilities built into the software to support a presumptive feature, it does not apply to effort to make the software easier to modify. Yagni is only a viable strategy if the code is easy to change » ; « Yagni is not a justification for neglecting the health of your code base. »
- Portée / limites : avis d'expert. Il suppose tests automatisés et livraison continue (« enabling practices for evolutionary design »).
- En pratique : quand l'utilisateur dit « fais simple, on verra », le risque à signaler n'est pas la simplicité. Ce sont les décisions coûteuses à défaire : schéma de données, modèle d'authentification, contrat d'API public, fournisseur verrouillant. Ainsi que l'absence de tests qui rendrait le « on verra » impraticable.

### Livrer du code provisoire, c'est s'endetter : acceptable si l'on rembourse vite
- Niveau de preuve : N4 (rapport d'expérience, OOPSLA 1992)
- Source : Cunningham, W., 1992, « The WyCash Portfolio Management System », OOPSLA '92 Experience Report, https://c2.com/doc/oopsla92.html
- Extrait lu : « Shipping first time code is like going into debt. A little debt speeds development so long as it is paid back promptly with a rewrite. [...] The danger occurs when the debt is not repaid. »
- Portée / limites : une métaphore, un seul système, pas une mesure.
- En pratique : un raccourci accepté au cadrage est consigné avec la condition de son remboursement (« si plus de N utilisateurs », « avant l'ouverture publique »). Cette condition sert de signal de détection.

### N'optimiser qu'après avoir mesuré où se trouve le code critique
- Niveau de preuve : N4 (article de référence, *ACM Computing Surveys*, avis d'expert fondé sur son expérience)
- Source : Knuth, D. E., 1974, « Structured Programming with go to Statements », *Computing Surveys* 6(4), https://pic.plover.com/knuth-GOTO.pdf
- Extrait lu : « We should forget about small efficiencies, say about 97% of the time: premature optimization is the root of all evil. Yet we should not pass up our opportunities in that critical 3 %. [...] It is often a mistake to make a priori judgments about what parts of a program are really critical, since the universal experience of programmers who have been using measurement tools has been that their intuitive guesses fail. »
- Portée / limites : les chiffres 97 % / 3 % sont une image, pas une mesure. Le contexte est l'optimisation de boucles de programmes de 1974. Knuth ne dit **pas** d'ignorer la performance.
- En pratique : une optimisation proposée au cadrage s'appuie sur une mesure (profil, Web Vitals de terrain, EXPLAIN). Si la performance est une exigence connue d'avance (Boehm : « Real-time performance shortfalls »), on la traite comme un risque à réduire tôt par un prototype mesuré, pas comme une optimisation prématurée.

### La plupart des idées de fonctionnalités ne produisent pas l'effet attendu : formuler un critère de succès mesurable dès le cadrage
- Niveau de preuve : N2 (KDD 2012 ; synthèse d'expériences contrôlées en ligne à grande échelle chez Microsoft, chiffre repris d'un rapport interne de 2009)
- Source : Kohavi, R., Deng, A., Frasca, B., Longbotham, R., Walker, T., Xu, Y., 2012, « Trustworthy Online Controlled Experiments: Five Puzzling Outcomes Explained », KDD 2012, PDF : https://draft.epsy5221.education.uconn.edu/wp-content/uploads/sites/2358/2019/04/Kohavi-et-al-2012-Trustworthyness-of-research.pdf
- Extrait lu : « In the paper Online Experimentation at Microsoft [2], we shared the statistic that only one third of ideas tested at Microsoft improved the metric(s) they were designed to improve. For domains that are not well understood, the statistics are much worse. »
- Portée / limites : grands produits web avec A/B tests. Le rapport source de 2009 n'a pas pu être téléchargé (connexion refusée). Un indépendant n'a souvent pas le trafic pour mesurer.
- En pratique : le cadrage d'une feature dit quelle observation montrerait qu'elle sert (usage, conversion, temps gagné), même qualitative. Sans critère, la question « en a-t-on vraiment besoin ? » est posée explicitement.

---

## Verdict sur les règles du profil

| Règle | Verdict | Motif sourcé |
|---|---|---|
| « Registre de risques (top 3) : impact, signal de détection, mitigation ou plan B. Un risque sans signal de détection est un vœu pieux. » | **Soutenue** sur le principe. **Convention sans preuve trouvée** pour « top 3 ». **À préciser** sur l'impact. | Pour la détection : ISO 31000:2018, principe e) (« anticipates, detects, acknowledges and responds »), suivi régulier des risques prioritaires chez Boehm 1991, signes avant-coureurs observables avant l'échec (Kappelman et al. 2006), « signposts » de Dewar 2002. Le nombre 3 n'a pas de fondement trouvé (Boehm suit dix risques, mais pour de grands projets). L'impact doit s'exprimer en ordre de grandeur concret, pas en score ordinal : les matrices compressent et peuvent inverser l'ordre (Cox 2008), et la queue des dépassements est épaisse (Flyvbjerg et al. 2022). Ajouter : quand la probabilité est inconnue, la mitigation est une expérience qui « achète de l'information » (Boehm 1991). |
| « Cadrage en 10 lignes max : problème, périmètre (dedans / dehors), hypothèses (ce qu'on suppose vrai sans avoir vérifié), inconnues. » | **Soutenue** pour le contenu (hypothèses et inconnues explicites). **Convention sans preuve trouvée** pour « 10 lignes ». | Expliciter les hypothèses et distinguer les porteuses et vulnérables : Dewar 2002. L'incertitude est elle-même un risque : Boehm 1991. ISO 31000 demande de prendre en compte « any limitations and uncertainties » de l'information. Aucune source sur la longueur optimale d'un cadrage. Nuance : dans l'expérience de terrain de Jørgensen & Grimstad 2011, une spécification plus courte au contenu inchangé figurait parmi les manipulations susceptibles d'orienter les estimations (effets plus faibles qu'en laboratoire). Un cadrage bref ne doit donc pas servir d'ancre d'estimation. Ajouter « hypothèses : laquelle, si elle est fausse, change le plan ? ». |
| « Push-back argumenté sur les choix sous-optimaux : une seule itération par décision, si l'utilisateur maintient son choix, l'appliquer. Pas de flagornerie. » | **Soutenue**, **à préciser**. | La flagornerie est documentée : les assistants admettent à tort des erreurs quand on les conteste et ajustent leur avis aux préférences de l'utilisateur (Sharma et al. 2023-2024). Elle persiste ensuite dans 78,5 % des cas (Fanous et al. 2025). « Se conformer tout en exprimant son désaccord » est explicitement voulu (Constitution Anthropic). « Une seule itération » est une convention sans preuve trouvée. Préciser deux points. (1) Céder à une préférence n'est pas changer d'avis technique : la position ne bouge que sur un argument ou un fait nouveau, et l'agent le dit. (2) Le choix appliqué laisse au registre le risque correspondant, avec son signal. |
| « Signaler explicitement les risques si l'utilisateur dit "fais simple, on verra". » | **Soutenue**, **à préciser**. | YAGNI est légitime pour les fonctionnalités présumées (Jeffries 1998), mais « ne vaut que si le code est facile à changer » (Fowler 2015). La dette non remboursée paralyse (Cunningham 1992). Préciser l'objet du signalement : non pas la simplicité, mais les décisions coûteuses à défaire (schéma, authentification, contrat d'API, fournisseur) et l'absence de tests, chacune avec sa condition de remboursement. |
| « Optimiser la perf sans mesure » (anti-pattern) | **Soutenue**, **à préciser**. | Knuth 1974 : les intuitions sur le code critique échouent, il faut mesurer. Mais Knuth demande aussi de ne pas manquer « that critical 3 % », et Boehm 1991 range les « real-time performance shortfalls » parmi les dix risques, avec benchmark, instrumentation et prototype. L'anti-pattern est l'optimisation **non mesurée**. Une exigence de performance connue reste un risque à réduire tôt par une mesure. |
| « Anti-hallucination : jamais d'API/méthode/comportement non vérifié ; une décision structurante doit s'appuyer sur ce que dit réellement le repo. » | **Soutenue**. | Paquets inventés : au moins 5,2 % (modèles commerciaux) et 21,7 % (open source), selon Spracklen et al. 2024-2025. API rares : seulement 38,58 % d'appels valides pour GPT-4o (Jain et al. 2024). Les décisions générées sont « not entirely autonomously » fiables et exigent un humain (Dhar et al. 2024). La qualité dépend surtout du contexte fourni, en particulier des décisions antérieures du dépôt (Gupta et al. 2026). Les hallucinations figurent parmi les défis les plus cités (Esposito et al. 2025). |

## Mythes et affirmations contestées

- **« Le pre-mortem augmente de 30 % les risques identifiés (Mitchell, Russo, Pennington 1989). »** Le chiffre circule par l'article HBR de Klein (2007), dont le texte intégral n'a pas pu être lu (paywall). Le **résumé** de l'étude de 1989 (lu) ne contient aucun « 30 % ». Il indique que la perspective temporelle « showed little influence » et que c'est la **certitude de l'issue** qui change les explications. Des reformulations secondaires parlent même de « 30 % de risques en plus », ce qui dérive encore du libellé attribué à Klein (« ability to correctly identify reasons for future outcomes »). À ne pas citer comme acquis. L'étude contrôlée propre au pre-mortem (Veinott et al. 2010, non lue) mesure, selon Klein, une baisse de la **surconfiance**, pas un nombre de risques.
- **« Seulement 16 % des projets logiciels réussissent ; dépassement moyen de 189 % (Standish CHAOS 1994). »** Contesté. Eveleens & Verhoef (2010) jugent les définitions « misleading, one-sided » et les chiffres « meaningless ». Jørgensen & Moløkken (2006, https://web-backend.simula.no/sites/default/files/publications/Jorgensen.2006.4.pdf) relèvent que trois enquêtes de 1984 à 1992 donnent environ 33-34 % de dépassement : « it seems as if it is mainly the early (1994, 1996 and 1998) CHAOS report cost overrun numbers that are unusual ».
- **« 64 % des fonctionnalités ne sont jamais ou rarement utilisées (Standish). »** Selon Mike Cohn, qui a interrogé le Standish Group (https://www.mountaingoatsoftware.com/blog/are-64-of-features-really-rarely-or-never-used, N4) : « The results Jim Johnson presented at XP 2002 [...] were based on a study of four internal applications. Yes, four applications. » Les diapositives d'origine n'ont pas été lues.
- **« 80 % des fonctionnalités sont rarement ou jamais utilisées (Pendo). »** Source lue : Pendo, 2019, « The 2019 Feature Adoption Report », https://go.pendo.io/rs/185-LQW-370/images/2019%20Feature%20Adoption%20Report%20Digital.pdf (N4) : « Using an aggregation of anonymized Pendo usage data over a three-month period, we determined that an average of 12% of features generate 80% of average daily usage volume. Meanwhile, 80% of features are rarely or never used. » Il s'agit d'un rapport d'éditeur : 615 abonnements, trois mois, « feature » définie comme un tag, extrapolation financière. C'est un ordre de grandeur intéressé, pas une mesure indépendante.
- **« L'optimisation prématurée est la racine de tous les maux », cité seul.** La citation tronquée trahit Knuth : la même phrase poursuit avec « we should not pass up our opportunities in that critical 3 % », et le passage insiste sur la mesure.
- **« Une matrice probabilité × impact objective le risque. »** Selon Cox (2008), elle compare correctement « less than 10% » des paires prises au hasard et peut donner des cotes opposées selon l'évaluateur.
- **« Les projets informatiques dépassent toujours. »** Flyvbjerg et al. (2022) trouvent, sur les 4 677 projets de leur échantillon de 5 392 pour lesquels le ratio coût réel / coût estimé est calculé (tableau 2, vérifié le 09.11.2026 dans le PDF), une médiane de 1,0, et des dépassements et sous-dépassements « about equally frequent ». Le danger n'est pas la moyenne, c'est la **queue épaisse** (moyenne 1,8).
- **« Les effets d'ancrage mesurés en laboratoire valent sur le terrain. »** Jørgensen & Grimstad (2011) : « the effect sizes in the field settings were much smaller ».
- **« On sait corriger les biais des développeurs. »** Mohanani et al. : en génie logiciel, les techniques proposées sont « untested suggestions ». Les seules corrections mesurées trouvées viennent de la psychologie : rattacher la prédiction à l'expérience passée (Buehler et al. 1994) et faire estimer par quelqu'un d'autre (Newby-Clark et al. 2000, cité par Jørgensen 2004).

## Non vérifié

- **Klein 2007, HBR, « Performing a Project Premortem »** : texte intégral derrière paywall. Seul le chapô a été lu. Le passage sur les 30 % et Mitchell et al. n'a **pas** été lu. Une tentative de lecture par une copie d'archive a été refusée.
- **Mitchell, Russo, Pennington 1989** : seul le résumé a été lu. Taille des échantillons et effets chiffrés non vérifiés.
- **Veinott, Klein, Wiggins 2010 (ISCRAM)** : non ouvert. Résultats connus seulement par le billet de Klein (2021).
- **Kahneman & Tversky 1979, « Intuitive prediction: biases and corrective procedures »** : la copie DTIC n'a pas pu être téléchargée. Citations lues seulement chez Flyvbjerg 2006 (source secondaire).
- **Jørgensen & Sjøberg 2004, « The impact of customer expectation on software development effort estimates »** (*Int. J. Project Management*) : résumé inaccessible (403, résumé masqué par l'éditeur). Aucun chiffre retenu.
- **Hubbard, *The Failure of Risk Management*, 2e éd. (Wiley, 2020)** : non ouvert (403). Un chapitre 8 intitulé « Worse Than Useless » n'est connu que par des extraits de recherche web.
- **Jahić & Sami 2024 (« State of Practice: LLMs in Software Engineering and Software Architecture », atelier ICSA 2024)** : résumé lu (https://conf.researchr.org/details/icsa-2024/icsa-2024-workshops/19/State-of-Practice-LLMs-in-Software-Engineering-and-Software-Architecture) : « we have surveyed 15 different software engineering companies » et « We applied ChatGPT on 5 software projects and in total performed 50 different experiments ». **Aucun résultat chiffré** dans le résumé. Texte intégral sous embargo.
- **Kohavi, Crook, Longbotham 2009, « Online Experimentation at Microsoft »** : PDF injoignable (connexion refusée). Le chiffre « un tiers » n'est lu que par l'auto-citation de 2012.
- **Texte de *The Pragmatic Programmer* sur les « tracer bullets »** : non lu. Seul l'entretien Artima de 2003 l'a été.
- **Contenu des chapitres de Dewar 2002** (définitions de « signpost », « shaping » et « hedging actions ») : seuls le sommaire et la préface ont été lus.
- **Recherche empirique propre aux spikes XP** : aucune étude trouvée. La seule donnée empirique sur le prototypage retenue est Boehm, Gray, Seewaldt 1984 (résumé seul).
- **Boehm 1991, numérotation exacte des dix risques** : le tableau 1 a été lu dans un PDF scanné. L'ordre listé ici suit le tableau, mais l'OCR est imparfaite.
- **Page iso.org d'ISO 31000:2018** : 403. Lecture faite sur l'aperçu officiel diffusé par iTeh (clauses 1 à 4).
- **Jørgensen & Grimstad 2011** : seul le résumé a été lu. Le constat selon lequel seule la contrainte de délai court produit une baisse importante vient d'un résumé de recherche web, pas du texte.

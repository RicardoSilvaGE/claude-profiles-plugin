# Fiche `ux-preuves` — Normes, lois UX, méthodes et mesure

> Fiche du skill `ux-preuves` (dev-fullstack). Couvre : ISO 9241-11, -110, -210 ; sources primaires des « lois UX » et leurs limites ; sévérité, tests, questionnaires, taille d'échantillon, A/B, HEART, JTBD, Kano.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Mythes » et « Non
> vérifié » en fin de fiche sont opposables autant que les entrées : ce qui y figure ne se cite
> pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Recherche menée le 09.11.2026. Chaque entrée renvoie à une page **réellement ouverte** (WebFetch).
Quand seul le résumé d'un article a pu être lu, l'entrée l'indique (« résumé seul lu »).
Quand un PDF a été récupéré puis converti en texte (pdftotext), l'extrait vient du texte intégral
ou de l'aperçu public du document.

Conventions :
- N1 = norme ; N2 = recherche revue par pairs ou étude empirique (échantillon cité) ; N3 = guideline
  officielle d'institution ou de plateforme ; N4 = avis d'expert, article de praticien.
- iso.org répond 403 au robot : les normes ISO ont été lues dans les **aperçus publics officiels**
  (iTeh Standards, « STANDARD PREVIEW »), qui reproduisent l'avant-propos, les définitions et les
  premiers articles.

Total : **34 entrées** (5 normes + 13 lois + 16 méthodes).

---

## 4.1 Fondements normatifs (ISO 9241)

### Juger l'utilisabilité toujours par rapport à des utilisateurs, des objectifs et un contexte d'usage nommés, jamais dans l'absolu
- Niveau de preuve : N1
- Source : ISO, 2018, « ISO 9241-11:2018 Ergonomics of human-system interaction — Part 11: Usability: Definitions and concepts » (2e édition, 2018-03), aperçu officiel : https://cdn.standards.iteh.ai/samples/63500/33c267a5a7564f298f02bbd65721a181/ISO-9241-11-2018.pdf
- Extrait lu : « 3.1.1 usability — extent to which a system, product or service can be used by specified users to achieve specified goals with effectiveness, efficiency and satisfaction in a specified context of use » ; note 1 : « The "specified" users, goals and context of use refer to the particular combination of users, goals and context of use for which usability is being considered. »
- Portée / limites : définition du concept, pas une méthode de mesure. Le « contexte d'usage » est défini en 3.1.15 : « combination of users, goals and tasks, resources, and environment », l'environnement incluant les dimensions « technical, physical, social, cultural and organizational ». Une affirmation « ce produit est utilisable » sans ces trois précisions n'a pas de sens au regard de la norme.

### Mesurer séparément l'efficacité (atteinte du but), l'efficience (ressources dépensées) et la satisfaction (réponses physiques, cognitives et émotionnelles)
- Niveau de preuve : N1
- Source : ISO, 2018, « ISO 9241-11:2018 », aperçu officiel : https://cdn.standards.iteh.ai/samples/63500/33c267a5a7564f298f02bbd65721a181/ISO-9241-11-2018.pdf
- Extrait lu : « 3.1.12 effectiveness — accuracy and completeness with which users achieve specified goals » ; « 3.1.13 efficiency — resources used in relation to the results achieved » ; « 3.1.14 satisfaction — extent to which the user's physical, cognitive and emotional responses that result from the use of a system, product or service meet the user's needs and expectations »
- Portée / limites : l'avant-propos signale deux changements par rapport à 1998 : « efficiency has been defined in relation to the results achieved rather than in relation to accuracy and completeness » et « satisfaction has been clarified to include a wider range of issues ». La note 2 de 3.1.14 précise : « Anticipated use can influence satisfaction with actual use. » Cela rejoint l'effet esthétique-utilisabilité (§ 4.2). La norme couvre aussi les services et les environnements bâtis, au-delà du logiciel.

### Auditer une interface avec les sept principes d'interaction de l'ISO 9241-110:2020, pas avec la liste de 2006
- Niveau de preuve : N1
- Source : ISO, 2020, « ISO 9241-110:2020 Ergonomics of human-system interaction — Part 110: Interaction principles » (2e édition, 2020-05), aperçu officiel : https://cdn.standards.iteh.ai/samples/75258/83c8cf072187487686645aad04eff40e/ISO-9241-110-2020.pdf
- Extrait lu : « Seven principles have been identified as being important for the design and evaluation of interactive systems. » Liste exacte (articles 5.1 à 5.7) : « Suitability for the user's tasks », « Self-descriptiveness », « Conformity with user expectations », « Learnability », « Controllability », « Use error robustness », « User engagement ». Avant-propos : « the principle of individualization has been merged into the principle of controllability; — a new principle on user engagement has been developed »
- Portée / limites : « The order in which the principles are presented here does not imply any priority. » La norme exclut explicitement « marketing, aesthetics and corporate identity » (résultat de recherche, non relu dans l'aperçu). Les anciennes listes de « 7 principes de dialogue » (2006 : « individualization », « error tolerance », « suitability for learning ») sont donc périmées. Définition de « User engagement » : « presents functions and information in an inviting and motivating manner supporting continued interaction ».

### Conduire la conception centrée sur l'humain selon les six principes de l'ISO 9241-210, dont l'itération et l'expérience globale
- Niveau de preuve : N1
- Source : ISO, 2019, « ISO 9241-210:2019 Ergonomics of human-system interaction — Part 210: Human-centred design for interactive systems » (2e édition, 2019-07), aperçu officiel : https://cdn.standards.iteh.ai/samples/77520/8cac787a9e1549e1a7ffa0171dfa33e0/ISO-9241-210-2019.pdf
- Extrait lu : sommaire (articles 5.2 à 5.7) : « The design is based upon an explicit understanding of users, tasks and environments », « Users are involved throughout design and development », « The design is driven and refined by user-centred evaluation », « The process is iterative », « The design addresses the whole user experience », « The design team includes multidisciplinary skills and perspectives ». En 5.5 : « The most appropriate design for an interactive system cannot typically be achieved without iteration. »
- Portée / limites : révision mineure de l'édition 2010 (figure 1 clarifiée, accessibilité ajoutée en 7.1). En 5.6, la norme récuse la réduction de l'utilisabilité à la facilité : « There is a common misconception that usability refers solely to making products easy to use. » Elle ne décrit pas les méthodes en détail (résultat de recherche : « does not provide detailed coverage of the methods »).

### Prévoir une évaluation par les utilisateurs jusqu'à la recette finale, puis en exploitation, pas seulement en phase de maquette
- Niveau de preuve : N1
- Source : ISO, 2019, « ISO 9241-210:2019 », § 5.4, aperçu officiel : https://cdn.standards.iteh.ai/samples/77520/8cac787a9e1549e1a7ffa0171dfa33e0/ISO-9241-210-2019.pdf
- Extrait lu : « User-centred evaluation should also take place as part of the final acceptance of the product to confirm that requirements have been met. Feedback from users during operational use identifies long-term issues and provides input to future design. »
- Portée / limites : « should » marque une recommandation, pas une exigence. Le tableau 1 de la norme liste des livrables types : profils de groupes d'utilisateurs, personas, scénarios, prototypes basse et haute fidélité, rapport de test d'utilisabilité, rapport d'enquête.

---

## 4.2 « Lois UX » : sources primaires et limites

### Ne pas invoquer la loi de Hick pour justifier de supprimer des options : elle décrit un temps de réaction à un stimulus, pas un choix dans un menu qu'on parcourt
- Niveau de preuve : N2 (Liu et al., CHI 2020, résumé seul lu) et index encyclopédique pour la formule
- Source : Liu, Gori, Rioul, Beaudouin-Lafon, Guiard, 2020, « How Relevant is Hick's Law for HCI? », CHI 2020, https://researchportal.ip-paris.fr/en/publications/how-relevant-is-hicks-law-for-hci/ ; et Wikipedia, « Hick's law », https://en.wikipedia.org/wiki/Hick%27s_law
- Extrait lu : « Hick's law speaks against, not for, the popular principle that 'less is better' » ; « the stimulus-response paradigm is rarely relevant to HCI tasks, where choice-reaction time can often be assumed to be constant » (Liu et al.). Wikipedia : formule T = b·log2(n+1) ; pour une liste en ordre aléatoire, « Hick's law does not apply ».
- Portée / limites : sources primaires identifiées mais **non ouvertes** (accès refusé) : Hick 1952, « On the rate of gain of information », QJEP 4(1) : 11-26 ; Hyman 1953, « Stimulus information as a determinant of reaction time », JEP 45(3) : 188-196. Leur contenu (≤ 10 alternatives, temps de réaction à des lampes) n'est connu ici que par les résumés des moteurs de recherche. La croissance est logarithmique : doubler les options n'ajoute qu'un incrément constant. Le parcours visuel d'une liste est linéaire et relève d'un autre modèle. Wikipedia cite d'autres exceptions : compatibilité stimulus-réponse, saccades, réponses verbales familières (Longstreth et al. 1985).

### Dimensionner et placer les cibles selon Fitts : le temps croît avec le log de (distance / largeur), mais ce n'est validé que pour des mouvements de pointage d'amplitude contrôlée
- Niveau de preuve : N2
- Source : Fitts, P. M., 1954, « The information capacity of the human motor system in controlling the amplitude of movement », Journal of Experimental Psychology 47 : 381-391 (réimpression APA Centennial), https://www.cs.princeton.edu/courses/archive/fall08/cos436/FittsJEP1954.pdf
- Extrait lu : « a binary index of difficulty (Id) is defined as Id = −log2 (Ws/2A) bits/response, where Ws is the tolerance range in inches and A is the average amplitude » ; « even though the index is not precisely constant, the hypothesis is substantially confirmed. »
- Portée / limites : trois tâches (tapotement réciproque, transfert de disques, transfert de goupilles). Échantillons : « Sixteen right-handed college men » (exp. I et II), « Twenty college students, ten men and ten women » (exp. III). Fitts lui-même écrit que l'indice est « insensitive to the information required for specifying the direction of a movement » et aux gestes de préhension. Transposer à la souris, au tactile ou au pointage 2D suppose les reformulations ultérieures (non vérifiées ici). La loi ne dit rien du temps de décision qui précède le geste.

### Ne pas tirer de règle « 7 ± 2 éléments par écran » de Miller : son article parle de jugement absolu et d'empan mnésique, et il qualifie lui-même le nombre sept de coïncidence possible
- Niveau de preuve : N2
- Source : Miller, G. A., 1956, « The Magical Number Seven, Plus or Minus Two: Some Limits on our Capacity for Processing Information », Psychological Review 63 : 81-97, http://psychclassics.yorku.ca/Miller/
- Extrait lu : « the span of immediate memory seems to be almost independent of the number of bits per chunk, at least over the range that has been examined to date » ; sur la récurrence du sept : « perhaps it is only a pernicious, Pythagorean coincidence ».
- Portée / limites : l'unité est le **chunk**, dont la taille dépend de l'expertise de la personne. Il ne s'agit ni d'items d'interface ni de bits. L'article concerne le rappel immédiat sans support visible, pas la lecture d'un menu affiché. Voir l'entrée Cowan, puis § Mythes.

### Pour ce que l'utilisateur doit garder en tête sans le voir (codes, étapes, comparaisons), compter sur environ quatre chunks, pas sept
- Niveau de preuve : N2 (article de synthèse avec commentaires de pairs)
- Source : Cowan, N., 2001, « The magical number 4 in short-term memory: A reconsideration of mental storage capacity », Behavioral and Brain Sciences 24(1) : 87-114, https://www.cambridge.org/core/journals/behavioral-and-brain-sciences/article/magical-number-4-in-shortterm-memory-a-reconsideration-of-mental-storage-capacity/44023F1147D4A1D44BDC0AD226838496 (résumé seul lu)
- Extrait lu : « that number was meant more as a rough estimate and a rhetorical device than as a real capacity limit » ; « A single, central capacity limit averaging about four chunks is implicated along with other, noncapacity-limited sources. »
- Portée / limites : la limite porte sur ce qui doit être **maintenu en mémoire**, quand la répétition et le regroupement ne sont pas possibles. Ce qui reste affiché à l'écran n'est pas concerné. Le résumé donne une moyenne, pas une constante universelle.

### Soigner le pic et la fin d'un parcours, car le souvenir qu'on en garde dépend d'eux plus que de sa durée
- Niveau de preuve : N2
- Source : Kahneman, Fredrickson, Schreiber, Redelmeier, 1993, « When More Pain Is Preferred to Less: Adding a Better End », Psychological Science 4(6) : 401-405, https://www.psychologicalscience.org/journals/psychological-science/j.1467-9280.1993.tb00589.x/ (résumé seul lu)
- Extrait lu : « in the short trial, they immersed one hand in water at 14 °C for 60 s » ; l'essai long ajoutait 30 s pendant que l'eau remontait à 15 °C, « still painful but distinctly less so » ; « A significant majority chose to repeat the long trial, apparently preferring more pain over less. »
- Portée / limites : expérience de laboratoire sur une douleur physique brève. L'effectif n'apparaît pas dans le résumé. La règle porte sur l'**évaluation rétrospective**, pas sur l'expérience vécue sur le moment. Elle ne justifie pas d'allonger un parcours, sauf si la fin ajoutée est réellement meilleure.

### Le peak-end se vérifie en situation réelle et à large échantillon, mais il gouverne le souvenir, pas toujours le comportement
- Niveau de preuve : N2
- Source : Redelmeier & Kahneman, 1996, « Patients' memories of painful medical treatments: real-time and retrospective evaluations of two minimally invasive procedures », Pain 66(1) : 3-8, notice Europe PMC (PMID 8857625) : https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=TITLE%3A%22memories%20of%20painful%20medical%20treatments%22&resultType=core&format=json (résumé seul lu) ; et Redelmeier, Katz, Kahneman, 2003, « Memories of colonoscopy: a randomized trial », Pain 104(1-2) : 187-194, https://yorkspace.library.yorku.ca/items/1237abd1-7e5a-4a48-bb27-c6e37bac1c34 (résumé seul lu)
- Extrait lu (1996) : « Patients' judgments of total pain were strongly correlated with the peak intensity of pain (P < 0.005) » ; « lengthy procedures were not remembered as particularly aversive ». Extrait lu (2003) : les patients du bras prolongé « experienced the final moments as less painful ».
- Portée / limites : 1996 : coloscopie n = 154, lithotripsie n = 133. 2003 : essai randomisé sur 682 patients ; notes de la fin 1,7 contre 2,5 sur 10 ; expérience globale 4,4 contre 4,9. Le taux de nouvelle coloscopie n'est que **légèrement** plus élevé dans le bras prolongé (odds ratio 1,41). L'effet sur le souvenir est net, l'effet sur le comportement futur est modeste.

### Traiter le peak-end comme un effet robuste, mais pas exclusif : la moyenne de l'expérience pèse autant
- Niveau de preuve : N2 (méta-analyse)
- Source : Alaybek, Dalal, Fyffe, Aitken, Zhou, Qu, Roman, Baines, 2022, « All's well that ends (and peaks) well? A meta-analysis of the peak-end rule and duration neglect », Organizational Behavior and Human Decision Processes 170, https://ideas.repec.org/a/eee/jobhdp/v170y2022ics0749597822000334.html (résumé seul lu)
- Extrait lu : « We meta-analyzed 174 effect sizes and found strong support for the peak-end rule » ; « (1) large (r = 0.581, 95% Confidence Interval = 0.487–0.661) » ; « (3) comparable to the effect of the overall average (mean) score » ; durée : « essentially nil ».
- Portée / limites : l'effet du pic et de la fin est **comparable** à celui de la moyenne, pas supérieur. On ne peut donc pas négliger le milieu d'un parcours. Les modérateurs ne sont pas détaillés dans le résumé.

### Ne pas compter sur la beauté d'une interface pour masquer ses défauts : l'effet esthétique-utilisabilité porte sur l'utilisabilité *perçue*, surtout avant usage
- Niveau de preuve : N2
- Source : Kurosu & Kashimura, 1995, « Apparent Usability vs. Inherent Usability: Experimental analysis on the determinants of the apparent usability », CHI '95 Companion (pp. 292-293 selon la recherche), https://chi1995.chistatic.hosting.acm.org/proceedings/shortppr/mk_bdy.htm
- Extrait lu : « the apparent usability is more strongly affected by the aesthetic aspects than the inherent usability » ; les corrélations avec l'utilisabilité intrinsèque étaient « unexpectedly low in many cases ».
- Portée / limites : 26 maquettes d'écran de distributeur de billets, notées par 252 étudiants (156 en école de design, 96 en psychologie). Aucun participant n'**utilisait** réellement l'interface : seule l'utilisabilité apparente est jugée. Le pays n'est pas indiqué (auteurs chez Hitachi, Tokyo). C'est une étude corrélationnelle.

### Après usage aussi, l'esthétique prédit l'utilisabilité perçue dans l'étude de Tractinsky 2000, mais ce résultat a été inversé depuis : la tester, ne pas la postuler
- Niveau de preuve : N2
- Source : Tractinsky, Katz, Ikar, 2000, « What is beautiful is usable », Interacting with Computers 13(2) : 127-145, https://academic.oup.com/iwc/article-abstract/13/2/127/898608 (résumé seul lu) ; contre-étude : Tuch, Roth, Hornbæk, Opwis, Bargas-Avila, 2012, « Is beautiful really usable? Toward understanding the relation between usability, aesthetics, and affect in HCI », Computers in Human Behavior 28(5) : 1596-1607, compte rendu lu : https://www.infoq.com/news/2012/05/Aesthetics-Usability (le résumé de l'article n'a pas pu être ouvert)
- Extrait lu : Tractinsky : « Post-experimental measures indicated that the strong correlation remained intact » ; « whereas the degree of actual usability had no such effect ». Tuch (selon InfoQ) : « 80 participants », quatre variantes d'une même boutique en ligne, « aesthetics does not affect perceived usability, but degraded usability negatively affects perceived aesthetics ».
- Portée / limites : Tractinsky simule un distributeur de billets ; l'effectif n'est pas indiqué dans le résumé. Tuch 2012, avec un plan factoriel 2×2, trouve la causalité inverse (« what is usable is beautiful »). La relation dépend donc de l'intensité des manipulations et du moment de mesure. Le compte rendu InfoQ est N4 ; l'article lui-même n'a pas été lu.

### Suivre les conventions établies par les autres sites et applications, parce que l'utilisateur y passe la plus grande partie de son temps (« loi de Jakob »)
- Niveau de preuve : N4
- Source : Nielsen, J., 22.07.2000, « End of Web Design », Nielsen Norman Group, https://www.nngroup.com/articles/end-of-web-design/
- Extrait lu : section « Jakob's Law of the Internet User Experience » : « Users spend most of their time on other sites » ; « This means that users prefer your site to work the same way as all the other sites they already know. »
- Portée / limites : c'est un **raisonnement d'expert**, pas une loi mesurée. Aucune étude n'est citée à l'appui. Le texte date de 2000 et vise le web. Il n'interdit pas d'innover là où il n'existe aucune convention, et rejoint le principe ISO « Conformity with user expectations », qui renvoie aux « commonly accepted conventions in this context ».

### Décider explicitement qui porte la complexité irréductible d'une tâche, le système ou l'utilisateur (« loi de Tesler »)
- Niveau de preuve : N4
- Source : Wikipedia, « Law of conservation of complexity », https://en.wikipedia.org/wiki/Law_of_conservation_of_complexity (qui cite l'entretien de Larry Tesler dans Saffer, D., 2010, « Designing for Interaction », New Riders, chap. 7, p. 136)
- Extrait lu : « every application has an inherent amount of complexity that cannot be removed or hidden » ; citation de Tesler : « If a million users each waste a minute a day dealing with complexity that an engineer could have eliminated in a week »
- Portée / limites : principe tiré d'un **entretien**, sans aucune mesure. La source primaire (le livre de Saffer) n'a pas été ouverte. Contrepoint rapporté par la même page : selon Tognazzini, les utilisateurs s'attaquent à des tâches plus complexes quand on simplifie l'outil.

### Placer les éléments à retenir en début et en fin de liste, effet mesuré en rappel libre de listes de mots
- Niveau de preuve : N2 (jeu de données) et index encyclopédique
- Source : Murdock, B. B., 1962, « The serial position effect of free recall », JEP 64(5) : 482-488. Lus : la documentation du jeu de données réanalysé, https://cdl-quail.readthedocs.io/en/latest/tutorial/murdock_1962.html, et Wikipedia, « Serial-position effect », https://en.wikipedia.org/wiki/Serial-position_effect (l'article original n'a pas été ouvert)
- Extrait lu : « list length (10, 15, 20, 30, or 40 items) » ; « presentation rate (1 or 2 sec/item) » ; « The dataset contains 90 subjects (15 per condition) across 6 experimental conditions. » Wikipedia : « Longer presentation lists have been found to reduce the primacy effect » ; une tâche distractive « exceeding 15 to 30 seconds in duration, can cancel out the recency effect » (Bjork & Whitten 1974).
- Portée / limites : rappel libre de listes de mots présentées une à une. Le transfert à un menu affiché, que l'on relit, n'est **pas démontré** par ces sources. L'effet de récence disparaît après une tâche intercalée, ce qui le rend fragile dans un parcours réel ponctué d'autres actions.

### Ne pas fonder une fonction sur l'effet Zeigarnik (mémoire des tâches interrompues) : la méta-analyse de 2025 ne le retrouve pas. Seul l'effet Ovsiankina (tendance à reprendre la tâche) tient
- Niveau de preuve : N2 (méta-analyse)
- Source : Ghibellini & Meier, 2025, « Interruption, recall and resumption: a meta-analysis of the Zeigarnik and Ovsiankina effects », Humanities and Social Sciences Communications 12(1), https://ideas.repec.org/a/pal/palcom/v12y2025i1d10.1057_s41599-025-05000-w.html (résumé seul lu) ; contexte historique : https://en.wikipedia.org/wiki/Zeigarnik_effect
- Extrait lu : « We found no memory advantage for unfinished tasks but found a general tendency to resume tasks » ; « the Ovsiankina effect represents a general tendency, whereas the Zeigarnik effect lacks universal validity. »
- Portée / limites : le nombre d'études incluses n'est pas indiqué dans le résumé lu (les chiffres qui circulent ailleurs n'ont pas été vérifiés). Les auteurs avancent que l'effet dépendrait de facteurs situationnels : autorité de l'expérimentateur, implication dans la tâche. Une barre de progression peut se justifier par la tendance à reprendre la tâche (Ovsiankina), **pas** par une meilleure mémorisation.

---

## 4.3 Méthodes et mesure

### Interpréter un score SUS par rapport à la moyenne de 68 et en rang centile, jamais comme un pourcentage
- Niveau de preuve : N4 (praticien ; base de données propriétaire de grande taille)
- Source : Sauro, J., 03.02.2011, « Measuring Usability with the System Usability Scale (SUS) », MeasuringU, https://measuringu.com/sus/
- Extrait lu : « The average SUS score from all 500 studies is a 68 » ; base : « data from over 5000 users across 500 different evaluations » ; « Even though a SUS score can range from 0 to 100, it isn't a percentage » ; « a raw SUS score of a 74 converts to a percentile rank of 70% ».
- Portée / limites : la moyenne de 68 provient d'un corpus **non public**, publié en 2011. La page de 2018 (« 5 Ways to Interpret a SUS Score », https://measuringu.com/interpret-sus-score/) maintient : « The average score (at the 50th percentile) is 68 », sur « over 10,000 responses and hundreds of products ». La page de 2011 date la création du SUS à 1986 ; le chapitre de référence est Brooke 1996.

### Citer le SUS dans sa forme d'origine (dix items alternés, de Brooke) et en citer la source
- Niveau de preuve : N2 (instrument publié) ; la fiche lue est N3
- Source : Brooke, J., 1996, « SUS: A quick and dirty usability scale », in « Usability Evaluation in Industry », fiche de la base d'échelles de George Mason University : https://hriscaledatabase.psychology.gmu.edu/usability/2025/01/13/SUS.html (le chapitre lui-même n'a pas été ouvert)
- Extrait lu : items 1 et 2 : « I think that I would like to use this system frequently. » ; « I found the system unnecessarily complex. » … item 10 : « I needed to learn a lot of things before I could get going with this system. »
- Portée / limites : la fiche GMU ne rapporte **aucune** mesure de fiabilité ni de structure factorielle (« None »). La pagination de la référence varie selon les sources (« 189(194), 4-7 » sur la fiche), à vérifier dans l'ouvrage.

### Quand dix items sont de trop, utiliser l'UMUX-Lite (deux items) et le recaler sur l'échelle SUS par sa régression
- Niveau de preuve : N2
- Source : Lewis, Utesch, Maher, 2013, « UMUX-LITE – When There's No Time for the SUS », CHI 2013, texte intégral : https://ccy05327.github.io/SDD/08-PDF/UMUX-LITE%20-%20when%20there's%20no%20time%20for%20the%20SUS.pdf
- Extrait lu : « The UMUX-LITE items are "This system's capabilities meet my requirements" and "This system is easy to use." » ; « Estimates of reliability were .82 and .83 » ; « significant correlation with the SUS (.81, .81) » ; « UMUX-LITE score means were slightly lower than those for the SUS, but easily adjusted using linear regression ».
- Portée / limites : deux enquêtes menées auprès d'employés d'IBM (n = 402 et n = 389). Le score brut n'est pas directement comparable au SUS : il faut appliquer la correction par régression. L'instrument mesure l'utilité **et** l'utilisabilité, pas l'utilisabilité seule.

### Après chaque tâche d'un test, poser la Single Ease Question (une question, sept points) et la comparer à une moyenne de l'ordre de 5,5
- Niveau de preuve : N2 (étude d'origine) et N4 (référentiel praticien)
- Source : Sauro & Dumas, 2009, « Comparison of Three One-Question, Post-Task Usability Questionnaires », CHI 2009, https://measuringu.com/wp-content/uploads/2017/07/Sauro_Dumas_CHI2009.pdf ; Sauro & Lewis, 06.08.2024, « The Evolution of the Single Ease Question (SEQ) », https://measuringu.com/evolution-of-seq
- Extrait lu : 2009 : « Three one-question rating types were compared in a study with 26 participants who attempted the same five tasks with two software applications » ; « the Likert and SMEQ types were more sensitive with small sample sizes ». 2024 : formulation actuelle « How easy or difficult was it to complete this task? » ; la moyenne a « settled closer to 5.5 ».
- Portée / limites : l'étude de 2009 porte sur 26 participants et deux logiciels. La formulation et la polarité actuelles (« Very Difficult » à gauche) datent de 2012 selon MeasuringU. Le repère de 5,5 vient d'une base propriétaire.

### Choisir les métriques produit avec HEART (Happiness, Engagement, Adoption, Retention, Task success), en partant des objectifs, puis des signaux, puis des métriques
- Niveau de preuve : N2 (note CHI, retour d'expérience industriel)
- Source : Rodden, Hutchinson, Fu, 2010, « Measuring the User Experience on a Large Scale: User-Centered Metrics for Web Applications », CHI 2010, https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/36299.pdf (fiche : https://research.google/pubs/measuring-the-user-experience-on-a-large-scale-user-centered-metrics-for-web-applications/)
- Extrait lu : « HEART: Happiness, Engagement, Adoption, Retention, and Task success. These are categories, from which teams can then define the specific metrics » ; « It is not always appropriate to employ metrics from every category » ; « Engagement may not be meaningful in an enterprise context, if users are expected to use the product as part of their work. »
- Portée / limites : cadre de **sélection** de métriques, pas un instrument validé. Conçu chez Google pour des produits web à fort trafic et à données comportementales massives, il est peu transposable tel quel à un outil métier à faible audience. Le processus « GOALS – SIGNALS – METRICS » est décrit dans la même note.

### Coter la sévérité des problèmes de 0 à 4 selon la fréquence, l'impact et la persistance, en faisant la moyenne d'au moins trois évaluateurs
- Niveau de preuve : N4
- Source : Nielsen, J., 01.11.1994, « Severity Ratings for Usability Problems », Nielsen Norman Group, https://www.nngroup.com/articles/how-to-rate-the-severity-of-usability-problems/
- Extrait lu : « The frequency with which the problem occurs » ; « The impact of the problem if it occurs » ; « The persistence of the problem » ; échelle : de « 0: I don't agree that this is a usability problem at all » à « 4: Usability catastrophe: imperative to fix this before product can be released » ; « severity ratings from a single evaluator are too unreliable to be trusted ».
- Portée / limites : Nielsen ajoute un quatrième critère, l'« impact marché ». Pour la moyenne de trois évaluateurs, il dit seulement qu'elle est « satisfactory for many practical purposes », sans donner de mesure d'accord inter-évaluateurs.

### Tester avec environ cinq utilisateurs **par itération et par groupe d'utilisateurs**, pour un test qualitatif, et répartir le budget sur plusieurs tours
- Niveau de preuve : N4 (article) fondé sur un modèle N2 (Nielsen & Landauer, INTERCHI '93, pp. 206-213, cité mais non ouvert)
- Source : Nielsen, J., 18.03.2000, « Why You Only Need to Test with 5 Users », Nielsen Norman Group, https://www.nngroup.com/articles/why-you-only-need-to-test-with-5-users/
- Extrait lu : modèle N(1−(1−L)^n) ; « The typical value of L is 31% » ; avec cinq participants, le test « has found 85% of the usability problems » ; « Spend this budget on 3 studies with 5 users each! »
- Portée / limites : le chiffre de 85 % suppose L = 31 %, une **moyenne** tirée des projets des auteurs. Il suppose aussi que tous les utilisateurs rencontrent les mêmes parties du système. Nielsen lui-même recommande d'autres effectifs : 3 à 4 par groupe quand il y a deux groupes, environ 20 pour des métriques quantitatives, 15 pour un tri de cartes.

### Augmenter l'effectif dès que les tâches sont ouvertes (« trouvez et achetez… ») : le modèle à cinq utilisateurs suppose une exposition identique de chaque participant au système
- Niveau de preuve : N4 (compte rendu) d'une étude N2 (Spool & Schroeder, CHI EA 2001, pp. 285-286, non ouverte)
- Source : Hudson, W., 2001, SIGCHI Bulletin (mai-juin), « How many users does it take to change a Web site? », https://syntagm.co.uk/design/articles/howmany.htm
- Extrait lu : l'étude de Spool « failed to find even half of a web site's predicted usability problems with a whopping 18 users » ; le modèle de Nielsen et Landauer « only works because users are exposed to the same aspects of the system under test ».
- Portée / limites : les tests de Spool étaient « goal-directed », chaque utilisateur fixant ses sous-objectifs. Les détails d'effectif de l'étude originale (« 49 users », « four sites ») ne viennent que des résultats de recherche et n'ont **pas été vérifiés** sur une page ouverte.

### Prévoir 10 à 15 participants quand on veut une couverture fiable des problèmes : avec cinq, la part trouvée varie de 55 % à presque 100 % selon le tirage
- Niveau de preuve : N4 (compte rendu) d'une étude N2 (Faulkner 2003, Behavior Research Methods, Instruments & Computers 35(3) : 379-383, résumé non lisible)
- Source : Straub, K., mai 2004, newsletter Human Factors International, « Enough is enough », https://www.humanfactors.com/newsletters/enough_is_enough.html
- Extrait lu : sur 60 participants, Faulkner tire des sous-ensembles au hasard ; « the percentage of usability problems found when testing five participants ranged from nearly 100% down to only 55% » ; moyenne de 85 % ; « Drawing 10 participants instead of five, the simulation uncovered 95% of the problems on average » ; avec 15 : 97 %.
- Portée / limites : la moyenne de 85 % reproduit celle de Nielsen. Ce que Faulkner montre, c'est la **variance** : un tour de cinq participants peut manquer près de la moitié des problèmes. Simulation sur une seule application.

### Valider une arborescence de navigation par un tree test (structure nue, sans habillage graphique) avant d'en faire la maquette
- Niveau de preuve : N4
- Source : Laubheimer, P., 06.08.2023 (relu le 19.08.2026), « Tree Testing: Evaluate Menu Labels and Categories », Nielsen Norman Group, https://www.nngroup.com/articles/tree-testing/
- Extrait lu : « An evaluation of a hierarchical category structure, or tree » ; les participants naviguent « without any visual design or content » ; un participant peut avoir « bounced around trying a few categories before making a choice » (directness).
- Portée / limites : l'article ne donne pas d'effectif chiffré (« only a few participants » en qualitatif, « a larger sample size » en quantitatif). Les outils n'admettent souvent que des feuilles comme bonnes réponses. Un méga-menu réel montre plusieurs niveaux à la fois, ce que le test ne reproduit pas.

### Mesurer le premier clic, mais ne pas lui prêter le pouvoir prédictif du chiffre « 87 % contre 46 % » : la réplication trouve 78 % contre 70 %
- Niveau de preuve : N2 (étude empirique, 750 participants)
- Source : Sauro, Schiavone, Du, Lewis, 21.03.2023, « Do Click Tests Predict Live Site Clicks? », MeasuringU, https://measuringu.com/?p=36842
- Extrait lu : chez Bailey & Wolfson (12 études, 2006-2009), un premier clic sur le bon chemin donnait 87 % de réussite contre 46 % ; mais « Bailey and Wolfson didn't use a click test to generate their findings » ; réplication sur cinq sites, 21 tâches et 750 participants : 78 % contre 70 %, « We found a more modest result. »
- Portée / limites : la source primaire de Bailey & Wolfson n'a pas été ouverte (voir § Non vérifié). La réplication est menée par un acteur commercial sans revue par les pairs. L'écart reste favorable au bon premier clic, mais il est faible (rapport de 1,1).

### En test A/B, lire la p-valeur comme P(données | H0) et non comme la probabilité que le variant gagne ; abaisser le seuil et invoquer la loi de Twyman devant un gain spectaculaire
- Niveau de preuve : N2 (KDD 2022, version auteur)
- Source : Kohavi, Deng, Vermeer, 2022, « A/B Testing Intuition Busters: Common Misunderstandings in Online Controlled Experiments », KDD 2022, version auteur : https://airbnb.tech/wp-content/uploads/sites/19/2025/10/ABTestingIntuitionBusters.pdf
- Extrait lu : « The p-value is the probability of obtaining a result equal to or more extreme than what was observed, assuming that all the modeling assumptions, including the null hypothesis, H0, are true » ; « Twyman's law—any figure that looks interesting or different is usually wrong (Kohavi, Tang and Xu 2020)—and only accept the result if the p-value is very low. »
- Portée / limites : les auteurs proposent de calculer le False Positive Risk à partir du taux de succès historique des expériences de l'organisation, ce qui suppose un volume d'expériences que peu d'équipes ont. Le livre de Kohavi, Tang & Xu (2020, Cambridge University Press) n'a **pas pu être ouvert** (pages Cambridge en erreur 500) : il n'est cité ici qu'à travers cet article.

### Fixer la durée ou l'effectif du test A/B à l'avance, ou utiliser une méthode séquentielle : arrêter dès que « c'est significatif » invalide la p-valeur
- Niveau de preuve : N2
- Source : Johari, Pekelis, Walsh, « Always Valid Inference: Bringing Sequential Analysis to A/B Testing », arXiv:1512.04922 (v1 2015, v3 2019), https://arxiv.org/abs/1512.04922 (résumé seul lu) ; complété par Kohavi, Deng, Vermeer 2022 (même PDF que ci-dessus)
- Extrait lu : Johari et al. : les inférences classiques « are wholly unreliable if users endogenously choose samples sizes by continuously monitoring their tests ». Kohavi et al. : « their users peeked at the data and chose to stop when it was statistically significant […] This type of multiple testing significantly inflates the type-I error rates (Johari, et al. 2017). »
- Portée / limites : Kohavi et al. rangent dans la même famille de faux positifs la suppression des valeurs aberrantes « within a variant » (jusqu'à 43 % de faux positifs, André 2021) et la segmentation a posteriori. La version KDD 2017 (« Peeking at A/B Tests ») n'a pas été ouverte.

### Contrôler le ratio d'échantillonnage (SRM) avant toute lecture des résultats d'un test A/B : un écart à la répartition prévue rend le résultat suspect
- Niveau de preuve : N2
- Source : Fabijan, Gupchup, Gupta, Omhover, Vermeer, Dmitriev, 2019, « Diagnosing Sample Ratio Mismatch in Online Controlled Experiments: A Taxonomy and Rules of Thumb for Practitioners », KDD 2019, https://www.lukasvermeer.nl/publications/papers/2019/07/25/diagnosing-sample-ratio-mismatch-in-online-controlled-experiments.html (résumé seul lu)
- Extrait lu : SRM = « the situation when the observed sample ratio in the experiment is different from the expected » ; « Ignoring the SRM without knowing the root cause may result in a bad product modification appearing to be good ».
- Portée / limites : retour d'expérience de quatre entreprises sur plus de 25 produits. Le chiffre d'environ 6 % d'expériences touchées chez Microsoft n'apparaît que dans des diapositives repérées en recherche : **non vérifié**.

### Cadrer un besoin comme un « job » : le progrès qu'une personne cherche à faire dans une circonstance donnée, avec ses dimensions fonctionnelle, sociale et émotionnelle
- Niveau de preuve : N4 (ouvrage de management, sans protocole publié)
- Source : Christensen, Hall, Dillon, Duncan, 2016, « Competing Against Luck », HarperBusiness, extrait de l'éditeur : https://porchlightbooks.com/blog/excerpts/competing-against-luck-the-story-of-innovation-and-customer-choice ; article associé : HBR, septembre 2016, « Know Your Customers' "Jobs to Be Done" », https://hbr.org/2016/09/know-your-customers-jobs-to-be-done (seul le chapeau a pu être lu)
- Extrait lu : « We define a "job" as the progress that a person is trying to make in a particular circumstance. » ; « A job can only be defined—and a solution created—relative to the specific context in which it arises. » ; « jobs not only have functional dimensions, they have social and emotional dimensions. »
- Portée / limites : cadre conceptuel, pas une méthode de mesure. Plusieurs écoles revendiquent l'approche (l'Outcome-Driven Innovation d'Ulwick, non vérifiée ici). L'exemple du milkshake n'a pas été retrouvé dans les pages ouvertes.

### Classer les attributs avec le modèle de Kano (attractif, proportionnel, obligatoire) sur la base d'un questionnaire, et non d'une intuition d'équipe
- Niveau de preuve : N2 (article revu, japonais)
- Source : Kano, Seraku, Takahashi, Tsuji, 1984, « Attractive Quality and Must-Be Quality » (魅力的品質と当り前品質), Journal of The Japanese Society for Quality Control 14(2) : 147-156, DOI 10.20684/quality.14.2_147, https://www.jstage.jst.go.jp/article/quality/14/2/14_KJ00002952366/_article/-char/en (résumé seul lu)
- Extrait lu : « two aspects of quality such as subjective and objective ones » ; catégories : « attractive, nust-be, one-dimensional quality ones » (coquille d'origine) ; validation par un questionnaire de consommateurs sur un téléviseur et une pendule de table.
- Portée / limites : l'article d'origine porte sur des **biens de consommation** de 1984. Le texte intégral est en accès restreint et en japonais. Le résumé ne dit rien de la stabilité des catégories dans le temps ni des catégories « indifférent » et « inverse » qu'on associe aujourd'hui au modèle (non vérifié). La pagination « 39-48 » parfois citée est contredite par J-STAGE (147-156).

---

## Mythes et affirmations contestées

| Affirmation courante | Statut | Source qui nuance (ouverte) |
|---|---|---|
| « La loi de Hick impose de réduire le nombre d'options » (formulation de lawsofux.com : « Minimize choices when response times are critical », https://lawsofux.com/hicks-law/) | **Contestée** | Liu et al., CHI 2020 : « Hick's law speaks against, not for, the popular principle that 'less is better' » ; la croissance est logarithmique, et le parcours d'une liste désordonnée n'y obéit pas (Wikipedia). |
| « Un menu doit contenir 7 ± 2 éléments » | **Mythe** | Nielsen 2009, https://www.nngroup.com/articles/short-term-memory-and-web-usability/ : « It's a common misconception that limited short-term memory implies that menus should be similarly limited to 7 items » ; uxmyths.com, mythe n° 23 : « a false constraint ». Miller parle de chunks en rappel immédiat (§ 4.2) et Cowan ramène la capacité à environ 4. |
| « La mémoire de travail contient 7 éléments » | **Dépassée** | Cowan 2001 : le sept de Miller était « a rough estimate and a rhetorical device » ; Miller lui-même : « a pernicious, Pythagorean coincidence ». |
| « 5 utilisateurs suffisent pour trouver 85 % des problèmes » | **Conditionnelle** | Valable pour un test qualitatif, à tâches fermées, auprès d'un seul groupe d'utilisateurs, avec L ≈ 31 % (Nielsen 2000). Faulkner 2003 : de 55 % à presque 100 % selon le tirage ; Spool (selon Hudson 2001) : moins de la moitié des problèmes trouvés avec 18 utilisateurs sur des tâches ouvertes. |
| « Un SUS de 70 signifie 70 % d'utilisabilité » | **Faux** | Sauro 2011 : « it isn't a percentage » ; 68 correspond au 50e centile. |
| « Ce qui est beau est utilisable » | **Contestée** | Tractinsky 2000 l'observe sur un distributeur de billets simulé ; Tuch et al. 2012 (80 participants, plan 2×2) trouvent l'inverse : l'esthétique n'agit pas sur l'utilisabilité perçue, alors qu'une mauvaise utilisabilité dégrade l'esthétique perçue. |
| « On retient mieux les tâches inachevées (Zeigarnik) : utilisez des barres de progression pour cela » (lawsofux.com, https://lawsofux.com/zeigarnik-effect/, sans mention des échecs de réplication) | **Non répliquée** | Ghibellini & Meier 2025 : « no memory advantage for unfinished tasks ». Seule la tendance à reprendre la tâche (Ovsiankina) est robuste. |
| « Le premier clic prédit la réussite à 87 % » | **Surestimée** | Réplication MeasuringU 2023 : 78 % contre 70 % (750 participants), et les données d'origine ne venaient pas de click tests. |
| « On peut arrêter un test A/B dès qu'il devient significatif » | **Faux** | Johari et al. : les inférences deviennent « wholly unreliable » ; Kohavi et al. 2022 : erreur de type I « significantly » gonflée. |
| « Seuls le pic et la fin comptent » | **Excessive** | Alaybek et al. 2022 : l'effet du pic et de la fin est « comparable » à celui de la moyenne. Seule la durée a un effet quasi nul. |
| « Les lois de Jakob et de Tesler sont des lois empiriques » | **Abus de langage** | Ce sont des principes d'expert (un article de 2000 et un entretien rapporté), sans mesure publiée. |
| « La liste des principes ISO 9241-110 comprend "individualisation" et "tolérance aux erreurs" » | **Périmé** | Édition 2020 : individualisation fusionnée dans « controllability » ; « use error robustness » ; « user engagement » ajouté. |

---

## Non vérifié

Affirmations repérées mais **pas confirmées sur une page ouverte**. Ne pas les citer comme établies :

- **Texte de Hick 1952 et de Hyman 1953** : bibliographie concordante (QJEP 4(1) : 11-26 ; JEP 45(3) : 188-196), mais pages éditeur en 403 et copies en ligne illisibles. Le « ≈ 5 bits/s » de Hick et le dispositif de Hyman ne sont connus que par les résumés des moteurs de recherche.
- **Proctor & Schneider 2018**, « Hick's law for choice reaction time: A review » (QJEP 71(6) : 1281-1299) : notice PubMed bloquée par une page de cookies, PDF CORE en 403.
- **Chapitre original de Brooke 1996** et **rétrospective de Brooke 2013** (JUS 8(2) : 29-40) : non ouverts (404). La date de création du SUS diverge selon les sources (1984 ou 1986).
- **Courbe de notation SUS de Sauro & Lewis** (241 études, bandes A+ à F, « Quantifying the User Experience », 2016) : vue seulement dans les résultats de recherche.
- **Spool & Schroeder 2001**, détails « 49 utilisateurs, quatre sites » : non lus sur une page ouverte (seul le chiffre de 18 utilisateurs vient d'une page lue).
- **Faulkner 2003, résumé original** : notice PubMed inaccessible ; chiffres repris d'un compte rendu (HFI 2004).
- **Nielsen & Landauer 1993**, article original (INTERCHI '93) : non ouvert, cité via NN/g.
- **Bailey & Wolfson 2009**, « FirstClick Usability Testing » : publication d'origine non ouverte ; chiffres repris via MeasuringU.
- **Livre de Kohavi, Tang & Xu 2020** (« Trustworthy Online Controlled Experiments ») : pages Cambridge en erreur 500. La définition de la loi de Twyman est citée via Kohavi et al. 2022.
- **Prévalence du SRM (~6 % des expériences chez Microsoft)** : diapositives, non ouvertes.
- **Tuch et al. 2012, résumé original** : ScienceDirect en 403 ; contenu connu par InfoQ (N4) seulement.
- **Tractinsky 1997** (CHI '97, réplication israélienne de Kurosu & Kashimura) : non ouvert.
- **Glanzer & Cunitz 1966** (suppression de la récence par un délai) : non ouvert ; Wikipedia attribue l'effet du distracteur à Bjork & Whitten 1974.
- **Zeigarnik 1927, chiffres d'origine** (ratio de rappel des tâches interrompues contre achevées) : absents des pages lues ; l'année même varie (1927 ou 1938) sur Wikipedia.
- **Exemple du milkshake (JTBD)** et **Outcome-Driven Innovation d'Ulwick** : non retrouvés dans les pages ouvertes.
- **Catégories Kano « indifférent » et « inverse »** et l'évolution des catégories dans le temps (l'attractif devenant obligatoire) : absentes du résumé de 1984 ; l'article de Kano sur le cycle de vie de la qualité attractive n'a pas été ouvert (hôte douteux).
- **Exclusion de l'esthétique par l'ISO 9241-110** (« does not consider … marketing, aesthetics and corporate identity ») : vue dans un résultat de recherche, non relue dans l'aperçu.

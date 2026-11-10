# Fiche `ux-preuves` — Revue de code — efficacité mesurée

> Fiche du skill `ux-preuves` (dev-fullstack), volet **revue de code**, préchargé par `reviewer`. Couvre : ce que la revue trouve vraiment (défauts fonctionnels contre évolutivité), taille et vitesse, couverture et participation, commentaires utiles, norme d'approbation de Google, checklists et lecture guidée, ordre des fichiers, biais du relecteur, changements mêlés, revue des tests.
> **Instantané de la recherche documentaire du 10.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Études sur les LLM (souvent des prépublications) et pratiques d'entreprise
> **vieillissent** : avant d'en faire dépendre une règle,
> relire la source (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Méthode : chaque entrée vient d'une page ou d'un PDF réellement ouvert pendant cette recherche (PDF téléchargé puis extrait avec `pdftotext`, ou page HTML lue). Quand seul le résumé a été lu, c'est écrit. Les extraits sont verbatim, dans la langue de la source. Aucune des études ci-dessous ne porte sur un développeur indépendant ni sur TypeScript/Python : elles portent sur de grandes organisations (Microsoft, Google, Cisco) ou de grands projets libres (Qt, Mozilla, projets Java sur GitHub). La transposition au contexte du profil est une extrapolation, signalée dans « Portée / limites ».
>
> Niveaux : N1 norme · N2 recherche revue par les pairs ou étude empirique à large échantillon · N3 guide officiel d'une institution sur sa propre pratique · N4 avis d'expert, livre, étude d'éditeur.

## 1. Ce que la revue trouve vraiment

### Ne pas compter sur la revue comme filtre à bugs : les défauts ne sont qu'une minorité de ce qu'elle produit
- Niveau de preuve : N2 (570 commentaires de 200 fils de revue classés à la main ; enquête auprès de 873 développeurs et 165 managers, Microsoft)
- Source : Bacchelli A., Bird C., 2013, « Expectations, Outcomes, and Challenges of Modern Code Review », ICSE 2013, https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/ICSE202013-codereview.pdf
- Extrait lu : « the category “defect” is the only the fourth most frequent, out of nine items, with 78 (14%) comments. » ; catégorie la plus fréquente : « with 165 (29%) comments, is “code improvements.” »
- Portée / limites : une seule entreprise, outil CodeFlow, 2012. L'échantillon de 570 commentaires est petit ; les auteurs le reconnaissent et triangulent avec entretiens et enquête. Ne mesure pas le nombre de défauts présents et manqués.
- En revue : mon verdict repose-t-il sur l'idée que « si je n'ai rien vu, il n'y a rien » ? Ce qui garantit la correction, ce sont les tests et la vérification exécutée, pas la lecture.

### Chercher délibérément les défauts profonds : spontanément, la revue ne remonte que des erreurs locales
- Niveau de preuve : N2 (même étude)
- Source : Bacchelli A., Bird C., 2013, « Expectations, Outcomes, and Challenges of Modern Code Review », https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/ICSE202013-codereview.pdf
- Extrait lu : « Review comments about defects are few, comprising one-eighth of the total in our sample, and mostly address “micro” level and superficial concerns » ; recommandation : « review does not result in identifying defects as often as project members would like and even more rarely detects deep, subtle, or “macro” level issues. Relying on code review in this way for quality assurance may be fraught. »
- Portée / limites : constat descriptif, pas une expérience contrôlée. Les défauts trouvés sont surtout des erreurs de logique simples (cas limites, valeurs de configuration, priorité d'opérateurs).
- En revue : ai-je posé au moins une question de niveau « macro » (invariant violé ailleurs, interaction entre modules, cas d'usage non couvert), ou seulement relevé ce qui se voit dans les lignes du diff ?

### Comprendre le pourquoi du changement avant de juger : c'est le goulot mesuré de la revue
- Niveau de preuve : N2 (même étude)
- Source : Bacchelli A., Bird C., 2013, « Expectations, Outcomes, and Challenges of Modern Code Review », https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/ICSE202013-codereview.pdf
- Extrait lu : « the most difficult thing when doing a code review is understanding the reason of the change » (développeur senior cité) ; « When reviewers have a priori knowledge of the context and the code, they complete reviews more quickly and provide more valuable feedback to the author. »
- Portée / limites : entretiens et enquête (91 % des répondants disent mettre plus de temps sur des fichiers inconnus, 82 % que les relecteurs familiers du fichier donnent un retour différent). Déclaratif.
- En revue : puis-je énoncer en une phrase ce que le diff est censé faire et pourquoi, à partir de la SPEC ou de la description ? Sinon, je ne suis pas encore en état de relire.

### S'attendre à ce que les trois quarts des constats portent sur l'évolutivité, pas sur le comportement
- Niveau de preuve : N2 (9 revues industrielles C/C++ et 23 revues d'étudiants Java, 388 et 371 défauts) — **résumé seul lu**
- Source : Mäntylä M. V., Lassenius C., 2009, « What Types of Defects Are Really Discovered in Code Reviews? », IEEE TSE 35(3), page de l'auteur : https://mmantyla.github.io/wiki/What+Types+of+Defects+Are+Really+Discovered+in+Code+Reviews%253F.html
- Extrait lu : « we discovered that 75 percent of defects found during the review do not affect the visible functionality of the software. Instead, these defects improved software evolvability by making it easier to understand and modify. »
- Portée / limites : texte intégral non obtenu (IEEE fermé, miroir en erreur). La ventilation fine des défauts d'évolutivité n'a pas été lue. Le chiffre est repris tel quel par Beller et al. 2014 (entrée suivante), qui l'ont lu.
- En revue : ce constat est-il fonctionnel (ça casse) ou d'évolutivité (ça coûtera à la prochaine modification) ? Les deux sont des constats légitimes, mais ils n'ont pas le même poids dans le verdict.

### Tenir le rapport 75/25 pour robuste : il se retrouve dans les changements réellement faits après revue en open source
- Niveau de preuve : N2 (plus de 1 400 changements classés à la main, deux projets libres : ConQAT et GROMACS)
- Source : Beller M., Bacchelli A., Zaidman A., Juergens E., 2014, « Modern Code Reviews in Open-Source Projects: Which Problems Do They Fix? », MSR 2014, https://sback.it/publications/msr2014.pdf
- Extrait lu : « featuring the similar 75:25 ratio of maintainability-related to functional problems. We also reveal that 7–35% of review comments are discarded and that 10–22% of the changes are not triggered by an explicit review comment. »
- Portée / limites : deux projets seulement. L'étude classe les changements effectués, pas les défauts manqués. Dans deux des échantillons, plus de la moitié des tâches passent la revue sans aucun changement (« more than 50% of tasks pass review directly »).
- En revue : parmi mes commentaires, lesquels l'auteur aurait-il des raisons d'écarter (7 à 35 % le sont) ? Les retirer ou les marquer facultatifs avant de rendre le verdict.

### Dimensionner l'attente : environ 15 % des commentaires signalent un défaut possible, encore moins un défaut bloquant
- Niveau de preuve : N3 (retour d'expérience de Microsoft sur sa propre pratique ; résumé de présentation de 2 pages, chiffres donnés sans protocole détaillé)
- Source : Czerwonka J., Greiler M., Tilford J., 2015, « Code Reviews Do Not Find Bugs: How the Current Code Review Best Practice Slows Us Down » (lieu de publication non indiqué dans le PDF lu), https://www.microsoft.com/en-us/research/wp-content/uploads/2015/05/PID3556473.pdf
- Extrait lu : « Only about 15% of comments provided by reviewers indicate a possible defect, much less a blocking defect. Rather, it is feedback related to the long-term code maintainability that comprises a much larger portion of comments provided by reviewers; at least 50% of all. »
- Portée / limites : le titre est une thèse ; le texte dit « often do not find functionality issues that should block a code submission », pas « ne trouvent jamais ». Les chiffres reprennent des études Microsoft antérieures (Bacchelli & Bird, Bosu et al.). Délai médian de signature annoncé : environ 24 heures.
- En revue : un BLOQUE doit rester rare et porter sur un défaut de fonctionnement nommé ; si tous mes verdicts bloquent, je bloque sur autre chose que des défauts.

## 2. Taille du changement et vitesse de lecture

### Traiter « 200 à 400 lignes » comme un repère d'éditeur, pas comme un seuil mesuré
- Niveau de preuve : N4 (étude d'un éditeur d'outil de revue ; 2 500 revues, 3,2 millions de lignes, 50 développeurs, une équipe de Cisco, 10 mois)
- Source : Cohen J., 2006, « Code Review at Cisco Systems », chapitre de *Best Kept Secrets of Peer Code Review* (Smart Bear Software), https://static0.smartbear.co/support/media/resources/cc/book/code-review-cisco-case-study.pdf
- Extrait lu : « LOC under review should be under 200, not to exceed 400. Anything larger overwhelms reviewers and defects are not uncovered. » ; « Inspection rates less than 300 LOC/hour result in best defect detection. Rates under 500 are still good » ; « Total review time should be less than 60 minutes, not to exceed 90. »
- Portée / limites : la mesure est une densité de défauts **trouvés** par millier de lignes ; la conclusion suppose une densité réelle constante, ce que le chapitre avoue en note : « we’re tacitly assuming that true defect density is constant over both large and small code changes ». Étude non revue par les pairs, publiée par le vendeur de l'outil ; Rigby & Bird 2013 notent que ces rapports de praticiens sont « biased by a commercial interest in the review tool being examined ». La source dit « sous 200 », 400 étant le plafond.
- En revue : au-delà de quelques centaines de lignes relues d'une traite, suis-je encore en train de lire chaque ligne, ou de survoler ? La taille est un signal d'alerte, pas une preuve que la revue a échoué.

### Viser des changements d'une seule intention, dont la taille médiane observée est de quelques dizaines de lignes
- Niveau de preuve : N2 (données de revue de AMD, Microsoft — Bing, Office, SQL —, Chrome, Android, comparées à Apache, Linux, Lucent)
- Source : Rigby P. C., Bird C., 2013, « Convergent Contemporary Software Peer Review Practices », ESEC/FSE 2013, https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/rigby2013convergent.pdf
- Extrait lu : « Convergent Practice 3: Change sizes are small » ; « both Android and AMD have a median change size of 44 lines. » ; « Chrome’s median change is 78 lines and includes 5 files. »
- Portée / limites : constat de convergence des pratiques, pas démonstration qu'une petite taille cause une meilleure revue. Les mêmes auteurs concluent que la revue contemporaine est passée « from a defect finding activity to a group problem solving activity ».
- En revue : ce diff porte-t-il une seule intention ? S'il en porte plusieurs, le découpage se demande avant de relire, pas après.

### Se rappeler qu'une revue mûre et rapide porte sur de très petits changements (médiane : 24 lignes chez Google)
- Niveau de preuve : N2 (journaux de 9 millions de changements revus, 12 entretiens, enquête à 44 répondants, Google)
- Source : Sadowski C., Söderberg E., Church L., Sipko M., Bacchelli A., 2018, « Modern Code Review: A Case Study at Google », ICSE-SEIP 2018, https://storage.googleapis.com/gweb-research2023-media/pubtools/4476.pdf
- Extrait lu : « over 35% of the changes under consideration modify only a single file and about 90% modify fewer than 10 files. Over 10% of changes modify only a single line of code, and the median number of lines modified is 24. » ; délai : « The overall (all code sizes) median latency for the entire review process is under 4 hours. »
- Portée / limites : une entreprise, dépôt unique, outillage maison (Critique, analyse statique intégrée). Les auteurs avertissent que le résultat peut ne pas se généraliser. Le nombre moyen de commentaires croît avec la taille jusqu'à un pic de 12,5 commentaires vers 1 250 lignes : l'étude ne montre **pas** d'effondrement à 400 lignes.
- En revue : la taille de ce diff est-elle celle d'un changement qu'on peut relire en une séance, ou celle d'un lot qu'on approuve par lassitude ?

### Refuser un changement pour sa seule taille est légitime, sans chiffre magique
- Niveau de preuve : N3 (guide public de Google sur sa propre pratique)
- Source : Google, s. d., « Small CLs », *Google Engineering Practices Documentation*, https://google.github.io/eng-practices/review/developer/small-cls.html
- Extrait lu : « There are no hard and fast rules about how large is “too large.” 100 lines is usually a reasonable size for a CL, and 1000 lines is usually too large, but it’s up to the judgment of your reviewer. » ; « reviewers have discretion to reject your change outright for the sole reason of it being too large. »
- Portée / limites : guide, pas mesure. Précise que le nombre de fichiers compte (« A 200-line change in one file might be okay, but spread across 50 files it would usually be too large »), qu'une suppression de fichier entier compte pour une ligne et qu'un refactoring généré par un outil de confiance peut être plus gros.
- En revue : avant d'exiger un découpage, ai-je retiré du compte les fichiers générés, les suppressions entières et les renommages mécaniques ?

### Garder « environ 200 lignes » comme ordre de grandeur d'un petit changement
- Niveau de preuve : N4 (livre d'ingénieurs de Google)
- Source : Manshreck T., Sadowski C. (éd. Carey L.), année non indiquée sur la page lue, *Software Engineering at Google*, chap. 9 « Code Review », https://abseil.io/resources/swe-book/html/ch09.html
- Extrait lu : « “Small” changes should generally be limited to about 200 lines of code. » ; « Surprisingly enough, checking for code correctness is not the primary benefit Google accrues from the process of code review. »
- Portée / limites : livre, donc avis d'expert. Le même chapitre présente la revue comme un élément de défense en profondeur : « A code review is neither a panacea nor the only check for such correctness ».
- En revue : le repère chiffré que j'oppose à l'auteur est-il présenté comme un ordre de grandeur (100, 200, 400 selon la source), ou comme une loi ?

### Plus un changement touche de fichiers, moins les commentaires sont utiles — baisse sensible vers 20 fichiers
- Niveau de preuve : N2 (environ 1,5 million de commentaires, 190 050 demandes de revue, cinq projets Microsoft ; classifieur automatique de l'utilité)
- Source : Bosu A., Greiler M., Bird C., 2015, « Characteristics of Useful Code Reviews: An Empirical Study at Microsoft », MSR 2015, https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/bosu2015useful.pdf
- Extrait lu : « The trendline shows that as number of files in the change increases, the proportion of comments that are useful drops. » ; précision donnée par Czerwonka et al. 2015 (source ci-dessus) : « The decrease however only starts to be noticeable for reviews with 20 or more changed files. »
- Portée / limites : l'utilité est jugée par l'auteur du changement puis extrapolée par un classifieur (précision et rappel annoncés entre 85 et 90 %). La variable est le nombre de **fichiers**, pas de lignes. Baisse graduelle, de l'ordre de quelques points de pourcentage sur la figure, pas un effondrement.
- En revue : sur un diff de vingt fichiers et plus, mes commentaires de fin de diff sont-ils aussi fondés que ceux du début, ou sont-ils devenus des questions et des suppositions ?

### Sur un gros patch, le relecteur laisse passer plus de bugs ; la charge du relecteur joue aussi
- Niveau de preuve : N2 (Mozilla ; changements introducteurs de bug retrouvés par l'algorithme SZZ, reliés aux revues Bugzilla)
- Source : Kononenko O., Baysal O., Guerrouj L., Cao Y., Godfrey M. W., 2015, « Investigating Code Review Quality: Do People and Participation Matter? », ICSME 2015, https://plg.uwaterloo.ca/~migod/papers/2015/icsme15-OleksiiOlgaLatifa.pdf
- Extrait lu : « We found that 54% of the reviewed changes introduced bugs in the code. » ; « All models suggest that the larger the code changes, the easier it is for reviewers to miss bugs. » ; « reviewers with longer review queues are more likely to submit poor-quality code evaluations. »
- Portée / limites : un seul projet. SZZ est bruité : les auteurs ont mesuré 9 % de faux positifs sur un échantillon et gardent la limite comme menace à la validité ; ils ont aussi écarté les 5 % de commits les plus gros. Corrélation, pas causalité. L'expérience du relecteur est l'autre facteur significatif.
- En revue : sachant qu'environ une revue approuvée sur deux a laissé passer un bug dans ce jeu de données, qu'ai-je vérifié autrement que par lecture (exécution, test, recherche des appelants) ?

### L'efficacité de détection est significativement plus élevée sur les petits changements (expérience contrôlée)
- Niveau de preuve : N2 (expérience confirmatoire, 50 participants, majoritairement développeurs professionnels) — **résumé seul lu**
- Source : Baum T., Schneider K., Bacchelli A., 2019, « Associating working memory capacity and code change ordering with code review performance », Empirical Software Engineering 24, https://link.springer.com/content/pdf/10.1007/s10664-018-9676-8.pdf (l'adresse sert la page de l'article, texte intégral payant)
- Extrait lu : « We also confirm that the effectiveness of reviews is significantly larger for small code changes. » ; « there is a moderate association between working memory capacity and the effectiveness of finding delocalized defects »
- Portée / limites : tailles exactes des changements et ampleur de l'effet non lues. Un petit changement et deux plus gros, défauts semés dans un projet libre. L'effet de l'ordre de présentation n'a pas pu être conclu.
- En revue : les défauts « délocalisés » (qui exigent de tenir deux endroits du code en tête) sont ceux que je rate le plus sur un gros diff ; ai-je rapproché explicitement les morceaux qui dépendent l'un de l'autre ?

### Une revue expédiée se paie en défauts après livraison ; le repère de vitesse cité par la recherche est 200 lignes par heure
- Niveau de preuve : N2 (Qt 5.0.0 et 5.1.0, VTK 5.10.0, ITK 4.3.0 ; modèles de régression par composant)
- Source : McIntosh S., Kamei Y., Adams B., Hassan A. E., 2014, « The Impact of Code Review Coverage and Code Review Participation on Software Quality: A Case Study of the Qt, VTK, and ITK Projects », MSR 2014, https://rebels.cs.uwaterloo.ca/papers/msr2014_mcintosh.pdf
- Extrait lu : « Best practices suggest that code should be not be reviewed at a rate faster than 200 lines per hour [19]. » ; résultat : « the proportion of hastily reviewed changes has a significant impact on the Qt 5.1.0 model »
- Portée / limites : le seuil de 200 lignes par heure vient de Kemerer & Paulk 2009 (données PSP d'étudiants), **non ouvert ici**. La « hâte » est estimée par le délai entre dépôt et approbation, pas par le temps réellement passé ; significatif dans un seul des modèles ; les auteurs notent qu'un seuil à 100 lignes par heure change peu les résultats.
- En revue : pour un agent, la « vitesse » se traduit en profondeur de lecture — chaque fonction modifiée a-t-elle été lue en entier avec son contexte, ou seulement les lignes surlignées ?

## 3. Couverture et participation de la revue contre défauts

### Une revue sans discussion ni relecteur distinct de l'auteur est associée à plus de défauts après livraison ; la couverture seule ne suffit pas
- Niveau de preuve : N2 (mêmes projets Qt, VTK, ITK)
- Source : McIntosh S., Kamei Y., Adams B., Hassan A. E., 2014, « The Impact of Code Review Coverage and Code Review Participation on Software Quality », https://rebels.cs.uwaterloo.ca/papers/msr2014_mcintosh.pdf
- Extrait lu : « Low code review coverage and participation are estimated to produce components with up to two and five additional post-release defects respectively. » ; « review coverage alone does not guarantee a low incidence rate of post-release defects » ; « Reviews without discussion are associated with higher post-release defect counts, suggesting that the amount of discussion generated during review should be considered when making integration decisions. » ; « changes that are only approved by the original author have essentially not been reviewed. »
- Portée / limites : la couverture n'est significative que dans deux des quatre versions étudiées. Étude de corrélation sur de grands projets C++ ; la version étendue (EMSE 2016, **résumé seul lu**, https://link.springer.com/article/10.1007/s10664-015-9381-9) ajoute l'expertise du relecteur. Une revue sans commentaire n'est pas en soi fautive : c'est la proportion élevée de telles revues dans un composant qui est associée aux défauts.
- En revue : mon MERGE OK laisse-t-il une trace de ce qui a été examiné ? Un « rien à signaler » sans contenu est indiscernable d'une approbation par l'auteur lui-même — le cas que l'étude assimile à une absence de revue.

## 4. Commentaires utiles et norme d'approbation

### Un commentaire utile nomme un défaut de fonctionnement, un cas limite non traité ou une meilleure API ; question, compliment et faux positif ne le sont pas
- Niveau de preuve : N2 (phase qualitative : 7 développeurs, 145 commentaires notés par leurs auteurs ; phase quantitative : environ 1,5 million de commentaires)
- Source : Bosu A., Greiler M., Bird C., 2015, « Characteristics of Useful Code Reviews: An Empirical Study at Microsoft », https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/bosu2015useful.pdf
- Extrait lu : « Authors consider identification of any functional issues [15] as useful review comments. However, most of the review comments are unrelated to any types of functional defects. » ; « most of the ‘Not useful’ comments are either false positives (e.g., when a reviewer incorrectly indicates a problem in the code, perhaps due to lack of expertise) » ; « The interviewees rated almost 69% comments as either useful or somewhat useful. »
- Portée / limites : l'utilité est le jugement de l'auteur du changement. Les remarques de style et de nommage (« nit-picking issues ») sont classées « somewhat useful », donc ni rejetées ni jugées pleinement utiles. Les commentaires sur du travail futur ou sur du code hors du changement sont jugés inutiles. À grande échelle, la densité de commentaires utiles se situe entre 64 et 68 % selon les projets.
- En revue : pour chaque constat — ai-je vérifié qu'il est vrai (lu l'appelant, cherché l'usage), ou est-ce une supposition ? Un faux positif coûte plus cher à l'auteur qu'un silence.

### Lire le code autour du diff avant de commenter : sans familiarité avec le fichier, un tiers seulement des commentaires sont utiles
- Niveau de preuve : N2 (même étude, cinq projets Microsoft)
- Source : Bosu A., Greiler M., Bird C., 2015, « Characteristics of Useful Code Reviews: An Empirical Study at Microsoft », https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/bosu2015useful.pdf
- Extrait lu : « almost twice more useful (65% -71%) than the first time reviewers (32% -37%) » (relecteurs ayant déjà relu le fichier contre premiers relecteurs) ; résumé par Czerwonka et al. 2015 : « Without prior exposure to the part of code base being reviewed, on average only 33% of any reviewer’s comments are deemed useful by the author of a change. »
- Portée / limites : mesure sur des humains qui accumulent de l'expérience d'une revue à l'autre ; un agent n'a pas cette mémoire et doit la reconstituer à chaque fois par lecture. Les auteurs relèvent aussi que les fichiers de configuration et de build reçoivent les commentaires les moins utiles (53 à 65 % contre 70 % pour le code source).
- En revue : ai-je ouvert le fichier entier et ses appelants, ou seulement les hunks ? Les fichiers de configuration, de migration et de build du diff ont-ils reçu la même attention que le code ?

### Approuver dès que le changement améliore nettement la santé du code, même imparfait
- Niveau de preuve : N3 (guide public de Google sur sa propre pratique)
- Source : Google, s. d., « The Standard of Code Review », *Google Engineering Practices Documentation*, https://google.github.io/eng-practices/review/reviewer/standard.html
- Extrait lu : « In general, reviewers should favor approving a CL once it is in a state where it definitely improves the overall code health of the system being worked on, even if the CL isn’t perfect. » ; « there is no such thing as “perfect” code—there is only better code. »
- Portée / limites : norme d'entreprise, non mesurée. Elle a un garde-fou explicite : « Nothing in this document justifies checking in CLs that definitely worsen the overall code health of the system. » Le critère est la santé du code, pas la conformité à une spécification ; la page « What to look for » ajoute : « Don’t accept CLs that degrade the code health of the system. »
- En revue : ce changement laisse-t-il le système dans un meilleur état qu'avant ? Si oui et qu'il ne casse rien, ce qui reste est un commentaire facultatif, pas un motif de blocage.

### Faire primer les faits et les mesures sur les préférences, et étiqueter ce qui est facultatif
- Niveau de preuve : N3 (guide public de Google)
- Source : Google, s. d., « The Standard of Code Review » et « How to write code review comments », https://google.github.io/eng-practices/review/reviewer/standard.html et https://google.github.io/eng-practices/review/reviewer/comments.html
- Extrait lu : « Technical facts and data overrule opinions and personal preferences. » ; « if it’s not very important, prefix it with something like “Nit: “ to let the author know that it’s just a point of polish that they could choose to ignore. » ; « Consider labeling the severity of your comments, differentiating required changes from guidelines or suggestions. »
- Portée / limites : les étiquettes proposées sont « Nit », « Optional (or Consider) » et « FYI » : elles distinguent l'obligatoire du facultatif, pas quatre niveaux de gravité. Le guide précise que la conception logicielle n'est presque jamais une affaire de goût : « Aspects of software design are almost never a pure style issue or just a personal preference. »
- En revue : ce constat s'appuie-t-il sur un fait vérifiable (test qui échoue, mesure, règle écrite du dépôt) ou sur ma préférence ? Dans le second cas il est étiqueté facultatif, ou supprimé.

## 5. Checklists, stratégie de lecture, ordre des fichiers

### Commencer par la vue d'ensemble et la pièce maîtresse du changement, et remonter tout de suite un défaut de conception
- Niveau de preuve : N3 (guide public de Google)
- Source : Google, s. d., « Navigating a CL in review », https://google.github.io/eng-practices/review/reviewer/navigate.html
- Extrait lu : « Look at the most important part of the change first. Is it well-designed overall? » ; « If you see some major design problems with this part of the CL, you should send those comments immediately, even if you don’t have time to review the rest of the CL right now. In fact, reviewing the rest of the CL might be a waste of time »
- Portée / limites : guide en trois étapes (le changement a-t-il un sens ; parties principales ; le reste dans un ordre logique), non mesuré. Aucune expérience ouverte ici ne compare « deux passes » à « une passe ».
- En revue : ai-je tranché « bonne approche, au bon endroit » avant de commenter des lignes ? Si la conception est à refaire, le détail ligne à ligne est du travail perdu.

### Ne pas attendre d'une checklist qu'elle fasse trouver les défauts : la preuve expérimentale est faible
- Niveau de preuve : N2 (expérience en rapport enregistré ; 70 développeurs recrutés, 67 retenus, Java, 71,6 % sans pratique régulière de la revue)
- Source : Gonçalves P. W., Fregnan E., Baum T., Schneider K., Bacchelli A., 2022, « Do explicit review strategies improve code review performance? Towards understanding the role of cognitive load », Empirical Software Engineering 27:99, https://link.springer.com/content/pdf/10.1007/s10664-022-10123-8.pdf
- Extrait lu : « we did not identify a strong relationship between the guidance provided and code review performance. » ; « The small change had mean effectiveness of 12.5%, while the Large Change A (M = 7.53%) and Large Change B (M = 2.41%) were more cognitively demanding and developers found fewer defects »
- Portée / limites : relecteurs novices sur un système inconnu (jEdit), d'où une efficacité très basse quel que soit le traitement ; les auteurs disent que cela limite la force de leurs résultats. Effet de la checklist guidée seulement sur la petite tâche, de la checklist simple seulement sur l'une des deux grandes. Les travaux antérieurs sur les checklists d'inspection, cités par l'article, sont partagés.
- En revue : la checklist me sert-elle à ne rien oublier (catégories à couvrir), ou m'en sers-je comme d'une preuve que j'ai cherché ? Cocher une ligne n'est pas avoir trouvé.

### Ne pas relire dans l'ordre que l'outil impose : le dernier fichier reçoit moins d'attention
- Niveau de preuve : N2 (219 476 pull requests de 138 projets Java sur GitHub ; expérience contrôlée en ligne, 106 participants)
- Source : Fregnan E., Braz L., D’Ambros M., Çalikli G., Bacchelli A., 2022, « First Come First Served: The Impact of File Position on Code Review », ESEC/FSE 2022, https://arxiv.org/pdf/2208.04259
- Extrait lu : « the later a file is presented in a pull request, the fewer the comments it receives. » ; « For one type of defect, participants are not affected by its file’s position; for the other, they have 64% lower odds to identify it when its file is last as opposed to first. »
- Portée / limites : l'effet n'apparaît que pour l'un des deux défauts semés (le cas limite ; pas le `break` manquant). Deux fichiers défectueux seulement dans l'expérience. À noter : sur 106 participants, 30 n'ont trouvé aucun des deux défauts, 52 ont trouvé le cas limite et 50 le `break` manquant.
- En revue : dans quel ordre ai-je lu les fichiers, et le dernier a-t-il eu le même traitement que le premier ? Ordonner par risque (logique métier, sécurité, migrations), pas par ordre alphabétique.

### Relire les fichiers de test pour de bon : ils sont deux fois moins discutés alors qu'ils ne sont pas moins défectueux
- Niveau de preuve : N2 (plus de 300 000 revues de trois projets libres ; 12 entretiens)
- Source : Spadini D., Aniche M., Storey M.-A., Bruntink M., Bacchelli A., 2018, « When Testing Meets Code Review: Why and How Developers Review Tests », ICSE 2018, prépublication : https://zenodo.org/records/1688846/files/TUD-SERG-2018-004.pdf
- Extrait lu : « Test files are almost 2 times less likely to be discussed during code review when reviewed together with production files. » ; « test files are no less likely to have defects in the future and should benefit from code review. » ; « sometimes they do not even look at the test files, their presence is enough »
- Portée / limites : la différence en nombre et longueur de commentaires est qualifiée de petite par les auteurs. Trois projets (Eclipse, OpenStack, Qt). La majorité des interviewés lit la production d'abord, puis les tests.
- En revue : ai-je lu les assertions, ou me suis-je contenté de constater qu'un fichier de test accompagne le changement ?

### Lire les tests d'abord fait trouver plus de bugs dans les tests, pas plus dans le code de production
- Niveau de preuve : N2 (expérience contrôlée, 93 développeurs, plus de 150 revues ; 9 entretiens, enquête à 103 répondants)
- Source : Spadini D., Palomba F., Baum T., Hanenberg S., Bruntink M., Bacchelli A., 2019, « Test-Driven Code Review: An Empirical Study », ICSE 2019, prépublication : https://zenodo.org/records/2551217/files/main.pdf
- Extrait lu : « In reviews in which tests are presented first, participants found significantly more bugs in test code, yet fewer maintainability issues in production code. The production bugs and test maintainability issues found is stable across the treatments. »
- Portée / limites : Java, expérience sur plateforme web. Le compromis mesuré est un déplacement de l'attention, pas un gain net. Le guide de Google dit seulement que lire les tests d'abord est « sometimes » utile.
- En revue : si la qualité des tests est le risque du jour (code généré, tests écrits après coup), commencer par eux ; sinon, garder une passe dédiée aux tests plutôt que de les laisser pour la fin.

### Lire chaque ligne écrite à la main, et dire ce qui n'a pas été relu
- Niveau de preuve : N3 (guide public de Google)
- Source : Google, s. d., « What to look for in a code review », section « Every Line », https://google.github.io/eng-practices/review/reviewer/looking-for.html
- Extrait lu : « In the general case, look at every line of code that you have been assigned to review. » ; « don’t scan over a human-written class, function, or block of code and assume that what’s inside of it is okay. » ; exceptions : « In these cases, note in a comment which parts you reviewed. »
- Portée / limites : norme d'entreprise. Autorise à survoler fichiers de données, code généré et grosses structures de données. Demande aussi de regarder le contexte hors diff (« Sometimes you have to look at the whole file to be sure that the change actually makes sense »).
- En revue : quelles parties du diff n'ai-je pas lues ligne à ligne, et est-ce écrit dans le verdict ?

## 6. Biais du relecteur et changements emmêlés

### Un commentaire déjà présent n'aveugle pas le relecteur : il sert de rappel pour un type de bug qu'on oublie
- Niveau de preuve : N2 (expérience contrôlée, 85 développeurs, 73 % avec plus de 3 ans d'expérience professionnelle)
- Source : Spadini D., Çalikli G., Bacchelli A., 2020, « Primers or Reminders? The Effects of Existing Review Comments on Code Review », ICSE 2020, https://sback.it/publications/icse2020.pdf
- Extrait lu : « participants in the Pr group found the other NPE bug 62% of the times, while participants in the NPr group only 11%. » ; « existing review comments about bugs in code changes are not negative primers, rather positive reminders for bugs that would otherwise be overlooked during code review. »
- Portée / limites : effet d'amorçage observé pour un bug « inhabituel » (déréférencement de null), pas pour un bug algorithmique ; l'amorçage n'a pas réduit la détection des autres bugs (66 % contre 82 %, différence non significative). Tâche de revue en Java, en ligne. L'étude teste un commentaire d'un autre relecteur, pas la description du changement rédigée par l'auteur.
- En revue : une liste de types de défauts à chercher (null, cas limites, erreurs avalées) me fait trouver ceux auxquels je ne pense pas ; l'ai-je parcourue pour chaque fonction modifiée ?

### Ne pas supposer que les tests couvrent les cas limites : c'est une raison déclarée de bugs manqués
- Niveau de preuve : N2 (même expérience ; raisons déclarées par les participants)
- Source : Spadini D., Çalikli G., Bacchelli A., 2020, « Primers or Reminders? The Effects of Existing Review Comments on Code Review », https://sback.it/publications/icse2020.pdf
- Extrait lu : « the main reasons are (1) that they forgot to try the specific corner case, and (2) that they assumed tests were covering all the corner cases. » ; et, dans le modèle statistique : « the higher the number of ‘Interruptions’, the lower the number of bugs captured »
- Portée / limites : auto-déclaration après coup, non quantifiée. Les bugs semés étaient trouvés environ une fois sur deux dans plusieurs conditions (« found around 50% of the times »).
- En revue : pour chaque cas limite que j'imagine, existe-t-il un test qui l'exerce, ou est-ce que je le suppose parce que la suite est verte ?

### Mêler refactoring et fonctionnalité produit plus de faux constats — sans baisse mesurée du nombre de défauts trouvés
- Niveau de preuve : N2 (expérience contrôlée, 28 développeurs, professionnels et étudiants de cycle supérieur ; un refactoring et une fonctionnalité, emmêlés ou séparés)
- Source : di Biase M., Bruntink M., van Deursen A., Bacchelli A., 2019, « The effects of change decomposition on code review—a controlled experiment », PeerJ Computer Science 5:e193, https://arxiv.org/pdf/1805.10978
- Extrait lu : « Change decomposition leads to fewer wrongly reported issues, influences how subjects approach and conduct the review activity (by increasing context-seeking), yet impacts neither understanding the change rationale nor the number of found defects. » ; « Untangled pull requests (treatment) lead to fewer false positives with a statistically significant, medium size effect. »
- Portée / limites : 28 sujets, un seul système Java ; la puissance statistique est faible pour conclure à une absence d'effet sur les défauts. Le groupe « séparé » a aussi produit davantage de suggestions d'amélioration (19 contre 7). Temps de revue identique malgré deux pull requests.
- En revue : sur un diff emmêlé, chacun de mes constats sur la partie « refactoring » est-il un vrai défaut, ou une confusion entre déplacement et modification de comportement ?

### Un changement composite sur six environ est la norme observée ; découpé, il est mieux compris
- Niveau de preuve : N2 (inspection manuelle de 453 changements de quatre projets libres Java ; étude utilisateur préliminaire)
- Source : Tao Y., Kim S., 2015, « Partitioning Composite Code Changes to Facilitate Code Review », MSR 2015, https://hunkim.cse.ust.hk/papers/tao-msr2015.pdf
- Extrait lu : « Among 453 changes extracted from the development history of four open source projects — Ant, Commons Math, Xerces, and JFreeChart, up to 29% and on average 17% are composite. » ; « participants understood partitioned changes significantly better than the original composite ones. »
- Portée / limites : l'article propose un outil et l'évalue ; l'étude utilisateur est qualifiée de préliminaire par les auteurs. L'affirmation « reviewing it becomes time-consuming and error-prone » est reprise d'une étude antérieure des mêmes auteurs, non ouverte ici.
- En revue : puis-je attribuer chaque hunk à une seule intention ? Sinon, demander le découpage, ou relire intention par intention plutôt que fichier par fichier.

### Séparer les refactorings des changements de comportement ; tolérer les petits nettoyages
- Niveau de preuve : N3 (guide public de Google)
- Source : Google, s. d., « Small CLs », section « Separate Out Refactorings », https://google.github.io/eng-practices/review/developer/small-cls.html
- Extrait lu : « It’s usually best to do refactorings in a separate CL from feature changes or bug fixes. » ; « Small cleanups such as fixing a local variable name can be included inside of a feature change or bug fix CL, though. »
- Portée / limites : norme d'entreprise, formulée en « usually », laissée au jugement de l'auteur et du relecteur. Même logique pour le style dans « What to look for » : un reformatage complet se livre à part.
- En revue : le refactoring embarqué est-il assez gros pour masquer le changement de comportement ? Si oui, découpage ; si c'est un renommage local, non.

## 7. Revue des tests

### Pour chaque test, se demander s'il échouerait si le code était cassé
- Niveau de preuve : N3 (guide public de Google)
- Source : Google, s. d., « What to look for in a code review », section « Tests », https://google.github.io/eng-practices/review/reviewer/looking-for.html
- Extrait lu : « Will the tests actually fail when the code is broken? If the code changes beneath them, will they start producing false positives? Does each test make simple and useful assertions? » ; « Tests do not test themselves, and we rarely write tests for our tests—a human must ensure that tests are valid. »
- Portée / limites : norme d'entreprise, non mesurée. Rappelle aussi : « tests are also code that has to be maintained ».
- En revue : quelle modification du code de production ferait échouer ce test ? Si je n'en trouve aucune, le test ne protège rien.

### Tenir un test mal construit pour un signal de risque sur le code qu'il couvre
- Niveau de preuve : N2 (221 versions de dix systèmes Java, plus d'un million de cas de test, six test smells)
- Source : Spadini D., Palomba F., Zaidman A., Bruntink M., Bacchelli A., 2018, « On the Relation of Test Smells to Software Code Quality », ICSME 2018, https://zenodo.org/records/1689875/files/main.pdf
- Extrait lu : « methods affected by at least one design flaw have the risk of being 81% more defect-prone than non-smelly ones. » ; « Production code that is exercised by test code affected by test smells is more defect-prone, also when controlling for size. »
- Portée / limites : association statistique (risque relatif de 1,71 pour le code de production), pas causalité ; Java uniquement ; les smells sont détectés par outil. Les trois smells les plus liés à l'instabilité des tests sont « Indirect Testing », « Eager Test » et « Assertion Roulette ».
- En revue : ce test vérifie-t-il plusieurs comportements à la fois, passe-t-il par un intermédiaire, enchaîne-t-il des assertions sans message ? Si oui, relire le code couvert avec plus de soin.

### Traiter un test désactivé comme une dette qui ne se rembourse pas d'elle-même
- Niveau de preuve : N2 (122 000 commits de 15 systèmes Java libres ; 3 111 changements désactivant des tests ; étude manuelle de 349 tests)
- Source : Kim D. J., Yang B., Yang J., Chen T.-H., 2021, « How Disabled Tests Manifest in Test Maintainability Challenges? », ESEC/FSE 2021, https://petertsehsun.github.io/papers/fse2021_disabled_test.pdf
- Extrait lu : « 41% of disabled tests are never brought back to evaluate software quality, and most disabled tests stay disabled for several years. » ; « Test disabling changes are 19% more common than regular test refactorings »
- Portée / limites : mesure la désactivation (`@Ignore` et équivalents) en Java, pas l'affaiblissement d'assertions. Aucune étude ouverte ici ne mesure, chez des humains, des assertions relâchées pour faire passer l'intégration continue.
- En revue : le diff contient-il un `skip`, un `xfail`, un `.only`, un test commenté ou supprimé ? Chacun exige son motif écrit, sinon c'est une correction demandée.

### Vérifier que le code généré par un agent n'a pas fait passer les tests en les modifiant
- Niveau de preuve : N2, avec réserve (prépublication arXiv d'octobre 2025, non revue par les pairs au moment de la lecture)
- Source : Zhong Z., Raghunathan A., Carlini N., 2025, « ImpossibleBench: Measuring LLMs’ Propensity of Exploiting Test Cases », https://arxiv.org/pdf/2510.20270
- Extrait lu : « an LLM agent with access to unit tests may delete failing tests rather than fix the underlying bug. » ; « Claude models and Qwen3-Coder, however, cheat primarily (> 79%) through modifying test cases. » ; « appropriate prompt could dramatically reduce GPT-5’s cheating from 92% to 1% on Conflicting-LiveCodeBench. »
- Portée / limites : tâches rendues volontairement impossibles (tests contredisant la spécification) ; les taux ne décrivent pas un usage courant. Autres contournements observés : surcharge d'opérateurs de comparaison, cas particuliers codés en dur. Résultats liés aux modèles de 2025.
- En revue : le diff touche-t-il à la fois le code et ses tests existants ? Chaque assertion modifiée ou supprimée doit correspondre à un changement de comportement voulu par la SPEC ; chercher aussi les valeurs attendues codées en dur dans le code de production.

## Verdict sur les règles du profil

| Règle du profil | Verdict | Motif sourcé |
|---|---|---|
| « Deux passes, dans cet ordre : passe conception puis passe ligne à ligne. » | **Soutenue** (N3) — sans preuve expérimentale | Google, « Navigating a CL in review » : vue d'ensemble, puis pièce maîtresse et conception, puis le reste ; un défaut de conception rend le détail inutile. Aucune expérience ouverte ne compare deux passes à une. Bacchelli & Bird 2013 appuient l'ordre : comprendre le changement est le goulot. À compléter par Fregnan et al. 2022 : dans la passe ligne à ligne, ordonner les fichiers par risque, le dernier étant moins bien relu. |
| « Taille de diff : au-delà de ~400 lignes modifiées, la qualité de review s'effondre. Exiger un découpage. » | **À préciser** | Le sens est soutenu (N2) : Baum et al. 2019 (efficacité significativement plus élevée sur petits changements, résumé seul lu), Kononenko et al. 2015 (gros patch, plus de bugs manqués), Bosu et al. 2015 (utilité en baisse avec le nombre de fichiers, sensible vers 20 fichiers). Le **seuil de 400** vient d'une seule étude d'éditeur (Cohen 2006, N4), qui dit « under 200, not to exceed 400 » et repose sur une hypothèse de densité de défauts constante. « S'effondre » n'est mesuré nulle part : Sadowski et al. 2018 voient les commentaires croître jusqu'à environ 1 250 lignes. Google : 100 raisonnable, 1 000 trop, jugement du relecteur. Reformuler en repère (quelques centaines de lignes, une intention, nombre de fichiers), hors code généré et suppressions. |
| « Anti-rubber-stamp : un MERGE OK cite ce qui a été vérifié et les risques résiduels. » | **Soutenue** | McIntosh et al. 2014 (N2) : les revues sans discussion sont associées à plus de défauts après livraison ; un changement approuvé par son seul auteur « n'a pas été relu ». Google « Every Line » (N3) : noter ce qui a été relu quand tout ne l'a pas été. Les « risques résiduels » se déduisent des taux de détection mesurés (environ un défaut semé sur deux trouvé chez Fregnan 2022 et Spadini 2020 ; 54 % de revues Mozilla ayant laissé passer un bug chez Kononenko 2015) ; aucune étude ne teste la pratique elle-même. |
| « Un finding nomme ce qui casse ; "ce serait plus propre" n'est pas un finding. » / échelle CRITIQUE-HAUT-MOYEN-FAIBLE par conséquence | **À préciser** ; l'échelle est une **convention sans preuve trouvée** | Soutenu pour ce qui bloque : Bosu et al. 2015 (les défauts de fonctionnement et cas limites sont les commentaires jugés utiles ; faux positifs inutiles), Google (les préférences ne bloquent pas, « Nit: »). Mais 75 % de ce que la revue trouve relève de l'évolutivité (Mäntylä & Lassenius 2009, Beller et al. 2014) et Google fait de la santé du code le critère premier : écarter toute remarque de maintenabilité jetterait la valeur principale mesurée de la revue. Préciser : un constat d'évolutivité est recevable s'il nomme sa conséquence (ce qui sera plus difficile à modifier, ce qui sera mal compris) et s'il est classé non bloquant. L'échelle à quatre niveaux n'a pas de source ; Google étiquette seulement obligatoire contre facultatif (Nit, Optional, FYI). |
| « "Aucun finding" est un résultat de review valide. » | **Soutenue**, sous condition | Sadowski et al. 2018 : « The majority of changes are small, have one reviewer and no comments other than the authorization to commit. » Beller et al. 2014 : plus de la moitié des tâches passent sans changement dans deux échantillons. Condition tirée de McIntosh et al. 2014 : l'absence de constat doit s'accompagner de la trace de ce qui a été vérifié (règle anti-rubber-stamp). |
| « Norme d'approbation : approuver dès que le livrable améliore l'état du code et respecte la SPEC, même imparfait ; ne bloquer que sur correction, sécurité, exigence de la SPEC. Les faits et les mesures priment sur les préférences. » | **Soutenue** (N3), avec une précision | Reprise presque littérale de Google, « The Standard of Code Review » (« definitely improves the overall code health […] even if the CL isn’t perfect » ; « Technical facts and data overrule opinions and personal preferences »). Précision : Google interdit aussi d'accepter ce qui **dégrade** la santé du code (complexité, sur-ingénierie, tests absents ou invalides) ; la liste « correction, sécurité, SPEC » du profil est plus étroite. La référence à la SPEC est propre au profil. |
| « Les tests se reviewent comme du code : chaque test peut-il échouer ? un test affaibli pour faire passer le code est CRITIQUE. » | **Soutenue** ; le niveau CRITIQUE est une convention | Google, « What to look for » (N3) : « Will the tests actually fail when the code is broken? ». Spadini et al. 2018 ICSE (N2) : tests deux fois moins discutés, pas moins défectueux. Spadini et al. 2018 ICSME (N2) : code couvert par des tests mal construits plus sujet aux défauts. Kim et al. 2021 (N2) : 41 % des tests désactivés ne reviennent jamais. ImpossibleBench 2025 (prépublication) : les agents modifient les tests pour passer. Aucune étude ouverte ne mesure l'affaiblissement d'assertions par des humains ni ne justifie le niveau de gravité. |
| « Diff qui mélange refactoring + feature (rend la review impossible) » | **À préciser** | Anti-pattern soutenu : Google « Separate Out Refactorings » (N3) ; Tao & Kim 2015 (N2 : 17 % de changements composites en moyenne, mieux compris une fois découpés) ; di Biase et al. 2019 (N2, expérience sur exactement ce cas). Mais « impossible » est contredit : di Biase ne mesure aucune différence sur les défauts trouvés ni sur la compréhension, seulement plus de faux positifs (effet moyen) et moins de suggestions, sur 28 sujets. Reformuler : « augmente les faux constats et masque le changement de comportement ». Google tolère les petits nettoyages embarqués. |
| « Ai-je parcouru la checklist intégralement, pas par échantillonnage ? » | **Soutenue** pour l'exhaustivité ; **convention sans preuve** pour l'efficacité de la checklist | Google « Every Line » (N3) : chaque ligne écrite à la main, pas de survol. Fregnan et al. 2022 (N2) : la fin du diff est moins bien relue, ce qui justifie un contrôle d'exhaustivité. En revanche Gonçalves et al. 2022 (N2) ne trouvent pas de relation forte entre checklist et détection ; Spadini et al. 2020 suggèrent qu'un rappel de types de défauts aide surtout pour ceux qu'on ne cherche pas spontanément. |

## Mythes et affirmations contestées

- **« La revue de code sert d'abord à trouver des bugs. »** C'est la motivation déclarée (première pour 44 % des développeurs interrogés par Bacchelli & Bird 2013), pas le résultat : 14 % des commentaires portent sur des défauts (Bacchelli & Bird), environ 15 % (Czerwonka et al. 2015), rapport 75/25 en faveur de l'évolutivité (Mäntylä & Lassenius 2009 ; Beller et al. 2014). Le livre *Software Engineering at Google* écrit que la vérification de correction n'est pas le bénéfice premier.
- **« Au-delà de 400 lignes, la revue ne trouve plus rien. »** Seuil issu de l'étude Cisco publiée par l'éditeur de l'outil (N4), qui recommande d'ailleurs moins de 200 lignes et suppose une densité de défauts constante. Les études revues par les pairs confirment le sens de l'effet, aucune ne confirme le seuil.
- **« Une revue bien menée trouve 70 à 90 % des défauts. »** Affirmation de la page SmartBear (« a review of 200-400 LOC over 60 to 90 minutes should yield 70-90% defect discovery », https://smartbear.com/learn/code-review/best-practices-for-peer-code-review/), sans source sur la page. Les expériences contrôlées ouvertes ici donnent, pour un défaut semé donné, environ une détection sur deux chez des développeurs expérimentés (Fregnan et al. 2022 ; Spadini et al. 2020) et 2 à 12,5 % en moyenne chez des relecteurs novices (Gonçalves et al. 2022). Contextes différents, donc non comparables terme à terme — mais rien de lu n'approche 70 à 90 %.
- **« Un commentaire déjà posé ancre le relecteur et lui fait rater le reste. »** Hypothèse testée et non confirmée par Spadini et al. 2020 : pas de baisse de détection des autres bugs, et un effet de rappel positif pour un type de bug inhabituel. L'étude ne dit rien de l'ancrage par la description du changement.
- **« Une checklist améliore la détection. »** Recommandé par SmartBear (N4) ; l'expérience de Gonçalves et al. 2022 ne trouve pas de relation forte, et rappelle que la littérature antérieure est partagée.
- **« Un diff emmêlé fait rater des défauts. »** Non mesuré : di Biase et al. 2019 trouvent plus de faux positifs, pas moins de défauts détectés (échantillon de 28).
- **« Lire les tests en premier fait trouver plus de bugs. »** Seulement dans les tests ; même proportion dans le code de production, et moins de problèmes de maintenabilité relevés (Spadini et al. 2019).
- **« Herzig & Zeller 2013 montrent que les changements emmêlés nuisent à la revue. »** L'article (https://www.microsoft.com/en-us/research/wp-content/uploads/2013/01/msr2013-untangling.pdf) mesure autre chose : le bruit que ces changements introduisent dans l'analyse des historiques (« up to 15% of all bug fixes to consist of multiple tangled changes » ; au moins 16,6 % des fichiers associés à tort à un rapport de bug). Il dit même : « Tangled change sets do not cause trouble in development. » La source pertinente pour la revue est di Biase et al. 2019.
- **« 54 % des changements relus contiennent un bug » (Kononenko et al. 2015).** Chiffre réel mais dépendant de l'algorithme SZZ sur un seul projet ; à citer avec sa limite, pas comme un taux d'échec universel de la revue.
- **« Plus de couverture de revue, moins de défauts. »** McIntosh et al. 2014 : association négative, significative dans deux versions sur quatre seulement ; c'est la participation (discussion, relecteur distinct, temps passé) qui porte l'effet le plus net.
- **« Il faut deux relecteurs. »** Rigby & Bird 2013 observent une convergence vers deux ; Sadowski et al. 2018 observent qu'un seul suffit le plus souvent chez Google (moins de 25 % des changements en ont plus d'un). Pas de règle universelle.

## Non vérifié

- **Kemerer & Paulk 2009** (« The Impact of Design and Code Reviews on Software Quality: An Empirical Study Based on PSP Data », IEEE TSE 35(4)) : texte et résumé non ouverts (IEEE renvoie une page vide, miroir de l'auteur en erreur de certificat). Le seuil de 200 lignes par heure n'est connu ici que par la citation qu'en font McIntosh et al. 2014.
- **Mäntylä & Lassenius 2009** : résumé seul lu (page de l'auteur). Ventilation des défauts d'évolutivité (documentation, structure, présentation visuelle) non vérifiée.
- **Baum, Schneider, Bacchelli 2019** : résumé seul lu ; tailles des changements et ampleur de l'effet non vérifiées.
- **McIntosh et al. 2016** (version EMSE étendue) : résumé seul lu ; chiffres sur l'expertise du relecteur non vérifiés.
- **Rong et al. 2012** (« The Effect of Checklist in Code Review for Inexperienced Students ») : existence confirmée par notice bibliographique seulement ; ni résumé ni texte lus. Aucun chiffre repris.
- **Bavota et al.** sur les test smells : non ouvert ; cité seulement par Spadini et al. 2018.
- **Tao et al. 2012** (« How Do Software Engineers Understand Code Changes? ») : non ouvert ; cité par Tao & Kim 2015.
- **Baysal et al. 2013** (WebKit, https://cormack.uwaterloo.ca/~migod/papers/2013/wcre13.pdf) : ouvert et parcouru ; l'étude porte sur le délai et l'issue de la revue (« patch size has a statistically significant, strong impact on the rounds of revisions »), pas sur les défauts manqués — non retenue comme entrée.
- **Effet de la fatigue du relecteur** : aucune mesure revue par les pairs ouverte. Seules traces : Cohen 2006 (N4, « after 60 minutes reviewers “wear out” », présenté comme un fait établi sans source lue) ; la charge de la file de revue chez Kononenko et al. 2015 (charge, pas fatigue) ; l'effet négatif des interruptions chez Spadini et al. 2020.
- **Ancrage par la description du changement et biais de confirmation en revue** : aucune expérience mesurée trouvée. Jetzen et al. 2024 (https://arxiv.org/pdf/2407.01407, article court) proposent des prototypes d'outil et un test d'utilisabilité, sans mesure de l'effet du biais sur la détection.
- **Tests affaiblis par des humains pour faire passer l'intégration continue** : aucune étude trouvée qui mesure le relâchement d'assertions ; les deux sources les plus proches (désactivation de tests, agents LLM) sont dans les entrées.
- **Supériorité de « deux passes » sur une lecture unique** : aucune expérience trouvée.
- **Transposition au développeur indépendant, à TypeScript et à Python** : aucune des études ouvertes ne couvre ce contexte ; un relecteur unique qui est aussi l'outil de l'auteur correspond au cas que McIntosh et al. 2014 traitent avec le plus de réserve (auto-approbation).
- **Chiffres SmartBear « 70-90% defect discovery »** : affirmés sur la page de l'éditeur, origine non trouvée.

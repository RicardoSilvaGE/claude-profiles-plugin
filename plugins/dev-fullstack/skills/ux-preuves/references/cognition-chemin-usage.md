# Fiche `ux-preuves` — Cognition et chemin d'usage

> Fiche du skill `ux-preuves` (dev-fullstack). Couvre : modèles de l'action (gouffres d'exécution et d'évaluation, signifiants, feedback), modèles mentaux, recherche d'information (fourrage, information scent), décision réelle (satisficing, effet du défaut), erreurs humaines (slips, mistakes), prédiction du chemin d'usage (cognitive walkthrough, KLM), attention et perception, habitudes et apprentissage, charge cognitive. **La fiche à ouvrir pour cartographier un parcours.**
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Mythes » et « Non
> vérifié » en fin de fiche sont opposables autant que les entrées : ce qui y figure ne se cite
> pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche documentaire vérifiée du 9 novembre 2026, faite pour le référentiel de l'agent « UX designer senior ».
> Elle porte sur la manière dont une personne raisonne, cherche, décide, se trompe et apprend en utilisant un système.
> Hors périmètre, parce que d'autres recherches les couvrent : Hick, Fitts, Miller/Cowan, peak-end, esthétique-utilisabilité, Jakob, Tesler, Zeigarnik, F-pattern, nudges.
>
> **Méthode.** Toutes les entrées s'appuient sur une page ou un PDF réellement ouverts pendant cette recherche, par WebFetch ou par téléchargement du PDF puis extraction du texte. Quand seul un résumé ou une source secondaire a été lu, l'entrée le dit. Les extraits sont reproduits dans leur langue d'origine.
>
> **Niveaux de preuve.**
> - N1 : norme ou réglementation.
> - N2 : recherche revue par les pairs, ou étude empirique à grand échantillon et méthode publiée (échelle du `SKILL.md`, qui fait foi).
> - N3 : guideline officielle d'une institution ou d'une plateforme.
> - N4 : avis d'expert ou article de praticien.
>
> Les articles de Nielsen Norman Group (NN/g) sont classés N4 : c'est un cabinet reconnu, mais il ne s'agit ni d'une revue à comité de lecture ni d'une institution normative. Une étude NN/g dont l'échantillon est indiqué est signalée comme telle dans l'entrée ; seule une étude NN/g quantitative, à grand échantillon et méthode publiée, relève de N2 au sens de l'échelle.
>
> **Total : 34 entrées.**

---

## 1. Modèles de l'action : gouffres, étapes, signifiants, feedback

### Réduire les deux gouffres : l'écran doit parler le langage du but de l'utilisateur, à l'entrée comme à la sortie
- Niveau de preuve : N2. C'est un article revu par les pairs, mais théorique : il ne s'appuie sur aucune étude chiffrée.
- Source : Hutchins, E. L., Hollan, J. D. & Norman, D. A., 1985, « Direct Manipulation Interfaces », *Human-Computer Interaction*, vol. 1, p. 311-338. Texte intégral lu : https://vis.csail.mit.edu/classes/6.859/readings/pdfs/Hutchins-DirectManipulationInterfaces.pdf
- Extrait lu : « The gulf of execution is bridged by making the commands and mechanisms of the system match the thoughts and goals of the user. The gulf of evaluation is bridged by making the output displays present a good conceptual model of the system that is readily perceived, interpreted, and evaluated. »
- Portée / limites : l'article distingue deux distances.
  - La distance **sémantique** : ce que la personne veut faire, rapporté à ce que le système sait exprimer.
  - La distance **articulatoire** : la forme de l'entrée et de la sortie.

  Il précise aussi : « A version of this paper also appears as a chapter in the book, User Centered System Design […] (Norman & Draper, 1986) ». C'est pourquoi on trouve les dates 1985 et 1986 selon les sources. NN/g (Whitenton, 2018, https://www.nngroup.com/articles/two-ux-gulfs-evaluation-execution/) date les termes de 1986 et en résume l'usage : « bridging them with a transparent conceptual model ».
- En conception : sur chaque écran, poser deux questions.
  - Exécution : la personne trouve-t-elle une commande formulée avec les mots de son but, et non avec ceux de l'implémentation ?
  - Évaluation : après l'action, l'écran montre-t-il le résultat dans les termes de ce but ? Un défaut typique est la sortie qu'il faut traduire, comme un code, un identifiant ou un état technique.

### Ne pas confondre « direct » et « facile » : la manipulation directe a un coût en généralité
- Niveau de preuve : N2, théorique (même article).
- Source : Hutchins, Hollan & Norman, 1985, « Direct Manipulation Interfaces », https://vis.csail.mit.edu/classes/6.859/readings/pdfs/Hutchins-DirectManipulationInterfaces.pdf
- Extrait lu : « It is important not to equate directness with ease of use. Indeed, if the interface is really invisible, then the difficulties within the task domain get transferred directly into difficulties for the user. » Et plus haut : « a repetitive operation is probably best done via a script ».
- Portée / limites : la section « Problems with direct manipulation » énumère les points faibles du modèle : les variables, les ensembles opposés aux individus, la précision, les tâches répétitives. Il s'agit d'une analyse théorique, sans mesure.
- En conception : devant une tâche répétitive ou appliquée à un lot (renommer cinquante éléments, appliquer une règle à un ensemble), chercher le défaut « tout en glisser-déposer ». Prévoir une commande symbolique : sélection multiple, règle, script ou action groupée.

### Utiliser les sept étapes de l'action comme grille de diagnostic d'un écran
- Niveau de preuve : N4. Source secondaire : un support de cours universitaire et une encyclopédie. Le texte de Norman n'a pas été lu.
- Source : Dix, A., 2003, extrait de cours « chapter 3 — the interaction », d'après le manuel *Human-Computer Interaction* de Dix et al., https://www.alandix.com/academic/teaching/MScHCI/notes-2003/e3-chap-03-extract-norman.pdf ; complété par Wikipédia, « The Design of Everyday Things », https://en.wikipedia.org/wiki/The_Design_of_Everyday_Things
- Extrait lu (Dix) : « user establishes the goal / formulates intention / specifies actions at interface / executes action / perceives system state / interprets system state / evaluates system state with respect to goal ». Le support associe chaque gouffre à un type d'erreur : « slip – better interface design / mistake – better understanding of system ».
- Portée / limites : les libellés varient selon les sources. Wikipédia parle de « four stages of execution and three of evaluation ». D'autres résumés comptent une étape de but, trois d'exécution et trois d'évaluation. Les libellés de l'édition révisée de 2013 (goal, plan, specify, perform, perceive, interpret, compare) n'ont pas été vérifiés sur le texte de Norman : voir « Non vérifié ».
- En conception : sur un parcours, trouver l'étape où la personne cale.
  - Elle ne sait pas quoi viser (but).
  - Elle ne voit pas quelle action faire (spécifier).
  - Elle ne voit pas ce qui a changé (percevoir).
  - Elle ne comprend pas ce que cela veut dire (interpréter).
  - Elle ne sait pas si c'est fini (évaluer).

  Chaque étape appelle une correction différente.

### Concevoir des signifiants perceptibles : ce que l'objet permet ne suffit pas si rien ne l'indique
- Niveau de preuve : N4 (essai d'auteur).
- Source : Norman, D. A., 17.11.2008, « Signifiers, not affordances », https://jnd.org/signifiers-not-affordances/ ; selon Wikipédia (page citée plus haut), l'édition révisée de *The Design of Everyday Things* (2013) « introduced the concept of signifiers to clarify his definition of affordances ».
- Extrait lu : « I call any physically perceivable cue a signifier, whether it is incidental or deliberate. » Et : « Forget affordances: what people need, and what design must provide, are signifiers. »
- Portée / limites : il s'agit d'un essai conceptuel. Norman étend la notion aux signifiants sociaux et aux absences : un quai vide, par exemple, signale que le train est parti. L'essai ne propose aucune mesure.
- En conception : pour chaque élément actionnable, se demander quel indice perceptible dit qu'on peut agir dessus, et comment. Le défaut à chercher est l'élément cliquable qui n'a ni forme, ni couleur, ni libellé de contrôle, comme un texte plat cliquable ou une icône seule. Il faut aussi chercher le signifiant trompeur : un élément décoratif qui a l'air cliquable.

### Donner un feedback immédiat et lisible après chaque action qui a une conséquence
- Niveau de preuve : N4 (heuristique de praticien).
- Source : Harley, A., 03.06.2018, « Visibility of System Status (Usability Heuristic #1) », NN/g, https://www.nngroup.com/articles/visibility-system-status/
- Extrait lu : « Ideally, systems should always keep users informed about what is going on ». Et : « no action with consequences to users should be taken without informing them. »
- Portée / limites : c'est une heuristique, pas une étude. Elle opérationnalise le pont du gouffre d'évaluation.
- En conception : après chaque clic qui modifie un état (enregistrer, envoyer, supprimer, payer), vérifier que l'écran dit ce qui s'est passé, à l'endroit où l'œil se trouve. Le défaut à chercher est l'action silencieuse, ou un toast placé loin de la zone d'attention (voir la cécité au changement, section 7).

---

## 2. Modèles mentaux

### Partir du principe que le modèle mental de l'utilisateur est incomplet, instable et « économe »
- Niveau de preuve : N4. C'est un chapitre académique fondé sur des observations qualitatives, comme l'usage de calculatrices, sans échantillon chiffré dans l'extrait lu. Seul l'aperçu partiel du livre a été lu.
- Source : Norman, D. A., 1983, « Some Observations on Mental Models », dans Gentner, D. & Stevens, A. (dir.), *Mental Models*, Erlbaum. Aperçu lu : https://www.perlego.com/book/1553915/mental-models-pdf
- Extrait lu : « Mental models are incomplete. » ; les gens « maintain 'superstitious' behavior patterns even when they know they are unneeded » ; « Mental models are parsimonious: Often people do extra physical operations rather than the mental planning ».
- Portée / limites : Norman a observé des utilisateurs de calculatrices qui ajoutaient des étapes inutiles par sécurité (« I always take extra steps. I never take short cuts. »). L'aperçu est tronqué, et les autres propriétés souvent citées (« no firm boundaries », « unscientific ») n'ont pas été lues.
- En conception : ne pas supposer que la personne a compris le fonctionnement. Elle préfère refaire un geste plutôt que réfléchir. Le défaut à chercher est le parcours qui exige de retenir un état caché : un mode, un filtre actif, un brouillon non enregistré. Autre signal : des gestes « superstitieux » observés en test, comme cliquer deux fois sur « Enregistrer » ou recharger la page. Ils trahissent un état mal communiqué.

### Le modèle conceptuel du concepteur doit être rendu visible : il ne se transmet pas tout seul
- Niveau de preuve : N4. Chapitre académique (aperçu) et article de praticien.
- Source : Norman, 1983, « Some Observations on Mental Models », https://www.perlego.com/book/1553915/mental-models-pdf ; Chan, M., 26.01.2024 (mise à jour d'un article de J. Nielsen de 2010), « Mental Models », NN/g, https://www.nngroup.com/articles/mental-models/
- Extrait lu : « Conceptual models are invented by teachers, designers, scientists, and engineers. » ; « Ideally, there ought to be a direct and simple relationship between the conceptual and the mental model. » (Norman). Et : « One of the biggest dilemmas in usability is the gap between designers' and users' mental models. » (NN/g).
- Portée / limites : NN/g explique cet écart par le fait que le concepteur connaît son produit en détail et juge donc chaque fonction évidente. C'est un constat de praticien, sans étude chiffrée dans l'article.
- En conception : se méfier de son propre sentiment d'évidence. Pour chaque concept-clé de l'écran (dossier, projet, espace, brouillon), se demander où l'interface montre sa structure et ses relations. Le défaut à chercher est le concept qu'on ne comprend qu'en lisant une aide.

### Quand les gens cherchent au mauvais endroit, déplacer l'objet là où ils cherchent
- Niveau de preuve : N4.
- Source : Chan, M., 26.01.2024, « Mental Models », NN/g, https://www.nngroup.com/articles/mental-models/
- Extrait lu : « if people look for something in the wrong place, then move it to the place where they look for it. » ; « Designers are better off leveraging this mental-model inertia instead of fighting it. »
- Portée / limites : l'article propose deux leviers. Le premier est de rendre le système conforme au modèle des utilisateurs. Le second est d'améliorer leur modèle, par l'explication, quand une nouveauté est « clearly superior ». L'article ne présente aucune donnée quantitative.
- En conception : en test ou dans l'analytique, relever les premiers clics erronés. Si une majorité cherche « Factures » sous « Compte » et non sous « Paramètres », le défaut est le rangement, pas les utilisateurs.

---

## 3. Recherche d'information : fourragement, odeur, cueillette

### Traiter la navigation comme un fourragement : l'information arrive par paquets, et l'on quitte un paquet quand il rapporte moins qu'ailleurs
- Niveau de preuve : N2 (CHI 1995, revu par les pairs, modèles appliqués à des données Scatter/Gather).
- Source : Pirolli, P. & Card, S., 1995, « Information Foraging in Information Access Environments », CHI '95, Xerox PARC. Texte intégral lu : https://www.chi1995.chistatic.hosting.acm.org/proceedings/papers/ppp_bdy.htm
- Extrait lu : « Information foraging theory is an approach to the analysis of human activities involving information access technologies. » ; « A user's encounters with valuable or relevant information will typically have a clumpy structure over space and time. »
- Portée / limites : l'article transpose à l'information les modèles de prospection optimale (marginal value theorem de Charnov). Il emploie les notions de « patch models » et d'« information diet ». La version longue de la théorie a paru en 1999 dans *Psychological Review* (vol. 106, n° 4, p. 643-675, DOI 10.1037/0033-295X.106.4.643). Pour celle-ci, seules les métadonnées ont été lues, via PubPeer (https://pubpeer.com/publications/13B6B9BCFD53A1073FDFEE5A4694AC) : son résumé n'a pas été lu.
- En conception : considérer chaque page de liste ou de résultats comme un « patch ». Le défaut à chercher est la page qui oblige à ouvrir chaque élément pour juger de sa valeur, faute de résumé, de date ou de critère visible. La personne quitte alors le patch trop tôt, ou s'épuise.

### Rédiger chaque libellé de lien comme une promesse précise : c'est l'odeur qui décide du prochain clic
- Niveau de preuve : N4 (article de praticien fondé sur la théorie de l'information foraging).
- Source : Budiu, R., 02.02.2020, « Information Scent: How Users Decide Where to Go Next », NN/g, https://www.nngroup.com/articles/information-scent/
- Extrait lu : l'odeur est « the user's imperfect estimate of the value that the source will deliver to the user, derived from a representation of the source. » ; « it's always good to be as specific as possible with the link names instead of relying on the context ».
- Portée / limites : l'article ne nomme pas Pirolli et Card. Il décrit l'arbitrage de l'utilisateur entre deux estimations : la probabilité que la page réponde et le temps que cela prendra. Ses recommandations portent sur les libellés, les résumés, les images représentatives et le risque de piège à clics, qui use la confiance. L'article ne présente aucune donnée chiffrée.
- En conception : lire chaque lien hors contexte. Le défaut à chercher : « En savoir plus », « Cliquez ici », un pictogramme seul, ou un libellé de catégorie interne à l'organisation. Sur mobile, le contexte autour du lien disparaît souvent.

### Prévoir que l'utilisateur évalue les liens dans l'ordre et clique sur le premier « assez bon »
- Niveau de preuve : N2 (CogSci 2007, revu par les pairs, modèle validé sur 74 sujets).
- Source : Fu, W.-T. & Pirolli, P., 2007, « SNIF-ACT: A Cognitive Model of User Navigation on the World Wide Web », *Proceedings of the Annual Meeting of the Cognitive Science Society*, 29. Texte lu (résumé étendu de 2 pages) : https://typeset.io/pdf/snif-act-a-cognitive-model-of-user-navigation-on-the-world-3tpvwmgse1.pdf
- Extrait lu : « an adaptive link selection mechanism that sequentially evaluates links on a Web page according to their position. The mechanism was derived based on a rational analysis of link selection on a Web page and the process of satisficing in action selection (Simon, 1956). » ; « SNIF-ACT 2.0 was validated on a data set obtained from 74 subjects. »
- Portée / limites : ce texte est un résumé de communication, et l'article complet (*Human-Computer Interaction*, 2007) n'a pas été lu. Le modèle couvre des tâches de recherche d'information non familières, pour des utilisateurs généraux. Selon le résumé, il s'ajuste mieux aux données humaines qu'un modèle fondé sur la seule position des liens. C'est le pont empirique entre le satisficing de Simon et l'usage du web.
- En conception : l'ordre des options compte autant que leur libellé. Le défaut à chercher est une option pertinente placée après une option « presque bonne » : la personne s'arrête sur cette dernière. Placer en tête l'option la plus probable pour la tâche principale.

### Concevoir la recherche comme une cueillette : la requête change en chemin et la personne garde des morceaux
- Niveau de preuve : N2 avec réserve. Article conceptuel de référence, mais la page lue ne cite pas la revue et aucun test empirique n'y figure.
- Source : Bates, M. J., 1989, « The Design of Browsing and Berrypicking Techniques for the Online Search Interface », https://pages.gseis.ucla.edu/faculty/bates/berrypicking.html
- Extrait lu : « the query itself (as well as the search terms used) is continually shifting, in part or whole. » ; « A bit-at-a-time retrieval of this sort is here called berrypicking. »
- Portée / limites : Bates oppose son modèle au modèle classique, celui d'une requête unique qui donne un unique ensemble de résultats. Le texte date de l'ère des catalogues en ligne et propose un modèle, pas une mesure.
- En conception : sur un moteur de recherche ou un catalogue, vérifier que la personne peut faire trois choses.
  - Reformuler sans perdre ce qu'elle a déjà trouvé (panier, favoris, comparateur).
  - Rebondir depuis un résultat : « voir aussi », auteur, mots-clés.
  - Retrouver son historique.

  Le défaut à chercher est la recherche qui repart de zéro à chaque nouvelle requête.

### Même quand on sait ce qu'on cherche, on avance par petits pas : offrir des points d'appui, pas seulement une barre de recherche
- Niveau de preuve : N2 (CHI 2004, étude de journal modifiée, 15 participants).
- Source : Teevan, J., Alvarado, C., Ackerman, M. S. & Karger, D. R., 2004, « The Perfect Search Engine Is Not Enough: A Study of Orienteering Behavior in Directed Search », CHI 2004. Texte intégral lu : https://people.csail.mit.edu/teevan/work/publications/papers/chi04.pdf
- Extrait lu : « our participants navigated to their target with small, local steps using their contextual knowledge as a guide, even when they knew exactly what they were looking for in advance. »
- Portée / limites : l'étude porte sur 15 doctorants en informatique du MIT (10 hommes, 5 femmes), interrogés deux fois par jour pendant cinq jours. Elle couvre la recherche dans leurs mails, leurs fichiers et le web. L'échantillon est petit et très particulier. Les auteurs notent que la plupart des recherches observées n'utilisaient pas de mots-clés.
- En conception : ne pas tout miser sur la recherche plein texte. Offrir des chemins d'orientation : récents, arborescence, filtres par date ou par personne, fil d'Ariane. Le défaut à chercher est l'application dont le seul moyen de retrouver un élément est de taper son nom exact.

---

## 4. Décision en situation réelle

### Concevoir pour une décision « assez bonne », pas optimale
- Niveau de preuve : N2, cité par une source secondaire : l'article de Simon n'a pas été lu en entier.
- Source : Simon, H. A., 1956, « Rational choice and the structure of the environment », *Psychological Review*, 63(2), 129-138. Cité et extrait par Stevens, J. R., 2013, « The Bounds of Rationality and Cognitive Building Blocks », *Behavioral Ecology*, 24, 13-14, https://digitalcommons.unl.edu/psychfacpub/632
- Extrait lu (citation de Simon par Stevens) : « organisms … do not, in general, 'optimize' » (p. 129).
- Portée / limites : Stevens résume la thèse de Simon : pour comprendre une décision, il faut étudier à la fois les capacités cognitives de l'organisme et la structure de l'environnement. L'article de 1955 (« A Behavioral Model of Rational Choice », *QJE*) et le texte de 1956 n'ont pas pu être ouverts. Le mécanisme du « niveau d'aspiration » n'est donc vérifié que par l'usage qu'en fait SNIF-ACT (entrée précédente). L'application au web par Steve Krug n'a pas été vérifiée sur le livre : voir « Non vérifié ».
- En conception : la personne choisira la première option qui lui paraît convenir. Il faut donc que les options correctes ressemblent à ce qu'elle cherche, et que les options proches mais fausses ne lui ressemblent pas. Le défaut à chercher est un écran où il faut tout comparer pour bien choisir, sans aide à la comparaison.

### Choisir chaque valeur par défaut comme une décision de conception : son effet est fort, mais il varie
- Niveau de preuve : N2 (méta-analyse de 58 études, n cumulé = 73 675 ; résumé seul lu).
- Source : Jachimowicz, J. M., Duncan, S., Weber, E. U. & Johnson, E. J., 2019, « When and why defaults influence decisions: a meta-analysis of default effects », *Behavioural Public Policy*, 3(2), 159-186, https://ideas.repec.org/a/cup/bpubpo/v3y2019i02p159-186_00.html
- Extrait lu : « we conduct a literature search and meta-analysis of the 58 default studies (pooled n = 73,675) that fit our criteria. » ; « While our analysis reveals a considerable influence of defaults (d = 0.68, 95% confidence interval = 0.53–0.83) ».
- Portée / limites : l'hétérogénéité est forte. La plupart des études trouvent un effet positif, certaines aucun effet significatif, deux un effet négatif. L'effet est plus fort dans le domaine de la consommation et plus faible dans le domaine environnemental. Il est aussi plus fort quand le défaut fonctionne par « endorsement » (il signale ce que le concepteur recommande) ou par « endowment » (il reflète le statu quo).
- En conception : chaque champ prérempli, chaque case cochée et chaque option présélectionnée sera majoritairement conservé. Il faut donc pouvoir justifier qu'il sert l'intérêt de l'utilisateur. Le défaut à chercher est la présélection qui sert l'éditeur (abonnement, consentement, option payante) : elle relève aussi de la recherche « dark patterns ».

### L'effet du défaut sur le don d'organes se réplique, mais ne se généralise pas à tout cadrage
- Niveau de preuve : N2 (réplication préenregistrée, N = 1 920 ; résumé seul lu).
- Source : Chandrashekar, S. P. et al., 2023, « Defaults versus framing: Revisiting Default Effect and Framing Effect with replications and extensions of Johnson and Goldstein (2003) and Johnson, Bellman, and Lohse (2002) », *Meta-Psychology*, 7, https://open.lnu.se/index.php/metapsychology/article/view/3108 ; recensé comme réplication réussie par l'atlas FORRT, https://forrt.org/flora-replication-atlas/doi/10.1126/science.1091721/
- Extrait lu : « We successfully replicated Johnson and Goldstein (2003). » Mais, pour Johnson, Bellman & Lohse (2002) : « we did not find evidence for a default effect. »
- Portée / limites : cette réplication porte sur des scénarios en ligne. Elle ne dit rien des taux réels de don, qui font débat : voir « Mythes ». Une réplication conceptuelle sur le don d'organes, avec le format de l'étude de 2002, n'a pas non plus trouvé d'effet du défaut. Les auteurs concluent que l'effet dépend du cadrage et du contexte.
- En conception : ne pas tenir le défaut pour un levier universel. Si l'option est formulée de manière ambiguë, par exemple une case du type « ne pas me contacter », c'est le cadrage qui domine. Tester la formulation et le défaut ensemble.

### Ce qui est en tête de liste capte les clics au-delà de sa pertinence : ordonner en conséquence
- Niveau de preuve : N4. Article de praticien qui rapporte une étude de Cornell (Joachims et al.), non lue directement.
- Source : Nielsen, J., 25.09.2005, « The Power of Defaults », NN/g, https://www.nngroup.com/articles/the-power-of-defaults/
- Extrait lu : Nielsen parle d'« a strong bias in favor of clicking the top link ».
- Portée / limites : chiffres rapportés par Nielsen.
  - Ordre d'origine : 42 % des clics sur le premier résultat, 8 % sur le deuxième.
  - Les deux premiers résultats inversés : le premier rang garde 34 % des clics, le deuxième 12 %.

  L'étude date de 2005 et porte sur des résultats Google. L'échantillon n'est pas donné dans l'article. Nielsen recommande de préremplir avec la valeur la plus probable, de ne pas laisser l'ordre alphabétique décider, et de ne pas toujours présélectionner l'offre la plus chère, ce qui érode la confiance.
- En conception : le premier élément d'une liste, d'un menu ou d'un résultat fonctionne comme un défaut. Vérifier qu'il correspond à la tâche la plus fréquente. Le défaut à chercher est un ordre fixé par l'implémentation : alphabétique, date de création, identifiant.

---

## 5. Erreurs humaines

### Distinguer les ratés d'action (slips) des erreurs d'intention : on ne les prévient pas de la même façon
- Niveau de preuve : N2 (*Psychological Review*, analyse de corpus d'erreurs).
- Source : Norman, D. A., 1981, « Categorization of Action Slips », *Psychological Review*, 88(1), 1-15. Texte intégral lu : https://ocw.tudelft.nl/wp-content/uploads/385f43617465676f72697a6174696f6e206f6620616374696f6e20736c697073.pdf
- Extrait lu : « A slip is the error that occurs when a person does an action that is not intended. » ; « The three major categories of slips are: (a) errors in the formation of the intention (which includes the subcategories of mode and description errors); (b) faulty activation of schemas (which includes the subcategories of capture errors, data-driven and associative activations, loss of intention, and misordering of action components); and (c) faulty triggering ».
- Portée / limites : la taxonomie repose sur des collections de ratés recueillies par l'auteur, sans échantillon représentatif. Le tableau de l'article exclut explicitement des slips les erreurs de décision et de résolution de problème. Ce sont les « mistakes » des textes ultérieurs.
- En conception : devant une erreur observée, se demander si la personne savait quoi faire et a mal fait (slip), ou si elle visait la mauvaise chose (mistake).
  - Une erreur de **capture** survient quand un geste fréquent prend le dessus. Exemple : un bouton « Supprimer » placé là où se trouve habituellement « Enregistrer ».
  - Une erreur de **description** survient quand deux commandes se ressemblent. Exemple : deux boutons identiques côte à côte.

### Éviter les modes cachés : même entrée, résultat différent, sans le signaler
- Niveau de preuve : N2 pour la définition (Norman 1981), N4 pour les recommandations (NN/g).
- Source : Norman, 1981 (lien ci-dessus) ; Laubheimer, P., 14.04.2019, « Modes in User Interfaces: When They Help and When They Hurt Users », NN/g, https://www.nngroup.com/articles/modes/
- Extrait lu : « When a situation is falsely classified, then the resulting action may be one that was intended and appropriate for the analysis of the situation but inappropriate for the actual situation. » ; « Failure to identify which mode the system is in leads to (frequent) errors » (Norman). Et : « Modes are different interpretations of the user input by the system, depending on the state which is active. » (NN/g).
- Portée / limites : NN/g recommande de montrer le mode actif par au moins deux indices visuels, de nommer les modes, et d'éviter les modes quand une erreur coûterait cher (perte de données, gêne, danger physique). Les modes « à ressort », actifs seulement tant qu'on maintient une touche, évitent les erreurs mais rendent les fonctions moins découvrables.
- En conception : relever tous les états qui changent le sens d'un clic ou d'une touche : édition ou lecture, outil actif, filtre appliqué, Verr. Maj., brouillon ou publié. Le défaut à chercher est un mode signalé par un seul indice discret, ou pas signalé du tout.

### Prévenir les ratés par la conception (contraintes, défauts plausibles, saisie tolérante), car la formation n'y peut rien
- Niveau de preuve : N3 (HSE, autorité britannique de santé et sécurité) et N4 (NN/g).
- Source : Health and Safety Executive, « Managing human failures: Overview », https://www.hse.gov.uk/humanfactors/topics/humanfail.htm ; Laubheimer, P., 23.08.2015, « Preventing User Errors: Avoiding Unconscious Slips », NN/g, https://www.nngroup.com/articles/slips/
- Extrait lu : à propos des slips et des lapses, « These cannot be eliminated by training », puis « improved design can reduce their likelihood and provide a more error tolerant system. » ; à propos des mistakes, « Training based on good procedures is the key to avoiding mistakes. » (HSE). Et : « Slips occur when users intend to perform one action, but end up doing another (often similar) action. » (NN/g).
- Portée / limites : la HSE vise la sécurité industrielle, pas les interfaces. Sa page ne cite pas James Reason, même si la typologie est la même (slips, lapses, mistakes, violations, ces dernières étant « intentional but usually well-meaning failures »). NN/g recommande trois moyens : contraindre les entrées (par exemple, pas de date de retour avant la date d'aller), proposer des défauts plausibles, et accepter les formats naturels puis les reformater.
- En conception : pour chaque champ et chaque commande irréversible, se demander si la conception peut rendre l'erreur impossible ou rattrapable. Le défaut à chercher est la validation qui rejette un format pourtant compréhensible (espaces dans un numéro de téléphone, tirets dans un numéro de compte bancaire), ou le message d'aide qui tient lieu de prévention.

### Réserver les fonctions de forçage (verrouillages) aux cas où l'erreur coûte cher, et les rendre peu gênantes
- Niveau de preuve : N4 (Norman, cité par un chercheur en design).
- Source : Lockton, D., « Everyday things & persuasive technology » (essai, site 2004-2025), https://architectures.danlockton.co.uk/everyday-things-persuasive-technology/ ; il cite *The Design of Everyday Things* de Norman.
- Extrait lu (citation de Norman) : « If a forcing function is really desired, it is usually possible to find one, although at some cost for normal behaviour. » ; « make sure it works right, is reliable, and distinguishes legitimate violations from illegitimate ones. »
- Portée / limites : la page mentionne la typologie de Norman (interlocks, lock-ins, lockouts) avec l'exemple de la ceinture de sécurité, sans définir chaque type. L'édition du livre citée n'est pas précisée. Les définitions détaillées n'ont été lues que dans des résumés secondaires.
- En conception : un « interlock » (impossible de payer sans avoir accepté les conditions), un « lock-in » (avertissement avant de quitter un document non enregistré) ou un « lockout » (bouton désactivé tant qu'un champ obligatoire manque) doit se justifier par un risque réel. Le défaut à chercher est le verrouillage qui bloque des usages légitimes et pousse les gens à le contourner.

---

## 6. Prédire et évaluer le chemin d'usage

### Inspecter chaque étape d'un parcours avec les quatre questions du cognitive walkthrough
- Niveau de preuve : N4. Article de praticien qui présente la méthode publiée par Wharton et al. (1994) ; l'original n'a pas été lu.
- Source : Flaherty, K., 13.02.2022, « Evaluate Interface Learnability with Cognitive Walkthroughs », NN/g, https://www.nngroup.com/articles/cognitive-walkthroughs/
- Extrait lu : « Will users try to achieve the right result? » / « Will users notice that the correct action is available? » / « Will users associate the correct action with the result they're trying to achieve? » / « After the action is performed, will users see that progress is made toward the goal? »
- Portée / limites : selon l'article, la méthode a été présentée par Lewis, Polson, Wharton et Rieman en 1990, puis simplifiée en 1994. Elle repose sur le modèle CE+ d'apprentissage par exploration. Ses limites :
  - elle se fait sans utilisateurs réels ;
  - elle se concentre sur l'apprenabilité ;
  - elle est disproportionnée pour des schémas familiers, comme un tunnel d'achat standard.

  Elle doit être complétée par des tests utilisateurs.
- En conception : appliquer les quatre questions à chaque action d'un parcours de première utilisation. Une réponse « non » situe le défaut :
  - question 1 : un but que la personne ne se donne pas ;
  - question 2 : une action invisible ;
  - question 3 : un libellé qui ne correspond pas au but ;
  - question 4 : une absence de feedback.

### Estimer le temps d'une tâche experte en sommant les opérateurs (KLM), en comptant surtout les préparations mentales
- Niveau de preuve : N2 (*Communications of the ACM*, validé sur 10 systèmes).
- Source : Card, S. K., Moran, T. P. & Newell, A., 1980, « The Keystroke-Level Model for User Performance Time with Interactive Systems », *Communications of the ACM*. Scan intégral lu (archives Newell, CMU) : https://iiif.library.cmu.edu/file/Newell_box00072_fld05094_doc0001/Newell_box00072_fld05094_doc0001.pdf
- Extrait lu : le modèle prédit « the time it takes an expert user to perform a given task on a given computer system » ; « When tested against data on 10 different systems, the model's prediction error is 21 percent for individual tasks. » ; « These mental preparations take 1.35 sec on the average ». Le pointage à la souris « ranges from .8 to 1.5 sec, with 1.1 being an average time », et le retour de la main sur le clavier (homing) vaut .40 s.
- Portée / limites : le modèle vaut pour des utilisateurs **experts**, des tâches de routine et une exécution sans erreur. Il ne traite ni l'apprentissage ni les erreurs. Les valeurs datent de 1980 (souris, éditeurs de texte). Wikipédia (https://en.wikipedia.org/wiki/Keystroke-level_model) rapporte que Dunlop & Crossan (2000) contestent sa précision sur mobile : non vérifié à la source.
- En conception : comparer deux variantes d'un écran fréquent en comptant les pointages, les allers-retours clavier-souris et surtout les M, c'est-à-dire chaque moment où la personne doit décider ou se souvenir de quelque chose. Le défaut à chercher est le parcours expert truffé de décisions évitables : choix répété à chaque fois, confirmation systématique, champ à ressaisir.

---

## 7. Attention et perception

### Ce qui n'est pas attendu n'est pas vu, surtout s'il ne ressemble pas à ce que la tâche fait surveiller
- Niveau de preuve : N2 (*Perception*, 192 observateurs).
- Source : Simons, D. J. & Chabris, C. F., 1999, « Gorillas in our midst: sustained inattentional blindness for dynamic events », *Perception*, 28, 1059-1074. Texte intégral lu : https://www.chabris.com/Simons1999.pdf
- Extrait lu : « Out of all 192 observers across all conditions, 54% noticed the unexpected event and 46% failed to notice the unexpected event » ; « the likelihood of noticing an unexpected object depends on the similarity of that object to other objects in the display and on how difficult the priming monitoring task is. »
- Portée / limites : le taux de détection varie fortement selon les conditions. La femme au parapluie a été vue plus souvent que le gorille (65 % contre 44 %). Les observateurs ont été plus nombreux à voir l'événement avec la tâche facile qu'avec la tâche difficile (64 % contre 45 %). L'étude porte sur des vidéos, pas sur des interfaces, et les participants étaient des étudiants.
- En conception : un message important qui n'a pas l'apparence de ce que la personne surveille sera manqué pendant une tâche absorbante. Exemples : bandeau d'alerte pendant une saisie, avertissement dans une marge. Le défaut à chercher est l'information critique placée hors du flux de la tâche, ou habillée comme un élément secondaire.

### Même un expert, dans son domaine, ne voit pas l'inattendu : ne pas compter sur la compétence pour compenser
- Niveau de preuve : N2 (*Psychological Science*, 24 radiologues, 25 novices, oculométrie).
- Source : Drew, T., Võ, M. L.-H. & Wolfe, J. M., 2013, « The Invisible Gorilla Strikes Again: Sustained Inattentional Blindness in Expert Observers », *Psychological Science*, 24(9). Manuscrit lu : https://pmc.ncbi.nlm.nih.gov/articles/PMC3964612/
- Extrait lu : « A gorilla, 48 times larger than the average nodule, was inserted in the last case. » ; « 83% of radiologists did not see the gorilla. » ; « Eye-tracking revealed that the majority of the those who missed the gorilla looked directly at the location of the gorilla. »
- Portée / limites : l'échantillon est petit, 24 radiologues. Rater le gorille ne mesure pas les erreurs de diagnostic. Avoir regardé l'emplacement n'implique pas l'avoir vu : 12 des 20 radiologues qui l'ont manqué ont pourtant posé les yeux dessus.
- En conception : un utilisateur expert, très concentré sur sa tâche habituelle, ne verra pas un changement de règle, de tarif ou de risque affiché dans son environnement familier. Le défaut à chercher est une information nouvelle et critique qui compte sur la vigilance de l'expert. Il faut l'insérer dans le geste lui-même, par exemple une confirmation ciblée.

### Signaler chaque changement d'état là où regarde la personne, un changement à la fois
- Niveau de preuve : N4 (article de praticien, appuyé sur des revues de Rensink).
- Source : Budiu, R., 23.09.2018, « Change Blindness in UX: Definition », NN/g, https://www.nngroup.com/articles/change-blindness-definition/
- Extrait lu : « Change blindness refers to people's tendency to ignore changes in a scene when they occur in a region […] that is far away from their focus of attention. » ; « Make one change at a time. » ; « Dim the areas of the screen that do not change ».
- Portée / limites : l'article s'appuie sur les expériences de clignotement du milieu des années 1990, où certains participants avaient besoin de 20 à 40 alternances avant de repérer un changement. Il cite Rensink (2002, *Annual Review of Psychology*), dont le nom y est mal orthographié. Il ne présente aucune étude propre sur des interfaces.
- En conception : après une action, vérifier que ce qui change (total recalculé, ligne ajoutée, erreur apparue) se trouve près du point d'action ou est signalé par une animation brève. Le défaut à chercher est la mise à jour silencieuse d'une zone éloignée, comme un panier en haut à droite après un clic en bas de page, ou une erreur affichée en haut d'un long formulaire.

### Ne pas habiller un contenu utile comme une publicité, ni le placer là où vont les publicités
- Niveau de preuve : N4. Étude de praticien par oculométrie (26 participants par tâche), et commentaire théorique de Norman.
- Source : Pernice, K., 22.04.2018, « Banner Blindness Revisited: Users Dodge Ads on Mobile and Desktop », NN/g, https://www.nngroup.com/articles/banner-blindness-old-and-new-findings/ ; Norman, D. A., 1999 (republié le 17.11.2008), « Banner Blindness, Human Cognition and Web Design », https://jnd.org/banner-blindness-human-cognition-and-web-design/
- Extrait lu : « Do not make content look like ads. » ; « Do not mix content and ads in the same visual section. » (NN/g). Pour Norman, la cause tient aux « schemas, frameworks, and expectations », et « Designers who break out of the established genre thereby do so at considerable risk ».
- Portée / limites : dans l'étude NN/g, la colonne de droite n'a reçu qu'environ 0,8 % des fixations de la zone de contenu. Norman présente lui-même son explication, une recherche dirigée par des schémas, comme une théorie non testée. L'étude d'origine de Benway & Lane (1998) n'a pas pu être lue (site disparu) : voir « Non vérifié ».
- En conception : vérifier qu'aucune information utile au parcours n'a les attributs d'une publicité. Ces attributs sont l'emplacement en bannière haute ou en colonne de droite, le format encadré ou animé, et le voisinage d'une promotion. Le défaut à chercher est le message de service présenté comme une bannière marketing, ou le lien essentiel placé dans un carrousel.

### Grouper par la proximité ce qui va ensemble, et éloigner ce qui ne va pas ensemble
- Niveau de preuve : N4. L'article ne cite aucune expérience : la preuve empirique propre aux interfaces manque dans cette source.
- Source : Harley, A., 02.08.2020, « Proximity Principle in Visual Design », NN/g, https://www.nngroup.com/articles/gestalt-proximity/
- Extrait lu : « Items close together are likely to be perceived as part of the same group — sharing similar functionality or traits. »
- Portée / limites : l'article s'appuie sur la psychologie de la Gestalt de la première moitié du XXᵉ siècle et sur des observations faites lors de tests NN/g sur mobile, sans échantillon ni statistique. Les études empiriques repérées par la recherche (Gestalt et visualisations, 22 participants) n'ont pas pu être ouvertes : voir « Non vérifié ».
- En conception : vérifier que l'espacement code bien la structure. Le libellé doit être plus proche de son champ que du champ voisin. Les actions liées doivent être ensemble (« Précédent » et « Suivant »), et les actions destructrices à l'écart. Contrôler aussi que l'empilement des colonnes sur mobile ne sépare pas ce qui était groupé sur ordinateur.

---

## 8. Habitudes et apprentissage

### Les gestes habituels sont déclenchés par le contexte, sans passer par le but : changer le contexte d'un geste installé casse l'habitude
- Niveau de preuve : N2 (*Psychological Review*, article de synthèse théorique).
- Source : Wood, W. & Neal, D. T., 2007, « A New Look at Habits and the Habit–Goal Interface », *Psychological Review*, 114(4), 843-863. Texte lu : https://dornsife.usc.edu/wendy-wood/wp-content/uploads/sites/183/2023/10/wood.neal_.2007psychrev_a_new_look_at_habits_and_the_interface_between_habits_and_goals.pdf
- Extrait lu : « Once a habit is formed, perception of contexts triggers the associated response without a mediating goal. » ; « habit associations accrue slowly and do not shift appreciably with current goal states or infrequent counterhabitual responses. »
- Portée / limites : c'est un modèle théorique fondé sur une revue de la littérature, qui ne porte pas spécifiquement sur les interfaces. L'« interface » de son titre est celle entre habitude et but.
- En conception : sur une interface utilisée chaque jour, l'emplacement d'un bouton ou un raccourci clavier devient un déclencheur contextuel. Déplacer « Envoyer » ou permuter deux actions produira des erreurs de capture, quelles que soient les intentions de l'utilisateur. Le défaut à chercher est une refonte qui change de place des commandes très fréquentes sans nécessité.

### Une habitude met des semaines à des mois à s'installer, avec de grands écarts entre individus : ne pas juger une nouveauté sur ses premiers jours
- Niveau de preuve : N2 (*European Journal of Social Psychology*, 96 volontaires sur 84 jours). L'article n'a pas été lu, ni son résumé : les chiffres viennent de deux sources secondaires concordantes.
- Source : Lally, P., van Jaarsveld, C. H. M., Potts, H. W. W. & Wardle, J., 2010, « How are habits formed: Modelling habit formation in the real world », *EJSP*, 40(6), 998-1009. Sources lues : BPS Research Digest, https://bps.org.uk/research-digest/how-form-habit ; Hreha, J., 09.02.2026, « How Long Does It Take to Form a Habit? What Lally et al. (2010) Actually Found », https://www.thebehavioralscientist.com/articles/how-long-to-form-a-habit
- Extrait lu : « 66 days was the median estimated time to reach 95% of a modeled automaticity plateau. » (Hreha). Et : « a single missed day had little impact on later automaticity gains » (BPS).
- Portée / limites :
  - Selon Hreha, 82 participants avaient des données exploitables, mais seuls 39 présentaient une courbe bien ajustée. La médiane de 66 jours ne porte que sur ces 39.
  - L'écart va de 18 à 254 jours, et la borne haute est extrapolée au-delà des 84 jours de l'étude.
  - L'automaticité était auto-déclarée.
  - Les comportements étudiés relevaient de la santé (manger, boire, faire de l'exercice), pas d'usages logiciels.
  - La BPS parle d'« average » là où Hreha précise « median ».
- En conception : après une refonte, ne pas conclure à l'échec sur la première semaine de mesure. Prévoir une période d'observation de plusieurs semaines et des indicateurs par cohorte d'ancienneté. Le défaut à chercher est un test A/B arrêté au bout de quelques jours sur une fonction qui exige un nouveau geste.

### Gérer l'aversion au changement : annoncer, expliquer, laisser revenir à l'ancienne version un temps, écouter
- Niveau de preuve : N4. Étude de cas industrielle (CHI 2013 Extended Abstracts), sans groupe contrôle. À côté : une critique de praticien.
- Source : Sedley, A. & Müller, H., 2013, « Minimizing Change Aversion for the Google Drive Launch », CHI 2013 Extended Abstracts. Texte lu : https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/41221.pdf ; Spool, J., 16.07.2012, « Google's take on change aversion misses the point », https://archive.uie.com/brainsparks/2012/07/16/googles-take-on-change-aversion-misses-the-point/
- Extrait lu : « Change aversion is a state of discomfort and anxiety when something familiar is replaced with something unfamiliar. » ; parmi les actions du cadre : « Let users switch between new and old UI » ; « Future research should aim to conduct controlled experiments to isolate the impact of each change management tactic » (Sedley & Müller). Et : « In most cases, people hate change because they don't like to suddenly become stupid. » (Spool).
- Portée / limites : les auteurs affirment que la satisfaction a été « significantly more positive » qu'avec d'autres refontes, mais sans expérience contrôlée et avec un biais de non-réponse qu'ils reconnaissent eux-mêmes. Pour Spool, la résistance vient surtout de la perte de compétence, pas du changement en soi.
- En conception : pour une refonte, prévoir les dix actions du cadre de Sedley & Müller (planifier, évaluer l'impact, prévenir, expliquer les bénéfices, guider, permettre le retour temporaire, suivre, recueillir les retours, corriger vite, dire ce qui a été amélioré). Mesurer aussi ce que l'expert perd : chaque geste expert devenu impossible ou plus lent est un défaut, pas une « résistance ».

### Concevoir pour des gens qui apprennent en faisant et ne lisent pas le mode d'emploi
- Niveau de preuve : N4. Chapitre académique fondé sur des études d'observation de l'usage du traitement de texte ; les échantillons ne sont pas repris dans l'extrait lu.
- Source : Carroll, J. M. & Rosson, M. B., 1987, « Paradox of the Active User », dans Carroll, J. M. (dir.), *Interfacing Thought*, MIT Press. Texte lu : https://typeset.io/pdf/paradox-of-the-active-user-2nnfw86642.pdf ; résumé par Nielsen, J., 04.10.1998, https://www.nngroup.com/articles/paradox-of-the-active-user/
- Extrait lu : « A motivational paradox arises in the "production bias" people bring to the task of learning and using computing equipment. Their paramount goal is throughput. » ; « A second, cognitive paradox devolves from the "assimilation bias": people apply what they already know to interpret new situations. » Parmi les pistes proposées : « make the learning safer and more risk-free, or make the relevant information easier to find. »
- Portée / limites : les auteurs ne présentent pas le paradoxe comme un problème à résoudre, mais comme des compromis entre approches qui se contredisent. Le texte est daté (1987, traitement de texte). La relecture de Fu & Gray (2004), selon laquelle le paradoxe serait un comportement rationnel à court horizon, n'a pas été lue : voir « Non vérifié ».
- En conception : partir du fait que la personne commence par agir.
  - L'essai doit être sans risque : annulation, brouillon, aperçu, bac à sable.
  - L'aide doit se trouver là où l'on agit, pas dans une documentation à part.
  - Il faut aussi repérer les fausses ressemblances avec des outils connus (biais d'assimilation), qui induisent un modèle faux.

  Le défaut à chercher est la fonction efficace mais coûteuse à découvrir, que les gens n'apprennent jamais.

---

## 9. Charge cognitive

### Réduire la charge extrinsèque, celle qui vient de la présentation et pas de la tâche, en commençant par l'attention partagée
- Niveau de preuve : N2 (*Instructional Science*, revue critique des 35 articles les plus cités).
- Source : de Jong, T., 2010, « Cognitive load theory, educational research, and instructional design: some food for thought », *Instructional Science*, 38, 105-134 (accès libre). Texte lu : https://ris.utwente.nl/ws/files/6597420/Jong10cognitive.pdf
- Extrait lu : sur la charge intrinsèque, « material that contains a large number of interactive elements is regarded as more difficult than material with a smaller number of elements ». Sur la charge extrinsèque, citant van Merriënboer & Sweller (2005) : « load that is not necessary for learning (i.e., schema construction and automation) and that can be altered by instructional interventions ». Sur l'attention partagée, l'effet « refers to the separate presentation of domain elements that require simultaneous processing ».
- Portée / limites :
  - La théorie de Sweller (1988) concerne l'**apprentissage** en contexte pédagogique. Son transfert à l'usage d'une interface est une extrapolation.
  - De Jong relève que la charge intrinsèque dépend aussi des connaissances préalables de l'apprenant.
  - Il conteste la cohérence de la catégorie « germane » et l'additivité des charges.
  - L'article de 1988 lui-même n'a pas été lu.
- En conception : chercher les cas où la personne doit garder une information en tête pendant qu'elle en cherche une autre. Exemples : une référence à recopier depuis un autre écran, une légende éloignée du graphique, une aide dans une fenêtre séparée. Intégrer les éléments qui doivent être traités ensemble.

### Mesurer la charge perçue avec un instrument établi (NASA-TLX), en sachant que c'est une auto-évaluation
- Niveau de preuve : N3 (manuel officiel de la NASA, lu en OCR imparfait) et N4 (encyclopédie). L'article de Hart & Staveland (1988) n'a pas été lu.
- Source : NASA Ames Research Center, Human Performance Research Group, « NASA Task Load Index (NASA-TLX) v1.0 — Computerized Version » (manuel), https://ntrs.nasa.gov/api/citations/20000021487/downloads/20000021487.pdf ; Wikipédia, « NASA-TLX », https://en.wikipedia.org/wiki/NASA-TLX
- Extrait lu : dans le manuel, au sujet de la version antérieure à neuf sous-échelles, celles-ci rendaient l'outil difficile à employer, « making the scale impractical to use in a simulation or operational environment ». Sur Wikipédia : « It is a subjective self-reporting set of scores, and is not an objective measure of the Task Load. »
- Portée / limites :
  - L'outil comporte six sous-échelles : exigence mentale, physique et temporelle, performance, effort, frustration. Wikipédia décrit une pondération par 15 comparaisons par paires, souvent abandonnée au profit du « Raw TLX ».
  - Il a été développé sur trois ans et plus de 40 simulations en laboratoire.
  - L'OCR du manuel est fragmentaire.
  - De Jong (2010, entrée précédente) rappelle que beaucoup d'études ne mesurent pas directement la charge et la déduisent des résultats aux tests. L'échelle d'effort de Paas, très utilisée, n'a pas de format standard.
- En conception : pour comparer deux variantes d'un parcours complexe, faire passer le NASA-TLX, ou au moins sa version brute, juste après la tâche, en plus du temps et du taux de réussite. Le défaut à chercher est de conclure qu'une variante est plus « simple » sur la seule impression du concepteur, ou sur un questionnaire maison sans référence.

---

## Mythes et affirmations contestées

- **« L'opt-out fait exploser le don d'organes. »** C'est contesté. Johnson & Goldstein (2003) montrent un écart considérable de **consentement** selon le défaut. Selon The Decision Lab (https://thedecisionlab.com/insights/health/can-defaults-save-lives-the-power-of-default-options-on-life-saving-decisions), « in European countries where opt-out was the default, almost everyone consented to donate their organs ». L'effet se réplique en ligne (Chandrashekar et al., 2023, N = 1 920). Mais une comparaison de 35 pays de l'OCDE (Arshad, Anderson & Sharif, 2019, *Kidney International*) conclut :
  - pas de différence significative de donneurs **décédés** : « 20.3 versus 15.4 » par million ;
  - moins de donneurs **vivants** dans les pays opt-out : « 4.8 versus 15.7 » ;
  - « other barriers to organ donation must be addressed, even in settings where consent for donation is presumed ».

  Ce résumé a été lu tel que reproduit sur https://marketdesigner.blogspot.com/2019/04/deceased-organ-donation-comparison-of.html?m=0 ; la page PubMed n'a pas pu être ouverte. Pour l'UX : un défaut change ce qui est coché, pas forcément le résultat final.
- **« Le défaut marche toujours. »** C'est faux. Chandrashekar et al. (2023) ne répliquent pas l'effet du défaut de Johnson, Bellman & Lohse (2002). La méta-analyse de Jachimowicz et al. (2019) montre une forte hétérogénéité, y compris deux effets négatifs.
- **« Il faut 21 jours pour prendre une habitude. »** Aucune source lue ne l'appuie. L'étude citée en général (Lally et al., 2010) donne une médiane de 66 jours sur 39 participants bien ajustés, avec des valeurs de 18 à 254 jours, et sur des comportements de santé.
- **« La moitié des gens ne voient pas le gorille. »** C'est approximatif. Dans l'étude de 1999, sur 192 observateurs et toutes conditions confondues, 46 % ne voient pas l'événement. Le gorille seul n'est remarqué que par 44 %, et les taux varient fortement avec la difficulté de la tâche et la ressemblance de l'objet avec ce qui est surveillé.
- **« 83 % des radiologues ratent ce qu'ils devraient voir. »** C'est une mauvaise lecture de Drew et al. (2013) : 83 % ratent un gorille inséré, pas une pathologie. L'échantillon compte 24 personnes.
- **« Une animation suffit pour attirer l'œil sur une bannière. »** C'est contesté. Selon NN/g (2018), l'animation fait partie des traits qui signalent une publicité et entraînent l'évitement. Le résultat de Benway & Lane (1998) sur l'animation n'a été vu que dans des résumés de recherche : voir « Non vérifié ».
- **« L'affordance d'un bouton. »** C'est un usage contesté par Norman lui-même, qui recommande de parler de **signifiants** pour les indices perceptibles (2008, puis édition révisée de 2013).
- **Les principes de la Gestalt « prouvés » en UI.** L'article NN/g lu sur la proximité ne cite aucune expérience propre aux interfaces. Ces principes sont solides en perception, mais leurs effets chiffrés sur des interfaces ne sont pas établis par les sources lues ici.
- **Les trois types de charge cognitive.** C'est contesté. De Jong (2010) met en cause le statut de la charge « germane » et l'additivité des charges, ainsi que l'absence fréquente de mesure directe. La théorie porte sur l'apprentissage, pas sur l'usage courant.
- **La précision du KLM.** Elle vaut pour des experts, des tâches de routine et une exécution sans erreur (erreur RMS de 21 % sur 10 systèmes, en 1980). Sa transposition au mobile est contestée : Dunlop & Crossan (2000) sont cités par Wikipédia, non lus.
- **La date des gouffres.** Selon les sources, on lit 1985 (article dans *Human-Computer Interaction*) ou 1986 (chapitre du livre de Norman & Draper). Les deux sont exactes : la même analyse a paru deux fois.
- **Le nombre d'étapes d'exécution et d'évaluation.** Les sources découpent différemment les sept étapes, en 4 + 3 ou en 1 + 3 + 3. Il ne faut pas en faire un dogme.

## Non vérifié

Les pistes suivantes ont été cherchées sans qu'une source primaire puisse être lue, ou n'ont été vues que dans des extraits de résultats de recherche. Elles ne doivent pas entrer telles quelles dans le référentiel.

- **Les libellés des sept étapes dans l'édition révisée de 2013** (goal, plan, specify, perform, perceive, interpret, compare) : vus seulement dans des résumés et des fiches d'étude. Les libellés « mapping » et « feedback » comme principes de Norman n'ont pas non plus été lus dans son texte.
- **Les chiffres exacts de Johnson & Goldstein (2003)**, *Science*, 302, 1338-1339 : environ 82 % de consentement en opt-out contre 42 % en opt-in dans l'expérience en ligne, 161 répondants. Ni l'article ni un résumé chiffré n'ont été lus. Seul le résumé de deceased.design a été lu, sans chiffres.
- **Le résumé de Pirolli & Card (1999)**, *Psychological Review* : seules les métadonnées ont été lues, via PubPeer.
- **Le texte de Simon (1955, *QJE*) et de Simon (1956, *Psychological Review*)**, y compris la définition du niveau d'aspiration et la phrase « adapt well enough to satisfice ». Seule la citation « do not, in general, 'optimize' » a été lue, chez Stevens (2013).
- **Steve Krug, *Don't Make Me Think*, chapitre 2** (« Scanning, satisficing, and muddling through ») et sa référence à Simon : le livre n'a pas été lu.
- **James Reason, *Human Error* (1990)**, typologie slips / lapses / mistakes / violations et définition de l'erreur : vues seulement dans des extraits secondaires. La page de la HSE qui a été lue reprend cette typologie mais ne cite pas Reason.
- **Benway & Lane (1998)**, « Banner Blindness: Web Searchers Often Miss "Obvious" Links », *Internetworking* (ITG) ; et Benway (1998), *Proceedings of the HFES 42nd Annual Meeting*, p. 463-467 : le site d'origine est un domaine parqué, et le résumé n'a pas pu être ouvert. Le constat d'inefficacité de l'animation et celui d'un fond coloré qui, lui, attirerait l'attention n'ont été vus que dans des résumés de recherche.
- **Wharton, Rieman, Lewis & Polson (1994)**, chapitre original, et **le modèle CE+ / apprentissage par exploration** de Polson & Lewis : connus seulement par l'article NN/g de 2022.
- **Johnson-Laird**, définition du modèle mental : seul le glossaire de l'IxDF a été lu, et il ne cite pas de texte primaire.
- **Norman (1983)**, autres propriétés des modèles mentaux (« no firm boundaries », « unscientific », « limited ability to run ») : non présentes dans l'aperçu lu.
- **Sweller (1988)**, *Cognitive Science*, 12, 257-285 : non lu. Les définitions viennent de de Jong (2010). **Sweller, van Merriënboer & Paas (2019)** : la page de l'éditeur n'était pas accessible.
- **Hart & Staveland (1988)**, chapitre d'origine du NASA-TLX : non lu.
- **Le résumé de Lally et al. (2010)** : la page de l'éditeur Wiley et le dépôt ISPA n'étaient pas accessibles.
- **Marchionini (2006)**, « Exploratory Search: From Finding to Understanding », *CACM*, et sa typologie lookup / learn / investigate : le PDF n'était pas accessible.
- **Fu & Gray (2004)**, *Cognitive Science*, qui relisent le paradoxe de l'utilisateur actif comme un comportement rationnel : non lu.
- **Güntürkün et al. (2024)**, revue sur l'opt-out avec un ratio d'environ ×6 des inscriptions et des effets de débordement sur le don vivant : accès refusé (403).
- **Les études empiriques de la Gestalt en interface** (oculométrie, visualisations, 22 participants ; étude web 2 × 2 similarité × proximité) : accès refusé ou résultats non lus.
- **Dunlop & Crossan (2000)**, sur l'imprécision du KLM sur mobile : cités par Wikipédia, non lus.

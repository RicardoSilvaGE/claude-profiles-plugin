# Fiche `ux-preuves` — Architecture — décisions et ADR

> Fiche du skill `ux-preuves` (dev-fullstack), volet **architecture**, préchargé par `architecte`. Couvre : formats d'ADR (Nygard, MADR, Y-statements), normes de description (ISO/IEC/IEEE 42010:2022, arc42, C4), recherche empirique sur la décision d'architecture et ses biais, réversibilité (portes à sens unique ou double, dernier moment responsable), cycle de vie et érosion, seuil pour écrire un ADR.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Normes, versions et textes réglementaires
> **vieillissent** ; le droit change par révision : avant d'en faire dépendre une décision,
> relire la page officielle (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Périmètre : référentiel d'un agent « architecte logiciel senior » qui cadre avant implémentation et écrit des ADR dans `docs/decisions/` pour de petites applications web (Next.js, Supabase, Node, FastAPI, PWA sans build).

Méthode : chaque entrée vient d'une page ouverte pendant la recherche (WebFetch, ou curl + `pdftotext` pour les PDF arXiv et IEEE Software). Quand seul le résumé a été lu, c'est écrit. Plusieurs éditeurs (ScienceDirect, Springer, core.ac.uk, iso.org, Medium, figshare, Wiley) ont refusé l'accès (403 ou défi anti-robot) : ce qui en dépendait est classé en « Non vérifié ».

Niveaux : N1 norme ; N2 recherche revue par les pairs ou étude empirique (échantillon cité) ; N3 guide officiel d'une institution ou d'une plateforme ; N4 avis d'expert, livre, billet ou article de praticien.

---

## 1. Origine et formats d'ADR

### Un ADR tient en une ou deux pages, est numéroté sans réemploi, et porte au minimum Titre, Contexte, Décision, Statut, Conséquences
- Niveau de preuve : N4
- Source : Michael Nygard, 15.11.2011, « Documenting Architecture Decisions », https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions
- Extrait lu : « The whole document should be one or two pages long. » ; « ADRs will be numbered sequentially and monotonically. Numbers will not be reused. » ; « If a decision is reversed, we will keep the old one around, but mark it as superseded. »
- Portée / limites : c'est le texte fondateur, un billet de praticien qui s'appuie sur quelques mois d'usage (« We've been using this format on a few of our projects since early August »). Le format **ne contient pas de section « alternatives »**. Les statuts cités sont proposed, accepted, deprecated et superseded. Le Contexte est décrit comme « value-neutral », et les Conséquences doivent toutes être listées : « not just the "positive" ones ».
- En pratique : sur un ADR, vérifier que les Conséquences contiennent au moins un effet négatif ou neutre, et qu'un ADR remplacé est marqué `superseded` avec un lien vers son successeur, pas effacé.

### Une décision « architecturalement significative » touche la structure, les qualités non fonctionnelles, les dépendances, les interfaces ou les techniques de construction
- Niveau de preuve : N4
- Source : Michael Nygard, 2011, « Documenting Architecture Decisions », https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions
- Extrait lu : « "architecturally significant" decisions: those that affect the structure, non-functional characteristics, dependencies, interfaces, or construction techniques. »
- Portée / limites : c'est une liste de domaines, pas un seuil de coût. AWS Prescriptive Guidance la reprend presque mot pour mot en citant Richards et Ford 2020 (voir plus bas). Elle couvre les « one-way doors » du profil : schéma de données (structure), frontière de module (structure), dépendance structurante (dependencies), format public d'API (interfaces).
- En pratique : pour chaque choix du cadrage, se demander s'il touche l'un de ces cinq domaines. Si oui, il est candidat à l'ADR.

### MADR 4.0.0 fait des options considérées une section de base et ajoute une section « Confirmation » qui dit comment vérifier le respect de la décision
- Niveau de preuve : N4 (gabarit communautaire, organisation GitHub `adr`)
- Source : organisation adr, MADR 4.0.0 publié le 17.09.2024, « Markdown Architectural Decision Records », https://adr.github.io/madr/ et https://raw.githubusercontent.com/adr/madr/main/template/adr-template.md
- Extrait lu : « ## Considered Options » ; « Describe how the implementation / compliance of the ADR can/will be confirmed. Is there any automated or manual fitness function? » ; « Note that although we classify this element as optional, it is included in many ADRs. »
- Portée / limites : Context and Problem Statement, Considered Options et Decision Outcome ne portent pas la mention « optional element ». Decision Drivers, Consequences, Confirmation, Pros and Cons et More Information sont optionnels. Le statut (« proposed | rejected | accepted | deprecated | … | superseded by ADR-0123 ») est une métadonnée optionnelle. Le CHANGELOG mentionne des modifications non publiées (« [unreleased] ») après la 4.0.0.
- En pratique : demander à chaque ADR « comment saura-t-on que le code respecte la décision ? » (test, règle de lint, revue). Sans réponse, la décision va s'éroder en silence.

### MADR admet une décision à option unique quand un critère éliminatoire écarte le reste, et prévoit de dire quand la décision devra être réexaminée
- Niveau de preuve : N4
- Source : organisation adr, 2024, gabarit `adr-template.md` de MADR, https://raw.githubusercontent.com/adr/madr/main/template/adr-template.md
- Extrait lu : « Chosen option: "{title of option 1}", because {justification. e.g., only option, which meets k.o. criterion decision driver | which resolves force {force} | … | comes out best (see below)}. » ; « define when/how this decision the decision should be realized and if/when it should be re-visited. »
- Portée / limites : le gabarit précise « numbers of options can vary », sans minimum. Le réexamen est rangé dans « More Information », une section optionnelle.
- En pratique : une option unique est acceptable si l'ADR nomme le critère éliminatoire qui a écarté les autres. Une option unique sans critère nommé est le défaut à signaler.

### Le Y-statement réduit une décision à une phrase : contexte, préoccupation, option retenue, qualité visée, inconvénient accepté
- Niveau de preuve : N4 (article d'IEEE Software, magazine de praticiens)
- Source : Uwe Zdun, Rafael Capilla, Huy Tran, Olaf Zimmermann, IEEE Software 30(6):46-53, novembre 2013 (DOI 10.1109/MS.2013.97, métadonnées vérifiées sur Crossref), « Sustainable Architectural Design Decisions », republié par InfoQ le 09.03.2014 : https://www.infoq.com/articles/sustainable-architectural-design-decisions/
- Extrait lu : « In the context of <use case/user story u>, facing <concern c> we decided for <option o> to achieve <quality q>, accepting <downside d>. » ; « Capturing significant decisions and their rationale is difficult and often neglected because doing so requires considerable effort. »
- Portée / limites : la forme publiée en 2013 n'a **pas** de clause « and neglected <other options> ». La variante plus longue souvent citée n'a pas été trouvée dans la source lue. Les auteurs proposent cinq critères de « décision durable » : Strategic, Measurable and Manageable, Achievable and Realistic, Rooted in Requirements, Timeless. Ils recommandent de commencer par une documentation légère, puis de détailler les décisions importantes une fois stabilisées.
- En pratique : si l'ADR d'une petite application ne tient pas en un Y-statement lisible, la décision n'est probablement pas encore claire. Exiger le « accepting <downside> » : c'est la conséquence négative assumée.

### Un ADR accepté devient immuable : on le remplace par un nouvel ADR, on ne le réécrit pas
- Niveau de preuve : N3
- Source : AWS Prescriptive Guidance, « Architectural decision record process » (date de page non relevée), https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/adr-process.html
- Extrait lu : « When the team accepts an ADR, it becomes immutable. If new insights require a different decision, the team proposes a new ADR. » ; « At a minimum, each ADR should define the context of the decision, the decision itself, and the consequences of the decision »
- Portée / limites : le minimum exigé est Contexte, Décision, Conséquences. AWS **n'exige pas** d'alternatives dans ce minimum. Les statuts sont Proposed, Accepted, Rejected et Superseded. Le guide vise des équipes, avec un propriétaire d'ADR et une revue collective.
- En pratique : quand une décision change, écrire un nouvel ADR qui remplace l'ancien et marquer l'ancien `Superseded`. Ne jamais modifier le corps d'un ADR accepté.

### La revue d'un ADR commence par une lecture silencieuse, et un rejet garde sa raison pour ne pas rouvrir le débat
- Niveau de preuve : N3
- Source : AWS Prescriptive Guidance, « Architectural decision record process », https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/adr-process.html
- Extrait lu : « On average, 10 to 15 minutes should be enough. » ; « the ADR owner adds a reason for the rejection to prevent future discussions on the same topic. »
- Portée / limites : c'est un rituel d'équipe. Pour un développeur seul, l'équivalent est la relecture de l'ADR par l'utilisateur avant que la décision ne passe à `Accepted`. AWS rattache aussi l'ADR à la revue de code : un reviewer qui voit une violation renvoie l'auteur à l'ADR.
- En pratique : garder les ADR rejetés avec leur motif. Ils évitent de reproposer la même option trois mois plus tard.

### Un ADR doit porter une seule décision ; l'exploration détaillée des options peut vivre dans un document de conception séparé
- Niveau de preuve : N4 (billet du blog d'architecture AWS, retour d'expérience de praticiens)
- Source : Christoph Kappey, Dominik Goby, Darius Kunce, 20.03.2025, « Master architecture decision records (ADRs): Best practices for effective decision-making », https://aws.amazon.com/blogs/architecture/master-architecture-decision-records-adrs-best-practices-for-effective-decision-making/
- Extrait lu : « Keep ADRs concise by focusing on a single decision. » ; « Use a separate design document mechanism to explore alternative options thoroughly. »
- Portée / limites : le billet s'appuie sur « over 200 ADRs » et plus de trois ans d'usage, sans mesure d'effet. Il demande quand même que l'ADR mentionne les alternatives considérées et la raison du choix.
- En pratique : dans l'ADR, des alternatives écartées en deux lignes chacune ; l'étude comparative longue, si elle existe, dans un document lié.

### Microsoft demande les options considérées, le niveau de confiance de la décision, et de ne consigner que les choix structurants ou difficiles à inverser
- Niveau de preuve : N3
- Source : Microsoft, Azure Well-Architected Framework, page datée du 10.04.2026, « Maintain an architecture decision record (ADR) », https://learn.microsoft.com/en-us/azure/well-architected/architect-role/architecture-decision-record
- Extrait lu : « Only include choices that affect the system's structure, key quality attributes, or are difficult to reverse. » ; « Record the confidence level of the decision. » ; « The ADR serves as an append-only log. Don't go back and edit accepted records. »
- Portée / limites : c'est la seule source institutionnelle lue qui fait de la **difficulté d'inversion** un critère explicite d'inclusion, ce qui appuie la règle de réversibilité du profil. Microsoft recommande aussi de découper une décision en phases (court, moyen, long terme), un ADR par phase, et d'éviter que l'ADR devienne un guide de conception.
- En pratique : ajouter une ligne « Confiance : faible / moyenne / élevée » à l'ADR. Une confiance faible appelle un signal de réexamen précis.

### Une décision prise sans être écrite sera oubliée, puis contredite sans le savoir
- Niveau de preuve : N3
- Source : Microsoft, 2026, « Maintain an architecture decision record (ADR) », https://learn.microsoft.com/en-us/azure/well-architected/architect-role/architecture-decision-record
- Extrait lu : « A decision that's made but never recorded will likely be forgotten, leading to repeated debates or later changes that unknowingly contradict the original intent. »
- Portée / limites : c'est une affirmation de guide, pas une mesure. Elle rejoint l'érosion d'architecture étudiée en section 5.
- En pratique : chercher dans le code les choix structurants qui n'ont pas d'ADR (ORM, mode d'authentification, découpage des dossiers, format d'API) : ce sont des décisions implicites.

### Google déclenche un ADR quand rien n'existe pour décider, quand une solution n'est pas documentée, ou quand au moins deux options techniques sont en concurrence
- Niveau de preuve : N3
- Source : Google Cloud Architecture Center, « Architecture decision records overview » (date de page non relevée), https://docs.cloud.google.com/architecture/architecture-decision-records
- Extrait lu : « When there are two or more engineering options and you want to document your thoughts and reasons behind the selection. » ; « If you make adjustments, include the previous decision and why a change is made. »
- Portée / limites : le contenu suggéré comprend auteurs, contexte, exigences fonctionnelles et non fonctionnelles, parcours utilisateur critique concerné, aperçu des options et décision motivée. Google n'impose pas l'immutabilité au même degré qu'AWS ou Microsoft.
- En pratique : « y a-t-il au moins deux options sérieuses ? » est un déclencheur d'ADR simple à appliquer pendant un cadrage.

### Le cadre ADR du gouvernement britannique exige statut, contexte, décision, conséquences et parties consultées, mais pas d'options
- Niveau de preuve : N3
- Source : GDS / GOV.UK, publié le 04.11.2025, « Architectural Decision Record Framework », https://www.gov.uk/government/publications/architectural-decision-record-framework/architectural-decision-record-framework
- Extrait lu : « An architecture decision (AD) is a choice that affects the structure, quality attributes, or behaviour of a system. » ; « Regularly review and update the ADR to reflect any changes in the context or consequences of the decision. »
- Portée / limites : la liste qui suit « Each ADR should contain » donne : title, date, status, context, decision, consequences, stakeholders consulted, links to supporting documents. Le texte ne contient ni « option » ni « alternative » (recherche dans la page). Il prévoit de **mettre à jour** l'ADR, ce qui contredit l'immutabilité d'AWS et de Microsoft. Le cadre n'est obligatoire que pour les décisions qui engagent plusieurs administrations. Le GDS Way (https://gds-way.digital.cabinet-office.gov.uk/standards/architecture-decisions.html) recommande de son côté de stocker les décisions « in version control ».
- En pratique : l'absence d'alternatives n'est pas universellement considérée comme un défaut. Si le profil l'exige, c'est un choix plus strict que le standard britannique, et il faut le justifier par la recherche sur les biais (section 3).

### Un ADR doit lister les alternatives sérieuses, le niveau de confiance, et les changements de contexte qui devraient déclencher un réexamen
- Niveau de preuve : N4
- Source : Martin Fowler, 24.03.2026, « Architecture Decision Record » (bliki), https://martinfowler.com/bliki/ArchitectureDecisionRecord.html
- Extrait lu : « it's valuable to explicitly list all the serious alternatives that were considered, together with their pros and cons. » ; « This is a good place to mention any changes in the product context that should trigger the team to reevaluate the decision. » ; « Keep the ADR short and to the point - typically a single page. »
- Portée / limites : c'est la source la plus proche du format du profil. Elle couvre les alternatives, la confiance et le déclencheur de réévaluation, avec une page de long. Fowler précise : « Once an ADR is accepted, it should never be reopened or changed - instead it should be superseded. » C'est un avis d'expert, pas une étude.
- En pratique : la section « Signal de réexamen » du profil correspond exactement aux « changes in the product context that should trigger the team to reevaluate ». Elle doit nommer une condition observable, pas une date.

## 2. Normes et modèles de description d'architecture

### ISO/IEC/IEEE 42010:2022 traite les décisions d'architecture et leur justification, mais n'impose aucun format d'enregistrement
- Niveau de preuve : N1 (lu : la fiche IEEE et la table des matières d'un aperçu de 15 pages, pas les clauses normatives)
- Source : ISO/IEC/IEEE, publié le 07.11.2022, « ISO/IEC/IEEE 42010:2022 Software, systems and enterprise — Architecture description », fiche IEEE https://standards.ieee.org/ieee/42010/6846/ ; aperçu iTeh https://cdn.standards.iteh.ai/samples/74393/fc7b7f103d8446a4b87a3261e31370d3/ISO-IEC-IEEE-42010-2022.pdf
- Extrait lu : « This document does not specify any format or media for recording an AD. » ; « Architectures are not the subject of this document. » ; table des matières : « 5.2.12 Architecture decisions and rationale » et « 6.10 Recording of architecture decisions and rationale », sous-clauses « 6.10.1 Decision recording » et « 6.10.2 Rationale recording ».
- Portée / limites : la page iso.org a renvoyé un défi anti-robot ; le texte des clauses 6.10.1 et 6.10.2 n'a **pas** été lu. On sait que la norme consacre une clause à l'enregistrement des décisions et de leur justification. On ne sait pas, d'après ce qui a été lu, ce qu'elle exige précisément (alternatives, statuts). Ici « AD » veut dire *architecture description*, pas *architecture decision*.
- En pratique : on ne peut pas dire « la norme impose des ADR ». On peut dire que la justification des décisions fait partie de ce que la norme attend d'une description d'architecture.

### arc42 (section 9) consigne les décisions « importantes, coûteuses, de grande portée ou risquées » et définit une décision comme le choix d'une alternative selon des critères
- Niveau de preuve : N4 (gabarit de praticiens, largement diffusé)
- Source : arc42, « 9. Architecture Decisions » (date de page non relevée), https://docs.arc42.org/section-9/
- Extrait lu : « Important, expensive, large scale or risky architecture decisions including rationales. With "decisions" we mean selecting one alternative based on given criteria. » ; « Stakeholders of your system should be able to comprehend and retrace your decisions. »
- Portée / limites : arc42 propose trois formes au choix : un ADR par décision, une liste ou un tableau ordonné par importance, ou des sections détaillées. La définition « selecting one alternative based on given criteria » appuie l'idée qu'une décision suppose des options.
- En pratique : « importante, coûteuse, de grande portée ou risquée » est un filtre qualitatif publié qui peut remplacer un seuil chiffré en jours.

### Le modèle C4 sert à dessiner l'architecture à quatre niveaux ; il ne documente pas les décisions
- Niveau de preuve : N4
- Source : Simon Brown, site officiel du C4 model (date de page non relevée), https://c4model.com/
- Extrait lu : « The C4 model is an easy to learn, developer friendly approach to software architecture diagramming » ; « Notation independent . Tooling independent . »
- Portée / limites : les quatre niveaux sont system context, containers, components et code, avec des diagrammes annexes (system landscape, dynamic, deployment). La page d'accueil ne parle pas d'ADR. C4 complète un ADR (montrer la frontière concernée), il ne le remplace pas.
- En pratique : pour une petite application, un diagramme de contexte et un diagramme de conteneurs suffisent souvent à situer un ADR. Le code et les composants se dessinent rarement.

## 3. Recherche empirique sur la décision d'architecture

### Les praticiens jugent la justification des décisions utile, mais disent rencontrer des obstacles à la documenter
- Niveau de preuve : N2 (enquête, 81 réponses valides) — résumé seul lu
- Source : Antony Tang, Muhammad Ali Babar, Ian Gorton, Jun Han, 2006, « A survey of architecture design rationale », Journal of Systems and Software 79(12):1792-1804, DOI 10.1016/j.jss.2006.04.029 ; résumé lu via https://api.semanticscholar.org/graph/v1/paper/DOI:10.1016/j.jss.2006.04.029
- Extrait lu : « Based on 81 valid responses, this study has discovered that practitioners recognize the importance of documenting design rationale and frequently use them to reason about their design choices. However, they have indicated barriers to the use and documentation of design rationale. »
- Portée / limites : c'est une enquête déclarative de 2006. Elle mesure une perception, pas un effet sur la qualité des décisions. Les pourcentages détaillés n'ont pas été lus (ScienceDirect, core.ac.uk et figshare ont refusé l'accès).
- En pratique : un ADR doit coûter peu à écrire, sinon il ne sera pas écrit. C'est un argument pour le format court du profil.

### Une heure d'atelier de « debiasing » a réduit la part de décisions biaisées de 52 % à 31 % chez des étudiants en master
- Niveau de preuve : N2 (expérience avant/après, 44 étudiants en master répartis en 12 équipes, sans groupe témoin)
- Source : Klara Borowa, Maria Jarek, Gabriela Mystkowska, Weronika Paszko, Andrzej Zalewski, 2022, « Debiasing architectural decision-making: a workshop-based training approach », arXiv:2206.14701, https://arxiv.org/pdf/2206.14701
- Extrait lu : « In most cases (10 out of 12 groups), the teams' reasoning improved after the workshop. » ; « Overall we found 641 decisions - 266 biased, 281 non-biased and 94 neutral. 52% of decisions before the workshop were biased, compared to 31% after. »
- Portée / limites : les trois techniques enseignées sont (1) anti-ancrage : « the individual that presents it must explicitly list one disadvantage of the solution », (2) anti-confirmation : un membre de l'équipe repère les phrases du type « We already decided that », (3) anti-optimisme : « the team must explicitly mention the risks associated with the design decisions ». Les participants étaient tous étudiants (validité externe limitée, reconnue par les auteurs). Le test est un Wilcoxon apparié, et les thèmes des deux tâches étaient différents.
- En pratique : exiger dans l'ADR au moins un inconvénient de l'option retenue et au moins un risque. Ce sont les deux techniques testées, et c'est plus que « des conséquences ».

### Une simple présentation sur les biais cognitifs n'a pas suffi à réduire leur effet
- Niveau de preuve : N2 (étude pilote, deux groupes d'étudiants)
- Source : Klara Borowa, Robert Dwornik, Andrzej Zalewski, 2021, « Is knowledge the key? An experiment on debiasing architectural decision-making - a pilot study », arXiv:2111.04362, https://arxiv.org/pdf/2111.04362 (publié dans les actes de PROFES 2021, pp. 207-214, selon la bibliographie de l'article de 2022)
- Extrait lu : « The preliminary results show that this kind of treatment is ineffective. »
- Portée / limites : c'est un pilote à petit échantillon. Il explique pourquoi l'atelier de 2022 impose des exercices pratiques plutôt qu'un exposé.
- En pratique : une consigne « attention aux biais » dans le prompt de l'agent ne suffit pas. Ce qui a été testé, ce sont des **gestes obligatoires** : lister des options, un inconvénient, un risque.

### Générer plusieurs options avant de trancher, puis lister un inconvénient et un risque pour chacune : l'ancrage et l'optimisme baissent significativement, praticiens compris
- Niveau de preuve : N2 (expérience contrôlée, 16 étudiants et 20 praticiens, paires groupe témoin / groupe atelier)
- Source : Klara Borowa, Rodrigo Rebouças de Almeida, Marion Wiese, 06.02.2025, « Debiasing Architectural Decision-Making: An Experiment With Students and Practitioners », arXiv:2502.04011, https://arxiv.org/pdf/2502.04011
- Extrait lu : « anchoring can cause architects to unconsciously prefer the first architectural solution that they came up with, without considering any solution alternatives. » ; « In particular, anchoring and optimism bias occurrences decreased significantly. We also found that practitioners were more susceptible to cognitive biases than students »
- Portée / limites : la première technique enseignée est « Generating multiple solution options », avec « it seems prudent to explicitly list solution alternatives before architects believe that one single solution is the best option ». Viennent ensuite « Listing at least one drawback » et « Listing at least one risk ». L'échantillon est petit, et les auteurs attribuent l'effet plus fort chez les praticiens à leur « attachment » à leurs systèmes, ce qu'ils présentent comme une hypothèse. La revue de publication n'a pas été vérifiée (préprint arXiv lu).
- En pratique : c'est le meilleur appui trouvé pour la règle « au moins une alternative crédible ». L'ordre compte : les options s'écrivent **avant** de choisir, pas après pour habiller une décision déjà prise.

### La réflexion explicite sur son propre raisonnement améliore la qualité de la discussion de conception, mais seulement sous certaines conditions
- Niveau de preuve : N2 (études de cas multiples, 12 groupes d'étudiants, groupes test et témoin) — résumé seul lu
- Source : Maryam Razavian, Antony Tang, Rafael Capilla, Patricia Lago, 2016, « In two minds: how reflections influence software design thinking », Journal of Software: Evolution and Process 28(6):394-426, DOI 10.1002/smr.1776 ; page lue : https://research.vu.nl/en/publications/in-two-minds-how-reflections-influence-software-architecture-desi/
- Extrait lu : « We theorize a two-mind model of design thinking. » ; « We found that reflection (Mind 2) improves the quality of design discourse (Mind 1) under certain preconditions. »
- Portée / limites : les préconditions n'ont pas été lues (texte intégral inaccessible, Wiley a refusé). Les participants sont étudiants, et c'est la qualité du **discours** qui est mesurée, pas celle du système livré.
- En pratique : le rôle de l'agent architecte, qui relit et questionne le raisonnement, correspond à « Mind 2 ». Ses questions doivent porter sur le raisonnement (hypothèses, options, risques), pas seulement sur le résultat.

### Les architectes choisissent d'abord ce qui leur est familier ou rapide à mettre en œuvre, et lister toutes les alternatives est jugé irréaliste en conception logicielle
- Niveau de preuve : N2 (questionnaire de 63 participants et 13 entretiens)
- Source : Klara Borowa, Rafał Lewańczyk, Klaudia Stpiczyńska, Patryk Stradomski, Andrzej Zalewski, 25.09.2023, « What rationales drive architectural decisions? An empirical inquiry », arXiv:2309.14164, https://arxiv.org/pdf/2309.14164
- Extrait lu : « We found that, overall, architects prefer to choose solutions which are familiar to them or that guarantee fast software implementation. » ; « The traditional decision-making process, which includes listing all possible alternatives and their attributes, is impractical for software design decisions »
- Portée / limites : la justification la plus citée est « Ease of use for development ». Les architectes de milieu de carrière (5 à 15 ans) sont décrits comme plus ouverts aux nouvelles solutions. La phrase sur l'irréalisme de l'exhaustivité est une affirmation de l'introduction qui cite un autre travail, pas un résultat de l'étude.
- En pratique : exiger **une** alternative crédible, pas toutes. Et vérifier qu'une justification « on connaît déjà » est écrite comme telle : c'est une raison légitime, mais elle doit être visible.

### Les décisions d'architecture se prennent surtout en équipe, sur un mode consultatif, et elles conditionnent les choix de conception en aval
- Niveau de preuve : N2 (étude de cas exploratoire, 15 architectes interviewés dans une grande entreprise européenne)
- Source : Sandun Dasanayake, Jouni Markkula, Sanja Aaramaa, Markku Oivo, 2017, « An Empirical Study on Collaborative Architecture Decision Making in Software Teams », arXiv:1707.00107, https://arxiv.org/pdf/1707.00107
- Extrait lu : « The results reveal that the majority of software teams make architecture decisions collaboratively. » ; « Architecture decisions stand out from the rest because they dictate all downstream design choices; thus, they have far-reaching consequences and are hard to change [3]. »
- Portée / limites : la seconde phrase est une affirmation d'introduction qui renvoie à une autre source, pas un résultat. Une seule entreprise a été étudiée. Le lieu de publication n'a pas été vérifié (préprint lu). Une étude voisine des mêmes auteurs (arXiv:1610.09240, trois entreprises) rappelle que documenter l'architecture sans la justification « will considerably undermine its usefulness ».
- En pratique : le critère « contraint d'autres décisions » se teste en listant ce que la décision rend impossible ou obligatoire ensuite. Si la liste est vide, la décision n'est probablement pas structurante.

### Dans les dépôts open source, l'adoption des ADR reste faible, et la moitié des dépôts qui en ont n'en contiennent qu'un à cinq
- Niveau de preuve : N2 (étude de dépôts GitHub, type MSR) — résumé seul lu
- Source : Georg Buchgeher, Stefan Schöberl, Verena Geist, Bernhard Dorninger, Philipp Haindl, Rainer Weinreich, 2023, « Using Architecture Decision Records in Open Source Projects—An MSR Study on GitHub », IEEE Access 11:63725-63740, DOI 10.1109/ACCESS.2023.3287654 ; page lue : https://research.jku.at/en/publications/using-architecture-decision-records-in-open-source-projects-an-ms/
- Extrait lu : « the adoption of ADRs is still low, although the number of repositories using ADRs is increasing every year. » ; « About 50% of all repositories with ADRs contain just one to five ADRs. »
- Portée / limites : le nombre total de dépôts analysés n'est pas donné dans le résumé lu. La plupart des dépôts suivent le gabarit de Nygard. Les auteurs écrivent « the concept has been tried but not yet definitively adopted ».
- En pratique : le risque réel n'est pas l'excès d'ADR mais l'abandon après les premiers. Un format court et un déclencheur clair favorisent la continuité.

### Dans une expérience récente, le gabarit de Nygard a été mieux compris et adopté que MADR par des étudiants
- Niveau de preuve : N2 (analyse DESMET par deux experts sur cinq gabarits, puis expérience contrôlée avec 33 étudiants en licence)
- Source : Fernando Nogueira, Nabson Silva, Tayana Conte, 30.04.2026, « One Size Fits All? An Empirical Comparison of ADR Templates regarding Comprehension, Usability, and Ease of Adoption », arXiv:2604.27333, https://arxiv.org/pdf/2604.27333
- Extrait lu : « In the subsequent controlled experiment, Nygard's template outperformed MADR in terms of the Overall Score. » ; « Nygard supports concise and objective documentation, while MADR facilitates structural details and specific architectural requirements. »
- Portée / limites : c'est un préprint récent, avec des participants débutants. Les gabarits comparés sont Tyree/Akerman, Nygard, arc42, Y-statements et MADR. L'étude mesure la compréhension et l'utilisabilité, pas la qualité des décisions.
- En pratique : un format court proche de Nygard, complété de deux ou trois champs ciblés (alternatives, signal de réexamen), est cohérent avec cette évidence. Un gabarit MADR complet serait plus lourd sans gain démontré pour un développeur seul.

## 4. Réversibilité

### Les décisions irréversibles (« one-way doors ») se prennent lentement et avec consultation ; les décisions réversibles (« two-way doors ») se prennent vite, par une personne ou un petit groupe
- Niveau de preuve : N4 (lettre aux actionnaires, contexte de gestion d'entreprise)
- Source : Jeff Bezos, lettre aux actionnaires sur l'exercice 2015, déposée à la SEC le 05.04.2016 (pièce EX-99.1 d'un 8-K), https://www.sec.gov/Archives/edgar/data/1018724/000119312516530910/d168744dex991.htm
- Extrait lu : « Some decisions are consequential and irreversible or nearly irreversible – one-way doors – and these decisions must be made methodically, carefully, slowly, with great deliberation and consultation. » ; « But most decisions aren't like that – they are changeable, reversible – they're two-way doors. » ; « Type 2 decisions can and should be made quickly by high judgment individuals or small groups. »
- Portée / limites : c'est la lettre **2015**, publiée en avril 2016, pas 2016. Bezos parle de décisions d'entreprise, pas d'architecture logicielle ; l'application au logiciel est une extension. Il nomme aussi le travers inverse : appliquer le processus lourd aux décisions de type 2 mène à « slowness, unthoughtful risk aversion, failure to experiment sufficiently ».
- En pratique : la règle du profil « two-way door → trancher vite » est fidèle à la source. Le défaut à surveiller est l'excès d'ADR sur des choix réversibles, autant que leur absence sur les choix irréversibles.

### La plupart des décisions devraient se prendre avec environ 70 % de l'information souhaitée ; se tromper coûte souvent moins qu'on ne le croit
- Niveau de preuve : N4
- Source : Jeff Bezos, lettre aux actionnaires sur l'exercice 2016, déposée à la SEC en 2017, https://sec.gov/Archives/edgar/data/1018724/000119312517120198/d373368dex991.htm
- Extrait lu : « most decisions should probably be made with somewhere around 70% of the information you wish you had. » ; « Many decisions are reversible, two-way doors. » ; « being wrong may be less costly than you think »
- Portée / limites : le chiffre de 70 % est une heuristique personnelle, pas une mesure. La lettre introduit aussi « disagree and commit ».
- En pratique : sur une two-way door, ne pas bloquer le cadrage pour une information manquante. Noter l'hypothèse et le signal qui ferait revenir en arrière.

### Une des tâches majeures de l'architecte est de supprimer de l'architecture en éliminant l'irréversibilité
- Niveau de preuve : N4 (chronique d'IEEE Software)
- Source : Martin Fowler, juillet/août 2003, « Who Needs an Architect? », IEEE Software, https://martinfowler.com/ieeeSoftware/whoNeedsArchitect.pdf
- Extrait lu : « I think that one of an architect's most important tasks is to remove architecture by finding ways to eliminate irreversibility in software designs. » ; « Remember Johnson's secondary definition: "Architecture is the decisions that you wish you could get right early in a project." »
- Portée / limites : Fowler en tire « things that people perceive as hard to change », pas une citation de Johnson. Il rapporte aussi l'analyse de l'économiste Enrico Zaninotto, selon qui l'irréversibilité est « one of the prime drivers of complexity ».
- En pratique : la clause du profil « chercher à convertir une one-way door en two-way door » est appuyée ici. Questions à poser : une couche d'abstraction, un feature flag, une migration réversible, une API versionnée rendraient-ils la décision réversible ?

### « L'architecture représente les décisions de conception significatives, où le significatif se mesure au coût du changement » (Booch)
- Niveau de preuve : N4 (diapositives d'une présentation, hébergées par un tiers)
- Source : Grady Booch, « Architecting the Unknown » (présentation IBM, date d'origine non indiquée ; mise en ligne le 15.03.2023 sur le site hôte), diapositive 40, https://www.sambuz.com/doc/architecting-the-unknown-ppt-presentation-322276
- Extrait lu : « A system's architecture is defined by its significant design decisions (where significant is measured by the cost of change) »
- Portée / limites : la forme longue souvent citée (« Architecture represents the significant design decisions that shape a system, where significant is measured by cost of change ») n'a été trouvée que dans des sources secondaires. Le texte des diapositives de Kevlin Henney n'a pas pu être extrait (images). Aucune source primaire datée n'a été trouvée.
- En pratique : le critère « coûteuse à inverser » du profil est cohérent avec cette définition. La formule exacte ne doit être attribuée à Booch qu'avec la mention « présentation, date inconnue ».

### Différer l'engagement jusqu'au « dernier moment responsable » : celui où ne pas décider élimine une alternative importante
- Niveau de preuve : N4 (livre de praticiens, cité de seconde main)
- Source : Mary et Tom Poppendieck, « Lean Software Development: An Agile Toolkit », cité par Jeff Atwood, 17.10.2006, « The Last Responsible Moment », https://blog.codinghorror.com/the-last-responsible-moment/
- Extrait lu : « delay commitment until the last responsible moment, that is, the moment at which failing to make a decision eliminates an important alternative. »
- Portée / limites : le livre n'a pas été ouvert (la page O'Reilly a renvoyé 403). La citation est lue chez Atwood, et l'année 2003 du livre n'a pas été vérifiée.
- En pratique : pour une one-way door qui n'est pas encore urgente, l'ADR peut rester `Proposé`. Écrire alors quelle échéance ou quel événement fermerait une alternative.

### Le « dernier moment responsable » appliqué seul pousse à décider trop tard ; mieux vaut viser le moment le plus responsable
- Niveau de preuve : N4
- Source : Rebecca Wirfs-Brock, 18.01.2011, « Agile Architecture Myths #2: Architecture Decisions Should Be Made At the Last Responsible Moment », https://wirfs-brock.com/rebecca/blog/2011/01/18/agile-architecture-myths-2-architecture-decisions-should-be-made-at-the-last-responsible-moment/
- Extrait lu : « Just having a last-responsible moment mindset leaves me open to making late decisions. »
- Portée / limites : c'est une critique d'expert, sans données. Elle complète la règle de Bezos : pour une two-way door, décider tôt ne coûte presque rien.
- En pratique : se méfier d'un cadrage où toutes les décisions structurantes sont « à trancher plus tard ». Différer doit être motivé par une information attendue, nommée.

## 5. Cycle de vie d'un ADR et érosion

### Le manque de documentation, notamment des décisions et de leur justification, revient parmi les causes de l'érosion d'architecture
- Niveau de preuve : N2 (étude de cartographie systématique, 73 études primaires)
- Source : Ruiyin Li, Peng Liang, Mohamed Soliman, Paris Avgeriou, 2022, « Understanding software architecture erosion: A systematic mapping study », Journal of Software: Evolution and Process, DOI 10.1002/smr.2423 ; préprint lu : https://arxiv.org/pdf/2112.10934
- Extrait lu : « Lack of documentation denotes that the previous knowledge (such as design decisions and their rationales) is not available or documented (such as undocumented design decisions and assumptions), which hinders the subsequent architecture enhancements and modifications » ; « nearly half of them (41.7%, 10 out of 24) regard violations of design decisions, principles (e.g., abstraction and encapsulation), or constraints as the symptoms of AEr. »
- Portée / limites : dans le tableau des causes, « Lack of documentation » est associé à 10 études sur 73 (décompte des références du tableau 11). C'est une fréquence de mention dans la littérature, pas une mesure d'effet. Les mêmes auteurs ont étudié la perception des développeurs (ICPC 2021, arXiv:2103.11392 : enquête auprès de 10 participants et 4 entretiens) et trouvent des causes techniques et non techniques.
- En pratique : un ADR sans « Confirmation » ni signal de réexamen ne protège pas contre l'érosion. C'est la violation non détectée de la décision qui érode.

### Aucune stratégie unique ne suffit à contrôler l'érosion d'architecture
- Niveau de preuve : N2 (revue de littérature) — résumé seul lu, par extraits
- Source : Lakshitha de Silva, Dharini Balasubramaniam, 2012, « Controlling software architecture erosion: A survey », Journal of Systems and Software 85(1):132-151, DOI 10.1016/j.jss.2011.07.036 ; page lue : https://research-portal.st-andrews.ac.uk/en/publications/controlling-software-architecture-erosion-a-survey/
- Extrait lu : « Software architectures capture the most significant properties and design constraints of software systems. » ; « controlling such architecture erosion becomes an important concern for software architects and developers. »
- Portée / limites : la conclusion (pas de stratégie unique, besoin d'un cadre global) n'est connue que par paraphrase du résumé. Aucun chiffre n'a été lu.
- En pratique : l'ADR n'est qu'une des défenses. Il faut l'accompagner d'une vérification (test d'architecture, revue) pour les décisions one-way.

## 6. Seuil : quand écrire un ADR

### Spotify : écrire un ADR à chaque décision d'impact significatif, chaque équipe définissant ce qu'est « significatif », et rattraper les décisions non documentées
- Niveau de preuve : N4 (blog d'ingénierie d'entreprise)
- Source : Josef Blake, 14.04.2020, « When Should I Write an Architecture Decision Record », https://engineering.atspotify.com/when-should-i-write-an-architecture-decision-record
- Extrait lu : « An ADR should be written whenever a decision of significant impact is made » ; « it is up to each team to align on what defines a significant impact »
- Portée / limites : aucun seuil chiffré. L'organigramme prévoit le rattrapage : problème connu, solution établie, non documentée → « Write an ADR! ». Pour un gros changement, un RFC d'abord, puis l'ADR.
- En pratique : quand l'agent découvre dans le code une convention structurante sans ADR, rédiger un ADR rétroactif, au statut `Accepté`, en indiquant que c'est une reconstitution.

### Keeling (IEEE Software 2022) présente les ADR comme petits et légers, mais ne donne aucun critère ni seuil de déclenchement
- Niveau de preuve : N4 (chronique d'IEEE Software, essai de praticien)
- Source : Michael Keeling, juillet-août 2022, « Love Unrequited: The Story of Architecture, Agile, and How Architecture Decision Records Brought Them Together », IEEE Software 39(4):90-93, DOI 10.1109/MS.2022.3166266 (Crossref) ; texte lu sur le site de l'auteur : https://keeling-dev.pages.dev/essays/agile-architecture-and-how-adrs-brought-them-together
- Extrait lu : « Documenting even only a single decision provides a strong return on investment. » ; les gabarits contiennent « commonly include three parts: context, decision, and consequences ».
- Portée / limites : l'essai affirme « ADRs are quickly becoming a standard practice across the software industry » sans donnée, ce que nuance Buchgeher et al. 2023. Le second essai de Keeling (« The Psychology of Architecture Decision Records », IEEE Software 39(6), 2022, https://keeling-dev.pages.dev/essays/psychology-of-architecture-decision-records) mentionne les « alternatives considered » seulement comme un élément de certains gabarits, et ne parle pas de biais cognitifs.
- En pratique : on ne peut pas citer Keeling 2022 à l'appui d'un seuil de type « plus d'une journée ». Il n'en donne aucun.

---

## Verdict sur les règles du profil

| Règle du profil | Verdict | Motif sourcé |
|---|---|---|
| « Réversibilité d'abord : two-way door → trancher vite ; one-way door (schéma, frontière de module, dépendance structurante, format public d'API) → ADR complet, alternatives, et chercher à la convertir en two-way door. » | **Soutenue** (N3-N4), sans preuve empirique en logiciel | Bezos, lettre 2015 : one-way « methodically, carefully, slowly » ; type 2 « made quickly ». Microsoft : n'inclure que les choix « difficult to reverse ». Fowler 2003 : « eliminate irreversibility ». Les quatre exemples recoupent la liste de Nygard et d'AWS (structure, dependencies, interfaces). Réserve : la métaphore de Bezos vient de la gestion d'entreprise, et aucune étude ne mesure son effet en architecture logicielle. |
| « Critère ADR : si revenir en arrière coûterait plus d'une journée de refactoring, c'est un ADR. » | **Convention sans preuve trouvée** ; à reformuler | Aucune source lue ne donne de seuil en durée. Spotify : chaque équipe définit « significant impact ». arc42 : « important, expensive, large scale or risky ». Microsoft : « difficult to reverse ». Keeling 2022 : aucun critère. Le seuil d'un jour peut rester une heuristique locale, à présenter comme telle, à côté des critères qualitatifs publiés. |
| « Format ADR : Contexte, Décision, Réversibilité, Conséquences, Alternatives écartées, Signal de réexamen. < 1 page. Une décision sans condition de réexamen est traitée comme éternelle. » | **Soutenue pour le noyau ; à préciser pour deux champs** | Contexte, Décision, Conséquences : minimum d'AWS et socle de Nygard. Alternatives : MADR, Microsoft, Google, Fowler 2026. Une page : Fowler 2026 (« typically a single page ») ; Nygard admet « one or two pages ». Signal de réexamen : Fowler 2026 (« changes in the product context that should trigger the team to reevaluate ») et MADR (« if/when it should be re-visited »). Un champ « Réversibilité » n'apparaît dans **aucun** gabarit lu : le plus proche est la « confidence level » de Microsoft et Fowler, qu'il serait utile d'ajouter. « Traitée comme éternelle » est une formule du profil, sans source. Nygard dit seulement que « the time to change old decisions will be clear from changes in the project's context ». |
| « Toujours au moins une alternative crédible par décision structurante » / « ADR sans alternative écartée : une décision sans option n'en est pas une. » | **Soutenue, avec une nuance** | Borowa et al. 2025 (N2, 36 participants) : « Generating multiple solution options » contre l'ancrage et la confirmation, baisse significative de l'ancrage. Borowa et al. 2022 : biais 52 % → 31 % avec la technique de l'inconvénient explicite. arc42 définit une décision comme « selecting one alternative based on given criteria ». Nuances : Nygard, AWS (minimum) et GOV.UK n'exigent pas d'alternatives ; MADR admet « only option, which meets k.o. criterion ». Borowa et al. 2023 rappellent que lister **toutes** les alternatives est irréaliste. Reformulation suggérée : au moins une alternative crédible, ou le critère éliminatoire qui n'en laisse qu'une. |
| « Identifier 2 à 5 décisions structurantes : coûteuse à inverser + contraint d'autres décisions = structurante. » | **Critère soutenu ; fourchette « 2 à 5 » sans preuve trouvée** | « Coûteuse à inverser » : Booch (« significant is measured by the cost of change »), Microsoft, Fowler/Johnson. « Contraint d'autres décisions » : Dasanayake et al. 2017 (« they dictate all downstream design choices », affirmation d'introduction) et Zdun et al. 2013 (limiter les dépendances entre décisions « to reduce ripple effects », lu en paraphrase InfoQ). Aucune source sur un nombre de décisions par cadrage. Microsoft conseille au contraire de découper une décision par phases. |
| « Décisions implicites non justifiées » (anti-pattern) | **Soutenue** (N2 + N3 + N4) | Nygard : sans justification, on ne peut que « Blindly accept » ou « Blindly change ». Microsoft : une décision non écrite « will likely be forgotten ». Li et al. 2022 : le manque de documentation des décisions est une cause d'érosion (10 études sur 73), et la violation des décisions en est un symptôme (10 sur 24). Spotify : rattraper les décisions non documentées. |

## Mythes et affirmations contestées

- **« Les one-way / two-way doors viennent de la lettre de 2016. »** Faux : le passage complet (Type 1 / Type 2, « one-way doors ») est dans la lettre sur l'exercice **2015**, déposée le 05.04.2016. La lettre sur 2016 reprend « two-way doors » et ajoute les « 70 % » et « disagree and commit ».
- **« L'architecture, ce sont les décisions difficiles à changer » (Ralph Johnson).** Attribution inexacte. Johnson parle de « the decisions you wish you could get right early in a project » (définition qu'il écarte lui-même, selon martinfowler.com/architecture) et préfère « the important stuff » ou « shared understanding ». C'est **Fowler** qui en tire « things that people perceive as hard to change » (IEEE Software, 2003). La formule de Booch sur le « cost of change » n'a été trouvée que dans des diapositives hébergées par un tiers.
- **« Un ADR doit toujours contenir les alternatives. »** Contesté : ni Nygard 2011, ni le minimum d'AWS, ni le cadre GOV.UK 2025, ni la description de Keeling 2022 ne les exigent. MADR, Microsoft, Google et Fowler 2026 les demandent. L'exigence se défend par la recherche sur les biais, pas par un standard unanime.
- **« Un ADR accepté est immuable. »** Contesté : AWS, Microsoft et Fowler 2026 le disent. GOV.UK demande au contraire de « Regularly review and update the ADR », et Google d'inscrire dans l'ADR la décision précédente et la raison du changement.
- **« Les ADR sont devenus un standard de l'industrie. »** Affirmé sans donnée par Keeling 2022. Dans l'open source, Buchgeher et al. 2023 trouvent une adoption « still low », et la moitié des dépôts concernés ont 1 à 5 ADR.
- **« ISO/IEC/IEEE 42010 impose les ADR. »** Faux d'après la fiche IEEE : « This document does not specify any format or media for recording an AD ». La norme a bien une clause sur l'enregistrement des décisions et de leur justification (6.10), mais son contenu normatif n'a pas été lu.
- **« Le Y-statement de 2013 comprend "and neglected <options>". »** Non trouvé : la forme publiée (republication InfoQ de l'article d'IEEE Software) s'arrête à « accepting <downside d> ».
- **« Il suffit d'expliquer les biais pour s'en protéger. »** Contredit par l'étude pilote de Borowa et al. 2021 (« ineffective »). Les effets mesurés viennent de gestes obligatoires pratiqués en atelier.
- **« Dernier moment responsable = décider le plus tard possible. »** Wirfs-Brock 2011 conteste cette lecture, qui « leaves me open to making late decisions ». La définition des Poppendieck est liée à la perte d'une alternative importante, pas au plus tard possible.

## Non vérifié

- **Seuil « plus d'une journée de refactoring = ADR »** : aucune source trouvée (recherche web dédiée, et ni Keeling 2022, ni Microsoft, ni AWS, ni Spotify, ni arc42 n'en donnent).
- **Effet mesuré de la documentation des alternatives** dans les ADR eux-mêmes, sur la qualité des décisions en situation réelle : aucune étude trouvée qui isole cet effet. Les preuves les plus proches portent sur des ateliers de debiasing (Borowa 2022, 2025) et sur la réflexion (Razavian 2016), avec des étudiants et un petit nombre de praticiens.
- **Zalewski, Borowa, Ratkowski 2017**, « On Cognitive Biases in Architecture Decision Making », ECSA 2017, LNCS 10475, pp. 123-137, DOI 10.1007/978-3-319-65831-5_9 : références confirmées (Crossref, BibSLEIGH, bibliographie de Borowa 2022), mais le résumé n'a pas été ouvert (Springer redirige vers une authentification). Les chiffres « 14 praticiens » et « 12 biais » ne viennent que d'un résumé de moteur de recherche et ne sont pas vérifiés.
- **van Vliet et Tang 2016**, « Decision making in software architecture », Journal of Systems and Software 117:638-644, DOI 10.1016/j.jss.2016.01.017 : métadonnées Crossref seulement, contenu non lu.
- **Tang, Tran, Han, van Vliet 2008**, « Design Reasoning Improves Software Design Quality » (QoSA 2008, LNCS 5281) : le résultat (« the test group that was equipped with design reasoning produced a higher quality design than the control group, especially for inexperienced designers ») n'a été vu que dans un extrait de moteur de recherche. Page non ouverte (403), donc non vérifié.
- **Weinreich, Groher, Miesbauer 2015** (Future Generation Computer Systems 47:145-160) : seul l'échantillon est confirmé (25 architectes, chefs d'équipe et développeurs seniors, 22 entreprises, 10 pays, plus de 13 ans d'expérience en moyenne, page JKU). Les résultats sur la manière dont les décisions sont documentées n'ont pas été lus.
- **van Heesch et Avgeriou 2011**, « Mature Architecting » (WICSA 2011) : seul l'échantillon (53 architectes industriels) est lu sur la page de l'université de Groningue. Le PDF a été refusé (403), et les résultats sur les alternatives ne sont pas vérifiés.
- **Contenu normatif de la clause 6.10 d'ISO/IEC/IEEE 42010:2022** (ce que la norme exige pour l'enregistrement des décisions et de leur justification) : non lu, iso.org refuse l'accès et l'aperçu s'arrête avant cette clause.
- **Critères du « Architectural Significance Test » de Zimmermann** (valeur et risque métier, préoccupation d'une partie prenante, niveau de qualité, dépendances externes, transversalité, première du genre, source de problèmes passés) : la source primaire (Medium) a refusé l'accès ; seul Wikipédia les liste, sans attribution ni référence.
- **Année 2003 et texte exact du livre des Poppendieck** : citation lue de seconde main (Atwood 2006), page de l'éditeur refusée.
- **Pourcentages détaillés de Tang et al. 2006** (au-delà des 81 réponses et du résumé) : texte intégral inaccessible.
- **Revue par les pairs de Borowa et al. 2025, Dasanayake et al. 2017 et Nogueira et al. 2026** : préprints arXiv lus, publication finale non vérifiée.

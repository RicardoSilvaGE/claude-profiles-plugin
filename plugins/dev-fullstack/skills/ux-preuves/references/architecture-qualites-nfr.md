# Fiche `ux-preuves` — Architecture — qualités et exigences non fonctionnelles

> Fiche du skill `ux-preuves` (dev-fullstack), volet **architecture**, préchargé par `architecte`. Couvre : ISO/IEC 25010:2023, scénarios d'attributs de qualité et ATAM, risques d'omission, recherche sur le traitement des exigences non fonctionnelles, mythe du surcoût ×100, fitness functions, modélisation des menaces à la conception, Well-Architected et sobriété, DORA, hors ligne et local-first.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Normes, versions et textes réglementaires
> **vieillissent** ; le droit change par révision : avant d'en faire dépendre une décision,
> relire la page officielle (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Périmètre : ce que l'agent « architecte » doit exiger d'un cadrage (Mode A) pour les applications web d'un développeur indépendant (Next.js, Supabase/Postgres, Node, FastAPI, parfois PWA hors ligne ; utilisateurs en Suisse et dans l'UE).
> Hors périmètre, déjà couvert ailleurs : OWASP API Top 10, ASVS, NIST 800-63B, nLPD/RGPD article par article, SLO et signaux dorés, Core Web Vitals, WCAG critère par critère.
> Méthode : chaque entrée vient d'une page ou d'un PDF réellement ouvert (WebFetch, ou curl + `pdftotext` pour les PDF). Quand seul un résumé a été lu, c'est indiqué. Les citations sont verbatim, dans leur langue d'origine. Quand l'outil de lecture a paraphrasé, seuls les passages entre guillemets sont des citations.
> Échelle : N1 norme ; N2 recherche revue par pairs ou étude empirique (l'échantillon est cité) ; N3 guide officiel d'une institution ou d'une plateforme ; N4 avis d'expert, livre ou article de praticien.

---

## 1. Modèle de qualité produit : ISO/IEC 25010:2023

### Parcourir les neuf caractéristiques d'ISO/IEC 25010:2023 pour vérifier qu'un cadrage n'a rien oublié, pas pour les remplir toutes
- Niveau de preuve : N1
- Source : ISO/IEC JTC 1/SC 7, 2023, « ISO/IEC 25010:2023 Systems and software engineering — SQuaRE — Product quality model » (aperçu officiel des pages i à 10 diffusé par iTeh Standards), https://cdn.standards.iteh.ai/samples/78176/13ff8ea97048443f99318920757df124/ISO-IEC-25010-2023.pdf
- Extrait lu : « The product quality model is composed of nine characteristics (which are further subdivided into subcharacteristics) » ; parmi les usages : « validating the comprehensiveness of requirements definition » ; et dans l'introduction : « It is important that the quality characteristics be specified, measured, and evaluated whenever possible using validated or widely accepted measures and measurement methods. »
- Portée / limites : seul l'aperçu (avant-propos, introduction, domaine d'application, début des définitions) a été lu, pas la norme complète. La fiche iso.org (https://www.iso.org/standard/78176.html) a répondu 403. La liste des caractéristiques est confirmée par iso25000.com (https://iso25000.com/index.php/en/iso-25000-standards/iso-25010) : Functional Suitability, Performance Efficiency, Compatibility, Interaction Capability, Reliability, Security. Maintainability, Flexibility et Safety se déduisent de l'avant-propos, mais leurs sous-caractéristiques n'ont pas été lues. La norme fournit un modèle, pas une liste de contrôle par feature.
- En pratique : la checklist NFR du profil ne couvre ni la **compatibilité/interopérabilité** (API tierces, export), ni la **fiabilité** (disponibilité, récupérabilité : sauvegarde et restauration Supabase), ni la **maintenabilité/flexibilité** (dont la scalabilité). Il faut les ajouter, ou les marquer N/A avec un motif.

### Utiliser les noms de 2023, et savoir que l'accessibilité y est découpée et que la scalabilité est une sous-caractéristique de la flexibilité
- Niveau de preuve : N1
- Source : idem, avant-propos (« Foreword »), même URL
- Extrait lu : « Safety has been added as a quality characteristic with subcharacteristics, i.e. operational constraint, risk identification, fail safe, hazard warning and safe integration. » / « Usability and portability have been replaced with interaction capability and flexibility respectively. » / « Inclusivity and self-descriptiveness, resistance, and scalability have been added as subcharacteristics of interaction capability, security, and flexibility respectively. » / « Accessibility has been split into inclusivity and user assistance. »
- Portée / limites : il s'agit de la deuxième édition, qui « cancels and replaces ISO/IEC 25010:2011 ». La « safety » vise les dommages aux personnes et aux biens. Pour une application web de gestion, elle sera le plus souvent N/A, mais il faut le dire explicitement. La nouvelle sous-caractéristique **resistance** de la sécurité est définie ainsi sur iso25000.com : « Degree to which the product or system sustains operations while under attack from a malicious actor. »
- En pratique : quand une feature expose un point d'entrée public (formulaire, webhook, endpoint), se demander comment elle tient sous attaque (limitation de débit, quotas), et pas seulement si elle est confidentielle.

### Distinguer la capacité d'interaction du produit (25010) de l'utilisabilité en usage (25019)
- Niveau de preuve : N1
- Source : idem, définition 3.4, même URL
- Extrait lu : « usability as defined in the quality-in-use model (ISO/IEC 25019) comprehensively focuses on outcomes of use to determine whether tasks are achieved by users with effectiveness, efficiency and satisfaction in a specific context of use. » / « Interaction capability is a prerequisite for usability. »
- Portée / limites : ISO/IEC 25019 n'a pas été ouverte. Seul le renvoi fait par 25010 a été lu.
- En pratique : au cadrage, l'architecte fixe les propriétés du produit (prévention des erreurs, aide, inclusivité). L'utilisabilité réelle se mesure ensuite, en usage, avec des utilisateurs. Le cadrage n'a pas à prétendre la garantir.

---

## 2. Scénarios d'attributs de qualité, utility tree et ATAM (SEI)

### Écrire chaque NFR prioritaire comme un scénario en six parties, avec une mesure de réponse chiffrée
- Niveau de preuve : N3
- Source : Barbacci, Ellison, Lattanze, Stafford, Weinstock, Wood, 2003, « Quality Attribute Workshops (QAWs), Third Edition », CMU/SEI-2003-TR-016, https://www.sei.cmu.edu/documents/716/2003_005_001_14249.pdf
- Extrait lu : « 1. stimulus - the condition that affects the system 2. response - the activity that results from the stimulus 3. source of stimulus - the entity that generated the stimulus 4. environment - the condition under which the stimulus occurred 5. artifact stimulated - the artifact that was stimulated 6. response measure - the measure by which the system's response will be evaluated » ; et sur la mesure : « Given enough time and money, any modification is possible. »
- Portée / limites : c'est une méthode d'atelier conçue pour des systèmes de grande taille, surtout militaires. Le rapport ne raffine en détail que « the top four or five scenarios ». Le format en six parties du livre de Bass, Clements et Kazman (*Software Architecture in Practice*) n'a pas été lu dans le livre : il est sourcé ici par le rapport SEI.
- En pratique : exemple pour une feature Supabase : « Un utilisateur authentifié (source) lance l'export de 10 000 lignes (stimulus) en charge normale (environnement) sur la route d'export (artefact). Le fichier est produit (réponse) en moins de N s au p95 (mesure). » Ne raffiner ainsi que 2 à 3 attributs critiques par feature.

### Construire un utility tree court : prioriser chaque scénario sur deux axes, l'importance et le risque, en Haut/Moyen/Bas
- Niveau de preuve : N3
- Source : Kazman, Klein, Clements, 2000, « ATAM: Method for Architecture Evaluation », CMU/SEI-2000-TR-004, https://www.sei.cmu.edu/documents/629/2000_005_001_13706.pdf
- Extrait lu : « we find that the stakeholders cannot reliably and repeatably make finer distinctions than High, Medium, and Low. The prioritization of the utility tree is done along two dimensions: by the importance of each node to the success of the system and the degree of perceived risk » ; et : « Statements, commonly found in requirements documents, such as "The architecture shall be modifiable and robust" are untenable here »
- Portée / limites : l'affirmation sur H/M/B est un constat des auteurs, pas une mesure. L'ATAM complète est un processus de plusieurs jours avec les parties prenantes, disproportionné pour un développeur seul. On n'en reprend que l'outil de priorisation.
- En pratique : refuser au cadrage les NFR adjectivales (« rapide », « sécurisé », « robuste »). Chaque NFR retenue porte un couple (importance, risque), et seules les (H, H) et (H, M) reçoivent un scénario détaillé.

### Consigner les risques, les points de sensibilité et les points de compromis, pas seulement les choix retenus
- Niveau de preuve : N3
- Source : Kazman, Klein, Clements, 2000, CMU/SEI-2000-TR-004, même URL
- Extrait lu : « Risks are architecturally important decisions that have not been made […] or decisions that have been made but whose consequences are not fully understood » / « A tradeoff point is found in the architecture when a parameter of an architectural construct is host to more than one sensitivity point where the measurable quality attributes are affected differently by changing that parameter. »
- Portée / limites : définitions de méthode, pas de mesure d'efficacité.
- En pratique : une section « Risques / compromis » dans le cadrage. Exemple : « Mettre en cache côté edge améliore la latence (+) mais retarde la révocation des droits (−). Compromis assumé : TTL de N s. »

### Chercher d'abord les risques d'omission, deux fois plus fréquents que les risques de commission dans les évaluations ATAM analysées
- Niveau de preuve : N3 (rapport technique d'institution, étude descriptive de 18 évaluations, non revue par pairs)
- Source : Bass, Nord, Wood, Zubrow, 2006, « Risk Themes Discovered Through Architecture Evaluations », CMU/SEI-2006-TR-012, https://www.sei.cmu.edu/documents/771/2006_005_001_14783.pdf
- Extrait lu : « We analyzed 18 final reports dated between 2000 and 2005 […] These ATAM evaluations produced 99 risk themes. » / « For our 99 risk themes, 25 were risks of commission, 57 were risks of omission, and 17 were neither. » / « the risk themes identify decisions or investigations that were never made rather than those that were made »
- Portée / limites : échantillon de 12 systèmes du DoD américain, 2 d'une autre agence et 4 commerciaux. Accord inter-juges de κ = 0,82 sur la catégorisation. La donnée Boeing donne un rapport de 1,5:1 (28 thèmes). L'étude ne mesure pas l'efficacité de l'ATAM : elle décrit ce que les évaluations ont trouvé. Parmi les thèmes cités : « not knowing performance requirements », « unknown requirements for quality of service ».
- En pratique : c'est le meilleur argument trouvé pour la checklist « chaque item traité ou N/A ». Le défaut typique d'un cadrage est la question jamais posée, plus souvent que le mauvais choix.

---

## 3. Ce que la recherche empirique dit du traitement des NFR

### Ne pas attendre que le client exprime les NFR : c'est l'architecte qui les fait émerger
- Niveau de preuve : N2 (revu par pairs, RE 2012 ; 13 entretiens, étude exploratoire)
- Source : Ameller, Ayala, Cabot, Franch, 2012, « How do Software Architects Consider Non-Functional Requirements: An Exploratory Study », IEEE RE 2012, DOI 10.1109/RE.2012.6345838 ; PDF en libre accès ouvert : https://scispace.com/pdf/how-do-software-architects-consider-non-functional-2n4dda8nyg.pdf
- Extrait lu : « in 10 out of the 13 projects considered, the software architect was the main source of the NFRs. Clients either never mentioned NFRs ("[the client] never mentioned that web pages could not take more than 2 seconds to load, but he complained about it afterwards" (E)) »
- Portée / limites : 13 architectes, contexte surtout espagnol, années 2010. L'étude est exploratoire, et les auteurs écrivent que leurs observations ne sont pas « a universal view ».
- En pratique : poser explicitement à l'utilisateur les questions de volumétrie, de latence acceptable et de coût mensuel toléré. Son silence ne veut pas dire « sans exigence ».

### Documenter et valider les NFR, car en pratique elles ne le sont presque jamais et la sécurité est oubliée
- Niveau de preuve : N2 (même étude, 13 entretiens)
- Source : Ameller et al., 2012, même URL
- Extrait lu : « 9 out of the 13 interviewees acknowledged that they had not documented the NFRs at all » / « most of the interviewed architects (11 out of 13) claimed that all NFRs had been satisfied by the end of the project. However, when asked how they had validated them, their answers were vague. » / « Notably, one highly relevant type of NFR, security, was not mentioned by any of the respondents. » / « this list is under extension and negotiation during all development and maintenance phases »
- Portée / limites : même échantillon. Les auteurs relaient aussi un chiffre de Svensson et al. (60 % des interviewés disent que les NFR ne sont jamais ou seulement parfois spécifiées de façon mesurable), qui n'a pas été vérifié à la source.
- En pratique : chaque NFR du cadrage porte son moyen de validation (test de charge, test RLS, alerte), et la liste est rouverte à chaque évolution de la feature.

### Traiter la plupart des NFR comme des comportements testables plutôt que comme une catégorie à part
- Niveau de preuve : N2 (ICSE '16 ; 530 exigences tirées de 11 spécifications industrielles)
- Source : Eckhardt, Vogelsang, Méndez Fernández, 2016, « Are "Non-functional" Requirements really Non-functional? An Investigation of Non-functional Requirements in Practice », ICSE '16, https://arxiv.org/pdf/1611.08868
- Extrait lu : « We report on the classification of 530 NFRs extracted from 11 industrial requirements specifications » / « Our results suggest that most "non-functional" requirements are not non-functional as they describe behavior of a system. »
- Portée / limites : les spécifications viennent de l'industrie allemande, surtout de systèmes embarqués et d'information. Le résultat concerne la nature des exigences, pas leur coût.
- En pratique : écrire « l'export renvoie une erreur 429 au-delà de N requêtes par minute et par utilisateur » plutôt que « l'API doit être protégée ». Une telle NFR devient un critère d'acceptation, donc un test.

### Ne pas justifier l'effort sur les NFR par une courbe de coût exponentielle : la justifier par l'irréversibilité de la décision concernée
- Niveau de preuve : N2 (Empirical Software Engineering 2017 ; 171 projets)
- Source : Menzies, Nichols, Shull, Layman, 2016/2017, « Are Delayed Issues Harder to Resolve? Revisiting Cost-to-Fix of Defects throughout the Lifecycle », https://arxiv.org/pdf/1609.04886
- Extrait lu : « This paper tests for the delayed issue effect in 171 software projects conducted around the world in the period from 2006–2014. […] We found no evidence for the delayed issue effect » / « DIE might be an historical relic that occurs intermittently only in certain kinds of projects. » ; et dans la revue de littérature : « Design changes (including architecture changes) required approximately twice the effort of implementation and test changes » (Royce, cité)
- Portée / limites : les projets suivaient le Team Software Process (TSP), ce qui en fait un biais possible discuté par les auteurs. L'étude porte sur les défauts en général, pas spécifiquement sur les NFR ou sur l'architecture.
- En pratique : la bonne question n'est pas « ça coûtera 100× plus tard ». C'est : « cette NFR change-t-elle un choix difficile à défaire (schéma, modèle d'authentification, emplacement des données, mode hors ligne) ? » Si oui, on la tranche au cadrage. Sinon, on peut la différer en le disant.

---

## 4. Fitness functions : rendre une NFR vérifiable en continu

### Transformer chaque NFR vérifiable automatiquement en fitness function exécutée en CI ou en supervision
- Niveau de preuve : N4
- Source : Thoughtworks, 2017-2018, « Architectural fitness function » (Technology Radar, anneau Trial, mai 2018), https://www.thoughtworks.com/radar/techniques/architectural-fitness-function ; Paul et Wang, 2019, « Fitness function-driven development », https://www.thoughtworks.com/insights/articles/fitness-function-driven-development
- Extrait lu : « an objective integrity assessment of some architectural characteristics » (Radar) / « Fitness functions describe how close an architecture is to achieving an architectural aim. » (Paul et Wang), avec des exemples comme « completes a transaction under 10 seconds » et « should not have plaintext secrets in codebase »
- Portée / limites : le concept vient du livre de Ford, Parsons et Kua, *Building Evolutionary Architectures*, dont la page O'Reilly de la 2e édition a répondu 403. Le livre n'a pas été lu, seule la définition relayée par Thoughtworks l'a été. Le site des auteurs (https://evolutionaryarchitecture.com/) dit seulement : « Evolutionary architectures make it explicit what "fit" means with as much automation as possible. » Le blip n'est plus sur le Radar actuel. Aucune étude empirique d'efficacité n'a été trouvée.
- En pratique : pour chaque scénario retenu, se demander s'il peut devenir un test. Exemples : budget de bundle, temps de réponse d'un endpoint en CI, test « aucune table sans RLS », scan de secrets. S'il ne le peut pas, la NFR reste déclarative et le dire.

### Pour une base JS/TS (Next.js, Node), garder les frontières de modules avec dependency-cruiser ; ArchUnit vise Java
- Niveau de preuve : N4 (documentation des outils)
- Source : Verweij, « dependency-cruiser », https://github.com/sverweij/dependency-cruiser ; TNG, « ArchUnit », https://www.archunit.org/
- Extrait lu : « Validate and visualize dependencies. Your rules. JavaScript, TypeScript, CoffeeScript. ES6, CommonJS, AMD. » / ArchUnit : « a free, simple and extensible library for checking the architecture of your Java code »
- Portée / limites : il s'agit de la description des outils par leurs auteurs. Aucune mesure d'effet sur la qualité n'a été trouvée.
- En pratique : quand le cadrage pose une frontière (« les composants client n'importent jamais le client Supabase service_role »), proposer la règle dependency-cruiser qui l'oppose en CI.

---

## 5. Modélisation des menaces à la conception

### Conduire une modélisation des menaces légère, avec les quatre questions, dès qu'une feature ajoute une surface d'attaque
- Niveau de preuve : N4 (manifeste rédigé par un collectif de praticiens)
- Source : Threat Modeling Manifesto, https://www.threatmodelingmanifesto.org/
- Extrait lu : « Threat modeling is analyzing representations of a system to highlight concerns about security and privacy characteristics. » ; les quatre questions : « What are we working on? », « What can go wrong? », « What are we going to do about it? », « Did we do a good enough job? » ; principe : « The best use of threat modeling is to improve the security and privacy of a system through early and frequent analysis. »
- Portée / limites : la page ne porte pas de date, donc l'année 2020 n'a pas été vérifiée. Le manifeste couvre aussi la vie privée (« privacy »), ce qui rejoint les exigences nLPD/RGPD traitées ailleurs.
- En pratique : une demi-page dans le cadrage (flux de données, frontières de confiance, menaces, parades) pour toute nouvelle route publique, tout webhook, tout upload ou toute délégation de droits.

### Faire la modélisation pendant la conception, puis la tenir à jour avec le système
- Niveau de preuve : N3
- Source : OWASP, « Threat Modeling Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Threat_Modeling_Cheat_Sheet.html ; motif complémentaire : Scandariato, Wuyts, Joosen (voir l'entrée suivante)
- Extrait lu : « Threat modeling is ideally performed early in the SDLC, such as during the design phase. » / « A threat model is something that should be maintained, updated and refined alongside the system. » ; Scandariato et al. : « early threat elicitation is best performed as soon as an initial architectural model of the system is available. »
- Portée / limites : la cheat sheet ne fournit aucune preuve d'efficacité. Chez Scandariato, cette phrase est une thèse d'introduction, pas un résultat.
- En pratique : la modélisation se fait sur le schéma du cadrage, pas après le code. Le fichier de menaces vit à côté de la spec et se révise à chaque évolution de flux.

### Parcourir STRIDE élément par élément du flux de données pour ne pas oublier de catégorie
- Niveau de preuve : N3
- Source : Microsoft, « Threats - Microsoft Threat Modeling Tool » (mise à jour du 2026-03-04), https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats
- Extrait lu : « Microsoft uses the STRIDE model, which categorizes different types of threats and simplifies the overall security conversations. » (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege) ; et l'affirmation de l'éditeur : « It allows software architects to identify and mitigate potential security issues early, when they are relatively easy and cost-effective to resolve. »
- Portée / limites : l'affirmation de coût (« cost-effective ») est celle de l'éditeur, non mesurée sur la page. Elle ne constitue pas une preuve (voir les mythes). La cheat sheet OWASP relie chaque catégorie à la propriété violée (authentification, intégrité, traçabilité, confidentialité, disponibilité, autorisation).
- En pratique : sur une feature Supabase, l'élévation de privilège vise d'abord une policy RLS manquante ou une RPC SECURITY DEFINER. La divulgation vise un select trop large exposé via PostgREST.

### Savoir que STRIDE est apprenable mais coûteux et incomplet : le borner, ne pas le croire exhaustif
- Niveau de preuve : N2 (Requirements Engineering, vol. 20 n° 2, 2015 ; 57 étudiants de master, étude descriptive)
- Source : Scandariato, Wuyts, Joosen, 2015, « A descriptive study of Microsoft's threat modeling technique », manuscrit auteur KU Leuven : https://lirias.kuleuven.be/retrieve/245643
- Extrait lu : « to date no empirical study has been carried out to quantify its cost and effectiveness » / « an average productivity of 1.8 threats per hour (standard deviation of 1.5) » / « In summary, this study concluded that STRIDE is not difficult to learn and execute, although it is relatively time-consuming. Further, many threats go undetected during the analysis. »
- Portée / limites : les participants sont des étudiants, pas des praticiens, et l'étude porte sur un seul type de système. Les taux exacts de faux positifs et de faux négatifs n'ont pas été extraits. Le temps moyen est de 25,1 h par équipe. Une réplication (Tuma et Mbaka, arXiv 2208.01512) n'est qu'un protocole sans résultats.
- En pratique : limiter l'exercice aux nouvelles frontières de confiance de la feature (30 à 60 min), et compléter par des contrôles outillés (advisors Supabase, tests de policies RLS) plutôt que de déclarer le modèle complet.

### Prendre « secure by design » comme posture par défaut : la sécurité est une exigence métier, pas une option
- Niveau de preuve : N3
- Source : CISA et 17 partenaires, révision du 25 octobre 2023, « Shifting the Balance of Cybersecurity Risk: Principles and Approaches for Secure by Design Software », https://www.cisa.gov/resources-tools/resources/secure-by-design ; https://www.cisa.gov/securebydesign
- Extrait lu : principes « Take Ownership of Customer Security Outcomes », « Embrace Radical Transparency and Accountability », « Lead From the Top » ; « Products designed with Secure by Design principles prioritize the security of customers as a core business requirement »
- Portée / limites : seules les pages de présentation ont été lues. Le PDF complet n'a pas pu être téléchargé (trop volumineux pour l'outil, et refus du téléchargement direct), donc rien n'a été vérifié sur la place qu'il donne à la modélisation des menaces. Le guide s'adresse aux éditeurs de logiciels, pas spécifiquement aux indépendants.
- En pratique : les réglages sûrs sont ceux par défaut (RLS activée, aucune clé service_role côté client, MFA proposée). Toute dérogation est écrite dans le cadrage.

---

## 6. Coût d'exploitation et sobriété

### Traiter le coût et la sobriété comme des piliers d'architecture au même titre que la sécurité
- Niveau de preuve : N3
- Source : AWS, « The pillars of the framework », https://docs.aws.amazon.com/wellarchitected/latest/framework/the-pillars-of-the-framework.html ; AWS, « Sustainability Pillar » (publié le 6 novembre 2024), https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/sustainability-pillar.html ; Google Cloud, « Well-Architected Framework », https://docs.cloud.google.com/architecture/framework
- Extrait lu : AWS : « if you neglect the six pillars of operational excellence, security, reliability, performance efficiency, cost optimization, and sustainability, it can become challenging to build a system that delivers on your expectations and requirements. » Google liste six piliers, dont « Security, privacy, and compliance » et « Sustainability ».
- Portée / limites : ce sont des guides d'éditeurs, orientés vers leurs propres clouds. Le framework Azure (https://learn.microsoft.com/en-us/azure/well-architected/pillars) n'en compte que cinq, sans pilier sobriété. Ces frameworks ne présentent aucune preuve d'efficacité.
- En pratique : la checklist du profil a raison de contenir le coût. Il faut y ajouter une ligne « sobriété » (volume de données stockées et transférées, tâches planifiées, appels à des modèles IA) pour les features qui en consomment beaucoup.

### Chiffrer au cadrage un modèle de coût et un budget qui couvre les NFR, puis poser des garde-fous
- Niveau de preuve : N3
- Source : Microsoft, « Cost Optimization design principles » (2025-05-27), https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/principles
- Extrait lu : « Develop a cost model. This fundamental exercise is a prerequisite to setting up a financial tracking system. » / « Estimate realistic budgets that cover all non-negotiable functional and nonfunctional requirements » / « Design and enforce cost guardrails in your architecture that keep the resources within the upper and lower limits. » / « A cost-optimized workload isn't necessarily a low-cost workload. »
- Portée / limites : le guide vise des organisations ayant une pratique FinOps. Pour un indépendant, cela se réduit à une estimation par palier (offre Supabase, Vercel, quotas d'API) et à des alertes de dépassement.
- En pratique : le cadrage donne le coût mensuel estimé à 1×, 10× et 100× la volumétrie attendue. Il nomme le palier tarifaire qui sera franchi et l'alerte de budget à configurer chez chaque fournisseur.

### Exprimer l'empreinte carbone, si elle est demandée, en intensité par unité fonctionnelle (SCI) et non en total
- Niveau de preuve : N1 (statut ISO rapporté par l'éditeur de la spécification ; la fiche iso.org n'a pas pu être lue)
- Source : Green Software Foundation, « Software Carbon Intensity (SCI) Specification », https://sci.greensoftware.foundation/ ; https://greensoftware.foundation/standards/sci/
- Extrait lu : « The Software Carbon Intensity (SCI) specification is an ISO-accredited standard (ISO/IEC 21031:2024) » ; « SCI is a rate; carbon emissions per one unit of `R`. »
- Portée / limites : la GSF date l'accréditation ISO d'avril 2024 et indique une version v1.1 en octobre 2024. Le numéro et le statut n'ont pas été confirmés sur iso.org (403). Cela reste peu pertinent pour une petite application, sauf exigence client.
- En pratique : à mentionner seulement si le client ou un appel d'offres le demande. Sinon, la sobriété se traite par le coût et le volume, qui sont des mesures disponibles.

### Prévoir l'observabilité dès le cadrage : juste assez de données, alertes actionnables, supervision découplée
- Niveau de preuve : N3
- Source : Microsoft, « Operational Excellence cloud design principles » (2025-05-05), https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/principles
- Extrait lu : « Collect just enough data and retain it for just enough time. Consider the cost tradeoffs associated with logging and storing data. » / « Trigger alerts only for incidents that require action. » / « Emit telemetry from application code that correlates the key points of the execution flow »
- Portée / limites : les SLO et les signaux dorés sont traités ailleurs. Cette entrée ne retient que ce qui doit être décidé au cadrage. Conserver des journaux a aussi un coût et des enjeux nLPD/RGPD.
- En pratique : le cadrage nomme les 1 à 3 événements à journaliser, l'alerte qui réveillera quelqu'un, et la durée de rétention.

---

## 7. Opérabilité : déploiement, retour arrière, migration

### Mesurer la livraison avec les cinq métriques DORA actuelles, sans en faire des objectifs
- Niveau de preuve : N3 (méthode d'enquête non lue ; voir les réserves)
- Source : DORA, « DORA's software delivery performance metrics » (mise à jour du 5 janvier 2026), https://dora.dev/guides/dora-metrics/
- Extrait lu : « Change lead time », « Deployment frequency », « Failed deployment recovery time », « Change fail rate », et la cinquième : « Deployment rework rate: The ratio of deployments that are unplanned but happen as a result of an incident in production. »
- Portée / limites : la page déconseille de fixer ces métriques comme cibles (risque de manipulation) et de les agréger entre équipes. Les pages ouvertes (https://dora.dev/research/, https://dora.dev/research/2024/dora-report/) ne publient ni la méthode statistique ni la taille d'échantillon. Elles disent seulement que l'équipe « applies behavioral science methodology ». D'où N3 et non N2.
- En pratique : pour un indépendant, deux suffisent au cadrage : comment on revient en arrière (temps de restauration), et ce qui provoquerait un déploiement non planifié (taux de reprise).

### Concevoir pour que chaque partie se déploie et se teste sans environnement intégré : c'est ce que DORA associe à la livraison continue
- Niveau de preuve : N3 (même réserve de méthode)
- Source : DORA, « Capabilities: Loosely coupled teams », https://dora.dev/capabilities/loosely-coupled-teams/
- Extrait lu : « effective organizational and technical structures are predictors for achieving continuous delivery » ; une telle architecture permet que « teams require little communication to get work done »
- Portée / limites : la page ne donne ni taille d'effet ni échantillon. Pour une seule personne, le couplage d'équipes est sans objet. Restent le déploiement indépendant (front et API, fonctions edge) et les tests sans environnement complet.
- En pratique : se demander si la feature peut être livrée seule, sans déploiement simultané du front, de l'API et du schéma. Sinon, prévoir une compatibilité ascendante (voir « expand/contract »).

### Prévoir la mise en production : petits changements, exposition progressive, compatibilité ascendante et descendante, action de repli
- Niveau de preuve : N3
- Source : Microsoft, « Operational Excellence cloud design principles », https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/principles
- Extrait lu : « Prefer small, incremental updates that are deployed frequently. » / « Roll out new features using deployment patterns that allow for progressive exposure and gradual adoption by users. Test for backward and forward compatibility. » / « Be ready with compensating actions to recover from faulty deployments or critical defects in production. »
- Portée / limites : guide d'éditeur, sans mesure publiée sur la page.
- En pratique : la section « Opérabilité » du cadrage nomme la stratégie d'exposition (flag, préversion, déploiement progressif sur Vercel) et l'action de repli exacte (redéploiement de la version précédente, migration inverse ou action compensatoire).

### Considérer chaque mise en production comme la première cause d'incident, et en tester une partie (canary) avant de tout exposer
- Niveau de preuve : N3
- Source : Google, « Canarying Releases », *The Site Reliability Workbook*, https://sre.google/workbook/canarying-releases/
- Extrait lu : « We define canarying as a partial and time-limited deployment of a change in a service and its evaluation. » / dans l'expérience de Google, « a majority of incidents are triggered by binary or configuration pushes. »
- Portée / limites : ce constat vaut à l'échelle de Google, sans chiffre précis. Pour une petite application, un « canary » se réduit souvent à une préversion testée, plus un flag par utilisateur.
- En pratique : les changements de configuration (variables d'environnement, policies, flags) méritent le même plan de retour arrière que le code.

### Tenir les feature flags pour un stock qui a un coût, avec une date de retrait prévue dès le cadrage
- Niveau de preuve : N4
- Source : Hodgson, 2016-2017, « Feature Toggles (aka Feature Flags) », https://martinfowler.com/articles/feature-toggles.html
- Extrait lu : « Savvy teams view their Feature Toggles as inventory which comes with a carrying cost. » ; quatre catégories : release, experiment, ops, permissioning
- Portée / limites : article de praticien, sans données.
- En pratique : chaque flag introduit par le cadrage a une catégorie, un propriétaire et une condition de retrait.

### Découper toute migration de schéma incompatible en expand, migrate, contract, pour qu'un retour arrière du code reste possible
- Niveau de preuve : N4
- Source : Sato, 2014, « ParallelChange », https://martinfowler.com/bliki/ParallelChange.html
- Extrait lu : « a pattern to implement backward-incompatible changes to an interface in a safe manner » / « Most database refactorings follow the parallel change pattern. »
- Portée / limites : patron de praticien. L'article rappelle que la phase « contract » doit être menée à terme, faute de quoi le système finit dans un état pire qu'avant.
- En pratique : une migration Supabase qui renomme ou supprime une colonne passe par trois livraisons. Le cadrage dit laquelle est irréversible (contract) et quand elle aura lieu.

---

## 8. Hors ligne et synchronisation (PWA, local-first)

### Décider explicitement quels idéaux local-first la feature vise, parce qu'ils engagent toute l'architecture des données
- Niveau de preuve : N2 (essai revu par pairs, Onward! 2019, appuyé sur des prototypes ; pas une étude à large échantillon)
- Source : Kleppmann, Wiggins, van Hardenberg, McGranaghan, 2019, « Local-first software: You own your data, in spite of the cloud », Onward! 2019, https://www.inkandswitch.com/essay/local-first/
- Extrait lu : les sept idéaux : « No spinners: your work at your fingertips », « Your work is not trapped on one device », « The network is optional », « Seamless collaboration with your colleagues », « The Long Now », « Security and privacy by default », « You retain ultimate ownership and control »
- Portée / limites : les auteurs écrivent eux-mêmes : « We do not claim that these libraries fully realize local-first ideals — more work is still required. »
- En pratique : une PWA « hors ligne » vise en général seulement « The network is optional ». Le dire dans le cadrage évite de promettre la collaboration sans conflit, ou la propriété des données, qui coûtent bien plus.

### Trancher au cadrage la source de vérité et la règle de conflit pour chaque donnée modifiable hors ligne
- Niveau de preuve : N2 (même essai)
- Source : Kleppmann et al., 2019, même URL
- Extrait lu : « the CRDT keeps track of the conflicting values, and leaves it to be resolved by the application or the user. » / « CRDTs accumulate a large change history, which creates performance problems. » / question ouverte : « How can we write software so that varying application versions can safely interoperate, even as data formats evolve? »
- Portée / limites : les auteurs constatent aussi que « users surprisingly rarely encounter conflicts », mais c'est une observation sur leurs prototypes, non généralisée. Les permissions par document y restent « an open research question », point sensible avec la RLS de Supabase.
- En pratique : pour chaque entité, préciser si le serveur fait autorité (dernier écrit gagnant, rejet ou fusion), qui résout un conflit, et comment une ancienne version cliente hors ligne se comporte après une migration de schéma.

### Ne pas compter sur le stockage du navigateur comme stockage durable : prévoir l'éviction
- Niveau de preuve : N3
- Source : web.dev (Google), « Storage for the web », https://web.dev/articles/storage-for-the-web
- Extrait lu : « Best effort means the storage can be cleared by the browser without interrupting the user. » ; sur la limite de sept jours de Safari pour le stockage écrit par script : « This eviction policy does not apply to installed PWAs. »
- Portée / limites : les règles des navigateurs évoluent, et la date de la page n'a pas été relevée. La page indique qu'on peut demander un stockage persistant.
- En pratique : une donnée saisie hors ligne doit être poussée au serveur dès que possible. Le cadrage prévoit la demande de stockage persistant, et ce que voit l'utilisateur si des données locales ont été évincées.

### Ne pas fonder la synchronisation sur Background Sync, qui ne fonctionne pas partout
- Niveau de preuve : N3
- Source : MDN, « Background Synchronization API », https://developer.mozilla.org/en-US/docs/Web/API/Background_Synchronization_API ; MDN, « Offline and background operation », https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Guides/Offline_and_background_operation
- Extrait lu : « This feature is not Baseline because it does not work in some of the most widely-used browsers. » / « issuing a background sync request may only be made while the main app is open, and browsers limit the number of retries and the length of time background sync operations can take. »
- Portée / limites : le tableau de compatibilité détaillé n'a pas été lu. Le statut « Limited availability » est celui de la page au moment de la consultation.
- En pratique : prévoir une resynchronisation au retour au premier plan, avec une file d'opérations idempotentes, et traiter Background Sync comme une amélioration facultative.

---

## 9. Performance : mesurer avant d'optimiser, mais fixer la cible au cadrage

### Fixer une cible de performance chiffrée au cadrage, et n'optimiser qu'après une mesure qui localise le problème
- Niveau de preuve : N4
- Source : Bueno, 2013, « The Mature Optimization Handbook » (Engineering at Meta), https://engineering.fb.com/core-data/the-mature-optimization-handbook ; il cite Knuth, 1974, « Structured Programming with go to Statements » (source primaire non ouverte)
- Extrait lu : « Optimizing without measurement to guide you is foolish. » ; Knuth, cité par Bueno : « We should forget about small efficiencies, say about 97% of the time; premature optimization is the root of all evil. » / « Yet we should not pass up our opportunities in that critical 3%. »
- Portée / limites : avis d'experts. Aucune étude empirique (N2) sur la fiabilité de l'intuition des développeurs quant aux goulets d'étranglement n'a été trouvée ni lue. Les pourcentages de Knuth sont rhétoriques, pas mesurés.
- En pratique : la cible (latence p95, volumétrie) est une NFR du cadrage, donc un scénario. L'optimisation, elle, ne commence qu'avec un profil ou une mesure (EXPLAIN ANALYZE, trace). Il n'y a pas de contradiction entre les deux.

---

## Verdict sur les règles du profil

| Règle | Verdict | Motif sourcé |
|---|---|---|
| Checklist NFR (performance, sécurité, coût d'exploitation, observabilité, opérabilité, accessibilité/i18n ; chaque item traité ou N/A) | **Soutenue, à préciser** | Le principe « chaque item traité ou N/A » est soutenu. Les risques d'omission sont environ deux fois plus nombreux que ceux de commission dans 99 thèmes de risque issus de 18 évaluations ATAM (SEI 2006, N3). Les architectes interrogés ne documentent ni ne valident leurs NFR, et la sécurité n'est citée par aucun (Ameller 2012, N2, n = 13). ISO/IEC 25010:2023 sert explicitement à « validating the comprehensiveness of requirements definition » (N1). **À préciser** : (1) il manque la fiabilité (disponibilité, récupérabilité : sauvegarde et restauration), la compatibilité/interopérabilité et la maintenabilité/flexibilité (dont la scalabilité) d'ISO 25010:2023 ; (2) « traité » doit signifier « avec une mesure et un moyen de validation » (SEI QAW 2003 ; Eckhardt 2016, N2 : 75 % des NFR sont des comportements testables) ; (3) la phrase « la dette qu'on découvre en prod » est une affirmation causale non mesurée. Mieux vaut la justifier par l'irréversibilité de certaines décisions (Menzies 2017 ne trouve pas d'effet général de surcoût lié au retard). |
| « Optimiser la perf sans mesure » (anti-pattern) | **Soutenue par l'avis d'experts (N4) ; aucune preuve empirique trouvée** | Bueno 2013 : « Optimizing without measurement to guide you is foolish. » Knuth 1974, cité via Bueno, « critical 3% ». Aucune étude N2 lue sur l'intuition des développeurs en matière de performance. **À préciser** : l'anti-pattern ne doit pas empêcher de fixer une cible chiffrée au cadrage. ATAM et QAW exigent une mesure de réponse (« receives it within five seconds »). |
| « Cadrer le fonctionnel en ignorant les NFR » (anti-pattern) | **Soutenue** | Ameller 2012 (N2) : dans 10 projets sur 13, l'architecte était la source principale des NFR, et un client « never mentioned that web pages could not take more than 2 seconds to load, but he complained about it afterwards ». SEI 2006 (N3) : parmi les thèmes de risque, « not knowing performance requirements » et « unknown requirements for quality of service ». **Nuance** : la formule « découvertes en prod » suggère un coût de correction toujours plus élevé, ce que Menzies et al. (N2, 171 projets) contredisent comme loi générale. |
| Absence de scénario mesurable par attribut | **À ajouter, sous forme légère** | Le format en six parties et l'exigence de mesure de réponse viennent du SEI (QAW 2003, ATAM 2000, N3). Les NFR vagues sont la norme observée (Ameller 2012, N2), et la plupart sont des comportements testables (Eckhardt 2016, N2). Aucune étude ne mesure l'effet des scénarios sur les défauts en production. Proposition : 2 à 3 scénarios pour les seuls attributs (H, H) ou (H, M) de l'utility tree. |
| Absence de modélisation des menaces | **À ajouter, bornée** | Recommandée en phase de conception par OWASP (N3), le Threat Modeling Manifesto (N4) et Microsoft (N3). La seule étude empirique lue (Scandariato 2015, N2, 57 étudiants) la trouve apprenable mais coûteuse (1,8 menace valide par heure) et incomplète (« many threats go undetected »). Proposition : les quatre questions plus STRIDE, limités aux nouvelles frontières de confiance de la feature, sans prétention d'exhaustivité. |
| Absence de fitness function | **Convention sans preuve trouvée : à proposer en option** | Concept défini par Ford, Parsons et Kua, relayé par Thoughtworks (N4). Les outils existent pour la stack (dependency-cruiser pour JS/TS). Aucune étude d'efficacité trouvée. Proposition : « si une NFR du cadrage est vérifiable automatiquement, nommer le test ou la règle CI qui l'opposera », sans en faire une obligation. |

---

## Mythes et affirmations contestées

- **« Un défaut d'exigence coûte 100 fois plus cher en production » (attribué à Boehm 1981).** Menzies, Nichols, Shull et Layman (https://arxiv.org/pdf/1609.04886) : sur 171 projets de 2006 à 2014, « We found no evidence for the delayed issue effect ». Ils notent aussi que les données des études anciennes ne sont souvent plus accessibles : « it was no longer possible to access the data used to make prior conclusions ». L'effet peut exister dans certains projets, d'où la nuance : ce n'est pas une loi universelle.
- **« Les revues d'architecture font économiser 10 % » / « une revue rapporte 12 fois son coût ».** Le chiffre AT&T vient d'économies **perçues** déclarées par les chefs de projet : « At AT&T, each project manager reports perceived savings from an architecture evaluation » ; « projects receiving a full architecture evaluation have reported a 10% reduction in project costs ». Source : page de cours hébergée par UBC, apparemment extraite de *Software Architecture in Practice* (le livre n'est pas nommé sur la page), https://people.ece.ubc.ca/matei/EECE417/BASS/part03.html. Ce sont des données auto-déclarées, pas une mesure contrôlée. Le « 12× » n'a été vu que dans un résultat de recherche (diaporama NASA non ouvert) : non vérifié.
- **« Les exigences non fonctionnelles sont une catégorie à part, non testable comme le fonctionnel. »** Eckhardt et al. 2016 (ICSE) : 75 % des 530 NFR industrielles décrivent un comportement du système.
- **« Une modélisation des menaces STRIDE trouve les menaces. »** Scandariato et al. : « many threats go undetected during the analysis ». La modélisation réduit l'oubli de catégories, sans garantir l'exhaustivité.
- **« Modéliser tôt est plus rentable. »** C'est l'affirmation de Microsoft (« when they are relatively easy and cost-effective to resolve »). Elle est plausible, mais aucune mesure n'est fournie sur la page, et le chiffrage général du surcoût tardif est contesté (voir plus haut).
- **« ISO 25010 = utilisabilité et portabilité. »** C'était l'édition 2011. Depuis 2023 : interaction capability, flexibility, plus safety. L'accessibilité est découpée en inclusivity et user assistance.
- **« DORA = quatre métriques clés. »** La page DORA à jour (janvier 2026) en liste cinq, dont « Deployment rework rate ». L'année d'introduction exacte (2024 ou 2025) n'a pas été vérifiée.
- **« Les CRDT font disparaître les conflits. »** Kleppmann et al. : le CRDT conserve les valeurs en conflit et « leaves it to be resolved by the application or the user ». L'historique grossit, et la migration de schéma entre versions reste une question ouverte.
- **« L'ATAM a prouvé son efficacité. »** Les sources SEI lues décrivent la méthode (2000) et ce que les évaluations ont trouvé (2006, 18 évaluations). Aucune étude indépendante et contrôlée de l'efficacité de l'ATAM n'a été trouvée.

---

## Non vérifié

- **Fiche iso.org d'ISO/IEC 25010:2023** (403). Le contenu vient de l'aperçu officiel diffusé par iTeh (© 2023) et d'iso25000.com. Les sous-caractéristiques de Maintainability, Flexibility et Safety (au-delà de celles de Safety citées dans l'avant-propos) n'ont pas été lues. Le passage de « huit à neuf caractéristiques » n'est rapporté que par des sources secondaires. Le texte lu dit « nine characteristics » sans recompter l'édition 2011.
- **ISO/IEC 25002 et ISO/IEC 25019** : non ouvertes. Seuls les renvois de 25010 ont été lus.
- **ISO/IEC 21031:2024 sur iso.org** (403) : le statut ISO et la date viennent de la seule Green Software Foundation.
- **Bass, Clements et Kazman, *Software Architecture in Practice* (4e éd.)** : non ouvert. Le format en six parties est sourcé par le rapport SEI QAW 2003.
- **Ford, Parsons et Kua, *Building Evolutionary Architectures* (2e éd.)** : la page O'Reilly a répondu 403. La définition n'a été lue que via Thoughtworks.
- **Knuth 1974 (source primaire)** : le téléchargement depuis l'ACM a échoué. La citation n'est lue que via Bueno 2013. La phrase de Knuth sur l'échec des intuitions des programmeurs n'est pas vérifiée.
- **Date du Threat Modeling Manifesto (2020)** : aucune date sur la page.
- **PDF CISA « Secure by Design » (octobre 2023)** : non lu (trop volumineux, téléchargement direct refusé). Il est donc impossible de dire ce qu'il prescrit sur la modélisation des menaces. La première version d'avril 2023 n'est connue que par des sources secondaires.
- **Méthode et échantillons DORA 2024 et 2025** : les pages ouvertes ne publient ni la méthode ni la taille d'échantillon. Le chiffre « nearly 5,000 » pour 2025 n'a été vu que dans un résumé de recherche (billet Google non ouvert).
- **Taux exacts de faux positifs et faux négatifs de STRIDE** chez Scandariato : non extraits.
- **Chiffre de Svensson et al. (60 % des NFR jamais ou parfois mesurables)** : lu seulement tel que relayé par Ameller et al.
- **Principes de conception AWS Operational Excellence** (dont « Make frequent, small, reversible changes ») : la page ouverte n'a rien renvoyé d'exploitable. Non cités.
- **Efficacité mesurée des fitness functions et des revues d'architecture** : aucune étude empirique trouvée.
- **Abowd et al. 1997 (CMU/SEI-96-TR-025)** : le PDF du DTIC n'a pas pu être lu. Les chiffres AT&T ne sont lus que via la page UBC.

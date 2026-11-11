# Fiche `ux-preuves` — Architecture — modularité, couplage et dette technique

> Fiche du skill `ux-preuves` (dev-fullstack), volet **architecture**, préchargé par `architecte`. Couvre : Parnas et l'information hiding, matrices de structure de conception, loi de Conway et mirroring hypothesis, monolithe, monolithe modulaire et microservices, couplage et performance de livraison, dette technique (Cunningham, dette d'architecture, SATD), churn et défauts, YAGNI et abstraction prématurée.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Normes, versions et textes réglementaires
> **vieillissent** ; le droit change par révision : avant d'en faire dépendre une décision,
> relire la page officielle (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche documentaire du 9 novembre 2026. Toutes les sources citées ont été **réellement ouvertes** (WebFetch, ou curl puis `pdftotext`). Quand seul le résumé a été lu, c'est écrit. Les extraits sont verbatim, dans leur langue d'origine. Les calculs faits par nous sont signalés « (calcul) ».
> Contexte cible : développeur indépendant, souvent seul ; Next.js, Supabase/Postgres, Node, FastAPI ; parfois une PWA monofichier sans build.
> Échelle de preuve : N1 norme · N2 recherche revue par pairs ou étude empirique à large échantillon · N3 guide officiel d'institution ou de plateforme · N4 avis d'expert, livre, billet de praticien, enquête d'éditeur.

---

## 1. Modularité et masquage d'information

### Découper en modules selon les décisions difficiles ou susceptibles de changer, et non selon les étapes du traitement
- Niveau de preuve : N2 (article revu par pairs, CACM). Attention : c'est un **argument de conception illustré par un exemple** (KWIC), pas une étude empirique ; il n'y a aucun échantillon.
- Source : D. L. Parnas, 1972, « On the Criteria To Be Used in Decomposing Systems into Modules », Communications of the ACM 15(12), DOI 10.1145/361598.361623. Copie ouverte : https://wstomv.win.tue.nl/edu/2ip30/references/criteria_for_modularization.pdf (le PDF ACM a répondu 403)
- Extrait lu : « We propose instead that one begins with a list of difficult design decisions or design decisions which are likely to change. Each module is then designed to hide such a decision from the others. »
- Portée / limites : l'article oppose deux découpages d'un même petit système et argumente sur des scénarios de changement. Il ne mesure aucun coût réel. Il annonce trois bénéfices attendus (« managerial », « product flexibility », « comprehensibility »), sans les démontrer.
- En pratique : pour chaque frontière proposée dans un cadrage, demander quelle décision elle cache (fournisseur d'auth, schéma de stockage, format d'export, moteur de calcul). Une frontière qui ne cache rien de susceptible de changer est suspecte. Même question pour un module qui suit simplement l'ordre des étapes, comme « parse → validate → save ».

### Ne jamais faire d'un format de données interne l'interface entre modules : le cacher derrière un module
- Niveau de preuve : N2 (même article, argument conceptuel)
- Source : D. L. Parnas, 1972, même article, https://wstomv.win.tue.nl/edu/2ip30/references/criteria_for_modularization.pdf
- Extrait lu : « It is conventional to make such formats the interfaces between various modules. Because design evolution forces frequent changes on control block formats such a decision often proves extremely costly. »
- Portée / limites : Parnas parle de « control blocks » d'un système de 1972. Le transfert vers une forme de JSON partagée entre le front et le back, une table Postgres lue par plusieurs services ou un schéma `localStorage` est une **analogie** de notre part.
- En pratique : chercher dans le cadrage les formats qui traversent plusieurs modules sans propriétaire unique, par exemple une table lue directement par le front, le back et une Edge Function. C'est ce qui fonde la règle du « format migrable ».

### Mesurer le couplage par la portée d'un changement (« propagation cost »), et savoir qu'une refonte délibérée peut le réduire fortement
- Niveau de preuve : N2 (Management Science 52(7), 2006). L'échantillon est très petit : Linux et Mozilla, plusieurs versions. Les auteurs qualifient eux-mêmes le travail d'« exploratory ».
- Source : A. MacCormack, J. Rusnak, C. Y. Baldwin, 2006, « Exploring the Structure of Complex Software Designs: An Empirical Study of Open Source and Proprietary Code », working paper HBS 05-016 (version « Forthcoming: Management Science 2006 »), https://www.hbs.edu/ris/Publication%20Files/05-016.pdf ; notice : https://ideas.repec.org/a/inm/ormnsc/v52y2006i7p1015-1030.html
- Extrait lu : « Intuitively, this measures the proportion of elements that could be affected, on average, when a change is made to one element in the system. » ; « the propagation cost of the design has dropped from 17.35% to 2.78%. That is, changes to a source file have the potential to impact 80% fewer source files, on average, after the re-design. »
- Portée / limites : la mesure porte sur les dépendances statiques entre fichiers source, à partir d'une matrice de structure de conception (DSM). C'est un potentiel d'impact, pas un coût mesuré en heures. Le lien entre le mode d'organisation (open source ou propriétaire) et la structure est corrélationnel.
- En pratique : demander quelle part du code doit bouger quand on change une règle métier ou un fournisseur. Un cadrage où « tout dépend de tout », par exemple des utilitaires partagés importés partout ou un store global, a un coût de propagation élevé. Le cas Mozilla montre aussi qu'une **refonte ciblée des dépendances** est faisable : une mauvaise structure ne condamne pas à la réécriture.

### Préférer des modules « profonds » : beaucoup de fonctionnalité derrière une interface simple ; se méfier des découpages en petites unités « peu profondes »
- Niveau de preuve : N4 (avis d'expert ; le livre lui-même n'a pas pu être ouvert)
- Source : J. Ousterhout et R. C. Martin, 2024-2025, « A Philosophy of Software Design vs Clean Code » (échange écrit, dépôt de J. Ousterhout), https://raw.githubusercontent.com/johnousterhout/aposd-vs-clean-code/main/README.md
- Extrait lu : « I call these methods "deep". However, like most ideas in software design, decomposition can be taken too far. » ; « I call these interfaces "shallow": they don't help much in terms of reducing what the programmer needs to know. »
- Portée / limites : c'est un critère de jugement, pas une mesure. Il vise d'abord les méthodes et les classes, mais Ousterhout l'étend aux modules. Aucune preuve empirique n'est citée.
- En pratique : pour chaque couche ou service proposé, comparer la taille de l'interface (ce que l'appelant doit savoir) au volume de ce qui est caché. Un wrapper qui expose les mêmes paramètres que la bibliothèque sous-jacente est une couche peu profonde, donc un coût sans masquage.

---

## 2. Loi de Conway et « mirroring hypothesis »

### La structure d'un système tend à copier la structure de communication de l'organisation qui le conçoit
- Niveau de preuve : N4 (article de magazine professionnel, Datamation, avril 1968, non revu par pairs)
- Source : M. E. Conway, 1968, « How Do Committees Invent? », Datamation, https://www.melconway.com/Home/Committees_Paper.html
- Extrait lu : « organizations which design systems (in the broad sense used here) are constrained to produce designs which are copies of the communication structures of these organizations. » ; « the very act of organizing a design team means that certain design decisions have already been made, explicitly or otherwise. »
- Portée / limites : c'est une thèse argumentée, sans données. Elle porte sur des **organisations** (plusieurs personnes ou groupes qui communiquent). Conway en tire aussi : « flexibility of organization is important to effective design. »
- En pratique : pour un développeur seul, il n'y a pas de structure de communication interne à refléter. La loi ne donne donc **aucun critère** pour découper un système en services. Elle devient pertinente dès qu'il y a un sous-traitant, un client qui développe une partie ou une équipe tierce qui détient une API.

### Le « mirroring » est fréquent mais pas universel, et peu soutenu dans les projets collaboratifs ouverts
- Niveau de preuve : N2 (revue de 142 études empiriques, Industrial and Corporate Change 25(5), 2016) — **résumé seul lu** ; le texte intégral (Harvard DASH) a renvoyé une erreur 429.
- Source : L. J. Colfer, C. Y. Baldwin, 2016, « The mirroring hypothesis: theory, evidence, and exceptions », Industrial and Corporate Change, DOI 10.1093/icc/dtw027, notice : https://ideas.repec.org/a/oup/indcch/v25y2016i5p709-738..html ; version de travail 2010 : https://ideas.repec.org/p/hbs/wpaper/10-058.html
- Extrait lu : 2016 : « The industry and firm studies indicate that mirroring is a prevalent pattern but not universal. » (les études de projets ouverts « were not supportive of the hypothesis ») ; version de travail 2010 : « The hypothesis was supported in 69% of the cases. » (sur 102 études)
- Portée / limites : le chiffre de 69 % vient de la version 2010 (102 études). Le résumé 2016 (142 études) ne donne pas de pourcentage global. Les auteurs montrent qu'on peut « break the mirror », par exemple par des partitions modulaires.
- En pratique : ne pas invoquer Conway comme une loi physique. Se demander qui, concrètement, va communiquer autour de chaque frontière. Pour un indépendant, la frontière qui compte est souvent **contractuelle** : client, prestataire, plateforme tierce.

### Les métriques d'organisation prédisent mieux les binaires sujets aux défaillances que le churn, la complexité ou les dépendances (dans une très grande organisation)
- Niveau de preuve : N2 (ICSE 2008 ; Windows Vista, plus de 50 millions de lignes, plus de 3 400 binaires, équipes de « several thousand »)
- Source : N. Nagappan, B. Murphy, V. R. Basili, 2008, « The Influence of Organizational Structure on Software Quality: An Empirical Case Study », ICSE 2008 (MSR-TR-2008-11), https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/tr-2008-11.pdf
- Extrait lu : Table 4 : « Organizational 86.2% 84.0% » (précision, rappel) ; « Code Churn 78.6% 79.9% » ; « Code Complexity 79.3% 66.0% » ; « Dependencies 74.4% 69.9% » ; « Code Coverage 83.8% 54.4% » ; « Pre-Release Bugs 73.8% 62.9% ».
- Portée / limites : il n'y a qu'un système. Les huit métriques mesurent par exemple le nombre d'ingénieurs qui ont touché un binaire, l'éloignement hiérarchique ou le « multi-tasking ». La validation est faite sur 50 découpages aléatoires (2/3 pour l'apprentissage, 1/3 pour le test).
- En pratique : quand plusieurs personnes ou équipes touchent un même module, c'est un signal de risque. Pour un projet solo, ces métriques ne s'appliquent pas (voir l'entrée suivante).

### Ne pas transposer à une équipe d'une personne les preuves de type Conway et organisation : elles ont été établies sur des organisations d'au moins une trentaine d'ingénieurs
- Niveau de preuve : N2 (même étude, section validité externe)
- Source : N. Nagappan, B. Murphy, V. R. Basili, 2008, même rapport, https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/tr-2008-11.pdf
- Extrait lu : « The results indicate that a team of size 30 engineers and three levels of depth should be sufficient to collect the organizational metrics to predict failure-proneness. »
- Portée / limites : ce seuil est celui à partir duquel la méthode **fonctionne** dans leur réplication réduite. Ce n'est pas une preuve que rien ne s'applique en dessous. Nous n'avons trouvé **aucune étude** sur le choix d'architecture d'un développeur seul.
- En pratique : quand un cadrage invoque Conway, la « Team Topologies » ou l'autonomie d'équipe pour justifier un découpage en services dans un projet solo, demander quelle équipe est concernée. Sans équipe, l'argument tombe.

---

## 3. Monolithe, monolithe modulaire, microservices

### Commencer par un monolithe, et ne passer aux services qu'une fois les frontières stabilisées
- Niveau de preuve : N4 (billet de praticien, fondé explicitement sur des anecdotes)
- Source : M. Fowler, 3 juin 2015, « MonolithFirst », https://martinfowler.com/bliki/MonolithFirst.html
- Extrait lu : « Almost all the successful microservice stories have started with a monolith that got too big and was broken up » ; « Any refactoring of functionality between services is much harder than it is in a monolith. But even experienced architects working in familiar domains have great difficulty getting boundaries right at the beginning. » ; « Although the evidence is sparse […] »
- Portée / limites : Fowler écrit lui-même « relatively few anecdotes to learn from » et dit que tout conseil sur ce sujet « must be seen as tentative ». Il mentionne aussi l'avis contraire de collègues, notamment pour les remplacements de systèmes existants.
- En pratique : pour un indépendant, le défaut à chercher est un découpage en services décidé avant que le domaine soit connu. Demander combien de fois la frontière a déjà été déplacée ou discutée. Si la réponse est « jamais », elle n'est probablement pas encore stable.

### Les migrations vers les microservices butent d'abord sur le découplage du monolithe, le découpage des données et la communication entre services
- Niveau de preuve : N2 (IEEE Cloud Computing 4(5), 2017). L'échantillon est petit : 21 praticiens interrogés, qui avaient tous déjà migré (biais de sélection).
- Source : D. Taibi, V. Lenarduzzi, C. Pahl, 2017, « Processes, Motivations, and Issues for Migrating to Microservices Architectures: An Empirical Investigation », IEEE Cloud Computing, copie des auteurs : https://m3s-cloud.github.io/assets/paper1.pdf
- Extrait lu : « The main issues reported are the complexity to decouple from the monolithic system, followed by migration and splitting of data in legacy databases and communication among services. » ; « Although return on investment was expected to take longer, the reduced maintenance effort in the long run was considered to highly compensate for this. »
- Portée / limites : il s'agit de perceptions déclarées par des praticiens satisfaits de leur choix. Aucun coût n'est mesuré. Le contexte est celui d'entreprises qui ont des équipes, pas de développeurs seuls.
- En pratique : si un cadrage prévoit un service séparé, demander où vit la donnée et qui en est propriétaire. Une base partagée entre services reproduit le couplage. Une base séparée crée un problème de cohérence que le cadrage doit traiter explicitement.

### Le choix du découpage en services (« service cut ») est le principal défi technique des migrations, et la plupart des entreprises finissent par réécrire
- Niveau de preuve : N2 (ICSME 2019 ; 14 systèmes, 16 entretiens, 10 entreprises ; étude qualitative)
- Source : J. Fritzsch, J. Bogner, S. Wagner, A. Zimmermann, 2019, « Microservices Migration in Industry: Intentions, Strategies, and Challenges », ICSME 2019, https://arxiv.org/pdf/1906.04702
- Extrait lu : « Due to the high complexity of their legacy systems, most companies preferred a rewrite using current technologies over splitting up existing code bases. This was often caused by the absence of a suitable decomposition approach. As such, finding the right service cut was a major technical challenge »
- Portée / limites : l'échantillon est de grandes et moyennes organisations. Un interviewé contredit MonolithFirst : « Most productive and successful Microservices projects that I know are greenfield developments. »
- En pratique : c'est l'argument le plus solide pour classer une **frontière de service** parmi les décisions coûteuses à inverser. Dans un cadrage, toute frontière qui deviendra un appel réseau ou une base séparée doit être justifiée par un besoin présent : scalabilité mesurée, isolation de sécurité, cadence de déploiement différente.

### Des retours des microservices au monolithe existent, motivés par le coût, la complexité, la scalabilité, la performance et l'organisation, mais ils restent rares et surtout documentés par la littérature grise
- Niveau de preuve : N4 (préprint lu, la version de revue n'a pas été ouverte : condition de N2 non établie ; revue multivocale ; la quasi-totalité des sources est grise ; 19 articles utiles + 9 par boule de neige dans la version 2023)
- Source : R. Su, X. Li, D. Taibi, 2023, « Back to the Future: From Microservice to Monolith », préprint arXiv 2308.15281 (étendu en 2024 dans Electronics 13(8) 1452, version non ouverte : MDPI a renvoyé 403), https://arxiv.org/pdf/2308.15281
- Extrait lu : « there are four cases that switch from microservice back to monolith: Istio [SA2], Amazon Prime Video [SA5], Segment [SA14] and InVision [SA20]. » ; « Such a switch back would require an assessment of whether monolithic is really the best fit for the company's team size, structure, skills, and operational capabilities »
- Portée / limites : quatre cas seulement. Le terme « trend » repose surtout sur des billets et des débats en ligne. Il n'y a aucune mesure indépendante.
- En pratique : le défaut à chercher est de citer ces cas comme une preuve qu'il faut un monolithe en général, ou, à l'inverse, de les ignorer. Le critère opérationnel qu'ils donnent est la **taille, la structure, les compétences et la capacité d'exploitation de l'équipe**. Pour un développeur seul, ces quatre critères vont tous dans le même sens.

### Le cas Prime Video 2023 concerne un seul service de surveillance audio et vidéo, pas l'architecture de Prime Video ; le billet original n'a pas pu être relu
- Niveau de preuve : N4 (billet d'ingénierie d'entreprise ; ici **lu seulement à travers une source secondaire**)
- Source : citation du billet « Scaling up the Prime Video audio/video monitoring service and reducing costs by 90% » (mars 2023) par D. Ramel, 8 mai 2023, Virtualization Review, https://virtualizationreview.com/articles/2023/05/08/serverless-vs-monolith.aspx — l'URL originale sur primevideotech.com redirige aujourd'hui vers aboutamazon.com, et l'archive web.archive.org n'était pas joignable depuis cet environnement.
- Extrait lu (cité par la source secondaire) : « Moving our service to a monolith reduced our infrastructure cost by over 90 percent » ; « It also increased our scaling capabilities. »
- Portée / limites : un seul composant, à charge très particulière (analyse d'images vidéo). Les détails techniques (Step Functions, S3, traitement en mémoire) ne sont rapportés que par des sources secondaires, et sont **non vérifiés** dans le texte original.
- En pratique : ne pas citer ce cas comme une preuve générale. Le retenir comme exemple d'un découpage dont le **coût des échanges** (orchestration, stockage intermédiaire) dépassait le bénéfice. C'est une question à poser à toute découpe en fonctions serverless chaînées.

### Les microservices supposent une équipe par service, des compétences en systèmes distribués et une culture DevOps mûre ; un domaine simple relève d'un style plus simple
- Niveau de preuve : N3 (guide officiel Microsoft Azure Architecture Center)
- Source : Microsoft, « Microservices architecture style » (dernière mise à jour 2025-07-11), https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices ; et « Architecture styles » (dernière mise à jour 2026-11-04), https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/
- Extrait lu : « Microservices are small, independent, and loosely coupled components that a single small team of developers can write and maintain. » ; « A microservices application has more moving parts than the equivalent monolithic application. » ; « Skill set: Microservices are highly distributed systems. Carefully evaluate whether the team has the skills and experience to be successful. » ; le tableau des styles associe Web-Queue-Worker à un « Relatively simple domain with some resource-intensive tasks » et les microservices à un « Complicated domain. Frequent updates. »
- Portée / limites : c'est la documentation d'un vendeur de plateforme cloud, sans données. Elle ne traite pas explicitement de l'équipe d'une personne.
- En pratique : poser trois questions. Le domaine est-il « compliqué » au sens du tableau ? Existe-t-il plusieurs équipes ? Qui assure l'exploitation (journaux corrélés, versionnage des contrats) ? Pour un indépendant, trois « non » orientent vers un monolithe (modulaire), éventuellement accompagné d'un worker asynchrone.

### Un guide de plateforme recommande au contraire d'éviter le monolithe « whenever possible » : le choix reste contesté entre sources officielles
- Niveau de preuve : N3 (AWS Well-Architected Framework, pilier fiabilité)
- Source : AWS, « REL03-BP01 Choose how to segment your workload », https://docs.aws.amazon.com/wellarchitected/latest/framework/rel_service_architecture_monolith_soa_microservice.html
- Extrait lu : « Monolithic architecture should be avoided whenever possible. » ; mais aussi : « What is right for a new product racing to first launch is different than what a workload built to scale from the start needs. » ; « Even if you choose to start with a monolith architecture, you must ensure that it's modular and can ultimately evolve to SOA or microservices »
- Portée / limites : cette page est écrite du point de vue de la **résilience** d'une charge de travail, pas de la productivité d'une petite équipe. Elle cite elle-même l'anti-pattern « microservice Death Star ».
- En pratique : quand un cadrage s'appuie sur « AWS recommande les microservices », vérifier le pilier invoqué. Le point de convergence entre AWS et Microsoft : si monolithe il y a, il doit être **modulaire**.

### Le monolithe modulaire (un seul déploiement, des frontières de composants respectées) est une voie intermédiaire documentée par des praticiens
- Niveau de preuve : N4 (billet d'ingénierie, Shopify)
- Source : K. Westeinde, 21 février 2019, « Deconstructing the Monolith: Designing Software that Maximizes Developer Productivity », https://shopify.engineering/deconstructing-monolith-designing-software-maximizes-developer-productivity
- Extrait lu : « We chose to evolve Shopify into a modular monolith, meaning that we would keep all of the code in one codebase, but ensure that boundaries were defined and respected between different components. » ; « no architecture is often the best architecture in the early days of a system. »
- Portée / limites : le contexte est un code Rails travaillé par « more than a thousand developers ». Le billet décrit une trajectoire, pas une mesure comparative.
- En pratique : pour un projet Next.js et Supabase solo, la forme utile est la suivante : des dossiers par domaine, avec une API interne par domaine (fonctions exportées) et une règle « pas d'import transverse ni de requête directe sur les tables d'un autre domaine ». Le défaut à chercher : ces frontières écrites dans le cadrage mais contrôlées par rien (lint, revue).

---

## 4. Couplage et performance de livraison

### Une architecture et des équipes faiblement couplées sont le meilleur prédicteur de la livraison continue (selon l'enquête DORA 2017)
- Niveau de preuve : N4 selon la règle de ce référentiel (enquête d'éditeur, Puppet et DORA), malgré un large échantillon : 3 200 répondants en 2017, plus de 27 000 réponses cumulées sur six ans. Les données sont **déclaratives et transversales**, ce qui ne permet pas d'établir de causalité.
- Source : Puppet et DORA, 2017, « 2017 State of DevOps Report », https://dora.dev/publications/pdf/state-of-devops-2017.pdf
- Extrait lu : « Loosely coupled architectures and teams are the strongest predictor of continuous delivery. » ; « The biggest contributor to continuous delivery — bigger even than test and deployment automation — is whether a team can do all of the following: • Make large-scale changes to the design of its system without permission from someone outside the team. »
- Portée / limites : l'unité d'analyse est l'**équipe dans une organisation**. Les critères parlent de permissions et de coordination avec d'autres équipes, qui n'ont pas d'objet pour un développeur seul. Le livre Accelerate (Forsgren, Humble, Kim 2018), qui expose la méthode, **n'a pas été ouvert**.
- En pratique : transposer les critères qui gardent un sens en solo. Peut-on tester un module sans environnement intégré complet ? Peut-on déployer sans coordonner plusieurs déploiements ? Un cadrage qui impose de déployer ensemble le front, une Edge Function et une migration, dans un ordre précis, crée un couplage de livraison même dans un projet solo.

### Le couplage faible est une propriété, pas une technologie : on peut l'obtenir sur mainframe et le rater en microservices
- Niveau de preuve : N3 (page officielle DORA, programme de Google Cloud)
- Source : DORA, « Capabilities: Loosely coupled teams » (dernière mise à jour 20 octobre 2025 ; l'URL `/capabilities/loosely-coupled-architecture/` redirige ici), https://dora.dev/capabilities/loosely-coupled-teams/
- Extrait lu : « It's possible to achieve these outcomes with mainframe technologies. It's also possible to fail to achieve them even when using the latest, most trendy technologies. » ; « many so-called service-oriented architectures don't permit testing and deploying services independently of each other »
- Portée / limites : c'est un guide qui renvoie aux rapports 2017, 2021, 2022 et 2023. Il ne donne pas de seuil chiffré.
- En pratique : juger un cadrage sur la testabilité et le déploiement indépendants, pas sur le nombre de services. Le défaut à chercher : des « services » séparés qu'on ne peut ni tester ni déployer seuls, c'est-à-dire un monolithe distribué.

---

## 5. Dette technique

### La dette au sens d'origine est un compromis assumé pour aller vite, à rembourser rapidement, y compris par une réécriture ; elle ne justifie pas d'écrire du mauvais code
- Niveau de preuve : N4 (rapport d'expérience OOPSLA 1992 ; explication de l'auteur en 2009, transcrite sur son wiki)
- Source : W. Cunningham, 1992, « The WyCash Portfolio Management System », OOPSLA '92 Experience Report, http://c2.com/doc/oopsla92.html ; W. Cunningham, transcription de la vidéo « Debt Metaphor » (page datée du 22 janvier 2011), http://c2.com/wiki/remodel/pages/WardExplainsDebtMetaphor
- Extrait lu : « Shipping first time code is like going into debt. A little debt speeds development so long as it is paid back promptly with a rewrite. » ; « The danger occurs when the debt is not repaid. » ; et, plus tard : « I'm never in favor of writing code poorly, but I am in favor of writing code to reflect your current understanding of a problem even if that understanding is partial. »
- Portée / limites : il s'agit d'une métaphore, sans mesure. Le texte d'origine parle bien d'un remboursement « with a rewrite ».
- En pratique : dans un cadrage, nommer explicitement chaque dette prise (ce qui est simplifié, pourquoi, et quel signal déclenchera le remboursement). Une dette non nommée n'est pas une dette, c'est un défaut.

### Utiliser la définition de consensus de Dagstuhl : des constructions opportunes à court terme qui rendent les changements futurs plus coûteux, avec un effet limité à la maintenabilité et à l'évolutivité
- Niveau de preuve : N3 (définition de consensus d'un séminaire de recherche international ; ce n'est ni une norme ni une étude empirique)
- Source : P. Avgeriou, P. Kruchten, I. Ozkaya, C. Seaman (éd.), 2016, « Managing Technical Debt in Software Engineering (Dagstuhl Seminar 16162) », Dagstuhl Reports 6(4), https://drops.dagstuhl.de/storage/04dagstuhl-reports/volume06/issue04/16162/DagRep.6.4.110/DagRep.6.4.110.pdf
- Extrait lu : « In software-intensive systems, technical debt is a collection of design or implementation constructs that are expedient in the short term, but set up a technical context that can make future changes more costly or impossible. Technical debt presents an actual or contingent liability whose impact is limited to internal system qualities, primarily maintainability and evolvability. » ; et : « we now understand that technical debt is often incurred unintentionally »
- Portée / limites : par cette définition, un bug visible de l'utilisateur, une faille ou une performance dégradée **ne sont pas** de la dette technique.
- En pratique : ne pas ranger dans la « dette » une faille de sécurité ou une absence de RLS. Ce sont des défauts à corriger, pas des emprunts à rembourser plus tard.

### Ordre de grandeur du coût : environ un quart du temps de développement déclaré perdu à cause de la dette, dans une étude longitudinale industrielle
- Niveau de preuve : N2 (TechDebt 2018 ; Journal of Systems and Software 156, 2019). L'échantillon est petit : 43 développeurs, 16 entretiens. La mesure est **déclarative**. **Résumés seuls lus.**
- Source : T. Besker, A. Martini, J. Bosch, 2018, « Technical Debt Cripples Software Developer Productivity », https://research.chalmers.se/en/publication/507477 ; et 2019, « Software Developer Productivity Loss Due to Technical Debt — A replication and extension study examining developers' development work », JSS 156:41-61, https://research.chalmers.se/en/publication/511450
- Extrait lu : « developers waste, on average, 23% of their development time due to TD and that they are frequently forced to introduce new TD due to already existing TD. The most common activity on which additional time is spent is performing additional testing. »
- Portée / limites : il s'agit de temps perdu estimé par les développeurs eux-mêmes, dans des entreprises industrielles. Rien ne garantit la transposition au code d'un indépendant.
- En pratique : utiliser ce chiffre comme ordre de grandeur, jamais comme constante. L'observation la plus utile pour un cadrage est la phrase « forced to introduce new TD due to already existing TD » : une dette posée en fondation se propage.

### Les chiffres d'enquête d'éditeur sur la dette (Stripe 2018) sont des estimations du temps des autres, pas des mesures
- Niveau de preuve : N4 (enquête d'éditeur, menée avec Harris Poll : plus de 1 000 développeurs et plus de 1 000 dirigeants)
- Source : Stripe, septembre 2018, « The Developer Coefficient », https://stripe.com/files/reports/the-developer-coefficient.pdf
- Extrait lu : « How many hours each week do you think the average developer at your company spends on addressing "technical debt?" 13.5 hours Mean » ; « 17.3 Average hours spent by developers on bad code, debugging, refactoring, modifying » ; semaine moyenne : « 41.1 total hours »
- Portée / limites : la question porte sur le développeur « at your company », donc sur une perception du temps d'autrui. Le rapport mentionne « six different countries » en introduction, alors que la méthodologie n'en liste que cinq (États-Unis, Royaume-Uni, France, Allemagne, Singapour) : incohérence interne. 13,5 / 41,1 ≈ 33 % (calcul).
- En pratique : ne pas reprendre ce chiffre dans un argumentaire de cadrage comme s'il s'agissait d'une mesure. Préférer Besker et al. (N2, mais petit échantillon) ou, mieux, l'historique Git du projet lui-même.

### La dette d'architecture peut être « contagieuse » : ses intérêts croissent de façon non linéaire quand d'autres parties copient le problème
- Niveau de preuve : N2 (WICSA 2015 ; étude de cas multiple, 7 sites dans 5 grandes entreprises) — **résumé seul lu**
- Source : A. Martini, J. Bosch, 2015, « The Danger of Architectural Technical Debt: Contagious Debt and Vicious Circles », WICSA 2015, https://research.chalmers.se/en/publication/224827
- Extrait lu : « We found that some Technical Debt items are contagious, causing other parts of the system to be contaminated with the same problem, which may lead to non-linear growth of interest. » ; « a combination of weak awareness of debt, time pressure and refactoring creates Vicious Circles »
- Portée / limites : l'étude est qualitative, sur de grandes entreprises. La taxonomie détaillée n'a pas été lue.
- En pratique : les décisions qui seront **copiées** méritent le plus d'attention dans un cadrage. Exemples : le premier modèle de requête Supabase, le premier pattern de gestion d'erreur, la première forme d'API. Une mauvaise fondation copiée dix fois coûte bien plus qu'une mauvaise feature isolée.

### La dette auto-déclarée (commentaires TODO, FIXME, « hack ») est fréquente, introduite surtout par des développeurs expérimentés, et souvent jamais remboursée
- Niveau de preuve : N2 (ICSME 2014 ; 4 projets open source : Eclipse, Chromium OS, ArgoUML, Apache httpd)
- Source : A. Potdar, E. Shihab, 2014, « An Exploratory Study on Self-Admitted Technical Debt », ICSME 2014, http://users.encs.concordia.ca/~eshihab/pubs/Potdar_ICSME2014.pdf
- Extrait lu : « We find that the amount of self-admitted technical debt exists in 2.4% - 31% of the files. Furthermore, we find that developers with higher experience tend to introduce most of the self-admitted technical debt and that time pressures and complexity of the code do not correlate with the amount of self-admitted technical debt. » ; « only between 26.3% - 63.5% of self-admitted technical debt gets removed from projects after introduction. »
- Portée / limites : quatre grands projets open source. La détection repose sur des motifs de commentaires.
- En pratique : un « TODO : on fera mieux plus tard » dans un cadrage ou dans le code n'est pas un plan de remboursement. Exiger un déclencheur explicite, par exemple « quand le volume dépasse N » ou « avant l'ouverture à un second client ».

### Le code de faible qualité concentre beaucoup plus de défauts et ralentit fortement la résolution des tickets (étude d'un éditeur d'outil)
- Niveau de preuve : N2 avec **conflit d'intérêts** : 39 bases de code propriétaires, 30 737 fichiers ; le premier auteur est fondateur de l'éditeur de l'outil de mesure. Préprint arXiv lu ; le lieu de publication n'a pas été vérifié.
- Source : A. Tornhill, M. Borg, 2022, « Code Red: The Business Impact of Code Quality – A Quantitative Study of 39 Proprietary Production Codebases », https://arxiv.org/pdf/2203.04374
- Extrait lu : « we find that low quality code contains 15 times more defects than high quality code. Furthermore, resolving issues in low quality code takes on average 124% more time in development. »
- Portée / limites : la qualité est mesurée par la métrique propriétaire « Code Health ». Il s'agit de corrélations par fichier, sans contrôle de toutes les variables confondantes.
- En pratique : c'est un argument pour soigner les fichiers qu'on touchera souvent. Ce n'est pas un argument pour tout soigner également (voir les entrées sur les points chauds).

### L'hypothèse selon laquelle un bon design paie vite (« design stamina ») est une conjecture sans preuve objective ; son auteur situe le point de bascule en semaines, à titre de jugement
- Niveau de preuve : N4 (billet d'expert, qui déclare lui-même l'absence de preuve)
- Source : M. Fowler, 20 juin 2007, « Design Stamina Hypothesis », https://martinfowler.com/bliki/DesignStaminaHypothesis.html
- Extrait lu : « I call this a hypothesis because it is a conjecture, there is no objective proof that this phenomenon actually occurs. » ; « I take the view that it's much lower than most people think: usually weeks not months. But again this can only be a judgment call. »
- Portée / limites : c'est le texte de référence de nombreux praticiens, mais il est explicitement non prouvé.
- En pratique : pour un prototype jetable de quelques jours, sacrifier le design peut être rationnel. Au-delà de quelques semaines de vie prévue, la négligence du design coûte selon Fowler. Le cadrage doit donc **déclarer la durée de vie visée**.

### Une architecture peut être délibérément « sacrificielle » : prévoir dès le départ qu'on la remplacera
- Niveau de preuve : N4 (billet d'expert)
- Source : M. Fowler, 20 octobre 2014, « Sacrificial Architecture », https://martinfowler.com/bliki/SacrificialArchitecture.html
- Extrait lu : « often the best code you can write now is code you'll discard in a couple of years time. » ; « Essentially it means accepting now that in a few years time you'll (hopefully) need to throw away what you're currently building. »
- Portée / limites : l'horizon évoqué se compte en années, pas en mois. Fowler distingue ce cas d'une réécriture voulue par une nouvelle équipe qui « hait » le code existant.
- En pratique : demander si la réécriture est un **choix planifié**, avec un déclencheur et des points de remplacement pensés, ou si elle sera **subie**. L'objectif réaliste n'est pas « jamais de réécriture », mais « aucune réécriture forcée par une décision qu'on pouvait anticiper ».

---

## 6. Points chauds et évolution

### Un logiciel utilisé change en continu, et sa complexité augmente si l'on ne travaille pas activement à la réduire
- Niveau de preuve : N2 (Proceedings of the IEEE 68(9), 1980 ; lois tirées d'observations de grands systèmes). Copie OCR lue ; la notice IEEE Xplore 1456074 n'a pas été ouverte.
- Source : M. M. Lehman, 1980, « Programs, Life Cycles, and Laws of Software Evolution », Proceedings of the IEEE, https://gwern.net/doc/cs/1980-lehman.pdf
- Extrait lu : Loi I : « A program that is used and that as an implementation of its specification reflects some other reality, undergoes continual change or becomes progressively less useful. » ; Loi II : « As an evolving program is continually changed, its complexity, reflecting deteriorating structure, increases unless work is done to maintain or reduce it. » (espaces de l'OCR rétablis)
- Portée / limites : les lois concernent les « E-programs », c'est-à-dire les programmes qui modélisent une activité humaine. Les données sont celles de grands systèmes des années 1970.
- En pratique : un cadrage qui ne prévoit **aucun temps de remise en ordre** contredit la loi II. Pour une application métier qui vivra, demander où et quand la complexité sera réduite.

### Le churn relatif (changements rapportés à la taille et à la durée) prédit la densité de défauts ; le churn absolu prédit mal
- Niveau de preuve : N2 (ICSE 2005 ; Windows Server 2003 SP1, 44,97 millions de lignes, 2 465 binaires)
- Source : N. Nagappan, T. Ball, 2005, « Use of Relative Code Churn Measures to Predict System Defect Density », ICSE 2005, https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/icse05churn.pdf
- Extrait lu : « while absolute measures of code churn are poor predictors of defect density, our set of relative measures of code churn is highly predictive of defect density. » ; « our code churn metric suite is able to discriminate between fault and not fault-prone binaries with an accuracy of 89.0 percent. »
- Portée / limites : un seul système, très grand, analysé au niveau du binaire. La transposition aux fichiers d'une petite application n'est pas démontrée.
- En pratique : dans un dépôt existant, regarder la **proportion** de code récemment modifié par module avant de cadrer une feature qui le touche. Un module déjà très remanié est une zone à risque où renforcer les tests.

### Prioriser la dette là où l'activité de développement est concentrée (points chauds : fréquence de changement × santé du code)
- Niveau de preuve : N4 (documentation d'un éditeur d'outil ; méthode popularisée par A. Tornhill)
- Source : CodeScene, « Hotspots » (documentation), https://codescene.io/docs/guides/technical/hotspots.html
- Extrait lu : « Most development activity tends to be located in relatively few modules. A Hotspot analysis helps you identify those modules where you spend most of your development time. »
- Portée / limites : c'est de la documentation commerciale. L'appui empirique indirect vient de Nagappan et Ball 2005 (churn relatif) et de Tornhill et Borg 2022 (auteur lié à l'éditeur).
- En pratique : dans un projet existant, avant de cadrer, lister les fichiers les plus modifiés, par exemple avec `git log --format= --name-only | sort | uniq -c | sort -rn | head`. Une dette dans un fichier qu'on ne touche jamais coûte peu. La même dette dans le fichier qu'on modifie à chaque feature coûte à chaque passage.

---

## 7. Abstraction prématurée et YAGNI

### YAGNI, formulation d'origine (Extreme Programming) : implémenter quand on en a besoin, jamais quand on prévoit d'en avoir besoin
- Niveau de preuve : N4 (texte de praticien fondateur d'XP ; wiki de Cunningham)
- Source : R. Jeffries, 4 avril 1998, « You're NOT gonna need it! », https://ronjeffries.com/xprog/articles/practices/pracnotneed/ ; c2 wiki, « YouArentGonnaNeedIt » (page datée du 24 novembre 2014), http://c2.com/wiki/remodel/pages/YouArentGonnaNeedIt
- Extrait lu : « Always implement things when you actually need them, never when you just foresee that you need them. » ; sur c2 : « This doesn't mean you should avoid building flexibility into your code. It means you shouldn't overengineer something based on what you think you might need later on. »
- Portée / limites : c'est une pratique d'équipe XP, qui suppose des tests automatisés et du refactoring continu. Aucune preuve empirique n'est fournie.
- En pratique : pour chaque élément d'un cadrage, demander s'il sert un besoin présent et démontré, ou un besoin prévu.

### YAGNI vise les capacités construites pour une fonctionnalité présumée ; il ne s'applique pas à ce qui rend le code plus facile à modifier
- Niveau de preuve : N4 (billet d'expert)
- Source : M. Fowler, 26 mai 2015, « Yagni », https://martinfowler.com/bliki/Yagni.html
- Extrait lu : « Yagni only applies to capabilities built into the software to support a presumptive feature, it does not apply to effort to make the software easier to modify. » ; « Yagni is only a viable strategy if the code is easy to change » ; « yagni only applies when you introduce extra complexity now that you won't take advantage of until later. » ; sur le coût de portage : « The code for the presumptive feature adds some complexity to the software, this complexity makes it harder to modify and debug that software, thus increasing the cost of other features. »
- Portée / limites : Fowler admet des « yagni-failures », c'est-à-dire des cas où un changement fait plus tôt aurait été moins cher, « hard to spot in advance ». Son chiffre de « ⅔ » de fonctionnalités inutiles est attribué à Kohavi et al. et **n'a pas été vérifié** à la source.
- En pratique : la bonne ligne de partage n'est pas « feature contre fondation », mais « **complexité ajoutée pour un besoin présumé** contre **ce qui rend le code malléable** » (tests, refactoring, intégration continue, frontières nettes). Une « fondation » spéculative, par exemple du multi-tenant « au cas où » ou un système de plugins, tombe sous YAGNI. Un schéma de données sain et des migrations versionnées n'y tombent pas.

### Mieux vaut une duplication qu'une mauvaise abstraction ; attendre la troisième occurrence avant de factoriser
- Niveau de preuve : N4 (billet de praticienne ; règle de livre)
- Source : S. Metz, 20 janvier 2016, « The Wrong Abstraction », https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction ; règle de trois : M. Fowler, *Refactoring* (1999), attribuée à Don Roberts — **livre non ouvert**, texte lu dans une reproduction secondaire : https://nicologies.gitbook.io/awesome-programming-knowledge/writing-better-code/books/refactoring-improving-the-design-of-existing-code/quotes/the-rule-of-three
- Extrait lu : Metz : « duplication is far cheaper than the wrong abstraction » ; « If you find yourself passing parameters and adding conditional paths through shared code, the abstraction is incorrect. » ; reproduction de Refactoring : « The third time you do something similar, you refactor. »
- Portée / limites : il s'agit d'heuristiques. Metz décrit un mécanisme (le coût irrécupérable qui pousse à garder une abstraction fausse), sans mesure.
- En pratique : dans un cadrage, refuser une abstraction générique conçue à partir d'un seul cas d'usage. Signal de défaut en revue : une fonction partagée qui accumule des paramètres booléens et des branches par appelant.

### Seule preuve empirique indirecte trouvée sur l'abstraction prématurée : la « Speculative Generality » est très répandue, et la supprimer réduit nettement la propension au changement (mais peu celle aux défauts)
- Niveau de preuve : N2 (Empirical Software Engineering 23(3), 2018 ; 395 versions de 30 projets open source Java ; 17 350 instances validées à la main ; 13 types de « smells »)
- Source : F. Palomba, G. Bavota, M. Di Penta, F. Fasano, R. Oliveto, A. De Lucia, 2018, « On the diffuseness and the impact on maintainability of code smells: a large scale empirical investigation », manuscrit d'auteur : https://www.iris.unisa.it/bitstream/11386/4708436/2/J9.pdf
- Extrait lu : définition opérationnelle : « A class declared as abstract having less than three children classes using its methods. » ; « Other diffused code smells are Speculative Generality (80% of affected releases) » ; le tableau de synthèse classe la suppression de Speculative Generality « High » pour la propension au changement et « Limited » pour la propension aux défauts.
- Portée / limites : la définition est **très étroite** (une classe abstraite avec moins de trois enfants), sur du Java orienté objet. Elle ne couvre ni les couches de service inutiles, ni les « repositories » génériques, ni les interfaces à implémentation unique en TypeScript. Il s'agit de corrélations, pas d'une expérience contrôlée.
- En pratique : on peut dire « l'abstraction spéculative est associée à plus de changements » (N2, indirect). On ne peut **pas** dire « il est prouvé que l'abstraction prématurée coûte X ». Aucune étude contrôlée n'a été trouvée sur le coût de l'abstraction prématurée en général.

### Distinguer les décisions réversibles (« two-way doors ») des décisions irréversibles (« one-way doors ») et adapter le soin à la réversibilité
- Niveau de preuve : N4 (lettre d'un dirigeant d'entreprise, déposée à la SEC)
- Source : J. Bezos, lettre aux actionnaires d'Amazon pour 2015 (Exhibit 99.1, dépôt 2016), https://www.sec.gov/Archives/edgar/data/1018724/000119312516530910/d168744dex991.htm
- Extrait lu : « Some decisions are consequential and irreversible or nearly irreversible – one-way doors – and these decisions must be made methodically, carefully, slowly, with great deliberation and consultation. » ; « But most decisions aren't like that – they are changeable, reversible – they're two-way doors. »
- Portée / limites : le texte porte sur la prise de décision en grande organisation, pas sur le logiciel. Il ne dit **rien** sur l'idée de convertir une décision irréversible en décision réversible. Cette idée, en logiciel, s'appuie plutôt sur Parnas (cacher la décision susceptible de changer), mais sans mesure.
- En pratique : classer explicitement chaque décision du cadrage (schéma de données, fournisseur d'auth, format de stockage côté client, frontière de service, choix de framework). Réserver la délibération lente aux décisions irréversibles. Si l'on ajoute une abstraction pour rendre une décision réversible, vérifier qu'elle est **mince** et qu'elle ne crée pas son propre coût de portage (voir Fowler, Yagni).

---

## Verdict sur les règles du profil

| Règle du profil | Verdict | Motif sourcé |
|---|---|---|
| « YAGNI mal compris (valide pour feature, jamais pour fondation) » | **À préciser** (convention N4, pas de preuve empirique) | Fowler 2015 (N4) trace une autre ligne : YAGNI vise toute « capability built … to support a presumptive feature » et « does not apply to effort to make the software easier to modify ». Une **fondation spéculative** (multi-tenant, bus d'événements, plugins « au cas où ») tombe donc sous YAGNI. Ce qui y échappe, c'est ce qui rend le code malléable : tests, refactoring, intégration continue, frontières nettes, schéma sain. Reformulation proposée : « YAGNI s'applique à toute complexité ajoutée pour un besoin présumé, feature comme fondation. Il ne s'applique pas à ce qui garde le code facile à changer. » |
| « Sur-architecturer (couches d'abstraction prématurées) » | **Soutenue faiblement** (consensus N4 + un appui N2 indirect) | Le consensus de praticiens est convergent : Fowler (coût de portage), Metz (« duplication is far cheaper than the wrong abstraction »), Ousterhout (modules peu profonds). La seule donnée N2 trouvée est Palomba et al. 2018 : la Speculative Generality touche 80 % des versions, et sa suppression a un effet « High » sur la propension au changement, « Limited » sur les défauts. La définition y est étroite. Aucune étude contrôlée trouvée. |
| « Réversibilité : chercher activement à convertir une one-way door en two-way door (abstraction mince, format migrable) » | **Convention sans preuve empirique**, appui conceptuel solide, **à préciser** | Bezos 2015 (N4) fonde la distinction, mais ne parle pas de conversion. Parnas 1972 (N2, conceptuel) soutient le fait de cacher les décisions susceptibles de changer et les formats d'échange. Limite à écrire dans la règle : l'abstraction doit être **mince** et justifiée par une décision **identifiée** comme probablement changeante. Sinon elle tombe sous YAGNI (coût de portage, Fowler) et sous le risque de mauvaise abstraction (Metz). |
| « Ton rôle est de t'assurer qu'on n'aura pas à réécrire le code dans 3 mois. » | **À préciser** (formulation contredite par les sources de référence) | Cunningham 1992 : la dette se rembourse « promptly with a rewrite ». Fowler, Sacrificial Architecture : « often the best code you can write now is code you'll discard ». Fowler, Design Stamina : bénéfice non prouvé, point de bascule « weeks not months » au jugé. Lehman : la complexité croît inévitablement sans travail actif. Reformulation proposée : « s'assurer qu'aucune réécriture ne sera **forcée** par une décision structurante qu'on pouvait anticiper ; les décisions jetables doivent être déclarées comme telles, avec leur durée de vie visée. » |
| « Frontière de module » classée comme décision structurante coûteuse à inverser | **Soutenue pour les frontières de service ou de données ; à préciser pour les modules internes** | Fowler, MonolithFirst (N4) : « refactoring of functionality between services is much harder than it is in a monolith ». Fritzsch et al. 2019 (N2) : le « service cut » est « a major technical challenge », et la plupart des entreprises réécrivent. Taibi et al. 2017 (N2) : découpler et répartir les données sont les premiers problèmes. En revanche, MacCormack et al. 2006 (N2) montrent qu'une refonte ciblée des dépendances internes est possible (propagation de 17,35 % à 2,78 %). Préciser que le coût d'inversion dépend du **type** de frontière : réseau ou données séparées (cher), module interne au même déploiement (moins cher, si le couplage est contrôlé). |
| (absence) Rien sur monolithe ou microservices, ni sur Conway pour une équipe d'une personne | **Oui, à ajouter**, en annonçant le niveau de preuve (N3/N4, aucune étude N2 sur le cas solo) | Microsoft (N3) : un microservice correspond à « a single small team », exige « skills and experience » et « a mature DevOps culture » ; un domaine simple oriente vers Web-Queue-Worker. Fowler (N4) : monolithe d'abord, frontières difficiles à trouver tôt. Su et al. 2023 : juger selon « team size, structure, skills, and operational capabilities ». Conway et Nagappan et al. 2008 : preuves établies sur des **organisations** (au moins 30 ingénieurs, trois niveaux hiérarchiques). Contre-voix à citer : AWS Well-Architected REL03 (« Monolithic architecture should be avoided whenever possible », point de vue résilience). Règle proposée : « Pour un développeur seul, défaut = monolithe modulaire (frontières par domaine contrôlées par lint ou revue), plus un worker asynchrone si besoin. Toute séparation en service se justifie par un besoin présent et mesuré (isolation de sécurité, scalabilité différente, cadence de déploiement), jamais par Conway ni par l'autonomie d'équipe. » |

---

## Mythes et affirmations contestées

- **« Amazon / Prime Video a abandonné les microservices. »** Le billet de mars 2023 porte sur **un** service de surveillance audio et vidéo. L'original est retiré : l'URL redirige vers aboutamazon.com et nous n'avons lu que des citations secondaires. La revue de Su et al. ne recense que quatre cas de retour au monolithe, toutes sources confondues.
- **« MonolithFirst est démontré. »** Fowler écrit lui-même « the evidence is sparse » et parle de « relatively few anecdotes ». Un interviewé de Fritzsch et al. 2019 soutient l'inverse : « Most productive and successful Microservices projects that I know are greenfield developments. »
- **« Les plateformes recommandent toutes le monolithe pour commencer. »** Faux. AWS Well-Architected (fiabilité) dit « Monolithic architecture should be avoided whenever possible ». Microsoft souligne surtout le coût et les compétences qu'exigent les microservices. Les deux convergent seulement sur la **modularité**.
- **« DORA montre que les microservices améliorent la livraison. »** DORA mesure le **couplage faible**, pas une technologie : « It's possible to achieve these outcomes with mainframe technologies. » Ses données sont déclaratives et transversales, ce qui ne permet pas d'établir de causalité. Le même rapport 2017 dit aussi « test automation is the biggest contributor » parmi les pratiques techniques, et place l'architecture au-dessus.
- **« La loi de Conway est une loi empirique universelle. »** Conway 1968 est une thèse sans données. La revue de Colfer et Baldwin trouve un soutien dans 69 % de 102 études (version 2010), et un soutien faible ou nul dans les projets collaboratifs ouverts (2016).
- **« La dette technique, c'est écrire vite du code sale. »** Cunningham, dans sa transcription : « I'm never in favor of writing code poorly ». La définition de Dagstuhl exclut aussi les défauts visibles (sécurité, bugs) : elle limite l'effet « to internal system qualities, primarily maintainability and evolvability ».
- **« Les développeurs perdent 23 % (ou 33 %, ou 42 %) de leur temps à cause de la dette. »** 23 % : estimation déclarée par 43 développeurs (Besker et al.). Environ 33 % : calcul sur des estimations du temps **des autres** dans une enquête d'éditeur (Stripe). 42 % : chiffre cité en introduction par Tornhill et Borg, dont la source n'a pas été vérifiée. Aucun de ces chiffres n'est une mesure directe du temps.
- **« Plus un fichier change, plus il est bogué. »** Nagappan et Ball 2005 : le churn **absolu** prédit mal. Seul le churn **relatif** (rapporté à la taille et à la durée) prédit bien.
- **« La règle de trois vient de Fowler. »** Fowler l'attribue à Don Roberts (« Here's a guideline Don Roberts gave me »), selon une reproduction secondaire du livre.
- **« Le bon design paie toujours. »** Fowler lui-même : « there is no objective proof that this phenomenon actually occurs ».

---

## Non vérifié

- **Texte original du billet Prime Video (2023)** : l'URL primevideotech.com redirige vers aboutamazon.com, et web.archive.org a refusé la connexion depuis cet environnement. Les détails Step Functions, S3 et traitement en mémoire, ainsi que l'auteur, ne sont connus que par des sources secondaires et sont non vérifiés.
- **Livre *Accelerate*** (Forsgren, Humble, Kim 2018) : non ouvert. Sa méthode (analyse psychométrique, modèles structurels) n'est pas vérifiée ici ; seul le rapport State of DevOps 2017 a été lu.
- **Livre *A Philosophy of Software Design*** (Ousterhout) : la page Stanford a répondu 503. Seul l'échange écrit Ousterhout–Martin a été lu.
- **Livre *Refactoring*** (Fowler 1999 ou 2018) : non ouvert. La règle de trois n'a été lue que dans une reproduction secondaire.
- **Colfer et Baldwin 2016, texte intégral** : Harvard DASH a répondu 429. Les pourcentages par catégorie (industrie, entreprise, projets ouverts) ne sont pas vérifiés ; seuls les résumés 2016 et 2010 ont été lus.
- **Besker, Martini, Bosch 2018 et 2019** et **Martini et Bosch 2015** : résumés seuls lus. Méthode détaillée et taxonomie non vérifiées.
- **Su, Li, Taibi 2024 (Electronics)** : MDPI a répondu 403. Le chiffre de 32 articles retenus est non vérifié ; seul le préprint 2023 a été lu.
- **Lieu de publication de Tornhill et Borg 2022** : seul le préprint arXiv a été lu.
- **Résultat propre à SpeculativeGenerality dans Khomh et al. 2012** : le rapport technique 2009 a été ouvert, mais l'effet par antipattern n'a pas pu être extrait de façon fiable de ses tableaux.
- **Chiffre de Kohavi et al.** (« only ⅓ » des fonctionnalités améliorent leurs métriques), cité par Fowler : source non ouverte.
- **Lehman 1980** : lu dans une copie OCR (gwern.net), la notice IEEE n'a pas été ouverte. Les systèmes observés (par exemple OS/360) ne sont pas vérifiés dans le texte lu.
- **Une preuve empirique contrôlée du coût de l'abstraction prématurée** : aucune trouvée. Seule une corrélation N2 indirecte (Palomba et al. 2018) l'a été.
- **Une étude sur le choix d'architecture d'un développeur seul ou d'une équipe d'une personne** : aucune trouvée. Toutes les preuves sur Conway, le mirroring et DORA portent sur des organisations.
- **Incohérence interne du rapport Stripe** : « six different countries » en introduction, cinq pays listés dans la méthodologie. Non résolue.

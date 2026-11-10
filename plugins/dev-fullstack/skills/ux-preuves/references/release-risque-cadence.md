# Fiche `ux-preuves` — Mise en production — risque d'une livraison et cadence

> Fiche du skill `ux-preuves` (dev-fullstack), volet **mise en production**, préchargé par `release`. Couvre : mesures DORA et effet de l'IA sur la stabilité, petits lots, part des incidents dus aux changements, approbation des changements, gels et moments à risque, liste de contrôle avant mise en production.
> **Instantané de la recherche documentaire du 10.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Études (souvent des prépublications pour les LLM), docs d'outils
> et pratiques d'entreprise **vieillissent** : avant d'en faire dépendre une règle,
> relire la source (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles de l'agent », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

**Méthode.** Recherche menée le 10 novembre 2026. Chaque entrée repose sur une page réellement ouverte : pages HTML lues avec WebFetch (dora.dev, sre.google, builder.aws.com, vercel.com, charity.wtf, increment.com, dl.gi.de), ou PDF téléchargés avec curl puis convertis avec `pdftotext` et lus dans le texte (rapport DORA 2024, rapport State of DevOps 2019, Kamei et al. 2013, Ghosh et al. 2022, Sadowski et al. 2018, Eyolfson et al. 2011, page « Change Management » du handbook GitLab). Pour les pages lues par WebFetch, les extraits viennent de l'outil de lecture, qui les donne pour verbatim et limite les citations à environ 125 caractères. Les extraits tirés des PDF ont été relus par moi dans le texte brut. Niveaux de preuve : les rapports DORA sont des enquêtes annuelles par questionnaire auto-déclaré, à grand échantillon, analysées statistiquement, mais non revues par des pairs et corrélationnelles. Je les classe **N2 avec réserve** quand l'échantillon est cité. Les pages « capabilities » de dora.dev sont des guides d'une institution (**N3**). Le livre et le workbook SRE de Google, AWS, GitLab et Vercel décrivent leur propre pratique (**N3**). Les articles revus par des pairs (TSE, SoCC, ICSE, MSR) sont classés **N2**. Les blogs d'experts sont classés **N4**. Ce qui n'a pas pu être ouvert est listé dans « Non vérifié ». Ne sont pas couverts ici, parce que traités ailleurs : signaux dorés, SLO et budget d'erreur, post-mortem, expand/contract, secrets Vercel et durcissement GitHub Actions.

## 1. Les mesures DORA : ce que l'on mesure après un déploiement

### Mesurer l'instabilité d'une livraison avec deux taux : les déploiements qui exigent une intervention immédiate et les déploiements correctifs non planifiés
- Niveau de preuve : N3 (guide officiel de l'institution qui définit les mesures)
- Source : DORA, mis à jour le 5 janvier 2026, « DORA's software delivery performance metrics », https://dora.dev/guides/dora-metrics/
- Extrait lu : « The ratio of deployments that require immediate intervention following a deployment. » (change fail rate) ; « The ratio of deployments that are unplanned but happen as a result of an incident in production. » (deployment rework rate)
- Portée / limites : cinq mesures en tout. Débit : change lead time (« committed to version control to deployed in production »), deployment frequency, failed deployment recovery time. Instabilité : change fail rate et deployment rework rate. Ce sont des mesures d'équipe dans la durée. Elles ne servent pas à noter un déploiement isolé.
- En release : après chaque mise en production, consigner si le déploiement a exigé une intervention (rollback, correctif urgent). Sans ce journal, le taux d'échec d'un projet solo reste inconnu.

### Le rework rate date de 2024, le « MTTR » est devenu « failed deployment recovery time » en 2023 : ne pas citer d'anciennes définitions
- Niveau de preuve : N3
- Source : Nathen Harvey (DORA), 2 janvier 2026, « A history of DORA's software delivery metrics », https://dora.dev/guides/dora-metrics/history/
- Extrait lu : « To test this, they introduced a fifth metric: deployment rework rate. » ; définition : « Percentage of deployments that are unplanned work to fix bugs. »
- Portée / limites : la page date l'ajout du rework rate à 2024. Le changement de nom du MTTR est daté de 2023 (« was renamed and redefined as failed deployment recovery time »). L'extension de la notion de disponibilité à la fiabilité est datée de 2021. Depuis 2024, les mesures sont réparties en deux facteurs : « Software Delivery Throughput » et « Software Delivery Instability ».
- En release : on mesure le temps de rétablissement après un **déploiement raté**, pas après n'importe quelle panne. Le rapport d'incident doit dire si l'incident suit un déploiement.

### Un correctif poussé en urgence pour un bug visible des utilisateurs compte comme un déploiement de reprise (rework)
- Niveau de preuve : N2 avec réserve (enquête DORA 2024, près de 3 000 répondants, auto-déclaratif)
- Source : DORA (Google Cloud), 2024, « Accelerate State of DevOps Report 2024 » (v. 2024.3), https://services.google.com/fh/files/misc/2024_final_dora_report.pdf (p. 11)
- Extrait lu : « approximately how many deployments in the last six months were not planned but were performed to address a user-facing bug in the application? » ; « Together, these two metrics create a reliable factor of software delivery stability. »
- Portée / limites : c'est la question posée aux répondants. L’échantillon est décrit dans la section méthodologique : « This year, nearly 3,000 working professionals ». Le rapport définit l'échec de changement ainsi : un problème survenu « after landing in production ».
- En release : quand un hotfix suit un déploiement, le déploiement d'origine est un échec. On compte les deux.

### Vitesse et stabilité vont ensemble chez la plupart des équipes, mais pas mécaniquement
- Niveau de preuve : N3 (synthèse de l'institution) et N2 avec réserve (rapport 2024)
- Source : DORA, 2026, https://dora.dev/guides/dora-metrics/ ; DORA, 2024, rapport cité ci-dessus (p. 13-14)
- Extrait lu : « DORA's research has repeatedly demonstrated that speed and stability are not tradeoffs. » (dora.dev) ; dans le rapport 2024, le groupe « Medium » affiche un change fail rate de « 10% » contre « 20% » pour le groupe « High ». Les auteurs écrivent : « The medium performance cluster, for example, may benefit from shipping changes more frequently. »
- Portée / limites : en 2024, le groupe « high » déploie plus souvent mais échoue deux fois plus que le groupe « medium ». Le rapport note aussi que débit et stabilité montrent « some independence from one another » (p. 39). La corrélation vaut en moyenne et ne garantit rien pour un projet donné.
- En release : déployer plus souvent ne rend pas sûr par soi-même. Ce qui réduit le risque, c'est la taille de chaque changement et la vérification qui l'accompagne.

### En 2024, l'adoption de l'IA est associée à une baisse estimée de la stabilité de livraison
- Niveau de preuve : N2 avec réserve (enquête, estimation statistique avec intervalle d'incertitude de 89 %, corrélationnel)
- Source : DORA, 2024, « Accelerate State of DevOps Report 2024 », https://services.google.com/fh/files/misc/2024_final_dora_report.pdf (p. 39-40)
- Extrait lu : « an estimated 1.5% reduction for every 25% increase in AI adoption » (débit) ; « an estimated 7.2% reduction for every 25% increase in AI adoption » (stabilité)
- Portée / limites : il s'agit d'une association, pas d'une cause démontrée. L'explication avancée est une hypothèse des auteurs : « it is possible, even likely, that changelists are growing in size. DORA has consistently shown that larger changes are slower and more prone to creating instability. »
- En release : quand le code d'un déploiement a été généré en grande partie par une IA, vérifier d'abord la taille du diff et le nombre de fichiers touchés.

### En 2025, l'IA est associée à un meilleur débit, mais toujours à moins de stabilité : sans garde-fous, plus de changements donnent plus d'instabilité
- Niveau de preuve : N2 avec réserve (près de 5 000 répondants et plus de 100 heures de données qualitatives). J'ai lu l'annonce officielle, pas le PDF complet du rapport.
- Source : Nathen Harvey et Derek DeBellis, 23 septembre 2025, « Announcing the 2025 DORA Report: State of AI-Assisted Software Development », https://cloud.google.com/blog/products/ai-machine-learning/announcing-the-2025-dora-report
- Extrait lu : « However, AI adoption does continue to have a negative relationship with software delivery stability. » ; « Without robust control systems, like strong automated testing, mature version control practices, and fast feedback loops, an increase in change volume leads to instability. »
- Portée / limites : le titre du rapport 2025 est bien « State of AI-assisted Software Development ». L'annonce ne donne pas de chiffre sur la stabilité. Sa thèse : « AI doesn't fix a team; it amplifies what's already there. »
- En release : plus le volume de changements par déploiement augmente, plus la batterie automatique (tests, build, typage) doit être exigeante. Elle ne doit jamais devenir facultative.

## 2. Petits lots

### Un lot qui prend plus d'une semaine à terminer et à vérifier est trop gros ; ne pas générer de PR massives avec l'IA
- Niveau de preuve : N3
- Source : DORA, « Capabilities: Working in small batches », https://dora.dev/capabilities/working-in-small-batches/
- Extrait lu : « Any batch of code that takes longer than a week to complete and check is too big. » ; « Avoid the temptation to generate massive pull requests. »
- Portée / limites : l'argument principal porte sur la rapidité du retour (« It reduces the time it takes to get feedback on changes, making it easier to triage and remediate problems. »). La page ne chiffre pas de réduction du risque par déploiement. Elle présente les petits lots comme une parade à l'instabilité liée à l'IA (« a critical countermeasure to this risk »). Autre piège cité : regrouper de petits lots avant de les tester ou de les livrer.
- En release : chercher les changements terminés depuis longtemps qui attendent d'être livrés ensemble. Ce regroupement est justement le piège que décrit la page.

### La taille et la dispersion d'un changement prédisent le risque de défaut ; le nombre de fichiers touchés est le meilleur indicateur
- Niveau de preuve : N2 (IEEE TSE, 6 projets open source et 5 projets commerciaux, plus de 250 000 changements)
- Source : Yasutaka Kamei, Emad Shihab, Bram Adams, Ahmed E. Hassan, Audris Mockus, Anand Sinha, Naoyasu Ubayashi, 2013, « A Large-Scale Empirical Study of Just-in-Time Quality Assurance », IEEE TSE 39(6), https://sail.cs.queensu.ca/data/pdfs/TSE_ALarge-ScaleEmpiricalStudyOfJust-in-TimeQualityAssurance.pdf
- Extrait lu : « for the open source projects, the number of files (NF), the relative churn metrics (LA/LT and LT/NF), and whether or not the change was to fix a defect (FIX) are the most important, risk-increasing factors. »
- Portée / limites : l'unité est le changement (commit), pas le déploiement. Le modèle prédit avec « an average accuracy of 68 percent and an average recall of 64 percent ». Dans les modèles qui tiennent compte de l'effort de revue, les facteurs de taille deviennent « risk decreasing » pour les projets commerciaux : un gros changement contient plus de défauts en tout, mais pas forcément plus par ligne relue. L'article ne mesure pas le nombre de commits par livraison.
- En release : compter les fichiers touchés et les sous-systèmes traversés. Ce critère est mieux fondé qu'un seuil en nombre de commits.

### Un changement qui corrige un bug est lui-même plus risqué : le hotfix mérite autant de vérification qu'une fonctionnalité
- Niveau de preuve : N2
- Source : Kamei et al., 2013, même URL
- Extrait lu : « A change that fixes a defect is more likely to introduce a new defect » (dimension « Purpose ») ; FIX figure parmi les facteurs « risk-increasing » des projets open source.
- Portée / limites : le résultat est net pour les projets open source. Pour les projets commerciaux, l'article retient surtout la dispersion et le volume de modifications.
- En release : se méfier du correctif poussé en urgence sans vérification préalable. C'est un profil de changement plus risqué que la moyenne.

### De petits changements sont mieux relus : la qualité de la revue baisse quand la taille augmente
- Niveau de preuve : N2 (ICSE-SEIP 2018 ; journaux de revue de 9 millions de changements, 12 entretiens, sondage de 44 répondants)
- Source : Caitlin Sadowski, Emma Söderberg, Luke Church, Michal Sipko, Alberto Bacchelli, 2018, « Modern Code Review: A Case Study at Google », https://storage.googleapis.com/gweb-research2023-media/pubtools/4476.pdf (page de la publication : https://research.google/pubs/modern-code-review-a-case-study-at-google/)
- Extrait lu : « the median number of lines modified is 24 » ; « Previous studies have found that the number of useful comments decreases [11, 14] and the review latency increases [8, 24] as the size of the change increases. »
- Portée / limites : la baisse de qualité de revue vient d'études antérieures citées par les auteurs. L'article décrit la pratique Google sans la relier aux incidents.
- En release : un diff de plusieurs centaines de lignes n'a probablement pas été relu au même niveau qu'un petit. C'est à signaler.

### Des artefacts petits et autonomes coûtent moins cher à annuler
- Niveau de preuve : N3 (Google, sur sa propre pratique)
- Source : Alec Warner et Štěpán Davidovič (avec Alex Hidalgo, Betsy Beyer, Kyle Smith, Matt Duftler), « Canarying Releases », The Site Reliability Workbook, ch. 16, https://sre.google/workbook/canarying-releases/
- Extrait lu : « Build artifacts should contain small, self-contained changes. » ; « Smaller, self-contained release artifacts make it cheaper and easier to roll back. »
- Portée / limites : ce sont des principes, sans mesure chiffrée. Les autres principes listés sont les builds reproductibles, les builds, tests et déploiements automatisés (« Deployments should be performed by computers, not humans. »).
- En release : demander si on peut annuler ce déploiement sans perdre une autre correction livrée avec lui. Si la réponse est non, le lot mélange des choses à séparer.

### Intégrer au tronc au moins une fois par jour, garder peu de branches, ne pas geler le code
- Niveau de preuve : N3 (guide de l'institution, qui s'appuie sur ses données de 2016 et 2017)
- Source : DORA, « Capabilities: Trunk-based development », https://dora.dev/capabilities/trunk-based-development/
- Extrait lu : « Merge branches to trunk at least once a day. » ; « Have three or fewer active branches in the application's code repository. » ; « Don't have code freezes and don't have integration phases. »
- Portée / limites : il s'agit de gel du **code** (personne ne peut soumettre), pas de gel du **déploiement**. Pousser sur le tronc fait partie de la pratique recommandée. Ce qui fait la différence, c'est le contrôle automatique à chaque commit (voir la section 6).
- En release : une branche de fonctionnalité vieille de plusieurs semaines, fusionnée juste avant un déploiement, mérite un finding.

## 3. Changements et pannes

### Chez Google, environ 70 % des pannes viennent d'un changement apporté à un système en production
- Niveau de preuve : N3 (estimation interne, méthode non décrite)
- Source : Benjamin Treynor Sloss, « Introduction », Site Reliability Engineering (Google), section « Change Management », https://sre.google/sre-book/introduction/
- Extrait lu : « SRE has found that roughly 70% of outages are due to changes in a live system. »
- Portée / limites : ni l'échantillon, ni la période, ni la définition de « change » ne sont donnés. Le chiffre décrit Google et non le secteur. Il est suivi des pratiques recommandées : « Implementing progressive rollouts », « Quickly and accurately detecting problems », « Rolling back changes safely when problems arise ».
- En release : devant un incident, la première hypothèse à tester est le dernier changement (code, configuration, variables, dépendances), avec sa date et son heure.

### La majorité des incidents est déclenchée par la mise en production d'un binaire ou d'une configuration
- Niveau de preuve : N3
- Source : Warner, Davidovič et al., « Canarying Releases », SRE Workbook ch. 16, https://sre.google/workbook/canarying-releases/
- Extrait lu : « In Google's experience, a majority of incidents are triggered by binary or configuration pushes. »
- Portée / limites : c'est une affirmation qualitative, sans chiffre. La configuration y compte autant que le code.
- En release : un changement de variable d'environnement, de configuration Vercel ou de `ecosystem.config.js` (PM2) est un déploiement. Il passe par la même vérification.

### Sur 152 incidents graves d'un grand service cloud, 40 % viennent du code ou de la configuration, 60 % d'autres causes (infrastructure, erreurs de déploiement, dépendances)
- Niveau de preuve : N2 (SoCC 2022, prix du meilleur article selon le résumé de recherche ; 152 incidents de sévérité élevée avec post-mortem complet, Microsoft Teams)
- Source : Supriyo Ghosh, Manish Shetty, Chetan Bansal, Suman Nath, 2022, « How to Fight Production Incidents? An Empirical Study on a Large-scale Cloud Service », SoCC '22, https://www.microsoft.com/en-us/research/wp-content/uploads/2022/09/3542929.3563482.pdf
- Extrait lu : « Code Bug - 27.0 % / Dependency Failure - 16.4 % / Infrastructure - 15.8 % / Deployment Error - 13.2 % / Config Bug - 12.5 % / Database/Network - 10.5 % / Auth Failure - 4.6 % » ; « Finding#1: While 40% incidents were root caused to code or configuration bugs, a majority (60%) were caused due to non-code related issues in infrastructure, deployment, and service dependencies. »
- Portée / limites : un seul service étudié. Les auteurs ont écarté « about 35% of recent high severity incidents that did not have a complete postmortem report ». Les erreurs de déploiement sont réparties en « Certificate management (55.0%) », « Faulty deployment & patching (25.0%) » et « Human Error (20.0%) ». Parmi les bugs de code, « Backward code compatibility (14.6% of code bugs) ».
- En release : au-delà du code, vérifier les certificats et domaines (dates d'expiration), les versions de dépendances et services tiers (Supabase, API externes) et la compatibilité ascendante (anciens clients, anciennes données).

### Le rollback est le moyen de rétablissement le plus fréquent, et le plus rapide pour les bugs de configuration
- Niveau de preuve : N2
- Source : Ghosh et al., 2022, même URL
- Extrait lu : « Rollback - 22.4 % » (première catégorie de mitigation) ; « Finding#2: Although 40% incidents were caused by code/configuration bugs, nearly 80% of incidents were mitigated without a code or configuration fix. » ; « we observe 47% of configuration bugs mitigated with a rollback, when compared to a lesser 21% mitigated with an actual configuration fix. »
- Portée / limites : les rollbacks se répartissent en annulations de code (35 %), de configuration (24 %) et de build (41 %). Un seul service étudié.
- En release : avant de déployer, savoir vers quelle version revenir et comment. En incident, rétablir d'abord (rollback), corriger ensuite.

### Les changements de base de données sont une source majeure de risque et de retard au déploiement
- Niveau de preuve : N3
- Source : DORA, « Capabilities: Database change management », https://dora.dev/capabilities/database-change-management/
- Extrait lu : « Database changes are often a major source of risk and delay when performing deployments. » ; les équipes performantes « store their database changes as scripts in version control ».
- Portée / limites : la page renvoie au parallel change, traité ailleurs. Elle ne donne pas d'année de recherche.
- En release : une migration Supabase dans le lot change le profil de risque. Elle doit être versionnée, et il faut savoir si un rollback Vercel la défait. Il ne la défait pas (voir l'entrée sur Instant Rollback).

## 4. Approbation des changements

### Une approbation externe lourde (comité, supérieur) n'est pas associée à moins d'échecs et pousse vers de plus gros lots
- Niveau de preuve : N2 avec réserve (enquête 2019, « almost 1,000 respondents », marge d'erreur de 3 % annoncée)
- Source : DORA (Google Cloud), 2019, « Accelerate State of DevOps 2019 », https://services.google.com/fh/files/misc/state-of-devops-2019.pdf (p. 48-50)
- Extrait lu : « Survey respondents were 2.6 times more likely to be low performers if their organization had this kind of formal approval process in place. » ; « we found no evidence to support this hypothesis, consistent with earlier research. » (hypothèse : approbation plus formelle = moins d'échecs) ; « Analysis suggests this approach will make things worse. »
- Portée / limites : la donnée est corrélationnelle. Le mécanisme proposé par le rapport : l'approbation ralentit et conduit à « the release of larger batches less frequently », et les auteurs écrivent : « Our hypothesis was supported in the data. » La page de dora.dev qui en est tirée reprend la même conclusion (https://dora.dev/capabilities/streamlining-change-approval/).
- En release : une étape manuelle de validation ne doit pas devenir une file d'attente qui accumule les commits. L'effet serait l'inverse de celui recherché.

### Remplacer l'approbation externe par la revue par les pairs et l'automatisation
- Niveau de preuve : N2 avec réserve (rapport 2019) et N3 (page de dora.dev)
- Source : DORA, 2019, PDF cité ci-dessus (p. 50) ; DORA, « Capabilities: Streamlining change approval », https://dora.dev/capabilities/streamlining-change-approval/
- Extrait lu : « organizations should "shift left" to peer review-based approval during the development process » ; « automation can be leveraged to detect, prevent, and correct bad changes much earlier in the delivery lifecycle. » (2019) ; « Instead, invest in making it quicker and safer to make changes. » (dora.dev)
- Portée / limites : Google applique la même règle chez lui : « Almost all changes to the codebase require a code review » (Dinah McNutt, « Release Engineering », https://sre.google/sre-book/release-engineering/, N3). Pour un développeur seul, il n'y a pas de pair humain : la relecture par un agent et les contrôles automatiques en tiennent lieu. Aucune étude trouvée ne mesure l'efficacité de ce substitut.
- En release : le contrôle avant déploiement doit être rapide, automatisé et répétable, à la manière d'une relecture. Il ne doit pas fonctionner comme un guichet.

## 5. Gel des déploiements et moments à risque

### Dans l'historique d'Eclipse, les changements qui ont dû être corrigés ensuite sont les plus fréquents le vendredi
- Niveau de preuve : N2 (résumé seul lu ; version courte dans Softwaretechnik-Trends 25(2), 2005, issue de MSR 2005)
- Source : Jacek Śliwerski, Thomas Zimmermann, Andreas Zeller, 2005, « Don't Program on Fridays! How to Locate Fix-Inducing Changes », https://dl.gi.de/items/0335dea3-78ba-4bce-8bc1-e353c66448fd/full
- Extrait lu : « In a first investigation of the ECLIPSE history, it turns out that fix-inducing changes are most frequent on Fridays. »
- Portée / limites : il s'agit de commits et non de déploiements, sur un seul projet open source, et présenté comme « a first investigation ». L'article complet n'a pas pu être téléchargé (connexion refusée par le serveur de Sarrebruck).
- En release : le jour du commit compte moins que la question de savoir qui l'a relu, et quand.

### Une étude ultérieure ne retrouve pas d'effet vendredi net ; elle trouve en revanche que les commits faits la nuit sont plus bogués
- Niveau de preuve : N2 (MSR 2011 ; Linux, 222 332 commits ; PostgreSQL, 31 098 commits)
- Source : Jon Eyolfson, Lin Tan, Patrick Lam, 2011, « Do Time of Day and Developer Experience Affect Commit Bugginess? », https://www.cs.purdue.edu/homes/lintan/publications/commitTime-msr11.pdf
- Extrait lu : « commits submitted between midnight and 4 AM (referred to as late-night commits) are significantly buggier and commits between 7 AM and noon are less buggy » ; « In contrast to a prior finding that Friday commits are buggier [19], our results on the Linux kernel and PostgreSQL show that the bugginess differences of commits that are checked in on different days of week are small. »
- Portée / limites : deux projets open source seulement. Les auteurs concluent que l'effet du jour de la semaine « varies for different software projects ». L'unité reste le commit, pas le déploiement.
- En release : le code écrit tard dans la nuit justifie une relecture renforcée avant d'être déployé. L'heure du commit est visible dans `git log`.

### AWS limite les déploiements automatiques aux heures où l'astreinte peut réagir vite ; certaines équipes excluent aussi le vendredi et la fin d'après-midi
- Niveau de preuve : N3 (AWS, sur sa propre pratique)
- Source : Clare Liguori, 18 juin 2020, « Automating safe, hands-off deployments », Amazon Builders' Library, https://builder.aws.com/content/3ErTKQOTKc5NIw031UePBPxTQ6I/automating-safe-hands-off-deployments
- Extrait lu : « The pipeline is also configured with a set of time windows that define when a deployment is allowed to start. » ; « Oncall engineers typically take longer to engage at night, on office holidays, and on weekends. » ; certaines équipes « exclude Fridays and late-afternoon deployments ».
- Portée / limites : le motif donné est la **disponibilité de celui qui doit réagir**, pas une fragilité propre au vendredi : « During regular business hours the team can be more quickly engaged after a failed deployment ». Le même article décrit un étage « one-box » qui reçoit au plus « ten percent of overall requests », un temps d'observation (« bake time ») et un rollback automatique sur alarme.
- En release : pour un développeur seul, demander s'il sera disponible et joignable pendant les heures qui suivent. Si ce n'est pas le cas, reporter le déploiement, quel que soit le jour.

### GitLab gèle les changements en production pendant les fêtes de fin d'année, parce que l'équipe est moins disponible
- Niveau de preuve : N3 (GitLab, sur sa propre pratique)
- Source : GitLab, « Change Management », The GitLab Handbook, https://handbook.gitlab.com/handbook/engineering/infrastructure-platforms/change-management/
- Extrait lu : « it is a good practice to temporarily halt production changes during certain events such as GitLab Summit, major global holidays, and other times where GitLab Team Member availability is substantially reduced. » ; « Advisory Change Control: Usually used when we have critical time periods in the year like near the end of November and December. » ; « teams are asked to defer large or risky changes. »
- Portée / limites : il existe trois niveaux de gel. En « Soft PCL », les déploiements avec migrations post-déploiement sont bloqués (« emergency only »). En « Hard PCL », tous les déploiements sont bloqués. Le handbook précise : « We do not create Hard PCLs for reasons other than low team-member coverage or periods of significant instability of our platforms. » Les déploiements applicatifs sont exclus du processus de changement ordinaire de GitLab.
- En release : avant des congés ou un pic d'activité connu (fin novembre et décembre pour du commerce en ligne), différer les changements gros ou risqués, surtout les migrations, et garder les petits correctifs.

### Le plus ancien gabarit de lancement de Google signalait déjà les échéances, les événements externes, les lundis et les vendredis
- Niveau de preuve : N3
- Source : Google SRE, « Launch Coordination Checklist » (annexe), https://sre.google/sre-book/launch-checklist/
- Extrait lu : « This is Google's original Launch Coordination Checklist, circa 2005, slightly abridged for brevity: » ; rubrique « Schedule and rollout planning » : « Hard deadlines, external events, Mondays or Fridays »
- Portée / limites : c'est une liste de points d'attention, sans données ni règle d'interdiction.
- En release : le calendrier (veille de week-end, lancement annoncé, campagne) fait partie de la liste de vérification. Ce n'est pas un interdit automatique.

### L'argument contre le gel du vendredi : la peur de déployer est la vraie dette ; si l'on gèle, on gèle les fusions, pas les déploiements
- Niveau de preuve : N4 (avis d'expert)
- Source : Charity Majors, 1er mai 2019, « Friday Deploy Freezes Are Exactly Like Murdering Puppies », https://charity.wtf/2019/05/01/friday-deploy-freezes-are-exactly-like-murdering-puppies
- Extrait lu : « Fear of deploys is the ultimate technical debt. » ; « Smaller, coherent changesets transform into debuggable, understandable deploys. » ; « Stop shipping blind. Actually LOOK at what you ship. »
- Portée / limites : c'est une opinion. La nuance « freeze merges » vient de la page de tag de son blog, que je n'ai vue qu'à travers les résultats de recherche (voir « Non vérifié »). Un gel du déploiement laisse les changements s'accumuler et produit le gros lot du lundi.
- En release : après un gel, le premier déploiement est souvent le plus gros. Le découper.

## 6. Liste de contrôle avant et après mise en production

### Tout changement visible de l'extérieur est un lancement, et la liste de lancement couvre plus que le code
- Niveau de preuve : N3
- Source : Google SRE, « Reliable Product Launches at Scale », ch. 27, https://sre.google/sre-book/reliable-product-launches/
- Extrait lu : un lancement est « any new code that introduces an externally visible change to an application. » ; Google effectue parfois « up to 70 launches per week. » ; exemples de questions : « Do you have any single points of failure in your design? », « Are there any manual processes required to keep the service running? »
- Portée / limites : les rubriques sont Architecture and Dependencies, Integration, Capacity Planning, Failure Modes, Client Behavior, Processes and Automation, Development Process, External Dependencies, Rollout Planning. Le rôle de Launch Coordination Engineering suppose une équipe dédiée. Pour un projet solo, garder les questions et laisser de côté le rôle.
- En release : pour un projet seul, retenir dépendances externes (Supabase, API), comportement des clients (cache, ancienne version du front), procédures manuelles et plan de déploiement progressif.

### Le canary est un déploiement partiel et limité dans le temps, suivi de son évaluation ; une comparaison avant/après est fragile
- Niveau de preuve : N3
- Source : Warner, Davidovič et al., « Canarying Releases », SRE Workbook ch. 16, https://sre.google/workbook/canarying-releases/
- Extrait lu : « We define canarying as a partial and time-limited deployment of a change in a service and its evaluation. » ; « it is difficult to assess degradation of performance with before/after evaluation. » ; « we serve 20% errors for 5% of traffic, resulting in a 1% overall error rate. »
- Portée / limites : pensé pour de gros volumes de trafic. Sur une application à faible trafic, un canary à 5 % ne produit presque aucun signal.
- En release : après le déploiement, comparer des signaux séparés par version (identifiant de déploiement) plutôt qu'une courbe globale. Un taux d'erreur global peut cacher une version cassée.

### Les tests réduisent l'incertitude de chaque changement ; un canary n'est pas un test mais une acceptation structurée par les utilisateurs
- Niveau de preuve : N3
- Source : Alex Perry et Max Luebbe, « Testing for Reliability », Site Reliability Engineering ch. 17, https://sre.google/sre-book/testing-reliability/
- Extrait lu : « As the percentage of your codebase covered by tests increases, you reduce uncertainty and the potential decrease in reliability from each change. » ; « Passing a test or a series of tests doesn't necessarily prove reliability. However, tests that are failing generally prove the absence of reliability. » ; « A canary test isn't really a test; rather, it's structured user acceptance. »
- Portée / limites : le chapitre parle aussi de tests en production (« Production tests interact with a live production system ») et de tests de configuration. Il ne rejette donc pas toute vérification en production.
- En release : un test rouge bloque le déploiement. Un test vert ne dispense pas de vérifier après le déploiement.

### Chaque commit déclenche build et tests en quelques minutes ; un build cassé se répare immédiatement
- Niveau de preuve : N3
- Source : DORA, « Capabilities: Continuous integration », https://dora.dev/capabilities/continuous-integration/ ; DORA, « Capabilities: Test automation », https://dora.dev/capabilities/test-automation/
- Extrait lu : « Each commit should trigger a series of automated tests that provide feedback in a few minutes. » ; « the team stops what they are doing to fix the problem immediately. » ; « Keep the test suite fast. » ; « test failures should indicate a real defect. »
- Portée / limites : la limite haute indiquée est « about 10 minutes ». Les tests instables ne doivent pas être tolérés. Le lint n'est mentionné dans aucune des deux pages.
- En release : un test instable qu'on relance jusqu'à ce qu'il passe est un finding. Il entraîne à ignorer les vrais échecs.

### Automatiser le déploiement, migrations comprises, avec un test de fumée, et compter les étapes manuelles
- Niveau de preuve : N3
- Source : DORA, « Capabilities: Deployment automation », https://dora.dev/capabilities/deployment-automation/
- Extrait lu : « perform a deployment test (sometimes known as a smoke test) » ; « Perform any deployment-related tasks such as running database migration scripts. » ; « The number of manual steps increases the deployment time as well as the opportunity for error. »
- Portée / limites : la page ne traite pas du rollback. Pour l'auto-hébergement (NAS, PM2, Docker), c'est elle qui s'applique le plus directement. Sur Vercel, l'essentiel est déjà automatisé par la plateforme.
- En release : lister les étapes manuelles du déploiement auto-hébergé (`pm2 reload`, `docker compose pull`, migration lancée à la main). Chacune est une source d'erreur à scripter.

### Sur Vercel, un Instant Rollback revient au build précédent sans toucher aux variables d'environnement, et coupe la promotion automatique
- Niveau de preuve : N3 (documentation de l'éditeur sur sa plateforme, mise à jour le 7 juillet 2026)
- Source : Vercel, « Performing an Instant Rollback on a Deployment », https://vercel.com/docs/instant-rollback
- Extrait lu : « Vercel won't update environment variables if you change them in the project settings and will roll back to a previous build » ; « After a rollback, Vercel turns off auto-assignment of production domains. » ; « Hobby users can roll back to the immediately previous deployment. »
- Portée / limites : la boîte de dialogue rappelle « the changing behavior of external APIs, databases, and CMSes ». Un rollback de code ne défait donc ni une migration Supabase ni un changement de variable. Pour repasser en promotion automatique, il faut promouvoir un déploiement (`vercel promote`).
- En release : le critère de rollback se décide avant le déploiement, avec la version cible connue (une seule possible sur le plan Hobby). Après un rollback, penser à rétablir la promotion automatique, sinon les pushes suivants n'iront plus en production.

### Sur Vercel Pro ou Enterprise, le Rolling Release envoie une fraction du trafic à la nouvelle version, à comparer avant de promouvoir
- Niveau de preuve : N3 (documentation de l'éditeur, mise à jour le 15 septembre 2026)
- Source : Vercel, « Rolling Releases », https://vercel.com/docs/rolling-releases
- Extrait lu : « Rolling Releases are available on Enterprise and Pro plans » ; « Vercel directs a configurable fraction of your visitors, for example, 5%, to the new deployment. » ; « We highly recommend enabling Skew Protection with Rolling Releases. »
- Portée / limites : sur le plan Pro, la fonction est limitée à un seul projet. Le découpage en pourcentage est approximatif quand il y a peu de sessions (« especially when the number of sessions is small »).
- En release : sur une application à faible trafic, le rolling release donne peu de signal statistique. Une vérification manuelle des parcours critiques sur la version promue reste nécessaire.

### Tester avant ET en production : les deux ne s'opposent pas
- Niveau de preuve : N4 (avis d'expert)
- Source : Charity Majors, août 2019, « I test in prod », Increment n° 10, https://increment.com/testing/i-test-in-production/
- Extrait lu : « Yes, you should test before and in prod. »
- Portée / limites : c'est une opinion, qui suppose une instrumentation (observabilité) que beaucoup de petits projets n'ont pas.
- En release : « on testera en prod » est inacceptable s'il remplace les tests préalables. En revanche, une vérification en production après déploiement (smoke test, logs, erreurs Vercel) fait partie du déploiement.

## Verdict sur les règles de l'agent

| Règle | Verdict | Motif sourcé |
|---|---|---|
| « Le déploiement le plus sûr est petit : plusieurs petits déploiements valent un gros. Un déploiement qui accumule 15 commits hétérogènes est un finding du pre-deploy check. » | **Soutenue sur le principe ; seuil de 15 = convention sans preuve trouvée** | DORA 2024 : « larger changes are slower and more prone to creating instability » ; SRE Workbook : « Smaller, self-contained release artifacts make it cheaper and easier to roll back » ; Kamei 2013 : le nombre de fichiers et le volume relatif de modifications augmentent le risque. Aucune source ne mesure un seuil en nombre de commits. Le critère le mieux fondé est l'**hétérogénéité** (fichiers et sous-systèmes touchés, mélange de fonctionnalité, migration et correctif). Reformulation proposée : « un déploiement qui mélange plusieurs sujets indépendants, ou touche beaucoup de fichiers, est un finding ». |
| « Le déploiement n'est pas un push — c'est une séquence de vérifications avant ET après. » | **Soutenue** | SRE : environ 70 % des pannes viennent de changements (chiffre propre à Google), avec détection rapide et rollback sûr comme pratiques. AWS : temps d'observation (bake time) et rollback automatique sur alarme. Workbook : le canary est « a partial and time-limited deployment of a change in a service and its evaluation ». Ghosh 2022 : rollback = 22,4 % des mitigations. |
| « Push direct sur main sans pre-deploy check » (anti-pattern) | **Soutenue, à préciser** | Le push sur le tronc n'est pas un anti-pattern en soi : DORA recommande « Merge branches to trunk at least once a day », et certaines équipes Google font du « Push on Green ». L'anti-pattern, c'est le push **sans contrôle automatique** (« Each commit should trigger a series of automated tests », DORA CI). |
| « Mode A obligatoire avant tout déploiement prod » | **À préciser** | Une vérification systématique est soutenue si elle est rapide et automatisée (DORA : peer review et automatisation). Si elle devient une validation manuelle lourde qui retarde et regroupe les livraisons, DORA 2019 montre que l'approbation lourde n'est pas associée à moins d'échecs (« we found no evidence ») et conduit à des lots plus gros (« larger batches less frequently »). Proportionner le Mode A au risque du lot, et ne jamais le laisser accumuler des commits. |
| « Pre-deploy : build, type check, lint, tests, vars d'env, migrations, secrets, breaking changes, critères de rollback. » | **Soutenue pour l'essentiel ; lint = convention sans preuve trouvée ; liste incomplète** | Build et tests : DORA CI et test automation. Migrations : « a major source of risk » (DORA). Variables, configuration et secrets : erreurs de configuration à 12,5 % et de déploiement à 13,2 % des incidents (Ghosh), Vercel ne revient pas en arrière sur les variables lors d'un rollback. Breaking changes : la compatibilité ascendante représente 14,6 % des bugs de code (Ghosh). Critères de rollback : rollback = mitigation la plus fréquente (Ghosh). **Lint** : aucune source trouvée qui le relie aux incidents. **À ajouter** : certificats et domaines (55 % des erreurs de déploiement chez Ghosh), dépendances et services tiers (16,4 %), disponibilité de l'opérateur après le déploiement (AWS, GitLab), hétérogénéité du lot, et l'étape **après** déploiement (smoke test, erreurs par version). |
| « On testera en prod — non. » | **À préciser** | Soutenue si la phrase veut dire « pas *au lieu* des tests préalables » : « tests that are failing generally prove the absence of reliability » (SRE). Contredite si elle exclut toute vérification en production : le SRE book décrit des « production tests » et le canary comme « structured user acceptance », et Majors écrit « you should test before and in prod ». Reformulation proposée : « on ne teste pas *seulement* en prod ; on vérifie *aussi* en prod ». |

## Mythes et affirmations contestées

- **« Vitesse et stabilité s'opposent. »** Contredit en moyenne par DORA (« speed and stability are not tradeoffs »). Le rapport 2024 nuance pourtant : le groupe « high » échoue à 20 % contre 10 % pour le groupe « medium », et débit et stabilité montrent « some independence ». Ni « aller vite rend sûr » ni « ralentir rend sûr » ne sont démontrés. Ce qui est soutenu, c'est la taille réduite des changements et l'automatisation.
- **« Ne jamais déployer le vendredi. »** Les données sont faibles et contradictoires. Śliwerski et al. (Eclipse, 2005, commits) trouvent plus de changements à corriger le vendredi. Eyolfson et al. (Linux et PostgreSQL, 2011) trouvent des écarts « small » selon les jours, mais un vrai effet des commits faits la nuit. Aucune étude revue par des pairs trouvée sur l'échec des **déploiements** par jour de la semaine. Les guides d'entreprise (AWS, GitLab) motivent leurs fenêtres par la **disponibilité de l'équipe**, pas par le jour. Pour un développeur seul, la bonne règle : ne pas déployer quand on ne pourra pas surveiller et revenir en arrière dans les heures qui suivent.
- **« 70 % des pannes sont causées par des changements » comme statistique universelle.** C'est une estimation interne de Google, sans méthode publiée. Chez Microsoft Teams, Ghosh et al. trouvent 40 % de bugs de code ou de configuration et 60 % d'autres causes, dont une partie sont pourtant des changements (erreurs de déploiement, changements de configuration chez un partenaire). Citer le chiffre comme ordre de grandeur Google, pas comme constante.
- **« Un comité d'approbation rend les livraisons plus sûres. »** Contredit par DORA 2019 (pas de preuve d'une baisse des échecs, et 2,6 fois plus de chances d'être parmi les moins performants).
- **« L'IA rend plus productif, donc les livraisons sont plus sûres. »** Contredit : DORA 2024 estime -7,2 % de stabilité pour +25 % d'adoption, et en 2025 la relation avec la stabilité reste négative. Le lien causal n'est pas démontré, l'hypothèse avancée étant celle de changements plus gros.
- **Statistiques d'éditeurs sur le vendredi** (un pic de 21 % des incidents critiques attribué à PagerDuty, 20 % d'échecs en plus pour les fusions du vendredi attribués à GitHub) : je les ai vues seulement en résultat de recherche, sur un site tiers. Rapports d'origine non trouvés. À ne pas citer.
- **Gunawi et al. 2016 (« Why Does the Cloud Stop Computing? »)** : des pourcentages circulent sur les causes (par exemple un billet qui parle d'une « majority » de pannes dues aux mises à jour, chiffrée à 16 %, ce qui est incohérent). Le texte de l'article n'a pas pu être lu. À ne pas citer en chiffres.

## Non vérifié

- **Gunawi et al., 2016, SoCC, « Why Does the Cloud Stop Computing? Lessons from Hundreds of Service Outages »** : seules les métadonnées sont confirmées (auteurs, titre, SoCC 2016, DOI 10.1145/2987550.2987583, via l'API Semantic Scholar, résumé masqué par l'éditeur). La copie PDF de l'Iowa State a échoué (chaîne TLS incomplète avec curl, HTTP 503 avec WebFetch). L'hôte `ucare.cs.uchicago.edu` n'est pas autorisé dans le réseau de la session et devra être autorisé pour lire l'article. ACM a renvoyé une erreur 403. Aucun chiffre de cet article n'est repris ici.
- **Forsgren, Humble, Kim, 2018, « Accelerate »** (N4) : livre non ouvert. Aucune affirmation n'en est tirée directement. Les constats DORA cités viennent des rapports et des pages dora.dev.
- **Rapport DORA 2025 complet (PDF)** : non lu. Seule l'annonce officielle de Google Cloud a été lue. Pas de chiffre de stabilité 2025.
- **Cindy Sridharan, « Testing in Production, the safe way »** (Medium) : HTTP 403, non lu.
- **Nuance « Don't freeze deploys. Freeze merges. » de Charity Majors** : vue uniquement à travers un résultat de recherche (page de tag charity.wtf et billet de décembre 2025), non ouverte.
- **Article complet de Śliwerski, Zimmermann, Zeller (MSR 2005, « When do changes induce fixes? »)** : téléchargement refusé (connexion réinitialisée). Seul le résumé de la version courte (GI) a été lu.
- **Seuil de « 15 commits »** : aucune source trouvée, ni pour ni contre un seuil en nombre de commits par déploiement.
- **Lien entre lint et incidents de production** : aucune source trouvée.
- **Supabase** : pas de documentation ouverte sur le rollback de migrations. Le point « un rollback Vercel ne défait pas une migration » repose sur la documentation Vercel (variables, API et bases de données externes non concernées par le rollback), pas sur la documentation Supabase.

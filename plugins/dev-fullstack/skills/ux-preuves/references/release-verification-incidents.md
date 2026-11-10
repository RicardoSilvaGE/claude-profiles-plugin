# Fiche `ux-preuves` — Mise en production — vérification après déploiement et incidents

> Fiche du skill `ux-preuves` (dev-fullstack), volet **mise en production**, préchargé par `release`. Couvre : conduite d'un incident hors sécurité, causes et atténuations mesurées, détection et sondes, santé liveness contre readiness, fenêtre d'observation, comparaison à une référence, communication, décision sous fatigue.
> **Instantané de la recherche documentaire du 10.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Études (souvent des prépublications pour les LLM), docs d'outils
> et pratiques d'entreprise **vieillissent** : avant d'en faire dépendre une règle,
> relire la source (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles de l'agent », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

**Méthode.** Recherche menée le 10.11.2026. Chaque entrée repose sur une page **réellement ouverte** : WebFetch, ou téléchargement par curl puis extraction du texte (HTML nettoyé, ou `pdftotext` pour les PDF, rangés dans `recherche-release/pdf4/`). Chaque extrait cité a été **revérifié par grep sur le texte téléchargé**, sauf mention contraire. Hiérarchie des preuves : N1 norme, N2 étude empirique revue par les pairs (échantillon cité), N3 guide officiel d'une organisation sur sa propre pratique ou doc officielle d'un outil, N4 avis d'expert ou résumé secondaire. Quand seul un résumé a été lu, c'est écrit (« résumé seul lu »). Sources inaccessibles : texte complet de Gunawi 2016 (hôte ucare bloqué par le réseau de la session, miroir iastate en erreur TLS puis 503, ACM 403), texte complet de Liu 2019 (ACM et sigops inaccessibles : lu seulement via le résumé d'A. Colyer), billet Netflix sur Kayenta (403), Dawson & Reid 1997 (aucun résumé disponible). Ces points figurent dans « Non vérifié ». Hors périmètre, parce que déjà couvert ailleurs : signaux dorés, alerte sur symptômes, SLO, RED/USE, post-mortem, rétention des logs, NIST 800-61, fuite de secret.

---

## 1. Conduite d'un incident (hors sécurité)

### Déclarer l'incident tôt, sur des critères écrits d'avance, plutôt qu'après une heure d'enquête solitaire
- Niveau de preuve : N3
- Source : Google (Andrew Stribblehill, éd. Beyer et al.), 2016, « Site Reliability Engineering — Chapter 14: Managing Incidents », https://sre.google/sre-book/managing-incidents/
- Extrait lu : « It is better to declare an incident early and then find a simple fix and close out the incident than to have to spin up the incident management framework hours into a burgeoning problem. » ; critères : « Do you need to involve a second team in fixing the problem? Is the outage visible to customers? Is the issue unsolved even after an hour's concentrated analysis? »
- Portée / limites : il s'agit de la pratique interne de Google, avec des équipes nombreuses. Pour une personne seule, le critère « une deuxième équipe » se traduit par « un tiers » (l'hébergeur, Supabase). Le critère « visible des clients » reste le plus discriminant.
- En release : la panne est-elle visible des utilisateurs ? Si oui, c'est un incident, même s'il semble « petit ». Ouvrir le journal sans attendre.

### Atténuer d'abord, chercher la cause racine ensuite
- Niveau de preuve : N3
- Source : Google (éd. Beyer, Murphy, Rensin, Kawahara, Thorne), 2018, « The Site Reliability Workbook — Chapter 9: Incident Response », https://sre.google/workbook/incident-response/
- Extrait lu : « It's important to remember that first responders must prioritize mitigation above all else, or time to resolution suffers. » ; « To mitigate an incident, you don't have to fully understand the details—you only need to know the location of the root cause. » ; « Ultimately, customers do not care whether or not you fully understand what caused an outage. »
- Portée / limites : le livre ne dit pas qu'il faut renoncer à la cause racine. L'atténuation est temporaire.
- En release : existe-t-il une action d'atténuation disponible tout de suite (rollback, feature flag, redémarrage) ? Si oui, l'appliquer avant d'ouvrir le débogueur.

### Prioriser dans l'ordre : arrêter l'hémorragie, rétablir le service, préserver les preuves
- Niveau de preuve : N3
- Source : Google, 2016, « Managing Incidents » (résumé des bonnes pratiques), https://sre.google/sre-book/managing-incidents/
- Extrait lu : « Stop the bleeding, restore service, and preserve the evidence for root-causing. »
- Portée / limites : la préservation des preuves est le pendant de l'atténuation rapide. Un redémarrage ou un rollback peut effacer l'état utile au diagnostic.
- En release : avant un rollback ou un redémarrage (PM2, Docker), avez-vous capturé les logs, l'identifiant du déploiement fautif et l'heure de début ?

### Tenir un journal d'incident en direct, horodaté, même désordonné
- Niveau de preuve : N3
- Source : Google, 2016, « Managing Incidents », https://sre.google/sre-book/managing-incidents/ ; complété par Atlassian, s. d., « Incident response » (Incident Handbook), https://www.atlassian.com/incident-management/handbook/incident-response
- Extrait lu : « The incident commander's most important responsibility is to keep a living incident document. » ; Atlassian : « Make sure to note whether the incident's start time corresponds with a change (for example, a Bamboo deployment) so that the change can be rolled back to potentially resolve the incident. »
- Portée / limites : le journal sert la coordination (équipe) et le post-mortem. Seul, il sert surtout à ne pas perdre le fil sous stress.
- En release : l'heure de début du symptôme coïncide-t-elle avec l'heure d'un déploiement, d'une migration ou d'un changement de variable d'environnement ?

### Seul en astreinte, on cumule tous les rôles : un petit incident se traite à une personne, mais on garde le droit d'escalader
- Niveau de preuve : N3
- Source : Google, 2018, « Incident Response » (Workbook), https://sre.google/workbook/incident-response/
- Extrait lu : « By default, the IC assumes all roles that have not been delegated yet. » ; « Typically, small incidents require only a single on-call engineer to respond. » (passage cité dans l'étude de cas PagerDuty du même chapitre)
- Portée / limites : aucune source officielle trouvée qui adapte formellement le système de commandement à **une seule personne** (voir « Non vérifié »). Le Workbook admet seulement que le cadre complet « may be more than you need ».
- En release : avez-vous nommé à l'avance un recours (support de l'hébergeur, Supabase, un pair) pour le cas où l'incident dépasse une heure ?

### Classer la sévérité vite et, dans le doute, prendre la plus haute
- Niveau de preuve : N3
- Source : PagerDuty, s. d., « Severity Levels » (Incident Response Documentation), https://response.pagerduty.com/before/severity_levels/ ; Atlassian, s. d., « Understanding incident severity levels », https://www.atlassian.com/incident-management/kpis/severity-levels
- Extrait lu : PagerDuty : « If you are unsure which level an incident is (e.g. not sure if SEV-2 or SEV-1), treat it as the higher one. During an incident is not the time to discuss or litigate severities, just assume the highest and review during a postmortem. » ; Atlassian : « SEV 1 A critical incident with very high impact. For example: A customer-facing service like Jira is down for all customers. » / « SEV 2 A major incident with significant impact. For example: A customer-facing service is down for a sub-set of customers. »
- Portée / limites : les échelles sont propres à chaque entreprise (cinq niveaux chez PagerDuty, trois exemples chez Atlassian). PagerDuty lie la sévérité au risque acceptable (« the higher the severity, the riskier the decisions you can take », page « What is an incident »).
- En release : quel est le niveau (tout le monde ou une partie, fonction critique ou cosmétique) ? Ce niveau justifie-t-il un rollback immédiat ?

### Évaluation initiale : impact, ampleur, heure de début, lien avec un changement
- Niveau de preuve : N3
- Source : Atlassian, s. d., « Incident response » (Handbook, étape Assess), https://www.atlassian.com/incident-management/handbook/incident-response
- Extrait lu : « What is the impact on customers (internal or external)? What are customers seeing? How many customers are affected (some, all)? When did it start? How many support cases have customers opened? Are there other factors, e.g. Twitter, security, or data loss? »
- Portée / limites : la source ne fixe **aucune durée** pour cette évaluation.
- En release : symptôme vu par l'utilisateur, périmètre, heure de début, dernier changement déployé : ce sont exactement les quatre questions du Mode D. Le chronomètre de « 2 minutes » n'a pas de source.

### Un mauvais déploiement se traite par un rollback, pas par un correctif à chaud
- Niveau de preuve : N3
- Source : PagerDuty, s. d., « During an Incident », https://response.pagerduty.com/during/during_an_incident/
- Extrait lu : « Identify if there is an obvious cause to the incident (recent deployment, spike in traffic, etc.) » ; « Bad Deployment: Roll it back. Web Application Stuck/Crashed: Do a rolling restart. »
- Portée / limites : c'est une liste d'exemples, la page le dit (« obviously not an exhaustive list »). Elle ne traite pas du cas où une migration de schéma empêche le retour en arrière.
- En release : le dernier déploiement est-il le suspect évident ? Si oui, revenir en arrière d'abord, diagnostiquer ensuite.

### Avancer par boucle observation, hypothèse, expérience ; « résolu » veut dire que l'impact a cessé, pas que la cause est connue
- Niveau de preuve : N3
- Source : Atlassian, s. d., « Incident response » (Handbook, étapes Review et Resolve), https://www.atlassian.com/incident-management/handbook/incident-response
- Extrait lu : « Observe what's going on. Share and confirm observations. Develop theories about why it's happening. Develop experiments that prove or disprove those theories. Carry those out. Repeat. » ; « An incident is resolved when the current or imminent business impact has ended. »
- Portée / limites : la source ne fixe pas de critère chiffré de retour à la normale.
- En release : quelle observation confirmerait ou réfuterait l'hypothèse « c'est le déploiement » ? Le symptôme a-t-il réellement disparu côté utilisateur après l'atténuation ?

### Un mode opératoire écrit d'avance raccourcit la remise en service
- Niveau de preuve : N3 (chiffre interne de Google, sans méthode publiée)
- Source : Google (Benjamin Treynor Sloss, éd. Beyer et al.), 2016, « Site Reliability Engineering — Introduction », https://sre.google/sre-book/introduction/
- Extrait lu : « recording the best practices ahead of time in a "playbook" produces roughly a 3x improvement in MTTR as compared to the strategy of "winging it." »
- Portée / limites : le chiffre « 3x » n'est assorti ni d'un échantillon ni d'une méthode. À citer comme ordre de grandeur, pas comme preuve.
- En release : la commande de rollback (Vercel, PM2, image Docker précédente) est-elle écrite quelque part, prête à copier, avant le déploiement ?

---

## 2. Causes réelles des incidents

### La plupart des pannes suivent un changement : le moment juste après un déploiement est le plus risqué
- Niveau de preuve : N3 (constat interne de Google, sans méthode publiée)
- Source : Google, 2016, « Site Reliability Engineering — Introduction », https://sre.google/sre-book/introduction/
- Extrait lu : « SRE has found that roughly 70% of outages are due to changes in a live system. »
- Portée / limites : chiffre à l'échelle de Google, non détaillé. La réponse proposée y est un triptyque : déploiement progressif, détection rapide, rollback sûr.
- En release : qu'est-ce qui a changé dans les dernières heures (code, configuration, variables d'environnement, schéma, dépendance) ?

### La grande majorité des incidents s'atténuent sans modifier le code : rollback, changement d'infrastructure ou de configuration, redémarrage
- Niveau de preuve : N2 (152 incidents de haute sévérité sur 12 mois, Microsoft Teams)
- Source : Supriyo Ghosh, Manish Shetty, Chetan Bansal, Suman Nath, 2022, « How to Fight Production Incidents? An Empirical Study on a Large-scale Cloud Service », SoCC '22, https://www.microsoft.com/en-us/research/wp-content/uploads/2022/09/3542929.3563482.pdf
- Extrait lu : « a vast majority (> 90%) of the incidents are mitigated without code-change » ; « Finding#2: Although 40% incidents were caused by code/configuration bugs, nearly 80% of incidents were mitigated without a code or configuration fix. » ; répartition : « Rollback - 22.4 % », « Infra Change - 21.1 % », « Code Fix - 7.9 % »
- Portée / limites : il s'agit d'un seul service, géant, doté d'outils de déploiement mûrs. Les auteurs précisent que l'atténuation est souvent provisoire (« Many incidents are later fixed with more permanent measures such as code fix »). Le texte donne « > 90 % » sans changement de code et « près de 80 % » sans correctif de code ni de configuration : les deux chiffres ne mesurent pas la même chose. Même étude, sur la vitesse : « Finding#6: Manually fixing code and configuration take significantly higher time-to-mitigate, when compared to rolling back changes. » Les durées y sont normalisées, aucune valeur absolue n'est transposable.
- En release : quelle est l'atténuation sans code disponible (rollback, retour de variable d'environnement, redémarrage) ? Elle passe avant tout correctif. La version N-1 est-elle encore compatible avec le schéma actuel de la base ? Sinon, le rollback le plus rapide n'existe pas : le savoir **avant** de déployer.

### Une bonne part des incidents ne vient pas du code : erreurs de déploiement, capacité, certificats, dépendances
- Niveau de preuve : N2 (152 incidents)
- Source : Ghosh et al., 2022, SoCC '22, https://www.microsoft.com/en-us/research/wp-content/uploads/2022/09/3542929.3563482.pdf
- Extrait lu : « Finding#1: While 40% incidents were root caused to code or configuration bugs, a majority (60%) were caused due to non-code related issues in infrastructure, deployment, and service dependencies. »
- Portée / limites : la taxonomie est propre à l'étude. Pour un indépendant, les équivalents sont le certificat ou le domaine expiré, le quota Supabase, une variable d'environnement absente, le disque du NAS plein.
- En release : un build vert ne dit rien des variables d'environnement de production, des quotas, des certificats ni de la base distante. Les vérifier en conditions réelles.

### Les retards d'atténuation viennent souvent du manque de procédure, des étapes manuelles et des erreurs de diagnostic
- Niveau de preuve : N2 (152 incidents)
- Source : Ghosh et al., 2022, SoCC '22, https://www.microsoft.com/en-us/research/wp-content/uploads/2022/09/3542929.3563482.pdf
- Extrait lu : « Finding#8: While complex root causes can affect time-to-mitigate, 30% of incidents had mitigation delays even after identifying the root cause due to poor documentation, procedures, and manual deployment steps. » ; parmi les causes d'effort manuel : « misdiagnosis (29%): the problem was not properly diagnosed initially, which leads to delay in executing wrong resolution methods »
- Portée / limites : les pourcentages de sous-catégories portent sur des sous-ensembles d'incidents. Les auteurs ne les extrapolent pas.
- En release : la procédure de rollback est-elle testée ? Les droits nécessaires (jeton Vercel, accès SSH au NAS) sont-ils disponibles à 3 h du matin ?

### Chez Azure, plus de la moitié des incidents dus à un bug logiciel ont été atténués sans corriger le code
- Niveau de preuve : N4 (résumé secondaire seul lu, l'article original n'a pas pu être ouvert)
- Source : Adrian Colyer, 2019, « What bugs cause production cloud incidents? Liu et al., HotOS'19 » (résumé de Haopeng Liu, Shan Lu, Madan Musuvathi, Suman Nath, HotOS 2019), https://blog.acolyer.org/2019/06/21/what-bugs-cause-cloud-production-incidents/
- Extrait lu : « In total, there were 112 such incidents over the period March – September 2018 » ; « software bug incidents were resolved through a variety of mitigation techniques (56%) without patching the buggy code (44%) »
- Portée / limites : chiffres de seconde main. La page Microsoft Research (https://www.microsoft.com/en-us/research/?p=610323) confirme seulement l'objet de l'étude et que les bugs logiciels sont une cause majeure.
- En release : même pour un vrai bug, l'atténuation sans patch (rollback, désactivation d'une fonction) est la voie la plus fréquente.

### Les mises à jour figurent parmi les premières causes de pannes publiques des services en ligne
- Niveau de preuve : N4 (compte rendu d'un chercheur ; article original non ouvert)
- Source : Murat Demirbas, 2016, « Paper review: Why does the cloud stop computing? Lessons from hundreds of service outages » (compte rendu de Gunawi et al., SoCC 2016), https://muratbuffalo.blogspot.com/2016/11/why-does-cloud-stop-computing-lessons.html
- Extrait lu : « The paper surveys 597 outages from 32 popular cloud services. » ; « UPGRADE, NETWORK, and BUGS are three most popular root causes, followed by CONFIG and LOAD. » ; « Only 40% outage descriptions reveal root causes and only 24% reveal fix procedures. »
- Portée / limites : l'étude repose sur des sources publiques (presse, post-mortems publiés), et 355 pannes sur 597 ont une cause inconnue. Les durées de détection et de résolution n'ont **pas** pu être vérifiées.
- En release : la mise à jour elle-même (déploiement, montée de version d'une dépendance) est une cause de premier rang, pas un simple « bruit » de fond.

### Les logs contiennent le plus souvent de quoi diagnostiquer, mais ils sont bruyants et ne couvrent pas tout
- Niveau de preuve : N2 (198 pannes signalées par des utilisateurs, cinq systèmes distribués : Cassandra, HBase, HDFS, MapReduce, Redis)
- Source : Ding Yuan, Yu Luo, Xin Zhuang et al., 2014, « Simple Testing Can Prevent Most Critical Failures: An Analysis of Production Failures in Distributed Data-Intensive Systems », OSDI '14, https://www.usenix.org/system/files/conference/osdi14/osdi14-paper-yuan.pdf
- Extrait lu : « Finding 6 76% of the failures print explicit failure-related error messages. » ; « Finding 7 For a majority (84%) of the failures, all of their triggering events are logged. » ; « Finding 8 Logs are noisy: the median of the number of log messages printed by each failure is 824. » ; « Finding 10 Almost all catastrophic failures (92%) are the result of incorrect handling of non-fatal errors explicitly signaled in software. »
- Portée / limites : l'étude porte sur des systèmes distribués de données, pas sur des applications web. Les auteurs notent que, dans leur étude antérieure sur des systèmes non distribués, seules « 43% of failures had explicit failure-related error messages logged ».
- En release : lire les logs est nécessaire mais insuffisant. Un quart des pannes ne laisse aucun message explicite. Chercher aussi les erreurs avalées (`catch` qui se contente de journaliser).

---

## 3. Détection

### Une part importante des incidents est signalée par les utilisateurs, pas par la surveillance
- Niveau de preuve : N2 (152 incidents)
- Source : Ghosh et al., 2022, SoCC '22, https://www.microsoft.com/en-us/research/wp-content/uploads/2022/09/3542929.3563482.pdf
- Extrait lu : « about 55% of the incidents were detected by the automated watchdogs » ; « Among other 45% incidents, 29% incidents are reported by the external users or customers, and 10% are identified by the partner teams within Microsoft. » ; « Finding#7: ≈17% of incidents either lacked monitors or telemetry coverage, both of which result in significant detection delays. »
- Portée / limites : il s'agit d'un service doté d'une surveillance mûre. Un projet individuel est probablement moins couvert, mais la source ne le dit pas.
- En release : si aucun utilisateur ne s'est plaint, ce n'est pas une preuve de bonne santé. Quelle sonde aurait vu la panne ?

### Surveiller en boîte noire : tester le comportement visible comme le ferait un utilisateur
- Niveau de preuve : N3
- Source : Google (Rob Ewaschuk, éd. Beyer et al.), 2016, « Site Reliability Engineering — Chapter 6: Monitoring Distributed Systems », https://sre.google/sre-book/monitoring-distributed-systems/
- Extrait lu : « Black-box monitoring Testing externally visible behavior as a user would see it. » ; « black-box monitoring is symptom-oriented and represents active—not predicted—problems: "The system isn't working correctly, right now." »
- Portée / limites : le même chapitre juge la boîte blanche (logs, endpoints instrumentés) « essential » pour le débogage. Les deux se complètent.
- En release : le ping de `/`, de `/login` et le test de fumée d'un parcours sont de la boîte noire. Les logs sont de la boîte blanche. Il faut les deux.

### La surveillance synthétique rejoue un parcours scripté et peut se déclencher à chaque déploiement
- Niveau de preuve : N3 (doc d'éditeur ; l'affirmation « avant les utilisateurs » est un argument commercial)
- Source : Checkly, s. d., « What is End to End Monitoring? », https://www.checklyhq.com/docs/learn/monitoring/end-to-end-monitoring/
- Extrait lu : « Synthetic monitoring uses scripted tests to simulate user interactions with applications and services. » ; « It helps identify performance issues and availability problems before they impact real users. »
- Portée / limites : l'éditeur ne publie pas de mesure indépendante de l'avance de détection.
- En release : le parcours critique (connexion, action principale) est-il scripté et rejoué contre la production juste après le déploiement, puis à intervalle régulier ?

### Sur Vercel, on peut retenir un déploiement de production tant que des vérifications ne sont pas passées
- Niveau de preuve : N3
- Source : Vercel, 2026 (mise à jour du 11.08.2026), « Deployment Checks », https://vercel.com/docs/deployment-checks ; Checkly, s. d., « Integrating Checkly in Vercel », https://www.checklyhq.com/docs/integrations/ci-cd/vercel/overview/
- Extrait lu : Vercel : « When you add Deployment Checks to a project, Vercel will hold each production deployment until all required checks pass before assigning it to your custom production domains. » ; « At scale, this can mean the set of code that is tested **before merging** is not the same as the code that would be released to end users. » ; Checkly : « You can block your Vercel deployments if any of your checks fail or if the web vitals degrade »
- Portée / limites : les vérifications natives de Vercel sont le lint et la vérification de types (statiques). Une vérification au comportement (test de fumée) passe par GitHub Actions ou par une intégration. Le blocage se contourne par « Force Promote ».
- En release : le test de fumée tourne-t-il **avant** l'attribution du domaine (sur l'URL du déploiement), ou seulement après, quand les utilisateurs sont déjà exposés ?

### Liveness et readiness ne répondent pas à la même question ; une sonde de vivacité mal conçue aggrave la panne
- Niveau de preuve : N3 (doc officielle)
- Source : The Kubernetes Authors, s. d., « Liveness, Readiness, and Startup Probes », https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/
- Extrait lu : « Liveness probes determine when to restart a container. » ; « Readiness probes determine when a container is ready to accept traffic. » ; « Liveness probes must be configured carefully to ensure that they truly indicate unrecoverable application failure, for example a deadlock. Incorrect implementation of liveness probes can lead to cascading failures. » ; « The liveness probe passes when the app itself is healthy, but the readiness probe additionally checks that each required back-end service is available. »
- Portée / limites : c'est le vocabulaire de Kubernetes. Il se transpose à Docker et PM2, mais Vercel ne propose pas de sondes de ce type pour les fonctions. En auto-hébergé, l'équivalent est le HEALTHCHECK de Docker (Docker Inc., « Dockerfile reference », https://docs.docker.com/reference/dockerfile/) : « This can detect cases such as a web server stuck in an infinite loop and unable to handle new connections, even though the server process is still running. » La page décrit un état (`healthy` / `unhealthy`), pas une action automatique ; je n'ai pas vérifié si Docker redémarre seul un conteneur unhealthy.
- En release : `/api/health` dit-il « le processus vit » (liveness) ou « je peux servir, Supabase compris » (readiness) ? Un redémarrage automatique est-il branché sur la mauvaise des deux ? Sur le NAS, `docker ps` montre-t-il `healthy`, et pas seulement `Up` ?

### Les vérifications de santé qui interrogent les dépendances sont utiles mais dangereuses si on réagit automatiquement à leur échec
- Niveau de preuve : N3
- Source : Amazon (David, Sr. Principal Engineer ; nom complet non affiché sur la page), 05.12.2019, « Implementing health checks », Amazon Builders' Library, https://aws.amazon.com/builders-library/implementing-health-checks/
- Extrait lu : « Dependency health checks are a thorough inspection of the ability of an application to interact with its adjacent systems. » ; « But they can also have false positives when there are problems with the dependency itself. » ; « Unfortunately they can be dangerous because a dependency can cause a cascading failure throughout a system. »
- Portée / limites : le contexte est une flotte de serveurs derrière un répartiteur de charge. Pour une instance unique, le risque principal est de redémarrer en boucle quand Supabase est indisponible.
- En release : un `/api/health` qui interroge la base est bon pour diagnostiquer, mauvais s'il déclenche des redémarrages automatiques. Séparer les deux usages.

---

## 4. Fenêtre de surveillance après déploiement

### La durée d'observation doit être assez longue pour être représentative, et l'intervalle des métriques ne doit pas dépasser cette durée
- Niveau de preuve : N3
- Source : Google (éd. Beyer et al.), 2018, « The Site Reliability Workbook — Chapter 16: Canarying Releases », https://sre.google/workbook/canarying-releases/
- Extrait lu : « It should be sizeable and last long enough to be representative of the overall deployment. Terminating a canary deployment after receiving just a handful of queries doesn't provide a useful signal » ; « When using metrics to evaluate canary success, make sure the intervals of your metrics are either the same as or less than your canary duration. »
- Portée / limites : **aucune durée chiffrée universelle**. La durée dépend du rythme de livraison (« If you release daily, you can't let your canary last for a week »).
- En release : combien de requêtes réelles ont touché le nouveau code pendant la fenêtre ? Une fenêtre de 5 minutes avec 3 visites ne prouve rien.

### Fixer la fenêtre en nombre de requêtes et en durée, car certaines régressions brûlent lentement
- Niveau de preuve : N3 (pratique d'Amazon et de Google)
- Source : Clare Liguori (Amazon), 18.06.2020, « Automating safe, hands-off deployments », Amazon Builders' Library, https://aws.amazon.com/builders-library/automating-safe-hands-off-deployments/ ; Eran Davidovich (Waze) et Théo Chamley (Google Cloud), 15.01.2019, « Canary analysis: Lessons learned and best practices from Google and Waze », https://cloud.google.com/blog/products/devops-sre/canary-analysis-lessons-learned-and-best-practices-from-google-and-waze
- Extrait lu : Amazon : « Sometimes a negative impact caused by a deployment is not readily apparent. It's slow burning . » ; « A typical pipeline waits at least one hour after each one-box stage » ; « The bake time includes requirements to wait for a specific number of data points in the team's metrics (for example, "wait for at least 100 requests to the Create API") » ; Google/Waze : « You need at least 50 pieces of time-series data per metric for the statistical analysis to be relevant. »
- Portée / limites : ce sont des pipelines automatisés à très fort trafic, non surveillés en direct par un humain. Le chiffre « une heure » n'est pas une norme. Les « 50 points » valent pour l'analyse statistique de Spinnaker/Kayenta.
- En release : la fenêtre pré-engagée est-elle exprimée en minutes **et** en volume minimal de requêtes ? Sur un site peu fréquenté, faut-il générer ce trafic par la sonde synthétique ?

---

## 5. Comparer avant et après

### Comparer « avant » et « après » dans le temps est une évaluation risquée : le moment lui-même change les métriques
- Niveau de preuve : N3
- Source : Google, 2018, « Canarying Releases » (section « Before/After Evaluation Is Risky »), https://sre.google/workbook/canarying-releases/
- Extrait lu : « Because time is one of the biggest sources of change in observed metrics, it is difficult to assess degradation of performance with before/after evaluation. » ; « For example, if we perform a release on Monday, we may be comparing behavior during a business day to behavior during a weekend, introducing a large amount of noise. »
- Portée / limites : la méthode préférée est le canari (une population en parallèle, au même moment). Sans canari (offre Hobby de Vercel, instance unique en auto-hébergé), avant/après reste la seule option, mais il faut corriger l'effet du temps.
- En release : la référence d'avant compare-t-elle la même tranche horaire et le même jour de semaine (par exemple la même heure, sept jours plus tôt), et pas simplement « l'heure précédente » ?

### La bonne référence est une version témoin servie en même temps, pas la production qui tourne depuis longtemps
- Niveau de preuve : N3
- Source : Nikhil Kaul et Andrew Phillips (Google Cloud), 10.04.2018, « Introducing Kayenta: An open automated canary analysis tool from Google and Netflix », https://cloud.google.com/blog/products/gcp/introducing-kayenta-an-open-automated-canary-analysis-tool-from-google-and-netflix ; Vercel, 2026 (mise à jour du 15.09.2026), « Rolling Releases », https://vercel.com/docs/rolling-releases
- Extrait lu : Kayenta : « Comparing short-term metrics of a new deployment to the long-running production instances in a manual or ad-hoc fashion is an inaccurate way to identify the health of the canary. » ; « Manual canary analysis requires subjective assessment and is prone to human bias and error. » ; Vercel : « Vercel shows you a breakdown of key metrics, such as Speed Insights, between the canary and current deployment. » ; « Rolling Releases are available on Enterprise and Pro plans »
- Portée / limites : Kayenta suppose plusieurs instances. Les Rolling Releases de Vercel sont limitées à un projet sur l'offre Pro et absentes de Hobby.
- En release : un rolling release est-il disponible (offre Pro) ? Si oui, comparer le canari et la version courante **au même moment** plutôt que la version nouvelle et l'historique.

---

## 6. Communication et page de statut

### Publier un premier message vite, puis des mises à jour à cadence annoncée, jusqu'à confirmation du rétablissement
- Niveau de preuve : N3
- Source : PagerDuty, s. d., « External Communication Guidelines », https://response.pagerduty.com/during/external_communication_guidelines/
- Extrait lu : « The first communication should indicate that an incident is under investigation. » ; « Decision and posting of initial communication happens within 5 minutes of kicking off the incident call. » ; « These updates should be delivered at least every 20 minutes » ; « Your final communication should be posted when full recovery of the incident has been confirmed »
- Portée / limites : c'est la cadence d'une entreprise à clientèle contractuelle. Le GDS (administration britannique) donne un exemple de cadence par priorité : une mise à jour par heure en P1, toutes les deux heures en P2 (https://gds-way.digital.cabinet-office.gov.uk/standards/incident-management.html, page révisée le 29.07.2024, signalée comme possiblement périmée).
- En release : seul, prévoir des messages types prêts à poster : « enquête en cours », « périmètre connu », « rétabli ». Annoncer l'heure de la prochaine mise à jour.

### Une page de statut dédiée, en langage non technique : ce qui ne marche pas, et dans combien de temps
- Niveau de preuve : N3
- Source : Atlassian, s. d., « Incident communication », https://www.atlassian.com/incident-management/incident-communication ; GOV.UK Developer Documentation, 01.10.2025, « Post a message on the status page », https://docs.publishing.service.gov.uk/manual/post-a-statuspage-message.html
- Extrait lu : Atlassian : « We recommend teams use a dedicated status page as their primary incident communication solution. Whether you build it yourself or use a hosted solution like Statuspage, it's important to provide your customers and colleagues with a clear source of truth during an incident. » ; GOV.UK : « Users will want to know what isn't working, and how long it will take to fix. Write in non-technical language. »
- Portée / limites : Atlassian vend Statuspage, sa recommandation est donc intéressée. Aucune source consultée n'impose une page de statut à un projet individuel (obligations légales : non vérifié).
- En release : où l'utilisateur apprend-il qu'il y a une panne ? La page de statut est-elle hébergée **hors** de l'infrastructure qui peut tomber ?

---

## 7. Fatigue, stress et décision

### Sous stress, l'intervenant glisse vers l'heuristique et l'action irréfléchie
- Niveau de preuve : N3 (chapitre de Google qui s'appuie sur la littérature, avec renvois [Kah11] et [Chr09])
- Source : Google (Andrea Spadaccini, éd. Beyer et al.), 2016, « Site Reliability Engineering — Chapter 11: Being On-Call », https://sre.google/sre-book/being-on-call/
- Extrait lu : « Stress hormones like cortisol and corticotropin-releasing hormone (CRH) are known to cause behavioral consequences—including fear—that can impair cognitive functions and cause suboptimal decision making » ; « Under the influence of these stress hormones, the more deliberate cognitive approach is typically subsumed by unreflective and unconsidered (but immediate) action, leading to potential abuse of heuristics. »
- Portée / limites : synthèse de seconde main de la recherche, pas une étude d'astreinte. Le même chapitre fixe une charge maximale : environ 6 heures de travail par incident, d'où « the maximum number of incidents per day is 2 per 12-hour on-call shift ».
- En release : la décision en cours (correctif à chaud, migration manuelle) est-elle délibérée, ou est-ce un réflexe ? Une liste de contrôle écrite d'avance réduit cette pente.

### La fatigue produit des erreurs ; 24 heures d'astreinte sans relève ne tiennent pas
- Niveau de preuve : N3
- Source : Google (éd. Beyer et al.), 2018, « The Site Reliability Workbook — Chapter 8: On-Call », https://sre.google/workbook/on-call/
- Extrait lu : « Team members run the risk of exhaustion when shifts run long, and when people are tired, they make mistakes. » ; « In our experience, 24 hours of on-call duty without reprieve isn't a sustainable setup. »
- Portée / limites : texte pensé pour des équipes. Un indépendant seul est, par construction, en astreinte continue. Aucune source n'a été trouvée sur ce cas précis.
- En release : éviter de déployer quand on ne pourra pas surveiller la fenêtre lucide (le soir tard, avant de partir). Si l'incident survient la nuit, viser le rétablissement minimal et reporter la cause racine au lendemain.

### La privation de sommeil dégrade surtout les décisions face à l'imprévu et la révision des plans
- Niveau de preuve : N2 (revue de littérature ; résumé seul lu)
- Source : Yvonne Harrison et James A. Horne, 2000, « The impact of sleep deprivation on decision making: a review », Journal of Experimental Psychology: Applied, doi 10.1037/1076-898x.6.3.236 ; résumé lu via https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=TITLE:%22impact%20of%20sleep%20deprivation%20on%20decision%20making%22&resultType=core&format=json
- Extrait lu : « recent findings show that despite this effort, SD still impairs decision making involving the unexpected, innovation, revising plans, competing distraction, and effective communication. » ; « SD presents particular difficulties for sleep-deprived decision makers who require these latter skills during emergency situations. »
- Portée / limites : revue ancienne (2000), sans échantillon unique. Elle note aussi que les tâches logiques à règles sont peu affectées par une privation courte.
- En release : un incident nocturne demande précisément de réviser ses plans face à l'imprévu. D'où l'intérêt d'actions préécrites (rollback en une commande) plutôt qu'improvisées.

### Revenir en arrière, corriger, puis redéployer, plutôt que pousser un correctif à chaud non testé
- Niveau de preuve : N3
- Source : Google, 2018, « The Site Reliability Workbook — Chapter 8: On-Call » (section Mitigation delay), https://sre.google/workbook/on-call/ ; Clare Liguori (Amazon), 2020, « Automating safe, hands-off deployments », https://aws.amazon.com/builders-library/automating-safe-hands-off-deployments/
- Extrait lu : Google : « Remember that even a "quick fix" needs time to be tested, built, and rolled out. Testing is vital to making sure the quick fix actually fixes the bug, and that it doesn't introduce additional bugs or other unintended consequences. Generally, it is better to "roll back, fix, and roll forward" rather than "roll forward, fix, and roll forward again." » ; Amazon : « we can dial down the pipeline's bake time to accelerate the deployment, but we require a high level of scrutiny on the change to do this. »
- Portée / limites : Google rappelle qu'un rollback « may be necessary but is not sufficient if the bug caused data corruption ». C'est la meilleure source trouvée pour la règle « pas de correctif non vérifié en prod ».
- En release : le correctif envisagé a-t-il été testé hors production ? Sinon, existe-t-il un rollback qui rend le service sans lui ?

---

## 8. Limites des outils de retour arrière et de contrôle de dérive

### Un rollback Vercel ne ramène ni les variables d'environnement ni la base, et il fige les déploiements suivants
- Niveau de preuve : N3 (doc officielle)
- Source : Vercel, 2026 (mise à jour du 07.07.2026), « Performing an Instant Rollback on a Deployment », https://vercel.com/docs/instant-rollback
- Extrait lu : « Vercel won't update environment variables if you change them in the project settings and will roll back to a previous build » ; « A reminder about the changing behavior of external APIs, databases, and CMSes used in the current or previous deployments » ; « After a rollback, Vercel turns off auto-assignment of production domains. This means new pushes to your production branch won't replace the rolled-back deployment. » ; « Hobby users can roll back to the immediately previous deployment. »
- Portée / limites : le comportement est propre à Vercel. Les définitions de cron sont restaurées avec le déploiement cible (même page).
- En release : après un rollback, la base Supabase est-elle encore compatible avec l'ancien code ? A-t-on pensé à annuler le rollback (`vercel promote`) une fois le correctif livré, faute de quoi les pushes suivants n'atteignent jamais la production ?

### `supabase migration list` ne compare que les horodatages : ce n'est pas un contrôle de dérive du schéma
- Niveau de preuve : N3 (doc officielle)
- Source : Supabase, s. d., « CLI reference — supabase migration list », https://supabase.com/docs/reference/cli/supabase-migration-list
- Extrait lu : « Lists the migration files in supabase/migrations next to the migration history of the target database. » ; « Only the timestamps are compared to identify any differences. » ; la même page décrit `supabase db diff` : « Diffs schema changes made to a database. »
- Portée / limites : la commande montre si l'historique est aligné, pas si le schéma réel a été modifié à la main. Pour ce second contrôle, il faut `db diff`.
- En release : « migrations sans dérive » veut-il dire « historique aligné » (`migration list --remote`) ou « schéma identique » (`db diff`) ? Ce n'est pas la même vérification.

---

## Verdict sur les règles de l'agent

| Règle | Verdict | Motif sourcé |
|---|---|---|
| « Mode B : statut, logs de build, ping des endpoints critiques (`/`, `/api/health`, `/login`), migrations sans dérive, logs runtime des 5 dernières minutes, logs DB, smoke test d'un parcours critique, signaux dorés comparés à l'avant-déploiement sur la fenêtre pré-engagée. » | **Contredite / à préciser** (sur trois points ; le reste est soutenu) | Le ping et le test de fumée sont **soutenus** : surveillance en boîte noire (SRE ch. 6), surveillance synthétique (Checkly), Deployment Checks de Vercel qui retiennent le domaine avant exposition. À préciser : (1) **« 5 dernières minutes »** : convention sans preuve. Le SRE Workbook exige une durée représentative et des intervalles de métriques au plus égaux à la fenêtre ; Amazon attend au moins une heure **et** un nombre minimal de requêtes, à cause des régressions à combustion lente. (2) **« comparés à l'avant-déploiement »** : le SRE Workbook juge l'évaluation avant/après « risky », et Kayenta qualifie d'« inaccurate » la comparaison avec la production installée depuis longtemps. Sans canari, comparer au même créneau (même heure, même jour de semaine) et l'écrire ; avec l'offre Pro, préférer un rolling release. (3) **« migrations sans dérive »** : `supabase migration list` ne compare que les horodatages ; la dérive réelle du schéma demande `supabase db diff`. Enfin, `/api/health` doit dire s'il vérifie la vivacité ou la disponibilité des dépendances (Kubernetes, Amazon). |
| « Un déploiement vert au build peut être rouge sur les signaux. » | **Soutenue** | Environ 70 % des pannes suivent un changement (SRE, introduction) ; 60 % des incidents ont une cause hors code : infrastructure, déploiement, dépendances (Ghosh 2022, n = 152) ; régressions « slow burning » (Amazon) ; Vercel note que le code testé avant fusion n'est pas forcément celui qui est publié. |
| « Mode D : évaluer en 2 minutes (symptôme, périmètre, depuis quand, dernier changement déployé). » | **Contenu soutenu, durée sans preuve** | Les quatre questions reprennent l'étape Assess d'Atlassian (« What are customers seeing? How many customers are affected? When did it start? », corrélation avec un déploiement) et la consigne du commandant d'incident chez PagerDuty (« obvious cause … recent deployment »). Le délai de **2 minutes** n'a aucune source. Le chiffre publié le plus proche est un premier message public « within 5 minutes » (PagerDuty). |
| « Hors critères → Mode D immédiat, pas d'attentisme. » | **Soutenue** | « Declare incidents early and often » et « managed incidents are resolved faster » (SRE Workbook) ; « better to declare an incident early » (SRE ch. 14) ; dans le doute, prendre la sévérité la plus haute (PagerDuty) ; rollback automatique dès l'alarme pendant la fenêtre d'observation (Amazon). Condition : que les critères aient été fixés **avant** le déploiement (SRE : « Set clear conditions for declaring an incident »). |
| « Logs prod jamais consultés post-déploiement » (anti-pattern) ; « Jamais d'affirmation sur le statut d'un déploiement sans avoir lu les logs réels. » | **Soutenue, à préciser** | Les logs portent l'information de diagnostic dans la majorité des cas (76 % des pannes avec message d'erreur explicite, 84 % avec tous les événements déclencheurs journalisés : Yuan 2014, n = 198). Mais 24 % des pannes n'ont aucun message explicite, les logs sont bruyants (médiane de 824 messages), et 29 % des incidents chez Microsoft Teams ont été signalés par des utilisateurs, la surveillance n'ayant rien vu (Ghosh 2022). Il faut donc lire les logs **et** sonder en boîte noire. Des logs sans erreur ne prouvent pas un déploiement sain. |

---

## Mythes et affirmations contestées

- **« Il faut comprendre la cause avant d'agir. »** Contredit par le SRE Workbook : « To mitigate an incident, you don't have to fully understand the details ». Chez Microsoft Teams, plus de 90 % des incidents ont été atténués sans changement de code (Ghosh 2022).
- **« La plupart des incidents se règlent par un correctif de code. »** Contredit : 7,9 % seulement par correctif de code chez Microsoft Teams (Ghosh 2022). Chez Azure, 56 % des incidents dus à un bug ont été atténués sans patch, d'après le résumé de Colyer (seconde main).
- **« Comparer les métriques avant et après le déploiement suffit. »** Contesté : le SRE Workbook titre « Before/After Evaluation Is Risky » ; Kayenta juge la comparaison avec la production installée depuis longtemps « inaccurate ». Cela reste acceptable faute de mieux, à condition de corriger l'effet du jour et de l'heure.
- **« Un `/api/health` complet doit vérifier toutes les dépendances. »** À nuancer : Kubernetes réserve la vérification des dépendances à la readiness, et prévient qu'une liveness mal conçue provoque des pannes en cascade ; Amazon juge les vérifications de dépendances « dangerous » si on réagit automatiquement à leur échec.
- **« La surveillance détecte les pannes avant les utilisateurs. »** Non garanti : 29 % des incidents signalés par les utilisateurs et environ 17 % sans surveillance ni télémétrie, même chez Microsoft Teams (Ghosh 2022). La promesse « before they impact real users » de Checkly est un argument d'éditeur, non mesuré.
- **« Un rollback ramène tout à l'état d'avant. »** Contredit pour Vercel : variables d'environnement inchangées, base et API externes non concernées, attribution automatique du domaine désactivée. Le SRE Workbook rappelle qu'un rollback ne suffit pas en cas de données corrompues.
- **« Un playbook triple la vitesse de rétablissement. »** Le chiffre « roughly a 3x improvement in MTTR » (SRE, introduction) n'est assorti d'aucune méthode publiée : c'est un ordre de grandeur interne, pas une preuve.
- **« 70 % des pannes viennent des changements. »** Chiffre de Google (« roughly »), sans méthode publiée. Il est cohérent avec Gunawi 2016 (UPGRADE parmi les trois premières causes, d'après le compte rendu de Demirbas), mais ce n'est pas une mesure transposable.

---

## Non vérifié

- **Gunawi et al. 2016 (SoCC)** : texte complet inaccessible (hôte ucare.cs.uchicago.edu hors réseau autorisé de la session, miroir iastate en erreur TLS puis 503, ACM 403). Les **durées de détection et de résolution** et les pourcentages par cause (UPGRADE, CONFIG) ne sont pas vérifiés ; seuls le nombre de pannes et l'ordre des causes, lus dans un compte rendu, sont cités.
- **Liu et al. 2019 (HotOS)** : article original non ouvert ; chiffres repris du résumé d'A. Colyer (seconde main).
- **Billet Netflix « Automated Canary Analysis at Netflix with Kayenta »** : 403. Le test statistique utilisé et la description de Netflix ne sont pas vérifiés ; seul l'article de Google Cloud a été lu.
- **Yuan et al. sur la journalisation proactive (OSDI 2012)** : PDF non obtenu. Seul Yuan et al. 2014 a été lu.
- **Dawson & Reid 1997 (Nature, « Fatigue, alcohol and performance impairment »)** : métadonnées seules, aucun résumé. L'équivalence entre veille prolongée et alcoolémie n'est **pas** vérifiée.
- **Adaptation formelle de la conduite d'incident à une personne seule** : aucune source officielle trouvée. Seuls existent « the IC assumes all roles » et « a single on-call engineer » (SRE Workbook).
- **Durées de l'agent** : « 2 minutes » pour l'évaluation du Mode D et « 5 dernières minutes » de logs : aucune source.
- **Fenêtre adaptée à un site à faible trafic** : aucune source ne traite ce cas. Les règles trouvées (une heure et 100 requêtes chez Amazon, 50 points par métrique chez Google/Waze) valent pour un fort trafic.
- **Obligations légales d'information des utilisateurs en cas de panne sans violation de données** (page de statut obligatoire ou non, en droit suisse ou européen) : non recherché à fond, non vérifié.
- **Cadence de communication du manuel d'incident d'Atlassian** : aucun chiffre trouvé sur la page ouverte.
- **Comportement de Docker devant un conteneur unhealthy** (redémarrage automatique ou non) : non vérifié.
- **Page Vercel « Working with Checks »** (https://vercel.com/docs/checks) : citée en lien par la page Deployment Checks, non ouverte.
- **Définitions de sévérité dans les docs d'incident de PagerDuty au-delà de la page « Severity Levels »** et lien explicite entre sévérité et cadence : non vérifiés.

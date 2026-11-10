# Fiche `ux-preuves` — Mise en production — déploiement progressif et retour arrière

> Fiche du skill `ux-preuves` (dev-fullstack), volet **mise en production**, préchargé par `release`. Couvre : canary et comparaison avant/après, retour arrière contre correctif en avant, Instant Rollback et Rolling Releases de Vercel, PM2 et Docker, feature flags et leur dette, critères pré-engagés, séparer déployer et activer.
> **Instantané de la recherche documentaire du 10.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Études (souvent des prépublications pour les LLM), docs d'outils
> et pratiques d'entreprise **vieillissent** : avant d'en faire dépendre une règle,
> relire la source (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles de l'agent », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

**Méthode.** Recherche menée le 10 novembre 2026. Chaque entrée repose sur une page ou un PDF **réellement ouvert** ce jour-là : pages HTML téléchargées avec curl puis converties en texte (les citations sont recopiées du texte obtenu, pas d'un résumé), PDF téléchargés dans `pdf2/` puis extraits avec `pdftotext`, docs Vercel et Supabase lues dans leur version Markdown officielle (`<url>.md`, champ `last_updated` relevé quand il existe). WebSearch n'a servi qu'à trouver des URL. Les docs de plateforme décrivent le produit **à la date de lecture (10.11.2026)** et peuvent changer. Niveaux : N1 norme, N2 étude revue par les pairs ou empirique (échantillon cité), N3 doc officielle ou guide d'une entreprise sur sa propre pratique, N4 avis d'expert. Ce qui est déjà couvert ailleurs (signaux dorés, SLO, budget d'erreur, expand/contract, rotation des secrets, post-mortem) n'est cité qu'en passant. Une affirmation non confirmée est marquée « Non vérifié ». Contexte visé : un développeur indépendant, Next.js/TypeScript sur Vercel + Supabase, ou auto-hébergé (NAS, PM2, Docker), donc souvent **un seul serveur et peu de trafic**. La transposition est signalée à chaque fois.

---

## 1. Canary et déploiement progressif

### Un canary est un déploiement partiel ET limité dans le temps, accompagné d'une évaluation qui décide de la suite
- Niveau de preuve : N3
- Source : Alec Warner, Štěpán Davidovič (Google), 2018, « Canarying Releases » (The Site Reliability Workbook, ch. 16), https://sre.google/workbook/canarying-releases/
- Extrait lu : « We define canarying as a partial and time-limited deployment of a change in a service and its evaluation. This evaluation helps us decide whether or not to proceed with the rollout. » ; et : « In Google's experience, a majority of incidents are triggered by binary or configuration pushes »
- Portée / limites : l'annexe C du même livre (https://sre.google/workbook/postmortem-analysis/) chiffre les déclencheurs : « Binary push 37% », « Configuration push 31% », sur « a sample of thousands of postmortems over the last seven years » (2010–2017). Ce sont des données Google, à grande échelle. Rien ne dit que la proportion vaut pour un petit service.
- En release : sans évaluation, il n'y a pas de canary : un déploiement partiel qu'on ne regarde pas n'apporte rien. Un changement de **configuration** (variables d'env, `vercel.json`, crons) est un push à risque au même titre que le code.

### Un canary doit durer assez longtemps et voir assez de trafic pour être représentatif. Une poignée de requêtes ne suffit pas
- Niveau de preuve : N3
- Source : Warner, Davidovič, 2018, « Canarying Releases », https://sre.google/workbook/canarying-releases/
- Extrait lu : « It should be sizeable and last long enough to be representative of the overall deployment. Terminating a canary deployment after receiving just a handful of queries doesn't provide a useful signal » ; et : « make sure the intervals of your metrics are either the same as or less than your canary duration. »
- Portée / limites : aucune durée ni taille chiffrée n'est universelle. La durée dépend de la cadence (« If you deploy continuously (for example, 20 times in a day), your canary duration must be significantly shorter ») et le chapitre conseille un seul canary à la fois. Les exemples à 5 % viennent d'une démo App Engine.
- En release : avec peu de trafic, la fenêtre se fixe en **nombre de requêtes** sur le chemin modifié, pas en minutes. Un tableau de bord agrégé à l'heure ne permet pas de juger une fenêtre de 15 minutes.

### Comparer un petit nombre de métriques visibles par l'utilisateur (« pas plus d'une douzaine »), ventilées entre canary et contrôle
- Niveau de preuve : N3
- Source : Warner, Davidovič, 2018, « Canarying Releases », https://sre.google/workbook/canarying-releases/
- Extrait lu : « Select the top few metrics to use in canary evaluations (perhaps no more than a dozen). » ; « our best metrics are likely the HTTP return codes and latency of response » ; « We need to correctly define a notion of acceptable behavior for each of the metrics. »
- Portée / limites : le chapitre demande aussi de « reevaluate expectations on a regular basis as the service, its feature set, and its behavior evolve ». Il suggère d'exclure les 4xx, que des utilisateurs peuvent provoquer. Il ne dit **pas explicitement** que les seuils doivent être figés avant le déploiement : c'est implicite dans « définir le comportement acceptable ».
- En release : avant de déployer, nommer 2 à 4 métriques (taux de 5xx, latence p95 de la route touchée, erreurs du journal d'exécution) et leur seuil. Un taux d'erreur global qui « a l'air normal » peut cacher 20 % d'erreurs sur 5 % du trafic.

### Avec un seul serveur, on ne peut évaluer qu'en « avant/après ». Google juge cette méthode risquée : il faut le savoir et compenser
- Niveau de preuve : N3
- Source : Warner, Davidovič, 2018, « Canarying Releases », section « Before/After Evaluation Is Risky », https://sre.google/workbook/canarying-releases/
- Extrait lu : « Because time is one of the biggest sources of change in observed metrics, it is difficult to assess degradation of performance with before/after evaluations. » ; « If the new release is completely broken, how quickly can we detect and revert? »
- Portée / limites : le chapitre ne traite pas des hôtes uniques ni des petits services. La transposition est la mienne : sur un NAS avec PM2 ou un conteneur unique, la seule comparaison possible est temporelle. Sur Vercel, Rolling Releases permet une vraie comparaison simultanée (voir § 3).
- En release : en avant/après, comparer à la **même plage horaire** d'un jour comparable et prévoir un retour arrière rapide, car tous les utilisateurs sont exposés en même temps.

### Le blue/green permet un retour arrière « trivial » en rebasculant le routeur, mais ce n'est qu'un avant/après, et la base de données reste commune
- Niveau de preuve : N3 (Google) + N4 (Fowler)
- Source : Warner, Davidovič, 2018, « Canarying Releases », https://sre.google/workbook/canarying-releases/ ; Martin Fowler, 2010, « BlueGreenDeployment », https://martinfowler.com/bliki/BlueGreenDeployment.html
- Extrait lu : Google : « rollback is a trivial reversal of the router change. One downside is that this setup uses twice as many resources […] you are effectively performing a before/after canary » ; Fowler : « There's still the issue of dealing with missed transactions while the green environment was live » et « The trick is to separate the deployment of schema changes from application upgrades. »
- Portée / limites : le retour arrière ne porte que sur le code servi. Les données écrites par la nouvelle version restent. Les modèles de Vercel (domaines repointés vers un déploiement immuable) et de PM2 ressemblent à ce schéma.
- En release : avant de rebasculer, se demander quelles écritures la nouvelle version a faites que l'ancienne ne sait pas lire.

### Fixer à l'avance un seuil d'alarme qui déclenche le retour arrière, une durée d'observation (« bake time ») et un nombre minimal de requêtes
- Niveau de preuve : N3
- Source : Clare Liguori (AWS), s.d. (Amazon Builders' Library), « Automating safe, hands-off deployments », https://aws.amazon.com/builders-library/automating-safe-hands-off-deployments/
- Extrait lu : « This high-severity alarm is used to page the oncall engineer and to automatically roll back the service if a deployment is in progress. » ; « The bake time includes requirements to wait for a specific number of data points in the team's metrics (for example, "wait for at least 100 requests to the Create API") » ; « During the entire bake time, the deployment is automatically rolled back if the team's high-severity aggregate alarm goes into the alarm state. »
- Portée / limites : pratique d'Amazon à très grande échelle (« at least one hour after each one-box stage, at least 12 hours after the first regional wave »). C'est la source la plus explicite trouvée sur des critères **pré-engagés et automatisés**. Les durées ne se transposent pas telles quelles. L'accélération en urgence existe, mais elle est encadrée : « we require the scrutiny of the organization's Principal Engineers ».
- En release : le critère s'écrit avant le déploiement, sous forme exécutable : un seuil, une fenêtre et un nombre de requêtes. Le retour arrière ne dépend alors pas d'un jugement improvisé.

### Arrêter la progression dès qu'une alerte de santé visible des utilisateurs se déclenche, et observer des heures plutôt que des minutes entre les vagues
- Niveau de preuve : N3
- Source : Microsoft, 2026 (ms.date 11.02.2026, mise à jour 30.07.2026), « Recommendations for safe deployment practices » (Azure Well-Architected), https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/safe-deployments
- Extrait lu : « Bake times should be measured in hours and days rather than minutes. » ; « During a rollout, if you receive an alert about a health change relating to an end user, the rollout should immediately halt » ; « Make sure that you define who can approve SDP acceleration in an emergency and the criteria that must be met for acceleration to be approved. »
- Portée / limites : le guide vise des charges multi-régions. Il recommande d'inclure des métriques d'usage, car une absence de plainte peut masquer un problème.
- En release : quand le trafic est faible, une absence d'erreur ne prouve pas l'absence de défaut. Vérifier que le chemin modifié a bien été **utilisé** pendant la fenêtre.

### Exposer par paliers (interne, puis petit pourcentage, puis 100 %) avec un bouton d'arrêt, et laisser derrière un flag ce qu'on peut éteindre sans redéployer
- Niveau de preuve : N3
- Source : Chuck Rossi (Facebook), 31.08.2017, « Rapid release at massive scale », https://engineering.fb.com/2017/08/31/web/rapid-release-at-massive-scale/
- Extrait lu : « an emergency stop button lets us keep the release from going any further. If everything is OK, we push the changes to 2 percent of production » ; « If we do find a problem, we can simply switch the gatekeeper off rather than revert back to a previous version or fix forward. »
- Portée / limites : échelle Facebook de 2017. Pour un indépendant, le palier « interne » correspond au déploiement de prévisualisation testé par soi-même, et le palier « 2 % » à Rolling Releases (Vercel Pro) ou à un flag par utilisateur.
- En release : couper le flag est une troisième option, souvent plus rapide que le retour arrière ou le correctif. Encore faut-il que le flag existe avant l'incident.

---

## 2. Retour arrière, mitigation et fix-forward

### Atténuer avant de comprendre : un retour arrière est une « mitigation générique » qu'on peut appliquer en connaissant seulement l'emplacement de la cause
- Niveau de preuve : N3
- Source : Jennifer Mace, Jelena Oertel, Stephen Thorne, Arup Chakrabarti et al., 2018, « Incident Response » (The Site Reliability Workbook), https://sre.google/workbook/incident-response/
- Extrait lu : « Google always aims to first stop the impact of an incident, and then find the root cause » ; « responders could roll back a recent release when an outage is correlated with the release cycle » ; « To mitigate an incident, you don't have to fully understand the details—you only need to know the location of the root cause. »
- Portée / limites : le même passage prévient que ces mitigations sont « blunt instruments and may cause other disruptions to the service ». Il précise aussi que l'outil de mitigation se construit **avant** l'incident.
- En release : une hausse d'erreurs qui coïncide avec un déploiement justifie le retour arrière, même sans diagnostic.

### Préférer « retour arrière, correctif, redéploiement » à « redéploiement, correctif, redéploiement », car même un correctif rapide doit être testé, construit et déployé
- Niveau de preuve : N3
- Source : Ollie Cook, Sara Smollett, Andrea Spadaccini, Cara Donnelly, Jian Ma, Garrett Plasky et al., 2018, « On-Call » (The Site Reliability Workbook, ch. 8), https://sre.google/workbook/on-call/
- Extrait lu : « Remember that even a "quick fix" needs time to be tested, built, and rolled out. […] Generally, it is better to "roll back, fix, and roll forward" rather than "roll forward, fix, and roll forward again." » ; « a rollback alone may be necessary but is not sufficient if the bug caused data corruption » ; « If at all possible, avoid changes that can't be rolled back, such as API-incompatible changes and lockstep releases. »
- Portée / limites : le chapitre fait le calcul avec un SLO de 99,99 %, soit environ 15 minutes de budget par trimestre. Il recommande aussi l'isolement par feature flag et le drainage du trafic. Le « if safe and appropriate » est explicite.
- En release : un correctif « trivial » doit passer par un build Vercel ou une image Docker, plus une vérification. C'est presque toujours plus lent que le retour arrière instantané.

### Priorité d'incident : arrêter l'hémorragie, restaurer le service ET conserver les preuves
- Niveau de preuve : N3
- Source : Andrew Stribblehill, 2016, « Managing Incidents » (Site Reliability Engineering, ch. 14), https://sre.google/sre-book/managing-incidents/ ; Chris Jones, 2016, « Effective Troubleshooting » (ch. 12), https://sre.google/sre-book/effective-troubleshooting/
- Extrait lu : « Prioritize. Stop the bleeding, restore service, and preserve the evidence for root-causing. » ; « Stopping the bleeding should be your first priority; you aren't helping your users if the system dies while you're root-causing. »
- Portée / limites : « restaurer d'abord » ne veut pas dire « effacer les traces ». Le chapitre 14 illustre aussi l'inverse : un retour arrière fait sans coordination, qui n'aide pas.
- En release : avant ou pendant le retour arrière, noter l'ID du déploiement fautif, l'heure et un extrait des journaux. Après un `pm2 restart` ou un `docker compose up`, les journaux en mémoire et l'état du processus sont perdus.

### Une mitigation générique ne sert que si elle existe, reste simple et a déjà été utilisée. Beaucoup de services croient avoir un retour arrière sûr et découvrent le contraire en pleine panne
- Niveau de preuve : N3 (texte d'une SRE de Google sur la pratique Google, publié avec O'Reilly)
- Source : Jennifer Mace, 15.12.2020, « Generic mitigations: A philosophy of duct-tape outage resolution », https://www.oreilly.com/content/generic-mitigations/
- Extrait lu : « The most important characteristic of a generic mitigation is this: You don't need to fully understand your outage to use it. » ; « Far too many think they have safe rollbacks, only to learn otherwise during an outage. » ; « Also? If you don't use them, they won't work. »
- Portée / limites : l'autrice reconnaît que le diagnostic reste nécessaire au niveau du type de panne : « you need to diagnose to the level of understanding the kind of failure scenario you're dealing with ». Elle cite aussi le « data rollback », distinct du retour arrière binaire.
- En release : avoir déjà exécuté au moins une fois, à froid, `vercel rollback` (ou le retour à l'image précédente) sur ce projet. Une commande jamais essayée n'est pas un plan de retour arrière.

### Tester les procédures de retour arrière avant d'en avoir besoin
- Niveau de preuve : N3
- Source : Corey Adam Baye, 2016, « Emergency Response » (Site Reliability Engineering, ch. 13), https://sre.google/sre-book/emergency-response/ ; Adrienne Walcer et al., 2023 (PDF daté du 21.10.2023 par ses métadonnées), « Lessons Learned from Two Decades of Site Reliability Engineering », https://sre.google/static/pdf/LessonsLearnedFromTwoDecades.pdf
- Extrait lu : ch. 13 : « Because we hadn't tested our rollback procedures in a test environment, these procedures were flawed, which lengthened the outage. » ; Lessons : « an outage is a terrible opportunity to try a risky load-shedding process for the first time. »
- Portée / limites : incidents internes de Google. Le même chapitre 13 montre un retour arrière de configuration lancé dans les cinq minutes qui a écourté une panne, avec ce constat : « Had this swift rollback not occurred, the outage could have lasted considerably longer ».
- En release : le retour arrière de la base (restauration PITR, script inverse) a-t-il déjà été répété sur une copie ?

### Choisir une mitigation dont le risque est proportionné à la gravité, et identifier son « gros bouton rouge » avant toute action risquée
- Niveau de preuve : N3
- Source : Walcer, Guliani, Ward, Hsiao, Stacey, 2023, « Lessons Learned from Two Decades of Site Reliability Engineering », https://sre.google/static/pdf/LessonsLearnedFromTwoDecades.pdf
- Extrait lu : « choose a mitigation path whose riskiness is appropriate for that severity » ; « it's important to identify what those big red buttons might be before you submit a potentially risky action » ; « Sometimes it is better to use an automated mitigation first and save the root-causing for after user impact has been avoided. »
- Portée / limites : enseignements tirés d'incidents YouTube et Calendar. Le document admet aussi qu'on peut, si tout est cassé, « bypass standard procedures » en connaissance de cause.
- En release : une restauration PITR en réponse à un bug d'affichage est disproportionnée. La question « quel est mon bouton rouge ? » se pose avant de déployer, pas après.

### Le fix-forward n'est pas une anomalie : sur 30 incidents analysés, il est un peu plus fréquent que le retour arrière, pour des raisons précises
- Niveau de preuve : N2 (qualitatif, petit échantillon : 30 incidents ; prépublication arXiv lue, évaluation par les pairs non vérifiée)
- Source : Jonathan Sillito, Esdras Kutomi, 2020, « Failures and Fixes: A Study of Software System Incident Response », https://arxiv.org/pdf/2008.11192
- Extrait lu : « Amongst incidents precipitated by a deployment, we found that deploying a fix was slightly more common than rolling back the deployment. » ; « (1) A rollback is a blunt tool […] (2) A rollback does not restore all aspects of the (persistent) state of the system » ; « With the benefit of hindsight, the responders wished they had rolled-back the change which "would have fixed it and given information about root cause." »
- Portée / limites : 15 entretiens et 15 rapports publics. L'étude décrit ce que font les équipes, pas ce qui fonctionne le mieux. Elle cite aussi un retour arrière abandonné parce qu'un cache corrompu faisait paraître l'ancienne version défaillante, et un retour arrière de configuration qui a produit une combinaison jamais testée.
- En release : si le déploiement contenait **un seul** changement, le retour arrière est sûr et instructif. S'il en groupait plusieurs, ou si l'état persistant a changé (cache, données), le retour arrière peut ne pas suffire.

### Dans une application web commerciale, environ un déploiement sur cinq a échoué, et le retour arrière était parfois impossible à cause de scripts de base déjà appliqués
- Niveau de preuve : N2 (SANER 2016, 320 déploiements analysés sur 345 sur environ 1,5 an, une seule entreprise)
- Source : Noureddine Kerzazi, Bram Adams, 2016, « Botched Releases: Do we Need to Roll Back? Empirical Study on a Commercial Web App », https://mcislab.github.io/publications/2016/saner_noureddine.pdf
- Extrait lu : « 77.5% (248 out of 320) of the releases were completed without problems, while 22.5% (72 out of 320) were botched. » ; « any changes to the database schema and/or contents made by the new version should be stored somehow until later on the rolled back features are re-enabled » ; dans le dialogue d'illustration de l'article : « Unfortunately, we cannot rollback because of the db scripts that already have been applied. »
- Portée / limites : un seul système e-commerce. Le dialogue est présenté par les auteurs comme une illustration, pas comme une mesure. L'étude constate que les différences entre environnements de production et de développement causent la majorité des crashs et des blocages, et que le code source domine pour les problèmes de performance (84 %).
- En release : une vérification « en local » ne couvre pas la principale cause de crash relevée ici, l'écart avec l'environnement de production. Une migration appliquée avant le code supprime l'option du retour arrière.

### Rendre chaque étape réversible : déploiement en deux phases (« Prepare » puis « Activate ») avec observation entre les deux, et vérifier que **chaque** serveur a reçu la phase 1
- Niveau de preuve : N3
- Source : Sandeep Pokkunuri (AWS), s.d., « Ensuring rollback safety during deployments » (Amazon Builders' Library), https://aws.amazon.com/builders-library/ensuring-rollback-safety-during-deployments/
- Extrait lu : « While each of the two phases is safe for rolling back, we can't roll back both changes. » ; « Therefore, we explicitly verify that all the servers have picked up the change in the Prepare phase. » ; « We call this time the bake period, and its duration is usually a few days. »
- Portée / limites : proche du parallel change (couvert ailleurs). L'apport propre ici est la **vérification explicite que le déploiement a pris partout** et la fenêtre de retour arrière limitée à une phase.
- En release : identifier jusqu'à quelle version on peut revenir sans casser les données écrites depuis.

### Trois sorties possibles quand le déploiement casse : revenir en arrière, corriger en avançant, ou redéployer la dernière configuration saine. Les changements de données compliquent les trois
- Niveau de preuve : N3
- Source : Microsoft, 2026, « Recommendations for safe deployment practices », https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/safe-deployments
- Extrait lu : « Rolling back changes, especially database, schema, or other stateful component changes, can be complex. Your SDP guidelines should provide clear instructions on how to deal with data changes » ; « rolling forward must be handled carefully to ensure that SDP isn't neglected and that the hotfix or other minimizing efforts are performed safely. »
- Portée / limites : Microsoft ne hiérarchise pas les trois options. La préférence pour le retour arrière vient de Google (entrée « On-Call » ci-dessus).
- En release : un fix-forward passe par les mêmes contrôles qu'un déploiement normal (build, prévisualisation, vérification), pas par un raccourci.

---

## 3. Outils de la plateforme par défaut

### Vercel Instant Rollback ne fait que repointer les domaines vers un ancien build : les variables d'environnement restent celles de ce build, les crons reviennent à cette version, et rien ne touche à la base
- Niveau de preuve : N3 (doc officielle, `last_updated: 2026-07-07`, lue le 10.11.2026)
- Source : Vercel, 2026, « Performing an Instant Rollback on a Deployment », https://vercel.com/docs/instant-rollback
- Extrait lu : « Vercel won't update environment variables if you change them in the project settings and will roll back to a previous build » ; « Vercel restores the cron job definitions associated with the target deployment » ; « A reminder about the changing behavior of external APIs, databases, and CMSes used in the current or previous deployments » ; « Hobby users can roll back to the immediately previous deployment. »
- Portée / limites : Pro et Enterprise peuvent revenir à tout déploiement déjà passé en production. Hobby est limité au déploiement précédent. Seul un déploiement qui a déjà servi la production est éligible, pas une prévisualisation.
- En release : un correctif de variable d'env fait après le build fautif **n'est pas** appliqué par le retour arrière. Une migration Supabase appliquée depuis reste en place sous l'ancien code.

### Après un Instant Rollback, Vercel désactive l'auto-assignation des domaines : les pushes suivants ne partent plus en production tant qu'on n'a pas « défait » le retour arrière
- Niveau de preuve : N3 (même doc, même date)
- Source : Vercel, 2026, « Performing an Instant Rollback on a Deployment », https://vercel.com/docs/instant-rollback
- Extrait lu : « After a rollback, Vercel turns off auto-assignment of production domains. This means new pushes to your production branch won't replace the rolled-back deployment. » ; « A rollback or a promotion reassigns your production domains in a background job that usually finishes within seconds » ; « A new rollback is rejected while a rollback or promotion is still in progress »
- Portée / limites : une tâche non terminée en 3 minutes est considérée comme périmée. L'état se lit dans l'API (`rollbackInfo=true`, `lastAliasRequest.jobStatus`).
- En release : après le correctif, un `git push` ne suffit pas. Il faut promouvoir explicitement (`vercel promote`), sans quoi le correctif paraît « déployé » sans être servi.

### Un retour arrière Vercel remet en service l'ancien `CRON_SECRET` de ce build, et un redéploiement de l'ancienne version ne le fait pas. La rétention limite jusqu'où on peut remonter
- Niveau de preuve : N3 (docs `last_updated: 2026-08-11` et `2026-09-16`)
- Source : Vercel, 2026, « Managing Cron Jobs », https://vercel.com/docs/cron-jobs/manage-cron-jobs ; Vercel, 2026, « Deployment retention », https://vercel.com/docs/deployment-retention
- Extrait lu : « Rolling back restores the target deployment's copy of `CRON_SECRET` along with its cron job definitions. » ; « Redeploying an older deployment won't bring its secret back. A redeploy builds a new deployment, which captures whatever your project settings hold now. » ; rétention : « Production deployments in state Ready | Last 3 | Last 20 » (Hobby | Pro et Enterprise)
- Portée / limites : distinguer « Instant Rollback » (pas de rebuild) et « Redeploy » (rebuild avec les réglages actuels). La différence est sémantique et pas seulement une question de vitesse. Le détail de la rotation des secrets est couvert ailleurs.
- En release : le plan de retour arrière doit préciser lequel des deux on fait, et vérifier que la cible n'a pas été supprimée par la rétention.

### Vercel Rolling Releases fournit un vrai canary simultané par paliers, mais seulement sur Pro (un projet) ou Enterprise, avec Skew Protection recommandée et une décision d'avancer ou d'annuler laissée à l'humain
- Niveau de preuve : N3 (doc `last_updated: 2026-09-15`)
- Source : Vercel, 2026, « Rolling Releases », https://vercel.com/docs/rolling-releases
- Extrait lu : « Vercel offers Rolling Releases on Pro and Enterprise. Pro teams can use Rolling Releases for one project. » ; « Vercel directs a configurable fraction of your visitors, for example, 5%, to the new deployment » ; « We highly recommend enabling Skew Protection with Rolling Releases. » ; « randomized assignment based on hashing may not achieve precisely the desired diversion rate, especially when the number of sessions is small. »
- Portée / limites : la doc décrit des métriques comparées (Speed Insights, onglet Observability) et un passage au palier suivant manuel ou après un délai configurable. Elle **ne décrit pas** d'annulation automatique sur seuil de métrique. Le paramètre `vcrrForceCanary=true` est accessible à tout le monde (« not securely hidden »). Pour des métriques externes, il faut propager l'ID de déploiement.
- En release : avec peu de sessions, le pourcentage réel diffère du pourcentage demandé. Juger sur les métriques **par déploiement**, pas sur l'agrégat.

### Promouvoir une prévisualisation en production la reconstruit avec les variables de production. Seule une production « staged » se promeut sans rebuild
- Niveau de preuve : N3 (doc `last_updated: 2026-06-26`) ; guide CLI (`last_updated: 2026-09-11`)
- Source : Vercel, 2026, « Promoting a deployment », https://vercel.com/docs/deployments/promoting-a-deployment ; Vercel, 2026, « Rollback a production deployment », https://vercel.com/docs/deployments/rollback-production-deployment
- Extrait lu : « Promote preview to production: You can use this as a way to promote a preview deployment to production through a complete rebuild » ; « You cannot use your preview environment variables in a production deployment » ; guide CLI : « When production is broken, restoring service is the priority. » suivi de « Confirm that the rollback resolved the issue by checking production logs again »
- Portée / limites : le guide officiel déroule l'ordre confirmer, revenir en arrière, vérifier, investiguer, corriger sur prévisualisation, puis livrer, avec les commandes exactes (`vercel rollback`, `vercel rollback status`, `vercel logs requests … --since 5m`). Il ne fixe aucun seuil.
- En release : une prévisualisation qui fonctionne ne prouve pas que la production fonctionnera (variables différentes, rebuild). La vérification post-déploiement porte sur la production réelle.

### Supabase : sauvegardes quotidiennes à partir du plan Pro seulement, PITR en option payante (RPO de 2 minutes au pire), restauration avec indisponibilité qui **remplace** l'état courant, objets Storage exclus
- Niveau de preuve : N3 (doc officielle lue le 10.11.2026, sans date de mise à jour affichée)
- Source : Supabase, 2026, « Database Backups », https://supabase.com/docs/guides/platform/backups
- Extrait lu : « We automatically back up all Pro, Team, and Enterprise Plan projects on a daily basis. » ; « Pro Plan projects can access the last 7 days of daily backups. » ; « We recommend that free tier plan projects regularly export their data » ; « Overall, in the worst case scenario, PITR achieves a Recovery Point Objective (RPO) of two minutes. » ; « Restoring to an earlier point in time replaces the current database state. » ; « The project is inaccessible during this process, so plan for downtime beforehand. » ; « Database backups do not include objects you store via the Storage API »
- Portée / limites : tarif PITR affiché : 7 jours de rétention pour « ~$100 » par mois (en plus du plan). Les mots de passe des rôles personnalisés ne sont pas dans les sauvegardes quotidiennes. Une restauration vers un nouveau projet est possible pour préserver les données courantes.
- En release : sur le plan Free, il n'y a pas de sauvegarde gérée, donc faire un `supabase db dump` avant une migration risquée. Revenir à un point antérieur efface les écritures légitimes faites depuis : c'est une mitigation lourde, pas un retour arrière de code.

### Les branches Supabase servent à tester une migration sur un environnement isolé, sans données par défaut et avec le schéma reconstruit depuis les migrations. `migration repair` ne défait aucun SQL
- Niveau de preuve : N3 (doc officielle lue le 10.11.2026)
- Source : Supabase, 2026, « Branching », https://supabase.com/docs/guides/deployment/branching ; Supabase, 2026, « Deploy database migrations », https://supabase.com/docs/guides/deployment/database-migrations
- Extrait lu : « By default, new branches do not start with any data or storage objects from your base project. » ; « The database schema isn't cloned. A GitHub-connected branch builds it from the migrations in your repository. » ; « `migration repair` updates the tracking table only — it does not apply or revert any SQL. »
- Portée / limites : facturation à l'usage (« A branch running on the default Micro Compute size starts at $0.01344 per hour », https://supabase.com/docs/guides/platform/manage-your-usage/branching). La disponibilité sur le plan Free est Non vérifiée. Une branche sans données ne reproduit pas les problèmes de données existantes.
- En release : une migration validée sur une branche vide n'a pas été validée contre les données de production. Supabase n'offre pas de « retour arrière de migration » : il faut écrire la migration inverse.

### `pm2 reload` ne garantit l'absence de coupure qu'en mode cluster, et redevient un `restart` classique si l'application ne se libère pas à temps
- Niveau de preuve : N3 (doc officielle PM2 lue le 10.11.2026)
- Source : PM2, s.d., « Cluster Mode », https://pm2.keymetrics.io/docs/usage/cluster-mode/ ; PM2, s.d., « Graceful Stop / Graceful Start », https://pm2.keymetrics.io/docs/usage/signals-clean-restart/
- Extrait lu : « As opposed to restart, which kills and restarts the process, reload achieves a 0-second-downtime reload. » ; « If the reload system hasn't managed to reload your application, a timeout will fallback to a classic restart. » ; « By default, PM2 wait 3000ms for the ready signal. »
- Portée / limites : la page de démarrage précise « 0s downtime reload (for NETWORKED apps) ». Le comportement de `reload` en mode fork n'est pas décrit dans les pages lues (Non vérifié). `wait_ready` et `process.send('ready')` permettent de ne déclarer le processus en ligne qu'une fois les connexions établies.
- En release : après `pm2 reload`, vérifier `pm2 ls` (redémarrages, uptime) et faire une vraie requête HTTP. Un fallback silencieux vers `restart` provoque une coupure qu'on n'avait pas prévue.

### Un HEALTHCHECK Docker produit un état (`starting`, `healthy`, `unhealthy`) mais Compose n'attend que l'état « running », sauf si on demande `service_healthy`. Les politiques de redémarrage réagissent à la sortie du conteneur
- Niveau de preuve : N3 (docs Docker lues le 10.11.2026)
- Source : Docker, s.d., « Dockerfile reference — HEALTHCHECK », https://docs.docker.com/reference/dockerfile/ ; Docker, s.d., « Control startup and shutdown order with Compose », https://docs.docker.com/compose/how-tos/startup-order/ ; Docker, s.d., « Start containers automatically », https://docs.docker.com/engine/containers/start-containers-automatically/
- Extrait lu : « It takes retries consecutive failures of the health check for the container to be considered unhealthy. » ; « On startup, Compose does not wait until a container is "ready", only until it's running. » ; « on-failure[:max-retries] Restart the container if it exits due to an error » ; « A restart policy only takes effect after a container starts successfully. In this case, starting successfully means that the container is up for at least 10 seconds »
- Portée / limites : valeurs par défaut lues : interval 30 s, timeout 30 s, retries 3, start-period 0 s. La doc lue ne dit pas qu'un conteneur `unhealthy` est redémarré automatiquement. Les politiques décrites se déclenchent sur une sortie. Le comportement sous Swarm n'a pas été lu.
- En release : « le conteneur tourne » ne veut pas dire « l'application répond ». Attendre `healthy` (`docker inspect`) et tester l'URL avant de déclarer le déploiement fait.

---

## 4. Feature flags : bénéfices, durée de vie, dette

### Les flags servent à désactiver vite une fonction défaillante, mais ils s'accumulent : sur 39 versions de Chrome, 2 409 toggles distincts, 72 % encore présents 5 versions plus tard, et seulement 20 % des release toggles effectivement retirés
- Niveau de preuve : N2 (MSR 2016 ; 39 versions de Chrome sur cinq ans, tableur de maintenance Google, 17 conférences et billets de praticiens)
- Source : Md Tajmilur Rahman, Louis-Philippe Querel, Peter C. Rigby, Bram Adams, 2016, « Feature Toggles: Practitioner Practices and a Case Study », https://users.encs.concordia.ca/~pcr/paper/Rahman2016MSR.pdf (DOI 10.1145/2901739.2901745)
- Extrait lu : « Across all 39 releases, a total of 2,409 distinct toggles have been used, 70% of which were removed at some point. » ; « On average 72% of the toggles survive 5 or more releases. » ; « only 51 (20% of all release toggles) had actually been removed, while 44 (17%) still lingered in the source code as technical debt. » ; « major bugs in new features can be quickly reverted on a web server without the need to revert, recompile, and deploy a new binary. »
- Portée / limites : application de bureau (Chrome) et non service web. Les auteurs le soulignent et appellent à d'autres études. Tous les toggles ne sont pas censés disparaître : il existe des toggles de développement et des toggles métier de long terme.
- En release : chaque flag ajouté pour un déploiement doit avoir un type (release, ops ou permanent) et, s'il est temporaire, une tâche de retrait.

### Un feature flag est temporaire par nature, à l'inverse d'une option de configuration. Il faut expliciter sa durée de vie et la condition qui le rendra obsolète
- Niveau de preuve : N2 (ICSE-SEIP 2020, revu par les pairs, mais **9 entretiens** seulement)
- Source : Jens Meinicke, Chu-Pan Wong, Bogdan Vasilescu, Christian Kästner, 2020, « Exploring Differences and Commonalities between Feature Flags and Configuration Options », https://par.nsf.gov/servlets/purl/10157116 (DOI 10.1145/3377813.3381366)
- Extrait lu : « Recommendation: Be explicit about the expected lifetime of a feature flag and the condition when it will become obsolete. » ; « removal of obsolete flags from the code and configurations was consistently identified as the key challenge for feature flags. »
- Portée / limites : il s'agit d'une recommandation des auteurs tirée d'entretiens, pas d'une mesure d'effet. Elle s'accorde avec les données Chrome ci-dessus.
- En release : la date de retrait seule ne suffit pas. Il faut aussi la **condition** (« retirer quand 100 % depuis 14 jours sans incident »).

### Les flags périmés ne disparaissent pas d'eux-mêmes : chez Uber, un outil a généré le nettoyage de 1 381 flags (17 % du total), et certains flags à 100 % restent des kill switches légitimes
- Niveau de preuve : N2 (ICSE-SEIP 2020, retour d'expérience industriel, déploiement de déc. 2017 à mai 2019)
- Source : Murali Krishna Ramanathan, Lazaro Clapp, Rajkishore Barik, Manu Sridharan, 2020, « Piranha: Reducing Feature Flag Debt at Uber », https://manu.sridharan.net/files/ICSE20-SEIP-Piranha.pdf (DOI 10.1145/3377813.3381350)
- Extrait lu : « generated code cleanup diffs for 1381 flags (17% of total flags), (b) 65% of the diffs landed without any changes » ; « certain flags are used as kill switches whose values can be modified for emergency purposes […] Therefore, even when flags are completely rolled out, they may not necessarily be stale. » ; « the flag owner may not necessarily cleanup the code because building newer features is usually better recognized and rewarded »
- Portée / limites : applications mobiles (Objective-C, Java, Swift). L'article distingue les flags « stale », « orphaned » et « forgotten ». Il cite Knight Capital avec des chiffres internes divergents (voir Mythes).
- En release : un flag à 100 % n'est pas forcément mort. Trancher entre retrait et conversion explicite en kill switch documenté.

### Ne jamais réutiliser un flag pour un autre usage, et vérifier que **chaque** serveur a reçu le nouveau code : chez Knight Capital, un flag réaffecté a réveillé un ancien code sur le seul serveur non mis à jour
- Niveau de preuve : N3 (ordonnance officielle de l'autorité américaine des marchés, constatations factuelles)
- Source : U.S. Securities and Exchange Commission, 16.10.2013, « In the Matter of Knight Capital Americas LLC », Release No. 70694, https://www.sec.gov/litigation/admin/2013/34-70694.pdf
- Extrait lu : « The new RLP code also repurposed a flag that was formerly used to activate the Power Peg code. » ; « one of Knight's technicians did not copy the new code to one of the eight SMARS computer servers. Knight did not have a second technician review this deployment » ; « orders sent with the repurposed flag to the eighth server triggered the defective Power Peg code » ; « Knight lost over $460 million »
- Portée / limites : l'incident cumule plusieurs causes : code mort laissé depuis 2003, pas de nouveau test après 2005, déploiement non vérifié, aucune procédure d'incident. Le flag n'en est qu'une.
- En release : un nouveau comportement reçoit un **nouveau** flag. Après un déploiement multi-instance (PM2 cluster, plusieurs conteneurs), vérifier la version servie par chaque instance.

### Distinguer les types de flags : un release toggle vit une à deux semaines, un kill switch ops ou un toggle de permission peut vivre des années. Tous ont un coût de portage
- Niveau de preuve : N4
- Source : Pete Hodgson, 09.10.2017, « Feature Toggles (aka Feature Flags) », https://martinfowler.com/articles/feature-toggles.html
- Extrait lu : « Release Toggles are transitionary by nature. They should generally not stick around much longer than a week or two » ; « it's not uncommon for systems to have a small number of long-lived "Kill Switches" » ; « Savvy teams view the Feature Toggles in their codebase as inventory which comes with a carrying cost » ; « Other teams put "expiration dates" on their toggles. Some go as far as creating "time bombs" »
- Portée / limites : avis d'expert, sans données. L'auteur cite Knight comme mise en garde. Il présente la séparation « [feature] release from [code] deployment » comme l'usage le plus courant des release toggles.
- En release : le flag qu'on ajoute est-il un release toggle (avec date) ou un kill switch assumé (permanent, documenté, testé dans les deux positions) ?

---

## 5. Critères de retour arrière pré-engagés et décision sous pression

### Fixer avant l'action les signaux et le plan B, puis traiter les critères comme des règles fermes et non comme des recommandations, car le biais de continuation pousse à poursuivre un plan dégradé
- Niveau de preuve : N4 (article de deux chercheurs de la NASA Ames dans le magazine de la Flight Safety Foundation, résumant une étude de 19 accidents aériens ; l'étude source n'a pas été lue)
- Source : Benjamin A. Berman, R. Key Dismukes, décembre 2006, « Pressing the Approach », Aviation Safety World, p. 28-33, https://flightsafety.org/asw/dec06/asw_dec06_p28-33.pdf
- Extrait lu : « plan continuation bias — a deep-rooted tendency of individuals to continue their original plan of action even when changing circumstances require a new plan » ; « One countermeasure is to analyze situations more explicitly […] explicitly stating the nature of the threat, the observable indications of the threat and the initial plan for dealing with the threat. » ; « they must be asked before snowballing workload limits the pilots' ability to think ahead » ; « publish, train and check those criteria as hard-and-fast rules rather than as guidelines. »
- Portée / limites : domaine aéronautique (approches non stabilisées). C'est une **analogie**, pas une preuve en exploitation logicielle. Le biais est relevé dans au moins 9 des 19 accidents. Aucune source équivalente propre au déploiement logiciel n'a été trouvée (voir Non vérifié).
- En release : écrire avant le déploiement « si X pendant Y, alors `vercel rollback <id>` ». Pendant l'incident, la question « et si mon hypothèse est fausse ? » a déjà sa réponse.

> Les autres appuis sur le pré-engagement sont dans les § 1 et 2 : seuils et durée d'observation automatisés (AWS), « define a notion of acceptable behavior » (Google, canary), bouton rouge identifié avant l'action risquée et procédures testées avant l'urgence (Google, Lessons Learned), critères d'accélération d'urgence définis d'avance (Microsoft).

---

## 6. Déployer n'est pas activer

### Séparer le lancement d'une fonction de la mise en production du binaire, et pouvoir désactiver une seule fonction sans redéployer
- Niveau de preuve : N3
- Source : Warner, Davidovič, 2018, « Canarying Releases », https://sre.google/workbook/canarying-releases/ ; Rhandeev Singh, Sebastian Kirsch, Vivek Rau, 2016, « Reliable Product Launches at Scale » (Site Reliability Engineering, ch. 27), https://sre.google/sre-book/reliable-product-launches/
- Extrait lu : « Feature flag or experiment frameworks like Gertrude, Feature, and PlanOut allow you to separate feature launches from binary releases. » ; ch. 27 : « Gradually increase to a larger but limited group of users, usually between 1 and 10 percent » et « Independently revert each such change immediately in the event of serious bugs or side effects »
- Portée / limites : il s'agit de frameworks internes de Google. La plage « 1 à 10 % » décrit leurs exigences, pas une norme.
- En release : si une fonction risquée et un correctif partent dans le même déploiement, un retour arrière défait les deux. Un flag permet de couper seulement la fonction.

### Un « dark launch » exécute la nouvelle logique serveur sur du trafic réel sans rien montrer, pour mesurer la charge avant d'allumer l'interface
- Niveau de preuve : N3
- Source : Eugene Letuchy (Facebook), 13.05.2008, « Facebook Chat », https://engineering.fb.com/2008/05/13/web/facebook-chat/ ; Facebook Engineering (auteur non affiché sur la page), 01.07.2009, « Hammering Usernames », https://engineering.fb.com/2009/07/01/web/hammering-usernames/
- Extrait lu : 2008 : « a "dark launch" period in which Facebook pages would make connections to the chat servers, query for presence information and simulate message sends without a single UI element drawn on the page. » ; 2009 : « a subset of user queries are routed to help us test, by making "silent" queries to the code that, on launch night, will have to absorb the traffic. »
- Portée / limites : vise la charge à très grande échelle. Pour un indépendant, l'intérêt tient surtout à valider une dépendance (requête Supabase, API tierce) en production sans exposition à l'utilisateur.
- En release : le code est en production mais la fonction est éteinte. Vérifier que le chemin « dark » n'écrit rien d'irréversible.

> **Complément (N4)** : Martin Fowler, 29.04.2020, « DarkLaunching », https://martinfowler.com/bliki/DarkLaunching.html. Extrait lu : « Dark launching a feature means taking a new or changed back-end behavior and calling it from existing users without the users being able to tell it's being called. » ; « I've heard people use "dark launch" to mean canary releases, or other variations on partial release strategies. » Fowler juge la technique mal adaptée aux fonctions déclenchées par un choix de l'utilisateur et renvoie alors au canary. Dans un plan de déploiement, écrire « dark launch (aucune UI) » ou « canary (X % des utilisateurs) » plutôt que le terme seul.

---

## Verdict sur les règles de l'agent

| Règle | Verdict | Motif sourcé |
|---|---|---|
| **Critères de rollback pré-engagés** : avant tout déploiement non trivial, écrire le signal, la fenêtre et la commande exacte ; décider à froid ; ne pas assouplir pendant l'incident. | **Soutenue en partie, à préciser** | *Soutenu (N3)* : AWS fixe d'avance l'alarme de retour arrière, la durée d'observation et un nombre minimal de requêtes (« wait for at least 100 requests »). Google demande de « define a notion of acceptable behavior » par métrique et d'identifier le « big red button » « before you submit a potentially risky action ». Le guide Vercel donne les commandes exactes. Mace : un outil de mitigation se construit et s'exerce avant. *Analogie (N4)* : Berman et Dismukes recommandent d'expliciter avant l'action les signes et le plan, et de traiter les critères comme « hard-and-fast rules ». *Convention sans preuve trouvée* : « ne s'assouplissent pas pendant l'incident ». Aucune source logicielle ne le dit. Microsoft et AWS prévoient plutôt une **dérogation encadrée et définie d'avance** (qui approuve, sur quels critères). *À préciser* : Google demande de réévaluer les seuils régulièrement, entre deux déploiements. À faible trafic, la fenêtre doit compter des requêtes et pas seulement des minutes (« a handful of queries doesn't provide a useful signal »). |
| **Découpler deploy et release** : flag pour toute feature risquée ; le flag a une date de retrait (un flag permanent est de la dette). | **Soutenue, avec une précision** | *Découplage soutenu (N3)* : Google (« separate feature launches from binary releases »), Facebook (« switch the gatekeeper off rather than revert »), Rahman 2016. *Date de retrait soutenue (N2)* : Meinicke 2020 recommande d'expliciter « expected lifetime » et « condition » ; données Chrome (20 % seulement des release toggles retirés) ; Piranha. *À préciser* : « un flag permanent est de la dette » est trop large. Les kill switches ops et les toggles de permission sont légitimement durables (Hodgson ; Piranha : « kill switches […] not necessarily be stale »). La bonne règle : chaque flag a un **type** et, s'il est temporaire, une date ou une condition de retrait ; un flag permanent est assumé, documenté et testé. « Pour toute feature risquée » reste une convention : les flags ont un coût de portage et de test (Hodgson), et Knight montre le risque d'un flag mal géré. |
| **Mode D** : signal atteint, retour arrière d'abord ; fix-forward seulement si le retour arrière est impossible ou si le fix est trivial ET vérifié localement. | **Soutenue ; exception à reformuler** | *Retour arrière d'abord soutenu (N3)* : « roll back, fix, and roll forward » plutôt que « roll forward, fix, and roll forward again » ; « even a "quick fix" needs time to be tested, built, and rolled out » (Google, On-Call) ; guide Vercel. *Contredit en partie* : « vérifié localement » ne suffit pas. Kerzazi et Adams (N2) attribuent la majorité des crashs et blocages aux écarts entre environnements de production et de développement, et Vercel reconstruit avec d'autres variables en production. Exiger plutôt « vérifié sur un déploiement de prévisualisation ou équivalent ». *À compléter* : (1) couper le flag est souvent la première option (Facebook) ; (2) le retour arrière peut être insuffisant ou dangereux : données corrompues (Google), cache persistant ou combinaison de configurations jamais testée (Sillito et Kutomi), retrait du nouveau code qui aggrave la panne (Knight, SEC) ; (3) le fix-forward est pratiqué un peu plus souvent que le retour arrière dans 30 incidents étudiés (N2, petit échantillon). Il reste légitime quand le déploiement groupait plusieurs changements ou a modifié l'état. |
| **Restaurer d'abord, comprendre ensuite.** | **Soutenue, avec deux précisions** | Google : « first stop the impact of an incident, and then find the root cause » ; « you only need to know the location of the root cause » ; Mace : « you want to understand your outage after it is mitigated ». *Précisions* : (1) **conserver les preuves** en restaurant (« Stop the bleeding, restore service, and preserve the evidence », SRE book ch. 14) ; (2) la mitigation doit être **proportionnée** (« riskiness is appropriate for that severity », Lessons Learned) : une restauration PITR, qui efface les écritures légitimes et provoque une indisponibilité, n'est pas une mitigation légère. |
| **Action prod à effet différé** (restart, superviseur, build d'image) : confirmer l'effet réel avant de déclarer déployé. | **Soutenue** | PM2 : un `reload` repasse en `restart` en cas de délai dépassé. Docker : Compose attend « running » et non « ready », et une politique de redémarrage ne s'applique qu'après 10 s de vie. Vercel : promotions et retours arrière sont des tâches de fond, `vercel rollback status` puis vérification des journaux est l'étape prescrite, et après un retour arrière les pushes ne partent plus en production. AWS : « we explicitly verify that all the servers have picked up the change ». Knight (SEC) : un serveur sur huit non mis à jour, sans seconde vérification. |

---

## Mythes et affirmations contestées

- **« Le retour arrière est toujours sûr. »** Contesté. Mace : « Far too many think they have safe rollbacks, only to learn otherwise during an outage. » Google, On-Call : « a rollback alone may be necessary but is not sufficient if the bug caused data corruption ». Knight (SEC) : désinstaller le nouveau code des sept serveurs sains « worsened the problem ». Sillito et Kutomi : un retour arrière de configuration a produit une combinaison jamais testée.
- **« Instant Rollback remet tout comme avant. »** Faux sur Vercel. Il repointe les domaines vers un ancien build avec **ses** variables d'env et **ses** crons (ancien `CRON_SECRET` compris), ne touche ni à la base ni aux API externes, et désactive l'auto-assignation des pushes suivants. À l'inverse, un « Redeploy » d'une ancienne version reprend les réglages **actuels**.
- **« Knight Capital : 465 M$ en 30 minutes à cause d'un feature flag. »** Chiffres incohérents dans la littérature. L'article Piranha écrit « 465M USD in 30 minutes » en introduction, puis « within 45 minutes […] more than 460M USD » plus loin. L'ordonnance de la SEC indique « approximately forty-five minutes » et « more than $460 million ». La cause est multiple : flag réaffecté, code mort, déploiement non vérifié sur un serveur, pas de revue, pas de procédure d'incident. Réduire l'incident au seul flag est inexact.
- **« Un blue/green est un canary. »** Pas tel quel. Google : en usage indépendant, il s'agit « effectively a before/after canary ». Il ne devient un canary A/B que si l'on répartit le trafic entre les deux environnements.
- **« On peut faire un canary sur n'importe quel volume. »** Contesté. Google : « a handful of queries doesn't provide a useful signal ». Vercel : la répartition par hachage est imprécise « especially when the number of sessions is small ».
- **« `pm2 reload` = zéro coupure. »** Seulement pour les applications réseau en mode cluster, et avec un repli silencieux vers `restart` en cas de délai dépassé (doc PM2).
- **« Le fix-forward est une mauvaise pratique. »** Trop absolu. Il est pratiqué un peu plus souvent que le retour arrière dans l'étude de Sillito et Kutomi (30 incidents), et Microsoft le liste parmi les sorties légitimes. Google le juge en général plus lent et plus risqué que le retour arrière. Le défaut documenté est de le faire **sans** les contrôles habituels.
- **« Un flag à 100 % est forcément à supprimer. »** Contesté par Piranha (kill switches) et Hodgson (toggles ops et de permission durables).
- **« Supabase sauvegarde tous les projets. »** Faux pour le plan Free : la doc recommande aux projets gratuits d'exporter eux-mêmes. Le PITR est une option payante des plans Pro et supérieurs, et les objets Storage ne sont pas inclus.

---

## Non vérifié

- **Études à grande échelle sur la fréquence et le taux de succès des retours arrière** (Meta, Microsoft) : aucune trouvée ni lue. Les seules données empiriques lues viennent de Kerzazi et Adams (une entreprise, 320 déploiements) et de Sillito et Kutomi (30 incidents, qualitatif). L'article de Microsoft « Gandalf » (NSDI 2020) n'a pas été lu.
- **« Canary Analysis Service »** (Davidovič, Beyer, ACM Queue 2018), cité par le PDF Lessons Learned : la page a renvoyé HTTP 403, rien n'en est cité.
- **Biais de décision sous pression en exploitation logicielle** : aucune source propre au domaine trouvée. Seule l'analogie aéronautique (Berman et Dismukes, 2006) a été lue. L'étude NASA sous-jacente (19 accidents, reprise dans un livre de 2007 selon des sources secondaires) n'a pas été lue.
- **Évaluation par les pairs de Sillito et Kutomi 2020** : seule la prépublication arXiv a été lue, la publication revue n'a pas été vérifiée.
- **Disponibilité des branches Supabase sur le plan Free** : non trouvée dans les pages lues.
- **Annulation automatique d'un Rolling Release Vercel sur seuil de métrique** : non décrite dans la doc lue. Seuls le passage manuel ou après délai et l'annulation manuelle (bouton ou Instant Rollback) le sont.
- **Comportement de `pm2 reload` en mode fork** : non décrit dans les pages PM2 lues.
- **Redémarrage automatique d'un conteneur `unhealthy`** : la doc Docker lue ne l'affirme pas (les politiques décrites se déclenchent sur une sortie). Le comportement sous Swarm n'a pas été lu.
- **Date et auteur exacts des articles de l'Amazon Builders' Library** : auteurs affichés (Clare Liguori ; Sandeep Pokkunuri, « Formerly written by »), date de publication non relevée.
- **Taille et durée « recommandées » d'un canary en chiffres universels** : aucune source ne les donne. Google refuse explicitement d'en fixer, et les durées d'AWS et de Microsoft concernent des systèmes multi-régions.

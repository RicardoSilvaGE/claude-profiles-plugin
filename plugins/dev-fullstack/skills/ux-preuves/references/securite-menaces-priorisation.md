# Fiche `ux-preuves` — Sécurité — menaces et priorisation

> Fiche du skill `ux-preuves` (dev-fullstack), volet **sécurité**, préchargé par `securite`. Couvre : OWASP Top 10:2025 et ses changements, CVSS v4.0 et ses limites, EPSS, catalogue CISA KEV, BOD 26-04 et SSVC, atteignabilité des vulnérabilités de dépendances, LINDDUN, arbres d'attaque et abuse cases, grilles de sévérité (Bugcrowd, OWASP Risk Rating).
> **Instantané de la recherche documentaire du 09 au 10.11.2026** (menée autour de minuit UTC) : chaque
> entrée cite une page réellement ouverte pendant cette recherche, avec un extrait lu. Classements, versions, avis de sécurité et textes réglementaires
> **vieillissent** ; le droit change par révision : avant d'en faire dépendre une décision,
> relire la page officielle (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Recherche documentaire pour l'agent « security engineer senior » du profil `dev-fullstack` (audit d'applications Next.js, Supabase/Postgres, Node, FastAPI, PWA ; rapport CRITIQUE / HAUT / MOYEN / FAIBLE).
Chaque entrée renvoie à une page ou un PDF **ouvert pendant la recherche** (WebFetch, ou curl + `pdftotext`). Quand seul un résumé a été lu, l'entrée le dit. Hors périmètre, car couverts ailleurs : API Top 10 2023, ASVS 5.0, STRIDE, Threat Modeling Manifesto, NIST 800-63B-4, mots de passe, JWT, CSRF/CORS/SSRF, XSS/CSP, Shai-Hulud, nLPD/RGPD.

Niveaux de preuve : N1 norme ou standard · N2 recherche revue par les pairs ou étude empirique à large échantillon · N3 guide officiel d'une institution · N4 avis d'expert, praticien ou éditeur.

---

## 1. OWASP Top 10:2025

### Prendre comme liste de référence le Top 10:2025, et non plus celui de 2021
- Niveau de preuve : N3
- Source : OWASP Top 10 Team, 2025, « OWASP Top 10:2025 », https://top10.owasp.org/2025
- Extrait lu : « Welcome to the OWASP Top 10:2025 Release. » Les dix catégories : A01 Broken Access Control · A02 Security Misconfiguration · A03 Software Supply Chain Failures · A04 Cryptographic Failures · A05 Injection · A06 Insecure Design · A07 Authentication Failures · A08 Software or Data Integrity Failures · A09 Security Logging and Alerting Failures · A10 Mishandling of Exceptional Conditions.
- Portée / limites : la page officielle ne donne pas de date de publication (pied de page « © Copyright 2021-2025 »). Des sources secondaires parlent d'une annonce en novembre 2025 et d'une version finale en janvier 2026, sans que je l'aie confirmé sur une page officielle (voir « Non vérifié »).
- En pratique : chaque constat du rapport cite son identifiant `Axx:2025`. Un constat SSRF se classe en A01:2025, plus dans une catégorie à part.

### Savoir ce qui a changé depuis 2021 : SSRF intégré à A01, A03 élargi à toute la chaîne d'approvisionnement, A10 nouveau
- Niveau de preuve : N3
- Source : OWASP Top 10 Team, 2025, « Introduction » (Top 10:2025), https://top10.owasp.org/2025/0x00_2025-Introduction
- Extrait lu : « There are two new categories and one consolidation in the Top Ten for 2025. » ; « Server-Side Request Forgery (SSRF) has been rolled into this category. » (A01) ; « A03:2025 - Software Supply Chain Failures is an expansion of A06:2021-Vulnerable and Outdated Components to include a broader scope of compromises occurring within or across the entire ecosystem of software dependencies, build systems, and distribution infrastructure. »
- Portée / limites : A07 et A09 changent légèrement de nom (« Authentication Failures » ; « Security Logging and Alerting Failures »). A02 Security Misconfiguration passe du 5ᵉ rang en 2021 au 2ᵉ.
- En pratique : A03 ne se limite plus aux « composants obsolètes ». Il couvre aussi le build (CI, actions GitHub), la publication et la distribution. L'audit d'un dépôt Next.js regarde donc le lockfile, mais aussi les workflows CI et les scripts `postinstall`.

### Traiter A03:2025 comme le risque que les praticiens placent en tête, et vérifier les trois conditions de vulnérabilité de la page
- Niveau de preuve : N3
- Source : OWASP Top 10 Team, 2025, « A03:2025 – Software Supply Chain Failures », https://top10.owasp.org/2025/A03_2025-Software_Supply_Chain_Failures/
- Extrait lu : « This was top-ranked in the Top 10 community survey with exactly 50% respondents ranking it #1. » ; vulnérable si « you do not scan for vulnerabilities regularly and subscribe to security bulletins related to the components you use » et si « you do not fix or upgrade the underlying platform, frameworks, and dependencies in a risk-based, timely fashion. »
- Portée / limites : la page se contredit sur son taux d'incidence (« 5.19% » dans le texte, 5,72 % dans le tableau). Elle signale aussi qu'« only 11 » CVE portent les CWE de la catégorie : celle-ci se mesure mal par les CVE.
- En pratique : demander s'il existe un scan régulier en CI, un abonnement aux avis de sécurité (Dependabot ou équivalent) et une politique de mise à jour fondée sur le risque.

### Chercher A10:2025 (conditions exceptionnelles) dans les chemins d'erreur : échec ouvert, message d'erreur bavard, transaction à moitié appliquée
- Niveau de preuve : N3
- Source : OWASP Top 10 Team, 2025, « A10:2025 – Mishandling of Exceptional Conditions », https://top10.owasp.org/2025/A10_2025-Mishandling_of_Exceptional_Conditions/
- Extrait lu : « Any time an application is unsure of its next instruction, an exceptional condition has been mishandled. » La page recommande d'annuler toute la transaction interrompue, « also known as failing closed ». CWE notables : CWE-209, CWE-234, CWE-274, CWE-476, CWE-636 (« Not Failing Securely ('Failing Open') »).
- Portée / limites : catégorie nouvelle, qui regroupe 24 CWE. La page ne donne pas d'échelle de sévérité propre.
- En pratique : vérifier qu'un `catch` sur la vérification d'authentification ou d'autorisation refuse l'accès au lieu de le laisser passer (middleware Next.js, dépendance FastAPI). Vérifier aussi que les erreurs Postgres et Supabase ne remontent pas telles quelles au client, et qu'une RPC multi-étapes tourne dans une transaction.

### Ne pas prendre le Top 10 pour une méthode d'audit : c'est un document de sensibilisation, un minimum
- Niveau de preuve : N3
- Source : OWASP Top 10 Team, 2025, « Establishing a Modern Application Security Program », https://top10.owasp.org/2025/0x03_2025-Establishing_a_Modern_Application_Security_Program/
- Extrait lu : « The OWASP Top 10 is primarily an awareness document. » ; « If you want to use the OWASP Top 10 as a coding or testing standard, know that it is the bare minimum and just a starting point. » ; « OWASP recommends you use the OWASP Application Security Verification Standard (ASVS) as a guide for setting the security requirements for your application(s). »
- Portée / limites : la même page recommande d'« Establish a common risk rating model with a consistent set of likelihood and impact factors ».
- En pratique : la méthode de l'agent vérifie selon l'ASVS (couvert ailleurs) et range ses constats dans le Top 10, sans en faire une check-list exhaustive.

### Ne pas lire le rang d'une catégorie comme sa fréquence dans l'application auditée : 8 catégories viennent des données et 2 d'un sondage
- Niveau de preuve : N3
- Source : OWASP Top 10 Team, 2025, « Introduction » (Top 10:2025), https://top10.owasp.org/2025/0x00_2025-Introduction
- Extrait lu : « The results in the data are largely limited to what the industry can test for in an automated fashion. » ; « Therefore, we only pick eight of the ten categories from the data because it's incomplete. The other two categories are from the Top 10 community survey. » ; « 589 CWEs in this edition to analyze in the dataset. »
- Portée / limites : la page dit aussi « We ranked 12 categories based on the data contributed, and allowed two to be promoted ». Les deux formulations ne coïncident pas tout à fait. Le classement agrège les données de plusieurs contributeurs et ne mesure pas un risque propre à une application.
- En pratique : ne jamais justifier une priorité par « c'est A01 donc c'est le plus grave ». La sévérité d'un constat se décide sur le cas lui-même (sections 2 à 8).

---

### Citer les dix catégories de 2025 par leur identifiant et leur nom exacts (veille, contrôle de clôture de la nuit du 09 au 10.11.2026)
- Niveau de preuve : N1 (classement de référence OWASP)
- Source : OWASP Top 10 Team, 2025, « OWASP Top 10:2025 », https://top10.owasp.org/2025/ (page relue au contrôle de clôture)
- Extrait lu : « A01:2025 - Broken Access Control », « A02:2025 - Security Misconfiguration », « A03:2025 - Software Supply Chain Failures », « A04:2025 - Cryptographic Failures », « A05:2025 - Injection », « A06:2025 - Insecure Design », « A07:2025 - Authentication Failures », « A08:2025 - Software or Data Integrity Failures », « A09:2025 - Security Logging and Alerting Failures », « A10:2025 - Mishandling of Exceptional Conditions ».
- Portée / limites : liste seule relue ; le détail de chaque catégorie est dans les entrées de cette fiche et sur la page de la catégorie.
- En pratique : un rapport qui cite « A05 Security Misconfiguration » ou « A06 Vulnerable Components » utilise la numérotation de 2021 : à corriger.

## 2. Sévérité : CVSS v4.0 et ses limites

### Présenter un score CVSS avec sa nomenclature (CVSS-B, BT, BE, BTE) et rappeler qu'un score de base mesure la sévérité, pas le risque
- Niveau de preuve : N1
- Source : FIRST CVSS SIG, 2023 (rév. 2024), « CVSS v4.0 User Guide », https://www.first.org/cvss/v4.0/user-guide ; et « CVSS v4.0 FAQ », https://www.first.org/cvss/v4-0/faq
- Extrait lu : « CVSS Base (CVSS-B) scores are designed to measure the severity of a vulnerability and should not be used alone to assess risk. » ; « This nomenclature should be used wherever a numerical CVSS value is displayed or communicated. » ; FAQ : « CVSS-B Base scores are not risk, and should not be used alone for patch prioritization. »
- Portée / limites : le User Guide précise que « the resulting CVSS-BTE score can be considered much closer to “Risk” », à condition d'enrichir le score avec les métriques Threat et Environmental. La NVD et les éditeurs ne publient en général que du CVSS-B.
- En pratique : dans le rapport, écrire « CVSS-B 4.0 : 8,7 (vecteur …) » et non « CVSS 8,7 ». Ne jamais déduire CRITIQUE d'un CVSS-B seul.

### Connaître l'échelle qualitative de CVSS v4.0 et sa date de publication (1er novembre 2023)
- Niveau de preuve : N1
- Source : FIRST CVSS SIG, 2023, « CVSS v4.0 Specification Document », https://www.first.org/cvss/v4.0/specification-document
- Extrait lu : historique du document : 2023-11-01, « Initial Publication » ; révision 1.2 du 2024-06-18. Échelle : None 0.0 · Low 0.1–3.9 · Medium 4.0–6.9 · High 7.0–8.9 · Critical 9.0–10.0. Et : « Consumers of CVSS should enrich the Base metrics with Threat and Environmental metric values specific to their use of the vulnerable system ».
- Portée / limites : c'est l'échelle de sévérité de CVSS. Elle ne définit pas les quatre niveaux du rapport de l'agent.
- En pratique : si l'agent rapproche ses niveaux de CVSS, CRITIQUE correspond à ≥ 9.0, HAUT à 7.0–8.9, MOYEN à 4.0–6.9, FAIBLE à 0.1–3.9. Il doit écrire que c'est une correspondance de convention.

### Se méfier de la reproductibilité d'un score CVSS : même des professionnels expérimentés le calculent avec plusieurs points d'écart
- Niveau de preuve : N3 (rapport technique d'institution, non revu par les pairs ; mis à jour ensuite dans IEEE S&P 2021, non lu)
- Source : Spring, Hatleback, Householder, Manion, Shick, déc. 2018, « Towards Improving CVSS », SEI/CMU, https://www.sei.cmu.edu/documents/574/2018_019_001_538372.pdf (fiche : https://www.sei.cmu.edu/library/towards-improving-cvss/)
- Extrait lu : « The Common Vulnerability Scoring System (CVSS) is widely misused for vulnerability prioritization and risk assessment, despite being designed to measure technical severity. Furthermore, the CVSS scoring algorithm is not justified, either formally or empirically. » ; « The most accurate 50% of security professionals surveyed mis-score vulnerabilities in a range of 2–4 points. »
- Portée / limites : le rapport porte sur CVSS v3.0. Le chiffre de 2 à 4 points vient d'une étude citée (Allodi et al., WEIS 2018), que je n'ai pas lue. Les auteurs ont ensuite conçu SSVC.
- En pratique : un score CVSS calculé par l'agent est une estimation. Il doit donner le vecteur, pour qu'un relecteur puisse le contester, et ne jamais présenter le score comme un fait.

### Ne pas corriger « parce que le CVSS est élevé » : sur données réelles, cette politique ne fait pas mieux que le hasard
- Niveau de preuve : N2 (NVD : 49 599 CVE ; 1 277 CVE exploitées dans la nature d'après Symantec)
- Source : Allodi, Massacci, 2014, « Comparing Vulnerability Severity and Exploits Using Case-Control Studies », ACM TISSEC 17(1), DOI 10.1145/2630069. Lu sur une copie tierce dont l'en-tête est conforme à l'ACM : https://typeset.io/pdf/comparing-vulnerability-severity-and-exploits-using-case-4gzqyjkudr.pdf (la page ACM renvoie 403)
- Extrait lu : « fixing a vulnerability just because it was assigned a high CVSS score is equivalent to randomly picking vulnerabilities to fix » ; « with ‘CVSS ≥ 6 + PoC’ a RR of 42% can be achieved » ; « The highest risk reduction (80%) is obtained by considering the existence of an exploit in the black markets. »
- Portée / limites : l'étude porte sur CVSS v2 et des données antérieures à 2014, côté postes de travail (exploit kits, Symantec). Elle ne porte ni sur CVSS v4 ni sur des applications web.
- En pratique : dans le tri des dépendances, l'existence d'un exploit public ou d'une exploitation constatée (KEV) pèse plus que le score CVSS.

### Savoir que les systèmes de score se contredisent sur les mêmes vulnérabilités
- Niveau de preuve : N2 (600 vulnérabilités du Patch Tuesday de Microsoft, avril à juillet 2024)
- Source : Koscinski, Nelson, Okutan, Falso, Mirakhorli, 2025, « Conflicting Scores, Confusing Signals: An Empirical Study of Vulnerability Scoring Systems », ACM CCS 2025, https://arxiv.org/pdf/2508.13644
- Extrait lu : « Our findings reveal significant disparities in how scoring systems rank the same vulnerabilities, with implications for organizations relying on these metrics to make data-driven, risk-based decisions. »
- Portée / limites : résumé seul lu, pas les chiffres détaillés. Le corpus est limité à Microsoft (CVSS, SSVC, EPSS, Exploitability Index).
- En pratique : quand deux sources donnent des priorités différentes (score de l'éditeur contre EPSS), l'agent signale le désaccord au lieu de choisir sans le dire.

---

## 3. Probabilité d'exploitation : EPSS, KEV, SSVC, BOD 26-04

### Utiliser EPSS pour la probabilité d'exploitation à 30 jours, jamais comme score de risque, et ne jamais le multiplier par un CVSS
- Niveau de preuve : N3
- Source : FIRST EPSS SIG, 2026, « EPSS – Frequently Asked Questions », https://www.first.org/epss/faq
- Extrait lu : EPSS « estimates the probability a vulnerability will be exploited in the wild within the next 30 days. » ; « EPSS is not a complete risk score. » ; « EPSS does not measure how much damage successful exploitation would cause, or whether it affects your environment. » ; « Multiplying EPSS by a CVSS score does not compute probability × severity and is never a good idea. »
- Portée / limites : EPSS ne note que des CVE publiées. La FAQ précise que « Work is underway » pour les identifiants réservés. Un avis GHSA sans CVE, fréquent sur npm, n'a donc pas de score EPSS.
- En pratique : pour une dépendance vulnérable, indiquer l'EPSS et son percentile à la date de l'audit, à côté de l'impact dans l'application. Ne jamais les combiner en une formule.

### Garder en tête le taux de base : seule une petite fraction des CVE est exploitée
- Niveau de preuve : N2 (chiffres publiés et datés) et N3 (FAQ FIRST)
- Source : FIRST EPSS SIG, 2026, https://www.first.org/epss/faq ; Jacobs, Romanosky, Edwards, Roytman, Adjerid, 2019/2021, « Exploit Prediction Scoring System (EPSS) », préprint https://arxiv.org/pdf/1908.04856 (publié dans Digital Threats: Research and Practice 2(3), 2021)
- Extrait lu : FAQ : « The CISA KEV catalog lists roughly 0.5% of published CVEs. » ; « In any 30-day window, through all of our data partners, EPSS is observed roughly 2.5-3% of published CVEs with exploitation activity. » Préprint EPSS v1 : « 921 observations of recorded exploitations used in the wild within the window of study. This represents an overall exploitation rate of 3.7% » (n = 25 159, juin 2016 à juin 2018, horizon de 12 mois).
- Portée / limites : les taux dépendent de la fenêtre de temps (30 jours ou 12 mois) et des capteurs des partenaires. Ils sous-estiment l'exploitation ciblée, que ces capteurs voient mal. L'article EPSS de 2023 avance « only 5% » en citant Jacobs et al. 2020.
- En pratique : une alerte de dépendance n'est pas une exploitation probable par défaut. Le rapport doit dire sur quoi repose l'urgence (KEV, exploit public, exposition).

### Préférer un signal d'exploitation à un seuil CVSS : à couverture égale, EPSS v3 demande environ 8 fois moins de corrections
- Niveau de preuve : N2 (modèle entraîné sur les CVE du 1er nov. 2021 au 31 oct. 2022)
- Source : Jacobs, Romanosky, Suciu, Edwards, Sarabi, 2023, « Enhancing Vulnerability Prioritization: Data-Driven Exploit Predictions with Community-Driven Insights », IEEE EuroS&PW 2023, https://arxiv.org/pdf/2302.14172
- Extrait lu : « Remediating CVEs rated as High or Critical with CVSS v3 gives a respectable level of coverage at 82.1%, but requires remediating 58.1% of published CVEs. On the other hand, EPSS v3 can achieve the same level of coverage but reduces the amount of effort from 58.1% to 7.3% of all CVEs » ; « CVSS v3.x base score has an AUC of 0.051 ».
- Portée / limites : les auteurs sont les concepteurs d'EPSS, et les données d'exploitation ne sont pas publiques (la FAQ le confirme : « the training data cannot be released »). Le résultat vaut pour l'ensemble des CVE, pas pour une application précise.
- En pratique : un CVSS « High » sur une dépendance npm, sans exploitation connue ni chemin atteignable, ne justifie pas à lui seul un HAUT dans le rapport.

### Citer la version d'EPSS en vigueur à la date du rapport (v5 en 2026, pas v4)
- Niveau de preuve : N4 (billet de l'éditeur qui entraîne le modèle) et N3 (page FIRST)
- Source : FIRST EPSS SIG, 2026, « EPSS Research », https://www.first.org/epss/research ; Empirical Security, 2026, « EPSS V5 Is Here », https://research.empiricalsecurity.com/research/epss-v5-is-here
- Extrait lu : FIRST : « many of the techniques are still used in Version 5 today. » Empirical Security : v4 « 0.514 » contre v5 « 0.633 » « on the same data », annoncé comme une amélioration de 23 %.
- Portée / limites : le billet est daté « Jun 15 » sans année (2026 par déduction, puisqu'il cite une mesure du 4 mai 2026). La métrique n'est pas nommée et le chiffre n'a pas été évalué de façon indépendante. Je n'ai pas trouvé d'annonce officielle de FIRST pour la v5.
- En pratique : écrire « EPSS (modèle en vigueur au JJ.MM.AAAA) » plutôt qu'un numéro de version appris par cœur.

### Traiter une vulnérabilité inscrite au KEV de la CISA comme prioritaire, quel que soit son EPSS
- Niveau de preuve : N3
- Source : CISA, 2026, « Known Exploited Vulnerabilities Catalog », https://www.cisa.gov/known-exploited-vulnerabilities ; FIRST, 2026, « Using EPSS », https://www.first.org/epss/using-epss
- Extrait lu : critères d'inscription : un CVE ID ; « There is reliable evidence that the vulnerability has been actively exploited in the wild. » ; une action corrective claire. « CISA strongly recommends all organizations review and monitor the KEV catalog ». FIRST : « a recent KEV addition is reasonable grounds to treat a vulnerability as high priority regardless of its EPSS score. »
- Portée / limites : le KEV n'inscrit que des vulnérabilités qui ont un correctif. Il est incomplet par construction : NIST CSWP 41 (Mell, Spring, 19 mai 2025, https://csrc.nist.gov/pubs/cswp/41/likely-exploited-vulnerabilities-a-proposed-metric/final) note que les listes KEV « may not be comprehensive » et qu'EPSS « has known inaccurate values ».
- En pratique : croiser chaque CVE de dépendance avec le KEV. Si elle y figure et que le code est atteignable, classer au moins HAUT.

### Savoir que la BOD 22-01 est révoquée : la BOD 26-04 du 10.06.2026 priorise selon l'exposition, le KEV, l'automatisabilité et l'impact technique
- Niveau de preuve : N1 (directive contraignante, mais seulement pour les agences fédérales civiles américaines)
- Source : CISA, 10.06.2026, « BOD 26-04: Prioritizing Security Updates Based on Risk », https://www.cisa.gov/news-events/directives/bod-26-04-prioritizing-security-updates-based-risk ; CISA, 03.11.2021, « BOD 22-01 », https://www.cisa.gov/news-events/directives/bod-22-01-reducing-significant-risk-known-exploited-vulnerabilities
- Extrait lu : sur la page de la BOD 22-01 : « This Directive has been revoked. It is superseded by » la BOD 26-04. Variables de la BOD 26-04 : « Is the vulnerable asset publicly exposed? » ; KEV ; « Is an adversary able to automate all the steps necessary to exploit the vulnerability? » ; « Does an adversary gain partial control or total control of the vulnerable asset after exploitation of the vulnerability? » Sa table de décision est « informed by the SSVC system ».
- Portée / limites : le tableau des délais est une image que je n'ai pas lue en entier. Seul le délai de « three days » figure dans le texte. Pour un indépendant suisse, ce n'est qu'un modèle. La FAQ CVSS de FIRST le présente comme « a model for other organizations to use or adapt ». Le CVSS n'est pas une variable de décision : la directive ne s'en sert que pour comparer sa notion d'impact technique.
- En pratique : pour chaque constat, l'agent pose les quatre questions : actif exposé publiquement ? KEV ? exploitation automatisable ? contrôle partiel ou total ? Ces réponses justifient mieux un CRITIQUE qu'un score.

### Utiliser l'arbre SSVC quand il faut une décision (suivre, surveiller, traiter, agir), pas un nombre
- Niveau de preuve : N3
- Source : CISA, s.d. (page consultée le 09.11.2026), « Stakeholder-Specific Vulnerability Categorization (SSVC) », https://www.cisa.gov/stakeholder-specific-vulnerability-categorization-ssvc
- Extrait lu : points de décision : « Exploitation status », « Technical impact », « Automatable », « Mission prevalence », « Public well-being impact ». Issues : Track (« The vulnerability does not require action at this time. »), Track*, Attend, Act (« attention from the organization's internal, supervisory-level and leadership-level individuals »).
- Portée / limites : l'arbre est fait pour des organisations. Pour un indépendant, « mission prevalence » et « public well-being » deviennent « l'application est-elle centrale pour le client ? » et « touche-t-elle des personnes : données personnelles, argent, mineurs ? ». Cette transposition est la mienne, pas celle de la CISA.
- En pratique : on peut lire les quatre niveaux du rapport comme Act, Attend, Track* et Track, et chaque constat dit quel point de décision le fait monter.

---

## 4. Atteignabilité et outils SCA (`npm audit`, `pip-audit`, `osv-scanner`)

### Écarter d'abord les dépendances qui ne partent pas en production
- Niveau de preuve : N2 (100 projets JavaScript qui utilisent npm)
- Source : Latendresse, Mujahid, Costa, Shihab, 2022, « Not All Dependencies are Equal: An Empirical Study on Production Dependencies in NPM », ASE 2022, https://arxiv.org/pdf/2207.14711
- Extrait lu : « less than 1% of the installed dependencies are released to production. » ; « 59% of the installed dependencies configured as runtime dependencies are not used in production, and 28.2% of the dependencies configured as development dependencies are used in production » ; « most security alerts target dependencies not used in production, making them highly unlikely to be a risk ».
- Portée / limites : l'étude porte surtout sur des projets front-end, où l'on voit ce qui finit dans le bundle. Pour un serveur Node, une dépendance d'exécution non bundlée tourne quand même. Et le classement `dependencies` / `devDependencies` n'est pas fiable dans les deux sens.
- En pratique : se demander si le paquet vulnérable finit dans le bundle client, dans le serveur, ou seulement dans l'outillage de build. Une dépendance de build compromise reste un risque de chaîne d'approvisionnement (A03) : ce n'est pas la même chose qu'une vulnérabilité à l'exécution.

### Compter les dépendances vulnérables qui comptent : environ 20 % ne sont pas déployées
- Niveau de preuve : N2 (200 bibliothèques Java, 10 905 GAV)
- Source : Pashchenko, Plate, Ponta, Sabetta, Massacci, 2018, « Vulnerable Open Source Dependencies: Counting Those That Matter », ESEM 2018, https://arxiv.org/pdf/1808.09753
- Extrait lu : « about 20% of the dependencies affected by a known vulnerability are not deployed, and therefore, they do not represent a danger to the analyzed library because they cannot be exploited in practice. » ; « The vast majority (81%) of vulnerable dependencies may be fixed by simply updating to a new version, while 1% [...] are halted ».
- Portée / limites : l'étude porte sur Java et Maven. « Non déployé » veut dire hors de l'artefact livré (portées test, provided), pas « code non atteignable ». Ce n'est donc pas une mesure de l'atteignabilité au niveau des appels.
- En pratique : la plupart des cas se règlent par une simple montée de version. Le rapport doit séparer « mise à jour triviale » et « paquet arrêté, il faut une autre mitigation ».

### Vérifier l'atteignabilité du code vulnérable, pas seulement la présence d'une version vulnérable
- Niveau de preuve : N2 (environ 500 applications SAP, plus de 250 000 scans)
- Source : Ponta, Plate, Sabetta, 2018, « Beyond Metadata: Code-centric and Usage-based Analysis of Known Vulnerabilities in Open-source Software », ICSME 2018, https://arxiv.org/pdf/1806.05893
- Extrait lu : l'approche « combines static and dynamic analysis to determine the reachability of the vulnerable portion of libraries used (directly or transitively) by an application. » ; « Vulnerable code was found reachable for 131 of them and we found that in 7.9% of the cases this was only determined by the combination of static and dynamic analysis. »
- Portée / limites : outil Java (Vulas, devenu Eclipse Steady ; l'extension de 2020 n'a pas été lue). Pour JavaScript et Python, avec du code dynamique, l'atteignabilité statique est moins sûre.
- En pratique : pour chaque CVE de dépendance, chercher l'appel à la fonction ou au module vulnérable (grep des imports et des usages) et se demander si une entrée contrôlée par l'attaquant y parvient. L'agent écrit « atteignable », « non atteignable » ou « non déterminé ». Il n'écrit jamais « non atteignable » sans avoir cherché.

### Savoir ce que fait `npm audit` : comparer des versions à des avis, sans analyse d'atteignabilité
- Niveau de preuve : N3
- Source : npm, Inc., 2026, « npm-audit » (CLI v11), https://docs.npmjs.com/cli/v11/commands/npm-audit
- Extrait lu : la commande « submits a description of the dependencies configured in your project to your default registry » et « asks for a report of known vulnerabilities » ; `--audit-level` « does not filter the report output, it simply changes the command's failure threshold. »
- Portée / limites : la documentation ne décrit aucune analyse des chemins de code. Avec `--omit=dev`, le Quick Audit « skips » les types de dépendances omis. `npm audit signatures` vérifie les signatures et les attestations de provenance.
- En pratique : lancer `npm audit --omit=dev` pour l'exécution, puis `npm audit` complet pour la chaîne de build, et `npm audit signatures`. Trier ensuite à la main, comme dans l'entrée précédente.

### Ne pas compter sur `osv-scanner` pour l'atteignabilité en JS ou en Python : son analyse d'appels ne couvre que Go et Rust
- Niveau de preuve : N3
- Source : Google OSV, 2026, « Project Source Scanning », https://google.github.io/osv-scanner/usage/scan-source
- Extrait lu : « By default, call analysis in Go is enabled » ; « Call analysis in Rust is still considered experimental. » ; « Running call analysis for Rust will execute build scripts (`build.rs`) in your dependencies as part of the compilation. » ; « This may execute arbitrary code. »
- Portée / limites : la page ne cite ni JavaScript ni Python. `pip-audit` n'a pas été vérifié.
- En pratique : pour Next.js, Node ou FastAPI, l'agent fait l'atteignabilité lui-même. Ne jamais lancer `--call-analysis=rust` sur un dépôt non fiable, puisque cela exécute du code des dépendances.

### Croiser au moins deux sources d'avis : les outils SCA ne trouvent pas les mêmes dépendances vulnérables
- Niveau de preuve : N2 (une étude de cas : 9 outils sur l'application OpenMRS)
- Source : Imtiaz, Thorn, Williams, 2021, « A Comparative Study of Vulnerability Reporting by Software Composition Analysis Tools », ESEM 2021, https://arxiv.org/pdf/2108.12078
- Extrait lu : « The count of reported vulnerable dependencies ranges from 17 to 332 for Maven and from 32 to 239 for npm projects across the studied tools. » ; « practitioners should not rely on any single tool at the present, as that can result in missing known vulnerabilities. »
- Portée / limites : une seule application, en 2021. Les bases d'avis (GHSA, OSV) ont convergé depuis, ce qui n'a pas été mesuré ici.
- En pratique : `npm audit` et `osv-scanner` sur le même lockfile, puis comparer les deux listes.

### Signaler une dépendance abandonnée selon une définition explicite, et la croiser avec le chemin sensible
- Niveau de preuve : N2 (28 100 paquets npm largement utilisés, fenêtre de 6 ans) et N3 (OpenSSF)
- Source : Miller, Jahanshahi, Mockus, Vasilescu, Kästner, 2025, « Understanding the Response to Open-Source Dependency Abandonment in the npm Ecosystem », ICSE 2025, https://cmustrudel.github.io/papers/icse2025abandonment.pdf ; OpenSSF, 2026, « Scorecard checks – Maintained », https://github.com/ossf/scorecard/blob/main/docs/checks.md
- Extrait lu : Miller et al. : « Conservatively, we look for 2+ years of regular maintenance [...] followed by 2 years with no activity from contributors representing the abandonment phase. » ; « 15% of widely-used packages becoming abandoned within our six-year observation window » ; « 18% of exposed projects remove the abandoned dependency ». Scorecard : « Risk: `High` (possibly unpatched vulnerabilities) » mais « A lack of active maintenance is not necessarily always a problem. »
- Portée / limites : « 2 ans sans activité » est une définition de recherche de l'abandon. Elle ne prouve pas qu'un paquet inactif cache plus de vulnérabilités. Les auteurs écartent aussi les paquets « feature complete ». La règle du profil parle de « release », alors que l'étude parle d'activité des contributeurs : ce n'est pas le même signal.
- En pratique : un constat d'abandon est FAIBLE par défaut. Il monte d'un cran si le paquet est sur un chemin sensible (authentification, parsing d'entrées, cryptographie) et qu'il n'existe pas d'alternative.

---

## 5. Secrets en clair

### Considérer comme compromis un secret valide qui a été poussé dans un dépôt partagé, même s'il est retiré ensuite
- Niveau de preuve : N2 (milliards de fichiers GitHub ; plus de 100 000 dépôts touchés)
- Source : Meli, McNiece, Reaves, 2019, « How Bad Can It Git? Characterizing Secret Leakage in Public GitHub Repositories », NDSS 2019, https://www.ndss-symposium.org/wp-content/uploads/2019/02/ndss2019_04B-3_Meli_paper.pdf
- Extrait lu : « thousands of new, unique secrets are leaked every day. » ; « 19% of the secrets were removed at some point in roughly 2 weeks [...] This also means 81% of the secrets we discover were not removed. » ; « the median time to discovery was 20 seconds » (pour leur propre collecteur).
- Portée / limites : l'étude porte sur des dépôts publics. Les 20 s mesurent leur outil, pas un attaquant. Un dépôt privé réduit l'exposition sans l'annuler (collaborateurs, forks, CI, sauvegardes).
- En pratique : chercher les secrets dans l'historique Git, pas seulement dans HEAD. Un secret retrouvé se révoque : le supprimer du code ne suffit pas.

### Révoquer d'abord, réécrire l'historique ensuite, et détecter avant le commit
- Niveau de preuve : N3
- Source : OWASP Cheat Sheet Series, 2026, « Secrets Management Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html
- Extrait lu : « Keys that were exposed should undergo immediate revocation. » ; « A new secret must be able to be quickly created and implemented. » ; détection pour « avoid checking secrets into code before commit/PR » ; réécrire l'historique « will break any other links to a given commit. »
- Portée / limites : guide général, sans échelle de sévérité.
- En pratique : la recommandation du rapport se donne dans cet ordre : révocation, rotation, nettoyage de l'historique, hook pre-commit.

### Ne pas compter comme secret une clé conçue pour être publique (Supabase publishable ou anon). La clé secrète ou `service_role` est CRITIQUE
- Niveau de preuve : N3 (documentation officielle de l'éditeur, sur son propre produit)
- Source : Supabase, 2026, « Understanding API keys », https://supabase.com/docs/guides/api/api-keys
- Extrait lu : clés publishable : « Safe to expose online: web page, mobile or desktop app, GitHub actions, CLIs, source code. » ; clé secrète : « Never put one in a browser, a shipped application, or source control. » ; « Policies never apply to a secret key, because `service_role` has the `BYPASSRLS` attribute. »
- Portée / limites : la clé publishable n'est sûre que si la RLS est correcte sur toutes les tables exposées. Le risque passe alors de la clé aux policies.
- En pratique : une clé publishable dans le bundle n'est pas un constat. Une clé `service_role` ou secrète dans le client, le dépôt ou un `NEXT_PUBLIC_*` est CRITIQUE (lecture et écriture de toute la base). Une table exposée sans RLS est un constat d'A01.

### Graduer un secret divulgué selon ce qu'il ouvre : actif public, actif interne, clé d'exemple ou invalide
- Niveau de preuve : N4 (taxonomie d'un éditeur de bug bounty, issue de ses programmes)
- Source : Bugcrowd, 2026, « Vulnerability Rating Taxonomy » (JSON, `release_date` 2026-07-08), https://raw.githubusercontent.com/bugcrowd/vulnerability-rating-taxonomy/master/vulnerability-rating-taxonomy.json ; page : https://bugcrowd.com/vulnerability-rating-taxonomy
- Extrait lu (valeurs du JSON) : « Disclosure of Secrets > For Publicly Accessible Asset » = P1 ; « For Internal Asset » = P3 ; « Intentionally Public, Sample or Invalid » = P5 ; « Pay-Per-Use Abuse » = P4.
- Portée / limites : c'est une priorité de base pour des chercheurs externes. Le README précise : « it’s possible that application complexity, bounty brief restrictions or unusual impact could result in a different rating. »
- En pratique : avant de classer, l'agent vérifie si le secret est valide, ce qu'il ouvre (production ou environnement local jetable) et qui peut le lire.

---

## 6. Modélisation de la vie privée : LINDDUN

### Ajouter LINDDUN à STRIDE dès que l'application traite des données personnelles : le modèle du système est le même
- Niveau de preuve : N3 (méthode académique publiée et maintenue par KU Leuven)
- Source : DistriNet, KU Leuven, 2026, « LINDDUN », https://linddun.org/ ; « Threat types », https://linddun.org/threat-types/
- Extrait lu : « LINDDUN is created by DistriNet Research Unit, KU Leuven. » Les sept catégories : Linking (« Associating data items or user actions to learn more about an individual or group. »), Identifying, Non-Repudiation, Detecting, Data Disclosure (« Excessively collecting, storing, processing or sharing personal data. »), Unawareness & Intervenability, Non-Compliance. Sur le lien avec STRIDE, la page dit que les deux modélisations « require the same system model as a starting point ».
- Portée / limites : il existe trois variantes : GO (allégée, sur cartes), PRO (systématique, part du DFD), MAESTRO (« More info coming soon »). La page d'accueil ne donne pas de numéro de version. Elle annonce « Enhanced LINDDUN GO ».
- En pratique : réutiliser le DFD du STRIDE et passer LINDDUN GO sur les flux de données personnelles, en cherchant par exemple une sur-collecte (Data Disclosure), des identifiants qui relient les sessions (Linking), ou l'absence d'export ou de suppression (Intervenability).

### Savoir que l'évaluation empirique de LINDDUN est encourageante mais ancienne et faite par ses auteurs
- Niveau de preuve : N2 (trois études empiriques ; résumé seul lu)
- Source : Wuyts, Scandariato, Joosen, 2014, « Empirical evaluation of a privacy-focused threat modeling methodology », Journal of Systems and Software 96, 122–138, https://tore.tuhh.de/handle/11420/14951
- Extrait lu : « This paper presents a series of three empirical studies that thoroughly evaluate LINDDUN from a multi-faceted perspective. » ; « The results are encouraging, overall. »
- Portée / limites : l'étude date de 2014 et porte sur la version de l'époque, pas sur GO ou PRO. Les évaluateurs sont les auteurs de la méthode. Résumé seul lu.
- En pratique : LINDDUN sert à ne rien oublier. Le rapport ne doit pas l'invoquer comme une garantie d'exhaustivité.

---

## 7. Arbres d'attaque et abuse cases

### Utiliser un arbre d'attaque (nœuds ET/OU) pour décomposer un objectif d'attaquant critique et trouver le chemin le moins cher
- Niveau de preuve : N4
- Source : Schneier, déc. 1999, « Attack Trees », Dr. Dobb's Journal, https://www.schneier.com/academic/archives/1999/12/attack_trees.html
- Extrait lu : « with the goal as the root node and different ways of achieving that goal as leaf nodes » ; « OR nodes are alternatives » ; « AND nodes represent different steps toward achieving the same goal. » ; « OR nodes have the value of their cheapest child; AND nodes have the value of the sum of their children. »
- Portée / limites : article de praticien, sans validation empirique. Des expériences comparant arbres d'attaque et misuse cases (Opdahl & Sindre 2009 ; Kárpáti et al. 2014, DOI 10.1016/j.infsof.2013.10.004 confirmé par Crossref) existent, mais je n'en ai pas lu le contenu (voir « Non vérifié »).
- En pratique : réserver l'arbre aux objectifs CRITIQUE, par exemple « lire les données d'un autre locataire » ou « débiter un paiement ». La feuille la moins chère de l'arbre sert à justifier la priorité.

### Ne pas présenter les abuse cases comme une pratique éprouvée : OWASP a archivé sa cheat sheet en les disant rarement utilisés
- Niveau de preuve : N3
- Source : OWASP Cheat Sheet Series, « Abuse Case Cheat Sheet » (archivée), https://cheatsheetseries.owasp.org/cheatsheets/Abuse_Case_Cheat_Sheet.html
- Extrait lu : « abuse cases are rarely used in practice » ; « In practice, the abuse case framework seems heavyweight and there are few published examples or success stories. » Définition : « A way to use a feature that was not expected by the implementer ».
- Portée / limites : la page ne cite aucune étude d'efficacité. Elle recommande de noter le risque « separately from any CVSS score ».
- En pratique : pour un indépendant, les abuse cases se réduisent à une question par fonctionnalité sensible : « comment détourner cette fonctionnalité sans exploiter de bug (énumération, abus de quota, parrainage, remboursement) ? » Il n'y a pas d'atelier de 4 heures.

---

## 8. Grilles de sévérité de rapport

### Ancrer la grille du rapport sur une taxonomie publique : XSS stocké vers tout utilisateur = HAUT, XSS réfléchi = MOYEN, RCE et SQLi = CRITIQUE
- Niveau de preuve : N4 (taxonomie d'éditeur, priorités de base issues des programmes Bugcrowd)
- Source : Bugcrowd, 2026, « Vulnerability Rating Taxonomy », JSON https://raw.githubusercontent.com/bugcrowd/vulnerability-rating-taxonomy/master/vulnerability-rating-taxonomy.json et README https://raw.githubusercontent.com/bugcrowd/vulnerability-rating-taxonomy/master/README.md ; page https://bugcrowd.com/vulnerability-rating-taxonomy (« Download JSON VRT 1.19 »)
- Extrait lu : README : « P1: Critical », « P2: High », « P3: Medium », « P4: Low », « P5: Informational » ; « Valid `Insecure Direct Object Reference` vulnerabilities can vary in priority from P4 to P1. » Valeurs du JSON : « Server-Side Injection > Remote Code Execution (RCE) » P1 ; « SQL Injection » P1 ; « Broken Authentication and Session Management > Authentication Bypass » P1 ; « XSS > Stored > Non-Privileged User to Anyone » P2 ; « XSS > Reflected > Non-Self » P3 ; « Using Components with Known Vulnerabilities > Unpatched Javascript Libraries » P5 ; « Lack of Security Headers > Content-Security-Policy » P5.
- Portée / limites : c'est une sévérité technique de base, pour des chercheurs externes, à moduler selon le contexte. Une bibliothèque non patchée est P5 tant qu'aucune exploitation n'est démontrée. HackerOne laisse ses programmes choisir CVSS 3.0, 3.1 ou 4.0 (« a standard implementation of [CVSS 3.1] and [CVSS 4.0] », https://docs.hackerone.com/en/articles/8495674-severity).
- En pratique : chaque constat du rapport peut citer l'entrée VRT équivalente comme point de départ, puis dire pourquoi le contexte le fait monter ou descendre.

### Si une grille vraisemblance × impact est utilisée, en expliciter les facteurs et faire primer l'impact métier
- Niveau de preuve : N3
- Source : OWASP, « OWASP Risk Rating Methodology », https://community.owasp.org/OWASP_Risk_Rating_Methodology
- Extrait lu : « Risk = Likelihood * Impact » ; facteurs de vraisemblance : agent de menace (Skill Level, Motive, Opportunity, Size) et vulnérabilité (Ease of Discovery, Ease of Exploit, Awareness, Intrusion Detection) ; impact : technique (C, I, A, Accountability) et métier (Financial, Reputation, Non-compliance, Privacy violation). Échelle de 0 à 9 : « 0 to <3 » LOW, « 3 to <6 » MEDIUM, « 6 to 9 » HIGH. Matrice : impact HIGH × vraisemblance HIGH = Critical ; LOW × LOW = Note. « Ultimately, the business impact is more important. » ; « The model above assumes that all the factors are equally important. »
- Portée / limites : la page reconnaît que la pondération du facteur Skill est débattue et renvoie à NIST 800-30. Les critiques des matrices (Cox 2008) sont couvertes ailleurs.
- En pratique : pour un indépendant, l'impact métier se résume à : données personnelles ou de mineurs ? argent ? disponibilité d'un service payé par le client ? Le rapport l'écrit en clair à côté du niveau.

---

## Verdict sur les règles du profil

| Règle du profil | Verdict | Motif sourcé |
|---|---|---|
| « Méthode (OWASP Top 10 2021) » avec la liste A01-A10 de 2021 | **Contredite (périmée)** | Le Top 10:2025 remplace celui de 2021. SSRF est « rolled into » A01, A03 devient « Software Supply Chain Failures », A10 « Mishandling of Exceptional Conditions » est nouvelle (top10.owasp.org/2025). Et le Top 10 est « primarily an awareness document » qui renvoie à l'ASVS pour les exigences : il ne doit pas tenir lieu de méthode. |
| « Threat modeling d'abord : actifs, acteurs, frontières de confiance passées au STRIDE ; profondeur proportionnée (ASVS L1 sans données sensibles, L2 pour données perso / argent / mineurs) » | **Soutenue sur le principe, à préciser** | STRIDE et ASVS sont couverts ailleurs. Il faut ajouter LINDDUN dès qu'il y a des données personnelles : même modèle du système, que STRIDE ne couvre pas (linddun.org ; évaluation encourageante, Wuyts 2014, résumé seul). Il faut aussi ajouter la question d'exposition publique, première variable de la BOD 26-04. |
| « Prioriser : CRITIQUE = exploitable à distance sans auth, ou compromet toute la data ; HAUT = auth standard + élévation, XSS stocké ; MOYEN = XSS reflété, info disclosure significative ; FAIBLE = durcissement » | **Convention cohérente avec les taxonomies publiques, à préciser** | Elle concorde avec la VRT de Bugcrowd (RCE et SQLi P1, XSS stocké vers tout utilisateur P2, XSS réfléchi non-self P3, en-têtes manquants P5). Elle omet en revanche des signaux d'urgence que les sources mettent au premier plan : exploitation constatée (KEV), exploitation automatisable, contrôle partiel ou total (BOD 26-04 ; SSVC). Et un XSS stocké n'est pas toujours HAUT : VRT donne P4 pour « Privileged User to No Privilege Elevation » et P5 pour « Self ». |
| « Toujours signaler les secrets en clair (même dev) comme HAUT minimum » | **À préciser (en partie contredite)** | Une clé conçue pour être publique (publishable ou anon de Supabase) n'est pas un secret. La VRT donne P5 à « Intentionally Public, Sample or Invalid » et P3 à un secret d'actif interne. À l'inverse, une clé `service_role` exposée est CRITIQUE (« bypasses Row Level Security »). Ce qui est fondé : un secret valide poussé dans Git doit être tenu pour compromis et révoqué (81 % jamais retirés, Meli 2019 ; « immediate revocation », OWASP). Règle proposée : un secret valide dans le dépôt ou l'historique vaut HAUT au minimum, CRITIQUE s'il ouvre la production ou contourne la RLS. Une valeur d'exemple ou invalide vaut FAIBLE. Une clé publique par conception n'est pas un constat. |
| « Supply chain : `npm audit` / `pip-audit` / osv passé et findings triés (atteignable ou non) ; une dépendance sans release depuis 2 ans sur un chemin sensible = finding » | **Tri par atteignabilité : soutenu. Seuil de 2 ans : convention sans preuve directe** | Atteignabilité : Latendresse 2022 (moins de 1 % des dépendances installées partent en production ; la plupart des alertes portent sur des dépendances hors production), Pashchenko 2018 (environ 20 % non déployées), Ponta 2018. Mais ni `npm audit` (pas d'analyse de chemins documentée) ni `osv-scanner` (analyse d'appels Go et Rust seulement) ne font ce tri en JS ou en Python : il est manuel. Les outils se contredisent (Imtiaz 2021), il faut donc en croiser deux. Les 2 ans reprennent l'opérationnalisation de recherche de Miller 2025 (« 2 years with no activity »), qui ne démontre aucun lien avec les vulnérabilités. OpenSSF Scorecard prend 90 jours et ajoute « not necessarily always a problem ». Mieux vaut parler d'activité que de release. |
| « Anti-hallucination : jamais de CVE, CVSS ou convention OWASP sans en être certain » | **Soutenue, à préciser** | Le score CVSS est mal reproductible, même par des professionnels (2 à 4 points d'écart, SEI 2018). FIRST exige la nomenclature CVSS-B/BT/BE/BTE. Les conventions changent : le profil lui-même citait le Top 10 2021 alors qu'il est remplacé, BOD 22-01 est révoquée depuis juin 2026, EPSS est passé en v5. À ajouter : toujours écrire le vecteur et la version (« CVSS-B 4.0 »), dater l'EPSS et le KEV, ne jamais calculer un CVSS de mémoire sans le vecteur. |

---

## Mythes et affirmations contestées

- **« Un CVSS élevé, ça se corrige en premier. »** Contesté. Allodi et Massacci (2014) trouvent que corriger sur un CVSS élevé revient à « randomly picking vulnerabilities to fix ». À couverture égale (environ 82 %), un seuil CVSS v3 High exige de corriger 58,1 % des CVE, contre 7,3 % avec EPSS v3 (Jacobs 2023). FIRST écrit lui-même « CVSS-B Base scores are not risk ».
- **« Risque = EPSS × CVSS. »** Faux selon FIRST : « Multiplying EPSS by a CVSS score [...] is never a good idea. »
- **« Le Top 10 OWASP est un standard d'audit. »** OWASP le décrit comme « primarily an awareness document » et « the bare minimum ».
- **« Le rang dans le Top 10 dit ce qui est le plus fréquent. »** Deux des dix catégories viennent d'un sondage, et les données se limitent à « what the industry can test for in an automated fashion ». La page A03 se contredit d'ailleurs sur son propre taux d'incidence (5,19 % contre 5,72 %).
- **« Une alerte `npm audit`, c'est une vulnérabilité de l'application. »** Contesté par Latendresse 2022 : la plupart des alertes portent sur des dépendances non utilisées en production.
- **« Pashchenko 2018 montre que 20 % des alertes SCA sont des faux positifs d'atteignabilité. »** Inexact : les 20 % sont des dépendances **non déployées** (portées test ou provided), pas du code non atteignable. L'atteignabilité au niveau des appels, c'est Ponta 2018.
- **« `osv-scanner` dit si la vulnérabilité est atteignable. »** Seulement en Go (par défaut) et en Rust (expérimental). Rien n'est documenté pour JS ou Python.
- **« La BOD 22-01 fixe la règle KEV de référence. »** Périmé : elle est révoquée et remplacée par la BOD 26-04 du 10.06.2026, qui reprend les critères KEV.
- **« EPSS v4 est la version actuelle. »** Périmé : FIRST parle de « Version 5 today » ; v5 annoncée par Empirical Security en 2026, date exacte non confirmée.
- **« La clé Supabase dans le code front est une fuite de secret. »** Faux pour la clé publishable ou anon (« Safe to expose online »). Vrai et CRITIQUE pour la clé secrète ou `service_role`.
- **« Supprimer le secret du dépôt règle le problème. »** Non : il faut révoquer d'abord (OWASP), et 81 % des secrets publiés restent en place (Meli 2019).
- **« Les abuse cases sont une pratique éprouvée. »** OWASP a archivé sa cheat sheet, avec « rarely used in practice » et « few published examples or success stories ».
- **« Une dépendance sans release depuis 2 ans est vulnérable. »** Rien ne le démontre. C'est une définition d'abandon tirée de la recherche, et des paquets « feature complete » peuvent légitimement ne plus bouger (Miller 2025 ; OpenSSF Scorecard).

---

## Non vérifié

- **Date de publication du Top 10:2025** : la page officielle n'en donne pas. Des sources secondaires (résultats de recherche, non ouverts) parlent d'une annonce en novembre 2025 à OWASP Global AppSec et d'une version finale en janvier 2026. Non vérifié.
- **EPSS v5** : date exacte (billet « Jun 15 » sans année ; un communiqué daté du 13 mai 2026 vu seulement dans les résultats de recherche) et absence d'annonce officielle de FIRST. La date de v4 (17.03.2025) n'apparaît que via un miroir de Wikipédia dans un résultat de recherche. Non vérifié.
- **BOD 26-04, tableau 1 (délais complets)** : c'est une image, non lue. Seul le délai de « three days » est confirmé dans le texte.
- **Arbres d'attaque contre misuse cases** (Opdahl & Sindre 2009, IST 51(5) ; Kárpáti, Redda, Opdahl, Sindre 2014, IST 56(3), DOI confirmé par Crossref) : contenu et résultats non lus. ScienceDirect renvoie 403 et l'hôte `bvbvf1.bib-bvb.de` n'est pas autorisé dans le réseau de la session. Les résultats rapportés (les arbres d'attaque trouvent plus de menaces) restent non vérifiés.
- **Koscinski et al. 2025** : résumé seul lu ; chiffres détaillés non vérifiés.
- **Wuyts et al. 2014 (LINDDUN)** : résumé seul lu.
- **Allodi & Massacci 2014** : lu sur une copie tierce (typeset.io) conforme à l'en-tête ACM. La version de l'éditeur n'a pas été ouverte (403).
- **Spring et al. 2021, « Time to Change the CVSS? »** (IEEE S&P 19(2)) et **Ponta et al. 2020** (Empirical Software Engineering, Eclipse Steady) : non ouverts.
- **`pip-audit`** : comportement (source des avis, atteignabilité) non vérifié.
- **Version de la VRT Bugcrowd** : la page affiche « 1.19 », le JSON a `release_date` 2026-07-08. Je n'ai pas vérifié que les deux correspondent à la même version.
- **Le chiffre « 2 à 4 points d'écart » des professionnels sur CVSS** vient d'Allodi et al., WEIS 2018, cité par le SEI. L'étude source n'a pas été lue.

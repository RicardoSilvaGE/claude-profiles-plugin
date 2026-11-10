# Fiche `ux-preuves` — Sécurité — efficacité mesurée des outils de détection

> Fiche du skill `ux-preuves` (dev-fullstack), volet **sécurité**, préchargé par `securite`. Couvre : analyse statique (C, Java, Python, Node.js), analyse des dépendances et divergence des outils, bases de vulnérabilités, détection de secrets (Meli 2019, Basak 2023), tests dynamiques et fuzzing d'API, revue de code humaine, combinaison des méthodes.
> **Instantané de la recherche documentaire du 09 au 10.11.2026** (menée autour de minuit UTC) : chaque
> entrée cite une page réellement ouverte pendant cette recherche, avec un extrait lu. Classements, versions, avis de sécurité et textes réglementaires
> **vieillissent** ; le droit change par révision : avant d'en faire dépendre une décision,
> relire la page officielle (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche documentaire du 9 novembre 2026, pour un agent « security engineer senior » qui audite des applications TypeScript/JavaScript et Python (Next.js, Node, FastAPI, Supabase).
> Chaque entrée vient d'une page ou d'un PDF réellement ouvert (WebFetch, ou curl + `pdftotext` pour les PDF). Quand seul le résumé a été lu, c'est écrit. Les rapports d'éditeurs sont classés N4.
> Hors périmètre (couvert ailleurs) : CWEval, BaxBench, Fu et al. 2025, Zahan 2023 (Scorecard), `npm ci` et lockfile.

## 1. Analyse statique (SAST)

### Ne jamais présenter un SAST « propre » comme une preuve d'absence de vulnérabilités : sur du code réel, les meilleurs outils en manquent la moitié ou plus, et les combiner ne suffit pas
- Niveau de preuve : N2 (6 analyseurs C, 27 projets réels, 1,15 million de lignes, 192 vulnérabilités issues de CVE)
- Source : Lipp, Banescu, Pretschner, 2022, « An Empirical Study on the Effectiveness of Static C Code Analyzers for Vulnerability Detection » (ISSTA '22), https://mediatum.ub.tum.de/doc/1659728/1659728.pdf
- Extrait lu : « our results indicate that state-of-the-art tools miss in-between 47% and 80% of the vulnerabilities in a benchmark set of real-world programs. Moreover, our study finds that this false negative rate can be reduced to 30% to 69% when combining the results of static analyzers, at the cost of 15 percentage points more functions flagged. »
- Portée / limites : C uniquement, vulnérabilités surtout mémoire ; les auteurs notent que les manques sont pires « beyond the classical memory-related security bugs ». Ne dit rien de JS/Python, mais le motif (synthétique ≠ réel) se retrouve dans les études Java, Node.js et Python ci-dessous.
- En pratique : demander « quels outils, quelle configuration, quelles règles ont tourné ? » et traiter le résultat comme une couverture partielle. Combiner deux analyseurs réduit les manques mais augmente le bruit : prévoir le temps de tri.

### Pour Java, les outils SAST gratuits détectent une petite minorité des vulnérabilités réelles, même combinés
- Niveau de preuve : N2 (7 outils retenus sur 161, benchmark réel construit par les auteurs) — **résumé seul lu**
- Source : Li, Chen, Fan et al., 2023, « Comparison and Evaluation on Static Application Security Testing (SAST) Tools for Java » (ESEC/FSE 2023), https://ink.library.smu.edu.sg/sis_research/8976
- Extrait lu : « our results indicate that only 12.7% of real-world vulnerabilities can be detected by the selected tools. Even combining the detection capability of all tools, most vulnerabilities (70.9%) remain undetected, especially those beyond resource control and insufficiently neutralized input/output vulnerabilities. »
- Portée / limites : Java, outils gratuits ou open source uniquement. Le PDF auteur annoncé (kaixuanli-ecnu.github.io) renvoie une 404 ; seul le résumé du dépôt institutionnel a été lu, donc pas de détail par outil.
- En pratique : ne pas compter sur le SAST pour les failles d'entrée/sortie mal neutralisées, alors que c'est la famille visée en premier (injection, XSS). La lecture manuelle des points d'entrée reste nécessaire.

### Pour Python, aucun outil SAST seul ne dépasse 40 % des vulnérabilités réelles ; tous agrégés, un tiers reste invisible
- Niveau de preuve : N2 (8 outils retenus sur 117, jeux synthétique et réel ; ICSE 2026) — **résumé seul lu** (page de la conférence)
- Source : Liu Zhuohang, Zhi Wang, Haotong Liu, Wanpeng Li et al., 2026, « An Empirical Study on Static Application Security Testing (SAST) Tools for Python », https://conf.researchr.org/details/icse-2026/icse-2026-research-track/30/An-Empirical-Study-on-Static-Application-Security-Testing-SAST-Tools-for-Python
- Extrait lu : « a single tool detects no more than 40% of the vulnerabilities in our real-world dataset » ; « Even when aggregating the outputs of all evaluated tools, only 66.7% of the real-world vulnerabilities are identified. »
- Portée / limites : la page ne donne pas les résultats par outil (Bandit, Semgrep, CodeQL…) ; pas de préprint arXiv trouvé. Ne dit pas quelles classes de failles FastAPI sont manquées.
- En pratique : sur un backend FastAPI, un Bandit ou Semgrep vert ne dispense pas de lire les dépendances d'authentification (`Depends`), les requêtes SQL brutes et les désérialisations.

### Sur du code Node.js, les failles du Top 10 OWASP échappent souvent à tous les outils, et la combinaison qui détecte le plus le paie d'une précision proche de zéro
- Niveau de preuve : N2 (9 outils sur 40 examinés, 957 vulnérabilités annotées à partir d'avis npm)
- Source : Brito, Ferreira, Monteiro, Lopes, Barros, Fragoso Santos, Santos, 2023, « Study of JavaScript Static Analysis Tools for Vulnerability Detection in Node.js Packages », https://arxiv.org/pdf/2301.05097
- Extrait lu : « many important vulnerabilities appearing in the OWASP Top-10 are not detected by any tool. The three best performing tools combined only detect up to 57.6% of all vulnerabilities in the dataset, but at a very low precision of 0.11%. » Et, dans le corps : « CodeQL detects 300 vulnerabilities (31.3%) and has a significantly higher precision (7.8%) » ; ESLint SSC a « the highest TPR (41.5%) » mais « the lowest precision (0.1%) ».
- Portée / limites : paquets npm (bibliothèques), pas des applications Next.js complètes ; versions d'outils de 2022. La publication dans IEEE Transactions on Reliability est indiquée par des notices bibliographiques, non vérifiée sur le site de l'éditeur.
- En pratique : préférer un outil précis (CodeQL) pour la passe obligatoire et réserver les outils bruyants à une exploration ciblée. Chaque alerte se confirme à la main avant d'entrer dans le rapport.

### En revue de code, un SAST aide à prioriser les fonctions modifiées, mais la plupart de ses alertes dans une fonction vulnérable n'ont rien à voir avec la faille
- Niveau de preuve : N2 (815 commits ayant introduit 319 vulnérabilités réelles, 92 projets C/C++)
- Source : Charoenwet, Thongtanunam, Pham, Treude, 2024, « An Empirical Study of Static Analysis Tools for Secure Code Review » (préprint arXiv), https://arxiv.org/pdf/2407.12241v1
- Extrait lu : « a single SAST can produce warnings in vulnerable functions of 52% of VCCs. […] Nevertheless, at least 76% of the warnings in vulnerable functions are irrelevant to the VCCs, and 22% of VCCs remain undetected due to limitations of SAST rules. » Combiner les outils atteint « 78% at the function level ».
- Portée / limites : C/C++ ; mesure « une alerte dans la fonction vulnérable », pas « la faille décrite ». Lieu de publication final non vérifié.
- En pratique : une alerte SAST sur la ligne modifiée invite à relire la fonction. Elle ne prouve pas que la faille est trouvée : décrire soi-même le chemin d'exploitation.

### Les faux positifs et la présentation des alertes freinent l'usage des outils d'analyse statique par les développeurs
- Niveau de preuve : N2 (20 entretiens de développeurs ; qualitatif) — **résumé seul lu**
- Source : Johnson, Song, Murphy-Hill, Bowdidge, 2013, « Why Don't Software Developers Use Static Analysis Tools to Find Bugs? » (ICSE 2013, p. 672-681), https://research.google/pubs/why-dont-software-developers-use-static-analysis-tools-to-find-bugs/
- Extrait lu : « We conducted interviews with 20 developers » ; « all of our participants felt that use is beneficial » ; « false positives and the way in which the warnings are presented, among other things, are barriers to use. »
- Portée / limites : outils de recherche de bugs en général (pas spécifiquement sécurité), petit échantillon qualitatif, 2013. Le PDF de l'auteur n'a pas pu être lu (erreur TLS puis HTTP 503) : aucune proportion chiffrée de faux positifs n'en est tirée.
- En pratique : un rapport d'audit qui recopie les sorties brutes d'un scanner reproduit exactement ce frein. Ne livrer que des constats triés et qualifiés.

## 2. Analyse des dépendances (SCA)

### Deux outils SCA sur le même projet ne rapportent pas les mêmes dépendances vulnérables : ne pas s'appuyer sur un seul outil
- Niveau de preuve : N2 (étude de cas : 9 outils SCA sur OpenMRS, projets Maven et npm)
- Source : Imtiaz, Thorn, Williams, 2021, « A comparative study of vulnerability reporting by software composition analysis tools » (ESEM '21), https://arxiv.org/pdf/2108.12078
- Extrait lu : « The count of reported vulnerable dependencies ranges from 17 to 332 for Maven and from 32 to 239 for npm projects across the studied tools. […] accuracy of the vulnerability database is a key differentiator for SCA tools. […] practitioners should not rely on any single tool at the present, as that can result in missing known vulnerabilities. »
- Portée / limites : une seule application ; outils et bases de 2020-2021 ; `npm audit` fait partie des outils comparés. Les écarts tiennent surtout aux bases de vulnérabilités et à la détection des dépendances.
- En pratique : croiser au moins deux sources (`npm audit` et `osv-scanner`, ou `pip-audit` sur PyPI et sur OSV). Toute divergence entre elles est à trier, pas à ignorer.

### La plupart des alertes SCA portent sur du code que l'application n'appelle pas, mais l'analyse d'atteignabilité a ses propres angles morts
- Niveau de preuve : N2 (même étude de cas, alertes analysées par Eclipse Steady et un outil commercial)
- Source : Imtiaz, Thorn, Williams, 2021, https://arxiv.org/pdf/2108.12078
- Extrait lu : « for 84.2% of the alerts, Steady did not find the corresponding dependency to be used by the dependent application. Further, Steady found only 2.1% of the alerts were potentially executable and 1.6% of the alerts were actually executed. […] for 11 alerts where dynamic analysis found the vulnerable code to be actually executed, static analysis did not find any part of the dependency containing the vulnerability to be in use at all. »
- Portée / limites : Java, graphe d'appels statique et traces de tests (couverture des tests d'environ 20 % selon les auteurs). Ne se transpose pas tel quel au JavaScript dynamique.
- En pratique : classer chaque constat en « atteignable démontré », « non atteint selon l'analyse » ou « non analysé ». Un « non atteint » est un signal de priorité, jamais une preuve d'absence de risque.

### Une part notable des dépendances vulnérables n'est pas déployée : compter celles qui comptent
- Niveau de preuve : N2 (200 bibliothèques Java open source parmi les plus utilisées par un éditeur, 10 905 versions distinctes)
- Source : Pashchenko, Plate, Ponta, Sabetta, Massacci, 2018, « Vulnerable Open Source Dependencies: Counting Those That Matter » (ESEM '18), https://arxiv.org/pdf/1808.09753
- Extrait lu : « We found that about 20% of the dependencies affected by a known vulnerability are not deployed, and therefore, they do not represent a danger to the analyzed library because they cannot be exploited in practice. […] The vast majority (81%) of vulnerable dependencies may be fixed by simply updating to a new version »
- Portée / limites : écosystème Maven, dépendances de test et de build. Pour npm, l'équivalent est la séparation `dependencies` / `devDependencies` ; la mesure ne porte pas sur npm.
- En pratique : distinguer ce qui part en production (bundle Next.js, image du serveur) de l'outillage de build. La plupart des corrections sont une simple montée de version : la proposer avant toute mitigation coûteuse.

### Le bruit de `npm audit` vient surtout des dépendances d'outillage de build, dont le scénario d'attaque n'a pas de sens
- Niveau de preuve : N4 (billet de praticien, mainteneur de React et Create React App)
- Source : Dan Abramov, 7 juillet 2021, « npm audit: Broken by Design », https://overreacted.io/npm-audit-broken-by-design/
- Extrait lu : « Today, `npm audit` is broken by design. » ; à propos d'un ReDoS signalé dans `browserslist` : « Verdict: this “vulnerability” is absurd in this context. »
- Portée / limites : vise les dépendances d'un outil de build front-end (Create React App), pas un serveur Node exposé. L'auteur n'a pas mesuré de taux de faux positifs : son constat porte sur les rapports qu'il a examinés.
- En pratique : pour chaque alerte, se demander si une entrée contrôlée par un attaquant atteint le paquet en production. Un ReDoS dans un parseur de configuration de build n'est pas un ReDoS sur une route d'API.

### `npm audit` interroge le registre sur l'arbre déclaré dans le lockfile ; on peut exclure les dépendances de développement et vérifier signatures et provenance
- Niveau de preuve : N3
- Source : npm, « npm-audit » (CLI v10), https://docs.npmjs.com/cli/v10/commands/npm-audit
- Extrait lu : `npm audit` « submits a description of the dependencies configured in your project to your default registry » ; avec `--omit`, « packages will be omitted from the submitted payload as appropriate » ; `npm audit signatures` vérifie les signatures du registre et les attestations de provenance.
- Portée / limites : la page ne dit pas quelles vulnérabilités sont pertinentes pour un projet ; `--audit-level` change le seuil d'échec, pas le contenu du rapport.
- En pratique : lancer `npm audit --omit=dev` pour la surface de production, puis un `npm audit` complet pour la chaîne de build et la CI. Ajouter `npm audit signatures`.

### `pip-audit` lit l'arbre des dépendances, pas le code : il ne dit pas si la fonction vulnérable est utilisée
- Niveau de preuve : N3
- Source : PyPA, README de `pip-audit`, https://github.com/pypa/pip-audit
- Extrait lu : « `pip-audit` is **not** a static code analyzer. It analyzes dependency trees, not code. » ; la page note que les flux de vulnérabilités « are not immune to extraneous or spam reports » et que « not all uses of a particular dependency map to all potential classes of vulnerabilities ». Service par défaut : PyPI (option `--vulnerability-service`, choix `osv`, `pypi`, `esms`).
- Portée / limites : les bibliothèques natives embarquées (non Python) ne sont pas couvertes de façon fiable. La page met aussi en garde : « If you wouldn't `pip install` it, you should not `pip audit` it. »
- En pratique : passer `pip-audit` deux fois (`pypi` puis `osv`) et justifier chaque `--ignore-vuln` par l'usage réel de la fonction concernée.

### L'analyse d'appels d'`osv-scanner` ne couvre que Go (et Rust en expérimental) ; le correctif guidé peut exécuter des scripts du projet
- Niveau de preuve : N3
- Source : Google, documentation OSV-Scanner, « Project Source Scanning », https://google.github.io/osv-scanner/usage/scan-source ; « Guided Remediation », https://google.github.io/osv-scanner/experimental/guided-remediation/
- Extrait lu : « By default, call analysis in Go is enabled » ; « Call analysis in Rust is still considered experimental. » ; et pour le correctif guidé : « Guided remediation (the `fix` command) can be risky when run on untrusted projects. »
- Portée / limites : la documentation ne mentionne aucune analyse d'appels pour JavaScript ni Python. Le correctif guidé couvre npm et Maven, pas pip, et se déclare expérimental.
- En pratique : sur une application TS/Python, `osv-scanner` donne une liste, pas une atteignabilité. Le tri se fait à la main. Ne pas lancer `osv-scanner fix` sur un dépôt audité non maîtrisé.

### Une alerte Dependabot ne naît que d'un avis relu par GitHub : les avis non relus, issus directement du NVD, ne déclenchent rien
- Niveau de preuve : N3
- Source : GitHub Docs, « About the GitHub Advisory Database », https://docs.github.com/en/code-security/security-advisories/working-with-global-security-advisories-from-the-github-advisory-database/about-the-github-advisory-database
- Extrait lu : « Unreviewed advisories are published automatically into the GitHub Advisory Database. » ; Dependabot alerte quand « a new GitHub-reviewed advisory reports a vulnerability » ; « Malware advisories are advisories about malicious open source packages. »
- Portée / limites : sources agrégées citées par la page : NVD, avis npm, PyPA, RustSec, Go Vulncheck, entre autres. La page précise que Dependabot ne regarde pas si un paquet vient d'un registre privé.
- En pratique : « aucune alerte Dependabot » ne veut pas dire « aucun avis ». Consulter aussi les avis non relus et les avis de logiciel malveillant pour les paquets sensibles (auth, crypto, client Supabase).

### Le NVD n'enrichit plus qu'en priorité certaines CVE : un outil qui dépend de lui seul voit des CVE sans versions ni scores ; OSV agrège d'autres sources
- Niveau de preuve : N3
- Source : NIST, page « National Vulnerability Database » (mises à jour datées), https://www.nist.gov/itl/nvd ; OSV, https://osv.dev/
- Extrait lu (NIST, 19 mars 2025) : « CVE submissions increased 32 percent in 2024 » et « the backlog is still growing » ; (15 avril 2026) : « Starting in early 2024, the NVD developed a significant backlog of unenriched CVEs. » ; les CVE en retard publiées avant le 1er mars 2026 passent en « Not Scheduled ». Priorités annoncées : CVE du catalogue KEV de la CISA, logiciels utilisés par le gouvernement fédéral, « critical software » au sens de l'Executive Order 14028. (OSV) : « This infrastructure serves as an aggregator of vulnerability databases that have adopted the OSV schema ».
- Portée / limites : la page NIST ne contient pas d'annonce datée de 2024 ; le ralentissement de 2024 n'y est cité que rétrospectivement. Les volumes de l'arriéré ne sont pas chiffrés sur la page.
- En pratique : préférer des outils alimentés par les bases d'écosystème (GitHub Advisory, PyPA, via OSV) à ceux qui s'appuient sur la seule correspondance CPE du NVD. Une CVE sans score NVD n'est pas une CVE bénigne.

### Le risque « composants vulnérables » est devenu en 2025 « Software Supply Chain Failures » (A03), élargi au-delà des vulnérabilités connues
- Niveau de preuve : N1 (OWASP Top 10, document de référence de sensibilisation)
- Source : OWASP, « OWASP Top 10:2025 », https://top10.owasp.org/2025 ; « A03:2025 – Software Supply Chain Failures », https://top10.owasp.org/2025/A03_2025-Software_Supply_Chain_Failures/
- Extrait lu : « A03:2025 - Software Supply Chain Failures » ; « A06:2025 - Insecure Design » ; « the risk has grown in scope to include all supply chain failures, not just ones involving known vulnerabilities. » Mesures : « Centrally generate and manage the Software Bill of Materials (SBOM) » ; « Only obtain components from official (trusted) sources over secure links. »
- Portée / limites : la page ne précise pas la date de publication ni le statut (finale ou candidate) ; elle ne mentionne pas explicitement l'ancien libellé A06:2021.
- En pratique : citer la nomenclature 2025 dans les rapports. A03 couvre aussi la compromission du build, des sources et des mises à jour, pas seulement `npm audit`.

### Les paquets malveillants s'exécutent surtout à l'installation et imitent le plus souvent un nom existant
- Niveau de preuve : N2 (174 paquets malveillants réels, npm, PyPI et RubyGems, novembre 2015 à novembre 2019)
- Source : Ohm, Plate, Sykosch, Meier, 2020, « Backstabber's Knife Collection: A Review of Open Source Software Supply Chain Attacks » (DIMVA 2020), https://arxiv.org/pdf/2005.09535
- Extrait lu : « It is apparent that most malicious packages (56%) start their routines on installation. » ; « most (61%) malicious packages mimic existing packages' names via typosquatting. […] the Levenshtein distance of an average typosquatting package to its target is 2.3 »
- Portée / limites : échantillon de 2015 à 2019, collecté à la main ; les techniques ont évolué depuis (comptes de mainteneurs compromis, par exemple).
- En pratique : pour tout ajout de dépendance, comparer le nom au paquet attendu (distance de 1 ou 2 caractères, portée `@org/`), regarder ses scripts `preinstall`, `install` et `postinstall`, son âge et son mainteneur. Aucun scanner de vulnérabilités connues ne fait cette vérification.

### `ignore-scripts` bloque les scripts de cycle de vie à l'installation, pas ceux qu'on lance explicitement
- Niveau de preuve : N3
- Source : npm, « config » (CLI v10), https://docs.npmjs.com/cli/v10/using-npm/config
- Extrait lu : « If true, npm does not run scripts specified in package.json files. » ; les commandes comme `npm test` ou `npm run-script` « will still run their intended script if `ignore-scripts` is set, but they will _not_ run any pre- or post-scripts. » Valeur par défaut : `false`.
- Portée / limites : documentation npm seulement ; ne dit rien de pnpm ni de yarn ; certains paquets légitimes ont besoin de leur script d'installation (binaires natifs).
- En pratique : vérifier si la CI installe avec `--ignore-scripts` et, sinon, quels paquets de l'arbre déclarent des scripts d'installation.

## 3. Détection de secrets

### Les fuites de secrets sur GitHub sont massives et durables : 81 % des secrets découverts n'étaient jamais retirés
- Niveau de preuve : N2 (près de six mois de commits publics en temps réel et un instantané de 13 % des dépôts publics ; clés privées et 11 plateformes d'API)
- Source : Meli, McNiece, Reaves, 2019, « How Bad Can It Git? Characterizing Secret Leakage in Public GitHub Repositories » (NDSS 2019), https://www.ndss-symposium.org/wp-content/uploads/2019/02/ndss2019_04B-3_Meli_paper.pdf
- Extrait lu : « secret leakage is pervasive — affecting over 100,000 repositories — but that thousands of new, unique secrets are leaked every day. » ; « 19% of the secrets were removed at some point in roughly 2 weeks, and most of those were done in the first 24 hours. This also means 81% of the secrets we discover were not removed. » ; temps de découverte par leur collecteur : « the median time to discovery was 20 seconds ».
- Portée / limites : dépôts publics, formats de clés distinctifs (détection conservatrice, donc sous-estimation) ; données de 2017-2018.
- En pratique : chercher les secrets dans tout l'historique Git, pas seulement dans la branche courante. Un secret poussé sur un dépôt public est compromis en quelques secondes.

### Réécrire l'historique ne protège pas un secret déjà poussé : il faut le révoquer
- Niveau de preuve : N2 (expérience des auteurs) + N3 (documentation GitHub)
- Source : Meli, McNiece, Reaves, 2019, https://www.ndss-symposium.org/wp-content/uploads/2019/02/ndss2019_04B-3_Meli_paper.pdf ; GitHub Docs, « About secret scanning », https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning
- Extrait lu (Meli) : « we discovered that even if commit histories are rewritten, secrets can still be recovered. […] we could recover the full contents of deleted commits from GitHub with only the commit's SHA-1 ID. » (GitHub) : retirer un secret de l'historique Git « is time-intensive and often unnecessary if you've already revoked the credential. »
- Portée / limites : le comportement de GitHub décrit par Meli date de 2018 ; non revérifié depuis.
- En pratique : face à un secret trouvé, la recommandation est d'abord rotation et révocation, puis contrôle des journaux d'usage. Le nettoyage d'historique vient après et ne suffit jamais seul.

### Aucun détecteur de secrets n'a à la fois une bonne précision et un bon rappel : Gitleaks a le meilleur rappel, l'outil de GitHub la meilleure précision mais un rappel très bas
- Niveau de preuve : N2 (9 outils, 5 open source et 4 propriétaires ; SecretBench, 818 dépôts, 97 479 secrets candidats étiquetés)
- Source : Basak, Cox, Reaves, Williams, 2023, « A Comparative Study of Software Secrets Reporting by Secret Detection Tools » (ESEM 2023), https://arxiv.org/pdf/2307.00714
- Extrait lu : « The top three tools based on precision are: GitHub Secret Scanner (75%), Gitleaks (46%), and Commercial X (25%), and based on recall are: Gitleaks (88%), SpectralOps (67%) and TruffleHog (52%). » ; « Though GitHub Secret Scanner is the top tool based on precision, the recall score is low (6%) » ; TruffleHog : « the precision is only 6% » ; « no current tool has the coveted high precision and high recall scores. »
- Portée / limites : configurations par défaut et versions de 2022 ; le rappel de GitHub reflète ses motifs de partenaires de l'époque (les motifs génériques et la détection par IA sont venus depuis). Les faux positifs viennent des expressions régulières génériques et du calcul d'entropie.
- En pratique : passer Gitleaks pour le rappel, trier ses sorties à la main, et s'appuyer sur la vérification active (TruffleHog `verified`, contrôles de validité GitHub) pour classer par gravité.

### Les détecteurs de secrets trouvent des secrets différents : en combiner deux
- Niveau de preuve : N2 (même étude)
- Source : Basak, Cox, Reaves, Williams, 2023, https://arxiv.org/pdf/2307.00714
- Extrait lu : « Gitleaks and TruffleHog outputs 1533 and 438 non-overlap unique TP secrets, respectively. […] our findings substantiate the necessity of not relying on a single tool to identify all the secrets present in a repository. »
- Portée / limites : recouvrement mesuré sur SecretBench, qui surreprésente certains types de fichiers ; les auteurs recommandent de choisir l'outil selon les types de secrets présents.
- En pratique : la règle « gitleaks/trufflehog » se lit comme « les deux », pas « l'un ou l'autre ». Ajouter des motifs propres à la pile (clés Supabase `service_role`, JWT secret, `DATABASE_URL`).

### La protection au push de GitHub bloque les secrets reconnus avant qu'ils n'entrent, mais toute personne qui a l'écriture peut la contourner en donnant un motif
- Niveau de preuve : N3
- Source : GitHub Docs, « About push protection », https://docs.github.com/en/code-security/secret-scanning/introduction/about-push-protection ; « Supported secret scanning patterns », https://docs.github.com/en/code-security/secret-scanning/introduction/supported-secret-scanning-patterns
- Extrait lu : par défaut, « anyone with write access to the repository can bypass push protection by specifying a bypass reason » ; un contournement motivé par « It's a false positive » crée une alerte close ; « Precision levels are estimated based on the pattern type's typical false positive rates. » Motifs Supabase listés : « Supabase OAuth Access Token », « Supabase Personal Access Token », « Supabase Secret Key ».
- Portée / limites : aucun taux de faux positifs publié ; la détection par IA des secrets non structurés (mots de passe) est en préversion publique. Il faut GitHub Secret Protection pour un dépôt privé.
- En pratique : vérifier que la protection au push est active, qui peut la contourner (contournement délégué), et relire les alertes closes comme « faux positif ».

### TruffleHog distingue les secrets vérifiés actifs des secrets non vérifiés, et sort les deux par défaut
- Niveau de preuve : N3
- Source : Truffle Security, README de TruffleHog, https://github.com/trufflesecurity/trufflehog
- Extrait lu : verified, « Credential confirmed as valid and active by API testing » ; unverified, « Credential detected but not confirmed valid (may be invalid, expired, or verification disabled) » ; pour `--results`, « Defaults to verified,unverified,unknown. »
- Portée / limites : la vérification appelle l'API du fournisseur, ce qui pose une question de périmètre en audit. La page annonce à la fois « over 700 » détecteurs avec vérification et « over 800 secret types ».
- En pratique : un secret « verified » est un incident à traiter tout de suite ; un « unverified » reste à qualifier, pas à écarter. Dans le rapport, dire si la vérification active était autorisée.

### Les rapports d'éditeur décrivent une hausse continue des secrets exposés et des secrets qui restent valides des années (chiffres d'éditeur)
- Niveau de preuve : N4 (éditeur d'outil de détection, non revu par des pairs)
- Source : Dwayne McDaniel pour GitGuardian, 2026, « The State of Secrets Sprawl 2026: AI Service Leaks Surge 81% and 29M Secrets Hit Public GitHub », https://dev.to/gitguardian/the-state-of-secrets-sprawl-2026-ai-service-leaks-surge-81-and-29m-secrets-hit-public-github-2bgj
- Extrait lu : « 28.65 million new hardcoded secrets were added to public GitHub commits in 2025 alone » ; « a 34% increase year over year » ; jeu de données 2022 retesté en janvier 2026 : « the validity rate was still above 64% » ; « Internal repos are roughly 6× more likely than public ones to contain hardcoded secrets » ; « About 28% of incidents originate entirely outside repositories, in places like Slack, Jira, and Confluence. »
- Portée / limites : méthode propriétaire non publiée ; rapport complet non lu (seulement le billet de l'éditeur) ; l'éditeur vend la détection. Donne des ordres de grandeur, pas des valeurs à opposer.
- En pratique : ne pas réserver la recherche de secrets au code. Fichiers `.env` d'exemple, configurations MCP, tickets et wikis du projet en font partie.

## 4. Tests dynamiques (DAST) et fuzzing d'API

### Les scanners boîte noire ratent l'autorisation, la logique métier et tout ce qui demande un compte ou plusieurs étapes
- Niveau de preuve : N2 (11 scanners commerciaux et open source, application vulnérable réaliste WackoPicko)
- Source : Doupé, Cova, Vigna, 2010, « Why Johnny Can't Pentest: An Analysis of Black-box Web Vulnerability Scanners » (DIMVA 2010), https://sites.cs.ucsb.edu/~vigna/publications/2010_doupe_cova_vigna_dimva10.pdf
- Extrait lu : « The parameter manipulation vulnerability was not discovered by any scanner. […] the scanner needs to determine which pages require a valid username/password to access and which ones do not and it is clear that none of the scanners make this determination. » ; « Logic Flaw: Another vulnerability that none of the scanners uncovered […] some domain knowledge about the application is needed to find the vulnerability. » Les étudiants au niveau moyen en sécurité « found all vulnerabilities except for the forceful browsing vulnerability ».
- Portée / limites : outils de 2010 sur une application PHP ; les scanners ont progressé sur l'exploration (crawl) et le JavaScript, mais aucune étude ouverte ici ne montre qu'ils détectent désormais les contrôles d'accès.
- En pratique : un rapport ZAP vert ne couvre ni l'IDOR, ni la RLS Supabase mal écrite, ni la logique métier. Ces points se testent avec deux comptes et un modèle de qui a le droit de voir quoi.

### Les générateurs de tests d'API REST couvrent peu le code : moins de 53 % des lignes pour le meilleur outil, avec accès au code
- Niveau de preuve : N2 (10 outils, 20 services REST réels open source)
- Source : Kim, Xin, Sinha, Orso, 2022, « Automated Test Generation for REST APIs: No Time to Rest Yet » (ISSTA 2022), https://arxiv.org/pdf/2204.08348
- Extrait lu : « In one hour, the best-performing tool (EvoMasterWB) achieved less than 53% line coverage, less than 37% branch coverage […] the best-performing tool among them is EvoMasterBB, with 45.41% line coverage, 28.21% branch coverage » ; deux limites communes : les valeurs contraintes et « satisfying dependencies among requests ».
- Portée / limites : services Java/Kotlin ; les « failures » comptées sont surtout des erreurs 500, pas des vulnérabilités qualifiées. RESTler et Schemathesis sont parmi les outils évalués.
- En pratique : un fuzzing d'API sans schéma OpenAPI exact, sans authentification fournie et sans enchaînement d'appels n'atteint pas la logique. Demander la couverture obtenue avant d'en tirer une conclusion.

### Les fuzzers d'API ne vérifient l'autorisation que si on leur fournit l'authentification et des vérifications dédiées
- Niveau de preuve : N3
- Source : Schemathesis, référence des vérifications, https://schemathesis.readthedocs.io/en/stable/reference/checks/ ; Microsoft, RESTler, « Checkers », https://github.com/microsoft/restler-fuzzer/blob/main/docs/user-guide/Checkers.md
- Extrait lu (Schemathesis) : `ignored_auth`, « Verifies authentication is properly enforced » ; `negative_data_rejection`, « Verifies the API properly rejects invalid input data » ; une catégorie Security contient `ignored_auth` et `object_level_authorization`. (RESTler) NameSpaceRuleChecker, « Detects that an unauthorized user can access service resources » ; UseAfterFreeChecker, « Detects that a deleted resource can still be accessed after deletion ».
- Portée / limites : RESTler prévient que le mode fuzz « may create outages in the service under test » ; il faut deux identités pour les vérifications d'autorisation. Aucune mesure d'efficacité de ces vérifications n'a été lue.
- En pratique : sur une API FastAPI ou des routes Next.js, lancer Schemathesis avec authentification et la vérification `object_level_authorization`. Ne jamais lancer en fuzz contre la production.

### ZAP est maintenu sous l'égide d'un éditeur depuis septembre 2024, sous licence Apache 2
- Niveau de preuve : N3 (blog officiel du projet)
- Source : ZAP, 24 septembre 2024, « ZAP has joined forces with Checkmarx », https://www.zaproxy.org/blog/2024-09-24-zap-has-joined-forces-with-checkmarx/
- Extrait lu : ZAP doit « stay licensed under Apache v2 » ; « ZAP will stay under the control of the ZAP Core Team » ; nouveau nom « ZAP by Checkmarx ».
- Portée / limites : l'éditeur a désormais une influence directe sur la feuille de route ; aucun chiffre d'efficacité ici ; statut en 2026 non revérifié.
- En pratique : ZAP reste un choix légitime pour une passe DAST de base (en-têtes, cookies, réflexions évidentes), dans les limites décrites par Doupé et al.

## 5. Revue de code humaine et sécurité

### Un relecteur seul trouve une minorité des failles, et l'expérience ne prédit pas son efficacité
- Niveau de preuve : N2 (30 développeurs web, application avec 7 vulnérabilités connues : XSS, CSRF, injection SQL)
- Source : Edmundson, Holtkamp, Rivera, Finifter, Mettler, Wagner, 2013, « An Empirical Study on the Effectiveness of Security Code Review » (ESSoS 2013), https://people.eecs.berkeley.edu/~daw/papers/coderev-essos13.pdf
- Extrait lu : « (1) none of the subjects found all confirmed vulnerabilities, (2) more experience does not necessarily mean that the reviewer will be more accurate or effective, and (3) reports of false vulnerabilities were significantly correlated with reports of valid vulnerabilities. » ; « The average number of correct vulnerabilities found was 2.33 » ; « only 17% of the reviewers found the lack of Cross-Site Request Forgery protection » ; « 10 reviewers have approximately an 80% chance of finding all vulnerabilities, 15 reviewers have approximately a 95% chance ».
- Portée / limites : petite application PHP, relecteurs recrutés en ligne, 2013. Les estimations sur 10 ou 15 relecteurs sont des simulations sur ce seul cas.
- En pratique : une revue de sécurité par une seule personne (ou un seul agent) est une couverture partielle. Les familles « absentes » (CSRF, contrôle manquant) sont les plus souvent oubliées : les passer en liste de contrôle explicite.

### Les développeurs ratent souvent une validation d'entrée manquante, même avertis qu'il y a une faille
- Niveau de preuve : N2 (expérience en ligne, 146 participants dont 105 avec au moins trois ans d'expérience professionnelle)
- Source : Braz, Fregnan, Çalikli, Bacchelli, 2021, « Why Don't Developers Detect Improper Input Validation? '; DROP TABLE Papers; -- » (ICSE 2021), https://arxiv.org/pdf/2102.06251
- Extrait lu : « the existence of a visible attack scenario facilitates the detection of IIV vulnerabilities and that a significant portion of developers who did not find the vulnerability initially could identify it when warned about its existence. Yet, a total of 60 participants could not detect the vulnerability even after the warning. »
- Portée / limites : un seul type de faille, en revue de code simulée.
- En pratique : partir d'un scénario d'attaque explicite (« un utilisateur non authentifié envoie X à la route Y ») améliore la détection. C'est un argument pour faire le modèle de menace avant la lecture.

### En revue de code, la sécurité n'est pas un réflexe spontané et les interactions entre parties du code et les bibliothèques tierces sont les points difficiles
- Niveau de preuve : N2 (10 entretiens et un questionnaire auprès de 182 praticiens ; déclaratif)
- Source : Braz, Bacchelli, 2022, « Software Security during Modern Code Review: The Developer's Perspective » (préprint arXiv, 2022), https://arxiv.org/pdf/2208.04261
- Extrait lu : « most developers do not immediately report to focus on security issues during code review. » ; « they have challenges with third-party libraries and to identify interactions between parts of code that could have security implications. Moreover, security may be disregarded during reviews due to developers' assumptions about the security dynamic of the application they develop. »
- Portée / limites : perceptions déclarées, pas une mesure de détection ; lieu de publication final non vérifié.
- En pratique : poser explicitement la question des frontières (client/serveur, `use server`, middleware, RLS). Ce sont les interactions que la relecture ligne à ligne laisse passer.

### Une couverture de revue plus large des pull requests va de pair avec moins de bugs de sécurité signalés (corrélation)
- Niveau de preuve : N2 (3 126 projets GitHub, 489 038 issues, 382 771 pull requests ; régression multiple)
- Source : Thompson, Wagner, 2017, « A Large-Scale Study of Modern Code Review and Security in Open Source Projects » (PROMISE 2017), https://people.eecs.berkeley.edu/~daw/papers/coderev-promise17.pdf
- Extrait lu : « we find evidence of a negative relationship between code review of pull requests and the number of security bugs reported in a project. »
- Portée / limites : étude observationnelle (relation, pas causalité), bugs de sécurité identifiés par classification des issues.
- En pratique : vérifier si les changements touchant à l'auth, aux règles RLS ou aux routes d'API passent bien par une revue. Une branche principale où l'on pousse sans revue est un constat de processus.

## 6. Combinaison des techniques

### Chaque technique trouve des vulnérabilités que les autres ratent ; le SAST en trouve le plus, l'exploration manuelle les plus graves
- Niveau de preuve : N2 (étude de cas : 4 techniques, SAST, DAST, test d'intrusion manuel systématique et exploratoire, appliquées à OpenMRS en Java ; réplication d'Austin et Williams)
- Source : Elder, Zahan, Shu, Metro, Kozarev, Menzies, Williams, 2022, « Do I really need all this work to find vulnerabilities? An empirical case study comparing vulnerability detection techniques on a Java application » (Empirical Software Engineering, préprint arXiv), https://arxiv.org/pdf/2208.01595
- Extrait lu : « We found the most vulnerabilities using SAST. However, EMPT found more severe vulnerabilities. With each technique, we found unique vulnerabilities not found using the other techniques. The efficiency of manual techniques (EMPT, SMPT) was comparable to or better than the efficiency of automated techniques (DAST, SAST) […] If the goal of an organization is to find “all” vulnerabilities in a project, they need to use as many techniques as their resources allow. » Sur l'étude d'origine : « relying on SAST alone would be insufficient since each technique found vulnerabilities not found by other techniques. »
- Portée / limites : une seule application ; les travaux d'Austin et Williams (2011, 2013) ne sont connus ici qu'à travers ce résumé (texte original non ouvert).
- En pratique : un audit qui se limite aux scanners rate la part la plus grave. Prévoir au minimum SAST, SCA et secrets, plus une exploration manuelle orientée par le modèle de menace sur auth, autorisation et logique métier.

### Un défaut de conception ne se trouve pas en scannant l'implémentation : le modèle de menace sert à viser ce qui compte
- Niveau de preuve : N1 (OWASP Top 10:2025)
- Source : OWASP, « A06:2025 – Insecure Design », https://top10.owasp.org/2025/A06_2025-Insecure_Design/
- Extrait lu : « A secure design can still have implementation defects leading to vulnerabilities that may be exploited. » ; « An insecure design cannot be fixed by a perfect implementation » ; « Use threat modeling for critical parts of the application such as authentication, access control ».
- Portée / limites : texte de recommandation, sans mesure. La preuve empirique indirecte vient de Doupé et al. (logique métier et contrôle d'accès hors de portée des scanners) et d'Elder et al. (gravité trouvée par l'exploration manuelle).
- En pratique : commencer l'audit par « qui sont les acteurs, quelles données, quelles frontières de confiance ». Les scanners viennent ensuite, et leurs résultats se trient au regard de ce modèle.

## Verdict sur les règles du profil

| Règle du profil | Verdict | Motif sourcé |
|---|---|---|
| « Scanner systématiquement : OWASP Top 10, secrets dans code (gitleaks/trufflehog), headers HTTP, cookies, dépendances + supply chain. » | **Soutenue en partie, à préciser** | Combiner plusieurs techniques est soutenu (Elder et al. 2022 : chaque technique trouve des failles uniques). Mais « scanner l'OWASP Top 10 » surestime les outils : beaucoup de failles du Top 10 ne sont détectées par aucun outil Node.js (Brito et al. 2023), et les scanners ratent contrôle d'accès et logique métier (Doupé et al. 2010). Pour les secrets, « gitleaks/trufflehog » doit se lire « les deux » : recouvrement partiel, aucun outil à la fois précis et complet (Basak et al. 2023), et il faut couvrir tout l'historique (Meli et al. 2019). Pour les en-têtes et cookies : aucune étude d'efficacité trouvée dans ce lot, donc convention. |
| « A06 Vulnerable Components — `npm audit` / `pip-audit`. » | **Contredite sur la nomenclature, à préciser sur le fond** | Dans l'OWASP Top 10:2025, A06 est « Insecure Design » ; le risque devient « A03:2025 – Software Supply Chain Failures », élargi au-delà des vulnérabilités connues (top10.owasp.org). Un seul outil SCA manque des vulnérabilités connues (Imtiaz et al. 2021) ; Dependabot ignore les avis non relus (GitHub Docs) ; le NVD a un arriéré d'enrichissement (NIST). Formulation proposée : « A03:2025 Supply Chain — `npm audit --omit=dev` + `osv-scanner` / `pip-audit` (PyPI et OSV), écarts entre outils triés ». |
| « Supply chain : `npm audit` / `pip-audit` / osv passé et findings triés (vulnérabilité atteignable ou non) ; méfiance sur les scripts `postinstall` ; typosquatting vérifié sur tout ajout manuel. » | **Soutenue** (avec une précision sur l'atteignabilité) | Le tri est justifié : 84,2 % des alertes portent sur une dépendance non utilisée selon Steady (Imtiaz et al. 2021) ; environ 20 % des dépendances vulnérables ne sont pas déployées (Pashchenko et al. 2018) ; bruit des dépendances de build (Abramov 2021, N4) ; `pip-audit` n'analyse pas le code. Scripts d'installation et typosquatting : 56 % des paquets malveillants agissent à l'installation, 61 % font du typosquatting (Ohm et al. 2020). Précision : l'analyse d'appels d'`osv-scanner` ne couvre ni JS ni Python, donc l'atteignabilité se juge à la main ; et elle a des faux négatifs (11 alertes exécutées mais jugées non utilisées par l'analyse statique, Imtiaz et al.). Écrire « non atteint selon l'analyse », jamais « non exploitable ». |
| « Ne jamais affirmer qu'un code est vulnérable sans avoir lu le chemin exact qui le rend exploitable. » | **Soutenue** | Précision des outils très basse : 0,11 % pour la meilleure combinaison Node.js, 7,8 % pour CodeQL (Brito et al. 2023) ; au moins 76 % des alertes SAST dans une fonction vulnérable n'ont pas de rapport avec la faille (Charoenwet et al. 2024) ; les relecteurs humains produisent aussi de faux signalements (Edmundson et al. 2013) ; les faux positifs freinent l'adoption (Johnson et al. 2013). Corollaire à ajouter : l'absence d'alerte ne prouve pas l'absence de faille (Lipp 2022, Li 2023, ICSE 2026 Python). |
| « Un scan sans modèle de menace trouve des vulnérabilités génériques et rate celles qui comptent. » | **Soutenue indirectement** (pas d'étude directe « avec ou sans modèle de menace ») | Les scanners ratent logique métier, contrôle d'accès et parcours authentifiés (Doupé et al. 2010) ; l'exploration manuelle trouve les failles les plus graves (Elder et al. 2022) ; un scénario d'attaque explicite améliore la détection humaine (Braz et al. 2021) ; OWASP A06:2025 recommande le modèle de menace pour l'authentification et le contrôle d'accès. Aucune étude n'a été trouvée qui compare directement un audit avec et sans modèle de menace. |

## Mythes et affirmations contestées

- **« Combiner tous les outils SAST donne une bonne couverture. »** Contredit : même agrégés, les outils laissent 70,9 % des vulnérabilités Java réelles (Li et al. 2023, résumé), 33,3 % des vulnérabilités Python réelles (ICSE 2026, résumé) et 30 à 69 % des vulnérabilités C (Lipp et al. 2022). La combinaison réduit les manques mais augmente fortement le bruit (précision 0,11 % chez Brito et al.).
- **« Les outils sont bons : ils obtiennent d'excellents scores sur les benchmarks. »** À préciser : Lipp, Li et l'étude Python d'ICSE 2026 constatent tous de bons résultats sur des cas synthétiques et un effondrement sur du code réel.
- **« `npm audit` à zéro veut dire des dépendances saines. »** Contredit : les outils SCA divergent fortement entre eux (Imtiaz et al. 2021) ; les paquets malveillants et le typosquatting ne sont visibles que si un avis existe (Ohm et al. 2020 ; avis de logiciel malveillant chez GitHub) ; le NVD n'enrichit plus toutes les CVE (NIST).
- **« `npm audit` ne sert à rien. »** Généralisation abusive du billet d'Abramov : son argument vise les dépendances d'outillage de build (Create React App), pas un serveur Node exposé. Il ne publie pas de taux de faux positifs mesuré.
- **« Non atteignable, donc pas exploitable. »** Contredit : chez Imtiaz et al., 11 alertes exécutées en dynamique n'étaient même pas vues comme utilisées par l'analyse statique, et les auteurs y voient « limitations to reachability analysis ».
- **« Réécrire l'historique Git suffit à éteindre une fuite de secret. »** Contredit (Meli et al. 2019 : commits supprimés récupérables par leur SHA-1 ; GitHub recommande la révocation).
- **« TruffleHog ne détecte que 25 % des secrets. »** Obsolète : ce chiffre vient de Meli et al. 2019, sur la version de 2018 basée sur l'entropie. En 2023, Basak et al. mesurent un rappel de 52 % (cas 2) avec 6 % de précision, et l'outil fait désormais de la vérification active.
- **« Un relecteur expérimenté trouve tout. »** Contredit : aucun des 30 relecteurs n'a trouvé les 7 failles, et l'expérience ne prédit pas l'efficacité (Edmundson et al. 2013).
- **« Un taux élevé de faux positifs mène à 100 % de faux négatifs, parce qu'on abandonne l'outil. »** Citation de Chess et McGraw reprise par Basak et al. 2023 ; texte original non ouvert. C'est une formule d'auteur, pas une mesure.
- **« La catégorie A06 de l'OWASP, ce sont les composants vulnérables. »** Vrai en 2021, faux en 2025 (A06:2025 = Insecure Design ; la chaîne d'approvisionnement passe en A03).

## Non vérifié

- **Austin et Williams 2011 (ESEM) et 2013 (Information and Software Technology)** : texte original non ouvert (ScienceDirect a répondu 403). Connus seulement par le résumé qu'en donnent Elder et al. 2022.
- **Johnson et al. 2013** : PDF de l'auteur inaccessible (certificat TLS de cs.gmu.edu non vérifiable, puis HTTP 503). Seul le résumé (Google Research) a été lu ; aucune proportion chiffrée.
- **Li et al. 2023 (Java)** : PDF auteur en 404, page ACM non lisible ; seul le résumé a été lu. Résultats par outil non vérifiés.
- **Étude Python ICSE 2026** : seul le résumé de la page de conférence a été lu. Résultats par outil (Bandit, Semgrep, CodeQL) non vérifiés ; aucun préprint trouvé.
- **Comparaison Bandit et Semgrep publiée par Semgrep (2021)** et **résultats EASE 2024 « Semgrep\* »** : seulement aperçus dans des résultats de recherche, non ouverts.
- **Taux de faux positifs de la protection au push et du secret scanning de GitHub** : la documentation n'en publie pas.
- **Efficacité mesurée de la vérification des en-têtes HTTP et cookies par les scanners** : aucune étude cherchée ni trouvée dans ce lot.
- **Statut 2026 de ZAP** au-delà de l'annonce du 24 septembre 2024 ; **date de publication finale de l'OWASP Top 10:2025** (absente de la page lue).
- **Rapport complet GitGuardian 2026** : seul le billet de l'éditeur a été lu ; méthode non publiée (N4). Le chiffre « 6× » des dépôts internes n'est pas vérifiable indépendamment.
- **Comportement actuel de GitHub** sur la récupération de commits supprimés par SHA-1 (constat de Meli et al. en 2018, non revérifié).
- **Lieux de publication finaux** de Charoenwet et al. 2024 et Braz et Bacchelli 2022 (seuls les préprints arXiv ont été lus) ; publication de Brito et al. dans IEEE Transactions on Reliability (indiquée par des notices, non vérifiée chez l'éditeur).
- **Efficacité de détection de vulnérabilités de Schemathesis et RESTler** : seules leurs listes de vérifications ont été lues. Kim et al. 2022 mesurent la couverture et les erreurs, pas des vulnérabilités qualifiées.

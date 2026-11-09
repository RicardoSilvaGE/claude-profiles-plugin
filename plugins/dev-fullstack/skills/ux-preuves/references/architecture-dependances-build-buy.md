# Fiche `ux-preuves` — Architecture — dépendances structurantes et construire, acheter ou ne rien construire

> Fiche du skill `ux-preuves` (dev-fullstack), volet **architecture**, préchargé par `architecte`. Couvre : truck factor et abandon de projets, OpenSSF Scorecard et Concise Guide, dépréciations et retard technique, licences et SBOM, Cyber Resilience Act, Data Act et coût de sortie, portabilité (Supabase, Vercel), réutilisation de composants et make-or-buy.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Normes, versions et textes réglementaires
> **vieillissent** ; le droit change par révision : avant d'en faire dépendre une décision,
> relire la page officielle (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche documentaire du 9 novembre 2026, pour l'agent « architecte logiciel senior » (cadrage d'auth, ORM, bibliothèque d'UI, state manager, base de données, hébergeur avant implémentation). Contexte : développeur indépendant en Suisse, applications web (Next.js, Supabase, Node, FastAPI), écosystèmes npm et PyPI.
>
> Méthode : chaque entrée vient d'une page ou d'un PDF réellement ouvert pendant cette recherche (WebFetch, ou curl puis `pdftotext`). Quand seul le résumé a été lu, c'est dit. Les textes européens ont été lus dans la version officielle servie par l'Office des publications (publications.europa.eu, ressource CELEX), car EUR-Lex refusait les requêtes automatisées : les URL EUR-Lex indiquées pointent vers le même acte.
>
> Déjà couvert ailleurs, donc non repris : Zimmermann et al. 2019, Shai-Hulud et debug@4.4.2, paquets hallucinés par les LLM, `npm ci` et lockfile.
>
> Le droit est cité pour ce qu'il dit. Savoir s'il s'applique à une application donnée relève d'un juriste.

---

## 1. Facteur bus (truck factor) et départ des mainteneurs

### Partir du principe qu'un projet open source populaire repose souvent sur une ou deux personnes, et le vérifier pour chaque dépendance structurante
- Niveau de preuve : N2 (133 projets GitHub populaires, validation auprès des développeurs de 67 systèmes)
- Source : Avelino, Passos, Hora, Valente, 2016, « A Novel Approach for Estimating Truck Factors », ICPC 2016, https://arxiv.org/abs/1604.06766
- Extrait lu : « the majority of our target systems (65%) have TF <= 2 »
- Portée / limites : le truck factor est estimé à partir de la paternité du code (« degree of authorship »), pas de la connaissance réelle. Les développeurs interrogés approuvent ou approuvent en partie la liste des auteurs principaux dans 84 % des réponses valides, mais l'estimation du TF lui-même seulement dans 53 %. L'échantillon de 2016 porte sur des dépôts GitHub très populaires, pas sur le registre npm ou PyPI entier.
- En pratique : combien de personnes ont réellement écrit le cœur de la bibliothèque, d'après l'historique git ? Si c'est une seule, quel est le plan si elle s'en va ?

### Traiter un truck factor de 1 comme le cas normal, et non comme une exception
- Niveau de preuve : N2 (1 932 projets GitHub populaires, enquête auprès de 33 nouveaux mainteneurs)
- Source : Avelino, Constantinou, Valente, Serebrenik, 2019, « On the abandonment and survival of open source projects: An empirical investigation », https://arxiv.org/abs/1906.08058 (PDF lu)
- Extrait lu : « In a sample of 1,932 projects, 57% have TF = 1 and 25% have TF = 2. »
- Portée / limites : dans le même échantillon, « 315 projects (16%) were abandoned and 128 of these projects (41%) survived because of new core developers ». Ici, « abandonné » veut dire que les développeurs du truck factor sont partis, pas que le projet est mort : 41 % ont repris vie. Les chiffres viennent de dépôts GitHub populaires de 2019. L'arXiv ne précise pas de lieu de publication (préprint).
- En pratique : la dépendance a-t-elle déjà survécu au départ d'un mainteneur ? Y a-t-il des contributeurs récents qui ont le droit de pousser ? La difficulté à obtenir ce droit est l'un des principaux freins à la reprise cités par l'étude.

### Mesurer la concentration des contributions avec une définition publique plutôt qu'à l'œil
- Niveau de preuve : N3 (métrique de CHAOSS, projet de la Linux Foundation)
- Source : CHAOSS, s.d., « Contributor Absence Factor », https://chaoss.community/kb/metric-contributor-absence-factor/
- Extrait lu : « identifying the smallest number of contributors responsible for 50% of total contributions »
- Portée / limites : la page précise : « This metric was previously called "Bus Factor." » Le seuil de 50 % est une convention. Une contribution n'est pas une connaissance. La page n'a pas de section dédiée aux limites.
- En pratique : quel est le plus petit nombre de contributeurs qui font 50 % des commits sur les 12 derniers mois ? Une valeur de 1 sur une dépendance d'auth ou d'ORM est un signal d'alerte.

### Préférer, à valeur égale, un projet porté par une organisation à un projet porté par un compte personnel
- Niveau de preuve : N2 (46 547 projets PyPI, régression de survie de Cox, entretiens avec des mainteneurs)
- Source : Valiev, Vasilescu, Herbsleb, 2018, « Ecosystem-Level Determinants of Sustained Activity in Open-Source Projects: A Case Study of the PyPI Ecosystem », ESEC/FSE 2018, https://cmustrudel.github.io/papers/fse18sustainability.pdf (PDF lu)
- Extrait lu : « Otherwise equal, such projects are 22% less likely to be become dormant »
- Portée / limites : cela concerne l'hébergement sous un compte d'organisation GitHub. L'effet de l'implication commerciale n'est pas celui que les auteurs attendaient (« Commercial involvement was expected to have a positive effect on sustainability […] but the models »…). La position dans le réseau de dépendances a aussi un effet, différent en début et en fin de vie du projet. Seul PyPI est étudié, avec des données de janvier 2018.
- En pratique : qui porte le projet (organisation, fondation, entreprise, individu) ? Existe-t-il un financement ou un employeur identifiable ?

---

## 2. Indicateurs de santé d'un projet

### Vérifier l'activité récente, une release dans les 12 derniers mois et la présence de plus d'un mainteneur avant d'adopter
- Niveau de preuve : N3 (guide de l'OpenSSF Best Practices Working Group)
- Source : OpenSSF Best Practices WG, version initiale 2023-11-21, publiée 2025-03-28, « Concise Guide for Evaluating Open Source Software », https://best.openssf.org/Concise-Guide-for-Evaluating-Open-Source-Software
- Extrait lu : « Verify the presence of more than one maintainer, ideally from different organizations. »
- Portée / limites : le guide demande aussi « Confirm that the last release was issued within the previous 12 months » et une activité significative dans les 12 derniers mois. C'est une liste de contrôle d'experts, sans validation empirique publiée de ses seuils. Le seuil de 12 mois est une convention.
- En pratique : dernier commit, dernière release, nombre de mainteneurs actifs, venus d'organisations différentes ou non.

### Commencer par se demander si la dépendance peut être évitée
- Niveau de preuve : N3
- Source : OpenSSF Best Practices WG, 2023-2025, « Concise Guide for Evaluating Open Source Software », https://best.openssf.org/Concise-Guide-for-Evaluating-Open-Source-Software
- Extrait lu : « Every new dependency increases the attack surface. »
- Portée / limites : la rubrique s'intitule « Necessity » : peut-on se passer de la dépendance en utilisant des composants déjà présents ? Le guide recommande aussi de regarder si elle tire des dépendances indirectes de production inutiles : « Every new dependency is a potential support problem or supply chain attack. »
- En pratique : la plateforme (Next.js, Supabase, la bibliothèque standard Node ou Python) fait-elle déjà le travail ? Combien de dépendances transitives la bibliothèque ajoute-t-elle (`npm ls --all`, `pipdeptree`) ?

### Lire OpenSSF Scorecard check par check, pas comme une note unique
- Niveau de preuve : N3 (documentation officielle de l'outil)
- Source : OpenSSF, s.d. (branche main consultée le 09.11.2026), « Scorecard checks » (docs/checks.md), https://github.com/ossf/scorecard/blob/main/docs/checks.md
- Extrait lu : « If there is at least one commit per week during the previous 90 days, the project receives the highest score. »
- Portée / limites : 20 checks, dont Maintained, Code-Review, Branch-Protection, Dangerous-Workflow, License, SBOM, Signed-Releases et Vulnerabilities (OSV). La documentation reconnaît elle-même ses limites : pour plusieurs checks, « A low score is therefore not a definitive indication that the project is at risk ». Signed-Releases « does not verify the signatures ». Maintained ne réussit que pour un projet GitHub de plus de 90 jours.
- En pratique : regarder Maintained, Code-Review, Vulnerabilities et License un par un. Une bibliothèque stable et terminée peut mal noter sur Maintained sans être abandonnée.

### Ne pas confondre « non maintenu selon Scorecard » avec « abandonné »
- Niveau de preuve : N2 (scores de 832 422 paquets npm et 191 483 paquets PyPI, revue manuelle d'échantillons)
- Source : Zahan, Kanakiya, Hambleton, Shohan, Williams, 2022-2023, « OpenSSF Scorecard: On the Path Toward Ecosystem-wide Automated Security Metrics », https://arxiv.org/abs/2208.03412 (PDF v4 lu ; la page arXiv cite le DOI 10.1109/MSEC.2023.3279773)
- Extrait lu : « more than 85% packages in npm and 75% PyPI packages were unmaintained in GitHub »
- Portée / limites : il s'agit du check Maintained (au moins un commit par semaine sur 90 jours), un critère très strict. Données du 9 mai 2022. L'article note aussi que seuls 68 % des paquets npm (contre 88 % sur PyPI) avaient une licence publiée dans le dépôt. Il relève des faux positifs et des biais de notation : un paquet avec une seule vulnérabilité exploitable obtient 9 sur Vulnerabilities, un paquet avec plus de 9 vulnérabilités non exploitables obtient 0.
- En pratique : un mauvais score Maintained appelle une vérification à la main (issues sans réponse ? PR ignorées ?), pas un rejet automatique.

### Ne pas prendre un score Scorecard agrégé élevé pour la preuve de moins de vulnérabilités
- Niveau de preuve : N2 (modèles construits sur les scores de 767 389 paquets npm et 191 158 PyPI, dont 2 422 avec vulnérabilités signalées)
- Source : Zahan, Shohan, Harris, Williams, 2022-2023, « Do Software Security Practices Yield Fewer Vulnerabilities? », https://arxiv.org/abs/2210.14884 (PDF v2 lu)
- Extrait lu : « we had low R2 (ranging from 9% to 12%) »
- Portée / limites : la suite du résumé dit : « the number of reported vulnerabilities increased rather than reduced as the aggregate security score of the packages increased ». Les auteurs l'attribuent à d'autres facteurs, comme la rareté des données de vulnérabilité ou le fait que les projets populaires sont davantage examinés. C'est un préprint sans lieu de publication indiqué sur arXiv. Les pratiques les plus influentes dans leurs modèles sont Maintained, Code Review, Branch Protection et Security Policy.
- En pratique : Scorecard sert à documenter des pratiques, pas à prédire le risque. Un comparatif de deux bibliothèques ne se tranche pas sur l'écart de score agrégé.

### Consulter deps.dev pour le graphe complet des dépendances et les avis de sécurité
- Niveau de preuve : N3 (documentation officielle du service Open Source Insights)
- Source : Google Open Source Insights, s.d., « deps.dev documentation », https://docs.deps.dev/
- Extrait lu : « currently indexes the Cargo, Go, Maven, npm, NuGet, PyPI, and RubyGems package ecosystems »
- Portée / limites : le service construit le graphe complet des dépendances et reprend les avis de sécurité d'OSV. La page de documentation lue ne mentionne ni les licences ni Scorecard, alors que le Concise Guide de l'OpenSSF dit que deps.dev affiche le score Scorecard. Ce point n'a pas été vérifié sur une fiche de paquet. Les données sont mises à jour régulièrement, donc pas en temps réel.
- En pratique : ouvrir la fiche deps.dev de la version candidate et compter les dépendances transitives et les avis OSV ouverts.

### Mesurer la dette de mise à jour d'un projet en « libyears »
- Niveau de preuve : N3 (métrique de CHAOSS)
- Source : CHAOSS, s.d., « Libyears », https://chaoss.community/kb/metric-libyears/
- Extrait lu : « Libyears measure the cumulative age of a project's dependencies compared to their current stable releases. »
- Portée / limites : la métrique se fonde sur les dates de release, pas sur les numéros de version. La page avertit qu'une médiane peut masquer une longue traîne de dépendances très anciennes, et que les dépendances transitives ne sont pas prises en charge par tous les outils.
- En pratique : appliquer la métrique au candidat lui-même. Une bibliothèque dont les propres dépendances accumulent des années de retard transmet cette dette.

---

## 3. Abandon et dépréciation

### Prévoir l'abandon d'une dépendance largement utilisée comme un événement probable sur la durée de vie de l'application
- Niveau de preuve : N2 (28 100 paquets npm à plus de 10 000 téléchargements par mois, observés sur six ans)
- Source : Miller, Jahanshahi, Mockus, Vasilescu, Kästner, 2025, « Understanding the Response to Open-Source Dependency Abandonment in the npm Ecosystem », ICSE 2025, https://cmustrudel.github.io/papers/icse2025abandonment.pdf (PDF lu)
- Extrait lu : « we identified 4,108 (15%) as becoming abandoned during our six-year observation window »
- Portée / limites : les auteurs qualifient leur définition de l'abandon de « conservative » (avis explicite ou absence d'activité). Seul npm est étudié, seulement les paquets très téléchargés, et seulement les projets dépendants publics sur GitHub. Les auteurs notent que l'abandon peut être plus fréquent chez les paquets moins téléchargés.
- En pratique : sur une application censée vivre cinq ans ou plus, quel est le plan B pour chaque dépendance structurante ?

### Surveiller l'état de ses dépendances, car la plupart des projets ne réagissent jamais à leur abandon
- Niveau de preuve : N2 (même étude, échantillon de 2 288 projets dépendants actifs)
- Source : Miller et al., 2025, ICSE 2025, https://cmustrudel.github.io/papers/icse2025abandonment.pdf
- Extrait lu : « Only 18% of directly dependent projects with any development activity after the abandonment date ever remove the abandoned dependency »
- Portée / limites : quand la dépendance est retirée, le délai moyen est de 13,5 mois. Une dépendance avec un avis explicite d'abandon a 1,58 fois plus de chances d'être retirée (IC 95 % : 1,26 à 1,98). Le retrait est corrélé à d'autres bonnes pratiques, comme les mises à jour régulières.
- En pratique : y a-t-il une veille (Dependabot ou Renovate, `npm outdated`, avertissements `npm deprecated`) qui ferait remonter l'abandon d'une dépendance structurante ?

### Réduire le coût d'un abandon futur par une couche d'abstraction et une veille, pas seulement par un meilleur choix initial
- Niveau de preuve : N2 qualitatif (entretiens avec 33 développeurs qui ont vécu l'abandon d'une dépendance)
- Source : Miller, Kästner, Vasilescu, 2023, « "We Feel Like We're Winging It:" A Study on Navigating Open-Source Dependency Abandonment », ESEC/FSE 2023, https://par.nsf.gov//servlets/purl/10451733 (PDF lu)
- Extrait lu : « Abandonment introduces cost for otherwise seemingly free dependencies »
- Portée / limites : les stratégies de préparation citées sont « dependency monitoring, building abstraction layers, and community involvement ». Avant l'adoption, les personnes interrogées regardent le nombre de mainteneurs, la popularité et la fréquence des mises à jour. C'est une étude qualitative : elle ne chiffre ni l'efficacité ni le coût de ces stratégies.
- En pratique : la dépendance (auth, ORM, paiement) est-elle appelée depuis un seul module adaptateur, ou depuis toute la base de code ?

### Vérifier que la version visée n'est pas dépréciée et qu'une version de remplacement existe
- Niveau de preuve : N2 (registre npm entier)
- Source : Cogo, Oliva, Hassan, 2021, « Deprecation of packages and releases in software ecosystems: A case study on npm », IEEE TSE (DOI 10.1109/TSE.2021.3055123), https://sail.cs.queensu.ca/data/pdfs/2021_Deprecation_of_packages_and_releases_in_software_ecosystems_A_case_study_on_npm.pdf (PDF lu)
- Extrait lu : « 27% of all client packages directly adopt at least one deprecated release and that 54% of all client packages transitively adopt at least one deprecated release »
- Portée / limites : 3,7 % des paquets ont au moins une release dépréciée, et 66 % de ceux-là ont déprécié toutes leurs releases, sans version de remplacement possible. Seul npm est étudié, avec des données antérieures à 2021. Le mécanisme de dépréciation de npm est jugé « rudimentary ».
- En pratique : `npm view <paquet> deprecated` sur la version candidate, et lire les avertissements `npm WARN deprecated` à l'installation, y compris pour les dépendances transitives.

---

## 4. Mises à jour et dette de dépendances

### Prévoir que les dépendances resteront en retard si rien n'organise leur mise à jour
- Niveau de preuve : N2 (plus de 4 600 projets GitHub et 2 700 dépendances, écosystème Java/Maven ; enquête auprès des développeurs)
- Source : Kula, German, Ouni, Ishio, Inoue, 2017, « Do Developers Update Their Library Dependencies? An Empirical Study on the Impact of Security Advisories on Library Migration », https://arxiv.org/abs/1709.04621 (PDF du préprint lu)
- Extrait lu : « 81.5% of the studied systems still keep their outdated dependencies »
- Portée / limites : dans le corps de l'article, 81,5 % est un indicateur moyen de « library residue » calculé sur 2 736 dépendances (« x̄=85.7%, µ=81.5%, σ=22.2% »), pas un comptage direct de systèmes. Le chiffre de 69 % de développeurs ignorant leur dépendance vulnérable vaut pour 11 réponses sur 16. Les données sont Java/Maven et datent d'avant 2017. La publication dans une revue n'a pas été vérifiée (voir Non vérifié).
- En pratique : qui mettra la bibliothèque à jour, à quelle fréquence, avec quel outil (Renovate, Dependabot) ? Si personne, compter ce retard dans le coût total.

### S'attendre à plusieurs mois de retard technique par défaut sur npm
- Niveau de preuve : N2 (plus de 1,4 M releases de 120 000 paquets npm et 8 M dépendances)
- Source : Decan, Mens, Constantinou, 2018, « On the evolution of technical lag in the npm package dependency network », ICSME 2018, https://arxiv.org/abs/1806.01545 (PDF lu)
- Extrait lu : « From 2015 onwards, the average technical lag for releases with technical lag is of 7 to 9 months. »
- Portée / limites : 25 % des releases accusent un retard de plus de 9 mois. Les mises à jour sont surtout des patchs (76 à 86 %), les majeures sont rares (0,6 à 7 %), et les majeures réduisent davantage le retard. Les dépendances de développement sont exclues. Données npm jusqu'en 2018. Le travail fondateur de Zerouali et al. sur le retard technique, cité par cet article, n'a pas été lu.
- En pratique : la bibliothèque respecte-t-elle semver, et les contraintes de version (`^`, `~`) permettent-elles de recevoir les correctifs sans intervention ?

---

## 5. Licences, changements de licence et SBOM

### Vérifier que chaque composant a une licence, et une licence OSI courante s'il se présente comme open source
- Niveau de preuve : N3
- Source : OpenSSF Best Practices WG, 2023-2025, « Concise Guide for Evaluating Open Source Software », https://best.openssf.org/Concise-Guide-for-Evaluating-Open-Source-Software
- Extrait lu : « Verify that every component has a license, that it's a widely-used OSI license if it's OSS. »
- Portée / limites : le guide ne dit rien de la compatibilité entre licences ni des obligations précises de chacune, ce qui relève d'un juriste. Zahan et al. (2022-2023) trouvent qu'en 2022, 32 % des paquets npm n'avaient pas de licence détectable dans leur dépôt.
- En pratique : `license` dans `package.json` ou dans les métadonnées PyPI, plus un fichier LICENSE dans le dépôt. Une licence absente veut dire qu'aucun droit d'utilisation n'est accordé.

### Identifier les licences avec les identifiants SPDX, et repérer celles qui ne sont pas approuvées par l'OSI
- Niveau de preuve : N1 (liste de référence du standard SPDX ; son statut de norme ISO n'a pas été vérifié ici)
- Source : SPDX, version 3.29.0 du 2026-09-16, « SPDX License List », https://spdx.org/licenses/
- Extrait lu : « The purpose of the SPDX License List is to enable efficient and reliable identification »
- Portée / limites : dans la liste, AGPL-3.0-only est marquée OSI Approved. BUSL-1.1 et SSPL-1.0 figurent dans la liste mais sans la marque OSI. Ce statut a été déduit des colonnes de la page.
- Portée / limites (suite) : l'OSI a publié « The SSPL is Not an Open Source License » (19.01.2021, https://opensource.org/blog/the-sspl-is-not-an-open-source-license). La licence lui avait été soumise, puis retirée par son auteur quand il était devenu clair qu'elle ne serait pas approuvée.
- En pratique : la licence du candidat est-elle BUSL-1.1, SSPL-1.0 ou une licence d'éditeur maison ? Si oui, ce n'est pas de l'open source au sens de l'OSI : lire la clause d'usage concurrentiel, et écrire dans l'ADR « source disponible » plutôt qu'« open source ».

### Considérer que la licence d'une dépendance « open source » d'éditeur peut changer pour toutes les versions futures
- Niveau de preuve : N3 (annonce officielle de l'éditeur, cas documenté)
- Source : Dadgar (HashiCorp), 10.08.2023, « HashiCorp adopts Business Source License », https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
- Extrait lu : « except where providing a competitive offering to HashiCorp »
- Portée / limites : le passage de MPL 2.0 à BSL 1.1 vaut pour « all future releases of HashiCorp products ». Les API, SDK et la plupart des bibliothèques restent sous MPL 2.0. Les versions déjà publiées ne changent pas de licence. La conversion de la BSL vers une licence ouverte après un délai n'est pas confirmée par la page lue.
- En pratique : la dépendance est-elle portée par une seule entreprise qui vend une offre hébergée concurrente ? Si oui, le risque de changement de licence fait partie du coût de sortie.

### Savoir qu'un changement de licence peut aussi revenir en arrière, mais sans retour à la licence d'origine
- Niveau de preuve : N3 (annonces officielles de l'éditeur)
- Source : Redis, 20.03.2024, « Redis Adopts Dual Source-Available Licensing », https://redis.io/blog/redis-adopts-dual-source-available-licensing/ ; Trollope (Redis), 01.05.2025, « Redis is now available under the AGPLv3 open source license », https://redis.io/blog/agplv3/
- Extrait lu : « Starting with Redis 7.4, Redis will be dual-licensed under the Redis Source Available License (RSALv2) and Server Side Public License (SSPLv1). » ; puis « Adding the OSI-approved AGPL as an additional licensing option for Redis, starting with Redis 8 »
- Portée / limites : Redis reconnaissait en 2024 « this change means Redis is no longer open source under the OSI definition ». Le billet de 2025 note que « AWS and Google now maintain their own fork ». Le retour se fait vers l'AGPL, pas vers la BSD d'origine. Elastic a suivi le même chemin : « we will be adding AGPL as another license option next to ELv2 and SSPL » (Banon, 29.08.2024, https://www.elastic.co/blog/elasticsearch-is-open-source-again).
- En pratique : existe-t-il un fork communautaire viable, sous gouvernance neutre, vers lequel migrer si la licence change ?

### Évaluer l'AGPL selon le mode de distribution : elle vise aussi l'usage à travers le réseau
- Niveau de preuve : N1 (texte de licence publié sur le site de l'OSI)
- Source : OSI, approbation du 03.03.2008, « GNU Affero General Public License v3 », https://opensource.org/licenses/agpl-v3
- Extrait lu : « your modified version must prominently offer all users interacting with it remotely through a computer network »
- Portée / limites : c'est l'article 13, « Remote Network Interaction ». La clause porte sur une version modifiée du programme. L'étendue exacte (qu'est-ce qu'une modification, une œuvre dérivée ?) est une question juridique.
- En pratique : la dépendance AGPL est-elle utilisée telle quelle comme service séparé (une base de données, par exemple), ou modifiée et liée au code de l'application ?

### Tenir un inventaire des composants selon les éléments minimaux d'un SBOM
- Niveau de preuve : N3 (rapport officiel du Département du Commerce des États-Unis)
- Source : NTIA, 12.07.2021, « The Minimum Elements For a Software Bill of Materials (SBOM) », https://www.ntia.doc.gov/files/ntia/publications/sbom_minimum_elements_report.pdf (PDF lu)
- Extrait lu : « Supplier, Component Name, Version of the Component, Other Unique Identifiers, Dependency Relationship, Author of SBOM Data, and Timestamp. »
- Portée / limites : les formats cités sont « SPDX, CycloneDX, and SWID tags ». Sur la profondeur : « At a minimum, all top-level dependencies must be listed ». En août 2025, la CISA a soumis à consultation une mise à jour qui ajoute « component hash, license, tool name, and generation context » (communiqué du 22.08.2025, https://www.cisa.gov/news-events/news/cisa-issues-draft-software-bill-materials-guide-public-comment). La version finale n'a pas été vérifiée.
- En pratique : le build produit-il un SBOM (CycloneDX ou SPDX) qui inclut la licence de chaque composant ?

---

## 6. Cadre européen : Cyber Resilience Act (Règlement (UE) 2024/2847)

### Connaître le calendrier : signalement dès le 11.09.2026, application complète le 11.12.2027
- Niveau de preuve : N1
- Source : Règlement (UE) 2024/2847, art. 71, JO L du 20.11.2024, https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng (texte officiel lu via https://publications.europa.eu/resource/celex/32024R2847)
- Extrait lu : « This Regulation shall apply from 11 December 2027. However, Article 14 shall apply from 11 September 2026 and Chapter IV (Articles 35 to 51) shall apply from 11 June 2026. »
- Portée / limites : l'article 69(3) étend l'article 14 (signalement des vulnérabilités activement exploitées) aux produits mis sur le marché avant le 11.12.2027. L'article 14(2)(a) impose une alerte précoce « within 24 hours ». La page de la Commission confirme l'entrée en vigueur le 10.12.2024 (https://digital-strategy.ec.europa.eu/en/policies/cra-summary). Au 9 novembre 2026, l'obligation de signalement est donc déjà applicable aux produits dans le champ.
- En pratique : l'application est-elle un « produit comportant des éléments numériques » mis sur le marché de l'UE ? Si oui, qui recevrait et signalerait une vulnérabilité activement exploitée dans une dépendance ?

### Savoir qu'un développeur indépendant peut être « fabricant », même pour un produit gratuit
- Niveau de preuve : N1
- Source : Règlement (UE) 2024/2847, art. 3, point 13, https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng
- Extrait lu : « 'manufacturer' means a natural or legal person who develops or manufactures products with digital elements […] and markets them under its name or trademark, whether for payment, monetisation or free of charge »
- Portée / limites : la définition vise les personnes physiques. Savoir si un logiciel donné est « mis sur le marché » dans le cadre d'une activité commerciale relève d'un juriste. Le considérant 18 sur le logiciel libre n'a pas été lu en entier.
- En pratique : application installable ou bibliothèque distribuée dans l'UE contre paiement ou sous sa marque ? Faire qualifier son statut par un juriste avant 2027.

### Pour une application web hébergée, vérifier d'abord si elle entre seulement dans le champ du CRA
- Niveau de preuve : N1 (considérant du règlement, qui éclaire son interprétation sans avoir la force d'un article)
- Source : Règlement (UE) 2024/2847, considérant 12, https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng
- Extrait lu : « websites that do not support the functionality of a product with digital elements, or cloud services designed and developed outside the responsibility of a manufacturer of a product with digital elements do not fall within the scope of this Regulation »
- Portée / limites : le même considérant renvoie à la directive (UE) 2022/2555 (NIS 2) pour le SaaS, le PaaS et l'IaaS, en précisant que seules les entités de taille moyenne ou plus y entrent. Une application web pure, en SaaS, n'est donc a priori pas un « produit » au sens du CRA. Une application mobile, une application de bureau ou une bibliothèque distribuée peuvent l'être. Ce tri relève d'un juriste.
- En pratique : le livrable est-il un logiciel distribué (app installable, paquet npm ou PyPI, binaire) ou uniquement un service en ligne ?

### Si l'application est un produit dans le champ, appliquer la diligence raisonnable aux composants tiers et tenir un SBOM
- Niveau de preuve : N1
- Source : Règlement (UE) 2024/2847, art. 13(5) et annexe I, partie II, point 1, https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng
- Extrait lu : « manufacturers shall exercise due diligence when integrating components sourced from third parties so that those components do not compromise the cybersecurity of the product with digital elements »
- Portée / limites : l'article inclut explicitement les composants libres non fournis dans le cadre d'une activité commerciale. L'annexe I demande un SBOM « in a commonly used and machine-readable format covering at the very least the top-level dependencies of the products ». La Commission peut préciser son format par acte d'exécution (art. 13(24)).
- En pratique : la grille d'évaluation des dépendances (maintenance, vulnérabilités, licence) est-elle conservée par écrit ? Elle peut servir de trace de diligence raisonnable.

### Ne pas compter sur un « steward » open source pour porter les obligations du fabricant
- Niveau de preuve : N1
- Source : Règlement (UE) 2024/2847, art. 3, point 14, et art. 24, https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng
- Extrait lu : « 'open-source software steward' means a legal person, other than a manufacturer, that has the purpose or objective of systematically providing support on a sustained basis »
- Portée / limites : les stewards (fondations, par exemple) doivent tenir une politique de cybersécurité documentée et coopérer avec les autorités de surveillance du marché (art. 24). D'après la page de la Commission, ils ne sont pas passibles de sanctions. Les obligations de diligence et de suivi des vulnérabilités restent celles du fabricant qui intègre le composant.
- En pratique : la dépendance est-elle portée par une fondation qui publie une politique de sécurité (SECURITY.md, processus de divulgation) ? C'est un plus, pas une décharge.

---

## 7. Verrouillage fournisseur et coût de sortie

### Pour un service cloud, connaître les droits de changement de fournisseur garantis par le Data Act
- Niveau de preuve : N1
- Source : Règlement (UE) 2023/2854 (Data Act), art. 25, 29 et 50, https://eur-lex.europa.eu/eli/reg/2023/2854/oj/eng (texte officiel lu via https://publications.europa.eu/resource/celex/32023R2854)
- Extrait lu : « From 12 January 2027, providers of data processing services shall not impose any switching charges on the customer for the switching process. »
- Portée / limites : le règlement s'applique depuis le 12.09.2025 (art. 50). Le contrat doit prévoir un préavis maximal de deux mois pour lancer le changement de fournisseur, puis une période de transition obligatoire de 30 jours calendaires au plus (art. 25). Jusqu'au 12.01.2027, des frais de changement réduits restent permis (art. 29(2)). Les services conçus sur mesure pour un client unique sont en partie exemptés (art. 31). Le règlement est européen : son effet pour un client établi en Suisse relève d'un juriste.
- En pratique : le contrat de l'hébergeur ou du BaaS mentionne-t-il la procédure de sortie, les formats d'export et les frais ?

### Préférer, pour le cœur de données, un service bâti sur des standards exportables
- Niveau de preuve : N3 (documentation officielle de Supabase)
- Source : Supabase, s.d. (consulté le 09.11.2026), « Architecture », https://supabase.com/docs/guides/getting-started/architecture
- Extrait lu : « To avoid lock-in, we make it easy to migrate in and out. »
- Portée / limites : Supabase dit aussi que « everything we use is open source » et que son offre cloud est compatible avec la version auto-hébergée. Les briques sont sous MIT ou Apache 2.0 (GoTrue, PostgREST, Storage API, Realtime). C'est la parole de l'éditeur, pas un audit indépendant.
- En pratique : les données sont-elles dans du Postgres standard, exportable avec `pg_dump`, ou dans un format propriétaire ?

### Chiffrer la sortie avant d'entrer : un export de base ne déplace pas tout le service
- Niveau de preuve : N3 (documentation officielle de Supabase)
- Source : Supabase, s.d. (consulté le 09.11.2026), « Backup and Restore using the CLI », https://supabase.com/docs/guides/platform/migrating-within-supabase/backup-restore
- Extrait lu : `supabase db dump --remote=[CONNECTION_STRING] -f schema.sql`
- Portée / limites : la procédure exporte les rôles, le schéma et les données. Les objets du Storage passent par un script séparé. Les Edge Functions se récupèrent avec `supabase functions download`, sans import maps ni `deno.json`. Webhooks, extensions non standard et publications Realtime sont à reconfigurer. « Backup files never contain the root key ». La page décrit une migration entre projets Supabase, pas vers un autre fournisseur.
- Portée / limites (auto-hébergement) : la page « Self-Hosting » (https://supabase.com/docs/guides/self-hosting) indique : « Some features of the managed platform aren't available when self-hosting: branching, advanced metrics beyond logs, ». Elle cite aussi, parmi les absents, les sauvegardes PITR, les analytics et la Management API, et précise : « Self-hosted Supabase is community-supported. » La sécurisation, les sauvegardes et la surveillance passent à la charge de celui qui auto-héberge.
- En pratique : lister ce qui dépend de fonctionnalités propres à la plateforme (Storage, Edge Functions, Auth, Realtime) et estimer le travail pour le reconstruire ailleurs. La sortie de secours par l'auto-hébergement est-elle réellement exploitable par une seule personne ?

### Pour le front, vérifier ce qui reste vrai hors de l'hébergeur d'origine
- Niveau de preuve : N3 (documentation officielle de Next.js, mise à jour le 2026-10-15)
- Source : documentation officielle de Next.js, 2026, « How to self-host your Next.js application », https://nextjs.org/docs/app/guides/self-hosting
- Extrait lu : « By default, calling revalidateTag() on one instance only invalidates the cache on that instance. »
- Portée / limites : avec `next start`, Image Optimization, Proxy et `after` fonctionnent sans configuration. Avec plusieurs instances, il faut en plus un cache handler partagé, une clé `NEXT_SERVER_ACTIONS_ENCRYPTION_KEY` commune et un `deploymentId` contre les écarts de version. Le streaming impose de désactiver la mise en mémoire tampon du proxy. La documentation propre à Vercel sur l'export n'a pas été lue.
- En pratique : l'application tournerait-elle sur un conteneur Node unique (chez un hébergeur suisse ou européen quelconque) sans modification de code ? Sinon, quelles fonctions de l'hébergeur sont utilisées (cron, KV, Blob, Edge Config) ?

---

## 8. Construire, acheter, ne rien construire

### Ne pas sous-estimer l'effort d'intégration d'un composant sur étagère, et apprendre le composant avant de s'engager
- Niveau de preuve : N2 (enquête auprès de 133 projets industriels en Norvège, en Italie et en Allemagne, échantillon aléatoire stratifié)
- Source : Li, Conradi, Slyngstad, Torchiano, Morisio, Bunse, 2008, « A State-of-the-Practice Survey on Risk Management in Development with Off-The-Shelf Software Components », IEEE TSE 34(2), p. 271-286, https://iris.polito.it/handle/11583/1666613 (résumé seul lu)
- Extrait lu : « OTS components normally do not contribute negatively to the quality of the software system as a whole »
- Portée / limites : le résumé signale que « underestimation of integration effort and inefficient debugging remain problematic ». Pratiques prometteuses citées : mieux apprendre les composants, intégrer d'abord ceux qu'on connaît mal, évaluer soigneusement la qualité des candidats, vérifier régulièrement que le fournisseur pourra continuer à les maintenir. Les composants (COTS et OSS) et les projets datent du milieu des années 2000 : c'est une analogie avec les dépendances npm ou PyPI, pas une mesure.
- En pratique : avant d'adopter, faire un prototype jetable sur le cas le plus difficile (par exemple les RLS avec l'auth choisie), et compter l'intégration dans le coût.

### Ne pas ajouter de dépendance pour une fonction triviale, et ne pas croire qu'un petit paquet est testé
- Niveau de preuve : N2 (plus de 230 000 paquets npm, 38 000 applications JavaScript, enquête auprès de 88 développeurs)
- Source : Abdalkareem, Nourry, Wehaibi, Mujahid, Shihab, 2017, « Why do developers use trivial packages? An empirical case study on npm », ESEC/FSE 2017, DOI 10.1145/3106237.3106267 ; résumé lu sur la reproduction de https://neverworkintheory.org/2021/09/17/why-do-developers-use-trivial-packages.html (résumé seul lu, l'article n'a pas pu être ouvert)
- Extrait lu : « contrary to developers' beliefs, only 45.2% of trivial packages even have tests »
- Portée / limites : selon le même résumé, les paquets triviaux représentent 16,8 % des paquets étudiés et « 11.5% of the studied trivial packages have more than 20 dependencies ». Données npm de 2016-2017. L'article ajoute que ces paquets paraissent « deployment tested ».
- En pratique : ces quelques lignes s'écrivent-elles en dix minutes avec leurs tests ? Si oui, ne rien installer.

### Faire de « ne rien construire » une option explicite : la recherche empirique sur l'arbitrage construire / acheter pour une application web est mince
- Niveau de preuve : N4 (constat de cette recherche : absence de source empirique trouvée)
- Source : aucune étude empirique comparant le coût total de « construire », « acheter » et « ne rien construire » pour des modules d'applications web n'a été trouvée. Les sources les plus proches sont l'enquête OTS de Li et al. (2008) et la rubrique « Necessity » du Concise Guide de l'OpenSSF (https://best.openssf.org/Concise-Guide-for-Evaluating-Open-Source-Software).
- Extrait lu : « Every new dependency increases the attack surface. » (Concise Guide, rubrique Necessity)
- Portée / limites : la règle des trois options est une discipline de décision raisonnable, pas un résultat mesuré. Les études PROFES 2005 et ICSE 2006 de Li et al. sur les décisions COTS contre OSS ont été repérées mais pas lues.
- En pratique : pour chaque module non central, écrire en une ligne le coût de chacune des trois options (temps, maintenance, sortie) et la raison du choix.

---

## Verdict sur les règles du profil

| Règle | Verdict | Motif sourcé |
|---|---|---|
| « Coût total d'une dépendance (Mode C) : au-delà des features — cadence de releases et maintenance réelle, bus factor, poids installé, surface de sécurité, coût de sortie (lock-in). Une lib morte dans 18 mois coûte plus que ses features. » | **Soutenue pour les critères, à préciser pour la phrase finale** | Les critères sont appuyés par l'OpenSSF Concise Guide (N3 : activité et release dans les 12 mois, plus d'un mainteneur, dépendances indirectes, licence), Avelino 2016 et 2019 (N2 : 57 % de TF = 1), Miller 2025 (N2 : 15 % d'abandon, 18 % de retraits) et Miller 2023 (N2 : « Abandonment introduces cost »). La phrase « une lib morte dans 18 mois coûte plus que ses features » est une **convention sans preuve trouvée** : aucune étude ne chiffre ce seuil. À ajouter : ne pas réduire la santé à un score agrégé (Zahan 2023 : R² de 9 à 12 %), et ajouter la licence aux critères. |
| « Build vs buy vs ne-rien-construire : pour tout module non-cœur de métier, les trois options sont évaluées. » | **Convention sans preuve trouvée, cohérente avec les guides** | Aucune étude empirique de l'arbitrage à trois options n'a été trouvée (N4). Appuis indirects : la rubrique « Necessity » du Concise Guide (N3), Li et al. 2008 (N2, résumé : intégration sous-estimée), Abdalkareem 2017 (N2, résumé : 45,2 % des paquets triviaux ont des tests). |
| « Jamais d'ajout de dépendance majeure sans ADR. » | **Convention sans preuve trouvée, à préciser** | Aucune étude ne mesure l'effet des ADR sur la qualité des choix de dépendances. Un appui réglementaire indirect existe : pour un produit dans le champ du CRA, l'art. 13(5) impose une diligence raisonnable sur les composants tiers, et l'annexe I un SBOM (N1). Une trace écrite de l'évaluation sert alors aussi de preuve. À préciser : définir « majeure » (dépendance structurante : auth, ORM, BaaS, hébergeur, bibliothèque d'UI). |
| Anti-pattern « Choisir une dépendance sur ses features sans regarder sa maintenance, son bus factor et son coût de sortie » | **Soutenue** | Concise Guide (N3). Avelino 2019 (N2 : TF faible dans la majorité des projets populaires). Miller 2025 (N2 : abandon fréquent, rarement suivi d'une réaction). Cogo 2021 (N2 : 27 % des paquets clients adoptent directement une release dépréciée). Documentation Supabase (N3 : la sortie a un coût réel, même avec des standards ouverts). |
| (absence) Licence | **À ajouter** | Concise Guide (« Verify that every component has a license »), liste SPDX (BUSL-1.1 et SSPL-1.0 non approuvées par l'OSI), cas HashiCorp 2023, Redis 2024-2025 et Elastic 2024 : les licences d'éditeur changent pour les versions futures. |
| (absence) SBOM | **À ajouter, sous condition** | NTIA 2021 (éléments minimaux, N3). Obligatoire pour un produit dans le champ du CRA (annexe I, partie II, point 1, N1). Pour une application SaaS pure, c'est une bonne pratique, pas une obligation CRA (considérant 12). |
| (absence) Cyber Resilience Act | **À ajouter comme question de qualification, pas comme obligation générale** | Art. 71 (signalement depuis le 11.09.2026, le reste au 11.12.2027) ; art. 3(13) (un fabricant peut être une personne physique, même pour un produit gratuit) ; considérant 12 (sites et services cloud hors champ). La qualification d'un cas relève d'un juriste. |
| (absence) Portabilité des données | **À ajouter** | Data Act, art. 25 et 29 (préavis de deux mois au plus, transition de 30 jours au plus, plus de frais de changement à partir du 12.01.2027, N1). Documentation Supabase sur l'export et l'auto-hébergement (N3). |

---

## Mythes et affirmations contestées

- **« 81,5 % des systèmes gardent des dépendances obsolètes » (Kula et al.)** : le chiffre figure bien dans le résumé. Dans le corps de l'article, il est la moyenne d'un indicateur de « library residue » calculé sur 2 736 dépendances, dans l'écosystème **Java/Maven**, avec des données d'avant 2017. Le « 69 % de développeurs non informés » repose sur **11 réponses sur 16**. Ne pas le citer comme une mesure de npm ou de PyPI.
- **« 16 % des projets populaires sont abandonnés » (Avelino 2019)** : dans cette étude, « abandonné » veut dire que les développeurs du truck factor sont partis. 41 % de ces projets ont survécu grâce à de nouveaux mainteneurs.
- **« 65 % des projets ont un truck factor ≤ 2 »** : c'est exact pour 133 projets GitHub populaires en 2016. En 2019, sur 1 932 projets, 57 % ont un TF de 1 et 25 % un TF de 2. Les deux mesures reposent sur la paternité du code, et les développeurs n'ont approuvé l'estimation du TF que dans 53 % des réponses en 2016.
- **« Un bon score OpenSSF Scorecard veut dire une dépendance sûre »** : c'est contredit. Zahan et al. (2023) trouvent un R² de 9 à 12 %, et davantage de vulnérabilités signalées quand le score agrégé monte. La documentation de Scorecard dit elle-même qu'un score bas « is therefore not a definitive indication that the project is at risk ».
- **« Plus de 85 % des paquets npm ne sont pas maintenus »** : c'est vrai au sens du check Maintained (au moins un commit par semaine sur 90 jours), pas au sens d'« abandonné ». Avec une définition prudente de l'abandon, Miller et al. (2025) trouvent 15 % sur six ans parmi les paquets très utilisés.
- **« Le CRA s'applique à toute application web vendue dans l'UE »** : à préciser. D'après le considérant 12, les sites qui ne soutiennent pas un produit et les services cloud sans lien avec un produit sont hors champ, le SaaS relevant de NIS 2. Une application installable, une bibliothèque distribuée ou le backend d'un produit peuvent en revanche être dans le champ. La qualification relève d'un juriste.
- **« Le CRA n'oblige à rien avant décembre 2027 »** : c'est faux. L'article 14 (signalement des vulnérabilités activement exploitées et des incidents graves) s'applique depuis le 11.09.2026, y compris aux produits mis sur le marché avant 2027 (art. 69(3)).
- **« Les changements de licence sont définitifs »** : c'est nuancé. Redis (2025) et Elastic (2024) ont ajouté l'AGPL après être passés à la SSPL, mais aucun n'est revenu à sa licence permissive d'origine, et des forks concurrents sont nés entre-temps.
- **« Supabase est open source, donc il n'y a pas de verrouillage »** : à préciser. La documentation reconnaît que la version auto-hébergée n'a ni branching, ni PITR, ni Management API, et qu'elle est « community-supported ». La migration demande aussi des étapes séparées pour le Storage, les Edge Functions et les réglages.
- **« La BSL de HashiCorp devient MPL après quatre ans »** : affirmation fréquente, **non vérifiée** ici. Le billet officiel lu ne le dit pas, et la FAQ consultée n'affichait pas ses réponses.

---

## Non vérifié

- **Zerouali et al. (2018), étude fondatrice du « technical lag » sur npm** : citée par Decan et al. (2018), qui disent qu'elle trouve « a technical lag of several months », mais pas ouverte ici.
- **Lieu de publication de Kula et al.** : l'article semble publié chez Springer (DOI 10.1007/s10664-017-9521-5, revue et année non confirmées), mais la page redirige vers une authentification. Seul le préprint arXiv a été lu.
- **Délai de conversion de la BSL de HashiCorp vers une licence ouverte** (« change date ») : non confirmé.
- **Version finale des « 2025 Minimum Elements » de la CISA** : seul le communiqué de consultation du 22.08.2025 a été lu. La date de publication finale et son contenu ne sont pas vérifiés.
- **Considérant 18 du CRA** (logiciel libre et activité commerciale) et ce qui fait qu'une mise à disposition est « commerciale » : non lus en entier.
- **Effet du Data Act pour un client établi en Suisse**, et applicabilité concrète des articles 23 à 31 aux contrats de Vercel ou de Supabase : non vérifiés. C'est une question juridique.
- **Documentation propre à Vercel sur l'export ou la sortie** (Build Output API, données KV ou Blob) : non lue. Seul le guide d'auto-hébergement de Next.js a été lu.
- **Affichage du score Scorecard et des licences sur les fiches deps.dev** : le Concise Guide le dit, mais la page de documentation de deps.dev lue ne le mentionne pas, et aucune fiche de paquet n'a été ouverte.
- **Li et al., ICSE 2006 (« An empirical study on decision making in off-the-shelf component-based development ») et PROFES 2005 (usage des composants COTS et OSS)** : repérés par la recherche, non lus.
- **Article d'Abdalkareem et al. (2017)** : seul le résumé, reproduit par neverworkintheory.org, a été lu. Les PDF trouvés ne s'ouvraient pas.
- **Li et al. (2008)** : seul le résumé, sur le dépôt institutionnel du Politecnico di Torino, a été lu.
- **Étude empirique sur le coût total « construire / acheter / ne rien construire »** pour des applications web modernes : aucune trouvée. L'absence de résultat ne prouve pas qu'il n'en existe pas.
- **Date exacte du changement de licence d'Elastic** : le billet de 2024 dit seulement « 3 years ago ».

# Fiche `ux-preuves` — D'où vient ce contenu

> Provenance et contrôles de la recherche documentaire, sortie du `SKILL.md` le 09.11.2026 pour
> alléger ce qu'il précharge. À lire avant de faire confiance à une fiche pour un chiffre qui compte.

Recherche documentaire du **09.11.2026**, menée en six volets parallèles (formulaires, navigation,
mobile et temps de réponse ; contenus, documents et accessibilité ; IA, dark patterns et
onboarding ; normes, lois UX et méthodes ; front de recherche 2022-2026 ; cognition et chemin
d'usage). Une règle unique pour les six : **rien de mémoire**. Chaque entrée cite une page
réellement ouverte (`WebFetch`, ou PDF téléchargé puis extrait par `pdftotext`) et en recopie un
extrait verbatim ; un chiffre dont la source primaire n'a pas été trouvée est rangé en
« Non vérifié », pas dans les entrées.

- **206 entrées** dans six fiches, **251 URL distinctes**. Sources les plus citées : NN/g, W3C,
  arXiv, legislation.gov.uk (texte de la directive EAA et lecture de secours quand EUR-Lex
  refusait l'accès), web.dev, aperçus officiels de normes ISO, Microsoft Research, MeasuringU,
  Canada.ca, GOV.UK Design System. Wikipédia n'y sert que d'index vers une source primaire.
- **38 mentions « résumé seul lu »** dans les fiches : les entrées qui ne reposent que sur
  l'abstract d'un article le disent à l'endroit même. Elles sont surtout dans
  les fiches les plus récentes (front de recherche, IA) et les méthodes, où le texte intégral
  était derrière un accès payant.
- **Volet growth**, même jour, même règle, cinq volets (science du marketing ; conversion et
  persuasion ; ASO ; e-mails, délivrabilité et droit ; SEO, recherche par IA et droit de la
  publicité) : **171 entrées**, **187 URL distinctes**, 34 mentions « résumé seul lu ». Sondage à la
  source : Play Console « Metadata » (titre à 30 caractères — le profil écrivait 60), Pew 2025
  (8 % contre 15 %), OIP art. 16 (texte complet sur fedlex), Binet & Field 2017 (PDF : 74:26 en
  ligne, innovation mineure), RFC 9989, délibération CNIL 2026-042, Kohavi, Deng, Vermeer 2022 (PDF :
  41 642 visiteurs par variante, taux de succès) — tous conformes.
- **Volet rédaction**, même jour, même règle, cinq volets (microcopy et UX writing ; voix, ton et
  langage inclusif ; i18n et locales ; orthotypographie ; traduction automatique et IA) : **177
  entrées**, **214 URL distinctes**, 13 mentions « résumé seul lu ». Sondage à la source : données
  CLDR 49 (pluriels de fr, es, it, en, de, ru, pl, ar), tableau d'expansion IBM sur la page du W3C,
  Li et al. 2025 (texte intégral : 43 % → 25 %), WCAG 2.5.3, Miller et al. 2016 (texte intégral),
  Instructions de la Chancellerie fédérale de 2016 (PDF : apostrophe interdite dans les nombres),
  sortie d'`Intl` en fr-CH, de-CH et it-CH mesurée sous Node 22, art. 113 de l'AI Act — tous
  conformes ; l'effet de l'Omnibus numérique sur l'art. 50 reste non vérifié au Journal officiel.
- **Volet design visuel**, même jour, même règle, cinq volets (perception et esthétique ; couleur et
  contraste ; typographie et mise en page ; motion, états et design systems ; front récent
  2024-2026) : **173 entrées**, **182 URL distinctes**, 29 mentions « résumé seul lu ». Chaque volet
  a jugé les règles de `designer` une à une. Sondage à la source : Doshi & Hauser 2024, Web Almanac
  2025 (incohérence interne 30 / 31 % notée), WebAIM Million 2026, WCAG 1.4.3 (texte large,
  arrondi, placeholder, désactivés), GOV.UK (corps 19 px), Legge & Bigelow 2011, NN/g 2017 sur le
  flat design, WCAG 2.4.13 (exemption du focus natif), NN/g sur la durée des animations — tous
  conformes, avec une nuance (NN/g resserre à 100-400 ms pour la plupart des cas).
- **Volet frontend**, même jour, même règle, cinq volets (performance web ; React, Next.js et
  écosystème ; accessibilité dans le code ; qualité, tests et sécurité côté client ; code écrit par
  un LLM et plateforme web 2025-2026) : **174 entrées**, **262 URL distinctes**, 11 mentions « résumé
  seul lu ». Chaque volet a jugé les règles de `frontend` une à une. Sondage à la source : `next/image`
  (`lazy` par défaut, `priority` déprécié en v16 au profit de `preload`, lui-même remplacé « in most
  cases » par `loading="eager"` ou `fetchPriority="high"`), doc Next.js « Data Security » (actions
  atteignables par POST direct, autorisation dans chaque action), Supabase (« Never trust
  `getSession()` »), TypeScript 6.0 (`strict` par défaut, 23.03.2026), WebAIM Million 2026 (59,1
  contre 42), Web Almanac 2025 (646 Ko de JS médian sur mobile), avis GHSA-4x49-vf9v-38px sur
  `debug@4.4.2`, Weichselbaum et al. 2016 (94,72 %) — conformes. **Une erreur trouvée et corrigée** :
  le billet Better Auth du 22.09.2025 promet pour Auth.js les correctifs de sécurité **et les
  problèmes urgents**, pas la seule sécurité. Versions et statuts navigateurs vieillissent en mois :
  ce volet est le plus périssable de tous.
- **Volet revue de code**, même règle, recherche du 10.11.2026, deux volets (efficacité mesurée de
  la revue ; revue par un LLM et revue du code écrit par un LLM) : **70 entrées**. Le volet LLM
  repose surtout sur des prépublications arXiv de 2024-2026, lues en PDF ; plusieurs entrées en
  « résumé seul lu » (Mäntylä & Lassenius 2009, Baum et al. 2019, Wang et al.). Les règles de domaine
  que `reviewer` oppose viennent des fiches frontend, backend et sécurité, sans recherche nouvelle.
  Sondage à la source, sources rouvertes au contrôle de clôture : Fregnan et al. 2022 (PDF : 64 %),
  Google « The Standard of Code Review » (deux citations), Jin & Chen 2025 (52,4 % → 11,0 %) et 2026
  (54,8 % → 16,3 %), Alexopoulos et al. 2026 (240/247 → 9/247), Crupi et al. 2025 (50 %, pour le
  meilleur juge testé), Bacchelli & Bird 2013 (78 commentaires, 14 %) — conformes.
- **Volet tests**, même règle, recherche du 10.11.2026, cinq volets (stratégie et allocation ;
  efficacité d'une suite ; tests instables et CI ; conception des cas ; tests et LLM) : **170 entrées**,
  **160 URL distinctes**, 31 mentions « résumé seul lu » (articles derrière accès payant, normes ISO
  payantes : seuls des extraits publics de 29119-3 et 29119-4 ont été lus). Le volet LLM repose surtout
  sur des prépublications arXiv lues en PDF. Sondage à la source, fait hors des volets de recherche en
  rouvrant la source : doc Vitest (« By default only files covered by tests are included »), doc
  Playwright (classement passed / flaky / failed ; `failOnFlakyTests`, v1.52, « Useful on CI »), doc
  PostgreSQL sur la RLS (`UPDATE 0` en silence, `WITH CHECK` en erreur, propriétaire non soumis),
  NIST SP 800-142 (PDF : « pairwise testing may miss 10% to 40% », 67 / 93 / 98 %), AgentCoder (PDF,
  RQ6 : 61,0 % et 51,8 % contre 87,8 % et 89,9 %), *Software Engineering at Google* chap. 11
  (80 / 15 / 5, « very rough guideline », « ice cream cone ») — conformes. Le billet Google de 2015
  (70/20/10, « good first guess ») a répondu 503 au contrôle : il n'est sourcé que par la fiche.
- **Volet mise en production**, même règle, recherche du 10.11.2026, cinq volets (risque et cadence ;
  déploiement progressif et retour arrière ; migrations et sauvegardes ; vérification et incidents ;
  configuration, build et agents sur la production) : **173 entrées**, **180 URL distinctes**,
  4 mentions « résumé seul lu ». Les docs de plateforme (Vercel, Supabase, Next.js) décrivent leur
  produit au jour de la lecture : ce volet vieillit aussi vite que le frontend. Sondage à la source,
  fait hors des volets de recherche en rouvrant la source : doc Vercel Instant Rollback (mise à jour
  du 07.07.2026 : variables non reprises, définitions de cron restaurées, auto-assignation coupée,
  Hobby limité au déploiement précédent), `supabase migration list` (« Only the timestamps are
  compared »), post-mortem GitLab du 31.01.2017 (quatre mécanismes, `pg_dump` 9.2 contre 9.6,
  snapshot LVM d'environ 6 heures), SRE Workbook On-Call (« roll back, fix, and roll forward », « quick
  fix »), sauvegardes Supabase (Storage exclu, Free sans sauvegarde automatique), doc Next.js sur
  `NEXT_PUBLIC_` (inline au build, figé), DORA 2024 (PDF téléchargé pendant la recherche : −7,2 %
  par +25 % d'adoption de l'IA) — conformes. **Erreur corrigée à la rédaction** : l'agent reprenait
  d'abord la version de l'incident Replit que la fiche classe parmi les mythes (suppression « pendant
  le gel ») ; réécrit sur ce que la source établit.
- **Volet ingénierie IA**, même règle, recherche du 10.11.2026, cinq volets (suivi des consignes ;
  architecture d'agents ; routage et chargement dans Claude Code ; mesure ; comportements des
  modèles) : **175 entrées**, **121 URL distinctes**, 21 mentions « résumé seul lu ». La doc de
  Claude Code n'affiche pas de date de mise à jour : chaque entrée qui la cite vaut pour la version
  de Claude Code qu'elle nomme. Sondage à la source, fait hors des volets de recherche en rouvrant
  la source : bonnes pratiques de Claude Code (emphase : « piling on emphasis mostly makes Claude
  over-apply the rule »), mémoire (moins de 200 lignes, CLAUDE.md racine relu depuis le disque après
  compaction), sous-agents (contexte reçu, `omitClaudeMd` depuis v2.1.271, fork actif par défaut,
  alerte à 15 000 tokens), skills (1 536 caractères, réattachement à 5 000 et 25 000 tokens),
  mode non interactif (`--bare` sans liste des skills), hooks (10 000 caractères, aperçu de 2 000,
  aucune invitation à lire la suite), fiche système d'Opus 5 (PDF : « Fabricating execution output,
  file contents, or citations ») ; calcul refait sur le banc C1 (p = 0,05 ; borne basse 29 %) —
  conformes. Le budget de la liste des skills (1 % de la fenêtre) n'a pas été recontrôlé.
- **Volet sécurité**, même règle, recherche menée du 09 au 10.11.2026 autour de minuit UTC, cinq
  volets (menaces et priorisation ; efficacité des outils de détection ; incidents et secrets ;
  plateforme, déploiement et CI ; applications avec LLM et agents) : **175 entrées**, **203 URL
  distinctes**, 11 mentions « résumé seul lu ». Sondage à la source, sources rouvertes au contrôle de clôture : liste complète de l'OWASP
  Top 10:2025 sur top10.owasp.org (ajoutée à la fiche, les volets n'en citaient qu'une partie) ;
  PDF de Basak et al. 2023 (précision 75 % et rappel 6 % pour GitHub, rappel 88 % pour gitleaks),
  de Meli et al. 2019 (81 % jamais retirés, découverte médiane en 20 s) et de PrimeVul (F1 68,26 %
  contre 3,09 %) ; doc Vercel des journaux d'exécution (1 h en Hobby, 1 jour en Pro, 30 jours avec
  Observability Plus) ; doc GitHub sur la suppression de données sensibles (révoquer d'abord, réécrire
  l'historique « may not be warranted », `git-filter-repo --sensitive-data-removal`) — conformes. Ce volet vieillit le plus vite de tous :
  avis de sécurité, versions corrigées, KEV et EPSS changent chaque semaine.
- **Volet architecture**, même jour, même règle, cinq volets (décisions et ADR ; qualités et
  exigences non fonctionnelles ; modularité et dette technique ; dépendances et construire ou
  acheter ; risques, estimation et LLM) : **173 entrées**, **184 URL distinctes**, 20 mentions
  « résumé seul lu » (beaucoup d'articles derrière accès payant ou défi anti-robot). Sondage à la
  source : Sharma et al. 2023 (PDF : « Claude 1.3 wrongly admits mistakes on 98% of questions »),
  Fowler 2026 sur les ADR (une page, alternatives, niveau de confiance, déclencheurs de réexamen),
  ISO/IEC 25010 (neuf caractéristiques), Avelino et al. 2019 (PDF : 1 932 projets, 57 % de TF = 1),
  Cyber Resilience Act (Commission : signalement au 11.09.2026, obligations principales au
  11.12.2027) — conformes ; Flyvbjerg et al. 2022 (PDF) : **précision ajoutée**, les ratios médiane
  1,0 et moyenne 1,8 portent sur 4 677 des 5 392 projets.
- **Volet backend**, même jour, même règle, cinq volets (sécurité des API et authentification ;
  données, PostgreSQL et migrations ; fiabilité et contrats d'API ; observabilité, tests et données
  personnelles ; pile serveur et code écrit par un LLM) : **173 entrées**, **228 URL distinctes**,
  6 mentions « résumé seul lu ». Les lois suisses ont été lues dans leur texte consolidé officiel
  (LPD au 07.07.2025, OPDo au 01.12.2025). Sondage à la source : OWASP Password Storage (Argon2id
  19 MiB, t = 2, p = 1 ; scrypt 2^17 ; PBKDF2 600 000 ; bcrypt « for legacy systems », 72 octets),
  Yuan et al. 2014 (PDF : 92 % des pannes catastrophiques, 58 %, 48 sur 198), LPD art. 7, 24 al. 1
  (« dans les meilleurs délais ») et 25 al. 7 (30 jours), Richardson sur l'outbox, registre npm
  (`prisma` : `latest` = 8.0.0-rc.33, `prev` = 7.10.1 ; `drizzle-orm` : 0.45.4), calendrier Node
  (22 jusqu'au 30.04.2027, 24 en maintenance, 26 LTS active) — conformes. **Le piège de `scrypt`
  a été exécuté** (Node 22.23.4) : N = 2^17, r = 8 avec `maxmem` par défaut lève « memory limit
  exceeded ». Aucune erreur trouvée dans ce volet.
- **Contrôle par sondage** du volet UX, fait hors des volets de recherche en rouvrant la source : heuristiques
  de Nielsen, échelle de sévérité de Nielsen, validation GOV.UK, zone du pouce (Hoober 2017),
  barres de progression (Harrison et al. 2010, texte intégral), Mathur et al. 2019, Bansal et al.
  2021, statut de WCAG 3 et approbation ISO de WCAG 2.2, METR 2025, déqualification en coloscopie
  (Lancet Gastroenterology & Hepatology 2025), Drew et al. 2013. Tous conformes ; une nuance
  ajoutée (les −11 % de Harrison valent pour une variante précise de barre). Le reste n'a pas été
  recontrôlé un par un : une entrée qui surprend se rouvre à sa source avant d'être citée.
- **Sources primaires inaccessibles** pendant la recherche (accès refusé ou rendu JavaScript) :
  iso.org, EUR-Lex, dl.acm.org pour plusieurs articles, Apple HIG, Material 3. Chaque fiche dit
  par quoi elles ont été remplacées.

**Ce qui fait vieillir ce contenu, par ordre de vitesse** : les fiches frontend et backend (versions de frameworks, d'ORM et de runtimes, statuts Baseline, brouillons IETF), les fiches IA et front de recherche
(préprints, études de 2025-2026), les statuts réglementaires (EAA, DSA, consentement, WCAG 3),
les guidelines de plateformes ; puis les chiffres d'études de marché (Baymard, WebAIM). Les
fondements cognitifs (Fitts, Norman, Simons & Chabris) vieillissent le moins.

## Versions du skill

Historique sorti de l'en-tête du `SKILL.md` le 10.11.2026 (v1.9).

- Version 1.0 — 09.11.2026 (création, demande de l'utilisateur : faire monter l'agent `ux` en compétence sur la recherche et les sources spécialisées, applications, sites, logiciels et documents). Préchargé par `ux` (clé `skills:`) : ne pas lui poser de `paths:`.
- Version 1.1 — 09.11.2026 (volet design visuel : cinq fiches `design-*.md`, 173 entrées, chacune finie par un verdict sourcé sur les règles du profil ; préchargé aussi par `designer` v4.0 ; mythes visuels ; § « Pour un choix visuel ».)
- Version 1.2 — 09.11.2026 (volet rédaction : cinq fiches `redaction-*.md`, 177 entrées, chacune finie par un verdict sourcé sur les règles du profil ; préchargé aussi par `redacteur` v3.0 ; mythes de rédaction ; § « Pour un choix visuel ou de rédaction ».)
- Version 1.3 — 09.11.2026 (volet growth : cinq fiches `growth-*.md`, 171 entrées, chacune finie par un verdict sourcé sur les règles du profil ; préchargé aussi par `growth` v3.0 ; mythes du marketing ; § « Pour un choix visuel, de rédaction ou de growth ».)
- Version 1.4 — 09.11.2026 (mythes et provenance sortis dans `references/mythes.md` et `references/provenance.md` : le préchargement passe de 40 à 20 Ko pour chaque agent qui le porte ; volet frontend à suivre.)
- Version 1.5 — 09.11.2026 (volet frontend : cinq fiches `frontend-*.md`, 174 entrées, chacune finie par un verdict sourcé sur les règles du profil ; préchargé aussi par `frontend` v3.0 ; mythes du frontend ; § « Pour un choix visuel, de rédaction, de growth ou d'implémentation ».)
- Version 1.6 — 09.11.2026 (volet backend : cinq fiches `backend-*.md`, 173 entrées, chacune finie par un verdict sourcé sur les règles du profil ; préchargé aussi par `backend` v4.0 ; mythes du backend.)
- Version 1.7 — 09.11.2026 (volet architecture : cinq fiches `architecture-*.md`, 173 entrées, chacune finie par un verdict sourcé sur les règles du profil ; préchargé aussi par `architecte` v4.0 ; mythes de l'architecture.)
- Version 1.8 — 10.11.2026 (volet sécurité : cinq fiches `securite-*.md`, 175 entrées, recherche menée du 09 au 10.11.2026, chacune finie par un verdict sourcé sur les règles du profil ; préchargé aussi par `securite` v4.0 ; mythes de la sécurité.)
- Version 1.9 — 10.11.2026 (allègement du préchargement : index détaillé des fiches et niveaux par domaine sortis dans `references/index.md`, historique des versions dans `references/provenance.md` ; de 28 à 14 Ko pour chacun des huit agents qui précharge ce skill.)
- Version 1.10 — 10.11.2026 (volet revue de code : deux fiches `revue-*.md`, 70 entrées, préchargé aussi par `reviewer` v3.0.)
- Version 1.11 — 10.11.2026 (volet tests : cinq fiches `qa-*.md`, 170 entrées, chacune finie par un verdict sourcé sur les règles de l'agent ; préchargé aussi par `qa` v3.0 ; mythes des tests.)
- Version 1.12 — 10.11.2026 (volet mise en production : cinq fiches `release-*.md`, 173 entrées, chacune finie par un verdict sourcé sur les règles de l'agent ; préchargé aussi par `release` v3.0 ; mythes de la mise en production.)
- Version 1.13 — 10.11.2026 (volet ingénierie IA : cinq fiches `ia-profils-*.md`, 175 entrées, chacune finie par un verdict sourcé sur les règles du profil ; préchargé par le nouvel agent `ingenieur-ia` ; mythes de l'ingénierie IA.)
- Version 1.14 — 11.11.2026 (première notation des skills : description complétée des volets tests, revue de code, mise en production et ingénierie IA ; « chaque fiche finit par un verdict » corrigé, les six fiches UX n'en ont pas ; dates d'instantané accordées aux 09 et 10.11.2026 ; échelle du `SKILL.md` rappelée dans `cognition-chemin-usage.md`, `redaction-microcopy.md` et `formulaires-navigation-mobile.md`, « N2 faible » qualifié dans `index.md` sans reclasser les entrées.)

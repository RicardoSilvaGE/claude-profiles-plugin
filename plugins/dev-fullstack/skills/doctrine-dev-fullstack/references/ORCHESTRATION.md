# Orchestration des sub-agents

> Source canonique : `templates/profiles/dev-fullstack/agents/ORCHESTRATION.md` (dépôt `claude-profiles`) ; la copie déployée vit dans `agents/` du home actif.
> Dernière mise à jour : 17.11.2026 (v2.44 — règle 3 et gabarit : le brief de `graphiste` donne le but, le goût et les interdits, jamais la solution ; DEHORS n'y ferme pas les choix de design. Versions antérieures : `CHANGELOG.md` § « ORCHESTRATION.md — historique des versions ».)

Ce fichier décrit le graphe d'invocation des sub-agents, leurs hand-offs et les séquences typiques. Il complète le `CLAUDE.md` global et les frontmatters de chaque agent.

## Inventaire

| Agent       | Rôle                                              | Écrit du code ? | Restriction fichiers                |
|-------------|---------------------------------------------------|-----------------|-------------------------------------|
| `muse`      | Idées improbables qui ont du sens, étincelle spontanée | Non   | `docs/MUSE/` sur demande, sinon inline |
| `brainstormer`| Idéation divergente amont (3-5 directions) | Non | `docs/BRAINSTORM/` uniquement |
| `architecte`| Cadrage feature/projet, ADR, SPEC                 | Non             | `docs/` uniquement                  |
| `architecte-donnees` | Modèle de données et son évolution, migrations sûres, audit d'une base existante (lenteur, index, intégrité), sécurité des données en base (RLS, privilèges, conservation) | Non (propose le SQL, ne l'applique pas) | `docs/DONNEES/`, `docs/AUDIT-DONNEES-*`, `docs/decisions/` (ADR de modèle) |
| `ux`        | Flows utilisateur et leur fil (la suite après chaque action), états système, audit heuristique sourcé, rejeu du parcours construit (Mode F), contenus et documents, plan d'évaluation, a11y | Non     | `docs/UX/` uniquement, en données génériques ; captures aux vraies données citées depuis `00 - CL\<sujet>\`, jamais recopiées |
| `redacteur` | Microcopy, voix et ton, i18n idiomatique, typographie par locale, relecture de traduction | Oui (locales)   | Fichiers de locales + table de chaînes ; `docs/VOIX-ET-TON.md` (Mode D) |
| `growth`    | GTM, positionnement, ASO, copy externe d'acquisition, emails, SEO, plan de mesure | Non          | `docs/GTM.md`, `docs/MESURE-*.md` + copy par asset et par locale |
| `graphiste` | Allure d'une app ou d'un écran neuf : 2 ou 3 variantes sur l'appareil visé (téléphone par défaut), vraies données | Non | canevas Claude Design privé par défaut, copie locale dans `00 - CL\<sujet>\` (planche HTML et son rendu PNG), jamais le dépôt de l'application |
| `designer`  | Système de la variante choisie, DS, prototype, recette de l'écran construit (Mode G), polish UI, critique structurée sourcée, graphiques | Non        | `docs/DESIGN-*`, configs de tokens (Mode A), assets texte SVG et HTML/CSS (Mode E), inline (Mode C) ; prototype et recette avec les vraies données : `00 - CL\<sujet>\`, jamais le dépôt |
| `backend`   | Modèles DB, endpoints, validation, auth           | Oui             | Code projet                         |
| `frontend`  | Pages, composants, intégration backend            | Oui             | Code projet                         |
| `qa`        | Stratégie de tests (unit/integration/e2e/smoke)   | Non             | `docs/TESTING-*`                    |
| `reviewer`  | Code review pré-merge                             | Non (lecture)   | Note inline (il n'a pas `Write` : un `docs/REVIEW-*` s'écrit par l'orchestrateur) |
| `auditeur`  | Audit de santé d'une base de code existante (dette, hotspots, tests, dépendances) | Non (lecture + mesures git) | `docs/AUDIT-CODE-*` |
| `securite`  | Threat model + audit OWASP/ASVS + reality check DB + réponse incident | Non (lecture)   | `docs/SECURITY-AUDIT-*`             |
| `release`   | Pre-deploy, post-deploy, migrations, incident prod | Non (commandes) | Note inline                         |
| `ingenieur-ia` | Conception, révision et mesure des textes qui pilotent les agents (doctrine, fiches, skills, descriptions, briefs) ; fonctionnalités d'IA à terme | Non (propose des diffs) | Note inline ou `docs/IA-*` |
Deux agents **transverses** (`templates/_shared/agents/`, déployés sous tous les profils) n'ont pas de ligne ici, parce qu'ils ne sont d'aucune séquence de développement : `mainteneur-profils` (cohérence de l'écosystème de profils ; reçoit le hand-off « appliquer un diff relu » de la règle 15 et les leçons d'incident qui dépassent un projet) et `agent-mails` (boîte Outlook locale, brouillons seulement).

## Qui fait quoi (17.11.2026)

Le cahier des charges de l'équipe, par activité courante (les modes plus rares sont dans les fiches). Chaque ligne **résume** une règle d'invocation, une séquence ou un paragraphe de ce fichier ou de la doctrine, cité en dernière colonne (« Arbitrer » : § « Arbitrer deux agents qui se contredisent », dernier alinéa) : la règle fait foi, la ligne y renvoie. Une ligne qui contredit sa règle, ou la fiche d'un agent, est un défaut à corriger (`/lc-bug-profil`), pas un choix à faire.

- **Fait** : propriétaire du livrable. Pour cadrer, implémenter et tester un même code, ce n'est pas un ordre de lancer un sous-agent : qui exécute suit la grille par forme de la doctrine (§ Phase 1). Une relecture, une recette ou un audit restent à l'agent nommé : on ne relit pas son propre code.
- **Apporte** : ce qui doit être remis avant, et par qui. **Contrôle** : qui relit, recette ou décide ensuite.
- Chaque fiche garde ses propres frontières (« Quand NE PAS m'invoquer », « Frontières », « Hand-off ») : un sous-agent ne lit que la sienne, sur contexte vierge.

| Activité | Fait | Apporte | Contrôle | Règle |
|---|---|---|---|---|
| Idée improbable, étincelle | `muse` | — | l'utilisateur garde ou jette | 14 |
| Problème ouvert, options à ouvrir | `brainstormer` | étincelle de `muse` (projet ou fonctionnalité neuve) | l'utilisateur choisit une direction | 1, S0 |
| Cadrer une feature, ADR, choix de stack, départager des options | `architecte` | directions de `brainstormer` si le problème était ouvert ; pour des écrans, prototype validé de `designer` et fil de `ux` | l'utilisateur tranche ; aucune option ne convient : retour à `brainstormer` Mode B | 1, 3, S1 |
| Allure d'écrans neufs ou à redessiner, en variantes | `graphiste` | parcours de `ux` ; but, goût de l'utilisateur et interdits, pas la solution ; une étincelle de `muse` au plus par planche | l'utilisateur choisit une variante | 3, 12, 14 |
| Parcours, fil, états d'un écran | `ux` (A, B) | — | `ux` Mode F rejoue l'écran construit (si le diff touche une action, sa suite ou un écran d'arrivée) | 3, 4 |
| Système visuel, design system, prototype | `designer` (A, B) | variante choisie chez `graphiste`, parcours de `ux` | l'utilisateur valide le prototype | 3 |
| Modèle de données, plan de migration, audit d'une base | `architecte-donnees` | moteur et fournisseur tranchés par `architecte` | l'utilisateur choisit les constats et le sort des lignes non conformes ; `securite` Mode C si durcissement ; `reviewer` relit la migration écrite par `backend` | 17, S16 |
| SPEC exécutable | skill `spec-builder` (contexte principal) | cadrage d'`architecte`, livrable d'`architecte-donnees` | l'utilisateur valide | 2 |
| Stratégie et matrice de tests | `qa` | SPEC | `reviewer` relit les tests contre la matrice | 8 |
| Microcopy, voix et ton, i18n | `redacteur` | états de `ux`, cadre de `designer` | locuteur natif ; `reviewer` si du code change | 10 |
| Copy externe : lancement, store, landing, e-mails marketing | `growth` | angle choisi après `brainstormer` | `redacteur` pour la voix et les traductions | 11, S10 |
| Code serveur, migration écrite, tests du code serveur | `backend` | SPEC de l'étage, livrable d'`architecte-donnees`, matrice de `qa` | `reviewer` ; `securite` (durcissement, auth, paiement, upload, données sensibles) | 2, 5, 7, 8 |
| Code client, Server Action d'un écran, câblage des chaînes, tests | `frontend` | SPEC de l'étage, états de `ux`, système de `designer`, chaînes de `redacteur`, matrice de `qa` | `reviewer` ; pour un écran, `designer` Mode G, et `ux` Mode F si une action est touchée | 2, 4 |
| Chaîne CI : mettre en place, modifier, réparer | `backend` | ce qu'elle lance : `qa` Mode A | `securite` (secrets, permissions, actions tierces) ; `reviewer` ; `release` refait build et tests au pre-deploy | 18 |
| Documentation technique : README, docs d'état, ADR | l'auteur de la livraison, dans la même livraison ; les ADR : `architecte`, `architecte-donnees` | chaque agent signale une divergence doc ↔ réalité : le brief le lui demande toujours, aucun ne le fait de lui-même | l'orchestrateur avant de clore ; une doc seule se relit en direct, pas par `reviewer` | doctrine § « Documentation des repos » |
| Relire un diff avant fusion | `reviewer` | diff complet et sa SPEC | corrections par l'auteur du diff | 4 |
| Écran existant qui ne va pas | parcours : `ux` Mode C ; rendu : `designer` Mode D ; les deux en parallèle si on ne sait pas ; à redessiner : `graphiste` Mode C | — | l'utilisateur choisit les corrections | 3 |
| Retouche de quelques tokens, polish | `designer` Mode C, ou `frontend` Mode C si elle s'applique telle quelle | — | `reviewer` si du code change | 3 |
| Recette de l'écran construit | `designer` Mode G ; `ux` Mode F si une action, sa suite ou un écran d'arrivée change | captures aux vraies données, par l'orchestrateur ou `frontend` | l'utilisateur : « c'est bien » sur son appareil | 4, S1 |
| Audit de santé d'un code existant | `auditeur` | — | l'orchestrateur répartit le plan ; correctifs par `backend` / `frontend` | 13, S12 |
| Audit de sécurité, menaces | `securite` (A, B) | passage d'hygiène d'`auditeur`, quand un audit de code a eu lieu | re-audit ciblé de `securite` | 5, 13, S4 |
| Reality check après un durcissement | `securite` Mode C | durcissement de `backend`, comptages d'`architecte-donnees` Mode C | `reviewer` vérifie le plan legacy | 7, S3 |
| Mise en production : avant, après, migration en prod | `release` (A, B, C) | plan d'`architecte-donnees` pour une migration | l'utilisateur autorise ; fusion = mise en production en déploiement continu | 5, 6, S16 |
| Production cassée | `release` Mode D ; compromission ou secret fuité : `securite` Mode D d'abord | critère d'atténuation, autorisation d'agir | post-mortem dans le Mode D | 16, S15 |
| Bug sans cause connue | skill `debug-investigation` (contexte principal) | — | correctif par `backend` / `frontend`, précédé du test qui reproduit | 16 |
| Lenteur, accessibilité d'un écran livré | skills `perf-audit`, `a11y-audit` | — | correctifs par `backend` / `frontend`, puis re-mesure | S6, S7 |
| Contenu ou document que personne ne lit | `ux` Mode D | — | `redacteur` réécrit ; `ux` Mode E pour le tester | S13 |
| Publication sur le Play Store | skill `publication-store` | audit de `securite`, fiche de `growth`, assets de `designer` Mode E | l'utilisateur signe, envoie et promeut | S11 |
| Texte qui pilote un agent | `ingenieur-ia` (propose et mesure) | trace du symptôme | `reviewer` relit le diff ; `mainteneur-profils` ou l'orchestrateur applique | 15, S14 |
| Priorités produit : quoi construire, dans quel ordre | l'utilisateur | directions de `brainstormer`, plans de mesure de `growth` Mode D et `ux` Mode E, plan d'`auditeur` ; les options résumées en trois lignes chacune | — | Arbitrer |
| Coût d'exploitation : hébergement, quotas d'API | l'utilisateur arbitre | exigence de coût au cadrage d'`architecte` (NFR) ; les options résumées en trois lignes chacune | — | Arbitrer |

## Règles d'invocation

1. **Tâche large ou idée floue** : si le problème est ouvert / mal défini, passer d'abord par `brainstormer` (idéation divergente, 3-5 directions, ne tranche pas) puis `architecte`. Si le besoin est déjà clair, commencer directement par `architecte`. Sans cadrage, on construit sur du sable. **Des options déjà posées à départager** → `architecte` (Mode B, ou C pour une brique de stack) et l'utilisateur ; aucune ne convient → `brainstormer` Mode B, qui rouvre sans choisir. Au démarrage d'un projet ou d'une fonctionnalité neuve, l'étincelle de `muse` passe avant (règle 14).
2. **Avant toute écriture de code** (`backend`, `frontend`, et `redacteur` quand il écrit des locales ; une Server Action propre à un écran est à `frontend`, le modèle et l'accès aux données qu'elle appelle à `backend`) : le cadrage de son étage doit exister — rien sous 10 lignes, une SPEC-lite de 10 à 50, une `SPEC.md` au-delà ou si structurel. Pour la `SPEC.md` → invoquer le skill `spec-builder` (pas un sub-agent). Règle absolue du 19.05.2026, trois étages depuis le 18.08.2026.
3. **`graphiste`, `ux` et `designer`** : pour les écrans d'une app ou d'une fonctionnalité visible, ils passent **avant** `architecte`, dans cet ordre : `graphiste` dessine l'allure en 2 ou 3 variantes (`ux` lui apporte le parcours), l'utilisateur choisit, `designer` fait de la variante retenue le système et le prototype que l'utilisateur valide (doctrine § « Interface d'une application »). Ailleurs, `ux` et `designer` peuvent travailler en parallèle après `architecte`. **Frontières** : `ux` pense parcours, enchaînement, états et contenu (ce qui se passe, dans quel ordre, et ce qu'on fait ensuite) ; `graphiste` propose l'allure (composition, objet principal de l'écran, ambiance) et ne fige rien ; `designer` systématise le rendu (palette, typographie, composants, états, jetons) sans réinventer l'allure choisie. Un écran « qui ne va pas » sans cause connue : parcours qui frictionne ou « pas fluide » → `ux` Mode C ; rendu → `designer` Mode D (critique sourcée, corrections dans l'allure actuelle) ; les deux en parallèle si on ne sait pas. Un écran jugé laid ou à améliorer, à redessiner (« on dirait un tableur ») → `graphiste` Mode C, avant / après en variantes. Le brief de `graphiste` donne le but, le goût de l'utilisateur (aimé, refusé, essai décevant) et les interdits, puis lui laisse dire ce qui est faible et quoi changer. Une décision de l'utilisateur s'y cite avec ses mots ; une idée de l'orchestrateur n'en est pas une (17.11.2026 : liste d'ajouts fermée, planche timide ; même agent, brief ouvert, deux propositions fortes). Retouche de quelques tokens → `designer` Mode C, ou `frontend` Mode C si elle s'applique telle quelle au composant.
4. **Avant merge** : `reviewer` systématique sur tout diff — livrables `backend` / `frontend`, code écrit en direct, diff proposé par `ingenieur-ia`. Seule exception : la tâche simple au sens de la doctrine (Phase 1 : premier étage, fichiers déjà lus), dont le filet est le hook de build. `reviewer` juge le diff, pas l'écran : pour un écran, la recette de `designer` (Mode G) s'y ajoute avant la question de fusion, et le rejeu de `ux` (Mode F) quand la PR ajoute ou change une action, ce qui la suit ou un écran d'arrivée.
5. **Avant prod** : `release` (pre-deploy check) à chaque mise en production ; `securite` (audit complet) avant la **première** mise en production et après tout changement sensible (auth, paiement, données personnelles, exposition nouvelle).
   **Dans un dépôt à déploiement continu** (fusion sur `main` = mise en ligne), **la fusion est la mise en production** : cette règle, et pour un écran la recette et l'essai de l'utilisateur, s'appliquent avant `gh pr merge`.
6. **Après prod** : `release` (post-deploy verification).
7. **Tout durcissement de validation** (Zod, regex, length min, FK) → signaler à `securite` pour reality check DB.
8. **Stratégie de tests** : projet sans stratégie → `qa` Mode A ; en début de feature, `qa` Mode B pour définir la matrice, puis `backend` / `frontend` pour écrire les tests avec le code qu'ils possèdent.
9. *(Retirée le 18.08.2026 : validation d'une stratégie de trading, partie avec l'agent `quant` dans le dépôt qui l'utilise. Le numéro reste pris.)*
10. **Textes d'interface et i18n** : pour toute microcopy (labels, CTA, erreurs, états vides, onboarding) qui n'est pas une tâche simple au sens de la doctrine (Phase 1), renommage de label, définition du ton/voix de marque, traduction ou synchro entre locales → `redacteur`. Il intervient **après** `ux`/`designer` (qui ont identifié les états et le cadre visuel) et **en amont** de `frontend` (qui câble les chaînes produites). Il **écrit lui-même les fichiers de locales** quand les clés existent déjà (renommage, traduction, synchro) et rend la table de chaînes. Une clé **nouvelle** : il l'écrit aussi dans les locales sous 10 lignes, ou de 10 à 50 avec une SPEC-lite au brief ; au-delà, il rend la table et `frontend` l'intègre avec son cadrage. Dans les deux cas, `frontend` câble la clé dans le composant. Garde-fou i18n : aucune clé dans une seule locale.
11. **Go-to-market et copy d'acquisition** : pour tout lancement, fiche store / ASO, copy de landing ou de page de vente, emails marketing (cycle de vie, onboarding produit, réactivation), positionnement ou messaging de marque **externe** → `growth`. Il intervient **après** `brainstormer` quand l'angle n'est pas encore choisi, et cadre le GTM ; en aval il fait le **hand-off** vers `designer` (déclinaison visuelle des assets), `redacteur` (cohérence de voix entre copy externe et microcopy interne) et `frontend` (mise en page de la landing). **Frontière à respecter** : `redacteur` = copy **INTERNE** (in-app, microcopy, i18n) ; `growth` = copy **EXTERNE** (acquisition, lancement, store, landing, emails) ; `brainstormer` = **idéation amont** (directions, ne rédige pas). Quand un texte vit à l'intérieur de l'app, c'est `redacteur` ; quand il sert à attirer/convertir/retenir depuis l'extérieur, c'est `growth`. Un e-mail **transactionnel** (réinitialisation de mot de passe, confirmation, reçu) est une notification du produit : `redacteur`.
12. **Design et Claude Design** (12.10.2026) : la règle vit dans la doctrine du profil (§ « Claude Design n'est pas l'agent `designer` »). Ce qu'elle implique ici : tout brief à `designer` ou `frontend` qui touche l'UI porte le lien et l'essentiel du design system de l'application, ou dit qu'il n'en existe pas ; comparer des variantes avant de coder → `graphiste` les dessine (sur un canevas Claude Design privé, par défaut), l'utilisateur choisit, `designer` systématise la variante retenue, `frontend` la code.
13. **Audit d'une base de code existante** (16.10.2026) : santé, dette technique, maintenabilité, reprise d'un dépôt inconnu, « par où commencer le ménage » → `auditeur`. **Frontières** : `reviewer` juge un **diff** contre une SPEC avant merge, `auditeur` juge l'**état** d'un dépôt sans diff ni SPEC ; `securite` modélise les **menaces**, `auditeur` ne fait qu'un passage d'hygiène (secrets en clair, lockfile, dépendances non maintenues) et lui renvoie le reste ; `perf-audit` et `a11y-audit` restent les audits spécialisés, vers lesquels `auditeur` oriente ; `architecte` décide d'une refonte que l'audit recommande. L'audit ne corrige rien : ses constats partent vers `backend`/`frontend` avec le cadrage de leur étage (§ « Séquences typiques », correctif issu d'un rapport).
14. **Idée improbable et étincelle** (30.10.2026) : « une idée folle », « sors des sentiers battus », un nom ou un angle neuf, ou un problème sur lequel on tourne en rond → `muse`. Appelable aussi **sans demande**, aux trois moments que nomme la doctrine du profil (§ Phase 1, « Étincelle »). **Frontière avec `brainstormer`** : `brainstormer` ouvre l'espace des options raisonnables et les compare, avec leurs coûts ; `muse` cherche ce qu'aucune option raisonnable n'aurait donné, et bannit d'office ce que `brainstormer` proposerait. Une graine gardée par l'utilisateur part ensuite chez `brainstormer` (ouvrir) ou `architecte` (cadrer) : elle ne saute aucun étage. **Brief** : le sujet, le moment (étincelle, séance, déraillement), ce qui a déjà été dit ou essayé, ce que l'utilisateur a fait des graines précédentes. L'idée d'une étincelle se montre telle quelle, dans un bloc marqué, sans être reformulée : la lisser, c'est la ramener au probable. Ses faits, eux, passent la vérification du retour comme ceux de tout agent : un fait marqué « vérifié » se contrôle, un fait faux se signale sous le bloc (arbitrage de l'utilisateur du 30.10.2026, audit AC-03). **Quand on bute** : un comportement cassé → débogage (règle 16), jamais d'étincelle ; une conception qui bute → étincelle possible ; des options déjà posées, ou aucune qui convienne → règle 1. **Vers `graphiste`** : une étincelle au plus par planche, qui fonde une seule variante ; l'orchestrateur n'en joint jamais une par variante (l'utilisateur, 16.11.2026 : « seulement une sur les 3 »).
15. **Textes qui pilotent les agents** (10.11.2026) : une règle écrite mais pas appliquée, un agent qui dérape, une description qui ne route pas, un socle qui grossit, un nouvel agent ou skill, un banc de comportement ou de routage à concevoir, un changement de modèle → `ingenieur-ia`. Il propose et mesure ; `mainteneur-profils` ou l'orchestrateur appliquent, `reviewer` relit le diff. Découper ou réorganiser un socle trop gros : skill `doctrine-de-depot` d'abord (où vit quoi), puis `ingenieur-ia` pour l'effet sur le modèle.
16. **Production cassée, incident, bug** : service dégradé ou cassé, après ou hors déploiement → `release` Mode D (évaluer, atténuer selon les critères pré-engagés, restaurer ; déroulé et brief : Séquence 15). Secret fuité, soupçon de compromission, comportement anormal **inexpliqué** en production (accès, données, trafic) → `securite` Mode D (contenir d'abord) ; un incident qui **ressemble** à une compromission va à `securite` d'abord. Un comportement cassé hors incident → skill `debug-investigation` dans le contexte principal (cause racine), puis le correctif, précédé du test qui le reproduit (charte de code, règle 10).
17. **Données : modèle, base existante, migration** (16.11.2026) : concevoir le schéma d'une fonctionnalité ou son évolution, auditer une base lente ou incohérente, planifier une migration sur des données existantes, concevoir l'accès et la conservation des données en base → `architecte-donnees`, **avant** `backend`. **Frontières** : `architecte` tranche le moteur, le fournisseur, le local-first et la règle de conflit d'une synchro (ADR) ; `architecte-donnees` détaille le modèle dans le moteur choisi et écrit l'ADR d'une décision de modèle ; `backend` écrit la migration, la montée de version et les tests depuis son livrable ; `release` Mode C applique en production ; `securite` audite l'accès comme surface d'attaque et garde le reality check après durcissement (règle 7) ; `perf-audit` mesure la lenteur côté page, `architecte-donnees` celle de la base. Il n'écrit dans aucune base, hors une base jetable qu'il crée sous `AUTORISÉ À`, et ne lit la production que sous `AUTORISÉ À`. Hors de lui : une colonne simple qu'une spec décrit déjà, que `backend` écrit directement.
18. **Chaîne d'intégration continue (CI)** (17.11.2026) : mettre en place, modifier ou réparer le pipeline qui lance build, tests et contrôles (`.github/workflows/` ou équivalent) → `backend`, parce que c'est du code du dépôt, sous le cadrage de son étage (règle 2). `qa` dit ce qu'elle doit lancer et comment elle traite l'instabilité (Mode A) ; `securite` relit ses secrets, ses permissions et ses actions tierces ; `reviewer` relit le diff ; `release` ne la construit pas : il refait build et tests dans les conditions de la plateforme au pre-deploy (Mode A, étape 2). Une CI rouge sans cause connue → skill `debug-investigation` d'abord (règle 16).

## Collaboration orchestrateur ↔ sub-agents

> Ajouté le 04.09.2026. Le `CLAUDE.md` § Phase 4 porte les règles opposables ; ce qui suit est
> l'outillage : gabarit, table d'arbitrage, preuves à exiger. Motif du chantier : les fiches
> d'agents décrivaient toutes ce qu'elles **rendent** (section « Hand-off »), aucune ne disait ce
> qu'elles **reçoivent**. La délégation était à sens unique.

### Ce qu'un sub-agent ne peut pas faire, et qu'on lui prête souvent

Quatre limites structurelles, dont découle tout le reste :

1. **Il démarre sur un contexte vierge.** Il n'a ni la conversation, ni les fichiers que tu as
   lus, ni les décisions déjà prises. Sa `description` et son prompt sont tout ce qu'il a.
2. **Il ne voit pas les autres agents.** `frontend` ignore ce que `ux` a produit tant que tu ne
   le lui transmets pas. Il n'y a pas de mémoire partagée entre délégations.
3. **Il ne peut pas interroger l'utilisateur.** Devant une inconnue décisive, il a deux issues : rendre
   `BLOQUÉ` (contrat d'entrée de sa fiche, depuis le 04.09.2026), ou choisir — et un choix ne
   remonte que s'il pense à l'écrire. Le brief décide laquelle il prendra.
4. **Il rend un texte, pas une preuve.** Rien dans le harness ne vérifie qu'un fichier annoncé
   existe ou qu'un test annoncé passe.

### Gabarit de brief

À recopier et remplir. Un champ sans contenu se **déclare vide** (« aucune contrainte
particulière ») plutôt que d'être supprimé : l'absence d'une ligne se lit comme un oubli, et
l'agent comblera.

```
OBJECTIF     : <une phrase> — fait quand <critère d'acceptation vérifiable>
DEDANS       : <ce qui est demandé>
DEHORS       : <ce qu'il ne doit pas toucher — fichiers, sujets, refactos tentantes>
ÉTABLI       : - fichiers déjà lus : <chemins> → <les faits qu'ils portent>
               - décisions déjà tranchées (NON rouvrables) : <liste>
               - contraintes du dépôt : <stack, conventions, CLAUDE.md local>
OUTILS       : <quoi lire en priorité, quoi ne pas ouvrir, quelles commandes lancer ou non>
AUTORISÉ À   : <ce qu'il peut faire hors du dépôt — déployer, migrer, publier — ou « rien »>
LIVRABLE     : <forme> dans <chemin exact>
RETOUR       : <résumé en contexte, ≈ 1 000 à 2 000 tokens ; le complet reste dans LIVRABLE>
HAND-OFF REÇU: <le livrable de l'agent précédent, ou « aucun »>
```

**« DEHORS » est le champ qui rapporte le plus.** Un agent compétent qui voit un défaut adjacent
le corrige — c'est son travail bien fait, et c'est un débordement de périmètre qui rend la review
impossible. Le lui interdire nommément coûte une ligne. Pour `graphiste`, DEHORS porte des interdits (fichiers, données, ce que l'utilisateur a refusé), jamais des choix de design : les fermer, c'est décider à sa place (règle 3).

**« OUTILS », « AUTORISÉ À » et « RETOUR » (05.09.2026, audit L2 et F5).** Un sub-agent a besoin
« d'un objectif, d'un format de sortie, d'indications sur les outils et sources à employer, et de
limites claires » (Anthropic, système de recherche multi-agents) : le gabarit couvrait trois des
quatre. `OUTILS` dit ce qu'il faut lire d'abord, ce qu'il ne faut **pas** ouvrir — un agent qui
lit tout le dépôt en perd le fil et le budget — et quelles commandes sont attendues ou interdites.
`AUTORISÉ À` porte l'autorisation explicite que `release` exige avant d'agir en production ;
« rien » est une réponse valable, et la plus fréquente. `RETOUR` borne ce qui revient dans ton
contexte : le livrable long se dépose sur disque, seul le résumé remonte. Un retour de
8 000 tokens n'est pas un rapport complet, c'est un livrable mal rangé.

**Où se lance la suite de tests (06.11.2026, frottement F06).** La suite complète de la CI lancée en local par un agent s'est arrêtée à 57 % faute de mémoire. Dans `OUTILS`, écrire, quand le dépôt a une CI : « la CI fait foi pour la suite complète ; en local, seulement les fichiers de test touchés ou cités » ; sans CI, nommer la commande de test voulue.

### Choisir le palier et l'effort d'un agent

À l'invocation, sans l'annoncer à l'utilisateur (Phase 1bis retirée de la doctrine le 13.11.2026). L'effort avant le modèle : baisser l'effort garde le jugement, baisser le modèle le perd. Tâche mécanique et volumineuse → le plus économique qui tienne la qualité ; conception, arbitrage, investigation → palier de la session ; erreur qui part en production ou fonde une architecture → jamais en dessous. Un regard différent sur un travail fait est un autre modèle, pas un palier.

Un `model:` épinglé dans un frontmatter s'impose à l'invocation ; seul `brainstormer` en porte un.

### Ce qu'on vérifie au retour, agent par agent

Un rapport se vérifie sur ce qui est **mécaniquement** vérifiable, avant d'être relayé à l'utilisateur.
Le contrôle prend quelques secondes ; ne pas le faire transfère à l'utilisateur le rôle de détecteur.

**La preuve est une commande dont tu lis la sortie, ou un chemin que tu ouvres — jamais une
phrase** (05.09.2026, audit L1). MAST mesure un quart des défaillances multi-agents en
vérification incorrecte, absente ou prématurée, et constate que les vérificateurs « n'effectuent
que des contrôles superficiels, bien qu'invités à vérifier en profondeur ». « Le build passe »
est une affirmation ; `tsc --noEmit`, sa sortie vide et son code 0 sont une preuve. Côté agent,
la règle miroir est dans le § Hand-off des fiches qui ont un shell et rendent une vérification (`muse`, qui n'a un shell que pour tirer au sort, ne la porte pas) : coller la sortie, jamais la résumer. Un agent sans
shell (`architecte`, `designer`, `ux`, `growth`, `brainstormer`) n'a pas de sortie à coller : sa
preuve est un extrait cité avec son fichier et sa ligne, ou une source ouverte avec son URL et sa
date, et c'est à toi de lancer la commande si le fait en demande une.

| Agent | Preuve à constater soi-même — commande dont on lit la sortie, ou chemin qu'on ouvre |
|---|---|
| `architecte`, `ux`, `designer`, `qa`, `growth`, `brainstormer` | `test -f docs/<fichier annoncé>` (ou `Read`) ; les sections que le brief exigeait s'y trouvent, par leur titre. Livrable rendu en note plutôt qu'en fichier : la note porte les rubriques exigées par le brief, et chaque fait sa ligne citée. **`qa` en plus** : `git status --short` vide de tout fichier hors `docs/TESTING-*` (ses mutants vivent dans un worktree jetable) |
| `architecte` en plus | chaque NFR du cadrage porte une mesure ou un N/A motivé, chaque risque un signal de détection, chaque ADR une alternative (ou un critère éliminatoire) et un signal de réexamen ; en Mode C, licence et activité de la dépendance vérifiées avec URL et date |
| `architecte-donnees` | `test -f` du livrable annoncé (`docs/DONNEES/<slug>.md`, `docs/AUDIT-DONNEES-<date>.md`) et des ADR cités ; `git status --short` vide hors de `docs/` ; en Mode B, chaque constat porte sa requête, sa sortie collée et la base où elle a tourné, et le rapport dit la date de départ des statistiques ; en Mode C, chaque étape a son verrou, son retour arrière (une restauration, pas un « down ») et le comptage de ce que l'existant violerait ; aucune donnée personnelle réelle dans `docs/` (une valeur lue dans une sortie, cherchée par `grep -r` dans `docs/`, ne sort pas) ; une règle tirée au hasard porte son `[Nx — source]` |
| `graphiste` | le lien du canevas Claude Design est donné (ou la voie locale était demandée) ; la planche `.png` annoncée s'ouvre (`Read`) et montre 2 ou 3 variantes, mêmes écrans, mêmes données ; le verdict est en tête et le JSON de `mesures.js` collé (sinon « REGARDÉE, NON MESURÉE » ou « PLANCHE NON REGARDÉE », avec la cause) ; les données sont réelles (source citée) ou l'exemple est annoncé en tête de planche ; rien d'écrit dans le dépôt de l'application (`git status --short`) |
| `designer` Mode G | les captures citées existent (`Read`), chacune en regard de sa planche du prototype ; le verdict CONFORME ou la table des écarts y figure ; un écart de sévérité 3-4 bloque la question de fusion |
| `ux` Mode F | chaque pas du fil a sa capture citée, qui s'ouvre (`Read`), ou est marqué NON JOUÉ ; le verdict CONFORME ou RUPTURES est en tête ; une rupture de sévérité 3-4 bloque la question de fusion ; `docs/UX/` ne recopie aucune donnée réelle (un nom lu sur une capture aux vraies données, cherché par `grep -r` dans `docs/UX/`, ne sort pas) |
| `ux`, `designer`, `growth` en plus | une recommandation tirée au hasard porte son `[Nx — source]` (ou `[N0 — style du profil]` chez `designer`), et la source se retrouve dans la bibliographie du livrable puis dans `ux-preuves/references/` ou à son URL ; chez `growth`, aucune affirmation « à sourcer » dans une version publiable, et chaque limite de store citée avec sa page officielle et sa date de lecture |
| `backend`, `frontend` | `git status --short` et `git diff --stat` : les fichiers touchés sont ceux du brief, aucun de « DEHORS » ; `npx tsc --noEmit` ou le script `build`/`check` de `package.json`, sortie collée et code 0 ; `npm test -- <fichier de test cité>` quand un test est annoncé. **`frontend` en plus, depuis la v3.0** : la Phase 0 cite les versions lues dans le lockfile ; toute dépendance ajoutée a sa vérification sur le registre collée (`npm view <nom>`) ; toute fonctionnalité de plateforme récente porte son statut Baseline avec URL et date de lecture. **`backend` en plus, depuis la v4.0** : la Phase 0 cite les versions du lockfile et les données personnelles touchées ; un test d'accès croisé (un appelant n'atteint pas l'objet d'un autre) existe pour chaque endpoint protégé livré ; la migration est fournie non appliquée, sortie de son rejeu sur une base jetable collée |
| `redacteur` | `grep -c "<clé>" <chaque fichier de locale>` : même compte partout — aucune clé présente dans une seule locale ; **depuis la v3.0** : chaque locale porte son statut de relecture (« à valider par un natif » tant qu'aucun natif ne l'a relue), et une décision tirée au hasard porte son `[Nx — source]` ou `[N0 — voix du projet]` |
| `reviewer` | pour chaque finding, `sed -n '<ligne>p' <fichier>` : la ligne existe et dit ce que le finding dit ; **depuis la v3.0** : le rapport porte sa section « Portée de la revue » (vérifié par exécution, par lecture, non examiné), et un MERGE OK cite les sorties d'exécution lues |
| `auditeur` | idem `reviewer` sur trois constats tirés au hasard ; `test -f docs/AUDIT-CODE-<date>.md` ; chaque mesure (churn, taille, couverture) porte la commande qui l'a produite, et en relancer une donne le même chiffre |
| `securite` | idem `reviewer` ; `test -f docs/SECURITY-AUDIT-<date>.md` en Mode A ; chaque constat porte sa preuve collée (test, requête) ou est rangé en « piste à confirmer » ; chaque identifiant (CVE, catégorie OWASP 2025, KEV, CVSS avec vecteur et version) a son URL et sa date de lecture ; pour chaque CRITIQUE, le diff du correctif ou la phrase d'acceptation de l'utilisateur — jamais « à traiter en suivi » |
| `release` | la commande annoncée figure dans le rapport **avec sa sortie collée** ; sans sortie, elle n'a pas été lancée |
| `ingenieur-ia` | chaque mécanisme de Claude Code cité porte sa page de doc, sa date et la version ; une mesure annoncée porte son témoin, son nombre d'essais et la sortie du banc ; une réécriture proposée chiffre son coût en contexte résident |
| `muse` | le tirage est affiché ; chaque fait marqué « vérifié » se retrouve à sa source (`sed -n '<ligne>p' <fichier>`, ou l'URL citée) ; un fait faux se signale sous le bloc d'étincelle, l'idée elle-même ne se retouche pas (règle 14) |
| `mainteneur-profils` | `git status --short` et `git diff --stat` : seuls les fichiers du brief ont bougé, rien n'est commité ; en Mode E, `git diff` rend le changement remis par le brief, sans un mot de plus, et la sortie des contrôles du Mode C (invariants, renvois croisés, compteurs) est collée, ou dite non lancée avec son motif |

### Le contrat d'entrée, et le verdict `BLOQUÉ`

Depuis le 04.09.2026, chaque fiche porte une section **« Contrat d'entrée »**, miroir du
« Hand-off » : ce que l'agent exige du brief, ce qu'il lit lui-même, et **ce qui le bloque**. Le
gabarit ci-dessus se remplit en la lisant — c'est elle qui dit ce que « ÉTABLI » doit contenir
pour cet agent-là.

Quand un point bloquant manque, l'agent rend, **à la place du livrable** :

```
BLOQUÉ — il manque : <input décisif 1>, <input décisif 2>
Établi malgré tout : <ce que la Phase 0 a permis de constater>
Avec chaque réponse possible, je ferais : <option A → …> / <option B → …>
```

**Rubrique « À mémoriser » en fin de livrable** (`reviewer`, `auditeur`, `securite`, `qa`, quand l'écriture dans leur mémoire d'agent leur est refusée) : l'orchestrateur ajoute la ligne dans `agent-memory/<agent>/` du home actif, telle quelle, ou dit à l'utilisateur qu'il ne l'a pas fait. Une leçon rendue et consignée nulle part est perdue.

À ne pas confondre avec `BLOQUE`, sans accent : c'est le verdict de `reviewer` sur un diff qu'il a **relu**.

Côté orchestrateur, un `BLOQUÉ` n'est ni un échec ni une itération : c'est le brief qui était
incomplet. **Compléter le brief et réinvoquer** ; si l'information est chez l'utilisateur, la lui poser
(`AskUserQuestion`) avec les options que l'agent a préparées — c'est exactement ce à quoi elles
servent. **Ne jamais répondre à la place de l'utilisateur pour débloquer plus vite** : c'est le choix
silencieux que le verdict existe pour empêcher, déplacé d'un cran.

Un agent qui devine là où sa fiche dit `BLOQUÉ` a violé son contrat : le lui nommer à la
reprise, comme tout autre écart.

### Quand un livrable ne convient pas

**Réinvoquer en nommant le manque**, jamais corriger soi-même en silence. Le brief de reprise
reprend le gabarit et ajoute : *ce qui manquait*, *ce qui était bon et doit être conservé*.

- **Deux itérations au plus.** À la troisième, le problème n'est presque jamais l'agent : c'est le
  brief, ou la tâche n'était pas déléguable. Reprendre en direct, et le dire dans la réponse.
- Un écart qui revient chez plusieurs agents est un défaut de **doctrine**, pas d'agent : le
  remonter (`/lc-bug-profil`) plutôt que le rattraper une troisième fois.

### Arbitrer deux agents qui se contredisent

Ne jamais trancher en silence : deux livrables contradictoires intégrés sans arbitrage produisent
un système qui ne respecte ni l'un ni l'autre. L'ordre pré-engagé, quand le conflit y tombe :

**sécurité > justesse > accessibilité > performance > esthétique**

| Conflit fréquent | Qui l'emporte, et pourquoi |
|---|---|
| `securite` exige une validation que `frontend` juge lourde | `securite`. La friction se traite par l'UX du message, pas par le retrait du contrôle |
| `designer` veut un contraste que `a11y-audit` refuse | L'accessibilité. Un critère WCAG est une norme, pas une préférence |
| `designer` voudrait changer l'allure de la variante que l'utilisateur a choisie chez `graphiste` | Le choix de l'utilisateur. `designer` systématise ; un défaut de la variante (contraste, état impossible) se corrige au plus près et se signale, la variante ne se redessine pas |
| `perf-audit` propose un cache que `backend` juge incohérent | La justesse. Un résultat faux plus vite reste faux |
| `architecte` cadre une chose, `backend` en implémente une autre | La SPEC. Si elle est fausse, on la corrige d'abord — on ne l'écarte pas en implémentant |

**Hors de cette échelle** — arbitrage produit, coût, calendrier, périmètre — l'arbitrage revient à
l'utilisateur, avec les deux positions résumées en trois lignes chacune.

### Parallélisme et conflits d'écriture

Paralléliser vaut quand les livrables sont **indépendants**. Deux paires sûres :
`ux` + `designer` après `architecte`, `qa` + `redacteur` sur une feature cadrée ; et avant la fusion, `designer` Mode G + `ux` Mode F sur la même campagne de captures.

**Jamais deux agents qui écrivent dans les mêmes fichiers.** Le second écrase le premier sans que
rien ne le signale — ni le harness, ni git, qui ne voit qu'un état final cohérent. Quand deux
agents doivent toucher la même zone, ils passent en série, et le second reçoit le hand-off du
premier.

Rappel de dépendance : `backend` attend `architecte` ; `frontend` attend `backend`, sauf contrats
stables et stub possible ; `reviewer` attend que le code soit complet — le lancer sur un travail
en cours produit une review du brouillon.

## Séquences typiques

**Correctif issu d'un rapport** (audit, finding, constat) : son cadrage suit les trois étages de la règle 2, comme tout code. Rien sous 10 lignes ; de 10 à 50, le finding tient lieu de SPEC-lite **s'il nomme objectif, périmètre et vérification** ; au-delà de 50 lignes ou dès que c'est structurel (schéma, auth, migration, contrat d'API), une `SPEC.md`. Les séquences ci-dessous écrivent « cadrage par étage » pour ce renvoi.

**Une case `[agent]` nomme le propriétaire de l'étape, pas son mode d'exécution** : comme dans le § « Qui fait quoi », des phases séquentielles du même code (cadrer, implémenter, tester) restent dans le contexte principal, sauf isolation voulue (doctrine, § Phase 1, grille par forme, qui prime).

### Séquence 0 — Idéation amont (problème ouvert / idée floue)

```
orchestrateur
   ↓
[muse] → étincelle si c'est un projet ou une fonctionnalité neuve, optionnelle sinon ; une fois par sujet (règle 14) ; idée montrée telle quelle, l'utilisateur garde ou jette
   ↓
[brainstormer] → docs/BRAINSTORM/<slug>.md : reformulation + 3-5 directions distinctes + reco (ne tranche pas)
   ↓
[orchestrateur] → pose les questions ouvertes via AskUserQuestion ; l'utilisateur choisit une direction
   ↓
[architecte] → convertit la direction retenue en ADR + SPEC ; si elle touche des écrans, après `graphiste`, `ux` et `designer` (règle 3)
   ↓
(enchaîne sur Séquence 1 après son `architecte` : étincelle, variantes, prototype et cadrage sont faits)
```

### Séquence 1 — Nouvelle feature dans projet existant

```
orchestrateur
   ↓
[muse] → étincelle, due sur une fonctionnalité neuve sauf si la Séquence 0 l'a déjà donnée (une fois par sujet, règle 14 ; coupée par « pas de Muse ») ; idée montrée telle quelle, l'utilisateur garde ou jette
   ↓
[graphiste] → planche de 2 ou 3 variantes des écrans touchés, vraies données ; [ux Mode A] apporte le parcours et son fil, dans docs/UX/ (si la feature change des écrans)
   ↓
[l'utilisateur] → choisit une variante
   ↓
[designer] → système de la variante retenue + prototype cliquable, vraies données
   ↓
[l'utilisateur] → touche le prototype, valide ou corrige
   ↓
[architecte] → docs/SPEC/<slug>.md + ADR si décision structurante ; cite le prototype validé et le fil de docs/UX/
   ↓
[architecte-donnees Mode A] → docs/DONNEES/<slug>.md : modèle, contraintes, index, accès et conservation ; Mode C si des données existent déjà (si la feature touche le schéma)
   ↓
[skill spec-builder] → SPEC.md d'exécution pour le harness
   ↓
[redacteur] → microcopy + i18n (table de chaînes par locale, si la feature a du texte UI)
   ↓
[qa Mode B] → matrice de tests, attendus gelés
   ↓
[backend] → endpoints + validation + migrations, depuis docs/DONNEES/ s'il existe (+ skill supabase-toolkit si Supabase)
   ↓
[frontend] → pages + composants + intégration (câble les chaînes du redacteur)
   ↓
[backend / frontend] → tests selon matrice qa
   ↓
[reviewer] → verdict MERGE OK / corrections / BLOQUE
   ↓
[designer Mode G] → recette : écran construit (captures, vraies données) contre prototype
   + [ux Mode F] → rejeu du fil, pas par pas, base vide puis d'usage (si la PR touche une action, ce qui la suit ou un écran d'arrivée)
   ↓
[l'utilisateur] → lien d'essai sur son appareil ; « c'est bien »
   ↓
[securite] → audit, si jamais audité ou si le changement est sensible (règle 5) — avant la mise en production
   ↓
[release Mode A] → pre-deploy check
   ↓
DEPLOY
   ↓
[release Mode B] → post-deploy verification
```

**Captures du Mode F.** L'orchestrateur (ou `frontend`, si son brief le demande) lance l'app en local et joue le fil de `docs/UX/` sur un appareil émulé : Playwright en session cloud, où il est préinstallé ; sur le poste, non vérifié. Une série sur base vide (premier usage), une sur base d'usage. Pour chaque pas : l'action jouée, l'URL atteinte, la capture de l'écran visible (une pleine page en plus si l'écran défile : elle dédouble les barres fixes, constaté sur l'application privée), et les titres, boutons, liens et messages d'état relevés. Le script de rejeu reste hors du dépôt (scratchpad ou `00 - CL`) tant que le projet n'a pas de tests de bout en bout : l'y ajouter est une dépendance à justifier. Les captures aux vraies données vont dans `00 - CL`, celles sur base vide peuvent accompagner la PR.

### Séquence 2 — Hotfix urgent (< 10 lignes, non structurel)

```
orchestrateur
   ↓
[skill debug-investigation] (si la cause n'est pas établie) → cause racine, test qui reproduit le défaut
   ↓
[backend ou frontend] → Phase -1 étage 1 (aucune spec, intention annoncée en une ligne)
   ↓
[reviewer Mode B] → spot review
   ↓
[release Mode A] → pre-deploy minimal (build + tests)
   ↓
DEPLOY
   ↓
[release Mode B] → post-deploy
```

### Séquence 3 — Durcissement de validation

```
orchestrateur
   ↓
[orchestrateur] (+ skill supabase-toolkit si Supabase), ou [architecte-donnees Mode C] si le durcissement fait partie d'une évolution de schéma → AVANT tout durcissement : compter ce que les données existantes violeraient sous la règle visée
   ↓
[orchestrateur] → l'utilisateur décide du sort des données existantes ; cadrage par étage (une contrainte ou une migration est structurelle : SPEC.md)
   ↓
[backend Mode C] → durcit le schéma Zod / regex / length, et écrit la migration legacy si un écart a été trouvé
   ↓
[securite Mode C] → reality check DB après durcissement, avant la prod : aucune donnée existante bannie, plan legacy complet
   ↓
[reviewer] → vérifie que le plan legacy est appliqué
   ↓
[release Mode C] → migration DB en prod avec backup
```

### Séquence 4 — Audit de sécurité standalone

```
orchestrateur
   ↓
[securite] (+ skill supabase-toolkit si Supabase) → rapport docs/SECURITY-AUDIT-<date>.md (Mode A) ou -<scope>.md (Mode B)
   ↓
[backend] et/ou [frontend] → correctifs selon priorité (CRITIQUE → HAUT → ...) — cadrage par étage
   ↓
[reviewer] → vérifie les correctifs
   ↓
[securite] → re-audit ciblé sur les findings corrigés (optionnel)
```

### Séquence 5 — Design system from scratch

```
orchestrateur
   ↓
[graphiste Mode A] → planche de 2 ou 3 variantes d'allure, vraies données ; l'utilisateur choisit
   ↓
[architecte] → ADR sur stack UI (Tailwind, shadcn, lib icônes)
   ↓
[designer Mode A] → docs/DESIGN-SYSTEM.md + configs de tokens ; [designer Mode B] → docs/DESIGN-DIRECTION.md d'un écran pivot
   ↓
[ux Mode A] → docs/UX/<flow-pivot>.md sur écrans clés
   ↓
[skill spec-builder] ou SPEC-lite, selon l'étage (règle 2) — frontend refuse sans elle
   ↓
[frontend Mode B] → tokens.css / tailwind.config personnalisé + 2-3 composants primitifs customisés
   ↓
[reviewer] → conformité au DS
```

### Séquence 6 — Audit performance

```
orchestrateur
   ↓
[skill perf-audit] → rapport priorisé CRITIQUE/HAUT/MOYEN/FAIBLE avec impact chiffré
   ↓
selon nature des findings :
   - N+1 SQL / index manquant → [backend] (+ skill supabase-toolkit)
   - lenteur dans la base sans cause dans le code (plans, index, bloat) → [architecte-donnees Mode B], puis [backend]
   - Re-renders / bundle / lazy load → [frontend]
   - Cache Next.js / ISR (ou l'équivalent de la stack) → [backend] ou [frontend]
   (cadrage par étage)
   ↓
[reviewer] → vérifie les correctifs
   ↓
[skill perf-audit] (re-mesure) → confirmer impact chiffré
   ↓
[release Mode A] → pre-deploy avant push
   ↓
DEPLOY
   ↓
[release Mode B] → post-deploy verification
```

### Séquence 7 — Audit accessibilité

```
orchestrateur
   ↓
[skill a11y-audit] → rapport BLOQUANT/SÉRIEUX/MODÉRÉ/MINEUR + critère WCAG cité
   ↓
[frontend] → correctifs par sévérité (BLOQUANT en premier ; cadrage par étage)
   ↓
[reviewer] → vérifie a11y dans le diff
   ↓
[skill a11y-audit] (re-test) → confirmer résolution
```

### Séquence 8 — Framework upgrade

```
orchestrateur
   ↓
[architecte Mode B] → ADR sur l'upgrade si effort > 1 jour (Mode C si l'upgrade remplace une brique)
   ↓
[skill framework-upgrade] → inventaire breaking changes + stratégie + plan rollback
   ↓
[skill spec-builder] → spec complète de l'upgrade (dépendance majeure = structurel), commitée avant le code
   ↓
[skill framework-upgrade] (Phase 5) → exécution sur branche upgrade/<framework>-<from>-to-<to>
   ↓
[reviewer] → review du diff (souvent volumineux)
   ↓
[release Mode A] → pre-deploy check sur la preview (Vercel ou équivalent du dépôt)
   ↓
DEPLOY (preview puis prod)
   ↓
[release Mode B] → post-deploy verification (LCP, INP, bundle, errors)
```

### Séquence 9 — Validation d'une stratégie de trading avant capital

> **Retirée le 18.08.2026** avec l'agent `quant`. Le numéro reste pris ; texte intégral : `CHANGELOG.md` du profil.

### Séquence 10 — Go-to-market / lancement (copy externe d'acquisition)

```
orchestrateur
   ↓
[brainstormer] (si l'angle n'est pas déjà choisi) → docs/BRAINSTORM/<slug>.md : angles de lancement, segments, propositions de valeur (ne tranche pas)
   ↓
[orchestrateur] → l'utilisateur choisit l'angle de positionnement via AskUserQuestion
   ↓
[growth] → docs/GTM.md + copy par asset et par locale : positionnement, fiche store/ASO, copy de landing/sales, séquences d'emails cycle de vie
   ↓
hand-off parallèle :
   ├─ [designer] → déclinaison visuelle des assets (landing, captures store, OG images)
   ├─ [redacteur] → alignement de voix entre copy externe (growth) et microcopy interne (in-app/i18n)
   └─ [frontend] → mise en page de la landing (sous SPEC.md) — câble la copy produite par growth
   ↓
[reviewer] → relit le diff de la landing contre sa SPEC, a11y comprise, si du code est produit (la cohérence du messaging se relit par growth et redacteur, pas par lui)
```

### Séquence 11 — Publication store (Android, Play Console)

```
orchestrateur
   ↓
[securite] → audit tous secteurs pré-store (le dépôt mesuré en a tiré deux bloquants ops : migrations prod, recovery codes)
   ↓
[skill publication-store] Phases 0-3 → brief, lecture, invariants, audit pré-release (lecture seule)
   ↓
hand-off parallèle :
   ├─ [growth Mode B] → copy de la fiche par locale, notes de release — avec les LIMITES données par le skill
   └─ [designer Mode E] → spécification des captures (rapport ≤ 2:1, 1080 × 1920 dans le dépôt mesuré : `publication-store` ; données de démonstration) et du feature graphic 1024×500,
      assets texte (SVG, HTML/CSS) ; la capture réelle et le bitmap reviennent à `frontend` ou à l'utilisateur
   ↓
[skill publication-store] Phase 4 → bump versionCode/versionName, build web + cap sync, checklist nominative
   ↓
UTILISATEUR → signature (keystore hors dépôt) + upload AAB + Data Safety / IARC dans la Console + testeurs
   ↓
[skill publication-store] Phase 7 → checklist device, ≥ 1 testeur tiers, app fermée, hors-ligne
   ↓
promotion internal → closed → open → production, une à la fois, sur décision de l'utilisateur
```

Le skill ne dit jamais « publié » : la publication est constatée dans la Console par l'utilisateur.

### Séquence 12 — Audit de santé d'une base de code existante

```
orchestrateur
   ↓
[auditeur] → docs/AUDIT-CODE-<date>.md : carte, mesures (hotspots = churn × taille), constats priorisés, plan
   ↓
selon nature des constats :
   - menace, auth, secret → [securite] (audit dédié)
   - lenteur mesurée → [skill perf-audit] ; accessibilité → [skill a11y-audit]
   - refonte de module recommandée → [architecte] (ADR si > 1 jour)
   - schéma, index, intégrité ou données incohérentes → [architecte-donnees Mode B]
   - absence de stratégie de tests → [qa] Mode A
   - correctif local → [backend] / [frontend] (cadrage par étage)
   ↓
[reviewer] → vérifie les correctifs
   ↓
[auditeur Mode D] (optionnel) → re-audit des constats traités, mêmes commandes, chiffres comparés
```

### Séquence 13 — Contenu ou document que personne ne lit (09.11.2026)

```
orchestrateur
   ↓
[ux Mode D] → docs/UX/<document>-contenu.md : questions du lecteur, constats cotés 0-4, plan cible, consignes
   ↓
[redacteur] → réécriture selon les consignes (langage clair, titres, microcopy)
   ↓
[designer] (si mise en page, tableaux ou graphiques en cause) → hiérarchie visuelle, lisibilité
   ↓
[ux Mode E] (optionnel) → protocole de test de repérage ou de compréhension ; c'est l'utilisateur qui le fait passer
```

Vaut pour une page d'aide, une documentation, un rapport, un PDF, une présentation, un e-mail
récurrent.

### Séquence 14 — Texte qui pilote un agent (règle écrite mais pas appliquée, fiche, skill, description)

```
orchestrateur
   ↓
[ingenieur-ia] → diagnostic sur la trace du symptôme, diff proposé, coût en contexte, mesure à lancer (ne modifie rien)
   ↓
[reviewer] → relit le diff proposé contre l'intention annoncée
   ↓
[orchestrateur] → validation de l'utilisateur si le diff touche une règle de doctrine
   ↓
[mainteneur-profils Mode E] ou orchestrateur → applique le diff relu, tel quel ; contrôles du Mode C
   ↓
[orchestrateur] → commit ; dans le dépôt de profils, plugin régénéré ; banc de comportement ou de routage si la mesure le demande
```

### Séquence 15 — Incident de production (règle 16)

Tri, comme la règle 16 : secret fuité, soupçon de compromission, comportement anormal inexpliqué → branche A ; service dégradé ou cassé dont rien n'indique une compromission → branche B. Dans le doute, A d'abord.

```
A. [securite Mode D] → contenir (un secret isolé se révoque avant de comprendre ; une intrusion installée
                       se recense d'abord, sans l'alerter, puis se coupe d'un coup), préserver les preuves,
                       évaluer l'exposition, chercher l'usage abusif, purger après la rotation,
                       question d'annonce (PFPDT, autorité UE) posée à l'utilisateur, post-mortem

B. [release Mode D]  → évaluer, atténuer (flag coupé, sinon retour arrière ; correctif en avant en dernier, écrit par backend ou frontend),
                       conserver les preuves, vérifier le rétablissement, post-mortem
```

Le post-mortem est rendu **dans** l'invocation du Mode D, avec ce qui est établi à ce moment-là ; une leçon qui dépasse le projet part à `mainteneur-profils`.

**Ce que le brief du Mode D doit porter**, sinon l'agent rend `BLOQUÉ` ou ne fait que prescrire :
- à `release` : la cible, l'**autorisation explicite d'agir en production** (sans elle, un go / no-go, rien d'exécuté), et le **critère d'atténuation** — celui écrit au pre-deploy, ou, pour un incident hors déploiement, celui que l'utilisateur donne maintenant, dans les mêmes termes (signal, référence de comparaison, durée, volume) ;
- à `securite` : ce qui a fuité ou est soupçonné, où, depuis quand, et la ligne `AUTORISÉ À` pour ce qu'il peut exécuter lui-même (confinement : rotation, invalidation, coupure ; export des journaux ; réécriture d'historique). Sans elle, il prescrit les gestes, l'utilisateur ou l'orchestrateur les exécutent.

Une fois l'incident clos (service rétabli, ou accès contenu), et seulement si la cause n'est pas établie :

```
[skill debug-investigation] → cause racine, test qui reproduit le défaut
   ↓
Correctif : Séquence 2 s'il tient sous 10 lignes non structurelles, sinon cadrage par étage puis Séquence 1
```

### Séquence 16 — Base de données existante : audit, puis migration sûre (16.11.2026)

```
orchestrateur
   ↓
[architecte-donnees Mode B] → docs/AUDIT-DONNEES-<date>.md : advisors, requêtes qui coûtent, index, intégrité, comptages (lecture seule ; production sous AUTORISÉ À)
   ↓
[l'utilisateur] → choisit les constats à traiter et le sort des lignes non conformes
   ↓
[architecte-donnees Mode C] → docs/DONNEES/<slug>-migration.md : étapes, verrous, comptages, essai sur copie, retour arrière (SQL proposé, non appliqué)
   ↓
[skill spec-builder] → spec complète (une migration est structurelle), commitée avant le code
   ↓
[backend] (Mode A pour une table neuve, B, ou C si durcissement) → fichier de migration, montée de version, tests ; migration rejouée sur une base jetable, sortie collée
   ↓
[securite Mode C] → reality check, si la migration durcit une contrainte (règle 7)
   ↓
[reviewer] → relit le diff contre la spec et le plan
   ↓
[release Mode C] → sauvegarde identifiée, application en production, vérification
```

Pour une application hors ligne (IndexedDB, SQLite sur le téléphone), `release` n'a pas de base à migrer : la montée de version part avec la publication de l'application, et l'essai se fait sur un export réel, hors du dépôt (`00 - CL`).

## Squelette d'une fiche et clés de frontmatter

Ne sont plus ici depuis le 11.11.2026 : ils servent à **écrire** une fiche, pas à router une demande. Le squelette commun des fiches et le registre des clés de frontmatter posées (`skills:`, `disallowedTools:`, `memory: user`, `model:`) sont dans `HOW-TO-ADD.md`, même dossier, § « Pattern obligatoire ». Ce qu'il faut en savoir pour orchestrer : un agent sans `Bash` ne lance rien, un agent sans `Write` rend une note, et aucune de ces clés ne restreint les **chemins** — le champ DEHORS du brief reste la seule barrière sur le *où*.

## Anti-patterns d'orchestration

- **Sauter `brainstormer` sur un problème vraiment ouvert** : on cadre la première idée venue au lieu d'avoir comparé les directions.
- **Lisser une étincelle de `muse`** : la reformuler, l'assortir d'avantages et d'inconvénients ou la rendre « raisonnable » avant que l'utilisateur l'ait lue, c'est la ramener à la réponse probable qu'elle devait éviter. On montre l'idée telle quelle ; le tri vient après, et c'est lui qui le fait. Contrôler ses faits n'est pas la lisser.
- **Sauter `architecte` sur une feature non triviale** : on récupère la dette en double dans 3 mois.
- **Invoquer `frontend` ou `backend` sans le cadrage de son étage** (règle 2).
- **Sauter `reviewer` pour gagner du temps** : on s'expose à des findings qu'on aurait détectés en 5 minutes.
- **Sauter `release` Mode A** : on découvre les vars d'env manquantes en prod.
- **Durcir une validation sans signaler à `securite`** : on bannit silencieusement des users existants (cf. incident du 21.05.2026).
- **Faire écrire des tests sans matrice `qa` préalable** : tests sans stratégie cohérente.
- **Faire tout en parallèle** : les dépendances sont au § « Parallélisme et conflits d'écriture ».

## Skills associées (non sub-agents, exécutées dans le contexte principal)

### Cadrage / écriture
- `spec-builder` : produit la SPEC.md d'exécution destinée au harness. **Obligatoire au-delà de 50 lignes ou sur du structurel (règle 19.05.2026) ; une SPEC-lite suffit de 10 à 50 lignes.**
- ~~`test-builder`~~ : **jamais livré par ce profil** (outil d'un bundle externe). L'écriture des tests revient à `backend` / `frontend`, à partir de la matrice de `qa` Mode B : celui qui écrit le code écrit ses tests.

- `charte-code` (créé 04.09.2026) : détail des onze règles opposables de la charte de code du
  `CLAUDE.md` — motifs, contre-exemples, cas limites, grille de review. **Préchargé** par
  `backend`, `frontend`, `reviewer` et `auditeur` : ces quatre-là ne peuvent ni écrire ni juger du code sans
  l'avoir sous les yeux. Il ne remplace pas `reviewer` : il est son référentiel.

### Construction
- `librairie-maison` (créé 25.08.2026) : socles de démarrage repris de code en service (non rejoués dans le skill), en deux jeux étiquetés. **Frontière avec `frontend-app-builder`** : celui-ci *génère* une application à partir d'un cadrage, `librairie-maison` *fournit des pièces* à recopier — HTTPS local auto-signé, conversion `.docx` → PDF, manifeste PWA, montage React in-browser. Les deux se composent : le builder construit, la librairie évite de réécrire ce qui existe. Elle intervient au **barreau 2bis** de l'échelle du moindre code de `backend` / `frontend`, jamais à la place du barreau 1 (« est-ce que ça doit exister ? »).
- `frontend-app-builder` : génération d'apps complètes **Vite** (hand-off nommé par le skill : `reviewer`, `designer`, `qa`, `release`). Renvoi croisé avec `librairie-maison` dans les deux descriptions depuis le 05.09.2026 : « nouvelle application » se routait vers trois skills qui ne se citaient pas (le troisième étant le défaut Next.js de la doctrine).
- ~~`modern-app-design`~~ : **jamais livré par ce profil** (outil d'un bundle externe). La direction visuelle est le domaine du sub-agent `designer`.
- ~~`ui-polish`~~ : **jamais livré par ce profil** (outil d'un bundle externe). Le polish ciblé passe par `frontend` Mode C, ou `designer` Mode C quand la retouche engage les tokens.
- `claude-api` : développement d'apps qui utilisent l'API Anthropic.

### Audit / analyse
- ~~`code-audit`~~ : **jamais livré par ce profil** (outil d'un bundle externe). L'audit généraliste est le sub-agent `auditeur` depuis le 16.10.2026 (séquence 12) ; les trois audits spécialisés restent `securite` (OWASP), `perf-audit` et `a11y-audit`, plus `reviewer` en pré-merge.
- `supabase-toolkit` (créé 21.05.2026) : conception et audit de RLS, RPC, migrations Supabase + reality check data legacy. Hand-off vers `securite` ou `release` Mode C. Préchargé par `backend` ; `architecte-donnees` l'invoque à la demande sur un projet Supabase.
- `perf-audit` (créé 21.05.2026) : Web Vitals + bundle + N+1 + re-renders. Hand-off vers `backend` ou `frontend`.
- `atelier-graphiste` (créé 13.11.2026) : **préchargé par `graphiste` seul**, jamais appelé en direct — `mesures.js` (contraste, débordements, cibles, polices rendues d'une planche) des outils de rendu et de mesure sur pixels (`outils/` depuis le 16.11.2026 : `releve.js`, `pixels.py`, `aquarelle.py`, `studio3d.html`) et six dossiers de recherche sur le beau visuel (dont, depuis le 15.11.2026, les sites et applications primés, source de règles de création et non de modèles à copier), indexés par étape de la fiche.
- `a11y-audit` (créé 21.05.2026) : audit WCAG 2.2 AA ex-post sur composant ou page. Complète le sub-agent `ux`.
- `ux-preuves` (créé 09.11.2026) : référentiel de preuves sourcées — échelle N0-N4, citation, veille, sévérité 0-4, et des fiches par domaine dont chaque entrée cite une page lue et datée. **Préchargé** par quatorze agents, chacun avec son volet : `ux`, `designer`, `graphiste` (volet design visuel), `redacteur`, `growth`, `frontend`, `backend`, `architecte`, `securite`, `reviewer`, `qa`, `release`, `ingenieur-ia`, `architecte-donnees` (volet données ; contenu des volets et versions : `references/provenance.md` du skill). **Frontière avec `a11y-audit`** : `ux-preuves` dit ce que la recherche et les normes établissent, `a11y-audit` vérifie un écran implémenté critère par critère.
- `debug-investigation` (créé 21.05.2026) : investigation structurée bug → cause racine → test qui reproduit le défaut → correctif.
- ~~`quant-toolkit`~~ : **parti le 18.08.2026** dans `<depot-prive>` avec l'agent `quant`.

- `publication-store` (créé 04.09.2026) : publication Android via Capacitor sur le Play Store —
  invariants d'identité (`applicationId`, `versionCode`, keystore + Play App Signing), AAB signé,
  tracks, Data Safety, IARC, limites de la fiche et formats des assets, App Links, validation sur
  device, pièges Android 15+ mesurés. **Mesuré sur un seul dépôt ; iOS hors périmètre.** Frontières :
  la copy de la fiche revient à `growth`, les visuels à `designer`, le déploiement web à `release`.
  Séquence 11.

### Maintenance / opérations
- `garde-fous-powershell` (créé 05.09.2026) : la table complète des garde-fous PowerShell 5.1, sortie du résident du `CLAUDE.md` (qui n'en garde que quatre règles) — BOM, arrays imbriqués, `-replace` Unicode, audit post-batch et ses motifs mojibake, cible = fichier, sorties ASCII. À charger avant tout `.ps1` ou toute écriture de fichier par PowerShell, et avant d'éditer par script (Git Bash, Python) un fichier accentué ou en CRLF ; sans objet en session cloud, sauf pour un `.ps1` destiné au poste.
- `framework-upgrade` (créé 21.05.2026) : upgrade Next.js / React / Tailwind / shadcn / TypeScript / Node. Hand-off `release` Mode A avant merge prod.
- `update-config` / `keybindings-help` / `fewer-permission-prompts` : config harness Claude Code.
- `loop` : automatisation récurrente. (`schedule`, mesuré natif le 25.08.2026, n'est plus énuméré par le harness depuis le 19.10.2026 : ne pas y renvoyer sans le revoir dans la liste de la session.)
- `doctrine-de-depot` : socle sous plafond, index par déclencheur, règles par thème et gardes documentaires d'un dépôt ; à charger quand un `CLAUDE.md` devient trop gros ; l'effet sur le modèle, et une règle écrite mais pas appliquée, vont ensuite à `ingenieur-ia` (règle 15).
- `simplify` : review du code modifié pour reuse / quality / efficiency (différent de `reviewer` qui fait du pré-merge structurel).
- `travail-autonome` (créé 27.10.2026) : méthode d'une **étape** de mission autonome, injectée par
  `scripts/travail-autonome/lanceur.py` dans chaque `claude -p` (ADR-0006 de `claude-profiles`) ; sert aussi en
  session normale pour écrire une mission et dire où elle en est. Une étape délègue aux agents nommés par la mission,
  avec le gabarit de brief de ce fichier. **Frontière avec `loop`** : il répète une invite ;
  ce skill porte une mission longue dont l'état vit sur disque et que le lanceur borne.

### À éviter (doublons avec sub-agents)
- `code-review` (plugin) : préférer le sub-agent `reviewer` (même contrat de sortie que les autres agents).
- `security-review` (plugin) : préférer le sub-agent `securite` (a la Phase 0 DB reality check).
- skills d'audit généraliste de bundles externes (dette technique, audit de code), quand la session les expose : préférer le sub-agent `auditeur` (Phase 0, mesures reproductibles, contrat d'entrée).

## Mise à jour de ce fichier

Quand un agent est ajouté, retiré ou change de périmètre, sept pièces de ce fichier le nomment :

1. Le tableau d'inventaire (contrôlé par `test-conformite-fiches-agents.sh`, R16).
2. Les règles d'invocation, frontières avec les voisins comprises.
3. Le tableau « Ce qu'on vérifie au retour ».
4. La ou les séquences où il intervient, avec le bon Mode.
5. « Skills associées », s'il précharge ou remplace un skill.
6. Le § « Qui fait quoi », pour chaque activité courante qu'il fait, apporte ou contrôle.
7. La date et la version en tête ; la version remplacée part dans `CHANGELOG.md` du profil.

Hors de ce fichier : le registre des clés de `HOW-TO-ADD.md` si le frontmatter en pose une, et la doctrine du profil (`global-CLAUDE.md`, § « Ton équipe » et table de la Phase 1) si la règle d'orchestration change.

Pour le pattern à respecter lors de la création d'un sub-agent ou d'un skill : `HOW-TO-ADD.md`, dans le même dossier `agents/` du home actif.

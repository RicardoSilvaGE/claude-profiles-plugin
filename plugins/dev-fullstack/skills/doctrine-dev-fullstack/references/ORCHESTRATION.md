# Orchestration des sub-agents

> Source canonique : `templates/profiles/dev-fullstack/agents/ORCHESTRATION.md` (dépôt `claude-profiles`) ; la copie déployée vit dans `agents/` du home actif.
> Dernière mise à jour : 05.09.2026 (v2.5 — PR 2.1 de l'audit du 05.09 : l'historique des versions, 5 254 octets lus à chaque Phase 0, part dans `CHANGELOG.md` § « ORCHESTRATION.md — historique des versions » ; séquence 9 réduite à sa note de retrait ; skill `garde-fous-powershell` inscrit ; renvoi croisé `frontend-app-builder` ↔ `librairie-maison`.)

Ce fichier décrit le graphe d'invocation des sub-agents, leurs hand-offs et les séquences typiques. Il complète le `CLAUDE.md` global et les frontmatters de chaque agent.

## Inventaire

| Agent       | Rôle                                              | Écrit du code ? | Restriction fichiers                |
|-------------|---------------------------------------------------|-----------------|-------------------------------------|
| `brainstormer`| Idéation divergente amont (3-5 directions) | Non | `docs/BRAINSTORM/` uniquement |
| `architecte`| Cadrage feature/projet, ADR, SPEC                 | Non             | `docs/` uniquement                  |
| `ux`        | Flows utilisateur, états système, audit heuristique, a11y | Non     | `docs/UX/` uniquement               |
| `redacteur` | Microcopy, voix de marque, i18n idiomatique       | Oui (locales)   | Fichiers de locales + table de chaînes |
| `growth`    | GTM, positionnement, ASO, copy externe d'acquisition | Non          | `docs/GTM.md` + copy par asset et par locale |
| `designer`  | Direction visuelle, DS, polish UI, critique structurée | Non        | `docs/DESIGN-*`, inline (Mode C)    |
| `backend`   | Modèles DB, endpoints, validation, auth           | Oui             | Code projet                         |
| `frontend`  | Pages, composants, intégration backend            | Oui             | Code projet                         |
| `qa`        | Stratégie de tests (unit/integration/e2e/smoke)   | Non             | `docs/TESTING-*`                    |
| `reviewer`  | Code review pré-merge                             | Non (lecture)   | Note inline (ou `docs/REVIEW-*`)    |
| `securite`  | Threat model + audit OWASP/ASVS + reality check DB + réponse incident | Non (lecture)   | `docs/SECURITY-AUDIT-*`             |
| `release`   | Pre-deploy, post-deploy, migrations, incident prod | Non (commandes) | Note inline                         |

## Règles d'invocation

1. **Tâche large ou idée floue** : si le problème est ouvert / mal défini, passer d'abord par `brainstormer` (idéation divergente, 3-5 directions, ne tranche pas) puis `architecte`. Si le besoin est déjà clair, commencer directement par `architecte`. Sans cadrage, on construit sur du sable.
2. **Avant toute écriture de code** (`backend`, `frontend`) : la SPEC.md doit exister. Si elle n'existe pas → invoquer le skill `spec-builder` (pas un sub-agent). Règle absolue du 19.05.2026.
3. **Parallélisation autorisée** : `ux` + `designer` peuvent travailler en parallèle après `architecte`.
4. **Avant merge** : `reviewer` systématique sur livrables `backend` / `frontend`.
5. **Avant prod** : `securite` (audit complet) + `release` (pre-deploy check).
6. **Après prod** : `release` (post-deploy verification).
7. **Tout durcissement de validation** (Zod, regex, length min, FK) → signaler à `securite` pour reality check DB.
8. **Stratégie de tests** : invoquer `qa` en début de feature (Mode B) pour définir la matrice, puis `backend` / `frontend` pour écrire les tests avec le code qu'ils possèdent.
9. ~~Validation d'une stratégie de trading avant capital.~~ **Retirée le 18.08.2026** : l'agent `quant` et le skill `quant-toolkit` sont partis dans `<depot-prive>`, le dépôt qui les utilise (9 livrables `docs/QUANT-*` y vivaient déjà, et son `CLAUDE.md` exige la validation avant capital réel). Ils y sont des assets **propres au dépôt** : versionnés dans son `.claude/`, préservés par `sync-profile.sh` qui ne détruit jamais un fichier suivi par git. La séquence garde son numéro : renuméroter casserait les renvois « séquence N » des autres fiches.
10. **Textes d'interface et i18n** : pour toute microcopy (labels, CTA, erreurs, états vides, onboarding), renommage de label, définition du ton/voix de marque, traduction ou synchro entre locales → `redacteur`. Il intervient **après** `ux`/`designer` (qui ont identifié les états et le cadre visuel) et **en amont** de `frontend` (qui câble les chaînes produites). Il produit une table de chaînes par locale ; `frontend` l'intègre. Garde-fou i18n : aucune clé dans une seule locale.
11. **Go-to-market et copy d'acquisition** : pour tout lancement, fiche store / ASO, copy de landing ou de page de vente, emails marketing (cycle de vie, onboarding produit, réactivation), positionnement ou messaging de marque **externe** → `growth`. Il intervient **après** `brainstormer` (qui a ouvert les directions de lancement) et cadre le GTM ; en aval il fait le **hand-off** vers `designer` (déclinaison visuelle des assets), `redacteur` (cohérence de voix entre copy externe et microcopy interne) et `frontend` (mise en page de la landing). **Frontière à respecter** : `redacteur` = copy **INTERNE** (in-app, microcopy, i18n) ; `growth` = copy **EXTERNE** (acquisition, lancement, store, landing, emails) ; `brainstormer` = **idéation amont** (directions, ne rédige pas). Quand un texte vit à l'intérieur de l'app, c'est `redacteur` ; quand il sert à attirer/convertir/retenir depuis l'extérieur, c'est `growth`.

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
LIVRABLE     : <forme> dans <chemin exact>
HAND-OFF REÇU: <le livrable de l'agent précédent, ou « aucun »>
```

**« DEHORS » est le champ qui rapporte le plus.** Un agent compétent qui voit un défaut adjacent
le corrige — c'est son travail bien fait, et c'est un débordement de périmètre qui rend la review
impossible. Le lui interdire nommément coûte une ligne.

### Ce qu'on vérifie au retour, agent par agent

Un rapport se vérifie sur ce qui est **mécaniquement** vérifiable, avant d'être relayé à l'utilisateur.
Le contrôle prend quelques secondes ; ne pas le faire transfère à l'utilisateur le rôle de détecteur.

| Agent | Preuve minimale à constater soi-même |
|---|---|
| `architecte`, `ux`, `designer`, `qa`, `growth`, `brainstormer` | Le fichier annoncé dans `docs/` existe et couvre le périmètre du brief |
| `backend`, `frontend` | Le diff existe ; le build ou `tsc --noEmit` passe ; les fichiers « DEHORS » n'ont pas bougé (`git status`) |
| `redacteur` | Aucune clé présente dans une seule locale |
| `reviewer` | Chaque finding pointe un fichier et une ligne qui existent |
| `securite` | Chaque finding pointe un fichier existant ; les CRITIQUE sont traités ou explicitement acceptés |
| `release` | La commande annoncée a été exécutée et sa sortie est citée, pas résumée |

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
| `perf-audit` propose un cache que `backend` juge incohérent | La justesse. Un résultat faux plus vite reste faux |
| `architecte` cadre une chose, `backend` en implémente une autre | La SPEC. Si elle est fausse, on la corrige d'abord — on ne l'écarte pas en implémentant |

**Hors de cette échelle** — arbitrage produit, coût, calendrier, périmètre — l'arbitrage revient à
l'utilisateur, avec les deux positions résumées en trois lignes chacune.

### Parallélisme et conflits d'écriture

Paralléliser vaut quand les livrables sont **indépendants**. Deux paires sûres :
`ux` + `designer` après `architecte`, `qa` + `redacteur` sur une feature cadrée.

**Jamais deux agents qui écrivent dans les mêmes fichiers.** Le second écrase le premier sans que
rien ne le signale — ni le harness, ni git, qui ne voit qu'un état final cohérent. Quand deux
agents doivent toucher la même zone, ils passent en série, et le second reçoit le hand-off du
premier.

Rappel de dépendance : `backend` attend `architecte` ; `frontend` attend `backend`, sauf contrats
stables et stub possible ; `reviewer` attend que le code soit complet — le lancer sur un travail
en cours produit une review du brouillon.

## Séquences typiques

### Séquence 0 — Idéation amont (problème ouvert / idée floue)

```
orchestrateur
   ↓
[brainstormer] → docs/BRAINSTORM/<slug>.md : reformulation + 3-5 directions distinctes + reco (ne tranche pas)
   ↓
[orchestrateur] → pose les questions ouvertes via AskUserQuestion ; l'utilisateur choisit une direction
   ↓
[architecte] → convertit la direction retenue en ADR + SPEC
   ↓
(enchaîne sur Séquence 1)
```

### Séquence 1 — Nouvelle feature dans projet existant

```
orchestrateur
   ↓
[architecte] → docs/SPEC/<slug>.md + ADR si décision structurante
   ↓
[skill spec-builder] → SPEC.md d'exécution pour le harness
   ↓
[ux] + [designer] (parallèle)
   ↓
[redacteur] → microcopy + i18n (table de chaînes par locale, si la feature a du texte UI)
   ↓
[qa] → matrice de tests (Mode B)
   ↓
[backend] → endpoints + validation + migrations (+ skill supabase-toolkit si Supabase)
   ↓
[frontend] → pages + composants + intégration (câble les chaînes du redacteur)
   ↓
[backend / frontend] → tests selon matrice qa
   ↓
[reviewer] → verdict MERGE OK / corrections / BLOQUE
   ↓
[release Mode A] → pre-deploy check
   ↓
DEPLOY
   ↓
[release Mode B] → post-deploy verification
   ↓
[securite] (audit pré-prod si jamais audité, ou après changement sensible)
```

### Séquence 2 — Hotfix urgent (≤ 5 lignes)

```
orchestrateur
   ↓
[backend ou frontend] → exception Phase -1 (hotfix justifié, signalé explicitement)
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
[backend] → durcit le schéma Zod / regex / length
   ↓ (signalement explicite obligatoire)
[securite Mode C] + [skill supabase-toolkit] → reality check DB (Phase 0)
   ↓
[backend] → migration data legacy si gap détecté (SPEC-lite si > 10 lignes : le rapport de securite en tient lieu s'il nomme objectif, périmètre, vérification)
   ↓
[reviewer] → vérifie que le plan legacy est appliqué
   ↓
[release Mode C] → migration DB en prod avec backup
```

### Séquence 4 — Audit de sécurité standalone

```
orchestrateur
   ↓
[securite] (+ skill supabase-toolkit si Supabase) → rapport docs/SECURITY-AUDIT-<date>-<mode>.md
   ↓
[backend] et/ou [frontend] → correctifs selon priorité (CRITIQUE → HAUT → ...) — chaque correctif > 10 lignes part avec sa SPEC-lite, le finding en tient lieu
   ↓
[reviewer] → vérifie les correctifs
   ↓
[securite] → re-audit ciblé sur les findings corrigés (optionnel)
```

### Séquence 5 — Design system from scratch

```
orchestrateur
   ↓
[architecte] → ADR sur stack UI (Tailwind, shadcn, lib icônes)
   ↓
[designer Mode A] → docs/DESIGN-SYSTEM.md + docs/DESIGN-DIRECTION.md
   ↓
[ux Mode A] → docs/UX/<flow-pivot>.md sur écrans clés
   ↓
[frontend Mode A] → tokens.css / tailwind.config personnalisé + 2-3 composants primitifs customisés
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
   - Re-renders / bundle / lazy load → [frontend]
   - Cache Next.js / ISR (ou l'équivalent de la stack) → [backend] ou [frontend]
   (chaque correctif > 10 lignes part avec sa SPEC-lite ; le finding du rapport en tient lieu)
   ↓
[reviewer] → vérifie les correctifs
   ↓
[skill perf-audit] (re-mesure) → confirmer impact chiffré
   ↓
[release Mode A] → pre-deploy avant push
```

### Séquence 7 — Audit accessibilité

```
orchestrateur
   ↓
[skill a11y-audit] → rapport BLOQUANT/SÉRIEUX/MODÉRÉ/MINEUR + critère WCAG cité
   ↓
[frontend] → correctifs par sévérité (BLOQUANT en premier ; SPEC-lite par correctif > 10 lignes, le finding en tient lieu)
   ↓
[reviewer] → vérifie a11y dans le diff
   ↓
[skill a11y-audit] (re-test) → confirmer résolution
```

### Séquence 8 — Framework upgrade

```
orchestrateur
   ↓
[architecte] (Mode C — décision unique) → ADR sur l'upgrade si effort > 1 jour
   ↓
[skill framework-upgrade] → inventaire breaking changes + stratégie + plan rollback
   ↓
[skill framework-upgrade] (Phase 5) → exécution sur branche upgrade/<framework>-<from>-to-<to>
   ↓
[reviewer] → review du diff (souvent volumineux)
   ↓
[release Mode A] → pre-deploy check sur preview Vercel
   ↓
DEPLOY (preview puis prod)
   ↓
[release Mode B] → post-deploy verification (LCP, INP, bundle, errors)
```

### Séquence 9 — Validation d'une stratégie de trading avant capital

> **Séquence retirée le 18.08.2026** avec l'agent `quant` et le skill `quant-toolkit`, partis dans
> le dépôt qui les utilise. Le numéro est conservé pour que les séquences suivantes ne bougent pas ;
> **aucune fiche de ce profil n'y renvoie** (grep du 05.09.2026 : zéro). Une session ouverte sur ce
> dépôt-là voit un `quant` que ce dépôt déploie lui-même, pas le profil. Texte intégral de la
> séquence : `CHANGELOG.md` § « ORCHESTRATION.md — historique des versions ».

### Séquence 10 — Go-to-market / lancement (copy externe d'acquisition)

```
orchestrateur
   ↓
[brainstormer] → docs/BRAINSTORM/<slug>.md : angles de lancement, segments, propositions de valeur (ne tranche pas)
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
[reviewer] → cohérence messaging + a11y de la landing si du code est produit
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
   └─ [designer] → captures 1080×2400 sur données de démonstration, feature graphic 1024×500
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

## Pattern partagé entre agents

Tous les sub-agents (v2 — depuis 21.05.2026) suivent le même squelette :

1. **Frontmatter** : `name` + `description` courte (2-3 lignes max) focalisée sur le trigger. Les champs `tools` et `model` ne sont déclarés **que pour restreindre** un agent (liste blanche d'outils, ou modèle épinglé) ; omis, l'agent hérite de tous les outils et du modèle par défaut. Seul `brainstormer` les déclare aujourd'hui (`tools` sans `Edit`/`Bash`, car il ne modifie jamais le code ; `model: opus` pour le raisonnement divergent) — exception assumée, pas un oubli sur les onze autres.
   Onze fiches n'ont pas de `model:` parce que la Phase 1bis raisonne **par tâche**, pas par agent : un `model:` épinglé contredirait l'annonce de palier.

   **Registre des clés de frontmatter posées, au 19.08.2026** (complété le 05.09.2026) — les compter dans les fichiers, jamais dans ce tableau, qui est le reflet et non la source :

   | Clé | Où | Ce qu'elle fait, et ce qui la casse |
   |---|---|---|
   | `skills:` | `backend` (`supabase-toolkit`, `charte-code`), `frontend` (`a11y-audit`, `charte-code`), `reviewer` (`charte-code`) | Précharge le skill en entier au démarrage. **Exclusif avec `paths:`** sur le skill visé : poser un `paths` vide la ligne de son effet **en silence** (vérifié par témoin le 17.08.2026, absent de la documentation officielle). **En revanche, PAS exclusif avec `context: fork`** : mesuré par témoin le 19.08.2026, les deux cohabitent — le skill reste préchargé, et une invocation depuis un sous-agent s'exécute bien en fork imbriqué. Ne pas généraliser la première exclusion à la seconde par analogie : c'est l'erreur qui a été commise, puis corrigée par la mesure. |
   | `observer:` + `observerMessage:` | `backend`, `frontend` | Lance un agent en observateur de fond pendant que l'agent travaille, et lui adresse des digests d'activité. Posé sur les agents qui **produisent** le code, jamais sur ceux qui le contrôlent : l'écart entre demandé et livré naît chez le producteur. `observerMessage` est restrictif à dessein (quatre motifs, silence sinon) — un observateur qui commente tout n'est plus lu. |
   | `memory: user` | `reviewer` | Mémoire persistante propre à l'agent (`agent-memory/reviewer/` du home), pour que le même défaut vu sur trois dépôts devienne une règle. **Éphémère en session cloud** (plugin) : le home du conteneur ne survit pas. Absente de `backup-memoire.ps1` (à vérifier avant de s'y fier). |

2. **Version** : ligne en tête juste après le frontmatter.
3. **Modes** : A / B / C (parfois D), détectés en Phase 0, déclarés en début de livrable.
4. **Skills à invoquer ou MCPs à utiliser** : si applicable.
5. **Phase -1** (pour les agents qui écrivent du code) : vérification SPEC.md (règle 19.05.2026).
6. **Phase 0 — Lecture obligatoire (HARD GATE)** : citation des sources lues avant toute proposition.
7. **Workflow numéroté**.
8. **Garde-fous (règles dures)**.
9. **Anti-patterns**.
10. **Anti-hallucination**.
11. **Posture**.
12. **Format de livrable** : structure imposée.
13. **Hand-off** : livrable produit, destinataire suivant, points à transmettre, risques.
13bis. **Contrat d'entrée** (depuis le 04.09.2026) : miroir du précédent — ce que le brief doit porter, ce que l'agent lit lui-même, ce qui le bloque, et le verdict `BLOQUÉ` rendu à la place du livrable quand un input décisif manque. Placé juste avant le Hand-off. Contrôlé par `test-conformite-fiches-agents.sh` (R20).
14. **Auto-check avant livraison** : 4-8 questions binaires. Si une seule réponse est non → corriger.
15. **Incidents source** : section pour traçabilité, à enrichir au fil des incidents.

## Anti-patterns d'orchestration

- **Sauter `brainstormer` sur un problème vraiment ouvert** : on cadre la première idée venue au lieu d'avoir comparé les directions.
- **Sauter `architecte` sur une feature non triviale** : on récupère la dette en double dans 3 mois.
- **Invoquer `frontend` ou `backend` sans SPEC.md** : violation règle 19.05.2026.
- **Sauter `reviewer` pour gagner du temps** : on s'expose à des findings qu'on aurait détectés en 5 minutes.
- **Sauter `release` Mode A** : on découvre les vars d'env manquantes en prod.
- **Durcir une validation sans signaler à `securite`** : on bannit silencieusement des users existants (cf. incident du 21.05.2026).
- **Faire écrire des tests sans matrice `qa` préalable** : tests sans stratégie cohérente.
- **Faire tout en parallèle** : `ux` et `designer` peuvent, mais `backend` doit attendre `architecte`. `frontend` doit attendre `backend` (sauf si contrats stables et stub possible).

## Skills associées (non sub-agents, exécutées dans le contexte principal)

### Cadrage / écriture
- `spec-builder` : produit la SPEC.md d'exécution destinée au harness. **Obligatoire avant toute modification de code (règle 19.05.2026).**
- `claude-spec` / `spec-claude-code` : **supprimés le 31.05.2026** (dépréciés depuis 21.05.2026, archivés dans `templates/profiles/_archives/skills-spec-deprecies/`), utiliser `spec-builder`.
- ~~`test-builder`~~ : **jamais livré par ce profil** (outil d'un bundle externe). L'écriture des tests revient à `backend` / `frontend`, à partir de la matrice de `qa` Mode B : celui qui écrit le code écrit ses tests.

- `charte-code` (créé 04.09.2026) : détail des onze règles opposables de la charte de code du
  `CLAUDE.md` — motifs, contre-exemples, cas limites, grille de review. **Préchargé** par
  `backend`, `frontend` et `reviewer` : ces trois-là ne peuvent ni écrire ni juger du code sans
  l'avoir sous les yeux. Il ne remplace pas `reviewer` : il est son référentiel.

### Construction
- `librairie-maison` (créé 25.08.2026) : socles de démarrage **vérifiés**, en deux jeux étiquetés. **Frontière avec `frontend-app-builder`** : celui-ci *génère* une application à partir d'un cadrage, `librairie-maison` *fournit des pièces déjà éprouvées* à recopier — HTTPS local auto-signé, conversion `.docx` → PDF, manifeste PWA, montage React in-browser. Les deux se composent : le builder construit, la librairie évite de réécrire ce qui existe. Elle intervient au **barreau 2bis** de l'échelle du moindre code de `backend` / `frontend`, jamais à la place du barreau 1 (« est-ce que ça doit exister ? »).
- `frontend-app-builder` : génération d'apps complètes **Vite** (à orchestrer avec `architecte` + `designer` + `frontend`). Renvoi croisé avec `librairie-maison` dans les deux descriptions depuis le 05.09.2026 : « nouvelle application » se routait vers trois skills qui ne se citaient pas (le troisième étant le défaut Next.js de la doctrine).
- ~~`modern-app-design`~~ : **jamais livré par ce profil** (outil d'un bundle externe). La direction visuelle est le domaine du sub-agent `designer`.
- ~~`ui-polish`~~ : **jamais livré par ce profil** (outil d'un bundle externe). Le polish ciblé passe par `frontend` Mode C, ou `designer` Mode C quand la retouche engage les tokens.
- `claude-api` : développement d'apps qui utilisent l'API Anthropic.

### Audit / analyse
- ~~`code-audit`~~ : **jamais livré par ce profil** (outil d'un bundle externe). Ce profil n'a pas d'audit généraliste : il porte trois audits spécialisés, `securite` (OWASP), `perf-audit` et `a11y-audit`, plus `reviewer` en pré-merge.
- `supabase-toolkit` (créé 21.05.2026) : conception et audit de RLS, RPC, migrations Supabase + reality check data legacy. Hand-off vers `securite` ou `release` Mode C.
- `perf-audit` (créé 21.05.2026) : Web Vitals + bundle + N+1 + re-renders. Hand-off vers `backend` ou `frontend`.
- `a11y-audit` (créé 21.05.2026) : audit WCAG 2.2 AA ex-post sur composant ou page. Complète le sub-agent `ux`.
- `debug-investigation` (créé 21.05.2026) : investigation structurée bug → root cause → fix + test de non-régression.
- ~~`quant-toolkit`~~ : **parti le 18.08.2026** dans `<depot-prive>` avec l'agent `quant`. Le skill portait les calculs (PSR, DSR, MinTRL, MDE/puissance, bootstrap stationnaire, Monte-Carlo, PBO/CSCV) et 20 tests d'auto-cohérence, tous verts au moment du transfert.

- `publication-store` (créé 04.09.2026) : publication Android via Capacitor sur le Play Store —
  invariants d'identité (`applicationId`, `versionCode`, keystore + Play App Signing), AAB signé,
  tracks, Data Safety, IARC, limites de la fiche et formats des assets, App Links, validation sur
  device, pièges Android 15+ mesurés. **Mesuré sur un seul dépôt ; iOS hors périmètre.** Frontières :
  la copy de la fiche revient à `growth`, les visuels à `designer`, le déploiement web à `release`.
  Séquence 11.

### Maintenance / opérations
- `garde-fous-powershell` (créé 05.09.2026) : la table complète des garde-fous PowerShell 5.1, sortie du résident du `CLAUDE.md` (qui n'en garde que quatre règles) — BOM, arrays imbriqués, `-replace` Unicode, audit post-batch et ses motifs mojibake, cible = fichier, sorties ASCII. À charger avant tout `.ps1` ou toute écriture de fichier par PowerShell ; sans objet en session cloud.
- `framework-upgrade` (créé 21.05.2026) : upgrade Next.js / React / Tailwind / shadcn / TypeScript / Node. Hand-off `release` Mode A avant merge prod.
- `update-config` / `keybindings-help` / `fewer-permission-prompts` : config harness Claude Code.
- `loop` / `schedule` : automatisation récurrente.
- `simplify` : review du code modifié pour reuse / quality / efficiency (différent de `reviewer` qui fait du pré-merge structurel).

### À éviter (doublons avec sub-agents)
- `code-review` (plugin) : préférer le sub-agent `reviewer` (cohérence pattern partagé).
- `security-review` (plugin) : préférer le sub-agent `securite` (a la Phase 0 DB reality check).

## Mise à jour de ce fichier

Quand un nouvel agent est ajouté ou un workflow modifié :
1. Mettre à jour le tableau d'inventaire.
2. Ajouter / modifier la séquence concernée.
3. Mettre à jour la date en tête.
4. Refléter dans le `CLAUDE.md` global si la règle d'orchestration change.

Pour le détail du pattern à respecter lors de la création d'un nouveau sub-agent ou skill : `~/.claude/agents/HOW-TO-ADD.md`.

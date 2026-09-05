---
name: spec-builder
description: "Cadre une tâche de code AVANT exécution, à l'étage qu'elle mérite : SPEC-lite d'environ 30 lignes (objectif, périmètre, vérifications) de 10 à 50 lignes, commitée avec le code ; spec complète en 13 sections au-delà de 50 lignes ou dès qu'elle est structurelle (schéma, auth, dépendance majeure, contrat d'API, migration), commitée avant le code. Lit CLAUDE.md, BACKLOG.md, audits et code réel avant toute question, tranche seule les choix techniques et ne sollicite l'utilisateur que sur les arbitrages métier non documentés. Rend un Markdown dans `specs/` du dépôt. Déclencheurs : rédige une spec, SPEC-lite, prépare un PRD, spécifie cette feature, cadre cette tâche avant développement."
---

> Version 1.2 — 05.09.2026 (PR 2.1 de l'audit du 05.09 : la description décrivait le skill d'avant le 18.08 — « 13 sections fixes », sans un mot de la SPEC-lite, l'étage le plus fréquent. Réécrite sur les trois étages que le corps applique depuis le 18.08.)
> Version 1.1 — 12.06.2026 (audit dev-fullstack : ligne de version ajoutée ; dépendance claude-rules explicitement marquée externe + fallback si absente).
> Version 1.0 — 26.05.2026 (entrée au repo ; usernames généralisés en `%USERPROFILE%` le 10.06.2026).

# spec-builder — Générateur de spécifications pour le harness Claude Code

> Ce skill applique les règles transversales définies dans `%USERPROFILE%\Documents\Claude\claude-rules\rules\specs-claude-code.md` (**dépendance externe — hors repo `claude-profiles` et hors `<BUREAU>/`, vit uniquement sur le poste ; version épinglée : v0.2.1**). En cas de conflit ou d'évolution de claude-rules, claude-rules fait foi et le skill doit être mis à jour.
> **Fallback si le fichier est absent** (autre machine, sandbox Linux) : les règles claude-rules résumées dans la description du frontmatter font foi (longueur 300-400 lignes, section « Décisions à prendre en cours d'exécution », bornes vérifiées par lecture du repo, chemins Windows à espaces quotés, épilogue d'export sur `globalThis` pour sandbox `node:vm`) — ne pas bloquer la rédaction de la spec, signaler le fallback dans le livrable.

Produit un fichier `SPEC.md` rigoureusement structuré, exploitable directement par Claude Code (harness Chrome) pour exécuter une tâche de développement sans ambiguïté.

## Principe directeur

**Documentation-first, décisions tranchées, structure non négociable.**

La skill épuise toutes les sources documentaires avant de poser une seule question, tranche elle-même les choix techniques, et impose une structure de 13 sections strictement nommées. Cible : **0 ou 1 question** à l'utilisateur, uniquement sur arbitrages métier non documentés.

---

## Étage de cadrage — à déterminer AVANT de rédiger (18.08.2026)

La doctrine `dev-fullstack` définit **trois étages**. Ce skill ne produit la spec complète qu'au troisième. Se tromper d'étage vers le haut coûte de la friction sur une tâche qui n'en méritait pas ; vers le bas, une livraison non cadrée.

| Ampleur estimée | Ce que produit ce skill |
|---|---|
| **< 10 lignes** | **Rien.** Le dire, en une ligne : « sous 10 lignes, pas de spec — le hook `check-build-ts.ps1` sert de filet ». Ne pas rédiger, ne pas insister. |
| **10 à 50 lignes** | **SPEC-lite**, ~30 lignes, **trois sections seulement** : `## Objectif` (verbe d'action mesurable), `## Périmètre` (dedans / dehors), `## Vérifications avant fin de tâche` (cases concrètes). Même exigence de fond que la spec complète : pas d'invention, chemins exacts, `À DÉFINIR — <explication>` si une info manque. |
| **> 50 lignes, ou structurel** | **Spec complète en 13 sections**, telle que décrite plus bas. |

« **Structurel** » l'emporte sur le compte de lignes : schéma de données, auth, dépendance majeure, contrat d'API, migration. Trois lignes qui changent une clé étrangère relèvent du troisième étage.

**L'étage retenu s'annonce à l'utilisateur en une ligne, avant de rédiger.** Il peut le corriger — c'est une estimation, et une estimation qui ne se dit pas ne se corrige pas.

---

## Workflow obligatoire (4 phases)

### Phase 1 — Lecture exhaustive du contexte

Dès que la skill se déclenche, lire **systématiquement, sans demander confirmation** :

1. **`CLAUDE.md`** du projet cible (racine) — conventions, stack, règles spécifiques
2. **`BACKLOG.md`** du projet (et `TODO.md`, `ROADMAP.md` si présents) — extraire scope, pattern, effort estimé si l'item y figure
3. **`docs/audits/`** ou tout fichier `AUDIT*.md` — si la tâche est issue d'un finding d'audit
4. **État réel du code** via grep/find sur les zones concernées — vérifier que la feature n'est pas déjà partiellement implémentée

**Règle d'or** : si la réponse à une question potentielle est dans une de ces 4 sources, **ne pas la poser**.

Restituer ensuite à l'utilisateur un résumé court (5-10 lignes) du contexte détecté, avant toute autre action.

### Phase 2 — Décisions techniques tranchées par la skill

La skill décide elle-même, sans demander :

| Décision | Règle |
|---|---|
| Choix de librairie | Lire le CLAUDE.md ; sinon défaut raisonnable (ex. jsPDF pour PDF client-only, Vitest pour tests si présent dans devDeps) |
| Tests unitaires vs manuels | Par défaut : tests unitaires sur la logique pure + manuel sur l'intégration |
| Slug de branche | Proposer un slug `claude/<slug-explicite>` à partir de l'item du backlog ou du libellé de la tâche |
| Scope du commit | Extraire du CLAUDE.md du projet (convention de scopes) ; sinon dériver du dossier touché |
| Format des tests | Reprendre celui déjà utilisé dans le projet (Vitest, Jest, Pytest…) |

**Interdit** : poser une question purement technique. Les questions sont **exclusivement** réservées aux arbitrages métier non documentés (périmètre fonctionnel, template visuel, critères de succès chiffrés).

### Phase 3 — Question(s) ciblée(s) — 0 ou 1

Si après la phase 1 il reste un trou métier non comblable :

- Poser **une seule question groupée** maximum, formulée précisément
- Ne pas demander confirmation sur des choix déjà tranchés
- Si tout est dans le contexte → ne rien demander, passer directement à la livraison

### Phase 4 — Livraison du fichier

Écrire le fichier au chemin imposé (cf. section « Livraison ») et fournir dans le chat :
- Le lien `computer://` vers le fichier
- Une note courte (projet ciblé, CLAUDE.md lu oui/non, règles intégrées, résultat §4 résumé, résultat §5 13/13 ou signalement, décisions laissées à l'utilisateur)

**Ne jamais afficher le contenu intégral du SPEC dans le chat.**

---

## Structure obligatoire du SPEC.md (13 sections)

Le fichier livré contient **exactement** ces 13 sections, dans cet ordre, avec les **titres Markdown `##` à l'identique**, sans numérotation `1./2./3.`. Toute déviation = livraison refusée.

````markdown
# SPEC — <Titre tâche>

> Projet : <projet> · Auteur : <user> · Date : jj.mm.aaaa

## Contexte
<2-5 paragraphes : situation actuelle, douleur, déclencheur, qui est concerné. Citer la source si l'item vient du BACKLOG.md ou d'un audit.>

## Objectif
<Une phrase action-orientée mesurable. Pas de "améliorer", pas de "optimiser" sans chiffre.>

## Périmètre

### Dans le scope
- <liste exhaustive des éléments traités>

### Hors scope (explicitement)
- <liste explicite de ce qui n'est PAS traité, pour éviter le scope creep>

## Branche cible
`claude/<slug-explicite>`

<Justification courte du slug si non évident.>

## Plan d'exécution
1. <Étape 1> — fichier(s) : `chemin/exact/fichier.ext`
2. <Étape 2> — fichier(s) : `chemin/exact/fichier.ext`
3. ...

<Chaque étape est testable indépendamment. Chemins absolus dans le repo, pas de chemins vagues type "le composant".>

## Contraintes et règles à respecter
- **Source : CLAUDE.md §<X>** — <règle reprise textuellement ou paraphrasée>
- **Source : règle qualité §<X>** — <règle qualité applicable>
- **Inventaire exhaustif** — <si la tâche touche une famille d'éléments, lister TOUS les éléments concernés ici>
- **Préservation des erreurs existantes** — les codes d'erreur natifs (ENOENT, 4xx, etc.) continuent de remonter sans être avalés
- **Nettoyage des ressources** — timers, listeners, connexions libérés dans tous les chemins (succès, échec, timeout, unmount)
- **Gestion d'erreur** — pas de try/catch vide ; logger via le logger projet ; spécifier codes/exceptions retournés, messages, logs. Pour les contextes HTTP : distinguer 4xx (métier) / 5xx (infra)

## Décisions à prendre en cours d'exécution

Le harness doit trancher les points suivants pendant l'exécution et **les documenter dans le rapport final §6** :
- [ ] <Décision 1> — contexte court, options envisageables, critère de choix
- [ ] <Décision 2> — ...

Si aucune décision n'est anticipée pour une SPEC particulière, écrire « Aucune décision attendue, exécution déterministe » et expliquer pourquoi.

## Vérifications avant fin de tâche

### Happy path
- [ ] <Cas nominal 1, sortie attendue précise>
- [ ] <Cas nominal 2, sortie attendue précise>

### Non-régression
- [ ] <Fonction existante 1 inchangée, comment le vérifier>
- [ ] <Fonction existante 2 inchangée, comment le vérifier>

### Edge cases
- [ ] <Cas limite 1 : entrée vide / valeur extrême / concurrence>
- [ ] <Cas limite 2>

### Ordre du repo et version
- [ ] `npm run build` (ou équivalent) passe sans warning nouveau
- [ ] Tests existants tous verts
- [ ] Aucun fichier non commité hors scope
- [ ] Version du package mise à jour si conventions du projet l'exigent

## Merge sur main
```bash
git fetch origin --prune
git checkout main
git merge origin/claude/<slug-explicite> --ff-only
git push
```

L'utilisateur teste sur `main` après le merge.

## Commit message attendu

Type en français et sans accent (`fonctionnalite`, `correctif`, `entretien`, `doc`, `refonte`, `test`) :
table complète et motif au § « Conventions git » du `global-CLAUDE.md`.
```
<type en français>(<scope>): <description en français>
```

Exemple concret pour cette tâche :
```
fonctionnalite(<scope-réel>): <description-réelle-en-français>
```

## Rapport de livraison (en français)
À produire par Claude Code à la fin de l'exécution, en 7 points :
1. Résumé de ce qui a été fait (2-3 phrases)
2. Liste exhaustive des fichiers créés / modifiés / supprimés
3. Inventaire exhaustif des éléments traités (si tâche par famille)
4. Confirmation que l'ordre du repo est propre et version à jour
5. Tests exécutés et résultats (happy path / non-régression / edge cases)
6. Points d'attention résiduels ou décisions prises en cours d'exécution
7. Confirmation du merge effectué (ou raison s'il ne l'est pas)

## Auto-review §4 — réponses aux 7 questions
Réponses oui / non applicable avec justification factuelle pour chaque question.

**Format de réponse imposé** :
- Si « **oui** » → fournir une **citation textuelle courte** (entre guillemets) de la section du SPEC qui prouve l'affirmation, avec son nom de section. Format : `oui — section "## X" : "<extrait>"`. Une déclaration sans citation est invalide.
- Si « **non applicable** » → expliquer en une phrase **pourquoi** la question ne s'applique pas au contexte de la tâche. Format : `non applicable — <raison>`.
- Si « **non** » → la spec doit être amendée AVANT livraison (cf. règle d'application §4 ci-dessous).
- **Longueur** : chaque justification tient en 1 phrase (max 400 caractères). Plusieurs citations peuvent être chaînées avec « ; » si nécessaire pour couvrir une réponse complexe.

1. **Inventaire exhaustif** : la tâche touche-t-elle une famille d'éléments (ex: toutes les opérations X, tous les composants Y) ? Si oui, la spec exige-t-elle un inventaire exhaustif dans `## Périmètre` ? `[oui — section "## X" : "<extrait>" / non applicable — <raison>]`

2. **Préservation des comportements existants** : la modification peut-elle casser des comportements existants (erreurs natives, API publiques, edge cases) ? Si oui, la spec impose-t-elle leur préservation dans `## Contraintes` ? `[oui — section "## X" : "<extrait>" / non applicable — <raison>]`

3. **Nettoyage des ressources créées** : la modification crée-t-elle des ressources (timers, listeners, connexions, subscriptions, intervals) ? Si oui, la spec exige-t-elle leur nettoyage dans TOUS les chemins (succès / échec / timeout / exception / unmount) ? `[oui — section "## X" : "<extrait>" / non applicable — <raison>]`

4. **3 groupes de tests** : la section `## Vérifications` contient-elle les 3 groupes obligatoires (Happy path / Non-régression / Edge cases) ? `[oui — section "## X" : "<extrait>" / non applicable — <raison>]`

5. **Gestion d'erreur précise** : les cas d'erreur sont-ils spécifiés (codes/exceptions retournés, messages, logs) ? Pour les contextes HTTP, distinguer 4xx (métier) / 5xx (infra). Pas de try/catch vide ? `[oui — section "## X" : "<extrait>" / non applicable — <raison>]`

6. **Critères vérifiables indépendants** : chaque case à cocher de `## Vérifications` est-elle testable séparément, avec sortie attendue claire ? `[oui — section "## X" : "<extrait>" / non applicable — <raison>]`

7. **CLAUDE.md intégré dans les Contraintes** : toutes les règles absolues et conventions du `CLAUDE.md` du projet cible sont-elles reportées dans `## Contraintes et règles à respecter`, avec source citée ? `[oui — section "## X" : "<extrait>" / non applicable — <raison>]`

**Règle d'application §4** : si une seule réponse est « **non** » (au sens : la spec ne couvre pas un point applicable), la spec doit être amendée AVANT livraison. Les réponses « **non applicable** » avec justification d'une ligne sont autorisées et n'empêchent pas la livraison. Pas de spec livrée avec un « non » non corrigé.

## Auto-check de conformité structurelle (§5)
- [ ] Section `## Contexte` présente, avec cadrage de l'origine.
- [ ] Section `## Objectif` présente, 1 phrase factuelle.
- [ ] Section `## Périmètre` présente, avec « Dans le scope » ET « Hors scope (explicitement) ».
- [ ] Section `## Branche cible` présente, avec slug `claude/[...]`.
- [ ] Section `## Plan d'exécution` présente, étapes numérotées, chemins exacts.
- [ ] Section `## Contraintes et règles à respecter` présente, avec sources citées.
- [ ] Section `## Décisions à prendre en cours d'exécution` présente.
- [ ] Section `## Vérifications avant fin de tâche` présente, avec les 4 sous-sections (Happy path / Non-régression / Edge cases / Ordre du repo et version).
- [ ] Section `## Merge sur main` présente, avec bloc bash complet.
- [ ] Section `## Commit message attendu` présente, avec proposition.
- [ ] Section `## Rapport de livraison (en français)` présente, 7 points listés.
- [ ] Section `## Auto-review §4 — réponses aux 7 questions` présente, réponses renseignées.
- [ ] Section `## Auto-check de conformité structurelle (§5)` présente (celle-ci).

**Règle d'application §5** : avant de livrer, la skill lit le fichier qu'elle vient d'écrire et coche chaque case si la condition est remplie. Si une case ne peut pas être cochée → amender le fichier puis refaire l'auto-check. Si après 2 passes une case persiste à être non cochée → alerter l'utilisateur avec le point défaillant plutôt que livrer une spec hors-norme.
````

---

## Règle de refus de livraison

Si **une seule** des 13 sections manque, est mal nommée, ou ne respecte pas son format, la skill **refuse de livrer**. Elle corrige et relit avant écriture du fichier final.

---

## Règles de qualité obligatoires (à imposer dans chaque spec)

Chaque spec produite doit imposer dans `## Contraintes` :

- **Inventaire exhaustif** quand la tâche touche une famille d'éléments (ex. « toutes les fonctions X ») → la liste complète figure dans `## Périmètre / Dans le scope`
- **Préservation des erreurs existantes** : codes natifs (ENOENT, 4xx, etc.) continuent de remonter
- **Nettoyage des ressources** dans tous les chemins (succès, échec, timeout, unmount)
- **3 groupes de tests** dans `## Vérifications` : happy path + non-régression + edge cases
- **Gestion d'erreur** : pas de try/catch vide, logger via le logger projet, spécifier codes/exceptions retournés. Pour les contextes HTTP : distinguer 4xx (métier) / 5xx (infra)
- **Critères vérifiables et indépendants** : chaque case du checklist `## Vérifications` doit être testable séparément avec une sortie attendue précise
- **Longueur** : viser 300-400 lignes max pour un MVP. Au-delà, scinder en deux SPECs ou retirer la redondance
- **Bornes techniques vérifiées** : toute borne quantifiée (numéros de ligne, nombre de helpers, taille fichier) doit être vérifiée par lecture du repo réel au moment de l'écriture, pas estimée
- **Chemins espaces Windows** : tout chemin shell quoté en double quotes (`"tests/**/*.test.mjs"`, `"C:\Users\..."`)
- **Sandbox `node:vm`** : si le test charge du code via `vm.runInContext`, la SPEC doit imposer un epilogue d'export sur `globalThis` pour rendre les fonctions adressables depuis le test runner
- **Décisions à prendre en cours d'exécution** : section dédiée présente dans le canevas (entre `## Contraintes` et `## Vérifications`), reprise dans le rapport final §6

---

## Ton et style de la spec

- **Factuel et concis**. Pas d'emoji dans la spec finale. Pas d'humour, pas de remarques décalées, pas de tutoiement de l'utilisateur.
- **Pas d'invention** : si une info reste inconnue après lecture + question, écrire `À DÉFINIR — <explication>`.
- **Verbes d'action mesurables** dans `## Objectif` (« générer », « réduire à <X>s », « ajouter », pas « améliorer »).
- **Chemins exacts** dans `## Plan d'exécution` (ex. `src/lib/pdfExport.js`), pas de tournures vagues.

---

## Livraison — où écrire la spec

**Dans un dépôt git : `<racine-du-dépôt>/specs/YYYY-MM-DD-slug.md`.** C'est le défaut, et il prime.

La raison est opposable : la doctrine exige que la spec soit **commitée avant le code**. Une spec écrite hors du dépôt ne peut pas l'être — elle vit à côté du travail qu'elle cadre, sans jamais y être rattachée, et un `git log` ne la retrouve pas. Dans le dépôt, elle voyage avec le code, se relit dans la PR, et survit au poste.

**Hors dépôt** (script isolé, cadrage amont sans code encore) :
```
%USERPROFILE%\Documents\Claude\Projects\Assistant DEV senior\specs\<projet-en-minuscules>\YYYY-MM-DD-slug.md
```

- `<projet-en-minuscules>` : nom du projet, en minuscules, sans espaces (ex. `factu-simple`, `offre-simple`, `verifbois`)
- `YYYY-MM-DD` : date du jour au format ISO **dans le nom de fichier** (tri lexicographique). Cohabite intentionnellement avec le format suisse `jj.mm.aaaa` utilisé **dans le contenu** du SPEC (en-tête > ligne « Date : »). Ne pas uniformiser : chaque format a sa raison d'être (tri vs lecture humaine).
- `slug` : identique au slug de branche utilisé dans `## Branche cible`

**Fallback environnement** : si le chemin Windows n'est pas accessible depuis l'environnement d'exécution (sandbox Linux Claude.ai), écrire dans `/mnt/user-data/outputs/<projet>/YYYY-MM-DD-slug.md` et proposer le téléchargement via le lien du panneau de fichiers (tool `present_files`). Mentionner explicitement ce fallback dans la note finale.

**Demande de livraison inline : une itération de push-back, puis appliquer.** Si l'utilisateur demande « inline », « dans le chat », ou « pas de fichier », le dire une fois :
> Une spec inline se perd à la fin de la conversation, ne se commite pas avant le code et ne se retrouve pas dans un `git log`. Je la mets en fichier dans `specs/`, consultable ici par lien — sauf si tu préfères vraiment l'inline.

**S'il maintient, livrer inline sans relancer.** C'est la posture du profil : une seule itération de push-back par décision, puis on applique.

> **Corrigé le 18.08.2026.** Ce paragraphe disait « livrer le fichier malgré la demande contraire ». Un skill qui passe outre une instruction explicite de l'utilisateur contredit frontalement la posture du profil, et il la contredisait **en silence** : l'utilisateur voyait sa demande acquiescée puis ignorée. Le motif invoqué (archivabilité) reste juste — il devient un argument, plus un veto.

**Note finale dans le chat** (après écriture du fichier) :
- Lien `computer://` vers le fichier
- Projet ciblé
- CLAUDE.md lu : oui/non
- Règles intégrées : <liste courte>
- Résultat auto-review §4 : <résumé en 1 ligne>
- Résultat auto-check §5 : <X/13 ou « 13/13 ✓ »>
- Décisions laissées à l'utilisateur : <liste si applicable, sinon « aucune »>

---

## Anti-patterns interdits

La skill ne doit **jamais** :

1. Renuméroter les sections (« 1. Contexte / 2. Objectif »)
2. Renommer les titres (« ## Origine » au lieu de `## Contexte`)
3. Omettre une des 13 sections, même si elle semble redondante
4. Livrer inline au lieu d'un fichier
5. Poser une question dont la réponse est dans le BACKLOG / CLAUDE.md / audits / code réel
6. Poser une question purement technique (lib, format de tests, slug, scope)
7. Hardcoder des **règles métier propres à un projet** dans la skill — les règles projet viennent du CLAUDE.md à chaque invocation. Les **règles utilisateur transversales** (chemins de livraison, conventions de slug, format de date suisse, fallback environnement) restent dans la skill par design.
8. Mettre des emojis ou de l'humour dans la spec finale
9. Inventer des informations manquantes — utiliser `À DÉFINIR` à la place
10. Restituer le contenu intégral du SPEC dans le chat — uniquement le lien et la note courte

---

## Critères d'auto-validation (avant écriture du fichier)

Avant d'écrire le fichier, la skill se pose ces questions et **n'écrit que si toutes les réponses sont oui** :

- Les 4 sources documentaires ont-elles été lues (CLAUDE.md, BACKLOG.md, audits, code réel) ?
- Toutes les décisions techniques ont-elles été tranchées par la skill, sans question à l'utilisateur ?
- 0 ou 1 question a-t-elle été posée à l'utilisateur, sur arbitrage métier uniquement ?
- Les 13 sections sont-elles présentes avec titres `##` exacts ?
- L'auto-review §4 et l'auto-check §5 sont-ils complétés dans le fichier ?
- **Format §4 vérifié** : chaque réponse §4 commence-t-elle par `oui — section "## ` (avec au moins une citation entre guillemets après) OU par `non applicable — ` (avec une justification d'une phrase) ? Toute autre forme (« oui — chaque… », « oui car… », « oui parce que… ») est invalide et doit être réécrite.
- Le ton est-il neutre, sans emoji ni humour ?
- L'**étage de cadrage** a-t-il été annoncé avant rédaction, et la spec correspond-elle à cet étage (rien / SPEC-lite 3 sections / 13 sections) ?
- Le chemin de livraison est-il bien `<racine-du-dépôt>/specs/YYYY-MM-DD-slug.md` quand on travaille dans un dépôt git — et seulement à défaut `%USERPROFILE%\Documents\Claude\Projects\Assistant DEV senior\specs\<projet>\` ou `/mnt/user-data/outputs/<projet>/` (sandbox Linux Claude.ai) ?
- La SPEC complète reste-t-elle sous 400 lignes (300 idéalement), la SPEC-lite autour de 30 ?
- Toute borne quantifiée a été vérifiée par lecture du repo réel ?

Si une seule réponse est non → corriger avant écriture.

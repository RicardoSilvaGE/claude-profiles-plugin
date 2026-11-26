---
name: spec-builder
description: "Cadre une tâche de code AVANT exécution, à l'étage qu'elle mérite : SPEC-lite, ou spec complète (la `SPEC.md` qu'exigent `backend`, `frontend` et l'orchestrateur) dès que c'est gros ou structurel (schéma, auth, dépendance majeure, contrat d'API, migration). Rend un Markdown dans `specs/` du dépôt. Déclencheurs : rédige une spec, SPEC-lite, SPEC.md, spec complète, prépare un PRD, spécifie cette feature, cadre cette tâche avant développement. Pas pour : docs purs, migrations SQL appliquées à la main, configuration du harness Claude Code (agents, skills, CLAUDE.md), ni la décision d'architecture en amont (sub-agent `architecte`)."
---

> Version 1.6 — 26.11.2026 (livrable nommé comme l'écosystème, branche de l'appelant, règles de qualité dites une fois). Versions antérieures : `CHANGELOG.md` du profil, non déployé.

# spec-builder — Générateur de spécifications pour le harness Claude Code

> Une partie des règles de qualité vient de claude-rules, fichier du poste hors dépôt, invérifiable d'ici (`%USERPROFILE%\Documents\Claude\claude-rules\rules\specs-claude-code.md`, épinglé v0.2.1). Le dépôt n'en garde que ce que ce skill en reprenait avant la 1.5 : longueur, section « Décisions à prendre en cours d'exécution », bornes vérifiées, chemins Windows quotés, `globalThis` pour `node:vm`. Lisible et en désaccord : il l'emporte, et ce skill est à mettre à jour. Absent : ce skill et son canevas suffisent, sans bloquer. Dans les deux cas, le dire dans la note finale.

Produit une spec Markdown rigoureusement structurée, exploitable directement par Claude Code pour exécuter une tâche de développement sans ambiguïté. Nom, lieu et équivalences du livrable : § « Livraison ».

## Principe directeur

**Documentation-first, décisions tranchées, structure non négociable.**

La skill épuise toutes les sources documentaires avant de poser une seule question, tranche elle-même les choix techniques, et impose, au troisième étage (spec complète), une structure de 13 sections strictement nommées. Cible : **0 ou 1 question** (Phase 3).

---

## Étage de cadrage — à déterminer AVANT de rédiger

La doctrine `dev-fullstack` définit **trois étages**. Ce skill ne produit la spec complète qu'au troisième. Se tromper d'étage vers le haut coûte de la friction sur une tâche qui n'en méritait pas ; vers le bas, une livraison non cadrée.

| Ampleur estimée | Ce que produit ce skill |
|---|---|
| **< 10 lignes** | **Rien.** Le dire, en une ligne : « sous 10 lignes, pas de spec — le hook de build `check-build-ts` (Stop, si la session est lancée à la racine du dépôt) sert de filet, TypeScript ou non ». Ne pas rédiger, ne pas insister. |
| **10 à 50 lignes** | **SPEC-lite**, ~30 lignes, **trois sections seulement** : `## Objectif`, `## Périmètre` (dedans / dehors), `## Vérifications avant fin de tâche`. Gabarit : `references/gabarit-spec-lite.md`. Même exigence de fond que la spec complète. Commitée avec le code ; si elle n'existe que dans le brief d'un sub-agent, celui qui commite la recopie en fichier. |
| **> 50 lignes, ou structurel** | **Spec complète en 13 sections**, sur le canevas de `references/canevas-spec-complete.md`. Commitée avant le code. |

« **Structurel** » l'emporte sur le compte de lignes : schéma de données, auth, dépendance majeure, contrat d'API, migration. Trois lignes qui changent une clé étrangère relèvent du troisième étage.

**L'étage retenu s'annonce à l'utilisateur en une ligne, après la lecture de la Phase 1 (l'estimation la suppose) et avant de rédiger.** Il peut le corriger — c'est une estimation, et une estimation qui ne se dit pas ne se corrige pas.

---

## Workflow obligatoire (4 phases)

### Phase 1 — Lecture exhaustive du contexte

Dès que la skill se déclenche, lire **systématiquement, sans demander confirmation** :

1. **`CLAUDE.md`** du projet cible (racine) — conventions, stack, règles spécifiques
2. **`BACKLOG.md`** du projet (et `TODO.md`, `ROADMAP.md` si présents) — extraire scope, pattern, effort estimé si l'item y figure
3. **`docs/audits/`** ou tout fichier `AUDIT*.md` — si la tâche est issue d'un finding d'audit ; **`docs/SPEC/`** si `architecte` a cadré la tâche
4. **État réel du code** via grep/find sur les zones concernées — vérifier que la feature n'est pas déjà partiellement implémentée

**Règle d'or** : si la réponse à une question potentielle est dans une de ces 4 sources, **ne pas la poser**.

Restituer ensuite à l'utilisateur un résumé court (5-10 lignes) du contexte détecté, avant toute autre action.

### Phase 2 — Décisions techniques tranchées par la skill

La skill décide elle-même, sans demander :

| Décision | Règle |
|---|---|
| Choix de librairie | Celle du CLAUDE.md ; sinon celle déjà en dépendance (ex. Vitest s'il est dans les devDeps) ; à défaut, un choix motivé dans la spec |
| Tests unitaires vs manuels | Par défaut : tests unitaires sur la logique pure + manuel sur l'intégration |
| Branche | Celle de l'appelant ou du dépôt (`upgrade/…` de `framework-upgrade`, convention du CLAUDE.md, `claude/<slug>` du harness en session web ou Chrome) ; à défaut `feat/<slug>`, anglais kebab-case (doctrine § « Conventions git ») |
| Scope du commit | Extraire du CLAUDE.md du projet (convention de scopes) ; sinon dériver du dossier touché |
| Format des tests | Reprendre celui déjà utilisé dans le projet (Vitest, Jest, Pytest…) |

**Interdit** : poser une question purement technique. Les questions sont **exclusivement** réservées aux arbitrages métier non documentés (périmètre fonctionnel, template visuel, critères de succès chiffrés).

### Phase 3 — Question(s) ciblée(s) — 0 ou 1

Si après la phase 1 il reste un trou métier non comblable :

- Poser **une seule question groupée** maximum, formulée précisément
- Ne pas demander confirmation sur des choix déjà tranchés
- Si tout est dans le contexte → ne rien demander, passer directement à la livraison
- Appelant qui ne peut pas répondre (sous-agent) : ne pas poser la question, écrire `À DÉFINIR — <question>` là où elle porte et la remonter à l'orchestrateur dans la note finale

### Phase 4 — Livraison du fichier

Ouvrir le gabarit de l'étage (`references/gabarit-spec-lite.md` ou `references/canevas-spec-complete.md`), écrire le fichier au chemin de « Livraison » et rendre dans le chat la note finale.

**Ne jamais afficher le contenu intégral de la spec dans le chat** — uniquement le chemin et la note (sauf livraison inline maintenue par l'utilisateur).

---

## Spec complète — canevas en 13 sections

**Avant de rédiger une spec complète, lire `references/canevas-spec-complete.md` en entier** : il porte les 13 sections, leurs titres `##` exacts, les règles de qualité à imposer dans `## Contraintes et règles à respecter` et `## Vérifications avant fin de tâche`, le format imposé de l'auto-review §4 (7 questions) et l'auto-check structurel §5. Le fichier livré le recopie, sans renommer ni numéroter un titre. Une SPEC-lite ne l'ouvre pas.

## Règle de refus de livraison

Pour une spec complète : si **une seule** des 13 sections manque, est mal nommée, ou ne respecte pas son format, la skill **refuse de livrer**. Pour une SPEC-lite, la même règle vaut sur ses trois sections. Elle corrige et relit avant écriture du fichier final.

---

## Règles de qualité des deux étages

Celles de la spec complète sont dans le canevas, là où elles s'écrivent. Valent en plus, aux deux étages :

- **Longueur** : spec complète 300-400 lignes max pour un MVP, SPEC-lite autour de 30. Au-delà, scinder ou retirer la redondance
- **Bornes techniques vérifiées** : toute borne quantifiée (numéros de ligne, nombre de helpers, taille fichier) est vérifiée par lecture du repo réel au moment de l'écriture, pas estimée
- **SPEC-lite** : une famille d'éléments s'inventorie en entier dans `## Périmètre` ; chaque case de `## Vérifications avant fin de tâche` est testable seule, sortie attendue dite, non-régression et cas limites compris ; là où la tâche y touche : erreurs existantes préservées, ressources nettoyées dans tous les chemins, aucune erreur avalée (logger projet, codes retournés dits ; 4xx métier, 5xx infra)
- **Seulement si la tâche y touche** : chemin ou glob shell quoté en double quotes (Windows, `"tests/**/*.test.mjs"`) ; test qui charge du code par `vm.runInContext` : épilogue d'export sur `globalThis` imposé

---

## Ton et style de la spec

- **Factuel et concis**. Pas d'emoji dans la spec finale. Pas d'humour, pas de remarques décalées, pas de tutoiement de l'utilisateur.
- **Pas d'invention** : si une info reste inconnue après lecture + question, écrire `À DÉFINIR — <explication>`.
- **Verbes d'action mesurables** dans `## Objectif` (« générer », « réduire à <X>s », « ajouter », pas « améliorer »).
- **Chemins exacts** dans `## Plan d'exécution` et `## Périmètre` (ex. `src/lib/pdfExport.js`), pas de tournures vagues.

---

## Livraison — où écrire la spec

**Dans un dépôt git : `<racine-du-dépôt>/specs/YYYY-MM-DD-slug.md`.** C'est le défaut, et il prime. Ce fichier est ce que les agents (`backend`, `frontend`, `ORCHESTRATION.md`) et la doctrine appellent, au troisième étage, « la `SPEC.md` » ou « la spec complète » ; le hook `guard-spec-code` l'accepte (`specs/*.md`, doctrine Phase 5). Une spec d'`architecte` déjà présente (`docs/SPEC/<slug>.md`) est une entrée de la Phase 1, pas le livrable : en reprendre décisions et critères sans les rediscuter, la citer dans `## Contexte`, écrire quand même le fichier de `specs/`.

- `YYYY-MM-DD` : date ISO **dans le nom** (tri) ; le contenu garde le format suisse `jj.mm.aaaa` (ligne « Date : »). Ne pas uniformiser.
- `slug` : celui de la branche retenue (`## Branche cible` en spec complète), sans son préfixe

**Hors dépôt** (script isolé, cadrage amont sans code encore) : chemin du poste, repli d'environnement et motif du défaut dans `references/livraison-hors-depot.md`, à ouvrir dans ce cas, ou si le défaut est contesté. Mentionner le repli dans la note finale.

**Demande de livraison inline : une itération de push-back, puis appliquer.** Si l'utilisateur demande « inline », « dans le chat », ou « pas de fichier », le dire une fois :
> Une spec inline se perd à la fin de la conversation, ne se commite pas et ne se retrouve pas dans un `git log`. Je la mets en fichier dans `specs/`, consultable ici par lien — sauf si tu préfères vraiment l'inline.

**S'il maintient, livrer inline sans relancer.** C'est la posture du profil : une seule itération de push-back par décision, puis on applique. Le motif (archivabilité) est un argument, pas un veto.

**Note finale dans le chat** (après écriture du fichier) :
- Chemin du fichier (lien `computer://` seulement là où l'environnement le fournit)
- Projet ciblé
- CLAUDE.md lu : oui/non
- Règles intégrées : <liste courte>
- Résultat auto-review §4 : <résumé en 1 ligne> (spec complète seulement)
- Résultat auto-check §5 : <X/13 ou « 13/13 ✓ »> (spec complète seulement)
- Décisions laissées à l'utilisateur : <liste si applicable, sinon « aucune »>

---

## Anti-patterns interdits

Chaque phase porte déjà ses interdits. S'y ajoutent, dits nulle part ailleurs — la skill ne doit **jamais** :

1. Renuméroter les sections (« 1. Contexte / 2. Objectif »)
2. Renommer les titres (« ## Origine » au lieu de `## Contexte`)
3. Livrer inline de sa propre initiative, ou sans avoir dit une fois ce que l'inline coûte
4. Hardcoder des **règles métier propres à un projet** dans la skill — les règles projet viennent du CLAUDE.md à chaque invocation. Les **règles utilisateur transversales** (chemins de livraison, conventions de slug, format de date suisse, fallback environnement) restent dans la skill par design.

---

## Auto-validation (avant écriture du fichier)

N'écrire que si les phases 1 à 3, les règles de qualité, le ton et le chemin de « Livraison » sont tenus, et si ces deux questions, posées nulle part ailleurs, reçoivent un oui :

- L'**étage de cadrage** a-t-il été annoncé avant rédaction, et la spec correspond-elle à cet étage (rien / SPEC-lite 3 sections / 13 sections) ?
- (spec complète) **Format §4 vérifié** : chaque réponse §4 commence-t-elle par `oui — section "## ` (avec au moins une citation entre guillemets après) OU par `non applicable — ` (avec une justification d'une phrase) ? Toute autre forme (« oui — chaque… », « oui car… », « oui parce que… ») est invalide et doit être réécrite.

Si une seule réponse est non → corriger avant écriture.

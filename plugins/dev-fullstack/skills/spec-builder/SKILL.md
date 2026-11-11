---
name: spec-builder
description: "Cadre une tâche de code AVANT exécution, à l'étage qu'elle mérite : SPEC-lite d'environ 30 lignes (objectif, périmètre, vérifications) pour une tâche de 10 à 50 lignes ; spec complète en 13 sections au-delà de 50 lignes ou dès que la tâche est structurelle (schéma, auth, dépendance majeure, contrat d'API, migration). Rend un Markdown dans `specs/` du dépôt. Déclencheurs : rédige une spec, SPEC-lite, prépare un PRD, spécifie cette feature, cadre cette tâche avant développement. Pas pour : docs purs, migrations SQL appliquées à la main, configuration du harness Claude Code (agents, skills, CLAUDE.md), ni la décision d'architecture en amont (sub-agent `architecte`)."
---

> Version 1.5 — 11.11.2026 (cure de poids : canevas et gabarits en `references/`, un seul nom du livrable). Versions antérieures : `CHANGELOG.md` du profil, non déployé.

# spec-builder — Générateur de spécifications pour le harness Claude Code

> Ce skill applique les règles transversales définies dans `%USERPROFILE%\Documents\Claude\claude-rules\rules\specs-claude-code.md` (**dépendance externe — hors repo `claude-profiles` et hors `<BUREAU>/`, vit uniquement sur le poste ; version épinglée : v0.2.1**). En cas de conflit ou d'évolution de claude-rules, claude-rules fait foi et le skill doit être mis à jour.
> **Fallback si le fichier est absent** (autre machine, sandbox Linux) : les règles claude-rules reprises plus bas, section « Règles de qualité obligatoires », font foi — ne pas bloquer la rédaction de la spec, signaler le fallback dans le livrable.

Produit un fichier `specs/YYYY-MM-DD-slug.md` rigoureusement structuré, exploitable directement par Claude Code pour exécuter une tâche de développement sans ambiguïté. C'est le seul nom et le seul lieu du livrable dans un dépôt (cf. « Livraison »).

## Principe directeur

**Documentation-first, décisions tranchées, structure non négociable.**

La skill épuise toutes les sources documentaires avant de poser une seule question, tranche elle-même les choix techniques, et impose, au troisième étage (spec complète), une structure de 13 sections strictement nommées. Cible : **0 ou 1 question** à l'utilisateur, uniquement sur arbitrages métier non documentés.

---

## Étage de cadrage — à déterminer AVANT de rédiger (18.08.2026)

La doctrine `dev-fullstack` définit **trois étages**. Ce skill ne produit la spec complète qu'au troisième. Se tromper d'étage vers le haut coûte de la friction sur une tâche qui n'en méritait pas ; vers le bas, une livraison non cadrée.

| Ampleur estimée | Ce que produit ce skill |
|---|---|
| **< 10 lignes** | **Rien.** Le dire, en une ligne : « sous 10 lignes, pas de spec — le hook de build `check-build-ts` (Stop) sert de filet, TypeScript ou non ». Ne pas rédiger, ne pas insister. |
| **10 à 50 lignes** | **SPEC-lite**, ~30 lignes, **trois sections seulement** : `## Objectif` (verbe d'action mesurable), `## Périmètre` (dedans / dehors), `## Vérifications avant fin de tâche` (cases concrètes). Gabarit : `references/gabarit-spec-lite.md`. Même exigence de fond que la spec complète : pas d'invention, chemins exacts, `À DÉFINIR — <explication>` si une info manque. Écrite dans `<racine-du-dépôt>/specs/YYYY-MM-DD-slug.md` **commitée avec le code** ; reçue par le seul brief d'un sub-agent, elle est recopiée dans ce fichier par celui qui commite — la spec complète, elle, l'est avant. |
| **> 50 lignes, ou structurel** | **Spec complète en 13 sections**, sur le canevas de `references/canevas-spec-complete.md`. |

« **Structurel** » l'emporte sur le compte de lignes : schéma de données, auth, dépendance majeure, contrat d'API, migration. Trois lignes qui changent une clé étrangère relèvent du troisième étage.

**L'étage retenu s'annonce à l'utilisateur en une ligne, après la lecture de la Phase 1 (l'estimation la suppose) et avant de rédiger.** Il peut le corriger — c'est une estimation, et une estimation qui ne se dit pas ne se corrige pas.

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

Ouvrir le gabarit de l'étage (`references/gabarit-spec-lite.md` ou `references/canevas-spec-complete.md`), écrire le fichier au chemin imposé et rendre dans le chat la note finale (cf. section « Livraison »).

**Ne jamais afficher le contenu intégral de la spec dans le chat** — uniquement le chemin et la note (sauf livraison inline maintenue par l'utilisateur).

---

## Spec complète — canevas en 13 sections

**Avant de rédiger une spec complète, lire `references/canevas-spec-complete.md` en entier** : il porte les 13 sections, leurs titres `##` exacts, le format imposé de l'auto-review §4 (7 questions) et l'auto-check structurel §5. Le fichier livré le recopie, sans renommer ni numéroter un titre. Une SPEC-lite ne l'ouvre pas.

## Règle de refus de livraison

Pour une spec complète : si **une seule** des 13 sections manque, est mal nommée, ou ne respecte pas son format, la skill **refuse de livrer**. Pour une SPEC-lite, la même règle vaut sur ses trois sections. Elle corrige et relit avant écriture du fichier final.

---

## Règles de qualité obligatoires (à imposer dans chaque spec)

Chaque spec produite doit imposer dans `## Contraintes` :

- **Inventaire exhaustif** quand la tâche touche une famille d'éléments (ex. « toutes les fonctions X ») → la liste complète figure dans `## Périmètre / Dans le scope`
- **Préservation des erreurs existantes** : codes natifs (ENOENT, 4xx, etc.) continuent de remonter
- **Nettoyage des ressources** dans tous les chemins (succès, échec, timeout, unmount)
- **3 groupes de tests** dans `## Vérifications` : happy path + non-régression + edge cases
- **Gestion d'erreur** : pas de try/catch vide, logger via le logger projet, spécifier codes/exceptions retournés. Pour les contextes HTTP : distinguer 4xx (métier) / 5xx (infra)
- **Critères vérifiables et indépendants** : chaque case du checklist `## Vérifications` doit être testable séparément avec une sortie attendue précise
- **Longueur** : viser 300-400 lignes max pour un MVP (SPEC-lite : autour de 30). Au-delà, scinder en deux SPECs ou retirer la redondance
- **Bornes techniques vérifiées** : toute borne quantifiée (numéros de ligne, nombre de helpers, taille fichier) doit être vérifiée par lecture du repo réel au moment de l'écriture, pas estimée
- **Chemins espaces Windows** : tout chemin shell quoté en double quotes (`"tests/**/*.test.mjs"`, `"C:\Users\..."`)
- **Sandbox `node:vm`** : si le test charge du code via `vm.runInContext`, la SPEC doit imposer un epilogue d'export sur `globalThis` pour rendre les fonctions adressables depuis le test runner
- **Décisions à prendre en cours d'exécution** : section dédiée présente dans le canevas (entre `## Contraintes` et `## Vérifications`), reprise dans le rapport final §6

Une SPEC-lite n'a pas de section `## Contraintes` : elle tient ces règles dans son périmètre et ses vérifications, là où elles s'appliquent.

---

## Ton et style de la spec

- **Factuel et concis**. Pas d'emoji dans la spec finale. Pas d'humour, pas de remarques décalées, pas de tutoiement de l'utilisateur.
- **Pas d'invention** : si une info reste inconnue après lecture + question, écrire `À DÉFINIR — <explication>`.
- **Verbes d'action mesurables** dans `## Objectif` (« générer », « réduire à <X>s », « ajouter », pas « améliorer »).
- **Chemins exacts** dans `## Plan d'exécution` (ex. `src/lib/pdfExport.js`), pas de tournures vagues.

---

## Livraison — où écrire la spec

**Dans un dépôt git : `<racine-du-dépôt>/specs/YYYY-MM-DD-slug.md`.** C'est le défaut, et il prime.

La raison est opposable : la doctrine exige que la spec complète soit **commitée avant le code**, la SPEC-lite **avec** lui. Une spec écrite hors du dépôt ne peut pas l'être — elle vit à côté du travail qu'elle cadre, sans jamais y être rattachée, et un `git log` ne la retrouve pas. Dans le dépôt, elle voyage avec le code, se relit dans la PR, et survit au poste.

- `YYYY-MM-DD` : date du jour au format ISO **dans le nom de fichier** (tri lexicographique). Cohabite intentionnellement avec le format suisse `jj.mm.aaaa` utilisé **dans le contenu** du SPEC (en-tête > ligne « Date : »). Ne pas uniformiser : chaque format a sa raison d'être (tri vs lecture humaine).
- `slug` : identique au slug de branche utilisé dans `## Branche cible`

**Hors dépôt** (script isolé, cadrage amont sans code encore) : chemin du poste et repli d'environnement dans `references/livraison-hors-depot.md`, à ouvrir dans ce cas seulement. Mentionner le repli dans la note finale.

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

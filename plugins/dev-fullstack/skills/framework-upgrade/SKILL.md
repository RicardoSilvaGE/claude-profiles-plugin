---
name: framework-upgrade
paths:
  - "**/package.json"
  - "**/package-lock.json"
  - "**/pnpm-lock.yaml"
  - "**/yarn.lock"
  - "**/bun.lockb"
  - "**/tsconfig.json"
  - "**/next.config.*"
  - "**/tailwind.config.*"
  - "**/vite.config.*"
description: "Upgrade d'un framework majeur (Next.js, React, Tailwind, shadcn, TypeScript, Node) : inventaire des breaking changes, audit d'impact, stratégie big bang vs feature flag, codemods, plan de rollback, vérification post-upgrade. Interdit le `npm install <pkg>@latest` à l'aveugle. Déclencheurs : upgrade ou saut de version nommé (Next 14 vers 15, Tailwind v3 vers v4), breaking changes, codemod, framework périmé. Pas pour : une dépendance mineure hors framework, un bug de dépendance (`debug-investigation`), ni Pages Router vers App Router (`architecte`)."
---

> Version 1.6 — 11.11.2026 (cure de poids : pièges par framework en annexe, porte `spec-builder` et règle des release notes écrites une fois, livrable défini). Versions antérieures : `CHANGELOG.md` du profil, non déployé.
> **Ce skill porte `paths`, et c'est délibéré** : il n'est préchargé dans aucun sub-agent (`paths` et `skills:` sont exclusifs), et un upgrade est inconcevable sans manifeste. `paths` ne se déclenche que sur un fichier concordant **effectivement manipulé** (mesure du 17.08.2026).

# framework-upgrade — Upgrade de framework structuré

> Un upgrade de framework non préparé casse plus qu'il n'apporte. Ce skill enforce un workflow méthodique : inventaire des breaking changes, audit d'impact, migration progressive, vérification.

## Principe directeur

**Un upgrade réussi n'est pas un `npm install` : c'est un projet avec scope, plan, rollback et vérification.**

## Périmètre

### Couvert
- Upgrade major / minor de framework principal : Next.js, React, Tailwind, shadcn/ui, TypeScript, Node.js.
- Inventaire des breaking changes vs base de code existante.
- Choix stratégique : big bang vs incrémental vs feature flag.
- Application des codemods officiels, nommés par l'upgrade guide lu le jour même.
- Plan de rollback explicite avant l'exécution.
- Plan de vérification post-upgrade (tests + smoke + monitoring).

### Hors-scope
- Upgrade d'une dep mineure non-framework (`lodash`, `date-fns`) → simple `npm update`.
- Bugfix d'une régression isolée post-upgrade → skill `debug-investigation`.
- Choix initial de stack pour un nouveau projet → sub-agent `architecte`.
- Migration de framework (ex: Vue → React) — c'est une refonte, pas un upgrade → sub-agent `architecte`.

## Skills à invoquer ou MCPs à utiliser

- **`WebFetch` / `WebSearch`** : requis en Phase 1 pour lire les release notes et upgrade guides officiels (URLs listées en Phase 1). Si indisponibles dans la session, demander à l'utilisateur de coller les release notes — ne jamais les réciter de mémoire.
- **`debug-investigation`** (hand-off) : régression isolée découverte post-upgrade.
- **`spec-builder`** : entre la Phase 4 et la Phase 5 (porte écrite en tête de Phase 5).
- Sub-agent **`reviewer`** : review du diff de la branche d'upgrade avant `release` Mode A (séquence 8 d'`ORCHESTRATION.md`).

## Workflow (7 phases, de 0 à 6)

### Phase 0 — Brief obligatoire

Avant toute action, formuler en 5 lignes max :
1. **Cible** : quel framework, quelle version actuelle, quelle version cible ? Version actuelle **lue dans le lockfile**, jamais supposée (forme : `<framework> <actuelle> → <cible>`).
2. **Motivation** : performance, feature requise, fin de support, dépendance qui le force.
3. **Périmètre projet** : taille (`git ls-files '*.tsx' | wc -l`), nombre de pages/routes.
4. **Contraintes** : freeze prochain ? feature en cours sur main ? autre dev sur le repo ?
5. **Niveau de risque acceptable** : peut-on casser temporairement le dev pour 2h ? La prod ?

Si une dimension manque (notamment 4 ou 5), poser **une seule question groupée** avant de continuer.

### Phase 1 — Lecture obligatoire (HARD GATE)

Lire **avant** de toucher au `package.json`, sans exception :

1. **Release notes officielles** entre version actuelle et version cible : chaque release majeure ET mineure, et **en entier** pour chaque majeure intermédiaire.
   - Next.js : https://nextjs.org/blog/next-X (à fetch via WebFetch).
   - React : https://react.dev/blog.
   - Tailwind : https://tailwindcss.com/blog.
   - shadcn : https://ui.shadcn.com/docs/changelog.
   - TypeScript, Node.js : release notes officielles du projet ; leur adresse n'est pas listée ici — la chercher, ne pas la deviner.
2. **Upgrade guide officiel** si dispo (souvent une page dédiée pour les majors).
3. **Codemods officiels** disponibles.
4. **`package.json` du projet** : repérer toutes les deps liées qui doivent suivre (une majeure d'un framework peut en exiger une autre, et ses types : le lire dans les `peerDependencies` et l'upgrade guide officiel, jamais de mémoire).
5. **CLAUDE.md projet** : conventions à respecter, sub-agents impliqués.
6. **Tests existants** : présence d'une suite (unit, e2e) qui validera le post-upgrade.

### Phase 2 — Inventaire des breaking changes

Où chercher les ruptures selon le framework (forme des pièges, sans numéro de version) : `references/pieges-par-framework.md` de ce skill, à ouvrir en début de phase.

Pour chaque breaking change identifié, écrire :
- **Description** : ce qui change (1 phrase).
- **Impact sur le code actuel** : grep / scan du repo pour trouver les sites affectés.
- **Fix automatisable ?** : oui (codemod) / non (manuel).
- **Effort** : XS / S / M / L.

Forme du tableau — **gabarit, sans aucun fait de version** : chaque ligne se remplit depuis les sources de la Phase 1 et le lockfile, jamais de mémoire.
| Breaking change | Impact actuel (grep) | Codemod | Effort |
|---|---|---|---|
| `<rupture citée de la release note, avec son lien>` | `grep -r "<motif>" <dossier>` → N occurrences | `<codemod nommé par l'upgrade guide>` ou manuel | XS/S/M/L |
| `<version minimale d'un runtime exigée par la release note>` | `node -v` et `engines` du `package.json` → valeur lue | n/a | XS/S/M/L |

Si l'inventaire révèle un effort > 1 jour ou des impacts cross-cutting → signaler à `architecte` pour cadrage formel.

### Phase 3 — Stratégie de migration

Décider entre :

**Stratégie A — Big bang** : un seul PR qui upgrade tout. Adapté si :
- Projet petit (< 50 fichiers TSX — repère de ce skill, non sourcé).
- Tests e2e solides.
- Pas de feature en cours sur main.

**Stratégie B — Branche dédiée + tests intensifs** : branche `upgrade/next-15`, batch de fixes, merge à la fin. Adapté si :
- Projet moyen.
- Breaking changes nombreux mais bornés.

**Stratégie C — Migration incrémentale par feature** : si le framework supporte un mode hybride (rare pour les framework majeurs ; Next.js a partiellement supporté Pages + App Router pendant la transition).

**Stratégie D — Reporter** : si effort > 1 semaine sans gain immédiat, documenter et reporter. Pas honteux.

Trancher en début de Phase 3 et écrire la stratégie choisie dans le livrable (défini en fin de Phase 4).

### Phase 4 — Plan de rollback

Avant d'exécuter, documenter :

1. **Snapshot avant** : commit hash actuel, version actuelle de chaque dep clé, output `npm list --depth=0`.
2. **Procédure de rollback** : commandes exactes pour revenir.
   - `git reset --hard <hash>` pour le code.
   - `rm -rf node_modules .next && npm ci` pour les deps.
3. **Critère de rollback** : à quel signe on revient en arrière ? (tests qui échouent > N, perf qui se dégrade > X%, bug bloquant en prod).
4. **Limite de temps** : « si après 2h de tentatives le build ne passe pas, rollback ».

Cette procédure vaut **tant que la branche n'est pas fusionnée**. Après fusion ou mise en prod, le retour arrière n'est plus un `git reset` : sa commande s'écrit au Mode A de `release` et s'exécute en Mode D.

**Livrable des Phases 0 à 4** — une note d'upgrade rendue dans la conversation, matière de la spec :

```
# Upgrade <framework> <actuelle> → <cible> — <date>
## Brief (Phase 0) : motivation, périmètre, contraintes, risque acceptable
## Sources lues (Phase 1) : release notes et upgrade guide, avec liens et date de lecture
## Inventaire (Phase 2) : tableau des breaking changes
## Stratégie (Phase 3) : A / B / C / D, et pourquoi
## Rollback (Phase 4) : snapshot, commandes, critère, limite de temps
## Vérification prévue (Phase 6)
```

### Phase 5 — Exécution

**Préalable (HARD GATE)** : la spec complète de l'upgrade est écrite via `spec-builder` et **commitée avant** le premier bump, quel que soit le nombre de lignes touchées — dépendance majeure = structurel (doctrine du profil, § « Règle absolue spec-builder »). La note des Phases 0 à 4 en fournit la matière ; elle ne la remplace pas. Pas de spec, pas de Phase 5.

1. **Brancher** : `git checkout -b upgrade/<framework>-<from>-to-<to>`.
2. **Bump versions** dans `package.json`. Bumper les peer deps liées.
3. **`npm install`** (ou `pnpm`, `yarn`). Lire les warnings/peer deps non satisfaites.
4. **Lancer les codemods** un par un, commit après chaque (pour pouvoir cherry-pick).
5. **Build local** : `npm run build`. Corriger les erreurs TypeScript et build une par une.
6. **Type check** : `tsc --noEmit`.
7. **Tests** : `npm test`. Corriger les régressions.
8. **Smoke manuel** : parcours utilisateur critique en local.

Chaque correction = un commit dédié. Pas de méga-commit "upgrade + 50 fixes".

### Phase 6 — Vérification post-upgrade

Une fois le build vert :

1. **Diff visuel** : comparer screenshots de pages clés avant/après si possible.
2. **Tests e2e** : suite complète si présente.
3. **Lighthouse** : LCP, INP, CLS avant/après — l'upgrade ne doit pas dégrader.
4. **Bundle size** : avant/après. Régression > 10% (repère de ce skill, non sourcé) = à investiguer.
5. **Preview de l'hébergeur** (preview Vercel, ou l'équivalent de la stack : Render, NAS) : déployer la branche en preview, smoke test sur la vraie infra.
6. **Review du diff par `reviewer`**, puis **hand-off `release` Mode A** avant merge prod.

## Garde-fous (règles dures)

- Les phases sont des portes, dans l'ordre : pas de bump sans Phase 1, pas de Phase 5 sans stratégie (3), rollback (4) et spec.
- Aucun merge sur main sans vérification Phase 6 complète.
- Si effort réel > effort estimé Phase 2 × 2 → stop, re-cadrer.
- Si un breaking change cross-cutting est découvert en Phase 5 (pas anticipé Phase 2) → stop, repasser Phase 2.

## Anti-patterns interdits

- **Bumper plusieurs frameworks en même temps** (Next + React + Tailwind ensemble) — diagnostic impossible si ça casse.
- **Ignorer les warnings de peer deps** : ils prédisent les bugs de demain.
- **Commit unique "upgrade Next.js"** sans découpage : non-rollback-friendly, non-reviewable.
- **Skipper les codemods pour faire à la main** : plus d'erreurs, plus lent.
- **Lancer en prod sans preview** (Vercel ou l'équivalent de l'hébergeur) sur la branche d'upgrade.
- **Upgrade « pour rester à jour »** sans motivation produit ou technique claire.
- **Tester uniquement le happy path** post-upgrade : c'est sur les edges que les régressions cassent.

## Auto-check final (avant livraison)

- Chaque version citée vient-elle du lockfile ou d'une release note lue ce jour, avec son lien ?
- Chaque ligne de l'inventaire porte-t-elle son grep et son nombre d'occurrences ?
- Le hand-off `reviewer` puis `release` Mode A est-il écrit en fin de livraison ?

Si une seule réponse est non → corriger avant livraison.

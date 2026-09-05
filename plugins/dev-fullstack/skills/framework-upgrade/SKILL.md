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
description: "Upgrade d'un framework majeur (Next.js, React, Tailwind, shadcn, TypeScript, Node) : inventaire des breaking changes, audit d'impact, stratégie big bang vs feature flag, codemods, plan de rollback, vérification post-upgrade. Interdit le `npm install <pkg>@latest` à l'aveugle. Déclencheurs : upgrade ou saut de version nommé (Next 14 vers 15, Tailwind v3 vers v4), migration Pages Router vers App Router, breaking changes, codemod, deps périmées. Pas pour : une dépendance mineure hors framework, ni un bug de dépendance (`debug-investigation`)."
---

> Version 1.2 — 17.08.2026 (ajout du champ frontmatter `paths` : l'activation **automatique** est bornée aux manifestes et fichiers de configuration de la chaîne JS/TS. `/framework-upgrade` reste invocable partout — `paths` ne borne que le déclenchement par le modèle.
> **Ce skill porte `paths`, et c'est délibéré** (`publication-store` en porte aussi depuis le 04.09.2026 ; son cas, où le déclencheur naturel est une phrase, est instruit au constat D10 de l'audit du 05.09 et attend un témoin). Deux raisons cumulées. D'abord il n'est préchargé dans aucun sub-agent : `paths` et le préchargement (`skills:`) sont **exclusifs** — un skill portant `paths` n'est pas préchargeable, vérifié par témoin isolé le 17.08.2026 et absent de la documentation officielle. Ensuite un upgrade de framework est **inconcevable sans manifeste** : la première chose que fait ce skill est de lire le `package.json`, donc la borne se referme sur elle-même au lieu de rater le déclenchement.
> **Sémantique à connaître avant d'en poser ailleurs** : `paths` ne se déclenche pas parce que le dossier *contient* un fichier concordant, mais parce qu'un tel fichier est **effectivement manipulé**. Mesuré le 17.08.2026 : dans un dossier contenant un `.tsx`, un skill borné sur `**/*.tsx` reste absent tant que le fichier n'a pas été lu. Un skill dont le déclencheur naturel est une phrase et non un fichier ne doit donc **pas** porter `paths` — il se tairait sans que rien ne le signale.)
> Version 1.1 — 12.06.2026 (audit dev-fullstack : ligne de version ajoutée ; `WebFetch` déclaré explicitement comme outil requis).
> Version 1.0 — 21.05.2026 (création ; entré au repo le 26.05.2026).

# framework-upgrade — Upgrade de framework structuré

> Un upgrade de framework non préparé casse plus qu'il n'apporte. Ce skill enforce un workflow méthodique : inventaire des breaking changes, audit d'impact, migration progressive, vérification.

## Principe directeur

**Lire les release notes en entier avant de toucher au `package.json`.** Un upgrade réussi n'est pas un `npm install` : c'est un projet avec scope, plan, rollback et vérification.

## Périmètre

### Couvert
- Upgrade major / minor de framework principal : Next.js, React, Tailwind, shadcn/ui, TypeScript, Node.js.
- Inventaire des breaking changes vs base de code existante.
- Choix stratégique : big bang vs incrémental vs feature flag.
- Application des codemods officiels (`@next/codemod`, `types-react-codemod`, etc.).
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

## Workflow (6 phases)

### Phase 0 — Brief obligatoire

Avant toute action, formuler en 5 lignes max :
1. **Cible** : quel framework, quelle version actuelle, quelle version cible ? (ex: Next.js 14.2 → 15.0).
2. **Motivation** : performance, feature requise, fin de support, dépendance qui le force.
3. **Périmètre projet** : taille (`find src -name '*.tsx' | wc -l`), nombre de pages/routes.
4. **Contraintes** : freeze prochain ? feature en cours sur main ? autre dev sur le repo ?
5. **Niveau de risque acceptable** : peut-on casser temporairement le dev pour 2h ? La prod ?

Si une dimension manque (notamment 4 ou 5), poser **une seule question groupée** avant de continuer.

### Phase 1 — Lecture obligatoire (HARD GATE)

Lire **avant** de toucher au `package.json`, sans exception :

1. **Release notes officielles** entre version actuelle et version cible. Lire chaque release majeure ET mineure.
   - Next.js : https://nextjs.org/blog/next-X (à fetch via WebFetch).
   - React : https://react.dev/blog.
   - Tailwind : https://tailwindcss.com/blog.
   - shadcn : https://ui.shadcn.com/docs/changelog.
2. **Upgrade guide officiel** si dispo (souvent une page dédiée pour les majors).
3. **Codemods officiels** disponibles.
4. **`package.json` du projet** : repérer toutes les deps liées qui doivent suivre (ex: Next 15 demande React 19, types correspondants).
5. **CLAUDE.md projet** : conventions à respecter, sub-agents impliqués.
6. **Tests existants** : présence d'une suite (unit, e2e) qui validera le post-upgrade.

**Pas d'upgrade sans avoir lu en entier les release notes de chaque release majeure intermédiaire.**

### Phase 2 — Inventaire des breaking changes

Pour chaque breaking change identifié, écrire :
- **Description** : ce qui change (1 phrase).
- **Impact sur le code actuel** : grep / scan du repo pour trouver les sites affectés.
- **Fix automatisable ?** : oui (codemod) / non (manuel).
- **Effort** : XS / S / M / L.

Exemple Next.js 14 → 15 :
| Breaking change | Impact actuel (grep) | Codemod | Effort |
|---|---|---|---|
| `params` / `searchParams` async | `grep -r "params\." app/` → 12 occurrences | `@next/codemod next-async-request-api` | S |
| `fetch` cache default `no-store` | revoir tous les fetch côté Server Component | manuel | M |
| `NextRequest.ip` retiré | `grep -r "request.ip"` → 2 occurrences | manuel | XS |
| Min Node 18.18 | `node -v` → 20.x ✅ | n/a | XS |

Si l'inventaire révèle un effort > 1 jour ou des impacts cross-cutting → signaler à `architecte` pour cadrage formel.

### Phase 3 — Stratégie de migration

Décider entre :

**Stratégie A — Big bang** : un seul PR qui upgrade tout. Adapté si :
- Projet petit (< 50 fichiers TSX).
- Tests e2e solides.
- Pas de feature en cours sur main.

**Stratégie B — Branche dédiée + tests intensifs** : branche `upgrade/next-15`, batch de fixes, merge à la fin. Adapté si :
- Projet moyen.
- Breaking changes nombreux mais bornés.

**Stratégie C — Migration incrémentale par feature** : si le framework supporte un mode hybride (rare pour les framework majeurs ; Next.js a partiellement supporté Pages + App Router pendant la transition).

**Stratégie D — Reporter** : si effort > 1 semaine sans gain immédiat, documenter et reporter. Pas honteux.

Trancher en début de Phase 3 et écrire la stratégie choisie dans le livrable.

### Phase 4 — Plan de rollback

Avant d'exécuter, documenter :

1. **Snapshot avant** : commit hash actuel, version actuelle de chaque dep clé, output `npm list --depth=0`.
2. **Procédure de rollback** : commandes exactes pour revenir.
   - `git reset --hard <hash>` pour le code.
   - `rm -rf node_modules .next && npm ci` pour les deps.
3. **Critère de rollback** : à quel signe on revient en arrière ? (tests qui échouent > N, perf qui se dégrade > X%, bug bloquant en prod).
4. **Limite de temps** : « si après 2h de tentatives le build ne passe pas, rollback ».

### Phase 5 — Exécution

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
4. **Bundle size** : avant/après. Régression > 10% = à investiguer.
5. **Preview Vercel** : déployer la branche en preview, smoke test sur la vraie infra.
6. **Hand-off `release` Mode A** avant merge prod.

## Garde-fous (règles dures)

- Aucun `npm install <framework>@latest` sans Phase 1 lecture des release notes complètes.
- Aucun upgrade sans stratégie (Phase 3) explicitement choisie.
- Aucun upgrade sans plan de rollback (Phase 4) écrit avant l'exécution.
- Aucun merge sur main sans vérification Phase 6 complète.
- Si effort réel > effort estimé Phase 2 × 2 → stop, re-cadrer.
- Si un breaking change cross-cutting est découvert en Phase 5 (pas anticipé Phase 2) → stop, repasser Phase 2.

## Anti-patterns interdits

- **`npm install next@latest`** sans avoir lu les release notes.
- **Bumper plusieurs frameworks en même temps** (Next + React + Tailwind ensemble) — diagnostic impossible si ça casse.
- **Ignorer les warnings de peer deps** : ils prédisent les bugs de demain.
- **Commit unique "upgrade Next.js"** sans découpage : non-rollback-friendly, non-reviewable.
- **Skipper les codemods pour faire à la main** : plus d'erreurs, plus lent.
- **Lancer en prod sans preview Vercel** sur la branche d'upgrade.
- **Upgrade « pour rester à jour »** sans motivation produit ou technique claire.
- **Tester uniquement le happy path** post-upgrade : c'est sur les edges que les régressions cassent.

## Connaissance domaine métier (upgrades typiques de la stack du profil)

### Next.js
- **14 → 15** : `params`/`searchParams` async, fetch cache default change, React 19 requis, `NextRequest.ip` retiré, instrumentation hook stable.
- **15 → 15.x mineurs** : codemod `next-async-request-api` à connaître. Lire le changelog avant chaque mineur.
- **App Router (depuis 13.4)** : si encore Pages Router, c'est une migration plutôt qu'un upgrade — cadrer avec `architecte`.

### React
- **18 → 19** : nouveau compiler (opt-in), `use()`, Actions / `useActionState`, `useFormStatus`, `useOptimistic`, ref as prop, document metadata, `<title>` etc. dans composants.
- **Types** : `@types/react` 19, breaking sur `ReactNode` (plus de `{}` autorisé), `forwardRef` déprécié au profit de ref comme prop.

### Tailwind
- **v3 → v4** : new engine (Oxide, Rust-based), config en CSS via `@theme`, plus de `tailwind.config.js` traditionnel (compat mode dispo), `@import "tailwindcss"` au lieu de 3 directives. Codemod : `npx @tailwindcss/upgrade@next`.

### shadcn/ui
- **Pas une lib npm — c'est du code copié**. "Upgrade" = re-coller depuis le nouveau registry. Customisations à re-appliquer manuellement.
- Vérifier la compat avec la version de Radix UI sous-jacente.

### TypeScript
- **5.x → 5.y** : généralement smooth. Lire les release notes pour `--noUncheckedIndexedAccess` ou autre flag de strictness ajouté par défaut.
- **Major** : breaking sur `Symbol`, `Iterator`, types utilitaires.

### Node.js
- **18 → 20 LTS** : généralement OK. Vérifier la matrice de compat de Vercel / Supabase.
- **20 → 22 LTS** : idem.
- Toujours bumper `engines.node` dans `package.json` après l'upgrade.

### Outils utiles
- `npx npm-check-updates -u` (juste pour voir, pas pour appliquer aveuglément).
- `@next/codemod`, `types-react-codemod`, `@tailwindcss/upgrade`.
- `npm ls <pkg>` : voir où une dep est utilisée.
- `npm dedupe` : nettoyer après upgrade.

## Auto-check final (avant livraison)

- Phase 0 brief formulé (versions + motivation + risque acceptable) ?
- Phase 1 release notes lues en ENTIER pour chaque version intermédiaire ?
- Phase 2 inventaire des breaking changes avec impact grep et effort estimé ?
- Phase 3 stratégie choisie explicitement (A/B/C/D) ?
- Phase 4 plan de rollback écrit AVANT exécution ?
- Phase 5 commits découpés (1 codemod = 1 commit, pas méga-commit) ?
- Phase 6 vérifications complètes (build + tests + Lighthouse + bundle + preview) ?
- Hand-off `release` Mode A avant merge prod ?

Si une seule réponse est non → corriger avant livraison.

## Incidents source

- *(à compléter au fil des upgrades — chaque upgrade qui découvre un piège non documenté ailleurs mérite une entrée).*

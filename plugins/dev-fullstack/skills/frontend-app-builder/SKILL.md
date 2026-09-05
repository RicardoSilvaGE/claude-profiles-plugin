---
name: frontend-app-builder
description: "Génère une application React SPA complète et production-ready depuis un gabarit d'architecture versionné : Vite + TypeScript strict + Tailwind + React Router + Zustand + auth. Déclencheurs : créer une app React, une SPA, un dashboard, un outil web, un frontend pour une API ; ou une demande partielle (ajouter une page, créer le routing) quand le contexte est déjà une SPA du gabarit. Pas pour : une app Next.js, SSR ou SEO-critique (sub-agent `frontend`), le polish d'un composant (`frontend` Mode C), l'identité visuelle (sub-agent `designer`), ni des pièces déjà éprouvées à recopier — HTTPS local, PWA, `server.js` — qui sont dans `librairie-maison`."
---

> Version 2.1 — 05.09.2026 (PR 2.1 de l'audit du 05.09 : renvoi croisé vers `librairie-maison` dans la description — « nouvelle application » se routait vers trois skills qui ne se citaient pas.)
> Version 2.0 — 12.06.2026 (refonte pattern v2 suite à l'audit dev-fullstack : Modes A/B/C, Phase -1 SPEC, Phase 0 lecture, workflow orchestré, garde-fous, auto-check ; le contenu tutoriel est déplacé vers `references/architecture-patterns.md` ; assets et références désormais câblés explicitement dans le workflow ; versions alignées sur `assets/package-template.json` — Vite 6+).
> Version 1.0 — 26.05.2026 (import d'un bundle externe, hors pattern v2 : guide de patterns monolithique de 744 lignes présenté comme générateur).

# frontend-app-builder — Génération d'app React SPA sur gabarit

Ce skill génère des applications React complètes, prêtes pour la production, en suivant un **gabarit d'architecture versionné** : scaffolding, routing, state management, authentification, couche API et design system. Le SKILL.md orchestre ; le détail des patterns vit dans `references/`, les templates de configuration dans `assets/`.

## Positionnement

- **Ce skill** = architecture, code, patterns React/TypeScript, logique applicative d'une **SPA Vite**.
- **`designer`** (sub-agent) = identité visuelle, archétypes design, motion. Les deux se combinent : ce skill fait le code, `designer` guide l'esthétique.
- **Sub-agent `frontend`** = code client dans un projet **Next.js** existant (App Router, Server Components). Si le besoin est SSR, SEO-critique ou déjà sur Next.js → `frontend`, pas ce skill.
- **`frontend` Mode C** = retouche ciblée d'un composant existant.

## La stack : le projet décide, le skill a un gabarit

Le gabarit par défaut (si le projet n'impose rien) est celui d'`assets/package-template.json` : React 18+, Vite 6+, TypeScript 5+ strict, Tailwind 4+, React Router 6+, Zustand 4+. **Les versions épinglées du template font foi** sur les tableaux indicatifs des références.

Si le `CLAUDE.md` du projet impose autre chose (autre state manager, autre lib de routing, zéro dépendance), la contrainte projet s'applique sans rejouer le débat — les principes (TS strict, couche services, selectors, états UI complets) restent obligatoires, les libs ne sont que le défaut.

## Ressources du skill (à câbler dans le workflow)

| Ressource | Usage | Quand |
|---|---|---|
| `assets/package-template.json` | Base du `package.json` généré (versions épinglées, source de vérité) | Étape 2 (scaffolding) |
| `assets/tsconfig-template.json` | Base du `tsconfig.json` strict | Étape 2 (scaffolding) |
| `references/architecture-patterns.md` | Structure `src/`, configs Vite/Tailwind, routing, stores, services, auth, conventions TS, error handling, pièges | Étapes 2 et 5-10 |
| `references/ui-components.md` | Primitives UI détaillées (Button, Input, Card, Modal, Badge, Table, Tabs, Toast...) | Étape 4 |
| `references/advanced-patterns.md` | Formulaires, data tables, notifications, dark mode toggle | Étapes 9-11, si la feature le demande |

Ne pas paraphraser ces fichiers de mémoire : les **lire** au moment indiqué.

## Modes — détecter en Phase 0

- **Mode A — Génération complète** : nouvelle app from scratch. Workflow intégral (étapes 1 à 11).
- **Mode B — Extension d'une app existante** conforme au gabarit : nouvelle page, module, store, service ("ajoute une page de login", "crée le routing"). Étapes pertinentes uniquement, en réutilisant l'existant (jamais re-scaffolder).
- **Mode C — Mise en conformité** : app existante à rapprocher du gabarit (structure `src/`, couche services, selectors). Produit un diagnostic d'écarts puis les correctifs, par priorité.

Le mode est déclaré en début de livrable.

## Phase -1 — Vérification SPEC (HARD GATE, règle 19.05.2026)

Ce skill **écrit du code**. Une SPEC.md doit exister pour la tâche ; sinon → invoquer `spec-builder` d'abord. Exception hotfix ≤ 5 lignes : signaler explicitement. Le code suit la spec, jamais l'inverse.

## Phase 0 — Lecture obligatoire (HARD GATE)

Citer en bullets compacts avant toute génération :

1. `SPEC.md` de la tâche (Phase -1).
2. `CLAUDE.md` du projet (stack imposée ? conventions ?) — détermine si le gabarit s'applique ou si la main passe au sub-agent `frontend`.
3. `assets/package-template.json` + `assets/tsconfig-template.json` (Mode A) ou le `package.json` réel du projet (Modes B/C).
4. Les sections de `references/architecture-patterns.md` couvrant les étapes prévues.
5. Modes B/C : le code existant (structure `src/`, stores, services, primitives UI déjà en place).

## Workflow de génération (Mode A — adapter en B/C)

1. **Brief** : pages, données, API backend, auth requise ? Une seule question groupée si une dimension manque.
2. **Scaffolding** : générer `package.json` (depuis `assets/package-template.json`), `tsconfig.json` (depuis `assets/tsconfig-template.json`), `vite.config.ts`, structure `src/` (cf. `references/architecture-patterns.md` § Architecture).
3. **Design tokens** : couleurs, polices, espacements dans `index.css` (règles de design du `global-CLAUDE.md` : système 4px, neutres + 1 accent, dark mode).
4. **Composants UI** : Button, Input, Card, Modal — depuis `references/ui-components.md`.
5. **Layout** : Shell (Sidebar + Header + main), responsive mobile.
6. **Routes** : `createBrowserRouter`, lazy loading si > 5 pages.
7. **Stores** : stores Zustand par domaine, selectors granulaires.
8. **Services** : instance API + un service par domaine — aucun fetch dans les composants.
9. **Pages** : composer les éléments précédents, 1 fichier = 1 route.
10. **Auth** : ProtectedRoute, Login, gestion du token par intercepteur.
11. **Polish** : loading states, error boundaries, empty states, transitions (4 états par écran, cf. doctrine `ux`).

## Format de livrable

Pour chaque app générée :

1. Tous les fichiers sources dans `src/` selon la structure du gabarit.
2. `package.json`, `vite.config.ts`, `tsconfig.json` complets.
3. `.env.example` avec les variables `VITE_*` nécessaires.
4. Instructions de lancement : `npm install && npm run dev`.
5. **Vérification** : `npm run build` + `tsc --noEmit` doivent passer — l'affirmer seulement si exécutés, sinon donner les commandes à lancer.

En tête du livrable : mode déclaré + sources lues (Phase 0).

## Garde-fous (règles dures)

- Aucune génération sans SPEC.md (Phase -1) ni lecture Phase 0 citée.
- `strict: true` non négociable ; pas de `any` non documenté.
- Aucun `fetch`/`axios` directement dans un composant : tout passe par `services/`.
- Stores Zustand consommés via selectors (`useStore(s => s.value)`), jamais le store entier.
- Code complet — jamais de `// TODO` ni pseudo-code.
- Tout interactif a ses états hover / focus visible / disabled ; tout écran a ses 4 états (empty/loading/error/success).
- Versions de dépendances : celles d'`assets/package-template.json` *(si gabarit par défaut)* ; ne pas inventer une version.

## Anti-patterns interdits

- **Générer une SPA Vite quand le besoin est SSR/SEO** : si le contenu doit être indexé ou rendu serveur → sub-agent `frontend` (Next.js). Le choix SPA vs SSR se tranche en Phase 0, pas après le scaffolding.
- **Re-scaffolder une app existante** en Mode B : on étend, on ne régénère pas.
- **Paraphraser les références de mémoire** au lieu de les lire (dérive des patterns).
- **`<BrowserRouter>` legacy** au lieu de `createBrowserRouter`.
- Pièges d'implémentation détaillés : cf. `references/architecture-patterns.md` § Pièges courants.

## Anti-hallucination

Ne jamais citer une API React/Vite/Zustand/Router sans certitude — vérifier dans les références ou la doc officielle. Les versions viennent du template, pas de mémoire. En cas de doute sur une API récente : le dire, vérifier, puis répondre.

## Hand-off

- **`reviewer`** : review pré-merge du code généré (systématique, règle d'orchestration n°4).
- **`designer`** : si une direction visuelle au-delà des tokens par défaut est attendue.
- **`qa`** : matrice de tests si l'app dépasse le prototype.
- **`release` Mode A** : avant tout déploiement.

## Auto-check final (avant livraison)

- SPEC.md existante et suivie (ou exception hotfix signalée) ?
- Phase 0 citée (CLAUDE.md projet + assets + références lues) ?
- Mode A/B/C déclaré et respecté (pas de re-scaffolding en B) ?
- `package.json`/`tsconfig.json` issus des templates `assets/` *(si gabarit par défaut, sinon N/A)* ?
- Aucun fetch hors `services/`, selectors Zustand partout ?
- 4 états UI + a11y de base (labels, focus visible) sur chaque écran livré ?
- Build/typecheck passés ou commandes de vérification fournies ?
- Hand-off `reviewer` proposé ?

Si une seule réponse est non → corriger avant livraison.

## Incidents source

- **12.06.2026 — audit dev-fullstack** : le skill (importé d'un bundle externe le 26.05.2026) était un guide monolithique sans structure pattern v2 ; ses `assets/` n'étaient jamais référencés dans le workflow et le tableau de stack annonçait Vite 5+ contre `^6.0.0` épinglé dans le template. Refonte : SKILL.md orchestrateur + `references/architecture-patterns.md`. Leçon : un skill importé s'aligne au pattern v2 **au moment de l'import** (cf. mémoire `skill-toujours-par-le-repo`).

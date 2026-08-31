---
name: perf-audit
description: "Audit de performance d'une app Next.js + React + Supabase : Web Vitals (LCP, INP, CLS), taille de bundle, N+1 SQL, re-renders inutiles, fetch waterfalls, lazy loading manquant, configuration Vercel. Rend un rapport priorisé CRITIQUE/HAUT/MOYEN/FAIBLE, avec impact chiffré quand c'est mesurable. Déclencheurs : c'est lent, audit perf, Lighthouse, TTFB, bundle trop gros, re-render, useMemo, code splitting. Pas pour : un bug isolé (`debug-investigation`), un audit sécurité (sub-agent `securite`), une refonte large (sub-agent `architecte`)."
context: fork
agent: general-purpose
background: false
---

> Version 1.1 — 19.08.2026 (**le skill s'exécute désormais dans un fork**, action A3.2 du plan
> « Cap sur l'exécutable ». Motif : un audit de perf lit des bundles, des traces et des plans de
> requête — des **dumps**, qui saturaient le contexte principal alors que seul le *rapport* a de
> la valeur pour la suite de la conversation. `context: fork` fait exécuter le skill par un
> sous-agent ; seul son rendu revient. `background: false` est délibéré : on veut le rapport
> **dans le tour**, pas en notification différée — un audit qu'on lance, on l'attend.
> **Critère de la mesure**, à vérifier au premier audit complet : contexte principal réduit de
> moitié. S'il ne l'est pas, le fork ne sert à rien ici et se retire.
> **Ce skill ne porte pas de champ `paths`, et c'est nécessaire** : un skill borné par `paths`
> n'atteint jamais un sous-agent, les deux mécanismes s'excluent.)
> Version 1.0 — 21.05.2026 (création ; entré au repo le 26.05.2026 ; ligne de version ajoutée le 12.06.2026, audit dev-fullstack).

# perf-audit — Audit de performance ciblé

> Performance = mesures, pas intuitions. Ce skill force la mesure avant l'optim, et chiffre l'impact attendu de chaque correctif.

## Principe directeur

**Mesurer avant d'optimiser, prioriser par impact réel.** Une optim sans mesure préalable est une croyance. Un correctif sans impact mesurable est du bruit. Ce skill exige les deux.

## Périmètre

### Couvert
- Audit Web Vitals (LCP, INP, CLS, TTFB) sur un parcours réel.
- Bundle analysis : taille par chunk, gros modules importés, doublons.
- Détection N+1 SQL côté Supabase (queries dans une boucle async).
- Re-renders React inutiles (composants qui re-rendent sans changement utile).
- Fetch waterfalls (requêtes sérielles qui pourraient être parallèles).
- Lazy loading manquant (composants lourds non-critiques).
- Config Next.js / Vercel relative à la perf (cache, ISR, edge vs node, image opt).

### Hors-scope
- Optimisation Postgres bas niveau (EXPLAIN, indexes complexes) → relève du sub-agent `backend`.
- Refacto structurelle large → cadrage par `architecte`.
- Audit sécurité → sub-agent `securite`.
- Bug isolé → skill `debug-investigation`.
- Tuning d'infra Vercel/Cloudflare → relève du sub-agent `release`.

## Workflow (5 phases)

### Phase 0 — Brief obligatoire

Avant toute action, formuler en 5 lignes max :
1. **Symptôme ressenti** : « la page X met 4s à charger », « scroll saccadé sur Y », « bundle initial 800kB ».
2. **Périmètre** : 1 page, 1 parcours, ou toute l'app ?
3. **Environnement** : prod (vrais users) / preview / dev. Quel device (desktop, mobile mid-tier) ?
4. **Métriques actuelles si dispo** : Vercel Speed Insights, Lighthouse score, taille bundle.
5. **Objectif chiffré** : « LCP < 2.5s », « bundle initial < 200kB ». Sinon, signaler qu'il manque.

Si dimension manque (notamment 1 ou 5), poser **une seule question groupée** avant de continuer.

### Phase 1 — Mesure avant tout (HARD GATE)

Lire et collecter, sans demander :

1. `package.json` : taille des deps, scripts (`build`, `analyze` si présent).
2. `next.config.*` : config images, cache, output, experimental flags.
3. Pour la page cible :
   - Le composant racine et ses imports directs.
   - Server vs Client Components (`'use client'` présence).
   - Stratégie de fetch (Server Component fetch, `use()`, React Query, `useEffect`).
4. **Métriques réelles** :
   - Si Vercel Speed Insights actif : lire les valeurs récentes (p75 LCP, INP, CLS).
   - Sinon : demander à l'utilisateur de lancer Lighthouse sur la page cible (mobile, throttled) et fournir le rapport.
   - Pour bundle : demander `next build` output ou un bundle analyzer si pas encore lancé.

**Aucun chiffre inventé.** Si pas de mesure dispo, l'écrire explicitement et donner la commande à lancer.

### Phase 2 — Analyse par axe

Parcourir systématiquement les axes ci-dessous. Pour chaque axe, soit OK soit finding avec sévérité.

**Axe 1 — LCP (Largest Contentful Paint)**
- Élément LCP identifié ? (souvent hero image, premier `<h1>`).
- Image LCP : `priority` dans `<Image>` ? format moderne (WebP/AVIF) ? `sizes` correct ?
- LCP bloqué par JS ? (font, script, fetch en attente).

**Axe 2 — INP (Interaction to Next Paint)**
- Handlers lourds sur clic / input ? (long task > 50ms).
- État global mis à jour synchroniquement sur grosse liste ? (manque virtualization).
- Animations en JS au lieu de CSS ?

**Axe 3 — CLS (Cumulative Layout Shift)**
- Images sans `width`/`height` ou `aspect-ratio` ?
- Fonts qui chargent en flash (manque `font-display: swap` ou next/font) ?
- Ads/embed qui apparaissent et poussent le contenu ?

**Axe 4 — Bundle**
- Taille du chunk initial (`/_next/static/chunks/main-*.js`).
- Gros modules : `next-bundle-analyzer` ou `@next/bundle-analyzer`.
- Doublons (deux versions de lodash, react-icons importé en entier).
- Imports paresseux : `dynamic(() => import('...'))` sur modales/heavy widgets.
- Tree-shaking : `import { x } from 'lodash'` vs `import x from 'lodash/x'`.

**Axe 5 — React rendering**
- Composants qui re-rendent sans raison (utiliser React DevTools Profiler).
- Listes longues sans virtualization (`react-window`, `@tanstack/react-virtual`).
- Context global qui re-render tous les consumers → split en plus petits contexts ou utiliser Zustand.
- `useMemo` / `React.memo` absents là où coûteux ; ou présents là où inutile (anti-pattern symétrique).

**Axe 6 — Fetch / data**
- Fetch dans `useEffect` au lieu de Server Component.
- Waterfalls : requête A → attend → requête B. Solution : Server Component avec `Promise.all`, ou `parallel routes`.
- N+1 Supabase : boucle JS qui fait une query par item. Solution : query unique avec join ou `IN (...)`.
- Pas de cache (`{ cache: 'no-store' }` involontaire ou `revalidate: 0`).
- React Query / SWR : `staleTime` à 0 → re-fetch sur chaque mount.

**Axe 7 — Server / Next.js**
- Server Components everywhere par défaut, `'use client'` minimisé ?
- `dynamic` avec `ssr: false` sur composants vraiment client-only seulement ?
- ISR (`revalidate`) configuré sur pages qui le supportent ?
- Edge runtime utile (latence) ou contre-productif (start-up à froid) ?

### Phase 3 — Priorisation + impact chiffré

Pour chaque finding, attribuer :
- **Sévérité** : CRITIQUE (LCP > 4s, bundle > 1MB, INP > 500ms), HAUT (LCP > 2.5s, bundle > 500kB), MOYEN (CLS > 0.1, re-renders évitables), FAIBLE (micro-optim).
- **Impact chiffré attendu** : « gain LCP estimé -800ms », « bundle -120kB », « -3 queries par page ». Si non chiffrable : « impact mesurable post-correctif requis ».
- **Effort** : XS (< 30 min), S (< 2h), M (< 1 jour), L (> 1 jour).
- **Coût/gain** : ordonner par gain × (1/effort).

### Phase 4 — Livrable

Note structurée :

```
# Audit perf — <page ou parcours> — <date>

## Phase 0 — Brief
- Symptôme : ...
- Périmètre : ...
- Métriques actuelles : LCP=Xs, INP=Yms, CLS=Z, bundle initial=NkB
- Objectif : ...

## Phase 1 — Sources lues
- ...

## Findings (par sévérité)

### CRITIQUE
- **<ID>** — <axe> — <fichier:ligne> — <problème>
  - Impact : <chiffré>
  - Effort : XS/S/M/L
  - Fix : <action concrète>

### HAUT
- ...

### MOYEN
- ...

### FAIBLE
- ...

## Plan d'attaque recommandé
1. <Action coût/gain max>
2. ...

## Mesures post-correctifs à refaire
- Lighthouse sur <URL>
- Vercel Speed Insights après 24h
- Bundle après `next build`
```

## Garde-fous (règles dures)

- Aucune optim recommandée sans une mesure préalable qui justifie l'effort.
- Aucun chiffre dans le rapport sans source (Lighthouse, Speed Insights, bundle analyzer).
- Aucun `useMemo` / `React.memo` ajouté sans profiling qui montre que le composant re-rendait coûteusement.
- Si finding nécessite une refacto structurelle → signaler à `architecte` au lieu de patcher.
- Si finding révèle un N+1 SQL → hand-off à `backend` ou `supabase-toolkit` pour le fix DB.

## Anti-patterns interdits

- **`useMemo` partout** : ajoute du coût (allocation, comparaison) sans gain prouvé.
- **`React.memo` sur tout composant** : casse les patterns de composition, masque le vrai problème.
- **Lazy load la page entière** : aggrave LCP, dégrade UX.
- **`fetch(..., { cache: 'no-store' })` par défaut** : empêche le caching Next.js automatique.
- **Bundle analyzer une fois, jamais re-checké** : la dette revient.
- **« Ça doit être plus rapide après cette modif »** sans mesure avant/après.
- **Optim de perf en l'absence d'un problème mesuré** (« au cas où »).

## Connaissance domaine métier (Next.js + React + Supabase + Vercel)

### Métriques cibles
- **LCP** : < 2.5s (bon), 2.5-4s (à améliorer), > 4s (mauvais).
- **INP** : < 200ms (bon), 200-500ms (à améliorer), > 500ms (mauvais).
- **CLS** : < 0.1 (bon), 0.1-0.25 (à améliorer), > 0.25 (mauvais).
- **TTFB** : < 800ms (bon).
- **Bundle initial JS** : < 200kB compressé (cible), < 500kB acceptable.

### Outils
- **Lighthouse** : `npx unlighthouse` ou DevTools, mode mobile throttled.
- **Vercel Speed Insights** : data réelle (p75 par device).
- **@next/bundle-analyzer** : `ANALYZE=true npm run build`.
- **React DevTools Profiler** : pour re-renders.
- **Chrome Performance tab** : pour long tasks.

### Patterns Next.js performants
- **Image** : `next/image` avec `priority` sur LCP, `sizes` correct, format AVIF/WebP via `formats` dans `next.config`.
- **Font** : `next/font/google` avec `display: 'swap'`.
- **Server Components first** : pas de `'use client'` sauf hooks/handlers.
- **Streaming** : `loading.tsx` + `Suspense` pour streamer le HTML.
- **Parallel routes** : pour éviter waterfall sur dashboards multi-zones.
- **Edge runtime** : utile pour endpoints courts + lecture cache, contre-productif pour Postgres direct (cold start).

### Patterns Supabase performants
- **Select column-by-column** : `.select('id, name')` au lieu de `.select('*')`.
- **Join via select nested** : `.select('id, profile:profiles(name, avatar)')` au lieu de 2 queries.
- **`limit()` + `range()`** : toujours, sur toute liste qui peut croître.
- **Indexes** : sur colonnes filtrées dans `WHERE`/`JOIN` (vérifier via Supabase Dashboard).

## Auto-check final (avant livraison)

- Phase 0 brief formulé (symptôme + métriques actuelles + objectif chiffré) ?
- Phase 1 mesure réelle effectuée (ou commande fournie si non) ?
- Findings priorisés CRITIQUE/HAUT/MOYEN/FAIBLE ?
- Pour chaque finding : impact chiffré (ou non-chiffrable explicite) + effort + fix concret ?
- Aucun chiffre inventé ?
- Plan d'attaque ordonné par coût/gain ?
- Mesures post-correctifs explicitées (re-Lighthouse, re-Speed Insights) ?

Si une seule réponse est non → corriger avant livraison.

## Incidents source

- *(à compléter au fil des audits — chaque incident perf qui révèle un pattern nouveau mérite une entrée).*

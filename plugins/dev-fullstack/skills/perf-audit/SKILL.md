---
name: perf-audit
description: "Audit de performance d'une app web, avec ou sans bundler : Web Vitals (LCP, INP, CLS), taille de bundle, N+1 SQL, re-renders inutiles, fetch waterfalls, lazy loading manquant, cache Next.js/Vercel. Rend un rapport priorisé CRITIQUE/HAUT/MOYEN/FAIBLE, avec impact chiffré quand c'est mesurable. Déclencheurs : c'est lent, audit perf, Lighthouse, TTFB, bundle trop gros, re-render, useMemo, code splitting. Pas pour : un bug isolé (`debug-investigation`), un audit sécurité (sub-agent `securite`), une refonte large (sub-agent `architecte`)."
context: fork
agent: general-purpose
background: false
---

> Version 1.5 — 11.11.2026 (renotation : section du rapport pour les hypothèses non mesurées). Versions antérieures : `CHANGELOG.md` du profil, non déployé.
> **Critère de la mesure**, à vérifier au premier audit complet : contexte principal réduit de
> moitié. S'il ne l'est pas, le fork ne sert à rien ici et se retire.
> **Ce skill ne porte pas de champ `paths`, et c'est nécessaire** : un skill borné par `paths`
> n'atteint jamais un sous-agent, les deux mécanismes s'excluent.

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

Ce skill tourne en contexte isolé (`context: fork`) : il ne dialogue pas avec l'utilisateur. Si une dimension manque (notamment 1 ou 5), **ne pas poser la question en route** : écrire l'hypothèse retenue dans le brief, poursuivre l'audit sur cette base, et rendre **une seule question groupée** dans la section « Questions et mesures rendues à l'orchestrateur » du rapport.

### Phase 1 — Mesure avant tout (HARD GATE)

Lire et collecter, sans demander :

1. `package.json` : taille des deps, scripts (`build`, `analyze` si présent).
2. `next.config.*` : config images, cache, output, experimental flags. **Sur un dépôt sans bundler** (cf. Phase 2), il n'y en a pas : lire à la place le HTML d'entrée (balises `<script>`, ordre de chargement) et le `server.js` (en-têtes de cache).
3. Pour la page cible :
   - Le composant racine et ses imports directs.
   - Server vs Client Components (`'use client'` présence).
   - Stratégie de fetch (Server Component fetch, `use()`, React Query, `useEffect`).
4. **Métriques réelles** :
   - Si Vercel Speed Insights actif : lire les valeurs récentes (p75 LCP, INP, CLS).
   - Sinon, et si la session ne peut pas lancer la mesure elle-même : **ne pas la demander en route** (contexte isolé). La rendre dans le rapport, section « Questions et mesures rendues à l'orchestrateur » : Lighthouse sur la page cible (mobile, throttled), à charge de l'orchestrateur de la faire lancer et de relancer l'audit avec le résultat.
   - Pour bundle : lancer `next build` si l'outillage est là et lire sa sortie ; sinon rendre la commande de la même façon.

**Aucun chiffre inventé.** Si pas de mesure dispo, l'écrire explicitement et donner la commande à lancer. Les findings tirés de la seule lecture du code sont alors rangés dans la section « Hypothèses à confirmer par la mesure » du rapport, hors sévérité.

### Phase 2 — Analyse par axe

Parcourir systématiquement les axes ci-dessous. Pour chaque axe, soit OK soit finding avec sévérité.

**Sur un dépôt sans bundler** — ESM vanilla, React chargé en navigateur, `server.js` Node : le socle
réel de sept dépôts sur huit, mesuré le 25.08.2026 par `librairie-maison` — les axes **4**
(bundle), **7** (Server Components, ISR, Edge) et la part Server Component de l'axe 6 sont
**sans objet** : le dire en une ligne dans le rapport, jamais les noter « OK ». Restent entiers
LCP/INP/CLS, le rendering React, le N+1 et le cache HTTP du serveur maison — et s'y ajoute ce
que le bundler faisait : poids des scripts chargés tels quels, `<script type="module">` en
cascade, Babel standalone qui transpile à chaque chargement.

**Sources à lire pour cette phase** : skill `ux-preuves`, `references/frontend-performance.md`
(INP et ses causes, limites de Lighthouse, bundle, hydratation), sourcé et daté ; en cas d'écart
avec ce qui suit, la fiche fait foi.

**Axe 1 — LCP (Largest Contentful Paint)**
- Élément LCP identifié ? (souvent hero image, premier `<h1>`).
- Image LCP : jamais en `lazy` — `loading="eager"` ou `fetchPriority="high"` sur l'`<Image>` principale (`next/image` est en `lazy` par défaut ; `priority` déprécié depuis Next 16) ? format moderne (WebP/AVIF) ? `sizes` correct ?
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
- Gros modules : `@next/bundle-analyzer` sous Webpack, `next analyze` sous Turbopack (depuis Next 16.1) — `ux-preuves/references/frontend-performance.md` l. 102-107 ; lire la version de Next dans le lockfile avant de choisir.
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
- **Impact chiffré attendu** : « bundle -120kB », « -3 queries par page » quand il se lit dans une mesure (sa source est citée) ; un gain projeté (« gain LCP estimé -800ms ») s'écrit **« estimation »**, avec ce sur quoi elle repose, et ne vaut pas mesure. Si non chiffrable : « impact mesurable post-correctif requis ».
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

## Hypothèses à confirmer par la mesure
- **<ID>** — <axe> — <fichier:ligne> — <ce que la lecture du code suggère> — mesure à lancer : <commande>

## Plan d'attaque recommandé
1. <Action coût/gain max>
2. ...

## Mesures post-correctifs à refaire
- Lighthouse sur <URL>
- Vercel Speed Insights après 24h
- Bundle après `next build`

## Questions et mesures rendues à l'orchestrateur
- Question (une seule, groupée) : <dimension manquante du brief, et l'hypothèse retenue en attendant>
- Mesure à faire lancer : <outil et commande> — <page, device, conditions> — <ce qu'elle confirme ou lève>
```

## Garde-fous (règles dures)

- Aucune optim recommandée sans une mesure préalable qui justifie l'effort.
- Aucun chiffre dans le rapport sans source (Lighthouse, Speed Insights, bundle analyzer) ; seule exception, le gain projeté de la Phase 3, marqué « estimation ».
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

LCP ≤ 2,5 s, INP ≤ 200 ms (500 ms et plus = mauvais) et CLS ≤ 0,1 sont sourcés dans `ux-preuves/references/formulaires-navigation-mobile.md`, § « Réactivité web : viser un INP ≤ 200 ms […] » (web.dev, lu le 09.11.2026 ; mesure de terrain au 75e centile). Les autres bornes ci-dessous (paliers intermédiaires, TTFB, bundle) sont **des conventions de ce skill, non sourcées** : les présenter comme telles.

- **LCP** : < 2.5s (bon), 2.5-4s (à améliorer), > 4s (mauvais).
- **INP** : < 200ms (bon), 200-500ms (à améliorer), > 500ms (mauvais).
- **CLS** : < 0.1 (bon), 0.1-0.25 (à améliorer), > 0.25 (mauvais).
- **TTFB** : < 800ms (bon).
- **Bundle initial JS** : < 200kB compressé (cible), < 500kB acceptable.

### Outils
- **Lighthouse** : DevTools, mode mobile throttled. Mesure de labo : elle ne mesure pas l'INP (`ux-preuves/references/frontend-performance.md` l. 42-47).
- **Vercel Speed Insights** : data réelle (p75 par device).
- **@next/bundle-analyzer** : `ANALYZE=true npm run build` — ne vaut que si le plugin est déjà câblé dans `next.config.*` (le lire en Phase 1).
- **React DevTools Profiler** : pour re-renders.
- **Chrome Performance tab** : pour long tasks.

### Patterns Next.js performants
- **Image** : `next/image` avec `loading="eager"` ou `fetchPriority="high"` sur LCP (pas `priority`, déprécié en Next 16), `sizes` correct, format AVIF/WebP via `formats` dans `next.config`.
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
- Phase 1 mesure réelle effectuée (ou rendue « à faire lancer » dans le rapport, avec sa commande) ?
- Findings priorisés CRITIQUE/HAUT/MOYEN/FAIBLE ?
- Pour chaque finding : impact chiffré (ou non-chiffrable explicite) + effort + fix concret ?
- Aucun chiffre inventé ?
- Plan d'attaque ordonné par coût/gain ?
- Mesures post-correctifs explicitées (re-Lighthouse, re-Speed Insights) ?

Si une seule réponse est non → corriger avant livraison.

## Incidents source

- *(à compléter au fil des audits — chaque incident perf qui révèle un pattern nouveau mérite une entrée).*

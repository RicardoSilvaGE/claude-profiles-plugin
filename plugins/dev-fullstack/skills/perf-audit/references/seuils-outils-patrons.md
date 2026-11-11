# perf-audit — métriques cibles, outils, patrons performants

> Annexe du skill `perf-audit`, sortie du `SKILL.md` le 11.11.2026 (v1.6), texte inchangé. À ouvrir
> en Phase 3 pour situer une mesure sur ses paliers, et au moment d'écrire le fix d'un finding
> (patrons Next.js et Supabase) ou de choisir l'outil d'une mesure.

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

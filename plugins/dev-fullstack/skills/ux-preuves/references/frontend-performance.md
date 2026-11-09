# Fiche `ux-preuves` — Frontend — performance web mesurée

> Fiche du skill `ux-preuves` (dev-fullstack), volet **frontend**, préchargé par `frontend`. Couvre : terrain contre laboratoire, INP et ses causes, `scheduler.yield()`, LoAF, poids du JavaScript (Web Almanac), budgets, hydratation et Server Components, images (LCP en différé, `fetchpriority`), bfcache, Speculation Rules, cache, re-renders et React Compiler.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Versions, statuts Baseline et API **vieillissent
> en mois** : avant d'écrire du code qui en dépend, relire la page officielle (§ « Quand vérifier en
> ligne » du skill). Les sections « Verdict sur les règles du profil », « Mythes » et « Non vérifié »
> sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche du 9 novembre 2026 pour l'agent « frontend engineer senior » (défaut Next.js + React + Tailwind, plus PWA React in-browser sans build et JS vanilla).
> Toutes les pages citées ont été ouvertes avec WebFetch le 09.11.2026. **Réserve de méthode** : WebFetch passe le texte par un modèle intermédiaire. Les extraits sont ceux qu'il a rendus en les donnant pour verbatim ; les plus structurants (Next.js, React, MDN `<img>`) ont été lus en texte brut. Avant de citer un extrait dans un document opposable, rouvrez la page.
> Déjà couvert ailleurs, donc absent ici : seuils LCP/INP/CLS, « Milliseconds make millions », mythe Amazon, skeleton contre spinner, barres de progression, polices, contraste.
> Niveaux de preuve : N1 norme, N2 étude empirique à large échantillon, N3 documentation officielle navigateur/framework/plateforme, N4 avis d'expert ou article d'éditeur.

---

## 1. Mesure

### Prioriser les données terrain (CrUX / RUM) ; le labo (Lighthouse) sert à diagnostiquer, pas à décider
- Niveau de preuve : N3
- Source : Philip Walton, s.d. (date non affichée), « Why lab and field data can be different (and what to do about it) », https://web.dev/articles/lab-and-field-data-differences
- Extrait lu : « field data is what you should use to prioritize your efforts » ; « lab data intentionally limits the number of variables involved » ; « field data … is not just one number, it's a distribution of numbers »
- Portée / limites : l'article explique pourquoi les écarts existent : appareils, réseaux, cache, interactions réelles. Il ne fournit pas d'écart chiffré type entre labo et terrain. La variabilité du score Lighthouse est confirmée par https://developer.chrome.com/docs/lighthouse/performance/performance-scoring : « it might be more useful to think of your site performance as a distribution of scores, rather than a single number ».
- En code : une PR qui revendique un gain de performance ne cite-t-elle qu'un score Lighthouse local ? Exiger soit une donnée terrain (CrUX, RUM `web-vitals`), soit un diagnostic de labo explicitement présenté comme tel.

### CrUX est une moyenne glissante sur 28 jours, limitée aux utilisateurs Chrome éligibles ; son p75 est modélisé
- Niveau de preuve : N3
- Source : Chrome team, s.d., « CrUX API », https://developer.chrome.com/docs/crux/api ; et « CrUX methodology », https://developer.chrome.com/docs/crux/methodology
- Extrait lu : « The data in the Chrome UX Report is a 28-day rolling average of aggregated metrics » ; « The values for each percentile are synthetically derived » ; exclusions : « Chrome on iOS », « Android apps using WebView », « Other Chromium browsers (for example Microsoft Edge) »
- Portée / limites : seules les pages « publicly discoverable » et « sufficiently popular » figurent dans CrUX, et le seuil de popularité n'est pas publié. L'API a environ deux jours de retard. Un correctif livré aujourd'hui n'apparaît donc pleinement dans CrUX qu'après environ quatre semaines. Pour les PWA internes ou les pages derrière authentification, CrUX est muet : il faut un RUM.
- En code : pour une application interne, un outil derrière login ou une audience iOS, rien ne mesure-t-il le terrain ? Ajouter un RUM (`web-vitals`). Après un correctif, ne pas conclure sur CrUX avant 28 jours.

### Mesurer le terrain soi-même avec `web-vitals`, build d'attribution pour le diagnostic
- Niveau de preuve : N3
- Source : GoogleChrome, s.d., dépôt `web-vitals`, https://github.com/GoogleChrome/web-vitals
- Extrait lu : « a tiny (~3K, brotli'd), modular library for measuring all the Web Vitals metrics on real users » ; il « accurately matches how they're measured by Chrome and reported to other Google tools » ; le build d'attribution ajoute des « additional diagnostic information with each metric to help you identify the root cause of poor performance »
- Portée / limites : selon la page lue le 09.11.2026, `onCLS()` est réservé à Chromium. FCP, INP, LCP et TTFB sont indiqués comme pris en charge par Chromium, Firefox et Safari. Cette prise en charge multi-moteurs d'INP et de LCP est récente : à reconfirmer sur la page avant de l'opposer. Les exemples CDN citent `web-vitals@5`, aucun numéro de version exact n'est lu. Les métriques des soft navigations exigent Chromium 151+.
- En code : la page envoie-t-elle LCP, INP et CLS à un endpoint d'analytics avec l'attribution (élément LCP, cible de l'interaction INP) ? Sans attribution, une régression d'INP ne se diagnostique pas.

### Lighthouse ne mesure pas l'INP : le TBT n'en est qu'un indicateur de labo
- Niveau de preuve : N3
- Source : Philip Walton, Barry Pollard, 2019 (mis à jour le 15.10.2025), « Total Blocking Time (TBT) », https://web.dev/articles/tbt ; Chrome team, « Lighthouse performance scoring », https://developer.chrome.com/docs/lighthouse/performance/performance-scoring
- Extrait lu : « TBT may be a reasonable proxy metric for INP for the lab but it's not a substitute for INP in and of itself » ; pondérations Lighthouse 10 : « Largest Contentful Paint | 25% », « Total Blocking Time | 30% », « Cumulative Layout Shift | 25% »
- Portée / limites : la cible TBT est inférieure à 200 ms sur du matériel mobile moyen. La page de scoring ne mentionne pas l'INP. Le TTI n'apparaît plus dans les pondérations de Lighthouse 10, ce qui pèse sur les budgets dérivés du TTI (voir § 2).
- En code : une PR annonce-t-elle « INP corrigé » sur la foi d'un TBT de labo ? Demander une trace DevTools de l'interaction réelle ou une mesure terrain.

### L'INP retient la pire interaction de la page (hors valeurs aberrantes), décomposée en délai d'entrée, traitement et présentation
- Niveau de preuve : N3
- Source : Jeremy Wagner, Barry Pollard, 2022 (mis à jour le 02.09.2025), « Interaction to Next Paint (INP) », https://web.dev/articles/inp
- Extrait lu : « The final INP value is the longest interaction observed, ignoring outliers » ; « we ignore one highest interaction for every 50 interactions » ; la latence va « from the time the user begins the interaction to the moment the browser is next able to paint a frame »
- Portée / limites : seuls le clic, le tap et la frappe clavier comptent. Le défilement et le survol sont exclus. La page indique un report au 75e centile des pages vues. L'article ne date pas l'entrée de l'INP dans les Core Web Vitals.
- En code : quelle est l'interaction la plus lourde de l'écran (filtre de grand tableau, ouverture de modale, saisie dans un champ de recherche) ? C'est elle qu'il faut profiler, pas la moyenne.

### Dans un gestionnaire d'événement, faire le minimum avant le prochain rendu, et surveiller la taille du DOM
- Niveau de preuve : N3
- Source : Jeremy Wagner, Philip Walton, Barry Pollard, 2023 (mis à jour le 02.09.2025), « Optimize Interaction to Next Paint », https://web.dev/articles/optimize-inp
- Extrait lu : « The best general advice in optimizing event callbacks is to do as little work as possible in them » ; « a large DOM can cause rendering updates to be very expensive »
- Portée / limites : cette page ne parle ni d'hydratation ni de `scheduler.yield()`. Elle illustre le découpage avec `setTimeout`. L'hydratation comme cause d'INP vient d'une autre source (§ 3).
- En code : un `onClick` ou `onChange` qui filtre, trie ou sérialise de gros volumes avant de mettre à jour l'UI ? Mettre d'abord à jour le retour visuel, puis céder la main et différer le reste. Une liste de plusieurs milliers de nœuds sans virtualisation ?

### Découper les tâches longues (> 50 ms) en cédant la main avec `scheduler.yield()`, avec repli obligatoire ; ne plus utiliser `isInputPending()`
- Niveau de preuve : N3
- Source : Jeremy Wagner, Brendan Kenny, 2022 (mis à jour le 19.12.2024), « Optimize long tasks », https://web.dev/articles/optimize-long-tasks ; statut : MDN, https://developer.mozilla.org/en-US/docs/Web/API/Scheduler/yield, et données BCD, https://raw.githubusercontent.com/mdn/browser-compat-data/main/api/Scheduler.json
- Extrait lu : « Any task that takes longer than 50 milliseconds is a long task » ; « `scheduler.yield()` is not yet supported in all browsers, so a fallback is needed » ; sur `isInputPending()` : « We **no longer recommend using this API** » ; bandeau MDN : « This feature is not Baseline because it does not work in some of the most widely-used browsers »
- Portée / limites : selon BCD, Chrome le prend en charge depuis la version 129 et Firefox depuis la 142, Safari pas du tout (`version_added: false`). La fonction est donc **hors Baseline** au 09.11.2026. Le repli recommandé est `setTimeout` enveloppé dans une Promise.
- En code : `scheduler.yield()` est-il appelé sans détection (`'scheduler' in globalThis && 'yield' in scheduler`) ? Sur Safari, cela lève une `TypeError`. Une boucle de traitement synchrone de plusieurs centaines de millisecondes ne cède-t-elle jamais la main ?

### Diagnostiquer l'INP avec la Long Animation Frames API (LoAF), réservée à Chromium
- Niveau de preuve : N3
- Source : Barry Pollard, Noam Rosenthal, s.d., « Long Animation Frames API », https://developer.chrome.com/docs/web-platform/long-animation-frames ; statut : https://raw.githubusercontent.com/web-platform-dx/web-features/main/features/long-animation-frames.yml.dist
- Extrait lu : « A long animation frame is when a rendering update is delayed beyond 50 milliseconds » ; elle a « shipped from Chrome 123 » ; « most problematic INPs should include LoAF data to help you diagnose those interactions »
- Portée / limites : web-features indique `baseline: false` (Chrome, Edge et Chrome Android 123). C'est un outil de diagnostic, pas une base de fonctionnalité. Il remplace l'attribution trop pauvre de la Long Tasks API.
- En code : le RUM remonte-t-il les scripts responsables (attribution LoAF, via le build d'attribution de `web-vitals`) pour les INP mauvais ? Le code doit tolérer l'absence de l'API hors Chromium.

---

## 2. Poids du JavaScript

### Le web réel embarque environ 560 à 650 Ko de JS médian sur mobile, dont près de la moitié reste inutilisée au chargement : mesurer la couverture avant d'ajouter
- Niveau de preuve : N2 (crawl HTTP Archive, des millions de pages)
- Source : Abdul Haddi Amjad, Nishu Goel, 2024, « JavaScript » (Web Almanac 2024, dernière édition qui contient un chapitre JavaScript ; l'édition 2025 n'en a pas), https://almanac.httparchive.org/en/2024/javascript ; complément : Richard Barret, Jamie Indigo, 2026, « Page Weight » (Web Almanac 2025), https://almanac.httparchive.org/en/2025/page-weight
- Extrait lu : 2024 : « median JavaScript payload rising by 14%, reaching 558 kilobytes on mobile and 613 kilobytes on desktop » ; « approximately half the bytes downloaded being unused during page load (206 kilobytes—or 44% of bytes delivered—at the median on mobile) » ; 2025 : « The median desktop page uses 708 KB of JavaScript », « slightly higher than mobile's 646 KB »
- Portée / limites : il s'agit d'octets transférés (compressés) sur le crawl HTTP Archive. Le chapitre 2025 ne précise pas la date du crawl ; ses graphiques de tendance vont jusqu'à juillet 2025. Les deux éditions ne se comparent pas strictement : chapitres et méthodes diffèrent. Ces chiffres décrivent l'état du web, ils ne fixent aucune cible.
- En code : le rapport Coverage de DevTools a-t-il été passé sur la route modifiée ? Le code chargé mais non exécuté au premier rendu peut-il partir en `import()` dynamique ?

### Découper les bundles et en surveiller l'exécution sur mobile modeste : le coût dominant est le téléchargement et le CPU
- Niveau de preuve : N3 (blog officiel de V8)
- Source : Addy Osmani, Mathias Bynens, 25.06.2019, « The cost of JavaScript in 2019 », https://v8.dev/blog/cost-of-javascript-2019
- Extrait lu : « In 2019, the dominant costs of processing scripts are now download and CPU execution time » ; « it takes 3–4× longer for a median phone (Moto G4) to execute Reddit's JavaScript » et « over 6× as long on a low-end device (the <$100 Alcatel 1X) » ; « if a bundle exceeds ~50–100 kB, split it up into separate smaller bundles »
- Portée / limites : l'article date de 2019 et ses appareils de référence (Moto G4, Alcatel 1X) sont anciens. Aucune édition plus récente n'a été trouvée. Le rapport de 3 à 6 fois entre appareils reste un ordre de grandeur, pas une constante actuelle. Le seuil de 50 à 100 kB porte sur la taille d'un bundle unique, pas sur un budget par page.
- En code : un chunk unique de plusieurs centaines de Ko ? Les tests de performance tournent-ils avec le ralentissement CPU de DevTools (4x ou 6x), et pas seulement sur un poste de développeur ?

### Un budget de 200 Ko de JS existe chez web.dev, mais comme exemple lié au TTI sur « Slow 4G / Moto G4 », pas comme norme
- Niveau de preuve : N3 (exemple pédagogique)
- Source : Milica Mihajlija, s.d., « Your first performance budget », https://web.dev/articles/your-first-performance-budget ; et « Performance budgets 101 », https://web.dev/articles/performance-budgets-101
- Extrait lu : « Here are a few examples based on TTI budgets: » puis la ligne « | Slow 4G | Moto G4 | 200 | 50 | 35 | 30 | 30 | ~345 KB | 3s | » (colonne JS = 200) ; « The recommended sizes are for the critical-path resources » ; défaut général : « Under 170 KB of critical-path resources (compressed/minified) »
- Portée / limites : il s'agit de ressources du **chemin critique**, « compressed/minified », sans précision gzip ou brotli. Les budgets sont dérivés du **TTI**, métrique absente des pondérations de Lighthouse 10. L'article présente ces valeurs comme des points de départ à ajuster. La médiane réelle (558 à 646 Ko mobile, ci-dessus) est trois fois plus haute.
- En code : le budget est-il vérifié automatiquement (taille de First Load JS par route dans le build, analyseur de bundle) plutôt que déclaré dans un document ?

### Analyser le bundle par route et déplacer côté serveur les bibliothèques qui ne font que transformer des données en HTML
- Niveau de preuve : N3
- Source : Vercel / Next.js, mis à jour le 15.10.2026, « Optimizing package bundling », https://nextjs.org/docs/app/guides/package-bundling
- Extrait lu : « Smaller bundles load faster, reduce JavaScript execution time, improve Core Web Vitals » ; « A common cause of large client bundles is doing expensive rendering work in Client Components. This often happens with libraries that exist only to transform data into UI, such as syntax highlighting, chart rendering, or markdown parsing. »
- Portée / limites : `next analyze` (Turbopack) existe depuis la v16.1 et `next analyze export` depuis la v16.4. `@next/bundle-analyzer` sert sous Webpack. `optimizePackageImports` est encore sous `experimental`. La doc ne fixe aucun seuil chiffré par dépendance.
- En code : une nouvelle dépendance (markdown, coloration syntaxique, dates, graphiques) est-elle importée dans un fichier `'use client'` alors que son résultat est statique ? Le diff `next analyze --output` avant/après est-il joint à la PR ?

### PWA React « in-browser » : `@babel/standalone` n'est pas fait pour la production
- Niveau de preuve : N3
- Source : Babel, s.d., « @babel/standalone », https://babeljs.io/docs/babel-standalone
- Extrait lu : « If you're using Babel in production, you should normally not use `@babel/standalone` » ; usages prévus : « It provides an easy, convenient way to prototype with Babel »
- Portée / limites : la page ne chiffre pas le coût de la compilation dans le navigateur (non vérifié). Elle renvoie à un build Node pour la production. Pour une PWA sans build, l'alternative est d'écrire du JS déjà exécutable (`React.createElement`, ou des template literals type `htm`), à vérifier à part.
- En code : une PWA livrée aux utilisateurs charge-t-elle `babel.min.js` et transpile-t-elle le JSX à chaque démarrage ? Le signaler comme dette de performance (téléchargement et compilation sur l'appareil client).

---

## 3. Rendu et hydratation

### L'hydratation complète pèse sur le TBT et l'INP : préférer le rendu serveur ou statique avec peu de JS à la réhydratation totale
- Niveau de preuve : N3 (web.dev, sans mesure publiée)
- Source : Addy Osmani, Jason Miller, 2019 (mis à jour le 05.01.2026), « Rendering on the Web », https://web.dev/articles/rendering-on-the-web
- Extrait lu : « it can have a significant negative impact on TBT and INP, even if it improves FCP » ; « can't actually respond to input until the client-side scripts for components are executed » ; « It's fine to mostly ship HTML with minimal JavaScript to get an experience interactive » ; « Partial rehydration has proven difficult to implement »
- Portée / limites : l'article est qualitatif et ne publie **aucune mesure chiffrée**. Il recommande de mesurer d'abord les goulots.
- En code : une page majoritairement statique (contenu, marketing, documentation) est-elle entièrement hydratée ? Quelle part de l'arbre a réellement besoin d'interactivité ?

### Server Components par défaut, `'use client'` posé sur les feuilles interactives : tout ce qu'importe un fichier client part dans le bundle
- Niveau de preuve : N3
- Source : Vercel / Next.js, mis à jour le 05.10.2026, « Server and Client Components », https://nextjs.org/docs/app/getting-started/server-and-client-components
- Extrait lu : « By default, layouts and pages are Server Components » ; Server Components pour « Reduce the amount of JavaScript sent to the browser » ; « Once a file is marked with "use client", **all of its imports and the components it directly renders are included in the client bundle** » ; « add 'use client' at the top of the files that define your interactive components instead of marking large parts of your UI as Client Components »
- Portée / limites : c'est la documentation du framework, qui ne publie pas de mesure. Les Server Components passés en `children` à un composant client ne sont pas inclus dans son graphe. Les providers de contexte se placent « as deep as possible in the tree ». Hors sujet performance mais lié : react.dev a publié deux avis de sécurité sur les RSC (03.12.2025, RCE corrigée en 19.0.1, 19.1.2 et 19.2.1 ; puis 11.12.2025). Seul l'index du blog a été lu.
- En code : `'use client'` est-il posé sur un layout ou une page entière pour un seul bouton ? Un provider englobe-t-il `<html>` au lieu de `{children}` ? Un module serveur est-il protégé par `import 'server-only'` ?

### Le gain des Server Components sur le JS envoyé n'est mesuré que par des éditeurs, en labo : ne pas promettre un chiffre
- Niveau de preuve : N4 (articles d'éditeurs)
- Source : Christian Mathiesen (Frigade), 20.09.2023, « Bundle size reduction with RSC », https://frigade.com/blog/bundle-size-reduction-with-rsc-and-frigade ; Lee Robinson (Vercel), 09.08.2022 (mis à jour le 18.01.2024), « Improving Interaction to Next Paint with React 18 and Suspense », https://vercel.com/blog/improving-interaction-to-next-paint-with-react-18-and-suspense
- Extrait lu : Frigade : « cut bundle size from 232kb to 89kb », « total blocking time from 110ms to 1ms » ; Vercel : TBT de nextjs.org « from 430ms to 80ms » grâce à l'hydratation sélective avec Suspense, puis « Interaction to Next Paint: 48ms (Good) » (Vercel Analytics)
- Portée / limites : il s'agit de sites uniques, mesurés par l'éditeur du framework ou d'un produit associé, avec des outils de labo (Pingdom, PageSpeed Insights) pour Frigade. **Aucune étude indépendante isolant l'effet des RSC sur l'INP terrain n'a été trouvée.**
- En code : une PR justifie-t-elle une migration RSC par « -60 % de JS » ? Exiger la mesure avant/après sur le projet (`next analyze`, RUM).

### Étude de cas terrain : l'INP de The Economic Times est passé d'environ 1 000 ms à 257 ms, par un ensemble de mesures et non par une technique isolée
- Niveau de preuve : N3 (étude de cas publiée par web.dev, données CrUX, un seul site)
- Source : Barun Kumar, Daya Ram Yadav, Saurabh Rajpal, s.d. (données de juillet à octobre 2022), « How The Economic Times passed Core Web Vitals thresholds and achieved an overall 43% better bounce rate », https://web.dev/case-studies/economic-times-inp
- Extrait lu : « Our INP was close to 1,000 milliseconds at the origin level when we started » ; « the INP for our origin was 257 milliseconds after our optimization efforts »
- Portée / limites : les leviers cumulés sont nombreux : `requestIdleCallback` pour le non-critique, chargement paresseux des bibliothèques tierces, suppression du JS et du CSS inutilisés, DOM réduit d'environ 1 200 nœuds (menu rendu au clic), migration Next.js, Partytown. L'hydratation n'est pas mentionnée. Le gain ne s'attribue à aucun levier seul.
- En code : avant de chercher une technique miracle, inventorier les nœuds DOM rendus mais invisibles (menus, onglets) et les scripts tiers chargés tôt.

### Éviter les cascades de requêtes : lancer en parallèle (`Promise.all`), précharger, et isoler le lent derrière `<Suspense>`
- Niveau de preuve : N3
- Source : Vercel / Next.js, mis à jour le 01.09.2026, « Fetching Data », https://nextjs.org/docs/app/getting-started/fetching-data
- Extrait lu : « within any component, multiple async/await requests can still be sequential if placed after the other » ; « Start multiple requests by calling fetch, then await them with Promise.all » ; « Preloading starts the request earlier so it can run in parallel with that work and avoid a request waterfall » ; « If you have any slow data requests, the whole route will be blocked from rendering until all the data is fetched »
- Portée / limites : `Promise.all` échoue en entier si une requête échoue. Pour tolérer les échecs partiels, la doc propose `Promise.allSettled`. Un `loading.js` ne couvre pas un layout qui lit des données dynamiques.
- En code : y a-t-il deux `await` indépendants qui se suivent dans un même Server Component ? Un `await` de haut niveau dans un layout bloque-t-il toute la route ?

### Avec Next.js 16, le Partial Prerendering est le comportement par défaut de Cache Components : la coquille statique part tout de suite, le dynamique est diffusé derrière `<Suspense>`
- Niveau de preuve : N3 (doc framework, aucune mesure publiée lue)
- Source : Vercel / Next.js, mis à jour le 06.10.2026, « Caching » (page servie à l'URL ouverte https://nextjs.org/docs/app/getting-started/cache-components, URL canonique https://nextjs.org/docs/app/getting-started/caching) ; React Team, 01.10.2025, « React 19.2 », https://react.dev/blog/2025/10/01/react-19-2
- Extrait lu : Next : « This rendering approach is called **Partial Prerendering (PPR)**, the default behavior with Cache Components » ; « Cache Components shipped in 16.0.0 » ; « New App Router apps created with the recommended create-next-app defaults already have Cache Components and Partial Prefetching enabled » ; React : « allows you to pre-render the static parts of your app and serve it from a CDN, and then resume rendering the shell to fill it in with dynamic content later »
- Portée / limites : il faut `cacheComponents: true` dans une application existante. La doc annonce l'activation partout à la prochaine majeure. Aucun gain chiffré publié n'a été lu.
- En code : l'accès à `cookies()`, `headers()` ou `searchParams` est-il placé le plus bas possible et enveloppé dans `<Suspense>` pour préserver la coquille statique ?

### Hydration mismatch : causes connues et correctifs documentés ; `suppressHydrationWarning` reste une échappatoire d'un niveau
- Niveau de preuve : N3
- Source : Vercel / Next.js, s.d., « Text content does not match server-rendered HTML », https://nextjs.org/docs/messages/react-hydration-error
- Extrait lu : causes : « Incorrect nesting of HTML tags », « Using checks like `typeof window !== 'undefined'` in your rendering logic », « Using time-dependent APIs such as the `Date()` constructor », « Browser extensions modifying the HTML » ; « This only works one level deep, and is intended to be an escape hatch. Don't overuse it. »
- Portée / limites : il y a trois correctifs : `useEffect` pour le contenu client seul, `dynamic(..., { ssr: false })` ou `suppressHydrationWarning`. Sur iOS, la détection automatique des numéros et adresses cause aussi des écarts (meta `format-detection`). Le coût de performance du mismatch n'est pas documenté sur cette page.
- En code : `Date.now()`, `Math.random()`, `localStorage` ou `window` sont-ils lus pendant le rendu ? Un `<div>` dans un `<p>`, ou un `<a>` dans un `<a>` ?

---

## 4. Images et médias

### Ne jamais lazy-loader l'image LCP ni les images au-dessus de la ligne de flottaison
- Niveau de preuve : N2 (tests A/B sur WordPress et corrélations HTTP Archive/CrUX, publiés par web.dev) et N2 pour la prévalence (Web Almanac 2025)
- Source : Felix Arntz, Rick Viscomi, s.d. (données jusqu'en juin 2021), « The performance effects of too much lazy loading », https://web.dev/articles/lcp-lazy-loading ; Himanshu Jariyal et al., 2025, « Performance » (Web Almanac 2025), https://almanac.httparchive.org/en/2025/performance
- Extrait lu : « When lazy loading was disabled on archive pages, LCP improved by a significant margin » (13 % desktop, 15 % mobile) ; « Lazy loading only the images below the fold results in a complete reversal of the LCP regression » ; Almanac 2025 : « Overall, about 16%-17% of pages lazy-load their LCP image, a figure that has held steady since 2024. »
- Portée / limites : les corrélations HTTP Archive ne valent pas causalité, et l'article le dit. La preuve causale vient des tests A/B. Dans Next.js, `next/image` est **lazy par défaut** (« Defaults to lazy »), donc l'image LCP doit être marquée explicitement (entrée suivante).
- En code : l'image héroïque est-elle en `loading="lazy"`, ou un `<Image>` Next sans `loading="eager"` / `fetchPriority="high"` ? Un carrousel lazy-loade-t-il sa première diapositive ?

### Marquer l'image LCP `fetchpriority="high"` (Next 16 : `preload` remplace `priority`, déprécié)
- Niveau de preuve : N3
- Source : Addy Osmani, Leena Sohoni, Patrick Meenan, Barry Pollard, s.d., « Optimizing resource loading with the Fetch Priority API », https://web.dev/articles/fetch-priority ; statut : https://raw.githubusercontent.com/web-platform-dx/web-features/main/features/fetch-priority.yml.dist ; Next.js, mis à jour le 06.11.2026, « Image Component », https://nextjs.org/docs/app/api-reference/components/image
- Extrait lu : « Fetch Priority improving Largest Contentful Paint from 2.6 s to 1.9 s in a test of Google Flights » ; « The fetchpriority attribute is a hint, not a directive » ; Next : « Starting with Next.js 16, the priority property has been deprecated in favor of the preload property » ; « In most cases, you should use loading="eager" or fetchPriority="high" instead of preload »
- Portée / limites : Baseline **nouvellement disponible** depuis le 29.10.2024 (Chrome et Edge 103, Firefox 132, Safari 17.2). Le gain Google Flights est un test unique publié par Google. Selon l'Almanac 2025, l'attribut n'est présent que sur 17 % des pages mobiles qui ont une image LCP. La doc Next déconseille `preload` quand plusieurs images peuvent être LCP selon le viewport.
- En code : `priority` (déprécié en Next 16) est-il encore utilisé ? `fetchPriority="high"` est-il posé sur plusieurs images à la fois, ce qui annule le signal ?

### Toute image et toute vidéo portent `width` et `height` (ou `aspect-ratio`) pour réserver l'espace
- Niveau de preuve : N3 (et N2 pour la prévalence)
- Source : Addy Osmani, Barry Pollard, 2020 (mis à jour le 07.02.2025), « Optimize Cumulative Layout Shift », https://web.dev/articles/optimize-cls ; MDN, « `<img>` », https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/img ; Almanac 2025 Performance (URL ci-dessus)
- Extrait lu : « Always include width and height size attributes on your images and video elements » ; « Alternatively, reserve the required space with CSS aspect-ratio or similar » ; MDN : « they are especially important for lazy-loaded ones » ; Almanac : « On mobile, 62% of pages fail to set dimensions on at least one image »
- Portée / limites : les publicités, embeds et contenus injectés en haut de page sont aussi des causes majeures de CLS (« Ads are one of the largest contributors to layout shifts on the web »). Animer `top` ou `left` décale la mise en page, `transform` non.
- En code : y a-t-il un `<img>` sans dimensions, un `<Image fill>` dont le parent n'a pas de taille, un bandeau ou un toast inséré au-dessus du contenu existant, une animation sur `top`/`left`/`height` ?

### Servir des images responsives : `srcset` en descripteurs `w` plus un `sizes` exact, sinon le navigateur suppose `100vw`
- Niveau de preuve : N3
- Source : MDN, « `<img>`: The Image Embed element », https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/img
- Extrait lu : « If the sizes attribute is not provided, it has a default value of 100vw (the viewport width). » ; `sizes="auto"` : « This is only valid when combined with loading="lazy" »
- Portée / limites : il ne faut pas mélanger descripteurs `w` et `x`. Le support de `sizes="auto"` n'est pas vérifié navigateur par navigateur : MDN prévoit des tailles de repli après `auto`. `next/image` génère `srcset` mais dépend du `sizes` fourni.
- En code : une image affichée sur un tiers de la largeur en desktop sans `sizes` téléchargera la variante plein écran. Le `sizes` reflète-t-il la grille Tailwind réelle ?

### Formats : AVIF est Baseline largement disponible depuis le 25.07.2026 et WebP depuis 2023, mais AVIF ne s'affiche pas progressivement ; `next/image` sert WebP seul par défaut
- Niveau de preuve : N3
- Source : MDN, « Image file type and format guide », https://developer.mozilla.org/en-US/docs/Web/Media/Guides/Formats/Image_types ; web-features, https://raw.githubusercontent.com/web-platform-dx/web-features/main/features/avif.yml.dist et https://raw.githubusercontent.com/web-platform-dx/web-features/main/features/webp.yml.dist ; Next.js « Image Component » (URL ci-dessus)
- Extrait lu : MDN : « For raster images, prefer WebP or AVIF, which generally provide better compression than PNG, JPEG, and GIF » ; « AVIF does not support progressive rendering, so files must be fully downloaded before they can be displayed » ; Next : `formats: ['image/webp']` commenté « // Default »
- Portée / limites : AVIF est Baseline basse depuis le 25.01.2024 et haute depuis le 25.07.2026 (Chrome 85, Edge 121, Firefox 113, Safari 16.4). WebP est Baseline haute depuis le 16.03.2023. Le texte MDN conseille encore un repli `<picture>`, une prudence antérieure au statut Baseline haute. Le chiffre de compression AVIF contre WebP cité par MDN vient d'un blog tiers. Dans Next, activer `['image/avif', 'image/webp']` double le stockage du cache.
- En code : y a-t-il des JPEG ou PNG lourds servis tels quels hors `next/image` ? Un AVIF sur une très grande image héroïque, où le rendu progressif d'un JPEG ou d'un WebP aurait mieux servi la perception ?

### `loading="lazy"` natif est Baseline largement disponible depuis le 19.06.2026 : plus besoin d'IntersectionObserver maison pour les images
- Niveau de preuve : N3
- Source : web-features, https://raw.githubusercontent.com/web-platform-dx/web-features/main/features/loading-lazy.yml.dist ; MDN `<img>` (URL ci-dessus)
- Extrait lu : MDN : « Lazy loading avoids the network and storage bandwidth required to handle the image until it's reasonably certain that it will be needed » ; « Loading is only deferred when JavaScript is enabled »
- Portée / limites : Baseline basse depuis le 19.12.2023 et haute depuis le 19.06.2026 (Chrome 77, Firefox 121, Safari 16.4). Les images lazy présentes dans le viewport ne retardent pas l'événement `load`. Le seuil de distance dépend du navigateur.
- En code : une bibliothèque de lazy-loading en JS (ou `data-src` avec un observer) en JS vanilla ou dans une PWA ? La remplacer par l'attribut natif, sauf besoin spécifique.

---

## 5. Navigation

### Rendre les pages éligibles au bfcache : aucun gestionnaire `unload` (utiliser `pagehide` / `visibilitychange`), vérifier `no-store` et les connexions ouvertes
- Niveau de preuve : N3 (et N2 pour la prévalence)
- Source : Philip Walton, Barry Pollard, 2023 (mis à jour le 16.10.2026), « Back/forward cache », https://web.dev/articles/bfcache ; Demián Renzulli, Barry Pollard, 2023 (mis à jour le 16.10.2026), « Deprecating the unload event », https://developer.chrome.com/docs/web-platform/deprecating-unload ; Almanac 2025 Performance
- Extrait lu : « Chrome usage data shows that 1 in 10 navigations on desktop and 1 in 5 on mobile are either back or forward » ; « The most important way to optimize for bfcache in all browsers is to never use the unload event » ; « Instead of using the unload event, use the pagehide event » ; « any pages using Cache-Control: no-store may not be eligible for bfcache »
- Portée / limites : selon la page Chrome, la dépréciation d'`unload` (les gestionnaires ne se déclenchent plus sauf opt-in) a été étendue à toutes les origines et s'est achevée avec Chrome 155 (06.10.2026). Firefox et Safari ne sont pas concernés par ce calendrier. Les connexions IndexedDB ouvertes, les fetch en cours et les WebSocket ou WebRTC peuvent aussi exclure la page, selon le navigateur. Selon l'Almanac 2025, `Cache-Control: no-store` est présent sur 23 % des sites. Test : panneau DevTools « Back-forward Cache » ; diagnostic terrain : NotRestoredReasons API. Le gain de bfcache sur les métriques n'est pas chiffré dans la page lue.
- En code : y a-t-il un `addEventListener('unload', …)` ou un `beforeunload` posé en permanence ? Un `no-store` sur des pages HTML non sensibles ? Une PWA qui garde une connexion IndexedDB ou WebSocket ouverte sans la fermer sur `pagehide` ?

### Speculation Rules (prérendu, préchargement) : amélioration progressive réservée à Chromium, à doser selon l'empressement
- Niveau de preuve : N3
- Source : Barry Pollard, 2022 (mis à jour le 29.10.2026), « Prerender pages in Chrome for instant page navigations », https://developer.chrome.com/docs/web-platform/prerender-pages ; statut : https://raw.githubusercontent.com/web-platform-dx/web-features/main/features/speculation-rules.yml.dist ; adoption : Almanac 2025 Performance
- Extrait lu : « a prerender behaves as if the page has been opened in an invisible background tab » ; « Over-speculation has a clear cost to users for bandwidth, memory, and CPU costs » ; Almanac : « Speculation Rules usage on the top 1,000 sites is quite low, only 3% on desktop and 5% on mobile. »
- Portée / limites : web-features indique `baseline: false` (Chrome, Edge et Chrome Android 109). Safari ne l'expose que derrière un flag, Firefox de façon partielle (Technology Preview pour `eagerness`). Chrome plafonne les spéculations : par exemple 2 prérendus en FIFO pour `moderate` sur desktop. Il s'abstient en mode Save-Data ou en économie d'énergie. Aucune mesure chiffrée n'est publiée, seulement des affirmations qualitatives. Dans l'Almanac, les chiffres d'adoption hors top 1 000 se contredisent entre texte et figure : ils ne sont pas retenus.
- En code : un prérendu `immediate` ou `eager` vise-t-il des pages à effets de bord (déconnexion, panier, analytics comptant une vue) ? Préférer `moderate` ou `conservative`, et ne pas compter sur la spéculation hors Chromium.

### View Transitions entre documents : hors Baseline (pas de Firefox), à traiter en amélioration progressive, sans `blocking=render` par défaut
- Niveau de preuve : N3
- Source : Bramus, s.d., « Cross-document view transitions for multi-page applications », https://developer.chrome.com/docs/web-platform/view-transitions/cross-document ; statut : https://raw.githubusercontent.com/web-platform-dx/web-features/main/features/cross-document-view-transitions.yml.dist
- Extrait lu : « Cross-document view transitions are limited to **same-origin navigations** only » ; « Cross-document view transitions are supported in Chrome from Chrome 126 » ; sur `blocking=render` : « incremental rendering is a fundamental aspect of the Web, so be cautious »
- Portée / limites : `baseline: false` (Chrome et Edge 126, Safari 18.2, Firefox absent). L'activation se fait par `@view-transition { navigation: auto; }` sur les deux pages. L'article conseille de mesurer l'effet sur les Core Web Vitals avant tout blocage du rendu. React 19.3 (09.09.2026) ajoute des View Transitions côté React selon l'index du blog react.dev, non lu en détail.
- En code : un `<link rel="expect" blocking="render">` ajouté pour une transition décorative retarde-t-il le premier rendu de toutes les navigations ?

---

## 6. Réseau et cache

### Ressources versionnées par hash : `Cache-Control: max-age=31536000, immutable`
- Niveau de preuve : N3 (MDN, qui décrit la directive normalisée)
- Source : MDN, « Cache-Control », https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Cache-Control
- Extrait lu : « The immutable response directive indicates that the response will not be updated while it's fresh » ; « You can add a long max-age value and immutable because the content will never change » ; exemple : « Cache-Control: max-age=31536000, immutable »
- Portée / limites : ne vaut **que** pour des URL dont le contenu ne change jamais (cache busting). Next.js le fait pour `/_next/static`, non vérifié ici. Le HTML lui-même ne doit pas être `immutable`.
- En code : une PWA ou un `server.js` maison sert-il `app.js` sous un nom fixe avec un `max-age` long (les utilisateurs restent bloqués sur une version), ou des assets hachés sans `immutable` (revalidations inutiles) ?

### Préconnecter seulement aux quelques origines tierces critiques, avec `crossorigin` quand la ressource est CORS (polices)
- Niveau de preuve : N3
- Source : Jeremy Wagner, Milica Mihajlija, s.d., « Establish network connections early to improve perceived page speed », https://web.dev/articles/preconnect-and-dns-prefetch
- Extrait lu : « You can speed up the load time by 100–500 ms by establishing early connections to important third-party origins » ; « Only preconnect to critical domains you will use soon » ; « the browser closes any connection that isn't used within 10 seconds » ; « If you omit the crossorigin attribute, the browser only performs the DNS lookup »
- Portée / limites : la fourchette de 100 à 500 ms est un ordre de grandeur, sans protocole de mesure publié. Préconnecter en excès « can delay other important resources ».
- En code : une liste de `<link rel="preconnect">` vers des origines qui ne servent rien au premier écran ? Une préconnexion vers une origine de polices sans `crossorigin` ?

### HTTP/3 s'obtient en pratique par le CDN : l'activer côté hébergeur, sans en attendre un gain uniforme
- Niveau de preuve : N2 (crawl HTTP Archive)
- Source : Joe Viggiano, Alex Moening, Nick McCord, 2025, « CDN » (Web Almanac 2025), https://almanac.httparchive.org/en/2025/cdn
- Extrait lu : « CDNs show 29-45% HTTP/3 adoption versus <7% for origins » ; « The TTFB performance for HTTP/3 compared to previous HTTP protocol versions varies by CDN provider » ; les auteurs avertissent que leurs données « should not be extrapolated to represent general internet usage patterns »
- Portée / limites : le navigateur découvre HTTP/3 via `Alt-Svc` après une première connexion HTTP/1.1 ou HTTP/2. Le gain n'est pas garanti, et les auteurs recommandent des tests contrôlés propres au site. C'est un réglage d'infrastructure, rarement une affaire de code frontend.
- En code : pour un `server.js` Node auto-hébergé, ne pas promettre HTTP/3. Pour Vercel ou un CDN, vérifier l'onglet Protocol de DevTools plutôt que supposer.

### Service worker : son démarrage retarde les navigations ; activer la navigation preload si le SW intercepte `fetch` pour les navigations
- Niveau de preuve : N3
- Source : Jake Archibald, s.d., « Speed up service worker with navigation preloads », https://web.dev/blog/navigation-preload
- Extrait lu : « It's usually around 50ms. On mobile it's more like 250ms » ; « In extreme cases (slow devices, CPU in distress) it can be over 500ms » ; la navigation preload permet de « start the network request while the service worker is booting up »
- Portée / limites : la fonction est disponible dans les trois moteurs (Chrome 59, Edge 18, Firefox 99, Safari 15.4). Les durées de démarrage citées sont des ordres de grandeur de l'auteur, pas une étude. Elle ne sert que si le SW passe par le réseau pour les navigations. Une stratégie « cache d'abord » de coquille d'application n'en a pas besoin.
- En code : une PWA dont le SW fait `respondWith(fetch(event.request))` sur les navigations sans `registration.navigationPreload.enable()` et sans lire `event.preloadResponse` ?

---

## 7. Re-renders React

### Ne pas mémoïser partout : profiler d'abord, appliquer les principes structurels (children, état local, rendu pur, moins d'Effects), puis `memo` / `useMemo` ciblés
- Niveau de preuve : N3
- Source : React, s.d., « memo », https://react.dev/reference/react/memo ; « useMemo », https://react.dev/reference/react/useMemo
- Extrait lu : « If there is no perceptible lag when your component re-renders, memo is unnecessary » ; « a single value that's "always new" is enough to break memoization for an entire component » ; « Most performance problems in React apps are caused by chains of updates originating from Effects that cause your components to render over and over » ; `useMemo` : « If the overall logged time adds up to a significant amount (say, 1ms or more), it might make sense to memoize that calculation » ; « build your app for production and test it on a device like your users have »
- Portée / limites : il n'y a pas de coût « significatif » à mémoïser, seulement une perte de lisibilité selon la doc. Mesurer en mode développement fausse les temps (StrictMode rend deux fois). React 19.2 ajoute des pistes de performance React dans le panneau Performance de Chrome DevTools (« React Performance Tracks »).
- En code : y a-t-il un `useEffect` qui fait `setState` d'une valeur dérivable des props ? Un état de survol ou de formulaire stocké dans un store global ? Un `memo` dont une prop est un objet ou une fonction littérale recréée à chaque rendu ?

### React Compiler 1.0 est stable depuis le 07.10.2025 et mémoïse automatiquement ; dans Next.js il s'active à la demande ; garder la mémoïsation manuelle existante
- Niveau de preuve : N3 pour le statut, N4 pour les gains (mesure de l'éditeur sur son propre produit)
- Source : Lauren Tan, Joe Savona, Mofei Zhang, 07.10.2025, « React Compiler v1.0 », https://react.dev/blog/2025/10/07/react-compiler-1
- Extrait lu : « We are releasing the compiler's first stable release today » ; « React Compiler is compatible with React 17 and up » ; « We've seen initial loads and cross-page navigations improve by up to 12%, while certain interactions are more than 2.5× faster » ; « For existing code, we recommend either leaving existing memoization in place (removing it can change compilation output) or carefully testing before removing the memoization »
- Portée / limites : le gain cité concerne le Meta Quest Store, mesuré par Meta, et « your mileage may vary ». Le compilateur est activé par défaut dans Expo SDK 54+. Pour Vite et Next.js, il passe par des gabarits `create-vite` / `create-next-app` ou l'option `reactCompiler`. `useMemo` et `useCallback` restent des échappatoires, notamment pour les dépendances d'effets.
- En code : un projet qui active le compilateur supprime-t-il en masse les `useMemo` et `useCallback` sans tests ? La doc conseille de les laisser. Un nouveau composant ajoute-t-il de la mémoïsation manuelle par réflexe alors que le compilateur est actif ?

---

## Verdict sur les règles du profil

| Règle du profil | Verdict | Fondement |
|---|---|---|
| **LCP < 2.5s, INP < 200ms, CLS < 0.1** | **Soutenue**, avec une précision manquante | Seuils couverts ailleurs (web.dev). La règle doit préciser **« au 75e centile, données terrain »** : Lighthouse ne mesure pas l'INP et le TBT n'en est qu'un indicateur de labo (web.dev/articles/tbt). Pour une PWA interne, CrUX est muet : il faut un RUM `web-vitals`. |
| **JS first-load par page < 200KB gzippé** | **Convention adossée à un exemple web.dev, pas à une norme** | web.dev « Your first performance budget » donne bien 200 Ko de JS pour « Slow 4G / Moto G4 », mais pour le **chemin critique**, en « compressed/minified » sans préciser gzip, et dérivé du **TTI**, métrique absente des pondérations de Lighthouse 10. C'est un exemple à ajuster, et le site lui-même conseille 170 Ko de ressources critiques au total par défaut. Le web médian est à 558 Ko (Almanac 2024) et 646 Ko (Almanac 2025, page-weight) sur mobile : la cible est ambitieuse et défendable, mais à présenter comme un budget choisi, pas comme une règle Google. |
| **Toute image dimensionnée** | **Soutenue** | web.dev optimize-cls (« Always include width and height »), MDN `<img>`. Almanac 2025 : 62 % des pages mobiles ont au moins une image sans dimensions. |
| **… et lazy hors viewport** | **Soutenue, à compléter** | `loading="lazy"` est Baseline largement disponible depuis le 19.06.2026. La règle doit dire explicitement l'inverse pour l'image LCP : **jamais lazy, et `fetchpriority="high"`** (web.dev lcp-lazy-loading, tests A/B). C'est critique en Next.js, où `next/image` est **lazy par défaut** : une image héroïque non marquée enfreint le principe sans que personne l'ait voulu. En Next 16, `priority` est déprécié. |
| **Dépendance ajoutée > 30KB gzippé = justification explicite** | **Convention sans preuve trouvée** pour le seuil | Aucune source ne fixe 30 Ko. Le principe de mesurer et de justifier est soutenu (doc Next « package bundling », `next analyze`). Le seul seuil officiel lu porte sur autre chose : découper un bundle au-delà d'environ 50 à 100 kB (v8.dev, 2019). Garder la règle comme garde-fou de revue, en la présentant comme une convention du profil. |
| **Loading : skeleton si > 300ms** | **Convention sans preuve trouvée, en tension avec NN/g** | Aucune source pour le seuil de 300 ms. NN/g (Tankala, 2023, revu le 02.09.2026, https://www.nngroup.com/articles/skeleton-screens/) : « If a page takes less than 1 second to load, skeleton screens or spinners aren't necessary ». Un skeleton déclenché à 300 ms clignote pour une attente de 400 à 900 ms. Sujet traité en détail ailleurs : n'arbitrer qu'avec cette autre fiche. |
| **Server Components par défaut, `'use client'` uniquement quand nécessaire** | **Soutenue (doc du framework)** ; bénéfice chiffré **non démontré indépendamment** | Next.js : « By default, layouts and pages are Server Components » et « add 'use client' … to your interactive components instead of marking large parts of your UI ». Les gains chiffrés trouvés (232 → 89 kB, TBT 430 → 80 ms) sont des mesures d'éditeurs, en labo. Ne pas promettre de chiffre. |
| **Pièges : hydration mismatch** | **Soutenue** | Doc Next « react-hydration-error » : causes et correctifs énumérés. |
| **Pièges : fetch waterfall** | **Soutenue** | Doc Next « Fetching Data » : `Promise.all`, preload, `<Suspense>`. |
| **Pièges : re-renders inutiles** | **Soutenue, à nuancer** | react.dev : profiler d'abord, ne pas mémoïser partout. La cause la plus fréquente selon React est la chaîne d'Effects. Avec React Compiler 1.0 stable, la vérification change : chercher les Effects inutiles plutôt que les `memo` absents. |
| **Pièges : bundle bloat** | **Soutenue** | Almanac 2024 : 44 % du JS livré est inutilisé à la médiane mobile. |
| **Pièges absents de la liste** | **À ajouter** | Image LCP lazy-loadée (16 à 17 % des pages selon l'Almanac 2025) ; gestionnaire `unload` ou `no-store` qui casse le bfcache ; tâches longues dans les gestionnaires d'événements (INP) ; `scheduler.yield()` appelé sans détection (absent de Safari) ; `@babel/standalone` en production pour les PWA sans build. |

---

## Mythes et affirmations contestées

- **« 200 Ko de JS compressé s'analysent en 300 à 500 ms ; hydrater 1 500 nœuds React coûte 150 à 300 ms »** (Patterns.dev, https://www.patterns.dev/react/progressive-hydration/). La page ne cite aucun auteur, aucune date, aucune source de mesure. Il en va de même pour « Hydration cost for an RSC is exactly zero » : une simplification (les Client Components imbriqués s'hydratent toujours). Ne pas reprendre ces chiffres.
- **« Lazy-loader toutes les images améliore la performance »** : contredit pour l'image LCP (tests A/B web.dev, -13 à -15 % de LCP en désactivant le lazy sur les pages d'archive WordPress).
- **« Un bon score Lighthouse vaut bon INP »** : contredit. Lighthouse ne mesure pas l'INP, le TBT n'est qu'un indicateur, et web.dev demande de prioriser le terrain.
- **« Il faut `isInputPending()` pour céder intelligemment »** : retiré. web.dev ne recommande plus cette API.
- **« `scheduler.yield()` est disponible partout »** : faux au 09.11.2026 (absent de Safari, hors Baseline).
- **« Les Server Components rendent l'application rapide / réduisent le JS de 60 % »** : chiffre d'éditeur sur un site unique, mesuré en labo. Aucune étude indépendante terrain trouvée.
- **« Le budget de 200 Ko de JS est une recommandation Google »** : à nuancer. C'est un exemple web.dev de budget critique, dérivé du TTI pour un Moto G4 en 4G lente.
- **« `useMemo` et `memo` partout, par précaution »** : react.dev dit « no benefit » hors cas précis, avec un coût de lisibilité. Ne pas non plus retirer en masse la mémoïsation existante quand on active React Compiler, selon le blog React.
- **« `Cache-Control: no-store` exclut toujours du bfcache »** : à nuancer. Formulation web.dev : « may not be eligible ». Selon le résumé de l'Almanac 2025, Chrome peut admettre certaines pages `no-store`, Firefox et Safari non (non revérifié sur une page Chrome dédiée).
- **Chiffres d'adoption des Speculation Rules hors top 1 000 (Almanac 2025)** : le texte et la figure se contredisent. Seul le 3 % desktop / 5 % mobile du top 1 000 est retenu.

---

## Non vérifié

- **Coût actualisé du JS sur mobile d'entrée de gamme** : la seule source officielle lue date de 2019 (v8.dev). Aucune édition 2024 à 2026 de « The cost of JavaScript » n'a été trouvée.
- **Mesure indépendante, sur données terrain, de la réduction de JS ou d'INP due aux Server Components ou au PPR** : rien trouvé hors articles d'éditeurs.
- **Seuil de 30 Ko par dépendance et seuil de 300 ms pour le skeleton** : aucune source.
- **Prise en charge multi-moteurs d'INP et de LCP dans `web-vitals`** (Firefox, Safari) : lue sur le README du dépôt mais non recoupée sur les notes de version de Safari et Firefox. Le numéro de version exact de `web-vitals` n'est pas lu.
- **Effet chiffré du bfcache sur les Core Web Vitals** : la page web.dev lue ne donne que la part des navigations arrière et avant (1 sur 10 en desktop, 1 sur 5 en mobile).
- **Gain chiffré des Speculation Rules et des View Transitions** : seulement qualitatif dans les pages Chrome.
- **Cache `immutable` appliqué automatiquement par Next.js à `/_next/static`** : non ouvert.
- **Date exacte de l'entrée de l'INP dans les Core Web Vitals** : non lue sur une source primaire. Patterns.dev la donne en mars 2024, source secondaire.
- **Statut Baseline exact de `sizes="auto"`** : non vérifié.
- **Coût mesuré de la transpilation JSX dans le navigateur (`@babel/standalone`)** : la doc Babel le déconseille en production sans chiffrer ce coût.
- **Données Chrome sur l'admission au bfcache des pages `Cache-Control: no-store`** : seul le résumé de l'Almanac a été lu, pas la page Chrome dédiée.

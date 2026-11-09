# Fiche `ux-preuves` — Frontend — React, Next.js et écosystème (état au 09.11.2026)

> Fiche du skill `ux-preuves` (dev-fullstack), volet **frontend**, préchargé par `frontend`. Couvre : React 19 et React Compiler, Next.js 16 (Cache Components, `proxy.ts`, Server Actions = POST publics), état serveur et client, react-hook-form et Zod 4, Tailwind v4, shadcn et Base UI, TypeScript 7, Node LTS, ESLint 10, Auth.js repris par Better Auth.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Versions, statuts Baseline et API **vieillissent
> en mois** : avant d'écrire du code qui en dépend, relire la page officielle (§ « Quand vérifier en
> ligne » du skill). Les sections « Verdict sur les règles du profil », « Mythes » et « Non vérifié »
> sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Recherche documentaire pour le référentiel de l'agent « frontend engineer senior » (pile par défaut : Next.js App Router, TypeScript strict, Tailwind, shadcn/ui, Zustand, React Query/SWR, react-hook-form, Zod).

**Méthode.** Chaque entrée s'appuie sur une page ouverte le 9.11.2026 avec WebFetch. WebFetch renvoie un texte déjà condensé par un petit modèle. Les citations entre « » sont celles que l'outil a restituées comme verbatim ; elles n'ont pas été comparées caractère par caractère au HTML d'origine. Quand seul un résultat de recherche a été lu, l'entrée porte la mention « résumé seul lu ». Sur les pages de releases GitHub, l'année n'est pas affichée : elle est déduite du contexte et signalée comme telle.

**Niveaux de preuve.** N1 : norme ou standard. N2 : recherche revue par les pairs. N3 : documentation officielle. N4 : avis d'expert. Presque tout ce qui suit est en N3, ce qui est normal pour un état de l'art d'outils. Aucune entrée N2 : aucune étude empirique n'a été cherchée ni lue.

---

## 1. React

### Fixer React sur une version corrigée de la série 19.x et traiter les avis de sécurité RSC comme bloquants
- Niveau de preuve : N3
- Source : The React Team, 2025, « Critical Security Vulnerability in React Server Components », https://react.dev/blog/2025/12/03/critical-security-vulnerability-in-react-server-components ; version courante lue sur https://react.dev/versions et https://react.dev/blog
- Extrait lu : « This vulnerability was disclosed as CVE-2025-55182 » ; « is rated CVSS 10.0. » ; « A fix was introduced in versions 19.0.1, 19.1.2, and 19.2.1. » ; « Even if your app does not implement any React Server Function endpoints it may still be vulnerable if your app supports React Server Components. »
- Portée / limites : la dernière version stable est **React 19.3**, publiée le **9 septembre 2026** (« Latest version: 19.3 », react.dev/versions). Un second billet, du 11.12.2025, signale deux failles supplémentaires (déni de service, exposition de code source). Les versions corrigées de ce second lot n'ont pas été relevées. Les apps sans serveur ni bundler RSC ne sont pas touchées.
- En code : vérifier dans `package.json` et dans le lockfile que `react`, `react-dom` et les paquets `react-server-dom-*` ne sont pas sur 19.0.0, 19.1.0, 19.1.1 ou 19.2.0. Une PR qui épingle une version vulnérable est refusée.

### Mettre les mutations dans des Actions (`<form action>`, `useActionState`, `useOptimistic`) plutôt que dans des gestionnaires `onSubmit` avec états `isLoading` faits main
- Niveau de preuve : N3
- Source : The React Team, 2024, « React v19 », https://react.dev/blog/2024/12/05/react-19
- Extrait lu : « By convention, functions that use async transitions are called "Actions". » ; « `React.useActionState` was previously called `ReactDOM.useFormState` in the Canary releases, but we've renamed it and deprecated `useFormState`. » ; « When a `<form>` Action succeeds, React will automatically reset the form for uncontrolled components. »
- Portée / limites : React 19 stable depuis le 5.12.2024. Le même billet annonce `ref` comme prop (« New function components will no longer need `forwardRef` [...] In future versions we will deprecate and remove `forwardRef`. »), et des `<title>`, `<meta>` et `<link>` natifs, remontés dans `<head>`. Dans Next.js, la Metadata API reste l'outil de la plateforme ; ce billet ne dit pas laquelle préférer.
- En code : chercher `useFormState` (déprécié), un `forwardRef` dans un composant nouveau, un `useState(isLoading)` plus un `try/finally` autour d'une soumission qui ferait doublon avec le `pending` de `useActionState`.

### Ne jamais passer à `use()` une promesse créée pendant le rendu, et gérer ses erreurs par un Error Boundary
- Niveau de preuve : N3
- Source : React, s.d. (page de référence en ligne au 9.11.2026), « use », https://react.dev/reference/react/use
- Extrait lu : « Promises created during render are recreated on every render, which causes React to show the Suspense fallback repeatedly and prevents content from appearing. » ; « `use` cannot be called inside a try-catch block. Instead, wrap your component in an Error Boundary » ; « Ideally, Promises are created before rendering, such as in an event handler, a route loader, or a Server Component, and passed to the component that calls `use`. »
- Portée / limites : `use` peut être appelé conditionnellement (billet React 19), contrairement aux autres Hooks. La page ne compare pas `use()` à TanStack Query.
- En code : `use(fetch(...))` ou `use(getX())` sans cache dans un Client Component est un défaut. Un `use()` dans un `try/catch` aussi. La promesse doit venir d'un Server Component, en prop.

### Calculer pendant le rendu ce qui se déduit des props ou de l'état, sans Effect ni état miroir
- Niveau de preuve : N3
- Source : React, s.d., « You Might Not Need an Effect », https://react.dev/learn/you-might-not-need-an-effect
- Extrait lu : « You don't need Effects to transform data for rendering. » ; « You don't need Effects to handle user events. » ; « When something can be calculated from the existing props or state, don't put it in state. » ; « Instead, calculate it during rendering. »
- Portée / limites : pour réinitialiser un sous-arbre quand une prop change, la page recommande une `key` explicite (« Whenever the key [...] changes, React will recreate the DOM and reset the state »).
- En code : le motif `useEffect(() => setX(f(a, b)), [a, b])` est à réécrire en `const x = f(a, b)`. Un `useEffect` qui réagit à un clic doit devenir du code dans le gestionnaire d'événement.

### N'utiliser un Effect que pour se synchroniser avec un système extérieur, toujours avec un cleanup qui résiste au double montage du Strict Mode
- Niveau de preuve : N3
- Source : React, s.d., « Synchronizing with Effects », https://react.dev/learn/synchronizing-with-effects ; React, s.d., « StrictMode », https://react.dev/reference/react/StrictMode
- Extrait lu : « Effects let you run some code after rendering so that you can synchronize your component with some system outside of React. » ; « The right question isn't "how to run an Effect once", but "how to fix my Effect so that it works after remounting". » ; Strict Mode : « Your components will re-run Effects an extra time to find bugs caused by missing Effect cleanup. »
- Portée / limites : le double montage n'a lieu qu'en développement. Selon le billet React 19.3 (9.9.2026), les Effects sont désormais aussi rejoués pendant l'hydratation en Strict Mode.
- En code : un `useRef(false)` qui sert de garde « déjà exécuté » pour contourner le double appel est un défaut. Un Effect sans `return () => …` alors qu'il ouvre une connexion ou un abonnement aussi.

### Ne pas charger des données dans un `useEffect` quand le framework ou un cache client sait le faire
- Niveau de preuve : N3
- Source : React, s.d., « Synchronizing with Effects » (encadré « What are good alternatives to data fetching in Effects? »), https://react.dev/learn/synchronizing-with-effects ; M. Carroll et R. Hanlon, 2025, « Sunsetting Create React App », https://react.dev/blog/2025/02/14/sunsetting-create-react-app
- Extrait lu : « Effects don't run on the server. » ; « Fetching directly in Effects makes it easy to create "network waterfalls". » ; « If you use a framework, use its built-in data fetching mechanism. » ; « Otherwise, consider using or building a client-side cache. Popular open source solutions include TanStack Query, useSWR, and React Router. » ; « You can continue fetching data directly in Effects if neither of these approaches suit you. »
- Portée / limites : la doc **ne l'interdit pas**. Elle exige alors un cleanup contre les courses (drapeau `ignore` ou `AbortController`), selon « You Might Not Need an Effect ».
- En code : dans une app App Router, un `useEffect(() => { fetch(...).then(setData) }, [])` dans une page est à remplacer par un Server Component (ou par une promesse passée à `use()`, ou par TanStack Query si l'état serveur est interactif). Faute de quoi, au minimum un cleanup `ignore` ou `abort`.

### Pour du code neuf, s'en remettre au React Compiler pour la mémoïsation, sans retirer en masse les `useMemo` et `useCallback` existants
- Niveau de preuve : N3
- Source : L. Tan, J. Savona et M. Zhang, 2025, « React Compiler v1.0 », https://react.dev/blog/2025/10/07/react-compiler-1 ; React, s.d., « Introduction » (React Compiler), https://react.dev/learn/react-compiler/introduction ; J. Lai et al., 2025, « Next.js 16 », https://nextjs.org/blog/next-16
- Extrait lu : « For new code, we recommend relying on the compiler for memoization and using `useMemo`/`useCallback` where needed to achieve precise control. » ; « For existing code, we recommend either leaving existing memoization in place (removing it can change compilation output) or carefully testing before removing the memoization. » ; Next.js 16 : « The `reactCompiler` configuration option has been promoted from `experimental` to stable. It is not enabled by default ».
- Portée / limites : version 1.0 stable depuis le **7 octobre 2025**, compatible avec React 17 et plus. Next.js 16.3 et 16.4 proposent une version Rust **expérimentale** (`experimental.turbopackRustReactCompiler`). Le billet ne se prononce pas explicitement sur `React.memo`. Côté Babel, le compilateur allonge les temps de build (Next.js 16).
- En code : sur un projet où `reactCompiler: true` est activé, demander la justification de tout `useMemo` ou `useCallback` ajouté (dépendance d'Effect, contrôle précis). Une PR qui supprime en masse la mémoïsation existante sans tests est refusée. Sur un projet où le compilateur n'est pas activé, la règle ne s'applique pas.

### Appliquer les règles des Hooks et le lint officiel `eslint-plugin-react-hooks` (preset `recommended`, flat config), sans détourner `useEffectEvent` pour faire taire le linter
- Niveau de preuve : N3
- Source : React, s.d., « Rules of Hooks », https://react.dev/reference/rules/rules-of-hooks ; The React Team, 2025, « React 19.2 », https://react.dev/blog/2025/10/01/react-19-2
- Extrait lu : « Don't call Hooks inside loops, conditions, nested functions, or `try`/`catch`/`finally` blocks. » ; « We also published `eslint-plugin-react-hooks@latest` with flat config by default in the `recommended` preset, and opt-in for new React Compiler powered rules. » ; « You don't need to wrap everything in `useEffectEvent`, or to use it just to silence the lint error, as this can lead to bugs. »
- Portée / limites : le billet React Compiler 1.0 dit que les règles du compilateur sont dans le preset `recommended` et que `eslint-plugin-react-compiler` est à retirer. Le billet 19.2 parle, lui, de règles « opt-in ». Les deux billets ne disent pas la même chose : à trancher sur la version installée. Numéro de version exact du plugin : non vérifié.
- En code : chercher les `// eslint-disable-next-line react-hooks/exhaustive-deps` et les `useEffectEvent` qui enveloppent une logique réactive. Chercher aussi un `eslint-plugin-react-compiler` resté dans les dépendances.

---

## 2. Next.js

### Partir de Next.js 16.4.x, la ligne « Active LTS », et appliquer les security releases devenues mensuelles
- Niveau de preuve : N3
- Source : J. Mohammad et S. Silbermann, 2026, « November 2026 Security Release », https://nextjs.org/blog/november-2026-security-release ; Next.js, 2026, « Next.js 16.4 », https://nextjs.org/blog/next-16-4 ; index https://nextjs.org/blog
- Extrait lu : « Updates are now available in v16.4.5 (Active LTS) and v15.5.29 (Maintenance LTS) to address these issues. »
- Portée / limites : Next.js 16 est sorti le **21.10.2025**, la 16.4 le **6.10.2026**, la 16.4.5 le **3.11.2026**. Le blog montre des security releases planifiées chaque mois depuis juillet 2026 (« Next.js is moving to a formal security release process », 13.7.2026), avec des mises à jour hors calendrier en plus. Aucune date de sortie de Next.js 17 n'a été trouvée. La 16.4 annonce seulement que Cache Components y deviendra le défaut.
- En code : un `next` inférieur à 16.4.5 ou à 15.5.29 dans le lockfile est un défaut de sécurité, pas un sujet de confort.

### Considérer qu'aucune donnée n'est mise en cache sans opt-in explicite, et cacher par `'use cache'` (Cache Components), pas par les heuristiques implicites d'avant
- Niveau de preuve : N3
- Source : D. de Oliveira, J. Lai et R. Haines, 2024, « Next.js 15 », https://nextjs.org/blog/next-15 ; J. Lai et al., 2025, « Next.js 16 », https://nextjs.org/blog/next-16 ; Next.js, 2026, « Next.js 16.4 », https://nextjs.org/blog/next-16-4
- Extrait lu : Next 15 : « `fetch` requests, `GET` Route Handlers, and client navigations are no longer cached by default. » ; Next 16 : « caching with Cache Components is entirely opt-in. All dynamic code in any page, layout, or API route is executed at request time by default » ; Next 16.4 : « This new programming model is called Cache Components, and it will become the default in Next.js 17. » ; « Starting with Next.js 16.4, we're excited to recommend Cache Components as the best choice for every Next.js app. » ; « all new apps created with `create-next-app` will have Cache Components enabled by default. »
- Portée / limites : activation par `cacheComponents: true` (et `partialPrefetching: true`, que la 16.4 décrit comme « part of the model »). Partial Prerendering n'existe plus comme drapeau : « the previous experimental `experimental.ppr` flag and configuration options have been removed in favor of the Cache Components configuration » (Next 16). PPR est absorbé par Cache Components.
- En code : un `export const dynamic = 'force-static'`, un `experimental.ppr` ou un `unstable_cache` dans du code neuf posent question. Un `'use cache'` sans `cacheLife` explicite aussi : la doc de référence recommande « Set an explicit cache lifetime with `cacheLife` in every `use cache` scope ».

### Dans une portée `'use cache'`, ne jamais lire `cookies()` ou `headers()` et ne jamais cacher une donnée propre à un utilisateur sans que son identité soit dans les arguments
- Niveau de preuve : N3
- Source : Next.js, 2026 (lastUpdated 2026-11-06), « use cache », https://nextjs.org/docs/app/api-reference/directives/use-cache ; J. Mohammad et S. Silbermann, 2026, « November 2026 Security Release », https://nextjs.org/blog/november-2026-security-release
- Extrait lu : « Cached functions and components **cannot** access runtime APIs like `cookies()`, `headers()`, or `searchParams` » ; « it can pass `next build` and fail under `next start`. Read these values outside the cached scope and pass them as arguments. » ; avis de sécurité : « Distinct binary arguments passed to a `use cache` function can produce the same cache identity. »
- Portée / limites : la release du 3.11.2026 corrige plusieurs fuites de cache entre locataires ou utilisateurs (GHSA-mfr8-8qww-v76h, sévérité haute). Le cache d'exécution ne persiste pas d'une requête à l'autre en serverless avec le gestionnaire mémoire par défaut.
- En code : dans une fonction marquée `'use cache'`, chercher tout appel indirect à `cookies()` ou `headers()`, des arguments binaires (`Uint8Array`, `ArrayBuffer`) qui servent d'identifiant, un mélange `unstable_cache` / `use cache` sur des données multi-locataires.

### Laisser pages et layouts en Server Components et poser `'use client'` sur les feuilles interactives, pas sur de grands sous-arbres
- Niveau de preuve : N3
- Source : Next.js, 2026 (lastUpdated 2026-10-05), « Server and Client Components », https://nextjs.org/docs/app/getting-started/server-and-client-components
- Extrait lu : « By default, layouts and pages are Server Components » ; « Once a file is marked with `"use client"`, **all of its imports and the components it directly renders are included in the client bundle**. » ; « add `'use client'` at the top of the files that define your interactive components instead of marking large parts of your UI as Client Components. » ; pour les providers : « You should render providers as deep as possible in the tree ».
- Portée / limites : les Client Components sont justifiés par l'état, les gestionnaires d'événement, le cycle de vie, les API navigateur et les Hooks personnalisés (liste de la page). Les props qui traversent la frontière doivent être sérialisables.
- En code : un `'use client'` en tête de `layout.tsx` ou de `page.tsx` doit être justifié. Une prop de Client Component typée comme un enregistrement complet de base de données est un défaut.

### Traiter chaque Server Action comme un endpoint POST public : authentifier, autoriser sur la ressource, valider les entrées et filtrer le retour dans l'action elle-même
- Niveau de preuve : N3
- Source : Next.js, 2026 (lastUpdated 2026-10-06), « How to think about data security in Next.js », https://nextjs.org/docs/app/guides/data-security ; Next.js, 2026 (lastUpdated 2026-10-15), « Server Actions and Mutations », https://nextjs.org/docs/app/guides/server-actions
- Extrait lu : « By default, when a Server Action is created and exported, it is reachable via a direct POST request, not just through your application's UI. » ; « A page-level authentication check does not extend to the Server Actions defined within it. Always re-verify inside the action » ; « Schema validation (zod or similar) only checks the *shape* of the input. A well-formed `Item` object can still refer to a row the caller does not own. » ; « Shape them to what the UI renders, not raw database records. »
- Portée / limites : Next.js ajoute une vérification CSRF (Origin contre Host), une limite de 1 Mo par défaut, des identifiants chiffrés et l'élimination des actions inutilisées, mais « Framework protections are not a substitute for application-level checks. » Pour les projets neufs, la doc recommande une Data Access Layer `server-only`.
- En code : dans chaque fichier `'use server'`, vérifier (1) `auth()` ou `verifySession()` en tête, (2) un contrôle de propriété sur l'identifiant reçu (IDOR), (3) un `safeParse` sur les entrées, (4) un `return` limité au besoin de l'UI, (5) aucune base ni `process.env` importés hors de la DAL.

### Ne pas lire de données via des Server Actions appelées du client : elles sont envoyées une à une ; pour lire, utiliser un Server Component ou un Route Handler
- Niveau de preuve : N3
- Source : Next.js, 2026, « Server Actions and Mutations », https://nextjs.org/docs/app/guides/server-actions
- Extrait lu : « Next.js dispatches Server Actions one at a time per client. » ; « do not rely on `Promise.all` to parallelize Server Actions from the client. If you need parallel work, do it inside a single Server Action, fetch in parallel from a Server Component, or use a Route Handler for non-mutation requests. »
- Portée / limites : la page n'interdit pas en toutes lettres la lecture par action. Elle oriente les requêtes sans mutation vers les Route Handlers.
- En code : un `useEffect(() => { getItemsAction().then(...) })` ou un `Promise.all([actionA(), actionB()])` côté client est un défaut.

### Faire les contrôles d'accès au plus près de la donnée (DAL), jamais seulement dans un layout ou dans `proxy.ts`
- Niveau de preuve : N3
- Source : Next.js, 2026 (lastUpdated 2026-09-16), « How to implement authentication in Next.js », https://nextjs.org/docs/app/guides/authentication
- Extrait lu : « be cautious when doing checks in Layouts as these don't re-render on navigation, meaning the user session won't be checked on every route change. » ; « While Proxy can be useful for initial checks, it should not be your only line of defense in protecting your data. » ; « A common pattern in SPAs is to `return null` in a layout or a top-level component if a user is not authorized. This pattern is **not recommended** ».
- Portée / limites : `proxy.ts` sert aux contrôles optimistes (lecture du cookie, sans accès base). Le `cache()` de React ne déduplique rien dans une Server Action ni dans un Route Handler : « Server Actions and Route Handlers are not part of a render pass, so the wrapper does nothing ».
- En code : un `if (!session) return null` dans `layout.tsx` présenté comme protection est un défaut. Un `proxy.ts` qui interroge la base de données aussi.

### Renommer `middleware.ts` en `proxy.ts` et adopter les ruptures de Next.js 16 (API de requête asynchrones, `next lint` supprimé, Turbopack par défaut)
- Niveau de preuve : N3
- Source : J. Lai et al., 2025, « Next.js 16 », https://nextjs.org/blog/next-16
- Extrait lu : « `proxy.ts` replaces `middleware.ts` and makes the app's network boundary explicit. `proxy.ts` runs on the Node.js runtime. » ; « The `middleware.ts` file is still available for Edge runtime use cases, but it is deprecated » ; tableau des suppressions : « Must use async: `await params`, `await searchParams` » ; « `next lint` command — Use Biome or ESLint directly; `next build` no longer runs linting. »
- Portée / limites : Next.js 16 exige Node.js 20.9 et plus, TypeScript 5.1 et plus. Les slots de routes parallèles doivent avoir un `default.js` explicite. `revalidateTag(tag)` à un seul argument est déprécié au profit de `revalidateTag(tag, profile)` ou de `updateTag(tag)` dans les actions.
- En code : chercher un `middleware.ts` neuf, un `params.id` lu sans `await`, un script `"lint": "next lint"`, un `revalidateTag('x')` sans profil.
- Turbopack (même billet) : « Turbopack has reached stability for both development and production builds, and is now the default bundler for all new Next.js projects. » L'opt-out passe par `next dev --webpack` et `next build --webpack`. Les gains annoncés (« 2–5× faster production builds ») sont des chiffres de l'éditeur. Un `--turbopack` résiduel dans les scripts est inutile, un `--webpack` doit être justifié par une config webpack réelle.

### Configurer `next/image` avec `remotePatterns` et `localPatterns`, en connaissant les nouveaux défauts de Next.js 16
- Niveau de preuve : N3
- Source : J. Lai et al., 2025, « Next.js 16 », https://nextjs.org/blog/next-16
- Extrait lu : « `images.qualities` default — Changed from `[1..100]` to `[75]`; `quality` prop is now coerced to closest value in `images.qualities` » ; « `images.minimumCacheTTL` default — Changed from 60s to 4 hours » ; « `next/image` local src with query strings — Now requires `images.localPatterns` config to prevent enumeration attacks » ; dépréciation : « `images.domains` config — Use `images.remotePatterns` config instead ».
- Portée / limites : `images.dangerouslyAllowLocalIP` bloque par défaut l'optimisation des IP locales. La release du 3.11.2026 corrige un contournement de `dangerouslyAllowSVG: false`.
- En code : un `quality={90}` sans `images.qualities` correspondant est silencieusement ramené à 75. Un `images.domains` est déprécié.

---

## 3. État et données

### Une seule source de vérité par information : état local d'abord, minimal, sans redondance, remonté au plus proche parent commun
- Niveau de preuve : N3
- Source : React, s.d., « Choosing the State Structure », https://react.dev/learn/choosing-the-state-structure ; React, s.d., « Sharing State Between Components », https://react.dev/learn/sharing-state-between-components
- Extrait lu : « Avoid redundant state. If you can calculate some information from the component's props or its existing state variables during rendering, you should not put that information into that component's state. » ; « Don't put props *into* state unless you specifically want to prevent updates. » ; « For each unique piece of state, you will choose the component that "owns" it. [...] It doesn't mean that all state lives in one place ».
- Portée / limites : les cinq principes (regrouper, éviter contradictions, redondance, duplication, imbrication profonde) visent la structure de l'état, pas le choix d'une bibliothèque d'état global.
- En code : `useState(props.x)` sans intention de figer la valeur, deux booléens `isSending` et `isSent` qui peuvent se contredire, une liste dupliquée dans un `selectedItem` complet au lieu d'un `selectedId`.

### Ranger les données serveur dans un cache serveur (TanStack Query ou SWR), et seulement si le framework ne couvre pas déjà le besoin
- Niveau de preuve : N3
- Source : TanStack, s.d., « Does TanStack Query replace Redux, MobX or other global state managers? », https://tanstack.com/query/latest/docs/framework/react/guides/does-this-replace-client-state ; TanStack, s.d., « Advanced Server Rendering », https://tanstack.com/query/latest/docs/framework/react/guides/advanced-ssr ; versions : https://github.com/TanStack/query/releases
- Extrait lu : TanStack Query est « a server-state library, responsible for managing asynchronous operations between your server and client. » ; « TanStack Query is not a replacement for local/client state management » ; avec les Server Components : « avoid bringing in React Query until you actually need it. » ; « This might be never, and that's fine, use the right tool for the job! » ; « treat Server Components as a place to prefetch data, nothing more. »
- Portée / limites : `@tanstack/react-query` **5.107.1** (release groupée du 6.11, année 2026 déduite). Les adaptateurs Svelte et Vue devtools sont en 6.x, React reste en v5. La page « replace client state » n'affiche pas son numéro de version. SWR : dernière stable **v2.5.1** (12 août, année non affichée), 2.6.0-beta.0 en préversion.
- En code : dans une app App Router, un `QueryClientProvider` ajouté sans besoin interactif identifié (polling, mutations optimistes répétées, scroll infini) est de la complexité gratuite. Un `queryClient.fetchQuery` rendu côté serveur au lieu d'être déshydraté via `HydrationBoundary` est un défaut.

### Avec Zustand dans Next.js, pas de store global de module : un store par requête via un provider de contexte, et aucun accès depuis un Server Component
- Niveau de preuve : N3
- Source : pmndrs, s.d., « Setup with Next.js », https://zustand.docs.pmnd.rs/learn/guides/nextjs ; versions : https://github.com/pmndrs/zustand/releases
- Extrait lu : défis listés : « Per-request store », « SSR friendly » ; recommandations : « No global stores » ; « React Server Components should not read from or write to the store »
- Portée / limites : le motif recommandé est une fabrique `createStore` (`zustand/vanilla`), une instance par provider créée par `useState`, et un Hook qui lit le contexte. Une note signale une réécriture prochaine du guide (résumé seul lu, discussion GitHub 2740). Dernière version : **v5.1.0** (6 nov., année non affichée, 2026 probable).
- En code : un `export const useStore = create(...)` au niveau module dans une app Next.js avec SSR, qui contient des données propres à un utilisateur, est une fuite potentielle entre requêtes.

---

## 4. Formulaires et validation

### Valider côté serveur dans l'action, avec un schéma, même quand le client valide déjà ; la validation HTML native suffit pour le premier filet côté client
- Niveau de preuve : N3
- Source : Next.js, 2026 (lastUpdated 2026-10-06), « How to create forms with Server Actions », https://nextjs.org/docs/app/guides/forms
- Extrait lu : « For **client-side validation**, you can use the HTML attributes like `required` and `type="email"` for basic validation. » ; « For **server-side validation**, you can use a schema validation library like Zod or Valibot » ; « Always verify authentication and authorization inside each Server Action, even if the form is only rendered on an authenticated page. »
- Portée / limites : la doc Next.js ne cite pas react-hook-form. Elle affiche les erreurs avec `useActionState` et `<p aria-live="polite">`.
- En code : un formulaire où seul `zodResolver` côté client valide, et dont l'action serveur ne fait pas de `safeParse`, est un défaut de sécurité, pas de confort.

### Écrire les schémas en API Zod 4 : formats de premier niveau, paramètre `error` unifié, `z.treeifyError` à la place de `.flatten()`
- Niveau de preuve : N3
- Source : C. McDonnell, s.d., « Release notes » (Zod 4), https://zod.dev/v4 ; Zod, s.d., « Migration guide », https://zod.dev/v4/changelog ; Zod, s.d., « Versioning », https://zod.dev/v4/versioning ; versions : https://github.com/colinhacks/zod/releases
- Extrait lu : « After a year of active development: Zod 4 is now stable! » ; « there is now a single, unified `error` parameter for customizing errors. » ; « The `invalid_type_error` / `required_error` params have been dropped. » ; « The `.flatten()` method on `ZodError` has also been deprecated. » ; « The method forms (`z.string().email()`) still exist and work as before, but are now deprecated. »
- Portée / limites : dernière version **v4.6.7** (12 oct., année non affichée). La page de versioning fait état d'une mise à jour datée du 8 juillet 2025 : la racine du paquet exporte Zod 4, et `"zod/v4"` reste disponible « forever ». Date de déclaration « stable » (mai 2025) : résumé seul lu (AlternativeTo, 20.5.2025). Zod Mini existe pour l'arbre minimal.
- En code : chercher `invalid_type_error`, `required_error`, `errorMap`, `.flatten()`, `z.string().email()`. Attention : le guide Forms de Next.js montre encore `invalid_type_error` et `.flatten()`, donc un exemple copié de la doc officielle n'est pas forcément à jour (voir les mythes).

### Utiliser react-hook-form 7.x stable avec `zodResolver`, sans adopter la v8 bêta en production
- Niveau de preuve : N3
- Source : react-hook-form, s.d., « useForm », https://react-hook-form.com/docs/useform ; versions : https://github.com/react-hook-form/react-hook-form/releases ; https://github.com/react-hook-form/resolvers/releases
- Extrait lu : `resolver` : « This function allows you to use any external validation library such as Yup, Zod, Joi, Vest, Ajv and many others. » ; `progressive` : « Enables progressive enhancement for the Form component » ; `errors` : « Keep the errors object reference-stable to avoid infinite re-renders. »
- Portée / limites : dernière stable **7.91.0** (23 oct.). En préversion : **8.0.0-beta.5**. `@hookform/resolvers` est en **v7.0.5** (8.11.2026). La page des resolvers lue ne mentionne pas Zod 4 : compatibilité non vérifiée sur source primaire. Aucune intégration documentée avec Server Actions ou `useActionState` n'a été trouvée.
- En code : un passage à `react-hook-form@8.0.0-beta.*` en production est refusé. Avec Zod 4, vérifier que la version de `@hookform/resolvers` est compatible (point non vérifié ici).

### Rendre les erreurs de saisie perceptibles : texte explicite, `aria-invalid` posé seulement après validation, message relié par `aria-describedby`, annonce via `aria-live`
- Niveau de preuve : N1 (WCAG 2.2, critère 3.3.1) et technique W3C informative ARIA21
- Source : W3C WAI, s.d., « Understanding SC 3.3.1: Error Identification », https://www.w3.org/WAI/WCAG22/Understanding/error-identification.html ; W3C WAI, s.d., « ARIA21: Using aria-invalid to Indicate An Error Field », https://www.w3.org/WAI/WCAG22/Techniques/aria/ARIA21
- Extrait lu : « If an input error is automatically detected, the item that is in error is identified and the error is described to the user in text. » ; ARIA21 : « The `aria-invalid` attribute should not be set to `"true"` before input validation is performed. » ; « The error message is associated with the field using `aria-describedby`. »
- Portée / limites : 3.3.1 est de niveau A. Les techniques W3C sont informatives, pas normatives. L'exemple `useForm` de react-hook-form utilise `aria-invalid` et `role="alert"` sans l'expliquer.
- En code : un `aria-invalid={true}` dès le premier rendu, un message d'erreur non relié au champ, une erreur signalée par la seule couleur sont des défauts.

---

## 5. Styles et composants

### Configurer Tailwind v4 dans le CSS (`@import "tailwindcss"` et `@theme`) et cibler les navigateurs qu'il exige
- Niveau de preuve : N3
- Source : Tailwind Labs, 2025, « Tailwind CSS v4.0 », https://tailwindcss.com/blog/tailwindcss-v4 ; Tailwind Labs, s.d., « Compatibility », https://tailwindcss.com/docs/compatibility ; versions : https://github.com/tailwindlabs/tailwindcss/releases
- Extrait lu : « Instead of a `tailwind.config.js` file, you can configure all of your customizations directly in the CSS file where you import Tailwind » ; « We've upgraded the entire default color palette from `rgb` to `oklch` » ; « Just one-line of CSS — no more `@tailwind` directives » ; « Chrome 111 (released March 2023) », « Safari 16.4 (released March 2023) », « Firefox 128 (released July 2024) ».
- Portée / limites : v4.0 sortie le **22 janvier 2025**. Dernière version **v4.3.5** (6 nov.). La détection de contenu est automatique (`.gitignore` respecté), `@source` sert pour les exclus. La page Compatibility lue ne dit rien d'un maintien en v3.4 pour les vieux navigateurs.
- En code : un `tailwind.config.js` neuf, des directives `@tailwind base`, un tableau `content` sont des restes v3. Si le public cible inclut Safari < 16.4, v4 n'est pas adapté.

### Avec shadcn/ui sur Tailwind v4 et React 19 : `@theme inline`, couleurs OKLCH, `data-slot`, sans `forwardRef`, `tw-animate-css` et `sonner`
- Niveau de preuve : N3
- Source : shadcn, 2025, « Tailwind v4 », https://ui.shadcn.com/docs/tailwind-v4
- Extrait lu : « Full support for the new `@theme` directive and `@theme inline` option. » ; « HSL colors are now converted to OKLCH. » ; « We've removed the forwardRefs and adjusted the types. » ; « Every primitive now has a `data-slot` attribute for styling. » ; « We've deprecated `tailwindcss-animate` in favor of `tw-animate-css`. » ; « We're deprecating the `toast` component in favor of `sonner`. »
- Portée / limites : page sans date de publication. Ses entrées datent de mars 2025 (19.3.2025 pour `tw-animate-css`). Le style `default` est déprécié au profit de `new-york`.
- En code : `tailwindcss-animate` dans `package.json`, des composants shadcn qui gardent `React.forwardRef`, l'usage de `components/ui/toast` dans du code neuf.

### Choisir explicitement la primitive sous shadcn : Base UI est le défaut des nouveaux projets depuis juillet 2026, Radix reste supporté et n'est pas déprécié
- Niveau de preuve : N3
- Source : shadcn, 2026, « Base UI as the Default », https://ui.shadcn.com/docs/changelog/2026-07-base-ui-default ; versions Base UI : https://github.com/mui/base-ui/releases ; dépôt Radix : https://github.com/radix-ui/primitives
- Extrait lu : « New projects now use Base UI by default. Radix is still fully supported. » ; « Radix is not being deprecated. » ; « Projects created on shadcn/create now pick Base UI over Radix 2 to 1. »
- Portée / limites : le billet cite Base UI 1.6.0. La dernière release visible est **v1.9.0** (9 oct.). Le dépôt Radix indique « Maintained by @workos », sans aucun avis de dépréciation sur la page lue. Date et activité du dernier commit Radix : non visibles. Les nouveaux projets peuvent encore choisir Radix (`-b radix`). Le changelog liste aussi React Aria comme troisième base (juillet 2026, titre seul lu). Date exacte du 3.7.2026 : résumé seul lu (sources secondaires).
- En code : un projet qui mélange des composants shadcn Radix et Base UI doit le justifier. Une migration sans plan composant par composant aussi.

### Traiter les composants shadcn comme du code à soi : la bibliothèque est un point de départ fait pour être modifié et distribué
- Niveau de preuve : N3
- Source : shadcn, s.d., « Introduction », https://ui.shadcn.com/docs ; shadcn, s.d., « Registry », https://ui.shadcn.com/docs/registry
- Extrait lu : « This is not a component library. It is how you build your component library. » ; code « open for modification » ; principe « Beautiful Defaults » : « simple to override and extend the defaults » ; le registre permet de « distribute your custom components, hooks, pages, config, rules and other files to any project. »
- Portée / limites : la doc **autorise et facilite** la personnalisation. Elle ne dit nulle part qu'il est fautif de garder les défauts, qu'elle présente même comme beaux en l'état.
- En code : la question à poser n'est pas « est-ce customisé ? » mais « les jetons (`@theme`, variables CSS) portent-ils l'identité du produit, et les composants modifiés sont-ils versionnés ou distribués par registre plutôt que copiés à la main ? ».

---

## 6. Authentification

### Ne plus démarrer un projet neuf sur Auth.js : il est maintenu par l'équipe Better Auth, qui oriente les projets neufs vers Better Auth
- Niveau de preuve : N3 (annonce de l'éditeur repreneur et bandeau de la doc officielle)
- Source : Better Auth, 2025, « Auth.js is now part of Better Auth », https://www.better-auth.com/blog/authjs-joins-better-auth ; Auth.js, s.d., « Getting Started », https://authjs.dev/getting-started
- Extrait lu : « Auth.js, formerly known as NextAuth.js, is now being maintained and overseen by Better Auth team » ; « we'll keep addressing security patches and urgent issues as they come up. » ; bandeau authjs.dev : « The Auth.js project is now part of Better Auth. »
- Portée / limites : annonce du **22 septembre 2025**. Le billet recommande Better Auth pour les projets neufs, sauf besoins précis comme des sessions sans état et sans base. La doc Auth.js couvre « next-auth@5.0.0-beta and later » : la v5 y apparaît encore comme bêta. Le guide Next.js liste toujours NextAuth.js parmi les bibliothèques possibles, à côté de Better Auth, Clerk, Supabase et d'autres.
- En code : un nouveau `next-auth@5.0.0-beta.*` dans un projet neuf doit être arbitré et justifié. Sur un projet existant, s'assurer de recevoir les correctifs de sécurité.

### Avec Supabase Auth côté serveur, valider le jeton (`getClaims()` ou `getUser()`) ; ne jamais faire confiance à `getSession()` dans du code serveur
- Niveau de preuve : N3
- Source : Supabase, s.d., « Setting up Server-Side Auth for Next.js », https://supabase.com/docs/guides/auth/server-side/nextjs
- Extrait lu : « Never trust `supabase.auth.getSession()` inside server code such as Proxy. » ; « Always use `supabase.auth.getClaims()` to protect pages and user data. » ; « Since Next.js Server Components can't write cookies, you need a Proxy to refresh expired Auth tokens and store them. » ; « On Next.js 15 and earlier, a `proxy.ts` file is never called ».
- Portée / limites : le paquet à utiliser est `@supabase/ssr`. Sur Next.js 15, le fichier reste `middleware.ts`.
- En code : `getSession()` dans un Server Component, une Server Action ou `proxy.ts` sert de garde d'accès : défaut bloquant.

---

## 7. TypeScript

### Cibler TypeScript 7 (compilateur natif en Go, `strict` actif par défaut), en gardant TypeScript 6 pour les outils qui dépendent de l'API programmatique
- Niveau de preuve : N3
- Source : D. Rosenwasser, 2026, « Announcing TypeScript 7.0 », https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/ ; index https://devblogs.microsoft.com/typescript/ ; versions : https://github.com/microsoft/TypeScript/releases
- Extrait lu : « a 10x faster native port of TypeScript » ; `strict` est « `true` by default » ; TypeScript 7.0 ne fournit pas d'API programmatique, et les outils comme typescript-eslint peuvent continuer sur 6.0 via `@typescript/typescript6` (synthèse de l'outil, pas de verbatim).
- Portée / limites : TS 6.0 sorti le 23.3.2026, dernier sur la base JavaScript. TS 7.0 sorti le **8.7.2026**. Dernière stable **7.0.2** (20 août). 7.1 en bêta depuis le 20.10.2026. « Project Corsa » est le nom de code cité dans le billet de décembre 2025. `target: es5`, `baseUrl` et `moduleResolution: classic` deviennent des erreurs. La vérification des templates Vue, Svelte, Astro, MDX et Angular n'est pas encore supportée en 7.0. Que Next.js 16.4 tolère TS 7 n'a pas été vérifié (Next.js 16 demande au minimum TS 5.1).
- En code : un `tsconfig` avec `baseUrl` ou `target: "es5"` casse sous TS 7. Avec typescript-eslint (lint typé), vérifier qu'une installation TS 6 est disponible.

---

## 8. Outillage

### Exécuter en production une version LTS de Node.js (26, 24 ou 22) ; Node 20 est en fin de vie
- Niveau de preuve : N3
- Source : OpenJS Foundation, s.d., « Node.js Releases », https://nodejs.org/en/about/previous-releases
- Extrait lu : « Production applications should only use _Active LTS_ or _Maintenance LTS_ releases. » ; « Starting with Node.js 27, the release cycle will be annual and every major version will move to _LTS_ status after its six-month _Current_ phase »
- Portée / limites : v26 « Lithium » (LTS, sortie le 5.5.2026), v24 « Krypton » (LTS), v22 « Jod » (LTS). v20 « Iron » est **EOL** (dernière mise à jour le 24.3.2026). v27 en Alpha depuis le 29.10.2026. La page ne distingue pas Active et Maintenance LTS. Next.js 16 accepte Node 20.9+, mais Node 20 n'est plus supporté par Node.js.
- En code : un `engines.node: ">=20"`, un `.nvmrc` à 20 ou une image Docker `node:20` sont à relever vers une LTS supportée.

### Pour une SPA hors Next.js, partir de Vite 8 (Rolldown) ; Create React App est déprécié
- Niveau de preuve : N3
- Source : Vite, 2026, « Announcing Vite 8 », https://vite.dev/blog/announcing-vite8 ; M. Carroll et R. Hanlon, 2025, « Sunsetting Create React App », https://react.dev/blog/2025/02/14/sunsetting-create-react-app
- Extrait lu : « Vite 8 ships with Rolldown as its single, unified, Rust-based bundler. » ; « Vite 8 requires Node.js 20.19+, 22.12+ » ; `@vitejs/plugin-react` v6 : « The plugin uses Oxc for React Refresh transform. » ; CRA : « Today, we're deprecating Create React App for new apps » ; « We recommend creating new React apps with a framework. »
- Portée / limites : Vite 8 est sorti le **12.3.2026**, Vite 8.1 le 23.6.2026. Le sélecteur de la doc affiche v8.3.7. Sous Vite 8, le React Compiler passe par un helper `reactCompilerPreset` avec `@rolldown/plugin-babel`.
- En code : `react-scripts` dans un projet neuf est refusé. Avec `@vitejs/plugin-react` v5 sous Vite 8, la mise à jour vers la v6 est conseillée mais pas bloquante.

### Lint en flat config uniquement : ESLint 10 a supprimé eslintrc ; Biome v2 est l'autre voie que cite Next.js
- Niveau de preuve : N3
- Source : ESLint, 2026, « ESLint v10.0.0 released », https://eslint.org/blog/2026/02/eslint-v10.0.0-released/ ; index https://eslint.org/blog/ ; Biome, 2026, blog, https://biomejs.dev/blog/
- Extrait lu : « the eslintrc config system has been completely removed in ESLint v10.0.0. » ; « we are dropping support for all versions of Node.js prior to v20.19.0 as well as v21.x and v23.x. »
- Portée / limites : ESLint 10.0.0 est sorti le **6.2.2026**, dernière version vue **10.14.0** (30.10.2026). Biome **v2.6** est sorti le 15.10.2026. Depuis Next.js 16, `@next/eslint-plugin-next` est en flat config par défaut. Le profil vise « ESLint 9 flat config » : c'est **périmé**, la majeure courante est ESLint 10.
- En code : `.eslintrc.*`, `.eslintignore` ou `ESLINT_USE_FLAT_CONFIG` présents sont sans effet sous ESLint 10. Toute config doit être un `eslint.config.*`.

### Réserver React « dans le navigateur, sans build » (Babel standalone) au prototype et au bac à sable, jamais à la production
- Niveau de preuve : N3
- Source : Babel, s.d., « @babel/standalone », https://babeljs.io/docs/babel-standalone
- Extrait lu : « If you're using Babel in production, you should normally not use `@babel/standalone`. » ; « Instead, you should use a build system running on Node.js, such as Webpack, Rollup, or Parcel, to transpile your JS ahead of time. »
- Portée / limites : les usages légitimes listés sont le prototypage rapide, les playgrounds, les moteurs JS embarqués et les environnements sans Node. La page ne dit rien de la version de React chargée par CDN.
- En code : une page livrée aux utilisateurs avec `<script type="text/babel">` doit porter la mention explicite « prototype » ou être migrée vers un build (Vite).

---

## Verdict sur les règles du profil

| Règle du profil | Verdict | Motif sourcé |
|---|---|---|
| « State : React state local first, Zustand si état global réel, server state via React Query / SWR / `use()`. » | **Soutenue, avec deux nuances** | État local et source unique : React « Choosing the State Structure » et « Sharing State ». Séparation état serveur / état client : TanStack (« server-state library », état client restant « usually very tiny »). Nuance 1 : en App Router, le premier lieu des données serveur est le **Server Component**. TanStack lui-même dit « avoid bringing in React Query until you actually need it ». Nuance 2 : `use()` ne vaut qu'avec une promesse en cache ou venue d'un Server Component (référence `use`). À ajouter : en Next.js, Zustand se crée **par requête** via un provider (« No global stores », guide Zustand). |
| « Server Components first : `'use client'` uniquement quand nécessaire. » | **Soutenue** | Next.js « Server and Client Components » : pages et layouts sont serveur par défaut, et « add `'use client'` [...] to your interactive components instead of marking large parts of your UI as Client Components ». |
| « Anti-pattern : `useState` quand un Server Component suffit ; fetch dans `useEffect` au lieu de Server Component / Server Action. » | **Soutenue pour le fetch-in-effect ; en partie contredite pour « Server Action »** | React liste les défauts du fetch en Effect (pas de rendu serveur, cascades réseau, pas de cache) et renvoie au mécanisme du framework, tout en admettant encore « You can continue fetching data directly in Effects if neither of these approaches suit you ». En revanche, **lire** des données par une Server Action n'est pas la voie officielle : les actions sont « dispatched one at a time per client », et la doc oriente les requêtes sans mutation vers les Server Components ou les Route Handlers. Reformulation proposée : « fetch dans `useEffect` au lieu d'un Server Component (lecture) ou d'une Server Action (mutation) ». |
| « Validation runtime : Zod côté formulaires (react-hook-form + zodResolver). » | **Soutenue mais incomplète, donc dangereuse telle quelle** | `zodResolver` est documenté par react-hook-form. Mais Next.js exige la validation **dans la Server Action** (« Treat `FormData`, query parameters, and headers as untrusted »), et rappelle que le schéma ne contrôle que la forme, pas la propriété de la ressource. La règle doit dire « le même schéma Zod côté client ET dans l'action serveur, plus un contrôle d'autorisation ». La syntaxe à exiger est celle de Zod 4. Compatibilité `@hookform/resolvers` v7 / Zod 4 : non vérifiée. |
| « Auth : consommer la session via Auth.js / Supabase Auth — jamais reconstruire l'état. » | **Principe soutenu ; nom de bibliothèque périmé** | « Ne pas reconstruire » est soutenu : Next.js recommande une bibliothèque d'auth et une DAL qui vérifie la session au plus près de la donnée. Mais Auth.js est passé sous la garde de Better Auth le 22.9.2025, avec correctifs de sécurité et problèmes urgents seulement, et les projets neufs sont orientés vers Better Auth. La v5 est toujours documentée en bêta. Pour Supabase, la règle doit préciser : `getClaims()` ou `getUser()` côté serveur, jamais `getSession()`. |
| « Lib de composants toujours customisée — jamais laissée brute (shadcn ou autre). » | **Convention sans preuve trouvée** | shadcn rend la personnalisation facile (« open for modification ») mais défend aussi ses défauts (« Beautiful Defaults »). Aucune source lue ne fait de la personnalisation une obligation. C'est un choix d'identité visuelle du profil, légitime mais pas une règle d'ingénierie : à présenter comme exigence de design, pas comme bonne pratique documentée. |

Écarts de version dans la pile déclarée du profil, à corriger dans le référentiel :
- « ESLint 9 flat config » : la majeure courante est **ESLint 10** (6.2.2026), et eslintrc y est supprimé.
- La mention implicite de Radix sous shadcn : **Base UI** est le défaut des nouveaux projets shadcn depuis juillet 2026.
- « `middleware.ts` » : renommé `proxy.ts` dans Next.js 16.

---

## Mythes et affirmations contestées

1. **« Next.js met en cache `fetch` par défaut. »** Faux depuis Next.js 15 (21.10.2024) : « `fetch` requests, `GET` Route Handlers, and client navigations are no longer cached by default. » Depuis la 16, le cache passe par `'use cache'`, en opt-in.
2. **« Partial Prerendering est une option expérimentale à activer (`experimental.ppr`). »** Périmé : le drapeau a été retiré dans Next.js 16. PPR est absorbé par Cache Components, que la 16.4 recommande pour toute app et annonce comme défaut de Next.js 17.
3. **« Le middleware Next.js tourne en Edge et s'appelle `middleware.ts`. »** Périmé : `proxy.ts`, sur runtime Node.js. `middleware.ts` est déprécié et ne reste que pour l'Edge.
4. **« Turbopack, c'est seulement pour le dev. »** Périmé : stable et par défaut pour `next build` depuis Next.js 16 (21.10.2025).
5. **« Il faut `useMemo` et `useCallback` partout pour la performance. »** Contesté par React depuis le Compiler 1.0 (7.10.2025) pour le code neuf, si le compilateur est activé. Le mythe inverse, « on peut tout supprimer », est contredit aussi : il faut garder l'existant ou tester avant de retirer.
6. **« Un `useRef` pour empêcher l'Effect de s'exécuter deux fois. »** Contredit : « The right question isn't "how to run an Effect once", but "how to fix my Effect so that it works after remounting". »
7. **« Vérifier la session dans le layout protège tout le segment. »** Contredit : les layouts ne se re-rendent pas à la navigation, et Next.js déconseille explicitement le `return null` de layout.
8. **« Une Server Action non importée n'est pas atteignable. »** Faux comme garantie de sécurité : Next.js élimine les actions inutilisées, mais « you should still treat Server Actions as reachable via direct POST requests ».
9. **« Valider avec Zod suffit à sécuriser une action. »** Contredit : « Schema validation (zod or similar) only checks the *shape* of the input. » Il faut aussi contrôler la propriété.
10. **« Les exemples de la doc officielle Next.js sont forcément à jour. »** Contredit par la doc elle-même : le guide Forms (lastUpdated 6.10.2026) utilise `invalid_type_error` et `.flatten()`, que Zod 4 a supprimés ou dépréciés. Le guide Authentication (16.9.2026), lui, utilise déjà la syntaxe Zod 4 (`z.email({ error })`).
11. **« Create React App pour démarrer une SPA React. »** Déprécié depuis le 14.2.2025.
12. **« ESLint 9 et eslintrc en mode compatibilité. »** Périmé : eslintrc est supprimé dans ESLint 10 (6.2.2026).
13. **« Radix est abandonné. »** Non soutenu par les sources primaires lues : shadcn écrit « Radix is not being deprecated », et le dépôt indique « Maintained by @workos ». Le ralentissement de la maintenance n'est rapporté que par des sources secondaires (résumé seul lu).
14. **« Tailwind se configure dans `tailwind.config.js`. »** Périmé depuis Tailwind v4 (22.1.2025), qui configure dans le CSS avec `@theme`.
15. **« TypeScript s'installe via un paquet natif séparé (`@typescript/native`). »** Selon la synthèse du billet TS 7.0, l'installation standard reste `typescript`. `@typescript/native` n'apparaît que dans un exemple d'alias.
16. **« `getSession()` de Supabase suffit côté serveur. »** Contredit : « Never trust `supabase.auth.getSession()` inside server code ».

---

## Non vérifié

- **Next.js 17** : aucune date de sortie, aucune version trouvée. Seulement l'annonce que Cache Components y deviendra le défaut.
- **Liste précise des correctifs** du billet React du 11.12.2025 (DoS et exposition de code source) : non relevée.
- **Version exacte de `eslint-plugin-react-hooks`**, et statut « par défaut » ou « opt-in » des règles du compilateur : les billets React 19.2 et Compiler 1.0 divergent.
- **Compatibilité `@hookform/resolvers` v7 avec Zod 4** : la page des releases lue n'en dit rien.
- **Intégration officielle react-hook-form et Server Actions / `useActionState`** : aucune documentation trouvée.
- **Date exacte de Zod 4 « stable »** (mai 2025) : résumé seul lu (sources secondaires). Mise à jour datée du 8.7.2025 : lue seulement dans la synthèse de la page de versioning.
- **Date exacte du passage de shadcn à Base UI par défaut** (3.7.2026) : résumé seul lu. Le changelog officiel dit « July 2026 ».
- **Base UI v1.0.0** (date) : non atteint dans la page des releases tronquée.
- **Activité réelle du dépôt Radix** (dernier commit, dernière release) : non visible sur la page lue.
- **Version courante de `lucide-react`** : le dépôt `lucide` est en 1.70.0 (6 nov.), mais la version du paquet React n'est pas affichée. Ruptures éventuelles d'une v1 : non vérifiées.
- **Années des releases GitHub** (Zustand, react-hook-form, Zod, Tailwind, Base UI, SWR) : seuls le jour et le mois sont affichés. 2026 est déduite du contexte.
- **Distinction Active LTS / Maintenance LTS** entre Node 26, 24 et 22 : non affichée sur nodejs.org/previous-releases.
- **Compatibilité de Next.js 16.4 avec TypeScript 7** : non vérifiée.
- **Gains de performance chiffrés** (Turbopack 2 à 5 fois, TS 7 environ 10 fois, Zod 4 14 fois) : chiffres des éditeurs, aucune mesure indépendante lue (pas de N2).
- **Lucide** : pas d'entrée, faute d'une page qui documente des recommandations d'usage.

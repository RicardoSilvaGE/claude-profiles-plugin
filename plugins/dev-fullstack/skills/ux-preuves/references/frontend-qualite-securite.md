# Fiche `ux-preuves` — Frontend — qualité, tests et sécurité du code client

> Fiche du skill `ux-preuves` (dev-fullstack), volet **frontend**, préchargé par `frontend`. Couvre : effet mesuré du typage statique, principes de Testing Library, couverture et efficacité des tests, tests instables, error boundaries et `error.js`/`global-error.js`, XSS et sanitization, Trusted Types, CSP stricte, secrets dans le bundle, chaîne d'approvisionnement npm (Shai-Hulud), SRI, risque des dépendances.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Versions, statuts Baseline et API **vieillissent
> en mois** : avant d'écrire du code qui en dépend, relire la page officielle (§ « Quand vérifier en
> ligne » du skill). Les sections « Verdict sur les règles du profil », « Mythes » et « Non vérifié »
> sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Référentiel de l'agent « frontend engineer senior » (TypeScript, React, Next.js, JS vanilla, PWA).
> Recherche menée le 09.11.2026. Toutes les pages citées ont été ouvertes ce jour-là : WebFetch pour
> les pages HTML ; pour les PDF, téléchargement puis extraction du texte avec `pdftotext`, et
> citations relevées dans le texte extrait. Les citations restent dans leur langue d'origine.
> Quand seul un résumé a été lu, c'est indiqué. Ce qui n'a pas pu être confirmé est rangé dans
> « Non vérifié ».
>
> Niveaux de preuve : N1 norme/standard · N2 recherche revue par pairs ou étude empirique à large
> échantillon · N3 documentation officielle, guide d'institution · N4 avis d'expert, article de
> praticien.

---

## 1. Typage

### Activer le typage statique pour attraper une part des bugs, sans le vendre comme un filet suffisant
- Niveau de preuve : N2
- Source : Zheng Gao, Christian Bird, Earl T. Barr, 2017, « To Type or Not to Type: Quantifying Detectable Bugs in JavaScript » (ICSE 2017), https://discovery.ucl.ac.uk/id/eprint/10064729/1/typestudy.pdf (PDF lu en texte intégral)
- Extrait lu : « both static type systems find an important percentage of public bugs: both Flow 0.30 and TypeScript 2.0 successfully detect 15%! » ; dans les résultats : « at the confidence level of 95%, the true percentage of detectable bugs for Flow and TypeScript falls into [11.5%, 18.5%] with mean 15%. »
- Portée / limites : 400 bugs publics corrigés, tirés de projets JavaScript open source. Les auteurs ont ajouté les annotations à la main, juste avant le commit de correction. Résultat brut : Flow 59 et TypeScript 58, puis 60 chacun une fois les 18 cas indécis tranchés. Le chiffre de 15 % est **confirmé**. Les auteurs le disent « conservative » : les bugs publics ont déjà passé les tests et la revue. Il s'agit de TypeScript 2.0 avec des annotations écrites pour l'étude, sans mesure propre à `strict`. Les erreurs de spécification, que le typage ne voit pas, pèsent 78 % des bugs non détectables (« Errors implementing specification, as a group, overwhelmingly constitute 78% », texte en colonnes entrelacées).
- En code : la PR ajoute-t-elle des `any`, des `as` ou des `@ts-ignore` qui retirent le code de la vérification ? Les tests couvrent-ils la logique métier (les 85 % restants) au lieu de compter sur le compilateur ?

### Ne pas citer « les langages typés ont moins de bugs » comme un fait établi
- Niveau de preuve : N2
- Source : Emery D. Berger, Celeste Hollenbeck, Petr Maj, Olga Vitek, Jan Vitek, 2019, « On the Impact of Programming Languages on Code Quality: A Reproduction Study », https://arxiv.org/pdf/1901.10220 (version arXiv v2 du 24.04.2019, texte intégral lu)
- Extrait lu : « We uncover a number of flaws that undermine the conclusions of the original study as only four languages are found to have a statistically significant association with defects, and even for those the effect size is exceedingly small. »
- Portée / limites : la réplication porte sur Ray et al. (FSE 2014, puis CACM 2017) : 729 projets GitHub, 17 langages. Elle relève un taux de faux positifs de 36 % sur l'étiquetage des commits de correction. Elle retire TypeScript du jeu de données : l'extension `.ts` désignait aussi des fichiers XML de traduction (« Out of 41 projects labeled as TypeScript, only 16 contained TypeScript »). Le classement favorable de TypeScript chez Ray et al. ne tient donc pas. La publication TOPLAS 2019 n'est pas confirmée dans le texte lu (version arXiv), et l'article original de Ray et al. n'a pas été ouvert directement.
- En code : n'avancer aucun argument « TS réduit les bugs de X % ». L'argument défendable est celui de Gao et al. : une classe précise de bugs (types, `undefined`, propriétés absentes) est attrapée avant l'exécution.

### Garder `strict` et le traiter comme un plancher : depuis TypeScript 6.0, c'est le défaut
- Niveau de preuve : N3
- Source : Microsoft, TSConfig Reference, « strict », https://www.typescriptlang.org/tsconfig/#strict ; Microsoft, 23.03.2026, « Announcing TypeScript 6.0 », https://devblogs.microsoft.com/typescript/announcing-typescript-6-0/
- Extrait lu : « Turning this on is equivalent to enabling all of the _strict mode family_ options » ; « Future versions of TypeScript may introduce additional stricter checking under this flag » ; annonce 6.0 : « `strict` is now `true` by default ».
- Portée / limites : la famille `strict` lue sur la page comprend `alwaysStrict`, `strictNullChecks`, `strictBindCallApply`, `strictBuiltinIteratorReturn`, `strictFunctionTypes`, `strictPropertyInitialization`, `noImplicitAny`, `noImplicitThis` et `useUnknownInCatchVariables`. `noUncheckedIndexedAccess` n'en fait **pas** partie et s'active à part (« Turning on `noUncheckedIndexedAccess` will add `undefined` to any un-declared field in the type »). Une montée de version peut ajouter des erreurs, puisque le périmètre de `strict` grandit.
- En code : le `tsconfig` désactive-t-il un membre de la famille (`"strictNullChecks": false`, etc.) ? Contient-il `"strict": false` hérité d'un ancien défaut ? Faut-il ajouter `noUncheckedIndexedAccess` aux accès indexés (tableaux, `Record`) ?

### Valider à l'exécution toute donnée qui franchit une frontière : les types TypeScript disparaissent à la compilation
- Niveau de preuve : N3
- Source : Microsoft, TypeScript Handbook, « The Basics », section « Erased Types », https://www.typescriptlang.org/docs/handbook/2/basic-types.html ; Zod, « Basic usage », https://zod.dev/basics
- Extrait lu : « **Remember**: Type annotations never change the runtime behavior of your program. » ; Zod : « Given any Zod schema, use `.parse` to validate an input. » et `.safeParse` permet de « get back a plain result object containing either the successfully parsed data or a `ZodError`. »
- Portée / limites : le handbook établit le fait (aucun contrôle de type à l'exécution). Zod n'est qu'un outil parmi d'autres, et sa doc ne compare aucune alternative. Le choix de Zod relève de la convention, pas de la preuve. Les erreurs Zod portent un `path` (exemple lu : `path: [ 'username' ]`), qui sert à rattacher l'erreur au champ.
- En code : une réponse `fetch` est-elle castée (`as User`) sans être validée ? Un `JSON.parse`, un `localStorage.getItem` ou un paramètre d'URL est-il utilisé tel quel avec un type supposé ?

---

## 2. Tests

### Écrire les tests comme l'utilisateur se sert de l'interface : requêtes par rôle et par libellé, pas par implémentation
- Niveau de preuve : N3
- Source : Testing Library, « Guiding Principles », https://testing-library.com/docs/guiding-principles ; Testing Library, « About Queries », section Priority, https://testing-library.com/docs/queries/about/#priority
- Extrait lu : « The more your tests resemble the way your software is used, the more confidence they can give you. » ; sur `getByRole` : « This should be your top preference for just about everything. »
- Portée / limites : c'est un principe de conception d'outil, pas un résultat mesuré. Ordre de priorité lu : requêtes accessibles à tous (`getByRole`, `getByLabelText`, `getByPlaceholderText`, `getByText`, `getByDisplayValue`), puis requêtes sémantiques (`getByAltText`, `getByTitle`), puis `getByTestId`, « only recommended for cases where you can't match by role or text ». Effet de bord utile : un test qui trouve un champ par son libellé vérifie au passage que ce libellé existe.
- En code : le test passe-t-il par `container.querySelector('.btn-primary')`, l'état interne ou des `data-testid` alors qu'un rôle ou un libellé existe ?

### Utiliser le « testing trophy » comme repère de retour sur investissement, pas comme une loi
- Niveau de preuve : N4
- Source : Kent C. Dodds, 03.06.2021, « The Testing Trophy and Testing Classifications », https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications
- Extrait lu : le trophée est décrit comme « A general guide for the **return on investment** of the different forms of testing » ; la conclusion parle de « getting a good return on your investment where "return" is "confidence" and "investment" is "time." »
- Portée / limites : l'article ne cite **aucune étude**. Il s'appuie sur l'expérience de l'auteur, et cite lui-même Tim Bray : « let's not kid ourselves that our software-testing tenets constitute scientific knowledge ». Il ne fixe aucun pourcentage par couche. Le trophée est apparu dans un tweet du 06.02.2018. La couche « static » (types, lint) y figure parce qu'en JavaScript « that's not a given ».
- En code : la répartition unitaire / intégration / E2E d'une PR se justifie-t-elle par la confiance gagnée sur le parcours livré, et non par un ratio imposé ?

### Ne pas faire de la couverture de code un objectif de qualité
- Niveau de preuve : N2
- Source : Laura Inozemtseva, Reid Holmes, 2014, « Coverage Is Not Strongly Correlated with Test Suite Effectiveness » (ICSE 2014), https://cs.ubc.ca/~rtholmes/papers/icse_2014_inozemtseva.pdf (texte intégral lu)
- Extrait lu : « there is a low to moderate correlation between coverage and effectiveness when the number of test cases in the suite is controlled for » ; « coverage, while useful for identifying under-tested parts of a program, should not be used as a quality target because it is not a good indicator of test suite effectiveness. »
- Portée / limites : 31 000 suites générées pour 5 systèmes **Java** (jusqu'à 724 000 lignes). L'efficacité est mesurée par mutation, pas sur des fautes réelles. Le transfert au front-end React reste une extrapolation. Les couvertures plus fortes (décision, MC/DC) n'apportent rien de plus.
- En code : refuser une règle de type « 80 % de couverture ou la CI échoue » comme preuve de qualité. Chercher plutôt les tests sans assertion sur le comportement (rendu sans `expect`, snapshots acceptés sans lecture).

### Traiter un test instable comme un défaut à corriger tout de suite : il masque les vraies régressions
- Niveau de preuve : N3 (retour d'expérience institutionnel, à large échantillon)
- Source : John Micco (Google), 27.05.2016, « Flaky Tests at Google and How We Mitigate Them », https://testing.googleblog.com/2016/05/flaky-tests-at-google-and-how-we.html
- Extrait lu : « Almost 16% of our tests have some level of flakiness associated with them! » ; « about 84% of the transitions we observe from pass to fail involve a flaky test! » ; « It is quite common to ignore legitimate failures in flaky tests due to the high number of false-positives. »
- Portée / limites : corpus interne de Google, toutes technologies confondues, chiffres de 2016. Le billet dit aussi qu'« about 1.5% of all test runs » rendent un résultat instable. Sa définition : « a test that exhibits both a passing and a failing result with the same code ». La présentation de Micco de 2017 n'a pas été ouverte.
- En code : la PR ajoute-t-elle des `retries` pour faire passer un test au lieu d'en corriger la cause ? Une mise en quarantaine a-t-elle un ticket et une échéance ?

### Remplacer les délais fixes par l'attente d'une condition : l'attente asynchrone est la première cause d'instabilité
- Niveau de preuve : N2
- Source : Qingzhou Luo, Farah Hariri, Lamyaa Eloussi, Darko Marinov, 2014, « An Empirical Analysis of Flaky Tests » (FSE 2014), https://huang.isis.vanderbilt.edu/cs8395/paper/flakytest.pdf (copie hébergée par un cours, texte intégral lu ; version ACM non comparée)
- Extrait lu : « F.1 The top three categories of flaky tests are Async Wait, Concurrency, and Test Order Dependency. » ; « 74 out of 161 (45%) commits are from the Async Wait » ; « F.8 Many Async Wait flaky tests (54%) are fixed using waitFor. »
- Portée / limites : 201 commits de correction dans 51 projets open source (Apache surtout), tests Java, donc pas de front-end. Autres constats : 78 % des tests instables le sont dès leur écriture (F.2), et un tiers des cas « Async Wait » reposent sur un simple délai (F.4).
- En code : chercher `setTimeout`, `sleep`, `page.waitForTimeout(…)` ou `await new Promise(r => setTimeout(r, …))` dans les tests. Les remplacer par `findBy*`, `waitFor` ou une assertion qui réessaie. Vérifier aussi qu'aucun état partagé ne crée une dépendance d'ordre entre tests.

### En E2E, s'appuyer sur l'auto-attente et les assertions web-first de Playwright, isoler chaque test et simuler les services tiers
- Niveau de preuve : N3
- Source : Playwright, « Auto-waiting », https://playwright.dev/docs/actionability ; Playwright, « Best Practices », https://playwright.dev/docs/best-practices
- Extrait lu : « Playwright performs a range of actionability checks on the elements before making actions » ; « Playwright includes auto-retrying assertions that remove flakiness » ; « Each test should be completely isolated from another test and should run independently. » ; « Only test what you control. »
- Portée / limites : contrôles lus : Visible, Stable, Receives Events, Enabled, Editable. La page des bonnes pratiques n'a pas de section dédiée aux attentes manuelles ou aux tests instables. Elle signale seulement qu'avec `isVisible()` « the test won't wait a single second ». Elle privilégie `getByRole` aux sélecteurs CSS/XPath.
- En code : `expect(await locator.isVisible()).toBe(true)` (aucune attente) au lieu de `await expect(locator).toBeVisible()` ? Des tests qui partagent un compte ou des données ? Des appels à un service tiers réel au lieu d'un mock réseau ?

### Ne comparer les captures de régression visuelle que dans l'environnement qui a produit la référence
- Niveau de preuve : N3
- Source : Playwright, « Visual comparisons », https://playwright.dev/docs/test-snapshots
- Extrait lu : « Browser rendering can vary based on the host OS, version, settings, hardware, power source » ; il faut « run tests in the same environment where the baseline screenshots were generated ».
- Portée / limites : documentation d'outil. Options lues : `threshold` (0,2 par défaut), `maxDiffPixels` (non fixé par défaut) et `stylePath` pour masquer les zones volatiles. **Aucune étude empirique sur l'efficacité de la régression visuelle n'a été trouvée** (voir « Non vérifié »).
- En code : les références ont-elles été générées sur la machine du développeur alors que la CI tourne sous Linux ? Les zones dynamiques (dates, animations, survol) sont-elles neutralisées ?

### Tester l'affichage des erreurs de formulaire au niveau du champ : c'est une exigence WCAG de niveau A
- Niveau de preuve : N1
- Source : W3C, WCAG 2.2, « Understanding SC 3.3.1: Error Identification (Level A) », https://www.w3.org/WAI/WCAG22/Understanding/error-identification.html
- Extrait lu : « If an input error is automatically detected, the item that is in error is identified » et « the error is described to the user in text. »
- Portée / limites : la norme exige le résultat (champ en erreur identifié, erreur décrite en texte). Elle n'impose pas de tester. La suggestion de correction relève de 3.3.3 (non lu ici).
- En code : après une soumission invalide, le test vérifie-t-il que le message apparaît et qu'il est relié au bon champ (par exemple `getByRole('textbox', { name })` puis description accessible), et pas seulement qu'un toast générique s'affiche ?

---

## 3. Erreurs et observabilité

### Rattraper soi-même les erreurs des gestionnaires d'événements et du code asynchrone : les error boundaries ne les voient pas
- Niveau de preuve : N3
- Source : React, « Component », section « Catching rendering errors with an Error Boundary », https://react.dev/reference/react/Component#catching-rendering-errors-with-an-error-boundary
- Extrait lu : « Error boundaries do not catch errors for: Event handlers · Server side rendering · Errors thrown in the error boundary itself (rather than its children) · Asynchronous code (e.g. `setTimeout` or `requestAnimationFrame` callbacks); an exception is the usage of the `startTransition` function returned by the `useTransition` Hook. »
- Portée / limites : « There is currently no way to write an Error Boundary as a function component » : il faut une classe, ou la bibliothèque `react-error-boundary` citée par la doc. Un `fetch` qui échoue dans un `onClick` ou un `useEffect` ne déclenche donc aucune boundary.
- En code : les `onSubmit` et `onClick` asynchrones ont-ils un `try/catch` qui met à jour un état d'erreur visible ? Un effet asynchrone gère-t-il le rejet ? Sinon, `startTransition` permet-il de renvoyer l'erreur à la boundary ?

### Placer les boundaries là où un message d'erreur a un sens, et garder une boundary racine : sans elle, tout l'arbre est démonté
- Niveau de preuve : N3
- Source : React (doc actuelle), même page, https://react.dev/reference/react/Component#catching-rendering-errors-with-an-error-boundary ; React (ancienne doc), « Error Boundaries », https://legacy.reactjs.org/docs/error-boundaries.html
- Extrait lu : « You don't need to wrap every component into a separate Error Boundary. [...] consider where it makes sense to display an error message. [...] it wouldn't make sense to place a boundary around every avatar. » ; ancienne doc : « You may also wrap individual widgets in an error boundary to protect them from crashing the rest of the application. » et « As of React 16, errors that were not caught by any error boundary will result in unmounting of the whole React component tree. »
- Portée / limites : les deux docs se rejoignent sur un découpage par zones porteuses de sens. Elles ne donnent ni taille ni nombre de boundaries, et aucune mesure.
- En code : un widget secondaire (graphique, panneau latéral) peut-il blanchir la page ? Existe-t-il une boundary au-dessus de toute l'application ? Le fallback propose-t-il une sortie (réessayer, revenir) ?

### En App Router, savoir ce que `error.tsx` couvre et ce qu'il ne couvre pas, et prévoir `global-error.tsx` pour le layout racine
- Niveau de preuve : N3
- Source : Next.js, « error.js » (mise à jour du 15.10.2026), https://nextjs.org/docs/app/api-reference/file-conventions/error
- Extrait lu : « `error.js` wraps `loading.js`, `not-found.js`, `page.js`, and nested `layout.js` files in a React error boundary. It does **not** wrap the `layout.js` or `template.js` above it in the same segment. To handle errors in the root layout, use `global-error.js`. » ; « Errors forwarded from Server Components show a generic message with an identifier. This is to prevent leaking sensitive details. »
- Portée / limites : `error.tsx` doit être un Client Component (`'use client'`). La prop `retry` est stable depuis v16.3.0 (`unstable_retry` en v16.2.0) ; `reset` remet l'état sans recharger les données. `global-error` doit rendre ses propres `<html>` et `<body>`, et ne reçoit pas les styles globaux. `error` est typé `unknown` : il faut le restreindre (`instanceof Error`) avant de lire `message` ou `digest`.
- En code : une erreur dans `app/(zone)/layout.tsx` est-elle bien couverte par l'`error.tsx` du segment parent ? Le fallback affiche-t-il `error.message` en supposant un message serveur (vide ou générique en production) au lieu de journaliser `digest` ?

### Remonter en production les erreurs rattrapées et non rattrapées : options de racine React et `unhandledrejection`
- Niveau de preuve : N3
- Source : React, « createRoot », section « Error logging in production », https://react.dev/reference/react-dom/client/createRoot ; MDN, « Window: unhandledrejection event », https://developer.mozilla.org/en-US/docs/Web/API/Window/unhandledrejection_event
- Extrait lu : « By default, React will log all errors to the console. To implement your own error reporting, you can provide the optional error handler root options `onUncaughtError`, `onCaughtError` and `onRecoverableError` » ; MDN : l'événement part « when a JavaScript `Promise` that has no rejection handler is rejected » et « This is useful for debugging and for providing fallback error handling for unexpected situations. »
- Portée / limites : React se contente de la console : sans branchement, rien ne remonte d'un navigateur utilisateur. Les promesses rejetées hors React (gestionnaires d'événements, code asynchrone) passent par `unhandledrejection`. La doc ne recommande aucun fournisseur de suivi des erreurs.
- En code : `createRoot` (ou l'équivalent du framework) transmet-il `onCaughtError` et `onUncaughtError` à un service de suivi ? Un écouteur `unhandledrejection` existe-t-il ? Les rapports partent-ils sans données personnelles ?

### Combiner mesure synthétique (régressions avant livraison) et RUM (ce que vivent les vrais utilisateurs)
- Niveau de preuve : N3
- Source : MDN, « RUM vs. synthetic monitoring », https://developer.mozilla.org/en-US/docs/Web/Performance/Guides/Rum-vs-Synthetic
- Extrait lu : « **Real User Monitoring** or RUM measures the performance of a page from real users' machines. » ; « RUM is generally best suited for understanding long-term trends whereas synthetic monitoring is very well suited to regression testing and mitigating shorter-term performance issues during development. »
- Portée / limites : la page traite de **performance**, pas d'erreurs. Elle cite pour seuls inconvénients du RUM le coût et la complexité. Le transfert au suivi d'erreurs est une inférence.
- En code : le seul garde-fou est-il un Lighthouse en CI ? Une métrique ou une erreur remonte-t-elle du terrain après mise en production ?

---

## 4. Sécurité côté client

### N'utiliser `dangerouslySetInnerHTML` qu'avec du HTML de confiance ET assaini
- Niveau de preuve : N3
- Source : React, « Common components », section « Dangerously setting the inner HTML », https://react.dev/reference/react-dom/components/common
- Extrait lu : « Unless the markup is coming from a completely trusted source, it is trivial to introduce an XSS vulnerability this way. » ; « **Only use `dangerouslySetInnerHTML` with trusted and sanitized data.** »
- Portée / limites : la doc accepte une valeur `TrustedHTML` : « React passes the value to the browser without converting it to a string, allowing the browser to validate it ». Elle ajoute que la politique Trusted Types doit elle-même assainir.
- En code : chercher `dangerouslySetInnerHTML`, `innerHTML =`, `insertAdjacentHTML` et `document.write`. Pour chacun, d'où vient la donnée et où se fait l'assainissement ?

### Assainir avec un assainisseur maintenu (DOMPurify) en dernière étape : ne rien modifier après
- Niveau de preuve : N3 (documentation du projet)
- Source : cure53, DOMPurify, README, https://github.com/cure53/DOMPurify
- Extrait lu : « DOMPurify will strip out everything that contains dangerous HTML and thereby prevent XSS attacks and other nastiness. » ; si l'on modifie après assainissement, « you might easily void the effects of sanitization. »
- Portée / limites : DOMPurify a besoin d'un vrai DOM. Côté serveur, le README juge happy-dom dangereux (« will likely lead to XSS »). Sur les navigateurs anciens, « It simply does nothing ». L'option `RETURN_TRUSTED_TYPE` produit un `TrustedHTML`. La version lue sur la page était v3.4.17.
- En code : la sortie de `DOMPurify.sanitize` passe-t-elle encore par un `replace`, une concaténation ou un parseur Markdown avant d'être injectée ? L'assainissement a-t-il lieu côté serveur avec un DOM simulé non sûr ?

### Valider le schéma des URL fournies par l'utilisateur (`href`, `src`) : React ne neutralise que `javascript:`
- Niveau de preuve : N3
- Source : React, 08.08.2019, « React v16.9.0 and the Roadmap Update », https://legacy.reactjs.org/blog/2019/08/08/react-v16.9.0.html ; code source React (branche `main`), `sanitizeURL.js`, https://raw.githubusercontent.com/facebook/react/main/packages/react-dom-bindings/src/shared/sanitizeURL.js
- Extrait lu : « In React 16.9, this pattern continues to work, but it will log a warning. » ; « In a future major release, React will throw an error if it encounters a `javascript:` URL. » ; le code source remplace l'URL par `"javascript:throw new Error('React has blocked a javascript: URL as a security precaution.')"`.
- Portée / limites : lu sur la branche `main` le 09.11.2026 : l'appel à `sanitizeURL` est inconditionnel pour les attributs d'URL dans `ReactDOMComponent.js`. La **version publiée** à partir de laquelle ce blocage est actif n'a pas été vérifiée sur une note de version officielle. La doc actuelle de react.dev ne mentionne pas `javascript:`. Le filtre ne vise que ce schéma : `data:` et les redirections ouvertes ne sont pas traités.
- En code : un `href={user.website}` ou un `src={param}` passe-t-il par une liste blanche de schémas (`https:`, `mailto:`) ?

### Viser Trusted Types pour verrouiller les points d'injection du DOM, en le testant sur les navigateurs cibles
- Niveau de preuve : N3
- Source : MDN, « Trusted Types API », https://developer.mozilla.org/en-US/docs/Web/API/Trusted_Types_API
- Extrait lu : bandeau de compatibilité : « Baseline 2026 · Newly available · Since February 2026, this feature works across the latest devices and browser versions. » ; « With this directive set, passing strings into injection sinks will result in a `TypeError` exception ».
- Portée / limites : « Newly available » signifie que les navigateurs anciens ne le gèrent pas. Le déploiement se fait d'abord en mode report-only, puis en blocage, et chaque bibliothèque qui écrit du HTML doit passer par une politique. Le détail par navigateur n'a pas été vérifié au-delà du bandeau.
- En code : la CSP contient-elle `require-trusted-types-for 'script'` (au moins en `Report-Only`) ? Les écritures `innerHTML` passent-elles par une politique nommée ?

### Ne pas compter sur une CSP à liste blanche d'hôtes : la quasi-totalité est contournable
- Niveau de preuve : N2
- Source : Lukas Weichselbaum, Michele Spagnuolo, Sebastian Lekies, Artur Janc, 2016, « CSP Is Dead, Long Live CSP! On the Insecurity of Whitelists and the Future of Content Security Policy » (CCS 2016), https://research.google.com/pubs/archive/45542.pdf (texte intégral lu)
- Extrait lu : « identify significant flaws in real-world deployments that result in bypasses in 94.72% of all distinct policies » ; « 75.81% of distinct policies use script whitelists that allow attackers to bypass CSP. In total, we find that 94.68% of policies that attempt to limit script execution are ineffective, and that 99.34% of hosts with CSP use policies that offer no benefit against XSS. »
- Portée / limites : 26 011 politiques uniques sur 1 680 867 hôtes, extraites d'un index d'environ 100 milliards de pages. Le chiffre **94,72 % est confirmé**, mais il porte sur les politiques distinctes. 94,68 % porte sur les politiques qui cherchent à restreindre les scripts, et 99,34 % sur les hôtes. Les trois ne sont pas interchangeables. Données de 2016.
- En code : la CSP contient-elle `'unsafe-inline'` sans nonce, ou des domaines de CDN entiers (`https://cdn.jsdelivr.net`) dans `script-src` ?

### Déployer une CSP stricte à nonce ou à hachage, en connaissant son coût dans Next.js
- Niveau de preuve : N3
- Source : Lukas Weichselbaum, web.dev, « Mitigate cross-site scripting (XSS) with a strict Content Security Policy (CSP) », https://web.dev/articles/strict-csp ; Next.js, « Content Security Policy » (mise à jour du 20.03.2026), https://nextjs.org/docs/app/guides/content-security-policy
- Extrait lu : web.dev : `script-src 'nonce-{RANDOM}' 'strict-dynamic'; object-src 'none'; base-uri 'none';` ; les CSP à liste blanche « can be bypassed in most configurations ». Next.js : « you **must use dynamic rendering to add nonces** » ; « Static optimization and Incremental Static Regeneration (ISR) are disabled » ; « **Partial Prerendering (PPR) is incompatible** with nonce-based CSP ».
- Portée / limites : la page web.dev ne donne pas sa date. Côté Next.js, l'alternative pour garder le rendu statique est le SRI **expérimental** (`experimental.sri`, App Router seulement). L'exemple Next.js « Without Nonces » contient `script-src 'self' 'unsafe-inline'` : ce n'est **pas** une CSP stricte au sens de web.dev.
- En code : le nonce est-il régénéré à chaque requête et jamais mis en cache ? La politique de production retire-t-elle `'unsafe-eval'`, que Next.js n'exige qu'en développement ?

### Ne jamais mettre de secret derrière `NEXT_PUBLIC_*` : la valeur est écrite en dur dans le bundle
- Niveau de preuve : N3
- Source : Next.js, « How to use environment variables in Next.js » (mise à jour du 25.08.2026), https://nextjs.org/docs/app/guides/environment-variables
- Extrait lu : « Next.js can "inline" a value, at build time, into the js bundle that is delivered to the client, replacing all references to `process.env.[variable]` with a hard-coded value. To tell it to do this, you just have to prefix the variable with `NEXT_PUBLIC_`. » ; « By default, environment variables are only available on the server ».
- Portée / limites : les valeurs sont figées au build : une même image Docker garde les valeurs du build dans tous les environnements. La doc rappelle que les fichiers `.env` ne doivent presque jamais être commités. Le même principe vaut pour tout bundler (préfixes `VITE_` et analogues), mais ce point n'a pas été vérifié ici.
- En code : grep `NEXT_PUBLIC_` sur les noms qui contiennent `KEY`, `SECRET`, `TOKEN` ou `SERVICE_ROLE`. Un module serveur est-il importé dans un Client Component ?

### Garder les jetons d'authentification hors de `localStorage` et `sessionStorage` : cookies `HttpOnly; Secure; SameSite` ou BFF
- Niveau de preuve : N3
- Source : OWASP, « Session Management Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html (phrases complètes relevées dans la source Markdown du même document, https://raw.githubusercontent.com/OWASP/CheatSheetSeries/master/cheatsheets/Session_Management_Cheat_Sheet.md) ; OWASP, « HTML5 Security Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/HTML5_Security_Cheat_Sheet.html
- Extrait lu : « Do not store authentication tokens, session IDs, JWTs, refresh tokens, or any credential in `localStorage` or `sessionStorage`. These APIs are accessible to any JavaScript executing in the origin, so a single XSS vulnerability discloses every token. Use `HttpOnly; Secure; SameSite=Strict` cookies (preferred) or a Backend-for-Frontend (BFF) pattern. »
- Portée / limites : OWASP précise que `HttpOnly` ne protège que la **confidentialité** du cookie : « The `HttpOnly` cookie only protects the confidentiality of the cookie; the attacker cannot use it offline, outside of the context of an XSS attack. » Une XSS peut donc toujours agir au nom de l'utilisateur pendant la session. La fiche JWT d'OWASP ouverte ce jour ne traite pas du stockage côté client.
- En code : `localStorage.setItem('token', …)` ou un SDK d'authentification configuré avec un stockage local par défaut ? Le choix est-il documenté et compensé (CSP stricte, durée de vie courte) ?

### Doubler la validation de formulaire côté client, pour l'ergonomie, d'une validation serveur, pour la sécurité
- Niveau de preuve : N3
- Source : OWASP, « Input Validation Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html
- Extrait lu : « Validate on the server even when the browser checks the same fields. » ; « Client-side validation is bypassable; use it for immediate feedback. »
- Portée / limites : OWASP rappelle aussi que la validation d'entrée ne remplace ni l'encodage de sortie (XSS) ni les requêtes paramétrées (SQL). La validation client sert l'utilisateur, pas la sécurité.
- En code : le schéma client est-il le seul garde-fou (aucune validation côté route handler, server action ou RPC) ? Le schéma est-il partagé entre client et serveur, ou dupliqué au risque de diverger ?

---

## 5. Chaîne d'approvisionnement npm

### Considérer qu'une dépendance compromise s'exécute dans le navigateur de l'utilisateur : reconstruire les bundles après un incident
- Niveau de preuve : N3 (avis GitHub Advisory Database, relu par GitHub)
- Source : GitHub Advisory Database, GHSA-4x49-vf9v-38px, publié le 15.09.2025, « debug@4.4.2 contains malware after npm account takeover », https://github.com/advisories/GHSA-4x49-vf9v-38px
- Extrait lu : « the npm publishing account for `debug` was taken over after a phishing attack » ; la charge tentait de « redirect cryptocurrency transactions to the attacker's own addresses » ; « Local environments, server environments, command line applications, etc. are not affected. » ; « Users should upgrade to the latest patch version, completely remove their `node_modules` directory ».
- Portée / limites : version affectée `= 4.4.2`, corrigée en 4.4.3, compromission du 08.09.2025. Seul l'avis sur `debug` a été lu. La liste complète des autres paquets compromis le même jour (`chalk` et d'autres) et les volumes de téléchargement viennent de la presse et d'éditeurs, et n'ont **pas** été vérifiés sur avis officiel. Point clé pour le front : la charge visait le **navigateur**, donc les bundles livrés.
- En code : après un incident, le bundle publié a-t-il été reconstruit depuis un lockfile assaini, et pas seulement la dépendance mise à jour en local ?

### Se préparer aux vers qui se propagent par les jetons de publication (Shai-Hulud, 2025)
- Niveau de preuve : N3
- Source : CISA, 23.09.2025, « Widespread Supply Chain Compromise Impacting npm Ecosystem », https://www.cisa.gov/news-events/alerts/2025/09/23/widespread-supply-chain-compromise-impacting-npm-ecosystem ; Xavier René-Corail (GitHub), 22.09.2025, « Our plan for a more secure npm supply chain », https://github.blog/security/supply-chain-security/our-plan-for-a-more-secure-npm-supply-chain/ ; GitLab Advisory Database, GMS-2025-611, https://advisories.gitlab.com/pkg/npm/schob/
- Extrait lu : CISA : « A self-replicating worm—publicly known as "Shai-Hulud"—has compromised over 500 packages. » ; « Pin npm package dependency versions to known safe releases produced prior to Sept. 16, 2025. » ; « Mandate phishing-resistant multifactor authentication (MFA) on all developer accounts ». GitLab : « On November 24th 2025, a new supply chain attack called Shai-Hulud 2.0 was launched. » et « The malicious software executes during the pre-install phase and attempts to harvest credentials from popular online services. »
- Portée / limites : le ver cherchait les jetons GitHub et les clés cloud (AWS, GCP, Azure) sur les postes et en CI, puis republiait les paquets. GitHub annonce la publication locale avec 2FA obligatoire, des jetons granulaires à 7 jours, la publication de confiance (trusted publishing) et l'abandon de la 2FA TOTP au profit de WebAuthn. L'ampleur de la vague 2.0 (paquets, dépôts touchés) n'a pas été vérifiée sur source primaire.
- En code : le projet publie-t-il lui-même des paquets avec un jeton longue durée ? La CI qui fait `npm install` a-t-elle accès à des secrets dont elle n'a pas besoin ?

### Installer en CI depuis le lockfile, sans résolution (`npm ci`), et envisager `--ignore-scripts`
- Niveau de preuve : N3
- Source : npm Docs v11, « npm ci », https://docs.npmjs.com/cli/v11/commands/npm-ci ; pnpm, « Settings: Build », https://pnpm.io/settings/build
- Extrait lu : « If dependencies in the package lock do not match those in package.json, npm ci will exit with an error » ; « It will never write to package.json or any of the package-locks: installs are essentially frozen. » ; `ignore-scripts` : « If true, npm does not run scripts specified in package.json files. » ; pnpm : « Packages not listed in `allowBuilds` are disallowed by default and are treated as unreviewed. »
- Portée / limites : `--ignore-scripts` casse les paquets qui compilent à l'installation (binaires natifs) : il faut une liste d'exceptions. Chez pnpm, les scripts de build des dépendances sont bloqués tant qu'on ne les a pas approuvés (`strictDepBuilds` vaut `true` par défaut selon la page lue). La version de pnpm qui a introduit ce comportement n'a pas été vérifiée. La vague Shai-Hulud 2.0 passait justement par `preinstall`.
- En code : la CI utilise-t-elle `npm install` (qui peut réécrire le lockfile) au lieu de `npm ci` ? Le lockfile est-il commité et relu dans la PR quand il change ?

### Retarder l'adoption des versions fraîchement publiées
- Niveau de preuve : N3
- Source : pnpm, « Settings: Dependency Resolution », `minimumReleaseAge`, https://pnpm.io/settings/dependency-resolution ; npm Docs v11, « config », `min-release-age`, https://docs.npmjs.com/cli/v11/using-npm/config
- Extrait lu : pnpm : « To reduce the risk of installing compromised or defective packages, you can delay the installation of newly published versions. » et « In most cases, malicious releases are discovered and removed from the registry within an hour. » ; npm : « If set, npm will build the npm tree such that only versions that were available more than the given number of days ago ».
- Portée / limites : la page pnpm affiche une valeur de 1440 minutes (un jour). Sa phrase « within an hour » n'est **pas sourcée** sur la page : c'est une affirmation de l'éditeur. Le délai retarde aussi les correctifs de sécurité, d'où `minimumReleaseAgeExclude`. La version de npm qui a introduit `min-release-age` n'a pas été vérifiée.
- En code : le projet fixe-t-il un âge minimal de publication (`.npmrc` ou `pnpm-workspace.yaml`) ? Les exceptions sont-elles nommées et justifiées ?

### Ne pas confondre provenance et innocuité
- Niveau de preuve : N3
- Source : npm Docs, « Generating provenance statements », https://docs.npmjs.com/generating-provenance-statements
- Extrait lu : la provenance « allows developers to verify where and how your package was built before they download it » ; « When a package in the npm registry has established provenance, it does not guarantee the package has no malicious code. »
- Portée / limites : vérification par `npm audit signatures`. La provenance n'est générée que depuis une CI cloud prise en charge (GitHub Actions, GitLab CI/CD). Elle relie un paquet à sa source, mais un dépôt source compromis produit une provenance valide.
- En code : `npm audit signatures` tourne-t-il en CI ? Une dépendance critique qui perd soudain sa provenance d'une version à l'autre est-elle signalée ?

### Charger un script tiers depuis un CDN avec Subresource Integrity, ou l'auto-héberger
- Niveau de preuve : N3
- Source : MDN, « Subresource Integrity », https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity
- Extrait lu : « It works by allowing you to provide a cryptographic hash that a fetched resource must match. » ; si aucun hachage ne correspond, le navigateur va « refuse to load the resource, and return a network error. » ; « Cross-origin requests that use subresource integrity must use the Cross-Origin Resource Sharing (CORS) protocol. »
- Portée / limites : il faut l'attribut `crossorigin`. SRI ne marche que pour une ressource figée : un script tiers qui change sans prévenir (balise d'analytics « evergreen ») cassera. La page lue ne montrait pas de statut Baseline.
- En code : `<script src="https://…">` sans `integrity` ni `crossorigin="anonymous"` ? URL de CDN sans version figée (`@latest`) ?

---

## 6. Dépendances

### Compter le coût de confiance d'une dépendance, pas seulement son poids : une installation moyenne fait confiance à ~79 paquets et ~39 mainteneurs
- Niveau de preuve : N2
- Source : Markus Zimmermann, Cristian-Alexandru Staicu, Cam Tenny, Michael Pradel, 2019, « Small World with High Risks: A Study of Security Threats in the npm Ecosystem » (USENIX Security 2019), https://www.usenix.org/system/files/sec19-zimmermann.pdf (texte intégral lu)
- Extrait lu : « Installing an average npm package introduces an implicit trust on 79 third-party packages and 39 maintainers, creating a surprisingly large attack surface. » ; « A significant percentage (up to 40%) of all packages depend on code with at least one publicly known vulnerability. » ; « a very small number of compromised maintainer accounts suffices to inject malware into the majority of all packages. »
- Portée / limites : instantané de l'écosystème npm de 2018-2019 (plus de 800 000 paquets en février 2019, 609 vulnérabilités publiques étudiées). Les chiffres ont pu évoluer depuis. Les auteurs estiment qu'environ 140 mainteneurs vérifiés diviseraient le risque par deux.
- En code : pour toute nouvelle dépendance, combien de dépendances transitives entrent (`npm ls --all` ou équivalent) ? Combien de mainteneurs ? Quelle activité récente ?

### Ne pas dépendre d'un micro-paquet qu'on écrirait en quelques lignes (leçon de left-pad)
- Niveau de preuve : N3 (communiqué officiel du registre)
- Source : npm, Inc., 23.03.2016, « kik, left-pad, and npm », https://blog.npmjs.org/post/141577284765/kik-left-pad-and-npm
- Extrait lu : l'incident a débuté « Shortly after 2:30 PM (Pacific Time) on Tuesday, March 22 » ; « The duration of the disruption was 2.5 hours. » ; mesure annoncée : « We will make it harder to un-publish a version of a package if doing so would break other packages. »
- Portée / limites : 273 paquets dépubliés (kik plus 272 autres), dont left-pad. La politique de dépublication a changé depuis. Le risque de disparition est donc réduit, mais pas le risque de compromission (voir Zimmermann et al.). L'étude de 2017 sur les « trivial packages » n'a pas pu être lue (voir « Non vérifié »).
- En code : la dépendance ajoutée fait-elle moins de quelques dizaines de lignes, sans dépendances propres, pour une fonction disponible dans la plateforme (`String.prototype.padStart`, `structuredClone`, `Intl`) ?

### Juger le poids d'une dépendance par le JavaScript téléchargé et exécuté, surtout sur mobile
- Niveau de preuve : N4 (ingénieurs de l'équipe V8 et Chrome, sur le blog officiel de V8)
- Source : Addy Osmani, Mathias Bynens, 25.06.2019, « The cost of JavaScript in 2019 », https://v8.dev/blog/cost-of-javascript-2019
- Extrait lu : « In 2019, the dominant costs of processing scripts are now download and CPU execution time. » ; « if a bundle exceeds ~50–100 kB, split it up into separate smaller bundles. » ; « On mobile you'll want to ship much less ».
- Portée / limites : article de 2019. Le seuil de 50-100 kB porte sur un **bundle**, pas sur une dépendance, et l'article ne précise pas s'il s'agit de taille compressée. Aucune source lue ne justifie un seuil de 30 KB gzippé par dépendance.
- En code : la dépendance est-elle importée dans le bundle initial ou chargée à la demande (`import()` dynamique) ? Est-elle « tree-shakable » ? Son poids est-il mesuré dans le build réel plutôt que sur une fiche de paquet ?

---

## Verdict sur les règles du profil

| Règle du profil | Verdict | Motif sourcé |
|---|---|---|
| « Pas de `dangerouslySetInnerHTML` sans sanitization. Pas de secret dans le code client. » | **Soutenue** (N3), mais **incomplète** | La doc React l'exige mot pour mot : « Only use `dangerouslySetInnerHTML` with trusted and sanitized data ». Next.js confirme que `NEXT_PUBLIC_*` est écrit en dur dans le bundle. Manques : (1) assainir **en dernier** (DOMPurify) ; (2) les URL fournies par l'utilisateur dans `href` et `src` ; (3) les jetons d'authentification dans `localStorage` sont aussi un « secret côté client » au sens d'OWASP ; (4) la défense en profondeur, avec une CSP stricte à nonce ou hachage (pas une liste blanche : 94,72 % contournables) et Trusted Types (Baseline depuis février 2026). |
| « Error boundaries par zone : une erreur dans un widget ne blanchit pas la page ; la boundary racine est le dernier filet. » | **Soutenue** (N3), avec **deux angles morts** | L'ancienne doc React recommande d'« wrap individual widgets ». La doc actuelle demande de placer les boundaries « where it makes sense to display an error message ». Depuis React 16, une erreur non rattrapée démonte tout l'arbre, ce qui justifie la boundary racine. Angles morts : les boundaries **ne rattrapent pas** les gestionnaires d'événements ni le code asynchrone (il faut un `try/catch` et un état d'erreur, plus `unhandledrejection`). Dans Next.js, `error.tsx` ne couvre pas le layout de son propre segment : le vrai dernier filet est `global-error.tsx`. Ajouter la remontée en production (`onCaughtError`, `onUncaughtError`). |
| « Tests : je couvre au minimum le rendu des 4 états, les interactions du parcours livré et les erreurs de formulaire mappées aux champs. » | **Convention sans preuve trouvée**, cohérente avec les sources | Aucune étude ne mesure un « minimum » de ce type. La règle s'aligne sur le principe de Testing Library (tester comme l'utilisateur) et sur WCAG 3.3.1 (N1), qui exige d'identifier le champ en erreur et de décrire l'erreur en texte. Elle évite le piège d'un objectif de couverture (Inozemtseva & Holmes : corrélation « low to moderate » à taille égale). À ajouter : requêtes par rôle et libellé, aucune attente par délai fixe (45 % des tests instables étudiés relèvent de l'attente asynchrone), isolation des tests E2E. |
| « Validation runtime côté formulaire (Zod ou équivalent) en plus de la validation backend. » | **Soutenue** (N3) sur le principe ; Zod est un **choix de convention** | OWASP : « Client-side validation is bypassable; use it for immediate feedback » et « Validate on the server even when the browser checks the same fields ». La formule « en plus » est donc juste, et la validation serveur reste la seule qui protège. Le handbook TypeScript confirme que les types n'existent plus à l'exécution. La validation runtime est donc aussi due sur les **réponses d'API** et les données stockées, pas seulement sur les formulaires. Aucune source ne départage Zod des alternatives. |
| « TypeScript strict. » | **Soutenue** (N2 + N3), effet à ne pas surestimer | Gao et al. : environ 15 % des bugs publics étudiés étaient détectables par TypeScript ou Flow (IC à 95 % : 11,5-18,5 %). Berger et al. montrent que l'effet « langage » des études observationnelles est très faible ou fragile. Depuis TypeScript 6.0 (23.03.2026), `strict` est le **défaut** : la règle devient « ne pas le désactiver ». À compléter : `noUncheckedIndexedAccess`, hors de `strict` (convention, aucune mesure trouvée), et l'interdiction des échappatoires (`any`, `as`, `@ts-ignore`). |
| « Dépendance ajoutée > 30KB gzippé = justification explicite » | **Seuil = convention sans preuve trouvée** ; le profil **ignore la sécurité** | Aucune source lue ne donne 30 KB. La seule référence chiffrée (V8, 2019) parle de découper les bundles au-delà d'environ 50-100 kB, ce qui est une autre mesure. L'angle mort principal est la confiance : environ 79 paquets et 39 mainteneurs par installation moyenne, et jusqu'à 40 % de paquets dépendant de code vulnérable (Zimmermann et al. 2019). Une dépendance minuscule peut être compromise (debug@4.4.2, charge active dans le navigateur, septembre 2025) ou se propager par les jetons (Shai-Hulud, plus de 500 paquets selon CISA). Mesures sourcées à ajouter : lockfile commité et `npm ci`, scripts d'installation bloqués ou approuvés, âge minimal de publication (`minimumReleaseAge`, `min-release-age`), `npm audit signatures` (en sachant que la provenance ne garantit pas l'innocuité), SRI pour tout script tiers servi par un CDN, 2FA résistante à l'hameçonnage pour qui publie. |

---

## Mythes et affirmations contestées

- **« Les langages typés ont moins de bugs (Ray et al. 2014). »** Contesté. La réplication de Berger et al. ne retrouve d'association significative que pour 4 langages, avec un effet « exceedingly small ». Les données « TypeScript » de l'étude d'origine mélangeaient des fichiers de traduction XML (25 projets sur 41 n'étaient pas du TypeScript).
- **« TypeScript attrape la plupart des bugs. »** Faux d'après la seule mesure lue : environ 15 % des bugs publics. Les erreurs de spécification, invisibles au typage, dominent les bugs non détectés.
- **« Une bonne couverture prouve une bonne suite de tests. »** Contredit par Inozemtseva & Holmes (Java, mutation) : la couverture repère les zones non testées mais « should not be used as a quality target ».
- **« Le testing trophy est une règle empirique. »** Non : l'article ne cite aucune étude. L'auteur s'appuie sur son expérience et cite lui-même une mise en garde contre la prétention scientifique des préceptes de test.
- **« Un test instable, on relance. »** Chez Google (2016), 84 % des passages vert vers rouge impliquaient un test instable, et les vraies défaillances finissaient ignorées. Relancer masque le problème.
- **« Une error boundary rattrape toutes les erreurs React. »** Faux : ni gestionnaires d'événements, ni code asynchrone, ni SSR, ni la boundary elle-même. Dans Next.js, `error.tsx` ne couvre pas le layout de son propre segment.
- **« React protège de toutes les XSS. »** Faux : `dangerouslySetInnerHTML`, les URL contrôlées par l'utilisateur (seul `javascript:` est neutralisé dans le code actuel de React) et les écritures DOM directes restent des points d'entrée.
- **« Une CSP avec une liste de domaines de confiance protège contre la XSS. »** 94,72 % des politiques distinctes étaient contournables (2016). Il faut un nonce ou un hachage, avec `strict-dynamic`. À noter : l'exemple « Without Nonces » de la doc Next.js contient `'unsafe-inline'` et n'est donc pas une CSP stricte.
- **« Un cookie `HttpOnly` rend la XSS inoffensive. »** OWASP : il ne protège que la confidentialité du cookie. Une XSS peut toujours émettre des requêtes authentifiées pendant la session.
- **« Un paquet avec provenance est sûr. »** npm écrit le contraire : « it does not guarantee the package has no malicious code ».
- **« Les versions malveillantes sont retirées en moins d'une heure. »** Affirmation de la doc pnpm, sans source sur la page lue. À ne pas citer comme un fait mesuré.
- **« Une dépendance compromise ne touche que la machine de build. »** L'avis sur debug@4.4.2 dit le contraire : la charge visait le navigateur, et l'avis demande de supprimer `node_modules` puis de réinstaller.

---

## Non vérifié

- **Abdalkareem et al. 2017, « Why Do Developers Use Trivial Packages? An Empirical Case Study on npm » (FSE 2017)** : PDF introuvable (lien de l'auteur et miroir hors service, page de l'auteur en 404). Le chiffre de 16,8 % de « trivial packages » vient d'un résumé de moteur de recherche : non vérifié.
- **Liste complète des paquets compromis le 08.09.2025** (`chalk`, `ansi-styles`, `strip-ansi`, `supports-color`, etc.) et volumes de téléchargement (« 2 à 2,6 milliards par semaine ») : seuls la presse et des éditeurs les donnent. Seul l'avis GitHub sur `debug` a été lu. Aucun avis GHSA sur `chalk` pour cet incident n'a été trouvé.
- **Ampleur de Shai-Hulud 2.0** (environ 800 paquets, 25 000 dépôts selon la presse) : non vérifiée sur source primaire. Seuls la date du 24.11.2025 et le mécanisme `preinstall` sont confirmés (avis GitLab GMS-2025-611).
- **Ray et al. 2014 (article original)** : non ouvert. Sa conclusion n'est connue que par la réplication de Berger et al. La publication de Berger et al. dans TOPLAS (2019) n'est pas confirmée dans le texte arXiv lu.
- **Micco 2017** (seconde présentation sur les tests instables chez Google) : non ouverte.
- **Recherche empirique sur la régression visuelle** (efficacité, taux de faux positifs) : aucune source primaire trouvée. Seule la doc Playwright a été lue.
- **Version publiée de React à partir de laquelle `javascript:` est bloqué** (et non plus seulement signalé) : seul le code de la branche `main` a été lu. Aucune note de version officielle confirmée.
- **Détail par navigateur du support de Trusted Types** : seul le bandeau Baseline de MDN (« Since February 2026 ») a été lu.
- **Versions d'introduction** de `min-release-age` (npm), `minimumReleaseAge` et du blocage des scripts par défaut (pnpm) : non vérifiées. Les pages lues ne les donnent pas.
- **Équivalent `VITE_*` de l'exposition des variables au bundle** : non vérifié ici (principe supposé analogue, à confirmer dans la doc Vite).
- **Seuil de 30 KB gzippé par dépendance** : aucune source trouvée.

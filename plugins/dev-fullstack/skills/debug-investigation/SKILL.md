---
name: debug-investigation
description: "Investigation structurée d'un bug : reproduction minimale, isolation, hypothèses falsifiables, instrumentation ciblée, root cause vérifiée, test de non-régression. Déclencheurs : un dysfonctionnement sous n'importe quelle forme (ça plante, marche en dev pas en prod), intermittence, race condition, régression, ou un stack trace soumis. Pas pour : review pré-merge (sub-agent `reviewer`), audit perf (`perf-audit`), audit sécurité (sub-agent `securite`)."
---

> Version 1.0 — 21.05.2026 (création ; entré au repo le 26.05.2026 ; ligne de version ajoutée le 12.06.2026, audit dev-fullstack).

# debug-investigation — Investigation structurée de bug

> Ce skill répond à la tentation de "patcher pour voir si ça passe". Un bug non compris reviendra. Ce skill force à comprendre AVANT de fixer.

## Principe directeur

**Pas de fix avant root cause vérifiée.** Une fois la root cause comprise, le fix est souvent évident — souvent une ligne. Le coût est dans la compréhension, pas dans le code.

## Périmètre

### Couvert
- Investigation structurée d'un bug observable.
- Reproduction minimale et isolement.
- Formulation d'hypothèses falsifiables, instrumentation pour les valider/réfuter.
- Identification de la root cause vraie (pas un symptôme intermédiaire).
- Test de non-régression couvrant le cas qui a échappé.
- Documentation post-mortem courte (cause / fix / prévention).

### Hors-scope
- Audit préventif de code sain → les audits spécialisés du profil : `securite`, `perf-audit`, `a11y-audit`.
- Review pré-merge structurelle → sub-agent `reviewer`.
- Audit performance → `perf-audit`.
- Audit sécurité → sub-agent `securite`.
- Refactoring large déclenché par le bug → cadrage par `architecte` en sortie.

## Workflow (6 phases)

### Phase 0 — Brief obligatoire

Avant toute action, formuler en 5 lignes max :
1. **Symptôme observable** : qu'est-ce qui se passe concrètement ? (pas « ça marche pas »)
2. **Conditions** : quand ça se produit ? quand ça ne se produit pas ?
3. **Environnement** : dev / prod, navigateur, OS, build version.
4. **Reproduction** : étape par étape (ou « non reproductible » explicite).
5. **Hypothèses initiales** : 2-3 pistes, classées de plus probable à moins.

Si une dimension manque (notamment 1 ou 4), poser **une seule question groupée** à l'utilisateur avant de continuer. Sinon Phase 1.

### Phase 1 — Reproduction minimale

Objectif : obtenir un cas qui échoue de manière fiable, le plus petit possible.

1. Reproduire le bug tel quel (1 essai).
2. Réduire l'environnement : retirer ce qui n'est pas nécessaire (dépendances, props, données).
3. Documenter la **séquence exacte** qui déclenche : entrées, clics, état préalable.
4. **Critère d'arrêt** : tu sais reproduire à 100% en moins de 30 secondes.

Si non reproductible :
- Hypothèse : timing, ordre d'événement, état partagé, données spécifiques.
- Instrumenter pour capturer le contexte au moment du bug (logs, screenshots, dumps d'état).
- Attendre une 2e occurrence avec instrumentation active.

### Phase 2 — Lecture obligatoire (HARD GATE)

Lire avant d'émettre la moindre hypothèse :

1. Le code de la fonction / composant / handler qui échoue.
2. Les **callers** immédiats (qui invoque ce code ?).
3. Les **callees** immédiats (qu'est-ce que ce code invoque ?).
4. Le **state global** pertinent (Zustand store, React context, query cache).
5. Les **logs réels** : console navigateur, logs Vercel, logs Supabase, network tab.
6. L'historique git récent sur les fichiers concernés (`git log -p <file>` 5 derniers commits).

**Anti-pattern absolu** : émettre une hypothèse en se basant sur le nom de la fonction sans avoir lu son code.

### Phase 3 — Hypothèses falsifiables

Pour chaque hypothèse, écrire :
- **Affirmation** : « le bug vient de X parce que Y ».
- **Test de falsification** : « si je fais Z, ma hypothèse est FAUSSE ».
- **Priorité** : haute / moyenne / basse selon coût de test × probabilité.

Tester les hypothèses dans l'ordre du coût croissant. Une hypothèse non testable n'est pas une hypothèse, c'est une croyance.

**Patterns d'hypothèses fréquents** :
- Stale closure (React useEffect / useCallback avec deps manquantes).
- Race condition (deux requêtes concurrentes, ordre non garanti).
- State pas mis à jour (mutation sans setState, ref vs state confusion).
- Hydration mismatch (Server vs Client diverge).
- Cache stale (React Query, SWR, ou cache navigateur).
- Timezone / date (UTC vs local).
- Null/undefined dans un chemin pas géré.
- Type runtime ≠ type compile (input externe non validé).
- RLS Supabase qui bloque silencieusement.
- Off-by-one, regex qui ne couvre pas tous les cas.
- Variable d'env manquante en prod.

### Phase 4 — Instrumentation ciblée

Quand la lecture seule ne suffit pas, instrumenter :
- `console.log` avec **contexte explicite** (pas juste la valeur, le chemin d'exécution).
- Logs structurés : `[component][action] state={...} props={...}`.
- Breakpoints si dispo (DevTools, Node inspector).
- Snapshot d'état avant/après l'opération suspecte.

**Règle** : pas de log permanent. Toute instrumentation est **temporaire** et retirée en Phase 6.

### Phase 5 — Root cause vérifiée

Une root cause valide remplit ces critères :
1. **Explique l'observation** : tous les symptômes découlent logiquement de la cause.
2. **Explique les non-symptômes** : si X est la cause, pourquoi Y (cas similaire) ne déclenche-t-il PAS le bug ?
3. **Prédictive** : « si je modifie tel paramètre, le bug doit disparaître » → vérifié.
4. **Au bon niveau** : un symptôme intermédiaire n'est pas une root cause.

**Test ultime** : si tu peux énoncer la cause en une phrase et qu'elle satisfait les 4 critères, c'est bon. Sinon, continuer.

### Phase 6 — Fix + test de non-régression

1. **Fix minimal** : modifier le moins de code possible pour adresser la cause.
2. **Test de non-régression** : un test (unit ou e2e) qui aurait échoué avant le fix et passe après. Sinon, le bug reviendra.
3. **Retirer toute instrumentation temporaire** (logs, breakpoints).
4. **Documenter** : court paragraphe `cause / fix / prévention` dans le commit ou un fichier `docs/POSTMORTEM-<date>-<slug>.md` si le bug a touché la prod.

## Garde-fous (règles dures)

- Aucun fix avant root cause vérifiée (les 4 critères Phase 5).
- Aucune hypothèse émise sans lecture du code (Phase 2 HARD GATE).
- Aucune affirmation sur le comportement runtime sans l'avoir observé (logs réels ou reproduction).
- Tout fix est accompagné d'un test de non-régression.
- Toute instrumentation temporaire est retirée à la livraison.
- Si la root cause révèle un pattern systémique → signaler à l'orchestrateur (peut nécessiter un cadrage `architecte`).

## Anti-patterns interdits

- **Patch chance** : « j'ajoute un `?.` pour voir si ça passe » sans comprendre pourquoi c'est null.
- **Try-catch silencieux pour faire taire l'erreur** sans comprendre ce qu'elle dit.
- **Augmenter un timeout** sans comprendre pourquoi l'opération est lente.
- **Désactiver un test qui échoue** sans comprendre pourquoi.
- **Logs permanents en prod** (« on garde au cas où ») — bruit + risque PII.
- **"Ça marche maintenant, je sais pas pourquoi"** — c'est exactement le bug qui reviendra.
- **Émettre une hypothèse sur le nom d'une variable** sans lire son usage.
- **Conclure depuis un seul cas de reproduction** sans vérifier 2-3 fois.

## Connaissance domaine métier (debugging React/Next/Supabase)

### Bugs React fréquents
- **Stale closure** : `useEffect(() => { fn(state); }, [])` → `state` capturé à la première render. Fix : ajouter `state` aux deps ou utiliser `useRef`.
- **Setter en boucle** : `setState` dans le render → infinite loop. React doit hurler, mais parfois silencieux via `useEffect` mal câblé.
- **Key manquante** sur liste : composants ne se remontent pas correctement → état zombi.
- **Hydration mismatch** : `Date.now()`, `Math.random()`, ou logique côté client dans un Server Component.

### Bugs Next.js fréquents
- **`'use client'` oublié** quand on utilise un hook.
- **Fetch dans Server Component pas mis en cache** (`{ cache: 'no-store' }` involontaire).
- **Params async non awaités** (Next 15+ : `params` est une Promise).
- **Env var côté client sans `NEXT_PUBLIC_`** → undefined silencieux.

### Bugs Supabase fréquents
- **RLS qui bloque sans message clair** : query renvoie `[]` au lieu d'erreur 403.
- **`service_role` sur le mauvais client** : bypass RLS involontaire en dev.
- **Realtime subscription pas désabonnée** → memory leak + events doublés.
- **RPC avec params typés JS qui échouent côté Postgres** (cast implicite raté).

### Bugs Vercel / déploiement fréquents
- **Var d'env définie en dev pas en prod**.
- **Build différent en prod** : optim Next.js qui change le comportement de Server Components.
- **Edge runtime vs Node runtime** : certaines libs marchent dans l'un pas l'autre.

## Auto-check final (avant livraison)

- Phase 0 brief formulé (symptôme + conditions + env + repro + hypothèses) ?
- Phase 1 reproduction minimale stable (ou non reproductibilité documentée) ?
- Phase 2 lecture du code, callers, callees, state, logs effectuée ?
- Phase 3 hypothèses falsifiables formulées et testées dans l'ordre ?
- Phase 5 root cause satisfait les 4 critères (explique, explique non-symptômes, prédit, bon niveau) ?
- Phase 6 fix minimal + test de non-régression présent ?
- Toute instrumentation temporaire retirée ?
- Si pattern systémique détecté → signalement vers `architecte` ?

Si une seule réponse est non → corriger avant livraison.

## Incidents source

- *(à compléter au fil des incidents — chaque bug investigué qui fait évoluer la connaissance domaine ci-dessus mérite une entrée datée).*

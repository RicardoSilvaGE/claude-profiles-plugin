# Aide-mémoire de debugging — React, Next.js, Supabase, Vercel

> Annexe de `debug-investigation`, déplacée verbatim du `SKILL.md` le 11.11.2026. À ouvrir en Phase 3, quand le projet tourne sur cette stack et que la lecture de la Phase 2 ne suffit pas à formuler des hypothèses. Sans objet sur le socle vanilla et le back Python.

> Aide-mémoire écrit à la création (21.05.2026), **ni sourcé ni daté ligne par ligne**, et limité à React, Next, Supabase et Vercel : rien sur le socle vanilla ni sur le back Python. Chaque ligne est une **piste à vérifier** sur la version installée du projet (le comportement de Next, en particulier, change d'une version majeure à l'autre), jamais un fait à affirmer. Pour un fait sourcé et daté : skill `ux-preuves`, volet code.

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

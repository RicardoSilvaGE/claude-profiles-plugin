---
name: a11y-audit
description: "Audit d'accessibilité WCAG 2.2 AA ex-post sur un composant ou une page existante : labels, focus, tab order, contraste, ARIA, lecteurs d'écran, motion. Rend un rapport priorisé Bloquant/Sérieux/Modéré/Mineur, chaque défaut avec son critère WCAG cité et un fix concret. Déclencheurs : audit a11y, WCAG, RGAA, lecteur d'écran, navigation clavier, contraste, alt text, prefers-reduced-motion. Pas pour : spécifier l'a11y d'une feature à concevoir (sub-agent `ux`), ni corriger un défaut isolé (`debug-investigation`). Toute stack web."
context: fork
agent: general-purpose
background: false
---

> Version 1.6 — 11.11.2026 (renotation : la région d'erreur du patron de formulaire existe dès le rendu initial ; message urgent en `role="alert"` seul). Versions antérieures : `CHANGELOG.md` du profil, non déployé.
> **Pas de champ `paths` sur ce skill, et c'est une décision** : il est préchargé dans `frontend`, et les
> deux mécanismes sont exclusifs (témoin du 17.08.2026). **Ne pas rajouter `paths` ici sans retirer le
> préchargement dans `agents/frontend.md`.** `context: fork` coexiste avec le préchargement (témoin du
> 19.08.2026). Motifs et mesures : `CHANGELOG.md` du profil, historique de ce skill — fichier du dépôt
> `claude-profiles`, non déployé : hors de portée depuis un home ou un plugin.

# a11y-audit — Audit d'accessibilité ex-post

> Complète le sub-agent `ux` (qui spécifie l'a11y en design) avec un audit du code livré. WCAG 2.2 AA en référence, pragmatique avant exhaustif.

## Principe directeur

**L'a11y n'est pas une checklist à cocher — c'est l'expérience d'un utilisateur réel qui ne voit pas, ne bouge pas, ou ne comprend pas comme la majorité.** Ce skill teste depuis le point de vue de cet utilisateur, pas depuis une matrice abstraite.

## Périmètre

### Couvert
- Audit a11y d'un composant ou d'une page existante.
- 4 piliers WCAG 2.2 : Perceivable, Operable, Understandable, Robust.
- Navigation clavier complète (Tab, Shift+Tab, Enter, Space, Escape, flèches).
- Focus management (visible, ordre logique, piégeage dans modale, restauration au close).
- ARIA approprié (rôles, états, propriétés) — pas l'inverse ARIA partout.
- Contraste de couleur (WCAG AA : 4.5:1 texte normal, 3:1 texte large + UI).
- Compatibilité screen reader (annonces dynamiques, structure sémantique).
- Motion et `prefers-reduced-motion`.
- Formulaires : labels associés, messages d'erreur annoncés, group fieldset.

### Hors-scope
- Spécifier l'a11y au design d'une nouvelle feature → sub-agent `ux`.
- Audit visuel / direction artistique → sub-agent `designer`.
- Audit perf → skill `perf-audit`.
- Bug a11y isolé reproduit → skill `debug-investigation`.
- Conformité légale formelle (RGAA, EN 301 549) — ce skill couvre WCAG 2.2 AA, sans certification ni déclaration de conformité (taux de recouvrement avec le RGAA : non sourcé, ne pas en avancer).

## Workflow (5 phases)

### Phase 0 — Brief obligatoire

Avant toute action, formuler en 5 lignes max :
1. **Cible** : un composant précis (chemin du fichier) ou une page (route) ?
2. **Contexte d'usage** : interface publique / outil métier interne / formulaire critique (auth, paiement) ?
3. **Niveau cible** : WCAG AA par défaut. AAA si justifié (santé, gov, éducation).
4. **Audit existant ?** : a-t-on déjà fait un passage axe-core / Lighthouse ?
5. **Question ouverte unique** : un seul arbitrage non documenté, si applicable.

Ce skill tourne en contexte isolé (`context: fork`) : il ne dialogue pas avec l'utilisateur. Si la cible est floue, **ne pas poser la question en route** : retenir l'hypothèse la plus plausible, l'écrire dans le brief, auditer sur cette base, et rendre **une seule question groupée** dans la section « Questions et tests rendus à l'orchestrateur » du rapport. Si aucune hypothèse ne tient (cible introuvable), rendre la question seule, sans audit.

### Phase 1 — Lecture obligatoire (HARD GATE)

Lire systématiquement :

1. Le code du composant / de la page cible.
2. Les composants UI primitifs utilisés (shadcn customisé : `<Button>`, `<Dialog>`, `<Form>`, etc.).
3. Le `CLAUDE.md` projet (conventions a11y, primitives a11y disponibles).
4. Les tokens de design relatifs au contraste : `tokens.css`, `tailwind.config`.
5. Si tests dispo : tests Playwright / Cypress qui couvrent les parcours clavier.

Ne pas auditer un composant sans avoir lu ses dépendances (un `<Dialog>` shadcn par défaut a déjà du focus management — vérifier qu'il n'a pas été cassé par customisation).

### Phase 2 — Audit par pilier

Parcourir les 4 piliers WCAG. Pour chaque critère, OK ou finding.

**Sur un dépôt sans bundler ni shadcn** (sept dépôts sur huit, mesure du 25.08.2026) : les quatre
piliers s'appliquent **tels quels** — WCAG ne dépend pas de la stack. Seules les recettes changent :
`focus-visible:` de Tailwind devient `:focus-visible` en CSS, `<Image>` devient `<img>` avec
`width`/`height`, un composant shadcn devient l'élément natif qu'il enveloppe. Ne jamais conclure
« non applicable » sur un critère parce que l'outil cité dans la recette manque.

**Sources.** Les seuils ci-dessous sont récités sans source ; leurs versions sourcées et datées sont
dans le skill `ux-preuves`, `references/frontend-accessibilite-code.md` (ARIA, régions live, focus),
`design-couleur-contraste.md` (contraste), `contenus-documents-accessibilite.md` (WCAG 2.2, RGAA) et
`formulaires-navigation-mobile.md` (taille de cible, authentification), `design-typographie-mise-en-page.md` (zoom, reflow). En cas d'écart, la fiche
sourcée fait foi.

**Pilier 1 — Perceivable** (l'info doit être perceptible)
- **Images** : `alt` présent et descriptif (vide si décorative `alt=""`).
- **Icônes interactives** : `aria-label` ou texte visible (un `<Button><X /></Button>` sans label est un échec).
- **Contraste** : texte normal ≥ 4.5:1 vs fond. Texte large (≥ 18pt ou 14pt bold) ≥ 3:1. UI controls et focus rings ≥ 3:1.
- **Couleur non porteuse seule d'info** : pas « les champs en rouge sont obligatoires » sans texte / icône / symbole.
- **Structure sémantique** : `<h1>` unique, hiérarchie sans saut (h1 → h2 → h3, pas h1 → h3).
- **Landmarks** : `<header>`, `<nav>`, `<main>`, `<footer>` présents.

**Pilier 2 — Operable** (tout doit être atteignable et opérable)
- **Navigation clavier intégrale** : Tab parcourt tout interactif, dans l'ordre visuel.
- **Focus visible** : `focus-visible:` styled, contraste ≥ 3:1 vs fond adjacent.
- **Pas de keyboard trap** : Escape ferme modale, Tab ne piège pas.
- **Skip links** : `<a href="#main">Aller au contenu</a>` en début de page si nav longue.
- **Targets de clic** : ≥ 24x24 px (WCAG 2.2). Idéal 44x44 sur mobile.
- **Pas de timeout sans extension possible** sur action critique (sauf justification).
- **Pas de flash** > 3 par seconde.
- **Autres critères A/AA ajoutés par WCAG 2.2**, à parcourir aussi : 2.4.11 Focus Not Obscured (Minimum), 2.5.7 Dragging Movements, 3.2.6 Consistent Help, 3.3.7 Redundant Entry, 3.3.8 Accessible Authentication (Minimum) — liste lue dans `ux-preuves/references/contenus-documents-accessibilite.md` (§ « Viser WCAG 2.2 niveau AA […] », l. 181-185) ; le contenu de chaque critère se lit à sa source, pas ici.

**Pilier 3 — Understandable** (l'interface doit être compréhensible)
- **Labels associés** : `<label for="X">` ou `aria-labelledby`, pas `placeholder` seul.
- **Erreurs claires** : message indique quoi corriger ET comment. Annoncé aux SR (live region).
- **Pas de changement de contexte automatique** au focus / changement d'input.
- **Cohérence** : mêmes patterns à travers l'app (un bouton "Annuler" est toujours à gauche, ou toujours à droite).
- **`lang` attribut** sur `<html>` (et `lang` local si segment dans une autre langue).

**Pilier 4 — Robust** (compatible avec les outils d'assistance)
- **4.1.1 Parsing n'est plus un critère** : retiré de WCAG 2.2 (`ux-preuves/references/contenus-documents-accessibilite.md` l. 184 : « WCAG 2.2 has removed one success criterion, 4.1.1 Parsing » ; rappelé dans `frontend-accessibilite-code.md` l. 316). Ne pas lever de finding « HTML invalide » ou « ID dupliqué » à ce titre ; un ID dupliqué ne se relève que s'il casse un nom ou une relation accessible (`for`, `aria-labelledby`, `aria-describedby`), sous le critère réellement touché.
- **ARIA approprié** : rôle / état / propriété correspond au comportement. Première règle ARIA : **ne pas utiliser ARIA si HTML natif suffit**.
- **`<button>` vs `<div onClick>`** : bouton natif sauf raison forte.
- **Status messages** : `aria-live="polite"` (info) ou `role="alert"` seul (urgent, patron plus bas) sur container qui change dynamiquement.

### Phase 3 — Tests pratiques

Ne pas se contenter de lire le code. Exécuter ce que les outils de la session permettent ; tout test qui exige un navigateur réel, un lecteur d'écran ou un réglage de l'OS **n'est pas demandé en route** (contexte isolé) : il est rendu dans le rapport, section « Questions et tests rendus à l'orchestrateur », avec l'outil, les étapes et le résultat attendu, à charge de l'orchestrateur de le faire lancer par l'utilisateur.

1. **Navigation clavier intégrale** : depuis le haut de la page, Tab jusqu'au bas. Tout est-il atteint ? L'ordre est-il logique ?
2. **Test screen reader** : VoiceOver (Mac) ou NVDA (Windows). Au moins :
   - Annonce du titre de page au chargement.
   - Annonce du focus quand on Tab.
   - Annonce des erreurs de formulaire.
3. **Test contraste** : extension `axe DevTools` ou outil colorimétrique sur les pairs texte/fond suspects.
4. **`prefers-reduced-motion`** : activer dans l'OS, recharger, vérifier que les animations sont désactivées ou réduites.
5. **Zoom 200%** (1.4.4 Resize Text) : texte agrandi à 200 % sans perte de contenu ni de fonction (ni rognage, ni chevauchement). L'absence de défilement horizontal est un **autre** critère, 1.4.10 Reflow, qui se teste à 320 px CSS de large, hors contenus réellement bidimensionnels (`ux-preuves/references/design-typographie-mise-en-page.md` l. 83-95).

Un test non exécuté reste coché « non fait » dans le rapport : jamais « OK » sur lecture du code.

### Phase 4 — Priorisation + livrable

Chaque finding reçoit :
- **Sévérité** :
  - **BLOQUANT** : empêche un utilisateur d'utiliser la feature (ex: input sans label, bouton sans nom accessible, navigation clavier impossible).
  - **SÉRIEUX** : dégrade fortement l'usage (ex: contraste insuffisant, ordre tab illogique, focus invisible).
  - **MODÉRÉ** : cause de friction (ex: target trop petit, message d'erreur peu clair).
  - **MINEUR** : amélioration recommandée (ex: skip link manquant sur petite page).
- **Critère WCAG cité** : ex « WCAG 2.2 — 1.4.3 Contrast (Minimum) ».
- **Fix concret** : code à modifier, ligne précise.
- **Vérification post-fix** : comment confirmer (test clavier, axe, screen reader).

Livrable structuré, rendu **comme retour du skill** à l'orchestrateur (contexte isolé) ; aucun fichier n'est écrit dans le dépôt audité sauf demande explicite :

```
# Audit a11y — <composant ou page> — <date>

## Phase 0 — Brief
- Cible : ...
- Contexte d'usage : ...
- Niveau : WCAG AA / AAA

## Phase 1 — Sources lues
- ...

## Findings (par sévérité)

### BLOQUANT
- **<ID>** — <pilier> — <fichier:ligne>
  - WCAG : <critère>
  - Problème : <description>
  - Fix : <code ou action>
  - Vérification : <test à refaire>

### SÉRIEUX
- ...

### MODÉRÉ
- ...

### MINEUR
- ...

## Tests effectués
- [ ] Navigation clavier intégrale
- [ ] Screen reader (VoiceOver / NVDA)
- [ ] Contraste (axe DevTools)
- [ ] Zoom 200% (1.4.4) et reflow à 320 px (1.4.10)
- [ ] `prefers-reduced-motion`

## Questions et tests rendus à l'orchestrateur
- Question (une seule, groupée) : <arbitrage non documenté, et l'hypothèse retenue en attendant>
- Test à faire lancer : <outil> — <étapes> — <résultat attendu> — <finding qu'il confirme ou lève>

## Plan de remédiation
1. <BLOQUANT 1>
2. <BLOQUANT 2>
3. ...
```

## Garde-fous (règles dures)

- Tout `<input>` a un `<label>` associé. `placeholder` seul = BLOQUANT.
- Tout `<button>` interactif sans texte visible a un `aria-label` ou `aria-labelledby`.
- Toute modale doit : trap focus, restaurer focus à la fermeture, fermer sur Escape, avoir un titre lu par SR.
- Tout `onClick` sur `<div>` doit avoir `role="button"` + `tabindex="0"` + handler clavier. Préférer `<button>` natif.
- Tout finding cite un critère WCAG.
- Aucune affirmation de conformité sans test pratique (clavier ou SR), pas juste lecture statique.

## Anti-patterns interdits

- **`placeholder` au lieu de `<label>`** : disparaît au focus, contraste souvent insuffisant.
- **`<div onClick={...}>` sans rôle ni clavier** : invisible aux SR, inopérable au clavier.
- **`aria-label` redondant** sur élément qui a déjà un texte visible.
- **`role="button"` sur `<button>`** : déjà bouton, ARIA redondant.
- **`tabindex` positif** (> 0) : casse l'ordre naturel.
- **Animations CSS qui ignorent `prefers-reduced-motion`**.
- **Couleur seule pour indiquer un état** (rouge = erreur sans icône / texte).
- **Toast d'erreur qui disparaît en 2s** : illisible pour SR ou lecture lente.
- **Modale sans focus trap** : Tab sort vers le contenu derrière.
- **`autofocus` mal placé** : focus sur un champ avant que le SR ait annoncé la page.

## Connaissance domaine métier (a11y React + shadcn + Next.js)

### Composants shadcn — état par défaut
- `<Dialog>` (Radix) : focus trap intégré, Escape close, restoration focus. **Ne pas casser** en customisant.
- `<Select>` (Radix) : navigation clavier complète (flèches, première lettre).
- `<Tabs>` (Radix) : flèches gauche/droite pour changer d'onglet.
- `<Tooltip>` (Radix) : trigger au focus aussi (pas que hover) — à vérifier après customisation.

### Pattern annonce dynamique
```jsx
// Pour annoncer un message après action
<div role="status" aria-live="polite" aria-atomic="true">
  {message}
</div>

// Pour erreurs urgentes : role="alert" seul
<div role="alert">
  {error}
</div>
```
Source : `ux-preuves/references/frontend-accessibilite-code.md` l. 156-161 (MDN). `role="alert"` équivaut déjà à `aria-live="assertive"` + `aria-atomic="true"`, et cumuler les deux provoque une double lecture sous VoiceOver iOS ; pour `role="status"`, le `aria-live="polite"` redondant est au contraire conseillé par MDN pour la compatibilité — seule exception à l'anti-pattern « ARIA redondant » ci-dessus.

### Pattern formulaire accessible (react-hook-form + Zod)
```jsx
<label htmlFor="email">Email</label>
<input
  id="email"
  type="email"
  {...register('email')}
  aria-invalid={!!errors.email}
  aria-describedby={errors.email ? 'email-error' : undefined}
/>
{/* Région présente dès le rendu initial, vide sans erreur : née avec son contenu, elle n'est pas
    toujours annoncée (ux-preuves/references/frontend-accessibilite-code.md l. 150-154) */}
<p id="email-error" role="alert" className="text-red-600">
  {errors.email?.message}
</p>
```

### Pattern skip link (Next.js App Router)
Dans `app/layout.tsx`, avant `<main>` :
```jsx
<a
  href="#main-content"
  className="sr-only focus:not-sr-only focus:absolute focus:top-2 focus:left-2 ..."
>
  Aller au contenu principal
</a>
<main id="main-content">{children}</main>
```

### Outils
- **axe DevTools** : extension Chrome/Firefox, audit auto.
- **Lighthouse a11y** : DevTools, score + recommandations.
- **WebAIM Contrast Checker** : couleur par couleur.
- **VoiceOver** (Mac, Cmd+F5) : screen reader natif.
- **NVDA** (Windows, gratuit) : screen reader.
- **eslint-plugin-jsx-a11y** : lint à l'écriture.

### Critères WCAG les plus violés
- 1.1.1 Non-text Content (alt manquant)
- 1.3.1 Info and Relationships (structure sémantique)
- 1.4.3 Contrast (Minimum)
- 2.1.1 Keyboard (opérable au clavier)
- 2.4.7 Focus Visible
- 3.3.1 Error Identification
- 3.3.2 Labels or Instructions
- 4.1.2 Name, Role, Value (rôle / nom accessible)

## Auto-check final (avant livraison)

- Phase 0 brief formulé (cible + contexte d'usage + niveau cible) ?
- Phase 1 lecture du composant + primitives + tokens contraste ?
- Phase 2 4 piliers WCAG parcourus systématiquement ?
- Phase 3 tests pratiques effectués (clavier + SR + contraste + reduced-motion + zoom 200%) ou rendus « à faire » dans le rapport, avec outil et étapes ?
- Chaque finding cite un critère WCAG ?
- Chaque finding a un fix concret + vérification post-fix ?
- Aucune affirmation de conformité sans test pratique ?
- Plan de remédiation ordonné BLOQUANT → SÉRIEUX → MODÉRÉ → MINEUR ?

Si une seule réponse est non → corriger avant livraison.

## Incidents source

- *(à compléter au fil des audits — chaque pattern récurrent détecté mérite une entrée dans la connaissance domaine).*

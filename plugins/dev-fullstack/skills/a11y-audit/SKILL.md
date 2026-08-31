---
name: a11y-audit
description: "Audit d'accessibilité WCAG 2.2 AA ex-post sur un composant ou une page existante : labels, focus, tab order, contraste, ARIA, lecteurs d'écran, motion. Rend un rapport priorisé Bloquant/Sérieux/Modéré/Mineur, chaque défaut avec son critère WCAG cité et un fix concret. Déclencheurs : audit a11y, WCAG, RGAA, lecteur d'écran, navigation clavier, contraste, alt text, prefers-reduced-motion. Pas pour : spécifier l'a11y d'une feature à concevoir (sub-agent `ux`), ni corriger un défaut isolé (`debug-investigation`). Stack React + Next.js + shadcn."
context: fork
agent: general-purpose
background: false
---

> Version 1.3 — 19.08.2026 (**`context: fork` appliqué, après que le témoin a levé la réserve
> posée quelques heures plus tôt en v1.2.** La v1.2 refusait ce champ par analogie avec
> l'exclusion `paths` ↔ préchargement : ce skill étant préchargé dans `frontend`, un fork y
> aurait fait un sous-agent lancé depuis un sous-agent, et rien n'établissait que ce soit permis.
> **Le protocole que la v1.2 décrivait a été exécuté le jour même, et il a dit l'inverse.** Deux
> mesures, chacune avec son témoin de contrôle :
> 1. **Le préchargement n'est pas affecté.** Deux skills témoins identiques au seul `context:
>    fork` près, marqueurs non devinables, préchargés dans un même agent : **les deux marqueurs
>    arrivent**. Contrairement à `paths`, `context` n'empêche pas le préchargement.
> 2. **Un fork imbriqué fonctionne.** Un second témoin, dont la doctrine *est* la tâche, a
>    invoqué depuis un sous-agent un skill portant `context: fork` : `RESULTAT=REUSSI`, un appel
>    d'outil, aucune erreur.
> **Trois pièges de banc rencontrés, et gardés parce qu'ils se reproduiront** : (a) un témoin dont
> le contrôle échoue aussi accuse le banc, pas la fonctionnalité — les deux premiers essais
> rendaient `ABSENT` sur le skill témoin *sans* `context`, ce qui invalidait la mesure ;
> (b) `--agent X -p` lance l'agent en **session principale**, pas en sous-agent, et le
> préchargement ne s'y observe pas — il faut le faire **invoquer** depuis une session ;
> (c) le premier agent témoin a répondu selon **sa propre description** au lieu de la consigne
> transmise, ce qui a nécessité un second témoin dédié. Un agent doctriné ne se teste pas
> lui-même.
> **Conséquence pratique** : le préchargement dans `frontend` continue d'opérer — la v1.1 reste
> entièrement valable — et une invocation directe depuis la conversation principale s'exécute
> désormais en fork, comme `perf-audit`.)
> Version 1.1 — 17.08.2026 (**pas de champ `paths` sur ce skill, et c'est une décision, pas un oubli.** Il en a porté un pendant une heure, borné aux fichiers de balisage et de style, avant d'être retiré : ce skill est **préchargé** dans le sub-agent `frontend` (frontmatter `skills:`), et les deux mécanismes sont **exclusifs**. Un skill portant `paths` n'est pas préchargeable — vérifié par témoin isolé le 17.08.2026, deux skills identiques au seul `paths` près, le préchargement ne passe que sans lui. Ce n'est écrit dans aucune documentation officielle : la seule contrainte de préchargement qui y figure est `disable-model-invocation`. Arbitrage retenu : le préchargement l'emporte, parce qu'il traite le problème documenté par incident — un sub-agent démarre sur un contexte vierge et n'ira pas chercher le skill de lui-même — là où `paths` n'économisait que ~280 tokens. **Ne pas rajouter `paths` ici sans retirer le préchargement dans `agents/frontend.md`.**)
> Version 1.0 — 21.05.2026 (création ; entré au repo le 26.05.2026 ; ligne de version ajoutée le 12.06.2026, audit dev-fullstack).

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
- Conformité légale formelle (RGAA, EN 301 549) — ce skill couvre WCAG 2.2 AA, équivalent ~95% RGAA mais sans certification.

## Workflow (5 phases)

### Phase 0 — Brief obligatoire

Avant toute action, formuler en 5 lignes max :
1. **Cible** : un composant précis (chemin du fichier) ou une page (route) ?
2. **Contexte d'usage** : interface publique / outil métier interne / formulaire critique (auth, paiement) ?
3. **Niveau cible** : WCAG AA par défaut. AAA si justifié (santé, gov, éducation).
4. **Audit existant ?** : a-t-on déjà fait un passage axe-core / Lighthouse ?
5. **Question ouverte unique** : un seul arbitrage non documenté, si applicable.

Si la cible est floue, poser **une seule question groupée** avant de continuer.

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

**Pilier 3 — Understandable** (l'interface doit être compréhensible)
- **Labels associés** : `<label for="X">` ou `aria-labelledby`, pas `placeholder` seul.
- **Erreurs claires** : message indique quoi corriger ET comment. Annoncé aux SR (live region).
- **Pas de changement de contexte automatique** au focus / changement d'input.
- **Cohérence** : mêmes patterns à travers l'app (un bouton "Annuler" est toujours à gauche, ou toujours à droite).
- **`lang` attribut** sur `<html>` (et `lang` local si segment dans une autre langue).

**Pilier 4 — Robust** (compatible avec les outils d'assistance)
- **HTML valide** : pas de duplicate IDs, balises imbriquées correctement.
- **ARIA approprié** : rôle / état / propriété correspond au comportement. Première règle ARIA : **ne pas utiliser ARIA si HTML natif suffit**.
- **`<button>` vs `<div onClick>`** : bouton natif sauf raison forte.
- **Status messages** : `aria-live="polite"` (info) ou `aria-live="assertive"` (urgent) sur container qui change dynamiquement.

### Phase 3 — Tests pratiques

Ne pas se contenter de lire le code. Exécuter (ou demander à l'utilisateur d'exécuter) :

1. **Navigation clavier intégrale** : depuis le haut de la page, Tab jusqu'au bas. Tout est-il atteint ? L'ordre est-il logique ?
2. **Test screen reader** : VoiceOver (Mac) ou NVDA (Windows). Au moins :
   - Annonce du titre de page au chargement.
   - Annonce du focus quand on Tab.
   - Annonce des erreurs de formulaire.
3. **Test contraste** : extension `axe DevTools` ou outil colorimétrique sur les pairs texte/fond suspects.
4. **`prefers-reduced-motion`** : activer dans l'OS, recharger, vérifier que les animations sont désactivées ou réduites.
5. **Zoom 200%** : la page reste utilisable sans scroll horizontal.

Si certains tests ne peuvent pas être faits côté skill (besoin du navigateur réel), donner la commande / l'outil à utiliser.

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

Livrable structuré :

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
- [ ] Zoom 200%
- [ ] `prefers-reduced-motion`

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

// Pour erreurs urgentes
<div role="alert" aria-live="assertive">
  {error}
</div>
```

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
{errors.email && (
  <p id="email-error" role="alert" className="text-red-600">
    {errors.email.message}
  </p>
)}
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
- Phase 3 tests pratiques effectués (clavier + SR + contraste + reduced-motion + zoom 200%) ou commandés à l'utilisateur ?
- Chaque finding cite un critère WCAG ?
- Chaque finding a un fix concret + vérification post-fix ?
- Aucune affirmation de conformité sans test pratique ?
- Plan de remédiation ordonné BLOQUANT → SÉRIEUX → MODÉRÉ → MINEUR ?

Si une seule réponse est non → corriger avant livraison.

## Incidents source

- *(à compléter au fil des audits — chaque pattern récurrent détecté mérite une entrée dans la connaissance domaine).*

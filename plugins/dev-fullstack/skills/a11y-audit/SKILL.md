---
name: a11y-audit
description: "Audit d'accessibilité WCAG 2.2 AA ex-post sur un composant ou une page existante : labels, focus, contraste, ARIA, motion. Rend un rapport priorisé Bloquant/Sérieux/Modéré/Mineur, critère WCAG et fix par défaut. Déclencheurs : audit a11y, WCAG, lecteur d'écran, navigation clavier, contraste, alt text, prefers-reduced-motion. Pas pour : spécifier l'a11y d'une feature (`ux`), l'audit visuel (`designer`), sourcer un seuil (`ux-preuves`), certifier une conformité RGAA, un défaut isolé (`debug-investigation`). Toute stack web."
context: fork
agent: general-purpose
background: false
---

> Version 1.7 — 11.11.2026 (cure de poids : patrons de code et outils en annexe, redites retirées, les deux lectures du skill dites). Versions antérieures : `CHANGELOG.md` du profil, non déployé.
> **Pas de champ `paths`, et c'est une décision** : ce skill est préchargé dans `frontend`, et les deux mécanismes sont exclusifs. Ne pas en rajouter sans retirer le préchargement dans `agents/frontend.md`.

# a11y-audit — Audit d'accessibilité ex-post

> Complète le sub-agent `ux` (qui spécifie l'a11y en design) avec un audit du code livré. WCAG 2.2 AA en référence, pragmatique avant exhaustif.

## Principe directeur

**L'a11y n'est pas une checklist à cocher — c'est l'expérience d'un utilisateur réel qui ne voit pas, ne bouge pas, ou ne comprend pas comme la majorité.** Ce skill teste depuis le point de vue de cet utilisateur, pas depuis une matrice abstraite.

## Deux lectures de ce skill

- **Invoqué comme skill**, il tourne en contexte isolé (`context: fork`) : il ne dialogue pas avec l'utilisateur, et son rapport est son retour à l'orchestrateur.
- **Préchargé dans le sous-agent `frontend`**, il est lu sans fork, comme une méthode : l'agent l'applique quand il audite ou corrige, et rend le rapport dans son propre hand-off. Un sous-agent ne dialogue pas davantage.

Dans les deux cas : aucune question ni demande de test posée en route ; elles sont **rendues** dans la section « Questions et tests rendus à l'orchestrateur » du rapport.

## Périmètre

### Couvert
- Audit a11y d'un composant ou d'une page existante, sur les 4 piliers WCAG 2.2 (détail en Phase 2) : clavier, focus, ARIA, contraste, lecteurs d'écran, motion, formulaires.

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

Si la cible est floue : retenir l'hypothèse la plus plausible, l'écrire dans le brief, auditer sur cette base, et rendre **une seule question groupée** dans le rapport. Si aucune hypothèse ne tient (cible introuvable), rendre la question seule, sans audit.

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
- **Icônes interactives** : `aria-label`, `aria-labelledby` ou texte visible (un `<Button><X /></Button>` sans label est un échec).
- **Contraste** : texte normal ≥ 4.5:1 vs fond. Texte large (≥ 18pt ou 14pt bold) ≥ 3:1. UI controls et focus rings ≥ 3:1.
- **Couleur non porteuse seule d'info** : pas « les champs en rouge sont obligatoires » ni « rouge = erreur » sans texte / icône / symbole.
- **Structure sémantique** : `<h1>` unique, hiérarchie sans saut (h1 → h2 → h3, pas h1 → h3).
- **Landmarks** : `<header>`, `<nav>`, `<main>`, `<footer>` présents.

**Pilier 2 — Operable** (tout doit être atteignable et opérable)
- **Navigation clavier intégrale** : Tab parcourt tout interactif, dans l'ordre visuel (Tab, Shift+Tab, Enter, Space, Escape, flèches) ; pas de `tabindex` positif, qui casse l'ordre naturel.
- **Focus visible** : `focus-visible:` styled, contraste ≥ 3:1 vs fond adjacent.
- **Pas de keyboard trap** : Tab ne piège pas hors modale. **Toute modale** : piège le focus (Tab ne sort pas vers le contenu derrière), le restaure à la fermeture, se ferme sur Escape, a un titre lu par SR.
- **Skip links** : `<a href="#main">Aller au contenu</a>` en début de page si nav longue.
- **Targets de clic** : ≥ 24x24 px (WCAG 2.2). Idéal 44x44 sur mobile.
- **Pas de timeout sans extension possible** sur action critique (sauf justification).
- **Pas de flash** > 3 par seconde ; les animations respectent `prefers-reduced-motion`.
- **Autres critères A/AA ajoutés par WCAG 2.2**, à parcourir aussi : 2.4.11 Focus Not Obscured (Minimum), 2.5.7 Dragging Movements, 3.2.6 Consistent Help, 3.3.7 Redundant Entry, 3.3.8 Accessible Authentication (Minimum) — liste lue dans `ux-preuves/references/contenus-documents-accessibilite.md` (§ « Viser WCAG 2.2 niveau AA […] », l. 181-185) ; le contenu de chaque critère se lit à sa source, pas ici.

**Pilier 3 — Understandable** (l'interface doit être compréhensible)
- **Labels associés** : tout `<input>` a un `<label for="X">` ou un `aria-labelledby`. `placeholder` seul = BLOQUANT (il disparaît au focus, contraste souvent insuffisant).
- **Erreurs claires** : message indique quoi corriger ET comment. Annoncé aux SR (live region). Pas de toast d'erreur qui disparaît en 2 s : illisible pour SR ou lecture lente.
- **Pas de changement de contexte automatique** au focus / changement d'input ; pas d'`autofocus` sur un champ avant que le SR ait annoncé la page.
- **Cohérence** : mêmes patterns à travers l'app (un bouton "Annuler" est toujours à gauche, ou toujours à droite).
- **`lang` attribut** sur `<html>` (et `lang` local si segment dans une autre langue).

**Pilier 4 — Robust** (compatible avec les outils d'assistance)
- **4.1.1 Parsing n'est plus un critère** : retiré de WCAG 2.2 (`ux-preuves/references/contenus-documents-accessibilite.md` l. 184 : « WCAG 2.2 has removed one success criterion, 4.1.1 Parsing » ; rappelé dans `frontend-accessibilite-code.md` l. 316). Ne pas lever de finding « HTML invalide » ou « ID dupliqué » à ce titre ; un ID dupliqué ne se relève que s'il casse un nom ou une relation accessible (`for`, `aria-labelledby`, `aria-describedby`), sous le critère réellement touché.
- **ARIA approprié** : rôle / état / propriété correspond au comportement. Première règle ARIA : **ne pas utiliser ARIA si HTML natif suffit** — pas d'`aria-label` sur un élément qui a déjà un texte visible, pas de `role="button"` sur un `<button>`.
- **`<button>` natif** sauf raison forte : un `onClick` sur `<div>` exige `role="button"` + `tabindex="0"` + handler clavier, sinon il est invisible aux SR et inopérable au clavier.
- **Status messages** : `aria-live="polite"` (info) ou `role="alert"` seul (urgent) sur container qui change dynamiquement.

Patrons de code des fixes (annonce dynamique, formulaire, skip link), état par défaut des composants shadcn et liste des critères le plus souvent en défaut (liste d'usage, **non sourcée**) : `references/patrons-et-outils.md` de ce skill, à ouvrir au moment d'écrire un fix.

### Phase 3 — Tests pratiques

Ne pas se contenter de lire le code. Exécuter ce que les outils de la session permettent ; tout test qui exige un navigateur réel, un lecteur d'écran ou un réglage de l'OS est rendu dans le rapport, avec l'outil, les étapes et le résultat attendu, à charge de l'orchestrateur de le faire lancer par l'utilisateur. Outils par test : `references/patrons-et-outils.md`, § « Outils ».

1. **Navigation clavier intégrale** : depuis le haut de la page, Tab jusqu'au bas. Tout est-il atteint ? L'ordre est-il logique ?
2. **Test screen reader** : VoiceOver (Mac) ou NVDA (Windows). Au moins :
   - Annonce du titre de page au chargement.
   - Annonce du focus quand on Tab.
   - Annonce des erreurs de formulaire.
3. **Test contraste** : extension `axe DevTools` ou outil colorimétrique sur les pairs texte/fond suspects. Formule du ratio et ses limites : `ux-preuves/references/design-couleur-contraste.md`, § « Connaître la formule WCAG 2 et ses limites ».
4. **`prefers-reduced-motion`** : activer dans l'OS, recharger, vérifier que les animations sont désactivées ou réduites.
5. **Zoom 200%** (1.4.4 Resize Text) : texte agrandi à 200 % sans perte de contenu ni de fonction (ni rognage, ni chevauchement). L'absence de défilement horizontal est un **autre** critère, 1.4.10 Reflow, qui se teste à 320 px CSS de large, hors contenus réellement bidimensionnels (`ux-preuves/references/design-typographie-mise-en-page.md` l. 83-95).

Un test non exécuté reste coché « non fait » dans le rapport : jamais « OK » sur lecture du code, et aucune affirmation de conformité sans test pratique (clavier ou SR).

### Phase 4 — Priorisation + livrable

Chaque finding reçoit :
- **Sévérité** :
  - **BLOQUANT** : empêche un utilisateur d'utiliser la feature (ex: input sans label, bouton sans nom accessible, navigation clavier impossible).
  - **SÉRIEUX** : dégrade fortement l'usage (ex: contraste insuffisant, ordre tab illogique, focus invisible).
  - **MODÉRÉ** : cause de friction (ex: target trop petit, message d'erreur peu clair).
  - **MINEUR** : amélioration recommandée (ex: skip link manquant sur petite page).
- **Critère WCAG cité** : ex « WCAG 2.2 — 1.4.3 Contrast (Minimum) ». Aucun finding sans critère.
- **Fix concret** : code à modifier, ligne précise.
- **Vérification post-fix** : comment confirmer (test clavier, axe, screen reader).

Livrable structuré, rendu **comme retour du skill** (en fork) ou dans le hand-off de `frontend` (préchargé) ; aucun fichier n'est écrit dans le dépôt audité sauf demande explicite :

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

## Auto-check final (avant livraison)

- Chaque finding porte ses quatre champs (sévérité, critère WCAG, fix à la ligne, vérification post-fix) ?
- Chaque test non exécuté est « non fait » et rendu avec outil, étapes et résultat attendu ?
- Les dépendances du composant ont été lues avant de conclure sur lui (Phase 1) ?

Si une seule réponse est non → corriger avant livraison.

# a11y-audit — patrons de code, outils, critères fréquents

> Annexe du skill `a11y-audit`, sortie du `SKILL.md` le 11.11.2026 (v1.7), texte inchangé. À ouvrir
> au moment d'écrire le fix d'un finding (annonce dynamique, formulaire, skip link, composant shadcn
> customisé) ou de choisir l'outil d'un test de la Phase 3. « L'anti-pattern ARIA redondant
> ci-dessus » renvoie à la règle ARIA du Pilier 4 du `SKILL.md`.

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

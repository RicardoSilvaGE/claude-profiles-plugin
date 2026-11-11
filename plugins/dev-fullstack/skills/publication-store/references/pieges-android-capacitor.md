# publication-store — pièges Android 15+ / Capacitor 8 mesurés

> Annexe du skill `publication-store`, sortie du `SKILL.md` le 11.11.2026 (v1.6), texte inchangé.
> À ouvrir avant de toucher à la status bar, au splash, aux safe areas ou aux notifications, et
> devant tout défaut natif relevé en Phase 7.

## Connaissance domaine — pièges Android 15+ / Capacitor 8 mesurés

Tirés d'un dépôt réel sur `targetSdk 36`, `@capacitor/core 8.3.1`, WebView Chrome. À vérifier contre la version installée avant de s'y fier.

- **`setStatusBarColor()` est déprécié au niveau OS** (API 35+) ; `android:statusBarColor` dans `styles.xml` et `StatusBar.setBackgroundColor()` de `@capacitor/status-bar` sont **ignorés en silence**. La voie qui marche : plugin **`SystemBars`** intégré à `@capacitor/core` ≥ 8.0, configuré par `plugins.SystemBars.insetsHandling: "css"`, et **fond peint en CSS** (`env(safe-area-inset-top)` + couleur de fond sur `body`).
- **`env(safe-area-inset-*)` vaut 0 sur WebView < 140** même avec `viewport-fit=cover` ; `SystemBars` injecte alors des variables `--safe-area-inset-*` et décale la WebView. Utiliser `env()` directement couvre les deux cas sans double padding.
- **`SystemBars` est auto-enregistré** : pas de `npm install`, pas de `registerPlugin`.
- **`Theme.SplashScreen` ne transitionne pas** vers `postSplashScreenTheme` sans `installSplashScreen()` — Capacitor ne l'appelle pas. Ne pas chercher à styler la barre via le thème de l'activité.
- **`style: "DEFAULT"`** lit le thème **système** au boot : flash d'icônes d'environ une seconde si le thème système et celui de l'app diffèrent. Cosmétique ; `"LIGHT"` le supprime, mais c'est une zone SPEC.
- **`access origin="*"`** dans `config.xml` est le défaut Capacitor ; sans `server.url` externe l'exposition est faible, pas un motif de rejet.
- **Android 13+** : `POST_NOTIFICATIONS` est une permission runtime — un **pré-prompt applicatif** avant le prompt système évite un refus définitif au premier contact, et se persiste pour ne pas re-demander.
- **Manifeste PWA : une seule `theme_color`**, pas de media query — le splash de la PWA installée reste dans la couleur claire même en sombre. Compromis non résoluble ; côté natif, `SystemBars` + `backgroundColor` prennent le relais.

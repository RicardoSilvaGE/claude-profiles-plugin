# publication-store — provenance et incidents source

> Annexe du skill `publication-store`, sortie du `SKILL.md` le 11.11.2026 (v1.6), texte inchangé.
> À ouvrir pour juger de la portée d'une règle du skill (mesure à n = 1), avant de la porter à un
> deuxième dépôt, ou quand une règle est contestée. « Phase » et « garde-fou » renvoient au
> `SKILL.md`.

## D'où vient ce contenu

Mesure du 04.09.2026 sur **un** dépôt applicatif ayant mené une PWA React (Vite, Supabase) jusqu'à
l'internal testing Play Store : `capacitor.config.json`, `build.gradle` avec `signingConfigs`
conditionnelle, `variables.gradle` (min 24 / cible 36), Manifest (`allowBackup=false`, règles
d'extraction), `keystore.properties.example`, `.gitignore`, un dossier `docs/play-store/` de
treize fichiers (procédure AAB, checklist QA en dix tests, Data Safety en sept catégories, IARC,
fiches en trois locales, captures, feature graphic, seed de démonstration), une spec de release,
un ADR App Links, un audit tous secteurs pré-store et une section de pièges Android 15+ écrite
après incident. **iOS n'y figure pas** : rien ici n'en parle.

Neutralisation appliquée : nom de l'app, domaine, adresses, prénoms, chemins de poste retirés ;
les valeurs numériques (tailles, limites, versions de SDK) sont celles constatées.

**Un dépôt, pas huit** : c'est une mesure à n = 1. Ce qui est générique (invariants, tracks,
formulaires de la Console, App Links) tient par la documentation Google ; ce qui est spécifique
(checklists, ordre des gestes) reflète une pratique et sera à confronter au deuxième dépôt publié.

## Incidents source

- **23.05.2026 (dépôt mesuré)** — status bar Android corrigée au tâtonnement sur plusieurs
  fichiers système, puis revert. Leçon : SPEC obligatoire sur toute zone système, lecture du code
  Java du plugin avant d'écrire, une hypothèse à la fois. Origine de la Phase 7 et du garde-fou 5.
- **30.05.2026 (dépôt mesuré)** — audit pré-store : Play App Signing non confirmé, migrations SQL
  non appliquées en prod, absence de recovery codes MFA. Deux des trois étaient des gestes ops
  invisibles du code. Origine de la Phase 3 et de l'invariant keystore.

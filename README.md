# claude-profiles-plugin

Marketplace public d'un seul plugin Claude Code : le profil **`dev-fullstack`** — 12 sub-agents,
8 skills métier, la doctrine de travail livrée comme skill, et cinq hooks.

## Avant de t'en servir — trois choses qui surprennent

**1. Les agents `backend` et `frontend` refusent d'écrire du code sans `SPEC.md`.**
Ce n'est pas un bug : c'est un `HARD GATE` volontaire, posé après un incident. Passe par le skill
`spec-builder` d'abord, ou demande explicitement de court-circuiter. C'est la première chose sur
laquelle bute un nouvel utilisateur.

**2. La doctrine est injectée à chaque session** par un hook `SessionStart` — environ
**11 300 tokens**, y compris dans les sessions où tu ne codes pas. `CLAUDE_DOCTRINE_RESIDENTE=0`
la coupe sans désinstaller le plugin.

**2 bis. Trois garde-fous s'interposent pendant que tu codes**, depuis le 02.09.2026 — ce sont
les hooks du profil sur le poste, portés en bash :
- `PreToolUse` : écrire un fichier de code dans un dépôt sans `SPEC*.md` récent déclenche une
  demande de confirmation (mode `default`) et, dans tous les modes, un rappel de la règle des
  trois étages. **En session non interactive, la première écriture est refusée** avec ce rappel
  pour motif — la relancer passe. Une fois par session et par dépôt. `CLAUDE_GUARD_SPEC=0` le
  coupe.
- `Stop` : si des `.ts/.tsx` ont bougé et que le dépôt porte un `tsconfig.json`, `tsc --noEmit`
  tourne en fin de tour et **bloque** la fin de tour avec les erreurs. Une fois par session et
  par dépôt. `CLAUDE_CHECK_BUILD_TS=0` le coupe.
- `PreToolUse` sur `Bash` : tout `git push` direct vers `main`/`master` est **refusé** (référence
  explicite, refspec, `--all`/`--mirror`, push nu depuis `main`), avec le flux branche + PR en
  réponse. Dans tous les modes. Pour un dépôt où c'est légitime : `~/.claude/.push-main-allowed`,
  une ligne `owner/repo`, joker `*` admis. `CLAUDE_GUARD_PUSH_MAIN=0` le coupe.

**2 ter. Tes préférences personnelles peuvent te suivre en cloud** — mais ce dépôt est public,
donc elles ne sont pas dedans. Le hook `SessionStart` + `SubagentStart` les lit dans, par ordre :
`CLAUDE_PROFIL_UTILISATEUR_FICHIER` (chemin), `CLAUDE_PROFIL_UTILISATEUR` (texte) — variables de
ton environnement cloud — ou `~/.claude/profil-utilisateur.md`, que tu déposes depuis le setup
script (bloc commenté dans `setup-script-cloud.sh`). Sous 1 700 octets. Sans source, une ligne
d'invitation, rien d'autre.

**3. Les commandes `/lc-*` ne sont pas dans le plugin.** La doctrine y renvoie treize fois : ce
sont des raccourcis liés à un poste et à un dossier d'entreprise, absents d'ici. Ne pas les
chercher.

## Installation

```
/plugin marketplace add RicardoSilvaGE/claude-profiles-plugin
/plugin install dev-fullstack@claude-profiles-plugin
```

En terminal ou dans l'app desktop. **`/plugin` n'existe pas dans une session cloud** — pour
celles-ci, voir ci-dessous.

## Dans toutes les sessions cloud

Coller le contenu de `setup-script-cloud.sh` dans le champ **Script de configuration** de
l'environnement cloud : claude.ai/code → icône nuage au-dessus de la zone de message →
engrenage sur l'environnement.

Ce dépôt est **public**, donc son clone ne demande aucune authentification — et c'est toute sa
raison d'être. Un setup script ne reçoit ni les variables d'environnement de l'environnement,
ni aucune authentification git : il ne sait cloner qu'un dépôt public. Mesuré le 31.08.2026,
après avoir constaté l'inverse pour un marketplace privé.

## Ce que le plugin contient

| | |
|---|---|
| Sub-agents | `architecte`, `backend`, `brainstormer`, `designer`, `frontend`, `growth`, `qa`, `redacteur`, `release`, `reviewer`, `securite`, `ux` |
| Skills | `a11y-audit`, `debug-investigation`, `framework-upgrade`, `frontend-app-builder`, `librairie-maison`, `perf-audit`, `spec-builder`, `supabase-toolkit` |
| Doctrine | `doctrine-dev-fullstack` — méthodologie en phases, règle absolue spec-builder, conventions |
| Hooks | `SessionStart` (doctrine en contexte, puis préférences personnelles), `SubagentStart` (préférences), `PreToolUse` (règle spec-builder), `Stop` (compilation TypeScript), `PreToolUse` sur `Bash` (push direct sur `main` refusé) |

**Le `CLAUDE.md` racine d'un plugin n'est pas chargé** : c'est pour cela que la doctrine est un
skill. Et comme un skill se charge *à la demande* là où un `CLAUDE.md` de profil est *résident*,
un hook `SessionStart` lui rend cette résidence — pour ~11 300 tokens par session.
`CLAUDE_DOCTRINE_RESIDENTE=0` le coupe sans désinstaller le plugin.

Le hook porte trois gardes qui le font **se taire** là où la même doctrine arrive déjà par un
autre chemin : deux copies d'une même règle ne s'additionnent pas, elles se contredisent au
premier écart de version.

## Provenance

Ce dépôt est **généré**, jamais édité à la main. Sa source est un dépôt privé, où
`scripts/build-plugin.sh --public` produit cette copie en retirant ce qui n'a pas à être publié,
puis **refuse de produire** s'il subsiste un motif interdit — un contrôle, pas une intention.

Toute correction se fait dans la source, jamais ici : une copie éditée sur place diverge en
silence.

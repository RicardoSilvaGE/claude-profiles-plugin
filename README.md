# claude-profiles-plugin

Marketplace public d'un seul plugin Claude Code : le profil **`dev-fullstack`** — 12 sub-agents,
8 skills métier, et la doctrine de travail livrée comme skill.

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
| Hook | `SessionStart`, qui injecte la doctrine en contexte |

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

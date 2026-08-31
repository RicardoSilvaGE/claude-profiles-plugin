#!/usr/bin/env bash
# ==============================================================================================
# injecter-doctrine.sh — hook SessionStart d'un profil empaquete en plugin.
#
# CE QU'IL FAIT, ET POURQUOI IL EXISTE.
# Un `CLAUDE.md` de profil est RESIDENT : il est dans le contexte avant que la session ne
# commence. Un skill, lui, se charge A LA DEMANDE. Empaqueter un profil en plugin degrade donc
# la doctrine de « garantie » a « declenchement » — et les regles dures d'un profil (regle
# absolue spec-builder, Phase 0, Phase -1, « commiter avant de deployer ») ne valent que si
# elles sont lues AVANT le premier geste, pas apres. Ce hook restaure la residence en injectant
# le corps du skill de doctrine en `additionalContext`.
#
# CE QU'IL COUTE, ET C'EST LE POINT A PESER. 11 321 tokens dans CHAQUE session ou le
# plugin est actif, y compris celles ou l'on ne code pas. Pour le desactiver sans desinstaller
# le plugin : `CLAUDE_DOCTRINE_RESIDENTE=0`.
#
# LES TROIS GARDES ANTI-DOUBLE-CHARGEMENT, ET C'EST LA VRAIE DIFFICULTE.
# Ce plugin s'active au niveau du COMPTE : il suit l'utilisateur partout, y compris la ou la
# meme doctrine arrive DEJA par un autre chemin. Deux copies d'une meme regle dans un contexte
# ne s'additionnent pas — elles se contredisent au premier ecart de version, et le modele n'a
# aucun moyen de savoir laquelle fait foi. D'ou trois sorties silencieuses :
#   1. le depot de travail EST claude-profiles (ou en voit une source vive) : son propre
#      .claude/hooks/session-start.sh injecte deja cette doctrine ;
#   2. le depot porte un .claude/profile-CLAUDE.md : l'amorcage web y a deja deploye le profil ;
#   3. le home de config actif porte deja cette doctrine dans son CLAUDE.md : c'est le poste
#      Windows, ou sync-global.ps1 / deploy-profile-local.ps1 l'ont installee.
#
# Le marqueur du garde 3 est la PREMIERE LIGNE NON VIDE de la doctrine elle-meme, lue au
# runtime. Pas une chaine ecrite en dur : une chaine en dur aurait derive le jour ou le titre
# du profil change, et le garde serait tombe en silence — exactement la classe de defaut que
# le CLAUDE.md de claude-profiles documente sous « une copie que personne ne surveille ».
#
# FAIL-OPEN PAR CONSTRUCTION : jq absent, doctrine introuvable, lecture impossible — le hook
# se tait et sort en 0. Un hook de confort ne casse jamais une session.
# ==============================================================================================
set -uo pipefail

[ "${CLAUDE_DOCTRINE_RESIDENTE:-1}" = "0" ] && exit 0

RACINE="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

# Le skill de doctrine est trouve par motif, jamais par un nom substitue a la generation :
# build-plugin.sh copie ce fichier VERBATIM, ce qui rend --check exact.
SKILL=""
for f in "$RACINE"/skills/doctrine-*/SKILL.md; do
    [ -f "$f" ] && { SKILL="$f"; break; }
done
[ -n "$SKILL" ] || exit 0

command -v jq >/dev/null 2>&1 || { echo "injecter-doctrine: jq absent, doctrine non injectee" >&2; exit 0; }

PROJET="${CLAUDE_PROJECT_DIR:-$PWD}"

# --- garde 1 : source vive de claude-profiles dans le depot de travail ------------------------
[ -d "$PROJET/templates/profiles" ] && [ -d "$PROJET/templates/_web-bootstrap" ] && exit 0

# --- garde 2 : amorcage web deja deploye dans ce depot ----------------------------------------
[ -f "$PROJET/.claude/profile-CLAUDE.md" ] && exit 0

# --- garde 3 : doctrine deja residente dans le home de config actif ---------------------------
# Premiere ligne non vide du corps, c'est-a-dire APRES le frontmatter YAML et le preambule
# d'adaptation : le titre du profil. C'est ce que sync-global.ps1 depose en tete de
# ~/.claude/CLAUDE.md, donc le seul marqueur commun aux deux chemins de deploiement.
MARQUEUR="$(awk '
    NR==1 && $0=="---" { fm=1; next }
    fm==1 && $0=="---" { fm=0; next }
    fm==1 { next }
    /^#[^#]/ { print; exit }
' "$SKILL")"

if [ -n "$MARQUEUR" ]; then
    for home in "${CLAUDE_CONFIG_DIR:-}" "$HOME/.claude"; do
        [ -n "$home" ] || continue
        [ -f "$home/CLAUDE.md" ] || continue
        grep -qxF "$MARQUEUR" "$home/CLAUDE.md" 2>/dev/null && exit 0
    done
fi

# --- injection --------------------------------------------------------------------------------
# Le corps seul : le frontmatter est de la metadonnee de skill, il n'a rien a faire dans un
# contexte de session.
NOM="$(basename "$(dirname "$SKILL")")"
{
    cat <<EOF
=== DOCTRINE DE PROFIL CHARGEE PAR LE PLUGIN (skill '$NOM') ===

Injectee au demarrage par le hook SessionStart du plugin, pour lui rendre la RESIDENCE qu'elle
a sur le poste Windows via ~/.claude/CLAUDE.md. Le skill '$NOM' porte le meme texte : inutile
de le charger, il est deja ci-dessous.

Un CLAUDE.md de PROJET, s'il existe, reste prioritaire sur ce qui suit.
Pour desactiver cette injection sans desinstaller le plugin : CLAUDE_DOCTRINE_RESIDENTE=0.

EOF
    awk '
        NR==1 && $0=="---" { fm=1; next }
        fm==1 && $0=="---" { fm=0; corps=1; next }
        fm==1 { next }
        corps==1 { print }
    ' "$SKILL"
    printf '\n=== fin de la doctrine du plugin ===\n'
} | jq -Rs '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:.}}'

exit 0

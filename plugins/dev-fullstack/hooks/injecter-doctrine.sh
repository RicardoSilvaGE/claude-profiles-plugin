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
# CE QU'IL COUTE, ET C'EST LE POINT A PESER. Le corps de la doctrine (mesure par I5) dans CHAQUE session ou le
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

# Numero de la partie a injecter (1 par defaut) : hooks.json appelle ce script une fois par partie.
PARTIE="${1:-1}"
case "$PARTIE" in (""|*[!0-9]*) exit 0;; esac

[ "${CLAUDE_DOCTRINE_RESIDENTE:-1}" = "0" ] && exit 0

RACINE="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

command -v jq >/dev/null 2>&1 || { echo "injecter-doctrine: jq absent, doctrine non injectee" >&2; exit 0; }

# Le skill de doctrine est NOMME EN ENTIER, `doctrine-<nom du plugin>`, le nom etant lu au runtime
# dans plugin.json : build-plugin.sh copie ce fichier VERBATIM, ce qui garde --check exact.
#
# CORRIGE LE 02.10.2026 (remontee du mainteneur, fiche 261002-1000). Il etait trouve par le motif
# `skills/doctrine-*/`, premier trouve. Depuis le plugin 1.17.0 (09.09.2026), un second skill
# `doctrine-de-depot` passe avant `doctrine-dev-fullstack` dans l'ordre de tri : le hook injectait
# la doctrine de depot a la place de celle du profil, et le garde 3, sans marqueur, ne se taisait
# plus jamais. Meme defaut que celui corrige le meme jour dans build-plugin.sh, reste ici. Le banc
# l'a vu des son premier run apres la panne de quota CI : il n'avait pas tourne depuis le 06.09.
PROFIL="$(jq -r '.name // empty' "$RACINE/.claude-plugin/plugin.json" 2>/dev/null)"
[ -n "$PROFIL" ] || exit 0
SKILL="$RACINE/skills/doctrine-$PROFIL/SKILL.md"
[ -f "$SKILL" ] || exit 0

PROJET="${CLAUDE_PROJECT_DIR:-$PWD}"

# --- garde 1 : source vive de claude-profiles dans le depot de travail ------------------------
[ -d "$PROJET/templates/profiles" ] && [ -d "$PROJET/templates/_web-bootstrap" ] && exit 0

# --- garde 2 : amorcage web deja deploye dans ce depot ----------------------------------------
[ -f "$PROJET/.claude/profile-CLAUDE.md" ] && exit 0

# --- garde 3 : doctrine deja residente dans le home de config actif ---------------------------
# Premiere ligne de titre du CORPS, c'est-a-dire APRES le frontmatter YAML (deux `---`) ET
# APRES le separateur `---` qui clot le preambule d'adaptation : le titre du profil. C'est ce
# que sync-global.ps1 depose en tete de ~/.claude/CLAUDE.md, donc le seul marqueur commun aux
# deux chemins de deploiement.
#
# CORRIGE LE 02.09.2026, TROUVE EN L'EPROUVANT : la premiere version prenait le premier titre
# apres le frontmatter — celui du PREAMBULE (« Doctrine du profil ... »), que le CLAUDE.md du
# poste ne porte pas. Le garde 3 ne pouvait donc JAMAIS se taire sur un vrai poste, et la
# doctrine y aurait ete chargee deux fois. Le banc etait vert parce qu'il fabriquait le home
# avec le marqueur calcule par ce meme awk : il testait le hook contre lui-meme.
MARQUEUR="$(awk '
    /^---$/ { sep++; next }
    sep < 3 { next }
    /^#[^#]/ { print; exit }
' "$SKILL")"

if [ -n "$MARQUEUR" ]; then
    for home in "${CLAUDE_CONFIG_DIR:-}" "$HOME/.claude"; do
        [ -n "$home" ] || continue
        [ -f "$home/CLAUDE.md" ] || continue
        grep -qxF "$MARQUEUR" "$home/CLAUDE.md" 2>/dev/null && exit 0
    done
fi

# --- injection, en parties sous le plafond des hooks ------------------------------------------
# Claude Code plafonne CHAQUE chaine additionalContext a 10 000 caracteres ; au-dela, le modele
# ne recoit qu'un chemin de fichier et un apercu de 2 000 caracteres, et rien ne lui demande de
# lire le reste (doc des hooks, lue le 10.11.2026 ; entree du changelog « Changed hook output
# over 10,000 characters to be saved to disk with a file path + a 2,000-character preview »).
# Le plafond se mesure chaine par chaine, et quand plusieurs hooks repondent au meme evenement,
# Claude recoit toutes les valeurs (meme doc). D'ou : un hook par partie dans hooks.json, chacun
# appele avec son numero, chacun sous le plafond.
#
# CONSTATE LE 10.11.2026 : la version a un seul hook produisait 44 848 caracteres ; le modele
# n'en recevait que l'apercu de 2 000, ou ne figure aucune regle dure du profil.
#
# Le decoupage est DETERMINISTE : chaque processus le recalcule a l'identique (« its matching
# hooks run in parallel », doc des hooks : aucun ne peut passer la main a un autre) et n'imprime
# que sa partie. Coupe aux titres #, ## et ### hors bloc de code ; un bloc trop gros a lui seul
# est coupe entre deux lignes. Mesure en OCTETS (LC_ALL=C) : un octet compte au moins autant
# qu'un caractere, la borne tient quel que soit l'awk du conteneur.
#
# Les commentaires HTML de bloc sont retires, comme Claude Code le fait pour un CLAUDE.md
# (doc memory) : parite avec le poste, et autant d'octets rendus au budget.
BUDGET_OCTETS="${CLAUDE_DOCTRINE_BUDGET_PARTIE:-9000}"
PARTIES_MAX=8   # nombre d'entrees `injecter-doctrine.sh <k>` dans hooks.json ; le banc le verifie

NOM="$(basename "$(dirname "$SKILL")")"

CORPS="$(LC_ALL=C awk '
    NR==1 && $0=="---" { fm=1; next }
    fm==1 && $0=="---" { fm=0; next }
    fm==1 { next }
    /^```/ { code = !code }
    !code && /^<!--/ { com=1 }
    com==1 { if ($0 ~ /-->/) com=0; next }
    { print }
' "$SKILL")"

# decouper <budget> : ecrit sur stdout les lignes du corps, chacune prefixee du numero de partie
decouper() {
    LC_ALL=C awk -v budget="$1" '
        function vider_bloc(   i) {
            if (nb == 0) return
            if (taille_part > 0 && taille_part + taille_bloc > budget) { part++; taille_part = 0 }
            if (taille_bloc > budget) {
                # bloc trop gros a lui seul : coupe entre deux lignes, au plus pres du budget
                for (i = 1; i <= nb; i++) {
                    if (taille_part > 0 && taille_part + length(L[i]) + 1 > budget) { part++; taille_part = 0 }
                    print part "\t" L[i]; taille_part += length(L[i]) + 1
                }
            } else {
                for (i = 1; i <= nb; i++) print part "\t" L[i]
                taille_part += taille_bloc
            }
            nb = 0; taille_bloc = 0
        }
        BEGIN { part = 1; taille_part = 0; nb = 0; taille_bloc = 0 }
        /^```/ { code = !code }
        !code && /^##?#? / { vider_bloc() }
        { L[++nb] = $0; taille_bloc += length($0) + 1 }
        END { vider_bloc() }
    '
}

DECOUPE="$(printf '%s\n' "$CORPS" | decouper "$BUDGET_OCTETS")"
TOTAL="$(printf '%s\n' "$DECOUPE" | awk -F'\t' 'END { print $1 }')"
[ "$PARTIE" -le "$TOTAL" ] 2>/dev/null || exit 0

{
    printf '=== Doctrine du profil (skill %s) : partie %s sur %s ===\n\n' "$NOM" "$PARTIE" "$TOTAL"
    printf 'Injectee au demarrage par le hook SessionStart du plugin, en %s parties : Claude Code\n' "$TOTAL"
    printf 'plafonne chaque chaine de contexte a 10 000 caracteres. Les parties peuvent arriver dans le\n'
    printf 'desordre ; elles se lisent dans l ordre de leur numero. Ensemble, elles forment le texte\n'
    printf 'complet du skill %s. S il en manque une dans ce contexte, ce skill porte le texte entier.\n\n' "$NOM"
    if [ "$PARTIE" -eq 1 ]; then
        printf 'Un CLAUDE.md de PROJET, s il existe, reste prioritaire sur ce qui suit.\n'
        printf 'Pour desactiver cette injection sans desinstaller le plugin : CLAUDE_DOCTRINE_RESIDENTE=0.\n\n'
    fi
    printf '%s\n' "$DECOUPE" | awk -F'\t' -v k="$PARTIE" '$1 == k { sub(/^[0-9]+\t/, ""); print }'
    if [ "$PARTIE" -eq "$TOTAL" ]; then
        printf '\n=== fin de la doctrine du plugin (partie %s sur %s) ===\n' "$PARTIE" "$TOTAL"
    elif [ "$PARTIE" -eq "$PARTIES_MAX" ] && [ "$TOTAL" -gt "$PARTIES_MAX" ]; then
        printf '\nATTENTION : la doctrine demande %s parties, hooks.json n en declare que %s. Les parties\n' "$TOTAL" "$PARTIES_MAX"
        printf 'au-dela de %s ne sont PAS dans ce contexte : charger le skill %s.\n' "$PARTIES_MAX" "$NOM"
    fi
} | jq -Rs '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:.}}'

exit 0

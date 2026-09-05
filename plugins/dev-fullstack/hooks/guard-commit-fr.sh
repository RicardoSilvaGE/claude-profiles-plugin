#!/usr/bin/env bash
# ==============================================================================================
# guard-commit-fr.sh — hook PreToolUse (matcher Bash) d'un profil empaquete en plugin.
#
# CE QU'IL FAIT. Refuse (`deny`) un `git commit` dont le SUJET — premiere ligne du message
# passe par -m, --message ou par la forme heredoc `-m "$(cat <<'EOF' ... EOF)"` — ne suit pas la
# convention git du profil : `type(scope): description`, TYPE FRANCAIS sans accent, pris dans
# la table fonctionnalite | correctif | entretien | doc | refonte | test. Il ne juge que le
# type et la forme `type(scope): ` : la langue de la description n'est pas verifiable par une
# regle, et il ne l'essaie pas.
#
# POURQUOI IL EXISTE. Pilote du banc de comportement, 05.09.2026 : les quatre regles portees par
# un hook ont tenu huit passes sur huit ; la convention de commit, purement doctrinale, a ete
# ignoree quatre commits sur quatre, doctrine injectee (37 Ko verifies). Une regle lue au
# demarrage et une regle opposee au moment du geste ne valent pas la meme chose.
#
# `deny` et non `ask`, comme la regle 0 : le correctif est trivial et sans ambiguite (reecrire le
# sujet), le message du refus donne la table, et un `ask` sans personne pour repondre vaut deja
# refus en session non interactive (mesure du 02.09.2026).
#
# CE QU'IL LAISSE PASSER, A DESSEIN :
#   - les formes que git ecrit lui-meme : `Merge ...`, `Revert "..."`, `fixup! ...`, `squash! ...` ;
#   - un commit sans message en ligne : -F/--file, editeur, --amend --no-edit, --help ;
#   - tout ce qui n'est pas `git [options globales] commit` ;
#   - les depots declares dans ~/.claude/.commit-fr-exempt (« owner/repo », joker `*`) — c'est
#     la clause « rouvrir si un depot passe public » de la doctrine, rendue locale et sans
#     commit ; CLAUDE_GUARD_COMMIT_FR=0 coupe le garde.
#
# LIMITES ASSUMEES : ne voit que l'outil Bash (pas les outils MCP GitHub) ; un `git commit`
# cite dans une chaine d'une autre commande (`echo "git commit -m x"`) est pris pour un commit ;
# seul le PREMIER -m est lu (c'est le sujet). Fail-open : jq absent, payload vide ou invalide,
# message introuvable -> silence, exit 0.
#
# Aucun nom de bureau ni de depot prive ici : `controler_publiable()` de build-plugin.sh grep
# les .sh. Parite poste : regle F de scripts/guard-poste.ps1.
# ==============================================================================================
set -uo pipefail
[ "${CLAUDE_GUARD_COMMIT_FR:-1}" = "0" ] && exit 0
command -v jq >/dev/null 2>&1 || { echo "guard-commit-fr: jq absent, regle non opposee" >&2; exit 0; }
RAW="$(cat)"
[ -n "$RAW" ] || exit 0
printf '%s' "$RAW" | jq -e . >/dev/null 2>&1 || exit 0
lire() { printf '%s' "$RAW" | jq -r "$1 // empty" 2>/dev/null; }
[ "$(lire '.tool_name')" = "Bash" ] || exit 0
CMD="$(lire '.tool_input.command')"
[ -n "$CMD" ] || exit 0
CWD="$(lire '.cwd')"; [ -n "$CWD" ] || CWD="$PWD"

OPT='(-[cC][[:space:]]+("[^"]*"|'"'"'[^'"'"']*'"'"'|[^[:space:]]+)|--?[[:alnum:]_-]+(=("[^"]*"|[^[:space:]]+))?)'
MOTIF="(^|[^[:alnum:]_])git([[:space:]]+$OPT)*[[:space:]]+commit([^[:alnum:]_-]|$)"
# Les trois motifs d'extraction sont des VARIABLES, pour que les classes soient exactement
# [^"] et [^'] sans avoir a raisonner sur ce que bash fait d'un guillemet echappe dans [[ =~ ]].
DQ='"'; SQ="'"
RE_HEREDOC="<<-?[[:space:]]*[${SQ}${DQ}]?([A-Za-z_][A-Za-z0-9_]*)[${SQ}${DQ}]?"
RE_MESSAGE="--message=(${DQ}([^${DQ}]*)${DQ}|${SQ}([^${SQ}]*)${SQ}|([^[:space:]]+))"
RE_M="(^|[[:space:]])-[a-zA-Z]*m[[:space:]]*(${DQ}([^${DQ}]*)${DQ}|${SQ}([^${SQ}]*)${SQ}|([^[:space:]]+))"

# PAS DE DECOUPAGE PAR INSTRUCTION AVANT L'EXTRACTION. La premiere version decoupait sur ';',
# '&&' et '||' comme guard-push-main.sh, puis cherchait le commit dans chaque instruction. Un
# message qui CONTIENT un point-virgule ("... tel quel a git checkout ; sous Linux ...") etait
# coupe avant son guillemet fermant, l'extraction tombait sur le mot sans espace
# `"correctif(tests):`, guillemet compris, et un commit conforme etait refuse. Trouve en usage
# reel le 05.09.2026, sur le commit qui corrigeait un autre banc - et d'abord attribue a tort a
# l'antislash du meme message (le diagnostic fautif est dans l'historique du depot, 6ea7be9).
# On cherche donc le premier `git [options] commit` dans la commande ENTIERE, et l'extraction
# du message est elle-meme bornee par les guillemets : un ';' dedans n'est plus un separateur.
SUJET=""; TROUVE=0
if [[ "$CMD" =~ $MOTIF ]]; then
    TROUVE=1
    rest="${CMD#*"${BASH_REMATCH[0]}"}"
    msg=""
    if [[ "$rest" =~ $RE_HEREDOC ]]; then
        marqueur="${BASH_REMATCH[1]}"
        corps="${rest#*"${BASH_REMATCH[0]}"}"
        corps="${corps#*$'\n'}"                                   # ce qui suit la ligne du marqueur
        while IFS= read -r ligne; do
            [ "$(printf '%s' "$ligne" | tr -d '[:space:]')" = "$marqueur" ] && break
            if [ -n "$(printf '%s' "$ligne" | tr -d '[:space:]')" ]; then msg="$ligne"; break; fi
        done <<EOF_CORPS
$corps
EOF_CORPS
    elif [[ "$rest" =~ $RE_MESSAGE ]]; then
        msg="${BASH_REMATCH[2]}${BASH_REMATCH[3]}${BASH_REMATCH[4]}"
    elif [[ "$rest" =~ $RE_M ]]; then
        msg="${BASH_REMATCH[3]}${BASH_REMATCH[4]}${BASH_REMATCH[5]}"
    else
        exit 0                                                    # -F, editeur, --amend --no-edit, --help
    fi
    SUJET="${msg%%$'\n'*}"
    SUJET="$(printf '%s' "$SUJET" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
fi
[ "$TROUVE" -eq 1 ] || exit 0
[ -n "$SUJET" ] || exit 0

# Formes ecrites par git lui-meme, ou marques de reecriture d'historique : hors convention, a dessein.
case "$SUJET" in
    "Merge "*|"Revert "*|"fixup! "*|"squash! "*|"amend! "*) exit 0 ;;
esac
printf '%s' "$SUJET" | grep -Eq '^(fonctionnalite|correctif|entretien|doc|refonte|test)\([^)]+\)!?: [^[:space:]]' && exit 0

# Exemptions locales, meme mecanique que guard-push-main.sh (~/.claude/.commit-fr-exempt).
FICHIER_EXEMPT="${HOME:-/nonexistent}/.claude/.commit-fr-exempt"
if [ -f "$FICHIER_EXEMPT" ]; then
    REMOTE="$(git -C "$CWD" remote get-url origin 2>/dev/null)"
    if [ -n "$REMOTE" ]; then
        DEPOT="$REMOTE"
        case "$DEPOT" in
            *://*) DEPOT="${DEPOT#*://}"; DEPOT="${DEPOT#*/}" ;;
            *@*:*) DEPOT="${DEPOT#*:}" ;;
        esac
        DEPOT="${DEPOT%.git}"; DEPOT="${DEPOT%/}"
        DEPOT="$(printf '%s' "$DEPOT" | tr 'A-Z' 'a-z')"
        while IFS= read -r motif; do
            motif="${motif%%#*}"
            motif="$(printf '%s' "$motif" | tr -d '[:space:]' | tr 'A-Z' 'a-z')"
            [ -n "$motif" ] || continue
            # shellcheck disable=SC2254
            case "$DEPOT" in $motif) exit 0 ;; esac
        done < "$FICHIER_EXEMPT"
    fi
fi

MSG="Message de commit hors convention du profil (conventions git) : \"$SUJET\"
Forme attendue : type(scope): description  —  en FRANCAIS, type sans accent, pris dans :
  feat -> fonctionnalite   fix -> correctif   chore -> entretien
  docs -> doc              refactor -> refonte   test -> test
Exemple : correctif(readme): coquille corrigee dans la procedure
Le type est un jeton qu'on grep ; la description s'accentue normalement. Merge, Revert, fixup!
et squash! passent tels quels. Pour un depot qui adopte une autre convention (historique
ouvert, outil qui lit le type), declare-le dans ~/.claude/.commit-fr-exempt (une ligne
\"owner/repo\", joker '*' admis) ; CLAUDE_GUARD_COMMIT_FR=0 coupe le garde."
jq -n --arg r "$MSG" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
exit 0

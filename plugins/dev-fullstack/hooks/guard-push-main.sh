#!/usr/bin/env bash
# ==============================================================================================
# guard-push-main.sh — hook PreToolUse (matcher Bash) d'un profil empaquete en plugin.
#
# CE QU'IL FAIT. Refuse (`deny`) tout `git push` direct vers main/master, et renvoie le flux
# branche + Pull Request. C'est la REGLE 0 de guard-poste.ps1, le hook PreToolUse unique du
# poste, qui porte cinq regles : celle-ci est la seule qui ne suppose ni PowerShell 5.1, ni
# Word, ni dossier bureau — une regle de flux git, portable telle quelle. Elle vit dans le
# settings-fragment.json _shared du poste, jamais copie dans un plugin.
#
# TABLE DE LA REGLE :
#   ID  Decision  Cible                                            Origine
#   0   deny      git push direct sur main/master                  regle de flux, ex guard-push-main
#
# `deny`, comme au poste : a l'inverse de guard-spec-code.sh, aucun arbitrage `ask` n'est a
# reprendre, et un `deny` fait le meme effet dans TOUS les modes de permission.
#
# L'HISTOIRE QUE CE PORTAGE CONSERVE, PARCE QU'ELLE A COUTE :
#   - 04.08.2026, trois FAUX POSITIFS : un `gh pr create --base main`, un message de commit
#     redige en francais, une commande qui ne poussait rien. Corrige en ne testant que les
#     ARGUMENTS DU PUSH, instruction par instruction (`;`, `&&`, `||`, saut de ligne), jamais
#     la commande entiere. Le `.*?` etait NON gourmand : la premiere occurrence, pas la derniere.
#   - 20.08.2026, un FAUX NEGATIF : `git -C <depot> push origin main` passait EN SILENCE, les
#     options globales de git cassant l'adjacence `git push`. `-C`/`-c` prennent une valeur,
#     eventuellement quotee avec des espaces ; les options longues portent parfois `=valeur`.
#   - Faux positif CONSERVE a dessein, comme au poste : `echo "git push origin main"` reste
#     refuse. Le hook PowerShell le documente comme une asymetrie voulue avec sa regle A.
#
# EXEMPTIONS (fichier ~/.claude/.push-main-allowed, optionnel, ABSENT PAR DEFAUT = garde-fou
# partout) : une ligne = un motif "owner/repo", joker `*` admis, `#` commentaire. Le depot
# courant est identifie par le remote `origin` (HTTPS ou SSH), compare en minuscules.
#
# LIMITES ASSUMEES (garde-fou cote outil, PAS une barriere de securite) :
#   - N'agit que dans Claude Code, sur l'outil Bash. `bash -c "..."`, `eval`, un script appele
#     par chemin, ou les outils GitHub MCP (`push_files`, `merge_pull_request`) contournent le
#     parsing — le hook du poste ne les voit pas non plus. Verrou reel : protection de branche.
#   - Aucun marqueur « une fois par session » : un refus qu'on ne repete pas n'est pas un refus.
#   - Fail-open : toute erreur => exit 0 silencieux. Un hook bugue ne bloque jamais le travail.
#
# AUCUN NOM DE BUREAU NI DE DEPOT PRIVE ICI : le message du poste nomme le bureau, et ce nom est
# dans MOTIFS_INTERDITS de build-plugin.sh, qui grep les .sh. Le message dit « regle du profil ».
# CLAUDE_GUARD_PUSH_MAIN=0 desactive le hook.
# ==============================================================================================
set -uo pipefail

[ "${CLAUDE_GUARD_PUSH_MAIN:-1}" = "0" ] && exit 0

command -v jq >/dev/null 2>&1 || { echo "guard-push-main: jq absent, regle non opposee" >&2; exit 0; }

RAW="$(cat)"
[ -n "$RAW" ] || exit 0
printf '%s' "$RAW" | jq -e . >/dev/null 2>&1 || exit 0

lire() { printf '%s' "$RAW" | jq -r "$1 // empty" 2>/dev/null; }

[ "$(lire '.tool_name')" = "Bash" ] || exit 0
CMD="$(lire '.tool_input.command')"
[ -n "$CMD" ] || exit 0
CWD="$(lire '.cwd')"; [ -n "$CWD" ] || CWD="$PWD"

# ---- 1. Motif `git [options globales]* push`, en ERE POSIX (pas de \b, \s, \S) ----------------
# Une option globale : -C <val> / -c <val> (valeur quotee admise), ou --long[=val] / -x.
OPT='(-[cC][[:space:]]+("[^"]*"|'"'"'[^'"'"']*'"'"'|[^[:space:]]+)|--?[[:alnum:]_-]+(=("[^"]*"|[^[:space:]]+))?)'
MOTIF="(^|[^[:alnum:]_])git([[:space:]]+$OPT)*[[:space:]]+push([^[:alnum:]_]|$)"

# ---- 2. Decoupage par instruction, puis on ne garde que ce qui SUIT le premier `push` ----------
# Un `|` simple n'est PAS un separateur : `git push origin main | tee log` reste un push.
PUSH_ARGS=""
NB_PUSH=0
while IFS= read -r stmt; do
    [ -n "$stmt" ] || continue
    if [[ "$stmt" =~ $MOTIF ]]; then
        # ${var#*X} retire le PLUS COURT prefixe : premiere occurrence, non gourmand.
        args="${stmt#*"${BASH_REMATCH[0]}"}"
        PUSH_ARGS="$PUSH_ARGS
$args"
        NB_PUSH=$((NB_PUSH + 1))
    fi
done <<EOF
$(printf '%s\n' "$CMD" | awk '{ gsub(/;|&&|\|\|/, "\n"); print }')
EOF
[ "$NB_PUSH" -gt 0 ] || exit 0

# ---- 3. Reference explicite a main/master, ou --all / --mirror ---------------------------------
BLOQUE=0
while IFS= read -r a; do
    # `+` capte le force-push par refspec (`git push origin +main`) ; `:` la forme HEAD:main.
    printf '%s' "$a" | grep -Eq '(^|[[:space:]:/+])(main|master)($|[[:space:]:])' && BLOQUE=1
    printf '%s' "$a" | grep -Eq '(^|[[:space:]])(--all|--mirror)([[:space:]]|$)' && BLOQUE=1
done <<EOF
$PUSH_ARGS
EOF

# ---- 4. Push « nu » alors que la branche courante est main/master ------------------------------
if [ "$BLOQUE" -eq 0 ]; then
    BRANCHE="$(git -C "$CWD" rev-parse --abbrev-ref HEAD 2>/dev/null)"
    case "$BRANCHE" in
        main|master|Main|Master|MAIN|MASTER)
            while IFS= read -r a; do
                [ "$NB_PUSH" -gt 0 ] || break
                refish=""
                for tok in $a; do
                    case "$tok" in -*|origin|upstream) ;; *) refish="$tok" ;; esac
                done
                [ -z "$refish" ] && BLOQUE=1
            done <<EOF
$(printf '%s\n' "$PUSH_ARGS" | sed '1{/^$/d}')
EOF
            ;;
    esac
fi
[ "$BLOQUE" -eq 1 ] || exit 0

# ---- 5. Exemptions : ~/.claude/.push-main-allowed ----------------------------------------------
FICHIER_EXEMPT="${HOME:-/nonexistent}/.claude/.push-main-allowed"
if [ -f "$FICHIER_EXEMPT" ]; then
    REMOTE="$(git -C "$CWD" remote get-url origin 2>/dev/null)"
    if [ -n "$REMOTE" ]; then
        DEPOT="$REMOTE"
        case "$DEPOT" in
            *://*) DEPOT="${DEPOT#*://}"; DEPOT="${DEPOT#*/}" ;;      # https://host/owner/repo
            *@*:*) DEPOT="${DEPOT#*:}" ;;                              # git@host:owner/repo
        esac
        DEPOT="${DEPOT%.git}"; DEPOT="${DEPOT%/}"
        DEPOT="$(printf '%s' "$DEPOT" | tr 'A-Z' 'a-z')"
        while IFS= read -r motif; do
            motif="${motif%%#*}"
            motif="$(printf '%s' "$motif" | tr -d '[:space:]' | tr 'A-Z' 'a-z')"
            [ -n "$motif" ] || continue
            # shellcheck disable=SC2254 — le motif NON quote est le joker voulu (`owner/*`).
            case "$DEPOT" in $motif) exit 0 ;; esac
        done < "$FICHIER_EXEMPT"
    fi
fi

# ---- 6. Refus ------------------------------------------------------------------------------------
MSG="Push direct sur main/master refuse par la regle du profil (regle 0).

Le bon flux de travail :
  1. Cree une branche dediee :   git switch -c feature/<sujet>
  2. Pousse cette branche :       git push -u origin feature/<sujet>
  3. Ouvre une Pull Request sur GitHub.

Le responsable du depot relira la PR et la fusionnera dans main. Ne pousse jamais
directement sur main/master sur les depots partages. Pour un depot ou c'est legitime,
declare-le dans ~/.claude/.push-main-allowed (une ligne \"owner/repo\", joker '*' admis)."

jq -n --arg r "$MSG" '{
    hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: $r
    }
}'

exit 0

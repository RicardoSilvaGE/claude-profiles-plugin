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
#   - 10.11.2026, douze FAUX NEGATIFS (audit, constat AC-B2) : `"main"` entre guillemets,
#     `main&`, `(git push origin main)`, `main>/dev/null`, et depuis main `git push -u origin
#     HEAD` — la forme idiomatique qu'un agent ecrit —, `@`, `-o ci.skip`, `git push fork`,
#     `git push 2>&1`. Corrige en NORMALISANT les arguments (guillemets retires, redirections
#     effacees, coupure au premier `|`, `&`, `)`) et en lisant la grammaire de git : le premier
#     argument positionnel est le DEPOT, les suivants sont les refspecs ; `HEAD` et `@` designent
#     la branche courante.
#   - 25.11.2026, push de main SILENCIEUX : la branche du push nu se lisait dans le cwd de la
#     session, et `cd <clone sur main> && git push` (ou `git -C <clone sur main> push`) passait
#     depuis une session sur une branche. Corrige en suivant les `cd` et `git -C` quand c'est
#     sur (section 1 bis), cas K du banc. Le meme jour, `git -c user.name="P N" push origin
#     main` passait aussi : la valeur a segment quote coupait le motif (cas D19).
#
# EXEMPTIONS (fichier ~/.claude/.push-main-allowed, optionnel, ABSENT PAR DEFAUT = garde-fou
# partout) : une ligne = un motif "owner/repo", joker `*` admis, `#` commentaire. Le depot
# courant est identifie par le remote `origin` (HTTPS ou SSH), compare en minuscules.
#
# LIMITES ASSUMEES (garde-fou cote outil, PAS une barriere de securite) :
#   - Une refspec portee par une variable (`B=main; git push origin $B`) n'est pas resolue.
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
# Une option globale : -C <val> / -c <val>, ou --long[=val] / -x. Une valeur peut etre quotee en
# entier ("a b") ou porter un segment quote apres un prefixe nu (`-c user.name="Prenom Nom"`) :
# avant le 25.11.2026 cette seconde forme coupait le motif, et `git -c user.name="P N" push
# origin main` passait EN SILENCE (parite de #517 au poste, cas D19 du banc).
Q='("[^"]*"|'"'"'[^'"'"']*'"'"')'
VAL='([^[:space:]"'"'"']*'"$Q"')+[^[:space:]]*|[^[:space:]]+'
OPT='(-[cC][[:space:]]+('"$VAL"')|--?[[:alnum:]_-]+(=('"$VAL"'))?)'
MOTIF="(^|[^[:alnum:]_])git([[:space:]]+$OPT)*[[:space:]]+push([^[:alnum:]_]|$)"
OPT_C='-C[[:space:]]+("([^"]*)"|'"'"'([^'"'"']*)'"'"'|([^[:space:]"'"'"']+))'

# ---- 1 bis. Dossier d'execution de chaque push (25.11.2026, parite de la regle 0 du poste) ----
# La branche du push nu se lisait dans le cwd de la SESSION, meme quand un `cd X` ou un
# `git -C X` plus tot dans la chaine envoyait le push ailleurs : refus a tort dans un sens, et
# dans l'autre un push de main SILENCIEUX (`cd <clone sur main> && git push` depuis une session
# sur une branche, cas K2 et K4 du banc).
# Le suivi n'est tente que quand il est sur : un `cd`/`pushd <chemin>` qui forme a lui seul une
# instruction. Tout autre mot qui change de dossier (bloc, sous-shell, message de commit qui cite
# un `cd`), un heredoc (`<<`), ou un chemin non resolu (variable, joker, dossier absent, chemin
# Windows non quote dont bash mange les `\`) abandonne le suivi pour TOUTE la commande : on lit
# alors la branche dans le cwd de la session, plus le dossier de chaque `git -C`, et on refuse si
# l'un d'eux est sur main.
SUIVI=1
case "$CMD" in *'<<'*) SUIVI=0 ;; esac
CD_TETE='^[[:space:]]*(cd|pushd)[[:space:]]+("([^"]*)"|'"'"'([^'"'"']*)'"'"'|([^[:space:]"'"'"']+))[[:space:]]*$'
CD_AILLEURS='(^|[^[:alnum:]_.-])(cd|pushd|popd|chdir)([[:space:]]|$)'
resoudre() { # resoudre <base> <chemin> <quote 0|1> : dossier existant, sinon echec
    local b="$1" p="$2"
    case "$p" in ''|*'$'*|*'`'*|*'*'*|*'?'*|'~'*) return 1 ;; esac
    [ "$3" = "0" ] && case "$p" in *'\'*) return 1 ;; esac
    case "$p" in /*|[A-Za-z]:*) ;; *) p="$b/$p" ;; esac
    [ -d "$p" ] || return 1
    printf '%s' "$p"
}
# dossiers_c <base> <tete du motif> : applique les `-C` de la tete a partir de <base>. Ecrit le
# dossier obtenu ; un `-C` non resolu ajoute <base> ET le cwd de la session, et rend 1.
dossiers_c() {
    local base="$1" reste="$2" v q d ok=0
    while [[ "$reste" =~ $OPT_C ]]; do
        if [ -n "${BASH_REMATCH[4]}" ]; then v="${BASH_REMATCH[4]}"; q=0; else v="${BASH_REMATCH[2]}${BASH_REMATCH[3]}"; q=1; fi
        reste="${reste#*"${BASH_REMATCH[0]}"}"
        if d="$(resoudre "$base" "$v" "$q")"; then base="$d"; else ok=1; printf '%s\n' "$CWD"; fi
    done
    printf '%s\n' "$base"
    return $ok
}

# ---- 2. Decoupage par instruction, puis on ne garde que ce qui SUIT le premier `push` ----------
# Un `|` simple n'est PAS un separateur : `git push origin main | tee log` reste un push.
ARGS_L=(); DIRS_S=(); DIRS_R=()
NB_PUSH=0
DIR="$CWD"
while IFS= read -r stmt; do
    [ -n "$stmt" ] || continue
    if [ "$SUIVI" -eq 1 ]; then
        if [[ "$stmt" =~ $CD_TETE ]]; then
            if [ -n "${BASH_REMATCH[5]}" ]; then c="${BASH_REMATCH[5]}"; q=0; else c="${BASH_REMATCH[3]}${BASH_REMATCH[4]}"; q=1; fi
            if d="$(resoudre "$DIR" "$c" "$q")"; then DIR="$d"; else SUIVI=0; fi
            continue
        fi
        [[ "$stmt" =~ $CD_AILLEURS ]] && SUIVI=0
    fi
    if [[ "$stmt" =~ $MOTIF ]]; then
        tete="${BASH_REMATCH[0]}"
        # ${var#*X} retire le PLUS COURT prefixe : premiere occurrence, non gourmand.
        ARGS_L+=("${stmt#*"$tete"}")
        DIRS_S+=("$(dossiers_c "$DIR" "$tete")")
        DIRS_R+=("$(printf '%s\n' "$CWD"; dossiers_c "$CWD" "$tete")")
        NB_PUSH=$((NB_PUSH + 1))
    fi
done <<EOF
$(printf '%s\n' "$CMD" | awk '{ gsub(/;|&&|\|\|/, "\n"); print }')
EOF
[ "$NB_PUSH" -gt 0 ] || exit 0

# ---- 2 bis. Normalisation des arguments (audit du 10.11.2026, AC-B2) ---------------------------
# Guillemets retires (`"main"` est main pour git), redirections effacees avec leur cible
# (`main>/dev/null`, `2>&1`), coupure au premier `|`, `&`, `)` ou accent grave (ce qui suit
# n'appartient plus au push), `(` neutralise. Parite : Normaliser-ArgsPush de guard-poste.ps1.
normaliser() {
    printf '%s\n' "$1" | sed -E \
        -e "s/[\"']//g" \
        -e 's/[0-9]*(>>?|<)(&[0-9-]+|[[:space:]]*[^[:space:]&|;()]+)?/ /g' \
        -e 's/[|&)`].*$//' \
        -e 's/[(]/ /g'
}
for i in "${!ARGS_L[@]}"; do ARGS_L[$i]="$(normaliser "${ARGS_L[$i]}")"; done

# ---- 3. Reference explicite a main/master, ou --all / --mirror ---------------------------------
BLOQUE=0
for a in "${ARGS_L[@]}"; do
    # `+` capte le force-push par refspec (`git push origin +main`) ; `:` la forme HEAD:main.
    printf '%s' "$a" | grep -Eq '(^|[[:space:]:/+])(main|master)($|[[:space:]:])' && BLOQUE=1
    printf '%s' "$a" | grep -Eq '(^|[[:space:]])(--all|--mirror)([[:space:]]|$)' && BLOQUE=1
done

# ---- 4. Push « nu » alors que la branche du dossier ou il s'execute est main/master ------------
# Dossier(s) de chaque push : le suivi (1 bis) s'il a tenu sur toute la commande, sinon le cwd de
# la session et les `git -C`. Un seul de ces dossiers sur main suffit.
sur_main() {
    local d
    while IFS= read -r d; do
        [ -n "$d" ] || continue
        case "$(git -C "$d" rev-parse --abbrev-ref HEAD 2>/dev/null)" in
            main|master|Main|Master|MAIN|MASTER) return 0 ;;
        esac
    done <<<"$1"
    return 1
}
if [ "$BLOQUE" -eq 0 ]; then
    for i in "${!ARGS_L[@]}"; do
        if [ "$SUIVI" -eq 1 ]; then dirs="${DIRS_S[$i]}"; else dirs="${DIRS_R[$i]}"; fi
        sur_main "$dirs" || continue
        # Grammaire de git : `git push [options] [<depot> [<refspec>...]]`. Le PREMIER
        # positionnel est le depot, quel que soit son nom (jusqu'au 10.11.2026 seuls
        # origin/upstream l'etaient, et `git push fork` passait). Sans refspec, ou avec la
        # refspec `HEAD`/`@`, c'est la branche courante, donc main, qui part.
        read -ra toks <<<"${ARGS_L[$i]}"
        npos=0; nrefs=0; courante=0; sauter=0
        for tok in "${toks[@]+"${toks[@]}"}"; do
            if [ "$sauter" -eq 1 ]; then sauter=0; continue; fi
            case "$tok" in
                -o|--push-option|--repo|--receive-pack|--exec) sauter=1; continue ;;
                -*) continue ;;
            esac
            npos=$((npos + 1))
            [ "$npos" -eq 1 ] && continue
            nrefs=$((nrefs + 1))
            case "$tok" in HEAD|+HEAD|@|+@) courante=1 ;; esac
        done
        if [ "$nrefs" -eq 0 ] || [ "$courante" -eq 1 ]; then BLOQUE=1; fi
    done
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
            # Le motif NON quote est le joker voulu (`owner/*`).
            # shellcheck disable=SC2254
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
declare-le dans ~/.claude/.push-main-allowed (une ligne \"owner/repo\", joker '*' admis).
ATTENTION : c'est la commande ENTIERE qui a ete refusee. Si elle enchainait d'autres
instructions (git add, git commit...), AUCUNE n'a ete executee : rejoue-les sans le push,
puis verifie par git log que le commit existe avant de l'annoncer."

jq -n --arg r "$MSG" '{
    hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: $r
    }
}'

exit 0

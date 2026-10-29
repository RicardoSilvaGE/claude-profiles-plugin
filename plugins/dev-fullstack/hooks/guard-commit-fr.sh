#!/usr/bin/env bash
# ==============================================================================================
# guard-commit-fr.sh — hook PreToolUse (matcher Bash) d'un profil empaquete en plugin.
#
# CE QU'IL FAIT. Refuse (`deny`) un `git commit` dont le SUJET — premiere ligne du message
# passe par -m, --message ou par la forme heredoc `-m "$(cat <<'EOF' ... EOF)"` — ne suit pas la
# convention git du profil : `type(scope): description`, TYPE FRANCAIS sans accent, pris dans
# la table fonctionnalite | correctif | entretien | doc | refonte | test | portage (ce dernier,
# sans equivalent anglais, pour un report venu d'un depot jumeau : audit du 17.10.2026, AC-10,
# six commits ainsi types refuses en usage). Il ne juge que le
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
#   - un commit sans message en ligne : editeur, --amend --no-edit, --help ;
#   - un message par fichier (-F/--file) qu'on ne peut pas lire : fichier absent, chemin dans
#     une variable, entree standard venue d'un tube. Lisible, il est juge (22.10.2026) ;
#   - un sujet illisible dans la commande : `-m "$MSG"`, `${X}`, `$(...)`, accents graves, dans
#     une zone que le shell developpe (29.10.2026) ;
#   - tout ce qui n'est pas `git [options globales] commit` ;
#   - les depots declares dans ~/.claude/.commit-fr-exempt (« owner/repo », joker `*`) — c'est
#     la clause « rouvrir si un depot passe public » de la doctrine, rendue locale et sans
#     commit ; CLAUDE_GUARD_COMMIT_FR=0 coupe le garde.
#
# SEUL UN COMMIT EN TETE D'INSTRUCTION EST JUGE (29.10.2026) : debut de commande, ou apres ';',
# '&', '|', '(', '{', saut de ligne, hors chaine, corps de heredoc et commentaire. Un
# `grep "git commit"`, un `echo`, un --body de PR ou un corps de heredoc qui cite un commit
# n'est pas un commit (sonde du 29.10.2026 : ils etaient refuses, et un corps de heredoc
# conforme masquait le vrai commit qui le suivait).
#
# LIMITES ASSUMEES : ne voit que l'outil Bash (pas les outils MCP GitHub) ; une commande portee
# par un $(...) entre guillemets doubles n'est pas jugee ; seul le PREMIER -m est lu (c'est le
# sujet). Fail-open : jq absent, payload vide ou invalide, message introuvable -> silence, exit 0.
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
RE_F="(^|[[:space:]])(-[a-zA-Z]*F[[:space:]]*|--file(=|[[:space:]]+))(${DQ}([^${DQ}]*)${DQ}|${SQ}([^${SQ}]*)${SQ}|([^[:space:]]+))"

# PAS DE DECOUPAGE PAR INSTRUCTION AVANT L'EXTRACTION. La premiere version decoupait sur ';',
# '&&' et '||' comme guard-push-main.sh, puis cherchait le commit dans chaque instruction. Un
# message qui CONTIENT un point-virgule ("... tel quel a git checkout ; sous Linux ...") etait
# coupe avant son guillemet fermant, l'extraction tombait sur le mot sans espace
# `"correctif(tests):`, guillemet compris, et un commit conforme etait refuse. Trouve en usage
# reel le 05.09.2026, sur le commit qui corrigeait un autre banc - et d'abord attribue a tort a
# l'antislash du meme message (le diagnostic fautif est dans l'historique du depot, 6ea7be9).
# On cherche donc le premier `git [options] commit` dans la commande ENTIERE, et l'extraction
# du message est elle-meme bornee par les guillemets : un ';' dedans n'est plus un separateur.
# Borne la zone d'extraction aux ARGUMENTS DU COMMIT : on s'arrete au premier ';', '&&', '||'
# ou saut de ligne qui n'est PAS dans une chaine. Sans cela, une instruction POSTERIEURE au
# commit portant une option qui finit par la lettre 'm' est capturee comme sujet, et un commit
# dont le message vit dans un fichier (-F) est refuse. Mesure du 16.09.2026, en usage reel sur
# le depot bureau : `git commit -F msg.txt; ... -Algorithm SHA256` refuse, avec un sujet annonce
# valant "SHA256).Hash". Le `exit 0` prevu pour -F n'etait jamais atteint, la branche RE_M
# matchant avant lui.
# On ne peut PAS revenir au decoupage par instruction de l'origine (voir le commentaire
# ci-dessus) : il coupait un ';' place DANS le message. D'ou un decoupage qui SUIT les
# guillemets -- un separateur n'en est un qu'hors chaine.
# LIMITE ASSUMEE, identique a celle des motifs d'extraction : l'echappement d'un guillemet
# par antislash n'est pas suivi, pas plus que ne le font les classes [^"] et [^'].
borner_args() {
    local s="$1" n i c suiv q out
    n=${#s}; i=0; q=''; out=''
    while [ "$i" -lt "$n" ]; do
        c="${s:$i:1}"
        if [ -n "$q" ]; then
            [ "$c" = "$q" ] && q=''
        else
            suiv="${s:$((i+1)):1}"
            case "$c" in
                '"'|"'") q="$c" ;;
                ';') break ;;
                '&') [ "$suiv" = '&' ] && break ;;
                '|') [ "$suiv" = '|' ] && break ;;
                '
') break ;;
            esac
        fi
        out="$out$c"
        i=$((i+1))
    done
    printf '%s' "$out"
}

# Imprime ce qui SUIT le premier `git [options] commit` place en TETE D'INSTRUCTION ; code 1 s'il
# n'y en a aucun. Tete : debut de la commande, ou apres ';', '&', '|', '(', '{' ou un saut de
# ligne, hors chaine, eventuellement precede d'affectations NOM=valeur, de env, then, do, else,
# time ou '!'. Le parcours suit les guillemets et l'antislash, saute les corps de heredoc
# (<<MARQ jusqu'a la ligne MARQ) et les commentaires ('#' en debut de mot). Parite : fonction
# Trouver-CommitEnTete de scripts/guard-poste.ps1. Locale C : l'indexation ${s:i:1} reste en
# temps constant (en UTF-8 elle recompte depuis le debut), seuls des delimiteurs ASCII comptent.
RE_TETE="^[[:space:]]*((then|do|else|time|env|!)[[:space:]]+|[A-Za-z_][A-Za-z0-9_]*=(${DQ}[^${DQ}]*${DQ}|${SQ}[^${SQ}]*${SQ}|[^[:space:]]*)[[:space:]]+|&[[:space:]]*)*git([[:space:]]+$OPT)*[[:space:]]+commit([^[:alnum:]_-]|$)"
RE_HEREDOC_TETE="^<<-?[[:blank:]]*[${SQ}${DQ}]?([A-Za-z_][A-Za-z0-9_]*)[${SQ}${DQ}]?"
commit_en_tete() {
    local LC_ALL=C
    local s="$1" n i c q='' tete=1 marqueur='' reste avant ligne prec p clos
    n=${#s}; i=0
    while [ "$i" -lt "$n" ]; do
        if [ -n "$q" ]; then
            # Saut direct au guillemet fermant (ou a l'antislash, entre guillemets doubles) : un
            # corps de PR de 8 Ko entre guillemets coutait 1,4 s caractere par caractere.
            reste="${s:$i}"
            if [ "$q" = '"' ]; then avant="${reste%%[\"\\]*}"; else avant="${reste%%\'*}"; fi
            i=$((i + ${#avant}))
            [ "$i" -lt "$n" ] || break
            if [ "${s:$i:1}" = '\' ]; then i=$((i+2)); continue; fi
            q=''; i=$((i+1)); continue
        fi
        if [ "$tete" -eq 1 ]; then
            if [[ "${s:$i}" =~ $RE_TETE ]]; then printf '%s' "${s:$((i + ${#BASH_REMATCH[0]}))}"; return 0; fi
            tete=0
        fi
        c="${s:$i:1}"
        case "$c" in
            '\') i=$((i+2)); continue ;;
            $'\n')
                if [ -n "$marqueur" ]; then
                    # Corps du heredoc : de la ligne suivante jusqu'a la ligne du marqueur incluse.
                    p=$((i+1)); clos=0
                    while [ "$p" -le "$n" ]; do
                        ligne="${s:$p}"; ligne="${ligne%%$'\n'*}"
                        if [ "${ligne//[[:space:]]/}" = "$marqueur" ]; then clos=1; p=$((p + ${#ligne})); break; fi
                        p=$((p + ${#ligne} + 1))
                    done
                    marqueur=''
                    [ "$clos" -eq 1 ] || return 1
                    i=$p
                fi
                tete=1; i=$((i+1)); continue ;;
            '"'|"'") q="$c"; i=$((i+1)); continue ;;
            '#')
                prec="${s:$((i-1)):1}"
                if [ "$i" -eq 0 ] || [[ "$prec" =~ ^[[:space:]\;\&\|]$ ]]; then
                    reste="${s:$i}"
                    case "$reste" in *$'\n'*) ligne="${reste%%$'\n'*}"; i=$((i + ${#ligne})); continue ;; *) return 1 ;; esac
                fi ;;
            '<')
                if [ "${s:$i:3}" = '<<<' ]; then i=$((i+3)); continue; fi
                if [[ "${s:$i}" =~ $RE_HEREDOC_TETE ]]; then
                    marqueur="${BASH_REMATCH[1]}"; i=$((i + ${#BASH_REMATCH[0]})); continue
                fi ;;
            ';'|'&'|'|'|'('|'{') tete=1 ;;
        esac
        i=$((i+1))
    done
    return 1
}

# Sujet d'un message passe par FICHIER (-F <chemin>, --file=<chemin>) ou par l'entree standard
# alimentee d'un heredoc (`git commit -F - <<'EOF'`) : premiere ligne non vide, ou rien.
# MOTIF, 22.10.2026 : -F passait sans examen ; deux commits `ci(...)` hors convention sont passes
# ainsi (par fichier, et par `-F -` + heredoc), le troisieme, en -m, a ete refuse. Le garde
# gardait une forme d'appel, pas la convention. Fail-open sur tout ce qui ne se lit pas ; un
# chemin relatif se resout contre le cwd de la session (apres un `cd` ou un `git -C`, il peut
# ne pas se trouver, et la regle se tait). $1 : arguments bornes ; $2 : les memes, non bornes,
# d'ou se lit le corps du heredoc (borner_args coupe au saut de ligne).
lire_message_fichier() {
    local args="$1" brut="$2" chemin marqueur corps ligne
    [[ "$args" =~ $RE_F ]] || return 0
    chemin="${BASH_REMATCH[5]}${BASH_REMATCH[6]}${BASH_REMATCH[7]}"
    if [ "$chemin" = "-" ]; then
        [[ "$args" =~ $RE_HEREDOC ]] || return 0
        marqueur="${BASH_REMATCH[1]}"
        corps="${brut#*"${BASH_REMATCH[0]}"}"
        corps="${corps#*$'\n'}"
        while IFS= read -r ligne; do
            [ "$(printf '%s' "$ligne" | tr -d '[:space:]')" = "$marqueur" ] && return 0
            if [ -n "$(printf '%s' "$ligne" | tr -d '[:space:]')" ]; then printf '%s' "$ligne"; return 0; fi
        done <<EOF_CORPS_F
$corps
EOF_CORPS_F
        return 0
    fi
    case "$chemin" in "~/"*) chemin="${HOME:-/nonexistent}/${chemin#"~/"}" ;; esac
    case "$chemin" in /*|[A-Za-z]:*) ;; *) chemin="$CWD/$chemin" ;; esac
    [ -f "$chemin" ] && [ -r "$chemin" ] || return 0
    while IFS= read -r ligne || [ -n "$ligne" ]; do
        ligne="${ligne%$'\r'}"
        if [ -n "$(printf '%s' "$ligne" | tr -d '[:space:]')" ]; then printf '%s' "$ligne"; return 0; fi
    done < "$chemin"
    return 0
}

SUJET=""; TROUVE=0
# DEVELOPPE=1 : le texte extrait vit dans une zone que le SHELL developpe (guillemets doubles, mot
# nu, heredoc a marqueur nu). Entre apostrophes, dans un heredoc a marqueur cite ou dans un
# fichier, un `$` reste un `$` et le sujet se juge a la lettre.
DEVELOPPE=0
# Le motif sur la commande entiere n'est qu'un pre-filtre bon marche : c'est commit_en_tete qui
# decide si un commit est en tete d'instruction, et d'ou partent ses arguments.
if [[ "$CMD" =~ $MOTIF ]] && rest="$(commit_en_tete "$CMD")"; then
    TROUVE=1
    rest_brut="$rest"
    rest="$(borner_args "$rest")"
    msg=""
    if [[ "$rest" =~ $RE_HEREDOC ]]; then
        case "${BASH_REMATCH[0]}" in *"$SQ"*|*"$DQ"*) DEVELOPPE=0 ;; *) DEVELOPPE=1 ;; esac
        marqueur="${BASH_REMATCH[1]}"
        corps="${rest#*"${BASH_REMATCH[0]}"}"
        corps="${corps#*$'\n'}"                                   # ce qui suit la ligne du marqueur
        while IFS= read -r ligne; do
            [ "$(printf '%s' "$ligne" | tr -d '[:space:]')" = "$marqueur" ] && break
            if [ -n "$(printf '%s' "$ligne" | tr -d '[:space:]')" ]; then msg="$ligne"; break; fi
        done <<EOF_CORPS
$corps
EOF_CORPS
        # Corps absent de la zone bornee : le heredoc alimente l'entree standard de `-F -`
        # (22.10.2026), il ne vit pas dans un -m "$(cat <<EOF ...)".
        [ -n "$msg" ] || msg="$(lire_message_fichier "$rest" "$rest_brut")"
    elif [[ "$rest" =~ $RE_MESSAGE ]]; then
        case "${BASH_REMATCH[1]}" in "$SQ"*) DEVELOPPE=0 ;; *) DEVELOPPE=1 ;; esac
        msg="${BASH_REMATCH[2]}${BASH_REMATCH[3]}${BASH_REMATCH[4]}"
    elif [[ "$rest" =~ $RE_M ]]; then
        case "${BASH_REMATCH[2]}" in "$SQ"*) DEVELOPPE=0 ;; *) DEVELOPPE=1 ;; esac
        msg="${BASH_REMATCH[3]}${BASH_REMATCH[4]}${BASH_REMATCH[5]}"
    else
        msg="$(lire_message_fichier "$rest" "$rest_brut")"            # -F / --file, lu depuis le 22.10.2026
        [ -n "$msg" ] || exit 0                                    # editeur, --amend --no-edit, --help, fichier illisible
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
printf '%s' "$SUJET" | grep -Eq '^(fonctionnalite|correctif|entretien|doc|refonte|test|portage)\([^)]+\)!?: [^[:space:]]' && exit 0

# Sujet ILLISIBLE dans la commande : variable ($X, ${X}), substitution $(...) ou accents graves,
# dans une zone que le shell developpe. Le hook ne lit que le texte de la commande, pas ce que le
# shell en fera : il ne juge pas, il ne devine pas, il laisse passer. MOTIF : `git commit -m "$MSG"`
# refuse avec un sujet annonce "$MSG" (sessions du 22 au 29.10.2026). LIMITE ASSUMEE :
# `-m "Fix $V"` passe aussi, le sujet entier etant inconnu. Le `-F -` alimente d'un heredoc suit
# la meme regle que le heredoc ; un fichier, lu tel quel, est toujours juge.
# shellcheck disable=SC2016
[ "$DEVELOPPE" -eq 1 ] && printf '%s' "$SUJET" | grep -Eq '[$][A-Za-z_{(0-9]|`' && exit 0

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
  et portage : report d'un changement venu d'un depot jumeau
Exemple : correctif(readme): coquille corrigee dans la procedure
Le type est un jeton qu'on grep ; la description s'accentue normalement. Merge, Revert, fixup!
et squash! passent tels quels. Pour un depot qui adopte une autre convention (historique
ouvert, outil qui lit le type), declare-le dans ~/.claude/.commit-fr-exempt (une ligne
\"owner/repo\", joker '*' admis) ; CLAUDE_GUARD_COMMIT_FR=0 coupe le garde."
jq -n --arg r "$MSG" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
exit 0

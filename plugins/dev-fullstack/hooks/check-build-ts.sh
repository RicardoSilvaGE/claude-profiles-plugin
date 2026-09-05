#!/usr/bin/env bash
# ==============================================================================================
# check-build-ts.sh — hook Stop d'un profil empaquete en plugin.
#
# CE QU'IL FAIT, ET POURQUOI IL EXISTE.
# La regle absolue spec-builder a trois etages, et le premier — « < 10 lignes : aucune spec » —
# repose sur un filet MECANIQUE : « le filet est check-build-ts.ps1 (Stop), pas une spec ». Ce
# hook compile TypeScript (tsc --noEmit) quand la session a laisse des .ts/.tsx modifies, et
# bloque la fin de tour avec la liste des erreurs. DEPUIS LE 05.09.2026 (audit D4 : sept depots
# reels sur huit n'ont pas de tsconfig.json, donc n'avaient AUCUN filet), un depot sans
# tsconfig.json est couvert aussi : script build/check/lint de package.json si node_modules/
# existe, sinon node --check sur les .js/.mjs/.cjs touches, et la syntaxe Python des .py touches.
# Cadrage : docs/SPEC-lite-check-build-hors-ts.md. C'est le controle qui aurait attrape
# l'accolade orpheline du 19.05.2026, incident fondateur de la regle : la mitigation posee ce
# jour-la etait DOCTRINALE (« passer par une spec ») la ou elle devait etre MECANIQUE (« le code
# compile-t-il ? »). Il ne remplace pas la revue : il rend impossible de terminer une session sur
# un projet TypeScript casse sans en avoir ete averti.
#
# Comme guard-spec-code.ps1, le hook du poste est declare dans le settings-fragment.json du
# profil, que build-plugin.sh ne copie pas. Apres le portage du garde PreToolUse, le plugin
# opposait les etages 2 et 3 ; plus rien ne couvrait le premier. Ce fichier ferme la boucle.
#
# CONTRAIREMENT A guard-spec-code.sh, IL FAIT LE MEME EFFET EN CLOUD QU'AU POSTE. Un
# `decision: block` sur Stop n'est pas une decision de permission : la documentation Claude Code
# (hooks.md, « Stop decision control ») ne le soumet a aucun permission_mode. Il empeche la fin
# de tour et remet le `reason` au modele, en `default` comme en `bypassPermissions`.
#
# DECLENCHEMENT (les quatre conditions, sinon exit 0 silencieux) :
#   1. Le dossier de travail est un depot git (un .git A SA RACINE — pas de remontee, comme le
#      hook PowerShell ; le Stop se joue sur le cwd de la session, pas sur un fichier).
#   2. Avec un tsconfig.json a sa racine : branche TypeScript (conditions 3 et 4). Sans : branche
#      « hors TypeScript », declenchee par un .js/.mjs/.cjs/.jsx ou un .py modifie ou ajoute
#      (hors node_modules/, dist/, build/, vendor/, .min.js).
#   3. git status signale au moins un .ts/.tsx/.mts/.cts modifie ou ajoute (hors .d.ts).
#      --untracked-files=all est OBLIGATOIRE : sans lui, git regroupe un dossier entierement non
#      suivi en une seule ligne (« ?? src/ ») et un dossier de composants cree pendant la session
#      devient invisible du hook. Constate au banc du 17.08.2026 sur le poste.
#   4. Un compilateur tsc est joignable : node_modules/.bin/tsc du depot en priorite (sa version
#      fait foi), sinon le tsc du PATH. Jamais npx : sans --no-install il peut telecharger, avec
#      il n'apporte rien de plus.
#
# GARANTIES ANTI-BOUCLE :
#   - stop_hook_active = true => exit 0 immediat. Documente par Anthropic : « true when Claude
#     Code is already continuing as a result of a stop hook. Check this value [...] to avoid
#     blocking on a condition that will never resolve. » Plafond harness : 8 continuations.
#   - marqueur build-<session>-<cle>.flag, pose AVANT la compilation : une compilation qui echoue
#     ne doit pas se rejouer a chaque stop. Un seul rapport par session et par depot.
#
# COUT : tsc --noEmit prend 5 a 30 s sur un projet moyen. Une seule fois par session, et
# seulement si des .ts ont bouge. Timeout dur a 90 s, au-dela on abandonne en silence plutot que
# de faire attendre. Le timeout declare dans hooks.json (100 s) doit rester SUPERIEUR, sinon le
# harness tue le hook avant qu'il ne rende son verdict. L'attente est une boucle `sleep 1` +
# `kill` : une seule voie, POSIX, sans dependre de coreutils — une voie unique est une voie
# testee, deux voies dont l'une ne tourne jamais au banc n'en sont pas.
#
# CE QU'IL NE DIT PAS : si le depot etait DEJA casse avant la session, le hook le signale quand
# meme. Il rapporte l'ETAT, il n'attribue pas la faute — et le message le dit, pour qu'un
# heritage ne soit pas lu comme une regression de la session.
#
# FAIL-OPEN PAR CONSTRUCTION : jq absent, payload vide ou invalide, cwd introuvable, marqueur non
# ecrivable, tsc introuvable, timeout — le hook se tait et sort en 0. Et si tsc rend un code non
# nul SANS aucune ligne `error TSxxxx`, il se tait aussi : ce n'est pas un build casse, c'est
# autre chose, et l'inventer serait pire. Meme regle hors TypeScript : node --check et Python ne
# bloquent que sur une ligne `SyntaxError` ; npm run ne bloque pas si sa sortie dit `: not found`
# (outil absent, pas code casse). Un .js dont la seule erreur est « Unexpected token
# '<' » est du JSX charge par Babel in-browser, le montage reel de plusieurs depots vanilla :
# ignore, plutot qu'un faux positif a chaque fin de tour. Le JSX d'un .js ou d'un .html n'est
# donc PAS couvert, et c'est ecrit. CLAUDE_CHECK_BUILD_TS=0 desactive le hook.
# ==============================================================================================
set -uo pipefail

[ "${CLAUDE_CHECK_BUILD_TS:-1}" = "0" ] && exit 0

command -v jq >/dev/null 2>&1 || { echo "check-build-ts: jq absent, filet non pose" >&2; exit 0; }

RAW="$(cat)"
[ -n "$RAW" ] || exit 0
printf '%s' "$RAW" | jq -e . >/dev/null 2>&1 || exit 0

lire() { printf '%s' "$RAW" | jq -r "$1 // empty" 2>/dev/null; }

# ---- 1. Anti-boucle ----------------------------------------------------------------------------
[ "$(lire '.stop_hook_active')" = "true" ] && exit 0

# ---- 2. Dossier de travail ---------------------------------------------------------------------
CWD="$(lire '.cwd')"; [ -n "$CWD" ] || CWD="$PWD"
[ -d "$CWD" ] || exit 0

# ---- 3 et 4. Depot git ; avec ou sans tsconfig.json -----------------------------------------------
[ -e "$CWD/.git" ] || exit 0
if [ -f "$CWD/tsconfig.json" ]; then BRANCHE=ts; else BRANCHE=autre; fi

# ---- 5. Des sources ont-elles bouge ? ---------------------------------------------------------------
STATUT="$(git -C "$CWD" status --porcelain --untracked-files=all 2>/dev/null)" || exit 0
[ -n "$STATUT" ] || exit 0
# Chemins des lignes de statut (hors suppressions ; un renommage garde sa destination).
CHEMINS="$(printf '%s\n' "$STATUT" | grep -Ev '^ ?D' | sed -E 's/^.. //; s/^.* -> //; s/^"(.*)"$/\1/' \
    | grep -Ev '(^|/)(node_modules|dist|build|vendor)/' | grep -Eiv '\.min\.js$')"
if [ "$BRANCHE" = ts ]; then
    TOUCHES="$(printf '%s\n' "$STATUT" | grep -Ei '\.(ts|tsx|mts|cts)$' | grep -Eiv '\.d\.ts$')"
    [ -n "$TOUCHES" ] || exit 0
    NB_TOUCHES="$(printf '%s\n' "$TOUCHES" | grep -c .)"
else
    TOUCHES_JS="$(printf '%s\n' "$CHEMINS" | grep -Ei '\.(js|mjs|cjs|jsx)$')"
    TOUCHES_PY="$(printf '%s\n' "$CHEMINS" | grep -Ei '\.py$')"
    [ -n "$TOUCHES_JS$TOUCHES_PY" ] || exit 0
fi

# ---- 6. Marqueur AVANT la compilation ----------------------------------------------------------
SID="$(lire '.session_id')"; [ -n "$SID" ] || SID="nosession"
SID="$(printf '%s' "$SID" | tr -c 'A-Za-z0-9_.-' '_' | cut -c1-64)"

if command -v cksum >/dev/null 2>&1; then
    CLE="$(printf '%s' "$CWD" | cksum | tr -cd '0-9')"
elif command -v md5sum >/dev/null 2>&1; then
    CLE="$(printf '%s' "$CWD" | md5sum | cut -d' ' -f1)"
else
    CLE="$(printf '%s' "$CWD" | tr -c 'A-Za-z0-9_.-' '_' | cut -c1-64)"
fi
[ -n "$CLE" ] || CLE="nokey"

DIR_MARQ="${TMPDIR:-/tmp}/claude-guard"
mkdir -p "$DIR_MARQ" 2>/dev/null || exit 0
MARQ="$DIR_MARQ/build-$SID-$CLE.flag"
[ -f "$MARQ" ] && exit 0
: > "$MARQ" 2>/dev/null || exit 0

# ---- 6bis. Branche HORS TYPESCRIPT (05.09.2026) -------------------------------------------------------
# Trois verifications, dans cet ordre, toutes en fail-open. Un seul rapport, qui les cumule.
attendre() { # attendre <pid> : boucle sleep 1 + kill a 90 s, une seule voie, POSIX. Rend 124 si tue.
    local pid="$1" i=0
    while kill -0 "$pid" 2>/dev/null && [ "$i" -lt 90 ]; do sleep 1; i=$((i + 1)); done
    if kill -0 "$pid" 2>/dev/null; then kill "$pid" 2>/dev/null; wait "$pid" 2>/dev/null; return 124; fi
    wait "$pid"
}
if [ "$BRANCHE" = autre ]; then
    RAPPORT=""; OUTILS=""
    # (a) npm run <build|check|lint> : seulement si package.json le declare, que node_modules/ existe
    #     (sinon c'est un clone frais, pas un depot casse) et que npm est joignable.
    SCRIPT=""
    if [ -n "$TOUCHES_JS" ] && [ -f "$CWD/package.json" ] && [ -d "$CWD/node_modules" ] && command -v npm >/dev/null 2>&1; then
        for s in build check lint; do
            if [ -n "$(jq -r --arg s "$s" '.scripts[$s] // empty' "$CWD/package.json" 2>/dev/null)" ]; then SCRIPT="$s"; break; fi
        done
    fi
    if [ -n "$SCRIPT" ]; then
        OUT="$DIR_MARQ/npm-$CLE.out"
        (cd "$CWD" && exec npm run --silent "$SCRIPT") > "$OUT" 2>&1 &
        attendre $!; CODE=$?
        if [ "$CODE" -ne 0 ] && [ "$CODE" -ne 124 ] && ! grep -Eqi '(: |command )not found' "$OUT" 2>/dev/null; then
            RAPPORT="$RAPPORT$(tail -n 12 "$OUT" 2>/dev/null)
"
            OUTILS="$OUTILS  npm run $SCRIPT : code $CODE
"
        fi
    elif [ -n "$TOUCHES_JS" ] && command -v node >/dev/null 2>&1; then
        # (b) node --check, fichier par fichier ; jamais un .jsx (extension refusee par node).
        NB_JS=0; ERR_JS=""
        while IFS= read -r f; do
            [ -n "$f" ] || continue
            case "$f" in *.jsx|*.JSX) continue ;; esac
            [ -f "$CWD/$f" ] || continue
            NB_JS=$((NB_JS + 1))
            SORTIE="$(cd "$CWD" && node --check "$f" 2>&1)"
            [ $? -eq 0 ] && continue
            LIGNE="$(printf '%s\n' "$SORTIE" | grep -m1 'SyntaxError')"
            [ -n "$LIGNE" ] || continue
            # JSX dans un .js (Babel in-browser) : hors perimetre de node --check, pas une erreur du code.
            case "$LIGNE" in *"Unexpected token '<'"*) continue ;; esac
            NUM="$(printf '%s\n' "$SORTIE" | grep -m1 -E "^.*$(printf '%s' "$f" | sed 's/[.[\*^$/]/\\&/g'):[0-9]+" | sed -E 's/.*:([0-9]+)$/\1/')"
            ERR_JS="$ERR_JS$f:${NUM:-?}: $LIGNE
"
        done <<EOF_JS
$TOUCHES_JS
EOF_JS
        if [ -n "$ERR_JS" ]; then RAPPORT="$RAPPORT$ERR_JS"; OUTILS="$OUTILS  node --check : $NB_JS fichier(s) lu(s)
"; fi
    fi
    # (c) Python : ast.parse, jamais py_compile (qui ecrirait un __pycache__/ dans le depot).
    PY=""
    if command -v python3 >/dev/null 2>&1; then PY=python3; elif command -v python >/dev/null 2>&1; then PY=python; fi
    if [ -n "$TOUCHES_PY" ] && [ -n "$PY" ]; then
        ERR_PY="$(cd "$CWD" && printf '%s\n' "$TOUCHES_PY" | "$PY" -c '
import ast, sys
for p in [l.strip() for l in sys.stdin if l.strip()]:
    try:
        ast.parse(open(p, "rb").read(), p)
    except SyntaxError as e:
        print("%s:%s: SyntaxError: %s" % (p, e.lineno, e.msg))
    except OSError:
        pass
' 2>/dev/null)"
        if [ -n "$ERR_PY" ]; then RAPPORT="$RAPPORT$ERR_PY
"; OUTILS="$OUTILS  python (ast.parse) : $(printf '%s\n' "$TOUCHES_PY" | grep -c .) fichier(s) lu(s)
"; fi
    fi
    [ -n "$RAPPORT" ] || exit 0
    NB="$(printf '%s' "$RAPPORT" | grep -c .)"
    EXTRAIT="$(printf '%s' "$RAPPORT" | head -12)"
    RESTE=$((NB - 12)); [ "$RESTE" -lt 0 ] && RESTE=0
    SUITE=""; [ "$RESTE" -gt 0 ] && SUITE="... et $RESTE autre(s) ligne(s).
"
    MSG="BUILD CASSE (hook du profil, depot sans tsconfig.json).

  Depot   : $(basename "$CWD")
  Verifications faites :
$OUTILS
-------- premieres lignes --------
$EXTRAIT
$SUITE----------------------------------

C'est le filet du premier etage de la regle spec-builder (< 10 lignes : pas de spec, mais le
code doit passer) — celui qui aurait attrape l'accolade orpheline du 19.05.2026, et qui n'existait
jusqu'ici que sur les depots TypeScript. Il ne lit pas le JSX d'un .js ou d'un .html.

Attention a l'attribution : le hook rapporte l'ETAT du depot, pas la faute. Si ces erreurs
preexistaient a la session, le dire plutot que de les corriger en passant.

Sorties : corriger, ou constater que l'erreur est heritee et l'annoncer en une ligne.
Ce rapport n'apparait qu'une fois par session et par depot."
    jq -n --arg r "$MSG" '{ decision: "block", reason: $r }'
    exit 0
fi

# ---- 7. Trouver tsc. Le binaire local du projet prime : c'est sa version qui fait foi. ----------
if [ -x "$CWD/node_modules/.bin/tsc" ]; then
    TSC="$CWD/node_modules/.bin/tsc"
elif command -v tsc >/dev/null 2>&1; then
    TSC="$(command -v tsc)"
else
    exit 0
fi

# ---- 8. Compilation, sortie capturee, timeout dur ----------------------------------------------
OUT="$DIR_MARQ/tsc-$CLE.out"
ERR="$DIR_MARQ/tsc-$CLE.err"
(cd "$CWD" && exec "$TSC" --noEmit) > "$OUT" 2> "$ERR" &
PID=$!
i=0
while kill -0 "$PID" 2>/dev/null && [ "$i" -lt 90 ]; do
    sleep 1; i=$((i + 1))
done
if kill -0 "$PID" 2>/dev/null; then
    kill "$PID" 2>/dev/null; wait "$PID" 2>/dev/null
    exit 0   # trop long : on ne fait pas attendre, et on ne rend pas un verdict partiel
fi
wait "$PID"; CODE=$?
[ "$CODE" -eq 0 ] && exit 0

# ---- 9. Ne garder que les vraies erreurs de compilation ------------------------------------------
ERREURS="$(cat "$OUT" "$ERR" 2>/dev/null | grep -E 'error TS[0-9]+')"
[ -n "$ERREURS" ] || exit 0
NB="$(printf '%s\n' "$ERREURS" | grep -c .)"
EXTRAIT="$(printf '%s\n' "$ERREURS" | head -12)"
RESTE=$((NB - 12)); [ "$RESTE" -lt 0 ] && RESTE=0

# ---- 10. Message -------------------------------------------------------------------------------
SUITE=""
[ "$RESTE" -gt 0 ] && SUITE="... et $RESTE autre(s).
"

MSG="BUILD TYPESCRIPT CASSE (hook du profil).

  Depot   : $(basename "$CWD")
  Erreurs : $NB  (tsc --noEmit)
  Sources TypeScript modifiees dans cette session : $NB_TOUCHES

-------- premieres erreurs --------
$EXTRAIT
$SUITE-----------------------------------

C'est le controle qui aurait attrape l'accolade orpheline du 19.05.2026 : build de production
casse par un cleanup en aveugle, detecte par des mails d'erreur GitHub et Vercel plutot que sur
le poste.

Attention a l'attribution : le hook rapporte l'ETAT du depot, pas la faute. Si ces erreurs
preexistaient a la session, le dire plutot que de les corriger en passant.

Sorties : corriger, ou constater que l'erreur est heritee et l'annoncer en une ligne.
Ce rapport n'apparait qu'une fois par session et par depot."

# ---- 11. Sortie : decision et reason A LA RACINE, format documente pour Stop -------------------
jq -n --arg r "$MSG" '{ decision: "block", reason: $r }'

exit 0

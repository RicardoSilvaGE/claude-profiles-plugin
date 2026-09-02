#!/usr/bin/env bash
# ==============================================================================================
# check-build-ts.sh — hook Stop d'un profil empaquete en plugin.
#
# CE QU'IL FAIT, ET POURQUOI IL EXISTE.
# La regle absolue spec-builder a trois etages, et le premier — « < 10 lignes : aucune spec » —
# repose sur un filet MECANIQUE : « le filet est check-build-ts.ps1 (Stop), pas une spec ». Ce
# hook compile TypeScript (tsc --noEmit) quand la session a laisse des .ts/.tsx modifies, et
# bloque la fin de tour avec la liste des erreurs. C'est le controle qui aurait attrape
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
#   2. Il porte un tsconfig.json a sa racine.
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
# autre chose, et l'inventer serait pire. CLAUDE_CHECK_BUILD_TS=0 desactive le hook.
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

# ---- 3 et 4. Depot git portant un tsconfig.json ------------------------------------------------
[ -e "$CWD/.git" ] || exit 0
[ -f "$CWD/tsconfig.json" ] || exit 0

# ---- 5. Des sources TypeScript ont-elles bouge ? -----------------------------------------------
STATUT="$(git -C "$CWD" status --porcelain --untracked-files=all 2>/dev/null)" || exit 0
[ -n "$STATUT" ] || exit 0
TOUCHES="$(printf '%s\n' "$STATUT" | grep -Ei '\.(ts|tsx|mts|cts)$' | grep -Eiv '\.d\.ts$')"
[ -n "$TOUCHES" ] || exit 0
NB_TOUCHES="$(printf '%s\n' "$TOUCHES" | grep -c .)"

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

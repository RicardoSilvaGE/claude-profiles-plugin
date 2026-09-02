#!/usr/bin/env bash
# ==============================================================================================
# guard-spec-code.sh — hook PreToolUse d'un profil empaquete en plugin.
#
# CE QU'IL FAIT, ET POURQUOI IL EXISTE.
# La « Regle absolue spec-builder » (19.05.2026) est opposable sur le POSTE par
# scripts/guard-spec-code.ps1, declare en PreToolUse dans le settings-fragment.json du profil
# dev-fullstack. build-plugin.sh ne copie JAMAIS ce fragment : en session cloud la regle
# n'existait donc que comme phrase au milieu des 34 Ko injectes au demarrage par
# injecter-doctrine.sh. Une regle lue au demarrage et une regle rappelee au moment du geste ne
# valent pas la meme chose. Ce hook porte la seconde.
#
# EN BASH, comme sync-profile.sh, vendor-profile.sh et build-plugin.sh : le conteneur des
# sessions cloud est Linux, aucun .ps1 n'y est executable. Le poste garde son hook PowerShell,
# inchange ; les deux versions vivent sur deux vehicules disjoints.
#
# LA LIMITE A CONNAITRE AVANT DE S'Y FIER. La documentation Claude Code est explicite : « A hook
# with no decision, or with permissionDecision "allow" or "ask", doesn't block; the tool call
# continues through the normal permission flow. » En mode `default` l'utilisateur est donc
# reellement interrompu, comme au poste. En `auto`, `dontAsk` ou `bypassPermissions` — modes
# courants en session cloud — il ne l'est pas, et seul l'additionalContext subsiste. Le hook
# REPORTE le mode qu'il a recu dans son message, pour que cet ecart se mesure au lieu de se
# supposer. Il n'emet JAMAIS `deny` : reprise textuelle de l'en-tete du hook PowerShell, « un
# faux positif bloquant sur une tache urgente detruit la confiance dans tout le dispositif ».
#
# CE QU'IL NE VOIT PAS (exclusions volontaires, cf. la regle elle-meme) :
#   - la configuration du harness Claude Code : .claude/, et tout depot portant
#     templates/profiles (regle structurelle, qui couvre aussi un clone renomme) ;
#   - les tests, la configuration, les artefacts de build, les dependances ;
#   - les docs pures : la regle ne les couvre pas ;
#   - les ecritures passant par Bash plutot que par Write/Edit/NotebookEdit.
#
# AUCUN NOM DE DEPOT PRIVE ICI, ET CE N'EST PAS UN DETAIL. Le hook PowerShell exclut deux depots
# par leur NOM. Ces chaines sont dans MOTIFS_INTERDITS de build-plugin.sh, et
# controler_publiable() grep TOUT l'arbre publiable — les .sh compris, que caviarder() ne
# reecrit pas. Les transposer aurait fait REFUSER `build-plugin.sh --public`. La regle
# structurelle (presence de templates/profiles) les remplace : plus robuste, et publiable.
#
# « SPEC.md existe » est une heuristique de PRESENCE, pas de PERTINENCE : le hook ne sait pas si
# la spec trouvee couvre la tache en cours. Il ne peut donc jamais confirmer qu'une spec est
# bonne, seulement signaler qu'il n'en trouve aucune. Le faux negatif est assume, le harcelement
# ne l'est pas — d'ou aussi le rappel unique par session et par depot.
#
# BORNE ASSUMEE : la recherche des SPEC*.md est bornee a 3 niveaux de profondeur. Le hook
# PowerShell fait un -Recurse non borne ; sur un gros depot cela depasserait le timeout de 10 s.
#
# FAIL-OPEN PAR CONSTRUCTION : jq absent, payload vide ou invalide, chemin illisible, marqueur
# non ecrivable, date de fichier illisible — le hook se tait et sort en 0. Un garde-fou qui
# casse une session n'est plus un garde-fou. CLAUDE_GUARD_SPEC=0 le desactive entierement.
# ==============================================================================================
set -uo pipefail

[ "${CLAUDE_GUARD_SPEC:-1}" = "0" ] && exit 0

command -v jq >/dev/null 2>&1 || { echo "guard-spec-code: jq absent, regle non opposee" >&2; exit 0; }

RAW="$(cat)"
[ -n "$RAW" ] || exit 0
printf '%s' "$RAW" | jq -e . >/dev/null 2>&1 || exit 0   # payload non JSON : on ne sait rien

lire() { printf '%s' "$RAW" | jq -r "$1 // empty" 2>/dev/null; }

# ---- 1. Outil concerne -----------------------------------------------------------------------
case "$(lire '.tool_name')" in Write|Edit|NotebookEdit) ;; *) exit 0 ;; esac

FICHIER="$(lire '.tool_input.file_path')"
[ -n "$FICHIER" ] || exit 0

# ---- 2. Est-ce du code applicatif ? -----------------------------------------------------------
case "$FICHIER" in
    *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.py|*.vue|*.svelte|*.astro|*.go|*.rs|*.rb|*.php) ;;
    *) exit 0 ;;
esac

# ---- 3. Exclusions de chemin : harness, dependances, artefacts, tests --------------------------
EXCLUS='(^|/)(\.claude|node_modules|\.next|dist|build|out|coverage|vendor|__pycache__|\.venv|venv|migrations|__tests__|tests?|e2e|cypress|playwright)/'
printf '%s' "$FICHIER" | grep -Eq "$EXCLUS" && exit 0

# ---- 4. Exclusions de nom de fichier ----------------------------------------------------------
case "$(basename "$FICHIER")" in
    *.test.*|*.spec.*|*_test.*|test_*|*.config.*|*.d.ts|conftest.py|setup.py) exit 0 ;;
esac

# ---- 5. Racine du depot. Hors depot git : on ne sait rien du contexte, on se tait. -------------
CWD="$(lire '.cwd')"
case "$FICHIER" in
    /*) ABS="$FICHIER" ;;
    *)  ABS="${CWD:-$PWD}/$FICHIER" ;;
esac

DEPOT=""
d="$(dirname "$ABS")"; i=0
while [ -n "$d" ] && [ "$d" != "/" ] && [ "$d" != "." ] && [ $i -lt 40 ]; do
    if [ -e "$d/.git" ]; then DEPOT="$d"; break; fi
    d="$(dirname "$d")"; i=$((i + 1))
done
[ -n "$DEPOT" ] || exit 0

# Second filet, structurel : un depot de profils n'est pas du code applicatif. Couvre un clone
# renomme, et evite d'ecrire ici le nom d'un depot prive (cf. en-tete).
[ -d "$DEPOT/templates/profiles" ] && exit 0

# ---- 6. Un SPEC*.md existe-t-il, et est-il recent ? -------------------------------------------
# Presence, pas pertinence. La date se lit par `stat`, dont les deux dialectes sont essayes ;
# si aucun ne repond, le hook se tait plutot que de crier sur un depot qu'il ne sait pas dater.
mtime() {
    stat -c %Y "$1" 2>/dev/null || stat -f %m "$1" 2>/dev/null
}
MAINTENANT="$(date +%s 2>/dev/null)" || exit 0
case "$MAINTENANT" in ''|*[!0-9]*) exit 0 ;; esac
SEUIL=$((MAINTENANT - 30 * 24 * 3600))

RECENT_TROUVE=0
PLUS_RECENT=""
PLUS_RECENT_TS=0
while IFS= read -r f; do
    [ -n "$f" ] || continue
    ts="$(mtime "$f")"
    case "$ts" in ''|*[!0-9]*) continue ;; esac
    if [ "$ts" -gt "$PLUS_RECENT_TS" ]; then PLUS_RECENT_TS="$ts"; PLUS_RECENT="$f"; fi
    [ "$ts" -gt "$SEUIL" ] && RECENT_TROUVE=1
done <<EOF
$(find "$DEPOT" -maxdepth 3 -type f -name 'SPEC*.md' 2>/dev/null | grep -Ev "$EXCLUS" | head -20)
EOF

[ "$RECENT_TROUVE" -eq 1 ] && exit 0

# ---- 7. Un seul rappel par session et par depot -----------------------------------------------
SID="$(lire '.session_id')"; [ -n "$SID" ] || SID="nosession"
SID="$(printf '%s' "$SID" | tr -c 'A-Za-z0-9_.-' '_' | cut -c1-64)"

if command -v cksum >/dev/null 2>&1; then
    CLE="$(printf '%s' "$DEPOT" | cksum | tr -cd '0-9')"
elif command -v md5sum >/dev/null 2>&1; then
    CLE="$(printf '%s' "$DEPOT" | md5sum | cut -d' ' -f1)"
else
    CLE="$(printf '%s' "$DEPOT" | tr -c 'A-Za-z0-9_.-' '_' | cut -c1-64)"
fi
[ -n "$CLE" ] || CLE="nokey"

DIR_MARQ="${TMPDIR:-/tmp}/claude-guard"
mkdir -p "$DIR_MARQ" 2>/dev/null || exit 0
MARQ="$DIR_MARQ/spec-$SID-$CLE.flag"
[ -f "$MARQ" ] && exit 0
: > "$MARQ" 2>/dev/null || exit 0

# ---- 8. Message --------------------------------------------------------------------------------
if [ -n "$PLUS_RECENT" ]; then
    DATE_LISIBLE="$(date -d "@$PLUS_RECENT_TS" '+%d.%m.%Y' 2>/dev/null \
                 || date -r "$PLUS_RECENT_TS" '+%d.%m.%Y' 2>/dev/null)"
    if [ -n "$DATE_LISIBLE" ]; then
        ETAT="  Le SPEC*.md le plus recent du depot date du $DATE_LISIBLE (plus de 30 jours) : $(basename "$PLUS_RECENT")"
    else
        ETAT="  Le SPEC*.md le plus recent du depot a plus de 30 jours : $(basename "$PLUS_RECENT")"
    fi
else
    ETAT="  Aucun SPEC*.md trouve dans ce depot (recherche bornee a 3 niveaux)."
fi

MODE="$(lire '.permission_mode')"; [ -n "$MODE" ] || MODE="inconnu"

MSG="REGLE SPEC-BUILDER (hook du profil, mode rappel).

Ecriture de code applicatif dans un depot sans SPEC.md recent :
  Fichier : $(basename "$FICHIER")
  Depot   : $(basename "$DEPOT")
$ETAT

La regle du 19.05.2026 demande un cadrage AVANT le code, commite avant lui. Elle est nee d'une
session de ~28 commits sans spec, ou un cleanup en aveugle a laisse une accolade orpheline et
casse le build de production.

Depuis le 18.08.2026 elle a TROIS ETAGES, et ce hook ne sait pas lequel s'applique : il voit une
ecriture de fichier, pas son ampleur. C'est a toi de situer la tache.
  < 10 lignes            : pas de spec. L'annoncer en une ligne et passer.
  10 a 50 lignes         : SPEC-lite ~30 lignes (objectif, perimetre, verifications).
  > 50 ou STRUCTUREL     : spec complete en 13 sections, via le skill spec-builder.
'Structurel' l'emporte sur le compte de lignes : schema de donnees, auth, dependance majeure,
contrat d'API, migration. Trois lignes sur une cle etrangere sont structurelles.

Trois sorties legitimes :
  1. Situer la tache dans un etage, l'annoncer, et produire le cadrage correspondant.
  2. Premier etage (moins de 10 lignes) : le dire en une ligne et passer.
  3. Cas hors perimetre de la regle (docs, migration SQL manuelle, configuration du harness) :
     le dire en une ligne et passer.

Mode de permission de cette session : $MODE. Hors du mode 'default', ce rappel n'interrompt pas
l'ecriture : il l'accompagne.

Ce rappel n'apparait qu'une fois par session et par depot."

jq -n --arg m "$MSG" '{
    hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "ask",
        permissionDecisionReason: $m,
        additionalContext: $m
    }
}'

exit 0

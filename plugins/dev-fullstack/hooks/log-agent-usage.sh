#!/usr/bin/env bash
# ==============================================================================================
# log-agent-usage.sh — hook PostToolUse (matcher Agent) d'un profil empaquete en plugin.
# Journalise chaque invocation de sous-agent dans un CSV. Sa SEULE sortie est ce fichier.
#
# CE QU'IL PORTE. Action A2.2 du plan du 17.08.2026 : « aucune decision de fusion ou de retrait
# d'agent ne se prend sur une impression ». Sur le poste, log-agent-usage.ps1 (hook _shared) ecrit
# une ligne par appel de l'outil Agent ; usage-agents-backfill.py reconstitue le passe depuis les
# transcripts et alimente le MEME fichier. En session cloud, l'usage des agents etait invisible.
#
# DEUX ADAPTATIONS, TOUTES DEUX STRUCTURELLES :
#   1. LE NOM DE L'AGENT EST PREFIXE. En plugin, subagent_type vaut `dev-fullstack:backend`, pas
#      `backend`. Le garde-fou de slug du poste refuserait ce nom ; le journaliser tel quel
#      scinderait chaque agent en deux agregats — « et le total serait faux sans que rien ne le
#      signale » (CLAUDE.md). Le prefixe est RETIRE, et il sert a deduire le profil, avec les
#      etiquettes du backfill : dev-fullstack -> `dev`, ingenieur-civil* -> `ingenieur`.
#   2. LA DESTINATION EST UN CONTENEUR EPHEMERE. ~/Documents/Claude/usage-agents/ devient
#      /root/Documents/..., qui survit au cache d'environnement mais pas au-dela, et que le poste
#      ne voit jamais. Ce journal est ORPHELIN tant qu'il n'est pas rapatrie ; il est ecrit au
#      format EXACT du poste (colonnes, `;`, BOM initial, CRLF) pour qu'un rapatriement soit une
#      simple concatenation. `source` vaut `hook-cloud`, pour que la provenance se lise.
#
# FAIL-OPEN, SILENCIEUX PAR CONSTRUCTION : un hook de mesure qui parle dans le contexte, ou qui
# casse une session, coute plus cher que la mesure ne rapporte. Rien sur stdout, jamais ; stderr
# seulement si jq est absent. CLAUDE_USAGE_AGENTS=0 le desactive.
# Surcharges : CLAUDE_USAGE_AGENTS_CSV (cible), CLAUDE_USAGE_AGENTS_PROFIL (etiquette).
# ==============================================================================================
set -uo pipefail

[ "${CLAUDE_USAGE_AGENTS:-1}" = "0" ] && exit 0
command -v jq >/dev/null 2>&1 || { echo "log-agent-usage: jq absent, usage non journalise" >&2; exit 0; }

RAW="$(cat)"
[ -n "$RAW" ] || exit 0
printf '%s' "$RAW" | jq -e . >/dev/null 2>&1 || exit 0
lire() { printf '%s' "$RAW" | jq -r "$1 // empty" 2>/dev/null; }

# ---- 1-3. L'agent invoque, depouille de son prefixe de plugin, puis controle ------------------
BRUT="$(lire '.tool_input.subagent_type')"
[ -n "$BRUT" ] || exit 0
PLUGIN=""; AGENT="$BRUT"
case "$BRUT" in *:*) PLUGIN="${BRUT%%:*}"; AGENT="${BRUT#*:}" ;; esac
printf '%s' "$AGENT" | grep -Eq '^[A-Za-z0-9_.-]{1,64}$' || exit 0

# ---- 4-5. Contexte -------------------------------------------------------------------------------
CWD="$(lire '.cwd')"
PROJET=""
[ -n "$CWD" ] && PROJET="$(basename "${CWD%/}")"
SESSION="$(lire '.session_id')"; [ -n "$SESSION" ] || SESSION="$(lire '.sessionId')"

# ---- 6. Etiquette de profil, IDENTIQUE au vocabulaire du backfill ---------------------------------
if [ -n "${CLAUDE_USAGE_AGENTS_PROFIL:-}" ]; then
    PROFIL="$CLAUDE_USAGE_AGENTS_PROFIL"
else
    NOM="$PLUGIN"
    if [ -z "$NOM" ] && [ -n "${CLAUDE_PLUGIN_ROOT:-}" ]; then
        # .../cache/<marketplace>/<plugin>/<version> ou .../<plugin> : on remonte tant que le
        # dernier segment ressemble a une version.
        d="${CLAUDE_PLUGIN_ROOT%/}"
        while [ -n "$d" ] && printf '%s' "$(basename "$d")" | grep -Eq '^[0-9]+(\.[0-9]+)*$'; do d="$(dirname "$d")"; done
        NOM="$(basename "$d")"
    fi
    case "$NOM" in
        dev-fullstack)     PROFIL="dev" ;;
        ingenieur-civil*)  PROFIL="ingenieur" ;;
        "")                PROFIL="inconnu" ;;
        *)                 PROFIL="$NOM" ;;
    esac
fi

# ---- 7-9. Ligne -------------------------------------------------------------------------------------
HORODATAGE="$(date '+%Y-%m-%dT%H:%M:%S' 2>/dev/null)" || exit 0
PROJET="$(printf '%s' "$PROJET" | tr ';' ',')"
PROFIL="$(printf '%s' "$PROFIL" | tr ';' ',')"
SESSION="$(printf '%s' "$SESSION" | tr ';' ',')"
LIGNE="$HORODATAGE;$AGENT;$PROFIL;$PROJET;$SESSION;hook-cloud"

# ---- 10-12. Cible, en-tete et BOM a la creation seulement, append avec reprise ----------------------
CSV="${CLAUDE_USAGE_AGENTS_CSV:-${HOME:-/root}/Documents/Claude/usage-agents/invocations.csv}"
DOSSIER="$(dirname "$CSV")"
mkdir -p "$DOSSIER" 2>/dev/null || exit 0
if [ -e "$CSV" ] && [ ! -f "$CSV" ]; then exit 0; fi   # ecrire « dans » un dossier reussit en silence

ENTETE='horodatage;agent;profil;projet;session;source'
i=0
while [ "$i" -lt 3 ]; do
    if [ -f "$CSV" ]; then
        printf '%s\r\n' "$LIGNE" >> "$CSV" 2>/dev/null && exit 0
    else
        # BOM + en-tete + ligne d'un seul printf : une seule fenetre de course.
        printf '\357\273\277%s\r\n%s\r\n' "$ENTETE" "$LIGNE" >> "$CSV" 2>/dev/null && exit 0
    fi
    i=$((i + 1)); sleep 0.1 2>/dev/null || sleep 1
done
exit 0

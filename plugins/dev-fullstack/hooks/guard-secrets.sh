#!/usr/bin/env bash
# ==============================================================================================
# guard-secrets.sh — hook PreToolUse (matcher Write|Edit|NotebookEdit) d'un profil empaquete
# en plugin.
#
# CE QU'IL FAIT. Refuse (`deny`) l'ecriture dans un fichier dont le NOM dit qu'il porte un
# secret : .env et ses variantes, keystores et proprietes de signature Android,
# google-services.json, cles et certificats prives, cles SSH. C'est la partie mecanisable de la
# regle 8 de la charte du profil (« aucun secret dans le code »), qui n'etait jusqu'ici que
# doctrinale : rien ne l'opposait au moment du geste. Meme regle au poste : regle E de
# guard-poste.ps1, meme table, meme message. Cadrage : docs/SPEC-lite-guard-secrets.md (05.09.2026).
#
# TABLE DE LA REGLE (basename, insensible a la casse) :
#   ID  Decision  Cible                                                     Exceptions (silence)
#   E   deny      .env, .env.*                                              .env.example/.sample/.template/.dist
#                 *.keystore, *.jks, keystore.properties
#                 google-services.json
#                 *.pem, *.p12, *.pfx, *.key
#                 id_rsa, id_ed25519, id_ecdsa, id_dsa                       *.pub
#
# `deny`, jamais `ask` : rien a arbitrer, et un `ask` en session non interactive vaut refus sans
# le dire (mesure du 02.09.2026). Meme effet dans TOUS les modes de permission.
#
# CE QU'IL NE REGARDE PAS, A DESSEIN : le CONTENU. Un secret colle dans config.ts passe ;
# detecter des secrets par leur forme est un autre outil, avec ses faux positifs. L'outil Bash
# (`echo KEY=... > .env`) est hors matcher, comme pour tous les hooks fichiers du poste. Pas de
# marqueur « une fois par session » : un refus qu'on ne repete pas n'est pas un refus.
#
# FAIL-OPEN : jq absent, payload vide ou invalide, chemin absent => exit 0 silencieux.
# CLAUDE_GUARD_SECRETS=0 desactive le hook. Aucun nom de bureau ni de depot prive ici.
# ==============================================================================================
set -uo pipefail

[ "${CLAUDE_GUARD_SECRETS:-1}" = "0" ] && exit 0

command -v jq >/dev/null 2>&1 || { echo "guard-secrets: jq absent, regle non opposee" >&2; exit 0; }

RAW="$(cat)"
[ -n "$RAW" ] || exit 0
printf '%s' "$RAW" | jq -e . >/dev/null 2>&1 || exit 0

lire() { printf '%s' "$RAW" | jq -r "$1 // empty" 2>/dev/null; }

case "$(lire '.tool_name')" in Write|Edit|NotebookEdit) ;; *) exit 0 ;; esac
CIBLE="$(lire '.tool_input.file_path')"
[ -n "$CIBLE" ] || CIBLE="$(lire '.tool_input.notebook_path')"
[ -n "$CIBLE" ] || exit 0

# ---- 1. Nom de fichier, separateurs Windows compris, en minuscules -------------------------------
NOM="$(printf '%s' "$CIBLE" | tr '\\' '/' | sed 's|.*/||' | tr 'A-Z' 'a-z')"
[ -n "$NOM" ] || exit 0

# ---- 2. La table ---------------------------------------------------------------------------------
SECRET=0
case "$NOM" in
    .env) SECRET=1 ;;
    .env.*)
        case "$NOM" in *.example|*.sample|*.template|*.dist) ;; *) SECRET=1 ;; esac ;;
    *.keystore|*.jks|keystore.properties) SECRET=1 ;;
    google-services.json) SECRET=1 ;;
    *.pem|*.p12|*.pfx|*.key) SECRET=1 ;;
    id_rsa|id_ed25519|id_ecdsa|id_dsa) SECRET=1 ;;
esac
[ "$SECRET" -eq 1 ] || exit 0

# ---- 3. Refus ------------------------------------------------------------------------------------
MSG="Ecriture refusee dans un fichier de secrets (regle 8 de la charte du profil) : $CIBLE

Un fichier dont le nom dit qu'il porte un secret (.env, keystore, cle privee...) ne s'ecrit
pas depuis une session : il se cree a la main, hors session, ou par copie du gabarit
(cp .env.example .env). Le gabarit .env.example, lui, se tient a jour ici.
Un secret deja expose se revoque d'abord ; retirer la ligne ne revoque rien.
Ce garde ne regarde que le NOM du fichier, jamais son contenu."

jq -n --arg r "$MSG" '{
    hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: $r
    }
}'

exit 0

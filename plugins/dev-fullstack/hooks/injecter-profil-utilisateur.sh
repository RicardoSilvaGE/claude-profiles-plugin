#!/usr/bin/env bash
# ==============================================================================================
# injecter-profil-utilisateur.sh — hook SessionStart ET SubagentStart d'un profil empaquete
# en plugin. Injecte les PREFERENCES PERSONNELLES de la personne (profil-utilisateur.md).
#
# CE QU'IL PORTE. Sur le poste, session-profil-utilisateur.ps1 est un hook TRANSVERSE, declare
# dans le settings-fragment.json _shared, jamais copie dans un plugin. Il est ne d'un incident
# (remontee du 17.08.2026) : quatre jours de travail silencieusement non conforme — questions
# groupees la ou la personne demande un arbitrage a la fois, police et registre ignores — parce
# que le hook ne tournait pas sous dev-fullstack. Le plugin reproduisait exactement cette
# absence, en le disant dans son preambule. Le dire ne suffisait pas.
#
# LE PROBLEME N'EST PAS LE HOOK, C'EST LA SOURCE. Le plugin est PUBLIC, le contenu est
# personnel, et le conteneur cloud n'a ni dossier bureau, ni le ~/.claude du poste. D'ou une
# cascade de TROIS sources, toutes privees au compte et hors depot — la premiere trouvee fait foi :
#   1. CLAUDE_PROFIL_UTILISATEUR_FICHIER  : chemin d'un fichier (variable de l'environnement) ;
#   2. CLAUDE_PROFIL_UTILISATEUR          : le texte lui-meme (variable de l'environnement) ;
#   3. ~/.claude/profil-utilisateur.md    : depose par le setup script de l'environnement, qui
#      tourne en root avant Claude Code ; /root survit au cache d'environnement.
# Les variables d'environnement de l'environnement atteignent toute commande lancee par Claude
# Code, hooks compris — mesure le 31.08.2026. JAMAIS un fichier dans le depot de travail : un
# contenu personnel dans un depot est une fuite en attente. JAMAIS CLAUDE_CONFIG_DIR, comme au
# poste : « une personne a un seul jeu de preferences ».
#
# DEUX EVENEMENTS, UN ARGUMENT. `SessionStart` (defaut) porte les preferences dans la session ;
# `SubagentStart` les porte dans un sous-agent, qui ne les recoit PAS autrement : mesure du
# 24.08.2026, le CLAUDE.md complet arrive dans un sous-agent, ce qu'injecte un hook SessionStart
# n'y arrive pas. hookEventName DOIT etre l'evenement reel : le harness valide l'enveloppe par
# evenement. Un evenement inconnu => silence, jamais une enveloppe au mauvais nom.
#
# BUDGETS, repris du poste sans les desserrer : alerte au-dela de 1 700 octets (la fin du bloc
# risque de tomber hors de l'apercu du hook) ; en SOUS-AGENT, au-dela de 2 500 octets RIEN n'est
# injecte et stderr le dit — la session paie l'injection une fois, les sous-agents a chaque
# lancement. Le silence serait pire : un sous-agent ne peut pas savoir ce qu'il n'a pas recu.
#
# FAIL-OPEN : jq absent, aucune source, fichier illisible — invitation courte ou silence, exit 0.
# ==============================================================================================
set -uo pipefail

EVENEMENT="${1:-SessionStart}"
case "$EVENEMENT" in SessionStart|SubagentStart) ;; *) exit 0 ;; esac

command -v jq >/dev/null 2>&1 || { echo "injecter-profil-utilisateur: jq absent, preferences non injectees" >&2; exit 0; }

# Le payload n'est pas utilise, mais il est consomme : un hook qui ne lit pas stdin peut
# laisser le harness sur un tuyau plein.
cat >/dev/null 2>&1 || true

BUDGET_SOUS_AGENT=2500
SEUIL_ALERTE=1700

emettre() { # emettre <texte>
    if [ "$EVENEMENT" = "SubagentStart" ]; then
        n="$(printf '%s' "$1" | wc -c | tr -d ' ')"
        if [ "$n" -gt "$BUDGET_SOUS_AGENT" ]; then
            echo "injecter-profil-utilisateur : injection sous-agent ABANDONNEE, $n octets pour un budget de $BUDGET_SOUS_AGENT. Alleger profil-utilisateur.md." >&2
            return 0
        fi
    fi
    jq -n --arg ev "$EVENEMENT" --arg t "$1" '{hookSpecificOutput:{hookEventName:$ev, additionalContext:$t}}'
}

# ---- Cascade des sources ------------------------------------------------------------------------
TEXTE=""; SOURCE=""; AUTRES=0
FICHIER_VAR="${CLAUDE_PROFIL_UTILISATEUR_FICHIER:-}"
TEXTE_VAR="${CLAUDE_PROFIL_UTILISATEUR:-}"
FICHIER_HOME="${HOME:-/nonexistent}/.claude/profil-utilisateur.md"

if [ -n "$FICHIER_VAR" ] && [ -r "$FICHIER_VAR" ]; then
    TEXTE="$(cat "$FICHIER_VAR" 2>/dev/null)"; SOURCE="CLAUDE_PROFIL_UTILISATEUR_FICHIER"
    [ -n "$TEXTE_VAR" ] && AUTRES=$((AUTRES + 1))
    [ -r "$FICHIER_HOME" ] && AUTRES=$((AUTRES + 1))
elif [ -n "$TEXTE_VAR" ]; then
    TEXTE="$TEXTE_VAR"; SOURCE="CLAUDE_PROFIL_UTILISATEUR"
    [ -r "$FICHIER_HOME" ] && AUTRES=$((AUTRES + 1))
elif [ -r "$FICHIER_HOME" ]; then
    TEXTE="$(cat "$FICHIER_HOME" 2>/dev/null)"; SOURCE="~/.claude/profil-utilisateur.md"
fi

if [ -z "$TEXTE" ]; then
    # Invitation courte, adaptee : /lc-mon-profil n'existe pas dans le plugin.
    emettre "Aucune preference personnelle enregistree (profil-utilisateur.md absent). En session cloud, deux canaux : le fichier ~/.claude/profil-utilisateur.md depose par le setup script de l'environnement, ou la variable d'environnement CLAUDE_PROFIL_UTILISATEUR. Ne pas le proposer a chaque tour."
    exit 0
fi

# ---- Bloc ------------------------------------------------------------------------------------------
# Preambule tenu COURT a dessein, marqueurs IDENTIQUES au poste : la doctrine les cite.
BLOC="===== DEBUT profil-utilisateur.md (prime sur les defauts du profil, jamais sur un garde-fou metier) =====
$TEXTE"
TAILLE="$(printf '%s' "$TEXTE" | wc -c | tr -d ' ')"
if [ "$TAILLE" -gt "$SEUIL_ALERTE" ]; then
    BLOC="$BLOC
ALERTE : ce fichier fait $TAILLE octets, au-dela du budget d'environ $SEUIL_ALERTE qui tient dans l'apercu du hook. Sa fin est probablement invisible. Proposer a l'utilisateur de l'alleger, ou de deplacer le detail vers une doctrine."
fi
BLOC="$BLOC
===== FIN profil-utilisateur.md ====="
if [ "$AUTRES" -gt 0 ]; then
    BLOC="$BLOC
NB : $AUTRES autre(s) source(s) de preferences existe(nt). Celle ci-dessus ($SOURCE) fait foi ; proposer de n'en garder qu'une."
fi

emettre "$BLOC"
exit 0

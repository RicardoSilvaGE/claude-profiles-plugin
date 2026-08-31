#!/bin/bash
# ==============================================================================================
# SETUP SCRIPT d'un environnement cloud — installe le profil en PLUGIN dans chaque session.
#
# OU LE COLLER : claude.ai/code -> l'icone nuage au-dessus de la zone de message -> engrenage
# sur l'environnement -> champ « Script de configuration ». Il tourne EN ROOT, AVANT que Claude
# Code ne demarre, et il est SAUTE quand un environnement en cache existe.
#
# POURQUOI CE FICHIER EXISTE PLUTOT QU'UN COPIER-COLLER DE MEMOIRE : ce script vit dans un champ
# de formulaire, hors de tout depot. Personne ne le relit, personne ne le versionne — ce serait
# une enieme instance de la famille « une copie que personne ne surveille » du CLAUDE.md. La
# source est ici ; le champ en recoit une copie, qu'on rafraichit en la recollant.
#
# ----------------------------------------------------------------------------------------------
# POURQUOI LE MARKETPLACE EST PUBLIC, ET POURQUOI IL N'Y A PAS DE TOKEN ICI
#
# Ce script a d'abord ete ecrit pour cloner un marketplace PRIVE avec un fine-grained PAT passe
# en variable d'environnement. CE CHEMIN EST MORT, et il faut savoir pourquoi pour ne pas le
# rouvrir : UN SETUP SCRIPT NE RECOIT NI LES VARIABLES D'ENVIRONNEMENT DE L'ENVIRONNEMENT, NI
# AUCUNE AUTHENTIFICATION GIT.
#
# Mesure du 31.08.2026 : CLAUDE_PROFILES_TOKEN etait PRESENTE dans la session (93 caracteres) et
# ABSENTE au setup. La documentation ne promet d'ailleurs les valeurs qu'a « each session […]
# any command Claude runs » — or le setup tourne AVANT que Claude Code ne demarre, et sa section
# « Script requirements » ne mentionne jamais les variables. Le clone d'un depot prive echoue
# donc sur :
#     fatal: could not read Username for 'https://github.com': terminal prompts disabled
# Le proxy git de la session n'est authentifie que pour les depots DE CETTE SESSION.
#
# Aucun secret ne peut donc atteindre ce script. Le marketplace doit etre PUBLIC — et c'est la
# seule raison pour laquelle il l'est. Sa copie publiable est produite par
# `scripts/build-plugin.sh --public`, qui expurge puis REFUSE de produire s'il subsiste un motif
# interdit.
#
# ----------------------------------------------------------------------------------------------
# LES DEUX AUTRES PIEGES, CONSTATES ET NON SUPPOSES
#
#   1. `claude` vit dans /opt/node22/bin, ajoute au PATH par /etc/profile.d/nodejs.sh — que seul
#      un shell de LOGIN lit. Un setup script n'en est pas un : sans l'export, `claude` est
#      introuvable et le script echoue avant d'avoir rien fait.
#
#   2. LE JOURNAL VA DANS /root, JAMAIS DANS /tmp. Un journal ecrit dans /tmp etait INTROUVABLE
#      a la session suivante : l'environnement est mis en cache par un instantane du systeme de
#      fichiers, et /tmp n'y survit pas. /root survit forcement — c'est la que vit
#      /root/.claude/plugins, donc la raison meme pour laquelle installer au setup a un sens.
#      Un journal qu'on ne retrouve pas ne diagnostique rien, et celui-la a coute une session.
#
# ----------------------------------------------------------------------------------------------
# CE QUI FAIT REJOUER CE SCRIPT, et rien d'autre : le MODIFIER (tout changement du champ
# reconstruit le cache), changer les hotes reseau autorises, ou attendre l'expiration du cache
# (~7 jours). « Reprendre une session existante ne rejoue JAMAIS le setup script » : il faut donc
# en OUVRIR UNE NOUVELLE. Modifier la seule variable d'environnement ne suffit PAS.
#
# LE CONTROLE QUI FAIT FOI N'EST PAS LE JOURNAL, C'EST `claude plugin list` : il dit l'etat reel,
# la ou l'absence d'un journal est ambigue (script non rejoue ? journal efface ?).
#
# ----------------------------------------------------------------------------------------------
# LE BIAIS DE MESURE A CONNAITRE AVANT DE TESTER QUOI QUE CE SOIT ICI. Trois affirmations fausses
# ont ete livrees le 31.08.2026 — « /plugin marche partout », « le PATH est la cause », « le clone
# prive fonctionne » — et toutes viennent du MEME defaut : une session lancee SUR le depot de
# profils a deja un proxy git autorise pour lui. Un clone y reussit avec un token bidon comme
# sans token. TOUTE MESURE D'ACCES A CE DEPOT FAITE DEPUIS CE DEPOT EST CONTAMINEE. La seule
# epreuve valable est une session cloud sur un AUTRE depot.
#
# NE FAIT JAMAIS ECHOUER UNE SESSION : `exit 0` termine le script quoi qu'il arrive. Un profil
# absent est un desagrement ; une session qui refuse de demarrer est une panne.
# ==============================================================================================

MARKETPLACE="RicardoSilvaGE/claude-profiles-plugin"
PROFIL="dev-fullstack"

export PATH="/opt/node22/bin:$PATH"

{
    echo "=== $(date -u +%FT%TZ) — installation du profil $PROFIL en plugin ==="

    if ! command -v claude >/dev/null 2>&1; then
        echo "ECHEC : la commande 'claude' est introuvable, meme apres l'ajout de /opt/node22/bin."
        echo "PATH = $PATH"
    else
        # Depot PUBLIC : clone anonyme, aucune authentification, aucun secret.
        claude plugin marketplace add "$MARKETPLACE"
        claude plugin install "${PROFIL}@${MARKETPLACE##*/}" --yes

        echo "--- etat final ---"
        claude plugin list
    fi
} > /root/plugin-setup.log 2>&1

exit 0

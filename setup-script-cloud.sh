#!/bin/bash
# Setup script d'un environnement cloud Claude Code.
# A coller dans : claude.ai/code -> icone nuage au-dessus de la zone de message ->
# engrenage sur l'environnement -> champ « Script de configuration ».
#
# `claude` vit dans /opt/node22/bin, ajoute au PATH par /etc/profile.d/nodejs.sh, que seul un
# shell de LOGIN lit — un setup script n'en est pas un, d'ou l'export.
#
# Le journal va dans /root et surtout PAS dans /tmp, qui ne survit pas a l'instantane de
# l'environnement mis en cache. Constate le 31.08.2026 : un journal ecrit dans /tmp etait
# introuvable a la session suivante.
#
# Ce script ne fait REJOUER que s'il est MODIFIE (tout changement du champ reconstruit le
# cache), ou apres l'expiration du cache. Reprendre une session existante ne le rejoue jamais.
# Le controle qui fait foi est `claude plugin list`, pas la presence du journal.
export PATH="/opt/node22/bin:$PATH"

{
    echo "=== $(date -u +%FT%TZ) — installation du profil dev-fullstack ==="
    claude plugin marketplace add RicardoSilvaGE/claude-profiles-plugin
    claude plugin install dev-fullstack@claude-profiles-plugin --yes
    echo "--- etat final ---"
    claude plugin list
} > /root/plugin-setup.log 2>&1

exit 0

# Librairie maison — provenance et neutralisation

> Sorti du `SKILL.md` le 11.11.2026 (v1.4), verbatim. À ouvrir avant de verser une nouvelle pièce
> dans la librairie, ou de contester le statut fichier / recette d'une pièce. L'inventaire du jeu et
> sa fraîcheur sont dans `vanilla/README.md`.

## D'où vient ce contenu

Mesure du 25.08.2026 sur les 8 dépôts applicatifs. Deux fichiers seulement étaient **réellement
dupliqués** entre projets, après neutralisation du nom de l'application :

| Fichier | Part de lignes identiques entre dépôts, ou constat |
|---|---|
| `scripts/generer-certificat-https.ps1` | **84 %** |
| `scripts/docx_vers_pdf.py` | **84 %** |
| `manifest.json` | 63 % (mais 15 lignes) |
| `sw.js` | **34 %** — trop divergent |
| `start-hidden.vbs` | 10 lignes, divergentes |

**Conséquence assumée, et c'est la ligne de partage de cette librairie** : ce qui est réellement
dupliqué est versé en **fichier**, ce qui diverge est versé en **recette**. Verser `sw.js` comme
fichier aurait imposé une stratégie de cache à des projets qui en avaient délibérément choisi deux
différentes.

## Neutralisation appliquée au versement

Les originaux portaient le **prénom et le nom d'utilisateur Windows d'un collègue**, ainsi que son
chemin de poste en dur. Tout cela est retiré : les copies versées ici sont anonymes, et les chemins
sont paramétrés.

Les sorties console des `.ps1` sont en outre passées en **ASCII pur** (règle 5bis du skill `garde-fous-powershell`),
ce que les originaux ne respectaient pas — un script sans BOM dont les messages portent des accents
s'affiche corrompu sous PowerShell 5.1.

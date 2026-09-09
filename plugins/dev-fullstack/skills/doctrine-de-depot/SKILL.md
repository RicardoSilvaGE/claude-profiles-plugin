---
name: doctrine-de-depot
description: "Comment un dépôt garde sa doctrine sans l'étouffer : socle chargé à chaque session sous plafond d'octets, index par déclencheur, règles par thème, archives par décision, journal daté, et les gardes documentaires qui tiennent les liens entre ces pièces. À charger quand un CLAUDE.md devient trop gros pour être lu, quand il faut découper de la doctrine sans en perdre, quand une règle écrite n'est pas appliquée, ou avant de porter un système documentaire d'un dépôt vers un autre. Porte aussi ce qui a été ESSAYÉ ET ÉCARTÉ, daté et motivé, pour qu'un autre dépôt ne le réessaie pas."
---

# La doctrine d'un dépôt : la garder sans l'étouffer

> Version 1.0 — 09.09.2026 (création). **Ce skill n'est pas la source.** Il porte les principes
> **généraux** extraits du système documentaire de `<depot-prive>`, écrit le 09.09.2026 sous le
> nom `docs/systeme-de-doctrine.md`. Ce document-là fait foi, porte la démonstration complète,
> les mesures et les seuils ; celui-ci porte ce qui se transpose.

## Avertissement, à lire avant de transposer quoi que ce soit

**Le système décrit ici avait trois jours quand il a été documenté.** Son auteur écrit
lui-même : *« Il n'a pas encore vu : un lot qui rouvre une règle ancienne, un conflit entre deux
thèmes, une reprise après plusieurs semaines. Ne pas le transposer avant d'avoir vu ces trois
cas. »*

Ce skill existe donc pour **rendre le système consultable**, pas pour l'imposer. Prendre ses
**principes** comme grille de lecture : oui. Recopier ses **seuils, ses thèmes et ses noms de
contrôle** : non — ils se re-dérivent sur le dépôt d'accueil, par la mesure.

## Le problème

Un `CLAUDE.md` chargé **en entier à chaque session** accumule la doctrine de chaque décision
prise. Il atteint une taille où deux défauts coexistent, opposés et simultanés :

- **trop gros pour être lu** — donc lu en diagonale, donc pas appliqué ;
- **trop précieux pour être jeté** — chaque énoncé a été payé par un incident.

Le remède ne peut donc être ni « on supprime », ni « on garde tout ». Cas de référence :
373 275 octets et 6 243 lignes, ramenés à 58 953 — facteur 6,3, **sans perdre un énoncé**.

## Les cinq pièces, et ce que chacune fait

```
socle ──(index)──> règles par THÈME ──(renvoi)──> archives par DÉCISION
  │                   ce qui VAUT                    POURQUOI ça vaut
  │                                                        │
  └──> specs : ce qu'on VA faire              journal daté : le RÉCIT
```

| pièce | ce qu'elle porte | ce qu'elle NE garde pas |
|---|---|---|
| **Socle** (`CLAUDE.md`) | ce qui doit être vrai **sans qu'on aille le chercher** | sa propre justesse au-delà de ce que les contrôles mesurent |
| **Index** | une ligne par thème : quoi, **quand l'ouvrir**, combien de blocs | que le classement soit **juste** — c'est un jugement |
| **Règles** (par thème) | les énoncés opposables, **verbatim**, jamais résumés | qu'un énoncé y soit **lu** |
| **Archives** (par décision) | la démonstration : mesures, contre-épreuves, ce qui a été écarté | sa propre véracité |
| **Journal** (daté) | ce qui s'est passé ce jour-là, jamais réécrit | sa propre atteignabilité — et c'est assumé |

## Les huit principes qui se transposent

1. **Le socle porte ce qui doit être vrai sans qu'on le cherche**, et rien d'autre. Le critère
   d'entrée n'est pas « est-ce important ? » — tout l'est — mais **« doit-ce être vrai sans
   qu'on le cherche ? »** Ce qui entre prend la place de ce qui y est.

2. **Un plafond d'octets sur le socle, mécaniquement opposé.** C'est *la* pièce qui rend le
   reste durable : sans lui, la doctrine se réaccumule dans le fichier chargé — c'est
   exactement ce qui s'était produit. Quand la marge est épuisée, on **déplace un bloc**, on ne
   relève pas le plafond.

3. **Deux niveaux : ce qui vaut (par thème) / pourquoi ça vaut (par décision).** Les deux ont
   des durées de vie différentes — la règle se lit chaque fois qu'on agit, la démonstration une
   fois, quand on veut rouvrir la règle. Les mélanger produit soit une règle noyée, soit une
   démonstration perdue.

4. **Le lien se garde dans les deux sens, titre compris.** Sans le titre, deux renvois peuvent
   **s'échanger** sans que rien ne le voie.

5. **Tout nombre annoncé est dérivé et confronté, jamais recopié.** Un nombre recopié dérive ;
   un nombre dérivé ne peut pas. Quand un contrôle a besoin d'un nombre, il le **compte**.

6. **Le récit reste daté et n'est jamais réécrit.** Un fichier réécrit périme en silence, une
   entrée datée reste vraie.

7. **Chaque garde est éprouvée en réinjectant le défaut qu'elle prétend voir.** Une garde verte
   ne dit rien tant qu'on ne l'a pas vue rougir. Mesuré : sur cinq injections, **deux** sont
   ressorties non détectées, et les deux étaient de vrais trous.

8. **Chaque pièce déclare ce qu'elle NE garde pas.** C'est la règle qui rend un tel document
   utile plutôt que rassurant.

## L'index se libelle par le DÉCLENCHEUR, jamais par le contenu

Une ligne qui **décrit** un fichier ne déclenche pas son ouverture ; une ligne qui nomme le
**geste** l'accroche à un moment. « Avant de toucher un rendu » se déclenche ; « Règles
d'interface et de rendu » ne se déclenche pas.

Même constat des deux côtés : c'est le seul mécanisme qui transforme une consultation
**volontaire** en consultation **provoquée**.

## Le point dur : sortir du contexte ne crée pas le geste de rouvrir

**C'est la limite que tout système de ce genre rencontre, et il faut la dire.** Retirer la
doctrine du fichier chargé la rend consultable **à la demande** — mais la demande ne se fait pas
toute seule. Deux mesures indépendantes, sur deux dépôts, le même jour :

- doctrine sortie du contexte chargé, puis **non rouverte avant d'agir sur les deux lots
  suivants** — deux fois sur deux ; il a fallu rendre la consultation **opposable** pour créer
  le geste ;
- sur un index mémoire de 140 entrées, **une seule fiche ouverte spontanément** sur une session
  entière.

Corollaires, tous les trois vérifiés :

- **Une règle purement doctrinale ne suffit pas.** Mesuré sur un banc de comportement : quatre
  règles portées par un **hook** tenues 8 fois sur 8 ; la seule règle purement doctrinale
  éprouvée, ignorée **4 fois sur 4**.
- **Une déclaration de consultation ne prouve aucune lecture.** Elle déplace le manquement de
  l'**invisible** au **déclaré**. C'est déjà utile, et c'est tout ce qu'elle fait.
- **Préférer un contrôle qui mesure l'EFFET plutôt que le geste.** Une déclaration se remplit
  sans avoir lu ; en revanche on ne peut pas citer des voisines qu'on n'a pas vues. Quand un
  effet observable existe, le contrôler vaut mieux que demander une case.

## Ce qui a été essayé et ÉCARTÉ — pour ne pas le réessayer

| écarté | motif, mesuré |
|---|---|
| **Supprimer la doctrine ancienne** | trois fois, un registre périmé a fait re-prioriser un chantier déjà fait |
| **Tout garder dans le fichier chargé** | 373 Ko à chaque session : lu en diagonale, donc pas appliqué |
| **Ranger la doctrine dans les journaux** | 204 fichiers à relire pour savoir ce qui vaut ; un récit n'est pas une règle |
| **Exiger que chaque journal soit référencé** | 179 sur 204 ne le sont pas : contrôle **rouge sur 88 % dès sa pose** |
| **Nommer le dossier `backlog/`** | « un backlog liste ce qui reste à faire » : le nom annonçait l'inverse du contenu, et une session tierce en a déduit le mauvais geste. **Un nom se lit avant l'avertissement qu'il contient** |
| **Garder « as-tu lu ? »** | impossible à mesurer. Seule l'absence de **déclaration**, ou un **effet** observable, l'est |
| **Copier le document de référence dans chaque dépôt** | une copie figée fait citer consciencieusement une version périmée. Cas mesuré : copie locale en avance sur le canonique sur **54 fichiers**, enrichissement jamais remonté |

## Un contrôle rouge en permanence est un contrôle désactivé

Écrit deux fois dans le dépôt d'origine, et vérifié une troisième ailleurs. Conséquences
pratiques quand on pose une garde sur un dépôt existant :

- **Ne jamais l'appliquer rétroactivement au stock** : la borner aux objets créés **après** sa
  pose, et déclarer le reste en **dette datée** — jamais en exception silencieuse.
- **Mesurer le taux de déclenchement sur le corpus réel avant de la poser.** Une garde qui
  parlerait sur la moitié des cas existants sera désactivée, et on croira l'avoir.
- **Prévoir un mode préavis** pour ce qui relève du jugement : un préavis se lit, un écart sur
  un jugement se contourne.

## Pour aller au fond

La démonstration complète — chiffres, contre-épreuves, pièges d'instrument, ce que chaque garde
ne voit pas — vit dans `docs/systeme-de-doctrine.md` du dépôt `<depot-prive>`. **Le lire là-bas,
pas ici** : ce skill se périmera, le document sera tenu à jour par les lots qui l'exercent.

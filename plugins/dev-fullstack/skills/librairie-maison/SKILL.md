---
name: librairie-maison
description: "Socles de démarrage vérifiés pour ne pas repartir de zéro : jeu VANILLA (PWA hors-ligne, React in-browser sans build, server.js Node, HTTPS local auto-signé, génération docx/PDF) et jeu NEXT-TS (le défaut déclaré du profil, encore VIDE : rien d'éprouvé à en extraire). À charger avant d'écrire le squelette d'une nouvelle application, ou d'ajouter à une application existante un service worker, un serveur local, un export PDF ou un lancement Windows silencieux. Pas pour : générer une SPA Vite complète (`frontend-app-builder`)."
---

# Librairie maison — deux jeux, étiquetés

> Version 1.1 — 05.09.2026 (PR 2.1 de l'audit du 05.09 : le vide de `next-ts/` n'était dit qu'au README du jeu — il est désormais dans la description et dans la table ; auto-check en trois questions ; renvoi croisé vers `frontend-app-builder`.)
> Version 1.0 — 25.08.2026 (création). Contenu issu d'une **mesure** des dépôts réels, pas d'une
> idée de ce qu'ils devraient contenir : cf. § « D'où vient ce contenu ».

## Le choix du jeu se fait AVANT d'écrire, et il s'annonce

Deux jeux vivent ici. Ils ne se mélangent pas, et le mauvais choix coûte plus cher que l'absence
de librairie.

| Jeu | Dossier | Quand |
|---|---|---|
| **VANILLA** | `vanilla/` | C'est le **socle réel** de 7 dépôts sur 8. ESM sans bundler, React chargé en navigateur via Babel standalone, `server.js` Node, PWA hors-ligne, outillage Python et PowerShell autour. |
| **NEXT-TS** | `next-ts/` | C'est le **défaut déclaré du profil** (Next.js App Router + TypeScript strict + Tailwind + shadcn). Un seul dépôt s'en approche aujourd'hui. **Dossier VIDE de fichiers, à dessein** : rien d'éprouvé à en extraire (`next-ts/README.md`) — pour un projet neuf, `create-next-app`. |

**Règle de choix, dans cet ordre :**

1. **Le dépôt existant décide.** S'il y a déjà un `package.json`, un `next.config`, un
   `tsconfig.json`, un `vendor/react.production.min.js` — la réponse est là, et on ne rouvre pas
   le débat (§ « Stack » du `CLAUDE.md` du profil).
2. **Projet neuf** : demander. Ne pas présumer le défaut du profil sous prétexte qu'il est écrit —
   il correspond à un huitième des dépôts.
3. **En cas de doute, le dire** plutôt que choisir : reprendre le mauvais socle se paie en refonte,
   pas en correction.

## Auto-check avant de copier quoi que ce soit

1. **Le jeu a-t-il été choisi par le dépôt, ou annoncé et validé** (projet neuf) — jamais présumé ?
2. **Le fichier a-t-il été exécuté dans le projet** avant de conclure qu'il convient — jamais copié et déclaré « ok » sur lecture ?
3. **La date de fraîcheur du § « Fraîcheur » du jeu a-t-elle été lue**, et l'écart signalé si elle a plus de quelques mois ?

## Ce que cette librairie N'EST PAS

- **Pas une dispense de l'échelle du moindre code.** Elle intervient au barreau 2 (« est-ce déjà
  quelque part ? »), pas au barreau 1. Un fichier de cette librairie qui ne sert à rien dans le
  projet reste du code inutile — copier n'est pas moins cher que d'écrire, c'est seulement plus
  rapide.
- **Pas une dépendance.** Le contenu se **copie** dans le projet, il ne s'y référence pas. Une copie
  se lit, se modifie et se déboguera sur place ; c'est un choix, pas un oubli.
- **Pas une source de vérité vivante.** Un fichier copié diverge dès le lendemain. Le § « Fraîcheur »
  de chaque jeu dit ce qui est vérifié et à quelle date.

## D'où vient ce contenu

Mesure du 25.08.2026 sur les 8 dépôts applicatifs. Deux fichiers seulement étaient **réellement
dupliqués** entre projets, après neutralisation du nom de l'application :

| Fichier | Identique à |
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

Les sorties console des `.ps1` sont en outre passées en **ASCII pur** (garde-fou 5bis du profil),
ce que les originaux ne respectaient pas — un script sans BOM dont les messages portent des accents
s'affiche corrompu sous PowerShell 5.1.

---
name: librairie-maison
description: "Socles de démarrage repris de code en service (non rejoués ici, à exécuter avant de s'y fier) : jeu VANILLA (fichiers : HTTPS local auto-signé, conversion docx vers PDF, manifeste PWA, lancement Windows silencieux ; recette : PWA hors-ligne, React in-browser sans build, server.js Node) et jeu NEXT-TS (le défaut déclaré du profil, encore VIDE : rien d'éprouvé à en extraire). À charger avant d'écrire le squelette d'une nouvelle application, ou d'ajouter à une application existante un service worker, un serveur local, un export PDF ou un lancement Windows silencieux. Pas pour : générer une SPA Vite complète (`frontend-app-builder`)."
---

# Librairie maison — deux jeux, étiquetés

> Version 1.4 — 11.11.2026 (provenance sortie vers `references/provenance.md`). Versions antérieures : `CHANGELOG.md` du profil, non déployé.
> Contenu issu d'une **mesure** des dépôts réels, pas d'une
> idée de ce qu'ils devraient contenir : cf. § « D'où vient ce contenu ».

## Le choix du jeu se fait AVANT d'écrire, et il s'annonce

Deux jeux vivent ici. Ils ne se mélangent pas, et le mauvais choix coûte plus cher que l'absence
de librairie.

| Jeu | Dossier | Quand |
|---|---|---|
| **VANILLA** | `vanilla/` | C'est le **socle réel** de 7 dépôts sur 8. ESM sans bundler, React chargé en navigateur via Babel standalone, `server.js` Node, PWA hors-ligne, outillage Python et PowerShell autour. |
| **NEXT-TS** | `next-ts/` | C'est le **défaut déclaré du profil** (Next.js App Router + TypeScript strict + Tailwind + shadcn). Un seul dépôt s'en approche aujourd'hui. **Dossier VIDE de fichiers, à dessein** : rien d'éprouvé à en extraire (`next-ts/README.md`) — pour un projet neuf, `create-next-app`. |

**Jeu VANILLA, quoi ouvrir et dans quel ordre :** `vanilla/README.md` d'abord (inventaire, gestes à
faire à chaque copie, § « Fraîcheur »), puis `vanilla/RECETTE-app-pwa-hors-ligne.md` (le montage
complet, `sw.js` et `server.js` compris, qui ne sont pas versés en fichiers), puis seulement les
fichiers à copier : `generer-certificat-https.ps1`, `docx_vers_pdf.py`, `manifest.json`,
`start-hidden.vbs`.

**Règle de choix, dans cet ordre :**

1. **Le dépôt existant décide.** S'il y a déjà un `package.json`, un `next.config`, un
   `tsconfig.json`, un `vendor/react.production.min.js` — la réponse est là, et on ne rouvre pas
   le débat (§ « Stack » du `CLAUDE.md` du profil).
2. **Projet neuf** : demander. Ne pas présumer le défaut du profil sous prétexte qu'il est écrit —
   il correspond à un huitième des dépôts.
3. **En cas de doute, le dire** plutôt que choisir : reprendre le mauvais socle se paie en refonte,
   pas en correction.

**L'annonce tient en une ligne, avant tout fichier** : `Jeu : VANILLA | NEXT-TS — motif : <fichier
du dépôt qui décide, ou réponse de l'utilisateur>`.

## Auto-check avant de copier quoi que ce soit

1. **Le fichier a-t-il été exécuté dans le projet** avant de conclure qu'il convient — jamais copié et déclaré « ok » sur lecture ?
2. **La date de fraîcheur du § « Fraîcheur » du `README.md` du jeu a-t-elle été lue**, et l'écart signalé si elle a plus de quelques mois ?

## Ce que cette librairie N'EST PAS

- **Pas une dispense de l'échelle du moindre code.** Elle intervient au barreau 2bis (« est-ce déjà
  dans la librairie maison ? »), pas au barreau 1. Un fichier de cette librairie qui ne sert à rien dans le
  projet reste du code inutile — copier n'est pas moins cher que d'écrire, c'est seulement plus
  rapide.
- **Pas une dépendance.** Le contenu se **copie** dans le projet, il ne s'y référence pas. Une copie
  se lit, se modifie et se déboguera sur place ; c'est un choix, pas un oubli.
- **Pas une source de vérité vivante.** Un fichier copié diverge dès le lendemain. Le § « Fraîcheur »
  du `README.md` de chaque jeu dit ce qui est vérifié et à quelle date.

## D'où vient ce contenu

Mesure du 25.08.2026 sur les 8 dépôts applicatifs. **Ligne de partage** : ce qui était réellement
dupliqué entre dépôts est versé en **fichier**, ce qui diverge (`sw.js`, `server.js`) en **recette**.
Parts mesurées par fichier et neutralisation appliquée au versement : `references/provenance.md`, à
ouvrir avant de verser une nouvelle pièce ou de contester le statut fichier / recette d'une pièce.

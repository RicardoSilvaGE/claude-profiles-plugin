# Jeu NEXT-TS — le défaut déclaré du profil

Next.js (App Router) + TypeScript strict + Tailwind + shadcn/ui, tel que le `CLAUDE.md` du profil
le propose par défaut.

## État de ce jeu, dit franchement

**Vide de fichiers, et ce n'est pas un oubli.**

Mesure du 25.08.2026 sur les 8 dépôts applicatifs : **un seul** est en TypeScript (`Frise`, 29 `.ts`
+ 16 `.tsx`), et aucun n'est en Next.js. Il n'existe donc, à ce jour, **aucun socle Next/TS
réellement éprouvé** dans les dépôts — rien à extraire.

Verser ici un squelette Next.js recopié d'une documentation reviendrait à faire passer pour du
« déjà éprouvé » ce qui ne l'a jamais tourné une seule fois. C'est exactement ce qu'une librairie
maison doit éviter : sa valeur tient à ce que son contenu a **déjà servi**.

## Ce qu'il faut faire à la place, aujourd'hui

Pour un projet Next/TS neuf, le générateur officiel (`create-next-app`) fait mieux et reste à jour
tout seul. Cette librairie n'a rien à ajouter par-dessus **tant qu'un projet maison n'a pas produit
de conventions propres**.

Ce qui, en revanche, s'applique dès le premier projet et vit ailleurs :

- la validation runtime obligatoire (Zod) — § « Garde-fous » de `backend.md` et `frontend.md` ;
- les règles de design opposables (espacements 4 px, palette neutre + 1 accent, radius, états) —
  § « Règles de design » du `CLAUDE.md` du profil ;
- la couverture des 4 états et des états étendus — `frontend.md`.

## Quand remplir ce dossier

**Au deuxième projet Next/TS, pas au premier.** La règle de la troisième occurrence vaut ici aussi :
un socle extrait d'un unique projet n'est pas un socle, c'est une copie de ce projet-là. Attendre
d'avoir deux implémentations permet de voir ce qui est vraiment commun — et c'est exactement la
méthode qui a produit le jeu `vanilla/`, où deux fichiers sur cinq candidats ont survécu à la
mesure.

## Fraîcheur

| | |
|---|---|
| Dernier état vérifié | **25.08.2026** — 1 dépôt TS sur 8, 0 en Next.js |
| À rouvrir quand | un deuxième projet Next/TS existe |

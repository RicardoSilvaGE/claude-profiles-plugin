---
name: atelier-graphiste
description: "Préchargé par `graphiste` : mesure des planches et recherche datée sur le beau visuel."
---

# Atelier du graphiste

> Version 1.0 — 13.11.2026 (création avec `graphiste` 2.0 : le script de mesure et les quatre dossiers de recherche de l'essai du 13.11.2026, sortis du dossier de travail où ils vivaient).

## Le dossier

Son chemin est donné au chargement du skill (« Base directory »). À défaut : `Glob` sur `**/atelier-graphiste/mesures.js` dans le home de config (`CLAUDE_CONFIG_DIR`, sinon `~/.claude`), puis dans le dossier du plugin. Introuvable : le dire ; la planche se livre alors **REGARDÉE, NON MESURÉE**, contraste calculé en Python sur les hex des fiches de direction.

| Fichier | Sert à |
|---|---|
| `mesures.js` | mesurer la planche rendue (§ suivant) |
| `recherche/1-science-du-beau.md` | ce qui plaît : unité et variété, typique et nouveau, fluidité, beauté et utilisabilité, forme, couleur |
| `recherche/2-metier-direction-artistique.md` | le métier : thème, point focal, échelle, grille, air, typographie, palette, matière, signes du générique, grille de critique |
| `recherche/3-methode-de-creation.md` | la méthode : variantes en parallèle, références, quantité, contraintes, critique |
| `recherche/4-faire-produire-du-beau-a-une-ia.md` | diriger un modèle hors du générique, ce que vaut son regard sur un PNG, la boucle rendre-critiquer |

## `mesures.js`

**Usage** : le copier à côté de la planche, l'appeler en fin de `<body>` (`<script src="mesures.js"></script>`), lancer Chrome sans fenêtre avec `--virtual-time-budget=5000 --dump-dom` sur `file:///<planche>.html`, lire le JSON du `<pre id="mesures">`. Passe étroite : même commande sur `<planche>.html?largeur=360` ; seuls les cadres de téléphone (360 à 430 px) sont rétrécis.

**Ce qu'il rend, par cadre `data-ecran`** :

| Champ | Contenu | Doit sortir |
|---|---|---|
| `contraste` | texte sous 4,5:1, ou 3:1 en grand ; couleur et opacité composées sur le fond réel, texte SVG lu par son `fill` | vide |
| `contrasteNonTexte` | contour de champ, icône d'un bouton sans texte, sous 3:1 (WCAG 1.4.11) | vide |
| `aEchantillonner` | texte sur image, dégradé ou forme SVG : mesurer sur les pixels du rendu | traité |
| `deborde` | texte tronqué, coupé (largeur ou hauteur) ou sorti de sa boîte ; conteneur qui coupe du texte | vide, ou troncature voulue et dite |
| `horsCadre` | texte ou cible qui sort du cadre en largeur ou par le haut | vide |
| `chevauche` | deux textes ou cibles qui se recouvrent (éléments tournés et `aria-hidden` exclus) | vide |
| `ciblesSous24` / `ciblesSous44` | cibles sous 24 px, puis de 24 à 44 px (liens dans une phrase exclus) | vide / dit |
| `polices` | par famille : tailles, graisses, `nonRendues` (graisses tombées sur un repli) | `nonRendues` vide |
| `sousLePli` | éléments sous le bas du cadre, et ceux qu'il coupe : information, pas défaut | dit |

**Ce qu'il ne voit pas**, à déclarer « non mesuré » s'il compte : un contrôle dessiné en `<div>` sans `role`, `tabindex` ni `cursor: pointer` (dessiner les contrôles en `<button>` ou `<a>`) ; le texte dans une image ; les états (survol, focus) ; l'espacement entre cibles.

Testé le 13.11.2026 sous Chrome sans fenêtre : chaque contrôle sur un défaut posé exprès et son jumeau corrigé, puis sur les trois planches gagnantes de l'essai. Rejoué le même jour sous Linux (conteneur cloud) : chaque champ du tableau rend le défaut posé exprès, les jumeaux corrigés (contraste, SVG, hors texte, débordement, hors cadre, chevauchement, cibles, police) ne rendent rien, et la passe à 360 px coupe ce qui tenait à 390. Là, `chrome --headless=new` restait bloqué même sur une page vide ; `chrome-headless-shell`, avec les mêmes options plus `--no-sandbox`, a rendu.

## Recherche — quoi ouvrir, à quelle étape

Chercher par `Grep` dans les titres `###` ; ne pas lire un dossier en entier. Chaque dossier finit par un « Top 8 des consignes pour graphiste ».

| Étape de la fiche | Dossier, terme à chercher |
|---|---|
| Ligne de base, signes du générique | 4 « centre de sa distribution », « parade » ; 2 « Signes du générique » |
| Références | 3 « exemples », « références proches » |
| Diverger | 3 « premières idées », « persister » ; 4 « Diversité » |
| Fiche de direction | 2 « thème », « palette », « rampes », « police d'affichage » ; 1 « Couleur » |
| Composition, héros, air | 2 « point focal », « écarts d'échelle », « grille », « air » |
| Objet du domaine, matière | 2 « illustration », « langage de formes », « relief » |
| Critique, boucle | 2 « Grille de critique » ; 3 « critique utile », « auto-évaluation » ; 4 « juge », « boucle » |
| Défendre la beauté | 1 « utilisabilité », « mythes » |

## Lire les niveaux

Échelle de `ux-preuves` : N1 norme, N2 recherche publiée, N3 guide officiel, N4 praticien, N0 jugement déclaré. Une consigne transposée d'une étude sur le web ou sur des produits à un écran de téléphone se cite « appui N2 », pas N2 ; « résumé seul lu » reste écrit. Les sections « Sources non lues » et « Repéré, non lu » ne se citent pas comme faits.

Le § « Écarts avec les règles de design du profil » du dossier 2 est **tranché** depuis le 13.11.2026 : la doctrine borne ses « Règles de design opposables » aux interfaces d'outil.

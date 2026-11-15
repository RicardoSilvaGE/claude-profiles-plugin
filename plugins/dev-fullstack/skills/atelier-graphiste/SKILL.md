---
name: atelier-graphiste
description: "Préchargé par `graphiste` : mesure des planches et recherche datée sur le beau visuel."
---

# Atelier du graphiste

> Version 1.1 — 15.11.2026 (avec `graphiste` 2.1 : dossiers 5, sites primés, et 6, applications primées, indexés comme source de règles de création, pas de modèles ; leurs écarts avec la fiche tranchés). Versions antérieures : `CHANGELOG.md` du profil, § « Historiques des versions des fiches et skills ».

## Le dossier

Son chemin est donné au chargement du skill (« Base directory »). À défaut : `Glob` sur `**/atelier-graphiste/mesures.js` dans le home de config (`CLAUDE_CONFIG_DIR`, sinon `~/.claude`), puis dans le dossier du plugin. Introuvable : le dire ; la planche se livre alors **REGARDÉE, NON MESURÉE**, contraste calculé en Python sur les hex des fiches de direction.

| Fichier | Sert à |
|---|---|
| `mesures.js` | mesurer la planche rendue (§ suivant) |
| `recherche/1-science-du-beau.md` | ce qui plaît : unité et variété, typique et nouveau, fluidité, beauté et utilisabilité, forme, couleur |
| `recherche/2-metier-direction-artistique.md` | le métier : thème, point focal, échelle, grille, air, typographie, palette, matière, signes du générique, grille de critique |
| `recherche/3-methode-de-creation.md` | la méthode : variantes en parallèle, références, quantité, contraintes, critique |
| `recherche/4-faire-produire-du-beau-a-une-ia.md` | diriger un modèle hors du générique, ce que vaut son regard sur un PNG, la boucle rendre-critiquer |
| `recherche/5-sites-primes.md` | d'où viennent des règles de création : ce que les jurys du web récompensent et tolèrent, traits communs de 15 lauréats, ce qui se transpose à une app |
| `recherche/6-applications-primees.md` | d'où viennent des règles de création : traits communs de 18 apps primées, ce que saluent Apple et les équipes, avis d'utilisateurs sur l'UI |

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

Chercher par `Grep` dans les titres (`^#`) ; ne pas lire un dossier en entier. Chaque dossier finit par un « Top 8 ». Les dossiers 5 et 6 s'ouvrent pour **justifier** une règle de la fiche, jamais pour y chercher un modèle : aucune palette, police, composition ni signature d'un lauréat ne passe sur une planche.

| Étape de la fiche | Dossier, terme à chercher |
|---|---|
| Ligne de base, signes du générique | 4 « centre de sa distribution », « parade » ; 2 « Signes du générique » ; 5 « contredisent » et 6 « Écarts » (tranchés) |
| Références | 3 « exemples », « références proches » |
| Diverger | 3 « premières idées », « persister » ; 4 « Diversité » |
| Fiche de direction | 2 « thème », « palette », « rampes », « police d'affichage » ; 1 « Couleur » ; 5 « Se transpose » ; 6 « Traits communs », « Ce que disent les équipes » |
| Composition, héros, air | 2 « point focal », « écarts d'échelle », « grille », « air » ; 6 « Traits communs » (donnée en image, chiffre héros) |
| Mouvement | 5 « Ne se transpose pas » ; 2 « toucher et au son » |
| Objet du domaine, matière | 2 « illustration », « langage de formes », « relief » |
| Critique, boucle | 2 « Grille de critique » ; 3 « critique utile », « auto-évaluation » ; 4 « juge », « boucle » |
| Défendre la beauté | 1 « utilisabilité », « mythes » ; 5 « Biais documentés » ; 6 « textes d'Apple », « Études publiées » |

## Lire les niveaux

Échelle de `ux-preuves` : N1 norme, N2 recherche publiée, N3 guide officiel, N4 praticien, N0 jugement déclaré. Une consigne transposée d'une étude sur le web ou sur des produits à un écran de téléphone se cite « appui N2 », pas N2 ; « résumé seul lu » reste écrit. Les sections « Sources non lues » et « Repéré, non lu » ne se citent pas comme faits. Dans les dossiers 5 et 6, un décompte de lauréats est un N0 d'observation (un codeur, échantillon choisi, souvent des visuels de vente) : il décrit ces lauréats, il ne prouve pas qu'un trait fait gagner, et il ne pèse jamais contre un N1.

Le § « Écarts avec les règles de design du profil » du dossier 2 est **tranché** depuis le 13.11.2026 : la doctrine borne ses « Règles de design opposables » aux interfaces d'outil. L'entrée 7 du dossier 5 et le § « Écarts » du dossier 6 sont tranchés depuis le 15.11.2026 dans `graphiste` 2.1 (« Signes du générique », « Ce qui rend une planche belle »).

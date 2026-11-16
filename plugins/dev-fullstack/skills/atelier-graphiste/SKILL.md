---
name: atelier-graphiste
description: "Préchargé par `graphiste` : mesure des planches et recherche datée sur le beau visuel."
---

# Atelier du graphiste

> Version 1.2 — 16.11.2026 (avec `graphiste` 2.3 : outils de rendu et de mesure sur pixels dans `outils/`, techniques et limites des trois registres de rendu éprouvés le 16.11.2026, commandes de rendu sorties de la fiche). Versions antérieures : `CHANGELOG.md` du profil, § « Historiques des versions des fiches et skills ».

## Le dossier

Son chemin est donné au chargement du skill (« Base directory »). À défaut : `Glob` sur `**/atelier-graphiste/mesures.js` dans le home de config (`CLAUDE_CONFIG_DIR`, sinon `~/.claude`), puis dans le dossier du plugin. Introuvable : le dire ; la planche se livre alors **REGARDÉE, NON MESURÉE**, contraste calculé en Python sur les hex des fiches de direction.

| Fichier | Sert à |
|---|---|
| `mesures.js` | mesurer la planche rendue (§ « `mesures.js` ») |
| `outils/releve.js` | relever chaque texte des cadres (texte entier, boîte, couleur) et masquer du texte pour une capture |
| `outils/pixels.py` | contraste sur le pire pixel, contact réel d'un très grand texte, découpe des cadres (§ « Mesurer sur les pixels ») |
| `outils/aquarelle.py` | registre illustration peinte : lavis, granulation, réserves, plume (§ « Registres de rendu ») |
| `outils/studio3d.html` | registre profondeur et lumière : scène three.js rendue en image fixe |
| `recherche/1-science-du-beau.md` | ce qui plaît : unité et variété, typique et nouveau, fluidité, beauté et utilisabilité, forme, couleur |
| `recherche/2-metier-direction-artistique.md` | le métier : thème, point focal, échelle, grille, air, typographie, palette, matière, signes du générique, grille de critique |
| `recherche/3-methode-de-creation.md` | la méthode : variantes en parallèle, références, quantité, contraintes, critique |
| `recherche/4-faire-produire-du-beau-a-une-ia.md` | diriger un modèle hors du générique, ce que vaut son regard sur un PNG, la boucle rendre-critiquer |
| `recherche/5-sites-primes.md` | d'où viennent des règles de création : ce que les jurys du web récompensent et tolèrent, traits communs de 15 lauréats, ce qui se transpose à une app |
| `recherche/6-applications-primees.md` | d'où viennent des règles de création : traits communs de 18 apps primées, ce que saluent Apple et les équipes, avis d'utilisateurs sur l'UI |

Les outils se copient à côté de la planche (`mesures.js`, `releve.js`, `studio3d.html`) ou s'appellent par leur chemin (`pixels.py`, `aquarelle.py`). Ils ne lisent et n'écrivent que des fichiers locaux ; aucun n'appelle le réseau.

## Rendre

**Navigateur** : Chrome ou Chromium sans fenêtre. Sous Windows : `C:\Program Files\Google\Chrome\Application\chrome.exe` ; Edge a échoué en Git Bash (13.11.2026). En conteneur Linux, `chrome --headless=new` peut rester bloqué même sur une page vide ; `chrome-headless-shell` (souvent sous `/opt/pw-browsers/`), avec les mêmes options plus `--no-sandbox`, rend (13 et 16.11.2026).

**Capture** : `chrome --headless=new --disable-gpu --user-data-dir=<dossier temporaire> --hide-scrollbars --virtual-time-budget=8000 --force-device-scale-factor=2 --window-size=<largeur>,<hauteur> --screenshot=<chemin.png> "file:///<planche.html>"`. La fenêtre couvre toute la planche : ce qui dépasse n'est pas capturé.

**JSON** : même commande avec `--dump-dom` au lieu de `--screenshot` ; `python3 pixels.py extraire <dom.html> mesures` (ou `releve`) l'en tire.

**Paramètres d'URL** reconnus par les outils, combinables : `?largeur=360` (passe étroite, `mesures.js`) ; `?masque=textes` (tout texte non décoratif transparent) ; `?masque=<sélecteur CSS>` (un élément seul transparent, avec son texte, son `fill` et son `stroke`). Un sélecteur avec espaces s'encode (`%20`).

**Python** : numpy et Pillow, rien d'autre. Trouver un interpréteur où `import PIL, numpy` réussit (`python`, `py -3.12`, `python3`…) avant d'en dépendre.

## `mesures.js`

**Usage** : le copier à côté de la planche, l'appeler en fin de `<body>` (`<script src="mesures.js"></script>`, puis `<script src="releve.js"></script>`), lancer Chrome sans fenêtre avec `--dump-dom` (§ « Rendre »), lire le JSON du `<pre id="mesures">`. Passe étroite : même commande sur `<planche>.html?largeur=360` ; seuls les cadres de téléphone (360 à 430 px) sont rétrécis.

**Ce qu'il rend, par cadre `data-ecran`** :

| Champ | Contenu | Doit sortir |
|---|---|---|
| `contraste` | texte sous 4,5:1, ou 3:1 en grand ; couleur et opacité composées sur le fond réel, texte SVG lu par son `fill` | vide |
| `contrasteNonTexte` | contour de champ, icône d'un bouton sans texte, sous 3:1 (WCAG 1.4.11) | vide |
| `aEchantillonner` | texte sur image, dégradé ou forme SVG : mesurer sur les pixels du rendu (`pixels.py contraste`) | traité |
| `deborde` | texte tronqué, coupé (largeur ou hauteur) ou sorti de sa boîte ; conteneur qui coupe du texte | vide, ou troncature voulue et dite |
| `horsCadre` | texte ou cible qui sort du cadre en largeur ou par le haut | vide |
| `chevauche` | deux textes ou cibles dont les **boîtes** se recouvrent (éléments tournés et `aria-hidden` exclus) | vide, ou très grand texte jugé sur son tracé |
| `ciblesSous24` / `ciblesSous44` | cibles sous 24 px, puis de 24 à 44 px (liens dans une phrase exclus) | vide / dit |
| `polices` | par famille : tailles, graisses, `nonRendues` (graisses tombées sur un repli) | `nonRendues` vide |
| `sousLePli` | éléments sous le bas du cadre, et ceux qu'il coupe : information, pas défaut | dit |

**Ce qu'il ne voit pas**, à déclarer « non mesuré » s'il compte : un contrôle dessiné en `<div>` sans `role`, `tabindex` ni `cursor: pointer` (dessiner les contrôles en `<button>` ou `<a>`) ; le texte dans une image ; les états (survol, focus) ; l'espacement entre cibles ; **le tracé réel d'un texte** : `chevauche` compare des boîtes, et la boîte d'une police contient son interligne, ses jambages et son approche. Sous 40 px l'écart compte peu ; pour un chiffre d'affiche, il fait des faux chevauchements (§ suivant).

Testé le 13.11.2026 sous Chrome sans fenêtre : chaque contrôle sur un défaut posé exprès et son jumeau corrigé, puis sur les trois planches gagnantes de l'essai. Rejoué le même jour sous Linux (conteneur cloud) : chaque champ du tableau rend le défaut posé exprès, les jumeaux corrigés ne rendent rien, et la passe à 360 px coupe ce qui tenait à 390.

## Mesurer sur les pixels — `releve.js` et `pixels.py`

`releve.js` écrit dans `<pre id="releve">` chaque texte visible de chaque cadre : `ecran`, `texte` entier, `boite` serrée sur les lignes (px CSS de la page), `couleur`, `taille`, `graisse`, `decoratif` (sous `aria-hidden`), `masque` (visé par `?masque=`). `pixels.py` compare ensuite deux captures de même taille.

| Besoin | Captures | Commande | Doit sortir |
|---|---|---|---|
| Relevé des textes, à confronter au brief (aucune donnée ajoutée) | `--dump-dom` | `pixels.py extraire dom.html releve > releve.json` | chaque `texte` remonte au brief ou est un libellé d'interface |
| Contraste d'un texte sur image, dégradé, texture, forme SVG | normale + `?masque=textes` | `pixels.py contraste planche.png fond.png releve.json` | sortie 0 : `nonMesures` vide et aucun `ok: false` (sortie 1 : un texte sous le seuil ; 2 : un texte non mesuré, listé sur stderr) ; le pire ratio par écran est imprimé |
| Contact réel d'un très grand texte signalé en `chevauche` | normale + `?masque=<sélecteur>`, et le relevé de cette URL masquée | `pixels.py contact planche.png sans.png releve-masque.json` | `contacts` vide à 2 px (`--marge`) |
| Regarder chaque écran | normale + JSON de `mesures.js` | `pixels.py decouper planche.png mesures.json <dossier>` | un PNG par cadre, ouvert avec Read |

`--echelle` vaut le `--force-device-scale-factor` du rendu (2 par défaut).

**Contraste** : la couleur du texte est lue sur ses pixels d'encre (médiane du cœur des glyphes), donc avec l'opacité de ses parents, les formats `oklch()` ou `color()` et les calques déjà composés ; jamais sur la couleur déclarée. Le fond est pris sur la capture sans texte, aux pixels qui touchent le glyphe (encre dilatée de 1,5 px CSS). Les textes décoratifs (`aria-hidden`) restent dans le fond. Un texte sans pixel d'encre (transparent, masque sans effet, couleur du fond) n'est jamais déclaré conforme : il sort en `nonMesures`. Un texte en dégradé se mesure à la main, couleur la plus claire et la plus sombre ; une police très fine à petite taille garde un cœur anticrénelé, la mesure pèche alors par prudence.

**Contact** : le tracé est l'ensemble des pixels qui changent quand l'élément est masqué ; `traceReel` donne ses bornes, `contacts` les textes dont la boîte, élargie de la marge, contient de ce tracé. Viser le texte principal seul (`.chiffres text:not([aria-hidden])`) : son ombre ou son reflet décoratif se masque à part si on veut le juger. Tracé vide (aucun pixel ne change : masque oublié, sans effet, mauvaise URL) : la commande sort en erreur, ce n'est pas un « sans contact ». Zéro contact sur un tracé réel : écrire « boîte seulement, tracé sans contact » et coller la ligne imprimée. Contact voulu (l'ombre posée au pied du chiffre) : le dire.

Testé le 16.11.2026 sous Chromium (Linux) sur un banc de quatre textes : `oklch()` clair sur fond clair 1,46:1 et blanc à 35 % d'opacité sur fond sombre 3,14:1 (calcul théorique : environ 3,1:1), tous deux en échec ; témoin 17,4:1 ; texte transparent en `nonMesures`, sortie 2. La première version, qui lisait la couleur déclarée, sautait le premier et déclarait le second à 15,6:1 (relecture du 16.11.2026). Sur la planche de la troisième séance « Marque-page » (mesure de contact, inchangée depuis) : le « 142 » de 566 px du rendu C a une boîte de 612 px de haut pour un tracé de 420 px (59 à 480 px sous le haut du cadre) et ne touche aucun texte, quand `mesures.js` signalait quatre chevauchements. **Ne voit pas** : le texte dans une image ou un canvas, un texte posé par `::before` ou `::after`, un chiffre dessiné en tracés (segments SVG), à relire à l'œil contre le brief ; un texte de moins de 1 px CSS de haut ou entièrement hors cadre.

## Registres de rendu

Chaque registre : les techniques qui ont porté le rendu le 16.11.2026, l'outil, les limites constatées par l'agent qui l'a joué, et le pas suivant, qui vise ces limites. Une séance, une app, un juge : ce sont des points de départ [N0], pas des recettes. Aucun ne fournit de scène à reprendre : l'objet et la composition viennent de la fiche de direction.

**Illustration peinte ou dessinée** — `outils/aquarelle.py`.
- *Techniques* : grain du papier en relief, éclairé d'en haut ; lavis superposés par la loi de Beer-Lambert (ils se multiplient comme des glacis) ; granulation dans les creux ; pigment qui migre vers le bord qui sèche ; bords déformés ; le blanc **réservé** (le soleil est le papier laissé nu) ; brosse sèche sur le grain ; plume tremblée à pression variable. La donnée en image se peint aussi (un nuancier de 17 petits ciels pour 17 livres).
- *Limites* : formes géométriques (un livre devient une boîte, une ombre un trapèze) ; aucun geste de pinceau voulu ; répétitions mécaniques (sillons) ; une seule qualité de lavis.
- *Pas suivant* : contours tracés à la main en points irréguliers ; plans distincts par la densité et la granulation ; motifs répétés cassés ; un accident laissé (coulure, auréole).

**Profondeur et lumière** — `outils/studio3d.html` (three 0.180.0, image fixe).
- *Techniques* : objet modelé en primitives (plats arrondis, tranche, dos ; vernis par `clearcoat`, toile par `sheen`) et textures dessinées sur canvas ; fond en cinq couches (studio neutre par défaut ; un ciel seulement si le sujet le porte) ; disque solaire et halo sur option (`?soleil=1`) ; brume exponentielle (perspective atmosphérique) ; ombres douces (VSM, pénombre de 8 px CSS au bord le plus net, mesurée) et ombre de contact ; éclat (bloom) ; profondeur de champ ; suréchantillonnage ×3 ; décalage de caméra pour garder les verticales droites. Tricherie permise si elle sert le sens : lumière placée pour que l'ombre courte désigne le chiffre. L'interface au-dessus est une surface opaque qui flotte, à ombre longue et douce : pas de verre.
- *Limites* : pas d'éclairage global ; objet neuf et propre, qui reste « image de synthèse » ; scène vide.
- *Pas suivant* : usure et accidents sur l'objet (coins frottés, plis) ; deux ou trois jalons d'échelle ; rebond coloré du sol ; ombre vérifiée douce sur une découpe agrandie (interdit absolu).
- *Rendu sans serveur ni Playwright* : `npm install --prefix vendor three@0.180.0` à côté du studio, puis `chrome-headless-shell --no-sandbox --hide-scrollbars --allow-file-access-from-files --use-angle=swiftshader --enable-unsafe-swiftshader --ignore-gpu-blocklist --virtual-time-budget=20000 --window-size=1170,2532 --screenshot=img/fond3d.png "file:///<dossier>/studio3d.html?ss=3"` (environ 10 s, 16.11.2026, Linux ; non essayé sous Windows). Les positions à l'écran de l'objet, de son pied, du soleil et de l'horizon, pour poser le HTML par-dessus : même URL avec `--dump-dom`, `<pre id="info">`.

**Typographie d'affiche** — SVG et CSS dans la planche, sans outil.
- *Techniques* : le chiffre ou le mot de la tâche en `<text>` SVG géant, police d'affichage condensée, posé sur l'horizon d'un bord à l'autre ; un objet du domaine passe derrière ou dans une lettre (dans l'œil d'un chiffre, par exemple) ; ombres en trame de points (`<pattern>` de cercles tourné de 30°) ; aplats francs de deux ou trois encres ; grain d'encre en petite tuile générée ; coins vifs.
- *Limites* : grain uniforme ; aucun décalage de repérage ; la frise de données ressemble à un histogramme ; le bas de l'écran reste classique.
- *Pas suivant* : un décalage de repérage de 1 à 2 px entre deux encres ; grain plus dense sur les aplats sombres ; frise et bas d'écran dans la même grammaire d'affiche (bandeaux, filets épais), contrôles toujours nets.
- *Mesure* : `chevauche` y est presque sûr ; le juger par `pixels.py contact`.

**Atmosphère, dans tous les registres** : une lumière qui vient de quelque part (halo, réserve, source dans l'image) ; un air entre l'œil et le fond (brume, perspective atmosphérique, pénombre) ; une ombre portée qui suit cette lumière ; une couleur de ciel ou de pièce qui dit le moment. Elle se règle sur le héros et le fond ; le texte reste sur un fond mesuré.

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
| Objet du domaine, matière, registre | 2 « illustration », « langage de formes », « relief » ; 5 « Top 8 » (le premier écran sert la tâche) ; ce skill, § « Registres de rendu » |
| Critique, boucle | 2 « Grille de critique » ; 3 « critique utile », « auto-évaluation » ; 4 « juge », « boucle » |
| Défendre la beauté | 1 « utilisabilité », « mythes » ; 5 « Biais documentés » ; 6 « textes d'Apple », « Études publiées » |

## Lire les niveaux

Échelle de `ux-preuves` : N1 norme, N2 recherche publiée, N3 guide officiel, N4 praticien, N0 jugement déclaré. Une consigne transposée d'une étude sur le web ou sur des produits à un écran de téléphone se cite « appui N2 », pas N2 ; « résumé seul lu » reste écrit. Les sections « Sources non lues » et « Repéré, non lu » ne se citent pas comme faits. Dans les dossiers 5 et 6, un décompte de lauréats est un N0 d'observation (un codeur, échantillon choisi, souvent des visuels de vente) : il décrit ces lauréats, il ne prouve pas qu'un trait fait gagner, et il ne pèse jamais contre un N1. Les registres de rendu sont un N0 d'essai (§ « Registres de rendu »).

Le § « Écarts avec les règles de design du profil » du dossier 2 est **tranché** depuis le 13.11.2026 : la doctrine borne ses « Règles de design opposables » aux interfaces d'outil. L'entrée 7 du dossier 5 et le § « Écarts » du dossier 6 sont tranchés depuis le 15.11.2026 dans `graphiste` 2.1 (« Signes du générique », « Ce qui rend une planche belle »).

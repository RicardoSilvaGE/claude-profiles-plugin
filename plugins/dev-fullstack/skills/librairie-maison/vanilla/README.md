# Jeu VANILLA — inventaire, provenance, fraîcheur

Socle réel de **7 dépôts sur 8** au 25.08.2026. ESM sans bundler, React chargé en navigateur,
`server.js` Node, PWA hors-ligne, outillage Python et PowerShell autour.

## Ce qu'il y a ici

| Fichier | Ce que c'est | Provenance |
|---|---|---|
| `generer-certificat-https.ps1` | HTTPS local auto-signé, **condition du service worker hors localhost** | mesuré **84 %** identique entre deux dépôts |
| `docx_vers_pdf.py` | Conversion .docx → .pdf, LibreOffice puis Word COM en repli | mesuré **84 %** identique |
| `manifest.json` | Manifeste PWA, paramétré | 15 lignes, 63 % identique |
| `start-hidden.vbs` | Démarrage Windows silencieux, chemin **à renseigner** | 10 lignes, divergentes — versé pour ses 3 pièges, pas pour son code |
| `RECETTE-app-pwa-hors-ligne.md` | Le montage complet, et les 5 endroits où il casse | — |

**`sw.js` et `server.js` ne sont PAS ici**, et c'est un choix mesuré : `sw.js` n'a que **34 %** de
lignes communes entre projets, `server.js` porte le métier. Les verser en fichiers aurait imposé
des décisions que chaque projet avait délibérément prises autrement. Ils sont traités en recette.

## À faire à chaque copie

1. **Renseigner** : `NOM_APP` et `DESCRIPTION_COURTE_DE_L_APP` dans `manifest.json`, `appDir` dans
   `start-hidden.vbs`, les noms de fichiers d'icônes.
2. **Vérifier que `data/` est exclu de git** avant de lancer le script de certificat. Il y écrit une
   **clé privée**.
3. **Ne pas copier ce qui ne sert pas.** C'est le barreau 1 de l'échelle du moindre code : une
   application sans mode hors-ligne n'a besoin ni du certificat, ni du manifeste, ni du service
   worker.

## Fraîcheur

| | |
|---|---|
| Contenu extrait le | **25.08.2026** |
| Vérifié contre | les dépôts `Argos` et `Coordis`, plus `flux/output/` |
| Testé ici | **non** — les fichiers sont repris d'un code en service, pas rejoués dans un projet neuf |

**Ce dernier point est une réserve, pas une formalité.** La neutralisation (retrait d'un nom
d'utilisateur, paramétrage des chemins, passage des sorties console en ASCII) a modifié les
fichiers. Ils n'ont pas été relancés après cette modification. Au premier emploi réel, les
**exécuter** avant de conclure qu'ils marchent.

## Ce qui a été retiré au versement

Les originaux portaient le **prénom et le nom d'utilisateur Windows d'un collègue**, ainsi que son
chemin de poste en dur dans `start-hidden.vbs`. Retirés. Ne jamais les réintroduire en recopiant
depuis un projet : cette librairie est versionnée, et un dépôt privé n'est pas un dossier privé.

# Recette — application PWA hors-ligne, React in-browser, sans build

Ce qui suit n'est pas un fichier à copier : c'est le **montage**, avec les points où ça casse.
Les pièces réellement dupliquées entre projets, elles, sont versées en fichiers à côté.

## Ce que ce socle est, et ce qu'il coûte

Une application d'une seule page, servie par un petit `server.js` Node, qui charge React **dans le
navigateur** via Babel standalone. **Aucun bundler, aucune étape de build, aucun `node_modules` à
déployer.** On copie un dossier, on lance `node server.js`, ça tourne.

**Le prix, à dire avant de choisir ce socle** : Babel transpile à chaque chargement de page, donc
le premier affichage est plus lent qu'un bundle. C'est le compromis assumé — il s'échange contre
l'absence totale de chaîne de build, ce qui compte quand l'application est déposée sur un NAS et
relevée par un `start-hidden.vbs`.

## Arborescence mesurée

```
<app>/
  <nom>.html            page unique, React + Babel en <script type="text/babel">
  server.js             serveur Node : statique + API + HTTPS si les certs existent
  sw.js                 service worker (voir plus bas : DIVERGENT entre projets)
  manifest.json         PWA           <- fichier versé
  start-hidden.vbs      démarrage Windows silencieux  <- fichier versé
  vendor/               react, react-dom, babel, EN LOCAL (jamais un CDN distant)
  branding/             icônes 180 / 192 / 512 + .svg
  data/                 base, journaux, certs — EXCLU DE GIT
  scripts/              outillage Python (docx/PDF) et PowerShell
  templates/            gabarits .dotx / .docx du bureau
```

## Les cinq pièges, dans l'ordre où ils se présentent

### 1. Le service worker exige un contexte sécurisé

C'est **le** piège du socle, parce qu'il est silencieux. Un service worker ne s'enregistre qu'en
HTTPS ou sur `http://localhost`. Depuis le poste qui héberge, tout marche. Depuis un téléphone sur
`http://192.168.x.x:3200`, le navigateur **refuse** le service worker — sans erreur visible dans
l'application. Le mode hors-ligne n'existe simplement pas.

Un **certificat auto-signé suffit** : le navigateur exige un contexte sécurisé, pas une autorité de
confiance. → `generer-certificat-https.ps1`, versé ici.

### 2. `vendor/` en local, jamais un CDN

React, React-DOM et Babel sont **copiés dans le dépôt**. Un CDN distant casse l'application dès que
le réseau tombe — ce qui est exactement la situation que le mode hors-ligne existe pour couvrir.
Prendre les builds `.production.min.js`, pas les builds de développement.

### 3. `sw.js` est DIVERGENT, et c'est délibéré

Mesuré le 25.08.2026 : **34 % de lignes communes** entre deux projets. Les stratégies de cache ne
sont pas interchangeables — une application de saisie terrain et une application de consultation
n'ont pas le même besoin. **Ne pas recopier un `sw.js` d'un projet à l'autre** : décider la
stratégie, puis l'écrire.

Les deux questions à trancher avant d'écrire : que sert-on quand le réseau est absent (dernier
cache, ou page dédiée) ? et qu'est-ce qui ne doit **jamais** être mis en cache (les réponses d'API
qui portent de la donnée fraîche) ?

### 4. `data/` doit être exclu de git AVANT le premier lancement

Le dossier reçoit la base, les journaux **et les clés privées** des certificats. Vérifier le
`.gitignore` avant, pas après : une clé privée commitée ne se retire pas d'un historique par un
simple commit.

### 5. Le chemin de `start-hidden.vbs` est propre au poste

Le gabarit versé porte un chemin à renseigner. Un chemin laissé au réglage d'un autre poste échoue
**sans fenêtre pour le dire** — d'où la redirection vers `data\server.log`, qui n'est pas un confort
mais la seule trace exploitable.

## Côté `server.js`

Non versé : il fait 35 à 51 Ko selon les projets et porte le métier, pas le socle. Ce qui, en
revanche, se retrouve à l'identique partout et mérite d'être repris :

- **HTTPS optionnel** : charger `data/certs/{key,cert}.pem` s'ils existent, écouter alors sur
  `PORT+1`, et **continuer en HTTP seul** s'ils sont absents. Jamais d'échec au démarrage pour un
  certificat manquant.
- **Une variable d'environnement pour ne PAS ouvrir le navigateur** — sans quoi un démarrage par
  `start-hidden.vbs` ouvre une fenêtre à chaque ouverture de session Windows.
- **Le timeout d'un sous-processus (conversion PDF) doit rester au-dessus** de celui du script
  appelé : si l'appelant tue le processus le premier, le message d'erreur utile est perdu.

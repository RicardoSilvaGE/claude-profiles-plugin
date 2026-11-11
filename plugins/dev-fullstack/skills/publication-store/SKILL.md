---
name: publication-store
description: "Publication d'une app web (PWA) sur le Google Play Store via Capacitor Android : identité figée (applicationId, versionCode), AAB signé avec keystore hors dépôt et Play App Signing, tracks internal → production, Data Safety, IARC, limites de la fiche, App Links, validation sur device, pièges Android 15+ / Capacitor 8 mesurés. Déclencheurs : release Play Store, publier l'app, AAB, keystore, Play Console, internal testing, Capacitor. Pas pour : un build Android de test, la copy de la fiche (`growth`), les visuels (`designer`), le déploiement web (`release`), iOS (non mesuré)."
---

# Publication store — Android via Capacitor, Play Console

> Version 1.6 — 11.11.2026 (cure de poids : pièges, provenance et App Links en annexes, gabarits ajoutés, redites retirées). Versions antérieures : `CHANGELOG.md` du profil, non déployé.
> Contenu **mesuré le 04.09.2026 sur un seul dépôt réel** (Capacitor 8, targetSdk 36) : « le dépôt mesuré » ci-dessous, et toute valeur donnée sans autre source (V1 + V2, délai de propagation) vient de lui. Portée et incidents : `references/provenance.md`.

## Principe directeur

Une publication store n'est pas un déploiement : **elle engage une identité qu'on ne peut plus
changer** (`applicationId`), **une clé qu'on ne peut pas perdre** (le keystore), et **un compteur
qui ne recule jamais** (`versionCode`). Tout le reste se corrige à la release suivante ; ces
trois-là, non. Le skill sert d'abord à ne pas les casser, ensuite à produire la release.

**Ce que ce skill fait, et ce qu'il ne peut pas faire.** Il prépare : audit pré-release, bump de
version, build web + sync Capacitor, checklists, fichiers de la fiche, `assetlinks.json`. **La
signature et l'upload restent des gestes de la personne** : le keystore est sur sa machine, hors
dépôt, et la Play Console est une interface. Le livrable du skill est donc toujours **un état du
dépôt + une checklist manuelle nominative**, jamais « c'est publié ».

## Périmètre

### Couvert

- Android via **Capacitor 8** (`@capacitor/core`, `@capacitor/android`, `webDir: "dist"`).
- Invariants d'identité : `appId` / `applicationId`, `versionCode`, `versionName`, `package.json.version`.
- Build **AAB** (`bundleRelease`) pour le store, APK (`assembleRelease`) pour le sideload de test.
- Signature : `keystore.properties` hors dépôt, `signingConfigs.release` lue conditionnellement, **Play App Signing**.
- Play Console : tracks, testeurs, release notes, **Data Safety**, **classification IARC**, limites de la fiche.
- Assets : captures (1080 × 2400 dans le dépôt mesuré), feature graphic 1024 × 500 — **spécifications**, pas la création.
- **App Links** HTTPS (`autoVerify` + `assetlinks.json`) pour un deep-link natif.
- Validation sur device et pièges Android 15+ mesurés.

### Hors-scope

- **La copy** de la fiche (titre, descriptions, mots-clés, notes de version rédigées) → sub-agent `growth`, Mode B. Ce skill donne les **limites** et les **champs**, pas le texte.
- **Les visuels** (captures, feature graphic, icônes) → sub-agent `designer`. Ce skill donne les formats.
- **Le déploiement web** (Vercel, Cloudflare, NAS) → sub-agent `release`. Une PWA et son wrapper natif partagent le code, pas le pipeline.
- **iOS / App Store** : non mesuré. Le dire, ne pas improviser.
- **Push notifications** (FCM, `google-services.json`) : mentionnées où elles touchent la publication (permissions, Data Safety), pas implémentées ici.

## Skills à invoquer ou MCPs à utiliser

- `spec-builder` : **obligatoire** avant de toucher une zone système (`AndroidManifest.xml`, `build.gradle`, `variables.gradle`, `capacitor.config.json` au-delà de `appId/appName/webDir/server`, `MainActivity`, `res/values*`). C'est la règle absolue du profil.
- Sub-agent `growth` en hand-off pour la copy, `designer` pour les visuels, `securite` avant la première ouverture publique.
- Sub-agent `release` pour la partie web du même lancement.

## Workflow (8 phases, de 0 à 7)

### Phase 0 — Brief obligatoire

Avant toute action, établir et **annoncer** :

1. **Quel track** : internal testing (famille, testeurs nommés), closed, open, production. Le premier upload est toujours **internal**.
2. **Quelle version** : `versionCode` précédent (lu dans `build.gradle`, jamais supposé) et `versionName` visé. Si la version précédente n'est pas certaine : **lister les valeurs trouvées et demander**.
3. **Ce qui a changé depuis la dernière release** : `git log <tag-precedent>..HEAD`, et les migrations SQL en attente côté prod.
4. **Qui signe et qui uploade** : la personne, sur sa machine. Le skill s'arrête au `cap sync` (seule suite possible : le tag de la Phase 4, sur confirmation).

### Phase 1 — Lecture obligatoire (HARD GATE)

Citer en bullets ce qui a été lu :

1. `CLAUDE.md` projet : règles absolues d'identité, workflow git (le dépôt mesuré committe **directement sur `main`** en bêta privée — ne pas imposer une PR par réflexe), procédure de release déjà écrite (§ « Versionnage et releases » ou équivalent).
2. `capacitor.config.json` : `appId`, `appName`, `webDir`, `server.androidScheme`, section `plugins`.
3. `android/app/build.gradle` : `applicationId`, `versionCode`, `versionName`, `signingConfigs`, `buildTypes.release` (`minifyEnabled`, `shrinkResources`, `proguardFiles`).
4. `android/variables.gradle` : `minSdkVersion`, `compileSdkVersion`, `targetSdkVersion`.
5. `android/app/src/main/AndroidManifest.xml` : permissions, `intent-filter`, `allowBackup`, `dataExtractionRules`.
6. `android/keystore.properties.example` et `.gitignore` : ce qui est exclu (`*.keystore`, `*.jks`, `keystore.properties`, `google-services.json`, `local.properties`).
7. `package.json` : scripts `npm run cap:sync`, `npm run android:build`, `npm run android:build:bundle`, `version`.
8. `docs/play-store/` s'il existe : procédure, checklists, Data Safety, IARC, fiches — **ne pas les réécrire, les compléter**.
9. `public/manifest.json` et `index.html` : `theme_color` / `background_color` cohérents avec `capacitor.config.json` `android.backgroundColor`.

Sans cette lecture, refus de produire un livrable : une release préparée sur une version supposée casse l'upload, et un `appId` recopié de mémoire casse l'app.

### Phase 2 — Les trois invariants (règles dures)

| Invariant | Règle | Pourquoi c'est irréversible |
|---|---|---|
| **`applicationId`** (= `appId` Capacitor) | **Jamais modifié après le premier upload.** Ne se touche que sur demande explicite, et le refuser une fois avant d'obéir. | C'est l'identité de l'app dans le store. Le changer publie une **autre** app ; les utilisateurs existants ne reçoivent plus rien. |
| **`versionCode`** | Entier, **+1 à chaque upload**, jamais réutilisé, jamais diminué. | Play Console **rejette** un upload dont le `versionCode` n'est pas strictement supérieur au dernier accepté, sur tous les tracks confondus. |
| **Keystore de signature** | Hors dépôt, sauvegardé **à deux endroits** (gestionnaire de mots de passe + copie hors-ligne), **Play App Signing activé au premier upload**. | Clé perdue sans Play App Signing = **plus aucune mise à jour possible**, jamais. Avec Play App Signing, Google détient la clé finale et peut régénérer une clé d'upload. |

`versionName` (semver) et `package.json.version` s'alignent l'un sur l'autre — c'est une
convention de lisibilité, pas un invariant du store. Bump majeur sur refonte visible, mineur
sinon.

### Phase 3 — Audit pré-release (lecture seule)

Checklist mesurée sur le dépôt de référence, à passer **avant** de bumper :

- [ ] Branche de release (`main`) propre : `git status` vide, tout est sur `origin`.
- [ ] `applicationId` et `appId` **inchangés** (les relire, ne pas les supposer).
- [ ] `targetSdkVersion` ≥ l'exigence courante de Google (à relire sur la page *Target API level requirements* de Google, relevée chaque année — jamais un chiffre de mémoire ; le dépôt mesuré visait 36). Une cible en dessous est refusée à l'upload.
- [ ] Tests unitaires verts, lint sans `console.log` non gaté, **build prod propre** (`npm run build`).
- [ ] `theme_color` / `background_color` du manifeste PWA et de `index.html` cohérents avec `android.backgroundColor` — c'est ce que l'utilisateur voit au splash.
- [ ] **Migrations SQL en attente appliquées en prod** avant l'upload : une app publiée qui parle à un schéma en retard tourne en dégradé sans le dire. Le dépôt mesuré l'a marqué **CRITIQUE** dans sa spec de release.
- [ ] Permissions du Manifest **toutes justifiées** dans Data Safety (Phase 5) : chaque `uses-permission` est une question du formulaire.
- [ ] `allowBackup="false"` + `dataExtractionRules` excluant tout, si le WebView stocke des jetons (le dépôt mesuré le fait : `localStorage` porte la session Supabase, `adb backup` l'exfiltrerait).
- [ ] `minifyEnabled` + `shrinkResources` avec les règles ProGuard **qui gardent Capacitor** (`com.getcapacitor.**`, plugins, `@JavascriptInterface`) — sans elles, R8 casse le pont natif en release et pas en debug, ce qui ne se voit qu'après l'upload.

### Phase 4 — Bump, build, signature

**Qui fait quoi** : étapes 1 et 2, le skill ; étapes 3 à 5, **la personne**, sur sa machine (le keystore n'est pas dans le dépôt) ; étape 6, le tag n'est posé qu'après que la personne a confirmé `jar verified.` — par elle, ou par le skill sur sa confirmation explicite.

1. **Bump** dans `android/app/build.gradle` : `versionCode` +1, `versionName` semver ; aligner `package.json.version`. C'est la seule modification autorisée de ce fichier sans SPEC, **parce que la procédure de release est cette demande explicite**.
2. **Build web + sync** : `npm run build && npx cap sync android` (script `npm run cap:sync`). Le skill peut le faire s'il a l'outillage ; il s'arrête là.
3. **AAB, pas APK, pour le store** : `gradlew bundleRelease` → `android/app/build/outputs/bundle/release/app-release.aab`. Garder `assembleRelease` dans un script **séparé** pour le sideload de test (`adb install`).
4. **Signature** — deux voies, la seconde est celle du dépôt mesuré :
   - Android Studio → *Generate Signed Bundle*, keystore existant, V1 + V2 ;
   - ou `signingConfigs.release` lue depuis `android/keystore.properties` (**non commité**, template `.example` commité). Si le fichier manque, Gradle produit un bundle **non signé avec un simple warning** — pas une erreur. D'où l'étape 5.
5. **Vérifier la signature avant l'upload** : `jarsigner -verify -verbose -certs app-release.aab` doit finir par `jar verified.`. Un bundle non signé est rejeté par la Console, mais seulement après l'upload.
6. **Tag git** après build OK : `git tag -a v<versionName> -m "…"`, poussé. C'est ce que `release` Mode B lira pour `git log <tag>..HEAD` la prochaine fois.

**Ce que le skill livre à la personne** : une checklist nominative (Android Studio → Play Console → testeurs), avec les chemins exacts des artefacts et les valeurs attendues au scan de la Console (`applicationId`, `versionCode`, `targetSdk`, permissions). Gabarit : `references/gabarits.md`, qui porte aussi le tableau Data Safety et les notes de release de la Phase 5.

### Phase 5 — Play Console

**Tracks**, dans l'ordre, sans en sauter : **internal testing** (liste d'e-mails, lien d'opt-in, propagation ~1-2 min) → **closed** → **open** → **production**. Critère de promotion mesuré : **tous** les tests de la checklist device (Phase 7) verts, **≥ 1 testeur tiers** (pas seulement le compte du développeur — le flow d'opt-in ne se teste pas sur soi), **aucun crash au pre-launch report**, et décision explicite de la personne.

**Nom de release** : `versionName (versionCode)`, p. ex. `1.0.0 (4)`. **Notes de release** : par locale ; la copy revient à `growth`, le skill fournit le gabarit (nouveautés · sous le capot · connu · contact).

**Data Safety** (*App content*) : un tableau par type de donnée collectée — collectée ? optionnelle ? partagée ? chiffrée en transit ? suppression possible ? finalité. Le dépôt mesuré en a documenté sept (e-mail, nom, date de naissance, identifiants, journaux, jeton push…) **dans un fichier versionné, cohérent avec la politique de confidentialité publiée**. Deux réponses structurantes : *chiffrement en transit* (oui si tout passe en TLS) et *suppression à la demande* (il faut un chemin réel dans l'app — le dépôt mesuré a une RPC de suppression de compte). **Un jeton push envoyé à FCM est un partage avec un tiers** : le déclarer.

**Classification IARC** (*Content rating*) : questionnaire par e-mail, catégorie *Utility/Productivity* pour un agenda, toutes réponses « non » → PEGI 3 / Everyone. Le documenter dans le dépôt pour la prochaine fois.

**Limites de la fiche**, à donner à `growth` : titre ≤ 30 (« Your app title must be 30 characters or less », Play Console Help « Metadata », lu le 09.11.2026 ; le « 60 » écrit ici jusqu'à cette date était faux), description courte ≤ 80, description longue ≤ 4 000 caractères, par locale (`ux-preuves/references/growth-aso-stores.md`, § « Description courte ≤ 80 caractères […] », Play Console Help). Pas de superlatif non prouvé, pas de feature absente.

**Assets**, à donner à `designer` : **captures** — 1080 × 2400 est le **choix du dépôt mesuré** (portrait Pixel 7, 4 claires + 2 sombres), pas la règle Play, qui est dans `ux-preuves/references/growth-aso-stores.md` l. 62-67 (jusqu'à 8 captures par type d'appareil ; au moins 4 captures ≥ 1080 px pour l'éligibilité aux recommandations ; minimum de publication : deux captures) ; toujours sur des **données de démonstration seedées**, jamais des données réelles ; **feature graphic 1024 × 500** lisible aussi à 320 × 156 (taille de vignette dans les résultats). Captures depuis un émulateur ou un device (`adb shell screencap`), pas depuis DevTools — la barre système manque.

### Phase 6 — App Links (deep-link natif HTTPS)

**Seulement si la release doit ouvrir l'app depuis un lien `https://`** ; sinon passer à la Phase 7. Les cinq étapes (`intent-filter` `autoVerify`, `assetlinks.json`, empreinte, route cible, vérification `adb`) sont dans `references/app-links.md`, à ouvrir avant d'y toucher. Trois points qui ne se rattrapent pas : le Manifest est une **zone système (SPEC d'abord)** ; l'empreinte SHA-256 est celle du certificat de **release** — avec Play App Signing, celle de la clé de signature Google —, **jamais** celle du keystore de debug ; elle est un **input bloquant de la personne**.

### Phase 7 — Validation sur device

Une checklist par **catégorie fonctionnelle** (le dépôt mesuré en a dix : auth, création, permission push, réception push app **fermée**, sync multi-device, hors-ligne, vues, tâches, réglages, robustesse), chaque case **binaire**, exécutée sur **device physique**, par la personne et ≥ 1 testeur.

Trois règles mesurées :

- **Tester l'app complètement fermée** (retirée des applications récentes), pas seulement en arrière-plan : c'est là que les notifications et le boot diffèrent.
- **Une hypothèse à la fois** sur tout défaut natif : observation factuelle d'abord (`chrome://inspect` pour le WebView, `adb logcat` pour le natif), modification unique, revert immédiat si échec. Pas de cumul de correctifs. Pièges natifs déjà mesurés (status bar, safe areas, splash, notifications) : `references/pieges-android-capacitor.md`, à lire avant la première hypothèse.
- **Une permission ne se re-teste qu'après désinstallation** : un « accordé » persiste.

Séparer **bloquant** (perte de données hors-ligne, push non reçu, crash) — corriger, nouveau `versionCode`, re-upload — de **mineur**, consigné dans un `known-issues` versionné et non bloquant pour la promotion.

## Garde-fous (règles dures)

1. **`applicationId` : jamais** (Phase 2 : refus une fois, avec la conséquence, avant d'obéir).
2. **Aucun secret dans le dépôt** : keystore, `keystore.properties`, `gradle.properties` avec mots de passe, `google-services.json`, `local.properties`. Vérifier le `.gitignore` **avant** le premier build signé, pas après. Un keystore commité puis supprimé reste dans l'historique : c'est une révocation, pas un nettoyage.
3. **`versionCode` bumpé à chaque upload**, y compris pour un re-upload correctif sur le même track.
4. **Play App Signing au premier upload**, et sauvegarde double du keystore d'upload (Phase 2).
5. **Toute zone système passe par une SPEC** (Manifest, Gradle, `capacitor.config.json` hors champs CLI, activité, ressources) — pas d'« exception hotfix », même pour une ligne. Lire le **code Java du plugin** concerné (`node_modules/@capacitor/…/android/…`) avant d'écrire la SPEC.
6. **Ne jamais annoncer « publié »** : le skill livre un dépôt prêt et une checklist ; la publication est constatée par la personne dans la Console.
7. **Captures sur données de démonstration**, jamais sur une famille ou un client réel.

## Anti-patterns interdits

- Uploader un APK là où le store attend un AAB (accepté sur les vieux tracks, refusé en production depuis 2021 pour une nouvelle app).
- « Passer en `LIGHT` la status bar » ou toute retouche de `capacitor.config.json` sans SPEC, parce que ça a l'air petit.

Les autres interdits sont écrits là où ils décident : empreinte de debug (Phase 6), opt-in testé sur le seul compte du développeur (Phase 5), captures dans DevTools (Phase 5), correctifs natifs cumulés (Phase 7), copy écrite ici (Hors-scope).

## Annexes — quand les ouvrir

- `references/gabarits.md` : fin de Phase 4 et Phase 5 (checklist nominative, Data Safety, notes de release).
- `references/app-links.md` : Phase 6, si un deep-link est demandé.
- `references/pieges-android-capacitor.md` : avant de toucher status bar, splash, safe areas, notifications ; devant un défaut natif.
- `references/provenance.md` : d'où vient ce contenu (n = 1) et les deux incidents source.

## Auto-check final (avant livraison)

1. `applicationId` et `versionCode` **relus dans les fichiers** au moment de livrer, pas repris du brief ?
2. Migrations prod en attente identifiées et signalées comme préalables ?
3. La checklist remise dit **qui** fait **quoi**, avec chemins et valeurs attendues, et « prêt à uploader », jamais « publié » ?

# publication-store — Phase 6, App Links (deep-link natif HTTPS)

> Annexe du skill `publication-store`, sortie du `SKILL.md` le 11.11.2026 (v1.6), texte inchangé.
> À ouvrir seulement si la release doit ouvrir l'app depuis un lien `https://` ; une release sans
> deep-link saute cette phase.

### Phase 6 — App Links (deep-link natif HTTPS)

Pour qu'un lien `https://<domaine>/<chemin>` ouvre l'app installée sans dialogue « ouvrir avec » :

1. `intent-filter` `VIEW` avec `android:autoVerify="true"`, `scheme="https"`, `host`, `pathPrefix` — dans le Manifest (**zone système : SPEC d'abord**).
2. `https://<domaine>/.well-known/assetlinks.json` servi en `Content-Type: application/json`, portant l'**empreinte SHA-256 du certificat de signature release** — celle du keystore de release, **pas** celle du keystore de debug (erreur classique, silencieuse : la vérification échoue et le lien ouvre le navigateur).
3. L'empreinte s'obtient par `keytool -list -v -keystore release.keystore` — c'est un **input bloquant de la personne** ; sans elle le fichier est inécrivable. Avec Play App Signing, c'est l'empreinte de la **clé de signature Google** (Console → *App integrity*) qui fait foi pour les installations depuis le store, pas celle de l'upload key.
4. Réutiliser la **route web existante** comme cible du deep-link plutôt qu'une route parallèle — le dépôt mesuré a tranché ainsi (ADR) : un seul gate, testable en PWA.
5. Vérification : `adb shell pm verify-app-links --re-verify <applicationId>` puis `adb shell pm get-app-links <applicationId>` doit dire `verified`. Un hébergeur qui intercepte `/.well-known/` casse tout : le tester en `curl`.

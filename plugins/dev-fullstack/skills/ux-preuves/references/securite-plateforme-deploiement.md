# Fiche `ux-preuves` — Sécurité — plateforme web, déploiement et CI

> Fiche du skill `ux-preuves` (dev-fullstack), volet **sécurité**, préchargé par `securite`. Couvre : en-têtes de sécurité, cookies (`__Host-`, `SameSite`), TLS et durée des certificats, failles Next.js et React (CVE-2025-29927, CVE-2025-55182), Vercel (prévisualisations, variables secrètes, pare-feu), Supabase (Security Advisors, réseau, sauvegardes), GitHub Actions (épinglage, permissions, OIDC, tj-actions), serveur auto-hébergé.
> **Instantané de la recherche documentaire du 09 au 10.11.2026** (menée autour de minuit UTC) : chaque
> entrée cite une page réellement ouverte pendant cette recherche, avec un extrait lu. Classements, versions, avis de sécurité et textes réglementaires
> **vieillissent** ; le droit change par révision : avant d'en faire dépendre une décision,
> relire la page officielle (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> **Méthode.** Chaque entrée repose sur une page ouverte pendant la recherche (WebFetch, ou curl + extraction de texte pour les PDF et les fichiers JSON). Les citations les plus structurantes (OWASP Headers et Session, hstspreload.org, GitHub « Secure use », postmortem Vercel, avis React, Let's Encrypt, Supabase, OFCS, Web Almanac, W3C CSP3) ont été **recontrôlées par recherche exacte dans le texte brut téléchargé**. Les autres proviennent de l'extraction WebFetch de la page ; leur formulation exacte peut différer d'un signe de ponctuation. Hors périmètre (couvert ailleurs) : CSP stricte, XSS, SRI, CORS, CSRF, SSRF, RLS et clé secrète Supabase, Server Actions = POST publics, nouvelles clés Supabase.
>
> **Niveaux de preuve.** N1 norme/standard/RFC · N2 étude empirique à large échantillon · N3 documentation ou guide officiel · N4 avis d'expert.

---

## 1. En-têtes de sécurité HTTP

### Servir HSTS avec une durée longue (2 ans) et `includeSubDomains` sur toute réponse HTTPS du domaine
- Niveau de preuve : N3
- Source : OWASP Cheat Sheet Series, consulté 2026, « HTTP Security Response Headers Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/HTTP_Headers_Cheat_Sheet.html
- Extrait lu : « Strict-Transport-Security: max-age=63072000; includeSubDomains; preload » et « See the HSTS preload requirements before requesting preload inclusion. »
- Portée / limites : valeur d'exemple OWASP (63072000 s = 2 ans). La liste de référence OWASP Secure Headers (fichier `headers_add.json`, mis à jour le 2026-10-18) recommande `max-age=63072000; includeSubDomains` **sans** `preload` — les deux ressources OWASP ne concordent pas sur `preload`. MDN précise que l'en-tête envoyé en HTTP est ignoré et que HSTS ne protège pas la toute première visite (« One weakness of HSTS is that it does not take effect until the browser has made at least one secure connection to the host », https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Strict-Transport-Security).
- En pratique : `curl -sI https://<domaine>` : HSTS présent, `max-age` ≥ 1 an, `includeSubDomains` ? Sous-domaines tous en HTTPS avant d'activer `includeSubDomains` ? Sur Vercel, vérifier l'en-tête effectivement servi sur le domaine de production, pas seulement la config.

### Ne demander le préchargement HSTS (`preload`) que si tout le domaine et tous ses sous-domaines resteront en HTTPS durablement : le retrait prend des mois
- Niveau de preuve : N3
- Source : Chromium / hstspreload.org, consulté 2026, « HSTS Preload List Submission », https://hstspreload.org/
- Extrait lu : « Be aware that inclusion in the preload list cannot easily be undone. » ; « HSTS preloading applies to all subdomains, including internal subdomains that are not publicly accessible. » ; « The `max-age` must be at least `31536000` seconds (1 year). »
- Portée / limites : exigences de soumission : certificat valide, redirection HTTP→HTTPS sur le même hôte, tous les sous-domaines en HTTPS, `max-age` ≥ 1 an, `includeSubDomains` et `preload`. Retrait : « it takes months for a change to reach users with a Chrome update and we cannot make guarantees about other browsers ».
- En pratique : `preload` présent dans l'en-tête ? Si oui, inventaire des sous-domaines internes (intranet, NAS, `*.local` publiés en DNS public) : un seul sous-domaine en HTTP devient inaccessible. Un `preload` posé « par copier-coller » d'un gabarit est un défaut à signaler.

### Interdire l'encadrement par `frame-ancestors` (CSP) ; `X-Frame-Options: DENY` ne sert plus que de repli pour les anciens navigateurs
- Niveau de preuve : N1 (W3C, Working Draft) + N3
- Source : W3C Web Application Security WG, 27 octobre 2026 (Working Draft), « Content Security Policy Level 3 », §6.4.2.2, https://www.w3.org/TR/CSP3/ ; OWASP, « HTTP Security Response Headers Cheat Sheet » (URL ci-dessus)
- Extrait lu : « In order to allow backwards-compatible deployment, the frame-ancestors directive overrides the ``X-Frame-Options`` header. » (W3C) ; « Use Content Security Policy (CSP) frame-ancestors directive if possible. » (OWASP, qui garde `X-Frame-Options: DENY` en valeur)
- Portée / limites : CSP3 est un brouillon de travail, pas une Recommandation. `frame-ancestors` est ignoré dans une CSP posée par `<meta>` (CSP3 §3.3) ; le Web Almanac 2025 relève que plus de 2 % des pages mobiles qui posent une CSP par `<meta>` y mettent `frame-ancestors` (sans effet). MDN déclare seulement `ALLOW-FROM` obsolète, pas `DENY`/`SAMEORIGIN`.
- En pratique : `frame-ancestors` est-il dans l'**en-tête** CSP (pas dans une balise `<meta>`) ? `X-Frame-Options` éventuel cohérent avec lui (`DENY` ↔ `'none'`, `SAMEORIGIN` ↔ `'self'`) ?

### Ne pas envoyer `X-XSS-Protection`, ou l'envoyer à `0` : le filtre XSS des navigateurs est abandonné et a lui-même créé des failles
- Niveau de preuve : N3
- Source : OWASP, « HTTP Security Response Headers Cheat Sheet » (URL ci-dessus) ; MDN, consulté 2026, « X-XSS-Protection », https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/X-XSS-Protection
- Extrait lu : « Do not set this header or explicitly turn it off. » + valeur `X-XSS-Protection: 0` (OWASP) ; « in some cases, X-XSS-Protection can create XSS vulnerabilities in otherwise safe websites. » (MDN, page marquée « Deprecated » et « Non-standard »)
- Portée / limites : MDN ne prescrit pas littéralement `0` ; elle renvoie à une CSP qui interdit le script inline. L'en-tête est absent de la liste « à ajouter » d'OWASP Secure Headers (2026-10-18).
- En pratique : un `X-XSS-Protection: 1; mode=block` dans `next.config.js`, `vercel.json` ou la conf nginx est un reliquat à retirer, pas une protection.

### Poser `X-Content-Type-Options: nosniff` et une `Referrer-Policy` explicite (`strict-origin-when-cross-origin` ou plus stricte)
- Niveau de preuve : N3
- Source : OWASP, « HTTP Security Response Headers Cheat Sheet » (URL ci-dessus)
- Extrait lu : « Set the header explicitly rather than relying on browser defaults. » (Referrer-Policy, valeur `strict-origin-when-cross-origin`) ; `X-Content-Type-Options: nosniff` avec « Set the Content-Type header correctly throughout the site. »
- Portée / limites : OWASP Secure Headers (liste 2026-10-18) recommande plus strict : `Referrer-Policy: no-referrer`. Le choix dépend du besoin d'analytique ; les deux sont défendables. `nosniff` suppose des `Content-Type` corrects.
- En pratique : en-têtes présents sur les réponses HTML **et** sur les API / fichiers téléversés servis (Supabase Storage, route handlers) ? URL contenant des jetons (réinitialisation de mot de passe, liens magiques) + Referrer-Policy laxiste = fuite vers les tiers.

### Fermer les fonctionnalités navigateur inutiles par `Permissions-Policy` (liste de référence OWASP Secure Headers)
- Niveau de preuve : N3
- Source : OWASP Secure Headers Project, fichier `ci/headers_add.json`, `last_update_utc` 2026-10-18 07:04:36, https://raw.githubusercontent.com/OWASP/www-project-secure-headers/master/ci/headers_add.json (projet : https://owasp.org/www-project-secure-headers/) ; OWASP Cheat Sheet (URL ci-dessus)
- Extrait lu : « Set it and disable all the features that your site does not need or allow them only to the authorized domains: » + `Permissions-Policy: geolocation=(), camera=(), microphone=()` (Cheat Sheet). La liste OWASP Secure Headers propose une valeur longue (`accelerometer=(), autoplay=(), camera=(), … geolocation=(), … microphone=(), … payment=(), … usb=() …`).
- Portée / limites : la liste « à ajouter » d'OWASP inclut aussi `Clear-Site-Data: "cache","cookies","storage"` et `Cache-Control: no-store, max-age=0` : valeurs de **référence maximale**, à ne pas poser globalement (effacerait la session à chaque réponse et casserait le cache d'une PWA). Adoption réelle faible : 3,7 % des pages mobiles (Web Almanac 2025, entrée ci-dessous).
- En pratique : une PWA qui n'utilise ni caméra, ni micro, ni géolocalisation les ferme-t-elle ? Les `allow=` des `<iframe>` tierces sont-ils bornés ?

### N'activer COOP / COEP / CORP qu'en connaissance de cause : `same-origin` pour COOP est sûr, `require-corp` pour COEP casse les ressources tierces non marquées
- Niveau de preuve : N3 + N2
- Source : OWASP, « HTTP Security Response Headers Cheat Sheet » (URL ci-dessus) ; Vanderlinden V., Franken G., 15 janvier 2026, « Security — Web Almanac 2025 », HTTP Archive, https://almanac.httparchive.org/en/2025/security
- Extrait lu : « Isolates the browsing context exclusively to same-origin documents. » (COOP `same-origin`) ; COEP : « A document can only load resources from the same origin, or resources explicitly marked as loadable from another origin. » ; Almanac : « In total, 5.6% of the observed COEP headers contain an invalid value on mobile. »
- Portée / limites : Almanac 2025 (valeurs observées, pas taux d'adoption) : COOP `same-origin` dans 61,64 % des en-têtes COOP mobiles ; COEP `unsafe-none` dans 86,52 % (donc COEP posé mais neutre) ; CORP `cross-origin` dans 80,52 %. CORP et COOP dépassent chacun 2 % d'adoption globale (extraction WebFetch, non recontrôlée par grep).
- En pratique : COOP `same-origin` est un gain à faible risque (sauf popups OAuth qui ont besoin de `window.opener` : tester la connexion Google / GitHub). COEP `require-corp` seulement si l'isolation cross-origin est requise (`SharedArrayBuffer`).

### Retirer `X-Powered-By` (Next.js l'ajoute par défaut) et ne pas exposer de numéro de version dans `Server`
- Niveau de preuve : N3 + N2
- Source : Next.js, mis à jour 2025-06-16, « poweredByHeader », https://nextjs.org/docs/app/api-reference/config/next-config-js/poweredByHeader ; OWASP Cheat Sheet (URL ci-dessus) ; Web Almanac 2025 (URL ci-dessus)
- Extrait lu : « By default Next.js will add the `x-powered-by` header. » (Next.js) ; « Remove all X-Powered-By headers. » (OWASP) ; « For both desktop and mobile, we find that over 27% of the X-Powered-By headers contain version information. » (Almanac)
- Portée / limites : gain limité (empreinte, pas vulnérabilité) ; Almanac : `Server` présent sur 91,5 % et `X-Powered-By` sur 23,9 % des hôtes. OWASP Secure Headers liste `Server`, `X-AspNet-Version`, `X-Powered-By` parmi 88 en-têtes à retirer (`headers_remove.json`).
- En pratique : `poweredByHeader: false` dans `next.config.*` ? nginx `server_tokens off` sur le VPS / NAS ?

### Mesurer l'écart à la norme du web avant de juger : CSP sur 21,9 % des pages, HSTS sur 36 % des pages mobiles, TLS 1.3 sur ~76 %
- Niveau de preuve : N2 (crawl HTTP Archive de juillet 2025, « several million websites », URL issues du Chrome UX Report)
- Source : Vanderlinden V., Franken G. (relecture : Duggal, Kraus, Clark, Rautenstrauch, Tiwari ; analyse : Vansteenhuyse), 15 janvier 2026, « Security — Web Almanac 2025 », https://almanac.httparchive.org/en/2025/security ; méthodologie : https://almanac.httparchive.org/en/2025/methodology
- Extrait lu : « The adoption of CSP continued increasing from 18.5% last year to 21.9% this year, an increase of close to 20%. » ; « Figure 9.8. The percentage of pages using the HSTS header on mobile » (36 %) ; « TLS 1.3 is the clear standard, powering roughly 76% of all web pages »
- Portée / limites : taux par page, pas par site ; pas de ventilation par hébergeur. Pour HSTS, `includeSubDomains` (~40 %) et `preload` (~22 %) sont lus sur la description d'une figure (approximatif, part des en-têtes HSTS). Le chapitre ne traite pas les attributs de cookies (renvoi au chapitre Cookies, non lu).
- En pratique : une application sans HSTS ni CSP est dans la majorité du web — ce n'est pas une circonstance atténuante, mais cela calibre la sévérité : « manquant » = MOYEN, « mal configuré avec fausse assurance » peut être plus grave.

---

## 2. Cookies de session

### Cookie de session : `Secure`, `HttpOnly`, `SameSite=Strict` (préféré) ou `Lax` **explicite**, préfixe `__Host-`, `Path=/`, pas de `Domain`
- Niveau de preuve : N3
- Source : OWASP Cheat Sheet Series, consulté 2026, « Session Management Cheat Sheet », https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html
- Extrait lu : « Session cookies must explicitly set SameSite=Strict (preferred) or SameSite=Lax. Never use SameSite=None without Secure, and do not rely on the browser-default value, which varies across browsers and versions. » ; « __Host- — the cookie must be set with Secure, must not have a Domain attribute, and must use Path=/. […] Recommended for session IDs. »
- Portée / limites : OWASP rappelle que SameSite est une défense en profondeur contre CSRF, pas un remplaçant du jeton. MDN confirme que le défaut `Lax` n'est appliqué que par « Some browsers » (https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Set-Cookie). L'exemple officiel Next.js pose `httpOnly`, `secure`, `sameSite: 'lax'`, `path: '/'` mais **pas** de préfixe `__Host-` (https://nextjs.org/docs/app/guides/authentication).
- En pratique : DevTools > Application > Cookies : les trois drapeaux sont-ils présents sur le cookie d'authentification (y compris ceux posés par `@supabase/ssr`) ? `SameSite` absent = défaut à signaler même si le navigateur de test applique `Lax`.

### Les préfixes `__Host-` / `__Secure-` (et `__Http-` / `__Host-Http-`) sont appliqués par le navigateur ; RFC 6265bis n'est pas encore publiée ; `Partitioned` (CHIPS) ne sert qu'aux contextes tiers
- Niveau de preuve : N3 + N1 (en cours)
- Source : MDN, consulté 2026, « Set-Cookie », https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Set-Cookie ; IETF HTTPBIS, 1er décembre 2025, « draft-ietf-httpbis-rfc6265bis-22 », https://datatracker.ietf.org/doc/draft-ietf-httpbis-rfc6265bis/
- Extrait lu : « This combination yields a cookie that is as close as can be to treating the origin as a security boundary. » (MDN, `__Host-`) ; `__Host-Http-` : « must have the `HttpOnly` attribute set to prove that they were set via the `Set-Cookie` header » ; datatracker : « Active Internet-Draft », statut RFC Editor « blocked: Final Approval Pending », statut visé « Proposed Standard »
- Portée / limites : pas de numéro de RFC au 9 novembre 2026 ; RFC 6265 (2011) reste le texte publié. MDN : « You cannot count on these additional assurances on browsers that don't support cookie prefixes ». La date « Last updated 2026-10-19 » du datatracker postérieure à l'expiration annoncée (4 juin 2026) est une incohérence de la page elle-même.
- Complément `Partitioned` (CHIPS) : MDN, « Cookies Having Independent Partitioned State (CHIPS) », https://developer.mozilla.org/en-US/docs/Web/Privacy/Guides/Privacy_sandbox/Partitioned_cookies — « Partitioned cookies must be set with `Secure`. » ; page marquée « Baseline 2025 » ; usage : widgets tiers embarqués (cartes, chat), le préfixe `__Host` y est recommandé. Un cookie de session premier-partie n'en a pas besoin.
- En pratique : un cookie de session sans préfixe sur un domaine qui a des sous-domaines tiers (blog, statut, `*.vercel.app` partagé) est exposé à l'écrasement par un sous-domaine : recommander `__Host-`. `Partitioned` sur le cookie de session d'une application non embarquée = configuration copiée sans compréhension.

### Imposer côté serveur une expiration d'inactivité **et** une expiration absolue, et régénérer l'identifiant à la connexion
- Niveau de preuve : N3
- Source : OWASP, « Session Management Cheat Sheet » (URL ci-dessus) ; OWASP Top 10:2025, « A07:2025 Authentication Failures », https://top10.owasp.org/2025/A07_2025-Authentication_Failures
- Extrait lu : « Common idle timeouts ranges are 2-5 minutes for high-value applications and 15-30 minutes for low risk applications » (Session) ; « invalidated after logout, idle, and absolute timeouts. » et « Reuses the same session identifier after successful login. » parmi les failles (A07:2025)
- Portée / limites : pour l'absolu, OWASP ne fixe pas de valeur (exemple 4 à 8 h pour un usage de bureau). Avec Supabase Auth, la durée vit dans la config du projet (JWT + refresh token) — non vérifié ici. L'exemple Next.js utilise un JWT de 7 jours prolongé à chaque visite : aucune expiration absolue.
- En pratique : déconnexion → le jeton est-il invalidé côté serveur ou seulement supprimé du navigateur ? Session « glissante » sans plafond absolu ?

### Aligner la politique de mot de passe sur NIST SP 800-63B-4 : longueur et liste noire, pas de règles de composition ni de rotation périodique
- Niveau de preuve : N1
- Source : NIST, juillet 2025 (Final, 31/07/2025), « SP 800-63B-4 Digital Identity Guidelines: Authentication and Authenticator Management », https://pages.nist.gov/800-63-4/sp800-63b.html (statut : https://csrc.nist.gov/pubs/sp/800/63/b/4/final)
- Extrait lu : « Verifiers and CSPs SHALL NOT impose other composition rules (e.g., requiring mixtures of different character types) for passwords. » ; « SHALL require passwords that are used as a single-factor authentication mechanism to be a minimum of 15 characters in length. » ; liste noire des mots de passe courants ou compromis obligatoire.
- Portée / limites : 8 caractères minimum tolérés si le mot de passe n'est qu'un facteur d'une MFA. OWASP A07:2025 renvoie à NIST 800-63b §5.1.1 et dit « Do not force human beings to rotate passwords unless you suspect breach. » **Contradiction relevée** : l'exemple Zod du guide d'authentification Next.js (mis à jour 2026-09-16) exige lettre + chiffre + caractère spécial et 8 caractères — exactement ce que NIST interdit.
- En pratique : la validation du formulaire d'inscription impose-t-elle des classes de caractères ? Le mot de passe est-il confronté à une liste de mots de passe compromis (réglage « leaked password protection » côté Supabase — non vérifié ici) ?

---

## 3. TLS et certificats

### Profil TLS « Intermediate » (TLS 1.2 + 1.3) par défaut ; « Modern » (TLS 1.3 seul) si aucun client ancien ; le générateur Mozilla a migré vers TLSRef
- Niveau de preuve : N3
- Source : Mozilla, « Server Side TLS » guidelines v6.0, fichier https://ssl-config.mozilla.org/guidelines/latest.json ; page https://ssl-config.mozilla.org/ (redirection) ; TLSRef Configurator, build du 2026-10-13, https://configurator.tlsref.org/
- Extrait lu : « Mozilla SSL Config Generator has moved to TLSRef Configurator » (ssl-config.mozilla.org) ; « General-purpose servers with a variety of clients, recommended for almost all systems. » (TLSRef, Intermediate) ; JSON v6.0 : `"tls_versions": ["TLSv1.3"]` (modern), `["TLSv1.2", "TLSv1.3"]` (intermediate), `hsts_min_age` 63072000.
- Portée / limites : Modern : plus anciens clients Firefox 63, Chrome 70, Safari 12.1, Android 10. Le JSON v6.0 contient encore `"ocsp_staple": true` alors que Let's Encrypt n'émet plus d'URL OCSP (entrée suivante) : incohérence à signaler. La page wiki Mozilla Server_Side_TLS ne s'est pas chargée (lue : non). Ne concerne que le VPS/NAS : Vercel et Supabase gèrent TLS eux-mêmes.
- En pratique : `nmap --script ssl-enum-ciphers -p 443 <hôte>` ou testssl.sh : TLS 1.0/1.1 désactivés ? Conf nginx générée depuis TLSRef, et datée ?

### Automatiser entièrement le renouvellement : la durée maximale des certificats publics baisse de 398 jours à 47 jours d'ici mars 2029
- Niveau de preuve : N1 (exigences de l'industrie, CA/Browser Forum)
- Source : CA/Browser Forum, 11 avril 2025, « Ballot SC081v3: Introduce Schedule of Reducing Validity and Data Reuse Periods », https://cabforum.org/2025/04/11/ballot-sc081v3-introduce-schedule-of-reducing-validity-and-data-reuse-periods/
- Extrait lu : « Eventual reduction of maximum validity period from 398 days to 47 days » ; « These reductions are proposed to occur starting in March 2026 and concluding in March 2029. » ; « Eventual reduction of SAN validation data reuse from 398 days to 10 days »
- Portée / limites : proposé par Clint Wilson (Apple) ; adopté (émetteurs 25 oui / 0 non / 5 abstentions ; consommateurs 4 oui). Les paliers intermédiaires (200 jours dès le 15/03/2026, 100 jours dès le 15/03/2027, 47 jours dès le 15/03/2029) n'apparaissent que dans le résumé d'une recherche citant les Baseline Requirements : **non lus dans le texte des BR** (voir « Non vérifié »).
- En pratique : un certificat posé à la main sur un NAS ou un reverse proxy, renouvelé « une fois par an », cessera de fonctionner ; exiger ACME (certbot, Caddy, Traefik) et une alerte d'expiration.

### Let's Encrypt : 45 jours par défaut d'ici février 2028 ; utiliser ARI plutôt qu'un renouvellement à intervalle fixe ; OCSP arrêté depuis août 2025
- Niveau de preuve : N3
- Source : Let's Encrypt, 2 décembre 2025, « Decreasing Certificate Lifetimes to 45 Days », https://letsencrypt.org/2025/12/02/from-90-to-45 ; Let's Encrypt, 6 août 2025, « OCSP Service Has Reached End of Life », https://letsencrypt.org/2025/08/06/ocsp-service-has-reached-end-of-life ; Let's Encrypt (M. McPherrin), 15 janvier 2026, « 6-day and IP Address Certificates are Generally Available », https://letsencrypt.org/2026/01/15/6day-and-ip-general-availability
- Extrait lu : « renewing at a hardcoded interval of 60 days will no longer be sufficient » ; « Today we turned off our Online Certificate Status Protocol (OCSP) service. » ; « These certificates are valid for 160 hours, just over six days. »
- Portée / limites : calendrier : profil opt-in `tlsserver` à 45 jours le 13 mai 2026 ; profil `classic` à 64 jours le 10 février 2027 ; 45 jours (réutilisation d'autorisation 7 h) le 16 février 2028. Certificats de 6 jours : profil `shortlived`, opt-in, « no plan to make them the default ». La révocation passe exclusivement par CRL. Que les certificats demandés avec OCSP Must-Staple soient refusés depuis le 7 mai 2025 provient d'un résumé de recherche (forum), **non lu sur la page source**.
- En pratique : `crontab` / timer certbot avec intervalle fixe ? Client ACME compatible ARI ? Option `--must-staple` ou `ssl_stapling` dans une vieille conf ?

---

## 4. Next.js et Vercel

### Ne jamais faire du middleware / `proxy` la seule barrière d'autorisation (CVE-2025-29927 l'a contourné par un simple en-tête) : contrôler au plus près des données
- Niveau de preuve : N3
- Source : Vercel / Next.js, 21 mars 2025, « Authorization Bypass in Next.js Middleware » (GHSA-f82v-jwr5-mffw, CVE-2025-29927), https://github.com/vercel/next.js/security/advisories/GHSA-f82v-jwr5-mffw ; Vercel, 2025, « Postmortem on Next.js Middleware bypass », https://vercel.com/blog/postmortem-on-next-js-middleware-bypass
- Extrait lu : « We do not recommend Middleware to be the sole method of protecting routes in your application » (postmortem) ; avis : bloquer les « external user requests which contain the `x-middleware-subrequest` header » si la mise à jour est impossible.
- Portée / limites : CVSS 3.1 = 9,1 (critique). Corrigé en 12.3.5, 13.5.9, 14.2.25, 15.2.3. Touchés : auto-hébergement `next start` et `output: 'standalone'` ; non touchés : Vercel (« incidentally invulnerable »), Netlify, Cloudflare Workers, export statique. Signalé le 27 février 2025.
- Complément (même thème) : Next.js, mis à jour 2026-09-16, « How to implement authentication in Next.js », https://nextjs.org/docs/app/guides/authentication — « While Proxy can be useful for initial checks, it should not be your only line of defense in protecting your data. The majority of security checks should be performed as close as possible to your data source » ; « be cautious when doing checks in Layouts as these don't re-render on navigation ». Un `return null` dans un layout « will not prevent nested route segments and Server Actions from being accessed ». Depuis Next.js 16 le middleware s'appelle `proxy` (date exacte du renommage non vérifiée).
- En pratique : version de `next` dans le lockfile ≥ version corrigée de sa branche ? Chaque page, route handler et Server Action vérifie-t-il la session lui-même (couche d'accès aux données) ? Sur un VPS/NAS, le reverse proxy filtre-t-il les en-têtes internes ? Contrôles d'accès présents seulement dans `middleware.ts`/`proxy.ts` ou `layout.tsx` = constat ; chercher une fonction `verifySession()` appelée à chaque lecture de données sensible.

### Tenir React et Next.js à jour sur les avis de sécurité : CVE-2025-55182 (React Server Components) est une exécution de code à distance sans authentification, et les mitigations des hébergeurs ne suffisent pas
- Niveau de preuve : N3
- Source : The React Team, 3 décembre 2025 (mis à jour le 26 janvier 2026), « Critical Security Vulnerability in React Server Components », https://react.dev/blog/2025/12/03/critical-security-vulnerability-in-react-server-components
- Extrait lu : « Even if your app does not implement any React Server Function endpoints it may still be vulnerable if your app supports React Server Components » ; « You should not depend on these to secure your app, and still update immediately »
- Portée / limites : CVSS 10.0 ; paquets `react-server-dom-*` 19.0, 19.1.0, 19.1.1, 19.2.0 ; corrigés en 19.0.1, 19.1.2, 19.2.1 ; frameworks touchés dont `next`. CVE ultérieures listées : CVE-2025-55184 et CVE-2025-67779 (DoS, 7.5), CVE-2025-55183 (exposition de code source, 5.3), CVE-2026-23864 (DoS, 7.5). Les numéros de version Next.js corrigés divergent légèrement au sein même de la page (15.4.10 vs 15.4.11) : se référer au billet Next.js (https://nextjs.org/blog/security-update-2025-12-11, **non lu**).
- En pratique : `npm ls next react-server-dom-webpack` ; Dependabot / `npm audit` actifs ? Contraste à retenir : pour CVE-2025-29927 Vercel protégeait d'office ; pour CVE-2025-55182 la protection de l'hébergeur est explicitement déclarée insuffisante.

### Protéger les déploiements de prévisualisation (Vercel Deployment Protection, « Standard Protection » au minimum) et inventorier les contournements
- Niveau de preuve : N3
- Source : Vercel, mis à jour 2026-09-15, « Deployment Protection on Vercel », https://vercel.com/docs/deployment-protection ; Vercel, 2026-09-15, « Restrict access to deployments with Vercel Authentication », https://vercel.com/docs/deployment-protection/methods-to-protect-deployments/vercel-authentication
- Extrait lu : « Standard Protection is the recommended option for most projects. It protects all domains except production domains. » ; « Disabling Vercel Authentication renders all existing deployments unprotected. »
- Portée / limites : Standard Protection et All Deployments disponibles sur tous les plans ; Password Protection payante (Pro, 20 $/mois/projet ; absente du plan Hobby) ; Trusted IPs réservé à Enterprise. Contournements prévus : Shareable Links, « Protection Bypass for Automation », Trusted Sources. Valeur par défaut pour un **nouveau** projet : la doc parle d'un défaut d'équipe configurable, sans dire lequel s'applique sans réglage (non vérifié).
- En pratique : Settings > Deployment Protection : niveau = None ? Une prévisualisation branchée sur la base de **production** et ouverte au public est une production bis sans contrôle. Liens partageables et secrets de contournement encore actifs ?

### Classer les variables d'environnement Vercel en « Secret » (non relisibles) et séparer les valeurs de production de celles de prévisualisation
- Niveau de preuve : N3
- Source : Vercel, mis à jour 2026-08-28, « Config and Secret environment variables », https://vercel.com/docs/environment-variables/sensitive-environment-variables
- Extrait lu : « Secret values are write-only after saving. Use them for passwords, API keys, and tokens. » ; « When enabled, each Secret must use a different value in Production than in Preview, Development, and custom environments. »
- Portée / limites : la terminologie a changé : les variables « Sensitive » sont désormais « Secret » ; la politique d'équipe « Enforce Sensitive Environment Variables » est **dépréciée**, remplacée par « Separate Production Secret Values » (option, propriétaire de l'équipe). Masquage dans les logs de build seulement si la valeur fait ≥ 32 caractères.
- En pratique : la clé secrète Supabase / `service_role` de production est-elle aussi servie aux prévisualisations ? Variables typées « Config » contenant un secret ? Une variable `NEXT_PUBLIC_*` contenant un secret est publique quel que soit son type.

### Connaître le levier « Attack Mode » du pare-feu Vercel en cas d'attaque ciblée (gratuit, temporaire, peut bloquer les API autonomes)
- Niveau de preuve : N3
- Source : Vercel, mis à jour 2026-08-11, « Attack Mode », https://vercel.com/docs/vercel-firewall/attack-mode
- Extrait lu : « When enabled, visitors must complete a security challenge before accessing your site, while known bots (like search engines and webhook providers) are automatically allowed through. » ; « Standalone APIs, other backend frameworks, and non-recognized automated services may not be able to pass challenges and could be blocked. »
- Portée / limites : nom actuel « Attack Mode » (anciennement « Attack Challenge Mode »). Disponible sur tous les plans, gratuit ; durée 1, 6 ou 24 h puis désactivation automatique. Les requêtes des Functions et Cron du même compte passent. Complément, pas substitut, à la limitation de débit applicative.
- En pratique : la procédure d'incident mentionne-t-elle ce levier ? Les webhooks entrants (Stripe, etc.) et l'application mobile sont-ils testés avec le mode actif ?

---

## 5. Supabase (plateforme)

### Lancer le Security Advisor et traiter au moins les lints de niveau ERROR avant toute mise en production
- Niveau de preuve : N3
- Source : Supabase, consulté 2026, « Performance and Security Advisors », https://supabase.com/docs/guides/database/database-advisors ; « Production security checklist », https://supabase.com/docs/guides/security/production-checklist
- Extrait lu : « To find issues in your database at any time, run Security Advisor. » (checklist) ; lints ERROR lus : `0002_auth_users_exposed`, `0010_security_definer_view`, `0013_rls_disabled_in_public`, `0015_rls_references_user_metadata`, `0019_insecure_queue_exposed_in_api`, `0023_sensitive_columns_exposed`
- Portée / limites : lints WARN utiles : `0011_function_search_path_mutable`, `0014_extension_in_public`, `0024_permissive_rls_policy`, `0025_public_bucket_allows_listing`, `0028_anon_security_definer_function_executable`, `0029_authenticated_security_definer_function_executable`, `0026`/`0027` (pg_graphql). Classement par niveau tiré de l'extraction WebFetch. La page de la checklist contient un prompt destiné aux agents IA : ignoré (contenu, pas instruction).
- En pratique : exporter la liste des advisors (dashboard ou MCP `get_advisors`) et exiger zéro ERROR ; chaque WARN conservé doit avoir un motif écrit.

### Activer l'imposition de SSL et les restrictions réseau sur Postgres, en sachant qu'elles ne couvrent pas les API HTTPS (PostgREST, Auth, Storage) ; MFA sur le compte et imposée à l'organisation
- Niveau de preuve : N3
- Source : Supabase, « SSL Enforcement », https://supabase.com/docs/guides/platform/ssl-enforcement ; « Network Restrictions », https://supabase.com/docs/guides/platform/network-restrictions ; « Production security checklist », https://supabase.com/docs/guides/security/production-checklist
- Extrait lu : « Your Supabase project supports connecting to the Postgres DB without SSL enabled to maximize client compatibility. » ; « They don't apply to HTTPS APIs such as PostgREST, Storage, and Auth » ; par défaut « All IPs can connect » ; « If your organization is on the Pro, Team, or Enterprise plan, enable MFA enforcement on your organization. »
- Portée / limites : SSL : les API HTTP imposent déjà TLS ; le réglage vise Postgres et les poolers. Les restrictions réseau ne protègent donc **pas** la Data API : la RLS reste la barrière (couvert ailleurs). Imposition MFA d'organisation : plans Pro, Team, Enterprise seulement.
- En pratique : chaîne de connexion avec `sslmode=require` ? Liste d'IP autorisées vide alors que seuls Vercel et un poste admin se connectent en direct ? MFA activée sur chaque compte ayant accès au dashboard (et 2FA GitHub si connexion via GitHub) ?

### Vérifier la stratégie de sauvegarde selon le plan : pas de sauvegarde téléchargeable en Free, PITR en option payante, Storage jamais inclus
- Niveau de preuve : N3
- Source : Supabase, consulté 2026, « Database Backups », https://supabase.com/docs/guides/platform/backups ; « Production Checklist », https://supabase.com/docs/guides/deployment/going-into-prod
- Extrait lu : « Pro Plan projects can access the last 7 days of daily backups. » ; « Database backups do not include objects you store via the Storage API. » ; « Database backups are not available for download for Free Plan projects. »
- Portée / limites : Team 14 jours, Enterprise jusqu'à 30 jours ; PITR = add-on Pro/Team/Enterprise. La page ne dit pas explicitement si le plan Free bénéficie de sauvegardes automatiques ; elle recommande aux projets Free d'exporter régulièrement (`db dump`).
- En pratique : projet en plan Free avec données réelles et aucun `supabase db dump` planifié = perte de données probable. Fichiers téléversés (Storage) sauvegardés à part ?

---

## 6. GitHub Actions et chaîne CI

### Verrouiller les actions tierces (lockfile de dépendances de workflow si disponible, sinon SHA complet de commit), jamais un tag mobile ; laisser Dependabot les mettre à jour
- Niveau de preuve : N3
- Source : GitHub Docs, consulté 2026, « Secure use reference », https://docs.github.com/en/actions/reference/security/secure-use ; GitHub Docs, « Keeping your actions up to date with Dependabot », https://docs.github.com/en/code-security/dependabot/working-with-dependabot/keeping-your-actions-up-to-date-with-dependabot
- Extrait lu : « The best measure is to lock your workflow dependencies with a lockfile. […] This is the strongest protection available, and supersedes SHA pinning for repositories that adopt it. » ; « For repositories that cannot adopt a lockfile, you can: Pin actions to a full-length commit SHA » ; « a tag can be moved or deleted if a bad actor gains access to the repository storing the action »
- Portée / limites : la page « Workflow dependency lockfiles » vers laquelle GitHub renvoie **n'a pas été lue** : nom de fichier, disponibilité et plans non vérifiés. Dependabot : `package-ecosystem: "github-actions"` ; la page ne dit pas s'il met à jour les références épinglées par SHA. CODEOWNERS sur `.github/workflows` recommandé par la même page « Secure use ».
- En pratique : `grep -rn "uses:" .github/workflows | grep -v "@[0-9a-f]\{40\}"` — toute action tierce non épinglée est un constat. `dependabot.yml` couvre-t-il `github-actions` ?

### Réduire `GITHUB_TOKEN` à la lecture par défaut et élever les permissions job par job ; préférer OIDC aux secrets cloud de longue durée
- Niveau de preuve : N3
- Source : GitHub Docs, « Secure use reference » (URL ci-dessus) ; GitHub Docs, « OpenID Connect », https://docs.github.com/en/actions/concepts/security/openid-connect
- Extrait lu : « It's good security practice to set the default permission for the GITHUB_TOKEN to read access only for repository contents. » ; OIDC : « your cloud provider issues a short-lived access token that is only valid for a single job, and then automatically expires. »
- Portée / limites : la page OIDC lue ne mentionne pas la permission `id-token: write` (non vérifiée ici). Le masquage automatique des secrets dans les logs n'est pas garanti : « Because there are multiple ways a secret value can be transformed, automatic redaction is not guaranteed. »
- En pratique : bloc `permissions:` présent au niveau du workflow ? Absence = permissions par défaut du dépôt (à vérifier dans Settings > Actions). Jeton Vercel ou clé `service_role` stockés en secret de dépôt alors qu'un mécanisme OIDC existe ?

### Ne jamais interpoler `${{ github.event.* }}` (titre de PR, nom de branche, corps de commentaire) dans un `run:` ; passer par une variable d'environnement intermédiaire
- Niveau de preuve : N3
- Source : GitHub Docs, « Secure use reference » (URL ci-dessus)
- Extrait lu : « the preferred approach to handling untrusted input is to set the value of the expression to an intermediate environment variable »
- Portée / limites : l'injection a lieu avant l'exécution du shell (l'expression est substituée dans le script). La variable intermédiaire doit être citée (`"$TITLE"`).
- En pratique : `grep -rn 'run:.*\${{ *github\.event' .github/workflows` et blocs `run: |` multi-lignes contenant `github.event.pull_request.title`, `head_ref`, `issue.body`, `comment.body`.

### Ne pas combiner `pull_request_target` (ou `workflow_run`) avec un checkout du code de la PR ; pas de runner auto-hébergé sur un dépôt public
- Niveau de preuve : N3
- Source : GitHub Docs, « Secure use reference » (URL ci-dessus) ; Lobačevski J. (GitHub Security Lab), 3 août 2021, « Keeping your GitHub Actions and workflows secure Part 1: Preventing pwn requests », https://securitylab.github.com/resources/github-actions-preventing-pwn-requests/
- Extrait lu : « Workflows that use these triggers must not explicitly check out untrusted code » (GitHub Docs) ; « Combining pull_request_target workflow trigger with an explicit checkout of an untrusted PR is a dangerous practice » (Security Lab) ; runners auto-hébergés : « any user can open pull requests against the repository and compromise the environment. »
- Portée / limites : l'article Security Lab date de 2021 mais reste cité par la doc actuelle. Un `npm install` sur le code de la PR suffit (scripts `postinstall`). `persist-credentials: true` (défaut d'`actions/checkout`) laisse le jeton sur disque.
- En pratique : `grep -rn "pull_request_target" .github/workflows` puis vérifier tout `actions/checkout` avec `ref: ${{ github.event.pull_request.head.sha }}` ; `runs-on: self-hosted` dans un dépôt public = défaut bloquant.

### Traiter une action compromise comme une fuite de secrets : tj-actions/changed-files (CVE-2025-30066, mars 2025) a imprimé les secrets dans les logs publics
- Niveau de preuve : N3
- Source : GitHub Advisory Database, 2025, « GHSA-mrrh-fwg8-r2c3 / CVE-2025-30066 », https://github.com/advisories/GHSA-mrrh-fwg8-r2c3 ; CISA, 18 mars 2025 (révisé le 26 mars 2025), « Supply Chain Compromise of Third-Party tj-actions/changed-files (CVE-2025-30066) and reviewdog/action-setup@v1 (CVE-2025-30154) », https://www.cisa.gov/news-events/alerts/2025/03/18/supply-chain-compromise-third-party-tj-actionschanged-files-cve-2025-30066-and-reviewdogaction
- Extrait lu : « extracted secrets from the Runner Worker process memory and printed them in GitHub Actions logs » (GHSA) ; « Rotate all identified secrets immediately as they should be considered compromised. » (CISA)
- Portée / limites : versions ≤ 45.0.7 touchées, corrigé en 46.0.1 ; CVSS 8,6 ; fenêtre GHSA 14–15 mars 2025, fenêtre d'audit CISA 2025-03-12 00:00 UTC → 2025-03-15 12:00 UTC ; des tags (v1.0.0, v35.7.7-sec, v44.5.1) avaient été repointés vers le commit malveillant — démonstration directe du risque des tags mobiles. Compromission probablement rendue possible par celle de `reviewdog/action-setup@v1`.
- En pratique : logs des workflows publics relus pour des valeurs encodées en base64 ? Plan de rotation des secrets CI documenté et testé ?

### Protéger la branche de production : revue obligatoire, contrôles requis, force-push interdit, CODEOWNERS sur les workflows
- Niveau de preuve : N3
- Source : GitHub Docs, consulté 2026, « About protected branches », https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches ; « Secure use reference » (URL ci-dessus)
- Extrait lu : « Required status checks must have a `successful`, `skipped`, or `neutral` status » ; « GitHub blocks force pushes on all protected branches » ; « You can use the `CODEOWNERS` feature to control how changes are made to your workflow files. »
- Portée / limites : une seule règle de protection par branche, limite levée par les rulesets. OWASP A03:2025 ajoute la séparation des tâches : « No single person should be able to write code and promote it all the way to production » — difficile à tenir pour un développeur seul (voir verdicts).
- En pratique : `main` sans protection et déployée automatiquement par Vercel = n'importe quel jeton à droit d'écriture déploie en production.

---

## 7. Serveur auto-hébergé (VPS, NAS)

### Ne pas exposer d'interface d'administration (panneau NAS, base de données, SSH ouvert au monde) sur Internet ; la mettre derrière un réseau d'administration, une liste d'IP ou un VPN
- Niveau de preuve : N3
- Source : Crowther R. (NCSC UK), 22 mars 2017, « Protect your management interfaces », https://www.ncsc.gov.uk/blog-post/protect-your-management-interfaces ; CISA, 13 juin 2023, « BOD 23-02: Mitigating the Risk from Internet-Exposed Management Interfaces », https://www.cisa.gov/news-events/directives/binding-operational-directive-23-02
- Extrait lu : « If you can avoid exposing management interfaces then you're reducing your attack surface. » ; « At the very least, limit authorised inbound IP addresses to those used by dedicated management devices. » (NCSC) ; « Remove the interface from the internet by making it only accessible from an internal enterprise network. » (CISA)
- Portée / limites : BOD 23-02 ne s'impose qu'aux agences fédérales américaines et vise routeurs, pare-feu, VPN, répartiteurs de charge ; l'analogie avec un panneau NAS ou un port Postgres 5432 est une transposition. Billet NCSC de 2017.
- En pratique : depuis l'extérieur, `nmap -Pn <IP publique>` : ports 22, 5000/5001 (panneaux NAS courants), 5432, 3306, 6379, 8080 ouverts ? Postgres / Supabase auto-hébergé écoutant sur `0.0.0.0` ?

### NAS domestique ou de bureau : aucune redirection de port, accès distant par VPN avec second facteur, mots de passe ≥ 12 caractères pour tout service exposé, mises à jour de tous les appareils
- Niveau de preuve : N3
- Source : Office fédéral de la cybersécurité (OFCS, Suisse), 6 février 2024, « Semaine 5 : Protégez votre réseau privé des accès externes », https://www.bacs.admin.ch/fr/24w05-fr
- Extrait lu : « que s'il est doté des derniers patchs de sécurité et qu'aucune redirection de port n'est configurée, c'est-à-dire qu'aucun service n'est accessible de l'extérieur. » ; « les services exposés et les accès VPN devraient être protégés par un deuxième facteur » ; « L'OFCS recommande d'utiliser des mots de passe d'au moins 12 caractères pour les services exposés. »
- Portée / limites : cas réel : intrusion par une vulnérabilité d'un stockage réseau exposé par redirection de port, puis chiffrement des données. Avis grand public. Le seuil de 12 caractères diffère du minimum NIST (15 en facteur unique) — les deux sources ne visent pas le même contexte.
- En pratique : règles de redirection de port sur le routeur ? Service « accès à distance » du fabricant du NAS (relais cloud) activé ? Sauvegarde hors ligne des données du NAS ?

### SSH : authentification par clé (asymétrique), connexion directe en root interdite, accès limité aux utilisateurs nominatifs qui en ont besoin
- Niveau de preuve : N3
- Source : ANSSI, 17 août 2015, « Recommandations pour un usage sécurisé d'(Open)SSH » (DAT-NT-007), https://messervices.cyber.gouv.fr/documents-guides/NT_OpenSSH.pdf (PDF extrait avec pdftotext)
- Extrait lu : R17 « L'authentification d'un utilisateur doit se faire à l'aide d'un des mécanismes suivants, par ordre de préférence : • par cryptographie asymétrique ECDSA ; • par cryptographie asymétrique RSA ; […] » et « Dans tous les cas, si l'utilisateur a des privilèges élevés sur le système, l'usage du mot de passe est à proscrire. » ; « PermitRootLogin no » ; R22 « Les accès à un service doivent être restreints aux utilisateurs qui en ont un besoin justifié. »
- Portée / limites : document de 2015 : ses choix d'algorithmes (ECDSA préféré, RSA ≥ 2048) n'intègrent pas Ed25519 ; ne pas en tirer de règle cryptographique actuelle. La logique d'accès (clé, pas de root, liste positive d'utilisateurs, écoute sur l'interface d'administration) reste valable.
- En pratique : `sshd -T | grep -Ei 'passwordauthentication|permitrootlogin|allowusers'` ; `PasswordAuthentication yes` sur un VPS exposé = constat.

### Durcir le système : paquets strictement nécessaires, procédure de mise à jour de sécurité régulière, services en écoute uniquement sur les interfaces adéquates
- Niveau de preuve : N3
- Source : ANSSI, 3 octobre 2022 (v2.0), « Recommandations de configuration d'un système GNU/Linux » (ANSSI-BP-028), https://messervices.cyber.gouv.fr/documents-guides/fr_np_linux_configuration-v2.0.pdf (PDF extrait avec pdftotext) ; NCSC UK, consulté 2026, « Keeping devices and software up to date », https://www.ncsc.gov.uk/collection/device-security-guidance/managing-deployed-devices/keeping-devices-and-software-up-to-date
- Extrait lu : R61 « Il est recommandé d'avoir une procédure de mise à jour de sécurité régulière et réactive. » ; R80 « Tous les services réseau doivent être en écoute sur les interfaces réseau adéquates. » ; R79 « Les services exposés à des flux non maîtrisés doivent être durcis et particulièrement surveillés. » (ANSSI) ; « Install updates promptly when notified - ideally within a few days. » (NCSC)
- Portée / limites : le titre exact du guide est « Recommandations de configuration… », pas « de sécurité relatives à… ». Il s'adresse à des administrateurs ; niveaux M (minimal) à R/E (renforcé, élevé) — R58, R61, R62, R80 sont de niveau minimal. Le guide NCSC vise les terminaux d'une organisation, pas spécifiquement les serveurs. Les CIS Benchmarks n'ont pas été consultés.
- En pratique : `ss -tlnp` : services écoutant sur `0.0.0.0` alors qu'ils ne servent qu'en local ? `unattended-upgrades` (ou équivalent) actif et journalisé ? Date du dernier redémarrage après mise à jour du noyau ?

---

## 8. Référentiel OWASP en vigueur

### Citer l'OWASP Top 10 dans sa version 2025 : « Security Misconfiguration » est A02, la chaîne d'approvisionnement a sa propre catégorie A03
- Niveau de preuve : N3
- Source : OWASP, 2025, « OWASP Top 10:2025 », https://top10.owasp.org/2025 ; « A02:2025 Security Misconfiguration », https://top10.owasp.org/2025/A02_2025-Security_Misconfiguration ; « A03:2025 Software Supply Chain Failures », https://top10.owasp.org/2025/A03_2025-Software_Supply_Chain_Failures ; « A08:2025 Software or Data Integrity Failures », https://top10.owasp.org/2025/A08_2025-Software_or_Data_Integrity_Failures
- Extrait lu : A02 : « The server does not send security headers or directives, or they are not set to secure values. » ; « Error handling reveals stack traces or other overly informative error messages to users. » ; « Use identity federation, short-lived credentials, or role-based access mechanisms provided by the underlying platform » ; A03 : « your CI/CD pipeline has weaker security than the systems it builds and deploys, especially if it is complex. »
- Portée / limites : liste 2025 : A01 Broken Access Control, A02 Security Misconfiguration, A03 Software Supply Chain Failures, A04 Cryptographic Failures, A05 Injection, A06 Insecure Design, A07 Authentication Failures, A08 Software or Data Integrity Failures, A09 Security Logging and Alerting Failures, A10 Mishandling of Exceptional Conditions. Date exacte de publication non affichée sur la page lue. A08:2025 garde CDN non fiables, CI/CD sans contrôle d'intégrité, mises à jour non signées et désérialisation.
- En pratique : un rapport d'audit qui étiquette « A05 = Security Misconfiguration » en novembre 2026 cite la numérotation 2021 : préciser l'édition ou passer à 2025.

---

## Verdict sur les règles du profil

| Règle du profil | Verdict | Motif sourcé |
|---|---|---|
| « A05 Security Misconfiguration — debug en prod, CORS `*`, headers manquants (CSP, HSTS, X-Frame-Options), erreurs verbose. » | **Contredite / à préciser** (fond soutenu, étiquette périmée) | Le fond est soutenu par A02:2025 (« does not send security headers », « Error handling reveals stack traces »). Mais dans le Top 10:2025, A05 = **Injection** ; la mauvaise configuration est **A02** (top10.owasp.org/2025). Pour les en-têtes : citer `frame-ancestors` en premier (W3C CSP3 §6.4.2.2 : il prime sur X-Frame-Options), ajouter `nosniff`, `Referrer-Policy`, `Permissions-Policy`, retrait de `X-Powered-By` (Next.js l'ajoute par défaut). Ajouter la configuration plateforme : prévisualisations Vercel non protégées, SSL et restrictions réseau Supabase, Security Advisor. |
| « A07 Auth Failures — pas de MFA option, session sans expiration, cookies sans Secure/HttpOnly/SameSite, password policy faible. » | **Soutenue, à préciser** | A07:2025 reste « Authentication Failures » et cite MFA absente, sessions non invalidées et mots de passe faibles. À préciser : (1) SameSite **explicite** (`Strict` ou `Lax`), jamais le défaut navigateur, et préfixe `__Host-` (OWASP Session Cheat Sheet) ; (2) expiration **d'inactivité et absolue**, côté serveur ; (3) « password policy faible » doit se lire au sens NIST 800-63B-4 : longueur (15 en facteur unique) + liste noire, et **pas** de règles de composition ni de rotation périodique (SHALL NOT). Sans cette précision, la règle pousse à recommander des règles de composition que NIST interdit. Ajouter : MFA sur les comptes **d'administration de la plateforme** (Supabase, Vercel, GitHub). |
| « A08 Software & Data Integrity — SRI manquant sur CDN, désérialisation non sécurisée, supply chain. » | **Soutenue, à préciser** | A08:2025 couvre bien CDN non fiables, CI/CD sans intégrité, désérialisation. Mais la **supply chain** a désormais sa propre catégorie **A03:2025** (Software Supply Chain Failures), où vivent le durcissement du pipeline, la séparation des tâches et le MFA sur les dépôts. CVE-2025-55182 (désérialisation RSC, CVSS 10) illustre que la désérialisation concerne directement la pile Next.js, pas seulement Java. |
| « Jamais "désactiver l'auth temporairement pour debug". » | **Convention sans preuve trouvée (cohérente)** | Aucune source lue ne formule cette règle telle quelle. Indices concordants : A02:2025 (« Unnecessary features are enabled or installed (e.g., … testing frameworks …) », configuration identique entre environnements) ; Vercel : « Disabling Vercel Authentication renders all existing deployments unprotected », et les utilisateurs déjà authentifiés gardent l'accès à la réactivation. À conserver comme convention. |
| « Jamais accepter un check d'autorisation purement front. Toujours serveur. » | **Soutenue, à étendre** | Next.js : « client-side UI restrictions alone are not sufficient for security ». À étendre : le serveur ne suffit pas s'il s'agit du **seul middleware/proxy** — CVE-2025-29927 (CVSS 9,1) et postmortem Vercel : « We do not recommend Middleware to be the sole method of protecting routes » ; doc Next.js : contrôles au plus près des données (Data Access Layer), pas dans un layout. |
| (absence) GitHub Actions | **À ajouter** | Sources N3 solides : GitHub « Secure use reference » (lockfile ou SHA complet, `GITHUB_TOKEN` en lecture par défaut, variables intermédiaires contre l'injection, pas de checkout de code non fiable sous `pull_request_target`, OIDC) ; incident tj-actions CVE-2025-30066 (GHSA + CISA) ; OWASP A03:2025. |
| (absence) Déploiements de prévisualisation | **À ajouter** | Vercel Deployment Protection (« Standard Protection is the recommended option for most projects ») ; variables « Secret » et « Separate Production Secret Values » pour ne pas servir les secrets de production aux prévisualisations. |
| (absence) Auto-hébergement | **À ajouter** | NCSC UK 2017 et CISA BOD 23-02 (pas d'interface d'administration exposée) ; OFCS 2024 (NAS : pas de redirection de port, VPN + second facteur) ; ANSSI DAT-NT-007 (SSH par clé, pas de root) et ANSSI-BP-028 v2.0 (mises à jour, écoute sur les bonnes interfaces) ; certificats : CA/B SC-081v3 et Let's Encrypt (renouvellement automatisé, ARI). |

---

## Mythes et affirmations contestées

- **« X-Frame-Options a été remplacé par `frame-ancestors`. »** — Partiellement vrai. CSP3 dit que `frame-ancestors` **prime** sur X-Frame-Options quand il est appliqué ; MDN ne déclare obsolète que `ALLOW-FROM`. OWASP garde `X-Frame-Options: DENY` en repli. Et `frame-ancestors` dans une `<meta>` est sans effet (CSP3 §3.3) : plus de 2 % des pages mobiles qui posent une CSP par `<meta>` le font quand même (Web Almanac 2025).
- **« `X-XSS-Protection: 1; mode=block` protège contre le XSS. »** — Faux aujourd'hui : en-tête non standard et déprécié, qui « can create XSS vulnerabilities » (MDN) ; OWASP : ne pas le poser ou le mettre à `0`.
- **« Il faut toujours ajouter `preload` à HSTS. »** — Contesté : le Cheat Sheet OWASP l'inclut, la liste OWASP Secure Headers (2026-10-18) ne l'inclut pas, et hstspreload.org avertit que l'inscription « cannot easily be undone » et s'étend aux sous-domaines internes.
- **« Sur Vercel, je suis protégé des failles Next.js. »** — Vrai pour CVE-2025-29927 (« Next.js deployments hosted on Vercel are automatically protected »), **faux** pour CVE-2025-55182 : « You should not depend on these to secure your app, and still update immediately » (React).
- **« Épingler une action par SHA est la protection ultime. »** — Dépassé selon GitHub : le lockfile de dépendances de workflow « supersedes SHA pinning » (vérifie aussi les dépendances transitives et l'identité du dépôt source). Le SHA reste la mesure de repli. Rappel : un SHA épinglé fige aussi les failles ; il faut Dependabot.
- **« Les secrets GitHub sont masqués dans les logs, donc sans risque. »** — Faux : « automatic redaction is not guaranteed » (GitHub) ; tj-actions a imprimé les secrets en base64 doublement encodé (CISA).
- **« Les restrictions réseau Supabase protègent ma base. »** — Seulement l'accès Postgres direct et les poolers : « They don't apply to HTTPS APIs such as PostgREST, Storage, and Auth ».
- **« Un mot de passe fort exige majuscule, chiffre et caractère spécial. »** — Contredit par NIST SP 800-63B-4 (« SHALL NOT impose other composition rules ») ; pourtant l'exemple officiel du guide d'authentification Next.js le fait. Ne pas recopier cet exemple tel quel.
- **« Le navigateur met `SameSite=Lax` par défaut, inutile de le préciser. »** — Contesté : MDN dit « Some browsers » ; OWASP : « do not rely on the browser-default value, which varies across browsers and versions. »
- **« Il faut activer l'OCSP stapling. »** — Obsolète pour Let's Encrypt, qui a arrêté OCSP le 6 août 2025 ; le JSON Mozilla v6.0 porte pourtant encore `ocsp_staple: true` (incohérence entre sources).
- **« COEP est largement adopté. »** — Trompeur : 86,52 % des en-têtes COEP mobiles valent `unsafe-none` (neutre) et 5,6 % sont invalides (Web Almanac 2025).

---

## Non vérifié

- **Paliers 200 / 100 / 47 jours avec dates (15/03/2026, 15/03/2027, 15/03/2029)** des Baseline Requirements : vus seulement dans un résumé de moteur de recherche ; la page du ballot SC-081v3 lue ne donne que 398 → 47 jours, mars 2026 → mars 2029.
- **Let's Encrypt et OCSP Must-Staple refusé depuis le 7 mai 2025**, URL CRL ajoutées le 12 mars 2025 : résumé de recherche (forum communautaire), page source non lue.
- **Page GitHub « Workflow dependency lockfiles »** : non lue (nom du fichier, disponibilité, plans).
- **Permission `id-token: write` pour OIDC** : absente de la page OIDC lue.
- **Billet Next.js « security-update-2025-12-11 »** (liste de référence des versions corrigées pour CVE-2025-55182 et suivantes) : non lu.
- **Valeur par défaut de Deployment Protection pour un nouveau projet Vercel** sans défaut d'équipe : non établie par les pages lues.
- **Page wiki Mozilla « Server Side TLS »** : ne s'est pas chargée ; profils lus dans le JSON v6.0 et sur TLSRef.
- **Chapitre « Cookies » du Web Almanac 2025** (adoption de `HttpOnly`, `Secure`, `SameSite`, préfixes) : non lu.
- **CIS Benchmarks** : non consultés (accès sous inscription).
- **Pages NCSC suisse sur les NAS de 2021** (QNAP, rapport semestriel) : vues seulement en résumé de recherche ; seule la page OFCS du 6 février 2024 a été lue.
- **Durées de session et protection contre les mots de passe compromis dans Supabase Auth** : non vérifiées.
- **Date exacte du renommage `middleware` → `proxy`** dans Next.js : non vérifiée (la doc actuelle emploie `proxy`).
- **Date de publication officielle de l'OWASP Top 10:2025** : non affichée sur la page lue.

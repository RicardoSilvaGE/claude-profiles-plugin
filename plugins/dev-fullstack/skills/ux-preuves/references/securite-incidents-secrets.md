# Fiche `ux-preuves` — Sécurité — réponse aux incidents et cycle de vie des secrets

> Fiche du skill `ux-preuves` (dev-fullstack), volet **sécurité**, préchargé par `securite`. Couvre : NIST SP 800-61 Rev. 3, playbooks CISA, vitesse de découverte d'un secret fuité, quarantaine AWS, purge de l'historique Git, rotation et gestion des secrets (OWASP, NIST SP 800-57, OIDC), rétention des journaux Vercel, Supabase et GitHub, post-mortem, compromissions de comptes et d'outillage.
> **Instantané de la recherche documentaire du 09 au 10.11.2026** (menée autour de minuit UTC) : chaque
> entrée cite une page réellement ouverte pendant cette recherche, avec un extrait lu. Classements, versions, avis de sécurité et textes réglementaires
> **vieillissent** ; le droit change par révision : avant d'en faire dépendre une décision,
> relire la page officielle (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Périmètre : référentiel d'un agent « security engineer senior » pour un développeur indépendant en Suisse (Next.js sur Vercel, Supabase, Node, GitHub). Hors périmètre (couvert ailleurs) : nLPD art. 24 / RGPD art. 33, clés Supabase `sb_secret_`, contenu des journaux structurés, Shai-Hulud.

Méthode : chaque entrée provient d'une page ou d'un PDF réellement ouvert le 9.11.2026 (curl + extraction texte, ou WebFetch). Les PDF NIST, NDSS, CISA et Google ;login: ont été téléchargés et extraits avec `pdftotext`. Quand la citation a été restituée par l'outil de résumé WebFetch et non lue dans le texte brut, c'est signalé. Les extraits sont verbatim dans leur langue d'origine.

---

## 1. Cadre de réponse à incident

### Choisir un cycle de réponse adapté à sa taille : la Rev. 3 du NIST n'impose plus les quatre phases, elle les range sous les fonctions du CSF 2.0 et demande de partager les leçons sans attendre la fin
- Niveau de preuve : N1
- Source : Nelson, Rekhi, Souppaya, Scarfone (NIST), avril 2025, « SP 800-61r3 — Incident Response Recommendations and Considerations for Cybersecurity Risk Management: A CSF 2.0 Community Profile », https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-61r3.pdf (page de notice : https://csrc.nist.gov/pubs/sp/800/61/r3/final)
- Extrait lu : « This publication supersedes SP 800-61r2 (Revision 2), Computer Security Incident Handling Guide » ; « Organizations should use the incident response life cycle framework or model that suits them best. » ; « The lessons learned during incident response should often be shared as soon as they are identified, not delayed until after recovery concludes. »
- Portée / limites : publiée en avril 2025 (date de notice : 04/03/25). Réécriture complète (annexe C : « Performed a full rewrite », « Reorganized the contents to comprise a CSF 2.0 Community Profile »). La table 1 fait correspondre les anciennes phases (Preparation ; Detection & Analysis ; Containment, Eradication & Recovery ; Post-Incident Activity) aux fonctions Govern/Identify/Protect, Detect, Respond/Recover et à la catégorie Improvement (ID.IM). La Rev. 3 dit elle-même ne plus détailler le « comment » (« it is no longer feasible to capture and maintain that information in a single static publication »). Le texte note que les grandes organisations dépendantes de la technique profitent davantage d'un modèle d'amélioration continue « than other organizations would ».
- En pratique : pour un indépendant, garder le cycle simple (détecter → contenir → éradiquer/restaurer → apprendre). Écrire la leçon dès qu'elle apparaît (note datée dans le dossier d'incident), sans attendre le post-mortem.

### Contenir, c'est empêcher l'extension : la plupart des incidents en demandent une forme, et l'on peut autoriser un fournisseur à contenir automatiquement
- Niveau de preuve : N1
- Source : NIST, avril 2025, SP 800-61r3, tableau RS.MI-01 / RS.MI-02, https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-61r3.pdf
- Extrait lu : « Containment refers to preventing the expansion of an incident. [...] Most incidents require some form of containment. » ; « C2: Consider authorizing third parties (e.g., the organization's internet service providers and cloud service providers) to automatically act to contain certain types of incidents ». Pour l'éradication : « disabling breached user accounts ».
- Portée / limites : principe général, sans délai chiffré et sans geste propre aux secrets applicatifs.
- En pratique : laisser actifs les mécanismes de confinement automatique des fournisseurs (quarantaine AWS, partenaires du secret scanning GitHub, protection au push). Ne pas les retirer pendant l'incident.

### Consigner chaque action et conserver les données de l'incident comme preuves, même sans poursuite pénale envisagée ; ne pas retarder volontairement le confinement pour observer l'attaquant
- Niveau de preuve : N1
- Source : NIST, avril 2025, SP 800-61r3, RS.AN-03, RS.AN-06, RS.AN-07 et la note qui précède RS.MI-01, https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-61r3.pdf
- Extrait lu : « collected incident data is still considered evidence » ; « R1: Determine the sequence of events that have occurred during the incident » ; sur la redirection vers un bac à sable : « This delays containment and eradication activities. [...] The intentional delay can be dangerous because an attacker could escalate unauthorized access or compromise other systems. »
- Portée / limites : la chaîne de possession formelle « might not be performed for every incident ».
- En pratique : tenir un journal horodaté (qui, quoi, quand) dès la première minute et exporter les journaux avant qu'ils expirent. Ne jamais laisser une clé fuitée active « pour voir ».

### Pour une intrusion avérée, faire tourner les secrets fait partie du confinement, mais ce confinement doit couvrir toute l'activité de l'adversaire et ne pas lui donner l'alerte ; avant d'éradiquer, recenser ses accès persistants et collecter les preuves
- Niveau de preuve : N3
- Source : CISA, novembre 2021 (fichier republié en 2024-08), « Federal Government Cybersecurity Incident and Vulnerability Response Playbooks », https://www.cisa.gov/sites/default/files/2024-08/Federal_Government_Cybersecurity_Incident_and_Vulnerability_Response_Playbooks_508C.pdf
- Extrait lu : « Changing system admin passwords, rotating private keys, and service/application account secrets where compromise is suspected and revocation of privileged access. » ; « Some adversaries may actively monitor defensive response measures [...] to avoid "tipping off" the adversary. » ; « Before moving to eradication, ensure that all means of persistent access into the network have been accounted for, [...] and that all evidence has been collected. »
- Portée / limites : écrit pour les agences fédérales civiles américaines (FCEB) et pour des incidents « major », encore sur le cycle de la Rev. 2 (« as defined in [...] SP 800-61 Rev. 2 »). Le guide exclut explicitement les incidents mineurs non intentionnels. Mention de date lue dans le PDF : « Publication: November 2021 ».
- En pratique : une clé fuitée seule se fait tourner tout de suite. En cas de soupçon d'intrusion (compte admin compromis, comportement anormal en prod), recenser d'abord tous les accès de l'attaquant (jetons, comptes, clés SSH, webhooks, membres d'équipe ajoutés), puis les couper tous ensemble.

---

## 2. Vitesse d'exploitation d'un secret fuité

### Un secret poussé sur GitHub public est trouvable en quelques secondes : en 2017-2018, l'API de recherche le rendait visible en 20 s (médiane), et 81 % des secrets détectés n'étaient jamais retirés
- Niveau de preuve : N2 (≈ 4,4 millions de fichiers candidats, 681 784 dépôts captés en temps réel, plus un instantané BigQuery couvrant 13 % des dépôts open source ; « over 200,000 leaked credentials »)
- Source : Meli, McNiece, Reaves, 2019, « How Bad Can It Git? Characterizing Secret Leakage in Public GitHub Repositories », NDSS 2019, https://www.ndss-symposium.org/wp-content/uploads/2019/02/ndss2019_04B-3_Meli_paper.pdf
- Extrait lu : « We found that the median time to discovery was 20 seconds, with times ranging from half a second to over 4 minutes » ; « 19% of the secrets were removed at some point in roughly 2 weeks [...] This also means 81% of the secrets we discover were not removed. » ; « the largest drop in secret presence occurred in the first hour after discovery, where about 6% of all detected secrets were removed »
- Portée / limites : collecte du 31.10.2017 au 20.04.2018. Le délai de 20 s mesure l'**indexation par l'API de recherche** (le temps qu'il faut à un chercheur outillé pour voir la chaîne), pas l'exploitation. Ce n'est **pas** une étude par jetons-pièges et les auteurs n'ont pas testé les clés trouvées. Depuis, GitHub a ajouté le secret scanning et la protection au push, ce qui modifie le contexte.
- En pratique : un secret sur un dépôt public se traite comme lu par un tiers dans la minute. Le compte à rebours part de la poussée, pas de sa découverte par l'équipe.

### L'exploitation se compte en minutes : dans l'expérience de Unit 42 (2023), des clés AWS exposées ont été utilisées moins de cinq minutes après leur publication
- Niveau de preuve : N4 (recherche d'un éditeur de sécurité, expérience avec des clés-appâts sur leur propre compte ; échantillon non chiffré)
- Source : Gamazo, Quist (Palo Alto Networks Unit 42), 30.10.2023, « EleKtra-Leak: Tracking Malicious Operations of Exposed IAM Keys », https://unit42.paloaltonetworks.com/malicious-operations-of-exposed-iam-keys-cryptojacking/
- Extrait lu : « We found that the actor was able to detect and use the exposed IAM credentials within five minutes of their initial exposure on GitHub. » ; « AWS applied the quarantine policy within two minutes of the AWS credentials being leaked on GitHub. » ; « the actor started their operations within four minutes after AWS applied the quarantine policy »
- Portée / limites : un seul acteur (cryptominage) et un seul type de clé (AWS IAM). Les chercheurs ont retiré la quarantaine à la main pour observer la suite. On ne peut pas en déduire un délai pour des clés Supabase, Vercel ou Stripe. Recommandation de l'article : révoquer, retirer, régénérer, et « use short-lived credentials ».
- En pratique : viser une révocation en minutes. « Un secret leaké se traite en minutes » est cohérent avec cette mesure, mais elle vient d'un éditeur, pas d'une étude revue par des pairs.

### La quarantaine automatique d'AWS freine les abus sans remplacer la rotation : ne pas retirer la politique, suivre le dossier de support qu'AWS ouvre
- Niveau de preuve : N3
- Source : AWS, création 21.08.2024, modification 16.03.2026, « AWSCompromisedKeyQuarantineV3 — AWS Managed Policy », https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AWSCompromisedKeyQuarantineV3.html
- Extrait lu : « Denies access to certain actions, applied by AWS in the event that an IAM user's credentials have been compromised or exposed publicly. The policy aims to limit the potential damage that may be caused by fraud-related activity leading to unauthorized charges, while not impacting the existing resources. Do NOT remove this policy. »
- Portée / limites : la politique refuse **certaines** actions seulement (« certain actions »). Unit 42 a observé de la reconnaissance (DescribeRegions) quatre minutes après son application. Version par défaut lue : v3.
- En pratique : si la politique apparaît sur un utilisateur IAM, l'incident est ouvert. Faire tourner la clé, examiner CloudTrail et laisser la politique en place.

### GitHub transmet aux fournisseurs partenaires les secrets trouvés dans les dépôts publics et les paquets npm publics, et leur recommande de les tenir pour publics et compromis
- Niveau de preuve : N3
- Source : GitHub Docs, consulté le 9.11.2026, « Secret scanning partner program », https://docs.github.com/en/code-security/secret-scanning/secret-scanning-partnership-program/secret-scanning-partner-program
- Extrait lu : « Secret scanning happens by default on public repositories and public npm packages. » ; « we recommend considering any secrets that GitHub sends you messages about as public and compromised »
- Portée / limites : c'est le **fournisseur** qui décide de révoquer ou non (« How you implement this in your secret alert service is up to you »). Rien ne garantit une révocation automatique, et rien ne se passe pour un dépôt privé sans GitHub Secret Protection.
- En pratique : ne pas compter sur une révocation par le fournisseur. Un e-mail « your key was found on GitHub » signifie que la clé est déjà publique.

### Les jetons Supabase (secret key, PAT), Vercel et npm figurent parmi les motifs détectés sur les dépôts publics ; la protection au push est active par défaut pour les utilisateurs sur les dépôts publics
- Niveau de preuve : N3
- Source : GitHub Docs, consulté le 9.11.2026, « Supported secret scanning patterns », https://docs.github.com/en/code-security/secret-scanning/introduction/supported-secret-scanning-patterns ; « Managing push protection for users », https://docs.github.com/en/code-security/secret-scanning/working-with-secret-scanning-and-push-protection/push-protection-for-users ; « About secret scanning », https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning
- Extrait lu : données du tableau : `"provider":"Supabase","supportedSecret":"Supabase Secret Key","secretType":"supabase_secret_key","isPublic":true,[...]"hasPushProtection":true` ; « Push protection for users is on by default for public repositories » ; « Secret scanning scans your entire Git history on all branches of your repository » ; « Organization-owned private and internal repositories : Available with GitHub Secret Protection enabled »
- Portée / limites : pour Supabase, le tableau ne liste que l'OAuth access token, le PAT, le PAT à portée restreinte et la Secret Key. Les anciens `anon` et `service_role` (des JWT) n'y ont pas de motif propre. Pour un dépôt privé personnel, le secret scanning n'est pas inclus d'office.
- En pratique : sur un dépôt privé, ajouter un scanner local (pré-commit et CI, par exemple gitleaks, que GitHub cite) pour couvrir ce que le secret scanning ne voit pas. Après une rotation, relancer un scan de tout l'historique.

### Un secret fuité reste souvent valide des années, et les dépôts privés en contiennent davantage que les publics
- Niveau de preuve : N4 (rapport d'éditeur ; citations restituées par WebFetch)
- Source : GitGuardian, 2025, « The State of Secrets Sprawl 2025 », https://www.gitguardian.com/state-of-secrets-sprawl-report-2025
- Extrait lu : « 70% of secrets leaked in 2022 are still valid today. » ; « Private repos are 9 times more likely to contain secrets. » ; « In 2024, we found 23,770,171 new hardcoded secrets added to public GitHub repositories. »
- Portée / limites : méthodologie propriétaire, non revue par des pairs. Un éditeur qui vend la détection a intérêt à ces chiffres.
- En pratique : « repo privé » n'est pas un argument pour ne pas faire tourner un secret. Les secrets anciens sont à inventorier et à révoquer.

---

## 3. Purge de l'historique Git

### Révoquer ou faire tourner d'abord : réécrire l'historique est secondaire, coûteux, et souvent inutile une fois la clé révoquée
- Niveau de preuve : N3
- Source : GitHub Docs, consulté le 9.11.2026, « Removing sensitive data from a repository », https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository
- Extrait lu : « if the sensitive data you need to remove is a secret (e.g. password/token/credential), as is often the case, then as a first step you need to revoke and/or rotate that secret. Once the secret is revoked or rotated, it can no longer be used for access, and that may be sufficient to solve your problem. Going through the extra steps to rewrite the history and remove the secret may not be warranted. »
- Portée / limites : l'outil recommandé est `git-filter-repo` (« You need a version with the --sensitive-data-removal flag »). La page ouverte **ne mentionne pas BFG**. Elle ne dit pas non plus « considérer le secret comme compromis » : cette formule figure dans le tutoriel de remédiation (entrée plus bas). Effets secondaires listés : « High risk of recontamination », « Changed commit hashes », « Leading others directly to the sensitive data ».
- En pratique : ordre fixe (1) révoquer et faire tourner, (2) vérifier l'usage abusif, (3) seulement ensuite décider de la purge. Si on purge : `git filter-repo --sensitive-data-removal`, puis recloner partout.

### Après un force-push, le commit reste lisible dans les clones, les forks, par son SHA dans les vues en cache et dans les pull requests ; le support GitHub ne purge que si la rotation ne suffit pas
- Niveau de preuve : N3
- Source : GitHub Docs, consulté le 9.11.2026, « Removing sensitive data from a repository », https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository
- Extrait lu : « If you only rewrite your history and force push it, the commits with sensitive data may still be accessible elsewhere: In any clones or forks of your repository Directly via their SHA-1 hashes in cached views on GitHub Through any pull requests that reference them » ; « GitHub Support won't remove non-sensitive data, and will only assist in the removal of sensitive data in cases where we determine that the risk can't be mitigated by rotating affected credentials. » ; « If the commit that introduced the sensitive data exists in any forks, it will continue to be accessible there. [...] GitHub cannot provide contact information for these owners. »
- Portée / limites : rien ne peut effacer les clones déjà faits par d'autres (« You cannot remove sensitive data from other users' clones of your repository »).
- En pratique : « on a force-push, c'est bon » est faux d'après la doc de GitHub elle-même. Le ticket au support ne se justifie que pour une donnée qui ne se fait pas tourner (donnée personnelle, par exemple), pas pour une clé.

### Dans un réseau de forks, les données Git d'un dépôt restent accessibles depuis les autres, même après suppression d'un fork : c'est le fonctionnement voulu par GitHub
- Niveau de preuve : N3 (GitHub) + N4 (Truffle Security)
- Source : GitHub Docs, consulté le 9.11.2026, « What happens to forks when a repository is deleted or changes visibility », https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/what-happens-to-forks-when-a-repository-is-deleted-or-changes-visibility ; Leon (Truffle Security), 24.07.2024, « Anyone can Access Deleted and Private Repository Data on GitHub », https://trufflesecurity.com/blog/anyone-can-access-deleted-and-private-repo-data-github
- Extrait lu : GitHub : « Git data from any repository in a network may be accessed from any repository in the same network, including the upstream repository, even after a fork is deleted. » ; Truffle : « we're introducing a new term: Cross Fork Object Reference (CFOR) » ; « the only way to securely remediate a leaked key on a public GitHub repository is through key rotation » ; Truffle rapporte la réponse de GitHub à son signalement : « it's clear as day that GitHub designed repositories to work like this », avec un renvoi à la page de doc citée.
- Portée / limites : « available forever » est l'affirmation de Truffle (N4). GitHub, lui, dit « may be accessed ». Le cas concerne surtout les dépôts publics et leurs forks, ou un dépôt privé devenu public.
- En pratique : pour un dépôt qui a des forks ou qui a été public, ne jamais promettre qu'un secret a disparu. La rotation reste le seul remède.

### Supprimer la ligne, pousser un nouveau commit ou supprimer et recréer le dépôt n'empêche pas l'exploitation : tout secret fuité est compromis dès la fuite
- Niveau de preuve : N3
- Source : GitHub Docs, consulté le 9.11.2026, « Remediating a leaked secret in your repository », https://docs.github.com/en/code-security/tutorials/remediate-leaked-secrets/remediating-a-leaked-secret
- Extrait lu : « You should consider any leaked secret to be immediately compromised and it is essential that you undertake proper remediation steps, such as revoking the secret. Simply removing the secret from the codebase, pushing a new commit, or deleting and recreating the repository do not prevent the secret from being exploited. » ; « It is not sufficient to simply remove the secret from your codebase. The most important remediation step is revoking the secret with the secret's provider. »
- Portée / limites : tutoriel générique, sans distinction public/privé. Il s'applique à « if you've accidentally committed a secret to your repository ». Étapes : identifier, évaluer, coordonner, révoquer, mettre à jour les services, « Check for unauthorized access », nettoyer le dépôt, prévenir.
- En pratique : la règle « si un secret a touché un commit, il est compromis » s'appuie directement sur ce texte.

### Réécrire l'historique ne protège pas : les commits supprimés restaient récupérables par leur SHA, et ces SHA se retrouvaient via l'Events API et des archives tierces
- Niveau de preuve : N2 (expérience sur les dépôts des auteurs, dans l'étude décrite plus haut)
- Source : Meli, McNiece, Reaves, 2019, NDSS, § « Rewriting History Does Not Protect Secrets », https://www.ndss-symposium.org/wp-content/uploads/2019/02/ndss2019_04B-3_Meli_paper.pdf
- Extrait lu : « we discovered that even if commit histories are rewritten, secrets can still be recovered. [...] we could recover the full contents of deleted commits from GitHub with only the commit's SHA-1 ID » ; « these hidden commit hashes could be recovered with trivial effort via the Events API » ; « the consequences of even rapidly detected secret disclosure is severe and difficult to mitigate short of deleting a repository or reissuing credentials. »
- Portée / limites : testé en 2018 avec `git filter-branch` et BFG, alors recommandés par GitHub. Le comportement actuel est confirmé dans son principe par la doc GitHub (SHA dans les vues en cache).
- En pratique : même une fuite détectée en quelques minutes impose la rotation.

---

## 4. Rotation et gestion des secrets

### Le confinement d'une fuite = révocation immédiate, puis rotation rapide et de préférence automatisée, puis suppression du secret partout où il a fuité, logs compris
- Niveau de preuve : N3 (guide de référence OWASP)
- Source : OWASP Cheat Sheet Series, consulté le 9.11.2026, « Secrets Management Cheat Sheet », § 9 Incident Response, https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html
- Extrait lu : « Quick response in the event of a secret exposure is perhaps one of the most critical considerations for secrets management. » ; « The primary goal of incident response is rapid response and containment. » ; « Revocation: Keys that were exposed should undergo immediate revocation. The secret must be able to be de-authorized quickly » ; « Rotation: A new secret must be able to be quickly created and implemented, preferably via an automated process » ; « Secrets in logs must have a process for removing the secret while maintaining log integrity. »
- Portée / limites : la documentation d'incident doit contenir « Steps to take for containment » et « Whom to alert when a secret is detected ». La réécriture d'historique est présentée comme possible mais risquée (« this may introduce other problems as it rewrites git history »).
- En pratique : un secret qu'on ne sait pas révoquer vite est une non-conformité au sens de ce guide. Tenir une fiche « comment faire tourner » par secret.

### Moindre privilège, rayon d'impact réduit, expiration et secrets dynamiques ; redémarrer l'application ne révoque rien
- Niveau de preuve : N3
- Source : OWASP, consulté le 9.11.2026, « Secrets Management Cheat Sheet », § 2.3, 2.4, 2.7, 2.11, 3.2.1, https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html
- Extrait lu : « the Least Privilege principle should be applied » ; « Limit blast radius : Avoid storing high-value, long-term, or widely scoped credentials in CI/CD variables; never share credentials across administrative users. » ; « Restarting the application does not itself revoke stolen credentials; they remain usable until the backing service expires or revokes them. » ; « You should regularly rotate secrets so that any stolen credentials will only work for a short time. » ; « User credentials are excluded from regular rotation. »
- Portée / limites : OWASP ne dit pas « une clé par service » mot pour mot. Il demande le moindre privilège, des métadonnées par secret (créateur, usage, « When you need to rotate it ») et l'absence de partage. Les mots de passe des utilisateurs humains sont exclus de la rotation périodique.
- En pratique : une clé par consommateur, avec sa portée minimale et son propriétaire noté. Chercher comme défaut les clés partagées entre environnements ou services.

### La durée de vie d'une clé (cryptopériode) se fixe pour limiter l'exposition en cas de compromission ; le NIST donne des ordres de grandeur, par exemple moins de 2 ans pour une clé symétrique d'authentification
- Niveau de preuve : N1
- Source : Barker (NIST), mai 2020, « SP 800-57 Part 1 Rev. 5 — Recommendation for Key Management: Part 1 – General », § 5.3 et table 1, https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-57pt1r5.pdf
- Extrait lu : « A suitably defined cryptoperiod: [...] 2. Limits the amount of exposure if a single key is compromised » ; « Note that the cryptoperiods suggested are only rough order-of-magnitude guidelines » ; table 1 : « 3. Symmetric Authentication Key < 2 years < OUP + 3 years »
- Portée / limites : vise les clés cryptographiques (signature, chiffrement, authentification), pas directement les jetons d'API SaaS. **Aucune durée de 90 jours** dans les passages lus.
- En pratique : fixer une échéance de rotation par secret (au plus 1 à 2 ans, plus court pour les secrets à fort impact). Le vrai critère reste de savoir faire tourner un secret en minutes en cas d'incident.

### Remplacer les clés cloud longues stockées dans GitHub Actions par la fédération OIDC : jeton éphémère, valide pour un seul job
- Niveau de preuve : N3
- Source : GitHub Docs, consulté le 9.11.2026, « OpenID Connect », https://docs.github.com/en/actions/concepts/security/openid-connect
- Extrait lu : « No cloud secrets: You won't need to duplicate your cloud credentials as long-lived GitHub secrets. » ; « With OIDC, your cloud provider issues a short-lived access token that is only valid for a single job, and then automatically expires. »
- Portée / limites : il faut un fournisseur qui accepte OIDC. Une condition de confiance mal restreinte (dépôt, branche, environnement) ouvre un autre risque.
- En pratique : chercher dans `.github/workflows` des secrets cloud longs remplaçables par OIDC (AWS, GCP, Azure, npm via trusted publishing).

### Chez Vercel, classer les secrets en type « Secret » (lecture impossible après enregistrement) ; le masquage dans les logs de build ne joue qu'à partir de 32 caractères
- Niveau de preuve : N3
- Source : Vercel Docs, mis à jour le 28.08.2026, « Config and Secret environment variables » (ex-« Sensitive environment variables »), https://vercel.com/docs/environment-variables/sensitive-environment-variables
- Extrait lu : « Secret values are write-only after saving. Use them for passwords, API keys, and tokens. Existing Sensitive environment variables continue to work as Secrets. » ; « if a Secret environment variable value is 32 characters or longer and appears in build logs, Vercel replaces the value with [REDACTED] » ; la politique d'équipe « Separate Production Secret Values » impose que « each Secret must use a different value in Production than in Preview, Development, and custom environments »
- Portée / limites : la doc a changé en 2026. Le type « Sensitive » est devenu « Secret » et la politique « Enforce Sensitive Environment Variables » est « deprecated ». Un secret court qui passe dans un log de build n'est pas masqué.
- En pratique : vérifier que toute clé est en type Secret et que la production a ses propres valeurs. Aucun secret dans une variable `NEXT_PUBLIC_*`.

### Rotation chez Vercel : créer la nouvelle valeur, redéployer, puis invalider l'ancienne ; les anciens déploiements gardent l'ancienne valeur
- Niveau de preuve : N3
- Source : Vercel Docs, mis à jour le 15.07.2026, « Rotating environment variables », https://vercel.com/docs/environment-variables/rotating-secrets
- Extrait lu : « The key to safe rotation is updating Vercel before you invalidate the old credential. » ; « Environment variable changes only apply to new deployments. If you visit an old deployment URL, it will still use the old credential. »
- Portée / limites : procédure de rotation **planifiée**, pensée pour éviter la panne. En cas de fuite exploitée, la doc ne traite pas l'arbitrage disponibilité contre sécurité.
- En pratique : en incident, faire les trois gestes d'affilée, en minutes. Si un abus est en cours, invalider l'ancienne valeur tout de suite et accepter la panne. Redéployer production **et** previews : un ancien déploiement encore joignable garde la clé compromise.

### Supabase : la révocation d'urgence est prévue, mais l'ancien secret JWT partagé impose de couper `anon`/`service_role` et déconnecte les utilisateurs, et un cache peut faire accepter jusqu'à ~20 min des JWT signés par une clé révoquée
- Niveau de preuve : N3
- Source : Supabase Docs, consulté le 9.11.2026, « JWT Signing Keys », https://supabase.com/docs/guides/auth/signing-keys
- Extrait lu : « In some situations, such as an active security incident you may want to revoke the legacy JWT secret immediately. » ; « before you revoke the legacy JWT secret, you must disable the anon and service_role » ; « This discovery endpoint is cached by Supabase's edge servers for 10 minutes. Furthermore the Supabase client libraries may cache the keys in memory for an additional 10 minutes. » ; « Supabase products (Auth, Data API, Storage, Realtime) do not rely » [on this cache] ; « It is always prudent to rotate signing keys at least once a year. »
- Portée / limites : le cache concerne les composants applicatifs qui vérifient eux-mêmes les JWT (API, Edge Functions). Avec l'ancien système, la doc note « Currently active users get immediately signed out » et des temps d'arrêt possibles.
- En pratique : ouvrir un finding pour tout projet encore sur l'ancien secret JWT, puisqu'on ne peut pas le faire tourner sans casse. En incident, après révocation, compter environ 20 minutes de vulnérabilité résiduelle pour les backends maison.

### `AUTH_SECRET` / `BETTER_AUTH_SECRET` : les docs demandent une chaîne aléatoire cryptographiquement sûre d'au moins 32 caractères et donnent des commandes qui produisent 32 ou 33 octets aléatoires
- Niveau de preuve : N3
- Source : Auth.js, consulté le 9.11.2026, « Deployment », https://authjs.dev/getting-started/deployment ; Better Auth, consulté le 9.11.2026, « Installation », https://www.better-auth.com/docs/installation ; Vercel KB, consulté le 9.11.2026, « Complete guide to authentication on Vercel », https://vercel.com/kb/guide/complete-guide-authentication-vercel.md
- Extrait lu : Auth.js : « It should be a cryptographically secure random string of at least 32 characters » ; « generated via the CLI with npm exec auth secret or via openssl with openssl rand -base64 33 ». Better Auth : « It must be at least 32 characters and generated with high entropy. [...] You can also use openssl rand -base64 32 » ; « You can use BETTER_AUTH_SECRETS (plural) to roll over to a new secret without invalidating existing data. ». Vercel KB : « `NEXTAUTH_SECRET` - A random string used to encrypt tokens and cookies. Generate with `openssl rand -base64 32` »
- Portée / limites : le texte dit « 32 caractères », les commandes données produisent 32 ou 33 octets (44 caractères en base64). La formulation « 32 octets d'un générateur cryptographique » colle aux commandes et va plus loin que le minimum textuel. Better Auth offre une rotation sans casse avec `BETTER_AUTH_SECRETS`. La page Auth.js lue ne mentionne pas la rotation.
- En pratique : générer avec `openssl rand -base64 32` (ou plus), jamais à la main, une valeur distincte par environnement. Le faire tourner en incident ; pour Better Auth, passer par `BETTER_AUTH_SECRETS`.

---

## 5. Investigation : quelles traces, combien de temps

### Les logs d'exécution Vercel expirent vite : 1 heure en Hobby, 1 jour en Pro, 3 jours en Enterprise, 30 jours avec Observability Plus
- Niveau de preuve : N3
- Source : Vercel Docs, mis à jour le 28.08.2026, « Runtime logs », https://vercel.com/docs/logs/runtime
- Extrait lu : « Plan Retention time Hobby 1 hour of logs Pro 1 day of logs Pro with Observability Plus 30 days of logs Enterprise 3 days of logs Enterprise with Observability Plus 30 days of logs »
- Portée / limites : limites de taille aussi (« each request can log up to 1MB », « 256 individual log lines per request »). Le journal d'activité d'équipe (« Activity Log is available on all plans ») trace les actions d'administration, pas les requêtes. Les « Audit Logs » sont réservés aux équipes Enterprise (https://vercel.com/docs/observability/activity-log, mis à jour le 29.06.2026).
- En pratique : en plan Hobby ou Pro, exporter les logs dans l'heure ou la journée de l'incident, en parallèle de la rotation. Sinon, prévoir un drain de logs **avant** l'incident.

### Les logs Supabase (API et base) se conservent 1 jour en Free, 7 en Pro, 28 en Team, 90 en Enterprise ; un résultat vide ne prouve pas l'absence d'activité
- Niveau de preuve : N3
- Source : Supabase, consulté le 9.11.2026, « Pricing », https://supabase.com/pricing ; Supabase Docs, « Logs », https://supabase.com/docs/guides/telemetry/logs
- Extrait lu : tableau de prix : « Log retention (API & Database) 1 day 7 days 28 days 90 days » ; doc des logs : « An empty result does not establish that the user had no activity. Events must be recorded before they can appear in Logs. »
- Portée / limites : types de logs disponibles : « API Gateway, Postgres, Auth, Storage, PostgREST, Edge Function, Realtime, or pooler ». Export manuel limité à 100, 500 ou 1 000 lignes. Pour l'export continu, « use Log drains » (option payante).
- En pratique : au premier signal, exporter les logs API Gateway et Auth sur la fenêtre d'exposition. Sur le plan Free, 24 h perdues = preuves perdues.

### L'absence de trace ne prouve pas l'absence d'abus : un secret partagé volé peut servir longtemps après, sans signe actuel
- Niveau de preuve : N3
- Source : Supabase Docs, consulté le 9.11.2026, « JWT Signing Keys », https://supabase.com/docs/guides/auth/signing-keys
- Extrait lu : « It is difficult to detect or identify when or how a shared secret has been given to a malicious actor. » ; « A malicious actor can use a shared secret far into the future , so lacking current evidence of compromise does not mean your data is secure. »
- Portée / limites : énoncé d'un fournisseur sur son ancien secret JWT. Il rejoint la doc des logs (« An empty result does not establish... ») et les durées de conservation courtes.
- En pratique : écrire « aucune trace trouvée sur la période couverte par les logs (du … au …) », jamais « aucun abus ». La rotation reste due quoi que montre l'enquête.

### Côté GitHub : journal de sécurité du compte sur 90 jours, journal d'audit d'organisation sur 180 jours (3 mois affichés par défaut)
- Niveau de preuve : N3
- Source : GitHub Docs, consulté le 9.11.2026, « Reviewing your security log », https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/reviewing-your-security-log ; « Reviewing the audit log for your organization », https://docs.github.com/en/organizations/keeping-your-organization-secure/managing-security-settings-for-your-organization/reviewing-the-audit-log-for-your-organization
- Extrait lu : « The security log lists all actions performed within the last 90 days. » ; « The audit log lists events triggered by activities that affect your organization within the last 180 days. [...] By default, only events from the past three months are displayed. »
- Portée / limites : pas vérifié si les lectures et clonages d'un dépôt privé personnel y figurent (voir « Non vérifié »).
- En pratique : après une fuite de PAT ou un soupçon sur le compte, exporter le journal de sécurité, puis chercher la création de jetons, de clés SSH et d'applications OAuth et les changements de visibilité.

### Saisir les preuves pendant la réponse : un ticket au support ne conserve pas les logs ; finir par un résumé d'incident avec chronologie, cause racine, décisions et leçons
- Niveau de preuve : N3
- Source : GitHub Docs, consulté le 9.11.2026, « Responding to a security incident », https://docs.github.com/en/code-security/tutorials/secure-your-organization/respond-to-a-security-incident
- Extrait lu : « Capture available evidence : Take screenshots of suspicious activity, export logs or query results while they are available, and save copies of affected files or code before cleanup. Opening a support ticket does not preserve logs or extend their retention period. » ; « For exposed or exploited credentials, the most immediate action you can take is to revoke the affected credentials to prevent further misuse. » ; « Write an incident summary . This should include a timeline of events from first indication to resolution, as well as the root cause analysis, decisions and actions taken, and lessons learned. »
- Portée / limites : guide écrit pour des propriétaires d'entreprise ou d'organisation GitHub. Il précise aussi : « We don't recommend taking all of these actions for every incident ».
- En pratique : en parallèle de la révocation, faire des captures et des exports datés. Le post-mortem reprend ce gabarit.

---

## 6. Post-mortem sans blâme

### Un post-mortem sans blâme cherche les causes contributives sans mettre en cause une personne ; ses déclencheurs se fixent avant l'incident
- Niveau de preuve : N4 (retour d'expérience d'un opérateur, publié par Google)
- Source : Lunney, Lueder (Google), 2016, « Site Reliability Engineering », chap. 15 « Postmortem Culture: Learning from Failure », https://sre.google/sre-book/postmortem-culture/
- Extrait lu : « For a postmortem to be truly blameless, it must focus on identifying the contributing causes of the incident without indicting any individual or team for bad or inappropriate behavior. » ; « If a culture of finger pointing and shaming individuals or teams for doing the "wrong" thing prevails, people will not bring issues to light for fear of punishment. » ; « It is important to define postmortem criteria before an incident occurs »
- Portée / limites : conçu pour une grande organisation. Pour un indépendant seul, l'enjeu « sans blâme » porte surtout sur l'honnêteté du récit envers soi-même et le client. Aucune mesure d'efficacité dans le chapitre.
- En pratique : déclencheurs fixés d'avance (tout secret exposé, toute perte de données, toute intervention manuelle en prod). Récit factuel et causes systémiques : « pourquoi le scan n'a pas bloqué ? » plutôt que « qui a commité ? ».

### Une action corrective qui n'est jamais close revient à accepter le même incident ; prioriser les actions selon le risque de récidive
- Niveau de preuve : N4
- Source : Lunney, Lueder, Beyer (Google), printemps 2017, « Postmortem Action Items: Plan the Work and Work the Plan », ;login:, https://sre.google/static/pdf/login_spring17_09_lunney.pdf
- Extrait lu : « If the AIs are not closed out, you are implicitly agreeing that it is acceptable to suffer the exact same outage again. » ; « P0: High risk of unmitigated recurrence of the incident if this AI is » [not completed] ; « Google teams are by no means perfect at formulating and executing postmortem action items. »
- Portée / limites : pratique interne décrite sans mesure. Les auteurs reconnaissent leurs propres limites.
- En pratique : chaque post-mortem produit des actions datées, avec responsable et priorité, ouvertes en issues. La capitalisation se vérifie à la clôture des issues, pas au document écrit.

---

## 7. Compromission de comptes et d'outillage

### Une action GitHub tierce compromise peut exposer tous les secrets du CI : avec tj-actions/changed-files (mars 2025, CVE-2025-30066), il fallait faire tourner immédiatement tous les secrets identifiés
- Niveau de preuve : N3 (NVD, CISA)
- Source : NIST NVD, publié le 15.03.2025, « CVE-2025-30066 », https://services.nvd.nist.gov/rest/json/cves/2.0?cveId=CVE-2025-30066 ; CISA, 18.03.2025 (révisé le 26.03.2025), « Supply Chain Compromise of Third-Party tj-actions/changed-files (CVE-2025-30066) and reviewdog/action-setup », https://www.cisa.gov/news-events/alerts/2025/03/18/supply-chain-compromise-third-party-tj-actionschanged-files-cve-2025-30066-and-reviewdogaction
- Extrait lu : NVD : « tj-actions changed-files before 46 allows remote attackers to discover secrets by reading actions logs. (The tags v1 through v45.0.7 were affected on 2025-03-14 and 2025-03-15 because they were modified by a threat actor to point at commit 0e58ed8, which contained malicious updateFeatures code.) » ; entrée au catalogue CISA des vulnérabilités exploitées le 18.03.2025. CISA (citations restituées par WebFetch) : « check for exposed access keys, GitHub Personal Access Tokens (PATs), npm tokens, and private RSA keys » ; « Rotate all identified secrets immediately as they should be considered compromised. »
- Portée / limites : les secrets fuyaient dans les **logs d'Actions**, lisibles publiquement pour les dépôts publics. L'épinglage par SHA n'est pas dans le texte CISA restitué (il figure dans le renvoi NVD vers la doc de durcissement GitHub, non ouverte).
- En pratique : face à une action ou une dépendance compromise, (1) faire l'inventaire des workflows qui l'utilisent, (2) relire les logs d'Actions sur la fenêtre, (3) faire tourner **tous** les secrets accessibles à ces workflows, sans trier « ceux qui ont l'air touchés ».

### La double authentification est obligatoire sur GitHub pour les contributeurs depuis mars 2023
- Niveau de preuve : N3
- Source : GitHub Docs, consulté le 9.11.2026, « About mandatory two-factor authentication », https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/about-mandatory-two-factor-authentication
- Extrait lu : « As of March 2023, GitHub required all users who contribute code on GitHub.com to enable one or more forms of two-factor authentication (2FA). [...] marking the beginning of a 45-day 2FA enrollment period »
- Portée / limites : déploiement par groupes (« If you didn't receive a notification, then you were not part of a group required to enable 2FA »). La 2FA par TOTP ou SMS reste vulnérable au phishing en temps réel ; GitHub (pour npm) recommande WebAuthn/passkeys comme « phishing-resistant ».
- En pratique : passkey ou clé matérielle sur GitHub, npm, Vercel et Supabase. En cas de soupçon de compromission du compte : changer le mot de passe, révoquer sessions, PAT, clés SSH et applications OAuth, puis relire le journal de sécurité.

### npm a durci l'authentification après les attaques de 2025 : jetons classiques révoqués le 9.12.2025, jetons granulaires d'écriture à 7 jours par défaut et 90 jours au plus, sessions `npm login` de deux heures, TOTP abandonné au profit de WebAuthn
- Niveau de preuve : N3
- Source : René-Corail (GitHub), 22.09.2025, « Our plan for a more secure npm supply chain », https://github.blog/security/supply-chain-security/our-plan-for-a-more-secure-npm-supply-chain/ ; GitHub Changelog, 29.09.2025, « Strengthening npm security: Important changes to authentication and token management », https://github.blog/changelog/2025-09-29-strengthening-npm-security-important-changes-to-authentication-and-token-management/ ; GitHub Changelog, 09.12.2025, « npm classic tokens revoked, session-based auth and CLI token management now available », https://github.blog/changelog/2025-12-09-npm-classic-tokens-revoked-session-based-auth-and-cli-token-management-now-available/
- Extrait lu : « recent surge in damaging account takeovers on package registries, including npm » ; « A default expiration of seven days, reduced from 30 days. A maximum expiration of 90 days, which used to be unlimited. » ; « Long-lived tokens are a primary vector for supply chain attacks. » ; « We've permanently revoked all existing npm classic tokens. » ; « when you use npm login you'll receive a two-hour session token instead of long-lived tokens » ; « WebAuthn/passkeys provide stronger, phishing-resistant authentication. »
- Portée / limites : le billet du 22.09.2025 évoque Shai-Hulud (couvert ailleurs) et les prises de contrôle de comptes en général. La vague de phishing du 8 septembre 2025 n'y est pas nommée (voir « Non vérifié »). Les jetons granulaires peuvent encore avoir « Bypass 2FA » pour l'automatisation.
- En pratique : pour un paquet publié, vérifier qu'aucun jeton d'écriture long ne traîne dans les secrets CI. Exiger la 2FA pour publier, en WebAuthn.

### Publier sur npm par « trusted publishing » (OIDC) supprime le jeton de publication long
- Niveau de preuve : N3
- Source : npm Docs, consulté le 9.11.2026, « Trusted publishing for npm packages », https://docs.npmjs.com/trusted-publishers
- Extrait lu : « Trusted publishing allows you to publish npm packages directly from your CI/CD workflows using OpenID Connect (OIDC) authentication, eliminating the need for long-lived npm tokens. » ; « each publish uses short-lived, cryptographically-signed tokens that are specific to your workflow and cannot be extracted or reused » ; « Trusted publishing requires npm CLI version 11.5.1 or later and Node version 22.14.0 or higher. »
- Portée / limites : pris en charge sur GitHub Actions (runners hébergés), GitLab.com et CircleCI cloud ; « Self-hosted runners are not currently supported ». Les jetons existants restent acceptés tant qu'on ne restreint pas l'accès (« Set up trusted publishers first [...] Then restrict token access »). Provenance générée automatiquement depuis GitHub Actions et GitLab.
- En pratique : sur un paquet publié depuis GitHub Actions, configurer le trusted publisher, puis interdire la publication par jeton et révoquer les jetons d'automatisation.

---

## Verdict sur les règles du profil

| Règle | Verdict | Motif sourcé |
|---|---|---|
| « Mode D : contenir d'abord (rotation/invalidation), évaluer l'exposition, vérifier l'usage abusif, puis post-mortem avec capitalisation. Un secret leaké se traite en minutes, pas en réunions. On contient AVANT de comprendre. » | **Soutenue pour un secret fuité ; à préciser sur deux points** | L'ordre révoquer → vérifier l'usage → post-mortem est celui de GitHub (« the most immediate action you can take is to revoke », tutoriel de réponse ; étapes 4 → 6 → 7 du tutoriel de remédiation) et d'OWASP (« The primary goal of incident response is rapid response and containment »). « En minutes » : Unit 42 mesure une exploitation en moins de 5 min (N4) ; Meli et al. mesurent une découverte en 20 s (N2). **Précision 1** : « contenir avant de comprendre » ne vaut que pour un secret isolé. Pour une intrusion avec persistance (compte admin, comportement anormal en prod), CISA demande un confinement qui couvre toute l'activité de l'adversaire sans lui donner l'alerte, et le recensement des accès persistants avant d'éradiquer. **Précision 2** : la saisie des preuves se fait *en parallèle* du confinement, pas après (« export logs [...] while they are available » ; logs Vercel 1 h en Hobby, Supabase 1 jour en Free). |
| « Si un secret a touché un commit, il est compromis — même supprimé au commit suivant, même repo privé : rotation immédiate, pas de "on a force-push, c'est bon". » | **Soutenue** (le cas privé repose sur la précaution, pas sur une mesure) | GitHub : « You should consider any leaked secret to be immediately compromised [...] Simply removing the secret from the codebase, pushing a new commit, or deleting and recreating the repository do not prevent the secret from being exploited. » Force-push insuffisant : clones, forks, SHA en cache, PR (doc GitHub) ; Meli et al. ; CFOR. Repo privé : le tutoriel ne fait pas de distinction. GitGuardian (N4) trouve 9 fois plus de secrets dans les dépôts privés. Aucune source ouverte ne mesure le risque d'exploitation propre à un dépôt privé. |
| « Cycle de vie : périmètre minimal (clé par service), rotation possible (documentée, testée — si on ne sait pas le faire tourner, c'est un finding), détection (scan du repo et des diffs). » | **Soutenue** ; « clé par service » est une conséquence du moindre privilège, pas une formule trouvée telle quelle | OWASP : « Least Privilege », « Limit blast radius », « never share credentials across administrative users », « The secret must be able to be de-authorized quickly », « A new secret must be able to be quickly created and implemented, preferably via an automated process ». Détection : OWASP (pré-commit, IDE) ; GitHub (scan de tout l'historique, protection au push). Cryptopériodes : NIST SP 800-57. Supabase : rotation au moins annuelle. Le cas de l'ancien secret JWT Supabase (rotation avec temps d'arrêt) illustre exactement le « finding ». |
| « Chercher l'usage abusif : "Aucune trace trouvée" ≠ "aucun abus". » | **Soutenue** | Supabase : « An empty result does not establish that the user had no activity. » et « lacking current evidence of compromise does not mean your data is secure ». Rétention courte (Vercel 1 h à 1 jour hors options ; Supabase 1 à 7 jours selon le plan). GitHub : « Opening a support ticket does not preserve logs ». |
| « Purger : retirer le secret de l'historique si pertinent, vérifier les caches/forks, re-scanner. » | **Soutenue, à préciser** : la purge vient *après* la rotation et n'en tient jamais lieu | GitHub : rotation « as a first step », la réécriture « may not be warranted » ; données restantes dans les forks (« GitHub cannot provide contact information for these owners ») ; support seulement si « the risk can't be mitigated by rotating ». Re-scan justifié par le « High risk of recontamination » (clone ancien + `git pull` + `git push`). Outil cité : `git-filter-repo --sensitive-data-removal` (BFG absent de la doc actuelle). |
| « Post-mortem blameless. » | **Soutenue comme pratique (N4) ; convention sans preuve empirique trouvée de son effet** | Google SRE chap. 15 (définition, déclencheurs fixés d'avance) ; Lunney et al. 2017 (actions à clore) ; NIST 800-61r3 (amélioration continue, leçons partagées sans attendre, mais sans le mot « blameless ») ; GitHub (résumé d'incident). Aucune étude revue par des pairs mesurant l'apprentissage ou la récidive n'a été trouvée et ouverte. |
| « Jamais valider une mise en prod sans `AUTH_SECRET` aléatoire >= 32 caractères. » | **À préciser** (dans le sens déjà établi : 32 octets d'un CSPRNG) | Auth.js : « cryptographically secure random string of at least 32 characters », commande `openssl rand -base64 33`. Better Auth : « at least 32 characters and generated with high entropy », `openssl rand -base64 32`. Vercel KB : `openssl rand -base64 32`. Les docs disent « caractères », leurs commandes produisent 32 ou 33 octets aléatoires : la formulation en octets d'un générateur cryptographique colle aux commandes et va plus loin que le minimum écrit. À ajouter : une valeur distincte par environnement (politique Vercel « Separate Production Secret Values ») et un moyen de rotation (`BETTER_AUTH_SECRETS`). |

## Mythes et affirmations contestées

- **« On a force-pushé, le secret a disparu. »** Contredit. GitHub : les commits restent accessibles dans les clones, les forks, par SHA dans les vues en cache et via les PR. Meli et al. ont récupéré des commits supprimés par leur seul SHA, retrouvé via l'Events API. Le réseau de forks garde les données même après suppression d'un fork.
- **« Supprimer et recréer le dépôt suffit. »** Contredit mot pour mot par GitHub (« deleting and recreating the repository do not prevent the secret from being exploited »).
- **« Meli et al. 2019 ont mesuré l'exploitation par jetons-pièges. »** Inexact. L'étude mesure la fuite et le délai d'indexation par l'API de recherche (20 s de médiane). Les auteurs n'ont pas utilisé de jetons-pièges et n'ont pas mesuré d'exploitation. Le « moins de 5 minutes » vient de Unit 42 (éditeur, une expérience, clés AWS).
- **« La quarantaine AWS a réglé le problème. »** Contredit. Elle ne refuse que « certain actions » et AWS demande de suivre le dossier de support. Unit 42 a vu de la reconnaissance 4 min après son application.
- **« GitHub a prévenu le fournisseur, donc la clé est révoquée. »** Non établi. Le programme partenaire laisse chaque fournisseur décider ; il couvre les dépôts publics et les paquets npm publics, pas un dépôt privé sans Secret Protection.
- **« Changer la variable sur Vercel suffit. »** Contredit. Les anciens déploiements gardent l'ancienne valeur (« it will still use the old credential ») et l'ancienne clé reste valide chez le fournisseur tant qu'on ne l'invalide pas.
- **« Redémarrer l'appli coupe l'accès volé. »** Contredit par OWASP (« Restarting the application does not itself revoke stolen credentials »).
- **« Le support GitHub purge sur demande. »** Seulement si le risque ne peut pas être couvert par une rotation, et rien n'atteint les clones déjà faits.
- **« La Rev. 3 du NIST abolit les quatre phases. »** À nuancer. Elle remplace la Rev. 2, range les phases sous le CSF 2.0 et dit explicitement « use the incident response life cycle framework or model that suits them best ».
- **« Il faut faire tourner tous les secrets tous les 90 jours (norme). »** Aucune source ouverte ne fixe 90 jours. Le NIST SP 800-57 donne des ordres de grandeur (moins de 2 ans pour une clé symétrique d'authentification) « only rough order-of-magnitude ». OWASP exclut les mots de passe d'utilisateurs de la rotation périodique. Le critère opposable est la capacité à faire tourner vite, pas un calendrier.
- **« Le masquage des logs de build Vercel protège mes secrets. »** Seulement les valeurs de type Secret d'au moins 32 caractères.

## Non vérifié

- **Etsy, « Blameless PostMortems and a Just Culture » (Allspaw, 2012)** : page renvoyant 403 ; Wayback Machine inaccessible depuis l'outil. Ni l'auteur, ni la date, ni une citation n'ont pu être confirmés.
- **SANS, « Incident Handler's Handbook » (Kral)** : résumé seul lu (page sans les noms des six phases). La séquence « PICERL » n'a pas été vérifiée.
- **Mesure empirique de l'apprentissage après incident** : aucune étude revue par des pairs trouvée et ouverte. Un préprint arXiv (« Failures and Fixes: A Study of Software System Incident Response », 8 entretiens et 15 rapports publics) n'est apparu que dans les résultats de recherche, non ouvert. Les chiffres de blogs sur le taux de clôture des actions (par exemple « 30 % ») sont sans source.
- **Vague de phishing npm du 8 septembre 2025 (`debug`, `chalk`, domaine `npmjs.help`)** : seules des sources secondaires (presse, éditeurs) sont apparues en recherche. Aucun avis officiel (GHSA ou billet GitHub/npm) n'a été ouvert : l'API des avis GitHub est bloquée dans cet environnement et la recherche sur github.com/advisories n'a rien remonté. Dates, nombre de paquets et mode opératoire non confirmés.
- **CISA, alerte tj-actions** : la page a été lue via WebFetch (résumé et citations restitués par l'outil, pas le texte brut). Recommandation d'épinglage par SHA non vue dans la restitution.
- **GitGuardian 2025** : citations restituées par WebFetch, méthodologie non examinée.
- **Révocation automatique par Supabase ou Vercel sur notification de GitHub** : le tableau confirme la détection sur dépôts publics. Le comportement du fournisseur à la réception (révocation, e-mail) n'a pas été vérifié dans la doc Supabase ou Vercel.
- **Contenu du journal de sécurité d'un compte GitHub personnel** (par exemple, les clonages d'un dépôt privé y sont-ils tracés ?) : non vérifié. La doc ouverte ne donne que la durée de 90 jours.
- **2FA obligatoire sur npm** (dates, périmètre) : seule l'intention annoncée a été lue (« Remove the option to bypass 2FA for local package publishing », 22.09.2025). Mise en œuvre effective non vérifiée.
- **Statut formel de la SP 800-61r2** : la notice du NIST dit « Supersedes » ; le mot « withdrawn » n'a pas été vu.
- **Date d'origine du recueil CISA** : le PDF porte « Publication: November 2021 », le chemin du fichier « 2024-08 ». Nature d'une éventuelle révision de 2024 non vérifiée.
- **Billet Truffle Security (CFOR)** : la formule « available forever » est celle de l'éditeur. Seul le principe d'accès dans le réseau de forks est confirmé par GitHub.

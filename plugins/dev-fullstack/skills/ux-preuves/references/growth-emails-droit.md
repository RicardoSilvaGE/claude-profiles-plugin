# Fiche `ux-preuves` — Growth — e-mails, délivrabilité et droit du marketing direct

> Fiche du skill `ux-preuves` (dev-fullstack), volet **growth**, préchargé par `growth`. Couvre : exigences Gmail, Yahoo et Outlook, DMARC (RFC 9989), désabonnement en un clic, fiabilité du taux d'ouverture (Apple MPP, CNIL 2026), droit suisse (LCD art. 3 let. o, nLPD), UE (ePrivacy, RGPD), CAN-SPAM, CASL, séquences de cycle de vie mesurées, accessibilité des e-mails.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Verdict sur les règles
> du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées : ce qui y
> figure ne se cite pas comme un fait. Le droit y est rapporté, pas appliqué : son application à
> un produit précis relève d'un juriste.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche du 9 novembre 2026 pour le référentiel de l'agent « stratège growth/marketing et copywriter d'acquisition senior ».
> Contexte : développeur indépendant établi en Suisse, utilisateurs en Suisse et dans l'UE, parfois aux États-Unis.
> Règle suivie : chaque entrée vient d'une page **ouverte** pendant la recherche. Quand seul un résumé a été lu, c'est indiqué.
> **Ce document rapporte le droit, il ne donne pas de conseil juridique.** Appliquer ces textes à un cas précis est le travail d'un juriste.
>
> Accès aux textes : Fedlex lu via le dépôt de fichiers officiel `fedlex.data.admin.ch` (versions consolidées). EUR-Lex n'a rendu
> aucun contenu à l'outil de lecture : la directive 2002/58, la directive 2005/29 et le RGPD ont été lus sur **legislation.gov.uk**
> (version UE « as adopted » du RGPD ; versions de 2002/58 et 2005/29 figées au 31.12.2020, sans modification UE ultérieure vérifiée).
> Les extraits sont en langue d'origine.

---

## 1. Exigences des fournisseurs de messagerie (délivrabilité)

### Tout expéditeur vers Gmail authentifie son domaine (SPF ou DKIM) et maintient un taux de spam déclaré inférieur à 0,3 %
- Niveau de preuve : N1 (exigence opposable d'un fournisseur de messagerie)
- Source : Google, 2024 (page en vigueur consultée le 09.11.2026), « Email sender guidelines », https://support.google.com/a/answer/81126
- Extrait lu : « Starting February 1, 2024, all email senders who send email to Gmail accounts must meet the requirements in this section. » ; « Set up SPF or DKIM email authentication for your sending domains. » ; « Keep spam rates reported in Postmaster Tools below 0.3%. »
- Portée / limites : vaut pour **tout** expéditeur, quel que soit le volume. Clé DKIM d'au moins 1024 bits exigée pour les comptes Gmail personnels, 2048 recommandés. TLS ajouté aux exigences en décembre 2023.
- En growth : avant le premier envoi d'une séquence, le domaine d'envoi est-il authentifié et suivi dans Postmaster Tools ? Sans ce suivi, on ne connaît pas le taux de plaintes.

### Au-delà d'environ 5 000 messages par jour vers Gmail, SPF, DKIM et DMARC (p=none suffit) avec alignement du From sont obligatoires, et le statut d'expéditeur de masse est définitif
- Niveau de preuve : N1
- Source : Google, « Email sender guidelines », https://support.google.com/a/answer/81126 ; Google, « Email sender guidelines FAQ », https://support.google.com/a/answer/14229414
- Extrait lu : « Your DMARC enforcement policy can be set to none. » ; « For direct email, the domain in the sender's From: header must be aligned with either the SPF domain or the DKIM domain. » ; la FAQ définit l'expéditeur de masse comme celui qui « sends close to 5,000 messages or more to personal Gmail accounts within a 24-hour period ».
- Portée / limites : le seuil est formulé de trois façons selon la page (« 5,000 or more », « more than 5,000 », « close to 5,000 »). D'après la FAQ, il suffit de l'atteindre **une fois** pour garder ce statut, même si les volumes baissent ensuite. Seuls les envois vers des comptes Gmail personnels comptent.
- En growth : un lancement ou un e-mail d'annonce à toute la base peut faire basculer un petit expéditeur dans le régime de masse pour de bon. Il faut donc configurer DMARC avant le pic, pas après.

### Un e-mail marketing envoyé à Gmail porte le désabonnement en un clic, la demande est traitée sous 48 heures, et le taux de spam vise moins de 0,1 % (rejets possibles depuis novembre 2025)
- Niveau de preuve : N1
- Source : Google, « Email sender guidelines FAQ », https://support.google.com/a/answer/14229414 ; Google, « Email sender guidelines », https://support.google.com/a/answer/81126
- Extrait lu : « Marketing messages and subscribed messages must support one-click unsubscribe. » ; « Transactional messages are excluded from this requirement. » ; « fulfill unsubscribe requests within 48 hours » ; « Keep spam rates reported in Postmaster Tools below 0.10% and avoid ever reaching a spam rate of 0.30% or higher. » ; « Starting November 2025, Gmail is ramping up its enforcement on non-compliant traffic. » ; « temporary and permanent rejections »
- Portée / limites : le délai de 48 heures figure dans la FAQ et **pas** sur la page principale des exigences. Depuis juin 2024, un expéditeur de masse dont le taux de spam dépasse 0,3 % n'a plus droit aux mesures d'atténuation ; il y a de nouveau droit après 7 jours consécutifs sous ce seuil. Un lien de désabonnement dans le corps du message reste admis en plus, mais il ne remplace pas le clic unique.
- En growth : un e-mail « transactionnel » qui contient de la promotion perd-il son exemption ? Le tableau de bord suit-il le taux de plaintes, avec une alerte à 0,1 % ?

### Yahoo impose le même socle depuis février 2024 et exige que les désabonnements soient honorés sous 2 jours
- Niveau de preuve : N1
- Source : Yahoo, 2024, « Sender Best Practices », https://senders.yahooinc.com/best-practices/
- Extrait lu : « Publish a valid DMARC policy with at least p=none - DMARC must pass » ; « Honor unsubscribes within 2 days » ; « Keep your spam rate below 0.3% » ; « Beginning in February 2024, enforcement of the following sending standards will take effect. »
- Portée / limites : la page ne chiffre pas le seuil qui fait d'un expéditeur un « bulk sender ».
- En growth : le désabonnement est-il propagé à **toutes** les listes et à tous les outils (CRM, ESP, outil d'automatisation) en moins de 48 heures ?

### Outlook.com range dans les indésirables, depuis le 5 mai 2025, les envois de plus de 5 000 e-mails par jour sans SPF, DKIM et DMARC, et annonce des rejets à une date encore inconnue
- Niveau de preuve : N1
- Source : Microsoft Defender for Office 365 Blog, 02.04.2025 (mis à jour le 30.04.2025), « Strengthening Email Ecosystem: Outlook's New Requirements for High-Volume Senders », https://techcommunity.microsoft.com/blog/microsoft-defender-for-office-365-blog/strengthening-email-ecosystem-outlook%E2%80%99s-new-requirements-for-high%E2%80%90volume-senders/4399730
- Extrait lu : « domains sending more than 5,000 emails per day » ; « will begin routing messages from high volume non‐compliant domains to the Junk folder » ; « 550; 5.7.515 Access denied, sending domain [SendingDomain] does not meet the required authentication level. »
- Portée / limites : le billet donne la date du rejet comme « to be announced ». Aucune mise à jour postérieure n'a été vérifiée. Le désabonnement facile y est une **recommandation** (« Provide an easy, clearly visible way for recipients to opt out ») et non une exigence.
- En growth : la délivrabilité est-elle mesurée séparément vers Gmail, Yahoo et Outlook ? Un domaine conforme pour Gmail ne l'est pas forcément pour Outlook.

### Le désabonnement en un clic repose sur RFC 8058 : un en-tête `List-Unsubscribe-Post: List-Unsubscribe=One-Click`, une URI HTTPS et une signature DKIM qui couvre ces en-têtes
- Niveau de preuve : N1 (norme IETF, Proposed Standard)
- Source : Levine J., Herkula T., janvier 2017, « RFC 8058 — Signaling One-Click Functionality for List Email Headers », https://www.rfc-editor.org/rfc/rfc8058
- Extrait lu : « List-Unsubscribe-Post header MUST contain the single key/value pair "List-Unsubscribe=One-Click" » ; « The List-Unsubscribe header field MUST contain one HTTPS URI. » ; « the message MUST have a valid DomainKeys Identified Mail (DKIM) signature »
- Portée / limites : la RFC répond à un problème précis : des logiciels qui suivent automatiquement les URL des en-têtes déclenchaient des désabonnements involontaires. La signature DKIM doit couvrir au moins les deux en-têtes.
- En growth : l'endpoint de désabonnement accepte-t-il un POST sans cookie ni page de confirmation ? Si un « êtes-vous sûr ? » s'interpose, ce n'est plus un clic unique.

### DMARC est devenu une norme IETF (RFC 9989, Proposed Standard), qui rend obsolète la RFC 7489 et retire la balise `pct`
- Niveau de preuve : N1
- Source : Kucherawy M., Zwicky E., mars 2015, « RFC 7489 — DMARC », https://www.rfc-editor.org/rfc/rfc7489 ; Herr T., Levine J. (éd.), 2026, « RFC 9989 — Domain-Based Message Authentication, Reporting, and Conformance (DMARC) », https://www.rfc-editor.org/rfc/rfc9989
- Extrait lu : RFC 7489 : « When the domain in the RFC5322.From address matches a domain validated by SPF or DKIM (or both), it has Identifier Alignment. » ; RFC 9989 : « This document obsoletes RFCs 7489 and 9091. »
- Portée / limites : la RFC 7489 n'était qu'**informationnelle** (Independent Submission). Son en-tête la renvoie désormais aux RFC 9989, 9990 et 9991. Le mois de publication de la RFC 9989 n'a pas été lu (seule l'année 2026, dans le copyright). Le détail de la suppression de `pct` (annexe A.6) n'a pas été lu.
- En growth : un enregistrement DMARC qui compte encore sur `pct=` pour un déploiement progressif repose sur une balise que la norme a retirée.

---

## 2. Mesure : ce que vaut encore le taux d'ouverture

### Apple Mail Privacy Protection télécharge le contenu distant en arrière-plan, que le message soit ouvert ou non : un « open » Apple ne prouve pas une lecture
- Niveau de preuve : N3 (documentation officielle de l'éditeur, non contraignante)
- Source : Apple, page datée du 12.12.2025, « Mail Privacy Protection & Privacy », https://www.apple.com/legal/privacy/data/en/mail-privacy-protection/ ; Apple Newsroom, 07.06.2021, « Apple advances its privacy leadership with iOS 15, iPadOS 15, macOS Monterey, and watchOS 8 », https://www.apple.com/newsroom/2021/06/apple-advances-its-privacy-leadership-with-ios-15-ipados-15-macos-monterey-and-watchos-8/
- Extrait lu : « Protect Mail Activity downloads remote content in the background by default » ; « regardless of whether you engage with the email » ; communiqué 2021 : « The new feature helps users prevent senders from knowing when they open an email, and masks their IP address »
- Portée / limites : l'annonce date de juin 2021. Le déploiement au 20 septembre (2021) vient de Litmus (entrée suivante), pas d'Apple. La protection ne couvre pas les liens.
- En growth : tout déclencheur d'automatisation fondé sur « a ouvert » ou « n'a pas ouvert » est faussé pour les utilisateurs Apple.

### Apple Mail pèse environ trois quarts des ouvertures mesurées par Litmus, qui classe les ouvertures MPP comme non fiables et recommande clics et conversions
- Niveau de preuve : N4 (données d'un éditeur, plus de 1,5 milliard d'ouvertures, échantillon de ses clients)
- Source : Litmus, données « current as of October 1, 2026 », « Email Client Market Share », https://www.litmus.com/email-client-market-share ; Litmus, 2021, « Email Client Market Share in September 2021: Early Data on the Impact of Apple's Mail Privacy Protection », https://www.litmus.com/blog/email-client-market-share-september-2021
- Extrait lu : Apple Mail à 76,56 % des ouvertures et Gmail à 16,10 % (septembre 2026) ; « not considered reliable opens » ; « roughly 55-60% of all email opens » ; 2021 : MPP déployé « to its Mail app on iOS 15 and iPadOS 15 on September 20th »
- Portée / limites : Litmus attribue le chiffre de 55 à 60 % à des « studies » sans les nommer, donc **source non identifiée**. L'échantillon se limite aux clients de Litmus, il n'est pas représentatif d'une liste donnée. La part réelle se mesure sur sa propre liste.
- En growth : quelle part de **notre** liste ouvre depuis Apple Mail ? Si elle est majoritaire, l'open rate ne mesure presque plus rien.

### Un ESP majeur déclare les ouvertures non fiables (préchargement MPP) et signale que les clics sont aussi gonflés par les robots de sécurité
- Niveau de preuve : N3 (documentation d'un fournisseur de service d'envoi)
- Source : Mailchimp, « Apple Mail Privacy Protection (MPP) FAQs », https://mailchimp.com/help/apple-privacy-faq/ ; Mailchimp, « About Bot Activity and Bot Filtering », https://mailchimp.com/help/about-bot-activity/
- Extrait lu : « Apple Mail will preload pixels, even if your contact hasn't opened the email » ; « If you're running A/B tests based on open rates, your results might not be accurate. » ; « stronger engagement criteria like clicks or purchases » ; sur les robots, les outils de sécurité « often click links or open emails before your contacts do »
- Portée / limites : le filtrage des robots de Mailchimp détecte « most bot activity », donc pas tout. Le clic est **moins** faussé que l'ouverture, sans être propre. Pages sans date de mise à jour visible.
- En growth : un test A/B d'objet jugé à l'ouverture n'a pas de valeur. Les relances aux non-ouvreurs manquent les utilisateurs MPP : il faut cibler les « non-cliqueurs ».

### En France, depuis le 14 avril 2026, mesurer le taux d'ouverture pour optimiser les campagnes exige le consentement du destinataire (pixels de suivi)
- Niveau de preuve : N3 (recommandation de l'autorité de contrôle, qui interprète l'art. 82 de la loi Informatique et Libertés)
- Source : CNIL, 14.04.2026 (délibération n° 2026-042 du 12 mars 2026), « Pixels de suivi dans les courriers électroniques : la CNIL publie ses recommandations », https://www.cnil.fr/fr/recommandation-pixel-suivi-courriels ; CNIL, « Recommendation on tracking pixels in emails » (traduction de courtoisie), https://www.cnil.fr/sites/default/files/2026-05/recommandation_tracking_pixels_emails.pdf ; CNIL, FAQ, https://www.cnil.fr/fr/faq-recommandation-pixels-courriers-electroniques
- Extrait lu : « the CNIL considers that the use of pixels for the following purposes requires the collection of the recipient's consent: Analysis of the email opening rate to measure and optimise the performance of campaigns » ; exemption pour la délivrabilité, mais « only the date (at the day and without recording the time) of the last known opening of emails » ; FAQ : « À défaut, l'expéditeur doit cesser l'usage de pixels qui nécessite le consentement dans les courriels »
- Portée / limites : les adresses collectées avant le 14.04.2026 bénéficiaient d'un délai d'information d'environ 3 mois. Selon la FAQ, la CNIL se déclare compétente même envers un acteur hors UE lorsque « les pixels sont utilisés pour suivre le comportement de personnes se trouvant sur le territoire français ». L'exemption de délivrabilité ne couvre que les e-mails demandés, pas la prospection fondée sur le « soft opt-in ». Position française, pas européenne.
- En growth : pour des destinataires en France, mesurer l'open rate par campagne suppose un consentement distinct au pixel. Sans ce consentement, l'open rate n'est même plus collectable.

### Une étude publiée dans le JMR juge « court-termiste » de piloter l'e-mail au taux d'ouverture : l'activité e-mail et l'activité d'achat ne vont pas forcément ensemble (résumé seul lu)
- Niveau de preuve : N2 (revue à comité de lecture, données d'un seul détaillant) — **résumé seul lu**
- Source : Zhang X., Kumar V., Cosguner K., 2017, « Dynamically Managing a Profitable Email Marketing Program », Journal of Marketing Research 54(6), 851-866 — résumé AMA du 02.05.2018 : https://www.ama.org/academics/Pages/The-Sweet-Spot-in-Email-Marketing.aspx
- Extrait lu : « using metrics based on email responsiveness, such as open rates » « may be short-sighted » ; « email contact policies should be customized at the customer level » ; « sending 4 (10) emails per month might cause the firm to lose 32% (16%) of its lifetime profit »
- Portée / limites : le résumé de l'éditeur académique n'a pas pu être ouvert (HTTP 503). L'optimum « 7 e-mails par mois » vaut pour **ce** détaillant et se situe dans une fourchette de 5 à 14 selon le client. Il ne se transpose pas.
- En growth : la séquence est-elle jugée sur le revenu ou la conversion, avec un groupe témoin ? Ou sur une métrique de réponse qui ne dit rien de l'achat ?

---

## 3. Droit suisse

### En Suisse, la publicité de masse par e-mail exige le consentement préalable, l'identification correcte de l'émetteur et une opposition gratuite et facile (LCD art. 3 al. 1 let. o)
- Niveau de preuve : N1 (loi fédérale)
- Source : Confédération suisse, RS 241, « Loi fédérale contre la concurrence déloyale (LCD) », état le 1er janvier 2025, https://fedlex.data.admin.ch/filestore/fedlex.data.admin.ch/eli/cc/1988/223_223_223/20250101/fr/html/fedlex-data-admin-ch-eli-cc-1988-223_223_223-20250101-fr-html-5.html (notice : https://www.fedlex.admin.ch/eli/cc/1988/223_223_223/fr)
- Extrait lu : « envoie ou fait envoyer, par voie de télécommunication, de la publicité de masse n'ayant aucun lien direct avec une information demandée et omet de requérir préalablement le consentement des clients, de mentionner correctement l'émetteur ou de les informer de leur droit à s'y opposer gratuitement et facilement »
- Portée / limites : le texte ne fait **pas** de distinction entre B2C et B2B (il parle de « clients ») et ne fixe pas de seuil chiffré pour la « masse ». La page OFCOM lue (« Wann ist der Massenversand erlaubt? », 02.07.2021, https://www.bakom.admin.ch/de/wann-ist-der-massenversand-erlaubt) ne donne pas de seuil non plus et date l'opt-in au 1er avril 2007. Sanction pénale : art. 23 LCD, « sur plainte, puni d'une peine privative de liberté de trois ans au plus ou d'une peine pécuniaire » (infraction intentionnelle).
- En growth : chaque e-mail promotionnel nomme-t-il l'émetteur et propose-t-il une opposition gratuite ? Le consentement a-t-il été recueilli **avant** le premier envoi ?

### L'exception « client existant » suisse exige une vente réelle, une information sur l'opposition au moment de la collecte et des produits propres analogues : ouvrir un compte en ligne ne suffit pas (PFPDT)
- Niveau de preuve : N1 (exception de la LCD) + N3 (interprétation du PFPDT)
- Source : LCD art. 3 al. 1 let. o, 2e phrase (même URL Fedlex que ci-dessus) ; PFPDT/EDÖB, page non datée, « Werbung & Marketing », https://www.edoeb.admin.ch/de/werbung-marketing
- Extrait lu : LCD : « celui qui a obtenu les coordonnées de ses clients lors de la vente de marchandises, d'œuvres ou de prestations et leur a indiqué qu'ils pouvaient s'opposer […] n'agit pas de façon déloyale […] pour autant que cette publicité concerne des marchandises, œuvres et prestations propres analogues » ; PFPDT : « Es genügt nicht, lediglich ein Onlinekonto eröffnet zu haben. » ; « Die Annahme der allgemeinen Geschäftsbedingungen ist nicht ausreichend. »
- Portée / limites : la page du PFPDT n'est pas datée. Que l'inscription à une application **gratuite** vaille « vente de prestations » n'est pas tranché dans les sources lues ; le PFPDT écarte en tout cas la simple ouverture de compte.
- En growth : la base marketing vient-elle d'achats ou d'inscriptions gratuites ? La case d'opposition était-elle présente **au moment de la collecte** ?

### La nLPD impose d'informer la personne dès la collecte (identité, finalité, destinataires, pays étrangers), sous peine d'une amende pénale personnelle de 250 000 francs au plus
- Niveau de preuve : N1
- Source : Confédération suisse, RS 235.1, « Loi fédérale sur la protection des données (LPD) », état le 7 juillet 2025, https://fedlex.data.admin.ch/filestore/fedlex.data.admin.ch/eli/cc/2022/491/20250707/fr/html/fedlex-data-admin-ch-eli-cc-2022-491-20250707-fr-html-1.html
- Extrait lu : art. 19 al. 2 : « il lui communique au moins: a. l'identité et les coordonnées du responsable du traitement; b. la finalité du traitement; c. le cas échéant, les destinataires ou les catégories de destinataires » ; art. 60 al. 1 : « Sont, sur plainte, punies d'une amende de 250 000 francs au plus les personnes privées qui […] omettent intentionnellement […] d'informer la personne concernée »
- Portée / limites : la première version consolidée sur Fedlex est datée du 01.09.2023. L'art. 19 al. 4 impose de nommer l'État destinataire d'une communication à l'étranger (cas d'un ESP américain, par exemple). L'amende vise la personne physique qui agit intentionnellement. Champ territorial : art. 3 al. 1, « états de fait qui déploient des effets en Suisse ».
- En growth : le formulaire d'inscription renvoie-t-il à une déclaration qui nomme l'ESP et son pays d'hébergement ?

### En droit suisse, le profilage est défini largement ; seul le « profilage à risque élevé » par un privé exige un consentement exprès, et un consentement n'est valable que s'il est libre et éclairé
- Niveau de preuve : N1
- Source : RS 235.1 (nLPD), art. 5 let. f et g, art. 6 al. 6 et 7 — même URL que ci-dessus
- Extrait lu : art. 5 let. f : « toute forme de traitement automatisé de données personnelles consistant à utiliser ces données pour évaluer certains aspects personnels […] les préférences personnelles, les intérêts, la fiabilité, le comportement » ; art. 6 al. 7 : « Le consentement doit être exprès dans les cas suivants: […] b. il s'agit d'un profilage à risque élevé effectué par une personne privée »
- Portée / limites : le profilage à risque élevé suppose « un appariement de données qui permet d'apprécier les caractéristiques essentielles de la personnalité ». Une segmentation comportementale courante n'en relève pas forcément ; la qualification se fait au cas par cas, par un juriste.
- En growth : une segmentation qui croise usage de l'application, achats et données externes approche-t-elle de l'appariement « à risque élevé » ?

### En droit suisse, traiter des données contre la volonté expresse de la personne porte atteinte à sa personnalité : une opposition au marketing doit être respectée
- Niveau de preuve : N1
- Source : RS 235.1 (nLPD), art. 30 et 31 — même URL que ci-dessus
- Extrait lu : art. 30 al. 2 : « Constitue notamment une atteinte à la personnalité le fait de: […] b. traiter des données personnelles contre la manifestation expresse de la volonté de la personne concernée » ; art. 31 al. 1 : « Une atteinte à la personnalité est illicite à moins d'être justifiée par le consentement de la personne concernée, par un intérêt privé ou public prépondérant, ou par la loi. »
- Portée / limites : la nLPD n'a pas d'équivalent littéral de l'art. 21 RGPD (droit d'opposition au marketing direct). C'est la combinaison de l'art. 30 et de l'opposition prévue par la LCD qui joue ce rôle. Lecture de praticien de la recherche, pas position officielle lue.
- En growth : une désinscription supprime-t-elle aussi le ciblage publicitaire (audiences personnalisées) fondé sur la même adresse ?

### En Suisse, une urgence ou une rareté inventée est une indication inexacte sur les stocks ou les prix, donc un procédé déloyal (LCD art. 3 al. 1 let. b)
- Niveau de preuve : N1
- Source : RS 241 (LCD), art. 3 al. 1 let. b — même URL Fedlex que l'entrée LCD
- Extrait lu : « donne des indications inexactes ou fallacieuses sur lui-même, son entreprise, sa raison de commerce, ses marchandises, ses œuvres, ses prestations, ses prix, ses stocks, ses méthodes de vente ou ses affaires »
- Portée / limites : le texte ne mentionne pas l'« urgence » ni les comptes à rebours. Les rattacher aux « prix », « stocks » ou « méthodes de vente » est une lecture, pas une jurisprudence lue.
- En growth : chaque « offre limitée » ou « plus que 3 places » est-il **vrai** et documentable ?

---

## 4. Droit de l'Union européenne et pays clés

### Dans l'UE, l'e-mail de prospection vers une personne physique exige un consentement préalable, sauf « soft opt-in » : un client, ses produits ou services propres et analogues, une opposition offerte dès la collecte puis dans chaque message
- Niveau de preuve : N1 (directive)
- Source : Directive 2002/58/CE, art. 13 par. 1 et 2, version modifiée par la directive 2009/136/CE (texte du 19.12.2009) — copie lue sur legislation.gov.uk : https://www.legislation.gov.uk/eudr/2002/58/article/13
- Extrait lu : par. 1 : « electronic mail for the purposes of direct marketing may be allowed only » « in respect of subscribers or users who have given their prior consent. » ; par. 2 : « of its own similar products or services provided that customers clearly and distinctly are given the opportunity to object, » « free of charge and in an easy manner, […] at the time of their collection » « and on the occasion of each message »
- Portée / limites : c'est une directive, et chaque État membre l'a transposée (voir l'Allemagne et la France ci-dessous). EUR-Lex n'a rendu aucun contenu ; copie britannique figée au 31.12.2020.
- En growth : la case d'opposition existe-t-elle **au moment** de l'achat, pas seulement dans le premier e-mail ?

### Dans l'UE, il est interdit de masquer l'expéditeur ou d'omettre une adresse valide pour se désabonner ; pour les personnes morales, le droit national décide
- Niveau de preuve : N1
- Source : Directive 2002/58/CE, art. 13 par. 4 et 5 — https://www.legislation.gov.uk/eudr/2002/58/article/13
- Extrait lu : par. 4 : « disguise » « or conceal the identity of the sender on whose behalf the communication is made, » « which do not have a valid address to which the recipient may send a request that such communications cease » ; par. 5 : « Paragraphs 1 and 3 shall apply to subscribers who are natural persons. »
- Portée / limites : pour le B2B (personnes morales), la directive renvoie aux États membres. Le régime B2B varie donc d'un pays à l'autre.
- En growth : l'adresse de réponse et le nom d'expéditeur sont-ils ceux de l'émetteur réel, y compris dans une séquence envoyée par un outil tiers ?

### Sous le RGPD, la personne peut s'opposer à tout moment au marketing direct, y compris au profilage qui le sert, et ce droit doit lui être signalé au plus tard lors du premier contact
- Niveau de preuve : N1 (règlement directement applicable)
- Source : Règlement (UE) 2016/679, art. 21 par. 2 à 4, version « as adopted » — https://www.legislation.gov.uk/eur/2016/679/article/21/adopted
- Extrait lu : « the data subject shall have the right to object at any time » ; « which includes profiling to the extent that it is related to such direct marketing. » ; « the personal data shall no longer be processed for such purposes. » ; « shall be presented clearly and separately from any other information. »
- Portée / limites : le droit d'opposition au marketing est absolu (pas de mise en balance). Il s'ajoute à l'art. 13 de la directive ePrivacy, il ne le remplace pas.
- En growth : l'opposition éteint-elle aussi le scoring et la segmentation marketing, pas seulement l'envoi ?

### Sous le RGPD, la demande de consentement est distincte du reste, aussi facile à retirer qu'à donner, et ne conditionne pas le service à un traitement inutile
- Niveau de preuve : N1
- Source : Règlement (UE) 2016/679, art. 7 et art. 6 par. 1 — https://www.legislation.gov.uk/eur/2016/679/article/7/adopted ; https://www.legislation.gov.uk/eur/2016/679/article/6/adopted
- Extrait lu : art. 7 par. 2 : « the request for consent shall be presented in a manner which is clearly distinguishable from the other matters » ; art. 7 par. 3 : « It shall be as easy to withdraw as to give consent. » ; art. 7 par. 4 : « the performance of a contract, including the provision of a service, is conditional on consent » ; art. 6 par. 1 let. f : intérêt légitime, sauf si prévalent les droits de la personne, « in particular where the data subject is a child. »
- Portée / limites : ces articles fondent juridiquement l'interdiction des cases pré-cochées, du consentement noyé dans les CGU et du « newsletter obligatoire pour utiliser l'app ».
- En growth : se désinscrire demande-t-il plus d'étapes que s'inscrire ? Si oui, c'est contraire à l'art. 7 par. 3.

### France (CNIL) : en B2C, le consentement est préalable et la création d'un compte ne crée pas de relation client ; en B2B, l'opposition suffit si le message touche à la profession
- Niveau de preuve : N3 (doctrine de l'autorité de contrôle, sur la base de l'art. L34-5 CPCE)
- Source : CNIL, 10.06.2026, « La prospection commerciale par courrier électronique, SMS-MMS et automate d'appel », https://www.cnil.fr/fr/la-prospection-commerciale-par-courrier-electronique-sms-mms-et-automate-dappel
- Extrait lu : « les personnes aient donné leur consentement avant d'être démarchées » ; l'exception client ne joue pas « lorsqu'aucune vente ou prestation de service n'a été effectuée » ; « la simple création d'un compte ne signifie pas » ; en B2B : « en rapport avec la profession de la personne démarchée »
- Portée / limites : la CNIL interdit la case pré-cochée et rejette l'acceptation des CGU comme consentement. Selon un résumé de recherche (non vérifié mot pour mot), les adresses génériques (contact@) échappent à ces principes.
- En growth : une adresse prise à l'inscription gratuite **ne** permet **pas** la prospection sans consentement explicite, ni en France ni en Suisse (voir le PFPDT).

### France (CNIL) : un message transactionnel ou relationnel qui glisse de la promotion peut être requalifié en prospection et soumis au consentement
- Niveau de preuve : N3
- Source : CNIL, 10.06.2026, « Communications par voie électronique aux prospects et clients : quelles règles respecter ? », https://www.cnil.fr/fr/communication-electronique-quelles-regles
- Extrait lu : « il peut être requalifié en prospection commerciale et soumis aux règles correspondantes » ; « Ils ne doivent pas être utilisés pour dissimuler un contenu promotionnel. » ; les messages relationnels sont adressés « sans finalité promotionnelle directe » et reposent sur l'intérêt légitime « à condition que ces communications restent raisonnables »
- Portée / limites : la CNIL distingue trois catégories : prospection, transactionnel et relationnel. Exemple de relationnel : conseils d'utilisation, alertes de sécurité. Les séquences d'onboarding y entrent tant qu'elles ne contiennent pas d'offre commerciale directe.
- En growth : l'e-mail d'onboarding du jour 3 contient-il un bandeau « passez Premium -20 % » ? Si oui, il bascule dans la prospection.

### Allemagne : l'e-mail publicitaire exige un consentement préalable exprès ; le double opt-in n'est pas inscrit dans la loi, mais le BGH y voit une preuve suffisante en principe
- Niveau de preuve : N1 (UWG § 7) + N1 (jurisprudence de la Cour fédérale)
- Source : UWG § 7 al. 2 n° 2 et al. 3, copie lue sur dejure.org (gesetze-im-internet.de indisponible, HTTP 503) : https://dejure.org/gesetze/UWG/7.html ; BGH, 10.02.2011, I ZR 164/09 « Double-opt-in-Verfahren », copie WIPO Lex : https://www.wipo.int/wipolex/en/text/597213
- Extrait lu : UWG : « ohne dass eine vorherige ausdrückliche Einwilligung des Adressaten vorliegt » ; exception : « der Unternehmer die Adresse zur Direktwerbung für eigene ähnliche Waren oder Dienstleistungen verwendet » ; BGH Rn. 37 : « ist grundsätzlich hinreichend dokumentiert, dass er in E-Mail-Werbung » ; Rn. 38 : « Dafür trägt er allerdings die Darlegungslast. »
- Portée / limites : le texte de l'UWG ne restreint pas l'exigence aux consommateurs (il parle de « Adressat »). L'arrêt portait sur la publicité **téléphonique** ; il juge le double opt-in suffisant comme preuve pour l'e-mail, pas pour le téléphone. Le débat sur le premier e-mail de confirmation (OLG München) n'a été vu que dans un résumé de recherche (non vérifié).
- En growth : peut-on **prouver** chaque consentement (horodatage, IP, clic de confirmation) ? En Allemagne, c'est à l'annonceur d'apporter la preuve.

### UE : déclarer faussement qu'une offre n'est disponible que très peu de temps, ou harceler par e-mail, est une pratique commerciale déloyale en toutes circonstances
- Niveau de preuve : N1 (directive 2005/29/CE, annexe I, « liste noire »)
- Source : Directive 2005/29/CE, annexe I, points 7 et 26 — copie lue sur legislation.gov.uk : https://www.legislation.gov.uk/eudr/2005/29/annex/I
- Extrait lu : point 7 : « Falsely stating that a product will only be available for a very limited time » ; point 26 : « Making persistent and unwanted solicitations by telephone, fax, e-mail or other remote media »
- Portée / limites : vise les pratiques envers les **consommateurs**. Les modifications UE postérieures au 31.12.2020 (directive « Omnibus ») ne sont pas reflétées dans cette copie et n'ont pas été vérifiées.
- En growth : un compte à rebours qui repart à zéro à chaque visite tombe sous le point 7.

---

## 5. États-Unis et Canada

### CAN-SPAM (États-Unis) : objet non trompeur, publicité signalée, adresse postale valide, désinscription claire honorée sous 10 jours ouvrables, B2B inclus
- Niveau de preuve : N1 (loi fédérale ; guide d'application de la FTC)
- Source : FTC, août 2023, « CAN-SPAM Act: A Compliance Guide for Business », https://www.ftc.gov/business-guidance/resources/can-spam-act-compliance-guide-business
- Extrait lu : « The subject line must accurately reflect the content of the message. » ; « Your message must include your valid physical postal address. » ; « You must honor a recipient's opt-out request within 10 business days. » ; « The law makes no exception for business-to-business email » ; « Each separate email in violation of the law is subject to penalties of up to $53,088. »
- Portée / limites : CAN-SPAM est un régime d'**opt-out**, sans consentement préalable. Le montant de l'amende est indexé ; la page signale une mise à jour de janvier 2024 non lue. Selon la FTC, la catégorie « transactionnel » s'interprète étroitement.
- En growth : le pied de page porte-t-il une adresse postale valide ? C'est une contrainte pratique pour un indépendant qui ne veut pas publier son domicile.

### CASL (Canada) : consentement exprès ou tacite préalable, identification complète et désabonnement traité sous 10 jours ouvrables ; le consentement tacite expire
- Niveau de preuve : N3 (guide gouvernemental qui expose la loi)
- Source : ISDE Canada, modifié le 01.04.2019, « Getting consent to send email », https://ised-isde.canada.ca/site/canada-anti-spam-legislation/en/getting-consent-send-email
- Extrait lu : « Express consent means someone has agreed (verbally or in writing) to receive a commercial electronic message from you. » ; « Their implied consent may be valid for up to 2 years—or just 6 months in the case of inquiries or applications. » ; « every unsubscribe request must be actioned within 10 business days or less »
- Portée / limites : page de 2019. Le texte de loi lui-même n'a pas été ouvert. Selon un résumé de recherche (décisions du CRTC, non ouvertes), la charge de la preuve du consentement pèse sur l'expéditeur.
- En growth : les contacts canadiens « tacites » sont-ils datés pour être purgés à 6 mois ou à 2 ans ?

### COPPA (États-Unis, moins de 13 ans) : depuis la révision de 2025, divulguer des données d'enfants à des tiers, notamment pour la publicité ciblée, exige un consentement parental vérifiable distinct
- Niveau de preuve : N1 (règle de la FTC, 16 CFR Part 312)
- Source : FTC, communiqué du 16.01.2025, « FTC Finalizes Changes to Children's Privacy Rule Limiting Companies' Ability to Monetize Kids' Data », https://www.ftc.gov/news-events/news/press-releases/2025/01/ftc-finalizes-changes-childrens-privacy-rule-limiting-companies-ability-monetize-kids-data
- Extrait lu : « separate verifiable parental consent to disclose children's personal information to third-party companies » ; entrée en vigueur « 60 days after its publication in the Federal Register » et « one year from that publication date to come into full compliance »
- Portée / limites : la page du Federal Register n'a pas pu être ouverte (redirection anti-robot). Les dates de publication (22.04.2025), d'entrée en vigueur (23.06.2025) et de mise en conformité (22.04.2026) viennent d'un résumé de recherche et restent **non vérifiées** sur la source primaire.
- En growth : une application qui peut attirer des moins de 13 ans aux États-Unis n'envoie pas d'audience à un réseau publicitaire sans ce consentement distinct.

---

## 6. Séquences de cycle de vie : ce qui est mesuré

### Ajouter le prénom du destinataire dans l'objet a augmenté ouvertures et leads et réduit les désabonnements dans des expériences de terrain randomisées
- Niveau de preuve : N2 (Marketing Science, expériences de terrain sur des millions de destinataires, trois entreprises) — **résumé seul lu**
- Source : Sahni N. S., Wheeler S. C., Chintagunta P., 2018, « Personalization in Email Marketing: The Role of Noninformative Advertising Content », Marketing Science 37(2), 236-258, https://ideas.repec.org/a/inm/ormksc/v37y2018i2p236-258.html
- Extrait lu : « increased the probability of the recipient opening it by 20% » (de 9,05 % à 10,80 %) ; d'après le résumé, leads +31 % (de 0,39 % à 0,51 %) et désabonnements -17 % (de 1,2 % à 1,0 %)
- Portée / limites : les données précèdent MPP (2018), donc l'ouverture y était encore mesurable. L'effet est **relatif** (+1,75 point d'ouverture). Le résumé ne dit rien de l'usure de l'effet à force de répétition. Le texte intégral n'a pas été lu.
- En growth : la personnalisation par prénom vaut un test, jugé au clic ou au lead, pas à l'ouverture.

### Un deuxième e-mail apporte un gain de rétention, mais l'effet s'use (fatigue) et peut réduire le profit selon le segment
- Niveau de preuve : N2 (expérience de terrain, revue à comité de lecture, un seul secteur)
- Source : Wang Y., Lu L. X., Shi P., 2022, « Does Customer Email Engagement Improve Profitability? Evidence from a Field Experiment in Subscription Service Retailing », Manufacturing & Service Operations Management 24(5), 2703-2721, https://ideas.repec.org/a/inm/ormsom/v24y2022i5p2703-2721.html
- Extrait lu : « increased the likelihood of subscriber retention by 7.4% five months after the experiment started » ; « the engagement effect decays over time and exhibits fatigue after the second email » ; « but decreases profit when deployed on mid-level frequent-use subscribers and basic-level subscribers »
- Portée / limites : une chaîne de lavage auto par abonnement aux États-Unis. Le critère mesuré est le churn, pas le désabonnement. Un seul contexte.
- En growth : la séquence a-t-elle un groupe témoin ? Ajouter un e-mail peut coûter plus qu'il ne rapporte sur certains segments.

### Un e-mail de bienvenue randomisé n'a pas changé l'activation mais a amélioré la rétention, surtout sur mobile (une seule expérience, analyses de sous-groupes ajoutées en cours)
- Niveau de preuve : N2 (expérience randomisée avec témoin de 20 %, 22 633 comptes ; rapport public non revu par des pairs)
- Source : Wikimedia Foundation (Growth team), 2022, « Welcome emails experiment, September 2022 », https://www.mediawiki.org/wiki/Growth/Personalized_first_day/Newcomer_experience_marketing_pilot/Welcome_emails_experiment,_September_2022
- Extrait lu : « 20% of the accounts (4,474 users) were randomly assigned to the Control group and were not eligible to receive emails » ; activation 19,9 % contre 19,8 % (fenêtre courte) ; rétention 7,9 % contre 6,5 % (fenêtre longue)
- Portée / limites : Wikipédia en espagnol, contribution bénévole et non commerciale. Ni p-values ni intervalles publiés. Analyse par plateforme ajoutée après une revue à mi-parcours.
- En growth : mesurer l'onboarding par e-mail sur la **rétention** à plusieurs semaines contre un groupe témoin, pas sur l'activation immédiate seule.

### Aucune étude revue par des pairs trouvée qui établisse un « meilleur moment d'envoi » général : les travaux trouvés testent l'heure liste par liste
- Niveau de preuve : N2 faible (article académique sur la méthode du test A/B, marché croate B2C) — **résumé seul lu**
- Source : Biloš A., Turkalj D., Kelić I., 2016, « Open-Rate Controlled Experiment in E-Mail Marketing Campaigns », Tržište/Market 28(1), 93-109, https://hrcak.srce.hr/en/160384
- Extrait lu : « subscriber behavior towards several newsletter components, including sending time » ; « several apparent limitations (the data-set scope, comparability issues) indicated a clear need » for standardization
- Portée / limites : l'étude mesure l'ouverture, ce que MPP fausse aujourd'hui. Le résumé ne donne aucune heure gagnante générale. Les autres résultats de recherche étaient des blogs d'éditeurs et des brevets (non retenus).
- En growth : un « mardi 10 h » tiré d'un benchmark n'est pas une preuve. Tester l'heure sur sa liste, jugée au clic ou au revenu.

### Les données sur la longueur de l'objet se contredisent : une analyse d'éditeur favorise 6 à 10 mots, d'autres ne trouvent aucune corrélation
- Niveau de preuve : N4 (analyse d'un éditeur rapportée par la presse spécialisée)
- Source : Martech (Marketing Land), 27.02.2014, « Study: Keep Subject Lines At 6 To 10 Words Or Try A Song Lyric To Lift Email Open Rates » (étude Retention Science), https://martech.org/study-email-marketing-subject-lines-6-10-words-deliver-highest-open-rates/
- Extrait lu : « more than 260 million emails across 540 retail email marketing campaigns » ; « email subject lines kept at 6 to 10 words resulted in a 21 percent open rate »
- Portée / limites : corrélation sans expérience, en 2014, avant MPP, sur du commerce de détail. L'étude Return Path de 2015 (aucune corrélation) n'a été vue que dans des résumés de recherche ; sa source n'a pas été ouverte (404).
- En growth : écrire pour l'aperçu mobile (les premiers mots portent le message) plutôt que viser une longueur « optimale ».

---

## 7. Accessibilité des e-mails

### Un e-mail accessible porte du texte réel (pas d'images de texte), des textes alternatifs, des liens explicites, un contraste de 4,5:1 et une langue déclarée
- Niveau de preuve : N3 (guide officiel du gouvernement américain ; WCAG appliquées par analogie)
- Source : GSA / Section508.gov, revu en septembre 2024, « Checklist for Accessible Email Messages », https://www.section508.gov/test/checklist/email-messages/ ; W3C, « Understanding SC 3.1.1 Language of Page » (WCAG 2.2), https://www.w3.org/WAI/WCAG22/Understanding/language-of-page.html ; Litmus (K. Voigt, d'après A. Li), 07.05.2025, « Email Marketer's Guide to Coding for Accessibility », https://www.litmus.com/blog/7-simple-tricks-to-make-your-email-code-more-accessible
- Extrait lu : Section508 : « Email message does not contain images of text and content copied from another source as an image. » ; « Email message uses unique and descriptive links and hypertext instead of vague terms like "click here" or "read more." » ; « Ensure that normal-sized text and images of text on a background have a 4.5:1 contrast ratio. » ; WCAG : « The default human language of each web page can be programmatically determined. » ; Litmus : « If there's no language code specified in your emails, screen readers can't pronounce the copy correctly » ; « adding role=presentation to your tables »
- Portée / limites : la liste Section508 vise les e-mails des agences fédérales américaines. Les WCAG portent sur les pages web, pas sur l'e-mail. Litmus est un éditeur. Certains clients de messagerie retirent l'attribut `lang` (résumé de recherche, non vérifié).
- En growth : un e-mail fait d'une seule image (bandeau promo) échoue à la fois en accessibilité et en délivrabilité. Le code HTML de chaque gabarit déclare-t-il `lang` ?

---

## Verdict sur les règles du profil

**1. « Métrique de succès déclarée avant publication (taux de conversion visite→install, open rate, réponse). »**
- Déclarer la métrique **avant** publication : **soutenue** (bonne pratique de test) ; aucune source lue ne la contredit.
- Open rate comme métrique de succès : **contredite**.
  - Apple MPP charge le contenu « regardless of whether you engage with the email ».
  - Apple Mail pèse 76,56 % des ouvertures chez Litmus (septembre 2026), qui juge ces ouvertures « not considered reliable ».
  - Mailchimp déclare les tests A/B sur l'ouverture non fiables.
  - En France, depuis le 14.04.2026, mesurer l'ouverture pour optimiser une campagne exige un consentement au pixel (CNIL).
  - Zhang, Kumar & Cosguner (2017, résumé seul lu) jugent les métriques de réponse « short-sighted ».
- Formulation proposée : « Métrique de succès déclarée avant publication : clic, conversion ou revenu par destinataire, rétention contre groupe témoin, désabonnements, taux de plaintes (Postmaster < 0,1 %). L'open rate ne sert que d'indicateur de délivrabilité, jamais de critère de succès ni de test A/B. »

**2. « Zéro dark pattern (urgence factice, opt-out caché, consentement forcé). »**
- **Soutenue**, et appuyée par du droit opposable. L'expression « dark pattern » ne figure dans aucun des textes lus, mais les trois exemples y correspondent :
  - **Urgence factice** : LCD art. 3 al. 1 let. b (« stocks », « prix ») et directive 2005/29 annexe I point 7.
  - **Opt-out caché** : LCD let. o (« gratuitement et facilement »), ePrivacy art. 13 par. 2 et 4, RGPD art. 7 par. 3, Gmail et RFC 8058 (clic unique), Yahoo (2 jours).
  - **Consentement forcé** : RGPD art. 7 par. 4, nLPD art. 6 al. 6, CNIL et PFPDT (CGU insuffisantes, case pré-cochée interdite).
- À compléter : « promotion déguisée en e-mail transactionnel ou relationnel » (requalification, CNIL) et « relances persistantes » (directive 2005/29, point 26).

**3. « Sensibilité légale : sujets enfants/données personnelles → messaging aligné Data Safety / COPPA / RGPD. »**
- **Soutenue mais incomplète** pour un indépendant établi en Suisse. Il manque :
  - **LCD art. 3 al. 1 let. o** : opt-in par défaut pour tout envoi de masse, sans distinction B2B dans le texte, avec émetteur nommé et opposition gratuite. Sanction pénale sur plainte (art. 23 LCD).
  - **Exception client suisse** : une vente réelle est requise, et selon le PFPDT un compte en ligne ne suffit pas. Même position à la CNIL.
  - **nLPD art. 19** : information à la collecte, y compris le pays de l'ESP (art. 19 al. 4). Amende personnelle jusqu'à 250 000 francs (art. 60). Consentement exprès pour le profilage à risque élevé (art. 6 al. 7).
  - **ePrivacy art. 13** et ses transpositions nationales (UWG § 7 en Allemagne : consentement exprès et preuve à la charge de l'annonceur ; CNIL en France). **RGPD art. 21** : opposition au marketing, profilage compris.
  - **CNIL** : consentement au pixel de suivi (2026).
  - **Délivrabilité** (Gmail, Yahoo, Outlook) : pas une obligation légale, mais une condition d'existence de la séquence.
  - **CAN-SPAM** (adresse postale, 10 jours ouvrables) et **CASL** (opt-in, expiration du consentement tacite).
  - **COPPA** : révision 2025, consentement parental distinct pour la divulgation à des tiers ; dates non vérifiées sur la source primaire.
  - « Data Safety » (Google Play) n'a pas été examiné dans cette recherche.
- Rappel : l'agent repère le risque et renvoie à un juriste. Il ne qualifie pas le cas lui-même.

---

## Mythes et affirmations contestées

- **« Le taux d'ouverture mesure l'intérêt. »** Contredit depuis MPP (Apple, Mailchimp, Litmus). En France, il n'est même plus collectable sans consentement au pixel (CNIL, 2026).
- **« Un utilisateur inscrit à mon application gratuite est un client : soft opt-in. »** Contredit par le PFPDT (« Es genügt nicht, lediglich ein Onlinekonto eröffnet zu haben ») et par la CNIL (« la simple création d'un compte ne signifie pas »). La LCD parle de « vente ».
- **« En B2B, pas de règles. »** Contredit. CAN-SPAM : « no exception for business-to-business email ». La LCD let. o ne distingue pas. L'UWG § 7 vise l'« Adressat ». Seule la CNIL admet un opt-out en B2B, sous conditions.
- **« Le double opt-in est obligatoire en Allemagne. »** Nuance. La loi exige une « vorherige ausdrückliche Einwilligung ». Le BGH (I ZR 164/09) reconnaît le double opt-in comme preuve suffisante en principe, sans l'imposer comme forme légale. En pratique, c'est le moyen de preuve reconnu.
- **« Il existe une meilleure heure d'envoi. »** Aucune étude revue par des pairs trouvée qui établisse une heure générale. Les « benchmarks » d'éditeurs ne sont pas des preuves causales.
- **« Un objet court ouvre mieux. »** Données d'éditeurs contradictoires (6 à 10 mots chez Retention Science ; aucune corrélation selon d'autres résumés), toutes mesurées à l'ouverture et datées d'avant MPP.
- **« Le prénom dans l'objet augmente l'ouverture de 20 %. »** Exact dans Sahni et al. (2018), mais en valeur **relative** (+1,75 point), dans des contextes précis, avant MPP. Le résultat plus solide pour le growth : leads +31 % et désabonnements -17 %.
- **« Plus d'e-mails = plus de revenus. »** Contredit par Wang et al. (fatigue après le 2e e-mail, profit négatif sur certains segments) et nuancé par Zhang et al. (un optimum par client, résumé seul lu).
- **« DMARC est une RFC informationnelle. »** Dépassé : la RFC 9989 (Proposed Standard, 2026) rend la RFC 7489 obsolète.
- **« Le seuil des 5 000 e-mails est quotidien et réversible. »** Contredit par la FAQ Gmail : le statut d'expéditeur de masse reste acquis une fois le seuil atteint.

---

## Non vérifié

- **Position du SECO** sur la LCD let. o : aucune page du SECO sur l'e-mail trouvée (seulement sur les appels publicitaires). Rôle exact du SECO et du PFPDT dans la poursuite du spam : non vérifié.
- **Seuil chiffré de la « publicité de masse »** en droit suisse : aucune source officielle lue n'en donne. Un résumé de recherche dit « au cas par cas », sans source primaire ouverte.
- **Application de la LCD let. o au B2B** : le texte ne distingue pas, mais aucune position officielle ou jurisprudence suisse n'a été lue.
- **Texte d'EUR-Lex** : inaccessible à l'outil de lecture. Directives et RGPD lus sur legislation.gov.uk. Les modifications UE après le 31.12.2020 (directive 2005/29 révisée par la directive « Omnibus ») n'ont pas été vérifiées.
- **Considérant 47 du RGPD** (marketing direct et intérêt légitime) : non lu.
- **Résumé et texte intégral de Zhang, Kumar & Cosguner (2017)** : non lus (HTTP 503) ; seul le résumé AMA l'a été. **Kumar, Zhang & Luo (2014, JMR)** sur l'opt-in et l'opt-out : non lu (HTTP 403).
- **Texte intégral de Sahni et al. (2018)** : non lu ; seul le résumé l'a été.
- **Origine du chiffre « 55 à 60 % des ouvertures affectées par MPP »** : Litmus cite des « studies » non nommées.
- **Étude Return Path (2015) sur la longueur de l'objet** : seulement vue dans des résumés de recherche, source introuvable (404).
- **Dates du Federal Register pour COPPA** (22.04.2025, 23.06.2025, 22.04.2026) : la page primaire n'a pas été ouverte.
- **Mois de publication de la RFC 9989** et détail de la suppression de `pct` : non lus.
- **Rejets Outlook (550 5.7.515)** : date « to be announced » dans la source. Aucune mise à jour postérieure à avril 2025 vérifiée.
- **Position de l'OLG München** sur le premier e-mail de confirmation du double opt-in : non vérifiée.
- **Montant actualisé des amendes CAN-SPAM** après la mise à jour de janvier 2024 : non lu.
- **Retrait de l'attribut `lang` par certains clients de messagerie** : non vérifié.
- **Exigences « Data Safety » de Google Play** : hors du champ de cette recherche.

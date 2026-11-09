# Fiche `ux-preuves` — Growth — ASO et fiches de store

> Fiche du skill `ux-preuves` (dev-fullstack), volet **growth**, préchargé par `growth`. Couvre : limites et politiques de métadonnées Google Play et App Store (titre Play à 30 caractères), expérimentation sur les fiches, ce qui convertit, notes et demandes d'avis, localisation, Data safety et App Privacy, applications pour enfants, mots-clés.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Verdict sur les règles
> du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées : ce qui y
> figure ne se cite pas comme un fait. Le droit y est rapporté, pas appliqué : son application à
> un produit précis relève d'un juriste.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Recherche du 09.11.2026. Toutes les pages ci-dessous ont été **réellement ouvertes** le 09.11.2026 (texte brut récupéré et cité depuis la page, pas depuis un résumé). Quand seul un résumé ou un abstract a été lu, c'est dit. Les pages d'aide Google et Apple ne portent en général **pas de date de version** : « consulté le 09.11.2026 » vaut date. Le texte des App Store Review Guidelines porte la mention « Last Updated: October 16, 2026 ».

Niveaux de preuve : N1 règle opposable (politique de store, loi) · N2 recherche revue par pairs ou étude empirique à large échantillon · N3 guideline officielle non contraignante (ou documentation produit) · N4 avis d'expert, article de praticien, étude de cas d'éditeur.

---

## 1. Limites de caractères et règles de métadonnées — Google Play

### Le titre Google Play est limité à 30 caractères, une valeur par langue
- Niveau de preuve : N1
- Source : Google, Play Console Help, consulté 2026, « Metadata » (politique) et « Create and set up your app », https://support.google.com/googleplay/android-developer/answer/9898842?hl=en et https://support.google.com/googleplay/android-developer/answer/9859152?hl=en
- Extrait lu : « Your app title must be 30 characters or less. » (politique) ; tableau de la page de configuration : « App name … 30 … You can add one localized name per language. »
- Portée / limites : la limite vaut pour le nom par défaut et pour chaque traduction ; « Character limits apply to both full-width and half-width characters. » Origine : pré-annonce Google du 29.04.2021 (Bert de Weerd et Tingmui Li, « Updated guidance to improve your app quality and discovery on Google Play », https://android-developers.googleblog.com/2021/04/updated-guidance-to-improve-your-app.html, lue : « Limiting the length of app titles to 30 characters »). Ce billet renvoie la date d'application à « later this year » sans la donner (voir § Non vérifié).
- En growth : tout titre de plus de 30 caractères est refusé, dans chaque langue. Vérifier la longueur **après** traduction (l'allemand déborde). Quand un document interne cite une autre limite (50, 60), demander de quelle année il date.

### Description courte ≤ 80 caractères, description complète ≤ 4 000 caractères
- Niveau de preuve : N1
- Source : Google, Play Console Help, consulté 2026, « Create and set up your app », https://support.google.com/googleplay/android-developer/answer/9859152?hl=en
- Extrait lu : « Short description … 80 … Users can expand this text to view your app's full description. » ; « Full description … 4,000 » ; « Character limits apply to both full-width and half-width characters. »
- Portée / limites : la même page avertit : « Repetitive or irrelevant keyword usage in your app name, short description, or full description can create an unpleasant user experience and result in app suspension. » La limite du **nom de développeur** n'est donnée nulle part dans les pages lues.
- En growth : les 4 000 caractères sont un plafond, pas un objectif : la politique sanctionne aussi la longueur excessive (entrée « succinct »).

### Titre, icône et nom de développeur : pas d'emoji, pas de MAJUSCULES hors marque, pas de classement, de prix, de promo ni de programme Google Play
- Niveau de preuve : N1
- Source : Google, Play Console Help, consulté 2026, « Metadata », https://support.google.com/googleplay/android-developer/answer/9898842?hl=en
- Extrait lu : « Don't use emojis, emoticons, or repeated special characters in these metadata elements. Avoid ALL CAPS unless it is part of your brand name. » ; « Don't use text or image in the app title, icon, or developer name that indicate store performance or ranking, price or promotional information, or that suggests relations to existing Google Play programs. » ; exemples : « 'App of the year,' '#1,' 'Best of Play 20XX,' 'Popular,' award icons » ; « '10% off,' '$50 cash back,' 'free for limited time only' » ; « 'Editor's choice,' 'New,' etc. »
- Portée / limites : l'interdiction du classement porte sur **titre, icône, nom de développeur**, que la mention soit vraie ou non. La page « Best practices for your store listing » étend ces exemples à toute la fiche et précise : « Words like "Free" and "No Ads" promote deals and don't belong in app titles or developer names. » (https://support.google.com/googleplay/android-developer/answer/13393723?hl=en)
- En growth : « Gratuit », « Sans pub », « N°1 », « Nouveau », « Choix de la rédaction » ne vont **jamais** dans le titre, l'icône ou le nom du développeur sur Play, même si c'est vrai.

### Description : pas de témoignage anonyme, pas de comparatif chiffré d'apps ou de marques, pas de référence trompeuse à une autre app
- Niveau de preuve : N1
- Source : Google, Play Console Help, consulté 2026, « Metadata » et « Best practices for your store listing », https://support.google.com/googleplay/android-developer/answer/9898842?hl=en et https://support.google.com/googleplay/android-developer/answer/13393723?hl=en
- Extrait lu : « We also don't allow unattributed or anonymous user testimonials in the app's description. » ; parmi les « Examples of common violations » : « Data comparison of apps or brands » ; « Don't include misleading or irrelevant references to other apps or products. » ; « Don't use a celebrity's name or a brand's logo without permission. »
- Portée / limites : la page « Best practices » demande « an attributed or clear source for any endorsements or quotes ». Elle précise : « Remember that the Metadata policy and our other policies apply to all translations of your Google Play store listing. »
- En growth : chaque citation d'utilisateur doit être attribuée ; aucun tableau « nous contre l'app X » dans la fiche.

### Description : succincte, sans répétition ni liste de mots-clés ; l'excès est lui-même une violation
- Niveau de preuve : N1
- Source : Google, Play Console Help, consulté 2026, « Metadata » et « Best practices for your store listing », https://support.google.com/googleplay/android-developer/answer/9898842?hl=en et https://support.google.com/googleplay/android-developer/answer/13393723?hl=en
- Extrait lu : « Excessive length, detail, improper formatting, or repetition can result in a violation of this policy. » ; contre-exemple donné par Google : « "Car racing, car driving, race cars, car races, race track, driving, drive, race, cars, vehicles, automobiles, trucks" » ; « Don't repeat your short description in your full description. »
- Portée / limites : Google ne publie aucun seuil (nombre de répétitions, densité) ; l'appréciation est celle de l'examen.
- En growth : chercher dans la description les blocs de mots-clés, les listes verticales, les répétitions de la description courte.

### Description courte : pas d'appel à l'action, pas de mots-clés ajoutés pour la recherche (« it will not impact ranking »)
- Niveau de preuve : N3 (section « Highly recommended » ; le non-respect n'affecte pas la fiche mais l'éligibilité aux recommandations)
- Source : Google, Play Console Help, consulté 2026, « Add preview assets to showcase your app », https://support.google.com/googleplay/android-developer/answer/9866151?hl=en
- Extrait lu : « Call-to-actions, for example, "download now," "install now," "play now," or "try now." » ; « Unnecessary keywords in an attempt to improve search results; it will not impact ranking and provides a bad user experience. » ; « Do not include special characters, line breaks, emojis, emoticons, repeated punctuation … or symbols (for example, ★ or ☆). »
- Portée / limites : la page précise : « Failure to comply with these guidelines will not impact your store listing page, but may result in changes to how your preview assets appear on Google Play or limit promotional opportunities. » Elle demande aussi d'éviter « time-sensitive copy ».
- En growth : une description courte qui commence par « Téléchargez maintenant » ou empile des mots-clés coûte de la visibilité sans rien rapporter en classement.

### Captures Play : jusqu'à 8 par type d'appareil ; pour les recommandations, au moins 4 captures ≥ 1080 px, l'interface dans les 3 premières, sans « Best », « #1 », « Top »
- Niveau de preuve : N3 (les seuils sont des conditions d'éligibilité aux formats recommandés ; le minimum de publication est N1)
- Source : Google, Play Console Help, consulté 2026, « Add preview assets to showcase your app », https://support.google.com/googleplay/android-developer/answer/9866151?hl=en
- Extrait lu : « You can add up to 8 screenshots for each supported device type. » ; « For apps, you must provide at least four screenshots with minimum 1080px resolution. » ; « prioritize UI in the first three screenshots as much as possible. » ; « do not use words like "Best," "#1," "Top," "New," "Discount," "Sale," or "Million Downloads." » ; « You must provide a minimum of two screenshots across different device types to publish your store listing »
- Portée / limites : les règles d'écran Wear OS interdisent cadres d'appareil et texte ajouté ; pour téléphone, Google recommande seulement d'éviter le texte en petite police. Le texte alternatif (≤ 140 caractères) est recommandé pour chaque capture.
- En growth : les trois premières captures doivent montrer l'interface réelle ; les accroches en surimpression doivent être localisées.

### Vidéo Play : une seule URL YouTube, monétisation désactivée, lecture automatique muette jusqu'à 30 s
- Niveau de preuve : N1 (conditions d'affichage) / N3 (recommandations)
- Source : Google, Play Console Help, consulté 2026, « Add preview assets to showcase your app », https://support.google.com/googleplay/android-developer/answer/9866151?hl=en
- Extrait lu : « You can add one preview video to your store listing by entering a YouTube URL » ; « Disable ads for your video to be shown on Google Play. » ; « Your preview video may autoplay inline with muted audio up to 30 seconds depending on the user device »
- Portée / limites : la vidéo est fortement recommandée pour les jeux, pas exigée pour les apps.
- En growth : les 30 premières secondes doivent se comprendre **sans le son** ; une vidéo monétisée ne s'affiche pas.

## 2. Limites de caractères et règles de métadonnées — App Store

### App Store : nom ≤ 30 caractères (au moins 2), sous-titre ≤ 30 caractères
- Niveau de preuve : N1
- Source : Apple, App Store Connect Help, consulté 2026, « App information », https://developer.apple.com/help/app-store-connect/reference/app-information/app-information
- Extrait lu : « The name must be at least two characters and no more than 30 characters. » ; « Subtitle … This can't be longer than 30 characters. »
- Portée / limites : la guideline 2.3.7 le répète : « App names must be limited to 30 characters. »
- En growth : sur iOS, le sous-titre porte la proposition de valeur ; Apple conseille d'éviter « generic descriptions such as "world's best app." » (https://developer.apple.com/app-store/product-page/).

### App Store : mots-clés ≤ 100 octets, sans répéter le nom, l'éditeur ni la catégorie, sans noms d'autres apps ou sociétés
- Niveau de preuve : N1 (App Store Connect) et N3 (guide de recherche)
- Source : Apple, App Store Connect Help, consulté 2026, « Platform version information », https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information ; Apple, consulté 2026, « App Store search », https://developer.apple.com/app-store/search/
- Extrait lu : « You can provide up to 100 bytes of content. Your app is searchable by app name and company name, so you shouldn't duplicate these values in the keyword list. Names of other apps or companies aren't allowed. » ; guide de recherche : « Keywords are limited to 100 characters total, with terms separated by commas and no spaces. » ; « Plurals of words you've already included, such as "climbs" and "climb," as these are considered duplicates. »
- Portée / limites : les deux pages Apple divergent (« bytes » contre « characters »). Inférence non vérifiée : en UTF-8, une lettre accentuée française occupe 2 octets, et le plafond réel serait donc plus bas. Chaque mot-clé doit faire plus de deux caractères (« each greater than two characters »).
- En growth : mesurer le champ en octets, virgules sans espace, aucun mot déjà présent dans le nom, le sous-titre ou la catégorie, aucun nom de concurrent.

### App Store : texte promotionnel ≤ 170 caractères (modifiable sans soumission, sans effet sur le classement) ; description et « What's New » ≤ 4 000 caractères
- Niveau de preuve : N1 (limites) / N3 (effet sur la recherche)
- Source : Apple, App Store Connect Help, consulté 2026, « Platform version information », https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information ; Apple, « App Store search », https://developer.apple.com/app-store/search/
- Extrait lu : « This property can't be longer than 170 characters. » ; « Limited to 4000 characters. The description should be in plain text » ; « keep in mind that promotional text doesn't affect your app's search ranking so it should not be used to display keywords. »
- Portée / limites : la description ne se modifie qu'avec une nouvelle version ; le texte promotionnel à tout moment.
- En growth : le texte promotionnel sert à l'actualité (offre, nouveauté), jamais aux mots-clés.

### Guideline 2.3.7 : pas de marques déposées, de noms d'apps populaires, de prix ni d'affirmation invérifiable dans le nom, le sous-titre ou les mots-clés
- Niveau de preuve : N1
- Source : Apple, App Store Review Guidelines (Last Updated: October 16, 2026), § 2.3.7, https://developer.apple.com/app-store/review/guidelines/
- Extrait lu : « don't try to pack any of your metadata with trademarked terms, popular app names, pricing information, or other irrelevant phrases just to game the system. » ; les sous-titres « should not include inappropriate content, reference other apps, or make unverifiable product claims. »
- Portée / limites : « Apple may modify inappropriate keywords at any time ». La 2.3.14 (« creative assets ») étend l'interdiction aux visuels : « unverifiable product claims, or specific or discounted pricing information ».
- Guidance associée (N3), « Creating your product page », https://developer.apple.com/app-store/product-page/ : « If you choose to mention an accolade, we recommend putting it at the end of your description or as part of your promotional text. » ; « avoid including specific prices in your app description. » Apple tolère donc une distinction **réelle** en fin de description, là où Google interdit tout signe de récompense dans le titre, l'icône et le nom du développeur.
- En growth : tout superlatif du sous-titre doit pouvoir être prouvé, sinon il disparaît ; aucun nom de concurrent. « Élue app du mois par X » peut figurer en fin de description iOS, jamais dans le titre ni dans l'icône Play.

### Guidelines 2.3, 2.3.1, 2.3.3, 2.3.4, 2.3.12 : les métadonnées, y compris la confidentialité, reflètent l'app réelle ; les captures montrent l'app en usage ; les nouveautés notables sont listées
- Niveau de preuve : N1
- Source : Apple, App Store Review Guidelines (Last Updated: October 16, 2026), § 2.3 à 2.3.12, https://developer.apple.com/app-store/review/guidelines/
- Extrait lu : 2.3 : « make sure all your app metadata, including privacy information, your app description, screenshots, and previews accurately reflect the app's core experience » ; 2.3.1(a) : « marketing your app in a misleading way … is grounds for removal » ; 2.3.3 : « Screenshots should show the app in use, and not merely the title art, login page, or splash screen. » ; 2.3.4 : « previews may only use video screen captures of the app itself. » ; 2.3.12 : « more significant changes must be listed in the notes. »
- Portée / limites : 2.3.2 exige aussi d'indiquer clairement ce qui demande un achat intégré.
- En growth : la promesse marketing qui précède la fonctionnalité réelle est un motif de retrait ; les notes de version doivent nommer les changements notables.

## 3. Expérimentation sur les fiches

### Google Play : une expérience « default graphics » ou jusqu'à cinq expériences localisées en même temps, jusqu'à 2 variantes, arrêt automatique au bout de 6 mois
- Niveau de preuve : N3 (documentation produit)
- Source : Google, Play Console Help, consulté 2026, « Run A/B tests on your store listing », https://support.google.com/googleplay/android-developer/answer/6227309?hl=en
- Extrait lu : « For each app, you can run one default graphics experiment or up to five localized experiments at the same time. » ; « (you can choose up to 2 variants) » ; « Store listing experiments stop automatically after running for 6 months. »
- Portée / limites : une expérience « default graphics » teste l'icône, la bannière (feature graphic) et les captures, dans la langue par défaut. Une expérience localisée teste aussi les descriptions, dans au plus cinq langues. Le titre n'est pas cité parmi les éléments testables. Les métriques cibles : « Unique user install clicks, Unique user open clicks or Unique user pre-registration clicks ». L'expérience se règle par l'effet minimal détectable et le niveau de confiance ; un écart sous ce seuil donne « a draw ».
- Bonnes pratiques Google (N3), lues sur https://google.play/business/store-listing-experiments/ (URL d'arrivée après redirection depuis developer.android.com/distribute/best-practices/grow/store-listing-experiments) : « Get the clearest results by testing a single asset at a time » ; « Test for at least a week to account for weekday vs weekend traffic patterns ». La même page affiche des études de cas d'éditeurs (« Kongregate increases installs by 45% »), sans méthode publiée (N4).
- En growth : fixer l'effet minimal détectable avant de lancer ; un seul élément par variante, une semaine au moins. Un « draw » est un résultat, pas un échec à relancer en boucle.

### Google Play : jusqu'à 50 fiches personnalisées, ciblées par pays, mots-clés de recherche, état de l'utilisateur, campagne Google Ads ou URL dédiée
- Niveau de preuve : N3
- Source : Google, Play Console Help, consulté 2026, « Create custom store listings to target specific user segments », https://support.google.com/googleplay/android-developer/answer/9867158?hl=en
- Extrait lu : « You can create up to 50 custom store listing pages. » ; segments : « Churned users », « Lapsed users », « Country/Region », « Pre-registration », « Search keywords », « Custom audiences », « Ads traffic » ; « For each custom store listing, you can customize your app's name, icon, descriptions, and graphic assets. Your app's contact details, privacy policy, and app category are shared across all versions »
- Portée / limites : un pays ne peut être ciblé que par une fiche à la fois. Les fiches personnalisées restent soumises aux mêmes politiques.
- En growth : aligner la fiche sur la promesse de la campagne (exemple 4 de la page : fiche par groupe d'annonces Google Ads) plutôt que d'envoyer tout le trafic payant vers la fiche par défaut.

### Apple, optimisation de la page produit : jusqu'à 3 variantes (icône, captures, vidéos), un test à la fois, 90 jours au plus, métadonnées approuvées par l'examen
- Niveau de preuve : N3
- Source : Apple, consulté 2026, « Product page optimization », https://developer.apple.com/app-store/product-page-optimization/
- Extrait lu : « A test can include up to three treatments with alternate app icons, screenshots, and app previews. » ; « You can create one test at a time which will run for up to 90 days. Keep in mind that you cannot change a test once it's started. » ; « We recommend waiting … until at least one treatment has been declared to be performing better or worse than the baseline with at least 90% confidence. »
- Portée / limites : on n'y teste ni le nom, ni le sous-titre, ni la description. Une icône alternative doit être livrée dans le binaire. Le test ne touche que iOS/iPadOS 15 ou plus.
- En growth : la copy (nom, sous-titre) ne se teste pas en A/B natif sur iOS : il faut des hypothèses de copy testées ailleurs (Play, annonces) ou passer par les pages produit personnalisées.

### Apple : jusqu'à 70 pages produit personnalisées (captures, texte promotionnel, vidéos), avec URL, mots-clés et liens profonds propres
- Niveau de preuve : N3
- Source : Apple, consulté 2026, « Custom product pages », https://developer.apple.com/app-store/custom-product-pages/
- Extrait lu : « You can publish up to 70 additional versions of your product page on the App Store for iPhone and iPad. Vary the screenshots, promotional text, and/or app previews » ; « You can also assign keywords to your custom product page … each keyword combination is unique to a single product page. » ; « Deep links for custom product pages are supported in iOS 18 and iPadOS 18, or later. »
- Portée / limites : le nom, le sous-titre et la description ne varient pas d'une page personnalisée à l'autre.
- En growth : une page personnalisée par promesse d'acquisition (canal, segment), avec son lien profond vers l'écran promis.

## 4. Ce qui convertit sur une fiche (preuves publiées)

### Les études de cas publiées par les stores eux-mêmes sont choisies et sans méthode complète : elles montrent qu'il faut tester, pas quel élément gagne
- Niveau de preuve : N4 (études de cas d'éditeurs, sélectionnées par la plateforme)
- Source : Apple, consulté 2026, « Product page optimization » (encadrés « Developer story »), https://developer.apple.com/app-store/product-page-optimization/ ; Google Play Console, « Store listing experiments », https://google.play/business/store-listing-experiments/
- Extrait lu : Apple, cas d'une app de piano : « The original product page without an app preview video outperformed the treatment, contrary to the developer's hypothesis. » ; cas d'une app d'entraînement cérébral (test d'icônes, 44 jours, 3 variantes) : « Brain +8% » avec « >98% confidence ». Google : « Kongregate increases installs by 45% with store listing experiments »
- Portée / limites : l'encadré Apple sur la vidéo affiche aussi « Treatment +3% », en contradiction apparente avec sa phrase ; la page n'en dit pas plus. Aucune taille d'échantillon publiée. Aucun chiffre agrégé publié par Google ou Apple sur l'effet moyen des captures, des vidéos ou des icônes n'a été trouvé.
- En growth : « une vidéo augmente la conversion » est une hypothèse à tester, pas une règle ; Apple publie lui-même un contre-exemple.

### Étude empirique (Corée du Sud, 2012) : la demande d'une app croît avec la longueur de description et le nombre de captures
- Niveau de preuve : N2 (communication ICIS, conférence à comité de lecture ; données observationnelles)
- Source : Sang Pil Han et Anindya Ghose, 2012, « Estimating Demand for Applications in the New Mobile Economy », ICIS 2012 Proceedings, https://aisel.aisnet.org/icis2012/proceedings/DigitalInnovation/1 — résumé seul lu
- Extrait lu : « We use a panel dataset consisting of apps' sales, prices, and characteristics from Apple App Store and Google Play for 4 months in the South Korean market. Our results show demand increases with the file size, app age, description length, and number of screenshots. »
- Portée / limites : marché coréen, quatre mois, stores de 2012, avant les limites actuelles et les fiches enrichies. Un modèle structurel n'est pas une expérience. La version publiée (Ghose et Han, 2014, Management Science 60(6), 1470-1488, https://ideas.repec.org/a/inm/ormnsc/v60y2014i6p1470-1488.html, résumé seul lu) porte sur les États-Unis et ne mentionne dans son résumé ni la description ni les captures : l'achat intégré y augmente la demande, la publicité intégrée la réduit.
- En growth : utile pour dire que la complétude de la fiche compte ; inutilisable pour fixer une longueur ou un nombre de captures.

### Étude revue par les pairs (60 pays) : la sensibilité de la popularité d'une app aux notes et au prix varie fortement selon le pays
- Niveau de preuve : N2 (Journal of Marketing)
- Source : Raoul Kübler, Koen Pauwels, Gökhan Yildirim et Thomas Fandrich, 2018, « App Popularity: Where in the World Are Consumers Most Sensitive to Price and User Ratings? », Journal of Marketing 82(5), DOI 10.1509/jm.16.0140 ; résumé lu sur https://api.openalex.org/works/doi:10.1509/jm.16.0140 — résumé seul lu
- Extrait lu : « Estimated across 60 countries, a dynamic panel model with product-specific effects reveals that price sensitivity is higher in countries with higher masculinity and uncertainty avoidance. Ratings valence sensitivity is higher in countries with higher individualism and uncertainty avoidance »
- Portée / limites : effet de la note (valence) et du nombre de notes (volume) sur la popularité, pas sur la conversion de la fiche au sens strict. Le texte intégral n'a pas été lu : ni les coefficients ni la liste des pays.
- En growth : sur un marché à forte aversion à l'incertitude, une note basse ou un faible nombre d'avis pèse plus : prévoir la collecte d'avis avant d'y investir en acquisition.

## 5. Notes et avis

### Google Play : la note affichée pondère les notes récentes, et le classement en recherche tient compte des notes, des avis et des téléchargements
- Niveau de preuve : N3
- Source : Google, Play Console Help, consulté 2026, « View and analyze your app's ratings and reviews », https://support.google.com/googleplay/android-developer/answer/138230?hl=en ; « Get discovered on Google Play search », https://support.google.com/googleplay/android-developer/answer/4448378?hl=en
- Extrait lu : « Currently, the rating that users see on Google Play is weighted towards more recent ratings to reflect changes and updates that you make to your app. » ; « Apps are ranked based on a combination of ratings, reviews, downloads, and other factors. While the details of these weights and values are a proprietary part of the Google search algorithm »
- Portée / limites : Google ne publie ni le poids de la note dans le classement ni de données sur l'effet de la note moyenne sur le taux d'installation. Apple dit de même pour sa recherche : « user behavior (downloads, ratings and reviews, and more) » (https://developer.apple.com/app-store/search/).
- En growth : une mise à jour qui corrige ce que critiquent les avis récents remonte la note plus vite qu'une campagne d'avis.

### Google Play : la demande d'avis en app se fait sans question préalable (« Do you like the app? »), sans bouton dédié, et la fenêtre s'affiche telle quelle
- Niveau de preuve : N3 (guidelines de l'API, présentées par Google comme « strict guidelines » ; le pendant opposable est la politique de l'entrée suivante)
- Source : Google, Android Developers, consulté 2026, « Google Play In-App Reviews API », https://developer.android.com/guide/playcore/in-app-review
- Extrait lu : « Your app shouldn't ask the user any questions before or while presenting the rating button or card, including questions about their opinion (such as "Do you like the app?") or predictive questions (such as "Would you rate this app 5 stars"). » ; « you should not have a call-to-action option (such as a button) to trigger the API » ; « Surface the card as-is, without tampering or modifying the existing design »
- Portée / limites : le quota est volontairement non publié : « calling the launchReviewFlow method more than once during a short period of time (for example, less than a month) might not always display a dialog » ; « The specific value of the quota is an implementation detail, and it can be changed by Google Play without any notice. »
- En growth : pas de tri préalable des utilisateurs satisfaits (« review gating ») sur Play. Déclencher l'avis après un usage réel, et renvoyer vers la fiche Play quand l'utilisateur demande lui-même à noter.

### Google Play : interdiction des avis et des notes incités, et de toute demande de meilleure note dans les réponses
- Niveau de preuve : N1
- Source : Google, Play Console Help, consulté 2026, « User Ratings, Reviews, and Installs », https://support.google.com/googleplay/android-developer/answer/9898684?hl=en
- Extrait lu : « Developers must not attempt to manipulate the placement of any apps on Google Play. This includes, but is not limited to, inflating product ratings, reviews, or install counts by illegitimate means, such as fraudulent or incentivized reviews and ratings » ; exemple de violation : « This notification offers users a discount in exchange for a high rating. » ; « Keep your reply focused on the issues raised in the user's comments and don't ask for a higher rating. »
- Portée / limites : les « Key Considerations » ajoutent : « Don't use deceptive pop-ups or force users to rate your app. »
- En growth : aucune réduction, aucun bonus, aucun déblocage contre un avis ; dans les réponses aux avis, ne pas solliciter une meilleure note.

### Apple : la demande système s'affiche au plus 3 fois par période de 365 jours ; jamais sur un bouton ; les invites d'avis maison sont interdites
- Niveau de preuve : N1 (guideline 5.6.1) et N3 (documentation StoreKit, HIG)
- Source : Apple, consulté 2026, « RequestReviewAction » (StoreKit), JSON lu : https://developer.apple.com/tutorials/data/documentation/storekit/requestreviewaction.json (page : https://developer.apple.com/documentation/storekit/requestreviewaction) ; Human Interface Guidelines « Ratings and reviews », JSON lu : https://developer.apple.com/tutorials/data/design/human-interface-guidelines/ratings-and-reviews.json ; App Store Review Guidelines § 5.6.1, https://developer.apple.com/app-store/review/guidelines/
- Extrait lu : « StoreKit displays the ratings and review request a maximum of three times within a 365-day period. » ; « Because this API may not present an alert, don't call it in response to a button tap or other user action. » ; HIG : « Avoid asking for a rating on first launch or during onboarding » ; 5.6.1 : « Use the provided API to prompt users to review your app … and we will disallow custom review prompts. »
- Portée / limites : quand l'utilisateur a déjà noté, la demande ne réapparaît que pour une nouvelle version et après plus de 365 jours. La HIG suggère « at least a week or two between requests ». Les pages HTML de la documentation Apple sont rendues en JavaScript : leur version JSON officielle a été lue.
- En growth : sur iOS comme sur Play, la demande d'avis est un moment du parcours à choisir, pas un bouton.

### Apple : manipuler les avis par des retours payés, incités, filtrés ou faux expose à l'exclusion ; conditionner l'accès à une note est interdit
- Niveau de preuve : N1
- Source : Apple, App Store Review Guidelines (Last Updated: October 16, 2026), introduction de la section 3 « Business », § 3.2.2(x) et § 5.6.3, https://developer.apple.com/app-store/review/guidelines/
- Extrait lu : « If we find that you have attempted to manipulate reviews, inflate your chart rankings with paid, incentivized, filtered, or fake feedback, or engage with third-party services to do so on your behalf, we will take steps … which may include expelling you from the Apple Developer Program. » ; 3.2.2(x) : « Apps must not force users to rate the app, review the app, download other apps, or other store-related actions in order to access functionality, content, or use of the app. »
- Portée / limites : 3.2.2(x) admet d'inciter à d'autres actions (« completing a level or watching an ad »), pas à noter. Le mot « filtered » vise un tri des avis.
- En growth : aucune récompense contre un avis, et aucun tri des seuls utilisateurs satisfaits vers le store.

## 6. Localisation des fiches

### Google Play affiche par défaut une traduction automatique (Google Translate) des fiches non traduites ; la Play Console propose une traduction machine gratuite pour 10 langues, non relue par un humain
- Niveau de preuve : N3
- Source : Google, Play Console Help, consulté 2026, « Create and set up your app », https://support.google.com/googleplay/android-developer/answer/9859152?hl=en ; « Translate and localize your app », https://support.google.com/googleplay/android-developer/answer/9844778?hl=en
- Extrait lu : « If you don't add custom translations, Google Play automatically displays your store listing either as an automated translation generated by Google Translate or in your app's default language. » ; « Using our free machine translation service, you can order instant, high-quality machine translations for your store listing » ; « Important: As these are machine translations, they are not reviewed or approved by humans. » ; « While automated translations provide a convenient fallback, providing bespoke translations offers the best user experience. »
- Portée / limites : traduction machine gratuite disponible vers arabe, français (France), allemand, indonésien, italien, japonais, portugais (Brésil), espagnol (Amérique latine et Espagne), thaï. Traduction humaine payante, « as little as USD 0.07 per word ». La traduction des chaînes de l'app par Gemini est un service distinct. Google ne publie aucune mesure de qualité.
- En growth : la traduction machine doit être relue par un locuteur natif, au moins pour le titre (30 caractères), la description courte et les accroches des captures. La politique des métadonnées vaut pour chaque traduction.

### Google : traduire la description par un professionnel améliore la découvrabilité ; localiser les visuels et les accroches
- Niveau de preuve : N3
- Source : Google, Play Console Help, consulté 2026, « Get discovered on Google Play search », https://support.google.com/googleplay/android-developer/answer/4448378?hl=en
- Extrait lu : « using a professional translation service for your "Description" can lead to better search results and discoverability for worldwide users. »
- Portée / limites : aucune donnée chiffrée sur la page. La page « Add preview assets » (https://support.google.com/googleplay/android-developer/answer/9866151?hl=en) ajoute : « any additional taglines or text overlays should be localized. » Les fiches personnalisées par pays (jusqu'à 50) permettent d'adapter le contenu, pas seulement la langue.
- En growth : prévoir une fiche par marché prioritaire, avec des visuels localisés. Le fallback automatique ne suffit pas pour un marché ciblé en acquisition.

### Apple : localiser toutes les métadonnées, mots-clés compris, par région, et faire relire toute traduction machine par des natifs
- Niveau de preuve : N3
- Source : Apple, consulté 2026, « Localization », https://developer.apple.com/localization/
- Extrait lu : « Localize your App Store metadata in App Store Connect — such as your app description, keywords, app previews, and more — for each of the regions in which you offer your app. » ; « If using any machine translation to localize content, be sure to have native speakers for any languages test your app or game's translation and provide feedback. »
- Portée / limites : la page cite « 175 regions and 50 languages ». Elle suggère d'utiliser les métriques par territoire pour décider où localiser.
- En growth : les mots-clés iOS se recherchent langue par langue ; ne pas traduire mot à mot la liste française.

## 7. Déclarations de confidentialité et applications pour enfants

### Google Play, sécurité des données (Data safety) : formulaire obligatoire pour toute app, exact, tenu à jour, cohérent avec la politique de confidentialité ; le développeur en répond seul
- Niveau de preuve : N1
- Source : Google, Play Console Help, consulté 2026, « User Data » (politique), https://support.google.com/googleplay/android-developer/answer/10144311?hl=en ; « Provide information for Google Play's Data safety section », https://support.google.com/googleplay/android-developer/answer/10787469?hl=en
- Extrait lu : « All developers must complete a clear and accurate Data safety section for every app detailing collection, use, and sharing of user data. … Where relevant, the section must be consistent with the disclosures made in the app's privacy policy. » ; « Don't provide misleading or inaccurate information about your data practices. » ; « You alone are responsible for making complete and accurate declarations … When Google becomes aware of a discrepancy between your app behavior and your declaration, we may take appropriate action, including enforcement action. »
- Portée / limites : le formulaire inclut les SDK tiers (« This includes data collected and handled through any third-party libraries or SDKs »). Il est requis même sans collecte (« Even developers with apps that do not collect any user data must complete this form »). Obligation en vigueur depuis le 20.07.2022 selon la même page. L'audit de sécurité indépendant, facultatif, ne valide pas l'exactitude des déclarations.
- En growth : toute phrase de la fiche sur la confidentialité (« aucune donnée collectée », « 100 % privé ») doit être confrontée au formulaire Data safety et à la politique de confidentialité, SDK d'analyse et de crash compris.

### Apple, étiquettes de confidentialité (App Privacy) : déclarer toutes les données collectées, y compris par les SDK tiers, et les tenir à jour ; les métadonnées incluent la confidentialité
- Niveau de preuve : N1
- Source : Apple, consulté 2026, « App privacy details on the App Store », https://developer.apple.com/app-store/app-privacy-details/ ; App Store Review Guidelines § 2.3 et § 5.1.1(i), https://developer.apple.com/app-store/review/guidelines/
- Extrait lu : « You need to identify all of the data you or your third-party partners collect, unless the data meets all of the criteria for optional disclosure listed below. » ; « You're responsible for keeping your responses accurate and up to date. » ; 5.1.1(i) : « All apps must include a link to their privacy policy in the App Store Connect metadata field and within the app in an easily accessible manner. »
- Portée / limites : la page parle de « Privacy Nutrition Labels ». Les cas de déclaration facultative sont étroits (pas de pistage, pas de publicité, collecte peu fréquente, etc.). Une donnée collectée pour le seul fonctionnement de l'app doit tout de même être déclarée.
- En growth : la copy ne promet pas plus que l'étiquette ; « nous ne collectons rien » contredit une étiquette qui déclare des diagnostics.

### Google Play : des éléments marketing qui plaisent aux enfants peuvent faire rejeter une app qui ne leur est pas destinée ; une app pour enfants doit respecter COPPA et le RGPD
- Niveau de preuve : N1
- Source : Google, Play Console Help, consulté 2026, « Manage target audience and app content settings », https://support.google.com/googleplay/android-developer/answer/9867159?hl=en ; « Google Play Families Policies », https://support.google.com/googleplay/android-developer/answer/9893335?hl=en
- Extrait lu : « If your app is not primarily designed for children under 13 but your listing contains marketing elements that suggest otherwise (such as youthful animation or young characters in the graphic assets), Google Play may reject your app. » ; Families : « You must ensure that your app, including any APIs or SDKs that your app calls or uses, is compliant with the U.S. Children's Online Privacy and Protection Act (COPPA), E.U. General Data Protection Regulation (GDPR), and any other applicable laws or regulations. »
- Portée / limites : Google garde le droit de réévaluer le public déclaré (« Regardless of what you identify in the Google Play Console, if you choose to include imagery and terminology in your app that could be considered targeting children… »). Les apps destinées aux seuls enfants ne transmettent pas l'AAID et ne collectent pas la position précise.
- En growth : le style graphique de la fiche (mascotte, personnages jeunes) engage le public cible déclaré ; le choisir avec la conformité, pas seulement avec le design.

### Apple : « For Kids » et « For Children » sont réservés à la catégorie Kids ; hors de cette catégorie, rien dans la fiche ne doit suggérer un public principal d'enfants
- Niveau de preuve : N1
- Source : Apple, App Store Review Guidelines (Last Updated: October 16, 2026), § 2.3.8, § 1.3 et § 5.1.4, https://developer.apple.com/app-store/review/guidelines/
- Extrait lu : « Apps not in the Kids Category cannot include any terms in app name, subtitle, icon, screenshots or description that imply the main audience for the app is children. » ; 1.3 : « Apps in the Kids Category should not include third-party analytics or third-party advertising. » ; 5.1.4 : « we encourage you to carefully review all the requirements for complying with laws like the Children's Online Privacy Protection Act ("COPPA"), the European Union's General Data Protection Regulation ("GDPR") »
- Portée / limites : 5.1.4 rappelle que le contrôle parental exigé par la catégorie Kids n'équivaut pas au consentement parental exigé par ces lois.
- En growth : ne pas écrire « idéal pour les enfants » dans une fiche hors catégorie Kids.

### COPPA (États-Unis) : pour juger si un service vise les enfants, la FTC regarde aussi sa publicité et ses supports marketing
- Niveau de preuve : N1 (règlement fédéral, 16 CFR § 312.2)
- Source : Legal Information Institute (Cornell), consulté 2026, « 16 CFR § 312.2 – Definitions », https://www.law.cornell.edu/cfr/text/16/312.2
- Extrait lu : « the Commission will consider its subject matter, visual content, use of animated characters or child-oriented activities and incentives … as well as whether advertising promoting or appearing on the website or online service is directed to children. The Commission will also consider … evidence regarding the intended audience, including marketing or promotional materials or plans »
- Portée / limites : version reproduite par le LII, sans date de version affichée (le texte officiel eCFR n'a pas pu être chargé). Ne s'applique qu'aux services soumis au droit américain.
- En growth : sur un marché US, la fiche et les campagnes sont des pièces à charge pour qualifier le public visé : la copy « pour toute la famille » n'est pas neutre.

## 8. Mots-clés et recherche en store

### Apple : la pertinence textuelle porte sur le nom, le sous-titre, les mots-clés et la catégorie principale ; ne pas répéter un mot d'un champ à l'autre ; pas de noms d'apps concurrentes
- Niveau de preuve : N3 (le refus pour mots-clés abusifs relève de 2.3.7, N1)
- Source : Apple, consulté 2026, « App Store search », https://developer.apple.com/app-store/search/
- Extrait lu : « Search results are based on a number of factors, including text relevance (matches for your app's title, subtitle, keywords, and primary category), as well as user behavior (downloads, ratings and reviews, and more). » ; « Don't repeat any words any words included in your app name, subtitle, or category. » (sic) ; « Improper use of keywords is a common reason for App Store rejections. Don't include: … Competing app names. »
- Portée / limites : Apple n'écrit pas que la description n'est pas indexée ; elle ne figure simplement pas dans la liste. Les « app tags » des résultats sont « generated using large language models (LLMs) based on the metadata you've provided ».
- En growth : sur iOS, travailler nom, sous-titre et champ mots-clés comme un seul budget de mots sans doublon. La description sert à convaincre, pas à se classer (inférence, voir Mythes).

### Google : le texte de la fiche sert la découverte (pas de champ mots-clés) ; appliquer les bonnes pratiques SEO dans la description, dans les limites des règles anti-spam
- Niveau de preuve : N3 (le bourrage de mots-clés relève des politiques, N1)
- Source : Google, Play Console Help, consulté 2026, « Get discovered on Google Play search », https://support.google.com/googleplay/android-developer/answer/4448378?hl=en
- Extrait lu : « The text in your store listing helps users discover your app. » ; « Your title should be unique and accessible, avoid common terms, and reinforce what your app is about. » ; « Use SEO best practices in your "Description," but be mindful of the Google Play Content Policies regarding spam and IP Infringement (for example, keyword spamming, impersonation, etc.). » ; « Avoid using subtle misspellings of general terms »
- Portée / limites : Google ne publie aucune pondération entre titre, description courte et description longue, ni de densité recommandée. La page « Add preview assets » ajoute que les mots-clés superflus de la description courte « will not impact ranking ».
- En growth : sur Play, les termes recherchés figurent naturellement dans le titre et la description ; toute répétition de type liste est à la fois inutile et sanctionnable.

---

## Verdict sur les règles du profil

| Règle actuelle | Verdict | Motif sourcé |
|---|---|---|
| « Limites Play Store : titre ≤ 60, courte ≤ 80, longue ≤ 4 000, par locale. » | **Contredite pour le titre**, soutenue pour le reste | Titre : **30 caractères** (politique Metadata et page de configuration de la Play Console ; annoncé par Google le 29.04.2021). Aucune source, même ancienne, n'a été trouvée pour « 60 ». Courte 80 et longue 4 000 : confirmées. « Par locale » : confirmé (« one localized name per language » ; limites valables en pleine et demi-chasse). À corriger : « titre ≤ 30 ». Ajouter : App Store nom 30, sous-titre 30, mots-clés 100 octets, texte promotionnel 170, description 4 000, notes de version 4 000. |
| « Conformité store : pas de keyword-stuffing, pas de nom de concurrent, pas de superlatifs non prouvés type « n°1 », pas de fausse mention « Editor's Choice ». » | **Soutenue, mais trop permissive sur deux points** | Keyword-stuffing : interdit sur Play (Metadata, risque de suspension) et sur Apple (2.3.7). Nom de concurrent : Play range « Data comparison of apps or brands » parmi les violations et proscrit les références trompeuses à d'autres apps ; Apple interdit les noms d'autres apps dans les mots-clés et les sous-titres. « Editor's Choice » : interdit nommément par Play. **Correction 1** : sur Play, tout signe de classement, de prix, de promotion ou de programme Google est interdit dans le titre, l'icône et le nom du développeur **même s'il est vrai** ; le qualificatif « non prouvés » est donc trop faible. Une vraie distinction n'est admise qu'en fin de description iOS (guidance Apple). **Correction 2** : ajouter « Free/Gratuit », « No Ads/Sans pub », « New/Nouveau », les prix, les emoji, les MAJUSCULES, les appels à l'action dans la description courte et les témoignages anonymes. |
| « Sujets enfants/données personnelles → messaging aligné Data Safety / COPPA / RGPD ; ne jamais sur-promettre sur la confidentialité. » | **Soutenue** (à compléter) | Data safety obligatoire, exact et cohérent avec la politique de confidentialité, sanction en cas d'écart ; étiquette Apple obligatoire, SDK tiers compris (2.3 inclut « privacy information »). Compléments : (a) des visuels « enfantins » peuvent faire rejeter une app qui ne vise pas les moins de 13 ans (Play) ; (b) « For Kids » est réservé à la catégorie Kids sur iOS ; (c) la règle COPPA compte la publicité et les supports marketing parmi les indices du public visé. |
| « Défaut : Google Play d'abord, App Store ensuite. » | **Convention sans preuve trouvée** | Aucune source officielle ne hiérarchise les stores : c'est un choix de contexte (projets Capacitor Android), défendable mais non sourcé. Conséquence vérifiée : la copy ne se transpose pas telle quelle. iOS a un champ mots-clés et un sous-titre que Play n'a pas ; Play indexe le texte de la fiche ; Apple tolère une distinction en fin de description, Play l'interdit dans le titre et l'icône ; l'A/B natif ne teste pas la même chose (descriptions testables sur Play en expérience localisée, pas sur iOS). |

## Mythes et affirmations contestées

- **« Le titre Play fait 50 (ou 60) caractères. »** — Faux depuis 2021 : 30. Le chiffre de 50 apparaît dans la presse spécialisée de 2017 (titre d'article vu dans les résultats de recherche, non lu, non vérifié). Aucune trace de 60 : confusion probable avec la balise `<title>` du SEO web (inférence).
- **« Les expériences Play testent jusqu'à 5 variantes. »** (blogs ASO) — La page officielle dit « up to 2 variants » par expérience. Le chiffre 5 désigne le nombre d'**expériences localisées simultanées**.
- **« La vidéo augmente toujours la conversion. »** — Apple publie le contre-exemple d'une app de piano (« The original product page without an app preview video outperformed the treatment »). Le chiffre « +3 % » affiché dans le même encadré est ambigu.
- **« La première capture fait 60 % de la décision d'installation. »** — Chiffre de blog sans source primaire. Google et Apple disent seulement que les premières captures apparaissent dans les résultats de recherche (Apple : « the first one to three images will appear in search results when no app preview is available ») et qu'il faut y placer l'interface (Google : « prioritize UI in the first three screenshots »).
- **« Il faut répéter le mot-clé N fois dans la description longue Play. »** — Google ne publie aucune densité. La politique sanctionne la répétition ; la description courte bourrée de mots-clés « will not impact ranking ».
- **« Apple indexe la description. »** — Non confirmé : Apple liste nom, sous-titre, mots-clés et catégorie principale pour la pertinence textuelle, et dit explicitement que le texte promotionnel n'influe pas sur le classement. L'absence d'indexation de la description est une inférence, Apple ne l'écrit pas.
- **« Demander d'abord "Vous aimez l'app ?" puis n'envoyer au store que les contents. »** — Contraire aux guidelines de l'API Google (« shouldn't ask the user any questions before or while presenting the rating button ») ; Apple sanctionne les retours « filtered ».
- **« Un bouton "Noter l'app" qui appelle l'API d'avis. »** — Déconseillé par les deux stores (quota : la fenêtre peut ne pas s'afficher) ; utiliser un lien vers la fiche.
- **« Champ mots-clés Apple = 100 caractères. »** — Apple se contredit : « 100 bytes » (App Store Connect) contre « 100 characters » (guide de recherche). Avec des accents, se fier aux octets (inférence sur l'encodage).
- **Études de cas « +45 % d'installations » (pages Google) ou « +8 % » (pages Apple).** — Cas choisis par la plateforme, sans taille d'échantillon ni méthode complète : N4. Ils ne fondent aucune règle générale.

## Non vérifié

- **Date d'application** de la limite de 30 caractères sur Play : le billet officiel du 29.04.2021 renvoie à une communication ultérieure. Un blog ASO avance le 29 septembre (2021), non confirmé par une source Google ouverte.
- **Limite de caractères du nom de développeur** sur Google Play : absente des pages officielles lues.
- **Ancienne limite du titre Play (50 caractères)** : seulement vue dans les titres de résultats de recherche, page non ouverte.
- **Données chiffrées publiées par Google ou Apple** sur l'effet moyen des captures, de la vidéo, de l'icône ou de la localisation sur la conversion, avec leur méthode : aucune trouvée, seulement des études de cas d'éditeurs. Contenu de Play Academy non ouvert.
- **Effet chiffré de la note moyenne sur le taux d'installation**, selon des données Google : rien de publié trouvé. Le billet Google de mai 2019 sur le recalcul des notes n'a pas été ouvert (seule l'aide actuelle, qui confirme la pondération vers les notes récentes, l'a été).
- **Valeur du quota** de l'API In-App Review de Google : non publiée par Google, par choix.
- **Études revues par les pairs sur la conversion en store** : seulement deux trouvées (Han et Ghose, ICIS 2012 ; Kübler et al., Journal of Marketing 2018), lues **en résumé seul** ; texte intégral de Ghose et Han 2014 non lu.
- **Version datée de la règle COPPA** (16 CFR 312.2) : texte lu sur le LII de Cornell, eCFR officiel inaccessible ; date de la version non affichée.
- **Texte du RGPD** : non ouvert dans cette recherche ; seules les mentions qu'en font Google et Apple ont été lues.
- **Page google.play « Grow your audience »** (redirection de la checklist de localisation Android) : rendue en JavaScript, contenu non lu.

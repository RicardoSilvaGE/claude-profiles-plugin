# Fiche `ux-preuves` — Growth — conversion et persuasion

> Fiche du skill `ux-preuves` (dev-fullstack), volet **growth**, préchargé par `growth`. Couvre : taux de succès réels des tests A/B et taille d'échantillon, preuve sociale et avis, prix (chiffres en 9, essai gratuit, renouvellement automatique), titres et accroches, urgence et rareté, pages d'atterrissage, formules de copywriting.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Verdict sur les règles
> du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées : ce qui y
> figure ne se cite pas comme un fait. Le droit y est rapporté, pas appliqué : son application à
> un produit précis relève d'un juriste.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Rédigé le 9 novembre 2026 pour le référentiel de l'agent « stratège growth/marketing et copywriter d'acquisition senior ».
> Règle suivie : chaque entrée s'appuie sur une page ou un PDF réellement ouvert pendant la recherche (WebFetch, ou téléchargement puis `pdftotext`, ou notice bibliographique via l'API Crossref / EconPapers). Lorsque seul le résumé a été lu, c'est indiqué (« résumé seul lu »).
> Hors périmètre, car couverts ailleurs : pièges statistiques des tests A/B (peeking, SRM, p-valeur), dark patterns (Mathur 2019, DSA), nudges et réplications (Maier 2022), effet de leurre (Frederick 2014), « bouton rouge +21 % », Baymard checkout.

Échelle de preuve : N1 = norme ou réglementation ; N2 = recherche revue par les pairs ou étude empirique sur un large échantillon ; N3 = guideline d'institution ou de plateforme ; N4 = avis d'expert ou article de praticien.

---

## 1. Expérimentation : taux de succès réels et taille des effets

### Partir du principe que la plupart des idées ne feront pas bouger la métrique visée
- Niveau de preuve : N2 (retour d'expérience sur des milliers d'expériences, Microsoft/Bing ; publié à KDD 2013)
- Source : Kohavi R., Deng A., Frasca B., Walker T., Xu Y., Pohlmann N., 2013, « Online Controlled Experiments at Large Scale », https://exp-platform.com/Documents/2013%20controlledExperimentsAtScale.pdf (lien trouvé sur https://exp-platform.com/large-scale/)
- Extrait lu : « Only one third of the ideas tested at Microsoft improved the metric(s) they were designed to improve [5]. Success is even harder to find in well-optimized domains like Bing. »
- Portée / limites : le chiffre « un tiers » remonte à Kohavi, Crook et Longbotham 2009 (réf. [5] du papier, non ouverte ici). Pour Google, le papier cite Jim Manzi : « about 10 percent of these [controlled experiments, were] leading to business changes ». Pour Netflix, il cite Mike Moran (« Netflix considers 90% of what they try to be wrong »). Ces deux chiffres sont donc de seconde main dans le papier lui-même.
- En growth : quand un plan de tests affiche une majorité de « gagnants » attendus, demander quel taux de succès historique justifie cette confiance. Prévoir du volume d'idées plutôt que miser sur une seule « certitude ».

### Caler ses attentes sur des taux de succès de 8 à 33 % selon la maturité du produit
- Niveau de preuve : N2 (KDD 2022, revu par les pairs ; agrège des taux publiés par plusieurs organisations)
- Source : Kohavi R., Deng A., Vermeer L., 2022, « A/B Testing Intuition Busters: Common Misunderstandings in Online Controlled Experiments », https://airbnb.tech/wp-content/uploads/sites/19/2025/10/ABTestingIntuitionBusters.pdf
- Extrait lu : Table 2, « Microsoft 33% […] Avinash Kaushik 20% […] Bing 15% […] Booking.com, Google Ads, Netflix 10% […] Airbnb Search 8% », avec la réserve des auteurs : « These numbers may involve different accounting schemes, and we never know the true rates, but they suffice as ballpark estimates. »
- Portée / limites : il s'agit d'ordres de grandeur dont les définitions de « succès » diffèrent selon les organisations. Le chiffre de 10 % pour Booking, Google Ads et Netflix est regroupé et attribué à Manzi 2012, à Thomke 2020 et à Moran 2007. Le papier en tire le taux de faux positifs implicite : 22 % à une puissance de 80 % pour un taux de succès de 10 %, et 52,9 % à une puissance de 20 % (Table 3).
- En growth : avec un taux de succès de base de 10 %, un « gagnant » isolé et tout juste significatif a de bonnes chances d'être un faux positif. Le répliquer avant de le généraliser.

### Attendre des effets de l'ordre du pour cent et se méfier d'un effet spectaculaire
- Niveau de preuve : N2
- Source : Kohavi et al., 2013, « Online Controlled Experiments at Large Scale », https://exp-platform.com/Documents/2013%20controlledExperimentsAtScale.pdf ; complété par Kohavi, Deng, Vermeer 2022 (URL ci-dessus)
- Extrait lu : « many ideas impact key metrics by 1% and are not well estimated a-priori » et, à propos de la loi de Twyman : « We recommend healthy skepticism towards stories depicting astounding results from tiny changes, such as 50% revenue lift due to changing the color of the Buy Button. While we have some unexpected successes from small changes, they are extremely rare. » Dans le papier de 2022 : « At Bing, monthly improvements in revenue from multiple experiments were usually in the low single digits ».
- Portée / limites : ce sont des contextes à très fort trafic (Bing, Microsoft). Le papier de 2022 démonte un cas publié de +300 % obtenu avec environ 80 utilisateurs par variante, soit une puissance d'environ 3 %.
- En growth : face à une étude de cas CRO affichant +50 % ou +300 %, demander l'effectif par variante, la puissance et l'existence d'une réplication. À défaut, la classer en N4 au mieux.

### Savoir que, dans l'e-commerce, l'effet médian d'un test est minuscule et que les promotions de prix dominent
- Niveau de preuve : N2 (2 732 tests issus de 252 entreprises ; document de travail Wharton, statut de publication non vérifié)
- Source : Miller A. P., Hosanagar K., 2020 (version de mars 2020), « An Empirical Meta-analysis of E-commerce A/B Testing Strategies », https://mackinstitute.wharton.upenn.edu/wp-content/uploads/2020/11/FP0398a_WP_2020Mar.pdf (page de présentation : https://mackinstitute.wharton.upenn.edu/2020/empirical-meta-analysis-e-commerce-a-b-testing-practices/)
- Extrait lu : « the typical effect size observed in an A/B test is very small: the median (absolute) effect size is just 0.1%, with the mean slightly higher at 0.7%. » ; « experiments involving price promotions and those targeted on category or product listing pages are associated with the largest effect sizes »
- Portée / limites : l'effet est mesuré comme l'écart absolu de taux de conversion entre les deux bras, en points. Les auteurs ne savent pas toujours quel bras est le contrôle, d'où l'usage de la valeur absolue. Les tests proviennent des clients d'une plateforme de test, sur trois ans et dans sept secteurs.
- En growth : prioriser ce qui touche à l'offre (prix, livraison) et au bon endroit du tunnel, plutôt que les retouches cosmétiques. Le papier rapporte que les promotions de prix fonctionnent mieux tôt dans le tunnel et celles sur la livraison tard, sur les pages produit et checkout.

### Ne pas ériger « une seule variable à la fois » en dogme : tester aussi des paris audacieux, et des plans factoriels quand une interaction est suspectée
- Niveau de preuve : N2 (KDD 2007, retour d'expérience Microsoft)
- Source : Kohavi R., Henne R. M., Sommerfield D., 2007, « Practical Guide to Controlled Experiments on the Web: Listen to Your Customers not to the HiPPO », https://cdn.elezea.com/pdf/GuideControlledExperiments.pdf (copie auteur, « Appears in KDD 2007 »)
- Extrait lu : « Several authors […] recommend testing one factor at a time. We believe the advice, interpreted narrowly, is too restrictive and can lead organizations to focus on small incremental improvements. » Recommandations : « Conduct single-factor experiments for gaining insights and when you make incremental changes that could be decoupled. » / « Try some bold bets and very different designs. » / « Use factorial designs when several factors are suspected to interact strongly. Limit the factors and the possible values per factor because users will be fragmented (reducing power) ».
- Portée / limites : Kohavi et al. 2013 confirme que les tests multivariés sont peu utilisés chez Bing (« interactions are relatively rare and more often represent bugs than true statistical interactions »). Le contexte est celui d'un trafic massif. Sur un petit trafic, chaque cellule d'un plan factoriel manque de puissance.
- En growth : la vraie question est « veut-on apprendre pourquoi ça marche, ou trouver mieux ? ». Pour apprendre, un seul facteur. Pour trouver mieux, une refonte entière contre l'existant est légitime, à condition d'accepter de ne pas savoir quel élément a joué.

### Déclarer avant le test un critère d'évaluation unique, mesurable à court terme et prédictif du long terme, et juger sur un tableau final à date fixe
- Niveau de preuve : N2
- Source : Kohavi et al., 2013, « Online Controlled Experiments at Large Scale », https://exp-platform.com/Documents/2013%20controlledExperimentsAtScale.pdf
- Extrait lu : « Tenet 1: The Organization wants to make data-driven decisions and has formalized the Overall Evaluation Criterion (OEC) » ; « "Profit" is not a good OEC, as short-term theatrics (e.g., raising prices) can increase short-term profit, but hurt it in the long run. » ; « there is one final scorecard at the end of the experiment, which we require to be a multiple of weeks, usually two weeks. » ; « we standardized our success criteria to use a small set of metrics »
- Portée / limites : c'est une pratique d'organisation documentée, pas un essai comparatif « OEC déclaré contre non déclaré ». Le papier montre aussi l'inflation des faux positifs quand on itère : six itérations de cinq traitements donnent plus de 50 % de chances d'obtenir un « gagnant » par hasard.
- En growth : exiger, avant publication, la métrique, son sens attendu, l'effet minimal visé et la date du verdict, en semaines entières. Refuser une métrique de succès choisie après coup parmi des dizaines.

### Calculer l'effectif nécessaire avant de lancer : quelques centaines de conversions ne suffisent pas pour un effet de 10 %
- Niveau de preuve : N2
- Source : Kohavi, Deng, Vermeer, 2022, « A/B Testing Intuition Busters », https://airbnb.tech/wp-content/uploads/sites/19/2025/10/ABTestingIntuitionBusters.pdf
- Extrait lu : « Assuming historical data showed 3.7% as the conversion rate […] The sample size recommended for each variant to achieve 80% power is therefore: 16σ²/δ² = 16 ∗ 3.563%/(0.37%)² = 41,642. »
- Portée / limites : il s'agit de détecter une variation relative de 10 % sur un taux de base de 3,7 %, avec une puissance de 80 % et un seuil α de 0,05. 41 642 visiteurs × 3,7 % ≈ 1 540 conversions par variante (calcul fait ici, pas dans le papier). Comme l'effectif varie en 1/δ², détecter 1 % demande environ 100 fois plus.
- En growth : avant tout test, faire le calcul de puissance à partir du taux de base et de l'effet minimal visé. Si le trafic ne le permet pas, ne pas tester finement : tester des changements plus gros, ou décider sans test et le dire.

---

## 2. Preuve sociale, avis et témoignages

### Viser les cinq premiers avis : c'est là que se fait l'essentiel du gain, davantage encore pour les produits chers
- Niveau de preuve : N2 (données observationnelles sur des millions de pages vues ; rapport d'un centre universitaire co-signé avec un éditeur de solutions d'avis)
- Source : Spiegel Research Center (Northwestern University) et PowerReviews, 2017, « How Online Reviews Influence Sales », PDF officiel : https://spiegel.medill.northwestern.edu/wp-content/uploads/sites/2/2021/04/Spiegel_Online-Review_eBook_Jun2017_FINAL.pdf (copie identique lue : https://www.xait.com/hubfs/Spiegel_Online-Review_eBook_Jun2017_FINAL.pdf ; page : https://spiegel.medill.northwestern.edu/How-Online-Reviews-Influence-Sales)
- Extrait lu : « The purchase likelihood for a product with five reviews is 270% greater than the purchase likelihood of a product with no reviews. » ; « nearly all of the increase in purchase likelihood occurs within the first 10 reviews, and the first five reviews drive the bulk of this increase. » ; « when reviews were displayed for a lower-priced product, the conversion rate increased 190%. However, for a higher-priced product, the conversion rate increased 380%. »
- Portée / limites : le 270 % provient d'un seul détaillant de cadeaux haut de gamme (1 800 produits, 7,8 millions d'utilisateurs, une année). L'étude est observationnelle et non randomisée, et compare 5 avis à 0 avis. Les produits peu chers plafonnent selon le rapport après 2 à 4 avis. Recherche sous-jacente : Askalidis et Malthouse 2016 (RecSys), non ouverte ici.
- En growth : sur une page sans avis, collecter les premiers avis est un levier prioritaire. Ne jamais citer « +270 % » sans préciser « 5 avis contre 0, un détaillant, données observationnelles ».

### Ne pas viser une note parfaite : l'intention d'achat culmine sous 5,0
- Niveau de preuve : N2 (mêmes données ; s'appuie sur Maslowska, Malthouse et Bernritter 2017, International Journal of Advertising, dont le résumé n'a pas été lu)
- Source : Spiegel Research Center et PowerReviews, 2017, « How Online Reviews Influence Sales », https://spiegel.medill.northwestern.edu/wp-content/uploads/sites/2/2021/04/Spiegel_Online-Review_eBook_Jun2017_FINAL.pdf
- Extrait lu : « purchase likelihood typically peaks at ratings in the 4.0 - 4.7 range, and then begins to decrease as ratings approach 5.0. Put differently, products with an average star rating in the 4.7 - 5.0 range are less likely to be purchased than those in the 4.2 - 4.7 range. »
- Portée / limites : la fourchette citée est 4,0 à 4,7, pas 4,2 à 4,5. La comparaison porte sur les tranches 4,7-5,0 et 4,2-4,7. Les courbes varient selon la catégorie (chaussures, vitamines, ampoules, etc.). Le rapport cite aussi un chiffre de Revoo (+67 % de conversion lorsque les visiteurs consultent des avis négatifs), de seconde main et non vérifié.
- En growth : ne pas filtrer les avis négatifs. Une note de 4,9 avec peu d'avis peut sembler « too good to be true ». Montrer la distribution des notes plutôt que la seule moyenne.

### Signaler les avis d'acheteurs vérifiés
- Niveau de preuve : N2 (65 000 avis d'acheteurs vérifiés et 57 000 avis anonymes, environ 13 500 produits)
- Source : Spiegel Research Center, page « How Online Reviews Influence Sales », https://spiegel.medill.northwestern.edu/How-Online-Reviews-Influence-Sales et rapport PDF (URL ci-dessus)
- Extrait lu : « We found that verified buyers are more likely to give four- or five-star ratings than anonymous reviewers are. » La page indique aussi que l'identification des acheteurs vérifiés « improves the odds of purchase by 15% ».
- Portée / limites : ce sont des données d'un éditeur de solutions d'avis, avec un biais de sélection possible entre avis sollicités et spontanés, que le rapport discute lui-même.
- En growth : afficher la mention « acheteur vérifié » seulement si une vérification existe vraiment (voir l'entrée suivante sur le droit).

### Ne jamais présenter des avis comme vérifiés sans procédure de vérification, ni publier de faux avis
- Niveau de preuve : N1
- Source : Code de la consommation (France), article L121-4, version en vigueur depuis le 28 mai 2022, https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000044563107
- Extrait lu : chapeau : « Sont réputées trompeuses, au sens des articles L. 121-2 et L. 121-3, les pratiques commerciales qui ont pour objet : ». Le 27° vise le fait d'affirmer que des avis émanent de consommateurs ayant réellement utilisé ou acheté le produit « sans avoir pris les mesures nécessaires pour le vérifier ». Le 28° vise la diffusion « des faux avis ou de fausses recommandations de consommateurs » et leur modification « afin de promouvoir des produits ».
- Portée / limites : droit français, modifié par l'ordonnance n° 2021-1734. La correspondance avec l'annexe I de la directive 2005/29/CE n'a pas été vérifiée sur EUR-Lex (inaccessible pendant la recherche). Les sanctions n'ont pas été vérifiées.
- En growth : un témoignage inventé, « reformulé » ou sélectionné de façon trompeuse n'est pas une zone grise. Documenter la provenance de chaque avis et témoignage.

### Afficher la popularité réelle : un classement « les plus choisis » augmente la demande pour ces options
- Niveau de preuve : N2 (expérience de terrain randomisée, American Economic Review)
- Source : Cai H., Chen Y., Fang H., 2009, « Observational Learning: Evidence from a Randomized Natural Field Experiment », American Economic Review 99(3), DOI https://doi.org/10.1257/aer.99.3.864 (résumé seul lu, notice Crossref : https://api.crossref.org/works/10.1257/aer.99.3.864)
- Extrait lu : « when customers are given ranking information of the five most popular dishes, the demand for those dishes increases by 13 to 20 percent. We do not find a significant saliency effect. »
- Portée / limites : l'expérience porte sur un restaurant et non sur une page web. Le mécanisme est l'apprentissage par observation (l'information sur les choix des autres), pas la simple mise en avant. Les auteurs relèvent un effet plus fort chez les clients occasionnels.
- En growth : une preuve sociale de type « les plus choisis » ou « X personnes ont choisi ce plan » est défendable si elle est vraie et vérifiable. L'effet attendu est de l'ordre de la dizaine de pour cent sur l'option mise en avant, pas un multiplicateur.

---

## 3. Prix et présentation des offres

### Utiliser les terminaisons en 9 surtout pour les produits nouveaux ou mal connus, et sans les cumuler avec un affichage « Soldes »
- Niveau de preuve : N2 (trois expériences de terrain sur catalogue)
- Source : Anderson E. T., Simester D. I., 2003, « Effects of $9 Price Endings on Retail Sales: Evidence from Field Experiments », Quantitative Marketing and Economics 1(1), 93-110, https://econpapers.repec.org/RePEc:kap:qmktec:v:1:y:2003:i:1:p:93-110 (résumé seul lu)
- Extrait lu : « First, use of a $9 price ending increased demand in all three experiments. Second, the increase in demand was stronger for new items than for items that the retailer had sold in previous years. There is also some evidence that $9 price endings are less effective when retailers use "Sale" cues. »
- Portée / limites : vente par catalogue aux États-Unis, prix en dollars ronds terminés par 9 (par ex. 39 $ contre 40 $). L'ampleur de l'effet n'est pas dans le résumé et n'a pas été vérifiée. Les auteurs l'interprètent comme un effet plus fort quand le client manque d'information.
- En growth : utile pour un nouveau produit ou un prix qu'on ne peut pas comparer ; moins utile quand le prix est connu ou déjà présenté comme réduit.

### N'attendre un effet du chiffre de gauche que si ce chiffre change réellement
- Niveau de preuve : N2 (cinq expériences, Journal of Consumer Research)
- Source : Thomas M., Morwitz V., 2005, « Penny Wise and Pound Foolish: The Left-Digit Effect in Price Cognition », Journal of Consumer Research 32(1), 54-64, https://econpapers.repec.org/RePEc:oup:jconrs:v:32:y:2005:i:1:p:54-64 (résumé seul lu)
- Extrait lu : « First, this occurs only when the leftmost digits of the prices differ (e.g., $2.99 vs. $3.00). Second, the left-digit effect also depends on the numerical and psychological distances between the target price and a competing product's price. The closer the two prices being compared, the more likely is the left-digit effect. »
- Portée / limites : il s'agit de perception de prix en laboratoire, pas de ventes. 19,99 contre 20,00 change le chiffre de gauche ; 24,99 contre 25,00 ne le change pas.
- En growth : 49 € contre 50 € peut compter ; 47 € contre 48 € n'apporte rien. Ne pas présenter le « prix psychologique » comme universel.

### Savoir que le biais du chiffre de gauche est mesurable sur des données réelles de vente
- Niveau de preuve : N2 (données de caisse : 3 500 produits, 25 chaînes américaines ; Review of Economic Studies)
- Source : Strulov-Shlain A., 2022 (publication en ligne), « More Than a Penny's Worth: Left-Digit Bias and Firm Pricing », Review of Economic Studies, DOI https://doi.org/10.1093/restud/rdac082 (résumé seul lu, notice Crossref : https://api.crossref.org/works/10.1093/restud/rdac082)
- Extrait lu : « consumers respond to a one-cent increase from a ninety-nine-ending price as if it were more than a twenty-cent increase. »
- Portée / limites : distribution alimentaire et grande consommation aux États-Unis, petits montants. L'auteur conclut aussi que les distributeurs exploitent mal ce biais (« retailers forgo 1–4% of potential gross profits »). La transposition à un abonnement SaaS n'est pas démontrée.
- En growth : l'effet existe en conditions réelles, mais sur des prix bas et achetés souvent. Pour une offre B2B ou un abonnement, le tester plutôt que le supposer.

### Ne pas appliquer les prix en 9 à une offre premium sans réfléchir : les prix ronds sont associés à la qualité
- Niveau de preuve : N2 (modèle théorique et données empiriques, Management Science)
- Source : Stiving M., 2000, « Price-Endings When Prices Signal Quality », Management Science 46(12), DOI https://doi.org/10.1287/mnsc.46.12.1617.12078 (résumé seul lu, notice Crossref : https://api.crossref.org/works/10.1287/mnsc.46.12.1617.12078)
- Extrait lu : « Firms that are using high prices to signal quality are more likely to set those prices at round numbers, and (2) price-endings themselves are not necessarily signals of quality. […] firms tend to use more round prices for higher quality products »
- Portée / limites : le résultat porte sur le comportement des entreprises, pas sur une expérience mesurant la perception des acheteurs. Un commentaire critique et une réponse de l'auteur ont paru en 2003 dans la même revue (titres vus sur Crossref, contenu non lu).
- En growth : pour un positionnement premium ou une offre de conseil, un prix rond est la convention dominante. Le choix 99/100 doit découler du positionnement, pas d'une « règle de CRO ».

### Traiter l'ancrage de prix comme un effet fragile, à vérifier sur son propre terrain
- Niveau de preuve : N2 (American Economic Review)
- Source : Maniadis Z., Tufano F., List J. A., 2014, « One Swallow Doesn't Make a Summer: New Evidence on Anchoring Effects », American Economic Review 104(1), 277-290, https://econpapers.repec.org/RePEc:aea:aecrev:v:104:y:2014:i:1:p:277-90 (résumé seul lu)
- Extrait lu : « We present new evidence that explores the strength of certain anchoring results. […] a few independent replications dramatically increase the chances that the original finding is true. »
- Portée / limites : le résumé ne chiffre pas l'échec de réplication ni le résultat d'origine visé, qui n'a pas été vérifié ici. Il s'agit d'ancrage par un nombre arbitraire en laboratoire, pas d'ancrage par un prix barré ou une offre de référence.
- En growth : un « prix d'ancrage » (offre très chère affichée pour faire paraître l'offre cible raisonnable) reste une hypothèse à tester. Ne pas citer l'ancrage comme une loi. Un prix de référence fictif relève en outre du droit des réductions de prix, non traité ici.

### Ramener un coût annuel à une petite dépense récurrente (« X € par jour ») peut augmenter l'acceptation
- Niveau de preuve : N2 (série d'études en laboratoire, Journal of Consumer Research)
- Source : Gourville J. T., 1998, « Pennies-a-Day: The Effect of Temporal Reframing on Transaction Evaluation », Journal of Consumer Research 24(4), https://econpapers.repec.org/RePEc:oup:jconrs:v:24:y:1998:i:4:p:395-408 (résumé seul lu)
- Extrait lu : « The PAD framing of a target transaction is shown to systematically foster the retrieval and consideration of small ongoing expenses as the standard of comparison, whereas an aggregate framing of that same transaction is shown to foster the retrieval and consideration of large infrequent expenses. »
- Portée / limites : il s'agit d'expériences de laboratoire. L'ampleur n'est pas indiquée dans le résumé et l'effet en conditions réelles n'est pas mesuré. Les études ne tranchent pas « affichage mensuel contre annuel » pour un abonnement SaaS.
- En growth : afficher « 0,30 €/jour » ou « 9 €/mois » plutôt que « 108 €/an » est une hypothèse étayée en laboratoire. Elle doit rester honnête : le prix total doit être visible.

### Préférer un essai qui s'arrête de lui-même : le renouvellement automatique fait fuir une partie des prospects
- Niveau de preuve : N2 (expérience de terrain randomisée 2 × 2 × 2 sur environ 1,4 million de lecteurs, préenregistrée AEARCTR-0011311 ; document de travail)
- Source : Miller K. M., Sahni N. S., Strulov-Shlain A., version du 22 janvier 2026, « Sophisticated Consumers with Inertia: Long-Term Implications from a Large-Scale Field Experiment », https://marketing.wharton.upenn.edu/wp-content/uploads/2026/02/Strulov-Shlain-Avner-PAPER-Subscriptions.pdf
- Extrait lu : « though offering auto-renewing contracts benefits the firm in the short-term, it lowers subscriptions take-up by 35% and total subscribers by 23% over 20 months. »
- Portée / limites : un grand quotidien européen, avec des offres promotionnelles à 0 € ou 0,99 € sur deux ou quatre semaines. Les informations demandées étaient identiques dans tous les bras : la variable testée est le renouvellement, pas « carte bancaire exigée ou non ». La généralisation au SaaS B2B n'est pas démontrée.
- En growth : un taux de conversion essai → payant plus élevé avec renouvellement automatique ne prouve pas qu'il y ait plus de clients au bout du compte. Mesurer les abonnés payants par visiteur sur plusieurs mois, pas le taux de conversion de l'essai.

---

## 4. Titres et accroches

### Ne pas transposer « la négativité fait cliquer » aux titres de landing pages
- Niveau de preuve : N2 (Registered Report, 22 743 expériences randomisées, Nature Human Behaviour)
- Source : Robertson C. E., Pröllochs N., Schwarzenegger K., Pärnamets P., Van Bavel J. J., Feuerriegel S., 2023, « Negativity drives online news consumption », Nature Human Behaviour, https://www.nature.com/articles/s41562-023-01538-4
- Extrait lu : « For a headline of average length, each additional negative word increased the click-through rate by 2.3%. » Limite déclarée : « Upworthy differs from more traditional news sources due to its use of 'click-bait' headlines. » ; « Our results show that negative words increase consumption rates, but make no claims regarding the subjective experience of readers. »
- Portée / limites : la métrique est le taux de clic sur des titres d'actualité Upworthy entre 2013 et 2015, pas la conversion, ni la confiance, ni la satisfaction après clic. Les auteurs mesurent aussi qu'un titre plus long augmente le taux de clic et qu'un titre plus complexe le réduit. La période étudiée (du 24.01.2013 au 14.04.2015) recouvre la fenêtre que la correction de 2024 de l'archive signale comme mal randomisée (voir l'entrée suivante). L'effet de cette correction sur ces résultats n'a pas été vérifié.
- En growth : l'étude dit qu'un titre négatif attire plus de clics sur de l'actualité. Elle ne dit pas qu'il convertit ou fidélise mieux sur une page produit. Sur une landing, la métrique est l'action, pas le clic.

### Se rappeler que même les grandes archives de tests de titres ont des défauts de randomisation
- Niveau de preuve : N2 (jeu de données publié et sa correction, Scientific Data)
- Source : Matias J. N., Munger K., Le Quere M. A., Ebersole C., 2021, « The Upworthy Research Archive, a time series of 32,487 experiments in U.S. media », Scientific Data 8, DOI https://doi.org/10.1038/s41597-021-00934-7 (résumé lu via la notice Crossref) ; correction : https://pmc.ncbi.nlm.nih.gov/articles/PMC11239857/
- Extrait lu : résumé : « In total, the archive includes 32,487 experiments, 150,817 experiment arms, and 538,272,878 participant assignments. » Correction : « A total of 7,004 A/B tests or 22% of experiments may have been affected » ; « we encourage researchers to treat these tests as not randomized. »
- Portée / limites : l'archive ne mesure que des clics sur des paquets titre + image. La période concernée par la correction va du 25 juin 2013 au 10 janvier 2014, et la cause supposée est un cache qui servait un seul bras à la fois.
- En growth : avant de se fier à un outil de test (le sien ou celui d'un fournisseur), vérifier que la randomisation fonctionne (contrôle de SRM, couvert ailleurs).

### Éviter les titres racoleurs : ils semblent coûter un peu de crédibilité
- Niveau de preuve : N2 (deux expériences en ligne, Journalism Practice) ; résumé seul lu
- Source : Molyneux L., Coddington M., 2020, « Aggregation, Clickbait and Their Effect on Perceptions of Journalistic Credibility and Quality », Journalism Practice, DOI https://doi.org/10.1080/17512786.2019.1628658 (résumé lu via la notice OpenAlex https://api.openalex.org/works/doi:10.1080/17512786.2019.1628658)
- Extrait lu : « Aggregation itself has little effect on perceptions of credibility and quality; instead, writing proficiency is more closely linked to these perceptions. Results also suggest clickbait headlines may lower perceptions of credibility and quality. »
- Portée / limites : contexte journalistique ; les auteurs écrivent « may lower ». La taille de l'effet n'a pas été lue (texte intégral inaccessible : 403).
- En growth : arbitrer entre clic et confiance. Une accroche de type « fossé de curiosité » peut gagner sur le taux de clic et perdre en aval. Mesurer jusqu'à la conversion.

### Écrire des titres clairs, sans jargon à la mode, avec les mots-clés en tête
- Niveau de preuve : N4 (article de praticien NN/g s'appuyant sur ses études d'oculométrie, sans protocole détaillé)
- Source : Loranger H., 2015 (9 août), « Headings Are Pick-Up Lines: 5 Tips for Writing Headlines That Convert », Nielsen Norman Group, https://www.nngroup.com/articles/headings-pickup-lines/
- Extrait lu : « It is much better to aim for clarity and authenticity. » ; « Our eyetracking studies show that readers pay most attention to the first few words in lists. » ; « Moving the keywords to the front makes the heading more scannable. »
- Portée / limites : il s'agit d'une recommandation et non d'une mesure de conversion. L'oculométrie citée n'est pas détaillée (effectif inconnu).
- En growth : dans un titre ou une accroche, les deux ou trois premiers mots doivent porter le bénéfice ou le sujet. Un jeu de mots ne passe que si le sous-titre clarifie aussitôt.

---

## 5. Urgence et rareté

### Considérer l'effet de la rareté comme réel mais dépendant du contexte, et surtout mesuré sur des intentions
- Niveau de preuve : N2 (méta-analyse de 416 tailles d'effet issues de 131 études, Journal of Retailing)
- Source : Barton B., Zlatevska N., Oppewal H., 2022, « Scarcity tactics in marketing: A meta-analysis of product scarcity effects on consumer purchase intentions », Journal of Retailing 98(4), 741-758, https://pure.bond.edu.au/ws/portalfiles/portal/182976505/Scarcity_tactics_in_marketing.pdf
- Extrait lu : « Results show that demand-based scarcity is most effective for utilitarian products, supply-based scarcity for experiences, and time-based scarcity for high involvement products. » Limite : « Our dataset comprised only 24 effect sizes measuring actual […] with the balance (k = 384) measuring hypothetical situations. » ; « purchase intentions do not always result in actual purchases »
- Portée / limites : les études portent surtout sur des scénarios hypothétiques. Les auteurs signalent que la différence entre achat en ligne et en magasin reste à étudier.
- En growth : choisir le type de rareté selon le produit (stock, demande ou délai). Une méta-analyse d'intentions déclarées ne garantit pas un effet sur les ventes en ligne.

### En ligne, ne pas compter sur un « offre limitée dans le temps » pour faire mieux qu'une offre identique sans limite ; si la limite est réelle, en donner la raison externe
- Niveau de preuve : N2 (méta-analyse et expériences, Journal of Marketing Research)
- Source : Hmurovic J., Lamberton C., Goldsmith K., 2023, « Examining the Efficacy of Time Scarcity Marketing Promotions in Online Retail », Journal of Marketing Research 60(2), 299-328, https://pure.psu.edu/en/publications/examining-the-efficacy-of-time-scarcity-marketing-promotions-in-o/ (résumé seul lu)
- Extrait lu : « the authors report meta-analytic and experimental results suggesting that previously identified positive effects of time scarcity promotions observed offline may not emerge in online shopping contexts. » ; « online time scarcity promotions activate more persuasion knowledge than identical control promotions » ; « results stop short of suggesting that online time scarcity promotions will consistently yield superior outcomes compared with identical online control promotions. »
- Portée / limites : les auteurs constatent qu'une justification extérieure au vendeur (anniversaire du client, changement de saison) rend un effet positif plus probable, surtout près de l'échéance. Les tailles d'effet n'ont pas été lues.
- En growth : un compte à rebours générique sur une landing active la méfiance (connaissance des techniques de persuasion). Si une échéance réelle existe (fin de cohorte, fin de saison, hausse de prix datée), la nommer et l'expliquer.

### Ne jamais afficher une urgence ou une disponibilité limitée fausse : c'est une pratique réputée trompeuse
- Niveau de preuve : N1
- Source : Code de la consommation, article L121-4, 7°, version en vigueur depuis le 28 mai 2022, https://www.legifrance.gouv.fr/codes/article_lc/LEGIARTI000044563107
- Extrait lu : « De déclarer faussement qu'un produit ou un service ne sera disponible que pendant une période très limitée […] afin d'obtenir une décision immédiate et priver les consommateurs d'une possibilité ou d'un délai suffisant »
- Portée / limites : droit français, liste des pratiques « réputées trompeuses ». La correspondance avec le point 7 de l'annexe I de la directive 2005/29/CE n'a pas été vérifiée sur EUR-Lex (inaccessible). Les sanctions n'ont pas été vérifiées.
- En growth : tout « plus que 3 places » ou « offre valable jusqu'à minuit » doit être vrai et traçable. Un minuteur qui repart à zéro au rechargement de la page est exclu.

### Savoir que les faux comptes à rebours sont un motif de contrôle effectif dans l'UE
- Niveau de preuve : N3 (communiqué de la Commission européenne sur une opération de contrôle du réseau CPC)
- Source : Commission européenne, 30 janvier 2023, communiqué IP/23/418, « Consumer protection: manipulative online practices found on 148 out of 399 online shops screened », https://ec.europa.eu/commission/presscorner/api/files/document/print/en/ip_23_418/IP_23_418_EN.pdf
- Extrait lu : « 42 websites used fake countdown timers with deadlines to purchase specific products; »
- Portée / limites : il s'agit d'un contrôle de conformité (sweep) sur 399 boutiques de détail, pas d'une étude d'effet sur les ventes.
- En growth : le risque n'est pas théorique. Un minuteur fictif expose à une action des autorités nationales et coûte en réputation.

---

## 6. Pages d'atterrissage

### Faire comprendre la proposition de valeur en moins de 10 secondes
- Niveau de preuve : N4 (article de Jakob Nielsen, NN/g) s'appuyant sur une étude N2 (Liu et al., Microsoft Research, 205 873 pages ; étude primaire non ouverte)
- Source : Nielsen J., 2011 (11 septembre), « How Long Do Users Stay on Web Pages? », Nielsen Norman Group, https://www.nngroup.com/articles/how-long-do-users-stay-on-web-pages/
- Extrait lu : « Users often leave Web pages in 10–20 seconds » ; « 99% of web pages have a negative aging effect » ; « To gain several minutes of user attention, you must clearly communicate your value proposition within 10 seconds. »
- Portée / limites : la donnée mesure la durée de visite, pas la conversion. La recommandation sur la proposition de valeur est une inférence de Nielsen à partir de la forme de la distribution, pas un résultat testé.
- En growth : le haut de page doit répondre en quelques secondes à « qu'est-ce que c'est, pour qui, quel bénéfice ». Un test des cinq secondes sur des utilisateurs représentatifs est un contrôle bon marché.

### Mettre le contenu prioritaire en haut de page, sans croire que rien n'est lu en dessous
- Niveau de preuve : N3/N4 (NN/g, oculométrie : 120 participants, plus de 130 000 fixations, écran 1920×1080)
- Source : Fessenden T., 2018 (15 avril), « Scrolling and Attention », Nielsen Norman Group, https://www.nngroup.com/articles/scrolling-and-attention/
- Extrait lu : « users spent about 57% of their page-viewing time above the fold » ; 74 % du temps de lecture se concentre sur les deux premiers écrans ; en 2010, « 80% of the viewing time » se situait au-dessus de la ligne de flottaison (écrans 1024×768).
- Portée / limites : mesures sur ordinateur et non sur mobile, tâches dirigées sur des sites d'actualité, d'e-commerce, de blogs, etc. Ce n'est pas une mesure de conversion.
- En growth : le mythe vaut dans les deux sens. Oui, la moitié de l'attention se joue au premier écran, donc il porte la promesse et le CTA principal. Non, le bas de page n'est pas mort : environ 43 % du temps est passé sous le premier écran.

### Rédiger le CTA pour dire ce qui se passe après le clic
- Niveau de preuve : N3/N4 (observations qualitatives NN/g lors de tests utilisateurs, par ex. 8 utilisateurs sur un site de livraison de repas ; oculométrie dont l'effectif n'est pas précisé)
- Source : Harley A., Flaherty K., 2017 (20 août), « "Get Started" Stops Users », Nielsen Norman Group, https://www.nngroup.com/articles/get-started/
- Extrait lu : le CTA générique « attracts clicks, but also misleads users » ; recommandation : « avoid a generic call-to-action and increase the information scent by stating precisely what users should expect. »
- Portée / limites : l'étude est qualitative et ne fournit pas de mesure de conversion. Le problème décrit est un « Commencer » qui mène à une inscription ou un quiz alors que l'utilisateur cherchait de l'information.
- En growth : « Créer mon planning » ou « Voir les tarifs » plutôt que « Commencer ». Si le clic mène à une inscription, le dire.

### Faire correspondre la page à l'annonce et à la recherche qui y mènent
- Niveau de preuve : N3 (aide officielle Google Ads)
- Source : Google Ads Help, « Landing page experience: Definition », https://support.google.com/google-ads/answer/1659694?hl=en ; et « About Quality Score for Search campaigns », https://support.google.com/google-ads/answer/2404197?hl=en
- Extrait lu : « Landing pages with higher ratings are usually well organized and have text that relates to a person's search terms. » ; composante du Quality Score : « Landing page experience: How relevant and useful your landing page is to people who click your ad. » ; « Quality Score is not an input in the ad auction. »
- Portée / limites : c'est le point de vue de la plateforme publicitaire, pas une étude de conversion. Aucune source primaire n'a été trouvée pour les chiffres de « message match » qui circulent sur les blogs CRO (voir Non vérifié).
- En growth : le titre de la page reprend la promesse et les mots de l'annonce. Une annonce par intention, une page (ou une variante) par annonce.

---

## 7. Copywriting

### Utiliser AIDA, PAS et consorts comme aides à la rédaction, pas comme des modèles validés
- Niveau de preuve : N2 (revue de plus de 250 articles et livres, Journal of Marketing), nuancée par un acte de colloque (N2-, EMAC 2020)
- Source : Vakratsas D., Ambler T., 1999, « How Advertising Works: What Do We Really Know? », Journal of Marketing 63(1), DOI https://doi.org/10.1177/002224299906300103 (résumé lu via https://api.crossref.org/works/10.1177/002224299906300103) ; nuance : Valenti A., Yildirim G., Vanhuele M., Srinivasan S., Pauwels K., 2020, « Is the Hierarchy of Effects Dead or Alive? », Proceedings of EMAC, https://proceedings.emac-online.org/pdfs/A2020-63137.pdf
- Extrait lu : Vakratsas et Ambler : « The generalizations suggest that there is little support for any hierarchy, in the sense of temporal sequence, of effects. » Valenti et al. : « the original concept of hierarchy (which signifies "sequentiality") holds up firmly. However, the sequence varies across brands, with the Affect→Cognition→Experience being the most prevalent. »
- Portée / limites : ces travaux portent sur la publicité et ses effets intermédiaires (notoriété, attitude), pas sur la structure d'une page. Aucune étude comparant une page structurée en AIDA ou en PAS à une autre structure n'a été trouvée : les formules de copywriting relèvent de la convention de praticien (N4).
- En growth : une formule aide à ne rien oublier. Elle ne justifie pas un ordre « attention → intérêt → désir → action » comme loi de comportement. Le juge reste le test ou l'entretien utilisateur.

### Remplacer les affirmations vagues par des affirmations précises et vérifiables
- Niveau de preuve : N2 (expérience en ligne 2 × 2, 274 participants analysés, Journal of Advertising Research)
- Source : Ganz B., Grimes A., 2018, « How claim specificity can improve claim credibility in green advertising », Journal of Advertising Research 58(4), 476-486, version acceptée : https://eprints.whiterose.ac.uk/163071/8/How%20Claim%20Specificity%20Can%20Improve%20Claim%20Credibility%20in%20Green%20Advertising.pdf
- Extrait lu : « The results show that being specific increases the perceived credibility of green claims across a range of products, regardless of their perceived environmental relevance. »
- Portée / limites : il s'agit d'allégations environnementales et d'une crédibilité perçue, non de ventes. Un travail connexe (Jerez-Fernandez, Angulo et Oppenheimer 2014, Psychological Science) montre que la précision numérique est lue comme un signe de confiance en soi. Seul un article de presse de l'APS a été lu (https://www.psychologicalscience.org/news/were-only-human/precisely-right-no-doubt-trust-me.html), qui précise : « this all has to do with perceptions of confidence—not true expertise ».
- En growth : « 3 h gagnées par semaine sur la planification (moyenne de 40 familles bêta-testeuses) » plutôt que « gagnez du temps ». La précision doit être vraie : une fausse précision reste une allégation trompeuse.

### Bannir le ton promotionnel (« marketese ») : un texte objectif est plus utilisable
- Niveau de preuve : N2- (étude empirique ancienne et modeste : 51 participants dans l'étude de mesure, cinq versions, un seul site de sept pages)
- Source : Morkes J., Nielsen J., 1997, « Concise, SCANNABLE, and Objective: How to Write for the Web », Nielsen Norman Group, https://www.nngroup.com/articles/concise-scannable-and-objective-how-to-write-for-the-web/
- Extrait lu : la version de contrôle était rédigée en « promotional style (i.e., "marketese") » ; la version objective présentait l'information « without exaggeration, subjective claims, or boasting ». L'utilisabilité mesurée progresse de 27 % pour la version objective, de 58 % pour la version concise, de 47 % pour la version scannable et de 124 % pour les trois combinées.
- Portée / limites : l'étude date de 1997, avec un site touristique fictif, des tâches dirigées et un score composite (temps, erreurs, mémorisation, satisfaction). Elle ne mesure pas la conversion. Les auteurs écrivent eux-mêmes que d'autres recherches sont nécessaires.
- En growth : supprimer les superlatifs et l'autopromotion non prouvée (« la meilleure solution », « révolutionnaire »). Chaque phrase doit apporter un fait, une preuve ou une action.

### Écrire simple : la lisibilité augmente l'engagement
- Niveau de preuve : N2 (plus de 4 000 publications Facebook analysées et des expériences, Journal of Consumer Psychology)
- Source : Pancer E., Chandler V., Poole M., Noseworthy T. J., 2019 (en ligne en 2018), « How Readability Shapes Social Media Engagement », Journal of Consumer Psychology 29(2), DOI https://doi.org/10.1002/jcpy.1073 (résumé seul lu via https://api.crossref.org/works/10.1002/jcpy.1073)
- Extrait lu : « Consistent with a processing fluency account, we find that easy‐to‐read posts are more liked, commented on, and shared on social media. »
- Portée / limites : la métrique est l'engagement sur les réseaux sociaux (une page Facebook) et non la conversion sur une landing. Robertson et al. 2023 trouvent aussi qu'une complexité plus élevée réduit le taux de clic des titres.
- En growth : phrases courtes, mots courants, une idée par phrase. Mesurer la lisibilité d'une page FR avec un indice adapté au français (aucune source vérifiée ici sur ce point).

---

## Verdict sur les règles du profil

**1. « Une promesse par page : le hero porte LA proposition de valeur. Chaque claim porte sa preuve dessous. Le CTA dit ce qui se passe ensuite. »**
- *Le hero porte la proposition de valeur* : **soutenue** (N3/N4). Nielsen 2011 recommande une proposition de valeur comprise en 10 secondes ; NN/g 2018 mesure environ 57 % du temps de lecture au-dessus de la ligne de flottaison et recommande d'y placer le contenu prioritaire.
- *Une seule promesse par page* : **convention sans preuve trouvée**. Aucune étude comparant une promesse unique à plusieurs promesses n'a été trouvée. La règle est cohérente avec la logique d'annonce → page (Google Ads, N3), mais elle n'est pas testée.
- *Chaque claim porte sa preuve* : **soutenue indirectement** (N2 sur la crédibilité perçue). Une affirmation précise est jugée plus crédible (Ganz et Grimes 2018) ; le ton promotionnel nuit (Morkes et Nielsen 1997) ; les avis et preuves sociales réelles ont un effet (Spiegel 2017, Cai et al. 2009). La position « dessous » est une convention.
- *Le CTA dit ce qui se passe ensuite* : **soutenue** (N3/N4, observations qualitatives NN/g 2017). Aucune mesure de conversion publique n'a été trouvée.

**2. « Expérimentation : en dessous de quelques centaines de conversions par variante, on ne conclut rien de fin ; une seule variable testée à la fois ; verdict à la date pré-engagée. »**
- *Seuil de « quelques centaines de conversions »* : **contredite en tant que seuil** (la direction est juste, le chiffre est trop bas). Pour détecter +10 % relatif sur un taux de base de 3,7 % (puissance 80 %, α = 0,05), il faut environ 41 600 visiteurs, soit environ 1 540 conversions par variante (Kohavi, Deng et Vermeer 2022). Un effet « fin » de 1 % demande environ 100 fois plus. Reformulation proposée : « effectif fixé par un calcul de puissance avant lancement, à partir du taux de base et de l'effet minimal visé ; sinon, pas de test fin ».
- *Une seule variable à la fois* : **contredite dans sa forme stricte**. Kohavi et al. 2007 la jugent « too restrictive », recommandent un seul facteur pour comprendre, des « bold bets and very different designs » pour trouver mieux, et des plans factoriels limités quand une interaction est suspectée. Les tests multivariés sont rarement utiles en ligne d'après les mêmes auteurs (2013), et peu réalistes à faible trafic. Reformulation proposée : « un facteur à la fois quand on veut savoir *pourquoi* ; une refonte entière contre l'existant quand on veut trouver *mieux* ; pas de test multivarié sans le trafic nécessaire ».
- *Verdict à la date pré-engagée* : **soutenue** (Kohavi et al. 2013 : « one final scorecard at the end of the experiment […] a multiple of weeks »).

**3. « Métrique de succès déclarée avant publication, niveau attendu, date d'évaluation. »** : **soutenue** (N2). Le critère d'évaluation global défini en amont est le « Tenet 1 » de Kohavi et al. 2013, qui ajoutent des critères standardisés, une métrique à court terme prédictive du long terme et une date fixe. Le « niveau attendu » correspond à l'effet minimal détectable du calcul de puissance (Kohavi et al. 2022). Le préenregistrement est aussi la pratique des études les plus solides citées ici (Robertson et al. 2023 en Registered Report ; Miller et al. préenregistrée).

**4. « Anti-patterns : hype creuse, buzzwords, copy générique SaaS (« simple, rapide, puissant »). »**
- *Hype creuse et ton promotionnel* : **soutenue**, avec une preuve ancienne et modeste (Morkes et Nielsen 1997, N2-), renforcée par Ganz et Grimes 2018 (la spécificité augmente la crédibilité) et par Molyneux et Coddington 2020 (le racolage tend à réduire la crédibilité perçue).
- *La liste « simple, rapide, puissant »* : **convention sans preuve trouvée**. Aucune étude ne teste ces mots en particulier. Le fond est soutenu : ces mots sont des affirmations non spécifiques, sans preuve.

---

## Mythes et affirmations contestées

- **« Les avis multiplient les ventes par 3,7 (+270 %) »** : le chiffre est exact, mais pour 5 avis contre 0, chez un seul détaillant de cadeaux haut de gamme, en données observationnelles, dans un rapport co-signé par un éditeur de solutions d'avis (Spiegel/PowerReviews 2017). Ce n'est pas un effet attendu pour n'importe quel site.
- **« La note idéale est 4,2-4,5 »** : non trouvé dans la source. Spiegel 2017 situe le pic entre 4,0 et 4,7 et compare les tranches 4,7-5,0 et 4,2-4,7.
- **« La plupart des tests réussissent si on a de bonnes idées »** : contredit. Environ un tiers chez Microsoft, 8 à 15 % dans les domaines très optimisés (Kohavi et al. 2013 et 2022).
- **« Un test A/B sérieux = une seule variable »** : contredit dans sa forme stricte (Kohavi et al. 2007).
- **« Tout doit être au-dessus de la ligne de flottaison » et, à l'inverse, « la ligne de flottaison n'existe plus »** : les deux sont faux. L'attention chute nettement sous le premier écran, mais environ 43 % du temps de lecture se passe en dessous (NN/g 2018).
- **« Les titres négatifs convertissent mieux »** : non démontré. Robertson et al. 2023 mesurent des clics sur des titres d'actualité Upworthy, pas des conversions. Le racolage tend à réduire la crédibilité perçue (Molyneux et Coddington 2020).
- **« Les prix en 9 marchent toujours »** : seulement quand le chiffre de gauche change (Thomas et Morwitz 2005), et mieux sur les produits nouveaux ou sans affichage « Soldes » (Anderson et Simester 2003). Les prix ronds sont associés au haut de gamme (Stiving 2000).
- **« L'urgence augmente toujours les ventes »** : en ligne, une offre limitée dans le temps ne surpasse pas de façon fiable une offre identique sans limite, et active la méfiance (Hmurovic et al. 2023). La méta-analyse sur la rareté repose à environ 94 % sur des intentions hypothétiques (Barton et al. 2022). Les chiffres de fournisseurs (« rareté +2,9 % », « urgence +1,5 % ») n'ont pas été vérifiés à la source.
- **« Un essai avec carte bancaire / renouvellement automatique convertit à 50 % contre 15 % »** : il s'agit de chiffres de fournisseurs, non vérifiés, et de surcroît trompeurs par leur dénominateur : le taux de conversion de l'essai augmente parce que moins de gens entrent dans l'essai. L'expérience randomisée de Miller, Sahni et Strulov-Shlain trouve −35 % d'adhésion et −23 % d'abonnés totaux à 20 mois avec le renouvellement automatique.
- **« AIDA est un modèle validé du comportement d'achat »** : contesté (Vakratsas et Ambler 1999), débat rouvert (Valenti et al. 2020), et sans aucun test trouvé sur la structure de page.
- **« L'ancrage est une loi »** : plusieurs résultats d'ancrage sont fragiles en réplication (Maniadis, Tufano et List 2014).

---

## Non vérifié

- **Méta-analyse Qubit (Browne et Swarbrick Jones, 2017, « What works in e-commerce – a meta-analysis of 6700 online experiments »)** : le PDF d'origine (qubit.com) est inaccessible et la copie d'archive n'a pas pu être ouverte. Les chiffres qui circulent (rareté +2,9 %, preuve sociale +2,3 %, urgence +1,5 %, boutons −0,2 %) viennent de résumés de presse ou de fournisseurs, avec des incohérences entre eux. **Non vérifié.**
- **Livre « Trustworthy Online Controlled Experiments »** (Kohavi, Tang, Xu 2020) : non ouvert. Les chiffres « un tiers » et « 10 % » ont été vérifiés dans les papiers de 2013 et 2022, pas dans le livre.
- **Chiffres Google (« about 10 percent ») et Netflix (« 90% wrong »)** : connus seulement par la citation de seconde main dans Kohavi et al. 2013 (Manzi, Moran). Les sources primaires n'ont pas été ouvertes.
- **Maslowska, Malthouse et Bernritter 2017, « Too good to be true »** (International Journal of Advertising) : la référence est confirmée, mais le résumé n'a pas été lu (page bloquée). Le résultat n'est connu qu'à travers le rapport Spiegel.
- **Darley et Smith 1993, « Advertising Claim Objectivity »** (Journal of Marketing) : seuls des extraits de moteur de recherche ont été vus, le résumé n'a pas été ouvert. Non cité comme source.
- **Jerez-Fernandez, Angulo et Oppenheimer 2014** (Psychological Science) : seul un article de presse de l'APS a été lu, pas l'article original.
- **Chiffre « Revoo : +67 % de conversion quand on interagit avec des avis négatifs »** : de seconde main dans le rapport Spiegel. Non vérifié.
- **Statistiques « opt-in vs opt-out trial »** (First Page Sage, ChartMogul, Softletter, Visionary Marketing) : uniquement relayées par des blogs, sans méthodologie vérifiée. **Non vérifié.**
- **Chiffres de « message match »** (gain de conversion annonce → page) : aucune source primaire trouvée.
- **Étude CHI EA 2023 sur les comptes à rebours trompeurs** (DOI 10.1145/3544549.3585735, N = 245 selon l'extrait de recherche) et **« Tuncer et al. 2023 »** sur les émotions négatives suscitées par la rareté : non ouvertes. Non vérifié.
- **Texte de la directive 2005/29/CE, annexe I, point 7** : EUR-Lex était inaccessible pendant la recherche. Seule la règle française (L121-4 7°) a été lue ; la correspondance exacte avec le texte européen n'a pas été vérifiée. Sanctions non vérifiées.
- **Effet de la correction 2024 de l'archive Upworthy sur Robertson et al. 2023** : le chevauchement des périodes est constaté, mais aucune analyse de son impact n'a été lue.
- **Statut de publication de Miller et Hosanagar (2020)** et de **Miller, Sahni et Strulov-Shlain (version janvier 2026)** : ce sont des documents de travail ; une éventuelle publication revue par les pairs n'a pas été vérifiée.
- **Indice de lisibilité adapté au français** (Flesch adapté, Kandel-Moles, etc.) et lien avec la conversion : non recherché, non vérifié.

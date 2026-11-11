# Fiche `ux-preuves` — Formulaires, navigation, mobile, temps de réponse

> Fiche du skill `ux-preuves` (dev-fullstack). Couvre : formulaires et saisie, checkout, authentification ; navigation, architecture d'information, recherche interne ; mobile et tactile ; temps de réponse et performance perçue.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Mythes » et « Non
> vérifié » en fin de fiche sont opposables autant que les entrées : ce qui y figure ne se cite
> pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Recherche du 09.11.2026. Chaque entrée repose sur une page réellement ouverte (WebFetch, ou PDF
téléchargé puis extrait avec `pdftotext` quand c'est précisé). Les extraits sont verbatim dans
la langue d'origine. 35 entrées.

Niveaux : N1 norme/réglementation · N2 recherche revue par pairs ou étude empirique à large
échantillon · N3 guideline officielle d'institution ou de plateforme · N4 avis d'expert, article
de praticien.

Remarque de méthode : les articles NN/g et Baymard sont des synthèses de recherches
propriétaires dont la méthode complète n'est pas publiée dans l'article lu. Ils sont classés N2
seulement quand la page lue établit la condition de l'échelle du `SKILL.md`, qui fait foi (grand
échantillon et méthode publiée) ; sinon N4, NN/g comme Baymard — la parenthèse de chaque entrée dit
ce qui manque. Les entrées marquées « N2 faible » jusqu'au 10.11.2026 (niveau absent de l'échelle)
ont été reclassées le 11.11.2026 : quatre Baymard en N4, « Milliseconds make millions » en N2 avec
ses réserves.

---

## 1. Formulaires et saisie

### Placer le label au-dessus du champ, aligné à gauche, pour les formulaires mobiles et courts
- Niveau de preuve : N4
- Source : Kathryn Whitenton (NN/g), 2016, « Website Forms Usability: Top 10 Recommendations », https://www.nngroup.com/articles/web-form-design/ — appui empirique : Matteo Penzo, 2006, « Label Placement in Forms », UXmatters, https://www.uxmatters.com/mt/archives/2006/07/label-placement-in-forms.php
- Extrait lu : « immediately above the field for mobile and shorter desktop forms » (NN/g). Penzo, sur sa propre étude : « Please note that our ad-hoc test setup didn't resemble real-world conditions. »
- Portée / limites : NN/g admet le label à gauche pour les formulaires desktop très longs. L'étude oculométrique de Penzo (saccades d'environ 50 ms label-au-dessus contre environ 500 ms label aligné à gauche à gauche du champ) ne donne pas son nombre de participants, porte sur des formulaires de quatre champs obligatoires, et mesure la vitesse, pas l'utilisabilité (« what we tested was performance in terms of time, or speed »). Ne pas en tirer un gain chiffré général.

### Ne jamais utiliser le placeholder comme label : label visible, hors du champ
- Niveau de preuve : N4
- Source : Katie Sherwin (NN/g), 2014 (revu 2018), « Placeholders in Form Fields Are Harmful », https://www.nngroup.com/articles/form-design-placeholders/
- Extrait lu : « the best solution is to have clear, visible labels that are placed outside empty form fields. »
- Portée / limites : sept motifs listés (mémoire de travail, impossibilité de relire avant envoi, correction d'erreur, navigation clavier, champ moins visible, confusion avec une donnée préremplie, suppression manuelle). Synthèse d'observations de tests, sans échantillon chiffré dans l'article.

### Disposer le formulaire sur une seule colonne ; seuls deux ou trois champs liés (ville / NPA) partagent une ligne
- Niveau de preuve : N4 (tests d'utilisabilité Baymard, échantillon non chiffré dans l'article : condition de N2 non établie)
- Source : Edward Scott (Baymard Institute), 2023, « Form Field Usability: Avoid Extensive Multicolumn Layouts (16% Make This Form Usability Mistake) », https://baymard.com/blog/avoid-multi-column-forms
- Extrait lu : « single-column layouts resulted in fewer skipped fields, misinterpreted fields, and errors compared to multicolumn layouts. »
- Portée / limites : contexte e-commerce (checkout). Une mise en page globale à deux colonnes est dite « generally problematic and never recommended ». Concordant avec NN/g (« Present fields in a single column layout. », même article que l'entrée sur les labels).

### Valider un champ libre après que la personne a fini de le remplir, jamais dès la prise de focus
- Niveau de preuve : N4 (étude de praticien, 22 participants, non revue par pairs)
- Source : Luke Wroblewski, 2009, « Inline Validation in Web Forms », A List Apart, https://alistapart.com/article/inline-validation-in-web-forms/
- Extrait lu : « give feedback after the user finishes providing an answer » ; et : « validating inputs prematurely can be harmful. »
- Portée / limites : 22 utilisateurs de 21 à 49 ans, six variantes d'un formulaire d'inscription. La meilleure variante en ligne contre validation à l'envoi : +22 % de réussite, −22 % d'erreurs, +31 % de satisfaction, −42 % de temps, −47 % de fixations. Petit échantillon, un seul formulaire, 2009. La variante « before and while » (dès le focus) a les pires taux d'erreur. Contredit en partie par GOV.UK (entrée suivante).

### Par défaut, valider à l'envoi de la page, pas en quittant le champ ; la validation en ligne demande une preuve de recherche utilisateur
- Niveau de preuve : N3
- Source : GOV.UK Design System, s. d. (consulté le 09.11.2026), « Validation », https://design-system.service.gov.uk/patterns/validation/
- Extrait lu : « Do not validate when the user moves away from a field. » ; « This sort of validation can cause problems - especially for users who type more slowly. »
- Portée / limites : services publics britanniques, populations très larges incluant les personnes qui tapent lentement et les technologies d'assistance. Exception citée : le compteur de caractères. À arbitrer contre Wroblewski 2009 selon le public : c'est un désaccord réel entre sources, pas une règle unique.

### Message d'erreur : dire ce qui s'est passé et comment corriger, en langage simple, à côté du champ et dans un récapitulatif en tête de page ; ne pas vider les champs
- Niveau de preuve : N3
- Source : GOV.UK Design System, s. d. (consulté le 09.11.2026), « Error message », https://design-system.service.gov.uk/components/error-message/
- Extrait lu : « Describe what has happened and tell them how to fix it. » ; « Do not clear any form fields when showing the Error message component. Keep both passing and failing answers. »
- Portée / limites : proscrit « sorry ». Même message dans le champ et dans le récapitulatif (« Error summary »). Ne dit pas à quel moment afficher l'erreur (renvoie implicitement au motif Validation).

### Identifier l'erreur en texte, pas seulement par la couleur (WCAG 3.3.1, niveau A)
- Niveau de preuve : N1
- Source : W3C WAI, WCAG 2.2, « Understanding SC 3.3.1 Error Identification », https://www.w3.org/WAI/WCAG22/Understanding/error-identification.html
- Extrait lu : « If an input error is automatically detected, the item that is in error is identified » … « the error is described to the user in text. »
- Portée / limites : la suggestion de correction relève de 3.3.3 (Error Suggestion) ; un même message peut satisfaire les deux. La couleur est admise « in addition to the text description ».

### Marquer les champs facultatifs par « (optionnel) » et ne jamais marquer les obligatoires par un astérisque ; réduire le nombre de champs facultatifs
- Niveau de preuve : N3
- Source : GOV.UK Design System, s. d. (consulté le 09.11.2026), « Question pages », https://design-system.service.gov.uk/patterns/question-pages/
- Extrait lu : « in most contexts, add ‘(optional)’ to the labels of optional fields. » ; « Never mark mandatory fields with asterisks. »
- Portée / limites : la page ne motive pas l'interdiction de l'astérisque. NN/g (Whitenton 2016, entrée « labels ») va dans le même sens : « Limit the form to only 1 or 2 optional fields, and clearly label them as optional. » Convention inverse très répandue (astérisque) : c'est un choix de convention, à tenir de façon cohérente.

### Une question par page pour les parcours longs ou complexes (« one thing per page »)
- Niveau de preuve : N3
- Source : GOV.UK Design System, s. d. (consulté le 09.11.2026), « Question pages », https://design-system.service.gov.uk/patterns/question-pages/
- Extrait lu : « Asking just one question per question page helps users understand what you’re asking them to do »
- Portée / limites : la page ne donne pas de mesure ; c'est une doctrine d'institution issue de ses propres tests. Utiliser le label ou la légende comme titre de page évite la double lecture par les lecteurs d'écran. N'implique pas qu'un formulaire court (connexion, contact) doive être découpé.

### Le taux moyen d'abandon de panier documenté est d'environ 70 % ; la première cause est le surcoût découvert tard, pas l'ergonomie
- Niveau de preuve : N2 (agrégat de 50 études publiées 2006–2025 ; enquête causes : échantillon non publié sur la page)
- Source : Baymard Institute, page mise à jour (consultée le 09.11.2026), « Cart Abandonment Rate Statistics », https://baymard.com/lists/cart-abandonment-rate
- Extrait lu : « Based on the data we collected, we’ve calculated the average cart abandonment rate of 70.22%. »
- Portée / limites : moyenne non pondérée d'études hétérogènes. Les causes sont calculées après exclusion des personnes qui « regardaient seulement » (42 % des répondants US) : surcoûts 40 %, livraison lente 20 %, méfiance carte 19 %, création de compte imposée 18 %, checkout trop long ou compliqué 17 %, erreurs du site 17 %, coût total invisible d'avance 12 %. La page ne donne ni la taille ni la date de l'enquête.

### Viser 12 à 14 éléments de formulaire (7 à 8 champs) dans un checkout, contre 23,48 en moyenne aux États-Unis
- Niveau de preuve : N4 (benchmark Baymard, méthode non détaillée sur la page : condition de N2 non établie)
- Source : Baymard Institute (consultée le 09.11.2026), « Cart Abandonment Rate Statistics », https://baymard.com/lists/cart-abandonment-rate
- Extrait lu : « The average US checkout shows 23.48 form elements versus an ideal 12–14. » ; « the average large-sized ecommerce site can gain a 35.26% increase in conversion rate though better checkout design. »
- Portée / limites : grands sites e-commerce US/Europe. Le +35,26 % est une estimation de potentiel par Baymard, pas un résultat d'expérience contrôlée.

### Déclarer la finalité des champs personnels (attribut `autocomplete`) pour permettre le remplissage automatique (WCAG 1.3.5, niveau AA)
- Niveau de preuve : N1
- Source : W3C WAI, WCAG 2.2, « Understanding SC 1.3.5 Identify Input Purpose », https://www.w3.org/WAI/WCAG22/Understanding/identify-input-purpose.html
- Extrait lu : « The purpose of each input field collecting information about the user can be programmatically determined when: »
- Portée / limites : ne vaut que pour les finalités de la liste « Input Purposes » de WCAG (nom, adresse, téléphone, e-mail…). Bénéfice explicite pour les handicaps cognitifs et moteurs. GOV.UK (page « Text input ») rend l'attribut obligatoire en production pour cette raison.

### Ne pas redemander dans un même parcours une information déjà fournie : la préremplir ou la proposer (WCAG 3.3.7, niveau A)
- Niveau de preuve : N1
- Source : W3C WAI, WCAG 2.2, « Understanding SC 3.3.7 Redundant Entry », https://www.w3.org/WAI/WCAG22/Understanding/redundant-entry.html
- Extrait lu : « previously entered by or provided to the user » … « required to be entered again in the same process » … « auto-populated » … « available for the user to select. »
- Portée / limites : exceptions — ressaisie essentielle, sécurité, information devenue invalide. Cas typique : adresse de facturation identique à la livraison.

### N'utiliser un masque de saisie que pour les champs à format contraint (téléphone, date, carte), localisé et tolérant à l'édition ; sinon le désactiver
- Niveau de preuve : N4 (tests checkout Baymard, échantillon non chiffré dans l'article : condition de N2 non établie)
- Source : Edward Scott (Baymard Institute), 2017, « Input masking form field » (titre de l'URL), https://www.baymard.com/blog/input-masking-form-field
- Extrait lu : « we recommend implementing input masks for restricted form fields such as phone number, date, credit card auto-spacing, » ; « An input mask that doesn’t align with a user’s domestic formatting will often result in an abandonment »
- Portée / limites : 64 % des sites du benchmark n'en utilisent pas ou mal. Risque principal observé : la logique du masque ne gère pas l'édition au milieu du champ. L'article ne traite ni du copier-coller ni des conflits avec l'autoremplissage — à tester soi-même.

### Mots de passe : longueur minimale, aucune règle de composition, pas de changement périodique, coller autorisé, option « afficher »
- Niveau de preuve : N1 (norme fédérale US)
- Source : NIST, 2025 (rév. 4), « SP 800-63B Digital Identity Guidelines: Authentication and Authenticator Management », https://pages.nist.gov/800-63-4/sp800-63b.html
- Extrait lu : « SHALL NOT impose other composition rules (e.g., requiring mixtures of different character types) for passwords. » ; « SHOULD offer an option to display the password — rather than a series of dots or asterisks — while it is entered »
- Portée / limites : §3.1.1.2. Minimum 15 caractères en facteur unique, 8 en multi-facteur ; comparaison obligatoire à une liste de mots de passe compromis ; pas d'indice mémorisé ; pas de changement périodique imposé (sauf compromission). Norme d'administration US : opposable aux agences fédérales, référence de fait ailleurs. Seuls les 100 000 premiers caractères de la page ont été lus.

### Ne pas bloquer le coller ni les gestionnaires de mots de passe à la connexion (WCAG 3.3.8, niveau AA)
- Niveau de preuve : N1
- Source : W3C WAI, WCAG 2.2, « Understanding SC 3.3.8 Accessible Authentication (Minimum) », https://www.w3.org/WAI/WCAG22/Understanding/accessible-authentication-minimum.html
- Extrait lu : « Copy and paste can be relied on to avoid transcription. »
- Portée / limites : retenir un mot de passe propre au site est un « cognitive function test » ; il faut donc un mécanisme d'aide (gestionnaire, coller) ou une alternative. Bloquer le coller ou l'autoremplissage échoue au critère sauf autre méthode offerte.

---

## 2. Navigation, architecture d'information, recherche interne

### Sur desktop, ne pas cacher la navigation principale derrière un hamburger
- Niveau de preuve : N2 (179 participants, 6 sites réels, desktop et smartphone)
- Source : Kara Pernice et Raluca Budiu (NN/g), 2016, « Hamburger Menus and Hidden Navigation Hurt UX Metrics », https://www.nngroup.com/articles/hamburger-menus/
- Extrait lu : « Do not use hidden navigation (such as hamburger icons) in desktop user interfaces. » ; « people were at least 39% slower when the navigation was hidden »
- Portée / limites : chute de découvrabilité de plus de 20 % (tous appareils) ; usage de la navigation cachée 27 % sur desktop contre 57 % sur mobile. Difficulté perçue 2,6 (caché) / 2,3 (combo) / 2,1 (visible) sur 7. Sites de 2016, méthode NN/g non revue par pairs.

### Sur mobile, afficher en clair jusqu'à quatre liens de premier niveau ; au-delà, une navigation combinée (liens visibles + menu) bat le hamburger seul
- Niveau de preuve : N2 (même étude, 179 participants)
- Source : Kara Pernice et Raluca Budiu (NN/g), 2016, « How to Make Navigation (Even a Hamburger) Discoverable on Mobile », https://www.nngroup.com/articles/find-navigation-mobile-even-hamburger/ — règle des quatre liens dans l'article compagnon ci-dessus
- Extrait lu : « hiding global navigation degrades the user experience both on desktop and on mobile. » ; « If your site has 4 or fewer top-level navigation links, display them as visible links. »
- Portée / limites : l'effet est plus faible sur mobile et varie selon les sites (usage de la navigation : 89 % sur un site combo contre 44 % sur un site à menu caché peu saillant). La différence mobile/desktop n'était pas statistiquement significative.

### Le fil d'Ariane montre la hiérarchie, pas l'historique ; il complète la navigation sans la remplacer ; le dernier élément (page courante) n'est pas un lien
- Niveau de preuve : N4
- Source : Page Laubheimer (NN/g), 2018 (revu 2026), « Breadcrumbs: 11 Design Guidelines for Desktop and Mobile », https://www.nngroup.com/articles/breadcrumbs/
- Extrait lu : « Breadcrumbs are not intended to show the history of pages traversed during a session on the site. » ; « The last breadcrumb (denoting the current page) should not be a link. »
- Portée / limites : utile pour les sites à hiérarchie profonde ; inutile pour un site plat. Lignes directrices d'expert sans échantillon chiffré.

### Une page « zéro résultat » doit offrir une suite : catégories liées, requêtes alternatives, aide humaine, contenus populaires — les conseils de saisie seuls ne suffisent pas
- Niveau de preuve : N4 (tests de recherche interne Baymard et benchmark, échantillon non chiffré dans l'article : condition de N2 non établie)
- Source : Sonia Sousa (Baymard Institute), 2019 (maj 2025), « No Results Page » (titre de l'URL), https://baymard.com/blog/no-results-page
- Extrait lu : « nearly 50% of sites fail to provide users with effective ways to recover from a search that yields no results. » ; « search tips aren't enough on their own. »
- Portée / limites : e-commerce. Cinq stratégies recommandées (catégories liées, recherches alternatives, recommandations personnalisées, téléphone/chat/aide, produits populaires). Le chiffre plus ancien « 68 % de culs-de-sac » n'a été vu que dans des résumés tiers.

### Suggestions de recherche : ne suggérer que des requêtes qui ont de bons résultats, et distinguer visuellement la saisie de la complétion
- Niveau de preuve : N4 (avec une mesure : 31 sélections sur 136 occasions)
- Source : Kate Moran (NN/g), 2018, « Site Search Suggestions », https://www.nngroup.com/articles/site-search-suggestions/
- Extrait lu : « Make sure every suggested query actually has good, relevant results. »
- Portée / limites : dans une étude e-commerce, suggestions choisies dans 23 % des cas (marge ± 7 %). L'article ne fixe ni nombre de suggestions, ni support clavier, ni gestion des fautes : ne pas lui attribuer ces règles. Sur mobile, préférer des suggestions texte simples.

### Card sorting pour générer la structure, tree testing pour l'évaluer ; viser environ 15 participants pour un card sorting ouvert
- Niveau de preuve : N4 (Nielsen rapporte Tullis & Wood, UPA 2004, non lu)
- Source : Jakob Nielsen (NN/g), 2004, « Card Sorting: How Many Users to Test », https://www.nngroup.com/articles/card-sorting-how-many-users-to-test/ — et Page Laubheimer (NN/g), 2023, « Tree Testing », https://www.nngroup.com/articles/tree-testing/
- Extrait lu : « my recommendation is to test 15 users. » ; « Card sorting is a generative method used for discovering possible groupings » ; tree testing : « a method solely used for evaluating a potential navigation hierarchy. »
- Portée / limites : 15 utilisateurs = corrélation de 0,90 avec le résultat asymptotique ; Tullis et Wood recommandent eux-mêmes 20 à 30. L'article tree testing ne donne pas d'effectif (« a larger sample size » en quantitatif) ; métriques : réussite, directness, temps.

---

## 3. Mobile et tactile

### Cibles tactiles : 24 × 24 px CSS minimum (WCAG 2.5.8, AA), 44 × 44 px CSS en niveau renforcé (WCAG 2.5.5, AAA)
- Niveau de preuve : N1
- Source : W3C WAI, WCAG 2.2, « Understanding SC 2.5.8 Target Size (Minimum) », https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html — et « Understanding SC 2.5.5 Target Size (Enhanced) », https://www.w3.org/WAI/WCAG22/Understanding/target-size-enhanced.html
- Extrait lu : « The size of the target for pointer inputs is at least 24 by 24 CSS pixels, except when: » ; « The size of the target for pointer inputs is at least 44 by 44 CSS pixels except when: »
- Portée / limites : 2.5.8 admet une cible plus petite si un cercle de 24 px centré sur elle ne recoupe aucune autre cible ni cercle (exception d'espacement), ainsi que les exceptions « equivalent », « inline », « user agent control », « essential ». 2.5.5 n'a pas d'exception d'espacement. 24 px est un minimum d'accessibilité, pas une taille de confort.

### Applications natives : contrôles d'au moins 44 × 44 pt sur iOS, zone tactile d'au moins 48 × 48 dp sur Android
- Niveau de preuve : N3
- Source : Apple Developer, s. d. (consulté le 09.11.2026), « UI Design Dos and Don'ts », https://developer.apple.com/design/tips/ — et Android Developers, s. d. (consulté le 09.11.2026), « Make apps more accessible », https://developer.android.com/guide/topics/ui/accessibility/apps
- Extrait lu : « Create controls that measure at least 44 points x 44 points so they can be accurately tapped with a finger. » (Apple) ; « we recommend that each interactive UI element have a focusable area, or touch target size, of at least 48dpx48dp. Larger is even better. » (Android)
- Portée / limites : la page HIG « Accessibility » (https://developer.apple.com/design/human-interface-guidelines/accessibility) et la page Material Design 3 (m3.material.io) n'ont pas pu être lues (rendu JavaScript) : les valeurs propres à visionOS, watchOS et macOS ne sont pas vérifiées, et le 48 dp l'est sur la documentation Android, pas sur Material. Android admet une cible plus petite en saisie précise (souris, trackpad). La zone tactile peut dépasser le dessin visible du contrôle.

### Concevoir pour des prises variées : environ la moitié des usages tactiles se font à une main, mais un tiers en berceau et 15 % à deux mains
- Niveau de preuve : N2 (1 333 observations de terrain, dont 780 en interaction tactile)
- Source : Steven Hoober, 2013, « How Do Users Really Hold Mobile Devices? », UXmatters, https://www.uxmatters.com/mt/archives/2013/02/how-do-users-really-hold-mobile-devices.php
- Extrait lu : « I did not record what individuals were doing because that would have been too intrusive. »
- Portée / limites : une main 49 %, berceau 36 %, deux mains 15 % ; à une main, pouce droit 67 %. Observation en lieux publics, téléphones seulement (le plus grand : Galaxy Note 2), sans démographie ni tâche ; les prises changent souvent. Hoober : « not the ultimate study ». Écrans de 2013, plus petits qu'aujourd'hui.

### Placer contenus et actions principales au centre de l'écran tactile ; prévoir des cibles plus grandes vers les coins (environ 7 mm au centre, 12 mm aux coins)
- Niveau de preuve : N4 (synthèse de terrain de l'auteur, plus de 1 300 + 651 observations et méta-revue citée)
- Source : Steven Hoober, 2017, « Design for Fingers, Touch, and People, Part 1 », UXmatters, https://www.uxmatters.com/mt/archives/2017/03/design-for-fingers-touch-and-people-part-1.php
- Extrait lu : « prefer to view and touch the center of the screen » ; « All of my suggested target sizes contain only 95% of all observed taps. »
- Portée / limites : Hoober y qualifie lui-même le schéma de « zone du pouce » de « well-known, but incorrect » (voir Mythes). Tailles exprimées en millimètres physiques, à convertir selon la densité d'écran.

### Choisir le clavier virtuel avec `inputmode` (et `type`/`autocomplete`) ; pour les nombres non arithmétiques, `inputmode="numeric"` plutôt que `type="number"` ; dimensionner le champ à la réponse attendue
- Niveau de preuve : N1 (WHATWG HTML Living Standard) + N3 (GOV.UK)
- Source : WHATWG, HTML Living Standard (consulté le 09.11.2026), § « Input modalities: the inputmode attribute », https://html.spec.whatwg.org/multipage/interaction.html#input-modalities:-the-inputmode-attribute — et GOV.UK Design System, « Text input », https://design-system.service.gov.uk/components/text-input/
- Extrait lu : « The user agent should display a virtual keyboard capable of numeric input. This keyword is useful for PIN entry. » (WHATWG) ; « Do not use `<input type="number">` unless your user research shows that there's a need for it. » (GOV.UK)
- Portée / limites : `inputmode` ne change pas la validation ; à défaut, le navigateur se fonde sur `type` ou `pattern`. GOV.UK motive le refus de `type="number"` (valeur modifiée en faisant défiler, retour peu clair sur une saisie non numérique) et demande des champs à largeur fixe pour les longueurs connues : « Postcode inputs should be postcode-sized ». `spellcheck="false"` pour noms, e-mails, références.

### Tout geste à trajectoire, à plusieurs doigts ou de glisser doit avoir une alternative à un seul pointeur, sans glisser (WCAG 2.5.1 niveau A, 2.5.7 niveau AA)
- Niveau de preuve : N1
- Source : W3C WAI, WCAG 2.2, « Understanding SC 2.5.1 Pointer Gestures », https://www.w3.org/WAI/WCAG22/Understanding/pointer-gestures.html — et « Understanding SC 2.5.7 Dragging Movements », https://www.w3.org/WAI/WCAG22/Understanding/dragging-movements.html
- Extrait lu : « All functionality that uses multipoint or path-based gestures for operation can be operated with a single pointer » ; « All functionality that uses a dragging movement for operation can be achieved by a single pointer without dragging, »
- Portée / limites : exception si le geste est essentiel, ou fourni par le navigateur et non modifié. Concrètement : un swipe pour supprimer exige aussi un bouton ; un curseur glissant exige des boutons ou un champ.

---

## 4. Temps de réponse et performance perçue

### Seuils de réponse : 0,1 s pour l'instantané, 1 s pour ne pas rompre le fil de pensée, 10 s pour garder l'attention ; au-delà de 10 s, indicateur de progression en pourcentage et moyen d'interrompre
- Niveau de preuve : N4 (synthèse d'expert, s'appuyant sur Miller 1968 et Card et al. 1991, non lus en texte intégral)
- Source : Jakob Nielsen (NN/g), 1993, mise à jour 2014, « Response Times: The 3 Important Limits », https://www.nngroup.com/articles/response-times-3-important-limits/
- Extrait lu : « is about the limit for having the user feel that the system is reacting instantaneously » (0,1 s) ; « As a rule of thumb, percent-done progress indicators should be used for operations taking more than about 10 seconds. »
- Portée / limites : extrait du livre *Usability Engineering* (1993). Ce sont des ordres de grandeur, pas des mesures nouvelles ; leur base empirique est celle des sources citées, dont la vérification est en « Non vérifié ». La version 2014 ajoute : « Anything slower than 10 seconds needs a percent-done indicator ».

### Indicateur selon la durée : rien sous 1 s ; animation en boucle (spinner) de 2 à 10 s ; barre en pourcentage à partir de 10 s
- Niveau de preuve : N4 (s'appuie sur Nah 2004, non lu)
- Source : Katie Sherwin (NN/g), 2014, « Progress Indicators Make a Slow System Less Insufferable », https://www.nngroup.com/articles/progress-indicators/
- Extrait lu : « use a looped indicator for delays of 2–9 seconds and a percent-done indicator for delays of 10 seconds »
- Portée / limites : l'article rapporte une étude de l'université du Nebraska-Lincoln (Nah, *Behaviour and Information Technology* 23(3), 2004) : avec barre en boucle, satisfaction plus haute et attente acceptée en moyenne trois fois plus longue — chiffre de seconde main, effectif non donné. La zone 1–2 s n'est pas couverte explicitement.

### Le skeleton screen convient au chargement d'une page entière de moins de 10 s ; le spinner à un module isolé ; il ne remplace pas l'optimisation
- Niveau de preuve : N4
- Source : Samhita Tankala (NN/g), 2023 (revu 2026), « Skeleton Screens 101 », https://www.nngroup.com/articles/skeleton-screens/
- Extrait lu : « skeleton screens should be used with a wait time that's under 10 seconds. » ; « If a page takes less than 1 second to load, skeleton screens or spinners aren't necessary »
- Portée / limites : l'affirmation que le skeleton « create[s] the illusion of a shorter wait time » est un raisonnement de l'autrice, pas un résultat mesuré dans l'article. Déconseille les skeletons « frame-display » (en-tête/pied seuls) et met en garde contre les animations distrayantes.

### Ne pas attendre du skeleton screen un gain de vitesse perçue démontré : l'étude publiée ne trouve aucune différence significative avec un spinner
- Niveau de preuve : N2 (actes revus par pairs, ECCE 2018 ; **résumé seul lu**)
- Source : Thomas Mejtoft, Arvid Långström, Ulrik Söderström, 2018, « The effect of skeleton screens: Users' perception of speed and ease of navigation », Proceedings of the 36th European Conference on Cognitive Ergonomics, DOI 10.1145/3232078.3232086 — résumé lu via https://api.semanticscholar.org/graph/v1/paper/DOI:10.1145/3232078.3232086?fields=title,abstract,authors,year,venue
- Extrait lu : résumé restitué en paraphrase par l'outil (pas de citation verbatim obtenue) : skeleton mieux noté en moyenne sur la vitesse perçue et la facilité de navigation, spinner plus rapide pour trouver l'article, aucune différence statistiquement significative.
- Portée / limites : un site d'actualité fictif, primo-visiteurs ; effectif non lu. À citer comme « tendance non significative », jamais comme preuve.

### Une barre de progression animée (nervures reculant en décélérant) réduit la durée perçue d'environ 11 % à durée réelle égale
- Niveau de preuve : N2 (ACM CHI 2010, texte intégral lu ; 20, 10 et 16 participants selon l'expérience)
- Source : Chris Harrison, Zhiquan Yeo, Scott E. Hudson, 2010, « Faster Progress Bars: Manipulating Perceived Duration with Visual Augmentations », CHI 2010, https://chrisharrison.net/projects/progressbars2/ProgressBarsHarrison.pdf
- Extrait lu : « Progress bars with animated ribbing that move backwards in a decelerating manner proved to have the strongest effect. » ; « it reduces the perceived duration among our participants by 11%. »
- Portée / limites : petits échantillons d'étudiants (âge moyen 19 à 23 ans), durées de 5 et 15 s, comparaisons en laboratoire par paires. Ne dit rien des attentes longues ni de la satisfaction globale.

### Réactivité web : viser un INP ≤ 200 ms au 75e centile (500 ms et plus = mauvais), avec LCP ≤ 2,5 s et CLS ≤ 0,1
- Niveau de preuve : N3
- Source : web.dev (Google), consulté le 09.11.2026, « Interaction to Next Paint (INP) », https://web.dev/articles/inp — et « Web Vitals », https://web.dev/articles/vitals
- Extrait lu : « An INP below or at 200 milliseconds means a page has good responsiveness. » ; « An INP above 500 milliseconds means a page has poor responsiveness. »
- Portée / limites : mesure de terrain, « the 75th percentile of page loads recorded in the field », segmentée mobile/desktop. INP succède à FID ; la page « Web Vitals » dit seulement « INP became a stable Core Web Vital metric in 2024 » (date exacte non vérifiée ici). Seuils choisis par Google, pas des seuils perceptifs.

### Un gain de 0,1 s de vitesse mobile est associé à environ +8 % de conversion en retail et +10 % en voyage — association observée, non causale démontrée
- Niveau de preuve : N2 (étude empirique à grand échantillon et méthode décrite : 30 millions de sessions, 37 marques ; commandée par Google, non revue par pairs, observationnelle)
- Source : Google / 55 / Deloitte Digital, 2020, « Milliseconds make millions », présenté sur web.dev, https://web.dev/case-studies/milliseconds-make-millions
- Extrait lu : synthèse de la page : retail « Conversion rose about 8.4% », voyage environ 10,1 % (la formulation exacte n'a pas été restituée verbatim par l'outil ; le PDF Deloitte arrondit à 8 % et 10 %).
- Portée / limites : 37 sites européens et américains (retail, luxe, voyage, génération de leads), suivi horaire sur 30 jours fin 2019 ; quatre métriques (dont First Meaningful Paint, aujourd'hui déprécié) devaient toutes s'améliorer de 0,1 s. Aucun groupe témoin mentionné : à présenter comme corrélation. Commanditaire intéressé (Google).

---

## Mythes et affirmations contestées

- **« Amazon : 100 ms de latence = 1 % de ventes en moins. »** La source primaire retrouvée est une diapositive de Greg Linden (« Stanford Data Mining 11-29-2006 », https://docs.google.com/presentation/d/1r5sZSaS39mrAn5KTe271EGBlOZrMr_bR/htmlpresent) qui porte seulement « +100 ms -1% sales » « @ Amazon », sans méthode, période ni intervalle. Chiffre interne de 2006, invérifiable, répété partout comme loi générale. À ne citer qu'avec cette mention.
- **« 53 % des visiteurs mobiles quittent une page qui met plus de 3 s à charger » (attribué à DoubleClick 2016).** Le PDF Google lu (https://www.thinkwithgoogle.com/_qs/documents/1632/au-mobile-page-speed-new-industry-benchmarks.pdf, texte extrait) attribue le chiffre en note à « Google Data, Global, n=3,700 aggregated, anonymized Google Analytics data from a sample of mWeb sites opted into sharing benchmark data, Mar. 2016 » — pas au rapport DoubleClick, et sans méthode publiée. Le même document tire « +113 % de probabilité de rebond de 1 à 7 s » d'un réseau de neurones prédictif (« The neural net, which had a 90% prediction accuracy »), pas d'une mesure : ce n'est pas un résultat expérimental.
- **La « zone du pouce » en arc de cercle (bas d'écran facile, haut-gauche inaccessible).** Hoober 2017 (entrée mobile ci-dessus) la qualifie de « well-known, but incorrect » : les personnes changent de prise, préfèrent le centre et atteignent couramment le bouton Retour en haut. Son étude de 2013 est souvent citée pour justifier cette carte alors qu'elle mesure des prises, pas des zones d'atteinte.
- **« Seuil de Doherty : 400 ms, publié dans l'IBM Systems Journal. »** La seule page lue (Laws of UX, https://lawsofux.com/doherty-threshold/) affirme « In 1982 Walter J. Doherty and Ahrvind J. Thadani published, in the IBM Systems Journal, a research paper » « that set the requirement for computer response time to be 400 milliseconds ». Les résultats de recherche désignent pourtant un document IBM sous référence de formulaire GE20-0752-00 (rapport technique), et des commentateurs (non lus) contestent que « 400 ms » soit un résultat mesuré. Contexte : mainframes et terminaux de 1982. Traiter comme non vérifié (voir ci-dessous).
- **« Les skeleton screens paraissent plus rapides. »** L'étude publiée trouvée (Mejtoft et al. 2018) ne trouve aucune différence significative, et NN/g 2023 présente l'effet comme un raisonnement. Une étude de praticien (Viget 2017), connue par résumé tiers seulement, aurait même trouvé l'inverse.
- **« La validation en ligne est toujours meilleure. »** Wroblewski 2009 (22 participants, un formulaire) contre GOV.UK (« Do not validate when the user moves away from a field. ») : les deux sources sérieuses divergent ; la règle commune est seulement « jamais avant que la personne ait fini sa saisie ».
- **« Labels au-dessus : saisie dix fois plus rapide (50 ms contre 500 ms). »** Ce sont des durées de saccade dans un test oculométrique ad hoc à quatre champs (Penzo 2006), dont l'auteur dit qu'il ne ressemble pas aux conditions réelles. Pas un gain de temps de complétion généralisable.
- **« 70 % des acheteurs abandonnent à cause d'un mauvais checkout. »** Le 70,22 % de Baymard est un taux d'abandon de panier toutes causes, y compris les 42 % qui « regardaient seulement » ; « checkout trop long ou compliqué » ne pèse que 17 % des raisons parmi les autres.
- **« Hamburger = interdit partout. »** L'étude NN/g 2016 est nette sur desktop, plus nuancée sur mobile (effet plus faible, différence mobile/desktop non significative, règle des quatre liens et navigation combinée).
- **« +8,4 % de conversion par 0,1 s gagnée » présenté comme causal.** C'est une association observée sur 37 sites, étude commandée par Google, sans groupe témoin mentionné.

## Non vérifié

- **Miller 1968**, « Response time in man-computer conversational transactions », AFIPS Fall Joint Computer Conference (DOI 10.1145/1476589.1476628) : page ACM refusée (403), copie PDF iamue.com en 503, copie bitsavers trop volumineuse. Contenu (seuils 0,1 / 2 s) non lu. Une critique de Butler (1983) selon laquelle ces seuils reposeraient sur l'expérience de Miller plutôt que sur des données n'a été vue que dans un résultat de recherche.
- **Card, Robertson, Mackinlay 1991**, « The information visualizer, an information workspace », CHI '91 (DOI 10.1145/108844.108874) : métadonnées seules (ACM 403, résumé absent chez Semantic Scholar). L'origine précise des seuils 0,1 / 1 / 10 s dans ce texte n'est pas vérifiée.
- **Doherty & Thadani 1982**, « The Economic Value of Rapid Response Time » (IBM, GE20-0752-00) : la page IBM (vm.ibm.com/devpages/jelliott/) a répondu 503 à chaque essai, et la récupération directe a échoué. Le seuil de 400 ms n'est donc vérifié qu'en source secondaire.
- **Myers 1985**, « The importance of percent-done progress indicators for computer-human interfaces » (CHI '85) : non lu (limite de requêtes Semantic Scholar). Seulement cité par Nielsen.
- **Nah 2004**, étude sur l'attente tolérable (« trois fois plus longue » avec indicateur) : connue seulement par NN/g.
- **Étude Viget 2017 sur les skeleton screens** (temps perçus 2,82 s skeleton / 2,41 s spinner / 2,29 s écran vide, selon un résumé tiers) : page protégée par un contrôle anti-robot, non lue.
- **Material Design 3, cible de 48 dp** : page m3.material.io non lisible (JavaScript) ; vérifié uniquement sur la documentation Android.
- **Apple HIG, page Accessibility** (tailles par plateforme : visionOS, watchOS, macOS) : non lisible ; seul le 44 × 44 pt de la page « UI Design Dos and Don'ts » est vérifié.
- **Google « +500 ms = −20 % de trafic »** (Marissa Mayer) : vu seulement sur la diapositive de Linden 2006, sans source primaire.
- **Tullis & Wood 2004** (UPA), card sorting : non lu, connu par Nielsen.
- **Date exacte du remplacement de FID par INP** (souvent donnée comme mars 2024) : web.dev lu dit seulement « 2024 ».
- **Taille et date de l'enquête Baymard sur les causes d'abandon** : non publiées sur la page lue.
- **« 68 % des sites ont un cul-de-sac zéro résultat »** (ancien chiffre Baymard) : vu seulement dans des résumés tiers.
- **Baymard, saisie de carte bancaire avec espaces automatiques** : les pourcentages de non-conformité (15 %, 51 %, 80 % selon les titres) divergent entre pages et n'ont pas été lus en source.

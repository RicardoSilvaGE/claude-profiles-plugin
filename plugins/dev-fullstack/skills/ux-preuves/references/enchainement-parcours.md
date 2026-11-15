# Fiche `ux-preuves` — Enchaînement d'un parcours

> Fiche du skill `ux-preuves` (dev-fullstack). Couvre : ce qui suit une action réussie (confirmation, suite logique, fin de parcours sans impasse), l'action principale de chaque écran et la concurrence des suites, l'orientation (où suis-je, retour, étapes, progression), l'élan dans une tâche en plusieurs étapes (gradient d'objectif, avance offerte), le premier usage (arriver vite à la première valeur, introduire au moment où ça sert), la continuité (reprendre une tâche interrompue, garder l'état), et ce que disent les avis d'applications. **La fiche à ouvrir pour vérifier un parcours écran par écran : à chaque écran, la personne sait-elle où elle est, ce qu'elle vient de faire, et ce qu'elle fait ensuite ?**
> **Instantané de la recherche documentaire du 15.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Mythes » et « Non
> vérifié » en fin de fiche sont opposables autant que les entrées : ce qui y figure ne se cite
> pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche documentaire vérifiée du 15 novembre 2026, faite pour l'agent `ux` du profil, qui doit vérifier l'enchaînement d'un parcours écran par écran.
> Point de départ : une application mobile où, après avoir rangé une bouteille, on arrive sur une fiche dont le bouton principal est « Sortir une bouteille » (l'inverse du geste qu'on vient de faire), où l'accueil donne deux consignes contradictoires et quatre suites de même poids, et où le concept central n'est jamais introduit en chemin.
> Hors périmètre, parce que d'autres fiches les couvrent (renvois dans les lignes « En conception ») : gouffres d'exécution et d'évaluation, feedback, cognitive walkthrough, information scent, effet du défaut, cécité au changement (`cognition-chemin-usage.md`) ; aide contextuelle contre tutoriel, divulgation progressive, états vides, annulation contre confirmation, notifications (`ia-ethique-onboarding.md`) ; formulaires, hamburger, fil d'Ariane, temps de réponse (`formulaires-navigation-mobile.md`) ; Hick, Zeigarnik, peak-end (`normes-lois-methodes.md`) ; WCAG 3.2.3 navigation cohérente (`design-motion-etats-systemes.md`).
>
> **Méthode.** Toutes les entrées s'appuient sur une page ou un PDF réellement ouverts le 15.11.2026 par WebFetch ; quand WebFetch ne rendait qu'un résumé ou un binaire, le texte de la même URL a été extrait (curl, pdftotext) pour recopier l'extrait mot pour mot. Quand seul un résumé d'article a été lu, l'entrée le dit (« résumé seul lu »). Les extraits sont dans leur langue d'origine.
>
> **Niveaux de preuve** (échelle du `SKILL.md`, qui fait foi).
> - N1 : norme ou réglementation.
> - N2 : recherche revue par les pairs, ou étude empirique à grand échantillon et méthode publiée.
> - N3 : guideline officielle d'une institution ou d'une plateforme.
> - N4 : avis d'expert ou article de praticien.
>
> NN/g et Baymard sont classés N4 ici : aucune des pages lues ne donne échantillon et méthode. Les chiffres d'entreprise rapportés par un praticien (Twitter, « bouton à 300 millions ») restent N4 : méthode non publiée.
>
> **Total : 29 entrées.**

---

## 1. Après une action réussie : confirmer, puis désigner la suite

### Après une action qui conclut une tâche, dire ce qui s'est passé, ce qui se passe ensuite, et offrir ce dont la personne aura besoin ensuite
- Niveau de preuve : N3.
- Source : GOV.UK Design System, pattern « Confirmation pages », https://design-system.service.gov.uk/patterns/confirmation-pages/ (lu le 15.11.2026).
- Extrait lu : « Confirmation pages reassure users that they have completed a transaction and helps them understand what to expect next. » La page doit contenir notamment : « details of what happens next and when » et « links to information or services that users are likely to need next ».
- Portée / limites : écrit pour la fin d'une démarche administrative. La page signale elle-même son angle mort, qui est exactement le cas d'une app où une action s'inscrit dans une tâche plus large : « Research is needed on the best way to confirm transactions that are part of a wider user task. For example, where you might need to emphasise next steps more than completion of that particular transaction. »
- En conception : après l'action X, l'écran d'arrivée dit-il en une phrase ce qui vient d'être fait, **et** propose-t-il en premier la suite la plus probable dans la tâche en cours ? Si l'action X n'est qu'un pas d'une tâche plus large (ranger une bouteille parmi six), la suite (« Ranger la suivante ») doit-elle primer sur la célébration de la fin ?

### Ne pas faire de l'écran qui suit une réussite une impasse
- Niveau de preuve : N4 (article de cabinet ; ni échantillon ni méthode sur la page lue).
- Source : Holst, J. (Baymard Institute), 08.11.2023, « 6 Ways to Get More Out of Your Order Confirmation Page », https://baymard.com/research-articles/order-confirmation-page (lu le 15.11.2026).
- Extrait lu : « The order confirmation page is too often a dead end for users ».
- Portée / limites : e-commerce ; les suites proposées (création de compte, ventes additionnelles, guides) servent aussi le vendeur. La page invoque une « large-scale testing » sans la décrire. Ce qui se transpose : un écran de fin sans action vers la suite laisse la personne sans prochaine étape.
- En conception : sur chaque écran atteint après une réussite, compter les actions qui prolongent ce que la personne vient de faire. S'il n'y en a aucune, ou si la seule action visible ramène à l'accueil, c'est une impasse : laquelle est la suite logique ?

### Après une correction faite en revenant en arrière, ramener la personne là où elle reprend, pas au début
- Niveau de preuve : N3.
- Source : GOV.UK Design System, pattern « Check answers », https://design-system.service.gov.uk/patterns/check-answers/ (lu le 15.11.2026).
- Extrait lu : « If a user decides to go back to a previous answer, make sure information they've already entered is pre-populated. » ; « When they've finished, the 'Continue' button should return them to the check answers page. » ; « They should not need to go through the rest of the transaction again. »
- Portée / limites : pattern de formulaire long ; le principe (le bouton qui conclut une correction ramène au point de reprise) vaut pour toute modification lancée depuis un récapitulatif ou une fiche.
- En conception : quand la personne quitte un écran pour corriger un détail (modifier un rangement depuis une fiche), le bouton « Enregistrer » la ramène-t-il sur l'écran d'où elle est partie, dans l'état où elle l'a laissé, ou la renvoie-t-il au début d'un parcours ?

### Proportionner le retour à l'enjeu, et laisser le retour léger porter l'action qui suit (annuler, réessayer)
- Niveau de preuve : N3.
- Source : Apple, Human Interface Guidelines, « Feedback », JSON lu : https://developer.apple.com/tutorials/data/design/human-interface-guidelines/feedback.json (page : https://developer.apple.com/design/human-interface-guidelines/feedback) ; Google, Material Components for Android, « Snackbar », https://github.com/material-components/material-components-android/blob/master/docs/components/Snackbar.md (lus le 15.11.2026).
- Extrait lu : Apple : « It's generally best to reserve this type of confirmation for activities that are sufficiently important — because people typically expect their action or task to succeed, they only need to know when it doesn't. » Material : « Snackbars can also offer the ability to perform an action, such as undoing an action that was just taken, or retrying an action that had failed. »
- Portée / limites : guidelines de plateforme, sans données publiées. Le site m3.material.io n'a pas pu être lu (rendu en JavaScript) ; la documentation du composant Android, qui renvoie à la spécification M3, l'a été.
- En conception : après une action courante réussie, le retour est-il léger (toast, snackbar) plutôt qu'un écran ou une alerte à fermer ? Ce retour porte-t-il la seule action qui a du sens tout de suite (« Annuler ») sans bloquer le geste suivant ? Renvois : feedback immédiat et cécité au changement (`cognition-chemin-usage.md`, § 1 et 7) ; annulation plutôt que confirmation (`ia-ethique-onboarding.md`, § 3).

### Ne pas laisser une étape nécessaire après le signal « c'est fini » : elle sera oubliée (erreur post-complétion)
- Niveau de preuve : N2 (actes revus par les pairs de la Cognitive Science Society ; 41 participants, étudiants).
- Source : Li, S. Y. W., Blandford, A., Cairns, P. & Young, R. M., 2005, « Post-completion errors in problem solving », actes de CogSci 2005, PDF lu : https://www-users.york.ac.uk/~pc530/pubs/Li_CogSci_05.pdf (lu le 15.11.2026).
- Extrait lu : « A post-completion error is a specific form of omission error occurring after some task goal has been accomplished – for example, forgetting to collect your original after photocopying. » ; « The findings suggest that even a simple static cue can reduce the error rate, though not eliminate it. » Dans l'une des deux interfaces, « an overall error rate of 59% (29 out of 49 opportunities) », contre 32 % (15 sur 47) dans l'autre.
- Portée / limites : tâche de laboratoire (résolution de problèmes), 41 étudiants de l'UCL. L'article résume Byrne & Bovair (1997) — erreur rare sous faible charge mémoire, plus fréquente sous forte charge — et Chung & Byrne (2004) — un indice dynamique, placé juste avant l'étape, la réduit, un indicateur statique non ; ces deux textes n'ont pas été lus (« Non vérifié »). Il rapporte aussi que réprimander ou rappeler la consigne ne réduit pas l'erreur.
- En conception : dans le parcours, une étape nécessaire vient-elle **après** l'écran ou le message qui dit « c'est fait » (noter la place, valider un brouillon, retirer la photo de la file) ? Si oui, peut-on la faire avant le signal de fin, ou la rendre automatique ? Un rappel statique ne suffit pas.

---

## 2. Une action principale par écran, et peu de suites concurrentes

### Un seul bouton principal par écran : plusieurs appels principaux brouillent la suite
- Niveau de preuve : N3.
- Source : GOV.UK Design System, composant « Button », https://design-system.service.gov.uk/components/button/ ; Google, Material Components for Android, « Floating action button », https://github.com/material-components/material-components-android/blob/master/docs/components/FloatingActionButton.md (lus le 15.11.2026).
- Extrait lu : GOV.UK : « Use a default button for the main call to action on a page. Avoid using multiple default buttons on a single page. Having more than one main call to action reduces their impact, and makes it harder for users to know what to do next. » ; « Before adding lots of secondary buttons, try to simplify the page or break the content down across multiple pages. » Material : « A floating action button (FAB) represents the primary action of a screen. » ; « A FAB performs the primary or the most common action on a screen. »
- Portée / limites : deux systèmes de conception, aucun chiffre publié. Ils disent qu'il en faut un ; ils ne disent pas lequel choisir. Material le définit comme l'action « primaire ou la plus courante » de l'écran : c'est le critère à appliquer.
- En conception : sur chaque écran, combien d'éléments ont le style principal ? S'il y en a plus d'un, lequel est l'action la plus probable **à ce moment du parcours** (en tenant compte de l'écran d'où l'on vient) ? Sur l'écran d'arrivée après « Ranger », l'action principale est-elle la continuation du rangement, ou l'action inverse ?

### Distinguer visuellement l'action principale des secondaires, et ne pas placer l'action destructrice là où l'on attend la principale
- Niveau de preuve : N4 (test de praticien, 23 participants, oculométrie, non revu par les pairs).
- Source : Wroblewski, L., 27.08.2007, « Primary & Secondary Actions in Web Forms », https://www.lukew.com/ff/entry.asp?571 (lu le 15.11.2026).
- Extrait lu : « we tested six variations on 23 people using eye-tracking and usability metrics. » ; « Option A, B, C, D and F achieved success rates of 100% » ; « Only Option E performed poorly during our testing. Six people mistakenly clicked on the "Cancel" button when attempting the task with this design » ; « When choosing between primary and secondary actions, visual distinctions are a useful method for helping people make good choices. »
- Portée / limites : formulaire web de bureau, 2007, test mené avec le cabinet Etre ; pas de statistique inférentielle publiée. Le résultat robuste est qualitatif : la seule variante qui a provoqué des erreurs était celle où le placement induisait en erreur.
- En conception : l'action principale se distingue-t-elle des autres par le style, pas seulement par le libellé ? L'action contraire au but courant (sortir, supprimer) occupe-t-elle la place ou le style où l'œil cherche l'action principale ?

### N'interrompre que pour une information critique : une alerte de plus est une suite concurrente de plus
- Niveau de preuve : N3.
- Source : Apple, Human Interface Guidelines, « Feedback », JSON lu : https://developer.apple.com/tutorials/data/design/human-interface-guidelines/feedback.json (lu le 15.11.2026).
- Extrait lu : « Use alerts to deliver critical — and ideally actionable — information. By design, alerts disrupt the current context, so you need to match the importance of the information to the level of interruption. Alerts can lose their impact if you use them too often or to deliver unimportant information. » ; et « Consider integrating status feedback into your interface. When status feedback is available near the items it describes, people get important information without having to take action or leave their current context. »
- Portée / limites : guideline sans données. Elle traite les alertes ; la même logique s'applique aux bandeaux, rappels et invites empilés sur un écran.
- En conception : sur un écran, combien de messages demandent une attention (bandeau, rappel, invite, badge) en plus de l'action principale ? Chacun est-il critique **maintenant**, ou peut-il devenir un statut discret à côté de ce qu'il décrit ? Deux messages disent-ils des choses contradictoires (« commence par X » et « fais d'abord Y ») ? Renvois : permission de notifier, avertissement répété (`ia-ethique-onboarding.md`, § 3).

### Réduire le nombre de suites de même poids quand la décision est difficile ou que la personne ne sait pas encore ce qu'elle veut — la surcharge de choix n'est pas universelle
- Niveau de preuve : N2 (deux méta-analyses, résumés seuls lus).
- Source : Scheibehenne, B., Greifeneder, R. & Todd, P. M., 2010, « Can There Ever Be Too Many Options? A Meta-Analytic Review of Choice Overload », *Journal of Consumer Research*, 37(3), 409-425, résumé lu : https://ideas.repec.org/a/oup/jconrs/v37y2010i3p409-425.html ; Chernev, A., Böckenholt, U. & Goodman, J., 2015, « Choice overload: A conceptual review and meta-analysis », *Journal of Consumer Psychology*, résumé lu : https://www.kellogg.northwestern.edu/faculty/research/detail/2015/when-product-assortment-leads-to-choice-overload-a-conceptual (lus le 15.11.2026).
- Extrait lu : Scheibehenne et al. : « In a meta-analysis of 63 conditions from 50 published and unpublished experiments (N = 5,036), we found a mean effect size of virtually zero but considerable variance between studies. » Chernev et al. : « In a meta analysis of 99 observations (N = 7202) […] we identify four key factors-choice set complexity, decision task difficulty, preference uncertainty, and decision goal-that moderate the impact of assortment size on choice overload » ; « higher levels of decision task difficulty, greater choice set complexity, higher preference uncertainty, and a more prominent, effort-minimizing goal facilitate choice overload. »
- Portée / limites : les études portent sur des assortiments de produits (choisir un article parmi n), pas sur des menus d'actions. Les deux méta-analyses ne se contredisent pas : effet moyen nul, mais réel dans des conditions précises — qui sont celles d'un nouvel utilisateur devant l'accueil (préférence incertaine, but de moindre effort).
- En conception : sur l'accueil et sur chaque écran de fin d'action, combien de suites ont le même poids visuel ? Pour une personne qui découvre l'app (préférence incertaine), une seule est-elle désignée comme la prochaine ? Ne pas justifier la réduction par « la loi de Hick » (`normes-lois-methodes.md`, § 4.2) ni par « trop de choix paralyse » (Mythes).

---

## 3. Orientation : où suis-je, d'où je viens, où j'en suis

### Chaque écran doit dire où l'on est, et cela se teste en une question
- Niveau de preuve : N1 pour le critère WCAG (niveau AAA, non exigé en AA) ; N4 pour la méthode NN/g.
- Source : W3C, « Understanding SC 2.4.8: Location (Level AAA) », https://www.w3.org/WAI/WCAG22/Understanding/location.html ; Farrell, S. (NN/g), 25.10.2015, « Navigation: You Are Here », https://www.nngroup.com/articles/navigation-you-are-here/ (lus le 15.11.2026).
- Extrait lu : WCAG : « Information about the user's location within a set of web pages is available. » NN/g : « Navigating the web from a web search is somewhat like being dropped off at an arbitrary location in a strange city. Good signage is essential. » Et le test : « Show people various pages at different levels of your website, one at a time, without navigating to them. Say: "Pretend you just arrived at this web page. Where are you on the website?" » ; puis « Avoid making navigational dead ends. »
- Portée / limites : écrit pour le web ; une app y arrive par notification, lien profond ou reprise après coupure, ce qui pose le même problème d'entrée par le côté. L'article ne donne aucun chiffre ; il recommande l'analytics (va-et-vient, retours répétés) comme signal.
- En conception : pour chaque écran du parcours, montré seul, la personne peut-elle dire où elle est et comment elle le sait (titre, onglet actif, nom de l'objet, étape) ? Renvois : navigation cohérente WCAG 3.2.3 (`design-motion-etats-systemes.md`) ; fil d'Ariane (`formulaires-navigation-mobile.md`, § 2).

### Garder la barre d'onglets visible, et garder l'état de chaque section
- Niveau de preuve : N3.
- Source : Apple, Human Interface Guidelines, « Tab bars », JSON lu : https://developer.apple.com/tutorials/data/design/human-interface-guidelines/tab-bars.json (lu le 15.11.2026).
- Extrait lu : « Make sure the tab bar is visible when people navigate to different sections of your app. If you hide the tab bar, people can forget which area of the app they're in. » ; « They also let people quickly switch between sections of the view while preserving the current navigation state within each section. » ; « Use a tab bar to support navigation, not to provide actions. »
- Portée / limites : convention iOS, sans données publiées ; exception explicite pour une vue modale, « temporary and self-contained ».
- En conception : en allant d'une section à l'autre puis en revenant, la personne retrouve-t-elle l'écran et la position qu'elle avait quittés ? La barre de navigation principale contient-elle seulement des destinations, et pas une action (« + ») qui se confond avec elles ?

### Le retour mène à l'écran précédent, dans l'état où on l'a vu
- Niveau de preuve : N3 (deux plateformes concordantes) ; N4 pour le modèle mental décrit par NN/g.
- Source : Android Developers, « Principles of navigation », https://developer.android.com/guide/navigation/principles ; GOV.UK Design System, composant « Back link », https://design-system.service.gov.uk/components/back-link/ ; Chan, M. (NN/g), 26.01.2024, « Mental Models and User Experience Design », https://www.nngroup.com/articles/mental-models/ (lus le 15.11.2026).
- Extrait lu : Android : « Every app you build has a fixed start destination. » ; « Within your app's task, the Up and Back buttons behave identically. » ; à propos d'un lien profond, la pile synthétique « should match a back stack that could have been achieved by organically navigating through the app. » GOV.UK : « Make sure the link takes users to the previous page they were on, in the state they last saw it. » NN/g : « users have built a strong mental model for it: namely, Back is supposed to lead back to the previous screen, essentially acting as an undo. »
- Portée / limites : Android décrit la pile de navigation de sa propre bibliothèque, mais la donne comme principe (« Even if you aren't using the Navigation component in your project, your app should follow these design principles »). Dans une PWA, le retour système et celui du navigateur passent par l'historique : chaque navigation ajoute-t-elle une entrée cohérente ?
- En conception : après chaque transition du parcours, le retour (bouton de l'app, geste, bouton système) mène-t-il à l'écran d'où l'on vient, avec ses filtres, sa position et sa saisie ? Après une action qui crée un objet puis ouvre sa fiche, « Retour » ramène-t-il au formulaire déjà soumis (ce qui invite à soumettre deux fois) ou à l'écran d'avant le formulaire ?

### Le retour système ferme la surcouche ouverte, il ne fait pas sauter un écran de plus
- Niveau de preuve : N4 (étude qualitative NN/g sur mobile, effectif non donné sur la page lue).
- Source : Budiu, R., Behnam, S. & Moran, K. (NN/g), 18.09.2022, « Accidental Dismissal of Overlays: A Common Mobile Usability Problem », https://www.nngroup.com/articles/accidental-overlay-dismissal/ (lu le 15.11.2026).
- Extrait lu : « the Back button (at least in its standard implementation) takes people back to the previous page (and not to the previous view), the result is that users are thrown back farther than they expected. This outcome contributes to a sense disorientation and a lack of control. » ; « you should allow users to use the browser or the phone's Back button or gesture to act as undo and move back from the current view to the previous one. »
- Portée / limites : observations sur des sites et apps mobiles réels ; recommandation, pas mesure.
- En conception : sur chaque feuille, modale ou panneau du parcours, le geste ou bouton retour du téléphone le ferme-t-il en laissant l'écran dessous intact ? Ou fait-il quitter l'écran parent, voire l'app ?

### Dans un parcours par étapes, montrer toutes les étapes, l'étape courante, et nommer le bouton par l'étape suivante
- Niveau de preuve : N4.
- Source : Budiu, R. (NN/g), 25.06.2017, « Wizards: Definition and Design Recommendations », https://www.nngroup.com/articles/wizards/ (lu le 15.11.2026).
- Extrait lu : « Communicate a clear mental model of the process by displaying a list or a diagram of the steps involved and highlighting the current step. Because the process is presented one step at a time, there is danger that users will miss the context, get confused, or not realize how long the progression will be. » ; « Generic labels such as Next and Previous have weak information scent and don't tell users anything about these steps. It's better to indicate in the label what the user will actually have to do next. »
- Portée / limites : l'article réserve l'assistant aux processus peu familiers ou rares et conseille une voie plus rapide pour ceux qui les répètent. Pas de données chiffrées.
- En conception : dans chaque parcours de plus de deux écrans, la personne voit-elle combien d'étapes restent et laquelle est la sienne ? Le bouton principal dit-il ce qui vient (« Choisir le rangement ») plutôt que « Suivant » ? Renvoi : odeur des libellés (`cognition-chemin-usage.md`, § 3).

### L'indicateur d'étapes doit correspondre une à une aux étapes réelles, et ses étapes passées doivent être cliquables
- Niveau de preuve : N4 (billet Baymard ; aucune étude, échantillon ou méthode cités pour ces points).
- Source : MacDonald, C. (Baymard Institute), 12.11.2026, « Progress Indicators for UI/UX: Definition & Ecommerce Best Practices », https://baymard.com/blog/progress-indicator-ui-ux (lu le 15.11.2026).
- Extrait lu : « Provide visual process steps that are an exact match for each step of the process » ; « Don't let steps appear or disappear without warning » ; « Users often try to click previous steps, and when those steps aren't interactive, they're forced to hunt for other ways back or rely on repeated browser-back behavior. »
- Portée / limites : tunnel d'achat ; le chiffre de « 5 seconds » avant impatience que donne la même page n'a pas de source et n'est pas repris ici.
- En conception : l'indicateur annonce-t-il le nombre réel d'écrans, y compris ceux qui n'apparaissent que dans certains cas ? Toucher une étape passée y ramène-t-il, saisie conservée ?

### Ne pas compter sur une barre de progression pour réduire l'abandon : son effet dépend de ce qu'elle laisse percevoir
- Niveau de preuve : N2 (méta-analyse de 32 expériences randomisées ; résumé seul lu).
- Source : Villar, A., Callegaro, M. & Yang, Y., 2013, « Where Am I? A Meta-Analysis of Experiments on the Effects of Progress Indicators for Web Surveys », *Social Science Computer Review*, 31, 744-762, résumé lu : https://research.google/pubs/where-am-i-a-meta-analysis-of-experiments-on-the-effects-of-progress-indicators-for-web-surveys/ (lu le 15.11.2026).
- Extrait lu : « we analyzed 32 randomized experiments comparing drop-off rates » ; « Our results show that, overall, using a constant progress indicator does not significantly help reduce drop-offs and that effectiveness of the progress indicator varies depending on the speed of indicator: Fast-to-slow indicators reduced drop-offs, whereas slow-to-fast indicators increased drop-offs. We also found that among the studies in which a small incentive was promised, showing a constant progress indicator increased the drop-off rate. These findings question the common belief that progress indicators help reduce drop-off rates. »
- Portée / limites : questionnaires en ligne, pas applications. Mesure l'abandon, pas la compréhension ni la satisfaction. Une barre qui avance lentement au début décourage : ce qui compte est la progression **perçue** dès les premiers pas. Une critique de blog sur des erreurs de codage n'a pas été lue (« Non vérifié »).
- En conception : si le parcours affiche une progression, les premiers pas la font-ils avancer visiblement ? Pour un parcours court (trois écrans ou moins), l'indicateur apporte-t-il plus que les titres d'étape ? Renvoi : progression pendant une attente (`formulaires-navigation-mobile.md`, § 4).

---

## 4. Élan dans une tâche en plusieurs étapes

### Plus le but paraît proche, plus on accélère : montrer la distance qui reste
- Niveau de preuve : N2 (*Journal of Marketing Research*, expériences de terrain et données clients ; PDF intégral lu).
- Source : Kivetz, R., Urminsky, O. & Zheng, Y., 2006, « The Goal-Gradient Hypothesis Resurrected: Purchase Acceleration, Illusionary Goal Progress, and Customer Retention », *Journal of Marketing Research*, XLIII, 39-58, PDF lu : https://business.columbia.edu/sites/default/files-efs/pubfiles/1200/goalgradient.pdf (lu le 15.11.2026).
- Extrait lu : « participants in a real café reward program purchase coffee more frequently the closer they are to earning a free coffee » ; « (on average, interpurchase times decrease by 20% or .7 days throughout the program) » ; « Internet users who rate songs in return for reward certificates visit the rating Web site more often, rate more songs per visit, and persist longer in the rating effort as they approach the reward goal ».
- Portée / limites : ce qui est mesuré est un rythme d'achat (carte de dix cafés, près de 10 000 achats) et un effort de notation récompensé, pas la complétion d'un parcours d'interface sans récompense. Le modèle des auteurs fait dépendre l'effort de la **proportion** de distance restante. L'extrapolation à une barre de progression d'app est raisonnable mais non mesurée ici.
- En conception : dans une tâche répétée (ranger une commande de six bouteilles), la personne voit-elle combien il en reste (« 4 sur 6 rangées ») au moment où elle décide de continuer ?

### Une avance offerte dès le départ accélère la complétion, à effort réel égal
- Niveau de preuve : N2 (expérience de terrain randomisée, 108 clients ; second article sur résumé seul).
- Source : Kivetz, Urminsky & Zheng, 2006 (référence et PDF ci-dessus) ; Nunes, J. C. & Drèze, X., 2006, « The Endowed Progress Effect: How Artificial Advancement Increases Effort », *Journal of Consumer Research*, 32(4), 504-512, résumé lu : https://ideas.repec.org/a/oup/jconrs/v32y2006i4p504-512.html (lus le 15.11.2026).
- Extrait lu : Kivetz et al. : « The participants were 108 customers of the café » ; « customers in the control condition completed the ten required purchases (for the 10-stamp card) in 15.6 days. In contrast, customers in the experimental (illusionary goal progress) condition completed the ten required purchases (for the corresponding 12-stamp card) in only 12.7 days, nearly three days or 20% faster ». Nunes & Drèze : « By converting a task requiring eight steps into a task requiring 10 steps but with two steps already complete, the task is reframed as one that has been undertaken and incomplete rather than not yet begun. This increases the likelihood of task completion and decreases completion time. » ; « Moderators include the reason, if any, offered for the endowment and the currency in which progress is recorded. »
- Portée / limites : cartes de fidélité. L'avance de Kivetz était « bogus » (fictive) ; en interface, une avance **réelle** (étapes déjà faites par l'inscription, première bouteille déjà rangée) est la seule défendable : une avance fictive présentée comme réelle relève du dark pattern (`ia-ethique-onboarding.md`, § 2). Le taux de complétion chiffré de Nunes & Drèze n'a pas été lu (« Non vérifié »).
- En conception : une check-list de démarrage compte-t-elle comme faites les étapes que la personne a réellement accomplies en chemin (au lieu de partir de zéro) ? Le premier écran du parcours montre-t-il une tâche déjà commencée plutôt qu'une page blanche ?

### Après avoir atteint un but, l'élan retombe : proposer le but suivant au moment de la réussite
- Niveau de preuve : N2 (même étude ; 110 membres suivis après une première récompense).
- Source : Kivetz, Urminsky & Zheng, 2006, PDF lu : https://business.columbia.edu/sites/default/files-efs/pubfiles/1200/goalgradient.pdf (lu le 15.11.2026).
- Extrait lu : « Notably, purchase and effort rates reset (to a lower level) after the first reward is earned and then reaccelerate toward the second reward goal. » Et : « we analyzed the postredemption purchase behavior of 110 members who completed a first card ».
- Portée / limites : programme de fidélité, but numérique et récompensé. L'article montre aussi que l'accélération vers la première récompense prédit la rétention ; il ne teste pas l'annonce d'un but suivant.
- En conception : sur l'écran qui suit l'atteinte d'un but (cave rangée, commande entièrement saisie), y a-t-il une suite nommée qui relance (« 3 vins à compléter ») ? Ou la réussite laisse-t-elle un écran sans prochaine étape ?

---

## 5. Premier usage : arriver vite à la première valeur

### Mettre la personne directement dans l'interface ; un onboarding, s'il existe, est bref, facultatif et réservé à ce qui est nouveau
- Niveau de preuve : N4 (analyse NN/g ; s'appuie sur leur étude des tutoriels, effectif non donné sur la page lue).
- Source : Kendrick, A. (NN/g), 21.06.2020, « Mobile-App Onboarding: An Analysis of Components and Techniques », https://www.nngroup.com/articles/mobile-app-onboarding/ (lu le 15.11.2026).
- Extrait lu : « our research on deck-of-cards tutorials, a method of instructional onboarding, showed that tutorials didn't improve task performance. Consequently, we recommend professionals avoid creating app onboarding whenever possible and instead spend your resources making the UI more usable. » ; « Keep onboarding as simple as possible. For most mobile apps, this means putting users directly into the interface. »
- Portée / limites : distinct de l'entrée « aide contextuelle contre tutoriel » (`ia-ethique-onboarding.md`, § 3, Laubheimer 2023), qu'il complète par la typologie : promotion de fonctions, personnalisation, instructions. La personnalisation de **contenu** y est jugée plus acceptable au démarrage que celle de l'apparence.
- En conception : combien d'écrans séparent l'ouverture de l'app du premier geste utile (ranger une bouteille) ? Chacun de ces écrans est-il indispensable à ce premier geste ? Sinon, peut-il venir plus tard, au moment où il sert ?

### Faire faire plutôt qu'expliquer, et reporter tout réglage non indispensable derrière des valeurs par défaut
- Niveau de preuve : N3.
- Source : Apple, Human Interface Guidelines, « Onboarding », JSON lu : https://developer.apple.com/tutorials/data/design/human-interface-guidelines/onboarding.json (lu le 15.11.2026).
- Extrait lu : « Teach through interactivity. People tend to grasp and retain information better when they can actually perform the task they're learning about instead of just viewing instructional material. » ; « Postpone nonessential setup flows or customization steps. Provide reasonable default settings so most people can immediately start interacting with your app or game without performing additional configuration. » ; « If you try to teach too much, people can feel overwhelmed and may be less likely to remember what they learned. »
- Portée / limites : guideline sans données publiées. Elle appuie l'idée d'introduire le concept central **en le faisant utiliser**, au moment où il sert.
- En conception : le concept central de l'app est-il introduit par une action que la personne fait (son premier rangement crée le premier casier, avec une phrase qui le nomme) plutôt que par un écran d'explication ? Chaque réglage demandé au premier lancement a-t-il un défaut raisonnable qui permettrait de le reporter ? Renvoi : effet du défaut (`cognition-chemin-usage.md`, § 4).

### Laisser utiliser le service avant d'exiger un compte ou une saisie complète
- Niveau de preuve : N4 (essais et retours de praticiens ; chiffres d'entreprise sans méthode publiée).
- Source : Wroblewski, L., 05.05.2008, « Sign Up Forms Must Die », *A List Apart*, https://alistapart.com/article/signupforms/ ; Wroblewski, L., 16.06.2010, « Gradual Engagement Boosts Twitter Sign-Ups by 29% », republié : https://articles.centercentre.com/?p=223 ; Spool, J. M., 14.01.2009, « The $300 Million Button », https://articles.centercentre.com/three_hund_million_button/ (lus le 15.11.2026).
- Extrait lu : Wroblewski 2008 : « In Geni's case, their approach to gradual engagement has given them five million profiles in five months. » ; « Gradual engagement isn't well served by simply distributing each of your sign-up form input fields onto separate web pages. » Wroblewski 2010 : « Though the new sign-up process added one more screen, conversions went up 29%. » Spool : « As one shopper told us, "I'm not here to enter into a relationship. I just want to buy something." » ; « The number of customers purchasing went up by 45%. »
- Portée / limites : trois récits de praticiens reconnus ; aucun ne publie de méthode (période, groupe témoin, définition de la conversion). Ils vont dans le même sens et désignent le même défaut : un mur placé avant la première valeur. Les chiffres se citent comme « rapportés par », jamais comme effet attendu.
- En conception : qu'est-ce que la personne doit fournir (compte, accord, saisie complète) **avant** d'avoir vu l'app faire quelque chose pour elle ? Chaque exigence peut-elle être déplacée après le premier résultat ?

### Au début, cacher ce qui ne sert pas encore et mène surtout à l'erreur
- Niveau de preuve : N2 (*Human Factors*, deux expériences ; résumé seul lu ; étude de 1984 sur un traitement de texte).
- Source : Carroll, J. M. & Carrithers, C., 1984, « Blocking Learner Error States in a Training-Wheels System », *Human Factors*, 26(4), 377-389, résumé lu : https://pure.psu.edu/en/publications/blocking-learner-error-states-in-a-training-wheels-system/ (lu le 15.11.2026).
- Extrait lu : « Some of the most troubling problems for users of computer equipment arise in the getting-started stage. A 'training-wheels' system was designed for a commercial word processor in which system functions that new users typically do not need, but which can be springboards for errors and confusions, were disabled. The training-wheels word processor improved learning efficiency in two experiments, one of which examined learning by doing and the other, learning by the book. »
- Portée / limites : étude ancienne, matériel et population de 1984 ; l'effectif n'a pas été lu (l'article de *Communications of the ACM* de la même année, refusé en 403, est en « Non vérifié »). Le principe est perceptif et cognitif, il vieillit moins que l'outil. Voisin de la divulgation progressive (`ia-ethique-onboarding.md`, § 3).
- En conception : sur les écrans d'une première session, quelles actions ne servent qu'à une personne déjà installée (exporter, réorganiser, faire le tri) ? Sont-elles en retrait tant que la cave est vide ou presque ? Un état vide mène-t-il à la première action (`ia-ethique-onboarding.md`, § 3) ?

### Pour un démarrage en plusieurs tâches sans ordre imposé, une liste de tâches avec statut ; sinon, un parcours guidé
- Niveau de preuve : N3 (recherche interne GOV.UK citée sans chiffres).
- Source : GOV.UK Design System, composant « Task list », https://design-system.service.gov.uk/components/task-list/ (lu le 15.11.2026).
- Extrait lu : « Only use the task list if there's evidence that users: do not want to, or cannot, complete all the tasks in one sitting need to be able to choose the order they complete the tasks in » ; « Do not use the task list for a long service that needs to be completed in a specific order. » ; « Users should be able to complete tasks in whatever order they like. » ; « User research has also shown that once a few tasks have been completed, it is harder for users to scan the page and spot incomplete tasks. »
- Portée / limites : démarches longues de service public. La page demande d'abord de simplifier : « Try to simplify the service before you use a task list. »
- En conception : la check-list de démarrage, s'il y en a une, laisse-t-elle choisir l'ordre et dit-elle pour chaque tâche si on peut la commencer ? Les tâches faites s'effacent-elles visuellement pour que la suivante ressorte ? Si l'ordre compte, le parcours est-il plutôt guidé, étape par étape ?

---

## 6. Continuité : reprendre sans perdre le fil

### Rouvrir l'app là où on l'a quittée, avec l'état détaillé
- Niveau de preuve : N3 (Apple) ; N1 niveau AAA pour le cas d'une session expirée (non exigé en AA).
- Source : Apple, Human Interface Guidelines, « Launching », JSON lu : https://developer.apple.com/tutorials/data/design/human-interface-guidelines/launching.json ; W3C, « Understanding SC 2.2.5: Re-authenticating (Level AAA) », https://www.w3.org/WAI/WCAG22/Understanding/re-authenticating.html (lus le 15.11.2026).
- Extrait lu : Apple : « Restore the previous state when your app restarts so people can continue where they left off. » ; « Avoid making people retrace steps to reach their previous location in your app or game. Restore granular details of the previous state as much as possible. For example, scroll the view to people's most recent position ». WCAG : « When an authenticated session expires, the user can continue the activity without loss of data after re-authenticating. »
- Portée / limites : guideline de plateforme, sans données. Sur mobile, le système tue souvent une app en arrière-plan : sans restauration, toute interruption ramène à l'accueil.
- En conception : si l'app est fermée au milieu d'un parcours (saisie d'une commande, file de photos), la rouvrir ramène-t-elle à l'écran et à la saisie en cours, ou à l'accueil ? L'accueil signale-t-il au moins le travail en cours et y mène-t-il en un geste ?

### Garder visible la trace d'une tâche suspendue : sans indice, la reprise tarde beaucoup
- Niveau de preuve : N2 (CHI 2007, étude de terrain, 27 personnes, deux semaines de journalisation).
- Source : Iqbal, S. T. & Horvitz, E., 2007, « Disruption and Recovery of Computing Tasks: Field Study, Analysis, and Directions », CHI 2007, PDF lu : https://www.erichorvitz.com/CHI_2007_Iqbal_Horvitz.pdf (lu le 15.11.2026).
- Extrait lu : « On average, 27% of the alerts resulted in users being diverted from these prior active windows for more than 2 hours into the resumption phase. » ; « suspended application windows that were less than 25% visible took significantly longer to return to as compared to application windows that were more than 75% visible » ; « This finding suggests that the visibility of windows may serve as a reminder to users to break out of the diversion chain and return to suspended applications ».
- Portée / limites : postes de travail Windows, 27 employés (« We deployed DART on the primary machines of 27 people »), interruptions par e-mail et messagerie. Corrélation observée, pas expérience contrôlée ; la transposition au mobile (où rien ne reste visible) renforce plutôt le besoin d'un indice explicite.
- En conception : une tâche commencée et non finie (commande collée à moitié rangée, photo en attente de validation) laisse-t-elle un indice visible là où la personne revient d'habitude (accueil, onglet) ? Un seul, et qui mène à la reprise en un geste ? Renvoi : ne pas s'appuyer sur l'effet Zeigarnik (`normes-lois-methodes.md`, § 4.2).

### Prévenir avant d'interrompre une tâche aide à la reprendre
- Niveau de preuve : N2 (*International Journal of Human-Computer Studies* ; expérience, 17 participants ; PDF lu).
- Source : Trafton, J. G., Altmann, E. M., Brock, D. P. & Mintz, F. E., 2003, « Preparing to resume an interrupted task: effects of prospective goal encoding and retrospective rehearsal », *Int. J. Human-Computer Studies*, 58, 583-603, PDF lu : https://interruptions.net/literature/Trafton-IJHCS03.pdf (lu le 15.11.2026).
- Extrait lu : « participants in a Warning condition received an 8-s interruption lag, and participants in an Immediate condition received no interruption lag. Participants in the Warning condition prepared more than participants in the Immediate condition, as measured by verbal reports, and resumed the interrupted task more quickly. However, Immediate participants resumed faster with practice, suggesting that people adapt to particularly disruptive forms of interruption. »
- Portée / limites : 17 employés d'un laboratoire de la marine américaine, tâche de simulation complexe. Le résultat porte sur l'interruption **par le système ou l'environnement** ; il appuie le fait de ne pas couper une tâche sans transition.
- En conception : quand l'app interrompt elle-même un parcours (invite, changement d'écran automatique, demande d'autorisation), le fait-elle à un point de rupture naturel, après avoir laissé finir le geste en cours ? Sinon, la personne retrouve-t-elle exactement où elle en était ?

---

## 7. Ce que disent les retours d'utilisateurs

### Dans les avis négatifs, les plaintes sur l'interface pèsent peu face aux pannes : un parcours confus se voit mal dans les avis
- Niveau de preuve : N2 (*IEEE Software* ; analyse manuelle d'un échantillon statistiquement représentatif) pour Khalid et al. ; N2 pour Pagano & Maalej (résumé lu) ; N4 pour le rapport d'éditeur cité en limite.
- Source : Khalid, H., Shihab, E., Nagappan, M. & Hassan, A. E., « What Do Mobile App Users Complain About? », *IEEE Software*, vol. 32, n° 3, p. 70-77 (année 2014 selon la page du laboratoire), PDF lu : https://www.swag.uwaterloo.ca/www/assets/other/papers/khalid-ieeesw-2014.pdf ; notice : https://swag.uwaterloo.ca/publications/what-do-mobile-app-users-complain-about.html ; Pagano, D. & Maalej, W., 2013, « User Feedback in the AppStore: An Empirical Study », RE 2013, PDF lu : https://ase.in.tum.de/lehrstuhl_1/images/people/pagano/RE2013PaganoMaalej.pdf (lus le 15.11.2026).
- Extrait lu : Khalid et al. : « we qualitatively study 6,390 low rated user-reviews for 20 free iOS apps. Our study uncovers 12 types of user complaints. We find that functional errors, feature requests and app crashes are the most frequent complaints. » Tableau III : « Interface Design 5 3.44 » (rang 5 en fréquence, 3,44 % en médiane), contre « Functional Error 1 26.68 ». Définition de la catégorie : « Complaint about the design, controls or visuals », exemple « "The design isn't sleek and not very intuitive" ». Pagano & Maalej : « Negative feedback such as shortcomings is typically destructive and misses context details and user experience. »
- Portée / limites : avis à 1 et 2 étoiles d'applications iOS gratuites connues, collectés vers 2013. Un avis dit ce qui a fâché au point de noter, pas ce qui a fait hésiter : la confusion de parcours, qui fait abandonner sans écrire, y est sous-représentée par construction. Un rapport d'éditeur (unitQ, présenté par MacTech le 26.02.2026, https://www.mactech.com/2026/02/26/unitq-report-app-users-file-6x-more-complaints-about-broken-basics-than-requests-for-new-features/, lu le 15.11.2026) annonce « 67.7 million Apple App Store and Google Play app reviews across 8,000 apps », classés par IA, et cite « navigation confusion, ad frequency, login friction » parmi les irritants, sans chiffre propre à la navigation : N4, méthode non publiée.
- En conception : ne pas conclure d'avis silencieux sur la navigation qu'un parcours est clair. Pour savoir si l'enchaînement pose question, observer (test de cinq personnes, entonnoir d'étapes), pas lire les avis. Les avis servent à repérer les pannes et les régressions après mise à jour (11 % des avis analysés par Khalid et al. les y attribuent).

### Quand on synthétise les études d'avis, la navigation difficile et le manque de guidage reviennent parmi les défauts récurrents
- Niveau de preuve : N2 (revue systématique de la littérature, 42 études retenues sur 670 ; *Journal on Interactive Systems*).
- Source : Oliveira, A. D. A. & Eler, M. M., 2025, « Analyzing Accessibility, Usability, and User Experience in Mobile Apps Through User Reviews: An Extended Systematic Literature Review », *Journal on Interactive Systems*, 16:1, doi:10.5753/jis.2025.5983, PDF lu : https://journals-sol.sbc.org.br/index.php/jis/article/download/5983/3396/31258 (lu le 15.11.2026).
- Extrait lu : « From 670 studies published since 2013, we selected 42 for thematic analysis. » ; « usability findings revealing six strengths (e.g., performance, design simplicity) but fourteen shortcomings (e.g., navigation difficulties, unintuitive interfaces) ». Dans la synthèse : « Many users report navigation difficulties, confusing interfaces, and slow or inefficient app performance leading to usability issues » ; « Lack of proper guidance on how to use the application can lead to frustration ».
- Portée / limites : synthèse thématique, sans fréquence agrégée ; les études retenues portent surtout sur des apps de santé physique et mentale. Elle établit que ces défauts reviennent, pas leur poids relatif — à lire avec l'entrée précédente, qui les montre minoritaires dans les avis négatifs d'apps grand public.
- En conception : le parcours dit-il, au moment où elle en a besoin, comment faire la chose suivante (manque de guidage), sans dépendre d'une aide séparée ? Le nombre de boutons visibles sur l'écran critique est-il justifié (la synthèse cite « many buttons » parmi les éléments non intuitifs) ?

---

## Mythes et raccourcis à ne pas reprendre

- **« Une barre de progression réduit l'abandon. »** Non démontré. La méta-analyse de Villar et al. (2013, 32 expériences) ne trouve pas d'effet significatif d'un indicateur constant ; un indicateur lent au départ **augmente** l'abandon. Ce qui compte est la progression perçue des premiers pas.
- **« Trop de choix paralyse. »** Pas en général : effet moyen « virtually zero » sur 50 expériences (Scheibehenne et al., 2010). L'effet existe sous conditions (tâche difficile, préférence incertaine, but de moindre effort ; Chernev et al., 2015). L'étude des confitures souvent citée n'a pas été lue ici.
- **« Le gradient d'objectif est prouvé pour les interfaces. »** Il est mesuré sur des programmes de fidélité (café) et un site de notation **récompensé** (Kivetz et al., 2006). Son application à une barre de progression d'app sans récompense est une extrapolation, raisonnable mais non mesurée par les sources lues.
- **« L'avance offerte double le taux de complétion. »** Le chiffre circule sur des sites de conseil (complétion de 19 % contre 34 % pour la carte de lavage auto de Nunes & Drèze) ; l'article n'a été lu qu'en résumé, qui ne donne pas de taux. Ne pas le citer.
- **« Le bouton à 300 millions de dollars. »** Récit de Spool (2009) : +45 % d'acheteurs, 15 millions le premier mois, 300 millions la première année, chez un détaillant anonyme, sans méthode publiée. Le constat qualitatif (le mur d'inscription bloquait des acheteurs) est utile ; les chiffres ne se citent que comme « rapportés par Spool ».
- **« Twitter : +29 % grâce à l'engagement progressif. »** Chiffre rapporté par Wroblewski (2010) sans définition de la conversion ni période. N4.
- **« Les tâches inachevées restent en tête, donc une check-list incomplète motive (Zeigarnik). »** Renvoi : `normes-lois-methodes.md`, § 4.2 — la méta-analyse de 2025 ne retrouve pas l'effet Zeigarnik. L'avance offerte (Nunes & Drèze) et le gradient d'objectif sont des mécanismes distincts, mesurés sur d'autres tâches.
- **« Les utilisateurs se plaignent surtout de la navigation. »** Dans l'échantillon de Khalid et al., les plaintes sur l'interface font 3,44 % (médiane) des avis négatifs, loin derrière les erreurs fonctionnelles (26,68 %). Une navigation confuse fait abandonner plus qu'elle ne fait écrire.
- **« Un bon onboarding augmente la rétention. »** Aucune source primaire lue ne le mesure. NN/g rapporte que les tutoriels en paquet de cartes n'améliorent pas la performance (Kendrick, 2020 ; Laubheimer, 2023, dans `ia-ethique-onboarding.md`).
- **« Après l'action, on renvoie sur la fiche de l'objet créé. »** Convention répandue, pas une règle : aucune source lue ne la prescrit. GOV.UK prescrit de dire ce qui suit et de proposer ce dont la personne a besoin ensuite ; la fiche n'est la bonne arrivée que si son action principale est cette suite.

## Non vérifié

Cherché sans qu'une source primaire puisse être lue, ou vu seulement dans des extraits de moteur de recherche ou des sites secondaires. Ne pas faire entrer tel quel dans le référentiel.

- **Nunes & Drèze (2006), texte intégral** : taux de complétion de l'expérience de lavage auto, effectif, conditions. Accès réservé aux abonnés ; seuls le résumé (IDEAS) et des sites de conseil ont été vus.
- **Byrne & Bovair (1997)**, « A Working Memory Model of a Common Procedural Error », *Cognitive Science* : connu seulement par Li et al. (2005) et des notices. **Chung & Byrne (2004)**, indice dynamique contre indicateur statique : connu seulement par Li et al.
- **Carroll & Carrithers (1984)**, « Training wheels in a user interface », *Communications of the ACM* : page ACM refusée (403). Le chiffre « 21 % plus rapides » et l'effectif de 12 personnes n'ont été vus que sur un agrégateur.
- **Hedegaard & Simonsen (2013)**, CHI, part de phrases d'avis contenant de l'information d'utilisabilité ou d'UX (« 13 %-49 % » selon un résumé de moteur) : page ACM refusée (403), page de l'université en 404.
- **Étude NN/g des tutoriels en paquet de cartes** (« 70 utilisateurs, 4 apps » selon un blog) : la page de l'étude n'a pas été ouverte ici.
- **Critique de Villar et al. (2013)** pour erreurs de codage (blog NeoAcademic) : non lue.
- **« Time to value » comme mesure** : aucune définition ni étude revue par les pairs trouvée ; la notion vient de blogs de growth. Les entrées de la section 5 appuient le principe (première valeur tôt) sans chiffre.
- **Spécification Material 3 des boutons** (hiérarchie d'emphase, nombre de boutons pleins par écran) : site m3.material.io rendu en JavaScript, illisible par les outils ; seule la documentation Android des composants a été lue.
- **Étude des confitures (Iyengar & Lepper, 2000)** : non lue ; ne pas la citer sans les méta-analyses ci-dessus.
- **Chiffres d'abandon d'apps après un seul usage** (du type « 25 % ») : non cherchés dans cette recherche ; ne pas les citer sans source primaire.

## Verdict pour l'agent ux

Ce que cette fiche permet d'exiger d'un parcours, écran par écran :

1. **Une seule action principale par écran, et c'est la suite la plus probable à ce moment du parcours** (N3, GOV.UK et Material) : l'action inverse de celle qu'on vient de faire ne peut pas l'être. Écart à justifier par écrit.
2. **Après une réussite : dire ce qui s'est passé et désigner la suite, sans impasse** (N3, GOV.UK ; N4, Baymard) ; aucune étape nécessaire après le signal de fin (N2, erreur post-complétion).
3. **Retour = écran précédent dans son état ; la surcouche se ferme d'abord ; une correction ramène au point de reprise** (N3, Android et GOV.UK ; N4, NN/g).
4. **Chaque écran dit où l'on est ; un parcours à étapes montre l'étape courante et le reste** (N1 AAA et N4 ; N4 NN/g et Baymard). Test : « où êtes-vous ? » sur l'écran montré seul.
5. **Premier usage : pas de mur avant la première valeur, concept central introduit en le faisant faire, réglages reportés derrière des défauts** (N3 Apple ; N4 NN/g et praticiens ; N2 ancien, Carroll).
6. **Interruption et reprise : restaurer l'état, laisser un indice visible du travail en cours** (N3 Apple ; N2 Iqbal & Horvitz, Trafton).
7. **Élan : montrer la distance restante, proposer le but suivant après une réussite** (N2, gradient d'objectif — mesuré hors interface : à présenter comme extrapolation). Une barre de progression n'est pas une preuve d'élan (N2, Villar).
8. Les avis des stores ne disent pas si un parcours est clair (N2) : l'enchaînement se vérifie par l'observation, le parcours cognitif et l'entonnoir d'étapes.

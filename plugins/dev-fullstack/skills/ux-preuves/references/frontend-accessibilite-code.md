# Fiche `ux-preuves` — Frontend — accessibilité côté code

> Fiche du skill `ux-preuves` (dev-fullstack), volet **frontend**, préchargé par `frontend`. Couvre : règles d'usage d'ARIA et leur statut, `<dialog>` et `showModal()`, Popover, `inert`, changements de route en SPA, régions live, formulaires accessibles en code (moment de validation, double envoi), ce que détectent les outils automatiques, lecteurs d'écran utilisés, `forced-colors` et focus Tailwind.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu. Versions, statuts Baseline et API **vieillissent
> en mois** : avant d'écrire du code qui en dépend, relire la page officielle (§ « Quand vérifier en
> ligne » du skill). Les sections « Verdict sur les règles du profil », « Mythes » et « Non vérifié »
> sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Recherche vérifiée le 9 novembre 2026. Chaque entrée renvoie à une page **ouverte** (WebFetch ou
téléchargement direct de la page puis extraction du texte). Les extraits sont verbatim, dans leur
langue d'origine. « Résumé seul lu » signale une source dont seul un résumé a été consulté.
Les chiffres calculés par l'agent sont marqués comme tels.

Hors périmètre (couvert ailleurs) : contraste, focus visible 2.4.7/2.4.11/2.4.13, taille de cible,
reflow, redimensionnement du texte, 2.5.3, alt, WCAG 3, chiffre de contraste du WebAIM Million,
overlays.

---

## 1. ARIA

### N'ajouter un rôle ou un attribut ARIA que si aucun élément HTML natif ne porte déjà la sémantique et le comportement voulus
- Niveau de preuve : N3 (document W3C informatif ; voir limites)
- Source : W3C, ARIA Working Group, 2026 (version datée du 24 février 2026), « Using ARIA », https://www.w3.org/TR/using-aria/
- Extrait lu : « If you can use a native HTML element or attribute with the semantics and behavior you require already built in, instead of re-purposing an element and adding an ARIA role, state or property to make it accessible, then do so. » — 2e règle : « Do not change native semantics, unless you really have to. »
- Portée / limites : le document est désormais un **« W3C Discontinued Draft »** (24.02.2026) : « the four rules of ARIA are kept for historical purposes and for easier reference, but there are no plans to continue work on this document ». Il renvoie à l'APG. Il se déclare « informative only ». La règle reste citée, mais ce n'est plus un texte vivant ni normatif.
- En code : chaque `role=` dans la PR a-t-il un équivalent natif (`<button>`, `<a href>`, `<dialog>`, `<details>`, `<input type="checkbox">`) qui aurait suffi ?

### Un rôle ARIA est une promesse de comportement : ne pas poser un rôle sans implémenter le clavier qu'il annonce
- Niveau de preuve : N3 (guide W3C/WAI)
- Source : W3C WAI, ARIA Authoring Practices Guide, « Read Me First », https://www.w3.org/WAI/ARIA/apg/practices/read-me-first/
- Extrait lu : « No ARIA is better than Bad ARIA » ; « Incorrect ARIA misrepresents visual experiences, with potentially devastating effects on their corresponding non-visual experiences. » ; « Principle 1: A role is a promise » ; « Unlike HTML input elements, ARIA roles do not cause browsers to provide keyboard behaviors or styling. »
- Portée / limites : l'APG prévient aussi que ses exemples ne sont pas du code de production : « Testing assistive technology interoperability is essential before using code from this guide in production. » La page **ne cite aucune statistique WebAIM** (la donnée chiffrée est dans l'entrée suivante).
- En code : un `<div role="button">` ou `role="tab"` sans gestion de `keydown` (Entrée, Espace, flèches selon le motif) est un défaut bloquant.

### Traiter l'ARIA comme un signal de risque en revue : les pages qui en utilisent ont en moyenne plus d'erreurs détectées
- Niveau de preuve : N2 (mesure automatisée sur un million de pages d'accueil)
- Source : WebAIM, 2026 (données de février 2026, page mise à jour le 30.03.2026), « The WebAIM Million — 2026 report », https://webaim.org/projects/million/
- Extrait lu : « 82.7% of the one million home pages used ARIA (excluding ARIA landmark roles), up from 79.4% in 2025. » ; « Home pages with ARIA present had significantly more errors (59.1 on average) than pages without ARIA (42 on average) » ; « This does not necessarily mean that ARIA introduced these errors (these pages were also more complex) »
- Portée / limites : **corrélation, pas causalité**, dit le rapport lui-même. Détection automatique seulement (WAVE), pages d'accueil seulement. L'écart relatif (≈ +41 %) est un calcul de l'agent, pas un chiffre du rapport. Même rapport : champs de formulaire sans label sur 51 % des pages, boutons vides sur 30,6 %.
- En code : une PR qui ajoute beaucoup d'`aria-*` mérite un passage au lecteur d'écran, pas seulement un lint.

### Un élément non natif qui joue le bouton doit être focalisable et réagir à Entrée ET Espace ; mieux, utiliser `<button>`
- Niveau de preuve : N3 (documentation de référence)
- Source : MDN Web Docs, « ARIA: button role », https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/button_role
- Extrait lu : « Where possible, it is recommended to use native HTML buttons […] rather than the button role, as native HTML buttons are supported by all user agents and assistive technology and provide keyboard and focus requirements by default » ; « Buttons are expected to be triggered using the Space or Enter key, while links are expected to be triggered using the Enter key. »
- Portée / limites : la page distingue le comportement clavier lien/bouton mais **ne formule pas** la règle « navigation = lien, action = bouton » ; aucune source primaire ouverte ne la formule (voir Non vérifié).
- En code : `onClick` sur `<div>`/`<span>` ; `<a>` sans `href` avec `onClick` ; `<a role="button">` sans gestion de l'Espace.

---

## 2. Éléments natifs

### Ouvrir une modale avec `showModal()` : le navigateur rend le reste inerte, gère Échap et place le focus
- Niveau de preuve : N1 (WHATWG HTML) + N3 (MDN)
- Source : WHATWG, HTML Living Standard, « The dialog element », https://html.spec.whatwg.org/multipage/interactive-elements.html#the-dialog-element ; MDN, « <dialog>: The Dialog element », https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/dialog
- Extrait lu : MDN : « When using `<dialog>` along with the `HTMLDialogElement.showModal()` method, this behavior is provided by the browser. » (rendre le reste inerte) ; « By default, a dialog invoked by the `showModal()` method can be dismissed by pressing the Esc key. » ; « A non-modal dialog does not dismiss via the Esc key by default ». Spec : l'attribut `closedby` à l'état Auto « behaves as Close Request state when the dialog was shown using its showModal() method ».
- Portée / limites : MDN : « Baseline Widely available […] since March 2022 ». `show()` (non modal) ne rend rien inerte et ne ferme pas sur Échap. La page MDN ne donne pas de statut Baseline propre à `closedby`.
- En code : modale ouverte par `dialog.show()` ou par l'attribut `open` au lieu de `showModal()` ; piège à focus maison et `keydown Escape` réécrits par-dessus un `<dialog>` modal (doublon) ; `closedby="none"` sans bouton de fermeture.

### Ne pas réécrire la restitution du focus d'un `<dialog>` ; placer `autofocus` sur l'élément d'interaction immédiate, jamais `tabindex` sur le `<dialog>`
- Niveau de preuve : N1 (WHATWG HTML) + N3 (APG, MDN)
- Source : WHATWG, HTML Living Standard (dialog close steps), https://html.spec.whatwg.org/multipage/interactive-elements.html#the-dialog-element ; W3C WAI APG, « Dialog (Modal) Pattern », https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/
- Extrait lu : spec : « When showModal() and show() are called, this element is set to the currently focused element before running the dialog focusing steps » puis, à la fermeture, « Let element be subject's previously focused element. » ; « The tabindex attribute must not be specified on dialog elements. » ; autofocus « on the descendant element of the dialog that the user is expected to immediately interact with ». APG : « When a dialog closes, focus returns to the element that invoked the dialog »
- Portée / limites : MDN ajoute qu'en cas de doute (contenu dynamique) « the `<dialog>` element itself may provide the best initial focus placement ». Si le déclencheur a disparu du DOM (ligne supprimée), le retour automatique ne suffit pas : l'APG prévoit une autre cible.
- En code : `tabIndex` sur `<dialog>` ; `useEffect` qui force `triggerRef.current.focus()` en plus du retour natif ; modale dont le déclencheur est démonté à la fermeture sans cible de repli.

### Ne pas utiliser `<dialog>` pour un menu contextuel, une infobulle ou une liste déroulante
- Niveau de preuve : N1 (WHATWG HTML)
- Source : WHATWG, HTML Living Standard, https://html.spec.whatwg.org/multipage/interactive-elements.html#the-dialog-element
- Extrait lu : « it is not conforming to use the dialog element when attempting to represent another type of control. For example, context menus, tooltips, and popup listboxes are not dialog boxes, so abusing the dialog element to implement these patterns is incorrect. »
- Portée / limites : pour ces cas, l'API Popover (entrée suivante) ou un motif APG dédié.
- En code : `<dialog>` utilisé comme menu de compte, infobulle ou combobox.

### Pour un contenu superposé non modal (menu, panneau, infobulle cliquable), préférer `popover` + `popovertarget` : fermeture légère, Échap, ordre de tabulation et relation ARIA fournis
- Niveau de preuve : N3 (documentation de référence)
- Source : MDN, « Using the Popover API », https://developer.mozilla.org/en-US/docs/Web/API/Popover_API/Using ; MDN, « popover » (attribut global), https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/popover
- Extrait lu : « The popover can be "light dismissed" » ; « The popover can also be closed, using browser-specific mechanisms such as pressing the Esc key. » ; « when closing the popover via the keyboard (usually via the Esc key), focus is shifted back to the invoker » ; « an implicit aria-details and aria-expanded relationship is set up between them. » Badge : « Baseline Widely available […] since April 2024 ».
- Portée / limites : ces automatismes ne valent que si la relation passe par `popovertarget` (pas par `showPopover()` seul — inféré de la formulation, non testé). La page ne dit pas qu'un popover rend le reste inerte : un popover n'est **pas** une modale. `popover="hint"` répond aussi aux close requests.
- En code : menu déroulant maison avec `useState` + listener `mousedown` global + `aria-expanded` manuel, là où `popovertarget` suffit ; popover utilisé pour un contenu qui doit bloquer la page (il faut `showModal()`).

### Utiliser `inert` pour neutraliser une zone (focus, clic, recherche, arbre d'accessibilité), en signalant visuellement qu'elle est inactive
- Niveau de preuve : N3 (documentation de référence)
- Source : MDN, « inert » (attribut global), https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/inert
- Extrait lu : « Baseline Widely available […] It's been available across browsers since April 2023. » ; « An inert element, along with its descendants, gets removed from the tab order and accessibility tree. » ; « By default, there is no visual way to tell whether or not an element or its subtree is inert. As a web developer, it is your responsibility to clearly indicate the content parts that are active and those that are inert. »
- Portée / limites : `inert` exclut aussi la recherche dans la page et la sélection de texte. Avec `showModal()`, inutile de le poser soi-même.
- En code : `aria-hidden="true"` posé sur `#root` pendant une modale (masque à l'AT mais laisse le focus atteindre la zone) au lieu d'`inert` ; zone inerte sans indice visuel.

### Pour un accordéon exclusif, utiliser `<details name="…">` sans script
- Niveau de preuve : N3 (documentation de référence)
- Source : MDN, « <details>: The Details disclosure element », https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/details
- Extrait lu : « This attribute enables multiple `<details>` elements to be connected, with only one open at a time. This allows developers to easily create UI features such as accordions without scripting. » ; « The contents of the `<summary>` element are used as the label for the disclosure widget. » ; rôles ARIA permis : « No `role` permitted ».
- Portée / limites : le badge « Widely available […] since January 2020 » couvre l'élément ; **la page ne donne aucun statut Baseline distinct pour l'attribut `name`** (non vérifié). Pas de section accessibilité sur la page MDN.
- En code : `role=` posé sur `<details>` (interdit) ; accordéon React avec `useState` et `aria-expanded` réécrits pour un simple dévoilement.

### `<select>` personnalisable (`appearance: base-select`) : à traiter comme amélioration progressive, pas comme base
- Niveau de preuve : N3 (documentation de référence et blog de l'éditeur du navigateur)
- Source : MDN, « Customizable select elements », https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/Customizable_select ; Chrome for Developers, 24.03.2025, « The <select> element can now be customized with CSS », https://developer.chrome.com/blog/a-customizable-select
- Extrait lu : MDN : « Limited availability — This feature is not Baseline because it does not work in some of the most widely-used browsers. » ; « Some JavaScript frameworks block these features; in others, they cause hydration failures when Server-Side Rendering (SSR) is enabled. » ; « falling back to "classic" selects in non-supporting browsers ». Chrome : « From Chrome 135 ».
- Portée / limites : MDN avertit que du contenu arbitraire dans le bouton « can alter the accessible value exposed to assistive technology ». Le blog Chrome note la perte des sélecteurs natifs du système mobile. Liste exacte des navigateurs supportant au 09.11.2026 : non vérifiée.
- En code : composant select qui dépend de `base-select` pour être utilisable ; contenu riche dans `<selectedcontent>` sans vérifier ce qu'annonce le lecteur d'écran ; échec d'hydratation en SSR.

### Tout `<button>` qui ne soumet pas porte `type="button"` ; tout bouton icône porte un nom accessible
- Niveau de preuve : N3 (documentation de référence)
- Source : MDN, « <button>: The Button element », https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/button
- Extrait lu : « `submit`: […] This is the default if the attribute is not specified for buttons associated with a `<form>` » ; « If your buttons are not for submitting form data to a server, be sure to set their `type` attribute to `button`. » ; « Buttons that only display an icon do not have an accessible name. »
- Portée / limites : MDN ajoute que laisser le texte visible aide ceux qui ne reconnaissent pas l'icône.
- En code : bouton « Afficher le mot de passe » ou « Ajouter une ligne » sans `type` dans un `<form>` (soumission involontaire) ; `<button><Icon/></button>` sans texte masqué ni `aria-label`.

---

## 3. SPA et changements de route

### Après un changement de route côté client, déplacer le focus sur un titre (ou un petit élément focalisable) de la nouvelle vue et annoncer la page
- Niveau de preuve : N4 (test utilisateur qualitatif, 5 participants)
- Source : Marcy Sutton (Gatsby), 11.07.2019, « What we learned from user testing of accessible client-side routing techniques with Fable Tech Labs », https://v2.gatsbyjs.com/blog/2019-07-11-user-testing-accessible-client-routing
- Extrait lu : 5 sessions (NVDA/Chrome, JAWS/Firefox, agrandissement d'écran, Dragon, contacteur). Constats : focaliser un titre a le mieux fonctionné pour les lecteurs d'écran ; remettre le focus en haut de l'application « would be very overwhelming » ; avec un fort zoom, « the prototypes pretty much fell apart when zoomed way in ». Recommandation révisée : un lien d'évitement qui prend le focus au changement de route, plus une région live annonçant la page.
- Portée / limites : 5 personnes, 2019, prototypes Gatsby. Aucune significativité statistique. Corroboration indirecte : WebAIM SRS #11 (entrée suivante) montre que la navigation par titres reste la stratégie dominante.
- En code : changement de route qui laisse le focus sur le lien cliqué (désormais démonté) ou sur `<body>` ; focus envoyé sur un conteneur pleine largeur (invisible au zoom).

### Donner à chaque page un `<title>` unique : c'est ce que lit l'annonceur de route de Next.js — qui, lui, ne déplace pas le focus
- Niveau de preuve : N3 (documentation officielle) + N1 (WCAG 2.4.2)
- Source : Vercel, Next.js docs (lastUpdated 2024-11-06), « Accessibility », https://nextjs.org/docs/architecture/accessibility ; W3C, « Understanding SC 2.4.2 Page Titled », https://www.w3.org/WAI/WCAG22/Understanding/page-titled.html
- Extrait lu : « Next.js includes a route announcer by default. » ; « The Next.js route announcer looks for the page name to announce by first inspecting `document.title`, then the `<h1>` element, and finally the URL pathname. For the most accessible user experience, ensure that each page in your application has a unique and descriptive title. » WCAG 2.4.2 : « Web pages have titles that describe topic or purpose. »
- Portée / limites : la page Next.js parle d'annonce, **pas** de gestion du focus ; elle ne distingue pas App Router et Pages Router. Elle cite aussi `eslint-plugin-jsx-a11y` inclus par défaut (statut actuel de l'intégration ESLint dans Next.js : non vérifié).
- En code : `metadata.title` identique sur toutes les routes ; vues sans `<h1>` ; SPA Vite/React Router sans aucun équivalent d'annonceur.

### Structurer chaque vue par des titres hiérarchisés : c'est le premier moyen de navigation des utilisateurs de lecteur d'écran
- Niveau de preuve : N2 (enquête, 1 780 réponses, échantillon non contrôlé)
- Source : WebAIM, 2026 (enquête de juillet-août 2026), « Screen Reader User Survey #11 Results », https://webaim.org/projects/screenreadersurvey11/
- Extrait lu : « Navigate through the headings on the page 1191 67.8% » ; « 88.3% of respondents find heading levels very or somewhat useful. » ; « only 3.4% use this [landmarks] as a primary method for finding information on a lengthy web page. »
- Portée / limites : « The sample was not controlled and may not represent all screen reader users. » 54,1 % de répondants nord-américains.
- En code : titres sautant des niveaux ou stylés via `<div className="text-2xl">` ; cible de focus de route qui n'est pas le `<h1>`.

---

## 4. Régions live et messages de statut

### Exposer tout message de statut (résultat, progression, erreur non focalisée) par un rôle ou une propriété, sans lui donner le focus
- Niveau de preuve : N1 (WCAG 2.2, critère AA)
- Source : W3C, « Understanding SC 4.1.3 Status Messages », https://www.w3.org/WAI/WCAG22/Understanding/status-messages.html
- Extrait lu : « status messages can be programmatically determined through role or properties such that they can be presented to the user by assistive technologies without receiving focus » ; « Since the dialog takes focus, it is defined as a change of context and does not meet the definition of a status message. »
- Portée / limites : techniques suffisantes listées : ARIA22 (`role=status`), ARIA19 (`role=alert` ou région live, pour les erreurs), ARIA23 (`role=log`). Un contenu qui reçoit le focus sort du critère.
- En code : toast « Enregistré » ou compteur « 12 résultats » sans `role="status"` ; spinner « Chargement… » muet.

### Monter la région live vide au chargement, puis y écrire le message ; ne jamais insérer un `role="alert"` déjà rempli
- Niveau de preuve : N3 (documentation de référence) + N4 (praticien)
- Source : MDN, « ARIA live regions », https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Guides/Live_regions ; MDN, « ARIA: alert role », https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/alert_role ; Scott O'Hara, 05.02.2022 (maj 22.08.2022), « Are we live? », https://www.scottohara.me/blog/2022/02/05/are-we-live.html
- Extrait lu : MDN : « Establish the live region before updating its content. » ; « The most reliable way to ensure that live regions are registered is to include them in the initial markup. » ; « Do not try to dynamically add/generate an element with `role="alert"` that is already populated with the alert message you want announced - this generally does _not_ lead to an announcement ». O'Hara : « ensuring an empty live region exists in your DOM, and injecting content into it when necessary » est plus robuste.
- Portée / limites : si la région est créée en JS, MDN conseille de différer l'écriture (« defer the content update to a later event-loop task »). O'Hara : passer de `display:none` à visible équivaut à une injection.
- En code : `{error && <p role="alert">{error}</p>}` (région et contenu naissent ensemble) ; toast monté avec son texte ; région conditionnée par un `hidden`.

### `aria-live="polite"` par défaut ; `assertive` / `role="alert"` seulement pour l'urgent
- Niveau de preuve : N3 (documentation de référence)
- Source : MDN, « ARIA live regions » et « ARIA: alert role » (URL ci-dessus)
- Extrait lu : « Normally, only `aria-live="polite"` is used. » ; « `aria-live="assertive"` should only be used for time-sensitive/critical notifications » ; « Setting `role="alert"` is equivalent to setting `aria-live="assertive"` and `aria-atomic="true"`. » ; « adding both `aria-live` and `role="alert"` causes double speaking issues in VoiceOver on iOS. »
- Portée / limites : pour `role="status"`, MDN conseille un `aria-live="polite"` redondant « To maximize compatibility ». O'Hara (2022) vise « none being the ideal » : le moins de régions live possible.
- En code : `role="alert"` sur un toast de succès ; `role="alert" aria-live="assertive"` cumulés ; plusieurs régions live concurrentes sur une page.

### Tester les annonces sur plusieurs couples lecteur d'écran / navigateur : le support des régions live diverge encore en 2026
- Niveau de preuve : N4 (tests de praticien, publiés)
- Source : Adrian Roselli, 14.01.2026, « Live Region Support », https://adrianroselli.com/2026/01/live-region-support.html
- Extrait lu : tableau « Current Support » : ligne « VoiceOver macOS / Safari ❌ buggy ❌ buggy » pour les régions `polite` ; « No live region announces when hidden ».
- Portée / limites : un testeur, versions du moment ; l'auteur prévient : « It's possible I got something wrong during transcription or testing. » Le tableau couvre aussi `<output>` et `aria-describedby` dynamique. Lecture fine colonne par colonne non garantie (tableau extrait en texte).
- En code : un test unitaire ne prouve pas l'annonce ; vérifier au moins NVDA ou JAWS + VoiceOver.

---

## 5. Formulaires

### Associer chaque champ à un `<label for>` visible ; le placeholder n'en tient jamais lieu
- Niveau de preuve : N3 (tutoriel W3C/WAI, MDN)
- Source : W3C WAI, « Labeling Controls », https://www.w3.org/WAI/tutorials/forms/labels/ ; W3C WAI, « Form Instructions », https://www.w3.org/WAI/tutorials/forms/instructions/ ; MDN, « <input> », https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/input
- Extrait lu : WAI : « Whenever possible, use the label element to associate text with form elements explicitly. The for attribute of the label must exactly match the id of the form control. » ; « placeholder text is not a replacement for labels » ; « it disappears from form fields when users start entering text ». MDN : « It is not a label, and should not be used as a substitute, because it isn't. »
- Portée / limites : WAI rappelle que le label agrandit la zone cliquable. WebAIM Million 2026 : labels manquants sur 51 % des pages d'accueil.
- En code : `<input placeholder="Email">` sans label ; `htmlFor` qui ne correspond pas à l'`id` (penser `useId()` en React) ; label visuel en `<span>` non associé.

### Relier le message d'erreur au champ par `aria-describedby`, n'activer `aria-invalid="true"` qu'après validation, et décrire l'erreur en texte
- Niveau de preuve : N1 (WCAG 3.3.1) + N3 (technique W3C ARIA21, GOV.UK)
- Source : W3C, « Understanding SC 3.3.1 Error Identification », https://www.w3.org/WAI/WCAG22/Understanding/error-identification.html ; W3C, « ARIA21: Using aria-invalid to Indicate An Error Field », https://www.w3.org/WAI/WCAG22/Techniques/aria/ARIA21 ; GOV.UK Design System, « Error summary », https://design-system.service.gov.uk/components/error-summary/
- Extrait lu : 3.3.1 : « If an input error is automatically detected, the item that is in error is identified and the error is described to the user in text. » ARIA21 : « The aria-invalid attribute should not be set to "true" before input validation is performed. » ; « The error message is associated with the field using aria-describedby ». GOV.UK (code d'exemple) : `<span class="govuk-visually-hidden">Error: </span> Enter your full name` et `aria-describedby="full-name-input-error"`.
- Portée / limites : l'exemple 2 d'ARIA21 code `aria-invalid="true"` en dur, ce qui contredit sa propre règle d'usage. L'exemple GOV.UK n'utilise pas `aria-invalid`.
- En code : `aria-invalid={!!errors.email}` évalué au premier rendu (champ vide annoncé invalide) ; erreur affichée sans `id` référencé ; erreur signalée par la seule couleur rouge.

### À la soumission en erreur : récapitulatif en haut, focus dessus, liens vers chaque champ, « Error: » en tête du `<title>`
- Niveau de preuve : N3 (guide d'institution)
- Source : GOV.UK Design System, « Error summary », https://design-system.service.gov.uk/components/error-summary/
- Extrait lu : « Always show an error summary when there is a validation error, even if there's only one. » ; « move keyboard focus to the error summary (the govuk-frontend javascript will do this for you) » ; « You must link the errors in the error summary to the answer they relate to. » ; « adding 'Error: ' to the beginning of the page <title> so screen readers read it out as soon as possible »
- Portée / limites : modèle conçu pour des formulaires multipages rendus serveur. Pour une SPA, l'équivalent « focus sur le premier champ en erreur » n'a pas été trouvé dans une source primaire ouverte (voir Non vérifié).
- En code : soumission en erreur qui ne déplace pas le focus ; récapitulatif sans liens ; libellés différents entre récapitulatif et message sous le champ.

### Moment de validation : ne pas valider pendant la saisie ; valider à la sortie de champ ou à la soumission est un arbitrage, pas une règle établie
- Niveau de preuve : N3 (GOV.UK) contre N4 (étude de praticien, 22 participants)
- Source : GOV.UK Design System, « Recover from validation errors », https://design-system.service.gov.uk/patterns/validation/ ; Luke Wroblewski, 01.09.2009, « Inline Validation in Web Forms », A List Apart, https://alistapart.com/article/inline-validation-in-web-forms/
- Extrait lu : GOV.UK : « Do not validate when the user moves away from a field. Wait until they try to move to the next part of the service » ; « avoid validating the information in a field before the user has finished entering it. This sort of validation can cause problems - especially for users who type more slowly. » Wroblewski : test de « 22 average users » avec Etre ; meilleure variante : « a 22% increase in success rates, a 22% decrease in errors made, a 31% increase in satisfaction rating, a 42% decrease in completion times » ; « validating inputs prematurely can be harmful » ; variante « After » = « This is validating "on blur" ».
- Portée / limites : les deux sources s'accordent contre la validation à la frappe. Elles divergent sur le blur : GOV.UK l'interdit (doctrine fondée sur l'usage de ses services, sans chiffre publié sur cette page) ; Wroblewski le soutient sur 22 personnes, sans test de significativité, sans participants handicapés déclarés, en 2009. Un commentaire sous l'article relève que les pourcentages portent sur de très petits effectifs.
- En code : erreur affichée dès la première frappe ; message qui apparaît au blur d'un champ simplement traversé au clavier (Tab) sans saisie.

### Contre le double envoi, ignorer le second clic plutôt que désactiver le bouton ; annoncer l'état d'envoi
- Niveau de preuve : N3 (guide d'institution, documentation de référence)
- Source : GOV.UK Design System, « Button », https://design-system.service.gov.uk/components/button/ ; MDN, « <button> », https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/button
- Extrait lu : GOV.UK : « Disabled buttons have poor contrast and can confuse some users, so avoid them if possible. » ; double clic dû notamment à des « motor impairments such as hand tremors » ; « you can configure the button to ignore the second click. To do this, set the data-prevent-double-click attribute to true. » MDN (attribut `disabled`) : « it cannot be pressed or focused. »
- Portée / limites : GOV.UK conditionne même la protection à la recherche (« If […] research shows that users are frequently sending information twice »). L'effet exact sur le focus quand un bouton focalisé devient `disabled` n'a pas été vérifié dans une source ouverte (MDN dit seulement qu'il n'est plus focalisable).
- En code : `disabled={isSubmitting}` sur le bouton qui a le focus ; libellé « Envoi… » sans `role="status"` ; aucune garde côté serveur (idempotence) contre le double envoi.

### Ne pas compter sur les bulles de validation natives du navigateur pour l'accessibilité
- Niveau de preuve : N3 (GOV.UK) + N4 (tests de praticien)
- Source : GOV.UK Design System, « Recover from validation errors » (URL ci-dessus) ; Adrian Roselli, 20.02.2019 (maj 21.05.2026), « Avoid Default Field Validation », https://adrianroselli.com/2019/02/avoid-default-field-validation.html
- Extrait lu : GOV.UK : « Turn off HTML5 validation. » ; « the visual style, placement and content of HTML5 error messages cannot be made consistent » ; « To turn off HTML5 validation, add 'novalidate' to your form tags. Do not add 'required' to your input fields. » Roselli : « the default messages browsers provide are not always useful and typically do not work with assistive technology » ; « In Chrome 100, the error message stays visible for 5 seconds » ; « browsers still do not respect zoom » (maj 2022).
- Portée / limites : GOV.UK reconnaît ne pas savoir si l'absence de `required` gêne les lecteurs d'écran (« We'd also like to know about any research into whether not adding 'required' to form fields causes problems for screen reader users »). Les tests de Roselli datent de 2019-2022 (Chrome 100) ; mises à jour récentes = renvois, pas nouveaux tests.
- En code : formulaire qui repose sur `required`/`pattern` seuls ; `novalidate` absent alors qu'une validation JS existe (double système de messages).

### Poser `autocomplete` avec un jeton normalisé sur chaque champ qui collecte une donnée de l'utilisateur
- Niveau de preuve : N1 (WCAG 2.2, critère AA)
- Source : W3C, « Understanding SC 1.3.5 Identify Input Purpose », https://www.w3.org/WAI/WCAG22/Understanding/identify-input-purpose.html ; GOV.UK Design System, « Date input », https://design-system.service.gov.uk/components/date-input/
- Extrait lu : 1.3.5 : « makes filling out forms easier, especially for people with certain cognitive disabilities » ; « is specifically scoped to inputs collecting information about the user ». GOV.UK : « set the autocomplete attribute on the 3 fields to bday-day, bday-month and bday-year ».
- Portée / limites : ne vise que les données sur l'utilisateur figurant dans la liste « Input Purposes » ; un champ « email du destinataire » n'est pas concerné.
- En code : champs nom, email, téléphone, adresse sans `autocomplete` ; `autocomplete="off"` sur l'identifiant ou le mot de passe.

### `input type="date"` : utilisable pour choisir une date proche, à éprouver aux technologies d'assistance ; pour une date connue (naissance), trois champs texte numériques
- Niveau de preuve : N4 (tests de praticiens) + N3 (GOV.UK)
- Source : Graham Armfield, Hassell Inclusion, début 2019, « Is input type="date" ready for use in accessible websites? », https://www.hassellinclusion.com/blog/input-type-date-ready-for-use/ ; Raghavendra Satish Peri, Digital A11y (maj 04.12.2024), « Input Type 'date': The Accessibility of HTML Date Picker », https://www.digitala11y.com/?p=26659 ; GOV.UK, « Date input », https://design-system.service.gov.uk/components/date-input/ et « Ask users for dates », https://design-system.service.gov.uk/patterns/dates/
- Extrait lu : Hassell : « our answer, sadly, has to be… "No" » ; « It seems impossible to successfully interact with date inputs using Dragon NaturallySpeaking. » Digital A11y : « the experience is much better than the custom date pickers that are inaccessible » ; dans Chrome les flèches font sortir le focus du calendrier, qui « needs to get trapped ». GOV.UK : « Use the date input component when you're asking users for a date they'll already know » (3 champs `type="text" inputmode="numeric"`) ; « Never make a calendar control that depends on JavaScript as the only input option. »
- Portée / limites : Hassell teste Firefox 65, Chrome 72, Safari 12 (2019) : résultats périmés pour les versions actuelles. Digital A11y : surtout Firefox + NVDA, mobile et Mac non testés. Aucune source ouverte ne donne un état 2026 multi-navigateurs. GOV.UK ne se prononce pas explicitement sur `type="date"`.
- En code : date de naissance en `type="date"` (défilement d'années) ; date picker maison sans saisie clavier possible ; `type="date"` non testé avec un lecteur d'écran.

---

## 6. Tests d'accessibilité

### Lire le « 57 % » de Deque comme une part d'**occurrences** de problèmes sur les données d'un fournisseur, pas comme une part des critères WCAG
- Niveau de preuve : N4 (étude d'éditeur d'outil sur ses propres audits, non revue par pairs)
- Source : Deque Systems, 10.03.2021, « Automated testing study identifies 57 percent of digital accessibility issues », https://www.deque.com/blog/automated-testing-study-identifies-57-percent-of-digital-accessibility-issues/ ; Deque, « Automated Accessibility Testing Coverage Report », https://www.deque.com/automated-accessibility-testing-coverage/ ; Deque, README axe-core, https://github.com/dequelabs/axe-core
- Extrait lu : blog : « Deque found that, on average, 57 percent of accessibility issues were completely covered by this automated testing. » Rapport : « spanning 13,000+ pages/page states, and nearly 300,000 issues » ; « this study concentrated on first-time audits » ; « 57.38% of total issues were identified using Deque's automated tests » ; but affiché : « to disprove the widely accepted belief that automated accessibility testing only provides 20 to 30% of accessibility testing coverage ». README : « find on average 57% of WCAG issues automatically » ; « returns zero false positives (bugs notwithstanding) ».
- Portée / limites : unité = occurrences, dominées par les erreurs fréquentes et faciles à détecter (le contraste 1.4.3 pèse 30,08 % de tous les problèmes, détecté à 83 % en automatique). Le tableau compte **4.1.1 Parsing** (34 488 problèmes, 90,28 % automatiques), critère **« Obsolete and removed »** en WCAG 2.2 (https://www.w3.org/WAI/WCAG22/Understanding/parsing.html). Calcul de l'agent, approximatif : sans Parsing, la part automatique tombe vers 53 %. Le rapport passe aussi à 80,39 % en ajoutant des tests « guidés » (résumé seul lu, via recherche).
- En code : un pipeline axe vert n'est pas un audit ; garder les tests clavier et lecteur d'écran dans la définition de fini.

### Ne jamais se fier à un seul outil automatique : sur une page piégée, 29 % des barrières ont échappé à tous les outils
- Niveau de preuve : N3 (évaluation d'institution publique, protocole publié)
- Source : Mehmet Duran (GDS, gouvernement britannique), 24.02.2017, « What we found when we tested tools on the world's least-accessible webpage », https://accessibility.blog.gov.uk/2017/02/24/what-we-found-when-we-tested-tools-on-the-worlds-least-accessible-webpage/
- Extrait lu : « it contains a total of 143 failures grouped into 19 categories » ; « Of the 143 barriers we created, a total of 42 were missed by all of the tools we tested. » ; « Asqatasun was the most effective – it found 41% of the barriers » ; « Google Developer Tools […] only picked up 17% of the barriers » ; « they cannot be relied on, by themselves, to check the accessibility of a website ».
- Portée / limites : page artificielle (chaque type de barrière y pèse autant), 10 outils de 2017 (axe testé avant sa v3.0, selon un commentaire). Mesure différente de celle de Deque : couverture de types de barrières, pas d'occurrences. Les deux chiffres ne se contredisent donc pas.
- En code : CI qui n'exécute qu'un seul moteur et le présente comme « conformité ».

### Écrire les tests de composants avec `getByRole(…, { name })` : une requête par rôle qui échoue signale souvent une UI inaccessible
- Niveau de preuve : N3 (documentation officielle)
- Source : Testing Library, « About Queries — Priority », https://testing-library.com/docs/queries/about/ ; « Guiding Principles », https://testing-library.com/docs/guiding-principles
- Extrait lu : « This should be your top preference for just about everything. There's not much you can't get with this (if you can't, it's possible your UI is inaccessible). » ; « A placeholder is not a substitute for a label. » ; `getByTestId` : « only recommended for cases where you can't match by role or text » ; principe : « The more your tests resemble the way your software is used, the more confidence they can give you. »
- Portée / limites : `getByRole` lit l'arbre d'accessibilité calculé par jsdom, pas celui d'un vrai navigateur ni ce qu'annonce un lecteur d'écran. La page note que le support des attributs ARIA « varies greatly across browsers and assistive technology ».
- En code : tests truffés de `getByTestId` ou de `container.querySelector('.btn')` ; `getByPlaceholderText` utilisé faute de label.

### Tester au lecteur d'écran sur les couples réellement utilisés : JAWS et NVDA sous Windows, VoiceOver sur iOS
- Niveau de preuve : N2 (enquête, 1 780 réponses, échantillon non contrôlé)
- Source : WebAIM, 2026 (enquête de juillet-août 2026), « Screen Reader User Survey #11 Results », https://webaim.org/projects/screenreadersurvey11/
- Extrait lu : lecteur principal sur ordinateur : « JAWS 975 55.0% NVDA 584 32.9% VoiceOver 116 6.5% » ; « 2026 saw a resurgence in respondents reporting JAWS as their primary screen reader with both NVDA and VoiceOver declining since 2024. » ; couples : « JAWS with Chrome 549 31.2% NVDA with Chrome 304 17.3% JAWS with Edge 299 17.0% NVDA with Firefox 160 9.1% » ; mobile : « VoiceOver 72.2% TalkBack 29.5% » ; « Windows 1607 90.7% ».
- Portée / limites : forte variation régionale (Amérique du Nord : JAWS 72,5 % contre NVDA 15,6 % ; Europe : 42,8 % contre 42,3 %). Non représentatif selon WebAIM lui-même.
- En code : plan de test limité à VoiceOver macOS (6,5 % des répondants en usage principal) ; aucun test mobile.

---

## 7. Mouvement et préférences d'affichage

### Envelopper toute animation de mouvement non essentielle dans `prefers-reduced-motion` (réduire ou remplacer, pas forcément supprimer)
- Niveau de preuve : N1 (WCAG 2.3.3, niveau AAA) + N3 (MDN)
- Source : W3C, « Understanding SC 2.3.3 Animation from Interactions », https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html ; MDN, « prefers-reduced-motion », https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@media/prefers-reduced-motion
- Extrait lu : 2.3.3 : « Motion animation triggered by interaction can be disabled. » ; « Vestibular (inner ear) disorder reactions include dizziness, nausea and headaches. » ; technique C39 « Using the CSS prefers-reduced-motion query to prevent motion ». MDN : « the user prefers an interface that removes, reduces, or replaces motion-based animations » ; « available across browsers since January 2020 ».
- Portée / limites : 2.3.3 est **AAA** : hors d'une cible AA stricte, mais seule base normative du sujet. L'exemple MDN remplace un `scale` par un fondu.
- En code : parallax, `scroll-behavior: smooth`, transitions de route ou Framer Motion sans branche `useReducedMotion`/`motion-reduce:`.

### En mode couleurs forcées, ne porter aucune information par `box-shadow`, dégradé ou couleur d'auteur ; icônes SVG en `currentColor`
- Niveau de preuve : N3 (documentation de référence et éditeur du navigateur)
- Source : MDN, « forced-colors », https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@media/forced-colors ; Microsoft Edge Team, 17.09.2020, « Styling for Windows high contrast with new standards for forced colors », https://blogs.windows.com/msedgedev/2020/09/17/styling-for-windows-high-contrast-with-new-standards-for-forced-colors/ ; MDN, « prefers-contrast », https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@media/prefers-contrast
- Extrait lu : MDN : « box-shadow is forced to 'none' » ; « background-image is forced to 'none' for values that are not url-based » ; « User agents choose system colors based on native element semantics, _not_ on added ARIA roles. » ; « web authors should **not** be using the forced-colors media feature to create a separate design ». Edge : « Forced color modes do not adjust SVGs » ; « apply the currentColor keyword to fills and strokes within an SVG » ; contour transparent : « you'll get a visual outline on the element ». `prefers-contrast: custom` : « This value will match the color palette specified by users of forced-colors: active. »
- Portée / limites : `forced-colors` Baseline « since September 2022 », `prefers-contrast` « since May 2022 ». Un `<div role="button">` ne reçoit pas les couleurs système d'un bouton : argument de plus pour le natif.
- En code : état sélectionné indiqué par un fond seul ou une ombre ; bordure `border-transparent` supprimée (elle devient visible et utile en couleurs forcées) ; SVG à `fill="#333"` codé en dur.

### Avec Tailwind, un anneau de focus `ring-*` (ombre portée) disparaît en couleurs forcées : utiliser `outline-hidden` (pas `outline-none`) ou un `outline` réel
- Niveau de preuve : N3 (documentation officielle) — raisonnement composé de deux sources
- Source : Tailwind CSS v4.3, « outline-style », https://tailwindcss.com/docs/outline-style ; Tailwind CSS, « box-shadow », https://tailwindcss.com/docs/box-shadow ; MDN « forced-colors » (URL ci-dessus)
- Extrait lu : Tailwind : « Use the `outline-hidden` utility to hide the default browser outline on focused elements, while still preserving the outline in forced colors mode » ; `outline-hidden` = « outline: 2px solid transparent; outline-offset: 2px; » ; `outline-none` = « outline-style: none; ». La page box-shadow documente `ring` = « --tw-ring-shadow: 0 0 0 1px; ». MDN : « box-shadow is forced to 'none' ».
- Portée / limites : la disparition du `ring` en couleurs forcées est une **déduction** (ring documenté sur la page box-shadow + box-shadow forcé à none), pas une phrase de Tailwind. À confirmer par émulation `forced-colors: active` dans les outils de développement.
- En code : `focus-visible:outline-none focus-visible:ring-2` (motif shadcn courant) → remplacer `outline-none` par `outline-hidden` ou ajouter `focus-visible:outline-2`.

---

## Verdict sur les règles du profil

**« Accessibilité : labels (jamais placeholder seul), focus visible, Escape sur modale, contraste vérifié. »**
- Labels, jamais placeholder seul : **soutenue** (W3C WAI tutorials, MDN `<input>`, Testing Library ; WebAIM Million 2026 : 51 % de pages avec labels manquants).
- Escape sur modale : **soutenue** (APG Dialog Modal ; HTML : `showModal()` le fournit par défaut via `closedby` Auto). Précision à ajouter : obtenir Échap, l'inertie du fond et le retour du focus **par `showModal()`**, ne pas les réécrire ; un `<dialog>` ouvert par `show()` ne ferme pas sur Échap.
- Focus visible, contraste : hors périmètre de ce document (couverts ailleurs).
- Manques : retour du focus à la fermeture, annonce des messages de statut (4.1.3), gestion du focus au changement de route.

**« Focus visible (`focus-visible:`) sur tout interactif. »**
- **Soutenue** sur le principe (MDN `:focus-visible` : « removing focus styles makes keyboard navigation inaccessible for sighted users » ; MDN précise que les styles de focus restent requis « when focus is managed via scripts »).
- **Défaut d'implémentation fréquent à ajouter** : un indicateur fait uniquement de `ring-*` (box-shadow) disparaît en mode couleurs forcées ; `outline-none` supprime aussi le contour de repli. Préférer `outline-hidden` ou un `outline` réel (déduction de deux sources, voir entrée Tailwind).

**« Doctrine formulaires : validation à la sortie de champ, jamais seulement au submit ; erreurs serveur mappées aux champs ; bouton de soumission à état loading + protection double-submit. »**
- Validation à la sortie de champ : **contestée**. Le guide GOV.UK dit l'inverse en toutes lettres : « Do not validate when the user moves away from a field. » L'étude favorable au blur (Wroblewski, 2009) porte sur 22 personnes, sans test statistique ni participants handicapés déclarés. Seul point d'accord : **ne pas valider pendant la frappe**. Formulation défendable : « jamais pendant la frappe ; au blur seulement pour les champs à contrainte non devinable (identifiant disponible, format de mot de passe) ; toujours à la soumission, avec récapitulatif et focus ».
- « Jamais seulement au submit » : **convention sans preuve trouvée**, et contredite par GOV.UK, dont le modèle repose sur la soumission.
- Erreurs serveur mappées aux champs : **soutenue** indirectement (WCAG 3.3.1 : l'élément en erreur est identifié et l'erreur décrite en texte ; GOV.UK : récapitulatif lié à chaque champ ; validation serveur toujours obligatoire).
- État loading + protection double-submit : **soutenue sur le besoin** (GOV.UK cite les tremblements et les connexions lentes), mais **à préciser sur le moyen** : GOV.UK déconseille les boutons désactivés (« avoid them if possible ») et ignore le second clic (`data-prevent-double-click`). Un `disabled` posé sur le bouton focalisé le rend non focalisable (MDN). Recommandation : garder le bouton actif, ignorer les clics pendant l'envoi, annoncer « Envoi en cours » dans une région `role="status"` déjà montée, et rendre l'envoi idempotent côté serveur.

**« Plateforme native avant librairie : `<dialog>`, `<details>`, `popover`, `<form>` + `FormData`, `input type="date"` … »**
- `<dialog>` (Baseline depuis mars 2022), `<details>` (depuis janvier 2020), `popover` (Widely available, depuis avril 2024), `inert` (depuis avril 2023) : **soutenue** (première règle d'ARIA, APG « No ARIA is better than Bad ARIA », comportements fournis par le navigateur). Réserve : l'attribut `name` de `<details>` n'a pas de statut Baseline propre sur MDN ; `<select>` personnalisable reste en **disponibilité limitée** (MDN).
- `input type="date"` : **contestée / à nuancer**. Hassell (2019) répondait « No », notamment pour Dragon et l'annonce des erreurs ; Digital A11y (2024) le juge meilleur que la plupart des sélecteurs maison, mais garde des défauts sous Chrome. Aucune source ouverte ne donne un état 2026 multi-navigateurs. GOV.UK préfère trois champs texte numériques pour une date connue. Règle proposée : `type="date"` pour une date proche à choisir, testé au lecteur d'écran ; trois champs `inputmode="numeric"` + `autocomplete="bday-*"` pour une date de naissance.
- `<form>` + `FormData` : pas de source d'accessibilité spécifique trouvée (**convention sans preuve trouvée** sous l'angle a11y ; le gain vient du `<form>` natif : Entrée soumet, bouton `type="submit"`). Associer `novalidate` si la validation est en JS (GOV.UK).

---

## Mythes et affirmations contestées

- **« Les outils automatiques détectent 57 % des problèmes. »** Le chiffre vient d'un éditeur d'outil (Deque, 2021), mesuré en occurrences sur ses propres audits. Le contraste y pèse 30 % et il inclut 4.1.1 Parsing, critère retiré en WCAG 2.2. Le « 20-30 % » qu'il conteste mesure autre chose : des critères WCAG. GOV.UK (2017) : 29 % des types de barrières ratés par tous les outils, meilleur outil à 41 %. Ces chiffres ne mesurent pas la même chose et ne s'additionnent pas.
- **« L'ARIA cause les erreurs. »** WebAIM Million 2026 montre une corrélation (59,1 contre 42 erreurs) et précise que les pages avec ARIA sont plus complexes. On ne peut pas en tirer « ARIA = erreurs ». On peut en tirer « ARIA = risque à vérifier ».
- **« Next.js gère l'accessibilité des changements de route. »** Il annonce le titre de la page (title → h1 → URL) ; sa documentation ne parle pas de déplacer le focus.
- **« Un `role="alert"` rendu conditionnellement sera lu. »** MDN : insérer un élément `role="alert"` déjà rempli « generally does not lead to an announcement ».
- **« Ajouter `aria-live` en plus de `role="alert"` maximise la compatibilité. »** MDN : double lecture sous VoiceOver iOS.
- **« La validation inline est prouvée meilleure. »** L'étude classique (2009) compte 22 participants. Elle soutient surtout de ne pas valider pendant la frappe, et elle est contredite sur le blur par GOV.UK.
- **« Using ARIA est la norme du W3C sur l'ARIA. »** C'est un document informatif, devenu « Discontinued Draft » le 24.02.2026 ; l'APG le remplace comme référence pratique.
- **« NVDA est le lecteur d'écran majoritaire. »** Vrai une seule fois dans l'historique WebAIM. En 2026 : JAWS 55,0 %, NVDA 32,9 % en usage principal (échantillon non contrôlé, très nord-américain).

---

## Non vérifié

- **Règle « lien pour naviguer, bouton pour agir »** : aucune source primaire ouverte ne la formule telle quelle (MDN ne donne que la différence clavier Entrée / Espace).
- **Focus sur le premier champ en erreur** (alternative SPA au récapitulatif GOV.UK) : pas de source primaire ouverte.
- **Tab qui sort d'un `<dialog>` modal vers l'interface du navigateur** (au lieu d'un bouclage comme dans l'APG) : non vérifié dans la spec ou MDN.
- **Comportement du focus quand le bouton focalisé passe à `disabled`** (perte vers `<body>` ?) : non vérifié.
- **Statut Baseline de `closedby`, de `<details name>`, et liste des navigateurs supportant `appearance: base-select`** au 09.11.2026 : non vérifiés.
- **État 2026 de `input type="date"`** avec NVDA, JAWS, VoiceOver, TalkBack et Dragon : aucune source récente multi-plateforme ouverte.
- **Support détaillé de `role="status"` par a11ysupport.io** : page ouverte mais contenu non rendu (résumé de recherche seul lu, non retenu).
- **Adrian Roselli, « Defining 'Toast' Messages » (2020, maj 2025)** : résumé seul lu (recherche), non retenu comme entrée.
- **Rapport Deque 2022 à 80,39 % avec tests guidés** : résumé seul lu (recherche).
- **Date de première publication de la page « Coverage Report » de Deque** : le JSON-LD de la page indique 2025-11-11, sans doute une republication. La date de l'étude (10.03.2021) vient du billet de blog.
- **Intégration actuelle d'ESLint / `eslint-plugin-jsx-a11y` dans les versions récentes de Next.js** : la page ouverte date de novembre 2024.
- **Pages React officielles (react.dev) sur l'accessibilité** : non consultées.

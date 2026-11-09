# Fiche `ux-preuves` — Rédaction — microcopy et UX writing

> Fiche du skill `ux-preuves` (dev-fullstack), volet **rédaction**, préchargé par `redacteur`. Couvre : libellés d'action et dialogues de confirmation, messages d'erreur au-delà de GOV.UK, états vides et notifications, liens et noms accessibles (WCAG 2.4.4, 2.4.6, 2.5.3, 4.1.3, textes alternatifs), casse et chiffres, concision et troncature, guides de style de référence, emoji.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Verdict sur les règles
> du profil » (ou « Ce que le profil devrait dire »), « Mythes » et « Non vérifié » sont opposables
> autant que les entrées : ce qui y figure ne se cite pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Recherche du 9 novembre 2026. Toutes les sources citées ci-dessous ont été ouvertes avec WebFetch,
ou téléchargées puis converties avec `pdftotext`. Pour les pages Apple HIG, le rendu HTML ne livre
que le titre : le texte a été lu dans le JSON public que sert la page
(`developer.apple.com/tutorials/data/design/human-interface-guidelines/<page>.json`). Les deux URL
sont données. Les extraits sont verbatim, dans leur langue d'origine.

Hors périmètre, parce que déjà couvert ailleurs : ISO 24495-1, F-pattern, GOV.UK « Error message »,
WCAG 3.3.1, placeholders (NN/g 2014), validation en ligne.

Échelle des niveaux de preuve : N1 = norme ; N2 = étude empirique (taille de l'échantillon citée) ;
N3 = guideline d'une institution ou d'une plateforme ; N4 = avis d'expert ou article de praticien.
Les articles NN/g sont classés N4 : ce sont des articles de praticiens, nourris de tests
utilisateurs dont la méthode n'est pas publiée avec l'article.

---

## 1. Libellés d'action (boutons, dialogues de confirmation)

### Nommer un bouton par ce qu'il fait, et pas par « OK »
- Niveau de preuve : N4
- Source : Jakob Nielsen, 2008 (26 mai), « OK-Cancel or Cancel-OK? The Trouble With Buttons », https://www.nngroup.com/articles/ok-cancel-or-cancel-ok/
- Extrait lu : « It's often better to name a button to explain what it does than to use a generic label (like "OK"). » ; « An explicit label serves as just-in-time help, giving users more confidence in selecting the correct action. »
- Portée / limites : argument d'expert, sans donnée chiffrée. Sur l'ordre des boutons, l'article ne tranche pas : il faut suivre la plateforme (« Do what the platform owner tells you to do »). L'article ne parle pas de verbes en tant que tels, seulement de libellés descriptifs.
- En rédaction : si on lit le bouton seul, sans le dialogue, sait-on ce qui va se passer ?

### Dans une alerte, mettre sur le bouton un verbe qui reprend le texte, réserver « OK » aux alertes purement informatives et toujours appeler « Annuler » le bouton qui annule
- Niveau de preuve : N3
- Source : Apple, Human Interface Guidelines, « Alerts » (dernière modification listée : 2 février 2024), https://developer.apple.com/design/human-interface-guidelines/alerts (texte lu via https://developer.apple.com/tutorials/data/design/human-interface-guidelines/alerts.json)
- Extrait lu : « Aim for a one- or two-word title that describes the result of selecting the button. Prefer verbs and verb phrases that relate directly to the alert text » ; « The meaning of "OK" can be unclear even in alerts that ask people to confirm that they want to do something. » ; « Always use "Cancel" to title a button that cancels the alert's action. »
- Portée / limites : convention de plateforme, en anglais. Apple met les boutons en title case (« use title-style capitalization »), ce qui ne se transpose pas en français. Le style destructif est réservé à une action destructive que la personne n'a **pas** choisie délibérément : pour « Vider la corbeille », choisi exprès, le bouton n'est pas stylé destructif.
- En rédaction : « OK » est-il sur une alerte qui demande une décision ? Le bouton de confirmation reprend-il le verbe du titre (« Supprimer » sous « Supprimer ce fichier ? ») ?

### Sur un dialogue, éviter les titres en excuse, ambigus ou en question vide (« Attention ! », « Êtes-vous sûr ? ») et préférer la paire explicite « Annuler / Supprimer » à « Non / Oui »
- Niveau de preuve : N3 (version archivée de la guideline)
- Source : Google, Material Design (version 1, archivée), « Dialogs », https://m1.material.io/components/dialogs.html (atteinte par redirection depuis https://material.io/archive/guidelines/components/dialogs.html)
- Extrait lu : titres à éviter : « apologies, ambiguity, or questions, such as "Warning!" or "Are you sure?" » ; « The dismissive action text "No" answers the question, but does not suggest what will happen afterwards. » ; « A better action pair would be an explicit "Cancel" and "Delete." »
- Portée / limites : c'est Material **1**. La page Material 3 (m3.material.io) ne se rend qu'en JavaScript et n'a pas pu être lue : rien ne dit ici que Material 3 formule la règle de la même façon.
- En rédaction : le titre nomme-t-il l'action et l'objet ? Un bouton « Non » ou « Oui » oblige-t-il à relire la question pour savoir ce qu'il fait ?

### Dans une confirmation, donner aux réponses le résumé de leur conséquence (« Supprimer le fichier / Garder le fichier ») et ne confirmer que ce qui est rare et grave
- Niveau de preuve : N4
- Source : Jakob Nielsen, 2018 (18 février ; revu le 7 août 2026), « Confirmation Dialogs Can Prevent User Errors — If Not Overused », https://www.nngroup.com/articles/confirmation-dialog/
- Extrait lu : « Instead of Yes/No answers, provide response options that summarize what will happen for each possible response. » ; « if you cry wolf too many times, people will stop paying attention to the question. »
- Portée / limites : avis d'expert. L'effet d'habituation est affirmé, pas mesuré dans l'article. Apple converge : pas d'alerte pour une action courante et annulable, même destructive (HIG « Alerts »).
- En rédaction : cette confirmation protège-t-elle d'une erreur rare et irréversible, ou est-elle un réflexe ? Les deux boutons disent-ils chacun ce qu'ils font ?

### Faire répondre les boutons au titre du dialogue, et limiter un bouton à quelques mots courts, à la voix active
- Niveau de preuve : N3
- Source : Microsoft, « Writing style – Windows apps » (ms.date 24.09.2020), https://learn.microsoft.com/en-us/windows/apps/design/style/writing-style
- Extrait lu : « Make sure that your buttons are clear answers to the question posed by the title » ; « The longest the text on a button should ever be is a couple short words, and many should be shorter than that. » ; « use words that represent actions rather than reactions. »
- Portée / limites : guideline Windows. La même page invoque une recherche (« Research shows that people respond best to a writing style that's friendly, helpful, and concise ») sans la citer : la recherche n'est pas vérifiable. GOV.UK, qui converge, nuance la brièveté : « Write button text in sentence case, describing the action it performs » ; « You may need to include more or different words to better describe the action. » (https://design-system.service.gov.uk/components/button/)
- En rédaction : si on lit le titre puis le bouton, forment-ils une question et sa réponse ? Le bouton est-il un verbe d'action ou une réaction (« OK », « D'accord ») ? Un message d'erreur se termine-t-il par « OK » ? Le guide des erreurs Windows l'exclut et demande « Fermer » à la place (« Don't use OK for error messages, because this wording implies that problems are OK. », https://learn.microsoft.com/windows/win32/uxguide/mess-error, ms.date 11.01.2022 ; argument sémantique, non mesuré).

---

## 2. Messages d'erreur, au-delà de GOV.UK

### Rendre l'erreur visible près du problème, dans la langue de l'utilisateur, avec un remède, sans le blâmer ; un code d'erreur ne sert qu'au diagnostic
- Niveau de preuve : N4
- Source : Tim Neusesser et Evan Sunwall, 2023 (14 mai), « Error-Message Guidelines », https://www.nngroup.com/articles/error-message-guidelines/
- Extrait lu : « Avoid technical jargon and use language familiar to your users instead. » ; « Merely stating the problem is also not enough; offer some potential remedies. » ; « Don't use phrasing that blames users or implies they are doing something wrong. » ; « Hide or minimize the use of obscure error codes or abbreviations; show them for technical diagnostic purposes only. »
- Portée / limites : synthèse de praticiens, sans protocole publié. Aucune date de mise à jour affichée sur la page.
- En rédaction : le message propose-t-il une action ? Un code apparaît-il en premier plan à la place d'une explication ?

### Construire un message d'erreur en trois parties, problème, cause et solution, et ne mettre un code d'erreur qu'en complément, derrière « Afficher les détails »
- Niveau de preuve : N3
- Source : Microsoft, « Error Messages in Windows 7 – Win32 apps » (ms.date 11.01.2022), https://learn.microsoft.com/windows/win32/uxguide/mess-error
- Extrait lu : « Effective error messages inform users that a problem occurred, explain why it happened, and provide a solution so users can fix the problem. » ; « Always provide a text description of the problem and solution. Don't depend just on the error code for this purpose. » ; « Use Show/Hide details to display error codes. »
- Portée / limites : guide desktop. La page demande aussi un message distinct pour chaque cause détectable, pour ne pas faire chercher l'utilisateur. Le « pourquoi » n'est donc pas toujours facultatif : quand la cause est connue, la nommer évite le dépannage.
- En rédaction : un même message couvre-t-il plusieurs causes que le programme sait distinguer ? Le code d'erreur remplace-t-il la solution ?

### Éviter les mots qui blâment ou dramatisent (« invalide », « illégal », « fatal »), et accepter le passif quand l'actif accuserait l'utilisateur
- Niveau de preuve : N3
- Source : Microsoft, « Error Messages in Windows 7 – Win32 apps », https://learn.microsoft.com/windows/win32/uxguide/mess-error
- Extrait lu : « Illegal, invalid, bad (use incorrect instead) » ; « Catastrophic, fatal (use serious instead) » ; « While the active voice is generally preferred, use the passive voice when the user is the subject and might feel blamed for the error if the active voice were used. » ; « Use the word "sorry" only in error messages that result in serious problems for the user »
- Portée / limites : exception explicite à la règle de la voix active. Les règles sur « please » et « sorry » divergent de GOV.UK (déjà couvert ailleurs) : Microsoft admet « sorry » quand la perte est grave.
- En rédaction : la phrase a-t-elle l'utilisateur pour sujet d'une faute (« Vous avez saisi… ») ? Y a-t-il « invalide » ou « illégal » là où « incorrect » suffit ?

### Donner à une alerte un titre qui décrit la situation, jamais « Erreur » ou « Erreur 329347 », et formuler la correction plutôt que la faute
- Niveau de preuve : N3
- Source : Apple, HIG « Alerts », https://developer.apple.com/design/human-interface-guidelines/alerts (via le JSON cité en tête), et Apple, HIG « Writing » (modifiée le 16 décembre 2025), https://developer.apple.com/design/human-interface-guidelines/writing (via https://developer.apple.com/tutorials/data/design/human-interface-guidelines/writing.json)
- Extrait lu : « Avoid writing a title that doesn't convey useful information — like "Error" or "Error 329347 occurred" » ; « use a neutral, approachable tone … avoid being oblique or accusatory, or masking the severity of the issue » ; « "That password is too short" isn't as helpful as "Choose a password with at least 8 characters." » ; « Interjections like "oops!" or "uh-oh" are typically unnecessary and can sound insincere. »
- Portée / limites : guideline de plateforme. Apple ne bannit pas « oops », elle le juge « typically unnecessary ». Elle demande aussi de ne pas masquer la gravité, ce qui borne la recherche d'un ton léger.
- En rédaction : le titre seul permet-il de savoir ce qui s'est passé ? Le message dit-il ce qu'il faut faire (« Choisissez au moins 8 caractères ») ou seulement ce qui est faux (« Trop court ») ?

### Des messages de compilateur réécrits pour des débutants ont réduit les erreurs mesurées, mais cet effet n'a pas été répliqué partout
- Niveau de preuve : N2 (essai contrôle/intervention, environ 200 étudiants, près de 50 000 erreurs)
- Source : Brett A. Becker, Graham Glanville et al., 2016, « Effective compiler error message enhancement for novice programming students », Computer Science Education 26(2-3), 148-175, DOI 10.1080/08993408.2016.1225464 ; résumé lu sur https://arc.cct.ie/fac_research/1
- Extrait lu : « The effectiveness of this approach was tested in an empirical control/intervention study of approximately 200 students generating almost 50,000 errors. » ; « Results show that the intervention group experienced reductions in the number of overall errors, errors per student, and several repeated error metrics. »
- Portée / limites : résumé seul lu. Le contexte est celui d'étudiants en Java, pas d'utilisateurs d'une interface grand public. Le contre-résultat de Pettit, Homer et Gee, 2017 (SIGCSE, « Do Enhanced Compiler Error Messages Help Students? Results Inconclusive », résumé lu sur https://digitalcommons.acu.edu/info_tech_computing/6) conclut que « enhancing compiler error messages shows no measurable benefit to students ». La revue du groupe de travail ITiCSE 2019 (Becker, Denny et al., DOI 10.1145/3344429.3372508) dit classer ses recommandations par type de preuve, « historical, anecdotal, and empirical » (page compagnon https://iticse19-wg10.github.io), mais le texte intégral n'a pas été lu.
- En rédaction : ne pas promettre qu'une reformulation réduira les erreurs. La tester sur un indicateur, par exemple le taux de répétition de la même erreur.

### Une erreur de formulaire doit être polie, en langue familière, et dire quelle est la faute et comment la corriger
- Niveau de preuve : N2 (expérience contrôlée avec eye tracking, N = 65)
- Source : Mirjam Seckler, Silvia Heinz, Javier A. Bargas-Avila, Klaus Opwis, Alexandre N. Tuch, 2014, « Designing Usable Web Forms – Empirical Evaluation of Web Form Improvement Guidelines », CHI 2014, 1275-1284, https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/42513.pdf (PDF lu avec pdftotext)
- Extrait lu : « This study reports a controlled eye tracking experiment (N = 65) that shows the combined effectiveness of 20 guidelines » ; règle 14 : « Error messages should be polite and explain to the user in familiar language that a mistake has occurred. Eventually the error message should apologize for the mistake and it should clearly describe what the mistake is and how it can be corrected. »
- Portée / limites : l'étude mesure l'effet **combiné** de 20 règles, sur des formulaires de sites d'information germanophones. La formulation des erreurs n'y est pas isolée. La règle 14 admet l'excuse, à rebours de GOV.UK.
- En rédaction : le message nomme-t-il la faute et sa correction, en mots de l'utilisateur ?

### Un ton amical ou neutre, et un rôle actif laissé à l'utilisateur, améliorent la réaction affective à un message d'erreur
- Niveau de preuve : N2 (essai de terrain, 84 participants, plan factoriel 3 × 2 × 2 sur 12 messages)
- Source : H. Kukka, J. Goncalves, T. Heikkinen et al., 2015, « Touch OK to continue: Error messages and affective response on interactive public displays », PerDis 2015, https://findanexpert.unimelb.edu.au/scholarlywork/1201944-touch-ok-to-continue--error-messages-and-affective-response-on-interactive-public-displays
- Extrait lu : « A total of 12 error messages that varied in tone, severity, and mode (3×2×2 factorial design) were designed, and data was gathered in a field trial with 84 participants. » ; « Results show that using friendly or neutral tones, and providing users with an active role, has … » (le résumé est tronqué à cet endroit)
- Portée / limites : résumé partiel seul lu, et la suite de la phrase de résultat manque. Le contexte est celui d'écrans publics interactifs. Les tailles d'effet ne sont pas connues.
- En rédaction : le message est-il neutre ou amical, sans reproche ? Laisse-t-il une action à l'utilisateur ?

### N'afficher une erreur qu'une fois l'erreur commise, et ne pas habiller en erreur une information neutre
- Niveau de preuve : N4
- Source : Kate Kaplan, 2022 (30 octobre), « Hostile Patterns in Error Messages », https://www.nngroup.com/articles/hostile-error-messages/
- Extrait lu : « Display error messages only after the error has been made. » ; « Let's assist users, not admonish them. »
- Portée / limites : l'article relève deux motifs, l'erreur prématurée (« Adresse e-mail invalide » dès la première lettre) et le style d'erreur appliqué à une information (« Aucune pièce jointe » sur fond d'alerte). Il ne traite ni le jargon ni l'humour.
- En rédaction : un état vide ou une remarque utile porte-t-il une icône d'alerte ou du rouge ? Le message apparaît-il avant que l'utilisateur ait fini de saisir ?

### Quand une correction est connue, la proposer
- Niveau de preuve : N1
- Source : W3C, WCAG 2.2, « Understanding SC 3.3.3 Error Suggestion (Level AA) », https://www.w3.org/WAI/WCAG22/Understanding/error-suggestion.html
- Extrait lu : « If an input error is automatically detected and suggestions for correction are known, then the suggestions are provided to the user, unless it would jeopardize the security or purpose of the content. »
- Portée / limites : niveau AA. L'exception de sécurité vise par exemple un mot de passe, où l'on ne dit pas quelle partie est fausse. Ce critère complète 3.3.1, couvert ailleurs, qui se limite à identifier l'erreur.
- En rédaction : le système connaît-il le format attendu sans l'écrire dans le message ?

---

## 3. États vides, onboarding, notifications

### Ne pas laisser un état vide muet : dire pourquoi c'est vide, à quoi sert l'espace, et donner l'action pour le remplir
- Niveau de preuve : N4
- Source : Kate Kaplan, 2021 (19 septembre), « Designing Empty States in Complex Applications: 3 Guidelines », https://www.nngroup.com/articles/empty-state-interface-design/
- Extrait lu : « Do not default to totally empty states. » ; titres des trois règles : « Use Empty States to Communicate System Status », « Use Empty States to Provide Learning Cues », « Use Empty States to Provide Direct Pathways for Key Tasks »
- Portée / limites : applications complexes. L'article oppose un « No records » ambigu, qui laisse croire à une absence de données même pendant le chargement, à « There are no records to display for the selected date range ». Apple converge (HIG « Writing ») : « guide people on actions they can take, and give them a button or link to do so if possible », et ajoute que les états vides étant temporaires, il ne faut pas y mettre d'information cruciale.
- En rédaction : « Aucun résultat » dit-il pour quels critères ? Le texte propose-t-il l'action, avec un bouton ?

### Préférer l'aide en contexte à un tutoriel d'accueil, et rendre « Passer » très visible si le tutoriel existe
- Niveau de preuve : N4
- Source : Alita Kendrick, 2020 (21 juin), « Mobile-App Onboarding: An Analysis of Components and Techniques », https://www.nngroup.com/articles/mobile-app-onboarding/
- Extrait lu : « avoid creating app onboarding whenever possible and instead spend your resources making the UI more usable » ; « we don't recommend deck-of-cards onboarding » ; « it's often more effective to train users by showing them tips in context. »
- Portée / limites : applications mobiles. L'onboarding reste justifié quand l'application a besoin d'informations sur l'utilisateur pour démarrer.
- En rédaction : ce texte d'accueil explique-t-il une interface qui devrait s'expliquer seule ? L'aide apparaît-elle au moment du geste ?

### Mettre l'essentiel dans le titre d'une notification (environ 30 caractères sous Android), ne pas y répéter le nom de l'application, ni redire le titre dans le corps
- Niveau de preuve : N3
- Source : Google, Android Developers, « Notifications » (guide de design), https://developer.android.com/design/ui/mobile/guides/home-screen/notifications
- Extrait lu : « Android truncates content titles to a single line (even when expanded). » ; « Doesn't exceed 30 characters » ; « Excludes the app's name, which already appears in the header » ; « Avoids exceeding the 40-character limit » ; « Avoids repeating what's in the content title »
- Portée / limites : les limites de caractères sont pensées pour l'anglais. Apple converge, sans chiffre (HIG « Notifications », modifiée le 24 octobre 2023, https://developer.apple.com/design/human-interface-guidelines/notifications, lue via le JSON) : « Avoid including your app name or icon » ; « don't truncate your message — the system does this automatically » ; « Use an alert — not a notification — to display an error message. » ; prévoir un texte générique (« New comment ») quand les aperçus sont masqués ; pas d'information personnelle ou sensible. Android exclut aussi les notifications sans valeur directe (« Haven't seen you in a while! »).
- En rédaction : si le titre est tronqué à 30 caractères, que reste-t-il ? Le nom de l'application y figure-t-il ? La notification révèle-t-elle une donnée privée sur l'écran verrouillé ?

---

## 4. Liens et noms accessibles

### Le but d'un lien doit se comprendre par son texte, ou par son texte et le contexte qui l'entoure (A), idéalement par le texte seul (AAA)
- Niveau de preuve : N1
- Source : W3C, WCAG 2.2, « Understanding SC 2.4.4 Link Purpose (In Context) », https://www.w3.org/WAI/WCAG22/Understanding/link-purpose-in-context.html, et « Understanding SC 2.4.9 Link Purpose (Link Only) », https://www.w3.org/WAI/WCAG22/Understanding/link-purpose-link-only.html
- Extrait lu : 2.4.4 (niveau A) : « The purpose of each link can be determined from the link text alone or from the link text together with its programmatically determined link context » ; 2.4.9 (niveau AAA) : « A mechanism is available to allow the purpose of each link to be identified from link text alone »
- Portée / limites : le contexte admis pour 2.4.4 est la même phrase, le même paragraphe, élément de liste ou cellule de tableau, ou une association ARIA. La page de 2.4.4 ne contient pas l'expression « click here ». NN/g converge (Kate Moran, 2019, « Better Link Labels: 4Ss for Encouraging Clicks », https://www.nngroup.com/articles/better-link-labels/) : « 'Learn more' is the new 'Click here' » ; « There is no maximum word count for links. » Google aussi (https://developers.google.com/style/link-text) : « Don't use phrases such as this document, this article, or click here. »
- En rédaction : la liste des liens de la page, lue hors contexte par un lecteur d'écran, contient-elle plusieurs « En savoir plus » identiques ?

### Titres et étiquettes doivent décrire le sujet ou le but, ce qui ne demande pas d'être long
- Niveau de preuve : N1
- Source : W3C, WCAG 2.2, « Understanding SC 2.4.6 Headings and Labels » (niveau AA), https://www.w3.org/WAI/WCAG22/Understanding/headings-and-labels.html
- Extrait lu : « Headings and labels describe topic or purpose. » ; « Labels and headings do not need to be lengthy. » ; « A word, or even a single character, may suffice »
- Portée / limites : le critère exige qu'une étiquette soit descriptive, il n'exige pas qu'elle existe. La brièveté y est permise, pas imposée.
- En rédaction : l'étiquette identifie-t-elle ce champ parmi les autres de l'écran ?

### Le nom accessible d'un contrôle doit contenir son texte visible, de préférence au début
- Niveau de preuve : N1
- Source : W3C, WCAG 2.2, « Understanding SC 2.5.3 Label in Name » (niveau A), https://www.w3.org/WAI/WCAG22/Understanding/label-in-name.html
- Extrait lu : « For user interface components with labels that include text or images of text, the name contains the text that is presented visually. » ; « A best practice is to have the text of the label at the start of the name. »
- Portée / limites : cela vise surtout la commande vocale (on dit ce qu'on voit). Un `aria-label` qui remplace le libellé visible par un autre texte viole ce critère.
- En rédaction : le bouton affiche « Envoyer » ; son `aria-label` commence-t-il par « Envoyer » ?

### Rédiger un nom accessible en partant de la fonction, en mettant le mot distinctif en tête, en 1 à 3 mots, sans le nom du rôle et sans point final
- Niveau de preuve : N3 (note du W3C, non normative)
- Source : W3C, WAI-ARIA Authoring Practices Guide, « Providing Accessible Names and Descriptions », https://www.w3.org/WAI/ARIA/apg/practices/names-and-descriptions/
- Extrait lu : « Convey function or purpose, not form. » ; « Put the most distinguishing and important words first. » ; « Be concise. For many elements, one to three words is sufficient. » ; « Do NOT include a WAI-ARIA role name in the accessible name. » ; « Do not end names with a period; they are not sentences. »
- Portée / limites : le guide recommande aussi de préférer le texte visible au nom posé par ARIA. Il avertit que sur un élément nommé par son contenu, `aria-label` masque ce contenu aux technologies d'assistance.
- En rédaction : le nom contient-il « bouton » ou « icône » ? Décrit-il la forme (« Loupe ») au lieu de la fonction (« Rechercher ») ?

### Choisir le texte alternatif d'une image selon sa fonction : vide si elle est décorative ou redondante, la destination ou l'action si elle est dans un lien ou un bouton, le sens sinon
- Niveau de preuve : N3 (tutoriel W3C WAI, mis à jour le 13 mai 2024)
- Source : W3C WAI, « An alt Decision Tree », https://www.w3.org/WAI/tutorials/images/decision-tree/
- Extrait lu : « Use the alt attribute to communicate the destination of the link or action taken. » ; « Use a brief description of the image in a way that conveys that meaning in the alt attribute. » ; pour un texte déjà présent à côté : « Use an empty alt attribute. »
- Portée / limites : l'arbre dit lui-même ne pas couvrir tous les cas et renvoie au tutoriel complet. Il sert à appliquer WCAG 1.1.1, il n'en est pas le texte normatif.
- En rédaction : le texte alternatif d'une icône-lien décrit-il le dessin (« Flèche ») au lieu de l'action (« Page suivante ») ? Une image décorative porte-t-elle un texte qui sera lu pour rien ?

### Rendre les messages de statut (résultats, progression, succès, erreurs) annonçables sans déplacer le focus, et les rédiger pour qu'ils se comprennent seuls
- Niveau de preuve : N1
- Source : W3C, WCAG 2.2, « Understanding SC 4.1.3 Status Messages » (niveau AA), https://www.w3.org/WAI/WCAG22/Understanding/status-messages.html
- Extrait lu : un message de statut « provides information to the user on the success or results of an action, on the waiting state of an application, on the progress of a process, or on the existence of errors. » ; exemples de la page : « 18 results returned », « 5 errors on page », « Your form was successfully submitted. »
- Portée / limites : le critère porte sur l'exposition technique (rôle ou propriétés), pas sur la rédaction. Ses exemples montrent toutefois des messages autonomes, chiffrés, compréhensibles sans voir l'écran.
- En rédaction : le message annoncé (« Terminé ») dit-il quoi, et combien (« 3 fichiers importés ») ?

---

## 5. Casse, majuscules et chiffres

### Écrire les libellés, titres et boutons en casse de phrase (majuscule au seul premier mot) et ne jamais employer les capitales pour insister
- Niveau de preuve : N3
- Source : Microsoft Writing Style Guide, « Capitalization » (ms.date 26.08.2024), https://learn.microsoft.com/en-us/style-guide/capitalization
- Extrait lu : « Microsoft style uses sentence-style capitalization. » ; « Capitalize the first word of a sentence, heading, title, UI label (such as the name of a button or checkbox), or standalone phrase. » ; « Don't use all uppercase for emphasis. »
- Portée / limites : convention, sans étude citée. Google converge (https://developers.google.com/style/capitalization) : « use sentence case » et « Don't use all-uppercase, except in the following contexts: in official names ». Apple diverge : title case pour les boutons et les titres d'alerte, avec un conseil de cohérence (« Choose a style for each UI element type and use it consistently », HIG « Writing »). Mailchimp et GOV.UK sont en casse de phrase pour les boutons.
- En rédaction : un libellé en capitales cherche-t-il à crier ? La casse est-elle la même pour tous les éléments d'un même type ?

### En français, la majuscule ne va qu'au premier mot d'un titre, ce qui rend le title case anglais hors norme
- Niveau de preuve : N3 (référence normative de l'Office québécois de la langue française)
- Source : OQLF, Banque de dépannage linguistique, « Majuscule aux titres d'œuvres et d'ouvrages », https://vitrinelinguistique.oqlf.gouv.qc.ca/21497/la-typographie/majuscules/emploi-de-la-majuscule-pour-des-types-de-denominations/majuscule-aux-titres-doeuvres-et-douvrages
- Extrait lu : « La règle générale consiste à mettre une majuscule seulement au premier mot du titre d'une œuvre ou d'un ouvrage » ; « Les sous-titres précédés d'un deux-points commencent par une minuscule »
- Portée / limites : la page porte sur les titres d'œuvres, pas sur l'interface. Aucune page de la BDL sur les libellés d'interface n'a été trouvée. Le service USAGov fait la même observation (2023) : « Title case is rarely used for languages besides English. »
- En rédaction : une chaîne traduite de l'anglais a-t-elle gardé ses majuscules (« Paramètres Du Compte ») ?

### Aucune étude ne tranche entre casse de phrase et title case ; la décision repose sur la cohérence, la longueur des titres et la traduction
- Niveau de preuve : N4 (retour d'expérience d'une institution, avec données d'usage)
- Source : USAGov content team, 2023 (5 septembre), « Making the case for sentence case on USAGov's websites », https://cms.usa.gov/blog/2023/09/making-the-case-for-sentence-case
- Extrait lu : « hoped to find a definitive answer to whether sentence case or title case is easier to read, but the opinions on that front appeared to be mixed » ; le passage à la casse de phrase « reduced the number of lines that titles and headings wrapped to for our mobile users » ; « almost 60% of page titles and 77% of our H2 level headings were longer than 30 characters »
- Portée / limites : environ 400 pages basculées, sans changement des notes de confiance dans les enquêtes (« no change in trustworthiness ratings »). Il ne s'agit pas d'une mesure de lisibilité. L'équipe note aussi que les capitales paraissent plus grandes, ce qui peut aider les lecteurs malvoyants.
- En rédaction : ne pas présenter la casse de phrase comme « plus lisible » : c'est un choix de cohérence.

### Ne pas tenir les capitales pour illisibles par principe : à petite taille, elles se lisent aussi bien, voire mieux ; c'est sur un texte long qu'il faut les éviter
- Niveau de preuve : N2 (petit échantillon : 9 participants au tableau 1, dont 4 malvoyants)
- Source : Aries Arditi et Jianna Cho, 2007, « Letter case and text legibility in normal and low vision », Vision Research 47(19), https://pmc.ncbi.nlm.nih.gov/articles/PMC2016788
- Extrait lu : « Reading speeds were higher for upper- than for mixed-case text at sizes twice acuity size; at larger sizes, the upper-case advantage disappeared. » ; « Results suggest that upper-case is more legible than the other case styles, especially for visually-impaired readers »
- Portée / limites : très petit échantillon, et les effectifs varient entre le tableau et les figures (n = 2 à 4 voyants). L'étude porte sur la lisibilité au seuil d'acuité, pas sur la lecture prolongée. Elle rapporte elle-même le résultat inverse de Tinker (lenteur des capitales en lecture longue, préférées par 10 % des lecteurs seulement). Pour un libellé court, rien ne prouve que les capitales nuisent ; pour un paragraphe, la convention reste de les éviter.
- En rédaction : un paragraphe entier est-il en capitales ? Si c'est un libellé de deux mots, la question relève du style et de la cohérence, pas de la lisibilité.

### Dans l'interface, écrire les nombres en chiffres (« 23 », pas « vingt-trois »), même en début de phrase, sauf les quantités vagues
- Niveau de preuve : N4 (avis d'expert appuyé sur des sessions d'eyetracking non détaillées)
- Source : Jakob Nielsen, 2007 (15 avril), « Show Numbers as Numerals When Writing for Online Readers », https://www.nngroup.com/articles/web-writing-show-numbers-as-numerals/
- Extrait lu : « Write numbers with digits, not letters (23, not twenty-three). » ; « Use numerals even when the number is the first word in a sentence or bullet point. » ; « numerals often stop the wandering eye and attract fixations » ; « Spell out numbers that don't represent specific facts. »
- Portée / limites : l'argument suppose un lecteur qui balaie la page ; l'article l'écarte lui-même pour les lecteurs peu lettrés. Mailchimp diverge sur le début de phrase : « Spell out a number when it begins a sentence. Otherwise, use the numeral. » (https://styleguide.mailchimp.com/grammar-and-mechanics/)
- En rédaction : un chiffre factuel est-il écrit en lettres ? Une unité rare (To, Mo) est-elle expliquée ?

---

## 6. Concision, troncature, ellipse, traduction

### Limiter la troncature, surtout quand la taille de police augmente, et garder les libellés d'onglet assez courts pour être lus d'un coup d'œil
- Niveau de preuve : N3
- Source : Apple, HIG « Typography » (modifiée le 16 décembre 2025), https://developer.apple.com/design/human-interface-guidelines/typography (via le JSON homonyme), et HIG « Tab bars », https://developer.apple.com/design/human-interface-guidelines/tab-bars
- Extrait lu : « Keep text truncation to a minimum as font size increases. » ; « Avoid truncating text in scrollable regions unless people can open a separate view to read the rest of the content. » ; « you need to keep tab labels short so people can read them at a glance. »
- Portée / limites : guideline de plateforme. Les règles Material de troncature n'ont pas pu être lues (page rendue en JavaScript).
- En rédaction : à la plus grande taille de texte du système, le libellé tient-il ? Sinon, que reste-t-il de lisible après la troncature ?

### Ne mettre de points de suspension sur un bouton ou un élément de menu que si l'action demande encore une saisie avant de s'exécuter
- Niveau de preuve : N3
- Source : Apple, HIG « Menus » (modifiée le 8 juin 2026), https://developer.apple.com/design/human-interface-guidelines/menus, et HIG « Buttons », https://developer.apple.com/design/human-interface-guidelines/buttons (via les JSON homonymes)
- Extrait lu : « Append an ellipsis to a menu item's label when the action requires more information before it can complete. » ; « Append a trailing ellipsis to the title when a push button opens another window, view, or app. »
- Portée / limites : convention macOS et iOS. Une ellipse sert aussi à un état en cours (« Checking out… », HIG « Buttons »). Ce n'est pas une ellipse de troncature.
- En rédaction : « Exporter… » ouvre-t-il bien un choix, ou exporte-t-il directement ?

### Prévoir l'allongement des chaînes courtes à la traduction (de 200 à 300 % pour une chaîne anglaise de 10 caractères ou moins) et laisser le texte se replier
- Niveau de preuve : N3 (article du W3C Internationalization, reprenant des chiffres d'IBM)
- Source : W3C Internationalization, « Text size in translation », https://www.w3.org/International/articles/article-text-size
- Extrait lu : ligne de tableau « Up to 10 » : « 200–300% » ; « Allow text to reflow and avoid small fixed-width containers or tight squeezes where possible. »
- Portée / limites : chiffres moyens d'IBM, de l'anglais vers les langues européennes. Ni l'auteur ni la date de la page n'ont été trouvés dans l'extrait lu. Pour un produit écrit d'abord en français, le facteur vers d'autres langues n'est pas donné.
- En rédaction : le bouton est-il dimensionné sur la chaîne la plus courte ?

---

## 7. Guides de style : convergences, et emoji

### Commencer une instruction ou un libellé par le verbe, couper les mots inutiles, et préférer « Envoyer » à un libellé « malin »
- Niveau de preuve : N3
- Source : Microsoft Writing Style Guide, « Top 10 tips for Microsoft style and voice » (ms.date 02.07.2026), https://learn.microsoft.com/en-us/style-guide/top-10-tips-style-voice
- Extrait lu : « Most of the time, start each statement with a verb. Edit out you can when it isn't necessary. » ; « Default to sentence-style capitalization » ; « Replace this: Invalid ID With this: You need an ID that looks like this: someone@example.com »
- Portée / limites : Apple converge (HIG « Writing ») : « When labeling buttons and links, it's almost always best to use a verb. » ; « just saying "Send" often works better than "Let's do it!" ». Mailchimp aussi : « Button copy should always include verbs. » (https://styleguide.mailchimp.com/web-elements/). Ce sont des conventions concordantes, pas des mesures.
- En rédaction : le libellé commence-t-il par un nom ou une formule (« C'est parti ! ») là où un verbe précis suffit ?

### Préférer la voix active et s'adresser au lecteur par « vous », mais admettre le passif quand l'auteur de l'action importe peu ou quand l'actif accuserait l'utilisateur
- Niveau de preuve : N3
- Source : Google developer documentation style guide, « Active voice », https://developers.google.com/style/voice, et « Second person », https://developers.google.com/style/person
- Extrait lu : « In general, use active voice » ; passif admis « To de-emphasize a subject or actor » et « If your readers don't need to know who's responsible for the action » ; « address the reader of your documents using the second person instead of the first person »
- Portée / limites : Google accepte « nous » quand il désigne l'organisation, avec un antécédent clair. Microsoft (guide des erreurs Windows, cité plus haut) demande le passif quand l'actif blâmerait. Mailchimp est plus strict : « Use active voice. Avoid passive voice. »
- En rédaction : la voix active met-elle l'utilisateur en faute ? Dans ce cas, le passif ou un sujet système (« Ce fichier ne peut pas… ») est préférable.

### Un emoji n'est pas compris de façon univoque : un tiers des lecteurs, ou presque, ne lui prête pas le même sentiment, et l'écart grandit d'une plateforme à l'autre
- Niveau de preuve : N2 (enquête en ligne, 304 participants retenus sur 334, recrutés sur Mechanical Turk aux États-Unis)
- Source : Hannah Miller, Jacob Thebault-Spieker, Shuo Chang, Isaac Johnson, Loren Terveen, Brent Hecht, 2016, « "Blissfully happy" or "ready to fight": Varying Interpretations of Emoji », ICWSM 2016, https://www.brenthecht.com/publications/ICWSM2016_emoji.pdf (PDF lu avec pdftotext)
- Extrait lu : « In cases in which participants rated the same emoji rendering, they disagreed on whether the sentiment was positive, neutral, or negative 25% of the time. When considering renderings across platforms, these disagreements only increase. »
- Portée / limites : l'étude porte sur des emoji isolés en messagerie, pas sur l'interface. L'échantillon est américain, choisi pour limiter les écarts culturels, ce qui veut dire qu'un public multilingue en aurait davantage.
- En rédaction : si l'emoji porte un sens (statut, avertissement), ce sens est-il aussi écrit en mots ?

### Si un emoji est autorisé, le placer en fin de phrase, un au plus, jamais à la place d'un mot, parce que le lecteur d'écran lit son nom
- Niveau de preuve : N3 (guideline de design conversationnel de Salesforce, version archivée de printemps 2021)
- Source : Salesforce Lightning Design System, « Conversation Design – Accessibility and Inclusion », http://spring-21.lightningdesignsystem.com/guidelines/conversation-design/accessibility-and-inclusion/
- Extrait lu : « By default screen readers read the emoji alt text option in line with other text. » ; « Place emoji at the end of phrases rather than the beginning, and before punctuation if used. » ; « Use one emoji max per bot message. »
- Portée / limites : la page vise les messages de bot, pas les libellés d'interface. La version actuelle de la page ne se rend qu'en JavaScript : seule l'archive a été lue. Mailchimp tolère l'emoji « infrequently and deliberately », mais proscrit le point d'exclamation dans les messages d'échec (« Never use exclamation points in failure messages or alerts »).
- En rédaction : un emoji en tête de message retarde-t-il l'information à l'écoute ? L'emoji sert-il de seul libellé à un bouton ?

---

## Verdict sur les règles du profil

**1. « Anatomie d'un message d'erreur : quoi → pourquoi (si utile) → comment réparer (toujours). Jamais le code technique seul ; le code peut figurer discrètement pour le support. »**
**Soutenue** (N3 convergent, preuve empirique N2 mitigée). Le guide d'erreurs de Windows décrit
exactement cette structure (« problem, cause, solution »), interdit le code seul (« Don't depend
just on the error code ») et range le code derrière « Show/Hide details ». NN/g 2023 (« show them
for technical diagnostic purposes only ») et Apple (pas de titre « Error 329347 occurred ») vont
dans le même sens, et WCAG 3.3.3 (N1) rend la suggestion de correction obligatoire quand elle est
connue. Deux nuances : (a) le « pourquoi » n'est pas toujours facultatif, puisque Windows demande
un message distinct par cause détectable ; (b) la preuve qu'une reformulation réduit les erreurs
est mitigée : Becker et al. 2016 constatent un effet, Pettit et al. 2017 aucun effet mesurable.
Proposition : ajouter « nommer la cause quand le système la connaît ».

**2. « Plain language / accessibilité : phrases courtes, voix active, sujet explicite. Les aria-label et messages de statut doivent être signifiants (pas "bouton", mais "Copier le lien d'invitation"). »**
- Phrases courtes : **convention sans preuve trouvée** pour un seuil chiffré. Le chiffre de
  « 14 mots = 90 % » n'a pas de source primaire retrouvée (voir Mythes).
- Voix active : **soutenue comme convention** (Google, Microsoft, Mailchimp, Apple), mais
  **partiellement contredite** dans les messages d'erreur : Microsoft demande le passif quand
  l'actif blâmerait l'utilisateur, et Google l'admet quand l'auteur de l'action importe peu.
  Proposition : « voix active, sauf quand elle accuse l'utilisateur ».
- Sujet explicite : soutenue indirectement. Apple déconseille le « we » ambigu (« Unable to load
  content » plutôt que « We're having trouble… »), mais Microsoft Windows recommande « we » :
  c'est un choix de voix à fixer par projet.
- aria-label et messages de statut signifiants : **soutenue** (N1 et N3). L'APG dit « Do NOT
  include a WAI-ARIA role name in the accessible name » et « Convey function or purpose, not
  form » ; WCAG 2.4.6 demande des étiquettes descriptives et 4.1.3 couvre les messages de statut.
  Il manque une précision : WCAG 2.5.3 (niveau A) exige que le nom accessible **contienne le
  texte visible**, de préférence au début, et l'APG conseille de préférer le texte visible à
  `aria-label`. À ajouter : « l'aria-label commence par le libellé visible ».

**3. « Concision : un label de bouton/onglet doit tenir. »**
**Soutenue** (N3). Les sources convergent : un ou deux mots chez Apple pour un bouton d'alerte,
« a couple short words » chez Windows, « one to three words » pour un nom accessible dans l'APG,
des libellés d'onglet lisibles d'un coup d'œil chez Apple, 30 et 40 caractères pour les
notifications Android. Deux limites : la clarté prime sur la brièveté (GOV.UK : « You may need to
include more or different words », NN/g : « no maximum word count for links »), et « tenir » doit
s'apprécier après traduction (200 à 300 % d'allongement pour les chaînes de 10 caractères ou
moins, W3C i18n) et à grande taille de police (Apple).

**4. « Pas d'emoji dans l'UI sauf autorisation projet. »**
**Convention sans preuve trouvée** pour l'interface elle-même. Aucun des guides lus n'interdit
l'emoji : Mailchimp le tolère avec parcimonie, Salesforce le limite à un par message et en fin de
phrase. La règle reste défendable par des preuves indirectes : 25 % de désaccord sur le sentiment
d'un même rendu, davantage d'une plateforme à l'autre (Miller et al. 2016, N2), et lecture du nom
de l'emoji par les lecteurs d'écran (Salesforce). Elle est plus stricte que les sources, pas
contredite. Proposition : « jamais un emoji porteur de sens sans le même sens écrit en mots ».

**5. « Jargon technique jamais exposé ; pas de "Oops/Erreur" brut. »**
**Soutenue** (N3 et N4). Jargon : NN/g 2023 (« Avoid technical jargon »), Windows (« Avoid
technical jargon », « Avoid vague wording, such as syntax error »), Microsoft (« Invalid ID » à
remplacer). « Erreur » brut : Apple, « Avoid writing a title that doesn't convey useful
information — like "Error" ». « Oops » : Apple le juge « typically unnecessary » et pouvant
« sound insincere » ; il n'est pas interdit, et aucune étude lue ne le teste isolément.
Kukka et al. 2015 (N2, 84 participants, résumé partiel) vont dans le sens d'un ton amical ou
neutre. La règle est soutenue ; la nuance est que « Oops » est surtout à proscrire là où l'erreur
est grave, parce qu'Apple demande de ne pas masquer la gravité.

---

## Mythes et affirmations contestées

- **« Phrases de 8 mots = 100 % de compréhension, 14 mots = 90 %, 43 mots = moins de 10 % »**,
  attribué à l'American Press Institute. La page de Wylie Communications
  (https://www.wyliecomm.com/how-long-should-a-sentence-be/) reprend les chiffres en citant
  « research by the American Press Institute » portant sur « 410 newspapers », sans date, auteur
  ni référence. Aucune source primaire retrouvée ; les pages PRSA qui en discutaient renvoient une
  erreur 404. **À ne pas citer comme résultat.**
- **« Les capitales sont illisibles », ou l'argument de la « forme du mot » (bouma).** Kevin
  Larson (Microsoft, « The Science of Word Recognition », https://learn.microsoft.com/en-us/typography/develop/word-recognition)
  rapporte que les minuscules se lisent plus vite de 5 à 10 % (Smith 1969, Fisher 1975), mais
  attribue cet écart à l'entraînement (« This is entirely a practice effect ») et conclut :
  « Word shape is no longer a viable model of word recognition. » Arditi et Cho 2007 trouvent un
  avantage aux capitales à petite taille. Les chiffres plus élevés qui circulent (par exemple
  « 13 à 20 % plus lent ») n'ont pas été retrouvés dans une source primaire. Les capitales restent
  à éviter pour l'emphase et le texte long : c'est une convention, avec un effet modeste.
- **Le « bouton à 300 millions de dollars ».** Jared Spool, 2009
  (https://articles.centercentre.com/three_hund_million_button/) : client anonyme, aucune méthode
  ni période de référence, preuve tirée d'un message vocal du PDG. Surtout, ce qui a changé est le
  **parcours** (achat sans création de compte) et pas seulement le libellé (« Register » devenu
  « Continue »). Ce n'est pas une preuve de l'effet d'un libellé.
- **« Le title case est plus lisible » (ou l'inverse).** Aucune étude trouvée. USAGov 2023 : avis
  « mixed ». Le choix relève de la plateforme et de la langue.
- **« Réécrire les messages d'erreur réduit toujours les erreurs ».** Le résultat est contesté :
  Becker et al. 2016 constatent un effet (environ 200 étudiants), Pettit et al. 2017 aucun effet
  mesurable.
- **« Ne jamais s'excuser ».** Les sources divergent : GOV.UK (couvert ailleurs) proscrit
  « sorry » ; Microsoft le réserve aux problèmes graves ; la règle 14 de Seckler et al. 2014
  admet l'excuse. Une convention défendable : pas d'excuse pour une erreur courante de saisie, une
  excuse sobre quand le système a causé une perte.
- **« Nous » dans l'interface.** Apple : « Avoid using we altogether » ; Microsoft Windows : « Use
  "we" to refer to your own perspective » ; Google : acceptable avec un antécédent clair. Aucune
  preuve trouvée : à trancher par projet.
- **Chiffres en début de phrase.** NN/g les veut en chiffres, Mailchimp en lettres. C'est une
  convention.
- **« Les pages NN/g sont de la recherche ».** Les articles lus ici ne publient ni protocole ni
  échantillon. Ils sont classés N4, même quand ils s'appuient sur des tests utilisateurs.

---

## Non vérifié

- **Shneiderman 1982, « Designing computer system messages »** (Communications of the ACM, 1982,
  DOI 10.1145/358628.358639). Seules les métadonnées sont lues (API Semantic Scholar : titre,
  auteur, revue, année ; le résumé y est masqué). Le texte intégral renvoie une erreur 403 chez
  l'ACM. La page de l'université du Maryland (lccd.umiacs.umd.edu) n'est pas joignable depuis
  cette session : l'hôte n'est pas autorisé par le réseau de la session et doit l'être pour qu'on
  la lise. Les affirmations souvent attribuées à Shneiderman (spécificité, ton positif et clarté
  qui améliorent le taux de correction ; études sur des erreurs COBOL) n'ont été vues que dans des
  extraits de recherche : **non vérifié**.
- **Becker et al. 2019** (groupe de travail ITiCSE, « Compiler Error Messages Considered
  Unhelpful ») : seuls la page compagnon et un compte rendu de Greg Wilson (2021) ont été lus,
  pas la liste des recommandations ni leur niveau de preuve.
- **Kukka et al. 2015** : la fin du résumé, et donc la phrase de résultat complète, n'a pas été
  lue.
- **Études de Park et al. sur les messages d'erreur avec excuse** : vues seulement dans des
  extraits de recherche.
- **Material Design 3** (dialogues, boutons, casse de phrase, troncature) : pages rendues en
  JavaScript, illisibles. Seul Material 1 (archivé) a été lu.
- **Microsoft Writing Style Guide** : la page « emoji » renvoie une erreur 404, et aucune page
  dédiée aux messages d'erreur n'a été trouvée. Le guide des erreurs Windows 7 et la page
  « Writing style » des applications Windows ont servi à la place.
- **Seuils de longueur de phrase de GOV.UK et du Style Manual australien** (25 mots au plus,
  15 en moyenne) : vus dans des extraits de recherche. Les pages renvoient une erreur 404 ou 503.
- **Tests A/B sur les libellés de bouton** (« mon » contre « votre », etc.) : aucun n'a été
  ouvert, aucun n'est retenu.
- **Tinker et Paterson** (années 1920-1950) sur les capitales : connus seulement par la citation
  qu'en font Arditi et Cho (2007).

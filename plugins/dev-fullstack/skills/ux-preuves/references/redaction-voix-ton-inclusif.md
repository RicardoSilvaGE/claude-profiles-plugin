# Fiche `ux-preuves` — Rédaction — voix, ton, adresse et langage inclusif

> Fiche du skill `ux-preuves` (dev-fullstack), volet **rédaction**, préchargé par `redacteur`. Couvre : ton de voix mesuré, humour et excuses, tu/vous, du/Sie, tú/usted, « mon » ou « votre », « je » de la machine et persona, langage inclusif par langue et par pays (France, Suisse, Québec, anglais) avec les positions officielles datées, confirmshaming.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Verdict sur les règles
> du profil » (ou « Ce que le profil devrait dire »), « Mythes » et « Non vérifié » sont opposables
> autant que les entrées : ce qui y figure ne se cite pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Référentiel de l'agent « rédacteur UX et linguiste produit senior » (FR d'abord ; EN, ES, DE, IT).
> Recherche menée le 9 novembre 2026. Chaque entrée vient d'une page ouverte ce jour (WebFetch, ou
> téléchargement puis extraction `pdftotext` / texte HTML). Quand seul un résumé a été lu, c'est
> écrit. Les positions officielles sont datées : elles changent. Sur le langage inclusif, ce document
> rapporte les positions des sources sans prendre parti, et distingue ce qui **oblige** (textes
> officiels, pour leur périmètre) de ce qui est **recommandé**.
>
> Niveaux : N1 norme / réglementation · N2 recherche revue par pairs ou étude empirique à large
> échantillon · N3 guideline officielle d'institution ou de plateforme · N4 avis d'expert, praticien.
> « N2 (réservé) » = étude empirique qui ne remplit pas toutes les conditions de N2 (mémoire non
> revu par pairs, ou petit échantillon) : la réserve est explicitée dans « Portée / limites ».

---

## 1. Ton de voix : le mesurer et le moduler

### Décrire le ton sur quatre axes, puis le faire varier selon la situation du lecteur, sans changer la voix
- Niveau de preuve : N4 (NN/g) + N3 (Apple)
- Source : Kate Moran (Nielsen Norman Group), 2016 (revu le 16.08.2023), « The Four Dimensions of Tone of Voice », https://www.nngroup.com/articles/tone-of-voice-dimensions/ ; Apple, Human Interface Guidelines, « Writing » (journal des modifications : page créée le 27.02.2023, mise à jour le 16.12.2025), https://developer.apple.com/design/human-interface-guidelines/writing (lu via https://developer.apple.com/tutorials/data/design/human-interface-guidelines/writing.json)
- Extrait lu : NN/g — « Formal vs. casual », « Serious vs. funny », « Respectful vs. irreverent », « Matter-of-fact vs. enthusiastic ». Apple — « Once you’ve established your app’s voice, vary your tone based on the situation. »
- Portée / limites : grille descriptive, pas une preuve d'efficacité. NN/g illustre les quatre axes sur un même message d'erreur (« We apologize, but we are experiencing a problem. » → « Oops! We’re sorry… »), ce qui montre que l'axe « enthousiaste » se joue aussi sur une erreur.
- En rédaction : la charte de voix nomme-t-elle la position sur chacun des quatre axes ? Le texte examiné garde-t-il la voix tout en ajustant le ton à l'état du lecteur (réussite, paiement refusé, perte de données) ?

### Viser la confiance avant la sympathie : un ton décontracté aide, un ton ludique peut coûter la crédibilité dans un domaine sérieux
- Niveau de preuve : N2 (réservé)
- Source : Kate Moran (Nielsen Norman Group), 2016 (revu le 30.01.2024), « The Impact of Tone of Voice on Users' Brand Perception », https://www.nngroup.com/articles/tone-voice-users/
- Extrait lu : « Casual, conversational, and enthusiastic tones performed best. » ; « trustworthiness is a much stronger predictor of desirability, across all the industries. » ; sur l'assurance au ton ludique : « respondents were no more likely to recommend Alpha, and actually rated Beta as more trustworthy than Alpha by 0.3 points. »
- Portée / limites : enquête en ligne auprès de 100 adultes américains (+ contrôle de manipulation, n = 50), quatre paires de pages fictives (assurance, banque, sécurité, hôpital), échelles de Likert à 5 points ; la confiance explique ~52 % de la variance de la recommandation, la sympathie ~8 % de plus. Étude de cabinet, non revue par pairs, anglais seulement, écarts de 0,3 à 0,7 point. Le texte précise aussi : « do you really think they want that error message to be a joke? ».
- En rédaction : sur un parcours d'argent, de santé ou de sécurité, le registre ludique fait-il perdre en crédibilité ce qu'il gagne en sympathie ? Le texte serait-il cru sans son trait d'esprit ?

---

## 2. Humour, interjections et excuses

### Ne pas mettre d'humour dans un message d'erreur ; ailleurs, seulement s'il vient naturellement, et la clarté passe d'abord
- Niveau de preuve : N4 (NN/g) + N3 (guide de marque Mailchimp)
- Source : Tim Neusesser et Evan Sunwall (NN/g), 14.05.2023, « Error-Message Guidelines », https://www.nngroup.com/articles/error-message-guidelines/ ; Mailchimp, « Voice and Tone », Content Style Guide (non daté), https://styleguide.mailchimp.com/voice-and-tone/
- Extrait lu : NN/g — « Avoid humor since it can become stale if users encounter the error frequently. » Mailchimp — « it’s always more important to be clear than entertaining » ; « forced humor can be worse than none at all. If you’re unsure, keep a straight face. »
- Portée / limites : avis d'experts et guide d'une marque dont la voix assume l'humour (« Our humor is dry »). Aucun des deux ne cite d'étude contrôlée. Le motif NN/g (l'usure par répétition) est un argument, pas une mesure.
- En rédaction : le message sera-t-il revu dix fois par la même personne ? Si oui, la plaisanterie tient-elle à la dixième ? Retirer le trait d'esprit fait-il perdre une information ?

### Bannir « Oops » et les mots qui accusent ; dire ce qui se passe et comment le corriger
- Niveau de preuve : N3
- Source : GOV.UK Design System, « Error message » (page consultée le 09.11.2026), https://design-system.service.gov.uk/components/error-message/ ; Apple, HIG « Writing », https://developer.apple.com/design/human-interface-guidelines/writing
- Extrait lu : GOV.UK, à ne pas utiliser — « words like ‘forbidden’, ‘illegal’, ‘you forgot’ and ‘prohibited’ », « ‘please’ because it implies a choice », « ‘sorry’ because it does not help fix the problem », « humourous, informal language like ‘oops’ ». Apple — « Interjections like “oops!” or “uh-oh” are typically unnecessary and can sound insincere. »
- Portée / limites : GOV.UK vise les messages d'erreur de validation d'un service public ; Apple, toute app sur ses plateformes. NN/g (2023, ci-dessus) ajoute : « Don't use phrasing that blames users or implies they are doing something wrong, such as invalid, illegal, or incorrect. » Pas d'étude d'effet citée.
- En rédaction : chercher « Oups », « Oops », « Aïe », « Vous avez oublié », « invalide », « interdit », « illégal ». Le message dit-il quoi faire, dans les mots de la personne ?

### Réserver les excuses aux fautes du système qui ont un vrai coût pour la personne
- Niveau de preuve : N3
- Source : Microsoft Writing Style Guide, « sorry », https://learn.microsoft.com/en-us/style-guide/a-z-word-list-term-collections/s/sorry ; GOV.UK Design System, « There is a problem with the service pages », https://design-system.service.gov.uk/patterns/problem-with-the-service-pages/
- Extrait lu : Microsoft — « Use sorry (and similar wording) only in error messages that notify the customer about a serious problem or one that they might find very frustrating » ; « Don't apologize for problems that are outside the product ». GOV.UK — « ‘Sorry, there is a problem with the service’ as the H1 ».
- Portée / limites : GOV.UK interdit « sorry » dans l'erreur de saisie (motif : n'aide pas à corriger) mais l'impose en titre quand le service lui-même tombe. Microsoft cite comme cas : données perdues, appareil ou service inutilisable, recours au support. Ce sont des conventions, pas des mesures.
- En rédaction : qui est en faute, le système ou la saisie ? Une excuse sur une erreur de saisie est du bruit ; une panne sans excuse sonne sèche. L'excuse est-elle suivie de ce qui a été préservé (« We saved your answers ») et de la suite ?

### Des excuses du système améliorent l'expérience vécue, sans changer le jugement sur ses performances
- Niveau de preuve : N2 (résumé seul lu)
- Source : Jeng-Yi Tzeng, 2004, « Toward a more civilized design: studying the effects of computers that apologize », International Journal of Human-Computer Studies 61(3), 319-345 (DOI 10.1016/j.ijhcs.2004.01.002, métadonnées vérifiées sur https://api.crossref.org/works/10.1016/j.ijhcs.2004.01.002) ; résumé lu tel que cité le 17.08.2004 sur https://lists.gnome.org/archives/usability/2004-August/msg00085.html
- Extrait lu : « while the computers' actual performances still dominated the users' assessments of the program, the computer apologies help to create more desirable psychological experiences for the users »
- Portée / limites : 269 lycéens, jeu de devinettes, plan 2×2×2 (difficulté, excuses ou non, émoticônes ou non). Population scolaire, contexte ludique, étude de 2004. Article complet non lu : tailles d'effet non vérifiées.
- En rédaction : l'excuse ne remplace pas la réparation (la performance domine le jugement) ; elle accompagne un défaut réel du système.

### Dans une panne d'assistant vocal, préférer une réponse neutre à une réponse drôle
- Niveau de preuve : N2 (réservé)
- Source : Mikkel Clausen et Mikkel Peter Kyhn (Aalborg University), 17.06.2022, « "Alexa, Stop Playing" — A study in humorous voice user interfaces, during communication breakdowns », mémoire de master, https://projekter.aau.dk/projekter/files/474692605/P10___Kyhn___Clausen.pdf
- Extrait lu : « participants had a clear preference for non-humorous responses from the VUI during communication breakdown » ; « participants were more satisfied and perceived the Neutral VUI personality as more intelligent than a VUI with an Aggressive or Self-Defeating humor personality. »
- Portée / limites : magicien d'Oz, 30 participants, cinq personnalités (quatre humoristiques, une neutre). Mémoire non revu par pairs ; les auteurs appellent eux-mêmes à une réplication. Interface vocale, pas écran.
- En rédaction : quand l'outil a échoué, l'humour (surtout l'autodérision ou la moquerie) fait-il paraître le système moins compétent ?

### Humour d'un chatbot après un échec : résultats contradictoires, ne pas en faire une règle
- Niveau de preuve : N2 (résumés seuls lus)
- Source : Yuguang Xie, Changyong Liang, Peiyu Zhou, Li Jiang, 2024, « Exploring the influence mechanism of chatbot-expressed humor on service satisfaction in online customer service », Journal of Retailing and Consumer Services 76, https://ideas.repec.org/a/eee/joreco/v76y2024ics0969698923003508.html ; Min Jeong Seo, 2024, « Comparing the Effects of Courteous vs. Humorous Apologies for Chatbot Service Recovery », Journal of the Korean Society of Clothing and Textiles 48(2), 254-268, https://koreascience.or.kr/article/JAKO202412976201191.pdf
- Extrait lu : Xie et al. — « chatbot-expressed humor can significantly enhance customer service satisfaction » ; « identity disclosure exerts a negative moderating influence ». Seo — « in comparison to the humorous apology, the courteous apology had a higher positive predictive effect on perceived sincerity ».
- Portée / limites : Xie et al. : deux expériences en ligne et une en laboratoire, effectifs non lus (article payant). Seo : expérience en ligne, n = 71 (excuse courtoise) et n = 67 (excuse humoristique), contexte coréen. L'effet positif de l'humour chez Xie et al. baisse quand l'identité de chatbot est révélée, or la révélation devient obligatoire dans l'UE (voir § 4).
- En rédaction : l'humour en réparation n'est pas « prouvé » dans un sens ou dans l'autre ; s'il est retenu, le tester. Une excuse humoristique paraît-elle sincère ?

---

## 3. Adresse au lecteur

### S'adresser à la personne en « vous » / « you » ; réserver « mon » / « je » aux libellés où la personne agit ; un seul point de vue par produit
- Niveau de preuve : N3
- Source : Microsoft Writing Style Guide, « Person », https://learn.microsoft.com/en-us/style-guide/grammar/person ; Apple HIG « Writing » (ajout sur les possessifs le 16.12.2025), https://developer.apple.com/design/human-interface-guidelines/writing ; Microsoft, German Style Guide (localisation), https://aka.ms/german-styleguide
- Extrait lu : Microsoft — « In general, use second-person pronouns (you, your) » ; « First-person singular pronouns can be used in product UI to show someone’s control over an action in checkbox, button, or toggle labels. » Apple — « “Favorites” conveys the same message as “Your Favorites,” and is more succinct. If you do use possessive pronouns, use them consistently throughout your app, and try not to switch perspectives. » Microsoft (allemand) — « For German products, the guideline is to leave out the possessive pronoun. »
- Portée / limites : conventions de plateforme. Apple déconseille aussi « we » (« Avoid using we altogether because it may be unclear who the “we” in question refers to ») ; Microsoft l'admet dans « we recommend ». Aucune étude contrôlée « Mon compte » / « Votre compte » trouvée (voir « Non vérifié »). Un article de praticien (Smart Interface Design Patterns, 07.04.2025, https://smart-interface-design-patterns.com/articles/your-vs-my/) propose la même règle (« Never mix different pronouns ») sans citer de recherche.
- En rédaction : « Mon compte » et « Votre profil » coexistent-ils dans la même interface ? Le possessif apporte-t-il quelque chose, ou « Compte » suffit-il ? Le « nous » du message d'erreur désigne-t-il quelqu'un d'identifiable ?

### Tu ou vous en français : le choix dépend de l'aire francophone ; dans le doute, vous
- Niveau de preuve : N3
- Source : Office québécois de la langue française, Banque de dépannage linguistique, « Contextes d’emploi du vouvoiement et du tutoiement » (dernière mise à jour : 2015), https://vitrinelinguistique.oqlf.gouv.qc.ca/25140/la-redaction-et-la-communication/protocole-et-activites-publiques/contextes-demploi-du-vouvoiement-et-du-tutoiement
- Extrait lu : « Dans certaines aires francophones, au Québec notamment, dire tu dès la première rencontre est beaucoup plus fréquent que dans d’autres, où le tutoiement spontané peut être ressenti comme une familiarité déplacée. Il faut être sensible à cet état de fait. » ; « il est plus prudent d’utiliser le vous jusqu’au moment où la question est abordée ».
- Portée / limites : fiche sur la communication interpersonnelle, pas sur les produits numériques. Aucune étude ni directive officielle sur tu/vous dans les interfaces francophones n'a été trouvée (voir « Non vérifié »).
- En rédaction : le public est-il québécois, français, suisse, belge ? Jeune ou mixte ? Le tutoiement est-il un choix de marque assumé et cohérent partout, y compris dans les CGU et les messages de recouvrement ?

### Suivre le registre attendu par langue et par public : vous en français, Sie pour les adultes en allemand, tú en espagnol (chez Microsoft)
- Niveau de preuve : N3
- Source : Microsoft, French Style Guide (fr-FR, © 2021), https://download.microsoft.com/download/c/7/9/c7921dbd-4531-4a4e-8490-e4656d739f3d/fra-fra-StyleGuide.pdf ; German Style Guide, https://aka.ms/german-styleguide ; Spanish (Spain) Style Guide, https://aka.ms/spanish-spain-styleguide ; Spanish (Mexico) Style Guide, https://aka.ms/spanish-mexico-styleguide
- Extrait lu : français — « The second-person pronoun "vous" and direct, natural language clearly tell the user about the product key. » Allemand — « For German, when addressing children/teens under age of 18, use the informal “du”. » (les exemples adultes sont en « Sie »). Espagnol — « For Spanish Microsoft voice, the informal second person singular pronoun “tú” is recommended. » ; pour l'Espagne, le pluriel est « “vosotros” and not "ustedes" ».
- Portée / limites : convention d'un seul éditeur, pour sa voix « warm and relaxed ». Montre que la même voix chaleureuse se rend par « vous » en français et « Sie » en allemand : chaleur et tutoiement ne sont pas synonymes.
- En rédaction : le tutoiement imposé par la source anglaise ou par la marque est-il transposé tel quel dans une langue où le registre par défaut est formel ? Le public compte-t-il des mineurs (du) ?

### En allemand, passer au « du » n'améliore pas la perception en moyenne ; le « Sie » ressort mieux dans les sous-groupes où un écart apparaît
- Niveau de preuve : N2 (résumé seul lu)
- Source : Heinz L. Kretzenbacher et Susanne Hensel-Börner, 2024, « Pronominal Address in German Sales Talk: Effects on the Perception of the Salesperson », Languages 9(10), 316 (MDPI) ; résumé lu via l'API DOAJ, https://doaj.org/api/search/articles/title%3A%22Pronominal%20Address%20in%20German%20Sales%20Talk%22 (page éditeur https://www.mdpi.com/2226-471X/9/10/316 refusée, 403)
- Extrait lu : « The overwhelming majority of the significant differences in the perceptions of the salesperson according to the address pronoun used shows that the salesperson using Sie is seen in a more positive light. » ; « addressing customers with du does not have the general effect of improving the perception of the salesperson. »
- Portée / limites : vidéos de vente (secteurs différents), questionnaire ; pas d'effet sur l'ensemble, différences selon le genre, l'âge, la formation et le secteur. Effectif non lu. Vendeur filmé, pas une interface écrite.
- En rédaction : en allemand (y compris en Suisse alémanique, non testée spécifiquement), le « du » se justifie-t-il par le public et le secteur, ou par imitation d'une marque ?

### Ne pas tutoyer pour répondre à une plainte
- Niveau de preuve : N2 (réservé)
- Source : Alea Sophie Küppers, 22.01.2018, « “You can say ‘you’ to me!” The cross-cultural effects of formal and informal pronominal addressing in webcare conversations », mémoire de master, Tilburg University, https://arno.uvt.nl/show.cgi?fid=146041
- Extrait lu : « using informal second-person pronouns does not increase the likeability of the brand » ; « informal pronominal can be harmful for the likeability of the brand when responding to a complaint. We did not find any significant differences between Dutch and German consumers. »
- Portée / limites : expérience 2×2×2 inter-sujets, N = 352, consommateurs allemands et néerlandais, réponses de marque sur Facebook. Mémoire non revu par pairs.
- En rédaction : l'écran de litige, de remboursement ou de réclamation garde-t-il le registre familier du marketing ? Le passage au registre formel y est-il prévu ?

### En espagnol, le registre varie par pays et par type de texte : tuteo / voseo pour vendre, ustedeo pour les conditions
- Niveau de preuve : N2
- Source : Ilpo Kempas, 2019, « La elección de las formas de tratamiento en las páginas de tiendas online: Un recorrido por el mundo hispano », BeLLS 10(1), DOI 10.15845/bells.v10i1.1339, https://bells.uib.no/index.php/bells/article/download/1339/2883
- Extrait lu : « el tratamiento informal es exclusivo en las tiendas argentinas y chilenas, así como en las ecuatorianas, colombianas, hondureñas, salvadoreñas y mexicanas » ; « el ustedeo es común al especificar los términos de venta ».
- Portée / limites : corpus de pages de boutiques en ligne (recherches Google) dans 21 pays hispanophones ; décrit l'usage, ne mesure pas d'effet. L'article note que « usted » peut aussi être familier dans certaines variétés.
- En rédaction : le marché cible est-il l'Espagne (tú / vosotros), l'Argentine (vos), le Mexique (tú / ustedes) ? Les CGU et mentions légales passent-elles à « usted » quand le reste tutoie ?

---

## 4. Anthropomorphisme, « je » de la machine et persona

### Dire à la personne qu'elle échange avec une IA, sauf si c'est évident (obligation UE)
- Niveau de preuve : N1
- Source : Règlement (UE) 2024/1689 (AI Act), art. 50(1), applicable le 2 août 2026 selon l'art. 113 ; texte lu sur https://artificialintelligenceact.eu/article/50/ et https://artificialintelligenceact.eu/article/113/
- Extrait lu : « Providers shall ensure that AI systems intended to interact directly with natural persons are designed and developed in such a way that the natural persons concerned are informed that they are interacting with an AI system […] unless this is obvious from the point of view of a natural person who is reasonably well-informed, observant and circumspect »
- Portée / limites : vise les fournisseurs dont le système est mis sur le marché ou utilisé dans l'UE ; la Suisse n'est pas membre, mais un produit suisse proposé dans l'UE est concerné (champ d'application non analysé ici). Le site consulté signale des modifications « Digital Omnibus » sur d'autres articles ; l'alinéa 50(1) cité apparaît inchangé (non vérifié sur le Journal officiel).
- En rédaction : la persona, son prénom ou son « je » laissent-ils croire à un humain ? La mention « assistant IA » est-elle visible dès la première réponse ?

### Le « je » d'un assistant augmente la confiance accordée à ce qu'il dit : l'employer en le sachant
- Niveau de preuve : N2
- Source : Michelle Cohn, Mahima Pushkarna, Gbolahan O. Olanubi, Joseph M. Moran, Daniel Padgett, Zion Mengesha, Courtney Heldreth, 2024, « Believing Anthropomorphism: Examining the Role of Anthropomorphic Cues on Trust in Large Language Models », arXiv:2405.06079, http://arxiv.org/abs/2405.06079 (résumé seul lu)
- Extrait lu : « the "speech + text" condition led to higher anthropomorphism of the system overall, as well as higher ratings of accuracy of the information the system provides. Additionally, the first-person pronoun ("I") led to higher information accuracy and reduced risk ratings, but only in one context. »
- Portée / limites : n = 2 165 adultes américains (18-90 ans), pseudo-LLM, « I » vs « the system ». Effet du « je » limité à un contexte. Lieu de publication non vérifié (prépublication lue).
- En rédaction : le « je » rend-il plus crédible une réponse qui ne le mérite pas ? Sur un sujet à risque (santé, argent, droit), préférer une formulation qui ne surjoue pas la compétence.

### Exprimer l'incertitude en première personne (« Je ne suis pas sûr, mais… ») réduit la sur-confiance
- Niveau de preuve : N2
- Source : Sunnie S. Y. Kim, Q. Vera Liao, Mihaela Vorvoreanu, Stephanie Ballard, Jennifer Wortman Vaughan, 2024, « "I'm Not Sure, But...": Examining the Impact of Large Language Models' Uncertainty Expression on User Reliance and Trust », FAccT 2024, arXiv:2405.00623, http://arxiv.org/abs/2405.00623 (résumé seul lu)
- Extrait lu : « first-person expressions (e.g., "I'm not sure, but...") decrease participants' confidence in the system and tendency to agree with the system's answers, while increasing participants' accuracy. » ; « While we observe similar effects for uncertainty expressed from a general perspective (e.g., "It's not clear, but..."), these effects are weaker and not statistically significant. »
- Portée / limites : expérience préenregistrée, N = 404, questions médicales, moteur de recherche fictif à LLM. Anglais seulement. La sur-confiance baisse « but not fully eliminated ».
- En rédaction : quand la réponse est incertaine, le texte le dit-il, et en première personne ? « Il semble que » est plus faible que « Je ne suis pas sûr ».

### Concevoir une persona pour rendre la conversation familière, jamais pour faire croire à un humain
- Niveau de preuve : N3
- Source : Google, Conversation Design, « Create a persona » (documentation des Conversational Actions, retirées le 13.06.2023, page toujours en ligne), https://developers.google.com/assistant/conversation-design/create-a-persona
- Extrait lu : « Users will project a persona onto your Action whether you plan for one or not. » ; « The goal of creating a persona is not to trick the user into thinking they're talking to a human being, but simply to leverage the communication system users learned first and know best: conversation. »
- Portée / limites : guide d'un produit retiré ; reste une référence de méthode. Exemple donné : une persona bancaire inspirée d'un guichetier « trustworthy with customers’ money ».
- En rédaction : la persona est-elle définie (on peut répondre à « que dirait-elle ici ? ») ? Ses formulations « humaines » (émotions, souvenirs, « je comprends ce que vous ressentez ») dépassent-elles ce que le système fait réellement ?

---

## 5. Langage inclusif et épicène, par langue et par pays

### France, État : féminiser les fonctions, écrire « le candidat ou la candidate », ne pas employer l'écriture dite inclusive au Journal officiel
- Niveau de preuve : N1 (pour les administrations de l'État)
- Source : Premier ministre, circulaire du 21 novembre 2017 relative aux règles de féminisation et de rédaction des textes publiés au Journal officiel de la République française (JORF du 22.11.2017) ; copie lue : https://www.cfdt-ufetam.org/wp-content/uploads/2018/01/cir_pm_21-11-17_feminisation_textes-1.pdf (Légifrance n'a pas renvoyé le texte)
- Extrait lu : « je vous demande de systématiquement recourir, dans les actes de recrutement et les avis de vacances publiés au Journal officiel, à des formules telles que « le candidat ou la candidate » » ; « je vous invite, en particulier pour les textes destinés à être publiés au Journal officiel de la République française, à ne pas faire usage de l’écriture dite inclusive, qui désigne les pratiques rédactionnelles et typographiques visant à substituer à l’emploi du masculin, lorsqu’il est utilisé dans un sens générique, une graphie faisant ressortir l’existence d’une forme féminine. »
- Portée / limites : instruction aux administrations de l'État ; selon une analyse juridique (Landot avocats, 27.05.2025, https://blog.landot-avocats.net/2025/05/27/ecriture-inclusive-un-etat-des-lieux-juridique-en-droit-public-en-2025-video-et-article/), elle ne lie pas les autres autorités publiques ; le Conseil d'État l'a validée (CE, 28.02.2019, n° 417128). Elle ne vise pas les entreprises.
- En rédaction : le texte est-il un acte de l'État français ? Si oui, doublets complets et termes épicènes, pas de point médian. Sinon, la circulaire n'oblige pas, mais elle indique ce que le lecteur administratif attend.

### France, enseignement : le point médian est proscrit, et le Conseil d'État a jugé cette interdiction légale (20.12.2024)
- Niveau de preuve : N1 (pour l'enseignement scolaire et les actes du ministère)
- Source : Conseil d'État, actualité « L’interdiction de recourir à certains éléments de l’écriture inclusive (notamment le point médian) pour l’enseignement est légale », décision du 20.12.2024, https://www.conseil-etat.fr/actualites/l-interdiction-de-recourir-a-certains-elements-de-l-ecriture-inclusive-notamment-le-point-median-pour-l-enseignement-est-legale
- Extrait lu : la circulaire du 5 mai 2021 « proscrit l’usage et l’enseignement de certaines règles relevant de l’écriture inclusive, et notamment le point médian » ; elle exige aussi que les enseignants « féminisent systématiquement l’intitulé des fonctions tenues par une femme, recourent à des formulations ne marquant pas de préférence de genre ».
- Portée / limites : le texte de la circulaire (BO n° 18 du 6 mai 2021) n'a pu être ouvert (403) ; son contenu est rapporté par le Conseil d'État. Une proposition de loi d'interdiction générale, adoptée par le Sénat le 30.10.2023, n'était pas devenue loi au 27.05.2025 selon l'analyse Landot citée ci-dessus ; état ultérieur non vérifié. Les juridictions administratives divergent pour les autres collectivités (plaques de Paris validées ; statuts d'une université annulés à Grenoble en 2023 pour défaut d'intelligibilité).
- En rédaction : produit destiné à l'école française (élèves, parents, enseignants) ? Alors pas de point médian ; doublets et formulations neutres sont admis et même demandés.

### Académie française : contre l'écriture inclusive (2017), pour la féminisation des noms de métiers (2019)
- Niveau de preuve : N3 (avis d'institution, sans force normative)
- Source : Académie française, « Déclaration de l’Académie française sur l’écriture dite “inclusive” », 26.10.2017, https://www.academie-francaise.fr/actualites/declaration-de-lacademie-francaise-sur-lecriture-dite-inclusive ; « La féminisation des noms de métiers et de fonctions », rapport adopté le 28.02.2019, https://www.academie-francaise.fr/sites/academie-francaise.fr/files/rapport_feminisation_noms_de_metier_et_de_fonction.pdf
- Extrait lu : 2017 — « la langue française se trouve désormais en péril mortel ». 2019 — « il n’existe aucun obstacle de principe à la féminisation des noms de métiers et de professions. Celle-ci relève d’une évolution naturelle de la langue ».
- Portée / limites : l'Académie distingue les noms de métiers (féminisation admise) des fonctions, titres et grades (contraintes signalées). Ces textes n'obligent personne.
- En rédaction : « autrice », « ingénieure », « cheffe de projet » sont admis par l'Académie elle-même depuis 2019 ; ne pas les corriger comme fautes.

### France, Haut Conseil à l'Égalité : dix recommandations, dont le point (ou point médian) et l'ordre alphabétique
- Niveau de preuve : N3
- Source : Haut Conseil à l'Égalité entre les femmes et les hommes, « Pour une communication publique sans stéréotype de sexe », guide pratique, édition 2016 (La Documentation française) ; copie lue : https://www.ledepartement66.fr/media/2019/07/guide-recommandations-sans-stereotype-de-sexe.pdf
- Extrait lu : recommandation 3 « User du féminin et du masculin dans les messages adressés à tous et toutes » ; recommandation 4 « Utiliser l’ordre alphabétique lors d’une énumération » ; « Le point médian (aussi appelé « point d’altérité »), point situé à mi-hauteur du lettrage, peut également être utilisé ».
- Portée / limites : recommandation, non obligatoire ; elle contredit sur le point médian la circulaire de 2017 pour les textes du JO. L'édition actualisée 2022 n'a pas pu être lue (lien du HCE en 404). Le guide préconise, à l'oral, les formes développées.
- En rédaction : pour un client public français qui a signé la convention du HCE, la double flexion et l'ordre alphabétique (« les lycéennes et les lycéens ») sont attendus ; vérifier ensuite si le point médian est admis par la même institution (il ne l'est pas au JO ni à l'école).

### Suisse, textes fédéraux en allemand : pas de Genderstern ni de signe équivalent, mais pas non plus de masculin générique
- Niveau de preuve : N1 (pour les textes de la Confédération)
- Source : Chancellerie fédérale, « Umgang mit dem Genderstern und ähnlichen Schreibweisen in deutschsprachigen Texten des Bundes », Weisung und Erläuterungen vom 15. Juni 2021 ; copie lue (annexe d'un dossier du Grand Conseil de Zoug) : https://kr-geschaefte.zug.ch/dokumente/11189/3468-2-17179_Beilage4-Umgang-mit-Genderstern.pdf
- Extrait lu : « In den Texten des Bundes werden der Genderstern und ähnliche Schreibweisen deshalb nicht verwendet. Stattdessen kommen je nach Situation Paarformen (Bürgerinnen und Bürger), geschlechtsabstrakte Formen (versicherte Person), geschlechtsneutrale Formen (Versicherte) oder Umschreibungen ohne Personenbezug zum Einsatz. Das generische Maskulin (Bürger) ist nicht zulässig. » ; motif (e) : « Mangelnde Barrierefreiheit: Es ist unklar, wie Texte mit Genderstern und ähnlichen Schriftzeichen Sehbehinderten vorgelesen werden können. »
- Portée / limites : textes du Bund uniquement ; les cantons et communes décident pour eux-mêmes, les entreprises sont libres. Copie hébergée par un canton, pas sur bk.admin.ch.
- En rédaction : en allemand suisse officiel, chercher à la fois les astérisques / deux-points (« Kund:innen ») et le masculin générique (« Kunden ») : les deux sont hors norme fédérale.

### Suisse, textes fédéraux en français : pas de point médian ni de néologismes ; épicènes et collectifs ; le masculin pluriel peut désigner un groupe mixte
- Niveau de preuve : N1 (pour les textes de la Confédération)
- Source : Chancellerie fédérale, Services linguistiques centraux, Section française, « Pratiques d’écriture alternatives dans les textes de la Confédération en français », directive et explications du 1er novembre 2021, https://www.bk.admin.ch/dam/fr/sd-web/voYKXc0Q1qMM/Pratiques%20d%E2%80%99%C3%A9criture%20alternatives%20dans%20les%20textes%20de%20la%20Conf%C3%A9d%C3%A9ration%20en%20fran%C3%A7ais.pdf
- Extrait lu : « On ne recourra pas aux pratiques d’écriture alternatives dans les textes de la Confédération mais on utilisera de préférence et selon les cas des termes épicènes ou collectifs et on respectera le principe de l’économie de la langue : en français, le masculin pluriel peut désigner des ensembles mixtes » ; ces pratiques « sont difficiles à décoder, creusent l’écart entre la langue orale et la langue écrite ».
- Portée / limites : vise point médian, trait d'union, barre oblique, doublets abrégés, astérisque, néologismes (« iel »). Base : art. 7 de la loi sur les langues, qui impose de tenir compte de la formulation non sexiste. **Différence notable avec l'allemand** : la directive allemande interdit le masculin générique, la française admet le masculin pluriel pour un groupe mixte. La Chancellerie annonçait une actualisation du guide « à moyen terme » (parue ou non : non vérifié).
- En rédaction : pour un texte officiel suisse romand, préférer « le personnel », « la clientèle », « les personnes inscrites » ; pas de « client·es ». Un même message traduit en allemand n'aura pas la même solution.

### Suisse, textes fédéraux en italien : pas d'astérisque ni de schwa ; termes épicènes ou collectifs (guide du 30.01.2023)
- Niveau de preuve : N1 (lu via une source secondaire)
- Source : Angela Ferrari et Filippo Pecorari, « L’inclusione di genere nei testi ufficiali, tra maschile inclusivo e pratiche di scrittura alternative. Le scelte della Svizzera multilingue con focus sull’italiano » (revue de l'Université de Milan ; année non vérifiée, PDF créé en 2024), https://riviste.unimi.it/index.php/LCdM/article/download/24872/21582/72661
- Extrait lu : citation du guide fédéral : « 1. Le pratiche di scrittura alternativa, in particolare l’uso di segni tipografici (asterisco, schwa), non sono utilizzate nei testi della Confederazione. Si utilizzano invece, a seconda del caso, formulazioni senza referente semantico esplicito quanto al genere, quali termini epiceni […] » ; le guide est publié « Il 30 gennaio 2023 » et ses lignes « sono vincolanti per tutti i testi ufficiali ».
- Portée / limites : les auteurs ont rédigé le guide avec la Chancellerie ; texte primaire (directive du 21.09.2022, guide 2023) non ouvert (serveurs refusant la connexion).
- En rédaction : en italien suisse officiel, pas de « car* collegh* » ni de « tuttə » ; reformuler.

### Italie : l'Accademia della Crusca exclut astérisque et schwa dans la langue juridique et admet le masculin pluriel « inclusif »
- Niveau de preuve : N3 (avis d'institution)
- Source : Accademia della Crusca, « Risposta al quesito sulla scrittura rispettosa della parità di genere negli atti giudiziari posto all’Accademia della Crusca dal Comitato Pari opportunità del Consiglio direttivo della Corte di Cassazione » (protocole d'arrivée du 27.01.2023), https://www.dirittoantidiscriminatorio.it/app/uploads/2023/03/CRUSCA.pdf
- Extrait lu : « Va dunque escluso tassativamente l’asterisco al posto delle desinenze dotate di valore morfologico » ; « Lo stesso vale per lo scevà o schwa » ; « il maschile plurale “inclusivo” (a differenza del singolare) risulta comunque accettabile ».
- Portée / limites : avis sur les actes judiciaires, non contraignant pour un produit. Il recommande aussi d'éviter l'allongement par doublets systématiques et de préférer « persona », « il personale ».
- En rédaction : pour l'Italie, les doublets systématiques (« cittadini e cittadine ») alourdissent ; préférer un collectif ou un épicène, et réserver le masculin pluriel aux cas sans alternative.

### Allemagne (et espace germanophone) : les signes internes au mot ne font pas partie du noyau de l'orthographe
- Niveau de preuve : N3 (avis ; l'Amtliches Regelwerk devient contraignant pour l'école et l'administration par décision des États)
- Source : Rat für deutsche Rechtschreibung, communiqué « Amtliches Regelwerk der deutschen Rechtschreibung: Ergänzungspassus Sonderzeichen », 14.07.2023, https://www.rechtschreibrat.com/wp-content/uploads/rfdr_PM_2023-07-14_ARW_Sonderzeichen.pdf
- Extrait lu : « Diese Wortbinnenzeichen gehören nicht zum Kernbestand der deutschen Orthografie. » ; leur emploi « kann in verschiedenen Fällen zu grammatischen Folgeproblemen führen, die noch nicht geklärt sind, z. B. […] (der*die Präsident*in). »
- Portée / limites : le Conseil réunit Allemagne, Autriche, Suisse et d'autres. Il ne condamne pas le langage non sexiste ; il range les signes parmi les « Sonderzeichen » et observe l'évolution. Le Regelwerk révisé et sa date d'entrée en vigueur (01.07.2024 selon une recherche) n'ont pas été ouverts.
- En rédaction : en allemand, un « der*die Nutzer*in » crée des accords en chaîne ; préférer « Nutzende », « Person », ou la double forme.

### Québec : doublets complets dans le texte suivi ; doublets abrégés seulement faute de place, et alors entre parenthèses ou crochets
- Niveau de preuve : N3
- Source : OQLF, Banque de dépannage linguistique, « Qu’est-ce qu’un doublet abrégé ? » (mise à jour 2018), https://vitrinelinguistique.oqlf.gouv.qc.ca/25343/banque-de-depannage-linguistique/la-redaction-et-la-communication/feminisation-et-redaction-epicene/redaction-epicene/doublets/doublets-abreges/quest-ce-quun-doublet-abrege ; « Signes non retenus pour former des doublets abrégés » (mise à jour 2021), https://vitrinelinguistique.oqlf.gouv.qc.ca/25345/banque-de-depannage-linguistique/la-redaction-et-la-communication/feminisation-et-redaction-epicene/redaction-epicene/doublets/doublets-abreges/signes-non-retenus-pour-former-des-doublets-abreges ; « Désigner les personnes non binaires » (mise à jour 2021), https://vitrinelinguistique.oqlf.gouv.qc.ca/25370/banque-de-depannage-linguistique/la-redaction-et-la-communication/feminisation-et-redaction-epicene/redaction-epicene/designations-neutres/designer-les-personnes-non-binaires
- Extrait lu : « L’Office québécois de la langue française privilégie les parenthèses ou les crochets pour former un doublet abrégé. » ; « l’emploi des doublets abrégés est une option acceptable, mais seulement dans ces types de contextes » (tableaux, formulaires, microblogage) ; sur « iel », « frœur » : « L’Office ne conseille pas le recours à ces pratiques rédactionnelles. »
- Portée / limites : le point, le trait d'union, la majuscule et la virgule ne sont pas retenus (le point médian n'est pas nommé dans les extraits lus). Recommandation, non obligation pour le privé.
- En rédaction : pour le Québec, un libellé de formulaire peut porter « Employé(e) » ; un paragraphe d'aide, non.

### Préférer la reformulation épicène au doublet dans les phrases de service à la clientèle
- Niveau de preuve : N3
- Source : OQLF, « Exemples de formulations épicènes utiles en service à la clientèle » (mise à jour 2025), https://vitrinelinguistique.oqlf.gouv.qc.ca/25971/banque-de-depannage-linguistique/la-redaction-et-la-communication/feminisation-et-redaction-epicene/redaction-epicene/exemples-de-formulations-epicenes-utiles-en-service-a-la-clientele
- Extrait lu : « Êtes-vous un usager des transports en commun? » → « Utilisez-vous les transports en commun? » ; « Nous tenons à ce que vous soyez satisfait. » → « Votre satisfaction nous tient à cœur. » ; « il ne s’agit pas de synonymes, mais bien d’équivalents possibles ».
- Portée / limites : tableau d'exemples, à l'écrit et à l'oral. C'est la technique la plus portable : elle passe en France, en Suisse et au Québec, sans signe typographique.
- En rédaction : la phrase qui s'adresse à « vous » contient-elle un adjectif ou un nom genré évitable (« satisfait », « inscrit », « connecté ») ? « Vous êtes connecté » → « Connexion réussie ».

### Le point médian et les signes équivalents : ce qu'en disent les associations de personnes aveugles et dyslexiques
- Niveau de preuve : N4 (positions d'associations, sans protocole de test publié)
- Source : Handicap.fr / Emmanuelle Dal'Secco, 22.11.2017, « L'écriture inclusive, indéchiffrable pour les non-voyants », https://informations.handicap.fr/a-ecriture-inclusive-accessible-10358.php (rapporte le communiqué de la Fédération des aveugles et amblyopes de France du 20.11.2017) ; Deutscher Blinden- und Sehbehindertenverband (DBSV), position « Gendern » (dernière actualisation mars 2024), https://www.dbsv.org/gendern.html ; Université Paris-Saclay, poster « Écriture égalitaire et accessibilité numérique : amie ou ennemie ? » (2021), https://www.universite-paris-saclay.fr/sites/default/files/media/2021-05/handiversite-poster-ecritureinclusive.pdf
- Extrait lu : FAF (2017, via Handicap.fr) — « proprement indéchiffrable par nos lecteurs d'écrans ». Présidente de la FFDys, même article — « La FFDys n'a pas d'avis sur l'écriture inclusive mais mon avis personnel c'est qu'il est réducteur de dire qu'on ne doit pas l'appliquer au motif qu'elle entraverait la lecture des dyslexiques ». DBSV — « Damit klar wird, wie ein Text von einer Assistenz oder einem Screenreader vorgelesen werden soll, sollen Personenbezeichnungen ausformuliert werden » ; si des formes courtes sont imposées, « empfiehlt der DBSV, das Sternchen zu verwenden ». Paris-Saclay — « Limiter l’usage du point médian aux mots qui se prononcent pareil : ami.es ».
- Portée / limites : aucune de ces sources ne publie un test reproductible (lecteur, version, réglages, voix). La position de la FAF date de 2017 ; aucune mise à jour trouvée. Le DBSV recommande l'astérisque plutôt que le deux-points ou le tiret bas, contrairement à une idée répandue.
- En rédaction : écrire la forme développée ou une formulation neutre plutôt qu'une forme contractée ; si une forme contractée est imposée par le client, la tester au lecteur d'écran sur la plateforme cible.

### Les doublets complets ne ralentissent pas la lecture ; les formes contractées (voisin·es) ont un coût, qui diminue avec l'habitude
- Niveau de preuve : N2
- Source : Julia Tibblin, Pascal Gygax, Joost van de Weijer, Jonas Granfeldt, 2026, « Recognized but harder to integrate: An eye-tracking study of French gender-fair forms during reading », Applied Psycholinguistics, DOI 10.1017/S0142716426100484, https://lup.lub.lu.se/search/files/244168869/Tibblin_et_al_-_2026_-_recognized-but-harder-to-integrate-an-eye-tracking-study-of-french-gender-fair-forms-during-reading.pdf
- Extrait lu : « the complete double forms were not more costly to process. In contrast, contracted double forms led to increased processing costs in intermediate and late stages of processing, but had no effect on the early stages of processing. Our data also indicate that the processing of contracted double forms becomes easier over time, and that it is facilitated by positive attitudes towards gender-fair language. »
- Portée / limites : étude préenregistrée en oculométrie, 58 francophones natifs, textes courts ; lecteurs sans trouble déclaré (dyslexie et lecteurs d'écran non étudiés). L'introduction rappelle les travaux selon lesquels le masculin à visée générique active souvent une lecture spécifique masculine (Gygax et al., 2013, 2019, 2021 ; non lus).
- En rédaction : sur un écran lu vite (bouton, alerte, onboarding), la forme contractée ajoute un coût mesuré ; la double forme complète ou la tournure neutre n'en ajoutent pas.

### En anglais, employer le « they » singulier pour une personne indéterminée ; jamais « he/she » ni « (s)he »
- Niveau de preuve : N3
- Source : Google developer documentation style guide, « Pronouns », https://developers.google.com/style/pronouns ; Microsoft Writing Style Guide, « Bias-free communication », https://learn.microsoft.com/en-us/style-guide/bias-free-communication ; Merriam-Webster, « Singular 'They' », https://www.merriam-webster.com/wordplay/singular-nonbinary-they
- Extrait lu : Google — « don't use he/she or (s)he or other such punctuational approaches. Instead, use the singular they. » Microsoft — « If you can't write around the problem, it's OK to use a plural pronoun (they, their, or them) in generic references to a single person. Don't use constructions like he/she and s/he. » Merriam-Webster — « they has been in consistent use as a singular pronoun since the late 1300s ».
- Portée / limites : Microsoft préfère d'abord contourner (pluriel, « you », rôle), puis « they ». La page APA sur le sujet n'a pu être lue. Merriam-Webster distingue l'emploi générique (ancien) et l'emploi non binaire (récent).
- En rédaction : chercher « he or she », « his/her », « (s)he », « he » générique ; réécrire à la deuxième personne ou en « they ».

### Modèle commercial francophone : épicènes, reformulation, doublets dans l'ordre alphabétique, sans signe typographique
- Niveau de preuve : N3
- Source : Microsoft, French Style Guide (fr-FR, © 2021, position mise à jour après échange avec Microsoft France en septembre 2022), https://download.microsoft.com/download/c/7/9/c7921dbd-4531-4a4e-8490-e4656d739f3d/fra-fra-StyleGuide.pdf
- Extrait lu : « When presenting generalization, use epicene wording and terms (to be determined on a case-by-case basis), like “élève”, “membre”, “fonctionnaire” » ; « When referring to job titles, do not hesitate to feminize them such as “auteure/autrice” when referring to a real person. » ; « include them in alphabetical order. Examples: Bonjour à tous et à toutes » ; « use the pronouns that the person prefers, whether it's il, elle, iel or another pronoun. »
- Portée / limites : convention d'un éditeur ; le guide ne mentionne pas le point médian dans les passages lus. Il admet « iel » pour une personne réelle qui l'emploie, ce que l'OQLF et la Chancellerie fédérale déconseillent dans leurs textes.
- En rédaction : pour un produit commercial francophone, cette voie (épicène d'abord, doublet complet ensuite, pronoms choisis par la personne réelle) est compatible avec les positions officielles françaises, suisses et québécoises sur l'essentiel.

---

## 6. Confirmshaming et culpabilisation par la formulation

### Ne pas formuler le refus pour faire honte (« Non merci, je préfère payer plein tarif »)
- Niveau de preuve : N2
- Source : Arunesh Mathur, Gunes Acar, Michael J. Friedman, Elena Lucherini, Jonathan Mayer, Marshini Chetty, Arvind Narayanan, 2019, « Dark Patterns at Scale: Findings from a Crawl of 11K Shopping Websites », Proc. ACM HCI 3 (CSCW), art. 81, https://arxiv.org/pdf/1907.07032
- Extrait lu : définition — « Using language and emotion (shame) to steer users away from making a certain choice » ; « in the ‘Confirmshaming’ dark pattern—which tries to shame the user into making a particular choice— many messages begin with No thanks ».
- Portée / limites : relevé de ~53 000 pages produit sur ~11 000 sites marchands ; 169 instances de confirmshaming sur 164 sites. Mesure la fréquence, pas l'effet.
- En rédaction : relire chaque bouton de refus à voix haute : la personne qui clique dit-elle du mal d'elle-même ? Le refus doit être neutre (« Non merci », « Plus tard », « Continuer sans »).

### Le confirmshaming augmente un peu l'acceptation et fait baisser la recommandation : le gain se paie en confiance
- Niveau de preuve : N2
- Source : Kaixin Sha, Jingjun (David) Xu, Qi Wang (City University of Hong Kong), 2026, « Caught Between Compliance and Resistance: Understanding Users’ Conflicted Responses to Confirmshaming Techniques », Proceedings of the 59th Hawaii International Conference on System Sciences, https://scholarspace.manoa.hawaii.edu/server/api/core/bitstreams/ecce8bf5-907b-440f-983a-e204939d6b83/content
- Extrait lu : « confirmshaming increases customer acceptance of promotional offers by amplifying financial cost perception, while simultaneously reducing positive WOM intention through increased experienced coercion. » ; citant Luguri et Strahilevitz (2021) : « employing this tactic significantly increases acceptance rates by 4.8 percentage points (from 14.8% to 19.6%) ».
- Portée / limites : expérience par scénario, 151 participants retenus (69 traitement, 82 contrôle), plateforme Credamo (Chine), pop-up d'abonnement. Les chiffres de Luguri et Strahilevitz (Journal of Legal Analysis 13, 2021, 43-109) sont lus **via cette citation** : l'article primaire n'a pu être ouvert (403).
- En rédaction : le gain d'acceptation attendu (quelques points) vaut-il la baisse de recommandation et le risque juridique (les dark patterns sont traités dans un autre référentiel) ?

---

## Verdict sur les règles du profil

**Règle 1 — « Voix de marque : respecter le ton imposé (ex. chaleureux, tutoiement, jamais culpabilisant, jamais "Oops/Erreur" brut). Pas de condescendance. »**

| Élément | Verdict | Appui |
|---|---|---|
| Respecter le ton imposé par la marque | **Convention sans preuve trouvée**, partagée par toutes les plateformes (Apple, Google, Microsoft, Mailchimp) | Apple : voix cohérente, ton qui varie selon la situation ; Google : persona définie |
| « Chaleureux » | **Soutenue, avec réserve** : un ton conversationnel améliore sympathie et parfois confiance, mais la confiance prime et le ludique peut la faire baisser dans un domaine sérieux | NN/g 2016 (n = 100) |
| « Tutoiement » comme exemple | **Partiellement contredite** : en allemand, le du n'améliore pas la perception en moyenne et nuit en réponse à une plainte ; Microsoft garde vous (fr) et Sie (de, adultes) dans une voix « chaleureuse » ; l'OQLF signale que le tutoiement spontané passe mal hors Québec. Aucune étude sur tu/vous dans un produit francophone | Kretzenbacher & Hensel-Börner 2024 ; Küppers 2018 ; Microsoft ; OQLF |
| « Jamais culpabilisant » | **Soutenue** (guidelines convergentes ; coût mesuré du confirmshaming sur la recommandation) | NN/g 2023 ; GOV.UK ; Sha et al. 2026 |
| « Jamais "Oops" » | **Soutenue** (N3, convergence GOV.UK, Apple, NN/g ; pas d'étude d'effet) | GOV.UK ; Apple ; NN/g 2023 |
| « Jamais "Erreur" brut » | **Soutenue** si on l'entend comme « pas de message sans cause ni remède » ; aucune source ne bannit le mot « erreur » lui-même | NN/g 2023 (codes, jargon, « invalid ») ; GOV.UK |
| « Pas de condescendance » | **Convention sans preuve trouvée**, cohérente avec les guides | Mailchimp (« never condescending ») ; NN/g 2023 (erreurs prématurées : « belittled ») |

Formulation proposée : « Voix de marque : appliquer la voix imposée et moduler le ton selon l'état du lecteur. Le registre d'adresse (tu / vous, du / Sie, tú / usted / vos) se fixe **par langue et par marché**, pas par traduction de la source ; dans le doute, registre formel, et toujours formel sur les écrans de litige, de paiement refusé et de conditions. Jamais d'interjection (« Oups »), jamais de mot qui accuse (« invalide », « vous avez oublié »), pas d'humour dans une erreur, pas d'excuse pour une erreur de saisie ; une excuse brève quand le système a failli et que la personne en subit le coût. »

**Règle 2 — « Ton culpabilisant / alarmiste sur un état neutre = anti-pattern ("Vous n'avez rien fait", "Oops ! Erreur"). »**

- Culpabilisant : **soutenue** (NN/g 2023 « Don't use phrasing that blames users » ; GOV.UK bannit « you forgot » ; confirmshaming : baisse de recommandation mesurée, Sha et al. 2026).
- Alarmiste sur un état neutre : **convention sans preuve expérimentale trouvée**, appuyée par NN/g 2023, qui réserve les dialogues modaux aux erreurs graves et donne en bon exemple un avis de retard « without conventional red formatting ». Aucune étude sur la formulation des états vides (« Vous n'avez rien fait ») n'a été trouvée.
- Les deux exemples entre parenthèses relèvent de deux défauts distincts (culpabilisation d'un état vide ; interjection devant une erreur) : les séparer rend la règle plus vérifiable.

**Langage inclusif — ce que le profil devrait dire (proposition, à valider par le mainteneur)**

1. **Hiérarchie universelle, toutes langues** : reformulation neutre ou épicène d'abord (« Utilisez-vous… », « le personnel », « Nutzende », « persona », « you »), doublet complet ensuite, forme contractée en dernier recours et seulement si le client l'exige. Motif : c'est la seule voie compatible avec toutes les positions officielles lues, et la seule sans coût de lecture mesuré (Tibblin et al. 2026) ni objection d'associations de personnes aveugles.
2. **Registre officiel (obligatoire dans son périmètre)** :
   - France, État et JO : pas d'écriture dite inclusive, féminisation des fonctions, « le candidat ou la candidate » (circulaire du 21.11.2017). École : pas de point médian (circulaire du 05.05.2021, validée par le CE le 20.12.2024).
   - Suisse, Confédération : pas de signes ni de néologismes dans les trois langues ; en **allemand**, masculin générique interdit (Weisung 15.06.2021) ; en **français**, masculin pluriel admis pour un groupe mixte (directive 01.11.2021) ; en **italien**, ni astérisque ni schwa (guide 30.01.2023).
   - Québec : recommandations OQLF (doublets complets ; abrégés entre parenthèses ou crochets, seulement faute de place).
3. **Registre commercial (recommandé, pas obligatoire)** : aucune règle générale n'oblige les entreprises dans les pays étudiés (France : PPL non adoptée au 27.05.2025, état ultérieur non vérifié). Suivre la charte du client ; à défaut, la hiérarchie du point 1 ; pour une personne réelle, ses pronoms (Microsoft) ; en anglais, « they » singulier.
4. **Accessibilité** : si une forme contractée est retenue, la tester au lecteur d'écran sur la plateforme cible avant livraison ; en allemand, le DBSV préfère l'astérisque au deux-points.
5. **Ne jamais traduire une solution inclusive mot à mot** : la solution correcte change d'une langue à l'autre (exemple suisse ci-dessus).

---

## Mythes et affirmations contestées

- **« Le point médian est illisible par les lecteurs d'écran. »** — Affirmation portée par des associations (FAF 2017 via Handicap.fr ; DBSV, actualisé 2024 ; poster Paris-Saclay 2021) et reprise par la Chancellerie fédérale (2021), mais **aucun test publié et reproductible** (lecteur, version, réglages) n'a été trouvé. Le comportement dépend vraisemblablement du lecteur et de ses réglages : non vérifié.
- **« L'écriture inclusive pénalise les dyslexiques. »** — Argument avancé par la FAF (2017), par la circulaire de 2021 selon le Sénat (« publics en difficulté ») et par la Chancellerie fédérale ; la présidente de la FFDys, à titre personnel, le jugeait « réducteur » (2017). Aucune étude sur des lecteurs dyslexiques n'a été trouvée ; Tibblin et al. (2026) mesurent un coût des formes contractées chez des lecteurs sans trouble déclaré.
- **« L'écriture inclusive est interdite en France. »** — Inexact : les circulaires lient les administrations de l'État (JO) et l'enseignement ; la proposition de loi d'interdiction générale (Sénat, 30.10.2023) n'était pas loi au 27.05.2025 ; la jurisprudence diverge pour les collectivités. Rien de général pour le secteur privé dans les sources lues.
- **« La Suisse a interdit le langage inclusif. »** — Inexact : la loi sur les langues (art. 7) **impose** la formulation non sexiste aux autorités fédérales ; seuls les signes typographiques et néologismes sont écartés, et seulement dans les textes de la Confédération.
- **« L'Académie française refuse la féminisation. »** — Inexact depuis le 28.02.2019 pour les noms de métiers (« aucun obstacle de principe »).
- **« Le masculin générique est neutre. »** — Contesté par la recherche citée dans Tibblin et al. (2026) (lecture spécifique masculine souvent activée ; études non lues ici) ; admis toutefois au pluriel par la Chancellerie fédérale en français et par la Crusca en italien, interdit par la Chancellerie en allemand.
- **« Il ne faut jamais dire "désolé". »** — Généralisation abusive : GOV.UK l'interdit dans les erreurs de saisie mais l'impose en titre de page de panne ; Microsoft le réserve aux problèmes graves du produit ; Tzeng (2004) mesure un bénéfice sur l'expérience vécue.
- **« L'humour rend les erreurs plus sympathiques. »** — Non établi : résultats contradictoires (Xie et al. 2024 contre Seo 2024 ; Clausen & Kyhn 2022) ; les guides déconseillent l'humour dans l'erreur.
- **« Le tutoiement crée de la proximité, donc de la confiance. »** — Non soutenu par les études allemandes lues (Kretzenbacher & Hensel-Börner 2024 ; Küppers 2018) ; non testé en français.
- **« NN/g a tranché "Mon compte" contre "Votre compte". »** — Aucun article NN/g sur ce sujet n'a été trouvé ; les recommandations qui circulent viennent de praticiens et des guides Apple et Microsoft, sans étude contrôlée lue.
- **« Le "they" singulier est une innovation récente. »** — Faux pour l'emploi générique (Merriam-Webster : depuis la fin du XIVe siècle) ; l'emploi non binaire, lui, est récent.

---

## Non vérifié

- **Étude « My » vs « Your »** : un poster d'A. Moallem (IEA 2006, hébergé à SJSU) a été repéré mais le serveur a répondu 503 ; aucun article NN/g sur le sujet n'a été trouvé.
- **Étude ou directive officielle sur tu / vous dans les produits numériques francophones** : rien trouvé (OQLF : fiche interpersonnelle seulement).
- **Étude du / Sie propre à la Suisse alémanique** : rien trouvé.
- **Circulaire de l'Éducation nationale du 5 mai 2021** : texte primaire refusé (403) ; contenu lu via le Conseil d'État et le Sénat.
- **Statut de la proposition de loi sénatoriale (2023) après le 27.05.2025** : non vérifié.
- **Guide HCE, édition actualisée 2022** : lien officiel en 404 ; seule l'édition 2016 a été lue.
- **Directive fédérale italienne du 21.09.2022 et guide du 30.01.2023 (textes primaires)** : serveurs inaccessibles ; lus via Ferrari et Pecorari. Année de cet article non vérifiée.
- **Actualisation du guide fédéral de formulation non sexiste en français** (annoncée « à moyen terme » en 2021) : non vérifiée.
- **Regelwerk allemand révisé (entrée en vigueur annoncée au 01.07.2024)** : non ouvert.
- **Page APA sur le « they » singulier** : non lue (réponse vide).
- **Luguri & Strahilevitz (2021), article primaire** : refusé (403) ; chiffres lus via Sha et al. (2026).
- **Effectifs de Xie et al. (2024) et de Kretzenbacher & Hensel-Börner (2024)** : résumés seuls lus.
- **Lieu de publication de Cohn et al. (2024)** : prépublication arXiv lue ; publication en conférence non vérifiée.
- **Tests de lecteurs d'écran (NVDA, JAWS, VoiceOver, TalkBack) sur « étudiant·e·s »** : aucun protocole publié trouvé.
- **Effet de la modification « Digital Omnibus » sur l'art. 50 de l'AI Act** : l'alinéa 1 apparaît inchangé sur le site consulté ; non vérifié au Journal officiel de l'UE.
- **Vote de Zurich (novembre 2024) sur l'initiative contre le Genderstern** : vu seulement dans un résumé de recherche, page non ouverte ; non retenu.

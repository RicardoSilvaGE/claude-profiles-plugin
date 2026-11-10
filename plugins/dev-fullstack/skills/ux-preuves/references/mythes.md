# Fiche `ux-preuves` — Mythes à ne pas reproduire

> Liste opposable, sortie du `SKILL.md` le 09.11.2026 pour alléger ce qu'il précharge chez `ux`,
> `designer`, `redacteur`, `growth`, `frontend`, `backend`, `architecte`, `securite` et `reviewer`. Ces affirmations circulent dans la littérature de
> praticiens et **ne s'écrivent pas** dans un livrable, sauf pour les réfuter. Chaque réfutation est
> sourcée dans la fiche indiquée en tête de groupe, à sa section « Mythes et affirmations contestées ».

**Cognition et chemin d'usage** — `references/cognition-chemin-usage.md`

- « L'affordance d'un bouton. » Norman lui-même demande de parler de **signifiants** pour les
  indices perceptibles (2008, puis édition révisée de 2013).
- « Le défaut marche toujours », « l'opt-out fait exploser le don d'organes ». Le défaut change ce
  qui est coché (Johnson & Goldstein 2003, répliqué en ligne en 2023 sur N = 1 920), pas
  forcément le résultat final : pas de différence significative de donneurs décédés sur 35 pays
  de l'OCDE (2019) ; et une méta-analyse (2019) trouve une forte hétérogénéité, effets négatifs
  compris.
- « Il faut 21 jours pour prendre une habitude. » Aucune source ; l'étude citée (Lally et al. 2010)
  donne une médiane de 66 jours sur 39 participants, de 18 à 254 jours.
- « 83 % des radiologues ratent ce qu'ils devraient voir. » Ils ratent un gorille inséré dans un
  scanner (Drew et al. 2013, 24 radiologues), pas une pathologie : la leçon est que l'inattendu
  échappe même aux experts.
- « Une animation attire l'œil sur une bannière. » L'animation fait partie des traits qui signalent
  une publicité et font éviter la zone (NN/g 2018).
- « Les principes de la Gestalt sont prouvés en interface. » Solides en perception ; leurs effets
  chiffrés sur des interfaces ne sont pas établis par les sources lues.
- « Charge intrinsèque, extrinsèque, germane. » Le statut de la charge germane est contesté (de
  Jong 2010), et la théorie porte sur l'apprentissage, pas sur l'usage courant.
- « Le KLM prédit le temps de toute tâche. » Pour des experts, des tâches de routine, sans erreur.

**Perception, mémoire, décision** — `references/normes-lois-methodes.md`, `references/front-de-recherche.md`

- « La loi de Hick impose de réduire le nombre d'options. » Liu et al. (CHI 2020) : elle « speaks
  against, not for, the popular principle that 'less is better' » ; la croissance est logarithmique,
  et le parcours d'une liste désordonnée n'y obéit pas.
- « Sept éléments au plus dans un menu », « la mémoire de travail tient 7 ± 2 éléments ». Le sept
  de Miller était « a rough estimate and a rhetorical device » (Cowan 2001, qui ramène la capacité à
  environ quatre blocs) ; un menu se lit, il ne se mémorise pas (Nielsen 2009).
- « Ce qui est beau est utilisable. » Tuch et al. 2012 trouvent l'inverse : une mauvaise
  utilisabilité dégrade l'esthétique perçue, pas l'inverse.
- « On retient mieux les tâches inachevées (Zeigarnik). » Non répliqué (méta-analyse 2025) ; seule
  la tendance à reprendre la tâche est robuste.
- « Seuls le pic et la fin comptent. » L'effet est comparable à celui de la moyenne (Alaybek et al.
  2022) ; seule la durée pèse peu.
- « Les lois de Jakob et de Tesler. » Principes d'expert, sans mesure publiée : à citer en N4.
- « Les nudges ont un effet moyen de d = 0,45. » Corrigé du biais de publication : environ 0,04,
  sans preuve d'effet global (Maier et al. 2022). L'épuisement de la volonté (ego depletion) ne se
  réplique pas ; l'effet de leurre tient mal hors des tableaux de chiffres.

**Lecture et contenus** — `references/contenus-documents-accessibilite.md`, `references/front-de-recherche.md`

- « Notre attention (8 s) est plus courte que celle d'un poisson rouge. » Aucune étude derrière le
  chiffre (rapport Microsoft Canada 2015 citant « Statistic Brain »).
- « Les gens ne lisent pas. » Ils balaient d'abord, puis lisent quand le texte le mérite : on écrit
  pour le balayage **et** pour la lecture complète.
- « Il faut disposer le contenu en F. » Le F est le symptôme d'un texte mal formaté, pas un gabarit.
- « Un bon score de lisibilité prouve qu'un texte est clair. » ISO 24495-1 juge sur l'usage,
  « rather than on mechanical measures such as readability formulas ».
- « Des lignes courtes se lisent plus vite. » Non démontré à l'écran (Dyson & Kipping 1998) ; la
  plage « 45 à 75 caractères » vient de l'imprimé, sans source primaire lue.
- « La police préférée est la plus lisible », « une police pour dyslexiques aide ». La préférence
  ne prédit pas la vitesse (Wallace et al. 2022) ; la police dédiée n'est pas plus rapide (Rello 2013).
- « Le mode sombre est plus lisible. » Les mesures de performance favorisent le clair pour une
  vision normale, surtout en petit corps ; le sombre sert certains profils.
- « Un PDF balisé est accessible. » GOV.UK : un PDF ne peut pas être rendu pleinement accessible
  à tous ; HTML quand c'est possible.
- « Jamais de camembert. » Seul « position > angle et aire » est solide ; l'infériorité de l'angle
  sur la longueur n'est pas confirmée en réplication (Heer & Bostock 2010).

**Accessibilité** — `references/contenus-documents-accessibilite.md`, `references/front-de-recherche.md`

- « WCAG 3 remplace WCAG 2 », « il faut déjà s'y conformer ». Brouillon de travail du 10.09.2026 :
  « WCAG 3 does not replace WCAG 2 ». La référence reste WCAG 2.2, devenue ISO/IEC 40500:2025.
- « Un overlay rend un site conforme. » Faux selon plus d'un millier de praticiens signataires, et
  allégation sanctionnée par la FTC (accessiBe, 2025).

**Formulaires, mobile, performance** — `references/formulaires-navigation-mobile.md`

- « La validation en ligne est toujours meilleure. » Wroblewski 2009 (22 participants) et GOV.UK
  (« Do not validate when the user moves away from a field ») divergent ; elles ne s'accordent que
  sur « jamais avant que la saisie soit finie ».
- « Labels au-dessus : saisie dix fois plus rapide. » Durées de saccade d'un test oculométrique ad
  hoc (Penzo 2006), dont l'auteur dit qu'il ne ressemble pas aux conditions réelles.
- « 70 % des acheteurs abandonnent à cause du checkout. » Les 70,22 % de Baymard sont un abandon
  toutes causes ; « checkout trop long ou compliqué » pèse 17 % des raisons.
- « La zone du pouce en arc. » Son auteur supposé la qualifie de « well-known, but incorrect »
  (Hoober 2017) : on change de prise et on préfère le centre.
- « Amazon : 100 ms = 1 % de ventes », « 53 % des visiteurs mobiles partent après 3 s »,
  « + 8,4 % de conversion par 0,1 s ». Une diapositive sans méthode ; une note de bas de page sur des
  données Google Analytics de 2016 ; une association commandée par Google, sans groupe témoin.
- « Les skeleton screens paraissent plus rapides. » L'étude publiée ne trouve pas de différence
  significative avec un spinner (Mejtoft et al. 2018).
- « Le hamburger est interdit partout. » Net sur desktop, nuancé sur mobile (NN/g 2016).

**IA, éthique, engagement** — `references/ia-ethique-onboarding.md`, `references/front-de-recherche.md`

- « Une IA qui s'explique ou cite ses sources inspire une confiance justifiée. » Explications et
  citations font accepter la réponse « regardless of its correctness » (Bansal et al. 2021), y
  compris des citations fausses ; les utilisateurs cliquent rarement dessus.
- « Les utilisateurs vont plus vite avec l'IA, ils le disent. » METR 2025 : 19 % plus lents,
  persuadés d'avoir gagné 20 %. Le ressenti n'est pas une mesure.
- « Un pourcentage de confiance aide l'utilisateur. » PAIR le déconseille : préférer des catégories
  reliées à une action.
- « Un avertissement protège. » L'attention s'effondre dès la deuxième exposition (Anderson et al.
  2015).
- « Un tutoriel d'entrée améliore la prise en main. » Pas nécessairement (NN/g 2023) ; l'aide
  contextuelle fait mieux, sauf paradigme d'interaction nouveau.
- « Il faut 23 minutes pour se reconcentrer après une interruption. » C'est le délai moyen avant
  de **reprendre** la tâche, issu d'une interview (Mark, 2006), pas un temps de reconcentration.
- « 11 % des sites marchands ont des dark patterns. » Borne basse (Mathur et al. 2019), pas une
  estimation : ne jamais lire « 89 % n'en ont pas ».

**Design visuel** — `references/design-*.md`

- « On juge un site en 50 ms. » Lindgaard et al. 2006 portent sur l'**attrait visuel** ;
  l'extension à la crédibilité et à l'utilisabilité vient de reprises secondaires.
- « 46 % des utilisateurs jugent la crédibilité sur le design. » C'est 46,1 % **des commentaires**
  (Fogg et al. 2002), et l'effet est trouvé plus faible une décennie plus tard.
- « Il faut une complexité moyenne (U inversé). » Sur les sites au premier regard, la complexité
  élevée pénalise, faible et moyenne font jeu égal (Tuch et al. 2012 ; Reinecke et al. 2013).
- « L'espace blanc augmente la compréhension de 20 %. » Aucune source primaire trouvée.
- « La proximité groupe mieux qu'une bordure. » Une région commune groupe plus fort ; la proximité
  coûte seulement moins de complexité visuelle.
- « APCA est l'algorithme de WCAG 3. » Le brouillon du 10.09.2026 dit l'algorithme « yet to be
  determined ». Une palette « garantie APCA » se revérifie en ratio WCAG 2.
- « Le bouton rouge convertit mieux », « le rouge stresse », « le rouge rend plus attirant ». Page
  d'origine introuvable pour le premier ; pas de valeur probante après correction du biais de
  publication pour le deuxième (méta-analyse Gnambs 2020) ; effet « very small, potentially
  nonexistent » pour le troisième (méta-analyse Lehmann et al. 2018).
- « Le texte clair sur noir provoque une halation chez les astigmates. » Aucune source primaire.
- « HSL suffit pour un thème clair/sombre. » Contredit par CSS Color 4 § 7.3 : passer en OKLCH.
- « Serif pour le papier, sans-serif pour l'écran. » Aucune différence robuste à conditions égales.
- « La grille de 8 points est prouvée », « les échelles modulaires produisent l'harmonie ».
  Conventions de production.
- « Il faut toujours remplacer l'outline du navigateur. » Le focus natif est conforme (G165) ; c'est
  en le modifiant qu'on s'expose à l'échec.
- « Un bouton désactivé doit atteindre 4,5:1. » Les composants inactifs sont exemptés.
- « Les animations ne doivent jamais dépasser 300 ou 400 ms. » Seuil de praticien ; la gêne est
  située à 500 ms (NN/g), et environ 1 s est mesuré utile pour une transition de données.
- « `prefers-reduced-motion`, c'est aucune animation. » La spécification dit « removes or
  replaces » : un fondu remplace une translation.
- « 35 % des adultes souffrent de troubles vestibulaires. » Le chiffre porte sur les Américains de
  40 ans et plus, mesurés par un test d'équilibre, pas sur la gêne face au mouvement.
- « La spécification DTCG est une norme W3C. » C'est un rapport de groupe communautaire.
- « Un design system rend 47 % plus rapide. » Un formulaire, huit développeurs.
- « Material 3 Expressive fait repérer quatre fois plus vite. » « Up to », recherche d'éditeur
  sans protocole publié, gain porté par la saillance d'un bouton agrandi.
- « Les outils d'IA produisent des interfaces accessibles. » Résultats contradictoires ; une étude
  de 2026 mesure 29 % de conformité.

**Rédaction et traduction** — `references/redaction-*.md`

- « Phrases de 14 mots = 90 % de compréhension. » Source primaire introuvable.
- « Les capitales sont illisibles », « on lit par la forme des mots ». Argument du bouma non
  soutenu ; au seuil de lisibilité, les lettres isolées sont plus lisibles que les mots.
- « Le bouton à 300 millions de dollars. » C'est le parcours qui a changé, pas seulement le libellé.
- « Réécrire les messages d'erreur réduit toujours les erreurs. » Effet trouvé (Becker et al. 2016),
  non répliqué (Pettit et al. 2017).
- « Ne jamais s'excuser », « ne jamais dire nous ». Les guides divergent : GOV.UK proscrit « sorry »
  dans les erreurs de saisie mais l'emploie pour une panne ; Apple déconseille « we », Microsoft
  l'emploie.
- « L'humour rend les erreurs sympathiques. » Résultats contradictoires ; les guides le déconseillent.
- « Le tutoiement crée de la proximité, donc de la confiance. » Non soutenu en allemand, non testé
  en français.
- « NN/g a tranché "Mon compte" contre "Votre compte". » Aucun article trouvé.
- « L'écriture inclusive est interdite en France », « la Suisse a interdit le langage inclusif ».
  Inexacts : les circulaires françaises lient l'État et l'enseignement ; la loi suisse sur les
  langues **impose** la formulation non sexiste aux autorités fédérales, seuls certains signes sont
  écartés. « L'Académie refuse la féminisation » est inexact depuis le 28.02.2019 pour les métiers.
- « Le point médian est illisible par les lecteurs d'écran. » Porté par des associations, sans test
  reproductible trouvé : à tester sur la plateforme cible plutôt qu'à affirmer.
- « +30 % / +35 % en allemand et en espagnol. » Bornes hautes de prestataires, sans méthode ; les
  chaînes courtes s'allongent bien davantage.
- « Les langues romanes n'ont que singulier et pluriel », « le russe a six pluriels », « `one`
  signifie 1 ». Faux selon CLDR 49 : `many` en fr, es, it, pt ; quatre catégories en ru ; en
  français, 0 et 1,5 relèvent de `one`.
- « En Suisse, le séparateur de milliers est l'apostrophe. » CLDR oui, la Chancellerie fédérale non
  en français : décider et documenter.
- « MessageFormat 2.0 n'est pas stable. » Stable depuis CLDR 47 (13.03.2025) ; `Intl.MessageFormat`
  reste au stade 1.
- « Les LLM ont atteint la parité humaine en traduction », « un bon score COMET veut dire une bonne
  traduction », « il suffit de demander d'être naturel ». Contestés ou contredits (WMT 2024-2025 ;
  Li et al. 2025).
- « L'AI Act impose d'étiqueter tout texte rédigé avec l'IA. » Faux en l'état lu : l'art. 50(4) vise
  les textes publiés pour informer le public sur des sujets d'intérêt public, avec exception en cas
  de relecture sous responsabilité éditoriale.

**Growth et marketing** — `references/growth-*.md`

- « Le titre Play fait 50 ou 60 caractères. » 30, depuis 2021.
- « 7 amis en 10 jours » (Facebook), « 40 % de très déçus = product-market fit ». Aucune source
  primaire trouvée pour le premier ; seuil « a bit arbitrary » pour le second.
- « Le 60/40 marque/activation est la règle. » Moyenne de marques établies (62/38 en 2017), qui
  « varies by category » ; « 46/54 en B2B » repose sur moins de 50 cas.
- « Le NPS est le seul chiffre qui compte pour croître. » Non répliqué (2007), contredit (2022).
- « Les avis multiplient les ventes par 3,7. » Exact pour 5 avis contre 0 chez un seul détaillant ;
  la note « idéale » est entre 4,0 et 4,7 dans la source, pas 4,2-4,5.
- « La plupart des tests réussissent si on a de bonnes idées », « un test sérieux = une seule
  variable ». Contredits (Kohavi et al.).
- « Les titres négatifs convertissent mieux. » Mesuré en clics sur des titres d'actualité, pas en
  conversions.
- « Les prix en 9 marchent toujours », « l'urgence augmente toujours les ventes », « l'ancrage est
  une loi », « AIDA est un modèle validé ». Conditionnels, fragiles ou non testés.
- « L'essai avec renouvellement automatique convertit à 50 % contre 15 %. » Chiffres de fournisseurs ;
  l'expérience randomisée disponible mesure moins d'abonnés à 20 mois.
- « Le taux d'ouverture mesure l'intérêt », « il existe une meilleure heure d'envoi », « plus
  d'e-mails = plus de revenus ». Contredits ou sans étude.
- « Un inscrit gratuit est un client : soft opt-in », « en B2B, pas de règles ». Contredits (PFPDT,
  CNIL ; CAN-SPAM, LCD let. o).
- « L'E-E-A-T est un facteur de classement », « Google pénalise le contenu écrit par IA », « il faut
  un balisage spécial pour les IA », « le GEO augmente la visibilité de 40 % ». Contredits par Google
  ou par la recherche.
- « La publicité comparative est interdite », « un prix barré, c'est le prix d'avant ». Faux : elle
  est encadrée ; dans l'UE, le prix de référence est le plus bas des 30 jours.

**Frontend** — `references/frontend-*.md`

- « Lazy-loader toutes les images améliore la performance. » Contredit pour l'image LCP (tests A/B
  web.dev) ; et `next/image` est en `lazy` par défaut.
- « Un bon score Lighthouse vaut un bon INP. » Lighthouse ne mesure pas l'INP ; prioriser le terrain.
- « `scheduler.yield()` est disponible partout. » Absent de Safari au 09.11.2026.
- « Le budget de 200 Ko de JS est une recommandation Google. » C'est un exemple web.dev, dérivé d'un
  téléphone d'entrée de gamme en 4G lente ; la médiane mobile est à 646 Ko.
- « `useMemo` et `memo` partout, par précaution », et son inverse « on peut tout retirer avec React
  Compiler ». Contredits tous les deux par react.dev et le blog React.
- « Next.js met `fetch` en cache par défaut », « le middleware s'appelle `middleware.ts` »,
  « Tailwind se configure dans `tailwind.config.js` », « ESLint 9 et eslintrc ». Périmés.
- « Vérifier la session dans le layout protège le segment », « une Server Action non importée n'est
  pas atteignable », « valider avec Zod suffit ». Contredits par la doc Next.js : une action est un
  POST public, un schéma ne contrôle que la forme.
- « `getSession()` de Supabase suffit côté serveur. » « Never trust » (doc Supabase).
- « Radix est abandonné. » Non soutenu par les sources primaires.
- « Une error boundary rattrape toutes les erreurs React. » Ni gestionnaires d'événements, ni code
  asynchrone, ni SSR.
- « React protège de toutes les XSS. » `dangerouslySetInnerHTML`, URL saisies et écritures DOM
  directes restent ouvertes.
- « Une CSP par liste de domaines protège de la XSS » (94,72 % contournables, 2016), « un cookie
  `HttpOnly` rend la XSS inoffensive », « un paquet avec provenance est sûr ». Contredits.
- « TypeScript attrape la plupart des bugs » (environ 15 % mesurés), « les langages typés ont moins
  de bugs » (réplication : effet minime), « une bonne couverture prouve une bonne suite de tests ».
- « Les outils automatiques détectent 57 % des problèmes d'accessibilité. » Chiffre d'éditeur, en
  occurrences ; il ne se compare pas aux « 20-30 % », qui comptent des critères.
- « L'ARIA cause les erreurs. » Corrélation seulement (59,1 contre 42). « Un `role="alert"` monté
  déjà rempli sera lu », « Next.js gère l'accessibilité des changements de route » : faux.
- « 40 % du code Copilot est vulnérable. » Scénarios construits ; sur du code réel, 24 à 30 %
  d'extraits avec au moins une faiblesse. « Écrire "secure" dans la consigne suffit », « demander à
  l'IA d'améliorer le code le rend plus sûr », « le modèle vérifie seul qu'un paquet existe ».
  Contredits.
- « Anchor positioning est Baseline. » Le noyau oui, le groupe complet non : nommer la propriété.

**Revue de code** — `references/revue-*.md`

- « La revue de code sert d'abord à trouver des bugs. » C'est la motivation déclarée, pas le
  résultat : 14 % des commentaires portent sur un défaut (Bacchelli & Bird 2013), trois constats sur
  quatre touchent l'évolutivité.
- « Au-delà de 400 lignes, la revue s'effondre. » Le sens de l'effet est mesuré, pas le seuil : il
  vient d'une étude d'éditeur (« under 200, not to exceed 400 », Cohen 2006).
- « Mêler refactoring et feature rend la revue impossible. » Plus de faux constats, pas moins de
  défauts trouvés (di Biase et al. 2019, 28 sujets).
- « Une checklist améliore la détection. » Pas de relation forte mesurée (Gonçalves et al. 2022).
- « Un LLM qui sait écrire du code juste sait juger du code. » Sans exécuter, le meilleur juge testé
  classe « correctes » la moitié des implémentations fausses (Crupi et al. 2025).
- « Les tests passent, donc c'est correct. » 29,6 % de correctifs d'agents validés par les tests
  divergent de la référence ; jusqu'à 68,1 % de suites générées valident le bug.
- « Demander à l'IA de chercher encore améliore la revue. » Le rappel monte un peu, le rapport signal
  sur bruit se dégrade ; expliquer puis corriger fait rejeter du code correct (Jin & Chen 2025).
- « Un score élevé sur un banc de revue prouve la qualité. » Un quart des exemples des jeux de
  données de revue sont du bruit.

**Mise en production** — `references/release-*.md`

- « 70 % des pannes viennent des changements. » Estimation interne de Google, sans méthode publiée ;
  chez Microsoft Teams, 40 % des incidents graves viennent du code ou de la configuration.
- « Ne jamais déployer le vendredi. » Données faibles et contradictoires ; les gels documentés se
  motivent par la disponibilité de l'équipe, pas par le jour.
- « Un comité d'approbation rend les livraisons plus sûres. » Pas de baisse des échecs (DORA 2019).
- « Un retour arrière remet tout comme avant. » Sur Vercel, il repointe vers un ancien build avec sa
  configuration, ne touche ni la base ni les API, et coupe l'auto-assignation des pushes suivants.
- « Le retour arrière est toujours sûr. » Une migration appliquée peut l'interdire ; chez Knight
  Capital, retirer le nouveau code a aggravé la panne.
- « Promouvoir une préversion, c'est servir l'artefact testé. » Sur Vercel, c'est une reconstruction
  avec les variables de production.
- « Changer une variable Vercel prend effet tout de suite. » Seulement aux déploiements suivants ;
  une `NEXT_PUBLIC_` exige un nouveau build.
- « Supabase sauvegarde tous les projets. » Pas le plan Free, et jamais les objets Storage.
- « Une branche Supabase est une copie de la prod. » Ni données ni Storage par défaut.
- « GitLab avait cinq mécanismes de sauvegarde, aucun ne marchait. » Quatre, et un snapshot a servi.
- « Une sauvegarde non testée n'est pas une sauvegarde. » Slogan sans source primaire trouvée.
- « Comparer avant et après le déploiement suffit. » « Before/After Evaluation Is Risky » (SRE Workbook).
- « Il faut comprendre la cause avant d'agir. » Plus de 90 % des incidents de Microsoft Teams ont été
  atténués sans changement de code.
- « L'approbation humaine suffit à sécuriser un agent. » 93 % des demandes sont acceptées (Anthropic) ;
  l'autorisation se contrôle côté système.
- Incident Replit : « base supprimée pendant le gel, sans récupération ». La source ne situe pas la
  suppression pendant le gel, et l'utilisateur a écrit ensuite « the rollback did work ».

**Tests** — `references/qa-*.md`

- « La bonne pyramide, c'est 70/20/10. » Un « good first guess » (Google, 2015), 80/15/5 ailleurs chez
  Google comme « very rough guideline » ; aucune étude ne justifie un ratio.
- « Les tests d'intégration trouvent d'autres bugs que les unitaires. » Par mutation, pas de type de
  défaut différent (Trautsch et al. 2020, résumé lu) : leur valeur est la fidélité à l'environnement.
- « Plus de couverture, moins de bugs. » Corrélation faible une fois la taille de la suite contrôlée ;
  chez Meta, près de la moitié des tests qui détectent une faute nouvelle n'ajoutent aucune ligne.
- « Le score de mutation mesure la capacité à trouver de vrais bugs. » Bon guide, mauvais objectif :
  faible une fois la taille contrôlée, et 17 % des fautes réelles sans mutant correspondant.
- « Google impose 80 % de couverture. » Pas de seuil imposé à l'échelle du code (Ivanković et al. 2019).
- « Toute relance automatique masque des bugs. » Une relance bornée et tracée classe un échec
  (1 à 3 suffisent) ; c'est la relance silencieuse qui masque.
- « Un test instable cache une race du produit. » 71 à 88 % des correctifs ne touchent que le test.
- « Le test par paires suffit. » Il peut manquer 10 à 40 % des défauts (NIST SP 800-142).
- « Un accès refusé par RLS lève une erreur. » En lecture et mise à jour, PostgreSQL rend 0 ligne en
  silence ; et un test lancé en propriétaire de la table contourne la RLS.
- « Le bénéfice du TDD vient du test écrit d'abord. » Fucci et al. 2017 l'attribuent à la granularité
  et à la régularité des cycles, pas à l'ordre.
- « Si le test généré passe, le code est juste. » Un test généré qui passe d'emblée est un oracle de
  régression : il fige le comportement observé, bug compris.
- « Un LLM peut vérifier un test en cassant le code de tête. » Le meilleur GPT-4 testé ne prédit
  juste la sortie de fonctions de quelques lignes que dans 81 % des cas (CRUXEval).

**Sécurité** — `references/securite-*.md`

- « A06, ce sont les composants vulnérables », « A05, c'est la mauvaise configuration ». Numérotation
  de 2021 : en 2025, A06 = Insecure Design, A05 = Injection, la chaîne d'approvisionnement est A03.
- « Le Top 10 OWASP est un standard d'audit » (document de sensibilisation, « the bare minimum »),
  « un CVSS élevé se corrige en premier » (autant tirer au hasard, Allodi et Massacci 2014),
  « risque = EPSS × CVSS » (« never a good idea », FIRST), « EPSS v4 est la version actuelle » (v5),
  « la BOD 22-01 fixe la règle KEV » (remplacée par la BOD 26-04).
- « Une alerte `npm audit` est une vulnérabilité de l'application », « `npm audit` à zéro veut dire
  des dépendances saines », « non atteignable, donc pas exploitable », « osv-scanner dit si c'est
  atteignable » (Go et Rust seulement).
- « Combiner tous les outils SAST donne une bonne couverture » (70,9 % des failles Java réelles
  encore manquées), « un relecteur expérimenté trouve tout » (aucun des 30 relecteurs n'a trouvé
  les 7 failles), « TruffleHog ne détecte que 25 % des secrets » (chiffre de 2019, obsolète).
- « La clé Supabase dans le front est une fuite » (faux pour la clé publishable, CRITIQUE pour la
  clé secrète), « une dépendance sans release depuis 2 ans est vulnérable » (rien ne le démontre).
- « On a force-pushé, le secret a disparu », « supprimer et recréer le dépôt suffit », « changer la
  variable sur Vercel suffit » (les anciens déploiements gardent l'ancienne valeur), « redémarrer
  l'appli coupe l'accès volé », « GitHub a prévenu le fournisseur, donc la clé est révoquée ».
- « Il faut faire tourner tous les secrets tous les 90 jours » (aucune norme lue ne le fixe), « Meli
  et al. ont mesuré l'exploitation » (ils mesurent la découverte, 20 s).
- « Sur Vercel, je suis protégé des failles Next.js » (vrai pour CVE-2025-29927, faux pour
  CVE-2025-55182), « `X-XSS-Protection` protège du XSS » (déprécié), « un mot de passe fort exige
  majuscule, chiffre et caractère spécial » (NIST l'interdit), « inutile de préciser `SameSite` »,
  « les secrets GitHub sont masqués dans les logs, donc sans risque », « les restrictions réseau
  Supabase protègent toute la base » (pas les API HTTPS).
- « Un bon prompt système empêche l'injection », « un détecteur qui bloque 95 % suffit », « la règle
  des trois propriétés suffit à sécuriser un agent » (son auteur dit que non), « le serveur MCP
  officiel est sûr, donc l'agent l'est », « Anthropic vérifie la sécurité des serveurs MCP de
  l'annuaire » (non), « les LLM sont devenus de bons détecteurs de vulnérabilités » (contesté).

**Architecture** — `references/architecture-*.md`

- « Les portes à sens unique viennent de la lettre de Bezos de 2016 » (lettre sur l'exercice 2015) ;
  « l'architecture, ce sont les décisions difficiles à changer, dit Ralph Johnson » (reformulation de
  Fowler) ; « la règle de trois vient de Fowler » (il l'attribue à Don Roberts).
- « Un ADR doit toujours lister les alternatives » (Nygard, AWS et GOV.UK ne l'exigent pas ; la
  recherche sur les biais le justifie), « un ADR accepté est immuable » (les guides divergent),
  « ISO/IEC/IEEE 42010 impose les ADR » (non), « les ADR sont un standard de l'industrie » (adoption
  faible mesurée dans l'open source).
- « Il suffit d'expliquer les biais pour s'en protéger. » Inefficace mesuré ; seuls des gestes
  obligatoires (options multiples, inconvénient explicite) ont un effet.
- « Dernier moment responsable = décider le plus tard possible. » Contesté : c'est le moment où une
  alternative importante disparaît.
- « Un défaut d'exigence coûte 100 fois plus cher en production. » Aucun effet général sur 171 projets
  (Menzies et al.).
- « ISO 25010 = utilisabilité et portabilité » (édition 2011), « DORA = quatre métriques » (cinq),
  « les CRDT font disparaître les conflits » (ils les conservent), « l'ATAM a prouvé son
  efficacité », « STRIDE trouve les menaces » (beaucoup restent non détectées).
- « Amazon Prime Video a abandonné les microservices » (un seul service), « MonolithFirst est
  démontré » (« the evidence is sparse », Fowler), « toutes les plateformes recommandent le monolithe »
  (AWS dit l'inverse), « DORA montre que les microservices améliorent la livraison » (DORA mesure le
  couplage faible), « la loi de Conway est universelle » (thèse sans données, soutien partiel).
- « La dette technique, c'est du code sale écrit vite » (Cunningham dit le contraire), « les
  développeurs perdent 23 % de leur temps à cause de la dette » (estimation déclarée), « plus un
  fichier change, plus il est bogué » (seul le churn relatif prédit), « le bon design paie toujours »
  (« no objective proof », Fowler).
- « Un bon score OpenSSF Scorecard veut dire une dépendance sûre » (R² de 9 à 12 %), « 85 % des
  paquets npm ne sont pas maintenus » (au sens d'un seul check), « 81,5 % des systèmes gardent des
  dépendances obsolètes » (indicateur moyen, Java), « Supabase est open source, donc pas de
  verrouillage » (l'auto-hébergé n'a pas tout), « les changements de licence sont définitifs ».
- « Le CRA s'applique à toute application web vendue dans l'UE » (considérant 12), « le CRA n'oblige
  à rien avant décembre 2027 » (signalement depuis le 11.09.2026).
- « Le pre-mortem augmente de 30 % les risques identifiés » (chiffre non retrouvé dans l'étude),
  « 16 % des projets réussissent » (Standish, contesté), « 64 % des fonctionnalités ne servent
  jamais », « une matrice probabilité × impact objective le risque » (Cox 2008), « les projets
  informatiques dépassent toujours » (médiane 1,0, mais queue épaisse), « l'optimisation prématurée
  est la racine de tous les maux », cité sans la suite de Knuth.

**Backend** — `references/backend-*.md`

- « bcrypt est le choix par défaut », « `crypto.scrypt` natif suffit tel quel ». OWASP réserve bcrypt
  à l'existant et met Argon2id en premier ; le `scrypt` de Node par défaut est sous le plancher OWASP,
  et l'atteindre exige de relever `maxmem`.
- « Un secret de 32 caractères = 256 bits. » 32 caractères hexadécimaux font 128 bits ; il faut
  32 octets d'un générateur cryptographique.
- « 8 caractères minimum et des caractères spéciaux. » NIST SP 800-63B-4 : 15 en facteur unique,
  aucune règle de composition, aucune rotation forcée.
- « SameSite=Lax est le défaut, le CSRF est réglé », « des UUID rendent l'IDOR impossible ».
  Faux : Firefox et Safari ne traitent pas l'absence de `SameSite` comme Lax ; un UUID n'est pas un
  contrôle d'accès. « Les en-têtes RateLimit et `Idempotency-Key` sont standardisés » : brouillons
  IETF.
- « Le MFA stoppe 99,9 % des compromissions. » Affirmation d'éditeur, source primaire non lue.
- « 92 % des pannes viennent d'une mauvaise gestion d'erreur. » 92 % des pannes **catastrophiques**
  (48 sur 198), dans cinq systèmes distribués (Yuan et al. 2014).
- « Commiter puis envoyer l'e-mail, c'est sûr », « les retries rendent le système plus fiable »,
  « le backoff exponentiel suffit ». Contredits : crash entre commit et envoi, pannes métastables,
  rafales sans jitter.
- « Le timeout par défaut du client HTTP me protège. » undici : 300 s entre deux morceaux, aucune
  borne totale.
- « 422 est le code normalisé de la validation », « le versionnement par URL est la norme ». Les
  guides se contredisent.
- « `ADD COLUMN … DEFAULT` réécrit la table » (faux depuis PostgreSQL 11 pour un DEFAULT constant),
  « renommer une colonne est lourd » (métadonnées seulement ; le code déployé casse), « Serializable
  règle la concurrence sans rien changer » (rejouer les 40001), « l'upsert de l'ORM protège des
  doublons » (seulement sur un index unique).
- « La RLS protège la table quoi qu'il arrive. » Propriétaire, `BYPASSRLS`, clé secrète et vues la
  contournent.
- « SQLite n'est pas fait pour la production. » Contesté par sqlite.org ; c'est « SQLite en dev,
  Postgres en prod » qui pose problème.
- « `npm install prisma` installe la version stable », « Drizzle est en 1.0 ». Faux au 09.11.2026.
- « Node exécute TypeScript, plus besoin de `tsc` », « le modèle de permissions de Node isole une
  dépendance malveillante ». Contredits par la doc Node.
- « L'injection SQL est la faille typique du code backend généré », « un rappel de sécurité dans le
  prompt suffit », « un analyseur statique vert prouve la sûreté ». Contredits (BaxBench, SusVibes,
  CWEval).
- « En Suisse, une fuite s'annonce en 72 heures. » La LPD dit « dans les meilleurs délais », pour un
  risque élevé ; 72 heures est le RGPD.
- « La nLPD impose de journaliser tous les accès et de garder les logs un an. » Seulement dans les
  cas de l'OPDo art. 4 (données sensibles à grande échelle, profilage à risque élevé).
- « Hacher l'identifiant anonymise les journaux », « une colonne `deleted_at` répond au droit à
  l'effacement ». Pseudonymisation n'est pas anonymisation ; la suppression logique est une
  restriction temporaire.
- « Le RGPD ne concerne pas un développeur établi en Suisse. » Pas nécessairement (art. 3 par. 2) :
  question de juriste.

**Méthodes** — `references/normes-lois-methodes.md`

- « Cinq utilisateurs trouvent 85 % des problèmes. » Valable pour un test qualitatif, un seul
  profil, des tâches fermées ; selon le tirage, de 55 % à presque 100 % (Faulkner 2003).
- « Un SUS de 70, c'est 70 % d'utilisabilité. » « It isn't a percentage » : 68 est le 50e centile
  (Sauro 2011).
- « Le premier clic prédit la réussite à 87 %. » Réplication sur 750 participants : 78 % contre 70 %.
- « On arrête un A/B dès qu'il est significatif. » Inférence « wholly unreliable » (Johari et al.).
- « ISO 9241-110 : individualisation, tolérance aux erreurs. » Liste périmée depuis l'édition 2020.

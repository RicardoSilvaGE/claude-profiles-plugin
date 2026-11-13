# Faire produire du beau à une IA : preuves et consignes pour graphiste

> Recherche documentaire du **13.11.2026**. Axe 4 : comment amener un modèle de langage à produire un design visuel de haute qualité, puis à juger son propre rendu.
> Échelle de preuve : celle du skill `ux-preuves` (N1 norme, N2 recherche revue par les pairs ou étude à méthode publiée, N3 guide officiel, N4 avis de praticien, N0 jugement déclaré). Un guide d'éditeur sans mesure publiée est classé **N3 « sans mesure »**. Un préprint dont seul le résumé a été lu est classé N4, sauf mention contraire motivée.
> Déjà couvert ailleurs et **non refait** ici : homogénéisation mesurée (Doshi & Hauser, Anderson et al., Hintze et al., Design Theater, vibe coding, accessibilité des UI générées), fixation sur les images générées (`design-front-recent.md` § 3-4) ; évaluateur qui se loue, auto-préférence du juge, ordre des réponses, persona qui ne rend pas plus juste (`ia-profils-*.md`). Ces fiches sont citées par renvoi.

## Avertissements de portée, valables pour tout le fichier

- **Web vers mobile.** Presque toutes les sources portent sur des pages web : landing, hero, tableau de bord. Seuls UICrit (983 écrans mobiles) et, en partie, les guides Lovable et Figma touchent au mobile. Transposer à des écrans de téléphone est une inférence, signalée entrée par entrée.
- **Pas de mouvement.** graphiste rend des PNG. Les consignes de motion des sources (chargement orchestré, survol) sont écartées, sauf quand elles disent quelque chose de la composition statique.
- **Les guides d'éditeurs ne publient aucune mesure.** Anthropic, OpenAI, Google, Lovable et Figma décrivent ce qui marche selon eux, avec des captures avant/après. Aucun ne donne de protocole ni de chiffre. Leur valeur est d'être écrits par ceux qui entraînent ou outillent les modèles, pas d'être prouvés.
- **Citations.** Les citations mot pour mot viennent de textes lus en brut : fichiers SKILL.md téléchargés, pages de documentation Anthropic, résumé arXiv de Huang et al. Les autres sources sont paraphrasées.
- **Seuils des consignes.** Les nombres propres aux consignes « Pour graphiste » (deux axes d'écart, cinq à huit partis, largeurs de 360 et 430 points, arrêt après trois tours sans gain) sont des choix de cette recherche (N0), pas des valeurs tirées des sources. Les seuils de contraste et de cibles tactiles viennent des fiches existantes citées à l'endroit où ils servent.

---

## 1. Ce que disent les éditeurs : diriger le modèle hors de son centre

### Le modèle tire vers le centre de sa distribution : sans direction, il produit l'interface moyenne
- **Ce que dit la source.** Anthropic nomme le phénomène « Distributional convergence. » Les choix de design sûrs, ceux qui marchent partout et ne déplaisent à personne, dominent les données d'entraînement. Le modèle y retombe tant que rien ne l'en écarte. Le cookbook donne trois leviers : guider des dimensions précises (typographie, couleur, fonds), citer des inspirations (thèmes d'IDE, esthétiques culturelles) sans les prescrire, et nommer les défauts à éviter.
- **Référence.** Anthropic (P. Rajasekaran, J. Wei, A. Bricken et al.), 12.11.2025, « Improving frontend design through Skills », https://claude.com/blog/improving-frontend-design-through-skills. P. Rajasekaran, 21.10.2025, « Prompting for frontend aesthetics », Claude Cookbook, https://platform.claude.com/cookbook/coding-prompting-for-frontend-aesthetics. Lus le 13.11.2026 ; l'expression citée a été vérifiée dans le HTML brut du blog.
- **Niveau.** N3 sans mesure : captures avant/après, aucune métrique.
- **Limites.** Exemples uniquement web (landing SaaS, blog, tableau de bord). Le diagnostic rejoint les mesures N2 déjà en fiche (`design-front-recent.md` § 3), qui portent toutefois sur d'autres tâches.
- **Pour graphiste :** « Avant de dessiner, écris en une ligne ce que produirait un générateur sans consigne pour ce brief : c'est ta ligne de base, pas ta proposition. Chaque variante doit s'en écarter sur au moins deux axes parmi fond, couleur d'accent, typographie et composition, et dire lesquels. »

### Chaque parade nommée devient le défaut suivant : la liste des signes d'Anthropic a connu trois versions en neuf mois
- **Ce que dit la source.** Le skill `frontend-design` publié par Anthropic a été réécrit le 9 juin et le 3 septembre 2026. Les trois versions ont été lues.
  - **Décembre 2025 :** il proscrit Inter, Roboto, Arial et les polices système, ainsi que les dégradés violets sur fond blanc. Il recommande d'associer une police de titre distinctive à une police de texte raffinée, et de créer des fonds riches (grain, maillages de dégradés, ombres dramatiques). Il signale déjà que Space Grotesk revient d'une génération à l'autre.
  - **Juin 2026 :** trois « looks » sont désormais décrits comme des défauts : fond crème près de #F4F1EA avec serif contrastée et accent terracotta, fond presque noir avec un seul accent vert acide ou vermillon, mise en page de journal à filets fins.
  - **Septembre 2026 :** deux familles s'ajoutent. Le kit de cartes SaaS : cartes arrondies identiques, même ombre grise, dégradés en décor. Les accessoires de gabarit : surtitre en capitales espacées, séparateurs « · », police mono pour les petites étiquettes, flèche « → » ajoutée aux liens. Le skill note que l'accent #D97757 est la couleur d'Anthropic elle-même, donc un signe. Il dit de ces traits : « they are defaults rather than choices ».
- **Référence.** Anthropic, `skills/frontend-design/SKILL.md`, dépôt https://github.com/anthropics/skills : commit `0075614` (04.12.2025), `2235be7` (09.06.2026), `41bbe19` (03.09.2026, PR #1713). Lus le 13.11.2026. Le chemin cité par la documentation, `anthropics/claude-code/plugins/frontend-design/...`, renvoyait une 404 ce jour-là.
- **Niveau.** N3 sans mesure pour le contenu. **N0** pour le lien causal : aucune source ne dit que la consigne de 2025 a produit le look de 2026. La succession est seulement compatible avec cette lecture.
- **Limites.** Les signes listés sont ceux de Claude, observés par Anthropic, sans chiffre de fréquence. Un autre modèle a d'autres défauts.
- **Pour graphiste :** « Ne remplace pas un défaut par son contraire à la mode : ni la crème et la serif, ni le noir et l'accent acide ne sont des parades à Inter et au violet. Si ta variante tombe dans l'un des looks listés au § 6, il faut que le brief la justifie, et tu l'écris. »

### Une interdiction vague déplace vers un autre défaut fixe : nommer précisément, ou spécifier l'alternative
- **Ce que dit la source.** Pour Opus 4.8, la documentation décrit un style maison : fond crème vers #F4F1EA, titres en serif (Georgia, Fraunces, Playfair), mots isolés en italique, accent terracotta. Elle ajoute : « This default is persistent. » Une consigne générique comme « pas de crème » ou « fais propre et minimal » a tendance « to shift the model to a different fixed palette rather than producing variety ». La page Sonnet 5 dit la même chose. Pour Opus 5.5, une consigne du type « évite le look IA » « mostly swaps one default for another ». En revanche, le modèle répond bien quand on nomme des motifs précis à éviter, et la page conseille de procéder par itération : « check which styles the first result used instead, and extend the list ». Deux voies sont décrites comme fiables : spécifier une alternative concrète (atmosphère, hex, rayon, police, structure), ou faire proposer plusieurs directions avant de construire.
- **Référence.** Anthropic, documentation API, « Prompting Claude Opus 4.8 », « Prompting Claude Sonnet 5 », « Prompting Claude Opus 5.5 », sections « Design and frontend defaults », https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/ (pages `prompting-claude-opus-4-8`, `prompting-claude-sonnet-5`, `prompting-claude-opus-5-5`). Lues le 13.11.2026.
- **Niveau.** N3 sans mesure (« two approaches work reliably », sans chiffre).
- **Limites.** Ces pages contredisent en partie un principe général déjà en fiche, selon lequel nommer la chose interdite peut l'amorcer (`ia-profils-consignes.md` § 3). Elles se concilient : une négation **vague** déplace le défaut, une négation **précise et vérifiable** marche sur ces modèles. Le comportement change d'un modèle à l'autre et se re-teste.
- **Pour graphiste :** « Donne la direction par ce qu'elle est, pas par ce qu'elle n'est pas : un fond en hex, un accent en hex, une police nommée, un rayon en px, une image d'atmosphère en une phrase. Pour exclure un trait, nomme-le précisément (« pas de surtitre en capitales espacées »), jamais en catégorie (« pas de look IA »). »

### Pour obtenir des variantes vraiment différentes, poser les directions avant de construire
- **Ce que dit la source.** Les pages Opus 4.8 et Sonnet 5 donnent un gabarit : proposer quatre directions visuelles adaptées au brief, chacune en hex de fond, hex d'accent, police et justification d'une ligne, puis n'en construire qu'une. Sur Sonnet 5, c'est la voie recommandée pour obtenir des directions distinctes d'une exécution à l'autre, puisque la température n'y est plus réglable. Lovable fait la même chose dans son produit : avant de construire, trois questions de design (palette en nuanciers, paires de polices, mises en page en wireframes), quatre options au plus chacune, la première présélectionnée.
- **Référence.** Anthropic, pages citées à l'entrée précédente, lues le 13.11.2026. Lovable, « Design guidance », https://docs.lovable.dev/features/design-guidance, lu le 13.11.2026.
- **Niveau.** N3 sans mesure.
- **Limites.** Chez Lovable, l'option présélectionnée est un défaut de plus. Rien ne dit comment les quatre directions sont rendues distinctes entre elles.
- **Pour graphiste :** « Avant le premier pixel, écris tes 2 ou 3 directions sous forme de fiches : fond, accent, police, parti de composition, et une phrase qui dit ce qui la distingue des autres. Si deux fiches ne diffèrent que par la teinte, l'une des deux est à refaire. Ne construis qu'ensuite. »

### Planifier en jetons, relire le plan contre le brief, puis seulement coder
- **Ce que dit la source.** La version de septembre 2026 du skill impose deux passes. D'abord un plan compact : palette de 4 à 6 hex nommés, polices et leurs rôles, concept de mise en page en une phrase et en wireframe ASCII, principes propres à la page. Ensuite, relire ce plan contre le brief. Toute partie qui ressemble au défaut qu'on produirait pour une page voisine est révisée, avec le changement et sa raison. On ne code qu'après. Le skill conseille aussi de travailler un brief similaire pour voir si l'on aboutit au même endroit. OpenAI recommande de même de fixer en amont des tokens (fond, surface, texte principal et secondaire, accent) et des rôles typographiques (display, titre, corps, légende).
- **Référence.** Anthropic, SKILL.md commit `41bbe19`, déjà cité, lu le 13.11.2026. OpenAI, « Designing delightful frontends with GPT-5.4 », https://developers.openai.com/blog/designing-delightful-frontends-with-gpt-5-4, lu le 13.11.2026 (auteur et date non visibles dans le texte lu).
- **Niveau.** N3 sans mesure.
- **Limites.** Le test « un brief voisin aboutirait-il au même plan ? » est un jugement du modèle sur lui-même, que rien ne valide.
- **Pour graphiste :** « Écris le plan de chaque variante avant le HTML : 4 à 6 couleurs en hex nommées par rôle, une ou deux polices avec leur rôle, la composition en trois lignes. Puis demande-toi pour chaque ligne : la mettrais-je aussi dans une app de fitness, de banque ou de recettes ? Si oui, change-la et note pourquoi. »

### Ancrer la direction dans le monde du sujet et dans ses vraies données
- **Ce que dit la source.** Le skill d'Anthropic place la source des choix distinctifs dans l'industrie du sujet, ses matériaux et son vocabulaire. Un jouet pour filles de 8 à 11 ans et un tableau de bord d'analystes financiers ne se ressemblent pas. Il demande de construire avec le vrai contenu du brief, et note que le texte inventé peut rendre une page aussi générique que son graphisme. OpenAI dit que fournir de vrais textes et le contexte du produit réduit les formulations génériques et améliore la structure.
- **Référence.** Anthropic, SKILL.md `41bbe19` ; OpenAI GPT-5.4, déjà cités. Lus le 13.11.2026.
- **Niveau.** N3 sans mesure.
- **Limites.** Aucune mesure de l'effet du contenu réel sur la qualité perçue.
- **Pour graphiste :** « Tire au moins un choix visuel de chaque variante d'un objet réel du domaine de l'app : matière, outil, document, lieu. Écris d'où il vient. Remplis les écrans avec les vraies données quand elles existent, sinon avec des données plausibles du domaine, jamais avec du "Lorem" ou "Item 1". »

### Concentrer l'audace sur un seul élément, et garder le reste discipliné
- **Ce que dit la source.** Le skill dit : « Spend your boldness in one place. » Un élément mémorable, le reste calme ; on coupe toute décoration qui ne sert pas le brief. Il reprend le conseil attribué à Chanel : se regarder dans le miroir et retirer un accessoire. Il ajoute : « Visual structure is information. » Bordures, numéros, surtitres et séparateurs doivent dire quelque chose du contenu ; une numérotation 01/02/03 ne vaut que pour une vraie séquence.
- **Référence.** Anthropic, SKILL.md `41bbe19`, lu le 13.11.2026.
- **Niveau.** N3 sans mesure.
- **Limites.** Avis de l'éditeur, sans test. La règle rejoint toutefois des principes plus anciens de hiérarchie visuelle (`design-typographie-mise-en-page.md`).
- **Pour graphiste :** « Dans chaque variante, désigne l'élément signature, un seul, et écris-le sous la vignette. Avant de rendre, retire un ornement : une bordure, un badge, une ombre, un surtitre. Si l'écran ne perd rien, il ne revient pas. »

### Une carte doit contenir une interaction ; sinon on la retire
- **Ce que dit la source.** OpenAI : pas de cartes par défaut. Une carte n'est justifiée que comme conteneur d'une interaction ; si la retirer ne nuit pas à la compréhension, on la retire. Dans les interfaces produit, le guide rejette les mosaïques de cartes, les bordures épaisses partout, les dégradés décoratifs derrière l'interface courante et la multiplication des accents. Il demande aussi des budgets explicites : deux familles de polices, une couleur d'accent, un appel à l'action principal.
- **Référence.** OpenAI, « Designing delightful frontends with GPT-5.4 », déjà cité, lu le 13.11.2026.
- **Niveau.** N3 sans mesure.
- **Limites.** Les règles du hero (image bord à bord, rien par-dessus) visent des pages marketing et ne se transposent pas à un écran d'application.
- **Pour graphiste :** « Avant de poser une carte, nomme l'action qu'elle contient. Sans action, présente l'information par la typographie, l'espacement ou un filet. Un écran de téléphone fait d'une pile de cartes arrondies identiques est la composition par défaut. »

### Une image de référence se reproduit mal : dire si on la copie ou si on s'en inspire, et la traduire en jetons
- **Ce que dit la source.** OpenAI recommande des captures et des mood boards : le modèle en déduit le rythme, l'échelle typographique et l'espacement. Figma demande de préciser dans le prompt si l'image doit être reproduite à l'identique ou servir de référence de style, et de joindre une ou deux maquettes à la fois. Le modèle en tire mise en page, couleurs et positions, mais le résultat peut s'écarter de l'original. Design2Code mesure ce défaut sur 484 pages web réelles : les modèles multimodaux ratent surtout le rappel des éléments visuels et la mise en page.
- **Référence.** Figma, « Attach files to a prompt in the Figma agent and Figma Make », https://help.figma.com/hc/en-us/articles/31304529835671 (sans date visible), lu le 13.11.2026. OpenAI GPT-5.4, déjà cité. C. Si, Y. Zhang, R. Li, Z. Yang, R. Liu, D. Yang, « Design2Code: Benchmarking Multimodal Code Generation for Automated Front-End Engineering », NAACL 2025, https://arxiv.org/abs/2403.03163, résumé seul lu le 13.11.2026.
- **Niveau.** N3 sans mesure (OpenAI, Figma) ; N2 pour Design2Code (actes NAACL, résumé seul lu).
- **Limites.** Montrer une image ancre aussi l'idéation : la fixation est mesurée chez les designers (`design-front-recent.md` § 4, Wadinambiarachchi et al.).
- **Pour graphiste :** « Quand on te fournit une référence, écris ce que tu en retiens (palette en hex, police, densité, rayon, traitement d'image) et ce que tu laisses. Dessine ensuite depuis cette fiche, pas depuis l'image. Ne montre jamais une référence comme si c'était une variante. »

### Une fois la direction choisie, la fixer dans un fichier que les sessions suivantes relisent
- **Ce que dit la source.** Google Labs a publié comme spécification provisoire DESIGN.md, un format qui porte les règles de design d'un projet et leur raison d'être, pour que l'agent sache à quoi sert une couleur au lieu de le deviner. Lovable conseille d'enregistrer polices, couleurs et mots-clés de style dans les instructions du projet. v0 permet d'enseigner une fois un design system (dépôt, Storybook, cadres Figma) et de l'attacher aux prompts.
- **Référence.** C. Xu (Google Labs), 21.04.2026, « Stitch: DESIGN.md », https://blog.google/innovation-and-ai/models-and-research/google-labs/stitch-design-md/, lu le 13.11.2026. Lovable, « Design guidance », déjà cité. v0, pages « Design Systems » (miroirs de la documentation vus en résultats de recherche ; page officielle non ouverte).
- **Niveau.** N3 sans mesure.
- **Limites.** Le contenu exact de la spécification DESIGN.md n'a pas été lu (le billet ne le détaille pas). La règle sert la cohérence, pas l'originalité.
- **Pour graphiste :** « Quand l'utilisateur choisit une variante, écris sa fiche (hex par rôle, polices, rayon, échelle d'espacement, élément signature, ce qu'elle refuse et pourquoi) dans le dépôt, à l'endroit où `designer` la reprendra. La variante choisie se transmet par cette fiche, pas par la capture. »

### Les guides se contredisent sur les fonds, les polices et la mono : trancher par le plus récent et le plus proche du support
- **Ce que dit la source.** Points de désaccord relevés en lisant :

| Sujet | Avant | Plus récent |
|---|---|---|
| Fonds | Skill déc. 2025, cookbook oct. 2025 : créer de l'atmosphère, éviter la couleur unie (dégradés superposés, grain, motifs). OpenAI GPT-5.4 : pas de fond uni et plat. | Skill sept. 2026 : les dégradés décoratifs font partie du kit générique ; un fond sert le brief ou disparaît. |
| Nombre de polices | Skill déc. 2025 : une police de titre distinctive et une police de texte. Blog nov. 2025 : une seule police distinctive, utilisée avec décision. | Skill sept. 2026 : une famille ou deux, et si deux, nettement distinctes ; pas besoin d'une police de titre à part. |
| Police mono | Blog nov. 2025 : JetBrains Mono, Fira Code, Space Grotesk parmi les choix suggérés pour un style « code ». | Skill sept. 2026 : la mono pour les petites étiquettes de données est un accessoire générique. Opus 5.5 : liste les étiquettes mono parmi les traits à exclure. |
| Serif de titre | Blog nov. 2025 : Playfair Display, Crimson Pro suggérées pour l'éditorial. | Opus 4.8 : serif display (Georgia, Fraunces, Playfair) dans le style maison par défaut. |

- **Référence.** Sources de ce § 1, toutes lues le 13.11.2026.
- **Niveau.** N0 pour l'arbitrage. Il applique la règle du skill `ux-preuves` : la source la plus proche du contexte d'abord, puis la plus récente.
- **Limites.** Le plus récent n'est pas mieux prouvé que l'ancien : aucun n'est mesuré. La liste de 2026 sera périmée à son tour.
- **Pour graphiste :** « Une liste de polices "à préférer" lue quelque part n'est pas une direction : ce qui était distinctif en 2025 est un défaut en 2026. Choisis la police pour le sujet, puis vérifie qu'elle n'est pas dans la liste du § 6. »

---

## 2. Juger son propre rendu : ce que vaut un modèle vision-langage comme juge

### Les VLM généralistes départagent la qualité de deux interfaces à peine mieux que le hasard
- **Ce que dit la source.** UIClip compare des paires d'interfaces jugées par des designers. GPT-4V choisit la meilleure dans environ 52 % des cas et LLaVA dans environ 55 %. UIClip, un modèle spécialisé entraîné sur 2,3 millions d'exemples synthétiques et des notes de 12 designers, atteint environ 75 %. Les auteurs décrivent les grands VLM comme souvent au niveau du hasard sur l'évaluation de la qualité. Ils relèvent aussi un biais : certains modèles récitent presque toujours les quatre principes CRAP, ce qui gonfle leur rappel apparent.
- **Référence.** J. Wu et al., « UIClip: A Data-driven Model for Assessing User Interface Design », UIST 2024 (DOI 10.1145/3654777.3676408 vu en résultat de recherche), https://arxiv.org/abs/2404.12500, v1 lue le 13.11.2026.
- **Niveau.** N2.
- **Limites.** Modèles de 2024 (GPT-4V), écrans web et applications. Aucun Claude récent n'est testé. L'accord entre designers est lui-même faible (alpha de Krippendorff 0,37).
- **Pour graphiste :** « Ne prends pas ta propre impression "c'est beau" comme une preuve. Quand tu compares tes variantes, compare-les deux à deux, sur un critère nommé à la fois (lisibilité du chiffre clé, singularité, cohérence de palette), et écris ce qui fait la différence. »

### Un MLLM juge suit assez bien l'impression d'intérêt et d'esthétique, pas l'utilisabilité, la hiérarchie ni le confort
- **Ce que dit la source.** Sur 30 interfaces et 9 296 réponses humaines retenues, les auteurs comparent les notes de Claude 3.5 Sonnet, GPT-4o et Llama-3.2 à celles des humains, sur neuf dimensions. Pour Claude, la corrélation est forte sur « intéressant » (0,85) et moyenne sur le plaisir esthétique (0,62). Elle est nulle ou négative sur la facilité d'utilisation (-0,05), la hiérarchie visuelle (-0,14), l'intuitivité (-0,02) et le confort (-0,12). Les modèles surnotent la facilité d'utilisation, sous-notent l'émotionnel, et leurs notes varient moins que celles des humains. Conclusion des auteurs : utile pour un tri précoce, pas pour remplacer une évaluation humaine.
- **Référence.** R. A. Luera et al., 09.10.2025, « MLLM as a UI Judge: Benchmarking Multimodal LLMs for Predicting Human Perception of User Interfaces », https://arxiv.org/abs/2510.08783, texte HTML lu le 13.11.2026.
- **Niveau.** N2 (préprint, méthode et données publiées, grand échantillon de réponses).
- **Limites.** Seulement 30 interfaces, statiques et occidentales, crowdworkers MTurk. Pas de travail sur le prompting. L'article donne deux fourchettes d'erreur moyenne différentes selon la section.
- **Pour graphiste :** « Sers-toi de ton regard sur le PNG pour l'impression d'ensemble : est-ce que ça donne envie, est-ce que ça a du caractère. Ne t'en sers pas pour conclure qu'un écran est facile à utiliser ou bien hiérarchisé : ces deux points se vérifient par une mesure (§ 7) ou par le choix de l'utilisateur. »

### Le goût varie entre designers : se calibrer sur les choix de l'utilisateur, pas sur un consensus
- **Ce que dit la source.** Deux jeux de données mesurent un faible accord entre designers professionnels. UIClip : alpha de Krippendorff 0,37 (12 designers). DesignPref : alpha 0,25 sur 12 000 comparaisons de 20 designers. Dans UICrit, l'accord entre les annotateurs chargés de juger les critiques n'est lui aussi que « passable » (kappa de Fleiss d'environ 0,3), et les auteurs rappellent que l'évaluation de design est subjective par nature. DesignPref ajoute que des modèles personnalisés par designer, par ajustement fin ou par récupération des annotations de ce designer, battent les modèles agrégés, même avec 20 fois moins d'exemples.
- **Référence.** P. Duan et al., « UICrit », UIST 2024, https://arxiv.org/abs/2407.08850 (HTML v3 lu le 13.11.2026). UIClip, déjà cité. « DesignPref », préprint arXiv:2511.20513, 25.11.2025, https://arxiv.org/abs/2511.20513, résumé seul lu le 13.11.2026.
- **Niveau.** N2 pour UICrit et UIClip ; N4 pour DesignPref (préprint, résumé seul lu).
- **Limites.** Accord mesuré sur des notes ou des paires, pas sur des écrans faits pour un utilisateur précis.
- **Pour graphiste :** « Tiens un court journal des choix de l'utilisateur : variante retenue, variante écartée, la raison qu'il donne. Relis-le avant chaque nouvelle planche, et cite la ligne qui a guidé un choix. Une préférence de l'utilisateur l'emporte sur une règle générale de goût, jamais sur le contraste ou la taille des cibles. »

### Une critique sans exemple est faible ; des exemples choisis par ressemblance et des repères de coordonnées l'améliorent
- **Ce que dit la source.** Sur 983 écrans mobiles, Gemini Pro Vision en zero-shot produit 5 927 commentaires, dont 13,1 % seulement sont validés. Avec huit exemples choisis par ressemblance de tâche et d'apparence, et des coordonnées tracées sur les bords de la capture, la note de qualité des critiques passe de 0,31 à 0,48, soit environ +55 %. Les critiques humaines restent à 0,75. Les grilles superposées à l'image dégradent la localisation ; les coordonnées en bordure et les découpes l'améliorent.
- **Référence.** P. Duan, C.-Y. Chen, G. Li, B. Hartmann, Y. Li, « UICrit: Enhancing Automated Design Evaluation with a UI Critique Dataset », UIST 2024, https://arxiv.org/html/2407.08850v3, lu le 13.11.2026.
- **Niveau.** N2.
- **Limites.** Gemini Pro Vision de 2024, sept designers seulement. Les critiques n'ont pas été appliquées, donc leur utilité n'est pas mesurée. Des hallucinations persistent.
- **Pour graphiste :** « Pour critiquer ta planche, garde à portée deux ou trois écrans de référence du même type (même tâche, même famille visuelle) que l'utilisateur a aimés, et compare-toi à eux point par point. Chaque critique désigne une zone précise de l'écran, pas l'écran entier. »

### Les défauts fins d'affichage échappent aux MLLM : débordements, chevauchements, incohérences de texte
- **Ce que dit la source.** UI-Lens compte 4 759 pages en chinois, annotées par des designers selon six catégories de défauts d'affichage. Sur dix modèles, le F1 moyen est de 20,36 % pour le texte qui déborde, 31,21 % pour les conteneurs qui se chevauchent et 10,61 % pour les incohérences de texte. Sur les tâches de frontières fines, les auteurs jugent la performance proche du hasard.
- **Référence.** Xiang et al., « UI-Lens: Assessing General MLLMs' Potential to Automate UI Display Quality Assurance », CVPR 2026, https://cvpr.thecvf.com/virtual/2026/poster/38861, résumé seul lu le 13.11.2026 (texte complet refusé par le serveur, 403).
- **Niveau.** N2 (actes CVPR, résumé seul lu).
- **Limites.** Interfaces en chinois. Les modèles testés ne sont pas nommés dans le résumé.
- **Pour graphiste :** « Ne conclus jamais "aucun texte ne déborde" ou "rien ne se chevauche" en regardant le PNG. Vérifie-le dans le navigateur par les boîtes des éléments (§ 7) avant de livrer. »

### La vision des modèles cède quand les formes se touchent ; elle redevient fiable quand on les écarte ou qu'on zoome
- **Ce que dit la source.** BlindTest pose sept tâches visuelles triviales pour un humain : deux cercles se chevauchent-ils, combien de fois deux lignes se croisent-elles. Quatre VLM de pointe y obtiennent en moyenne 58,07 %, le meilleur (Claude 3.5 Sonnet) 77,84 %. Les erreurs se concentrent quand les formes se chevauchent ou sont proches ; avec beaucoup plus d'espace, la précision approche 100 %. Les modèles à raisonnement long n'y échappent pas.
- **Référence.** P. Rahmanzadehgervi, L. Bolton, M. R. Taesiri, A. T. Nguyen, « Vision language models are blind », arXiv:2407.06581, v6 du 27.03.2025, https://arxiv.org/abs/2407.06581v6, résumé lu le 13.11.2026. Les chiffres diffèrent selon les versions : ceux de la v6 sont retenus. Un PDF ACCV 2024 existe chez CVF (vu en résultat de recherche), mais la page arXiv ne confirme pas cette publication.
- **Niveau.** N2.
- **Limites.** Formes géométriques, pas des interfaces. Modèles de 2024 ; Anthropic annonce depuis de nets progrès (entrée suivante), sans chiffre comparable sur ce banc.
- **Pour graphiste :** « Pour juger un détail (alignement, coin, espacement entre deux éléments proches), découpe et agrandis la zone avant de la regarder. Ne juge pas un détail sur la planche entière. »

### Ce que l'image devient avant que le modèle la voie : redimensionnement, coordonnées approximatives, découpe utile
- **Ce que dit la source.** La documentation vision d'Anthropic donne une limite de résolution par modèle. Pour Claude 4.7 et suivants, elle est de 2 576 px sur le grand côté et 4 784 jetons visuels, un jeton couvrant un carré de 28 × 28 px. Au-delà de l'une ou l'autre, l'image est réduite. Le guide signale que la réduction peut rendre un texte moins lisible, et qu'une compression JPEG forte crée des artefacts. Dans ses limites, la page indique que « Claude's coordinate and localization outputs are approximate. », et que les comptages ne sont pas toujours exacts. Pour Opus 5.5, la page de prompting dit que la lecture des captures a nettement progressé. Pour les entrées les plus denses, deux choses aident encore : une meilleure résolution, et des outils de traitement d'image « so that it can crop, zoom, measure, and verify its work ».
- **Référence.** Anthropic, « Vision », https://platform.claude.com/docs/en/build-with-claude/vision ; « Prompting Claude Opus 5.5 », § « Tools for complex visual inputs ». Lus le 13.11.2026.
- **Niveau.** N3 (tests internes non publiés).
- **Limites.** Ces seuils valent pour l'API. Le traitement exact d'un PNG lu par Claude Code n'a pas été vérifié.
- **Pour graphiste :** « Rends chaque écran dans son propre PNG, à la taille d'un téléphone (par exemple 390 × 844 points) avec un facteur de densité de 2. Garde la planche assemblée pour l'utilisateur, pas pour ton jugement : une planche de trois écrans haute densité dépasse le budget et sera réduite. Pour un détail, découpe la zone. Ne déduis jamais une distance en pixels de ton regard : mesure-la. »

### Le contraste ne se juge pas à l'œil du modèle : aucun banc fiable trouvé, le calcul s'impose
- **Ce que dit la source.** Aucune étude mesurant la précision d'un VLM à estimer un rapport de contraste sur capture n'a été trouvée. Les pratiques décrites par des guides de praticiens et un billet Microsoft calculent le rapport par code, à partir des couleurs ou des pixels, et réservent le modèle au repérage. Une étude déjà en fiche montre que les interfaces générées échouent surtout sur le contraste (26,8 % de conformité), et qu'écrire « accessible » dans le prompt n'aide pas (`design-front-recent.md` § 3, Aljedaani et al., W4A 2026).
- **Référence.** Recherche du 13.11.2026, requêtes sur l'estimation du contraste par VLM : résultats vendeurs et blogs, non retenus comme preuve.
- **Niveau.** N0 pour la consigne ; N2 pour le constat d'échec des générateurs, par renvoi.
- **Limites.** L'absence de banc trouvé ne prouve pas qu'il n'en existe aucun.
- **Pour graphiste :** « Calcule le contraste de chaque paire texte/fond dans le navigateur, avec les couleurs calculées. Sur une image ou un dégradé, échantillonne les pixels sous le texte au pire endroit. Seuils : 4,5:1 pour le texte courant, 3:1 pour le grand texte et les composants. Un écran qui échoue n'est pas présenté. » (Seuils WCAG : `design-couleur-contraste.md`.)

---

## 3. La boucle générer, rendre, critiquer, réviser

### Sans signal extérieur, un modèle ne se corrige pas : le rendu est ce signal
- **Ce que dit la source.** Sur des tâches de raisonnement, les auteurs montrent que les LLM « struggle to self-correct their responses without external feedback ». Leurs performances baissent parfois après l'auto-correction.
- **Référence.** J. Huang et al., « Large Language Models Cannot Self-Correct Reasoning Yet », ICLR 2024, https://arxiv.org/abs/2310.01798, résumé lu le 13.11.2026.
- **Niveau.** N2.
- **Limites.** Raisonnement mathématique et questions-réponses, pas le design. La transposition est une inférence : relire son HTML n'est pas un retour extérieur, voir son rendu l'est en partie, une mesure l'est pleinement.
- **Pour graphiste :** « Ne révise jamais une variante sur la seule relecture de ton code. Chaque révision part d'un rendu PNG regardé ou d'une mesure faite dans le navigateur, et tu écris laquelle. »

### Une critique visuelle sur le rendu améliore la génération, et seules les révisions qui améliorent doivent être gardées
- **Ce que dit la source.** Un VLM en critique sur pages rendues, testé sur de vraies requêtes de WebDev Arena, donne jusqu'à +17,8 % en trois cycles. Un ajustement fin LoRA n'en récupère qu'environ 25 %. ReLook, en apprentissage par renforcement, fait noter le code par un MLLM à partir de captures. Un rendu invalide reçoit zéro, et une règle n'admet que les révisions qui améliorent le score, pour éviter que le système ne dérive.
- **Référence.** « Vision-Guided Iterative Refinement for Frontend Code Generation », arXiv:2604.05839, 07.04.2026, atelier ICLR 2026, https://arxiv.org/abs/2604.05839, résumé seul lu le 13.11.2026. « ReLook: Vision-Grounded RL with a Multimodal LLM Critic for Agentic Web Coding », arXiv:2510.11498, https://arxiv.org/abs/2510.11498, résumé seul lu le 13.11.2026 (une version ACL 2026 apparaît dans les résultats de recherche, non ouverte).
- **Niveau.** N4 pour l'atelier (résumé seul, condition N2 non établie) ; N2 pour ReLook, sous réserve de la publication ACL non vérifiée.
- **Limites.** Pages web, scores de bancs, pas d'esthétique jugée par des designers. Le nombre d'itérations utiles au-delà de trois n'est pas mesuré.
- **Pour graphiste :** « Garde chaque rendu numéroté (v1, v2…). Une révision ne remplace la précédente que si tu peux nommer ce qu'elle améliore, critère par critère, sans rien dégrader de mesurable (contraste, débordement, cibles). Sinon, reviens à la version précédente. »

### Noter sur des critères nommés, poids sur l'originalité, et se méfier du libellé du critère
- **Ce que dit la source.** Dans le harnais d'Anthropic, générateur et évaluateur partagent quatre critères. La qualité du design (un tout cohérent, une ambiance et une identité). L'originalité (les gabarits, les valeurs par défaut des bibliothèques et les motifs IA échouent). La finition (hiérarchie typographique, espacements, harmonie, contraste). La fonctionnalité. Les deux premiers pèsent davantage. L'évaluateur est calibré par des exemples notés et détaillés, et inspecte la page via Playwright. De 5 à 15 itérations, avec un plateau ; l'auteur préférait parfois une itération intermédiaire à la dernière. Dès la première itération, les critères seuls éloignaient le modèle de ses défauts. Effet imprévu : une phrase du critère invoquant une qualité « de musée » a fait converger les designs vers un style particulier.
- **Référence.** P. Rajasekaran (Anthropic), 24.03.2026, « Harness design for long-running application development », https://www.anthropic.com/engineering/harness-design-long-running-apps, lu le 13.11.2026 (par résumé de l'outil de lecture ; citations non revérifiées mot pour mot). L'évaluateur qui se loue est déjà en fiche : `ia-profils-architecture-agents.md`.
- **Niveau.** N3 (expérience interne décrite, sans protocole publié).
- **Limites.** Pages web de démonstration, un auteur-juge, des heures de calcul par génération.
- **Pour graphiste :** « Critique chaque variante sur quatre critères notés séparément : cohérence d'ensemble, singularité par rapport à la ligne de base, finition mesurable, lisibilité de la tâche principale. Écris tes critères en termes concrets ("le montant du jour se lit en premier"), jamais par une image de prestige ("digne d'un musée", "premium") : le mot oriente le style. Arrête après trois tours sans gain nommé. »

### Vérifier sur rendu réel, à plusieurs tailles, et comparer à la référence
- **Ce que dit la source.** OpenAI présente Playwright comme particulièrement utile au front-end. Le modèle peut inspecter les pages rendues, tester plusieurs tailles d'écran, parcourir les parcours et comparer le rendu à une interface de référence fournie. Le skill d'Anthropic dit de critiquer en construisant, captures à l'appui : « a picture is worth 1000 tokens ».
- **Référence.** OpenAI GPT-5.4 et Anthropic SKILL.md `41bbe19`, déjà cités, lus le 13.11.2026.
- **Niveau.** N3 sans mesure.
- **Limites.** Aucun chiffre sur le gain apporté par l'outil.
- **Pour graphiste :** « Rends au moins deux largeurs de téléphone (petit, vers 360 points, et grand, vers 430 points), plus une avec un texte agrandi. Un écran qui ne tient qu'à une seule largeur n'est pas fini. »

---

## 4. Diversité des variantes

### Les modèles se répètent et se ressemblent entre eux : plusieurs modèles ou plusieurs essais ne suffisent pas à diversifier
- **Ce que dit la source.** Sur 26 000 requêtes ouvertes réelles, les auteurs observent deux effets : un même modèle répète des réponses semblables, et des modèles différents produisent des sorties étonnamment proches. Les juges LLM sont moins bien calibrés quand les préférences humaines divergent.
- **Référence.** L. Jiang et al., « Artificial Hivemind: The Open-Ended Homogeneity of Language Models (and Beyond) », NeurIPS 2025, Datasets & Benchmarks (oral), https://arxiv.org/abs/2510.22954, résumé lu le 13.11.2026.
- **Niveau.** N2.
- **Limites.** Texte, pas images ni interfaces.
- **Pour graphiste :** « Ne compte pas sur le hasard pour obtenir des variantes différentes. La différence se décide dans les fiches de direction (§ 1), axe par axe. »

### La température n'est pas le réglage de la créativité, et elle n'est plus réglable sur les modèles récents
- **Ce que dit la source.** Sur une tâche de récit, la température n'a qu'une corrélation faible avec la nouveauté et une corrélation modérée avec l'incohérence ; aucun lien n'apparaît avec la cohésion ni avec le caractère typique. Les auteurs recommandent des moyens plus contrôlés que le hasard. Sur Sonnet 5, régler `temperature`, `top_p` ou `top_k` « returns a 400 error ».
- **Référence.** M. Peeperkorn, T. Kouwenhoven, D. Brown, A. Jordanous, « Is Temperature the Creativity Parameter of Large Language Models? », ICCC 2024, https://arxiv.org/abs/2405.00492, résumé lu le 13.11.2026. Anthropic, « Prompting Claude Sonnet 5 », déjà cité.
- **Niveau.** N2 (actes ICCC, résumé seul lu) ; N3 pour l'API.
- **Limites.** Un modèle, une tâche de récit.
- **Pour graphiste :** « La variété vient de partis imposés, pas d'un paramètre de génération. »

### Demander plusieurs propositions d'un coup, avec leur probabilité, élargit l'éventail
- **Ce que dit la source.** Les auteurs attribuent l'effondrement des modes en partie au biais de typicalité : les annotateurs préfèrent le texte familier. Leur méthode, sans entraînement, demande au modèle plusieurs réponses avec leurs probabilités. En écriture créative, la diversité augmente d'un facteur 1,6 à 2,1, sans perte d'exactitude selon eux.
- **Référence.** J. Zhang et al., « Verbalized Sampling: How to Mitigate Mode Collapse and Unlock LLM Diversity », arXiv:2510.01171 (v3 du 10.10.2025, v4 du 15.07.2026), https://arxiv.org/abs/2510.01171, résumé lu le 13.11.2026.
- **Niveau.** N4 (préprint, résumé seul lu).
- **Limites.** Texte créatif, pas design. La qualité visuelle des directions peu probables n'est pas mesurée.
- **Pour graphiste :** « Pour trouver tes directions, liste d'abord cinq à huit partis possibles pour ce brief, du plus attendu au plus improbable, en estimant pour chacun la chance qu'un autre générateur le propose. Écarte le plus attendu. Retiens 2 ou 3 partis éloignés les uns des autres, dont au moins un peu probable que le brief tient pourtant. »

### Des points de vue variés préservent la diversité ; un point de vue ne rend pas plus compétent
- **Ce que dit la source.** Dix personas d'IA diversifiées (origines, manières de penser) ont produit 300 trames de récit. Des écrivains qui s'en servaient ont gardé une diversité de récits comparable à ceux qui écrivaient sans IA. Une étude déjà en fiche montre qu'un persona n'améliore pas l'exactitude (`ia-profils-consignes.md` § 3).
- **Référence.** Y. Wan, Y. M. Kalman, « Diverse AI Personas Can Mitigate the Homogenization Effect in Human-AI Collaborative Ideation » (titre de la page arXiv), Computers in Human Behavior: Artificial Humans, 2026, DOI 10.1016/j.chbah.2026.100289, https://arxiv.org/abs/2504.13868, résumé lu le 13.11.2026.
- **Niveau.** N2 (revue, résumé seul lu).
- **Limites.** Récits, pas design. Le résumé lu ne compare pas la diversité au sein d'une persona à celle entre personas.
- **Pour graphiste :** « Tu peux donner à chaque direction un point de vue d'auteur distinct (l'affichiste, le relieur, l'ingénieur de cockpit…) pour l'écarter des autres. Le point de vue sert la différence entre variantes, pas leur qualité : chaque variante passe les mêmes contrôles. »

---

## 5. Apprendre des designers : exemples et retours

### Les retours de designer en commentaires et croquis entraînent mieux qu'une note ou un classement
- **Ce que dit la source.** 21 designers ont produit 1 500 annotations par commentaire, croquis et retouche directe. Des modèles ajustés sur ces données, jugés par des humains, dépassent ceux entraînés sur des classements, et toutes les références testées, GPT-5 compris.
- **Référence.** J. Wu, A. Swearngin, A. K. Vajjala, A. Leung, J. Nichols, T. Barik, « Improving User Interface Generation Models from Designer Feedback », CHI 2026 selon le champ commentaire d'arXiv, https://arxiv.org/abs/2509.16779, résumé seul lu le 13.11.2026.
- **Niveau.** N2 (résumé seul lu).
- **Limites.** Ajustement fin, que graphiste ne fait pas. Seule la forme du retour se transpose.
- **Pour graphiste :** « Quand l'utilisateur commente, garde sa remarque telle qu'il l'a écrite et la zone qu'elle vise, pas seulement "variante B retenue". Le motif d'un refus t'apprend plus qu'un classement. »

---

## Non vérifié, ou sources non lues

- **Tweet d'Adam Wathan** (août 2025) s'excusant d'avoir mis `bg-indigo-500` sur tous les boutons de Tailwind UI, souvent cité comme origine du violet des UI générées. Seuls des articles secondaires ont été lus (DEV Community, A. West) ; texte exact et lien non retrouvés. L'explication statistique est une hypothèse de blogueurs.
- **Listes de signes de praticiens** (925 Studios, Noqta, Capital and Compute, Utsubo) : extraits de moteur seulement. Les emojis en titres, le liseré coloré sur un côté de carte et l'échelle de tailles 12/14/16/18/24/30… y sont cités, sans vérification.
- **Kambhatla et al.** (arXiv:2505.17390, personas et diversité lexicale) et **« The Spark Effect »** (arXiv:2510.15568) : extraits de moteur seulement.
- **UXBench** (arXiv:2606.13192) : chiffres non obtenus.
- **Google** : aucun guide officiel de prompting esthétique pour Gemini trouvé. Seule la publication de DESIGN.md a été lue, pas sa spécification (`stitch.withgoogle.com/docs/design-md/specification`, dépôt `google-labs-code/design.md`).
- **v0** : documentation officielle non ouverte, seulement des miroirs en résultat de recherche.
- **OpenAI, cookbook « Frontend with GPT-5 »** (2025) : non ouvert ; seul le billet GPT-5.4 a été lu, sans auteur ni date visibles dans le texte lu.
- **Skill au chemin `anthropics/claude-code/plugins/frontend-design/skills/frontend-design/SKILL.md`**, cité par la documentation Anthropic : 404 le 13.11.2026. Les versions lues sont celles du dépôt `anthropics/skills`.
- **Seuils d'image dans Claude Code** : les limites de la documentation API n'ont pas été vérifiées pour un PNG lu par l'outil Read.
- **Publication ACL 2026 de ReLook** et **ACCV 2024 de BlindTest** : vues en résultat de recherche, non confirmées sur la page lue.
- **Harnais d'Anthropic** : article lu par l'intermédiaire de l'outil de lecture ; ses formules ne sont pas reprises mot pour mot.

---

## 6. Signes de l'interface générée par IA, et contre-mesures

**Mode d'emploi (N0).** Cette liste est un **contrôle après rendu**, pas un brief. Anthropic constate que, pour Opus 5.5, nommer des motifs précis à exclure marche, et que la liste s'allonge à l'usage. Le risque d'amorçage reste documenté en général (`ia-profils-consignes.md` § 3). D'où la règle : construire depuis la fiche de direction, puis vérifier le PNG contre cette liste. Un trait de la liste reste permis si le brief le justifie par écrit.

| Signe | Source | Contre-mesure pour un écran de téléphone |
|---|---|---|
| Inter, Roboto, Arial ou police système sans choix | Anthropic (blog 2025, skill 2025, Opus 4.8, Sonnet 5), OpenAI GPT-5.4 | Police choisie pour le sujet, avec son motif. Une famille ou deux. |
| Dégradé violet ou indigo sur blanc ou sur sombre | Anthropic (idem), OpenAI, harnais Anthropic | Accent tiré du monde du sujet, donné en hex avec son rôle. |
| Fond crème vers #F4F1EA, serif contrastée, accent terracotta vers #D97757 | Skill 2026, Opus 4.8 (style maison) | À éviter sauf brief éditorial ou hôtelier explicite. |
| Fond presque noir et un seul accent vert acide ou vermillon | Skill 2026 | Même règle : seulement si le brief le demande. |
| Mot isolé en italique, gras ou couleur dans un titre | Skill 2026, Opus 4.8, Opus 5.5 | Hiérarchie par la taille et la graisse du titre entier. |
| Surtitres en capitales espacées au-dessus de chaque bloc | Skill 2026 | Un surtitre seulement s'il porte une information que le titre ne donne pas. |
| Numéros 01 / 02 / 03 hors d'une vraie séquence | Skill 2025-2026, Opus 5.5 | Numéroter seulement des étapes réelles. |
| Police mono pour les petites étiquettes de données | Skill 2026, Opus 5.5 | Chiffres tabulaires de la police de texte. |
| Cartes arrondies identiques, même rayon, même ombre grise douce | Skill 2026, OpenAI | Carte seulement autour d'une action, rayons hiérarchisés, filets plutôt qu'ombres. |
| Dégradés en lavis décoratif en fond | Skill 2026, OpenAI (interfaces produit) | Fond uni ou matière liée au sujet ; le fond sert ou disparaît. |
| Gros chiffre, petit libellé, statistiques et accent en dégradé en tête | Skill 2025-2026 | En tête d'écran, l'élément le plus caractéristique de l'usage. |
| Séparateurs « A · B · C », flèches « → » ajoutées aux boutons | Skill 2026 | Libellés d'action explicites, sans ornement. |
| Boutons en pilule | Opus 5.5 (exemple) | Rayon choisi pour la direction, cohérent avec les autres composants. |
| Emojis comme icônes | Listes de praticiens (non lues, voir « Non vérifié ») ; règle du profil | Jeu d'icônes cohérent (Lucide par défaut dans le profil). |
| Écran vide : illustration aimable et deux lignes interchangeables ; erreur polie mais vague | T. Donska, Built In, 11.06.2026 (N4) ; skill 2026 (écriture) | L'état vide propose l'action suivante ; l'erreur dit ce qui s'est passé et comment réparer. |
| Tableau de bord en cartes avec un graphique en anneau | T. Donska, Built In (N4) | Une donnée principale lisible en premier, graphique choisi pour la question posée. |

Référence de la ligne Built In : T. Donska, 11.06.2026, « AI Makes Bad Design Look Good Enough », https://builtin.com/articles/ai-design-slop-era, lu le 13.11.2026, N4.

**À signaler.** Les « Règles de design opposables » du `CLAUDE.md` du profil fixent des défauts (Inter ou Geist, neutres zinc et un accent, rayon 6 ou 8 px, ombres douces). Plusieurs recoupent la signature décrite ci-dessus. Le conflit n'est pas tranché ici ; il revient au mainteneur.

---

## 7. Ce que l'agent ne peut pas juger seul sur son rendu

Chaque limite vient avec sa parade mécanique. L'agent dispose d'un navigateur sans fenêtre : ce qui se mesure se mesure, le regard ne sert qu'au reste.

| Ce qu'il ne voit pas bien | Preuve | Parade |
|---|---|---|
| Texte qui déborde, éléments qui se chevauchent | UI-Lens (F1 20 à 31 %), BlindTest | Dans le navigateur : `scrollWidth > clientWidth` sur chaque texte, intersections de `getBoundingClientRect()` entre éléments frères, texte tronqué par ellipse listé. |
| Contraste réel | aucun banc trouvé ; générateurs à 26,8 % de conformité (renvoi) | Rapport calculé sur `getComputedStyle` ; pixels échantillonnés sous le texte sur image ou dégradé. |
| Alignements et espacements fins | BlindTest ; documentation vision (coordonnées approximatives) | Lister les bords gauches et les écarts verticaux en px, vérifier qu'ils tombent sur la grille annoncée (4 px dans le profil). |
| Taille des cibles tactiles | non visible à l'œil sur un PNG réduit | Mesurer chaque élément interactif : 44 × 44 points sur iOS, 48 × 48 dp sur Android au minimum (`formulaires-navigation-mobile.md`). |
| Nombre de polices, tailles et couleurs réellement utilisées | dérive entre plan et code (Design Theater, renvoi `design-front-recent.md` § 3) | Inventaire des `font-family`, `font-size` et couleurs calculées, comparé à la fiche de direction. |
| Hiérarchie, facilité d'utilisation, confort | Luera et al. (corrélations nulles ou négatives) | Ne pas conclure. Énoncer l'élément qui doit se lire en premier, puis le vérifier par sa taille et son contraste mesurés. Le reste revient à l'utilisateur ou à un test. |
| Qualité relative de deux variantes | UIClip (proche du hasard) ; accord faible entre designers | Comparaison par paires sur un critère nommé, et journal des choix de l'utilisateur. Pas de note absolue. |
| Originalité par rapport au marché | Hivemind ; vibe coding (renvoi) | Comparer à la ligne de base écrite au départ et à la liste du § 6, pas à son impression. |
| Détails après réduction de l'image | documentation vision Anthropic | Un PNG par écran à densité 2, et des découpes agrandies pour les détails. |
| Rendu de l'intention annoncée | Design Theater : plus de 25 % des intentions non implémentées (renvoi) | Pour chaque ligne de la fiche de direction, pointer l'endroit du rendu qui l'incarne ; une ligne sans endroit est retirée de la fiche ou implémentée. |

**Ce que la boucle ne doit pas faire.** Itérer sans fin : dans le harnais d'Anthropic (N3, 5 à 15 itérations), les scores plafonnent et une version intermédiaire peut être meilleure que la dernière. Garder tous les rendus. Le seuil d'arrêt après trois tours sans gain nommé est un choix N0, adapté à un agent qui rend 2 ou 3 écrans et non une application entière.

---

## 8. Top 8 des consignes pour graphiste

1. **Poser 2 ou 3 directions avant de dessiner**, chacune en fiche (fond en hex, accent en hex, police nommée, parti de composition, ce qui la distingue des autres). La variété se décide là, pas par le hasard ni la température. [N3 Anthropic, Lovable ; N2 Peeperkorn, Hivemind]
2. **Écrire d'abord la ligne de base**, ce qu'un générateur ferait sans consigne, et écarter chaque variante d'elle sur au moins deux axes. [N3 Anthropic ; N2 homogénéisation, par renvoi]
3. **Donner la direction par ce qu'elle est**, en valeurs (hex, police, rayon, matière du sujet). Exclure un trait par son nom précis, jamais par « évite le look IA », qui ne fait que changer de défaut. [N3 Opus 4.8, Sonnet 5, Opus 5.5]
4. **Ancrer chaque variante dans un objet réel du domaine et dans les vraies données**, et concentrer l'audace sur un seul élément signature ; retirer un ornement avant de rendre. [N3 Anthropic, OpenAI]
5. **Mesurer dans le navigateur ce que l'œil du modèle rate** : contraste, débordements, chevauchements, alignements, cibles tactiles, inventaire des polices et couleurs. Rien n'est livré qui échoue à ces mesures. [N2 UI-Lens, BlindTest ; N3 vision Anthropic]
6. **Regarder chaque écran dans son propre PNG à densité 2, et zoomer les détails.** La planche assemblée est pour l'utilisateur, pas pour le jugement de l'agent. [N3 documentation vision, Opus 5.5]
7. **Critiquer par paires sur des critères nommés et concrets**, en gardant tous les rendus numérotés, en n'acceptant que les révisions qui améliorent quelque chose de nommé, et en s'arrêtant après trois tours sans gain. Pas de critère de prestige (« premium », « musée »). [N2 UIClip, Luera, Huang ; N3 harnais Anthropic ; ReLook]
8. **Contrôler le PNG contre la liste des signes du § 6 après le rendu, et se calibrer sur les choix motivés de l'utilisateur** (journal des variantes retenues et écartées), pas sur une liste de polices à la mode. [N3 Anthropic 2025-2026 ; N2 UICrit, DesignPref]

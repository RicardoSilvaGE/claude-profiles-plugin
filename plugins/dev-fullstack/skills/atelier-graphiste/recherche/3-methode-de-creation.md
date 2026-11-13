# Axe 3 — La méthode de conception qui produit de meilleurs résultats visuels

> Recherche documentaire du **13.11.2026**, pour la fiche de l'agent `graphiste` (2 ou 3 variantes d'écrans de téléphone en HTML/CSS, app grand public, rendues en image et regardées avant livraison).
> Question : que dit la recherche sur le **processus** (variantes, exemples, fixation, critique, contraintes, itération) qui mène à des écrans de meilleure qualité ?
> Échelle de preuve : celle du skill `ux-preuves` (N1 norme · N2 recherche revue · N3 guideline d'institution ou de plateforme · N4 praticien · N0 jugement déclaré).
> Toutes les consultations datent du **13.11.2026**. Le degré de lecture est indiqué à chaque entrée : *texte intégral lu* = PDF complet obtenu, résumé et passages ciblés lus (méthode, résultats, limites), pas lecture intégrale ligne à ligne ; *résumé seul lu* ; *connu par une source secondaire*. Les sources non lues sont regroupées en fin de fichier (« Non vérifié »).
> Les citations sont rares et courtes. Celles tirées d'un PDF extrait localement sont exactes ; celles passées par un outil de résumé de page valent paraphrase fidèle, pas texte exact au mot près.

## Ce qui n'est pas refait ici

Déjà couvert dans les fiches du skill `ux-preuves` (`references/`) (renvoyer, ne pas dupliquer) :
- **images générées pendant l'idéation et fixation** (Wadinambiarachchi et al., CHI 2024 : moins d'idées, moins variées, moins originales) → `design-front-recent.md` § 4 ;
- **homogénéisation des sorties d'IA, convergence vers des motifs « sûrs »** → `design-front-recent.md` § 3 ;
- **« squint test », flou des yeux** → `design-perception-esthetique.md` : NN/g le décrit comme une pratique d'école, **aucune étude de validation trouvée** ; il révèle la hiérarchie de saillance, pas la lisibilité.

## Comment lire les niveaux ici

- **Le niveau d'une entrée est celui de la source**, dans son contexte : des novices qui dessinent des bannières web, des étudiants qui écrivent des rimes, etc.
- **Chaque ligne « Pour graphiste » est une transposition** vers un modèle de langage qui dessine des écrans de téléphone. Elle est donc un **N0 déclaré**, accompagné du test qui la confirmerait. Aucune des études ci-dessous n'a porté sur un agent IA qui dessine des écrans d'application.
- Une seule étude ne se généralise pas : quand une réplication existe, elle est citée ; quand une source contredit, le conflit est écrit.

---

## A. Plusieurs variantes, en parallèle

### 1. Produire plusieurs variantes en parallèle avant de juger, plutôt qu'affiner une seule idée

**Ce que dit la source.** 33 novices conçoivent des bannières web pour un magazine : 5 prototypes puis une version finale, à temps égal. En condition *série*, une critique après chaque prototype. En condition *parallèle*, 3 prototypes, critique sur les 3, puis 2 autres, critique, puis la version finale. Les bannières finales ont été diffusées sur MySpace. Résultats : 445,0 contre 397,9 clics par million d'impressions en faveur du parallèle (F(1,30) = 4,227, p < 0,05) ; note d'experts de 24,4 contre 21,7 sur 50 (7 juges) ; les trois bannières les mieux notées viennent du parallèle ; les prototypes du parallèle sont jugés plus divers ; les participants du parallèle gagnent en confiance (effet plus marqué chez les novices), ceux de la série non. En série, les participants « restent sur la même idée » et prennent la critique comme un rejet de leur seule option. Extrait lu : « ads created in the Parallel condition significantly outperformed those from the Serial condition ».

**Référence.** Dow, Glassco, Kass, Schwarz, Schwartz, Klemmer, 2010, « Parallel Prototyping Leads to Better Design Results, More Divergence, and Increased Self-Efficacy », ACM TOCHI 17(4), art. 18. https://hci.stanford.edu/publications/2010/parallel-prototyping/ParallelPrototyping2010.pdf — *texte intégral lu le 13.11.2026.*

**Niveau.** N2.

**Limites.** Petit échantillon (33), novices, un seul format (bannière 160 × 600). Sur les cinq dimensions de la note d'experts, seules « tastefulness » et « respect des principes de graphisme » sont significatives prises une à une. Le mécanisme proposé passe par une **critique externe différée, lue côte à côte** : l'agent n'en dispose pas. Une étude complémentaire a vérifié le biais possible de l'expérimentateur : deux professionnels, à l'aveugle, ont approuvé ses choix de critique à un niveau d'accord modéré, comparable dans les deux conditions.

**Pour graphiste :** esquisser les 3 variantes avant d'en finir une seule ; ne pas peaufiner la variante A pendant que B et C n'existent pas encore. [N0 — transposition ; test : sur 5 briefs, comparer à l'aveugle les livrables « 3 en parallèle » et « 1 affinée puis déclinée ».]

### 2. Le gain du parallèle se retrouve dans une réplication conceptuelle, et les participants ne le perçoivent pas

**Ce que dit la source.** 46 étudiants de première année en génie mécanique, 23 par condition, conçoivent un dispositif imprimé en 3D (deux prototypes puis un final, en parallèle ou en itératif). Parmi les 12 participants qui marquent des points au concours, 9 sont en parallèle et 3 en itératif (χ²(1, n = 46) = 4,059, p = 0,044). Le parallèle accroît la confiance et réduit l'anxiété, et explore davantage l'espace de solutions. Les auteurs notent que les participants semblent « largely unaware of these benefits ».

**Référence.** Murphy, Floresca, Fu, Linsey, 2022, « Comparing parallel and iterative prototyping strategies during engineering design », *Research in Engineering Design*, https://doi.org/10.1007/s00163-021-00376-7 (copie auteur : https://edrl.engr.wisc.edu/wp-content/uploads/sites/142/2022/02/Murphy2022_Article_ComparingParallelAndIterativeP.pdf) — *texte intégral lu le 13.11.2026.*

**Niveau.** N2.

**Limites.** Ingénierie physique, pas graphisme ; critère binaire (marquer ou non) ; la condition parallèle n'imposait pas deux concepts distincts. Les auteurs mentionnent des travaux antérieurs de Dow et al. (2009) en contexte physique sans différence significative ; ces travaux n'ont pas été lus ici.

**Pour graphiste :** ne pas se fier à l'impression que « une seule bonne piste suffit » : le bénéfice du parallèle n'est pas ressenti par celui qui le pratique. Garder la règle même quand une variante paraît évidente. [N0 — transposition.]

### 3. Montrer toutes les variantes, pas seulement la meilleure

**Ce que dit la source.** 84 participants, en paires, conçoivent des bannières pour une association, puis se critiquent mutuellement avant une version finale. Trois conditions à temps égal : *Share Multiple* (3 bannières faites, 3 montrées), *Share Best* (3 faites, la meilleure montrée), *Share One* (1 faite, 1 montrée). Clics sur 12 jours : 106 clics pour 98 867 impressions (Share Multiple), 57 pour 77 558 (Share Best), 76 pour 98 038 (Share One) ; Share Multiple significativement supérieur (χ² = 4,72, p < 0,05). Share Multiple est aussi mieux noté par des juges à l'aveugle et jugé plus divergent ; les paires y empruntent plus d'idées et leur entente progresse, alors qu'elle baisse ailleurs. Fabriquer plusieurs variantes **puis n'en montrer qu'une** (Share Best) ne fait pas mieux, aux clics, que d'en faire une seule (735 contre 775 clics par million, calcul fait ici à partir des totaux de l'article).

**Référence.** Dow, Fortuna, Schwartz, Altringer, Schwartz, Klemmer, 2011, « Prototyping Dynamics: Sharing Multiple Designs Improves Exploration, Group Rapport, and Results », CHI 2011. https://d.ucsd.edu/srk/papers/2011/PrototypingDynamics-CHI2011.pdf — *texte intégral lu le 13.11.2026.*

**Niveau.** N2.

**Limites.** Effet aux clics porté par les participants expérimentés ; **aucune différence de performance entre conditions chez les novices**. Les bannières les mieux notées ne sont pas celles qui cliquent le plus (R² = 0,018) : « bien noté » et « efficace » divergent. Situation de pairs, pas de client.

**Pour graphiste :** livrer les 3 variantes à égalité de finition, chacune défendable, et non une favorite entourée de deux faire-valoir. [N0 — transposition ; test : demander au client de choisir sur des lots « 3 abouties » et « 1 aboutie + 2 esquisses » et compter les demandes de reprise.]

### 4. Une variante présentée seule est jugée trop favorablement : présenter dans un ensemble

**Ce que dit la source.** 48 participants testent un prototype papier de régulation de chauffage domestique, soit seul, soit avec deux alternatives de style différent (« Circular », « Tabular », « Linear »). Montrée seule, une même interface reçoit des notes significativement plus hautes et moins de critiques. Extrait lu : users « were more reluctant to criticize » quand une seule version est présentée. Les auteurs ajoutent que les utilisateurs signalent des problèmes mais ne proposent pas de solutions : « It is a means to identify problems, not provide solutions. »

**Référence.** Tohidi, Buxton, Baecker, Sellen, 2006, « Getting the Right Design and the Design Right: Testing Many Is Better Than One », CHI 2006, p. 1243-1252. https://groups.cs.umass.edu/nmahyar/wp-content/uploads/sites/8/2019/01/reading22.pdf — *texte intégral lu le 13.11.2026.*

**Niveau.** N2.

**Limites.** Différence significative pour deux des trois designs (Circular, Linear), proche du seuil pour le troisième. Prototypes papier, tâche d'usage plutôt qu'esthétique, 2006.

**Pour graphiste :** ne jamais juger une variante isolément ; ouvrir les trois rendus côte à côte et les classer, plutôt que noter chacune « dans l'absolu ». Attendre du client qu'il dise ce qui ne va pas, pas comment le corriger : c'est à l'agent de proposer. [N0 — transposition.]

---

## B. Exemples, références, fixation

### 5. Concevoir avec des exemples sous les yeux donne de meilleurs designs

**Ce que dit la source.** Étude 1 : 26 étudiants conçoivent une page web pour un persona, avec et sans galerie d'exemples (12 gabarits de départ dans les deux cas). 46 autres étudiants notent les pages sur 5 échelles en 7 points (adéquation des couleurs, de la mise en page, du design, sophistication, attrait visuel). Pages faites avec exemples : 4,04 contre 3,37 (F = 4,98, p < 0,05). Les deux autres études montrent que les participants préfèrent des exemples choisis de façon adaptative plutôt qu'au hasard, et qu'ils combinent plusieurs exemples. Extrait lu : « examples offer contextualized instances of how form and content integrate ».

**Référence.** Lee, Srivastava, Kumar, Brafman, Klemmer, 2010, « Designing with Interactive Example Galleries », CHI 2010, p. 2257-2266. https://hci.stanford.edu/publications/2010/examples/lee-chi2010-examples.pdf — *texte intégral lu le 13.11.2026.*

**Niveau.** N2.

**Limites.** Petit échantillon, pages web de 2010, analyse limitée à la première page de chaque participant. L'introduction affirme que les novices en profitent davantage, mais **les résultats de l'étude 1 ne montrent pas d'interaction significative avec l'expertise** : c'est ce résultat qui compte.

**Pour graphiste :** avant de dessiner, réunir de vraies références d'apps (captures, pas descriptions de mémoire) et les garder visibles pendant la conception. [N0 — transposition ; test : livrables avec et sans planche de références, jugés à l'aveugle.]

### 6. Regarder les exemples tôt, et y revenir en cours de route ; tard, ils font seulement copier

**Ce que dit la source.** 81 participants (Mechanical Turk) dessinent des créatures d'une autre planète en deux sessions ; 543 dessins. Quatre conditions : exemples au début, à la fin, au début et en cours (répétés), aucun. Les exemples augmentent la conformité à tout moment. Exposition précoce : plus de traits peu communs (marginal, p = 0,06) ; exposition répétée : plus de traits peu communs (p < 0,05). Les deux conditions sont mieux notées par des annotateurs (p < 0,05). Exposition tardive : conformité accrue (marginale), aucun gain de créativité, moins de dessins. Le nombre de traits *nouveaux* ne varie pas entre conditions.

**Référence.** Kulkarni, Dow, Klemmer, 2012, « Early and Repeated Exposure to Examples Improves Creative Work », CogSci 2012 (republié en 2014 dans *Design Thinking Research*, Springer). https://escholarship.org/content/qt2tv82969/qt2tv82969.pdf — *texte intégral lu le 13.11.2026.*

**Niveau.** N2 (actes revus de CogSci), avec des effets en partie marginaux.

**Limites.** Tâche de dessin sans formation, participants en ligne, deux sessions de dessin de 7 minutes, trois exemples montrés ; plusieurs effets au seuil de 0,1.

**Pour graphiste :** constituer la planche de références **avant** la première esquisse, puis la rouvrir au moment de choisir les détails (cartes, en-têtes, états). Ne pas aller chercher des références à la fin pour « valider » : à ce stade, elles font copier. [N0 — transposition.]

### 7. Les exemples font recopier leurs traits, y compris leurs défauts

**Ce que dit la source.** Dans les expériences fondatrices de Jansson et Smith (1991), des étudiants qui voyaient l'image d'une solution existante (porte-vélo de voiture, verre doseur pour aveugles, gobelet anti-renversement) en reprenaient les traits clés, même volontairement fautifs, **y compris quand on leur demandait de les éviter**. Définition d'origine, citée par Crilly et Cardoso : « a blind adherence to a set of ideas or concepts limiting the output of conceptual design ».

**Référence.** Jansson, Smith, 1991, « Design fixation », *Design Studies* 12(1), 3-11 — *non lu ; connu par* Crilly, Cardoso, 2017, « Where next for research on fixation, inspiration and creativity in design? », *Design Studies* 50, 1-38, https://www.repository.cam.ac.uk/handle/1810/262318 (*texte intégral de Crilly et Cardoso lu le 13.11.2026*).

**Niveau.** N2, connu par une revue de second rang.

**Limites.** Problèmes d'ingénierie, étudiants. Crilly et Cardoso notent que fixer n'est pas toujours mauvais : se conformer à un précédent « need not necessarily lead to bad outcomes ». Une étude de Chrysikou et Weisberg (2005) rapporterait au contraire que des consignes de « défixation » réduisent l'effet (résumé non lu, voir « Non vérifié »).

**Pour graphiste :** pour chaque référence retenue, écrire en une ligne ce qu'on lui prend **et** ce qu'on refuse de lui prendre (sa palette, sa navigation, son illustration). Vérifier sur le rendu final qu'aucune variante n'est un décalque d'une référence. [N0 — transposition.]

### 8. Des références proches du domaine profitent davantage que des références lointaines (données d'observation)

**Ce que dit la source.** Analyse de 2 341 concepts publiés sur 12 défis de la plateforme OpenIDEO ; 707 citent leurs sources d'inspiration. Critère de créativité : être présélectionné par un jury d'experts. Citer des sources va avec plus de créativité, mais **les sources conceptuellement proches** semblent plus profitables que les lointaines, de façon robuste d'un défi à l'autre. Extrait lu : « conceptually closer rather than farther sources appear more beneficial ».

**Référence.** Chan, Dow, Schunn, 2015, « Do the best design ideas (really) come from conceptually distant sources of inspiration? », *Design Studies* (volume 36, p. 31-58 selon le CV d'un auteur, non vérifié), doi 10.1016/j.destud.2014.08.001. Manuscrit : https://joelchan.github.io/files/2014-desstudies-nearfar-manuscript.pdf — *texte intégral (manuscrit) lu le 13.11.2026.*

**Niveau.** N2.

**Limites.** Corrélationnel, pas expérimental ; idées de services et de politiques, pas d'interfaces ; la présélection est un indicateur indirect de créativité. **Conflit possible** avec la méta-analyse de Sio, Kotovsky et Cagan (2015), qui selon des résumés de recherche trouverait qu'**un seul exemple peu commun** aide le plus : son texte n'a pas été lu, ce constat reste à vérifier.

**Pour graphiste :** puiser d'abord dans des apps du même usage (même type de contenu, même geste principal), puis s'autoriser **une** référence d'un domaine voisin (éditorial, signalétique, packaging) pour l'ambiance, pas pour la structure. [N0 — transposition.]

### 9. La planche d'ambiance sert à cadrer, aligner et orienter, sans mesure de son effet sur la qualité

**Ce que dit la source.** Entretiens rétrospectifs avec 14 designers expérimentés (mode, textile, design industriel), plus de 30 heures. La planche d'ambiance joue cinq rôles au début du projet : *framing* (fixer les limites de la tâche), *aligning* (partager une vision avec les parties prenantes), *paradoxing* (explorer des idées en tension), *abstracting* (juxtaposer images concrètes et abstraites), *directing* (donner une trajectoire au travail suivant).

**Référence.** Lucero, 2012, « Framing, Aligning, Paradoxing, Abstracting, and Directing: How Design Mood Boards Work », DIS 2012, p. 438-447. https://users.aalto.fi/~luceroa1/publications/2012/lucero12_moodboards.pdf — *texte intégral lu le 13.11.2026.* Complément : Herring, Chang, Krantzler, Bailey, 2009, « Getting Inspired! Understanding How and Why Examples Are Used in Creative Design Practice », CHI 2009 (11 designers web, graphiques et produit interviewés ; *résumé connu par une source secondaire seulement*).

**Niveau.** N2 qualitatif. **Aucune mesure de l'effet sur la qualité du résultat.**

**Limites.** Pas de designers d'interface dans l'échantillon ; déclaratif.

**Pour graphiste :** faire de la planche un outil de **cadrage** : 3 mots d'ambiance, une palette candidate, une typographie candidate, 4 à 8 références. Elle sert à garder les trois variantes cohérentes avec le brief, pas à prouver qu'elles sont belles. [N0 — transposition.]

---

## C. Quantité et persistance

### 10. Les premières idées sont les plus banales : la créativité monte avec le temps passé à chercher

**Ce que dit la source.** 133 jeunes adultes, tâche d'usages inhabituels de 10 minutes, chaque réponse horodatée et notée par trois juges. La créativité des idées augmente nettement avec le temps puis plafonne ; le nombre d'idées est maximal la première minute puis chute. L'effet d'ordre est « one of the oldest and most robust findings in modern creativity work ». Il est plus faible chez les personnes à intelligence fluide élevée, ce que les auteurs expliquent par une stratégie active pour s'écarter des réponses fréquentes.

**Référence.** Beaty, Silvia, 2012, « Why do ideas get more creative across time? An executive interpretation of the serial order effect in divergent thinking tasks », *Psychology of Aesthetics, Creativity, and the Arts* 6(4), 309-319. Copie auteur : https://beatylab.la.psu.edu/files/2020/08/2012_Beaty_PACA.pdf — *résumé et introduction lus le 13.11.2026.*

**Niveau.** N2 (effet ancien et répliqué selon les auteurs).

**Limites.** Tâche verbale d'idéation, pas de conception visuelle.

**Pour graphiste :** un LLM sort d'abord la réponse la plus probable, qui est l'équivalent de la « première idée ». Lister 6 à 10 directions en une ligne avant d'en retenir trois, et écarter celles qui ressemblent au gabarit d'app par défaut. [N0 — transposition ; lien avec `design-front-recent.md` § 3 sur la convergence des sorties d'IA.]

### 11. On sous-estime ce que rapporte le fait de persister après les premières idées

**Ce que dit la source.** Sept études : sur diverses tâches créatives, les gens sous-estiment systématiquement ce qu'ils produiront s'ils persistent. La difficulté ressentie (« disfluency ») explique cette sous-estimation ; dans l'étude 6, elle les fait renoncer à une occasion de persister et réduit leurs gains.

**Référence.** Lucas, Nordgren, 2015, « People underestimate the value of persistence for creative performance », *Journal of Personality and Social Psychology* 109(2), 232-243, doi 10.1037/pspa0000030. Copie : https://scottbarrykaufman.com/wp-content/uploads/2015/08/Lucas_nordgren_2015_persistence_creativity.pdf — *résumé lu le 13.11.2026.*

**Niveau.** N2.

**Limites.** Humains, tâches d'idéation ; le mécanisme (difficulté ressentie) n'a pas d'équivalent direct chez un modèle.

**Pour graphiste :** ne pas s'arrêter à la première série de directions qui « marche » : faire un deuxième tour de recherche délibéré avant de figer les trois variantes. [N0 — transposition.]

---

## D. Contraintes

### 12. Une contrainte modérée favorise la créativité ; trop peu ou trop en réduisent

**Ce que dit la source.** Revue intégrative de 145 études (management, entrepreneuriat, organisation, marketing). Les auteurs proposent une taxonomie (contraintes d'entrée, de processus, de résultat) et un effet **en U inversé** des contraintes sur la créativité et l'innovation. Extrait lu : « having too few input constraints breeds complacency ». Une thèse de doctorat (Joyce, 2009) rapporte le même sommet à un niveau de contrainte modéré, dans une expérience de conception de produit écrite et sur 43 équipes de développement.

**Référence.** Acar, Tarakci, van Knippenberg, 2019, « Creativity and Innovation Under Constraints: A Cross-Disciplinary Integrative Review », *Journal of Management* 45(1), 96-121. Manuscrit accepté : https://openaccess.city.ac.uk/id/eprint/20459/ — *texte intégral (manuscrit) lu le 13.11.2026.* Joyce, 2009, « The Blank Page: Effects of Constraint on Creativity », thèse, UC Berkeley, https://researchonline.lse.ac.uk/id/eprint/27113 — *notice lue le 13.11.2026.*

**Niveau.** N2 pour la revue (synthèse conceptuelle, pas méta-analyse chiffrée) ; N4 pour la thèse (non revue en revue).

**Limites.** Contraintes surtout organisationnelles (budget, temps, règles) ; pas de conception d'interface.

**Pour graphiste :** ni page blanche, ni cahier des charges qui dicte tout. Se donner explicitement 2 ou 3 contraintes par variante (une palette restreinte, une seule famille typographique, un parti pris de forme) et les écrire dans la présentation. [N0 — transposition.]

### 13. Imposer un élément concret à intégrer rend la production plus créative, et l'effet persiste après

**Ce que dit la source.** Étude 1 : 64 étudiants (59 analysés) écrivent des rimes de cartes de vœux, avec ou sans l'obligation d'y placer un nom imposé ; étude 2 : 48 étudiants, qui choisissent eux-mêmes le nom à placer. Trois juges indépendants trouvent les rimes contraintes plus créatives dans les deux études, et l'avantage persiste dans les essais suivants sans contrainte.

**Référence.** Haught-Tromp, 2016 (en ligne le 14.04.2016), « The Green Eggs and Ham Hypothesis: How Constraints Facilitate Creativity », *Psychology of Aesthetics, Creativity, and the Arts*, doi 10.1037/aca0000061. https://www.rider.edu/sites/default/files/docs/tromp_haught-tromp_PACA_2016.pdf — *texte intégral lu le 13.11.2026.*

**Niveau.** N2.

**Limites.** Écriture courte, étudiants d'une seule université.

**Pour graphiste :** tirer des **données réelles** du brief une contrainte concrète par variante (un vrai nom de produit, une vraie photo, un vrai chiffre qui doit dominer l'écran) et construire autour. [N0 — transposition.]

---

## E. Critique et retour

### 14. Se sentir amélioré par la critique ne prouve pas que le design s'est amélioré

**Ce que dit la source.** Système CrowdCrit, critique structurée par des non-experts. Étude 1 : 10 à 14 critiques de la foule retrouvent 40 à 60 % des problèmes repérés par des experts. Étude 3, contrôlée (18 designers d'un concours 99designs) : avec la critique de la foule, les designers disent avoir vu plus de problèmes (6,13 contre 3,67), fait plus de changements (5,25 contre 2,89) et produit un meilleur design (6,25 contre 3,67). Mais **les notes de juges tiers ne montrent aucune différence sur 9 dimensions sur 10** ; seule la « simplicité » diffère, en faveur du retour générique. Les auteurs y voient une tendance à affiner plutôt qu'à changer en profondeur.

**Référence.** Luther, Tolentino, Wu, Pavel, Bailey, Agrawala, Hartmann, Dow, 2015, « Structuring, Aggregating, and Evaluating Crowdsourced Design Critique », CSCW 2015, p. 473-485. https://people.eecs.berkeley.edu/~bjoern/papers/luther-crowdcrit-cscw2015.pdf — *texte intégral lu le 13.11.2026.*

**Niveau.** N2.

**Limites.** Affiches, petit échantillon, une seule itération.

**Pour graphiste :** après chaque révision, refaire le rendu et comparer **avant / après côte à côte** ; si l'amélioration ne se voit pas sur l'image, revenir en arrière. Ne jamais écrire « amélioré » sur la seule foi de la critique appliquée. [N0 — transposition.]

### 15. Une critique utile est spécifique, actionnable et justifiée ; une grille aide à l'écrire

**Ce que dit la source.** CritiqueKit guide les relecteurs novices pendant qu'ils écrivent : un classifieur indique si le commentaire est *spécifique*, *actionnable*, *justifié*, et des suggestions adaptées s'affichent. Expérience 2 (47 participants, 24 et 23 par condition) : 53 % des commentaires réunissent les trois attributs, contre 30 % sans l'outil. Dans un travail voisin, une grille d'expert permet à des novices de donner une critique jugée presque aussi précieuse que celle d'experts (Yuan et al., 2016, rapport technique de 2015 lu).

**Référence.** Ngoon, Fraser, Weingarten, Dontcheva, Klemmer, 2018, « Interactive Guidance Techniques for Improving Creative Feedback », CHI 2018. https://d.ucsd.edu/srk/papers/2018/CritiqueKit-CHI2018.pdf — *texte intégral lu le 13.11.2026.* Yuan, Luther, Krause, Vennix, Dow, Hartmann, 2016, « Almost an Expert: The Effects of Rubrics and Expertise on Perceived Value of Crowdsourced Design Critiques », CSCW 2016 — *résumé du rapport technique EECS-2015-223 lu*, https://www2.eecs.berkeley.edu/Pubs/TechRpts/2015/EECS-2015-223.html.

**Niveau.** N2.

**Limites.** Qualité de la critique mesurée sur ses attributs, pas sur l'amélioration du design qui en résulte.

**Pour graphiste :** chaque défaut relevé sur le rendu s'écrit en trois temps : **où** (élément précis), **quoi faire** (changement concret), **pourquoi** (principe ou mesure : contraste, hiérarchie, alignement, densité). Un constat qui n'a pas ces trois parties ne déclenche pas de retouche. [N0 — transposition.]

### 16. L'auto-évaluation est biaisée vers le haut

**Ce que dit la source.** Dans un cours en ligne massif (le sujet du cours, de l'interaction homme-machine selon la notice, n'a pas été vérifié dans l'article), les étudiants notent leur propre travail : « On average, students assessed their work 7% higher than staff did. » Leur montrer leur biais améliore la justesse de leurs notations suivantes.

**Référence.** Kulkarni et al. (dont Koller et Klemmer), 2013, « Peer and Self Assessment in Massive Online Classes », ACM TOCHI, doi 10.1145/2505057. https://hci.stanford.edu/publications/paper.php?id=274 — *résumé lu le 13.11.2026.*

**Niveau.** N2.

**Limites.** Notation sur grille de travaux d'étudiants ; effectif non relevé dans le résumé.

**Pour graphiste :** juger ses propres variantes avec une grille écrite **avant** de les voir, pas inventée après coup, et noter avec une marge de prudence. [N0 — transposition.]

---

## F. Ce que l'on sait des modèles de langage qui se relisent

### 17. Sans retour extérieur, un LLM se corrige mal, et peut dégrader une réponse juste

**Ce que dit la source.** En « auto-correction intrinsèque » (le modèle relit sa réponse sans aucun retour extérieur), les LLM « struggle to self-correct their responses without external feedback », et leurs performances baissent parfois après correction. Les auteurs recommandent de s'appuyer sur un retour extérieur.

**Référence.** Huang, Chen, Mishra et al., 2024, « Large Language Models Cannot Self-Correct Reasoning Yet », ICLR 2024. https://arxiv.org/abs/2310.01798 — *résumé lu le 13.11.2026.*

**Niveau.** N2, **par analogie** : tâches de raisonnement, pas de jugement esthétique.

**Limites.** Rien n'est mesuré sur des interfaces. Le rendu en image constitue justement un retour extérieur partiel.

**Pour graphiste :** la relecture ne vaut que si elle s'appuie sur quelque chose de vérifiable hors du modèle : l'image rendue, une mesure (contraste calculé, tailles réelles), une grille écrite d'avance. « Je relis mon code et je le trouve bien » n'est pas une vérification. [N0 — transposition.]

### 18. Comparer son rendu à une référence n'apporte qu'un gain mineur et inégal selon les modèles

**Ce que dit la source.** Banc Design2Code (484 pages web réelles) : on donne au modèle la capture de référence, la capture de sa propre page et son code, et on lui demande de rapprocher le rendu de la référence. Résultat : « some minor improvement » sur la correspondance des blocs et des positions pour GPT-4V et Claude 3, **aucune amélioration** pour Gemini Pro Vision et les modèles ouverts. Comprendre la différence entre deux images et la reporter dans le code est jugé plus difficile.

**Référence.** Si, Zhang, Li, Yang, Liu, Yang, 2025, « Design2Code: Benchmarking Multimodal Code Generation for Automated Front-End Engineering », NAACL 2025. https://arxiv.org/abs/2403.03163 (v3) — *texte intégral lu le 13.11.2026.*

**Niveau.** N2, **par analogie** : fidélité à une maquette donnée, pas qualité esthétique.

**Limites.** Modèles de 2024 ; les modèles récents peuvent faire mieux, non mesuré ici.

**Pour graphiste :** borner la boucle rendu-correction à une ou deux passes ciblées, chacune sur un défaut nommé et visible. Ne pas compter sur des passes répétées pour transformer une variante faible : mieux vaut la remplacer. [N0 — transposition.]

### 19. Une critique d'interface par LLM repère des détails mais s'use au fil des itérations ; des exemples de critiques la rendent meilleure

**Ce que dit la source.** Duan et al. (CHI 2024) : un greffon Figma demande à GPT-4 une évaluation heuristique de maquettes (51 interfaces évaluées par 3 experts, 12 designers en usage itératif). Extrait lu : « GPT-4-based feedback is useful for catching subtle errors, improving text, and considering UI semantics » ; mais son utilité **diminue au fil des itérations**. UICrit (UIST 2024) : environ 3 000 critiques et notes sur près de 1 000 écrans mobiles, écrites par 7 designers expérimentés ; des exemples de critiques choisis par similarité, plus un repérage visuel des zones, améliorent d'environ 55 % la critique générée, sans atteindre le niveau humain.

**Référence.** Duan, Warner, Li, Hartmann, 2024, « Generating Automatic Feedback on UI Mockups with Large Language Models », CHI 2024, https://arxiv.org/abs/2403.13139 ; Duan, Chen, Li, Hartmann, Li, 2024, « UICrit: Enhancing Automated Design Evaluation with a UI Critique Dataset », UIST 2024, https://arxiv.org/abs/2407.08850 — *résumés lus le 13.11.2026.*

**Niveau.** N2.

**Limites.** Selon un résumé de recherche non vérifié dans l'article, Duan 2024 envoie au modèle une représentation JSON de la maquette plutôt que l'image ; critère d'utilisabilité plus que de beauté.

**Pour graphiste :** faire la critique visuelle une fois à fond, sur les trois variantes, plutôt qu'en petites passes répétées ; la nourrir d'une grille et de quelques exemples de bonnes critiques. [N0 — transposition.]

---

## G. Pratique des studios

### 20. Diverger puis converger : un modèle de référence, sans mesure d'efficacité

**Ce que dit la source.** Le *Double Diamond* du Design Council britannique (Discover, Define, Develop, Deliver) décrit deux temps d'ouverture puis de resserrement. Extrait lu : « The second diamond encourages people to give different answers to the clearly defined problem. » La page n'apporte **aucune donnée empirique** ; elle présente le modèle comme une représentation largement acceptée.

**Référence.** Design Council, « The Double Diamond », https://www.designcouncil.org.uk/our-resources/the-double-diamond/ — *lu le 13.11.2026.*

**Niveau.** N3 (institution), sans preuve d'effet. Les entrées 1 à 3 en sont la meilleure justification mesurée.

**Limites.** Modèle descriptif de tout projet de conception, pas un protocole testé ; la page ne parle ni de nombre de variantes ni de critique.

**Pour graphiste :** séparer nettement le temps où l'on ouvre (directions, références) du temps où l'on resserre (trois variantes, critique, choix). Ne pas critiquer pendant qu'on ouvre. [N0.]

### 21. Présenter trois pistes de risque gradué, et en recommander une

**Ce que disent les sources.** David Airey, résumant une conférence CreativeMornings de johnson banks : « The best three options are presented », une sûre, une audacieuse, une « qui fait peur », du point de vue du client ; on en choisit une, on la développe, on la fait valider. Conseil rapporté : rendre l'option effrayante encore plus effrayante, pour que l'originale paraisse plus sûre. johnson banks (2013) rappelle qu'en vingt ans, une idée unique l'a emporté d'emblée environ trois fois. ZURB (2010) : « Showing three focused solutions is far better than showing 10 "choices." » D'autres agences défendent une seule direction recommandée (non lu ici).

**Référence.** Airey, 25.10.2012, « The ideal design process? », https://archive.davidairey.com/?p=1566 ; johnson banks, 21.01.2013, « Absolutism versus more ideas », https://www.johnsonbanks.co.uk/templates/thought/absolutionism-versus-more-ideas ; Zmijewski (ZURB), 23.07.2010, « The three concept rule », https://zurb.com/blog/the-three-concept-rule — *lus le 13.11.2026.*

**Niveau.** N4 (praticiens, témoignage indirect pour johnson banks).

**Limites.** Aucune mesure. Le chiffre « trois » n'est pas justifié par la recherche sur la surcharge de choix : la méta-analyse de Scheibehenne, Greifeneder et Todd (2010, *Journal of Consumer Research* 37(3), 409-425 ; 63 conditions, 50 expériences, N = 5 036 ; https://archive-ouverte.unige.ch/unige:76440, *résumé lu le 13.11.2026*) trouve un effet moyen **proche de zéro**, avec une forte variance. Trois se défend par le coût de production et par Tohidi (entrée 4), pas par la peur du choix.

**Pour graphiste :** livrer les variantes ordonnées de la plus sûre à la plus audacieuse, chacune nommée et décrite en une phrase (son parti pris, son risque), et terminer par **une recommandation argumentée**, en laissant le choix au client. [N0 — transposition.]

---

## Proposition de déroulé de travail (une session, sans pouvoir interroger le client)

1. **Cadrer et poser les contraintes.** Lire le brief et les données réelles ; en tirer 2 ou 3 contraintes concrètes par variante (un vrai contenu qui doit dominer, une palette restreinte, une typographie). — *entrées 12, 13.*
2. **Monter la planche de références avant toute esquisse.** 4 à 8 captures d'apps du même usage, plus une référence d'un domaine voisin pour l'ambiance ; pour chacune, une ligne « je prends / je refuse ». — *entrées 5, 6, 7, 8, 9.*
3. **Diverger sans rendre.** Écrire 6 à 10 directions en une ligne, faire un second tour au-delà des premières, écarter celles qui ressemblent au gabarit par défaut, en retenir trois qui diffèrent vraiment (de la plus sûre à la plus audacieuse). — *entrées 10, 11, 21.*
4. **Construire les trois variantes en parallèle.** Toutes les trois esquissées avant d'en finir une ; même niveau de finition à la fin ; rouvrir la planche au moment des détails. — *entrées 1, 2, 3, 6.*
5. **Rendre et critiquer côte à côte.** Rendre les trois écrans, les classer ensemble contre une grille écrite à l'étape 1 ; chaque défaut s'écrit où / quoi / pourquoi. Squint test en complément, pour la seule hiérarchie. — *entrées 4, 15, 16 ; renvoi `design-perception-esthetique.md`.*
6. **Réviser une ou deux fois, preuve à l'appui.** Chaque retouche vise un défaut nommé ; refaire le rendu et comparer avant / après sur l'image ; si rien ne se voit, revenir en arrière ; une variante faible se remplace plutôt qu'elle ne se rafistole. — *entrées 14, 17, 18, 19.*
7. **Livrer les trois avec une recommandation.** Ordre sûre → audacieuse, une phrase de parti pris et une de risque pour chacune, puis la recommandation argumentée ; le choix reste au client. — *entrées 3, 4, 21.*

## Top 8 des consignes

1. **Trois variantes en parallèle, toutes esquissées avant d'en finir une** [appui N2 : Dow 2010 ; Murphy 2022].
2. **Montrer les trois, pas une favorite et deux faire-valoir** [appui N2 : Dow 2011, qui compare montrer trois et montrer une ; « finition égale » est un jugement N0 ajouté ici].
3. **Juger côte à côte, jamais une variante seule** [appui N2 : Tohidi 2006].
4. **De vraies références d'apps du même usage, réunies avant la première esquisse et rouvertes pour les détails** [appui N2 : Lee 2010 ; Kulkarni 2012 ; Chan 2015].
5. **Écrire ce qu'on refuse de prendre à chaque référence, et vérifier qu'aucune variante n'en est un décalque** [appui N2 via revue : Jansson & Smith 1991, par Crilly & Cardoso 2017].
6. **Dépasser les premières idées : 6 à 10 directions avant d'en garder trois** [appui N2 : Beaty & Silvia 2012 ; Lucas & Nordgren 2015].
7. **Deux ou trois contraintes concrètes par variante, tirées des vraies données** [appui N2 : Haught-Tromp 2016 ; Acar et al. 2019].
8. **Toute retouche s'appuie sur un défaut où / quoi / pourquoi et se vérifie sur le rendu avant / après, pas sur l'impression d'avoir amélioré** [appui N2 : Luther 2015 ; Ngoon 2018 ; Huang 2024 par analogie].

Toutes ces consignes sont des **transpositions (N0)** de constats établis sur des humains : le test qui les confirmerait pour `graphiste` est une comparaison à l'aveugle de livrables produits avec et sans la consigne, sur plusieurs briefs.

## Non vérifié

- **Sio, Kotovsky, Cagan, 2015**, « Fixation or inspiration? A meta-analytic review of the role of examples on design processes », *Design Studies* 39, 70-99 : ni texte ni résumé lus (403 chez l'éditeur, résumé absent de Crossref, Semantic Scholar et OpenAlex). Les constats « 43 études », « moins de catégories d'idées mais plus de nouveauté », « un seul exemple peu commun aide le plus » viennent de résumés de moteur de recherche. Possible conflit avec Chan et al. 2015 (entrée 8).
- **Chrysikou, Weisberg, 2005**, « Following the wrong footsteps », *JEP: LMC* 31(5) : résumé non lu ; l'effet des consignes de défixation, rapporté par des résumés de recherche, contredit la persistance décrite par Crilly et Cardoso pour Jansson et Smith.
- **Jansson, Smith, 1991** et **Purcell, Gero, 1996** : non lus, connus par Crilly et Cardoso (2017) et des résumés.
- **Herring et al., 2009** et **Krause et al., 2017** (« Critique style guide », CHI 2017) : connus par des résumés de recherche seulement.
- **Xu, Huang, Bailey, 2014**, « Voyant », CSCW 2014 : non lu.
- **Stokes, 2005**, *Creativity from Constraints* : livre, non lu ; les entrées 12 et 13 couvrent la question avec des sources revues.
- **Dow, Heddleston, Klemmer, 2009**, prototypage sous contrainte de temps (C&C 2009) : non lu ; selon des résumés de recherche, itérer y bat ne pas itérer. Murphy et al. citent « Dow et al. 2009a, b » de façon ambiguë : ne rien en tirer sur parallèle contre itératif.
- **Agences qui présentent une seule direction** (p. ex. Parachute Design) : signalées par une recherche, non lues.

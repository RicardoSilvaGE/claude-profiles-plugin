# Fiche `ux-preuves` — Rédaction — traduction automatique, LLM et front 2023-2026

> Fiche du skill `ux-preuves` (dev-fullstack), volet **rédaction**, préchargé par `redacteur`. Couvre : qualité de la traduction par LLM (WMT 2024-2025), défauts typiques (translationese, omissions, genre, registre), chaînes d'interface sans contexte, post-édition et relecture humaine (ISO 17100, 18587), microcopy générée par LLM, uniformisation du style, langage clair et AI Act.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Verdict sur les règles
> du profil » (ou « Ce que le profil devrait dire »), « Mythes » et « Non vérifié » sont opposables
> autant que les entrées : ce qui y figure ne se cite pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche documentaire du 9 novembre 2026, pour le référentiel d'un agent « rédacteur UX et
> linguiste produit senior », FR-first et multilingue. Chaque entrée repose sur une page ou un PDF
> **réellement ouvert** (PDF ACL Anthology / arXiv téléchargés puis extraits avec `pdftotext`).
> Quand seul un résumé ou une source secondaire a été lu, c'est écrit. 34 entrées.
>
> Lecture du niveau de preuve : N1 norme/réglementation ; N2 recherche revue par pairs ou étude
> empirique à large échantillon ; N3 guideline officielle d'institution ou de plateforme ; N4 avis
> d'expert ou article de praticien. Un préprint non revu est signalé comme tel, même s'il est classé N2.

---

## 1. Qualité de la traduction par LLM : où en est-on vraiment ?

### Considérer un LLM de pointe comme un traducteur fort, sans le tenir pour sûr : relire, même sur des langues bien dotées
- Niveau de preuve : N2 (campagne d'évaluation humaine par annotateurs professionnels, 11 paires de langues)
- Source : Kocmi, Avramidis, Bawden, Bojar et al., 2024, « Findings of the WMT24 General Machine Translation Shared Task: The LLM Era is Here but MT is Not Solved Yet », Proceedings of WMT 2024, p. 1-46, https://aclanthology.org/2024.wmt-1.1.pdf
- Extrait lu : « the best performing system in general is Claude-3.5-Sonnet winning in 9 language pairs » ; « Human references are in the winning cluster in 7 out of 11 language pairs » ; « The best systems for English→Spanish produced close to flawless translations making it the easiest language pair ».
- Portée / limites : paires toutes au départ de l'anglais sauf cs→uk et ja→zh ; **aucune paire avec le français**, ni vers l'allemand de Suisse ou l'italien. Domaines : actualité, social, parole, littéraire, éducatif — pas d'interface logicielle. Protocole ESA (Error Span Annotation), au niveau du paragraphe. Le titre lui-même pose la limite : « MT is Not Solved Yet ».
- En rédaction ou en traduction : ne pas déduire d'un classement général la qualité sur *ma* paire et *mon* domaine (chaînes courtes d'interface). La question : « cette paire et ce type de texte ont-ils été évalués par des humains ? »

### Attendre des écarts forts d'une langue cible à l'autre, même entre modèles de pointe, et ne pas se fier à un score automatique pour le savoir
- Niveau de preuve : N2 (60 systèmes, 15 paires évaluées par des humains, ESA sur la plupart, MQM sur deux)
- Source : Kocmi, Artemova, Avramidis, Bawden et al., 2025, « Findings of the WMT25 General Machine Translation Shared Task: Time to Stop Evaluating on Easy Test Sets », Proceedings of WMT 2025, vol. 2, p. 355-413, https://aclanthology.org/2025.wmt-1.22.pdf
- Extrait lu : « The best system overall, was Gemini 2.5 Pro, which was in top cluster in 14 language pairs » ; « Although Shy-hunyuan-MT placed first for all but one language pair in the automatic rankings, human evaluation revealed its performance was considerably lower than that of the top-rated systems » ; « SOTA systems still struggle with robustness to non-standard input, linguistic complexity, domain-specific terminology and gender choice/agreement in particular language pairs ».
- Portée / limites : tableau anglais→arabe égyptien lu : référence humaine 78.5, GPT-4.1 77.0, Gemini-2.5-Pro 60.6, Claude-4 55.7 (score humain ESA) — un même modèle peut être excellent sur une paire et nettement derrière sur une autre. Jeux de test volontairement **difficiles** (échantillonnage par difficulté). Toujours aucune paire avec le français. Le système en tête des métriques automatiques avait été entraîné avec ces mêmes métriques (XCOMET, GEMBA) comme signal : c'est le « hill-climbing » que dénonçait déjà WMT24 avec COMET.
- En rédaction ou en traduction : pour chaque locale, demander « quel est mon niveau attesté sur *cette* langue cible ? » ; un score COMET/BLEU élevé ne remplace jamais une relecture native.

### Graduer la confiance selon le niveau de ressources de la langue cible : relecture native obligatoire pour les langues peu dotées
- Niveau de preuve : N2 (204 variétés de langues, FLORES-200 ; métriques automatiques chrF++/BLEU)
- Source : Robinson, Ogayo, Mortensen, Neubig, 2023, « ChatGPT MT: Competitive for High- (but Not Low-) Resource Languages », Proceedings of WMT 2023, https://aclanthology.org/2023.wmt-1.40.pdf
- Extrait lu : « GPT models approach or exceed traditional MT model performance for some high-resource languages (HRLs) but consistently lag for low-resource languages (LRLs), under-performing traditional MT for 84.1% of languages we covered. Our analysis reveals that a language's resource level is the most important feature in determining ChatGPT's relative ability to translate it ».
- Portée / limites : ChatGPT (GPT-3.5) et GPT-4 de 2023 ; évaluation **automatique** seulement (chrF++ principal) ; phrases isolées de Wikipédia. Les modèles 2025-2026 sont meilleurs, mais WMT25 confirme le gradient (anglais→bhojpuri et anglais→maasai exclus de l'évaluation humaine, faute d'annotateurs et de qualité suffisante).
- En rédaction ou en traduction : classer chaque locale demandée en « bien dotée » (fr, de, it, en, es…) ou « peu dotée » (dialectes, langues régionales, langues africaines…) ; pour la seconde catégorie, ne livrer qu'une proposition explicitement marquée « à faire valider ».

### Pour le romanche et les variétés régionales suisses, traduire *vers* elles est encore difficile : toujours signaler et faire valider
- Niveau de preuve : N2 (benchmark de référence pour six variétés de romanche ; évaluation automatique) — article d'atelier WMT25, préprint arXiv lu
- Source : Vamvas, Pérez Prat, Soliva et al., 2025, « Expanding the WMT24++ Benchmark with Rumantsch Grischun, Sursilvan, Sutsilvan, Surmiran, Puter, and Vallader », WMT25 (Open Language Data Initiative Shared Task), https://arxiv.org/abs/2509.03148v2 (résumé seul lu)
- Extrait lu : « An automatic evaluation of existing MT systems and LLMs shows that translation out of Romansh into German is handled relatively well for all the varieties, but translation into Romansh is still challenging. »
- Portée / limites : source allemande, pas française ; métriques automatiques ; résumé seul lu, pas les scores par modèle.
- En rédaction ou en traduction : asymétrie à retenir — un LLM peut *comprendre* une langue peu dotée bien mieux qu'il ne sait l'*écrire*. Comprendre un retour utilisateur en romanche ≠ savoir rédiger une interface en romanche.

### Ne pas prendre un classement automatique « LLM meilleur dans 55 langues » pour une preuve de qualité humaine
- Niveau de preuve : N2 (55 langues et dialectes, références humaines nouvelles) — **préprint** arXiv, sans mention de publication revue sur la page lue
- Source : Deutsch, Briakou, Caswell, Finkelstein et al. (Google), 2025, « WMT24++: Expanding the Language Coverage of WMT24 to 55 Languages & Dialects », https://arxiv.org/abs/2502.12404 (résumé seul lu)
- Extrait lu : « We benchmark a variety of MT providers and LLMs on the collected dataset using automatic metrics and find that LLMs are the best-performing MT systems in all 55 languages. These results should be confirmed using a human-based evaluation, which we leave for future work. »
- Portée / limites : les auteurs eux-mêmes renvoient la confirmation à une évaluation humaine non faite.
- En rédaction ou en traduction : citer ce type de résultat avec sa réserve ; « meilleur système » ne veut pas dire « publiable sans relecture ».

### Ne jamais trancher entre deux traductions (ou deux modèles) sur le seul BLEU
- Niveau de preuve : N2 (2,3 millions de jugements humains au niveau phrase, Microsoft)
- Source : Kocmi, Federmann, Grundkiewicz, Junczys-Dowmunt, Matsushita, Menezes, 2021, « To Ship or Not to Ship: An Extensive Evaluation of Automatic Metrics for Machine Translation », Proceedings of WMT 2021, https://aclanthology.org/2021.wmt-1.57.pdf
- Extrait lu : « we show that the sole use of BLEU impeded the development of improved models leading to bad deployment decisions. »
- Portée / limites : systèmes de 2021 (avant les LLM) ; mesure la capacité d'une métrique à prédire le classement humain de *paires de systèmes*, pas la qualité d'une chaîne isolée.
- En rédaction ou en traduction : pour une chaîne d'interface de trois mots, une métrique de recouvrement n'a quasiment aucun sens ; le contrôle est humain ou par grille d'erreurs.

### Juger une traduction par les erreurs qu'elle contient (grille de type MQM), par un professionnel, avec le contexte du document
- Niveau de preuve : N2 (la plus grande étude MQM à sa date ; sorties WMT 2020, deux paires, traducteurs professionnels)
- Source : Freitag, Foster, Grangier, Ratnakar, Tan, Macherey, 2021, « Experts, Errors, and Context: A Large-Scale Study of Human Evaluation for Machine Translation », TACL, https://aclanthology.org/2021.tacl-1.87.pdf
- Extrait lu : « finding among other results a substantially different ranking of evaluated systems from the one established by the WMT crowd workers, exhibiting a clear preference for human over machine output. Surprisingly, we also find that automatic metrics based on pre-trained embeddings can outperform human crowd workers. »
- Portée / limites : en→de et zh→en, systèmes neuronaux 2020. Montre que l'évaluateur compte autant que la métrique : des non-professionnels sans contexte voient moins de défauts.
- En rédaction ou en traduction : la relecture d'une locale doit être faite par un locuteur compétent, *dans l'écran*, avec une liste d'erreurs typée (exactitude, omission, ajout, terminologie, registre, fluidité) plutôt qu'une note globale.

### Relire au niveau de l'écran ou du parcours, pas chaîne par chaîne : certaines erreurs n'apparaissent qu'en contexte
- Niveau de preuve : N2 (expérience de classement par paires, zh→en)
- Source : Läubli, Sennrich, Volk, 2018, « Has Machine Translation Achieved Human Parity? A Case for Document-level Evaluation », EMNLP 2018, https://aclanthology.org/D18-1512.pdf
- Extrait lu : « human raters assessing adequacy and fluency show a stronger preference for human over machine translation when evaluating documents as compared to isolated sentences. Our findings emphasise the need to shift towards document-level evaluation as machine translation improves to the degree that errors which are hard or impossible to spot at the sentence-level become decisive ».
- Portée / limites : traduction journalistique, pas d'interface ; systèmes de 2018.
- En rédaction ou en traduction : incohérences de terme d'un écran à l'autre, tutoiement qui bascule en vouvoiement, bouton qui ne correspond plus au titre de la boîte de dialogue : défauts invisibles chaîne par chaîne. Relire le parcours entier.

---

## 2. Défauts typiques de la traduction automatique et par LLM

### Chercher activement les hallucinations propres aux LLM : mauvaise langue cible, ajout de contenu, refus déguisé en traduction
- Niveau de preuve : N2 (plus de 100 directions de traduction, modèles M2M et GPT)
- Source : Guerreiro, Alves, Waldendorf, Haddow, Birch, Colombo, Martins, 2023, « Hallucinations in Large Multilingual Translation Models », TACL, https://aclanthology.org/2023.tacl-1.85.pdf
- Extrait lu : « models struggle with hallucinations primarily in low-resource directions and when translating out of English » ; « LLMs produce hallucinations that are qualitatively different from those of conventional translation models, mostly consisting of off-target translations, overgeneration, and even failed attempts to translate » ; exemple cité : « This is an English sentence, so there is no way to translate it to Vietnamese ».
- Portée / limites : ChatGPT et GPT-4 de 2023 ; détecteurs automatiques d'hallucinations. GPT-4 en produisait moins que ChatGPT, mais le type d'erreur reste à surveiller.
- En rédaction ou en traduction : contrôles mécaniques après chaque lot — la sortie est-elle dans la bonne langue ? sa longueur est-elle plausible par rapport à la source (ajout = « overgeneration ») ? contient-elle un commentaire du modèle au lieu d'une traduction ?

### Fournir un glossaire imposé : les termes donnés améliorent à la fois l'exactitude terminologique et la qualité globale
- Niveau de preuve : N2 (tâche partagée, 13 équipes / 20 systèmes en piste 1, domaines informatique et finance)
- Source : Semenov, Huang, Zouhar, Berger, Zhu, Oncevay, Chen, 2025, « Findings of the WMT25 Terminology Translation Task: Terminology is Useful Especially for Good MTs », Proceedings of WMT 2025, vol. 2, p. 554-576, https://aclanthology.org/2025.wmt-1.30.pdf
- Extrait lu : « The results show that providing proper terminology consistently boosts both overall translation quality and term accuracy, whereas reliance on random terminology yields smaller gains. Despite the near-saturation of sentence-level benchmarks, document-level finance translation still falls short » ; « Top systems achieve close to perfect terminology accuracy in the sentence-level track, indicating LLM's suitability for the task ».
- Portée / limites : en→de, en→ru, en→es (informatique), en↔zh traditionnel (finance). Pas le français.
- En rédaction ou en traduction : avant de traduire une interface, poser le glossaire produit (noms de fonctions, objets métier, verbes d'action) par locale, et le passer explicitement au traducteur — humain ou LLM.

### Fixer le registre (tu/vous, du/Sie) par locale avant de traduire : sans consigne, un système en choisit un par défaut, et ce défaut varie selon la langue
- Niveau de preuve : N2 (première tâche partagée de contrôle de la formalité, IWSLT 2022 ; reconduite en 2023)
- Source : Anastasopoulos et al., 2022, « Findings of the IWSLT 2022 Evaluation Campaign », section 7 « Formality Control for SLT », https://aclanthology.org/2022.iwslt-1.10.pdf ; complété par Agarwal et al., 2023, « Findings of the IWSLT 2023 Evaluation Campaign », section 9, https://aclanthology.org/2023.iwslt-1.1.pdf
- Extrait lu : 2022 — « the inherent bias toward one formality level in the training set » (en zéro-shot, les systèmes réussissaient mieux « informal Italian and formal Russian translations ») ; 2022 — choisir entre registres valides sans contrôle « can lead to translations with inconsistent tone that are perceived as inappropriate by users » ; 2023 — « While machine translation (MT) systems typically produce a single generic translation for each input segment, SLT requires adapting the translation output to be appropriate to the context of communication and target audience. »
- Portée / limites : systèmes neuronaux dédiés, pas de LLM généraliste de 2025 ; paires en→de, es, hi, ja, it, ru (2022), en→ko, vi, pt, ru (2023). **Pas de paire vers le français.** Données de type oral.
- En rédaction ou en traduction : écrire le registre dans la consigne de chaque locale (« de : Sie ou du ? », « it : tu ou Lei ? ») et vérifier sa constance sur tout le parcours ; l'anglais source (« you ») ne porte pas l'information.

### Vérifier le genre de chaque personne mentionnée : par défaut, la traduction suit les stéréotypes
- Niveau de preuve : N2 (WinoMT : 3 888 phrases, 8 langues cibles dont le français, 4 systèmes commerciaux et 2 académiques)
- Source : Stanovsky, Smith, Zettlemoyer, 2019, « Evaluating Gender Bias in Machine Translation », ACL 2019, https://aclanthology.org/P19-1164.pdf
- Extrait lu : « Our analyses show that four popular industrial MT systems and two recent state-of-the-art academic models are significantly prone to gender-biased translation errors for all tested target languages. »
- Portée / limites : systèmes de 2019 ; phrases construites (schémas de Winograd), indicateur indirect de biais.
- En rédaction ou en traduction : relire chaque nom de rôle (« administrateur », « médecin », « utilisateur ») et chaque accord ; décider en amont de la stratégie de la locale (épicène, double flexion, reformulation) au lieu de laisser le masculin par défaut.

### Ne pas supposer qu'un LLM est moins biaisé en genre qu'un moteur neuronal : sur des modèles ouverts, c'était l'inverse ; une consigne explicite réduit l'écart
- Niveau de preuve : N2 (atelier GeBNLP 2024, revu ; en→ca et en→es ; quatre jeux de test dont WinoMT)
- Source : Sant, Escolano, Mash, De Luca Fornaciari, Melero, 2024, « The power of Prompts: Evaluating and Mitigating Gender Bias in MT with LLMs », 5th GeBNLP Workshop, https://aclanthology.org/2024.gebnlp-1.7.pdf
- Extrait lu : « Our findings reveal pervasive gender bias across all models, with base LLMs exhibiting a higher degree of bias compared to NMT models. To combat this bias, we explore prompting engineering techniques applied to an instruction-tuned LLM. We identify a prompt structure that significantly reduces gender bias by up to 12% on the WinoMT evaluation dataset ».
- Portée / limites : petits modèles ouverts (Llama-2-7B et apparentés), pas les modèles commerciaux de 2025-2026 ; deux paires romanes.
- En rédaction ou en traduction : quand le genre est inconnu ou non pertinent, le dire dans la consigne et demander la forme neutre ou inclusive retenue par la charte de la locale.

### Dans les messages à la première personne ou adressés à l'utilisateur, ne pas laisser le système choisir le masculin
- Niveau de preuve : N2 (banc d'essai WMT25 : 1 000 avis produits, en→ru et en→sr)
- Source : Popović, Lapshinova-Koltunski, 2025, « GENDER1PERSON: Test Suite for estimating gender bias of first-person singular forms », Proceedings of WMT 2025, https://aclanthology.org/2025.wmt-1.56.pdf
- Extrait lu : « The test suite shows that the majority of the systems participating in the WMT-2025 task for these two target languages prefer the masculine writer's gender. There is no single system which is biased towards the feminine variant. »
- Portée / limites : russe et serbe ; mais le phénomène existe en français (« Je suis ravi(e) », « Vous êtes connecté(e) »).
- En rédaction ou en traduction : repérer toute chaîne où un adjectif ou participe s'accorde avec l'utilisateur ; reformuler pour éviter l'accord (« Connexion réussie ») plutôt que trancher au masculin.

### Après une première traduction par LLM, faire une passe de « polissage » dans la langue cible : demander « sois naturel » dans la consigne ne suffit pas
- Niveau de preuve : N2 (ACL 2025, annotation experte ; en→zh et de→en ; GPT-4, GPT-3.5, ALMA, Mistral)
- Source : Li, Zhang, Wang, Zhang, Cui, Yin, Xiao, Zhang, 2025, « Lost in Literalism: How Supervised Training Shapes Translationese in LLMs », ACL 2025, https://aclanthology.org/2025.acl-long.630.pdf
- Extrait lu : « even advanced models like GPT-4 demonstrate over 40% of their translations as exhibiting substantial translationese patterns » ; « incorporating specific requirements (i.e., "specified") in prompts that intend to enhance naturalness does not consistently reduce the rate of translationese errors; in some cases, it may even worsen the translation quality » ; « GPT-4 decreases the proportion of translationese from 43% to 25% through self-polishing its own translations ».
- Portée / limites : deux paires seulement, aucune vers le français ; GPT-4 de 2023-2024.
- En rédaction ou en traduction : procédure en deux temps — (1) traduire le sens ; (2) relire le texte cible **seul**, comme un texte original, et réécrire ce qui « sent la traduction » : ordre des mots calqué, collocations littérales (« gagner plus de qualité de vie »), lourdeurs.

### Surveiller l'appauvrissement lexical : la traduction automatique préfère les mots fréquents et efface la variété
- Niveau de preuve : N2 (EACL 2021 ; en↔fr et en↔es ; systèmes statistiques et neuronaux)
- Source : Vanmassenhove, Shterionov, Gwilliam, 2021, « Machine Translationese: Effects of Algorithmic Bias on Linguistic Complexity in Machine Translation », EACL 2021, https://aclanthology.org/2021.eacl-main.188.pdf
- Extrait lu : « Our experiments show that there is a loss of lexical and morphological richness in the translations produced by all investigated MT paradigms for two language pairs (EN↔FR and EN↔ES). »
- Portée / limites : systèmes antérieurs aux LLM ; mesure statistique sur corpus, pas jugement de lecteurs.
- En rédaction ou en traduction : vérifier que la locale a sa propre voix (vocabulaire de marque, tournures propres) et n'est pas une version « moyenne » du texte source.

---

## 3. Chaînes d'interface : courtes, sans contexte, avec variables

### Accompagner chaque chaîne d'un commentaire de contexte : à quoi elle sert, où elle apparaît, quelle place elle a
- Niveau de preuve : N3 (documentation officielle Android)
- Source : Android Developers, « Localize your app », consultée le 09.11.2026, https://developer.android.com/guide/topics/resources/localization
- Extrait lu : « As you declare strings in your strings.xml file, make sure to describe the context in which the string is used. This information is invaluable to the translator and results in better quality translation. » ; exemple : « <!-- The action for submitting a form. This text is on a button that can fit 30 chars --> » ; « Where is this in the UI? For example, translations are less flexible in buttons than in text boxes. »
- Portée / limites : recommandation de plateforme, sans étude chiffrée à l'appui.
- En rédaction ou en traduction : refuser de traduire une chaîne nue ; exiger (ou rédiger) pour chaque clé : type d'élément, écran, déclencheur, longueur maximale. Si absent, le dire au lieu de deviner.

### Marquer ce qui ne se traduit pas (variables, codes, noms) et donner un exemple de valeur
- Niveau de preuve : N3 (documentation officielle Android)
- Source : Android Developers, « Localize your app », https://developer.android.com/guide/topics/resources/localization
- Extrait lu : « look for and mark text that must remain as-is, without translation, so that the translator doesn't change it. » ; « When you declare a placeholder tag, add an ID attribute that explains what the placeholder is for. If your app later replaces the placeholder value, be sure to provide an example attribute to clarify the expected use. »
- Portée / limites : syntaxe `<xliff:g>` propre à Android ; le principe vaut pour ICU, gettext, i18next.
- En rédaction ou en traduction : contrôler après traduction que chaque variable (`%1$s`, `{count}`) est présente, identique, une seule fois ; demander ce que la variable contient (nom ? nombre ? date ?) avant d'accorder autour.

### Désambiguïser les mots courts homonymes par un contexte explicite (`msgctxt`)
- Niveau de preuve : N3 (manuel officiel GNU gettext)
- Source : GNU, « GNU gettext utilities », § 12.2.5 « Using contexts for solving ambiguities », https://www.gnu.org/software/gettext/manual/html_node/Contexts.html
- Extrait lu : « many of the strings which have to be translated are very short. They have to appear in pull-down menus which restricts the length. But strings which are not containing entire sentences or at least large fragments of a sentence may appear in more than one situation in the program but might have different translations. This is especially true for the one-word strings which are frequently used in GUI programs. »
- Portée / limites : mécanisme technique ; ne dit rien de la qualité mesurée.
- En rédaction ou en traduction : « Open », « Save », « Home », « Clear », « Archive » : nom ou verbe ? Une même clé ne doit pas servir à deux usages ; sinon, deux clés avec deux contextes.

### Écrire des phrases entières avec des variables plutôt que de concaténer des morceaux
- Niveau de preuve : N3 (manuel officiel GNU gettext)
- Source : GNU, « GNU gettext utilities », § 4.3.4 « No string concatenation », https://www.gnu.org/software/gettext/manual/html_node/No-string-concatenation.html
- Extrait lu : « In order to present to the translator only entire sentences, and also because in some languages the translator might want to swap the order of object1 and object2, it is necessary to change this to use a format string: sprintf (s, "Replace %s with %s?", object1, object2); »
- Portée / limites : principe d'ingénierie, sans étude empirique.
- En rédaction ou en traduction : signaler toute chaîne qui est un fragment (« Bienvenue, » + nom + « ! ») ; la réécrire en phrase complète paramétrée, et prévoir le pluriel par la règle de la locale.

---

## 4. Post-édition et contrôle humain

### Distinguer post-édition complète (qualité équivalente à une traduction humaine) et légère (texte simplement compréhensible) ; une interface publiée exige la complète
- Niveau de preuve : N1 (norme internationale ; texte intégral non lu, extrait d'échantillon et résumé officiel lus via une plateforme de diffusion)
- Source : ISO, 2017, « ISO 18587:2017 Translation services — Post-editing of machine translation output — Requirements », fiche et échantillon lus sur https://standards.iteh.ai/catalog/standards/iso/310c236f-b40e-4027-a61e-e10c063dffec/iso-18587-2017 (la page iso.org a renvoyé 403)
- Extrait lu : « provides requirements for the process of full, human post-editing of machine translation output » ; « It is only applicable to content processed by MT systems. » ; définition 3.1.5 « full post-editing: process of post-editing to obtain a product comparable to a product obtained by human translation » ; 3.1.6 « light post-editing: process of post-editing to obtain a merely comprehensible text without any attempt to produce a … » (définition tronquée dans la lecture) ; « Light post-editing is described in Annex B. »
- Portée / limites : la norme exige des post-éditeurs compétents (section 5, non lue). Une révision de la norme est en préparation (comité, non vérifié en détail).
- En rédaction ou en traduction : une traduction produite par l'agent est une « sortie de traduction automatique » au sens de la norme ; pour une interface publiée, la cible est la post-édition **complète**, par un humain compétent dans la langue.

### Pour un texte publié, prévoir une révision bilingue par une seconde personne compétente, distincte du traducteur
- Niveau de preuve : N1 (norme internationale) — **texte de la norme non lu** : citations relevées dans une source secondaire (Wikipédia), à confirmer sur le texte officiel
- Source : ISO, 2015, « ISO 17100:2015 Translation services — Requirements for translation services », résumé lu sur https://en.wikipedia.org/wiki/ISO_17100
- Extrait lu : « requirements for translations to be subject to revision by a second person, which is an obligatory part of the standard » ; « The use of raw output from machine translation plus post-editing is outside the scope of this standard. »
- Portée / limites : ISO 17100 encadre les prestataires de traduction humaine ; elle **exclut** explicitement la post-édition de sortie automatique (qui relève d'ISO 18587). Amendement A1 de 2017 vu dans des catalogues nationaux, non lu.
- En rédaction ou en traduction : le principe « quatre yeux » s'applique à l'agent : il ne peut pas être son propre réviseur final pour une locale publiée.

### La post-édition fait gagner du temps et de la qualité, mais la proposition machine « amorce » le traducteur
- Niveau de preuve : N2 (CHI 2013, expérience contrôlée ; 16 traducteurs professionnels par langue cible, en→ar, fr, de)
- Source : Green, Heer, Manning, 2013, « The Efficacy of Human Post-Editing for Language Translation », CHI 2013, https://idl.cs.washington.edu/files/2013-PostEditing-CHI.pdf
- Extrait lu : « We present the first rigorous, controlled analysis of post-editing and find that post-editing leads to reduced time and, surprisingly, improved quality for three diverse language pairs (English to Arabic, French, and German). » ; « We find that MT suggestions prime translators ».
- Portée / limites : traduction automatique statistique de 2012-2013 ; phrases isolées, sans le document ; traducteurs recrutés sur une plateforme freelance. Les écarts avec les LLM actuels sont probablement plus grands en faveur de la post-édition, mais non vérifiés ici.
- En rédaction ou en traduction : présenter la traduction de l'agent au relecteur natif comme une **proposition**, et l'inviter à réécrire, pas seulement à corriger : sinon le calque survit.

### Se méfier du « post-editese » : un texte post-édité est plus simple, plus normalisé et plus marqué par la source qu'une traduction humaine
- Niveau de preuve : N2 (MT Summit 2019 ; trois jeux de données, cinq directions)
- Source : Toral, 2019, « Post-editese: an Exacerbated Translationese », MT Summit XVII, https://aclanthology.org/W19-6627.pdf
- Extrait lu : « We find out that PEs are simpler and more normalised and have a higher degree of interference from the source language than HTs. »
- Portée / limites : mesures computationnelles (simplification, normalisation, interférence), pas de jugement de lecteurs ; systèmes antérieurs aux LLM.
- En rédaction ou en traduction : pour les textes de marque (accueil, onboarding, marketing), préférer une **réécriture** native à partir du sens plutôt qu'une post-édition de la sortie machine.

### Un LLM utilisé comme post-éditeur améliore souvent la traduction, mais peut inventer des corrections
- Niveau de preuve : N2 (Findings EMNLP 2023 ; en↔zh, en↔de, WMT-22)
- Source : Raunak, Sharaf, Wang, Hassan Awadalla, Menezes, 2023, « Leveraging GPT-4 for Automatic Translation Post-Editing », Findings of EMNLP 2023, https://aclanthology.org/2023.findings-emnlp.804.pdf
- Extrait lu : « Our results demonstrate that GPT-4 is adept at translation post-editing, producing meaningful and trustworthy edits » ; « However, we also show that GPT-4 could produce hallucinated edits, thereby urging caution in its use as an expert translation post-editor. »
- Portée / limites : GPT-4 de 2023 ; amélioration mesurée surtout par métriques automatiques.
- En rédaction ou en traduction : une relecture par un second passage LLM n'est pas une révision humaine ; comparer source et cible phrase à phrase pour repérer ce que la « correction » a ajouté ou retiré.

---

## 5. Texte d'interface généré par LLM : messages d'erreur et d'aide

### Un message d'erreur réécrit par LLM peut être plus clair, mais sa correction proposée est souvent fausse : vérifier le contenu technique
- Niveau de preuve : N2 (SIGCSE TS 2023, revu ; échantillon petit : neuf messages d'erreur Python, sorties Codex)
- Source : Leinonen, Hellas, Sarsa, Reeves, Denny, Prather, Becker, 2023, « Using Large Language Models to Enhance Programming Error Messages », SIGCSE TS 2023, https://arxiv.org/abs/2210.11630 (PDF arXiv lu)
- Extrait lu : « most error message explanations created by Codex were comprehensible (percentage of "yes" ranging from 67% to 100%) » ; « However, the fix was correct only 33% of the time » ; « the Codex-created content […] were an improvement over the original error message in slightly over half of the cases (54%) ».
- Portée / limites : modèle Codex (2022), aujourd'hui dépassé ; jugement par les auteurs, pas par des utilisateurs.
- En rédaction ou en traduction : pour tout message d'erreur généré, contrôler séparément (1) la clarté, (2) l'exactitude de la cause, (3) l'exactitude de l'action proposée — la troisième est la plus fragile.

### À grande échelle, des messages d'erreur générés par GPT ont réduit la répétition des erreurs
- Niveau de preuve : N2 (essai contrôlé randomisé ; 8 762 étudiants de 146 pays ; SIGCSE 2024)
- Source : Wang, Mitchell, Piech, 2024, « A Large Scale RCT on Effective Error Messages in CS1 », SIGCSE 2024, DOI 10.1145/3626252.3630764 ; page lue : https://hai.stanford.edu/research/a-large-scale-rct-on-effective-error-messages-in-cs1 (résumé seul lu)
- Extrait lu : « students using GPT generated error messages repeat an error 23.1% less often in the subsequent attempt » ; « resolve an error in 34.8% fewer additional attempts, compared to students using standard error messages ».
- Portée / limites : contexte d'apprentissage de la programmation ; ce sont des messages pour débutants, pas une interface grand public. Un résultat de recherche relayé ailleurs donne 23,5 % et 36,1 % : chiffres non concordants avec la page lue (voir « Non vérifié »).
- En rédaction ou en traduction : l'effet porte sur des messages qui **expliquent et proposent une action** ; c'est la structure du message qui aide, pas l'origine LLM en soi.

### Un message rédigé par un expert reste supérieur au message généré par LLM
- Niveau de preuve : N2 (étude intra-sujets, n = 106, six programmes C ; UKICER 2024)
- Source : Santos, Becker, 2024, « Not the Silver Bullet: LLM-enhanced Programming Error Messages are Ineffective in Practice », UKICER '24, https://arxiv.org/abs/2409.18661 (résumé seul lu)
- Extrait lu : « GPT-4 generated error messages outperformed conventional compiler error messages in only 1 of the 6 tasks » ; « Handwritten explanations still outperform LLM and conventional error messages, both on objective and subjective measures. »
- Portée / limites : petit échantillon d'étudiants ; erreurs de compilation C.
- En rédaction ou en traduction : traiter la sortie LLM comme un premier jet ; la version publiée des messages critiques (paiement, perte de données, sécurité) doit être relue par quelqu'un qui connaît la cause réelle de l'erreur.

---

## 6. Uniformisation du style par l'IA

### Les suggestions d'IA rapprochent l'écriture de normes occidentales : relire chaque locale avec un natif de la culture visée, pas seulement de la langue
- Niveau de preuve : N2 (CHI 2025 ; expérience contrôlée, 118 participants, 60 Indiens et 58 Américains)
- Source : Agarwal, Naaman, Vashistha, 2025, « AI Suggestions Homogenize Writing Toward Western Styles and Diminish Cultural Nuances », CHI '25, DOI 10.1145/3706598.3713564, https://arxiv.org/pdf/2409.11360v3
- Extrait lu : « we found that AI caused Indian participants to write more like Americans, thereby homogenizing writing toward Western styles and diminishing nuances that differentiate cultural expression. Worryingly, AI influences not just what is written (e.g., shifting preferences toward Western cultural artifacts such as food items), but also more ingrained elements of how it's written ».
- Portée / limites : anglais écrit par des Indiens et des Américains, suggestions d'autocomplétion ; ne porte pas sur la traduction ni sur le français.
- En rédaction ou en traduction : exemples, prénoms, fêtes, formats, références culturelles dans une locale : sont-ils ceux de la culture cible ou un réflexe anglo-américain ?

### Bannir les tics lexicaux des LLM des textes d'interface et de marque
- Niveau de preuve : N2 (Science Advances, 2025 ; plus de 15 millions de résumés PubMed 2010-2024)
- Source : Kobak, González-Márquez, Horvát, Lause, 2025, « Delving into LLM-assisted writing in biomedical publications through excess vocabulary », Science Advances 11(27), https://arxiv.org/abs/2406.07016v5 (PDF v5 lu)
- Extrait lu : « Less common words with strong excess usage included delves (r = 28.0), underscores (r = 13.8), and showcasing (r = 10.7) » ; « out of all 379 excess style words in 2024, 66% were verbs and 14% were adjectives » ; résumé : « at least 13.5% of 2024 abstracts were processed with LLMs ».
- Portée / limites : anglais scientifique uniquement ; mesure collective, pas un détecteur fiable pour un texte isolé. Aucune liste équivalente vérifiée pour le français.
- En rédaction ou en traduction : tenir une liste de mots interdits de la voix de marque (en anglais : « delve », « showcase », « seamless »… ; en français : à constituer par observation, non sourcée ici) et la passer en relecture.

---

## 7. Langage clair et réglementation récente

### États-Unis : le langage clair est une obligation légale pour les documents fédéraux destinés au public, sans recours en justice
- Niveau de preuve : N1 (loi fédérale)
- Source : Congrès des États-Unis, 2010, « Plain Writing Act of 2010 », Public Law 111-274, 13 octobre 2010, https://www.govinfo.gov/content/pkg/PLAW-111publ274/html/PLAW-111publ274.htm
- Extrait lu : « The term "plain writing" means writing that is clear, concise, well-organized, and follows other best practices appropriate to the subject or field and intended audience. » ; « Beginning not later than 1 year after the date of enactment of this Act, each agency shall use plain writing in every covered document » ; « There shall be no judicial review of compliance or noncompliance with any provision of this Act. »
- Portée / limites : agences exécutives fédérales ; « covered document » inclut formulaires et notices, pas les règlements. Obligation sans sanction.
- En rédaction ou en traduction : la définition légale est une grille utile (clair, concis, organisé, adapté au public visé), mais elle ne s'applique pas à un produit privé.

### Union européenne (EAA) : depuis le 28 juin 2025, l'information des produits et services couverts doit être présentée de façon compréhensible ; pour les services bancaires aux consommateurs, pas au-delà du niveau B2
- Niveau de preuve : N1 (directive européenne)
- Source : Parlement européen et Conseil, 2019, « Directive (UE) 2019/882 relative aux exigences en matière d'accessibilité applicables aux produits et services » (European Accessibility Act), annexe I et article 31, texte lu sur https://www.legislation.gov.uk/eudr/2019/882/annex/I et https://www.legislation.gov.uk/eudr/2019/882/article/31 (EUR-Lex inaccessible depuis la session)
- Extrait lu : annexe I, section III (tous services) : « presenting the information in an understandable way; » ; section IV, services bancaires : « ensuring that the information is understandable, without exceeding a level of complexity superior to level B2 (upper intermediate) of the Council of Europe's Common European Framework of Reference for Languages. » ; article 31 : « They shall apply those measures from 28 June 2025. »
- Portée / limites : la directive vaut par sa transposition nationale ; la Suisse n'est pas membre de l'UE (applicable à un produit suisse qui vend dans l'UE — analyse juridique non faite ici). La copie lue est celle de legislation.gov.uk (version « as adopted »).
- En rédaction ou en traduction : pour un service couvert (commerce en ligne, banque, billetterie…), « compréhensible » devient une exigence ; viser un niveau de langue explicite par locale (B2 au plus pour la banque) et le tester.

### Union européenne (AI Act, art. 50) : marquage des contenus générés depuis le 2 août 2026 ; l'obligation de signaler un texte d'information du public généré par IA tombe s'il a été relu sous responsabilité éditoriale
- Niveau de preuve : N1 (règlement européen) — texte lu sur un site miroir non officiel ; dates de l'Omnibus lues dans des notes d'avocats (N4)
- Source : Règlement (UE) 2024/1689 (AI Act), article 50, lu sur https://artificialintelligenceact.eu/article/50/ ; Gibson Dunn, 27.05.2026, « EU AI Act Omnibus Agreement — Postponed High-Risk Deadlines and Other Key Changes », https://www.gibsondunn.com/eu-ai-act-omnibus-agreement-postponed-high-risk-deadlines-and-other-key-changes/ ; Paul Weiss, 04.08.2026, « EU Finalises Transparency Rules for AI-Generated Content », https://www.paulweiss.com/insights/client-memos/eu-finalises-transparency-rules-for-ai-generated-content
- Extrait lu : art. 50(2) : les sorties synthétiques doivent être « marked in a machine-readable format and detectable as artificially generated or manipulated » ; art. 50(4) : texte « published with the purpose of informing the public on matters of public interest » ; exception lorsque « the AI-generated content has undergone a process of human review or editorial control » et « a natural or legal person holds editorial responsibility for the publication of the content » ; page miroir : « Comes into force 2 August 2026, according to Article 113. » Paul Weiss : « The obligations apply from 2 August 2026 for most AI systems covered by Article 50 » ; report « to 2 December 2026 for obligations under Article 50(2) for marking and detection of generative systems » et « to 2 February 2027 for obligations under Article 50(2) for watermark-detection interoperability ».
- Portée / limites : le texte de l'Omnibus numérique au Journal officiel **n'a pas été lu** (numéro et date de publication non vérifiés). L'art. 50(2) vise les **fournisseurs** de systèmes génératifs ; l'art. 50(4) vise les **déployeurs** et seulement les textes d'information du public sur des sujets d'intérêt public, pas les libellés d'interface.
- En rédaction ou en traduction : un microtexte d'interface relu et validé par une personne responsable n'entre en principe pas dans l'obligation d'étiquetage de l'art. 50(4) ; un article d'aide ou une annonce publique générés et publiés sans relecture, si. Faire trancher par un juriste avant de publier.

---

## 8. Pivot et langue source

### Traduire directement depuis la source maîtresse, sans passer en silence par l'anglais ; savoir que les directions « non anglaises » restent plus faibles chez les LLM
- Niveau de preuve : N2 (EMNLP 2025, 72 directions x2x)
- Source : Yang, Bao, Lu, Chen, Huang, Cheng, 2025, « EnAnchored-X2X: English-Anchored Optimization for Many-to-Many Translation », EMNLP 2025, https://aclanthology.org/2025.emnlp-main.1081.pdf
- Extrait lu : « Large language models (LLMs) have demonstrated strong machine translation capabilities for English-centric language pairs but underperform in direct non-English (x2x) translation. » ; « While using English as a pivot language offers a compromise solution, this approach often suffers from error propagation and doubles the decoding overhead compared to direct translation ».
- Portée / limites : mesures sur des modèles ouverts (dont Llama2) par COMET ; pas de comparaison humaine fr→de spécifique ; le résultat vise l'entraînement, pas la consigne.
- En rédaction ou en traduction : une interface FR-first traduite vers de/it est une direction x2x ; prévoir une relecture native au moins aussi stricte que pour une source anglaise. Ne pas produire l'allemand à partir d'une version anglaise intermédiaire sans le dire.

---

## Verdict sur les règles du profil

### « Idiomatique, pas mot-à-mot : on traduit le sens et le ton, pas les mots. »
**Soutenue — à compléter d'un garde-fou.** Le défaut dominant des LLM en traduction est justement le littéralisme : plus de 40 % de traductions GPT-4 à translationese marqué (Li et al., 2025), appauvrissement lexical en↔fr (Vanmassenhove et al., 2021), post-editese (Toral, 2019). La recherche montre aussi *comment* l'obtenir : une passe de polissage dans la langue cible fait mieux qu'une consigne « sois naturel » (43 % → 25 % pour GPT-4). **Limite à écrire dans la règle** : l'idiomaticité ne couvre ni les termes du glossaire (WMT25 Terminology), ni les variables, ni l'ajout ou l'omission de contenu — l'excès de liberté produit les hallucinations d'« overgeneration » propres aux LLM (Guerreiro et al., 2023). Formulation proposée : « Sens, ton et registre idiomatiques ; termes du glossaire, variables et quantité d'information strictement conservés. »

### « Si une langue cible n'est pas la tienne au niveau natif, le signaler et proposer une traduction à faire valider. »
**Soutenue sur le fond, à reformuler.** Pour un LLM, « niveau natif » n'est pas une catégorie opératoire ; ce que la recherche mesure, c'est un **gradient selon les ressources de la langue** (Robinson et al., 2023 : en retrait sur 84,1 % des langues couvertes, surtout peu dotées ; Guerreiro et al., 2023 : hallucinations surtout en directions peu dotées) et des **écarts forts même entre langues dotées** (WMT25 : anglais→arabe égyptien, Claude-4 à 55,7 contre 78,5 pour la référence humaine). Le romanche reste difficile en écriture (Vamvas et al., 2025). Et même sur les langues les mieux dotées, aucune campagne ne montre une qualité publiable sans relecture pour des chaînes d'interface — WMT 2024 et 2025 n'ont même pas de paire avec le français. Les normes (ISO 18587 : post-édition complète ; ISO 17100 : révision par une seconde personne) vont dans le même sens. Formulation proposée : « Toute locale publiée est une proposition à faire valider par un locuteur natif compétent ; pour les langues peu dotées (dialectes, romanche, langues régionales), le signaler en tête et ne jamais présenter le texte comme final. Ne jamais affirmer l'idiomaticité d'une locale non relue. »

### « FR-first : rédiger d'abord un français impeccable, puis les autres locales en équivalents idiomatiques. »
**Convention sans preuve trouvée pour le gain de qualité ; aucun résultat ne la contredit, un risque documenté à couvrir.** Aucune étude trouvée ne mesure l'effet de « rédiger d'abord dans la langue maîtresse » sur la qualité des autres locales. Ce qui est documenté : les LLM sont plus faibles dans les directions non anglaises (x2x) que depuis ou vers l'anglais, et le pivot par l'anglais propage les erreurs (Yang et al., 2025). Une source française bien écrite porte des informations que l'anglais n'a pas (genre, tu/vous) — **inférence non testée**, cohérente avec les résultats IWSLT sur le registre et WinoMT sur le genre. Conséquences pratiques : (1) traduire directement depuis le français, avec le contexte et le glossaire ; (2) ne pas passer par l'anglais sans le dire ; (3) prévoir une relecture native renforcée pour fr→de/it ; (4) un français « impeccable » mais calqué de l'anglais transmettra son calque — la qualité de la source compte.

---

## Mythes et affirmations contestées

- **« Les LLM ont atteint la parité humaine en traduction. »** Contesté. WMT25 place la référence humaine dans le groupe de tête pour seulement 6 paires sur 15, mais les organisateurs notent que cela « This finding highlights the inherent difficulty of translation, though it could also reflect the stylistic or lexical preferences of the annotators. » Les annonces de parité de 2018 ont été démenties par une évaluation au niveau du document (Läubli et al., 2018). Sur des jeux difficiles et des langues moins dotées, l'écart reste net (arabe égyptien, bhojpuri, maasai).
- **« Un bon score COMET ou BLEU veut dire une bonne traduction. »** Contesté à chaque campagne : WMT24 (Tower70B premier en automatique, pas en humain), WMT25 (Shy-hunyuan-MT premier en automatique, nettement plus bas en humain), Kocmi et al. (2021) pour BLEU.
- **« Il suffit de demander au LLM d'être naturel. »** Contredit par Li et al. (2025) : la consigne « specified » n'a pas réduit le translationese et l'a même accru pour GPT-4 (0,50 → 0,53) ; c'est la passe de polissage qui fonctionne.
- **« Les LLM sont moins biaisés en genre que les anciens moteurs. »** Non établi : plus biaisés que les moteurs neuronaux pour des modèles ouverts de base (Sant et al., 2024) ; biais masculin persistant au WMT25 (GENDER1PERSON) ; WMT25 cite toujours le genre parmi les points faibles.
- **« Les messages d'erreur générés par IA sont meilleurs. »** Mitigé : effet positif à grande échelle chez des débutants (Wang et al., 2024), mais messages rédigés par expert supérieurs (Santos & Becker, 2024) et correctifs proposés faux dans deux cas sur trois avec Codex (Leinonen et al., 2023).
- **« Le mot "delve" prouve qu'un texte a été écrit par IA. »** Abusif : Kobak et al. (2025) mesurent un excès **collectif** de fréquence sur des millions de résumés ; ce n'est pas un détecteur de texte individuel.
- **« L'AI Act impose d'étiqueter tout texte rédigé avec l'IA. »** Faux en l'état lu : l'art. 50(4) vise les textes publiés pour informer le public sur des sujets d'intérêt public, avec exception en cas de relecture humaine sous responsabilité éditoriale ; le marquage technique de l'art. 50(2) pèse sur les fournisseurs de systèmes.

---

## Non vérifié

- **Étude Lingoport / RWS sur la traduction de chaînes d'interface par LLM** (≈ 18 000 chaînes, apport du contexte visuel) : pages du fournisseur en 403, aucune version revue trouvée. Non vérifié.
- **Chiffres de Wang, Mitchell, Piech (2024)** : la page Stanford HAI lue donne 23,1 % et 34,8 % ; un résumé de moteur de recherche donnait 23,5 % et 36,1 %. Article ACM non ouvert : version finale non vérifiée.
- **Texte intégral d'ISO 18587 et d'ISO 17100** : iso.org en 403. ISO 18587 lu par échantillon et résumé officiels sur une plateforme de diffusion ; ISO 17100 seulement par Wikipédia. Statut d'une seconde édition d'ISO 18587 en préparation : non vérifié.
- **Texte de l'Omnibus numérique au Journal officiel** (numéro de règlement, date d'entrée en vigueur, libellé exact du report de l'art. 50(2)) : non lu ; dates reprises de deux notes de cabinets d'avocats (Gibson Dunn, Paul Weiss), qui concordent sur le 2 décembre 2026.
- **EUR-Lex** inaccessible depuis la session (défi anti-robot) : AI Act lu sur un site miroir, EAA sur legislation.gov.uk.
- **Kimmel et al.** (messages d'erreur par LLM), cité dans la demande : pas trouvé ni vérifié.
- **RCT de Pankiewicz & Baker et de Zhou et al.** sur le retour LLM aux erreurs de compilation : vus seulement dans un résultat de recherche de seconde main, non ouverts.
- **Suite de Vamvas et al. (EMNLP 2026 Findings, asymétrie de traduction des LLM)** : vue dans un résultat de recherche, non ouverte.
- **Performance des LLM pour fr→de, fr→it, fr→en en évaluation humaine** : aucune campagne WMT 2024-2025 trouvée avec le français ; non vérifié.
- **Liste de tics lexicaux des LLM en français** : aucune source trouvée.
- **Effet mesuré des captures d'écran ou du contexte sur la qualité de traduction de chaînes d'interface par un LLM** : aucune étude revue trouvée ; seules des recommandations de plateforme (Android, gettext) sont vérifiées.

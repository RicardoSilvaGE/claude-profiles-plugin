# Fiche `ux-preuves` — Rédaction — internationalisation et locales

> Fiche du skill `ux-preuves` (dev-fullstack), volet **rédaction**, préchargé par `redacteur`. Couvre : expansion des textes traduits, pluriels CLDR 49 (cardinaux et ordinaux), ICU MessageFormat et MessageFormat 2.0, anti-patterns d'i18n, formats par locale avec focus Suisse, pseudo-localisation, bidi, gestion terminologique, négociation de langue et repli.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Verdict sur les règles
> du profil » (ou « Ce que le profil devrait dire »), « Mythes » et « Non vérifié » sont opposables
> autant que les entrées : ce qui y figure ne se cite pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche documentaire vérifiée du 09.11.2026, pour le référentiel d'un agent « rédacteur UX et
> linguiste produit senior » (FR-first ; FR, EN, ES par défaut ; DE et IT fréquents ; Suisse romande).
> Chaque entrée renvoie à une page ouverte le 09.11.2026 (WebFetch, ou curl pour les fichiers de
> données CLDR et les articles W3C). Lorsque seul un résumé a été lu, c'est indiqué.
> Données CLDR lues : **CLDR 49** (`_cldrVersion: "49"`, paquet `cldr-core` 49.0.0), publiée le
> **22.10.2026** selon la note de version.
>
> Niveaux de preuve : N1 norme ou standard (Unicode, W3C normatif, ISO, IETF, TC39) ; N2 étude
> empirique à large échantillon ; N3 guideline officielle d'institution ou de plateforme (articles du
> W3C i18n, Microsoft Learn, Android, MDN, documentation ICU ou i18next) ; N4 avis de praticien.
> **Aucune source N2 n'a été trouvée sur l'expansion des traductions** : tous les chiffres
> d'expansion ci-dessous sont des heuristiques N3 ou N4.

---

## 1. Expansion des textes traduits

### Réserver bien plus de place aux chaînes courtes qu'aux longues : un libellé de 10 caractères ou moins peut doubler, voire tripler
- Niveau de preuve : N3 (article du W3C i18n qui reprend un tableau IBM, source secondaire)
- Source : Richard Ishida (W3C), 2007 (publication), retouché le 01.02.2016, « Text size in translation », https://www.w3.org/International/articles/article-text-size
- Extrait lu : « No. of characters in English source / Average expansion — Up to 10: 200–300% · 11–20: 180–200% · 21–30: 160–180% · 31–50: 140–160% · 51–70: 151-170% · Over 70: 130% » ; « note carefully how the smaller the source message, the higher the likely translation length. »
- Portée / limites : il s'agit de taux de traduction **depuis l'anglais vers des langues européennes**, attribués aux « Guidelines to design global solutions » d'IBM. Le document IBM d'origine n'a pas été retrouvé (voir Non vérifié). Les valeurs représentent la longueur de la cible rapportée à la source, pas un supplément : 130 % équivaut à +30 %. La ligne 51–70 (151-170 %), plus haute que la ligne 31–50, est reproduite telle quelle. L'article ne cite **ni 30 % ni 35 %** pour l'allemand ou l'espagnol. Il ne dit rien des traductions dont la source est le français.
- En rédaction ou en revue : un bouton, un onglet ou une étiquette de moins de 10 caractères tient-il dans le double ou le triple de sa longueur ? Le conteneur peut-il passer à la ligne, ou est-il à largeur fixe ?

### Pseudo-localiser avec environ +40 % en moyenne, en sachant que les chaînes d'un ou deux mots dépassent souvent ce taux
- Niveau de preuve : N3
- Source : Microsoft Learn (P. Dempsey, J. Wilcox), ms.date 07.06.2022, « Pseudolocalization », https://learn.microsoft.com/en-us/globalization/methodology/pseudolocalization
- Extrait lu : « When the source language is English, a good heuristic is to lengthen the text by 40%. In practice, there can be extreme cases where a string may be 200% or even 400% longer when translated into a real language. Strings that are one or two words commonly grow proportionally longer than strings with more words. »
- Portée / limites : l'heuristique vaut pour une source anglaise. La page note aussi que la contraction existe mais n'est pas simulée (« Shrinkage generally causes fewer issues than growth »).
- En rédaction ou en revue : le taux de pseudo-localisation est-il modulé selon la longueur ? Un taux unique de +35 % ou +40 % sous-teste les libellés courts.

### Ne pas présenter « +30 % en allemand et en espagnol » comme une norme : ce sont les bornes hautes de tableaux de prestataires, publiés sans méthode
- Niveau de preuve : N4
- Source : Andiamo Language Services, s.d., « Expansion and contraction factors », https://www.andiamo.co.uk/resources/expansion-and-contraction-factors/
- Extrait lu : « German: +10% to +35% » ; « Spanish: +15% to +30% » ; « French: +15% to +20% » ; « Italian: +10% to +25% » ; « Finnish: -25% to -30% » ; « the table below will give you an idea of expansion and contraction factors. »
- Portée / limites : aucune méthode ni aucun corpus n'est indiqué, et l'unité (caractères ou mots) n'est pas précisée. C'est l'origine la plus plausible des chiffres « +30 % / +35 % » qui circulent. Aucune source N1 à N3 n'a été trouvée pour ces chiffres par langue.
- En rédaction ou en revue : lorsqu'une spécification cite « +30 % », demander d'où vient le chiffre, à partir de quelle langue source et pour quelle longueur de chaîne.

### Prévoir l'expansion en hauteur aussi, et les mots composés insécables (allemand, finnois)
- Niveau de preuve : N3
- Source : Microsoft Learn, ms.date 07.06.2022, « Design software for international markets », https://learn.microsoft.com/en-us/globalization/methodology/international-design ; et W3C, « Text size in translation » (URL ci-dessus)
- Extrait lu : « Keep in mind that text may expand both vertically and horizontally. […] The length of words will increase in some languages, such as German, Finnish, and Czech. » (Microsoft) ; « the English "Input processing features" may become "Eingabeverarbeitungsfunktionen" in German » (W3C)
- Portée / limites : la Suisse est concernée au premier chef par l'allemand. La césure automatique de ces mots dépend de l'attribut `lang` (voir § 4).
- En rédaction ou en revue : le composant tient-il un mot allemand de 30 caractères sans espace ? La troncature peut-elle changer le sens ? Microsoft : « Clipping and truncation can change meaning in profound or offensive ways. »

---

## 2. Pluriels CLDR (cardinaux et ordinaux)

### Traiter FR, ES, IT et PT avec trois catégories (`one`, `many`, `other`), pas deux : `many` couvre les millions exacts (« 1 000 000 de jours »)
- Niveau de preuve : N1
- Source : Unicode CLDR 49, fichier de données `plurals.json`, https://raw.githubusercontent.com/unicode-org/cldr-json/main/cldr-json/cldr-core/supplemental/plurals.json ; tableau « Language Plural Rules », https://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html ; notes de version https://cldr.unicode.org/downloads/cldr-38 et https://cldr.unicode.org/downloads/cldr-40
- Extrait lu : fr `"pluralRule-count-many": "e = 0 and i != 0 and i % 1000000 = 0 and v = 0 or e != 0..5 @integer 1000000, 1c6, …"`, avec les exemples du tableau « 1 000 000 de jours », « 1.000.000 de días », « 1.000.000 di giorni », « 1.000.000 de dias ». CLDR 38 : « The plural rules for French changed to add a new category, 'many', using the new operand 'c' (with a synonym 'e'). » CLDR 40 : « The ‘many’ plural category has been introduced into es, it, pt, and pt_PT. As in French, this is used for large numbers. »
- Portée / limites : le français a `many` depuis **CLDR 38**, l'espagnol, l'italien et le portugais (pt et pt_PT) depuis **CLDR 40** (vérifié dans les JSON étiquetés 38.0.0, 39.0.0 et 40.0.0). Les dates de sortie de CLDR 38 et 40 n'ont pas été vérifiées. Côté implémentation, si une variante `many` manque, ICU retombe sur `other` (voir § 3), ce qui donnerait « 1 000 000 jours » au lieu de « 1 000 000 de jours ». La catégorie sert aussi aux nombres compacts (« 1 M »).
- En rédaction ou en revue : un message pluriel FR, ES, IT ou PT qui affiche des montants ou des quantités pouvant atteindre le million a-t-il une variante `many` (« de ») ? Pour les compteurs ordinaires, `other` suffit.

### Ne pas calquer le pluriel français sur l'anglais : en français, 0 et 1 sont au singulier, en anglais 0 est au pluriel
- Niveau de preuve : N1
- Source : Unicode CLDR 49, `plurals.json` (URL ci-dessus)
- Extrait lu : fr `"pluralRule-count-one": "i = 0..1 @integer 0, 1 @decimal 0.0~1.5"` ; en `"pluralRule-count-one": "i = 1 and v = 0 @integer 1"` ; de `"pluralRule-count-one": "i = 1 and v = 0 @integer 1"` ; es `"pluralRule-count-one": "n = 1 …"` ; pt `"i = 0..1"`, mais pt-PT `"i = 1 and v = 0"`.
- Portée / limites : en français, « 1,5 jour » relève aussi de `one` (décimales 0.0 à 1.5). L'anglais et l'allemand n'ont que `one` et `other`. Le portugais du Brésil (pt) et celui du Portugal (pt-PT) diffèrent pour 0.
- En rédaction ou en revue : la chaîne FR « 0 fichiers » vient-elle d'une logique `n === 1` codée en dur ? C'est une erreur en français.

### Prévoir quatre formes en russe et en polonais, six en arabe, et pas « jusqu'à six » pour tous
- Niveau de preuve : N1
- Source : Unicode CLDR 49, `plurals.json` et tableau « Language Plural Rules » (URL ci-dessus)
- Extrait lu : ru `one` « v = 0 and i % 10 = 1 and i % 100 != 11 », `few` « v = 0 and i % 10 = 2..4 and i % 100 != 12..14 », `many` « v = 0 and i % 10 = 0 or v = 0 and i % 10 = 5..9 or v = 0 and i % 100 = 11..14 », `other` (décimales). pl : one/few/many/other (« 2 miesiące », « 5 miesięcy », « 1,5 miesiąca »). ar : `zero` « n = 0 », `one` « n = 1 », `two` « n = 2 », `few` « n % 100 = 3..10 », `many` « n % 100 = 11..99 », `other`.
- Portée / limites : le russe et le polonais n'ont **pas** de `zero` ni de `two`. Seul l'arabe utilise les six catégories parmi les langues demandées.
- En rédaction ou en revue : le format de fichier de traduction et l'outil de traduction acceptent-ils les catégories `few` et `many`, et pas seulement singulier et pluriel ?

### Écrire chaque variante plurielle comme une phrase complète et parallèle, toujours avec `other`, et ne pas confondre `one` avec « le nombre 1 »
- Niveau de preuve : N1 (guide de spécification CLDR)
- Source : Unicode CLDR, « Plural Rules » (guide de spécification), https://cldr.unicode.org/index/cldr-spec/plural-rules
- Extrait lu : « A common mistake is to think that “one” is only for only the number 1. » ; « Instead, “one” is a category for any number that behaves like 1. » ; « other (required—general plural form—also used if the language only has a single form) » ; « The sentences must be parallel, with exactly the same construction except for what is forced by a change in digits. » ; « implementations are encouraged to provide the ability to have special plural messages for 0 in particular. »
- Portée / limites : ce guide s'adresse d'abord aux contributeurs des données CLDR. Ses principes de rédaction s'appliquent tels quels aux messages d'interface.
- En rédaction ou en revue : y a-t-il une variante `other` ? Le cas « zéro élément » est-il traité par un message dédié (`=0`, par exemple « Aucun fichier ») plutôt que par « 0 fichier » ?

### Gérer les ordinaux par les règles CLDR de chaque langue, qui ne recoupent pas les cardinaux (1er/1re, 1st/2nd/3rd, 1.er/3.er, l'8°)
- Niveau de preuve : N1
- Source : Unicode CLDR 49, `ordinals.json`, https://raw.githubusercontent.com/unicode-org/cldr-json/main/cldr-json/cldr-core/supplemental/ordinals.json ; tableau « Language Plural Rules » (URL ci-dessus)
- Extrait lu : fr `"pluralRule-count-one": "n = 1 @integer 1"` (« Prenez la 1re à droite. » / « Prenez la 2e à droite. ») ; en one/two/few/other (« Take the 1st right. », « 2nd », « 3rd », « 4th ») ; es `"pluralRule-count-one": "n % 10 = 1,3 and n % 100 != 11 @integer 1, 3, 13, 21, 23, …"` (« El 1.ᵉʳ equipo clasificado ganó. ») ; it `"pluralRule-count-many": "n = 11,8,80,800"` (« Prendi l’8° a destra. ») ; de, pt, ru, pl, ar : `other` seulement (« 15. Abzweigung nach rechts nehmen »).
- Portée / limites : la catégorie ordinale `one` de l'espagnol est **nouvelle dans CLDR 49** : absente des JSON 38.0.0 à 48.0.0, présente en 49. La note de version de CLDR 49 cite es et fr parmi les règles plurielles et ordinales modifiées, sans détail. Les moteurs JavaScript embarquent une version antérieure de CLDR : un test local sous Node 22.23 (ICU 78.3, CLDR 48) renvoie encore `other` seulement pour l'ordinal espagnol. La règle française ne donne que one/other : le genre (1er/1re) se gère par `select`, pas par le pluriel.
- En rédaction ou en revue : un suffixe ordinal est-il concaténé en dur (« {n}e ») ? Le genre de l'ordinal français est-il pris en charge ?

---

## 3. ICU MessageFormat et MessageFormat 2.0

### Placer `select` (genre) et `plural` à l'extérieur du message et écrire des phrases complètes dans chaque branche : `select` dehors, `plural` dedans
- Niveau de preuve : N3 (guide utilisateur d'ICU, projet Unicode)
- Source : ICU User Guide, « Formatting Messages », https://unicode-org.github.io/icu/userguide/format_parse/messages/
- Extrait lu : « If possible, use complex arguments as the outermost structure of a message, and write **full sentences** in their sub-messages. » ; « place the **select** arguments (with their fixed sets of choices) on the **outside** » ; « nest the plural arguments (hopefully at most one) inside. » Exemple : `{gender_of_host, select, female {{num_guests, plural, offset:1 =0 {{host} does not give a party.} … # other people to her party.}}`
- Portée / limites : il s'agit de la syntaxe MessageFormat 1 d'ICU (`plural`, `select`, `selectordinal`), la plus répandue aujourd'hui (formatjs, ICU4J, ICU4C).
- En rédaction ou en revue : la chaîne « {user} a ajouté {n} fichiers » est-elle découpée en morceaux ? Elle doit être un seul message, avec `select` sur le genre de `{user}` si l'accord l'exige (« ajouté·e » ne se pose pas au passé composé avec avoir, mais se pose dès « {user} est parti·e »).

### Compter sur le repli vers `other` sans en abuser : une catégorie absente bascule silencieusement sur `other`, et les valeurs explicites (`=0`) passent avant les catégories
- Niveau de preuve : N3 (documentation de l'API ICU4J)
- Source : ICU4J API, « PluralFormat », https://unicode-org.github.io/icu-docs/apidoc/released/icu4j/com/ibm/icu/text/PluralFormat.html
- Extrait lu : « If there is no clause with that keyword, then the "other" clauses is returned. » ; « You always have to define a message text for the default plural case » ; « When formatting, the input number is first matched against the explicitValue clauses. »
- Portée / limites : c'est le comportement d'ICU. Il explique pourquoi un message FR sans `many` ne plante pas mais produit « 1 000 000 jours ».
- En rédaction ou en revue : le traducteur voit-il toutes les catégories de **sa** langue cible, et pas seulement celles de la langue source ?

### Considérer MessageFormat 2.0 comme une spécification stable depuis CLDR 47, mais ses implémentations ICU comme partiellement en préversion
- Niveau de preuve : N1
- Source : Unicode, 13.03.2025, « Unicode CLDR 47 Release: MessageFormat 2.0 Stable », https://blog.unicode.org/2025/03/unicode-cldr-47-release-messageformat-2.html ; ICU, page d'accueil, https://icu.unicode.org/ (entrée du 22.10.2026)
- Extrait lu : « The biggest change is that the MessageFormat 2.0 specification has advanced from Final Candidate to Stable. » ; « This means that the stability guarantees are in place and implementations can finalize their APIs. » ; ICU : « 2026-10-22: ICU 79.1 is now available. » ; « C++ and Java implementations of the CLDR MessageFormat 2.0 specification have been updated to CLDR 49. Some of the API remains in technology preview. » ; ICU 78 : « Java implementation of MessageFormat 2 upgraded to "draft". »
- Portée / limites : la page du guide ICU consacrée à MF2 (https://unicode-org.github.io/icu/userguide/format_parse/messages/mf2.html) est périmée : elle parle encore d'« a Technical Preview API », conforme à « the LDML 45 version of the specification ». Elle se contredit avec la page d'accueil d'ICU, et c'est cette dernière, datée, qui fait foi. La note de CLDR 49 ajoute : « The `:currency` and `:percent` functions are now Stable ».
- En rédaction ou en revue : avant d'adopter MF2 en production, vérifier que la bibliothèque visée l'implémente en version stable, et ne pas se fier à un article de blog daté.

### Ne pas compter sur `Intl.MessageFormat` dans le navigateur : la proposition TC39 est au stade 1
- Niveau de preuve : N1 (dépôt officiel de la proposition TC39)
- Source : TC39, « proposal-intl-messageformat », https://github.com/tc39/proposal-intl-messageformat
- Extrait lu : « Stage: 1 » ; « Champions: Eemeli Aro (Mozilla/OpenJS Foundation), Ujjwal Sharma (Igalia) »
- Portée / limites : le README situe la présentation au stade 1 en mars 2022, avec des mises à jour en octobre 2023 et février 2024. Il dit encore que la spécification MF2 est « still being developed by the working group », ce qui est dépassé depuis le 13.03.2025 (entrée précédente). Le site messageformat.unicode.org annonce le support ECMA-402 comme « soon ».
- En rédaction ou en revue : un message MF2 côté navigateur passe-t-il par une bibliothèque (par exemple le paquet `messageformat` 4.x cité par Unicode) et non par une API native ?

### Écrire les sélections MF2 avec `.match` et une variante attrape-tout `*` obligatoire
- Niveau de preuve : N1 (documentation officielle de MF2)
- Source : Unicode MessageFormat, « Quick start », https://messageformat.unicode.org/docs/quick-start/
- Extrait lu : `.input {$count :number}` / `.match $count` / `one {{You have {$count} notification.}}` / `*   {{You have {$count} notifications.}}` ; « The special value `*` is used to match any value. »
- Portée / limites : la syntaxe est plus explicite que MF1 (déclarations, fonctions annotées), mais les principes de rédaction restent ceux du § 3 : phrases complètes, une variante par catégorie.
- En rédaction ou en revue : chaque `.match` a-t-il sa variante `*` ? Les variantes `many` du français, de l'espagnol et de l'italien sont-elles présentes quand c'est pertinent ?

---

## 4. Anti-patterns d'i18n

### Ne jamais assembler une phrase à partir de fragments traduits : une chaîne entière avec des variables, ponctuation comprise
- Niveau de preuve : N3
- Source : Microsoft Learn (J. Wilcox), ms.date 26.03.2024, « String concatenation », https://learn.microsoft.com/en-us/globalization/internationalization/concatenation
- Extrait lu : « Concatenated strings are one of the most challenging issues for translators to resolve during translation. » ; « By including all punctuation marks in translatable content, translators have full control of the characters used for punctuation » ; « Use a single string to contain multiple sentences, rather than having a separate string for each sentence then concatenating the strings. »
- Portée / limites : la page cite aussi la ponctuation propre au français (« French adds a space before and after the quoted text and the guillemets, as well as spaces before question marks »), le pluriel par ajout de « s » et l'accord adjectif-nom (« vélo bleu », « voiture bleue »). Elle porte la métadonnée `ai-gen-docs-bap`, c'est-à-dire une rédaction assistée par IA relue par Microsoft.
- En rédaction ou en revue : une espace, un deux-points ou un « s » est-il ajouté dans le code et non dans la chaîne ? L'espace insécable française avant « : ? ! » se trouve-t-elle dans la traduction ?

### Rendre chaque variable déplaçable (placeholders nommés ou numérotés) : l'ordre des mots change d'une langue à l'autre
- Niveau de preuve : N3
- Source : Richard Ishida (W3C), première publication le 30.03.2006, dernière mise à jour substantielle le 24.08.2021, « Working with Composite Messages », https://www.w3.org/International/articles/composite-messages/
- Extrait lu : « It must be possible to reorder variables in sentence-like arrangements and reposition them in any way relative to the text. » ; exemple allemand : `printf( "Datei %2\$s enthält %1\$d Rechtschreibfehler.", spellerrors, filename)`
- Portée / limites : les exemples sont écrits en PHP et en printf, mais le principe vaut pour `{name}` dans ICU et i18next. La forme « Sujet : valeur » (topic-comment) est jugée sans problème : « This is a perfectly valid approach and poses no issues for translation. »
- En rédaction ou en revue : les placeholders sont-ils nommés (`{fileName}`) plutôt que positionnels anonymes (`%s %d`) ? Un libellé partagé entre plusieurs cellules de tableau ou plusieurs contrôles peut-il être réordonné ?

### Ne pas réutiliser un fragment commun en y substituant des noms : en français, l'accord en genre et en nombre rend la traduction impossible
- Niveau de preuve : N3
- Source : W3C, « Working with Composite Messages » (URL ci-dessus)
- Extrait lu : « in French the word for the would be translated le , la , les , or l' , depending on what immediately follows. Similarly, the word disabled would need to be désactivé , désactivés , désactivée , désactivées , depending on the gender and number of the subject. » ; « the French translator would have been faced with an impossible job. »
- Portée / limites : cela vaut aussi pour les noms d'objets insérés par variable (« Le {objet} a été supprimé »), car le genre de `{objet}` est inconnu au moment de la traduction. Microsoft cite en outre les déclinaisons polonaises (« Widzę samochód », « Używam samochodu »).
- En rédaction ou en revue : une variable contient-elle un **nom commun traduit** plutôt qu'une valeur saisie par l'utilisateur ? Dans ce cas, écrire un message par objet, ou passer à une formulation « Sujet : valeur ».

### Ne pas mettre de texte à traduire dans les images
- Niveau de preuve : N3
- Source : Microsoft Learn, « Design software for international markets » (URL § 1)
- Extrait lu : « If your feature has images that contain text that requires translation, can you use a generic image instead? Image translation adds complexity and extra cost to the localization process. It's recommended to create generic images or icons that work for all languages. »
- Portée / limites : la page ne traite ni du texte alternatif ni des SVG au texte vectorisé. Une icône portant une lettre (« B » pour gras) est son exemple de contre-cas.
- En rédaction ou en revue : une capture, une bannière ou une icône contient-elle du texte ? Ce texte existe-t-il en clé de traduction, dans un calque texte ?

### Déclarer `lang` sur la page et sur chaque passage dans une autre langue : majuscules CSS, césure et choix de police en dépendent
- Niveau de preuve : N3
- Source : MDN, « text-transform », https://developer.mozilla.org/en-US/docs/Web/CSS/text-transform ; Microsoft Learn, « Design software for international markets » (URL § 1)
- Extrait lu : « The `text-transform` property takes into account language-specific case mapping rules such as the following » ; « In German (`de`), the `ß` becomes `SS` in uppercase. » ; « The language is defined by the `lang` HTML attribute » ; « Support for language-specific cases varies between browsers ». Microsoft : « automatic lower-casing for German would lead to grammatically incorrect sentences. Nouns, names, and gerunds must start with upper case. »
- Portée / limites : `text-transform` est Baseline « Widely available » depuis juillet 2015, avec un astérisque : « Some parts of this feature may have varying levels of support ». MDN signale un enjeu d'accessibilité : « Large sections of text set with a `text-transform` value of `uppercase` may be difficult for people with cognitive concerns such as Dyslexia to read. »
- En rédaction ou en revue : la casse est-elle imposée par CSS (`uppercase`, `capitalize`) sur des chaînes traduites ? Le « Title Case » anglais est-il reproduit en FR, ES ou DE, où il est fautif ? Écrire la casse dans la chaîne, pas dans la feuille de style.

### Activer la césure automatique seulement sur du texte dont la langue est déclarée
- Niveau de preuve : N3
- Source : MDN, « hyphens », https://developer.mozilla.org/en-US/docs/Web/CSS/hyphens ; Richard Ishida (W3C), mis à jour le 18.11.2014, « Why use the language attribute? », https://www.w3.org/International/questions/qa-lang-why
- Extrait lu : « Hyphenation rules are language-specific. In HTML, the language is determined by the `lang` attribute. Browsers will only hyphenate if this attribute is present and the appropriate hyphenation dictionary is available. » (MDN) ; « Other typographic and layout features that are affected by language include line-breaking, justification, and case conversion » (W3C)
- Portée / limites : `hyphens` est Baseline « Widely available » depuis septembre 2023, avec la mention « Some parts of this feature may have varying levels of support ». La disponibilité des dictionnaires de césure par langue, de-CH par exemple, n'a pas été vérifiée.
- En rédaction ou en revue : `<html lang>` change-t-il avec la locale active (et non `lang="en"` codé en dur) ? Les mots composés allemands sont-ils protégés contre le débordement par `hyphens: auto` avec `lang="de"` ?

---

## 5. Formats par locale (focus Suisse)

### En Suisse, le séparateur de milliers est l'apostrophe droite (U+0027) dans les trois langues, mais le séparateur décimal diffère : point en de-CH et it-CH, virgule en fr-CH
- Niveau de preuve : N1
- Source : Unicode CLDR 49, `numbers.json` par locale, https://raw.githubusercontent.com/unicode-org/cldr-json/main/cldr-json/cldr-numbers-full/main/fr-CH/numbers.json (de même pour `de-CH`, `it-CH`, `fr`, `fr-CA`, `de`, `it`)
- Extrait lu : fr-CH `"decimal": ","`, `"group": "'"`, `"currencyDecimal": "."` ; de-CH `"decimal": "."`, `"group": "'"` ; it-CH `"decimal": "."`, `"group": "'"` ; pour comparaison, de `"decimal": ","`, `"group": "."` et it `"decimal": ","`, `"group": "."`. Point de code relevé dans le fichier : `group` = 0x27 dans les trois locales suisses.
- Portée / limites : **en fr-CH, CLDR distingue la virgule pour les nombres et le point pour les montants** (`currencyDecimal`). Un test local (Node 22.23, ICU 78.3, CLDR 48) donne `1'234'567,891` et `1'234'567.89 CHF` en fr-CH, `1'234'567.891` en de-CH. Ce sont des données de logiciel : l'usage typographique suisse (espace fine, par exemple, dans des textes rédigés) n'a pas été vérifié auprès d'une source suisse officielle.
- En rédaction ou en revue : un nombre est-il écrit en dur dans une chaîne (« 1 000 ») au lieu d'être formaté par `Intl.NumberFormat` selon la locale ? Un parseur de saisie accepte-t-il l'apostrophe ?

### Formater les montants en CHF selon la locale : symbole en tête en de-CH et it-CH (« CHF 1'234.50 »), en fin en fr-CH (« 1'234.50 CHF »)
- Niveau de preuve : N1
- Source : Unicode CLDR 49, `numbers.json` (URL ci-dessus)
- Extrait lu : de-CH et it-CH `currencyFormats … "standard": "¤ #,##0.00;¤-#,##0.00"` ; fr-CH `"standard": "#,##0.00 ¤"` (espace insécable U+00A0 entre le nombre et le symbole).
- Portée / limites : le motif négatif de de-CH et it-CH colle le signe au symbole (« CHF-1'234.50 »). L'arrondi au 5 centimes n'a pas été vérifié dans CLDR.
- En rédaction ou en revue : la chaîne contient-elle « CHF {montant} » en dur ? Laisser le symbole et sa position au formateur, sans quoi la chaîne FR place « CHF » au mauvais endroit.

### Ne pas confondre fr-FR, fr-CH et fr-CA : séparateurs, dates courtes et heures diffèrent
- Niveau de preuve : N1
- Source : Unicode CLDR 49, `numbers.json` (URL ci-dessus) et `ca-gregorian.json`, https://raw.githubusercontent.com/unicode-org/cldr-json/main/cldr-json/cldr-dates-full/main/fr-CH/ca-gregorian.json (de même pour `fr`, `fr-CA`, `de-CH`)
- Extrait lu : groupe fr `" "` (espace fine insécable), fr-CA `" "` (espace insécable), fr-CH `"'"`. Date courte : fr `"dd/MM/y"`, fr-CH `"dd.MM.yy"`, fr-CA `"y-MM-dd"`, de-CH `"dd.MM.yy"`. Heure courte : fr et fr-CH `"HH:mm"`, fr-CA `"HH 'h' mm"`. Date complète : fr `"EEEE d MMMM y"`, fr-CH `"EEEE, d MMMM y"`.
- Portée / limites : il s'agit des motifs par défaut de CLDR. `Intl.DateTimeFormat` les applique. Un rédacteur ne doit donc jamais écrire un format de date dans une chaîne.
- En rédaction ou en revue : la locale passée aux formateurs est-elle la locale régionale complète (fr-CH) et pas seulement la langue (fr) ?

### Utiliser les API `Intl` (toutes Baseline « Widely available ») plutôt que des formats maison
- Niveau de preuve : N3
- Source : MDN, pages `Intl.NumberFormat`, `Intl.PluralRules`, `Intl.RelativeTimeFormat`, `Intl.ListFormat`, https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/NumberFormat (et `/PluralRules`, `/RelativeTimeFormat`, `/ListFormat`) ; Microsoft Learn, « Design software for international markets » (URL § 1)
- Extrait lu : NumberFormat « It’s been available across browsers since September 2017. » ; PluralRules « since September 2019 » (avec « Some parts of this feature may have varying levels of support ») ; RelativeTimeFormat « since September 2020 » ; ListFormat « since April 2021 ». Microsoft : « Use internationalization libraries. Don't create your own. »
- Portée / limites : la page MDN de `Intl.DateTimeFormat` n'a pas été ouverte (voir Non vérifié). La version de CLDR embarquée dépend du navigateur ou du moteur : les règles récentes, comme l'ordinal espagnol de CLDR 49, arrivent avec retard.
- En rédaction ou en revue : une énumération est-elle construite par `join(", ")` avec un « et » codé en dur (à remplacer par `Intl.ListFormat`) ? « il y a 3 jours » vient-il de `Intl.RelativeTimeFormat` ?

---

## 6. Pseudo-localisation

### Pseudo-localiser tôt, avec accents, allongement, délimiteurs et identifiant : la méthode révèle chaînes en dur, troncatures et concaténations
- Niveau de preuve : N3
- Source : Microsoft Learn, « Pseudolocalization » (URL § 1)
- Extrait lu : « Resources that haven't been exposed to localization are readily apparent because they won't be pseudo-translated. » ; « Wrapping a string instantly reveals truncations in the product user interface because the delimiter is missing. Concatenations will also be revealed by paired delimiters embedded in the displayed text. » ; « it isn't a complete replacement for validating the translated application. » Pseudo-locales Windows : « qps-ploc », « qps-plocm », « qps-ploca » ; « ICU provides for two pseudo locale names: en-XA (A for Accents) and en-XB (B for bidirectional). »
- Portée / limites : la page recommande des étiquettes de langue à usage privé (`qaa`–`qtz`, d'après la RFC 4646) pour éviter les collisions avec une vraie locale (épisode de tk-TM).
- En rédaction ou en revue : la CI ou l'environnement de développement offre-t-il une pseudo-locale ? Un texte resté sans accents en pseudo signale une chaîne non externalisée.

### Tester aussi une pseudo-locale RTL (Android `ar-XB`), même si toutes les locales du produit s'écrivent de gauche à droite
- Niveau de preuve : N3
- Source : Android Developers, « Test your app with pseudolocales », https://developer.android.com/guide/topics/resources/pseudolocales
- Extrait lu : « English (XA): adds Latin accents to the base English UI text, expands the original text by adding non-accented text, and brackets each message unit » ; « AR (XB): sets the text direction of the original left-to-right messages to the right-to-left direction » ; « String concatenation, which displays as one message split across two or more brackets. » ; « Hardcoded strings, which can't be sent to translation, display as unaccented text in the pseudolocale ».
- Portée / limites : la page Android ne donne pas de taux d'allongement chiffré. Elle exige Android 4.3 (API 18) ou plus. Aucune date de mise à jour n'est visible.
- En rédaction ou en revue : un message apparaît-il découpé en plusieurs crochets en en-XA ? C'est une concaténation à corriger.

---

## 7. Bidi et RTL

### Isoler tout texte injecté dont la direction est inconnue (nom d'utilisateur, titre saisi) avec `<bdi>` ou `dir="auto"`
- Niveau de preuve : N3
- Source : Richard Ishida (W3C) et Aharon Lanin (Google), dernière mise à jour substantielle le 25.06.2021, « Inline markup and bidirectional text in HTML », https://www.w3.org/International/articles/inline-bidi-markup/
- Extrait lu : « If you don't know the direction of text that will be inserted at run time, add dir=auto to any markup that tightly wraps the location. If there is no markup, wrap the location with a bdi element. » ; « Without a dir attribute, the bdi element behaves as if dir="auto" had been applied. »
- Portée / limites : même dans une interface FR, EN ou ES, un nom en arabe ou en hébreu suivi d'un nombre (« {user} - 5 commentaires ») peut voir l'ordre de ses éléments inversé. Hors HTML (titre de page, notification), l'article renvoie aux caractères d'isolement Unicode U+2066 LRI, U+2067 RLI et U+2069 PDI.
- En rédaction ou en revue : chaque variable venant de l'utilisateur est-elle enveloppée dans `<bdi>` à l'affichage ?

### Écrire les marges, alignements et icônes directionnelles en propriétés CSS logiques (`inline-start` / `inline-end`)
- Niveau de preuve : N3
- Source : MDN, « CSS logical properties and values », https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_logical_properties_and_values
- Extrait lu : « Logical properties define direction‐relative equivalents to their corresponding physical properties. » ; « This means content translated into languages with different writing modes will be rendered as intended. »
- Portée / limites : c'est une préparation peu coûteuse tant que le produit n'a aucune locale RTL. Microsoft rappelle que l'inversion concerne aussi « animation, shadows, tree controls, and tab order ».
- En rédaction ou en revue : un texte d'interface dit-il « à gauche » ou « à droite » ? Préférer « avant » et « après », ou désigner l'élément par son nom.

---

## 8. Gestion terminologique

### Bâtir le glossaire par concept (une définition, puis les désignations par langue), pas par mot anglais
- Niveau de preuve : N1 (résumé de la norme seul lu ; le texte intégral est payant)
- Source : ISO/TC 37/SC 1, 2022, « ISO 704:2022 Terminology work — Principles and methods », fiche lue sur https://www.evs.ee/en/iso-704-2022 (la page iso.org a renvoyé une erreur 403)
- Extrait lu : « This document establishes the basic principles and methods for preparing and compiling terminologies » ; « It describes the links between objects, concepts, definitions and designations. » ; « Valid from 05.07.2022 ».
- Portée / limites : **résumé seul lu**. Le contenu détaillé de la norme (rédaction des définitions, relations entre concepts) n'a pas été vérifié. ISO 704:2022 remplace l'édition 2009.
- En rédaction ou en revue : chaque entrée du glossaire a-t-elle une définition qui permette de trancher entre deux termes proches (« compte » ou « profil », « supprimer » ou « retirer ») ?

### Pour un glossaire de traduction de petite taille, ISO 12616-1 est la référence adaptée, plutôt qu'une gestion terminologique lourde
- Niveau de preuve : N1 (résumé de la norme seul lu)
- Source : ISO/TC 37/SC 2, 02.09.2021, « ISO 12616-1:2021 Terminology work in support of multilingual communication — Part 1: Fundamentals of translation-oriented terminography », fiche lue sur https://online.standard.no/en/iso-12616-1-2021
- Extrait lu : « This document specifies requirements and recommendations related to fundamentals of translation-oriented terminography »
- Portée / limites : **résumé seul lu**. D'après la fiche (paraphrase), la norme vise les contextes « de faible complexité » où la terminologie sert une autre activité. Elle exclut les flux complexes à rôles multiples. Elle remplace ISO 12616:2002 (selon une source secondaire, non ouverte).
- En rédaction ou en revue : le glossaire produit est-il maintenu par la personne qui rédige et traduit ? C'est exactement le cas visé par ISO 12616-1.

### Donner à chaque terme un statut normalisé (préféré, admis, déconseillé, remplacé), un contexte et une catégorie grammaticale, comme le fait TBX
- Niveau de preuve : N1 (ISO 30042:2019, résumé lu) et N3 (schéma du dialecte TBX-Basic)
- Source : ISO, 2019, « ISO 30042:2019 Management of terminology resources — TermBase eXchange (TBX) », fiche lue sur https://www.evs.ee/en/iso-30042-2019 ; LTAC Global, dialecte TBX-Basic, règles de validation, https://raw.githubusercontent.com/LTAC-Global/TBX-Basic_dialect/master/DCA/TBX-Basic_DCA.sch ; TBX Info, « TBX Data Categories », https://www.tbxinfo.net/tbx-data-categories/
- Extrait lu : ISO 30042 : « This document explains fundamental concepts and describes the metamodel, data categories, and XML styles » ; TBX-Basic : « /administrativeStatus/ type may be: 'admittedTerm-admn-sts' or 'deprecatedTerm-admn-sts' or 'supersededTerm-admn-sts' or 'preferredTerm-admn-sts' » ; catégories du module Basic : « context crossReference definition grammaticalGender geographicalUsage projectSubset responsibility source termLocation termType transactionType xGraphic ».
- Portée / limites : TBX est un format d'échange XML. Un glossaire en Markdown n'a pas à le suivre, mais ses catégories forment une liste de contrôle éprouvée. `geographicalUsage` répond au cas fr-CH / fr-FR (« courriel », « natel »), et `grammaticalGender` au genre des noms insérés par variable (§ 4).
- En rédaction ou en revue : le glossaire distingue-t-il le terme **déconseillé** (statut `deprecated`) du simple faux ami ? Indique-t-il le genre grammatical des noms FR, ES, IT et DE, et un exemple de contexte ?

---

## 9. Négociation de langue et repli

### Ne pas déduire la locale du seul `Accept-Language` : s'en servir comme point de départ, laisser l'utilisateur corriger, et mémoriser son choix
- Niveau de preuve : N3
- Source : Lloyd Honomichl (Lionbridge), W3C, 17.09.2003, retouché le 26.02.2016, « Accept-Language used for locale setting », https://www.w3.org/International/questions/qa-accept-lang-locales
- Extrait lu : « It is not a good idea to use the HTTP Accept-Language header alone to determine the locale of the user. » ; « be sure to allow them to change the language as needed […] Store the results in a database or a cookie for later visits. » ; « you may not get a header with de-DE , de-CH or de-AT […] you might only get de ».
- Portée / limites : l'article est ancien, mais ses arguments ne dépendent pas de la technologie. Il illustre le cas suisse : `de` seul ne dit ni la région, ni la devise.
- En rédaction ou en revue : la devise ou le format d'adresse sont-ils déduits de la langue ? Le sélecteur de langue est-il visible et conservé entre les sessions ?

### Ne pas déduire la langue du pays (IP), et ne pas représenter une langue par un drapeau
- Niveau de preuve : N3
- Source : Richard Ishida (W3C), 11.03.2016, « Language negotiation » (question « qa-site-conneg »), https://www.w3.org/International/questions/qa-site-conneg ; Richard Ishida (W3C), 06.09.2013, « Indicating the language of a link destination », https://www.w3.org/International/questions/qa-link-lang
- Extrait lu : « Be wary about using IP addresses or other location services to guess the language of the user. » ; « it is always best to add links to alternate language versions, and to do so on every page » ; « Don't use flags to indicate languages! Flags represent countries, not languages. Numerous countries use the same language as another country, and numerous countries have more than one official language. »
- Portée / limites : l'exemple le plus parlant est la Suisse elle-même, avec un pays et quatre langues nationales : un drapeau suisse ne désigne aucune langue.
- En rédaction ou en revue : le sélecteur affiche-t-il chaque langue par son propre nom (« Deutsch », « Français », « Italiano ») plutôt que par un drapeau ou un nom traduit dans la langue courante ?

### Construire la chaîne de repli par troncature de l'étiquette (fr-CH → fr) et définir explicitement une langue par défaut
- Niveau de preuve : N1
- Source : IETF, septembre 2006, RFC 4647 (BCP 47), « Matching of Language Tags », https://www.rfc-editor.org/rfc/rfc4647.html ; Unicode CLDR 49, `parentLocales.json`, https://raw.githubusercontent.com/unicode-org/cldr-json/main/cldr-json/cldr-core/supplemental/parentLocales.json
- Extrait lu : « In the lookup scheme, the language range is progressively truncated from the end until a matching language tag is located. » ; « If no language tag matches the request, the "default" value is returned. » CLDR : `"es-MX": "es-419"`, `"pt-CH": "pt-PT"`, `"en-CH": "en-150"`.
- Portée / limites : la RFC impose que chaque application définisse son comportement par défaut (§ 3.4.1, lu en résumé). Pour les données de locale, CLDR ne tronque pas toujours (es-MX passe par es-419, pt-CH par pt-PT). Le W3C retombe sur la version originale, « because that is the original version, is most up-to-date » (qa-site-conneg), ce qui plaide pour la langue de référence comme repli.
- En rédaction ou en revue : la chaîne de repli est-elle écrite noir sur blanc dans la configuration, par exemple fr-CH → fr → langue de référence ?

### Considérer qu'une clé absente de toutes les langues de repli affiche la clé brute ; avec un repli configuré, elle affiche l'autre langue
- Niveau de preuve : N3 (documentation de bibliothèque)
- Source : i18next, « Fallback », https://www.i18next.com/principles/fallback
- Extrait lu : « If a key does not return a value the key acts as fallback » ; « Seeing raw keys in your UI usually means a translation is missing, not that the fallback is misconfigured. » ; « Since v27 there is no fallback language by default ( fallbackLng: false ): set it to the language your app is written in. » ; « By default, if a variant (containing region, script, etc) is not found, i18next will look for the same key in the broader version of that language. » ; exemple `'de-CH': ['fr', 'it'], //French and Italian are also spoken in Switzerland`.
- Portée / limites : le comportement est propre à i18next (d'autres bibliothèques affichent l'identifiant ou un message vide). Le mécanisme de variante permet d'écrire le texte commun en `fr` et les seuls écarts en `fr-CH`.
- En rédaction ou en revue : `fallbackLng` est-il défini (sinon, depuis la v27, c'est la clé brute qui s'affiche) ? Un contrôle en CI détecte-t-il les clés présentes dans une locale et absentes des autres ?

---

## Verdict sur les règles du profil

| Règle actuelle | Verdict | Motif sourcé |
|---|---|---|
| « Pseudo-localisation : tester chaque chaîne courte avec +35 % de longueur (~l'expansion DE/ES réelle). » | **Contredite** pour les chaînes courtes | Le tableau IBM repris par le W3C donne 200–300 % de longueur cible pour 10 caractères ou moins, et 180–200 % pour 11 à 20 caractères. Microsoft recommande +40 % **en moyenne** et précise que les chaînes d'un ou deux mots grossissent davantage en proportion. +35 % n'est pas « l'expansion DE/ES réelle » : aucune source N1 à N3 ne l'établit. Reformulation proposée : « allongement dégressif (par exemple ×2 à ×3 jusqu'à 10 caractères, +40 % au-delà) » ; ces ordres de grandeur valent depuis l'anglais. |
| « Une traduction fait souvent +30 % en DE/ES. » | **Convention sans preuve trouvée** | Le chiffre n'apparaît que comme borne haute de tableaux de prestataires (DE +10 à +35 %, ES +15 à +30 %, Andiamo, N4, sans méthode). Le W3C ne cite ni 30 ni 35 %. L'expansion dépend surtout de la longueur de la chaîne. Rien n'a été trouvé pour une **source française**, alors que le français est la langue de référence du profil. |
| « Pluriels CLDR : FR/EN/ES vivent avec one/other ; le russe, le polonais ou l'arabe ont jusqu'à 6 catégories (zero, one, two, few, many, other). » | **Contredite** (en partie) | CLDR 49 : FR a `one/many/other` depuis CLDR 38, ES (avec IT et PT) depuis CLDR 40. Seuls EN et DE se limitent à `one/other`. Le russe et le polonais ont 4 catégories (`one/few/many/other`), sans `zero` ni `two`. Seul l'arabe en a 6. Il faut aussi corriger « one = 1 » : en français, `one` couvre 0 et 1. |
| « Défaut : locales FR/EN/ES, clés plates namespacées, FR langue de référence. » | **Convention sans preuve trouvée** (choix d'architecture légitime) | Aucune norme ne prescrit ce trio ni la forme des clés. Appui indirect : le W3C retombe sur la langue originale comme repli. À compléter pour la Suisse : prévoir les variantes régionales (fr-CH, de-CH, it-CH) pour les formats, même si les textes restent en `fr`, `de` ou `it`. |
| « Ne jamais ajouter une chaîne dans une seule locale (sinon la clé brute s'affiche). » | **Soutenue**, avec une nuance | i18next : « If a key does not return a value the key acts as fallback » ; depuis la v27, `fallbackLng: false` par défaut. Avec un `fallbackLng` configuré, l'utilisateur voit l'autre langue au lieu de la clé brute. La règle reste juste, mais son motif est « clé brute **ou** texte dans une autre langue ». |
| « Glossaire versionné `docs/GLOSSARY.md` : terme \| FR \| EN \| ES \| définition \| à ne pas confondre avec. » | **Soutenue** sur le fond (forme en Markdown : convention) | ISO 704 (concept, définition, désignation) et TBX (`definition`, `context`, `administrativeStatus` préféré, admis, déconseillé, remplacé, `grammaticalGender`, `geographicalUsage`). Ajouts suggérés : statut (préféré, déconseillé), genre grammatical, exemple de contexte, colonnes DE et IT, usage régional (fr-CH). |

## Mythes et affirmations contestées

- **« +30 % / +35 % en allemand et en espagnol » serait une norme.** Ce n'en est pas une : ce sont des bornes hautes de tableaux de prestataires, sans méthode publiée. Un prestataire attribue ces chiffres au W3C ; l'article W3C « Text size in translation », vérifié le 09.11.2026, ne les contient pas.
- **« Les langues romanes n'ont que singulier et pluriel. »** C'est vrai jusqu'à CLDR 37 pour le français et CLDR 39 pour ES, IT et PT. Ce n'est plus le cas aujourd'hui (catégorie `many`).
- **« Le russe a 6 formes de pluriel. »** Il en a 4 dans CLDR. Le chiffre 6 ne vaut que pour l'arabe parmi les langues étudiées.
- **« `one` signifie le nombre 1. »** C'est faux d'après CLDR, qui le qualifie de « common mistake » : en français, 0 et 1,5 relèvent de `one`.
- **« fr-CH = fr-FR + CHF. »** Les séparateurs diffèrent (apostrophe contre espace fine), le décimal des montants aussi (point en fr-CH selon CLDR), tout comme la date courte (dd.MM.yy contre dd/MM/y).
- **« MessageFormat 2.0 n'est pas stable. »** C'est faux depuis CLDR 47 (13.03.2025). Deux pages officielles restent toutefois périmées et entretiennent la confusion : le guide ICU de MF2 (« Technical Preview », LDML 45) et le README TC39 (« still being developed »). Seule une partie des API d'ICU reste en préversion (ICU 79.1, 22.10.2026).
- **« `Intl.MessageFormat` arrive dans les navigateurs. »** La proposition est au stade 1.
- **« Le pays donne la langue » ; « un drapeau désigne une langue ».** Le W3C dit le contraire explicitement (§ 9).

## Non vérifié

- **Document IBM d'origine** (« Guidelines to design global solutions », ou un *National Language Design Guide*) : introuvable. Le tableau n'est connu que par la reprise du W3C. Une recherche signale une transcription divergente (21–30 : 160-280 %, plus de 70 : 150 %) : **résumé seul lu**, non retenu.
- **SAP Fiori « UI Text Space Calculator »** (paliers de longueur cible ; pseudo-langue « 2Q ») : la page renvoie une erreur 403. **Résumé seul lu**, non retenu.
- **Expansion depuis une source française** (FR → DE, FR → ES, FR → EN) : aucune table trouvée. Tous les chiffres publiés partent de l'anglais.
- **Dates de publication de CLDR 38 et CLDR 40** : non vérifiées. Seuls les numéros de version des changements le sont, par les notes de version et les JSON étiquetés.
- **Nature exacte des changements es et fr de CLDR 49** : la note de version cite « Plural/Ordinal rules (af, bg, es, fr, gl, nn, tg, vi » sans détail. Le nouvel ordinal espagnol `one` est confirmé par comparaison des JSON 48.0.0 et 49.0.0. Le changement français n'a pas été identifié (les catégories fr sont identiques en 48 et 49).
- **Usage typographique suisse** (séparateur de milliers dans les textes rédigés, apostrophe typographique U+2019 ou droite U+0027, arrondi des montants au 5 centimes) : aucune source suisse officielle n'a été ouverte. Seules les données CLDR sont vérifiées.
- **Baseline de `Intl.DateTimeFormat`** : la page MDN n'a pas été ouverte.
- **Texte intégral d'ISO 704, ISO 12616-1 et ISO 30042** : normes payantes, résumés seuls lus.
- **Étude empirique (N2)** sur l'expansion des traductions ou sur l'effet de la pseudo-localisation : aucune trouvée.

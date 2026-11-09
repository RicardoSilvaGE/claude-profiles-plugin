# Fiche `ux-preuves` — Rédaction — orthotypographie par locale

> Fiche du skill `ux-preuves` (dev-fullstack), volet **rédaction**, préchargé par `redacteur`. Couvre : français de France et de Suisse, allemand de Suisse, anglais, espagnol, italien ; caractères Unicode (espaces insécables, apostrophe) et leur rendu dans les polices ; langue des passages et abréviations ; table des règles minimales par locale.
> **Instantané de la recherche documentaire du 09.11.2026** : chaque entrée cite une page
> réellement ouverte ce jour-là, avec un extrait lu verbatim. Les sections « Verdict sur les règles
> du profil » (ou « Ce que le profil devrait dire »), « Mythes » et « Non vérifié » sont opposables
> autant que les entrées : ce qui y figure ne se cite pas comme un fait.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

> Recherche du 9 novembre 2026 pour le référentiel d'un agent « rédacteur UX et linguiste produit senior » (FR d'abord, multilingue, poste en Suisse romande).
> Méthode : chaque entrée vient d'une page ouverte avec WebFetch, ou d'un PDF téléchargé puis passé dans `pdftotext`. Les données CLDR ont été lues dans les fichiers XML du dépôt `unicode-org/cldr` (branche `main`, `cldrVersion` 50). Deux **mesures locales** reproductibles complètent les sources : la sortie d'`Intl` sous Node v22.23.4 (ICU 78.3, CLDR 48.0) et la couverture des glyphes dans des polices, mesurée avec fontTools. Elles sont signalées comme mesures, pas comme normes.
> Sources bloquées : toutes les pages `rae.es` (Ortografía, DPD, Libro de estilo de la Justicia) ont renvoyé HTTP 403. Les règles espagnoles passent donc par des relais (FundéuRAE, presse, Microsoft). Voir § Non vérifié.

---

## 1. Français de France

### Devant `;`, `!` et `?`, mettre une espace fine insécable (U+202F) ; devant `:` et dans les guillemets « », une insécable pleine (U+00A0), selon la tradition de l'Imprimerie nationale
- Niveau de preuve : N4 (le Lexique de l'Imprimerie nationale, imprimé, n'a pas été lu directement ; règle rapportée par un contributeur CLDR)
- Source : Eric Muller, 24.12.2014, « CLDR TL;DR article » (liste CLDR-Users), https://corp.unicode.org/pipermail/cldr-users/2014-December/000192.html
- Extrait lu : « adopts an "espace fine insécable" before ; ! and ? » ; « an "espace mot insécable" before : and », and after « »
- Portée / limites : le message rapporte le Lexique de mémoire d'expert, sans citation de page. L'auteur dit aussi qu'il convertit lui-même ses espaces en U+202F « when appropriate », ce qui suppose de maîtriser toute la chaîne de production. L'édition du Lexique n'est pas précisée. L'« espace mot » a la largeur d'un espace normal. Le wiki OpenOffice, relais secondaire, attribue au même Lexique un « ½ cadratin » dans les guillemets : il apparaît dans les résultats de recherche mais n'a pas été ouvert, donc le point reste non tranché.
- En rédaction : y a-t-il une espace avant `;` `!` `?` ? Est-elle insécable ? Un `!` ou un `?` rejeté seul en début de ligne est le défaut le plus visible à l'écran. `«texte»` collé, ou `« texte »` avec une espace sécable qui laisse un guillemet orphelin en bout de ligne, sont deux autres défauts.

### En pratique logicielle, Microsoft demande une espace insécable devant `; ! : ?` et signale les ennuis qu'elle cause
- Niveau de preuve : N3
- Source : Microsoft, 2025 (PDF modifié le 28.02.2025), « French (France) Localization Style Guide », https://aka.ms/french-france-styleguide
- Extrait lu : « Remember that in French, a nonbreaking space is required before the following punctuation: ; ! : ? » ; « Note: Nonbreaking spaces sometimes cause problems in the generation of the final documents. »
- Portée / limites : Microsoft ne distingue pas la fine de l'insécable pleine et prescrit U+00A0 (raccourci « Alt+0160 »). Le même guide demande l'insécable comme séparateur de milliers, entre nombre et unité ou devise, et avant `%`. L'exemple « 5 000 € (nbsp after "5" and before "€") » y figure.
- En rédaction : la chaîne de rendu (gabarit, export, e-mail) conserve-t-elle l'insécable, ou la remplace-t-elle par une espace normale ou un `&nbsp;` littéral ?

### Au Québec, l'OQLF préfère aucune espace devant `; ! ?` mais garde l'insécable devant `:` et dans les guillemets
- Niveau de preuve : N1 (organisme officiel de la langue, Québec)
- Source : Office québécois de la langue française, s. d. (© 2026), « Types d'espacements », Banque de dépannage linguistique, https://vitrinelinguistique.oqlf.gouv.qc.ca/index.php?id=24565 ; et « Espacement avant et après les signes de ponctuation et les symboles », https://vitrinelinguistique.oqlf.gouv.qc.ca/22039/la-typographie/espacement/espacement-avant-et-apres-les-signes-de-ponctuation-et-les-symboles
- Extrait lu : « Notons que l'Office québécois de la langue française opte plutôt pour l'absence d'espace devant ces signes de ponctuation. » ; et dans le tableau, pour `;` `!` `?` : « Pas d'espace ou une espace fine ».
- Portée / limites : c'est la norme québécoise, pas celle de France ou de Suisse. Elle ne doit pas s'appliquer à une interface fr-FR ou fr-CH. Le tableau ajoute qu'« on peut opter pour l'espace fine lorsqu'elle est disponible », et que les réseaux sociaux peuvent omettre l'insécable.
- En rédaction : la locale cible est-elle fr-CA ? Si oui, `Félicitations!` sans espace est correct. Sinon, c'est un défaut.

### Accentuer les majuscules, y compris `À`, en France comme en Suisse, mais pas dans les sigles
- Niveau de preuve : N1 (Académie française ; Chancellerie fédérale)
- Source : Académie française, s. d., « Accentuation des majuscules », Questions de langue, https://dictionnaire-academie.fr/article/QDL005 ; Chancellerie fédérale, mai 2016, « Instructions … en français », ch. 3 « Accents », https://www.bk.admin.ch/dam/fr/sd-web/t4P98Y1Vnyz-/objekt_55266.pdf
- Extrait lu : Académie : « On veille donc, en bonne typographie, à utiliser systématiquement les capitales accentuées, y compris la préposition À, » et « Il convient cependant d'observer qu'en français, l'accent a pleine valeur orthographique. » ; Chancellerie : « Les lettres accentuées conservent l'accent si elles sont en majuscules (de même que le « ç » conserve la cédille). La règle ne s'applique pas aux sigles et acronymes. » (exemples « le Conseil des États », « CE, CEE »)
- Portée / limites : les deux autorités concordent, et la Chancellerie ajoute l'exception des sigles. La règle compte surtout pour les boutons ou titres passés en capitales par CSS : le texte source garde ses accents, et la police doit avoir les glyphes accentués.
- En rédaction : `ETAT`, `A propos`, `Echec` sont des fautes. Il faut écrire `ÉTAT`, `À propos`, `Échec`, mais `CEE` reste sans accent.

### Dans les titres et libellés, mettre une capitale au premier mot et aux noms propres seulement
- Niveau de preuve : N3
- Source : Microsoft, 2025, « French (France) Localization Style Guide », § 4.1.5, https://aka.ms/french-france-styleguide
- Extrait lu : « As a general rule, in French, only proper nouns and the first word of a sentence have to be capitalized. »
- Portée / limites : le guide formule une règle générale de rédaction technique, sans détail pour les titres d'œuvres ou d'institutions. Les Instructions de la Chancellerie fédérale (2016, ch. 3, lues mais non reprises ici) donnent la règle pour les dénominations officielles : majuscule seulement dans « la dénomination officielle complète » (« le Conseil fédéral », mais « le département concerné »).
- En rédaction : `Paramètres Du Compte` ou `Mot De Passe Oublié` calquent la casse anglaise.

### Utiliser l'apostrophe typographique ’ (U+2019), pas l'apostrophe droite
- Niveau de preuve : N1 (Unicode) + N3 (Microsoft)
- Source : Unicode Consortium, 2024, « The Unicode Standard, Version 16.0 — Chapter 6 », https://www.unicode.org/versions/Unicode16.0.0/core-spec/chapter-6/ ; Microsoft, 2025, « French (France) Localization Style Guide », https://aka.ms/french-france-styleguide
- Extrait lu : « U+2019 RIGHT SINGLE QUOTATION MARK is preferred where the character is to represent a punctuation mark, as for contractions » ; Microsoft : « Use curly apostrophes [0146] < ’ > in general. » et « Use straight apostrophes when instructed to do so by the developer or SPM. »
- Portée / limites : l'apostrophe droite reste obligatoire dans le code, les identifiants et les chaînes analysées par un programme. Le texte affiché en français prend la courbe.
- En rédaction : un mélange `l'` / `l’` dans un même écran trahit souvent deux sources de chaînes.

### Écrire l'heure `14 h 30`, avec des espaces insécables autour du symbole `h`
- Niveau de preuve : N1 (OQLF) ; N3 pour la France (CNRS, 1995)
- Source : OQLF, « Espacement avant et après les signes de ponctuation et les symboles », https://vitrinelinguistique.oqlf.gouv.qc.ca/22039/la-typographie/espacement/espacement-avant-et-apres-les-signes-de-ponctuation-et-les-symboles ; CNRS, Délégation aux systèmes d'information, 25.11.1995 (v1.1), « Règles typographiques de base pour la présentation d'un document », https://www.pharmacie.universite-paris-saclay.fr/sites/default/files/media/2020-09/regles-typographie_cnrs.pdf
- Extrait lu : OQLF, colonne « après » du symbole `h` : « Une espace, mais une espace insécable pour 14 h 30. » ; CNRS : « Décollage à 12 h 42, arrivée à 15 heures »
- Portée / limites : le document du CNRS date de 1995, se dit « issu[…] des règles typographiques de l'Imprimerie nationale » et vaut comme document interne. Pour la France, je n'ai trouvé aucune source officielle récente en ligne. Le format `13:30` est celui que produit `Intl` en fr-FR (mesure, section 6). Il est courant dans les interfaces, mais les sources lues ne le recommandent pas dans un texte courant.
- En rédaction : `14h30` (collé) ou `14:30` dans une phrase relèvent de la convention technique, pas typographique. Il faut choisir et s'y tenir.

### Formater les montants en euros sous la forme `12,50 €` : virgule décimale, symbole après le nombre, insécable entre les deux
- Niveau de preuve : N3 (données CLDR) + mesure locale
- Source : Unicode CLDR, branche `main` (v50), fichier `common/main/fr.xml`, https://raw.githubusercontent.com/unicode-org/cldr/main/common/main/fr.xml ; Microsoft, « French (France) Localization Style Guide », https://aka.ms/french-france-styleguide
- Extrait lu : motif monétaire standard de `fr.xml` : `#,##0.00 ¤` (U+00A0 avant `¤`) ; Microsoft : « (+) 5 000 € (nbsp after "5" and before "€") »
- Portée / limites : CLDR décrit l'usage par défaut, pas une norme. Mesure sous Node 22 : `new Intl.NumberFormat('fr-FR',{style:'currency',currency:'EUR'}).format(12.5)` donne `12,50` + U+00A0 + `€`.
- En rédaction : `€12.50`, `12.50 €` ou `12,50€` sont des calques ou des oublis d'insécable.

### Écrire les abréviations de civilité `M.`, `MM.`, `Mme`, `Mmes`, jamais `Mr`
- Niveau de preuve : N3 (document institutionnel ancien)
- Source : CNRS, 25.11.1995, « Règles typographiques de base pour la présentation d'un document », https://www.pharmacie.universite-paris-saclay.fr/sites/default/files/media/2020-09/regles-typographie_cnrs.pdf
- Extrait lu : « M., MM Monsieur, Messieurs et non Mr » ; « Mme, Mmes Madame, Mesdames » ; « p. ex. par exemple »
- Portée / limites : document de 1995. L'Académie et l'OQLF n'ont pas été ouverts sur ce point. La Chancellerie fédérale (section 2) confirme `p. ex.` et `par ex.`.
- En rédaction : `Mr Dupont`, `Mme.` (avec point), `etc...` (point d'abréviation suivi de points de suspension).

---

## 2. Français de Suisse

### En Suisse officielle, grouper les nombres de plus de quatre chiffres par une espace insécable, jamais par une apostrophe (Instructions de la Chancellerie fédérale, mai 2016)
- Niveau de preuve : N1 (directive de la Chancellerie fédérale)
- Source : Chancellerie fédérale, Services linguistiques centraux, Section française, mai 2016 (PDF du 27.05.2016), « Instructions de la Chancellerie fédérale sur la présentation des textes officiels en français », ch. 4 et 5. Page : https://www.bk.admin.ch/fr/instructions-de-la-chancellerie-federale-sur-la-presentation-des-textes-officiels-en-francais ; PDF : https://www.bk.admin.ch/dam/fr/sd-web/t4P98Y1Vnyz-/objekt_55266.pdf
- Extrait lu : « Dans les nombres comprenant plus de quatre chiffres, on place une espace insécable tous les trois chiffres en commençant par la droite » (exemples « 55 000, 12 300 000 » et « 1700, 5400 ») ; note 4 : « L'utilisation de l'apostrophe dans les nombres n'est pas admise. »
- Portée / limites : les Instructions visent les textes publiés dans la FF, le RS et le RO (« et d'autres textes présentant un lien avec la législation »), pas les interfaces. Leurs 12 pages couvrent abréviations, majuscules, nombres, espaces insécables et notes, mais **ne disent rien** sur l'espace avant `; : ! ?` ni sur les guillemets. La page « Aides à la rédaction et à la traduction » (https://www.bk.admin.ch/fr/aides-a-la-redaction-et-a-la-traduction) ne propose pas d'édition plus récente. Le texte se contredit légèrement : le ch. 5 parle d'insécable dans les nombres « de plus de trois chiffres », alors que le ch. 4 et ses exemples (`1700`) ne groupent pas les nombres à quatre chiffres. CLDR et ICU font **l'inverse** pour fr-CH (apostrophe, voir Mythes).
- En rédaction : `1'234'567` dans un texte officiel romand est refusé. `1700` est correct, `1 700` toléré. Pour une interface, cette directive sert de référence et non d'obligation.

### Écrire les montants suisses en lettres dans le texte (« 50 francs »), abréger « fr. » entre deux chiffres, et réserver « CHF » au contexte financier
- Niveau de preuve : N1
- Source : Chancellerie fédérale, mai 2016, « Instructions … en français », ch. 2 « Unités monétaires », https://www.bk.admin.ch/dam/fr/sd-web/t4P98Y1Vnyz-/objekt_55266.pdf
- Extrait lu : « On abrège toutefois le mot « franc » en « fr. » lorsqu'il est placé entre deux chiffres. » ; exemples « 50 francs (et non fr. 50.-) », « 23 fr. 50 », « 300 CHF, 5000 EUR, 10 000 USD » ; « Les abréviations « mio. » pour « million » et « mia. » pour « milliard » ne sont pas admises. »
- Portée / limites : dans ce texte, le code ISO se place **après** le nombre. D'autres sources suisses le placent devant, avec un point décimal (`CHF 55.50` chez Educa, `CHF 12.50` dans ICU de-CH). Voir Mythes.
- En rédaction : `Fr. 50.-` est l'ancienne notation commerciale, refusée par la Chancellerie. `4,16 millions de francs` prend la virgule décimale.

### Écrire l'heure `5 h 30` et la date `le 23 janvier 2016`, en chiffres arabes et avec des insécables
- Niveau de preuve : N1
- Source : Chancellerie fédérale, mai 2016, « Instructions … en français », ch. 2, 4 et 5, https://www.bk.admin.ch/dam/fr/sd-web/t4P98Y1Vnyz-/objekt_55266.pdf
- Extrait lu : « On abrège toutefois le mot « heure » en « h » lorsqu'il est placé entre deux chiffres. » (exemple « 5 h 30 ») ; « On utilise des espaces insécables pour séparer les nombres des termes ou des abréviations qui les suivent ou les précèdent » (exemples « 12 h 30, 29 fr. 50 », « 3 %, 10 kg, no 5 », « 18 janvier »)
- Portée / limites : le format numérique court des dates n'y est pas réglé. CLDR fr-CH donne `dd.MM.yy` (mesure Node : `04.03.26 13:30`), et l'agence suisse Educa écrit `le 9.8.2020` et `15.00 heures` (entrée suivante).
- En rédaction : `14:30` ou `14.30` sont des usages techniques ou alémaniques. Dans un texte officiel romand, on écrit `14 h 30`.

### En Suisse romande, l'usage institutionnel non fédéral diverge : apostrophe pour les milliers, pas d'insécable, `CHF 55.50`
- Niveau de preuve : N3 (guide d'une agence intercantonale)
- Source : Educa (agence spécialisée de la Confédération et des cantons pour l'espace suisse de la formation), novembre 2023, « Guide linguistique », https://www.educa.ch/sites/default/files/2023-12/Guide_linguistique.pdf
- Extrait lu : « Subdivision par une apostrophe en groupes de trois pour les nombres ayant plus de quatre chiffres » (exemple « 1'234'567 ») ; « Nous renonçons en principe à l'espace insécable dans les textes allemands comme dans les textes français. » (exemples « «La numérisation dans l'éducation» », « 10% ») ; « CHF 55.50 », « 15.00 heures »
- Portée / limites : le guide renvoie à la Chancellerie « si rien n'est défini » et au *Guide du typographe romand* (non lu), mais il **contredit** la Chancellerie sur l'apostrophe. C'est la preuve qu'en Suisse romande il n'y a pas d'usage unique et que la charte du client prime.
- En rédaction : quelle référence le client a-t-elle adoptée : Chancellerie, *Guide du typographe romand* ou charte maison ? Il faut la noter dans le glossaire du projet avant d'écrire.

### Septante et nonante sont officiels en Suisse, huitante y a supplanté octante, mais dans une interface on écrit les nombres en chiffres
- Niveau de preuve : N1 (Académie française) ; usage officiel fédéral non confirmé dans un texte de la Chancellerie
- Source : Académie française, s. d., « Septante, octante, nonante », Questions de langue, https://dictionnaire-academie.fr/article/QDL078
- Extrait lu : « Ils sont officiels en Belgique et en Suisse » ; « supplanté par quatre-vingts et huitante — en Suisse — »
- Portée / limites : aucune règle sur ces formes n'a été trouvée dans les deux textes de la Chancellerie lus (Instructions 2016, GLLOC du 15.07.2025, recherche plein texte « septante|nonante|huitante » sans résultat). Le lien de l'Académie entre « huitante » et des textes administratifs n'est pas sourcé. Les Instructions demandent les chiffres pour les unités, montants, dates et âges.
- En rédaction : une interface affiche `80`, pas le nombre en lettres. Pour un texte lu à voix haute ou un message vocal destiné à la Suisse romande, préférer `septante` et `nonante`. `Huitante` reste régional (non vérifié par une source officielle).

---

## 3. Allemand de Suisse

### En allemand de Suisse, ne jamais écrire « ß » : toujours « ss »
- Niveau de preuve : N1 (Chancellerie fédérale et règle orthographique officielle)
- Source : Schweizerische Bundeskanzlei, 2017 (4e éd.), « Leitfaden zur deutschen Rechtschreibung », copie publiée par le canton de Zoug : https://kr-geschaefte.zug.ch/dokumente/11186/3468-2-17179_Beilage1-Leitfaden-Bund.pdf ; Rat für deutsche Rechtschreibung, 2024, « Amtliches Regelwerk », § 25 E2, https://www.rechtschreibrat.com/DOX/RfdR_Amtliches-Regelwerk_2024.pdf
- Extrait lu : Leitfaden, Rz. 1.7 : « Anstelle des Eszett wird immer Doppel-s geschrieben, und es wird zwischen den beiden s getrennt: Strasse, reissen. » ; Regelwerk § 25 E2 : « In der Schweiz und in Liechtenstein kann immer ss geschrieben werden: Straße – Strasse. »
- Portée / limites : le Regelwerk **permet** (« kann ») le `ss`, et la Chancellerie l'**impose** pour les textes fédéraux. Le Leitfaden signale lui-même les paires ambiguës (`Masse`/`Maße`, `Busse`/`Buße`) et demande alors de reformuler. La copie lue est l'édition 2017 hébergée par Zoug : je n'ai pas trouvé de page bk.admin.ch qui confirme qu'elle est toujours l'édition en vigueur.
- En rédaction : une chaîne `de-CH` copiée depuis `de-DE` sans adaptation (`Straße`, `schließen`, `Größe`) est le défaut le plus courant. Il faut aussi vérifier `ẞ` en capitales.

### En allemand de Suisse, utiliser les guillemets « » et ‹ ›, pas les » « allemands ni les „ “
- Niveau de preuve : N1
- Source : Schweizerische Bundeskanzlei, 2013, éd. corrigée 2015 (page datée du 20.07.2022), « Schreibweisungen. Weisungen der Bundeskanzlei zur Schreibung und zu Formulierungen in den deutschsprachigen amtlichen Texten des Bundes », Rz. 202-203, https://www.bk.admin.ch/dam/de/sd-web/YVHazXZRkqKn/schreibweisungen.pdf
- Extrait lu : « Es sind die oben → 201 angegebenen typografi­schen Anführungs- und Schlusszeichen (Guille­mets) « » zu schreiben. Die in Deutschland üb­li­che Schreibung » « ist in der Schweiz für amt­liche Texte nicht zulässig. » ; deuxième niveau : « kommen halbe Anführungszeichen zum » (exemple « ‹Zukunft für Schweizer Fahrende› »)
- Portée / limites : les guillemets se collent au texte (exemple `«Zukunft für Schweizer Fahrende»`), avec une espace avant l'ouvrant et après le fermant. **CLDR `de_CH` n'a pas de délimiteurs propres et hérite des `„ “` de `de`** (fichier lu). Une bibliothèque qui s'appuie sur CLDR produira donc la mauvaise forme pour la Suisse.
- En rédaction : `„Text“` dans une interface de-CH est un calque de de-DE. On écrit `«Text»`, et `‹…›` pour le second niveau.

### En allemand de Suisse, grouper les nombres par une espace fixe (Festabstand), sans grouper les nombres à quatre chiffres, et ne plus utiliser l'apostrophe
- Niveau de preuve : N1
- Source : Schweizerische Bundeskanzlei, « Schreibweisungen », Rz. 512-513, https://www.bk.admin.ch/dam/de/sd-web/YVHazXZRkqKn/schreibweisungen.pdf
- Extrait lu : « Besteht eine Zahl aus vier Ziffern, so wird die erste nicht abgesetzt » ; « Zur Gliederung wird ein Festabstand → 251 ver­wendet » ; « Die früher gebräuchliche Schreibung mit Apos­troph → 209 sollte nicht mehr angewendet wer­den, weil sie für die Drucklegung wieder rück­gängig gemacht werden muss. Nicht korrekt ist die Gliederung mit Punkten oder Kommas. »
- Portée / limites : dans un tableau qui contient des nombres à cinq chiffres ou plus, on groupe aussi ceux à quatre chiffres (Rz. 513). CLDR et ICU produisent `1'234'567.89` pour de-CH (mesure, section 6), soit la notation que la Chancellerie déconseille. Le `Festabstand` correspond au raccourci CTRL+⇧+Espace, donc une insécable pleine.
- En rédaction : `1.234` (à l'allemande) est une faute en de-CH. `1'234` correspond à l'usage CLDR et à l'usage courant. `1234` et `12 345` sont la forme officielle.

### En allemand de Suisse, mettre une virgule décimale, sauf dans les montants : `Fr. 23.50`, `EUR 64.15`
- Niveau de preuve : N1
- Source : Schweizerische Bundeskanzlei, « Schreibweisungen », Rz. 514 et 543-546, https://www.bk.admin.ch/dam/de/sd-web/YVHazXZRkqKn/schreibweisungen.pdf
- Extrait lu : « Bei Geldbeträgen ist zwischen der Währungs­einheit und der Untereinheit anstelle des Dezi­malkommas der Dezimalpunkt zu setzen » (exemples « Fr. 23.50 [falsch: Fr. 23,50] », « Fr. 20.– », « aber: 4,16 Millionen Franken ») ; « EUR 1.– entspricht CHF 1.66 bzw. USD 1.38. »
- Portée / limites : en allemand, la Chancellerie place l'unité avant le montant (`Fr. 15.40`, `CHF 1.66`), ce que fait aussi ICU de-CH (`CHF 12.50`). En français, la même Chancellerie écrit `300 CHF` et `23 fr. 50` (section 2). Les deux langues officielles ont donc des conventions monétaires différentes.
- En rédaction : sur une interface bilingue FR/DE, on ne recopie pas le format du montant d'une langue à l'autre.

### En allemand de Suisse, écrire l'heure `14.30 Uhr` et la date `2. September 2006` ou `2.9.2006`, sans zéros de tête dans un texte
- Niveau de preuve : N1
- Source : Schweizerische Bundeskanzlei, « Schreibweisungen », Rz. 533-536, https://www.bk.admin.ch/dam/de/sd-web/YVHazXZRkqKn/schreibweisungen.pdf
- Extrait lu : « Zwischen den Stunden und den Minuten steht ein Punkt (kein Doppelpunkt). » ; « In Texten ist die Reihenfolge für Daten: Tag / Monat / Jahr. » ; « 2.9.2006 [nicht empfohlen: 02.09.2006] » ; pour les noms de fichiers : « Jahr / Monat / Tag » (« 20130404_Dokumentname »)
- Portée / limites : le zéro de tête est « in Formularen üblich ». ICU de-CH produit `04.03.26, 13:30`, avec deux-points et zéros (mesure). L'interface et le texte n'obéissent donc pas à la même convention.
- En rédaction : dans une phrase, on écrit `am 4. März 2026 um 14.30 Uhr`. Les champs de formulaire suivent le format machine.

### En allemand, écrire les substantifs avec une majuscule
- Niveau de preuve : N1
- Source : Rat für deutsche Rechtschreibung, 2024, « Amtliches Regelwerk », https://www.rechtschreibrat.com/DOX/RfdR_Amtliches-Regelwerk_2024.pdf
- Extrait lu : « Substantive werden großgeschrieben. » (renvoi § 55) ; § 57 : « Wörter anderer Wortarten schreibt man groß, wenn sie als Substan- » [tive gebraucht werden]
- Portée / limites : la règle vaut pour tout l'espace germanophone. En de-CH, elle porte aussi sur les substantivations (`das Velofahren`, exemple du Regelwerk). Le « sentence case » anglais n'a pas d'équivalent direct : un titre allemand en casse de phrase garde ses majuscules aux noms.
- En rédaction : appliquer en allemand une règle « tout en minuscules sauf le premier mot » donne des fautes (`neue nachricht`).

---

## 4. Anglais

### En anglais, mettre les titres, en-têtes et libellés d'interface en sentence case (Microsoft, Google, GOV.UK)
- Niveau de preuve : N3
- Source : Microsoft, 2024 (ms.date 26.08.2024), « Capitalization — Microsoft Style Guide », https://learn.microsoft.com/en-us/style-guide/capitalization ; Google, s. d., « Capitalization », Google developer documentation style guide, https://developers.google.com/style/capitalization ; GOV.UK, s. d., « A to Z style guide », https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/style-guides/a-to-z-style-guide/
- Extrait lu : Microsoft : « Capitalize the first word of a sentence, heading, title, UI label (such as the name of a button or checkbox), or standalone phrase. » ; Google : « In document titles and headings, use sentence case. » ; GOV.UK : « Always use sentence case, even in page titles and service names. »
- Portée / limites : Microsoft réserve le title case aux noms de produits, aux titres d'œuvres et aux titres de personnes. La page Google lue parle des titres de documentation, pas des composants d'interface.
- En rédaction : `Save As Draft` est un title case non voulu. On écrit `Save as draft`.

### Apple ne prescrit pas le sentence case : la règle est de choisir un style par type d'élément et de s'y tenir
- Niveau de preuve : N3
- Source : Apple, s. d., « Writing », Human Interface Guidelines, https://developer.apple.com/design/human-interface-guidelines/writing (texte lu dans la version JSON de la page : https://developer.apple.com/tutorials/data/design/human-interface-guidelines/writing.json)
- Extrait lu : « Title case is generally considered formal, while sentence case is more casual. Choose a style for each UI element type and use it consistently throughout your app — for example, title case for all alerts or sentence case for all headlines. »
- Portée / limites : cette consigne contredit l'idée reçue « toutes les plateformes recommandent le sentence case » (voir Mythes). Material Design 3 n'a pas pu être lu (page rendue en JavaScript, texte vide).
- En rédaction : la casse est-elle cohérente **par type d'élément** (toutes les alertes, tous les boutons) ? Un mélange dans un même type est le vrai défaut.

### En anglais, mettre la virgule d'Oxford devant `and` ou `or` dans une liste de trois éléments ou plus (Microsoft, Google)
- Niveau de preuve : N3
- Source : Microsoft, 2019 (ms.date 11.03.2019), « Commas — Microsoft Style Guide », https://learn.microsoft.com/en-us/style-guide/punctuation/commas ; Google, s. d., « Commas », https://developers.google.com/style/commas
- Extrait lu : Microsoft : « Before the conjunction in a list of three or more items. (The comma that comes before the conjunction is known as the Oxford or serial comma.) » ; Google : « In a series of three or more items, use a comma before the final and or or » et « to avoid potentially changing the meaning of the sentence. »
- Portée / limites : c'est une convention de maison, pas une norme de la langue. GOV.UK n'a pas d'entrée sur ce point dans sa page A-Z.
- En rédaction : la règle est-elle appliquée partout dans le produit ? À ne pas transposer en français, où la virgule devant « et » final n'est pas d'usage.

### Ne pas afficher de dates entièrement numériques ambiguës (`03/04/02`) : écrire le nom du mois, ou ISO 8601 (`2026-03-04`) en contexte technique
- Niveau de preuve : N3 (W3C Internationalization)
- Source : W3C Internationalization, s. d., « Date formats », https://www.w3.org/International/questions/qa-date-format
- Extrait lu : « If there is likely to be any ambiguity on the part of the user, it is usually best to use explicit month names » ; « ISO 8601 specifies a format of YYYY-MM-DD. » ; « 2003-04-02 is clearer than 03/04/02. »
- Portée / limites : mesure sous Node 22 : la même date (4 mars 2026) s'affiche `3/4/26` en en-US, `04/03/2026` en fr-FR et `04.03.26` en fr-CH ou de-CH. GOV.UK veut `4 June 2017`, sans ordinal ni virgule.
- En rédaction : une date courte numérique figée (`MM/DD`) dans une maquette multilingue est une erreur garantie pour la moitié des lecteurs.

---

## 5. Espagnol et italien

### En espagnol, ouvrir les questions et exclamations par `¿` et `¡`, même dans une interface
- Niveau de preuve : N3 (Microsoft) ; N4 pour la position de la RAE, rapportée par la presse
- Source : Microsoft, 2024 (PDF modifié le 04.09.2024), « Spanish (Spain) Localization Style Guide », § 4.1.14, https://download.microsoft.com/download/9/a/1/9a19beca-597c-417b-a2c2-0f1ea5a1e6c3/spa-esp-StyleGuide.pdf ; Mario de las Heras, 26.11.2024, *El Debate*, https://www.eldebate.com/cultura/20241126/puede-prescindir-espanol-signo-apertura-interrogacion-exclamacion_247867.html
- Extrait lu : Microsoft : « The exceptions are the opening “¡” and “¿” used in Spanish. Follow normative rules regarding the use of punctuation. » (exemple « ¿Quieres continuar? ») ; *El Debate*, citant la RAE : « es incorrecto prescindir del signo de apertura en los enunciados interrogativos o exclamativos »
- Portée / limites : les pages de la RAE (Ortografía § 3.4.9, DPD) ont renvoyé HTTP 403. La source de la citation de la RAE dans l'article n'est pas datée.
- En rédaction : `Quieres continuar?` sans `¿` est un calque de l'anglais. L'erreur apparaît souvent quand une variable insère la question dans un gabarit.

### En espagnol et en italien, mettre une capitale au premier mot seulement dans les titres, menus et boutons
- Niveau de preuve : N3
- Source : Microsoft, 2024, « Spanish (Spain) Localization Style Guide », § 4.1.5, https://download.microsoft.com/download/9/a/1/9a19beca-597c-417b-a2c2-0f1ea5a1e6c3/spa-esp-StyleGuide.pdf ; Microsoft, 2024 (PDF modifié le 04.09.2024), « Italian Localization Style Guide », § 4.1.5, https://aka.ms/italian-styleguide
- Extrait lu : espagnol : « In headings, captions, table and figure titles, use initial capitals only for the first word and for proper nouns and interface terms that require it. » (exemple « Guía de referencia rápida ») ; italien : « In titles and headings, only the first character of the first word should have a capital letter. » et « The names of days, months, currencies, languages, and nationalities begin with a lowercase letter. »
- Portée / limites : le guide espagnol renvoie aux « normative rules », celles de la RAE, que je n'ai pas pu lire (403). L'Accademia della Crusca n'a pas été consultée.
- En rédaction : `Guía De Referencia Rápida` ou `Lunedì 4 Marzo` sont des calques de l'anglais.

### En espagnol, grouper les milliers par une espace (pas de point ni de virgule) et ne pas grouper les nombres à quatre chiffres
- Niveau de preuve : N3 (FundéuRAE, fondation liée à la RAE, relayée par l'agence EFE)
- Source : FundéuRAE / EFE, 05.06.2023, « FundéuRAE: miles y millones, claves de escritura », republié par SWI swissinfo.ch, https://www.swissinfo.ch/spa/fund%C3%A9urae-miles-y-millones-claves-de-escritura/48566582
- Extrait lu : « es impropio emplear punto o coma en lugar del espacio » ; « en los números de cuatro dígitos es frecuente y válido omitir el espacio »
- Portée / limites : la recommandation **contredit CLDR** : `es.xml` déclare `<group>.</group>` et `minimumGroupingDigits` = 2, et ICU produit `1.234.567,89` en es-ES (mesure). La page Ortografía de la RAE (403) n'a pas été lue, et sa recommandation sur le séparateur décimal n'est pas vérifiée.
- En rédaction : la sortie d'`Intl` (`1.234.567`) diffère de la norme académique (`1 234 567`). Il faut décider explicitement et documenter le choix, au lieu de le subir.

### Guillemets : en espagnol, la norme est « » mais Microsoft emploie “ ” ; en italien, « » au premier niveau et “ ” au second, sans guillemets simples, avec le point pour les milliers et la virgule décimale
- Niveau de preuve : N3 (Microsoft + CLDR)
- Source : Microsoft, 2024, « Spanish (Spain) Localization Style Guide », « Quotation marks », https://download.microsoft.com/download/9/a/1/9a19beca-597c-417b-a2c2-0f1ea5a1e6c3/spa-esp-StyleGuide.pdf ; Unicode CLDR, branche `main`, `common/main/it.xml`, https://raw.githubusercontent.com/unicode-org/cldr/main/common/main/it.xml ; Microsoft, 2024, « Italian Localization Style Guide », https://aka.ms/italian-styleguide
- Extrait lu : espagnol : « The recommended use of quotations marks in the normative references for Spanish is to use chevrons (« »). However, with the widespread use of English texts and translations, […] quotes (“ ”) are seen in Spanish printed material. In Microsoft Spanish documentation, curly or smart quotes will be used in normal text. » ; `it.xml` : `<quotationStart>«</quotationStart>`, `<alternateQuotationStart>“</alternateQuotationStart>`, `<decimal>,</decimal>`, `<group>.</group>`, `<minimumGroupingDigits>2</minimumGroupingDigits>` ; Microsoft, italien : « Avoid single quotation marks. » et « Punctuation should always be placed outside quotes. »
- Portée / limites : Microsoft reconnaît lui-même l'écart à la norme espagnole, et CLDR `es` hérite ses délimiteurs de `root` (`“ ”`). En italien, Microsoft accepte de suivre les guillemets de la source anglaise pour des raisons techniques. Aucune autorité italienne (Crusca) n'a été lue. En it-CH, ICU produit l'apostrophe suisse (`1'234'567.89`, mesure).
- En rédaction : en espagnol, le choix des guillemets est libre, mais une fois fait il vaut pour tout le produit. En it-IT, on écrit `1.234` ou `1234` ; en it-CH, voir le choix suisse.

---

## 6. Mise en œuvre numérique

### Employer U+202F (espace fine insécable) pour la typographie française soignée, U+00A0 (insécable pleine) quand la fine n'est pas garantie
- Niveau de preuve : N1 (Unicode)
- Source : Unicode Consortium, 2024, « The Unicode Standard, Version 16.0 — Chapter 6 », https://www.unicode.org/versions/Unicode16.0.0/core-spec/chapter-6/
- Extrait lu : « The NNBSP can be used to represent the narrow space occurring around punctuation characters in French typography »
- Portée / limites : Unicode indique que la fine peut servir à cet usage, il ne l'impose pas. Microsoft (section 1) prescrit U+00A0. Le choix dépend du rendu réel (entrées suivantes).
- En rédaction : les chaînes contiennent-elles un vrai caractère (U+202F ou U+00A0), une entité HTML qui ne passera pas hors du HTML (`&nbsp;` dans un JSON envoyé vers une application mobile), ou une espace ordinaire ?

### CLDR utilise U+202F comme séparateur de milliers en français depuis CLDR 34, ce qui a cassé des tests qui comparaient des chaînes formatées
- Niveau de preuve : N3 (données de référence) + N4 (retour de praticien)
- Source : Unicode CLDR, s. d., « CLDR 34 Release Note », https://cldr.unicode.org/downloads/cldr-34 ; Phil Haack, 17.05.2020, « The French Thousand Separator Mystery », https://haacked.com/archive/2020/05/17/french-thousand-separator-mystery/
- Extrait lu : CLDR : « French grouping separator changed from no-break space U+00A0 to narrow no-break space U+202F. » ; Haack : « Assert.AreEqual failed. Expected:<12 000,3000>. Actual:<12 000,3000>. »
- Portée / limites : c'est toujours le cas dans `fr.xml` de la branche `main` (`<group>` = U+202F, lu). Mesure Node 22 (ICU 78.3, CLDR 48) : `fr-FR` → `1` U+202F `234` U+202F `567,89`. En fr-CA, CLDR garde U+00A0.
- En rédaction et en test : ne jamais comparer une chaîne formatée à un littéral écrit à la main avec une espace. Il faut normaliser, ou comparer à la sortie de la même bibliothèque.

### U+202F peut manquer dans la police ou dans son sous-ensemble chargé : le caractère passe alors par une police de repli
- Niveau de preuve : N4 (retours de praticiens) + mesure locale
- Source : Morgan Cugerone, 21.08.2020, « Narrow non-breaking space not rendering », https://cugerone.netlify.app/blog/troubleshooting-narrow-non-breaking-space-not-rendering ; ksesong, ouvert le 04.11.2019, « IBM/plex issue #282 », https://github.com/IBM/plex/issues/282
- Extrait lu : Cugerone : « the culprit was the `sans-serif` font family in use » (graisse grasse sans le glyphe) et, citant un autre rapport, « the glyph (U+202F) doesn't exist in Georgia font » ; IBM Plex #282 : « This character is expected in some languages, particularly in French »
- Portée / limites : **mesure du 09.11.2026** avec fontTools sur des paquets npm. `@ibm/plex-sans` 1.1.0 complet (Regular, Bold) contient U+202F, mais son sous-ensemble `Latin1` ne le contient pas : le glyphe est dans le sous-ensemble `Pi`. `@fontsource/jost` 5.3.0 (sous-ensembles `latin` et `latin-ext`, 400 et 700) ne contient **ni U+202F ni U+2009**, mais contient U+00A0 et ’. Une page qui charge seulement ces sous-ensembles affiche la fine dans une autre police, avec une largeur qui n'est pas celle du dessin d'origine. Je n'ai pas vérifié le fichier Jost d'origine, hors sous-ensembles fontsource.
- En rédaction et en intégration : avant d'adopter U+202F, vérifier que la police **et le sous-ensemble effectivement chargé** contiennent le glyphe, en gras compris. Sinon, U+00A0.

### `Intl` (ICU/CLDR) ne suit pas les directives officielles suisses : apostrophe pour les milliers, point décimal dans les montants, „ “ hérités en de-CH
- Niveau de preuve : N3 (données CLDR) + mesure locale
- Source : Unicode CLDR, branche `main`, `common/main/fr_CH.xml` et `de_CH.xml`, https://raw.githubusercontent.com/unicode-org/cldr/main/common/main/fr_CH.xml , https://raw.githubusercontent.com/unicode-org/cldr/main/common/main/de_CH.xml
- Extrait lu : `fr_CH.xml` : `<group>'</group>`, `<currencyDecimal>.</currencyDecimal>`, `<alternateQuotationStart>‹</alternateQuotationStart>` ; `de_CH.xml` : `<decimal>.</decimal>`, `<group>'</group>`, délimiteurs `↑↑↑` (hérités de `de` : `„ “`)
- Portée / limites : mesure sous Node 22 : `fr-CH` donne `1'234'567,89` et `12.50 CHF` ; `de-CH` donne `1'234'567.89` et `CHF 12.50`, le séparateur étant l'apostrophe ASCII U+0027. C'est l'usage courant et commercial. La Chancellerie (FR et DE) le refuse ou le déconseille pour les textes officiels.
- En rédaction : pour un client public suisse, un format de nombre délégué à `Intl` ne respecte pas la directive fédérale. La décision doit être explicite (options de formatage, ou post-traitement).

---

## 7. Accessibilité et typographie du texte

### Marquer par `lang` les passages dans une autre langue (WCAG 3.1.2, niveau AA), sauf noms propres, termes techniques et mots entrés dans l'usage
- Niveau de preuve : N1 (W3C Recommendation)
- Source : W3C WAI, « Understanding SC 3.1.2: Language of Parts (Level AA) », WCAG 2.2, https://www.w3.org/WAI/WCAG22/Understanding/language-of-parts.html
- Extrait lu : « except for proper names, technical terms, words of indeterminate language, » ; « If changes are not marked, the synthesizer will try its best to speak the words in the default language it works in. »
- Portée / limites : le critère est de niveau AA, donc exigible dans la plupart des cadres de conformité. Il porte sur des passages, pas sur chaque emprunt (`e-mail`, `cookie`).
- En rédaction : sur une interface suisse multilingue, un sélecteur de langue (`Deutsch`, `Italiano`), une citation ou une mention légale dans une autre langue doit porter `lang="de"`, `lang="it"`, etc.

### Développer les sigles à leur première occurrence (Chancellerie) et rendre leur forme longue disponible (WCAG 3.1.4, niveau AAA), sans compter sur l'attribut `title` seul
- Niveau de preuve : N1 (critère WCAG ; directive de la Chancellerie) + N3 (technique H28)
- Source : W3C WAI, « Understanding SC 3.1.4: Abbreviations (Level AAA) », https://www.w3.org/WAI/WCAG22/Understanding/abbreviations.html ; W3C WAI, « H28: Providing definitions for abbreviations by using the abbr element », https://www.w3.org/WAI/WCAG22/Techniques/html/H28 ; Chancellerie fédérale, mai 2016, « Instructions … en français », ch. 2, https://www.bk.admin.ch/dam/fr/sd-web/t4P98Y1Vnyz-/objekt_55266.pdf
- Extrait lu : 3.1.4 : « A mechanism for identifying the expanded form or meaning of abbreviations is available. » ; H28, citant la spécification HTML : « Relying on the title attribute is currently discouraged as many user agents do not expose the attribute » ; Chancellerie : « On peut utiliser des abréviations et des sigles à condition d'introduire entre parenthèses l'abréviation ou le sigle la première fois que le terme concerné apparaît. »
- Portée / limites : le niveau AAA n'est généralement pas exigé. La technique la plus robuste est rédactionnelle (développer à la première occurrence), et les sigles s'écrivent en capitales sans accent ni point (exemples Chancellerie « CE, CEE »). Quand l'espace manque à l'écran, le développement peut aller dans une aide contextuelle accessible au clavier.
- En rédaction : un sigle métier (`AVS`, `LPP`, `TVA`) est-il développé une fois à l'écran, ou caché dans un `title` invisible au clavier et sur mobile ?

### Ne pas écrire de texte suivi en capitales ni s'en servir pour insister ; si un style l'exige, l'appliquer par CSS (`text-transform`), car certains lecteurs d'écran lisent les capitales comme des sigles
- Niveau de preuve : N3 (guidelines Microsoft, GOV.UK, Stanford) + N4 (article de praticien)
- Source : Microsoft, « Capitalization », https://learn.microsoft.com/en-us/style-guide/capitalization ; GOV.UK, « A to Z style guide », https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/style-guides/a-to-z-style-guide/ ; Stanford University IT, modifié le 14.05.2026, « All caps », https://uit.stanford.edu/accessibility/learn-about/typography/all-caps ; Bureau of Internet Accessibility, 01.05.2024, « All-Caps Headings: Are They Bad for Accessibility? », https://www.boia.org/blog/all-caps-headings-are-they-bad-for-accessibility
- Extrait lu : Microsoft : « Don't use all uppercase for emphasis. (It's OK to use italic sparingly for emphasis.) » ; GOV.UK : « DO NOT USE BLOCK CAPITALS FOR LARGE AMOUNTS OF TEXT AS IT'S QUITE HARD TO READ. » ; Stanford : « screen readers may interpret these text in all caps as acronyms, misinterpreting the content. » et « Using CSS or software formatting for all caps is preferable to manually typing in capitals, » ; BOIA : « Some older screen readers (software that converts text to audio) and text-to-speech (TTS) software » [may read] « capitalized text letter-by-letter. » et « The Web Content Accessibility Guidelines (WCAG) does not have specific guidelines for all-caps text. »
- Portée / limites : Microsoft et GOV.UK motivent la règle par la lisibilité, pas par des mesures publiées. La lecture lettre à lettre n'est **pas universelle** (« some older ») et dépend de la verbosité. Aucun test de lecteur d'écran n'a été fait ici. Le garde-fou rédactionnel reste valable : la source garde la casse normale et les accents (section 1).
- En rédaction : `WARNING: THIS CANNOT BE UNDONE` doit devenir un message en casse de phrase avec un signal visuel. `CONTACT US` saisi en dur peut être lu « contact U.S. » : on écrit `Contact us` dans la source et on stylise par CSS.

---

## Ce que le profil devrait dire

Les règles minimales, par locale, se bornent à ce qui a été vérifié ci-dessus. « Off. » renvoie à la directive officielle (Chancellerie ou académie), « Courant » à l'usage CLDR/ICU, que produit `Intl`. Quand ces deux colonnes divergent, **la règle consiste à décider explicitement et à noter le choix dans le glossaire du projet**.

| Locale | Ponctuation haute et guillemets | Nombres | Montants | Heure / date | Casse | À ne jamais faire |
|---|---|---|---|---|---|---|
| **fr-FR** | `;` `!` `?` : U+202F si la police (et le sous-ensemble chargé) l'a, sinon U+00A0 ; `:` : U+00A0 ; `« texte »` avec U+00A0 dedans ; apostrophe ’ (U+2019) | milliers : U+202F (CLDR) ou U+00A0 ; décimale : virgule | `12,50 €` (U+00A0 avant `€`) | `14 h 30` dans un texte ; `4 mars 2026` | capitale au premier mot seulement ; majuscules accentuées (`À`, `É`) | `14h30` collé, `€12.50`, `Mr`, `ETAT` sans accent, Title Case anglais |
| **fr-CH** | pas de règle de la Chancellerie sur l'espace avant `; ! ?` (non vérifié) ; à défaut, règle fr-FR, sauf charte client contraire (Educa n'en met pas) ; ’ | Off. : `1700`, `55 000` (insécable dès 5 chiffres), **apostrophe interdite** ; Courant : `1'234'567,89` | Off. : `50 francs`, `23 fr. 50`, `300 CHF` ; Courant : `12.50 CHF`, `CHF 55.50` | Off. : `5 h 30`, `le 23 janvier 2016` ; Courant : `04.03.26 13:30` | majuscules accentuées, sauf sigles | `fr. 50.-`, `mio.`/`mia.`, mélanger Off. et Courant dans un même écran |
| **de-CH** | `«Text»`, second niveau `‹Text›` ; jamais `» «` ni `„ “` | Off. : `1234`, `12 345` (Festabstand), apostrophe déconseillée ; Courant : `1'234'567.89` | `Fr. 23.50`, `Fr. 20.–`, `CHF 1.66` (point dans les montants, virgule ailleurs : `4,16 Mio. CHF`) | `14.30 Uhr` ; `2. September 2006` / `2.9.2006` | Substantive groß | **`ß`** (toujours `ss`), `1.234`, `Fr. 23,50` |
| **en** | Oxford comma (Microsoft, Google) | `1,234.5` | `$12.50` | pas de date tout numérique ambiguë : nom du mois, ou ISO 8601 `2026-03-04` en technique | sentence case (Microsoft, Google, GOV.UK) ; chez Apple, cohérence par type d'élément | TOUT EN CAPITALES pour insister, Title Case non choisi |
| **es** | `¿…?` `¡…!` obligatoires ; norme `« »`, Microsoft `“ ”` (choisir) | Fundéu : espace (`1 234 567`), 4 chiffres sans espace ; Courant (CLDR) : `1.234.567,89` → décider | `12,50 €` | — (non vérifié) | capitale au premier mot | omettre `¿` / `¡` |
| **it** | `« »`, second niveau `“ ”` ; pas de guillemets simples ; ponctuation hors des guillemets | `1.234.567,89` (CLDR) ; it-CH : apostrophe (Courant) | `12,50 €` | jours et mois en minuscules (`lunedì`, `giugno`) | capitale au premier mot | Title Case, `Lunedì` en milieu de phrase |

Règles transverses, quelle que soit la locale :
1. **Accessibilité** : `lang` sur tout passage dans une autre langue (WCAG 3.1.2 AA) ; sigles développés à la première occurrence ; jamais de capitales tapées en dur, mais `text-transform` avec la source en casse normale accentuée.
2. **Mise en œuvre** : les espaces insécables sont des caractères (U+00A0, U+202F), pas des entités HTML dans des chaînes non HTML. Les tests ne comparent jamais une chaîne formatée à un littéral tapé à la main.
3. **Suisse** : avant d'écrire, demander quelle référence s'applique (Chancellerie, *Guide du typographe romand* ou charte client), car l'usage institutionnel suisse lui-même n'est pas unanime.

---

## Mythes et affirmations contestées

- **« En Suisse, le séparateur de milliers est l'apostrophe. »** C'est contesté. La Chancellerie fédérale l'**interdit** en français (« L'utilisation de l'apostrophe dans les nombres n'est pas admise ») et la **déconseille** en allemand (« sollte nicht mehr angewendet werden »). CLDR/ICU (fr-CH, de-CH, it-CH), l'usage commercial et le guide d'Educa (2023) l'emploient. Les deux pratiques coexistent, et la directive officielle va contre l'usage majoritaire des logiciels.
- **« En Suisse, on écrit `CHF 12.50`. »** C'est vrai en allemand officiel (`Fr. 23.50`, `CHF 1.66`). En français officiel, la Chancellerie écrit `300 CHF`, `23 fr. 50` et la virgule décimale (`4,16 millions de francs`). ICU fr-CH donne `12.50 CHF`, Educa `CHF 55.50` : on a trois notations romandes pour la même somme.
- **« Toutes les plateformes recommandent le sentence case. »** C'est faux pour Apple : le HIG présente title case et sentence case comme deux registres et demande seulement la cohérence par type d'élément. Microsoft, Google (documentation) et GOV.UK prescrivent bien le sentence case. Material Design 3 n'est pas vérifié. L'affirmation circule dans des blogs (vue dans les résultats de recherche, non retenue).
- **« Les majuscules ne prennent pas d'accent en français. »** C'est faux. L'Académie française demande « systématiquement les capitales accentuées », et la Chancellerie fédérale aussi, sauf pour les sigles.
- **« Il faut une espace fine devant `;` `!` `?` : c'est la règle de l'Académie. »** Non vérifié comme règle de l'Académie : aucune page de l'Académie sur l'espacement n'a été lue. La fine est une règle de l'**Imprimerie nationale** (rapportée par un relais N4). Microsoft prescrit l'insécable pleine, et l'OQLF au Québec préfère aucune espace.
- **« En Suisse, ß et ss sont interchangeables. »** C'est imprécis. Le Regelwerk dit qu'en Suisse on **peut** toujours écrire `ss`. La Chancellerie fédérale fait de `ss` la seule graphie des textes fédéraux, `ß` n'y figurant pas « seit den 1970er-Jahren ».
- **« Les guillemets de second niveau en français sont “ ”. »** C'est contesté. Microsoft fr-FR prescrit les guillemets anglais pour l'imbrication. CLDR `fr` donne `« »` aux deux niveaux. CLDR `fr_CH` et la Chancellerie (en allemand) donnent `‹ ›`. Il n'existe pas de règle unique vérifiée.
- **« En Suisse romande, on met des insécables comme en France. »** C'est contesté. La Chancellerie impose des insécables avec les nombres et les abréviations, mais ne règle pas l'espace avant la ponctuation haute. Educa (2023) y « renonce en principe » et colle les guillemets (`«La numérisation»`).
- **« `text-transform: uppercase` règle le problème des lecteurs d'écran. »** C'est présenté comme « preferable » par Stanford. Le comportement réel des lecteurs d'écran avec ce CSS n'a pas été testé ni sourcé ici (voir Non vérifié).
- **« La RAE recommande l'espace pour les milliers. »** C'est rapporté par FundéuRAE (« es impropio emplear punto o coma »). Le texte de la RAE n'a pas pu être lu (403), et CLDR `es` utilise le point.

---

## Non vérifié

- **Lexique des règles typographiques en usage à l'Imprimerie nationale** : ouvrage imprimé, non consulté. Ses règles (fine devant `; ! ?`, insécable mot devant `:` et dans les guillemets) ne sont connues que par un relais (E. Muller, 2014) et par un document du CNRS de 1995 qui dit s'en inspirer. L'édition en vigueur (une 8e éd. de 2017 est signalée dans les résultats de recherche) n'a pas été vue.
- **RAE** : toutes les pages `rae.es` (Ortografía de la lengua española, ch. III et VIII ; DPD ; Libro de estilo de la Justicia) ont renvoyé HTTP 403. Les règles espagnoles (¿¡, guillemets, séparateurs, éventuelle recommandation du point décimal) ne sont donc pas lues dans le texte académique.
- **Material Design 3** (casse) : page rendue en JavaScript, contenu vide pour l'outil.
- **Duden** : non consulté. La règle `ss` est sourcée par le Rat für deutsche Rechtschreibung et la Chancellerie.
- **Chancellerie fédérale, français** : le type exact d'espace (fine ou pleine) dans ses exemples `RS 0.360.682.1 ; RO 2011 811` et `« CTRL »` reste inconnu, car `pdftotext` ramène tout à U+0020. Je n'ai pas trouvé de règle explicite sur l'espace avant `; : ! ?` ni sur les guillemets.
- **Septante, huitante, nonante dans les textes fédéraux** : aucune occurrence trouvée dans les Instructions 2016 ni dans le GLLOC 2025. L'affirmation de l'Académie (« huitante » dans les « textes administratifs ») n'est pas recoupée par une source suisse officielle.
- **Leitfaden zur deutschen Rechtschreibung** : je n'ai lu que l'édition 2017 (copie du canton de Zoug). Une page bk.admin.ch confirmant l'édition en vigueur n'a pas été trouvée (l'URL supposée renvoie 404).
- **Guide du typographe romand** (référence d'Educa) : non consulté.
- **Lecteurs d'écran face à U+202F, U+00A0 et `text-transform`** : aucune source sur la prononciation ou les pauses lues, aucun test fait.
- **Recherche dans la page (Ctrl+F) avec U+00A0 et U+202F** : un utilisateur qui tape une espace normale trouve-t-il `55 000` ? Non vérifié.
- **Rendu Safari de U+202F** : un contributeur de translatewiki l'a dit incompatible avec Safari. Le résumé de recherche seul a été lu, et le point reste non vérifié.
- **Abréviations `M.` et `Mme`** : les pages de l'Académie et de l'OQLF n'ont pas été ouvertes. Seul le document du CNRS (1995) a été lu.
- **Italien** : aucune autorité linguistique (Accademia della Crusca) n'a été consultée. Les règles italiennes reposent sur CLDR et Microsoft.
- **Fichier Jost d'origine** (hors sous-ensembles fontsource) : sa couverture de U+202F n'est pas mesurée.

---
name: charte-code
description: "Charte des bonnes pratiques de programmation du profil : gestion d'erreur, validation aux frontières, nommage, abstraction, dépendances, secrets et configuration, asynchrone et réseau, tests, logs, performance, compatibilité. Rend les onze règles opposables du CLAUDE.md applicables ligne par ligne, avec leur motif, leurs contre-exemples et la grille de review. À charger avant d'écrire du code applicatif, avant une review, et lorsqu'une règle de la charte est invoquée, contestée ou appliquée à un cas limite."
---

# Charte de code

> Version 1.1 — 05.09.2026 (PR 2.4 de l'audit du 05.09 : la règle 8 renvoie au hook `guard-secrets` / règle E du poste, qui la rend opposable sur le nom du fichier ; l'échelle du moindre code de `backend` et `frontend` renvoie désormais ici pour ses trois paragraphes communs).
> Version 1.0 — 04.09.2026 (création). Détail des **onze règles opposables** du
> `global-CLAUDE.md` § « Charte de code ». Les règles y sont résidentes parce qu'elles doivent
> être opposables sans rien charger ; leur motif, leurs contre-exemples et leurs cas limites
> sont ici parce qu'ils n'ont pas à peser sur toutes les sessions.
>
> **Préchargée** par `backend`, `frontend` et `reviewer` (clé `skills:` de leur frontmatter) :
> ces trois-là ne peuvent pas écrire ou juger du code sans l'avoir sous les yeux.

## Ce que cette charte ne couvre pas

Elle ne redit rien de ce qui vit déjà ailleurs, et un renvoi vaut mieux qu'une copie qui
divergera :

| Sujet | Où il vit |
|---|---|
| Cadrage avant code (les trois étages) | `CLAUDE.md` § « Règle absolue spec-builder » |
| Lecture avant modification | `CLAUDE.md` § « Phase 0 » |
| Ne rien affirmer d'invérifié | `CLAUDE.md` § « Anti-hallucination » |
| Stack et bibliothèques par défaut | `CLAUDE.md` § « Stack et préférences techniques » |
| Règles visuelles (espacements, couleurs, états) | `CLAUDE.md` § « Règles de design opposables » |
| Pièges PowerShell 5.1 du poste | `CLAUDE.md` § « Garde-fous techniques » |
| Audit OWASP / threat model | sub-agent `securite` |
| Audit de performance chiffré | skill `perf-audit` |
| Audit WCAG | skill `a11y-audit` |
| Stratégie de tests (matrice, pyramide) | sub-agent `qa` |

**Frontière avec `reviewer`** : la charte dit ce qui est juste, `reviewer` vérifie que ça l'est
sur un diff donné. Elle est son référentiel, pas son remplaçant.

## Portée

Tout code livré, par l'orchestrateur ou par un sous-agent, quel que soit le langage. Quand le
dépôt porte sa propre convention (linter, `CLAUDE.md` de projet, style en place), **c'est elle
qui l'emporte** : cette charte est un défaut, pas une préférence à imposer chez l'hôte. Le seul
cas où elle prime est celui d'une règle de justesse — un `catch` vide reste un défaut même dans
un dépôt qui en est plein.

---

## 1. Rien de silencieux

**Règle.** Aucune erreur avalée. Une erreur se traite, se propage, ou se journalise et
s'interrompt — jamais elle ne disparaît.

**Motif.** Une erreur avalée ne supprime pas la panne, elle supprime la trace de la panne. Le
symptôme réapparaît plus loin, sur un état déjà corrompu, dans un fichier qui n'a rien à voir.
C'est la seule classe de défaut qui rend le débogage plus coûteux que la réécriture.

```ts
// NON — le repli devient la valeur normale, personne ne saura jamais que l'appel a échoué
try { return await getUser(id) } catch { return null }

// OUI — l'échec est nommé, et l'appelant décide
try {
  return await getUser(id)
} catch (err) {
  logger.error({ err, id }, 'getUser a échoué')
  throw new UserLookupError(id, { cause: err })
}
```

**Cas limite légitime** : un repli est acceptable quand il est **décidé**, pas quand il est
subi — cache indisponible, télémétrie qui tombe, fonctionnalité optionnelle. Il se signale
alors dans le code (`// dégradation volontaire : ...`) et se journalise au niveau `warn`.

**Corollaires.**
- Pas de `except:` nu en Python : toujours le type attendu.
- Pas de `catch` qui perd la cause : `{ cause: err }` en TS, `raise ... from err` en Python.
- Une promesse non attendue est une erreur avalée (`floating promise`) : `await`, `void` explicite, ou `.catch()`.
- Un code de retour ignoré (`subprocess`, `fs`, appel shell) est le même défaut sous un autre nom.

## 2. Échouer tôt, à la frontière

**Règle.** Toute donnée qui entre dans le programme est validée **au point d'entrée** : requête
HTTP, formulaire, fichier lu, variable d'environnement, réponse d'une API tierce, message de
file. Passé ce point, le code fait confiance à ses types.

**Motif.** Valider partout un peu revient à ne valider nulle part : chaque fonction porte des
gardes défensives, personne ne sait laquelle fait foi, et la donnée invalide finit quand même
en base. Une frontière nette rend le reste du code lisible.

- Zod (TS) ou Pydantic (Python) sur les entrées, y compris les **variables d'environnement** au
  démarrage : un service qui démarre sans sa clé doit refuser de démarrer, pas échouer au premier
  appel client.
- **La réponse d'une API tierce est une entrée.** `as MyType` n'est pas une validation, c'est une
  affirmation non vérifiée — exactement ce que l'anti-hallucination interdit ailleurs.
- Les invariants métier se vérifient **au plus près de la donnée** : contrainte en base d'abord,
  validation applicative ensuite. L'inverse laisse la base accepter ce que le code refuse.
- Tout durcissement de validation sur une base existante déclenche le reality check data legacy
  (`securite` Mode C + skill `supabase-toolkit`, séquence 3 d'`ORCHESTRATION.md`).

## 3. Pas de code mort livré

**Règle.** Ni fonction non appelée, ni import inutilisé, ni bloc commenté « au cas où », ni
`TODO` sans destinataire ni ticket, ni drapeau de fonctionnalité mort depuis deux versions.

**Motif.** Le code mort n'est pas neutre : il est lu, il est maintenu, il est copié. Et il ment
sur l'état du système — quelqu'un finira par croire que ce chemin est actif.

Git conserve ce qui a été supprimé. Un bloc commenté est une sauvegarde qui ne sait pas dire
d'où elle vient ni pourquoi elle a été mise de côté.

**Interdit explicite en livrable** : `// TODO`, `pass`, `NotImplementedError`, valeur codée en
dur « provisoire », composant vide. Un livrable incomplet se **déclare** incomplet ; il ne se
déguise pas en livrable complet.

## 4. Le commentaire dit POURQUOI

**Règle.** Le commentaire porte l'intention, la contrainte, le renvoi à l'incident ou à la
norme. Ce que fait le code se lit dans le code.

```py
# NON — paraphrase : deviendra faux à la première modification, et personne ne le corrigera
# incrémente le compteur de 1
compteur += 1

# OUI — porte ce que le code ne peut pas dire
# L'API tierce plafonne à 100 req/min ; au-delà elle renvoie 200 avec un corps vide,
# ce qui se lit comme un succès. Incident du 12.03.
```

Corollaire : un nom bien choisi supprime le besoin de commentaire. Commenter est le second
recours, renommer est le premier.

## 5. Nommer ce qui existe

**Règle.** Pas d'abréviation non conventionnelle, pas de `data`, `tmp`, `res`, `handle` employés
seuls. Un booléen s'énonce en prédicat (`isActive`, `hasAccess`, `shouldRetry`). Une fonction
commence par un verbe. Une unité fait partie du nom (`delaiMs`, `tailleOctets`, `prixCentimes`).

**Motif.** Le nom est la seule documentation que le compilateur maintienne à jour. Et l'unité
absente d'un nom est une classe d'erreur entière : millisecondes contre secondes, centimes
contre unités, octets contre kilo-octets.

Le code et les identifiants sont en **anglais**, les commentaires et messages de commit en
français (§ « Conventions git » du `CLAUDE.md`). Ne pas mélanger dans un même identifiant.

## 6. Règle de trois avant d'abstraire

**Règle.** Deux occurrences se dupliquent ; à la troisième on factorise — et on factorise ce qui
est **le même besoin**, pas ce qui a la même forme.

**Motif.** Une abstraction posée sur un cas d'usage unique code une hypothèse qu'on n'a pas
encore vérifiée. Le jour où le second cas arrive, il ne rentre pas ; on ajoute un paramètre, puis
un drapeau, et l'abstraction coûte désormais plus cher que la duplication qu'elle a évitée.

Deux fonctions qui se ressemblent aujourd'hui mais répondent à deux besoins **divergeront** :
les fusionner est une dette, pas une économie. Le critère est « est-ce que ces deux appelants
changeront toujours ensemble ? ».

**Symétrique, tout aussi vrai** : trois copies de la même règle métier sont un bug en attente —
la quatrième modification n'en touchera que deux.

## 7. Une dépendance est un engagement

**Règle.** Avant tout ajout de dépendance, quatre questions, et la réponse va dans la réponse à
l'utilisateur — jamais un ajout en silence :

1. **Est-ce vingt lignes à écrire ?** Alors on les écrit.
2. **Est-elle maintenue ?** Dernière publication, ouverture des issues, nombre de mainteneurs.
3. **Sa licence est-elle compatible** avec l'usage du projet ?
4. **Le projet fait-il déjà la même chose** sous un autre nom ? Deux bibliothèques de dates dans
   un même dépôt, c'est deux comportements aux fuseaux horaires.

**Motif.** Une dépendance s'installe en dix secondes et se retire en trois jours. Elle apporte
son arbre transitif, sa surface d'attaque, ses breaking changes et ses obligations d'upgrade.

- Versions **épinglées**, lockfile commité, jamais de `@latest` à l'aveugle (skill
  `framework-upgrade` pour tout saut de version majeure).
- Une dépendance ajoutée pour une seule fonction utilitaire est presque toujours une erreur.

## 8. Aucun secret dans le code

**Règle.** Ni clé, ni jeton, ni mot de passe, ni chaîne de connexion dans le code source, dans un
log, dans un message d'erreur rendu à l'utilisateur, dans une URL, ou dans un commit — même
supprimé au commit suivant : l'historique le conserve.

- Configuration par variables d'environnement, validées au démarrage (règle 2).
- Valeurs par défaut jamais sensibles : un défaut permissif en développement devient un défaut
  permissif en production le jour où quelqu'un oublie une variable.
- `.env` gitignoré, `.env.example` commité et **à jour** : c'est la seule documentation de ce
  dont le service a besoin pour démarrer.
- Un secret exposé est **révoqué d'abord**, nettoyé ensuite. Retirer la ligne ne révoque rien.
- Un message d'erreur destiné à l'utilisateur ne porte ni chemin absolu, ni requête SQL, ni trace
  de pile : ces éléments vont dans le log, avec un identifiant de corrélation.
- **Opposable depuis le 05.09.2026** sur le seul critère du nom : le hook `guard-secrets`
  (plugin) et la règle E de `guard-poste.ps1` (poste) refusent toute écriture dans `.env` et ses
  variantes (sauf `.example`/`.sample`/`.template`/`.dist`), keystores et `keystore.properties`,
  `google-services.json`, `*.pem`/`*.p12`/`*.pfx`/`*.key`, clés SSH privées. Le contenu, lui, n'est
  pas regardé : un secret collé dans `config.ts` reste à la charge de la revue.

## 9. Tout appel réseau a un timeout

**Règle.** Tout appel sortant — HTTP, base de données, file, processus enfant — porte un timeout
explicite et un comportement défini en cas d'échec. Un `await` sans borne est une panne en
attente.

**Motif.** Sans borne, la défaillance d'un service lent ne se traduit pas par une erreur mais par
un épuisement : connexions retenues, fils bloqués, saturation, panne totale d'un service qui
n'avait qu'un dépendant dégradé.

- **Rejouer n'est légitime que sur un appel idempotent**, avec un recul exponentiel et un
  plafond. Rejouer un paiement, c'est débiter deux fois.
- Toute écriture déclenchable deux fois (webhook, retry client, double clic) doit être
  **idempotente** — clé d'idempotence, contrainte d'unicité, ou vérification d'état.
- Pas de `await` dans une boucle sur des éléments indépendants : `Promise.all` avec une
  concurrence bornée. Une boucle de 500 `await` séquentiels est une latence multipliée par 500.
- **Annulation** : ce qui peut être abandonné par l'utilisateur (recherche, navigation) porte un
  `AbortSignal` — sinon la réponse d'une requête périmée écrase celle de la requête courante.

## 10. Un correctif de bug commence par le test qui le reproduit

**Règle.** Rouge d'abord, vert ensuite. Un correctif sans test de non-régression ne prouve rien :
ni que la cause était bien celle-là, ni que le défaut ne reviendra pas.

**Motif.** C'est la même discipline que l'injection de faute qui valide les bancs de ce dépôt :
un test qu'on n'a jamais vu échouer ne prouve pas qu'il sait échouer.

- Le test se nomme d'après le **comportement attendu**, pas d'après le numéro du ticket.
- Ce qui se teste : la logique métier, les cas limites, les frontières (règle 2), les chemins
  d'erreur — pas les accesseurs trivialement corrects, pas le framework.
- Un test qui passe systématiquement quel que soit le code est pire qu'absent : il achète de la
  confiance sans rien vérifier.
- Un test instable (`flaky`) se répare ou se supprime ; il ne se relance pas jusqu'au vert.
  Une suite dont on relance les échecs a cessé d'être un contrôle.
- La **stratégie** (quoi tester, à quel étage, dans quelle proportion) revient à `qa` ; qui écrit
  le code écrit ses tests.

## 11. Mesurer avant d'optimiser

**Règle.** Aucune optimisation sans un chiffre avant et un chiffre après, obtenus sur le même
protocole. Sans mesure, ce n'est pas une optimisation, c'est une complication.

**Motif.** L'intuition de performance est fausse la plupart du temps, et le coût de l'erreur est
double : on complique un code qui n'était pas le goulet, et on ne corrige pas celui qui l'était.

- Les défauts qui valent qu'on regarde **avant** de mesurer, parce qu'ils sont structurels et non
  marginaux : N+1 sur une requête, index manquant sur une colonne filtrée, chargement complet
  d'une collection non paginée, travail refait à chaque rendu.
- La pagination n'est pas une optimisation, c'est un **contrat d'API** : elle se décide au
  cadrage, pas quand la table atteint le million de lignes.
- `useMemo`, `useCallback`, index supplémentaires, cache : tous ont un coût. Aucun ne se pose
  « par précaution ».
- Détail complet et budgets : skill `perf-audit`.

---

## Journalisation et observabilité

Ni une règle opposable à part entière, ni un détail : ce qui suit s'applique dès qu'un service
tourne ailleurs que sur la machine de son auteur.

- **Structuré, pas concaténé** : `logger.info({ userId, durationMs }, 'commande créée')` plutôt
  qu'une phrase interpolée. Un log qu'on ne peut pas filtrer ne sert qu'une fois.
- **Niveaux honnêtes** : `error` = une action humaine est requise ; `warn` = dégradation
  encaissée ; `info` = événement métier ; `debug` = ce qui n'existe qu'en développement.
  Tout journaliser en `error` revient à ne rien signaler.
- **Jamais de donnée personnelle ni de secret** dans un log (règle 8). Un identifiant, pas un
  courriel ; un identifiant de corrélation, pas le corps de la requête.
- Un `console.log` de mise au point laissé dans le code est du code mort (règle 3).

## Compatibilité et migrations

- **Expand / contract** pour tout changement de schéma déployé en continu : ajouter la nouvelle
  forme, écrire dans les deux, migrer les données, basculer les lectures, puis seulement retirer
  l'ancienne. Une migration qui supprime et ajoute dans le même déploiement casse les instances
  encore en vol.
- Une migration est **idempotente** et **réversible**, ou bien elle s'accompagne du geste de
  restauration écrit noir sur blanc avant exécution (`release` Mode C).
- Un contrat d'API se déprécie, il ne se rompt pas : nouvelle version en parallèle, date de
  retrait annoncée, mesure de l'usage résiduel avant suppression.

## Grille de review (opposable)

`reviewer` la passe sur chaque diff. Une réponse « non » est une correction, pas une discussion.

1. Toute erreur possible est traitée, propagée ou journalisée — aucune n'est avalée ? (1)
2. Toute donnée entrante est validée au point d'entrée, y compris les réponses tierces ? (2)
3. Le diff ne livre ni code mort, ni `TODO`, ni stub, ni valeur provisoire ? (3)
4. Les commentaires présents disent pourquoi, et aucun ne paraphrase le code ? (4)
5. Les noms portent leur intention et leur unité ? (5)
6. Aucune abstraction posée sur un cas unique, aucune règle métier triplée ? (6)
7. Toute dépendance ajoutée est justifiée dans la réponse, épinglée, lockfile commité ? (7)
8. Aucun secret dans le code, les logs ou les messages d'erreur rendus ? (8)
9. Tout appel sortant a un timeout, et toute écriture rejouable est idempotente ? (9)
10. Tout correctif de bug porte son test de non-régression, vu rouge avant d'être vert ? (10)
11. Toute optimisation porte un avant/après chiffré ? (11)
12. Le diff fait ce que la SPEC demandait — ni moins, ni plus ?

## Anti-patterns

- **Appliquer la charte contre la convention du dépôt hôte** : sauf règle de justesse, c'est le
  dépôt qui décide. Signaler l'écart, ne pas réécrire son style.
- **Invoquer une règle sans nommer le défaut concret** : « ce n'est pas idiomatique » n'est pas
  une review, c'est une préférence.
- **Élargir un correctif au nom de la charte** : un défaut vu hors périmètre se **signale**, il
  ne se corrige pas dans le même diff (le périmètre est ce que la SPEC a défini).
- **Traiter les onze règles comme des cases à cocher** : elles sont le plancher, pas le plafond.
  Aucun livrable n'est bon parce qu'il ne viole rien.

---
name: travail-autonome
description: "Méthode d'une étape de mission autonome (moteur scripts/travail-autonome/, ADR-0006) : lire mission.md et etat.json, faire UN incrément, le prouver, commiter sur la branche de mission, écrire resume.md, réécrire etat.json en dernier, inscrire une question au lieu de la poser. Sert aussi en session normale pour écrire une mission (mission.md, contrat 1) et pour répondre à « où en est la mission ? ». Déclencheurs : mission autonome, travail autonome, étape de mission, lanceur.py, etat.json, rédiger une mission, où en est la mission, relancer une mission bloquée."
---

# Travail autonome : la méthode d'une étape

> Version 1.1 — 28.10.2026 (session cloud : le moteur n'existe que sur le poste).
> Version 1.0 — 27.10.2026 (création, lot 3 de l'ADR-0006). Ce fichier est **injecté tel quel** dans chaque étape
> par `lanceur.py` (`--append-system-prompt-file`), depuis sa copie installée. Contrats complets :
> `docs/SPEC-travail-autonome.md` du dépôt `claude-profiles`.

Deux usages, à ne pas confondre :

- **Dans une étape** (une exécution `claude -p` lancée par `lanceur.py`) : § 1 à § 6, à la lettre. Personne n'est
  devant l'écran.
- **Dans une session normale avec l'utilisateur** : écrire une mission (§ 7), dire où elle en est (§ 8).

**En session cloud** (plugin) : `lanceur.py` et le moteur `scripts/travail-autonome/` n'existent que sur le poste.
Seul le second usage vaut : écrire une mission, ou dire où elle en est si le dépôt est cloné. Ne jamais annoncer
qu'une étape est lancée.

## 1. Ce qu'est une étape

Une étape fait **un** incrément de la mission, le prouve, puis s'arrête. La continuité ne vit pas dans ta mémoire :
elle vit dans `etat.json`, le journal et la branche de mission. Une étape qui en fait trop, ou qui ne prouve pas ce
qu'elle a fait, coûte plus cher qu'une étape modeste et prouvée.

L'invite te donne : le numéro de l'étape, le dossier de mission, le clone de travail (ton dossier courant), la
branche de mission et le dossier de l'étape.

## 2. La procédure, dans cet ordre

1. **Lire** `mission.md` (en-tête : bornes, chemins permis, publication ; corps : contexte et méthode propre à la
   mission), puis `etat.json`, puis les fichiers de `[sources] lire_d_abord`. Lire les 20 dernières lignes de
   `journal.jsonl` si une étape précédente a échoué.
2. **Vérifier que `prochain_increment` a encore un sens** au vu de l'état réel du clone (`git log --oneline -10`,
   `git status`). La réalité fait foi, pas l'état écrit.
3. **Choisir UN incrément** qui tient dans la durée de l'étape (`duree_etape_min` de la mission) en laissant de la
   marge pour prouver et écrire l'état. Trop gros : le découper, faire le premier morceau.
4. **Le faire**, seulement dans les chemins de `ecrire_dans_le_depot` et dans le dossier de mission. Déléguer si
   c'est utile, uniquement aux sous-agents de `[autorisations] sous_agents` (§ 5).
5. **Le prouver** : la commande de vérification et sa sortie réelle, collées dans `resume.md`. Pas de preuve, pas
   d'incrément « fait » : ce qui n'est pas prouvé va dans `dette`.
6. **Commiter** sur la branche de mission, message `type(scope): description` en français (types : `fonctionnalite`,
   `correctif`, `entretien`, `doc`, `refonte`, `test`). **Ne pas pousser** : l'étape n'a pas le jeton GitHub. Le
   lanceur publie la branche après l'étape, une fois son contrôle passé, et ouvre la PR à `termine` si la mission
   dit `publication = "pr"`. Un commit non fait à la fin de l'étape ne sera pas publié.
7. **Écrire `resume.md`** dans le dossier de l'étape (§ 4).
8. **Réécrire `etat.json` EN DERNIER**, avec l'outil Write (§ 3). C'est sa date de mise à jour qui dit au lanceur
   que l'étape est allée au bout : l'écrire avant d'avoir fini, c'est mentir au lanceur.

## 3. `etat.json` : le contrat, à respecter exactement

Réécrire le fichier **en entier**, en gardant tel quel ce qui n'a pas changé :

```json
{
  "contrat": 1,
  "mission": "<identique>",
  "empreinte_mission": "<identique, ne jamais la recalculer>",
  "statut": "en-cours",
  "etape": 4,
  "maj": "2026-11-04T03:12:09+01:00",
  "prochain_increment": "ce que la prochaine étape doit faire, en une phrase",
  "fait": ["... une ligne par incrément PROUVÉ, la nouvelle à la fin"],
  "questions": [{"id": "q3", "texte": "...", "options": ["A", "B"], "recommandation": "A", "bloquante": false}],
  "compteurs": {"essais": 212},
  "dette": ["contrôle non fait, et pourquoi"]
}
```

- `etape` = le numéro donné par l'invite. `maj` = l'heure **réelle** de l'écriture, avec décalage horaire, obtenue
  par une commande (`python -c "import datetime;print(datetime.datetime.now().astimezone().isoformat(timespec='seconds'))"`),
  jamais inventée.
- `statut` : `en-cours` ; `termine` si la `condition_de_fin` est remplie, **preuve citée** dans `resume.md` ;
  `impossible` si la mission ne peut pas aboutir, raison écrite ; `attente-utilisateur` s'il ne reste **rien** à faire
  sans une réponse. Aucune autre valeur : les autres statuts appartiennent au lanceur.
- `compteurs` : ceux que la mission définit (par exemple `essais` pour une recherche, que le lanceur compare à
  `essais_max`). Un compteur ne redescend jamais.

## 4. `resume.md`

Court, factuel, pour l'utilisateur et pour l'étape suivante :

```markdown
# Étape <n> — <incrément en une ligne>

## Fait
- ...

## Preuve
$ <commande>
<sortie réelle, tronquée si longue>

## Commit
<hash> <message>

## Pour la suite
<prochain incrément, et pourquoi celui-là>
```

## 5. Ce qui ne se fait jamais

- **Poser une question** : il n'y a personne. Elle s'inscrit dans `etat.json.questions` (options et
  recommandation), et l'étape continue sur une autre partie du travail.
- **Contourner un refus** de la garde ou des permissions. Un refus est une réponse : noter le besoin dans
  `questions` ou `dette`, passer à autre chose. Reformuler la commande pour passer à côté est une faute.
- Fusionner, pousser (quelle que soit la branche), ouvrir une PR, se connecter en SSH, lire `~/.ssh`,
  `~/.claude*`, un `.env`, un secret ; toucher `.github/`, `.claude/`, un réglage, un hook ; écrire hors des chemins
  permis ; créer une tâche planifiée, arrêter un processus, envoyer un message. Écrire **un script** qui fait l'un de
  ces gestes est le même geste.
- Modifier `mission.md`, `lanceur.json`, `journal.jsonl`, `STOP` : ils appartiennent au lanceur et à l'utilisateur.
- Élargir la mission : ce qui est hors objectif va dans `questions` ou `dette`, pas dans le code.

**Déléguer à un sous-agent** (seulement ceux de `sous_agents`) : il démarre sans contexte. Brief en six points —
objectif et critère d'acceptation ; périmètre dedans et dehors ; ce qui est établi (fichiers lus, décisions de la
mission) ; outils et sources, et les interdits ci-dessus ; livrable attendu et retour court ; ce que l'étape
précédente a laissé. Son retour est une affirmation : le vérifier par une commande avant de l'écrire dans `fait`.

## 6. Si quelque chose ne va pas

- L'état écrit contredit le clone : la réalité fait foi ; corriger `prochain_increment`, noter l'écart dans `dette`.
- Une étape précédente a échoué (journal) : comprendre pourquoi avant de refaire ; ne pas refaire trois fois la
  même chose.
- Le temps manque : arrêter l'incrément là où il est prouvable, écrire l'état honnêtement (`dette`), finir.

## 7. En session normale : écrire une mission

Gabarit commenté : `scripts/travail-autonome/mission.exemple.md` du dépôt `claude-profiles`. En-tête TOML entre deux
lignes `+++` (une clé inconnue est refusée), corps libre.

- **Une règle qui doit être garantie va dans l'en-tête** (bornes, chemins, publication) : le lanceur l'oppose. Une
  règle de jugement va dans le corps : elle est lue, pas garantie.
- `condition_de_fin` **vérifiable sur pièces** ; bornes réalistes (`echeance`, `etapes_max`, `duree_etape_min`) ;
  `ecrire_dans_le_depot` le plus étroit possible ; `sous_agents` nommés ; `web = false` sauf besoin.
- `validee_le` n'est posé que par l'utilisateur, après relecture. La mission se commite dans le dépôt cible
  (`docs/missions/<slug>.md`) **avant** `lanceur.py preparer`.

## 8. En session normale : « où en est la mission ? »

Lire, sans rien modifier : `lanceur.py statut` (copie installée, `%LOCALAPPDATA%\travail-autonome\`), puis
`etat.json`, la fin de `journal.jsonl`, le dernier `etapes/*/resume.md`, la branche de mission. Rendre : statut
effectif et pourquoi, dernier incrément prouvé, questions ouvertes avec leur recommandation, part de quota, et le
geste attendu de l'utilisateur s'il y en a un (`reprendre`, répondre à une question, retirer `STOP`). Ne jamais lancer
`etape` ni `reprendre` sans sa demande.

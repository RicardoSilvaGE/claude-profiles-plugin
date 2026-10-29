---
name: travail-autonome
description: "Méthode d'une étape de mission autonome (moteur scripts/travail-autonome/, ADR-0006) : lire mission.md et etat.json, faire UN incrément, le prouver, commiter sur la branche de mission, écrire resume.md, réécrire etat.json en dernier, inscrire une question au lieu de la poser ; en mode cloud (tâche planifiée Claude Code), état sur la branche de mission et push par l'étape. Sert aussi en session normale pour écrire une mission (mission.md, contrat 1) et pour répondre à « où en est la mission ? ». Déclencheurs : mission autonome, travail autonome, étape de mission, lanceur.py, etat.json, rédiger une mission, où en est la mission, relancer une mission bloquée."
---

# Travail autonome : la méthode d'une étape

> Version 1.2.3 — 29.10.2026 (§ 9 : aucun `;` dans une commande Bash, même entre guillemets ; refusé en cloud par
> la garde, tâche de diagnostic du 29.10.2026, cause non établie).
> Version 1.2.2 — 29.10.2026 (§ 3 : `maj` recopiée de la sortie de la commande ; § 9 : une commande Bash simple
> par appel, fichiers par Write/Edit. Leçons de la mission d'essai `essai-dates` : un refus de la garde à
> chacune des étapes 1 et 2, `maj` décalée de 30 à 40 s aux mêmes étapes).
> Version 1.2.1 — 28.10.2026 (§ 9 : la ligne de journal ne porte plus de hash, impossible à connaître avant le
> commit qui la contient ; relevé à l'étape 1 de la mission d'essai).
> Version 1.2 — 28.10.2026 (§ 9 « Mode cloud » : une étape par exécution de tâche planifiée, état sur la branche ;
> `docs/SPEC-travail-autonome-cloud.md`).
> Version 1.1 — 28.10.2026 (session cloud : le moteur n'existe que sur le poste).
> Version 1.0 — 27.10.2026 (création, lot 3 de l'ADR-0006). Ce fichier est **injecté tel quel** dans chaque étape
> par `lanceur.py` (`--append-system-prompt-file`), depuis sa copie installée. Contrats complets :
> `docs/SPEC-travail-autonome.md` du dépôt `claude-profiles`.

Deux usages, à ne pas confondre :

- **Dans une étape** (une exécution `claude -p` lancée par `lanceur.py`) : § 1 à § 6, à la lettre. Personne n'est
  devant l'écran.
- **Dans une session normale avec l'utilisateur** : écrire une mission (§ 7), dire où elle en est (§ 8).

**En session cloud**, deux cas :

- **Exécution d'une tâche planifiée** dont la consigne renvoie à ce fichier : c'est une étape en **mode cloud**.
  Appliquer § 1 à § 6, **avec les différences du § 9**, qui priment.
- **Toute autre session cloud** : `lanceur.py` n'existe que sur le poste. Seul le second usage vaut. Ne jamais
  annoncer qu'une étape est lancée.

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
  et **recopiée telle quelle** dans `etat.json` et le journal : jamais inventée, ni estimée à partir d'une heure
  lue plus tôt.
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

En mode cloud, lire la branche de mission sur `origin` : `docs/missions/<slug>/etat.json`, la fin de `journal.md`,
le dernier `etapes/*/resume.md`. Le geste attendu de l'utilisateur est alors : répondre à une question (en éditant
`etat.json` sur la branche), retirer `STOP`, ou désactiver la tâche sur claude.ai/code/routines.

## 9. Mode cloud : ce qui change

Pas de lanceur : **l'étape tient elle-même les garde-fous d'entrée et publie sa branche**. Une garde
(`.claude/hooks/garde_cloud.py`) refuse tout push hors `claude/…`, toute fusion, toute écriture par l'API GitHub
sauf l'ouverture d'une PR, et toute écriture sous `.claude/` ou `.github/`.

**Où sont les fichiers** (tous sur la branche de mission, dans le dépôt) :

| Fichier | Rôle |
|---|---|
| `docs/missions/<slug>/mission.md` | La mission. Ne jamais la modifier |
| `docs/missions/<slug>/etat.json` | Le contrat du § 3, inchangé |
| `docs/missions/<slug>/journal.md` | Une ligne ajoutée par étape : `<maj> · étape <n> · <statut> · <incrément>` (pas de hash : la ligne est dans le commit qu'elle décrirait ; `git log` le donne) |
| `docs/missions/<slug>/etapes/<nnn>/resume.md` | Le § 4, `<nnn>` sur trois chiffres (`007`) |
| `docs/missions/<slug>/STOP` | Posé par l'utilisateur : arrêt |

**Avant tout travail, dans cet ordre** (une condition vraie = ne rien faire d'autre que ce qui est dit) :

1. `STOP` existe → ne rien écrire, finir sur « Étape — : arrêtée (STOP) ».
2. `etat.statut` n'est pas `en-cours` → ne rien écrire, finir en rappelant le statut et en demandant de désactiver
   la tâche.
3. `bornes.echeance` dépassée (heure obtenue par une commande) → `statut = "echeance"` ; `etat.etape` ≥
   `bornes.etapes_max`, ou un compteur ≥ sa borne (`essais_max`) → `statut = "bornes-atteintes"`. Écrire alors
   seulement `etat.json` (sans changer `etape`) et la ligne de journal, commiter, pousser, finir. Ce sont les deux
   seuls statuts du lanceur que l'étape écrit, et seulement ici.

**Pendant l'étape** :

- Numéro de l'étape = `etat.etape + 1`. Le dossier de l'étape est `etapes/<nnn>/`.
- **Commandes Bash simples**, une par appel : un programme et ses arguments écrits en clair. La garde refuse ce
  qu'elle ne sait pas lire (substitution `$(…)`, variable qui compose un nom de commande ou de chemin, heredoc
  ambigu) ; un refus coûte un tour sans rien rapporter. Écrire et modifier les fichiers avec Write et Edit, jamais
  par `printf`, `cat <<` ou `sed -i`. **Aucun `;` dans une commande, même entre guillemets** : en cloud, la garde
  refuse `python3 -c "import a; a.f()"` qu'elle accepte en local. Du code de plus d'une instruction s'écrit dans un
  fichier (Write), puis se lance par `python3 <fichier>.py`.
- `bornes.fenetres`, `notifier` et `methode` sont sans objet. `duree_etape_min` reste la durée visée : une
  exécution qui dépasse l'heure chevauche la suivante.
- **Commiter puis pousser** (étape 6 du § 2, remplacée) : un seul commit en fin d'étape, qui contient le travail,
  `resume.md`, la ligne de `journal.md` et `etat.json` réécrit en dernier ; puis `git push -u origin <branche>`.
  Push refusé parce que la branche distante a avancé : `git fetch`, lire son `etat.json` ; si son `etape` est ≥ la
  tienne, une autre exécution a travaillé : **abandonner sans forcer**, finir en le disant. Sinon, `git rebase` puis
  pousser à nouveau, une fois.
- **À `termine`** : si `publication = "pr"`, ouvrir la PR de la branche vers la base par
  `gh api repos/<owner>/<repo>/pulls -X POST -f title=… -f head=<branche> -f base=<base> -f body=…` (`gh pr create`
  ne marche pas en cloud). Si `publication = "branche-seule"`, ne rien ouvrir.
- Interdits du § 5 inchangés, **sauf** pousser la branche de mission et, à `termine` sous `"pr"`, ouvrir sa PR. Lire
  `.claude/` se fait avec l'outil Read seulement : la garde refuse toute commande qui le nomme.
- Fin de réponse : une seule ligne `Étape <n> : <statut> — <incrément en une phrase>`.

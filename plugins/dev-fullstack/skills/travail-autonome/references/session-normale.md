# Travail autonome — en session normale (§ 7 et § 8)

> Sorti du `SKILL.md` le 11.11.2026 (v1.5), verbatim : une étape de mission n'en a pas l'usage. Les « § 3 », « § 4 »
> et « § 9 » renvoient au `SKILL.md`.

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

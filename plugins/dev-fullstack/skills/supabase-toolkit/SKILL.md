---
name: supabase-toolkit
description: "Couche Supabase d'un projet (Postgres + Auth + RLS + RPC + migrations) : policies RLS, RPC SECURITY DEFINER cohérentes avec la validation client, migrations idempotentes, et reality check des données existantes après tout durcissement de schéma : c'est là que la data legacy casse. Déclencheurs : RLS, policy manquante, SECURITY DEFINER, migration Supabase, data legacy, durcir la validation, service_role. Pas pour : un audit OWASP (`securite`), l'implémentation client (`frontend`), requêtes lentes et index (`backend`), l'application en prod (`release`)."
---

> Version 1.4 — 11.11.2026 (cure de poids : patrons SQL en annexe, redites retirées, gabarit du Mode audit). Versions antérieures : `CHANGELOG.md` du profil, non déployé. **Pas de champ `paths` sur ce skill, et c'est une décision** : il est préchargé par `backend`, et un skill portant `paths` n'est pas préchargeable (témoin isolé du 17.08.2026). **Ne pas rajouter `paths` ici sans retirer le préchargement dans `agents/backend.md`.**

# supabase-toolkit — Conception et audit de la couche Supabase

> Ce skill complète le sub-agent `backend` et le sub-agent `securite`. Quand un changement touche le schéma Supabase, les policies RLS, ou la validation côté DB, c'est ce skill qui apporte la rigueur procédurale.

## Principe directeur

**Le code n'est pas la vérité — la DB l'est.** L'état des données existantes, la sauvegarde et le rollback, la RLS : chacun se vérifie avant le geste qu'il conditionne (table de la Phase 2).

## Périmètre

### Couvert
- Conception et audit de policies RLS (Row Level Security) Postgres / Supabase.
- Écriture de fonctions RPC SECURITY DEFINER cohérentes avec la validation client.
- Planification de migrations SQL idempotentes avec rollback explicite.
- Reality check data legacy après tout durcissement de schéma (length min, regex stricter, FK ajoutée, contrainte UNIQUE nouvelle).
- Audit de cohérence : code Zod ↔ contraintes Postgres ↔ policies RLS.
- Génération de scripts SQL de migration de données legacy.

### Hors-scope
- Audit OWASP complet → sub-agent `securite`.
- Implémentation des composants frontend consommant Supabase → sub-agent `frontend`.
- Cadrage architectural de la feature → sub-agent `architecte`.
- Déploiement de la migration en prod → sub-agent `release` Mode C.
- Optimisation de query Postgres (indexes, EXPLAIN) → relève du sub-agent `backend` (`ORCHESTRATION.md`, séquence 6). Le skill `perf-audit` détecte le N+1 ou l'index manquant et les lui rend : il ne les corrige pas.

## MCPs à utiliser (Supabase)

Quand le MCP Supabase est connecté, **utiliser directement les tools** (ne pas demander à l'utilisateur d'exécuter les queries manuellement). Ils sont nommés ici par leur verbe : le préfixe (`mcp__Supabase__`, `mcp__claude_ai_Supabase__`…) dépend du nom du connecteur dans la session — le lire, ne pas le supposer :

- `list_tables` : cartographier le schéma actuel (avant conception, avant audit).
- `list_migrations` : voir l'historique des migrations appliquées.
- `execute_sql` : exécuter les queries reality check (lecture). L'essai à blanc d'une migration ne se fait **pas** sur la prod : il se joue sur un dump ou une copie minimisée — une branche vide ne teste pas les données (`release` Mode C, étape « Essai à blanc »).
- `apply_migration` : appliquer une migration **hors prod** (base locale, branche, copie), Mode migration ciblée uniquement. L'application en prod n'est pas un geste de ce skill : elle revient à `release` Mode C, par la CLI ou la CI, sauvegarde identifiée d'abord.
- `get_advisors` : récupérer les advisories sécu/perf Postgres (RLS manquante, indexes manquants).
- `query_logs` : erreurs RLS, queries lentes, échecs auth récents.

Si pas d'accès MCP : écrire les queries SQL exactes à exécuter manuellement et demander leurs résultats (dans le rapport, en sous-agent).

## Workflow (4 phases)

### Phase 0 — Brief obligatoire

Avant toute action, formuler en 5 lignes max :
1. **Cible** : quelle table, quelle policy, quelle migration ?
2. **Mode** : conception (création) / audit (existant) / data legacy (post-durcissement) / migration ciblée.
3. **Données en jeu** : count approximatif, criticité (auth, paiement, contenu user).
4. **Contraintes** : timing (avant prod ? après ?), réversibilité (FK = irréversible si data perdue).
5. **Question ouverte unique** : un seul arbitrage métier non documenté, si applicable.

Si une dimension manque, poser **une seule question groupée** avant de continuer (préchargé dans un sous-agent, qui ne dialogue pas : la rendre dans le rapport, `BLOQUÉ` si elle conditionne la suite). Sinon, passer directement à Phase 1.

### Phase 1 — Lecture obligatoire (HARD GATE)

Lire systématiquement, sans demander :

1. `CLAUDE.md` projet (conventions, stack imposée).
2. Schéma actuel : `supabase/migrations/*.sql` (toutes les migrations, par ordre chronologique).
3. Policies RLS actuelles sur les tables concernées : `SELECT * FROM pg_policies WHERE schemaname = 'public' AND tablename = '<table>'`.
4. Validation côté code : schémas Zod / Pydantic correspondants.
5. RPC SECURITY DEFINER existantes touchant le scope : `SELECT proname, prosrc FROM pg_proc WHERE prosecdef = true`.
6. **Reality check — en Mode data legacy, et avant tout durcissement de validation quel que soit le mode** : `SELECT count(*)` des lignes qui ne passeraient PAS la nouvelle validation (requêtes types : `references/patrons-sql.md`).

### Phase 2 — Décisions techniques tranchées

| Décision | Règle |
|---|---|
| RLS sur nouvelle table user-facing | **Obligatoire** : RLS activée + au moins une policy explicite, minimum `(select auth.uid()) = user_id` (forme enveloppée). Pas de table publique sans RLS. Refus de la skill si l'utilisateur dit « plus tard ». |
| RPC SECURITY DEFINER vs INSERT direct | RPC obligatoire quand : (a) validation côté serveur indispensable, (b) écriture cross-table atomique, (c) protection contre énumération. |
| Format migration | Fichier dans `supabase/migrations/YYYYMMDDHHMMSS_<slug>.sql`. `BEGIN; ... COMMIT;` autour, **sauf** pour un `CREATE INDEX CONCURRENTLY`, qui ne peut pas tourner dans un bloc de transaction : fichier à part, hors transaction, et un échec laisse un index INVALID à supprimer (`ux-preuves/references/backend-donnees-postgres.md` l. 44-49). Vérifier aussi que l'outil de migration n'enveloppe pas lui-même chaque fichier. |
| Verrous, changements incompatibles | `SET lock_timeout` dans la session de migration ; contrainte CHECK ou FK sur table peuplée en `NOT VALID` puis `VALIDATE CONSTRAINT` ; changement de schéma incompatible en expand / migrate / contract. Règles et sources : même fiche, l. 30-35, 51-56 et 58-63 — les y lire, elles ne sont pas recopiées ici. |
| Idempotence | Toute migration doit être idempotente (`IF NOT EXISTS`, `DROP ... IF EXISTS`, `CREATE OR REPLACE`) : sans cela la 2e application casse, et le rollback avec. |
| Plan de rollback | Inclus dans le fichier de migration, en commentaire ou en script séparé `rollback_<slug>.sql`. |
| Data legacy après durcissement | Si gap > 0 ligne : (a) script de migration data + (b) fallback compatible si migration impossible. Refus de durcir sans plan : sinon les users existants sont bannis en silence (incident du 21.05.2026, `join_code` passé de 4 à 6 caractères). |
| Naming policies | `<table>_<verb>_<scope>` (ex: `families_select_own`, `messages_insert_member`). |

**Patrons à recopier, pas à réécrire de mémoire** — `references/patrons-sql.md` de ce skill, à ouvrir avant d'écrire une policy, une RPC SECURITY DEFINER ou une requête de reality check : policies rejouables (`ENABLE ROW LEVEL SECURITY`, `DROP POLICY IF EXISTS`, `TO authenticated`, index de la colonne filtrée), RPC (`SET search_path`, `REVOKE EXECUTE … FROM PUBLIC, anon`), requêtes de comptage, wording anti-énumération. Chaque patron y porte sa source.

### Phase 3 — Livraison

Selon le mode, produire :

**Mode conception** :
- 1 fichier de migration `supabase/migrations/YYYYMMDDHHMMSS_<slug>.sql`.
- Section commentée en tête : but, rollback, dépendances.
- Tests SQL en pied de fichier (assertions sur count, structure).

**Mode audit** :
- Note inline, un tableau puis les findings :

  ```
  | Table | RLS activée | Policies (nom, verbe, rôle) | Verdict |
  ```
  Verdict : OK / manquante / trop permissive / contournable via RPC.
- Findings priorisés (grille de ce skill, tirée de ses garde-fous) : **CRITIQUE** — donnée lisible ou modifiable par qui ne devrait pas (table user-facing sans RLS, policy `USING (true)`, `service_role` atteignable du client) ; **HAUT** — protection contournable (RPC SECURITY DEFINER sans validation interne ou sans `REVOKE`) ; **MOYEN** — écart sans exposition immédiate (Zod ↔ contrainte ↔ policy, colonne filtrée non indexée, migration non rejouable).

**Mode data legacy** :
- Section « Gap actuel » : count exact des lignes non conformes (avec query reproductible).
- Section « Plan de migration » : script SQL de mise en conformité.
- Section « Fallback » si migration impossible : adapter le code pour tolérer l'existant.

**Mode migration ciblée** :
- Plan d'exécution numéroté (backup → dry-run → exec → vérification → rollback si KO).
- Hand-off explicite vers `release` Mode C pour l'exécution prod : ce skill écrit le fichier et le plan, et n'applique lui-même que hors prod.

Suite, dans tous les modes qui produisent du SQL : `reviewer` avant merge, et `securite` pour tout durcissement de validation (hand-off de `backend`).

## Garde-fous (règles dures)

- Toute migration prod → backup confirmé avant.
- Toute RPC SECURITY DEFINER → validation à l'intérieur du corps de fonction, jamais en confiance sur les paramètres : l'attaquant passe ceux qu'il veut.
- Tout `service_role` côté code → uniquement dans des Server Actions / API routes, jamais exposé au client (`NEXT_PUBLIC_*` est public par définition : faille critique).
- Aucune affirmation sur l'état réel des données sans avoir exécuté la query (ou écrit la query à exécuter par l'utilisateur). **Ne jamais inventer un count.**

## Anti-patterns interdits

- **RLS désactivée « temporairement pour debug »** — c'est toujours permanent.
- **Policy `USING (true)`** sur une table user-facing — c'est équivalent à pas de RLS.
- **Modifier un schéma sans toucher la validation Zod correspondante** — drift garanti.

## Auto-check final (avant livraison)

- Le fichier de migration se rejoue-t-il deux fois sans erreur, et son rollback est-il écrit ?
- Zod, contraintes Postgres et policies disent-ils la même chose après le changement ?
- Chaque count du livrable renvoie-t-il à une query exécutée, ou rendue à exécuter ?

Si une seule réponse est non → corriger avant livraison.

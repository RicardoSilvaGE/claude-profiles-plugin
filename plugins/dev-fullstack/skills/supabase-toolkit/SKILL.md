---
name: supabase-toolkit
description: "Couche Supabase d'un projet (Postgres + Auth + RLS + RPC + migrations) : policies RLS, RPC SECURITY DEFINER cohérentes avec la validation client, migrations idempotentes, et surtout le reality check sur les données existantes après tout durcissement de schéma : c'est là que la data legacy casse. Déclencheurs : RLS, policy manquante, SECURITY DEFINER, migration Supabase, data legacy, durcir la validation, service_role, supabase db push ou diff. Pas pour : un audit OWASP global (sub-agent `securite`), l'implémentation client (sub-agent `frontend`)."
---

> Version 1.1 — 17.08.2026 (**pas de champ `paths` sur ce skill, et c'est une décision, pas un oubli.** Il en a porté un pendant une heure, borné à `supabase/`, `migrations/`, `*.sql` et `db/`, avant d'être retiré : ce skill est **préchargé** dans le sub-agent `backend` (frontmatter `skills:`), et les deux mécanismes sont **exclusifs** — un skill portant `paths` n'est pas préchargeable. Vérifié par témoin isolé le 17.08.2026 ; absent de la documentation officielle, qui ne mentionne que `disable-model-invocation` comme obstacle au préchargement.
> Arbitrage retenu : le préchargement l'emporte, parce que le reality check sur données legacy du Mode C de `backend` ne doit dépendre d'aucune décision de l'agent — et parce que `paths` s'est révélé plus strict qu'annoncé, ne déclenchant que sur un fichier **effectivement manipulé**, pas sur le contenu du dossier. Une conversation RLS menée depuis un `.tsx` n'aurait donc rien déclenché. **Ne pas rajouter `paths` ici sans retirer le préchargement dans `agents/backend.md`.**)
> Version 1.0 — 21.05.2026 (création ; entré au repo le 26.05.2026 ; ligne de version ajoutée le 12.06.2026, audit dev-fullstack).

# supabase-toolkit — Conception et audit de la couche Supabase

> Ce skill complète le sub-agent `backend` et le sub-agent `securite`. Quand un changement touche le schéma Supabase, les policies RLS, ou la validation côté DB, c'est ce skill qui apporte la rigueur procédurale.

## Principe directeur

**Le code n'est pas la vérité — la DB l'est.** Avant tout durcissement de validation côté code, on vérifie l'état des données existantes. Avant toute migration prod, on a un backup et un rollback. Avant toute table user-facing, on a une RLS active.

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
- Optimisation de query Postgres (indexes, EXPLAIN) → relève du sub-agent `backend` ou du skill `perf-audit`.

## MCPs à utiliser (Supabase)

Quand le MCP Supabase est connecté, **utiliser directement les tools** (ne pas demander à l'utilisateur d'exécuter les queries manuellement) :

- `mcp__claude_ai_Supabase__list_tables` : cartographier le schéma actuel (avant conception, avant audit).
- `mcp__claude_ai_Supabase__list_migrations` : voir l'historique des migrations appliquées.
- `mcp__claude_ai_Supabase__execute_sql` : exécuter les queries reality check et dry-run de migration.
- `mcp__claude_ai_Supabase__apply_migration` : appliquer une migration (avec backup confirmé, Mode migration ciblée uniquement).
- `mcp__claude_ai_Supabase__get_advisors` : récupérer les advisories sécu/perf Postgres (RLS manquante, indexes manquants).
- `mcp__claude_ai_Supabase__get_logs` : erreurs RLS, queries lentes, échecs auth récents.

Si pas d'accès MCP : écrire les queries SQL exactes à exécuter manuellement et demander à l'utilisateur les résultats. **Ne jamais inventer un count.**

## Workflow (4 phases)

### Phase 0 — Brief obligatoire

Avant toute action, formuler en 5 lignes max :
1. **Cible** : quelle table, quelle policy, quelle migration ?
2. **Mode** : conception (création) / audit (existant) / data legacy (post-durcissement) / migration ciblée.
3. **Données en jeu** : count approximatif, criticité (auth, paiement, contenu user).
4. **Contraintes** : timing (avant prod ? après ?), réversibilité (FK = irréversible si data perdue).
5. **Question ouverte unique** : un seul arbitrage métier non documenté, si applicable.

Si une dimension manque, poser **une seule question groupée** avant de continuer. Sinon, passer directement à Phase 1.

### Phase 1 — Lecture obligatoire (HARD GATE)

Lire systématiquement, sans demander :

1. `CLAUDE.md` projet (conventions, stack imposée).
2. Schéma actuel : `supabase/migrations/*.sql` (toutes les migrations, par ordre chronologique).
3. Policies RLS actuelles sur les tables concernées : `SELECT * FROM pg_policies WHERE schemaname = 'public' AND tablename = '<table>'`.
4. Validation côté code : schémas Zod / Pydantic correspondants.
5. RPC SECURITY DEFINER existantes touchant le scope : `SELECT proname, prosrc FROM pg_proc WHERE prosecdef = true`.
6. **Si Mode data legacy** : `SELECT count(*)` des lignes qui ne passeraient PAS la nouvelle validation.

Si pas d'accès direct à la DB (MCP Supabase non connecté), écrire explicitement les queries à exécuter et demander à l'utilisateur de les lancer. **Ne pas inventer de chiffres.**

### Phase 2 — Décisions techniques tranchées

| Décision | Règle |
|---|---|
| RLS sur nouvelle table user-facing | **Obligatoire**. Policy minimum : `auth.uid() = user_id`. Refus de la skill si l'utilisateur dit « plus tard ». |
| RPC SECURITY DEFINER vs INSERT direct | RPC obligatoire quand : (a) validation côté serveur indispensable, (b) écriture cross-table atomique, (c) protection contre énumération. |
| Format migration | Fichier dans `supabase/migrations/YYYYMMDDHHMMSS_<slug>.sql`. Toujours `BEGIN; ... COMMIT;` autour. |
| Idempotence | Toute migration doit être idempotente (`IF NOT EXISTS`, `DROP ... IF EXISTS`, `CREATE OR REPLACE`). |
| Plan de rollback | Inclus dans le fichier de migration, en commentaire ou en script séparé `rollback_<slug>.sql`. |
| Data legacy après durcissement | Si gap > 0 ligne : (a) script de migration data + (b) fallback compatible si migration impossible. Refus de durcir sans plan. |
| Naming policies | `<table>_<verb>_<scope>` (ex: `families_select_own`, `messages_insert_member`). |

### Phase 3 — Livraison

Selon le mode, produire :

**Mode conception** :
- 1 fichier de migration `supabase/migrations/YYYYMMDDHHMMSS_<slug>.sql`.
- Section commentée en tête : but, rollback, dépendances.
- Tests SQL en pied de fichier (assertions sur count, structure).

**Mode audit** :
- Note inline : tableau policy par table avec verdict (OK / manquante / trop permissive / contournable via RPC).
- Findings priorisés CRITIQUE / HAUT / MOYEN.

**Mode data legacy** :
- Section « Gap actuel » : count exact des lignes non conformes (avec query reproductible).
- Section « Plan de migration » : script SQL de mise en conformité.
- Section « Fallback » si migration impossible : adapter le code pour tolérer l'existant.

**Mode migration ciblée** :
- Plan d'exécution numéroté (backup → dry-run → exec → vérification → rollback si KO).
- Hand-off explicite vers `release` Mode C pour l'exécution prod.

## Garde-fous (règles dures)

- Toute nouvelle table user-facing → RLS activée + au moins une policy explicite. Pas de table publique sans RLS.
- Toute migration prod → backup confirmé avant.
- Toute RPC SECURITY DEFINER → validation à l'intérieur du corps de fonction, jamais en confiance sur les paramètres.
- Tout `service_role` côté code → uniquement dans des Server Actions / API routes, jamais exposé au client.
- Tout durcissement de validation → Phase 1 reality check obligatoire.
- Aucune affirmation sur l'état réel des données sans avoir exécuté la query (ou écrit la query à exécuter par l'utilisateur).

## Anti-patterns interdits

- **RLS désactivée « temporairement pour debug »** — c'est toujours permanent.
- **Policy `USING (true)`** sur une table user-facing — c'est équivalent à pas de RLS.
- **RPC SECURITY DEFINER sans validation interne** — l'attaquant passe les params qu'il veut.
- **Migration durcissant sans plan data legacy** — bannit silencieusement les users existants (cf. incident du 21.05.2026 sur l'app de référence, join_code 4 chars).
- **`service_role` exposé via `NEXT_PUBLIC_*`** — par définition public, faille critique.
- **Migration sans `IF NOT EXISTS`** — casse la 2e application, casse le rollback.
- **Modifier un schéma sans toucher la validation Zod correspondante** — drift garanti.

## Connaissance domaine métier (Supabase + Postgres)

### Patterns RLS canoniques

```sql
-- Lecture propre à l'utilisateur
CREATE POLICY "table_select_own" ON public.<table>
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

-- Lecture membre d'un groupe (via table de jointure)
CREATE POLICY "table_select_member" ON public.<table>
  FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM public.memberships m
    WHERE m.user_id = auth.uid() AND m.group_id = <table>.group_id
  ));

-- Écriture avec WITH CHECK
CREATE POLICY "table_insert_own" ON public.<table>
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);
```

### Patterns RPC SECURITY DEFINER

```sql
CREATE OR REPLACE FUNCTION public.<name>(<params>)
RETURNS <type>
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- 1. Validation des params (length, regex, ranges)
  IF length(<param>) < 6 THEN
    RAISE EXCEPTION 'invalid input' USING ERRCODE = '22023';
  END IF;
  -- 2. Auth check explicite si nécessaire
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'unauthorized' USING ERRCODE = '42501';
  END IF;
  -- 3. Logique
  ...
END;
$$;

REVOKE EXECUTE ON FUNCTION public.<name> FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.<name> TO authenticated;
```

### Reality check data legacy — requêtes types

```sql
-- Length min sur join_code passé de 4 à 6
SELECT count(*) FROM public.families WHERE length(join_code) < 6;

-- Regex stricter sur email (passé de "@*" à RFC 5322)
SELECT count(*) FROM auth.users WHERE email !~ '^[^\s@]+@[^\s@]+\.[^\s@]+$';

-- Nouvelle FK ajoutée sur messages.user_id → auth.users(id)
SELECT count(*) FROM public.messages m
  LEFT JOIN auth.users u ON u.id = m.user_id
  WHERE u.id IS NULL;
```

### Erreurs i18n custom — anti-énumération

Les messages métier custom (`settings.codeTaken`, `auth.emailTaken`, `auth.usernameAvailable`) révèlent autant l'unicité que les erreurs Postgres brutes. Recommandation : wording agnostique (`indisponible`, `réessaie`) + rate-limiting sur l'endpoint qui peut révéler.

## Auto-check final (avant livraison)

- Phase 0 brief formulé et validé ?
- Phase 1 lecture obligatoire effectuée (schéma + policies + validation + RPC) ?
- Pour Mode data legacy : count exact basé sur une vraie query (ou query écrite à exécuter) ?
- Toute nouvelle table user-facing a une policy RLS explicite (pas `USING (true)`) ?
- Toute RPC SECURITY DEFINER valide les params dans son corps ?
- Migration idempotente (`IF NOT EXISTS`) + rollback documenté ?
- Aucun chiffre inventé (tout count vient d'une query exécutée) ?
- Hand-off explicite si Mode migration ciblée (vers `release` Mode C) ?

Si une seule réponse est non → corriger avant livraison.

## Incidents source

- **21.05.2026 — app de référence : join_code 4 chars, data legacy**
  - Pattern : durcissement Zod (4→6 chars) sans migration des données existantes → users bannis silencieusement au login depuis nouveau navigateur.
  - Mitigation incorporée : Phase 1 reality check obligatoire avant tout durcissement.

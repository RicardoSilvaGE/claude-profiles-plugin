# supabase-toolkit — patrons SQL (RLS, RPC SECURITY DEFINER, reality check)

> Annexe du skill `supabase-toolkit`, sortie du `SKILL.md` le 11.11.2026 (v1.4), texte inchangé. À
> ouvrir avant d'écrire une policy RLS, une RPC SECURITY DEFINER, une requête de reality check ou
> un message d'erreur qui peut révéler une unicité. « Phase 2 », « Idempotence » et « Format
> migration » renvoient à la table de décisions du `SKILL.md`.

## Connaissance domaine métier (Supabase + Postgres)

### Patterns RLS canoniques

Forme alignée sur `ux-preuves/references/backend-donnees-postgres.md` l. 236-241 (Supabase, « RLS Performance and Best Practices ») : `auth.uid()` appelé via `(select auth.uid())`, rôle nommé (`TO authenticated`), colonne filtrée indexée, et la requête cliente filtre aussi — la RLS sert à la sécurité, pas au filtrage. Réserve de la source : l'enveloppe ne vaut que si le résultat ne dépend pas de la ligne. RLS activée sur toute table d'un schéma exposé : même fiche, l. 243-248. Chaque `CREATE POLICY` est précédé de son `DROP POLICY IF EXISTS`, pour que le fichier soit rejouable (règle « Idempotence » de la Phase 2).

```sql
-- RLS activée : sans cette ligne, les policies ci-dessous ne protègent rien
ALTER TABLE public.<table> ENABLE ROW LEVEL SECURITY;

-- Lecture propre à l'utilisateur
DROP POLICY IF EXISTS "table_select_own" ON public.<table>;
CREATE POLICY "table_select_own" ON public.<table>
  FOR SELECT TO authenticated
  USING ((select auth.uid()) = user_id);

-- Lecture membre d'un groupe (via table de jointure)
DROP POLICY IF EXISTS "table_select_member" ON public.<table>;
CREATE POLICY "table_select_member" ON public.<table>
  FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM public.memberships m
    WHERE m.user_id = (select auth.uid()) AND m.group_id = <table>.group_id
  ));

-- Écriture avec WITH CHECK
DROP POLICY IF EXISTS "table_insert_own" ON public.<table>;
CREATE POLICY "table_insert_own" ON public.<table>
  FOR INSERT TO authenticated
  WITH CHECK ((select auth.uid()) = user_id);

-- Colonne filtrée par les policies : indexée. Table NEUVE seulement : sur une table en service,
-- CREATE INDEX CONCURRENTLY dans un fichier à part, hors transaction (ligne « Format migration »).
CREATE INDEX IF NOT EXISTS <table>_user_id_idx ON public.<table> (user_id);
```

### Patterns RPC SECURITY DEFINER

Forme alignée sur `ux-preuves/references/backend-donnees-postgres.md` l. 250-255 (PostgreSQL, « Writing SECURITY DEFINER Functions Safely ») : `search_path` fixé, sans schéma inscriptible par un rôle non fiable, `pg_temp` en dernière entrée ; droit EXECUTE retiré à PUBLIC (et à `anon` sur Supabase) puis accordé sélectivement. La même fiche note que Supabase va plus loin : `search_path = ''` et tous les noms qualifiés par leur schéma dans le corps.

```sql
CREATE OR REPLACE FUNCTION public.<name>(<params>)
RETURNS <type>
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
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

REVOKE EXECUTE ON FUNCTION public.<name> FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.<name> TO authenticated;
```

### Reality check data legacy — requêtes types

```sql
-- Length min sur join_code passé de 4 à 6
SELECT count(*) FROM public.families WHERE length(join_code) < 6;

-- Regex stricter sur email (passé de "@*" à un motif simplifié x@y.z ; ce n'est pas RFC 5322)
SELECT count(*) FROM auth.users WHERE email !~ '^[^\s@]+@[^\s@]+\.[^\s@]+$';

-- Nouvelle FK ajoutée sur messages.user_id → auth.users(id)
SELECT count(*) FROM public.messages m
  LEFT JOIN auth.users u ON u.id = m.user_id
  WHERE u.id IS NULL;
```

### Erreurs i18n custom — anti-énumération

Les messages métier custom (`settings.codeTaken`, `auth.emailTaken`, `auth.usernameAvailable`) révèlent autant l'unicité que les erreurs Postgres brutes. Recommandation : wording agnostique (`indisponible`, `réessaie`) + rate-limiting sur l'endpoint qui peut révéler.

## Incident source

- **21.05.2026 — app de référence : join_code 4 chars, data legacy**
  - Pattern : durcissement Zod (4→6 chars) sans migration des données existantes → users bannis silencieusement au login depuis nouveau navigateur.
  - Mitigation incorporée : Phase 1 reality check obligatoire avant tout durcissement.

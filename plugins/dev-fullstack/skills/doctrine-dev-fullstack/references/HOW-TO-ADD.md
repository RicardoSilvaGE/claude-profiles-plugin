# Comment ajouter un nouveau sub-agent ou skill

> Version 1.3 — 01.06.2026 (§ « Découplage de la stack » ajouté : la stack d'un agent est un défaut surpassable par le CLAUDE.md projet, à propager aux gates durs — incident 01.06.2026)
> Version 1.2 — 27.05.2026 (§ « Pourquoi un sub-agent n'apparaît pas » réécrit : la cause primaire prouvée est le CRLF dans le frontmatter, pas la longueur de description — théorie ~319 char réfutée par `qa.md` qui charge à 329 char)
> Version 1.1 — 26.05.2026 (ajout § « Pourquoi un sub-agent n'apparaît pas » : plafond description ~319 char + set figé au démarrage du process)
> Version 1.0 — 21.05.2026
> Référence pour l'utilisateur (et pour Claude qui orchestre les modifications).

## Sub-agent ou skill ?

- **Sub-agent** : a son propre contexte isolé, est invoqué via le Task tool. Idéal pour un rôle (auditeur, développeur, designer) qui produit un livrable.
- **Skill** : s'exécute dans le contexte principal, déclenché par mots-clés. Idéal pour un workflow procédural (rédiger un SPEC, auditer la perf, faire une migration).

Critère :
- Si le composant DOIT être isolé du contexte principal (pour éviter pollution) → sub-agent.
- Si le composant doit avoir accès au contexte conversationnel → skill.
- Si le composant doit produire un livrable structuré sur disque → sub-agent.
- Si le composant doit guider une procédure step-by-step → skill.

## Pattern obligatoire (v2 — depuis 21.05.2026)

Tout nouveau sub-agent ou skill suit ces 13 sections (ORCHESTRATION.md « Pattern partagé » les détaille en **15** en séparant Format de livrable / Hand-off / Auto-check / Incidents source — même pattern, décompte différent) :

1. **Frontmatter** : `name` + `description`. La description est un **routeur**, pas une norme.

   > **Ce qu'on y met** : les déclencheurs — les mots par lesquels une demande arrive, et ce que
   > le composant couvre. **Ce qu'on n'y met jamais** : une règle que le composant fait
   > respecter, ni un résumé de son workflow.
   >
   > **Mesuré, pas supposé** (banc C1, 24.08.2026). La description de `spec-builder` énonce les
   > trois étages de cadrage **mot pour mot**. Une cellule qui ne gardait qu'elle — doctrine
   > résidente ablatée, description intacte et chargée — a **violé la règle 3 fois sur 3**, là où
   > la cellule témoin la respectait 3 fois sur 3. Une règle en `description` est **lue, pas
   > obéie**.
   >
   > La conséquence est un faux sentiment de couverture : on lit la règle dans la description,
   > on la croit portée, et rien ne la porte. La règle doit vivre **dans le corps du fichier**
   > (lu à l'ouverture) et, si elle est opposable, **dans la doctrine résidente**.
   >
   > **Longueur** : pas de cible chiffrée. Celle de « ~300 caractères » qui figurait ici
   > descendait de la théorie d'un plafond à 319 caractères — théorie que ce document **réfute
   > lui-même** au § « Pourquoi un sub-agent n'apparaît pas » (`qa.md` charge à 329). Elle avait
   > survécu à sa propre réfutation. Le critère réel : **assez de déclencheurs pour router, rien
   > de plus**. Ce qui déborde de ce critère n'est pas trop long, il est **au mauvais endroit**.
2. **Version** : ligne `> Version X.Y — DD.MM.AAAA (changement résumé)` juste après le frontmatter.
3. **Titre + ligne d'identité** : 1-2 phrases sur le rôle.
4. **Modes** : A / B / C (ou D), détectés en Phase 0, déclarés en début de livrable.
5. **Skills à invoquer ou MCPs à utiliser** : si applicable, lister les skills/MCPs associés.
6. **Phase 0 — Lecture obligatoire (HARD GATE)** : citation des sources lues avant toute proposition.
7. **Phase -1** (pour les composants qui écrivent du code) : vérification SPEC.md (règle 19.05.2026).
8. **Workflow numéroté**.
9. **Garde-fous (règles dures)**.
10. **Anti-patterns**.
11. **Anti-hallucination**.
12. **Posture**.
13. **Format de livrable + Hand-off + Auto-check + Incidents source**.

## Découplage de la stack (depuis 01.06.2026)

Un sub-agent technique (`frontend`, `backend`, `designer`, `release`, `reviewer`) a une **stack par défaut** opinionée (Next/shadcn/Prisma/Vercel/Supabase). Cette stack est un **défaut surpassable**, jamais une prescription : la **source de vérité est le `CLAUDE.md` du projet**, lu en Phase 0.

**Règle 1 — Section « le projet décide ».** Tout agent qui nomme une stack pose explicitement la hiérarchie : si le projet impose autre chose (monofichier, zéro-dépendance, pas de build, autre lib), l'agent applique la contrainte **sans rejouer le débat**. La stack par défaut va dans une sous-section « Défaut (si le projet n'impose rien) », qui reste **forte et concrète** — découpler ≠ rendre fade.

**Règle 2 — Les garde-fous nommant une lib valent comme principes.** « validation runtime (Zod) », « hash éprouvé (bcrypt/argon2) », « shadcn customisé » → le **principe** est obligatoire (valider, hasher avec un KDF salé/coûteux, customiser la lib de composants), la **lib n'est qu'un exemple**. L'équivalent dans la stack du projet s'applique.

**Règle 3 (la plus oubliée) — Propager le découplage aux GATES DURS.** Le piège : ne découpler que les sections descriptives (« Stack et préférences ») et oublier les zones à effet bloquant — **Garde-fous, Workflow, Anti-patterns, Auto-check, et la Checklist du `reviewer`**. Un item de gate dur non conditionné (« Server Components par défaut ? », « jamais de hash maison — bcrypt/argon2 », « RLS Supabase activée ? ») **ré-impose silencieusement le défaut** que la section descriptive vient de relâcher : sur un projet atypique, l'item devient incochable et la règle « un non → corriger » force le retour à la stack par défaut. Conditionner ces items (`*(si stack à X)*`) et autoriser explicitement **N/A** comme réponse d'auto-check valide.

> Incident source : 01.06.2026 — découplage des 5 agents techniques. La 1ère passe, limitée aux sections « Stack », a laissé un **blocker** détecté par revue adversariale : le garde-fou backend « bcrypt/argon2 » imposait une dépendance npm interdite sur un projet zéro-dépendance (Flux, dont le hash PIN admin est natif `node:crypto`). Leçon : un découplage incomplet aux gates durs est **pire** que pas de découplage — il donne l'illusion d'être stack-agnostic tout en bloquant à l'exécution.

## Procédure d'ajout

### 1. Sub-agent

```powershell
# Créer le fichier
New-Item -ItemType File -Path "$env:USERPROFILE\.claude\agents\<nom>.md"

# Optionnel : créer le dossier projet autonome
New-Item -ItemType Directory -Path "$env:USERPROFILE\Claude\Projects\Assistant-<Nom>"
New-Item -ItemType File -Path "$env:USERPROFILE\Claude\Projects\Assistant-<Nom>\CLAUDE.md"
```

### 2. Skill

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude\skills\<nom>"
New-Item -ItemType File -Path "$env:USERPROFILE\.claude\skills\<nom>\SKILL.md"
```

### 3. Référencer dans l'écosystème

- **Sub-agent** : ajouter au tableau dans `~/.claude/CLAUDE.md` + `templates/profiles/dev-fullstack/global-CLAUDE.md` + `claude-profiles/CLAUDE.md`.
- **Skill** : ajouter à la section « Skills à connaître » dans `~/.claude/CLAUDE.md`.
- **Dans les deux cas** : ajouter à `~/.claude/agents/ORCHESTRATION.md` (inventaire + séquence typique si applicable).

### 4. Connecter aux sub-agents existants

Si le nouveau composant complète un sub-agent (ex: `supabase-toolkit` complète `securite` et `backend`), ajouter une section « Skills à invoquer » dans les sub-agents concernés.

### 5. Tester

Invoquer le nouveau sub-agent / skill sur un cas réel et vérifier :
- Le trigger fonctionne (description matche les mots-clés attendus).
- La Phase 0 lecture est effectuée.
- Le format de livrable est respecté.
- Le hand-off désigne un destinataire clair.

## Pourquoi un sub-agent n'apparaît pas (non-invocable)

Un sub-agent peut être présent sur disque, syntaxiquement correct, et **rester invisible** dans la liste des `subagent_type` invocables — **sans aucune erreur ni warning**. Deux causes distinctes, à diagnostiquer dans cet ordre :

### Cause 1 — Fins de ligne CRLF dans le `.md` (drop silencieux) — CAUSE PRIMAIRE PROUVÉE

Le parser de frontmatter du harness attend une ligne délimiteur `---` **exacte**. Sous CRLF, la ligne est `---\r` : le délimiteur n'est pas reconnu, le frontmatter est invalide, et l'agent est **silencieusement droppé** (aucune erreur). Corrélation 100 % observée la nuit du 26.05.2026 : tous les agents en LF chargeaient (frontend, qa, release, reviewer), tous les agents en CRLF non (architecte, backend, designer, securite, ux, mainteneur-profils). S'applique aussi aux `SKILL.md` et au frontmatter des commands.

- **Chaîne racine dans `claude-profiles`** : `core.autocrlf=true` convertissait LF→CRLF au checkout, et `sync-global.ps1` (un `Copy-Item` brut du working tree) recopiait ce CRLF dans `~/.claude/agents/`.
- **Diagnostic décisif (faire CECI en premier)** :
  - `git ls-files --eol templates/profiles/<profil>/agents/` → repérer `w/crlf` (cassé) vs `w/lf` (ok).
  - Ou byte-check du fichier déployé : premiers octets `2D 2D 2D 0D 0A` = CRLF (cassé) ; `2D 2D 2D 0A` = LF (ok). En Bash : `od -An -tx1 -N5 <fichier>`.
- **Correctif immédiat (copies déployées)** : normaliser `~/.claude/agents/*.md` CRLF→LF (relire en UTF-8, `.Replace("\r\n","\n")`, réécrire UTF-8 sans BOM via Edit/Write), PUIS un vrai redémarrage de process (cf. Cause 2).
- **Correctif durable (en place depuis le 27.05.2026)** : `.gitattributes` racine (`* text=auto eol=lf` + `*.md *.json *.ps1 text eol=lf`), `core.autocrlf=false`, working tree renormalisé LF. Sans ça, le prochain `sync-global.ps1` recasserait tout.

### Cause 2 — Set d'agents figé au démarrage du process

Le harness **photographie la liste des agents au moment où le process `claude` démarre**. Tout agent **créé ou modifié après** cet instant est invisible pour **toute la session en cours**, peu importe sa description.

- **Piège majeur** : un `/clear`, un nouvel onglet, ou une nouvelle conversation **NE rechargent PAS** les agents — ils restent dans le même process. Seul **un arrêt complet du process `claude` + relance** recharge le set (terminal : `/exit` puis `claude` ; app desktop : quitter l'application entière, pas juste fermer la fenêtre).

- **Diagnostic en une passe** (prouve la cause, sans deviner) : comparer l'heure de modif du fichier à l'heure de démarrage du process.
  ```powershell
  # Démarrage du process (le plus ancien PID claude = racine de session)
  Get-Process claude | Sort-Object StartTime | Select-Object -First 1 Id,StartTime
  # mtime du fichier agent
  Get-Item "$env:USERPROFILE\.claude\agents\<nom>.md" | Select-Object LastWriteTime
  ```
  Si `LastWriteTime > StartTime` → l'agent ne peut pas être chargé dans cette session ; **redémarrage complet obligatoire**.

### Règle de prudence (incident 26.05.2026)

**Ne JAMAIS affirmer « c'est réglé » depuis la session figée** : on n'y voit que la photo prise au démarrage. La seule preuve est **empirique** — après un vrai redémarrage du process, demander « liste tes sub-agents » dans la session neuve et confirmer que l'agent apparaît.

> Incident source : 26.05.2026 (clôturé 27.05.2026). Six agents (architecte, backend, designer, securite, ux + le partagé mainteneur-profils) invisibles. **Fausse piste** : on a d'abord cru à un plafond de description ~319 char et raccourci les 6 descriptions (commit `1cdd342`, ~455-830 → 286-301 char) — sans effet, les agents restaient invisibles. **Réfutation** : `qa.md` charge à **329 char** alors que `designer.md` à 281 ne chargeait pas — la longueur ne sépare pas chargés/droppés. La vraie variable était le **CRLF** (Cause 1 ci-dessus) : les 6 agents non chargés étaient exactement les 6 en CRLF (confusion par confondage). Résolu par `.gitattributes` + renormalisation LF (commit `260710e`, 27.05.2026). La longueur de description est un **non-sujet** tant qu'elle n'est pas re-prouvée. Voir aussi la mémoire `reference_subagent_not_invocable`.

## Modèle de SKILL.md à copier

Voir `~/.claude/skills/supabase-toolkit/SKILL.md` ou `~/.claude/skills/perf-audit/SKILL.md` comme modèles aboutis.

## Modèle de sub-agent à copier

Voir `~/.claude/agents/backend.md` ou `~/.claude/agents/frontend.md` comme modèles aboutis (pattern v2 strict + skills associés + MCPs explicités).

## Critères d'évaluation (avant de livrer un nouveau composant)

- [ ] Frontmatter en **fins de ligne LF** (cause primaire de drop silencieux, cf. § « Pourquoi un sub-agent n'apparaît pas » ; le CRLF casse la ligne délimiteur `---`). Description faite de **déclencheurs** — jamais d'une règle ni d'un résumé de workflow (mesuré au banc C1 : une règle en description est lue, pas obéie). **Aucune cible de longueur** : la longueur n'est pas une cause de drop (réfuté, `qa.md` charge à 329 char), et l'ancienne cible de ~300 char n'était qu'un vestige de cette théorie réfutée.
- [ ] Phase 0 HARD GATE de lecture obligatoire.
- [ ] Modes A/B/C détectables en Phase 0.
- [ ] Section « Skills à invoquer ou MCPs à utiliser » si applicable.
- [ ] Auto-check final structuré (6-8 questions binaires).
- [ ] Format de livrable explicite (structure imposée).
- [ ] Hand-off vers destinataires précis.
- [ ] Anti-patterns interdits + Anti-hallucination.
- [ ] Section Incidents source (vide est OK, présente obligatoire).
- [ ] **Stack en défaut surpassable** (si l'agent en nomme une) : section « le projet décide » + garde-fous formulés en principes + découplage **propagé aux gates durs** (garde-fous, workflow, auto-check, checklist) avec N/A autorisé. Cf. § « Découplage de la stack ».
- [ ] Référencement dans CLAUDE.md global + ORCHESTRATION.md + sub-agents connexes.

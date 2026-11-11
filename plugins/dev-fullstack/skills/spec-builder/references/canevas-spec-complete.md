# Canevas de la spec complète (13 sections)

> Annexe de `spec-builder`, déplacée verbatim du `SKILL.md` le 11.11.2026. À ouvrir au troisième étage seulement (plus de 50 lignes, ou tâche structurelle), avant de rédiger : le fichier livré, `specs/YYYY-MM-DD-slug.md`, recopie ce canevas.

Le fichier livré contient **exactement** ces 13 sections, dans cet ordre, avec les **titres Markdown `##` à l'identique**, sans numérotation `1./2./3.`. Toute déviation = livraison refusée.

````markdown
# SPEC — <Titre tâche>

> Projet : <projet> · Auteur : <user> · Date : jj.mm.aaaa

## Contexte
<2-5 paragraphes : situation actuelle, douleur, déclencheur, qui est concerné. Citer la source si l'item vient du BACKLOG.md ou d'un audit.>

## Objectif
<Une phrase action-orientée mesurable. Pas de "améliorer", pas de "optimiser" sans chiffre.>

## Périmètre

### Dans le scope
- <liste exhaustive des éléments traités>

### Hors scope (explicitement)
- <liste explicite de ce qui n'est PAS traité, pour éviter le scope creep>

## Branche cible
`claude/<slug-explicite>`

<Justification courte du slug si non évident.>

## Plan d'exécution
1. <Étape 1> — fichier(s) : `chemin/exact/fichier.ext`
2. <Étape 2> — fichier(s) : `chemin/exact/fichier.ext`
3. ...

<Chaque étape est testable indépendamment. Chemins absolus dans le repo, pas de chemins vagues type "le composant".>

## Contraintes et règles à respecter
- **Source : CLAUDE.md §<X>** — <règle reprise textuellement ou paraphrasée>
- **Source : règle qualité §<X>** — <règle qualité applicable>
- **Inventaire exhaustif** — <si la tâche touche une famille d'éléments, lister TOUS les éléments concernés ici>
- **Préservation des erreurs existantes** — les codes d'erreur natifs (ENOENT, 4xx, etc.) continuent de remonter sans être avalés
- **Nettoyage des ressources** — timers, listeners, connexions libérés dans tous les chemins (succès, échec, timeout, unmount)
- **Gestion d'erreur** — pas de try/catch vide ; logger via le logger projet ; spécifier codes/exceptions retournés, messages, logs. Pour les contextes HTTP : distinguer 4xx (métier) / 5xx (infra)

## Décisions à prendre en cours d'exécution

Le harness doit trancher les points suivants pendant l'exécution et **les documenter dans le rapport final §6** :
- [ ] <Décision 1> — contexte court, options envisageables, critère de choix
- [ ] <Décision 2> — ...

Si aucune décision n'est anticipée pour une SPEC particulière, écrire « Aucune décision attendue, exécution déterministe » et expliquer pourquoi.

## Vérifications avant fin de tâche

### Happy path
- [ ] <Cas nominal 1, sortie attendue précise>
- [ ] <Cas nominal 2, sortie attendue précise>

### Non-régression
- [ ] <Fonction existante 1 inchangée, comment le vérifier>
- [ ] <Fonction existante 2 inchangée, comment le vérifier>

### Edge cases
- [ ] <Cas limite 1 : entrée vide / valeur extrême / concurrence>
- [ ] <Cas limite 2>

### Ordre du repo et version
- [ ] `npm run build` (ou équivalent) passe sans warning nouveau
- [ ] Tests existants tous verts
- [ ] Aucun fichier non commité hors scope
- [ ] Version du package mise à jour si conventions du projet l'exigent

## Pull request vers main
```bash
git push -u origin claude/<slug-explicite>
gh pr create --base main --head claude/<slug-explicite> --title "<type>(<scope>): <description>"
```

La fusion sur `main` passe toujours par la PR, jamais par un push de la session ni par un merge local. Elle se fait **sur demande explicite de l'utilisateur** (« fusionne », « merge ») : Claude Code pousse la branche, ouvre la PR (par `gh` ou par l'outil GitHub de la session), rend son lien et s'arrête là.

## Commit message attendu

Type en français et sans accent (`fonctionnalite`, `correctif`, `entretien`, `doc`, `refonte`, `test`, `portage`) :
table complète et motif au § « Conventions git » du `global-CLAUDE.md`.
```
<type en français>(<scope>): <description en français>
```

Exemple concret pour cette tâche :
```
fonctionnalite(<scope-réel>): <description-réelle-en-français>
```

## Rapport de livraison (en français)
À produire par Claude Code à la fin de l'exécution, en 7 points :
1. Résumé de ce qui a été fait (2-3 phrases)
2. Liste exhaustive des fichiers créés / modifiés / supprimés
3. Inventaire exhaustif des éléments traités (si tâche par famille)
4. Confirmation que l'ordre du repo est propre et version à jour
5. Tests exécutés et résultats (happy path / non-régression / edge cases)
6. Points d'attention résiduels ou décisions prises en cours d'exécution
7. Lien de la PR ouverte (ou raison s'il n'y en a pas) ; la fusion n'est mentionnée que si l'utilisateur l'a demandée

## Auto-review §4 — réponses aux 7 questions
Réponses oui / non applicable avec justification factuelle pour chaque question.

**Format de réponse imposé** :
- Si « **oui** » → fournir une **citation textuelle courte** (entre guillemets) de la section du SPEC qui prouve l'affirmation, avec son nom de section. Format : `oui — section "## X" : "<extrait>"`. Une déclaration sans citation est invalide.
- Si « **non applicable** » → expliquer en une phrase **pourquoi** la question ne s'applique pas au contexte de la tâche. Format : `non applicable — <raison>`.
- Si « **non** » → la spec doit être amendée AVANT livraison (cf. règle d'application §4 ci-dessous).
- **Longueur** : chaque justification tient en 1 phrase (max 400 caractères). Plusieurs citations peuvent être chaînées avec « ; » si nécessaire pour couvrir une réponse complexe.

1. **Inventaire exhaustif** : la tâche touche-t-elle une famille d'éléments (ex: toutes les opérations X, tous les composants Y) ? Si oui, la spec exige-t-elle un inventaire exhaustif dans `## Périmètre` ? `[oui — section "## X" : "<extrait>" / non applicable — <raison>]`

2. **Préservation des comportements existants** : la modification peut-elle casser des comportements existants (erreurs natives, API publiques, edge cases) ? Si oui, la spec impose-t-elle leur préservation dans `## Contraintes` ? `[oui — section "## X" : "<extrait>" / non applicable — <raison>]`

3. **Nettoyage des ressources créées** : la modification crée-t-elle des ressources (timers, listeners, connexions, subscriptions, intervals) ? Si oui, la spec exige-t-elle leur nettoyage dans TOUS les chemins (succès / échec / timeout / exception / unmount) ? `[oui — section "## X" : "<extrait>" / non applicable — <raison>]`

4. **3 groupes de tests** : la section `## Vérifications` contient-elle les 3 groupes obligatoires (Happy path / Non-régression / Edge cases) ? `[oui — section "## X" : "<extrait>" / non applicable — <raison>]`

5. **Gestion d'erreur précise** : les cas d'erreur sont-ils spécifiés (codes/exceptions retournés, messages, logs) ? Pour les contextes HTTP, distinguer 4xx (métier) / 5xx (infra). Pas de try/catch vide ? `[oui — section "## X" : "<extrait>" / non applicable — <raison>]`

6. **Critères vérifiables indépendants** : chaque case à cocher de `## Vérifications` est-elle testable séparément, avec sortie attendue claire ? `[oui — section "## X" : "<extrait>" / non applicable — <raison>]`

7. **CLAUDE.md intégré dans les Contraintes** : toutes les règles absolues et conventions du `CLAUDE.md` du projet cible sont-elles reportées dans `## Contraintes et règles à respecter`, avec source citée ? `[oui — section "## X" : "<extrait>" / non applicable — <raison>]`

**Règle d'application §4** : si une seule réponse est « **non** » (au sens : la spec ne couvre pas un point applicable), la spec doit être amendée AVANT livraison. Les réponses « **non applicable** » avec justification d'une ligne sont autorisées et n'empêchent pas la livraison. Pas de spec livrée avec un « non » non corrigé.

## Auto-check de conformité structurelle (§5)
- [ ] Section `## Contexte` présente, avec cadrage de l'origine.
- [ ] Section `## Objectif` présente, 1 phrase factuelle.
- [ ] Section `## Périmètre` présente, avec « Dans le scope » ET « Hors scope (explicitement) ».
- [ ] Section `## Branche cible` présente, avec slug `claude/[...]`.
- [ ] Section `## Plan d'exécution` présente, étapes numérotées, chemins exacts.
- [ ] Section `## Contraintes et règles à respecter` présente, avec sources citées.
- [ ] Section `## Décisions à prendre en cours d'exécution` présente.
- [ ] Section `## Vérifications avant fin de tâche` présente, avec les 4 sous-sections (Happy path / Non-régression / Edge cases / Ordre du repo et version).
- [ ] Section `## Pull request vers main` présente, avec bloc bash complet, sans merge local ni push sur `main`.
- [ ] Section `## Commit message attendu` présente, avec proposition.
- [ ] Section `## Rapport de livraison (en français)` présente, 7 points listés.
- [ ] Section `## Auto-review §4 — réponses aux 7 questions` présente, réponses renseignées.
- [ ] Section `## Auto-check de conformité structurelle (§5)` présente (celle-ci).

**Règle d'application §5** : avant de livrer, la skill lit le fichier qu'elle vient d'écrire et coche chaque case si la condition est remplie. Si une case ne peut pas être cochée → amender le fichier puis refaire l'auto-check. Si après 2 passes une case persiste à être non cochée → alerter l'utilisateur avec le point défaillant plutôt que livrer une spec hors-norme.
````

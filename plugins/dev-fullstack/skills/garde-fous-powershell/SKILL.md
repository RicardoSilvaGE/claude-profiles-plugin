---
name: garde-fous-powershell
description: "Garde-fous d'écriture de fichiers sous Windows PowerShell 5.1 : BOM ajouté par Set-Content, un seul BOM sur un .ps1, arrays imbriqués dans une table de substitutions, -replace avec de l'Unicode, audit post-batch (motifs mojibake, BOM, restauration git), cible qui doit être un fichier, sorties console en ASCII. À charger avant d'écrire ou de lancer un .ps1, avant toute écriture de fichier par PowerShell, et devant un texte mojibaké."
---

> Version 1.0 — 05.09.2026 (création, PR 2.1 de l'audit du 05.09.2026, constat F1). Le contenu
> est la table « Garde-fous techniques » du `global-CLAUDE.md` du profil, **sortie du résident
> telle quelle** : elle ne vaut que sur un poste Windows, et coûtait ~3 500 octets à chaque
> session, cloud compris, où PowerShell n'est pas. Quatre règles restent résidentes dans la
> doctrine (Edit/Write d'abord, BOM de `Set-Content`, BOM unique des `.ps1`, cible = fichier) ;
> tout le reste est ici. Incidents fondateurs : `CHANGELOG.md` du profil § « Garde-fous
> PowerShell ».

# Garde-fous PowerShell 5.1 — la table complète

Le poste utilise **Windows PowerShell 5.1** (Desktop). Ses pièges ont déjà causé des corruptions
massives de fichiers (26.05.2026 : 21 fichiers mojibakés). Les hooks `guard-poste.ps1`
(PreToolUse) et `audit-mojibake.ps1` (PostToolUse) appliquent déjà mécaniquement plusieurs de ces
règles — ce sont des garde-fous, pas des barrières : un refus de hook se corrige **sur le fond**,
jamais en reformulant la commande.

**En session cloud (Linux), ce skill n'a pas d'objet** : pas de PowerShell 5.1, pas de
`Set-Content`. Il ne s'y charge que si l'on édite un `.ps1` destiné au poste — et alors les
règles 5 et 5bis s'appliquent au fichier produit, pas à l'environnement.

| # | Règle | Piège concret |
|---|---|---|
| 1 | `Set-Content -Encoding UTF8` **ajoute un BOM** | Écrire l'UTF-8 propre via `UTF8Encoding($false)` (recette ci-dessous). Vise `.md`, `.json`, `.ts` et consorts. |
| 2 | **Ne jamais imbriquer un array** dans une table de substitutions | `@{ 'f' = @( @('p','r') ) }` est déroulé : `$pair[0]` devient le *caractère* `'p'`. Utiliser des `[PSCustomObject]@{ From=…; To=… }`. |
| 3 | **`-replace` peut corrompre** avec de l'Unicode dans le pattern (`·`, `«»`, `—`) | Préférer `String.Replace()` : méthode .NET, littérale, pas regex. |
| 4 | **Préférer Edit / Write** (outils Claude Code) à PowerShell pour TOUTE modification de fichier | `.md`, `.py`, `.ps1`, `.ts`, `.tsx`… Edit et Write préservent l'encodage. PowerShell reste pour les opérations système (git, file ops, env vars). |
| 5 | **Exception à la règle 1 : un `.ps1` destiné à PS 5.1 porte un BOM UTF-8** | Sans BOM, PS 5.1 décode le script en ANSI et corrompt les accents de ses messages. **Un seul BOM** : deux en tête cassent le parsing du `<#` d'ouverture. **Edit conserve le BOM existant**, `Write` écrit sans — ne jamais reposer le BOM en aveugle après une édition. |
| 5bis | **Parade de fond, indépendante du BOM : aucun caractère accentué dans les sorties console d'un script** | Le BOM ne protège que tant qu'il est là ; un texte ASCII reste lisible s'il disparaît. Les deux garde-fous se cumulent — ne pas défaire l'un au nom de l'autre. |
| 6 | **Audit post-batch obligatoire** si PowerShell a quand même modifié des fichiers | Trois contrôles, sous ce tableau. Ils ne tiennent pas dans une cellule : le pipe y devrait être échappé, et l'échappement casse la regex **et** la ligne que le hook reconnaît. |
| 7 | **Vérifier que la cible EST un fichier avant de l'écraser, la supprimer ou la déplacer** | `Copy-Item` vers un **dossier** ne proteste pas : il copie **dedans**, le script réussit et n'a rien remplacé. Assertion `Test-Path -PathType Leaf` obligatoire (recette ci-dessous). |

## Règle 6 — l'audit post-batch, en trois contrôles

- Grep patterns mojibake connus : `Oiaie|uenior|aeruion|oroouiu|iignataire|oéuhoo|noroeu`
- Vérifier l'absence de BOM : `[IO.File]::ReadAllBytes($p) | Select -First 3` (ne doit pas valoir `0xEF 0xBB 0xBF`)
- Corruption détectée → `git checkout -- <fichier>` pour restaurer, puis refaire via l'outil Edit

> La formulation « Grep patterns mojibake connus » ci-dessus est **littérale et à conserver telle
> quelle** : `audit-mojibake.ps1` saute les lignes qui la contiennent, faute de quoi le texte qui
> définit les motifs déclenche le détecteur qui les cherche — ce skill est déployé dans
> `~/.claude/skills/`, donc dans le périmètre du hook. Reformuler cette ligne fait réapparaître un
> faux positif à chaque commande shell citant ce fichier. Mémoire : `le-detecteur-qui-cite-ses-motifs`.

## Deux recettes, à recopier telles quelles

```powershell
# 1 — écrire de l'UTF-8 sans BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($path, $content, $utf8NoBom)

# 7 — refuser une cible qui n'est pas un fichier
if (-not (Test-Path -LiteralPath $cible -PathType Leaf)) {
    Write-Host "REFUS : $cible n'est pas un fichier"; continue
}
Copy-Item -LiteralPath $source -Destination $cible -Force
```

**Poser le BOM d'un `.ps1`** (règle 5) : recette Python idempotente dans `CHANGELOG.md` du profil
§ « Garde-fous PowerShell ». Contrôle après pose : `[IO.File]::ReadAllBytes($p)[0..4]` doit valoir
`239 187 191` suivi des deux premiers octets réels du script.

## Deux réflexes transverses, nés de la règle 7

- **Une parade se transporte avec son contexte** : avant de recopier un contournement d'un script
  à l'autre, se demander si sa cause existe encore (l'incident du 12.08.2026 vient d'un `[char]92`
  hérité d'un lancement depuis bash, sans objet sous PowerShell — et c'est lui qui a déroulé le
  tableau, règle 2).
- **Après une passe qui a écrit sur un partage réseau, relire l'état réel** dossier par dossier,
  jamais le seul compte rendu du script : c'est cette relecture qui a révélé l'incident.

## Auto-check avant de rendre la main

1. Le fichier écrit par PowerShell a-t-il été relu en octets (BOM absent, ou unique s'il s'agit d'un `.ps1`) ?
2. Les motifs mojibake ont-ils été cherchés sur **tous** les fichiers touchés, pas sur un échantillon ?
3. Le script lancé a-t-il des sorties console en ASCII pur ?

Incidents fondateurs, règle par règle : `CHANGELOG.md` du profil § « Garde-fous PowerShell ».
Mémoires associées : `powershell-version-constraints`, `bom-ps1-un-seul-edit-le-conserve`.

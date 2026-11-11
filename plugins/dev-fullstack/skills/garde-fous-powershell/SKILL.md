---
name: garde-fous-powershell
description: "Garde-fous d'écriture de fichiers sous Windows PowerShell 5.1 (BOM de Set-Content, BOM unique d'un .ps1, arrays imbriqués, -replace Unicode, audit post-batch, cible = fichier, sorties console ASCII) et, sur le même poste, d'édition par script (Git Bash, heredoc, Python) d'un fichier accentué ou en CRLF. À charger avant d'écrire ou de lancer un .ps1, avant toute écriture de fichier par PowerShell, avant de modifier par un script Python ou un heredoc Git Bash un fichier accentué ou en CRLF, et devant un texte mojibaké. Sans objet en session cloud (Linux), sauf pour éditer un .ps1 destiné au poste."
---

> Version 1.4 — 11.11.2026 (cure de poids : en-tête et récits d'incident réduits). Versions antérieures : `CHANGELOG.md` du profil, non déployé.
> Quatre de ces règles sont aussi résidentes dans la doctrine (Edit/Write d'abord, BOM de
> `Set-Content`, BOM unique des `.ps1`, cible = fichier) ; tout le reste n'est qu'ici.

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
- Vérifier le BOM : `[IO.File]::ReadAllBytes($p) | Select -First 3` — hors `.ps1`, ne doit pas valoir `239 187 191` (soit `0xEF 0xBB 0xBF`, la commande affiche des décimaux) ; sur un `.ps1` destiné à PS 5.1, doit le valoir, une seule fois (règle 5)
- Corruption détectée → `git checkout -- <fichier>` pour restaurer, puis refaire via l'outil Edit

> La formulation « Grep patterns mojibake connus » ci-dessus est **littérale et à conserver telle
> quelle** : `audit-mojibake.ps1` saute les lignes qui la contiennent, faute de quoi le texte qui
> définit les motifs déclenche le détecteur qui les cherche — ce skill est déployé dans
> `~/.claude/skills/`, donc dans le périmètre du hook. Reformuler cette ligne fait réapparaître un
> faux positif à chaque commande shell citant ce fichier. Mémoire du poste : `le-detecteur-qui-cite-ses-motifs`.

## Recettes, à recopier telles quelles

```powershell
# 1 — écrire de l'UTF-8 sans BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($path, $content, $utf8NoBom)

# 7 — refuser une cible qui n'est pas un fichier
#     (se place dans la boucle qui parcourt les cibles : continue passe a la suivante)
if (-not (Test-Path -LiteralPath $cible -PathType Leaf)) {
    Write-Host "REFUS : $cible n'est pas un fichier"; continue
}
Copy-Item -LiteralPath $source -Destination $cible -Force   # $source : le fichier a copier
```

**Poser le BOM d'un `.ps1`** (règle 5) : recette Python idempotente, opération rare.

```python
# poser le BOM d'un .ps1, de facon idempotente
import io
brut = io.open(chemin, "rb").read()
bom = b"\xef\xbb\xbf"
while brut.startswith(bom):      # retirer les BOM deja presents
    brut = brut[len(bom):]
io.open(chemin, "wb").write(bom + brut)   # en octets : fins de ligne et contenu intacts
```

Le `while` n'est pas décoratif : c'est lui qui rend l'opération rejouable sans empiler un second
BOM. Contrôle après pose : `[IO.File]::ReadAllBytes($p)[0..4]` doit valoir `239 187 191` suivi des
deux premiers octets réels du script.

## Deux réflexes transverses, nés de la règle 7

- **Une parade se transporte avec son contexte** : avant de recopier un contournement d'un script
  à l'autre, se demander si sa cause existe encore.
- **Après une passe qui a écrit sur un partage réseau, relire l'état réel** dossier par dossier,
  jamais le seul compte rendu du script.

## Éditer par script un fichier accentué ou en CRLF (Git Bash, Python)

Relevé dans la boîte de frottements du labo des profils (F05) :

- **Accents** : un heredoc Git Bash qui porte du texte accentué vers Python l'abîme. Écrire le script avec l'outil Write, le lancer par `python -X utf8 script.py`.
- **CRLF** : un remplacement Python écrit avec `\n` ne trouve rien dans un fichier CRLF. Écrire les motifs en `\r\n`, ou lire en octets et normaliser avant de comparer. Reconnaître un fichier CRLF : le lire en octets et y chercher `\r\n`.

## Auto-check avant de rendre la main

1. Le fichier écrit par PowerShell a-t-il été relu en octets (BOM absent, ou unique s'il s'agit d'un `.ps1`) ?
2. Les motifs mojibake ont-ils été cherchés sur **tous** les fichiers touchés, pas sur un échantillon ?
3. Le script lancé a-t-il des sorties console en ASCII pur ?
4. Un fichier accentué ou en CRLF modifié par script a-t-il été relu (accents intacts, fins de ligne inchangées) ?

Incidents fondateurs, règle par règle : `CHANGELOG.md` du profil § « Garde-fous PowerShell », dans
le dépôt `claude-profiles` — non déployé, donc hors de portée ailleurs ; tout ce qui sert à
appliquer les règles est dans ce skill.

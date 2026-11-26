# Livrer une spec hors dépôt git

> Annexe de `spec-builder`, déplacée verbatim du `SKILL.md` le 11.11.2026. À ouvrir seulement quand la tâche n'a pas de dépôt git (script isolé, cadrage amont sans code encore). Dans un dépôt, le chemin est `<racine-du-dépôt>/specs/YYYY-MM-DD-slug.md` et seul le motif, en fin de fichier, peut servir.

**Hors dépôt** (script isolé, cadrage amont sans code encore) :
```
%USERPROFILE%\Documents\Claude\Projects\Assistant DEV senior\specs\<projet-en-minuscules>\YYYY-MM-DD-slug.md
```

- `<projet-en-minuscules>` : nom du projet, en minuscules, sans espaces (ex. `factu-simple`, `offre-simple`, `verifbois`)

**Fallback environnement** (hors dépôt seulement) : si le chemin Windows n'est pas accessible et que l'environnement est la sandbox Linux de Claude.ai (`/mnt/user-data/outputs` et le tool `present_files` y existent), écrire dans `/mnt/user-data/outputs/<projet>/YYYY-MM-DD-slug.md` et proposer le téléchargement par `present_files`. Dans une session Claude Code sans ce chemin ni ce tool (session cloud comprise), demander à l'utilisateur où écrire. Mentionner explicitement ce fallback dans la note finale.

**Motif du défaut dans le dépôt** (déplacé verbatim du `SKILL.md` le 26.11.2026, avec la cohabitation des deux formats de date) :

La raison est opposable : la doctrine exige que la spec complète soit **commitée avant le code**, la SPEC-lite **avec** lui. Une spec écrite hors du dépôt ne peut pas l'être — elle vit à côté du travail qu'elle cadre, sans jamais y être rattachée, et un `git log` ne la retrouve pas. Dans le dépôt, elle voyage avec le code, se relit dans la PR, et survit au poste.

- `YYYY-MM-DD` : date du jour au format ISO **dans le nom de fichier** (tri lexicographique). Cohabite intentionnellement avec le format suisse `jj.mm.aaaa` utilisé **dans le contenu** du SPEC (en-tête > ligne « Date : »). Ne pas uniformiser : chaque format a sa raison d'être (tri vs lecture humaine).

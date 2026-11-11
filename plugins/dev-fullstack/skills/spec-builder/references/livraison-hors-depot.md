# Livrer une spec hors dépôt git

> Annexe de `spec-builder`, déplacée verbatim du `SKILL.md` le 11.11.2026. À ouvrir seulement quand la tâche n'a pas de dépôt git (script isolé, cadrage amont sans code encore). Dans un dépôt, le chemin est `<racine-du-dépôt>/specs/YYYY-MM-DD-slug.md` et ce fichier ne sert pas.

**Hors dépôt** (script isolé, cadrage amont sans code encore) :
```
%USERPROFILE%\Documents\Claude\Projects\Assistant DEV senior\specs\<projet-en-minuscules>\YYYY-MM-DD-slug.md
```

- `<projet-en-minuscules>` : nom du projet, en minuscules, sans espaces (ex. `factu-simple`, `offre-simple`, `verifbois`)

**Fallback environnement** (hors dépôt seulement) : si le chemin Windows n'est pas accessible et que l'environnement est la sandbox Linux de Claude.ai (`/mnt/user-data/outputs` et le tool `present_files` y existent), écrire dans `/mnt/user-data/outputs/<projet>/YYYY-MM-DD-slug.md` et proposer le téléchargement par `present_files`. Dans une session Claude Code sans ce chemin ni ce tool (session cloud comprise), demander à l'utilisateur où écrire. Mentionner explicitement ce fallback dans la note finale.

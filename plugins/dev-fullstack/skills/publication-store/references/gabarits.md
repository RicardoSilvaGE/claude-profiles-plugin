# publication-store — gabarits des livrables

> Annexe du skill `publication-store` (v1.6, 11.11.2026 ; v1.7, 15.11.2026). À ouvrir en fin de Phase 4 (checklist
> remise à la personne) et en Phase 5 (Data Safety, notes de release). Les gabarits ne portent
> aucune valeur : chaque champ se remplit depuis les fichiers lus en Phase 1.

## Checklist nominative (fin de Phase 4)

```
# Release <versionName> (<versionCode>) — track <internal|closed|open|production> — <date>

## État du dépôt (fait par le skill)
- [x] Bump : versionCode <n-1> → <n>, versionName <x.y.z>, package.json aligné — commit <hash>
- [x] Build web + cap sync — <date, sortie>
- Préalables non faits : <migrations prod en attente, autres>

## À faire par <personne>, sur sa machine
- [ ] AAB : `gradlew bundleRelease` → android/app/build/outputs/bundle/release/app-release.aab
- [ ] Signature : <Android Studio | keystore.properties>
- [ ] `jarsigner -verify -verbose -certs app-release.aab` finit par `jar verified.`
- [ ] Upload Play Console, track <track>, nom de release `<versionName> (<versionCode>)`
- [ ] Valeurs attendues au scan de la Console : applicationId <…>, versionCode <n>, targetSdk <…>, permissions <liste>
- [ ] Testeurs : <liste d'e-mails>, lien d'opt-in envoyé, ≥ 1 testeur tiers
- [ ] Compte <personnel créé le … | organisation> ; si personnel après le 13.11.2023 : test fermé, <n>/12 testeurs inscrits, jour <j>/14, demande d'accès à la production <non faite | déposée le …>
- [ ] Confirmer `jar verified.` → tag `v<versionName>` posé et poussé par <qui>
```

## Data Safety (Phase 5) — une ligne par type de donnée

```
| Donnée | Collectée ? | Optionnelle ? | Partagée (avec qui) ? | Chiffrée en transit ? | Suppression possible (par quel chemin) ? | Finalité |
```

À tenir dans un fichier versionné du dépôt. Une ligne par donnée qui quitte l'appareil, contenu des
notifications compris ; « partagée » ne vaut pas pour un prestataire qui traite pour le compte du
développeur. Puis :

```
Lien web de suppression du compte (saisi dans le formulaire) : <URL>
Contrôle code ↔ ce fichier ↔ politique EN LIGNE : <date>, <écarts trouvés et corrigés | aucun>
```

## Notes de release (Phase 5) — par locale, copy par `growth`

```
Nouveautés : …
Sous le capot : …
Connu : …
Contact : …
```

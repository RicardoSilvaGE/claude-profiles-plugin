# Fiche `ux-preuves` — Sévérité 0-4 et choix de la méthode d'évaluation (volet UX)

> Sorti du `SKILL.md` le 11.11.2026 (v1.15), verbatim : ces deux sections ne servent qu'au volet UX,
> et le skill est préchargé par douze agents. À ouvrir avant de coter un problème d'utilisabilité, de
> choisir une méthode d'évaluation ou de lancer un test.

## Prioriser : sévérité 0-4

L'échelle de Nielsen cote chaque problème par trois facteurs — **fréquence** (combien de
personnes le rencontrent), **impact** (gêne ou blocage), **persistance** (surmonté une fois
appris, ou subi à chaque passage) — Nielsen y ajoute l'impact marché. Une cote donnée par **un
seul** évaluateur est « too unreliable to be trusted » : quand c'est possible, moyenner au moins
trois évaluateurs ; sinon, le dire. Source : Nielsen 1994, « Severity Ratings for Usability
Problems » ; détail dans `references/normes-lois-methodes.md`.

| Cote | Sens | Conduite |
|---|---|---|
| 4 | Catastrophe d'utilisabilité | Corriger avant livraison |
| 3 | Problème majeur | Priorité haute |
| 2 | Problème mineur | Priorité basse |
| 1 | Cosmétique | Si le temps le permet |
| 0 | Pas un problème d'utilisabilité | — |

Une cote se justifie par les trois facteurs, en une ligne. Un défaut **N1** (WCAG, légal) qui
bloque une personne est au moins 3, quelle que soit sa fréquence : bloquer quelqu'un n'est pas
une affaire de statistique.

## De la question à la méthode

| Question | Méthode | Ce qu'elle ne dit pas |
|---|---|---|
| Les gens trouvent-ils l'information ou la fonction ? | Tree testing (arborescence seule), first-click test | Si la page trouvée est comprise |
| Peuvent-ils accomplir la tâche ? Où butent-ils ? | Test d'utilisabilité modéré, itératif, petit nombre de participants par profil | Une fréquence fiable dans la population |
| La tâche est-elle perçue comme facile ? | SEQ après chaque tâche ; SUS ou UMUX-Lite en fin de session | Pourquoi ; la cause se voit dans l'observation |
| Le changement modifie-t-il le comportement à l'échelle ? | Test A/B, taille d'échantillon et durée fixées d'avance | Pourquoi ; et rien sur ce qui n'est pas mesuré |
| Sert-il l'objectif du produit ? | HEART (Happiness, Engagement, Adoption, Retention, Task success) en Goals → Signals → Metrics | Rien sans une décision à éclairer ; conçu pour du web à fort trafic, peu transposable tel quel à un outil métier à faible audience |
| Que cherchent-ils à accomplir, au fond ? | Entretiens orientés jobs-to-be-done, observation en contexte | Une validation de solution |

Détail, chiffres de référence (moyenne SUS, taille d'échantillon et ses critiques, pièges des
tests A/B) et sources : `references/normes-lois-methodes.md`.

**Trois règles de protocole qui évitent la plupart des faux résultats** :

1. **Fixer le seuil de décision avant de mesurer.** Choisir ensuite, c'est lire ce qu'on veut.
2. **Formuler les tâches sans le vocabulaire de l'interface.** « Trouvez où modifier votre
   adresse », pas « cliquez sur Profil ».
3. **Ne pas regarder un A/B en cours pour l'arrêter dès qu'il « gagne ».** Ce test multiple
   « significantly inflates the type-I error rates » (Kohavi, Deng, Vermeer, KDD 2022) : fixer
   durée et effectif d'avance, ou employer une méthode séquentielle (`references/normes-lois-methodes.md`).

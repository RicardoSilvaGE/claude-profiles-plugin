# Charte de code — compatibilité et migrations

> Annexe de `charte-code`, déplacée verbatim du `SKILL.md` le 11.11.2026. À ouvrir avant de modifier un schéma de données déployé, d'écrire une migration ou de changer un contrat d'API déjà consommé.

- **Expand / contract** pour tout changement de schéma déployé en continu : ajouter la nouvelle
  forme, écrire dans les deux, migrer les données, basculer les lectures, puis seulement retirer
  l'ancienne. Une migration qui supprime et ajoute dans le même déploiement casse les instances
  encore en vol.
- Une migration est **idempotente** et **réversible**, ou bien elle s'accompagne du geste de
  restauration écrit noir sur blanc avant exécution (`release` Mode C).
- Un contrat d'API se déprécie, il ne se rompt pas : nouvelle version en parallèle, date de
  retrait annoncée, mesure de l'usage résiduel avant suppression.

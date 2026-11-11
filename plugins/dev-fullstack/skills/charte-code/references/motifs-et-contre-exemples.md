# Charte de code — motifs et contre-exemples

> Annexe de `charte-code`, déplacée verbatim du `SKILL.md` le 11.11.2026. À ouvrir quand une règle est contestée, quand il faut la justifier à l'utilisateur ou dans une review, ou devant un cas limite que la règle seule ne tranche pas. Les règles, leurs corollaires et la grille de review sont dans le `SKILL.md`.

## 1. Rien de silencieux

**Motif.** Une erreur avalée ne supprime pas la panne, elle supprime la trace de la panne. Le
symptôme réapparaît plus loin, sur un état déjà corrompu, dans un fichier qui n'a rien à voir.
C'est la seule classe de défaut qui rend le débogage plus coûteux que la réécriture.

```ts
// NON — le repli devient la valeur normale, personne ne saura jamais que l'appel a échoué
try { return await getUser(id) } catch { return null }

// OUI — l'échec est nommé, et l'appelant décide
try {
  return await getUser(id)
} catch (err) {
  logger.error({ err, id }, 'getUser a échoué')
  throw new UserLookupError(id, { cause: err })
}
```

## 2. Échouer tôt, à la frontière

**Motif.** Valider partout un peu revient à ne valider nulle part : chaque fonction porte des
gardes défensives, personne ne sait laquelle fait foi, et la donnée invalide finit quand même
en base. Une frontière nette rend le reste du code lisible.

## 3. Pas de code mort livré

**Motif.** Le code mort n'est pas neutre : il est lu, il est maintenu, il est copié. Et il ment
sur l'état du système — quelqu'un finira par croire que ce chemin est actif.

Git conserve ce qui a été supprimé. Un bloc commenté est une sauvegarde qui ne sait pas dire
d'où elle vient ni pourquoi elle a été mise de côté.

## 4. Le commentaire dit POURQUOI

```py
# NON — paraphrase : deviendra faux à la première modification, et personne ne le corrigera
# incrémente le compteur de 1
compteur += 1

# OUI — porte ce que le code ne peut pas dire
# L'API tierce plafonne à 100 req/min ; au-delà elle renvoie 200 avec un corps vide,
# ce qui se lit comme un succès. Incident du 12.03.
```

## 5. Nommer ce qui existe

**Motif.** Le nom est la seule documentation que le compilateur maintienne à jour. Et l'unité
absente d'un nom est une classe d'erreur entière : millisecondes contre secondes, centimes
contre unités, octets contre kilo-octets.

## 6. Règle de trois avant d'abstraire

**Motif.** Une abstraction posée sur un cas d'usage unique code une hypothèse qu'on n'a pas
encore vérifiée. Le jour où le second cas arrive, il ne rentre pas ; on ajoute un paramètre, puis
un drapeau, et l'abstraction coûte désormais plus cher que la duplication qu'elle a évitée.

## 7. Une dépendance est un engagement

**Motif.** Une dépendance s'installe en dix secondes et se retire en trois jours. Elle apporte
son arbre transitif, sa surface d'attaque, ses breaking changes et ses obligations d'upgrade.

## 9. Tout appel réseau a un timeout

**Motif.** Sans borne, la défaillance d'un service lent ne se traduit pas par une erreur mais par
un épuisement : connexions retenues, fils bloqués, saturation, panne totale d'un service qui
n'avait qu'un dépendant dégradé.

## 10. Un correctif de bug commence par le test qui le reproduit

**Motif.** C'est la même discipline que l'injection de faute qui valide les bancs du dépôt des profils :
un test qu'on n'a jamais vu échouer ne prouve pas qu'il sait échouer.

## 11. Mesurer avant d'optimiser

**Motif.** L'intuition de performance est fausse la plupart du temps, et le coût de l'erreur est
double : on complique un code qui n'était pas le goulet, et on ne corrige pas celui qui l'était.

> Portée de ce motif : avis d'experts, pas une mesure — `ux-preuves`, `references/architecture-qualites-nfr.md` (« Aucune étude empirique […] sur la fiabilité de l'intuition des développeurs quant aux goulets d'étranglement n'a été trouvée ni lue »).

La règle 8 n'a pas de motif séparé : sa raison est dans son énoncé (l'historique conserve ce qu'on supprime).

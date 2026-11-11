# framework-upgrade — pièges structurels par framework, outils

> Annexe du skill `framework-upgrade`, sortie du `SKILL.md` le 11.11.2026 (v1.6), texte inchangé.
> À ouvrir en Phase 2, pour savoir **où chercher** les ruptures du framework visé avant de remplir
> l'inventaire. Elle ne remplace pas les release notes de la Phase 1.

## Connaissance domaine métier — les pièges structurels, jamais les numéros

Aucun numéro de version ici, à dessein (05.09.2026, audit § Skills) : cette section en récitait
une trentaine, contre sa propre règle « ne jamais réciter de mémoire », et chacun périmait en
silence. Ce qui suit est ce qui ne change pas d'une version à l'autre : la **forme** des ruptures,
à confronter aux release notes lues le jour même en Phase 1.

- **Next.js** : les ruptures portent sur les API de requête (paramètres, en-têtes et cookies qui
  deviennent asynchrones), sur les défauts de cache de `fetch`, sur la version de React exigée,
  et sur le passage Pages Router → App Router — qui est une **migration**, pas un upgrade :
  cadrer avec `architecte`. Chercher le codemod officiel (`@next/codemod`) avant de toucher à
  la main.
- **React** : une majeure casse d'abord par les **types** (`@types/react` durcit ce qu'accepte
  `ReactNode`), puis par les API dépréciées (`forwardRef`, refs passées en prop) ; les nouveaux
  primitifs (actions, état de formulaire, optimistic UI) ne cassent rien mais rendent l'ancien
  idiome obsolète — ne pas les adopter dans un upgrade, c'est un chantier à part.
- **Tailwind** : un changement de moteur déplace la configuration (fichier JS → CSS), change les
  directives d'import et rend les plugins tiers incompatibles jusqu'à leur propre mise à jour ;
  un codemod existe, à lire avant de l'exécuter, jamais en `@next` aveugle.
- **shadcn/ui** : pas une lib npm, du code copié. « Upgrade » = re-coller depuis le registre et
  réappliquer les customisations à la main ; vérifier la version de Radix UI sous-jacente.
- **TypeScript** : une mineure est presque toujours indolore ; une majeure casse par les flags de
  rigueur ajoutés par défaut et par les types utilitaires — lire le tableau des breaking changes
  de la release note, pas le résumé.
- **Node.js** : entre deux LTS, vérifier la matrice de compatibilité de l'hébergeur (Vercel,
  Render, NAS) et du client base de données, puis bumper `engines.node` dans `package.json`.

### Outils utiles
- `npx npm-check-updates` (pour **voir**, jamais `-u` à l'aveugle).
- Les codemods officiels de chaque outil, nommés dans leur upgrade guide du jour.
- `npm ls <pkg>` : voir où une dep est utilisée ; `npm dedupe` : nettoyer après upgrade.

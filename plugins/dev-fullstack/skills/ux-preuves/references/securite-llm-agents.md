# Fiche `ux-preuves` — Sécurité — applications avec LLM et agents, LLM auditeur

> Fiche du skill `ux-preuves` (dev-fullstack), volet **sécurité**, préchargé par `securite`. Couvre : OWASP Top 10 for LLM Applications 2025 et risques agentiques, injection de prompt indirecte et limites des défenses, patrons de conception sûrs, MCP (spécification 2026-07-28), données envoyées aux API, LLM comme détecteur de vulnérabilités (PrimeVul, Ullah et al., Big Sleep, AIxCC), traitement des sorties et consommation non bornée.
> **Instantané de la recherche documentaire du 09 au 10.11.2026** (menée autour de minuit UTC) : chaque
> entrée cite une page réellement ouverte pendant cette recherche, avec un extrait lu. Classements, versions, avis de sécurité et textes réglementaires
> **vieillissent** ; le droit change par révision : avant d'en faire dépendre une décision,
> relire la page officielle (§ « Quand vérifier en ligne » du skill). Les sections « Verdict sur les
> règles du profil », « Mythes » et « Non vérifié » sont opposables autant que les entrées.
> **Ajouter une entrée** : même format, ligne « Source » avec URL ouverte et date de lecture,
> marquée « veille du <date> ». Ne jamais réécrire un extrait de mémoire.

Périmètre : applications web d'un développeur indépendant qui appellent un modèle (API Claude ou autre), exposent des outils à un agent ou utilisent des serveurs MCP ; et limites d'un LLM employé comme auditeur de sécurité. Hors périmètre, traité ailleurs : sécurité du code généré, paquets hallucinés, flagornerie.

Méthode : chaque entrée vient d'une page ouverte le 9 novembre 2026 (WebFetch, ou PDF arXiv téléchargé puis extrait avec `pdftotext`). Les extraits sont verbatim dans leur langue d'origine. Quand seule la page de résumé a été lue, c'est indiqué. Les métadonnées de publication (lieu, pages) obtenues par l'API Crossref sont signalées comme telles.

---

## 1. OWASP : Top 10 LLM 2025 et publications agentiques

### Rattacher chaque constat d'une application à LLM à un identifiant OWASP LLM 2025 exact (LLM01 à LLM10), pas à un intitulé de mémoire
- Niveau de preuve : N1 (référentiel communautaire OWASP)
- Source : OWASP GenAI Security Project, 2024 (ressource datée du 17 novembre 2024), « OWASP Top 10 for LLM Applications 2025 », https://genai.owasp.org/llm-top-10/ et https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/
- Extrait lu : « LLM01:2025 Prompt Injection » … « LLM02:2025 Sensitive Information Disclosure », « LLM03:2025 Supply Chain », « LLM04:2025 Data and Model Poisoning », « LLM05:2025 Improper Output Handling », « LLM06:2025 Excessive Agency », « LLM07:2025 System Prompt Leakage », « LLM08:2025 Vector and Embedding Weaknesses », « LLM09:2025 Misinformation », « LLM10:2025 Unbounded Consumption »
- Portée / limites : liste lue sur la page web ; le PDF complet n'a pas été lu. La date du 17.11.2024 est celle de la page ressource. Les identifiants de la version 2023 (par ex. « Insecure Output Handling », « Model Denial of Service ») ne correspondent plus : LLM07, LLM08 et LLM10 ont changé de sens.
- En pratique : dans le rapport, citer « LLM06:2025 Excessive Agency » et non un numéro seul ; refuser tout identifiant OWASP qu'on ne peut pas rapprocher de cette liste.

### Pour une application agentique, citer l'OWASP Top 10 for Agentic Applications 2026 (ASI01–ASI10) en complément du Top 10 LLM
- Niveau de preuve : N1 (référentiel OWASP, présenté comme « globally peer-reviewed »)
- Source : OWASP GenAI Security Project, 9 décembre 2025, « OWASP Top 10 for Agentic Applications for 2026 », https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/ et billet https://genai.owasp.org/2025/12/09/owasp-top-10-for-agentic-applications-the-benchmark-for-agentic-security-in-the-age-of-autonomous-ai/ ; document compagnon : OWASP Agentic Security Initiative, 17 février 2025, « Agentic AI – Threats and Mitigations », https://genai.owasp.org/resource/agentic-ai-threats-and-mitigations/
- Extrait lu : « ASI01 – Agent Goal Hijack », « ASI02 – Tool Misuse », « ASI03 – Identity & Privilege Abuse », « ASI04 – Agentic Supply Chain Vulnerabilities », « ASI05 – Unexpected Code Execution », « ASI06 – Memory & Context Poisoning », « ASI07 – Insecure Inter-Agent Communication », « ASI08 – Cascading Failures », « ASI09 – Human-Agent Trust Exploitation », « ASI10 – Rogue Agents » ; et pour le document de février 2025 : « This document is the first in a series of guides from the OWASP Agentic Security Initiative (ASI) »
- Portée / limites : seuls les intitulés ont été lus (billet et page ressource) ; le contenu détaillé de chaque risque ASI n'a pas été lu. Le principe parfois attribué à ce document (« least agency ») n'apparaît pas dans les pages lues. Une recherche signale une version 1.1 (décembre 2025) du document « Threats and Mitigations » : non ouverte.
- En pratique : si l'application enchaîne plusieurs appels d'outils ou garde une mémoire, classer les constats en ASI (détournement d'objectif, abus d'outil, empoisonnement de mémoire) en plus de LLM01/LLM06.

### Partir du principe qu'aucune défense ne bloque à coup sûr l'injection de prompt (LLM01) et chercher les contrôles qui limitent l'impact
- Niveau de preuve : N1
- Source : OWASP, 2024-2025, « LLM01:2025 Prompt Injection », https://genai.owasp.org/llmrisk/llm01-prompt-injection/
- Extrait lu : « it is unclear if there are fool-proof methods of prevention for prompt injection » ; « Indirect prompt injections occur when an LLM accepts input from external sources, such as websites or files. »
- Portée / limites : la page liste sept mesures (contraindre le comportement, valider le format de sortie par du code déterministe, filtrer, moindre privilège, approbation humaine, séparer le contenu externe, tests adverses). OWASP ne hiérarchise pas leur efficacité.
- En pratique : demander « quelle source de texte non contrôlée par l'utilisateur atteint le modèle (page web, e-mail, fichier, résultat d'outil) ? » puis « quelle action le modèle peut-il déclencher ensuite ? ». Un constat LLM01 se juge à l'action atteignable, pas au simple fait que l'injection marche.

### Chercher la « complete mediation » : l'autorisation d'une action d'agent doit être vérifiée par le système en aval, jamais par le LLM (LLM06)
- Niveau de preuve : N1
- Source : OWASP, 2024-2025, « LLM06:2025 Excessive Agency », https://genai.owasp.org/llmrisk/llm062025-excessive-agency/
- Extrait lu : « Implement authorization in downstream systems rather than relying on an LLM to decide if an action is allowed or not. » ; causes : « excessive functionality », « excessive permissions », « excessive autonomy »
- Portée / limites : autres mesures de la page : minimiser les extensions et leurs fonctions, éviter les extensions ouvertes (« Avoid the use of open-ended extensions where possible. »), exécuter dans le contexte de l'utilisateur, approbation humaine pour les actions à fort impact.
- En pratique : pour chaque outil exposé au modèle, vérifier (1) qu'il ne fait que ce que la fonction exige (pas de shell générique, pas de SQL libre), (2) qu'il s'exécute avec le jeton de l'utilisateur et non un compte de service large, (3) que le contrôle d'accès est dans le code de l'outil ou de l'API, pas dans le prompt.

### Ne jamais traiter le prompt système comme un secret ni comme un contrôle de sécurité ; aucun identifiant dedans (LLM07)
- Niveau de preuve : N1
- Source : OWASP, 2024-2025, « LLM07:2025 System Prompt Leakage », https://genai.owasp.org/llmrisk/llm072025-system-prompt-leakage/
- Extrait lu : « the system prompt should not be considered a secret, nor should it be used as a security control. » ; « sensitive data such as credentials, connection strings, etc. should not be contained within the system prompt language. » ; « Critical controls such as privilege separation, authorization bounds checks, and similar must not be delegated to the LLM »
- Portée / limites : OWASP précise que le risque réel est la faiblesse sous-jacente, pas la divulgation du texte du prompt lui-même.
- En pratique : chercher dans le code les chaînes de prompt système contenant clés d'API, URL de base de données, noms de rôles « admin » ou règles du type « ne révèle jamais… » utilisées comme seule barrière.

### Vérifier que les restrictions de données sensibles ne reposent pas sur une consigne au modèle (LLM02)
- Niveau de preuve : N1
- Source : OWASP, 2024-2025, « LLM02:2025 Sensitive Information Disclosure », https://genai.owasp.org/llmrisk/llm022025-sensitive-information-disclosure/
- Extrait lu : « such restrictions may not always be honored and could be bypassed via prompt injection or other methods. » ; « Limit access to sensitive data based on the principle of least privilege. »
- Portée / limites : la page vise aussi l'entraînement (assainir les données, permettre l'opt-out, politiques de rétention transparentes). Elle ne traite pas spécifiquement des journaux applicatifs ; la question des logs est une déduction (voir thème 4).
- En pratique : quelles données personnelles entrent dans le contexte du modèle ? Le modèle peut-il récupérer (outil, RAG) des données d'un autre utilisateur ? Les prompts et réponses complets sont-ils journalisés, et où ?

### Dans une application RAG, exiger un cloisonnement des données par utilisateur dans l'index vectoriel (LLM08)
- Niveau de preuve : N1
- Source : OWASP, 2024-2025, « LLM08:2025 Vector and Embedding Weaknesses », https://genai.owasp.org/llmrisk/llm082025-vector-and-embedding-weaknesses/
- Extrait lu : « Inadequate or misaligned access controls can lead to unauthorized access to embeddings containing sensitive information. » ; le risque multi-locataire quand « multiple classes of users or applications share the same vector database »
- Portée / limites : la page recommande des « permission-aware vector and embedding stores » et un partitionnement logique strict ; elle cite aussi l'empoisonnement des données indexées.
- En pratique : la requête de similarité est-elle filtrée par `tenant_id`/`user_id` côté serveur (pas en post-filtrage dans le prompt) ? Un document téléversé par un utilisateur peut-il ressortir dans le contexte d'un autre (vecteur d'injection indirecte) ?

---

## 2. Injection de prompt indirecte : attaques, défenses, limites mesurées

### Considérer tout contenu récupéré par l'application (web, e-mail, document, résultat d'outil) comme un canal d'instructions de l'attaquant
- Niveau de preuve : N2 (article revu par les pairs, atelier ACM AISec ; démonstrations sur applications réelles, pas d'échantillon statistique)
- Source : Greshake, Abdelnabi, Mishra, Endres, Holz, Fritz, 2023, « Not What You've Signed Up For: Compromising Real-World LLM-Integrated Applications with Indirect Prompt Injection », Proceedings of the 16th ACM Workshop on Artificial Intelligence and Security, p. 79-90, DOI 10.1145/3605764.3623985 (métadonnées via api.crossref.org ; page ACM refusée en 403) ; texte lu : https://arxiv.org/pdf/2302.12173 (v2, 5 mai 2023)
- Extrait lu : « We argue that LLM-Integrated Applications blur the line between data and instructions. We reveal new attack vectors, using Indirect Prompt Injection, that enable adversaries to remotely (without a direct interface) exploit LLM-integrated applications by strategically injecting prompts into data likely to be retrieved. »
- Portée / limites : modèles et produits de 2023 (Bing Chat, etc.) ; l'article établit le vecteur et une taxonomie, il ne mesure pas un taux de réussite sur un grand échantillon.
- En pratique : tracer, pour chaque appel au modèle, la provenance de chaque bloc de texte. Tout bloc dont un tiers peut influencer le contenu est une entrée de l'attaquant, au même titre qu'un paramètre HTTP.

### Ne pas accepter une défense « anti-injection » publiée comme preuve de robustesse : les attaques adaptatives contournent la plupart d'entre elles
- Niveau de preuve : N2 (étude empirique ; 12 défenses, plus une compétition de red teaming humain de plus de 500 participants ; prépublication arXiv, lieu de publication non vérifié)
- Source : Nasr, Carlini, Sitawarin, Schulhoff, Hayes, Ilie, Pluto, Song, Chaudhari, Shumailov, Thakurta, Xiao, Terzis, Tramèr, 2025 (arXiv 10 octobre 2025), « The Attacker Moves Second: Stronger Adaptive Attacks Bypass Defenses Against LLM Jailbreaks and Prompt Injections », https://arxiv.org/pdf/2510.09023
- Extrait lu : « we bypass 12 recent defenses (based on a diverse set of techniques) with attack success rate above 90% for most; importantly, the majority of defenses originally reported near-zero attack success rates. » ; « On a selected subset of scenarios and defenses, the search attack succeeds 69% of the time whereas the red-teaming humans collectively succeeds 100% of the time » ; sur les détecteurs : « PIGuard is somewhat more resistant but still reaches 71% ASR. »
- Portée / limites : défenses de recherche et détecteurs du marché (Protect AI, PromptGuard, Model Armor, PIGuard) ; ne teste pas les patrons architecturaux (voir entrées suivantes). Les auteurs sont en partie chez Google DeepMind.
- En pratique : si l'application compte sur un filtre, un classifieur ou une consigne pour « bloquer les injections », le constat reste ouvert : demander ce qui se passe quand le filtre laisse passer une injection.

### Appliquer la règle des trois propriétés : une même session d'agent ne doit pas réunir données privées, contenu non fiable et capacité d'agir ou de communiquer vers l'extérieur
- Niveau de preuve : N4 (avis de praticien et article d'éditeur)
- Source : Willison, 16 juin 2025, « The lethal trifecta for AI agents », https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/ ; Meta, 31 octobre 2025, « Agents Rule of Two: A Practical Approach to AI Agent Security », https://ai.meta.com/blog/practical-ai-agent-security/
- Extrait lu : Willison : « Access to your private data », « Exposure to untrusted content », « The ability to externally communicate » ; « we still don't know how to 100% reliably prevent this from happening. » Meta : « [A] An agent can process untrustworthy inputs », « [B] An agent can have access to sensitive systems or private data », « [C] An agent can change state or communicate externally » ; « The Agents Rule of Two is a supplement — and not a substitute — for common security principles such as least-privilege. »
- Portée / limites : heuristique de conception, sans mesure. La version de Willison vise l'exfiltration ; celle de Meta ajoute le changement d'état. Meta écrit aussi que la satisfaire « should not be viewed as sufficient for protecting against other threat vectors ».
- En pratique : cocher A/B/C pour chaque agent ou session. Trois cases cochées sans validation humaine ou sans coupure architecturale = constat de conception, même si aucune injection n'a été démontrée.

### Recommander un patron de conception qui empêche le contenu non fiable de déclencher des actions, plutôt qu'un filtre
- Niveau de preuve : N2 (proposition de conception argumentée par des chercheurs de plusieurs organisations ; pas d'évaluation statistique, prépublication)
- Source : Beurer-Kellner, Buesser, Creţu, Debenedetti, Dobos, Fabian, Fischer, Froelicher, Grosse, Naeff, Ozoani, Paverd, Tramèr, Volhejn, 2025 (arXiv juin 2025), « Design Patterns for Securing LLM Agents against Prompt Injections », https://arxiv.org/pdf/2506.08837
- Extrait lu : « once an LLM agent has ingested untrusted input, it must be constrained so that it is impossible for that input to trigger any consequential actions » ; « we believe it is unlikely that general-purpose agents can provide meaningful and reliable safety guarantees. »
- Portée / limites : six patrons nommés dans le texte : Action-Selector, Plan-Then-Execute, LLM Map-Reduce, Dual LLM, Code-Then-Execute, Context-Minimization. Chacun réduit l'utilité de l'agent ; les auteurs le disent.
- En pratique : demander quel patron l'application suit. Un agent « généraliste » qui lit du contenu tiers puis choisit librement ses outils ne correspond à aucun patron : constat de conception.

### Citer CaMeL comme preuve qu'une isolation par capacités coûte un peu d'utilité, et AgentDojo comme banc pour tester un agent
- Niveau de preuve : N2 (évaluations sur banc public ; résumés seuls lus)
- Source : Debenedetti, Shumailov, Fan, Hayes, Carlini, Fabian, Kern, Shi, Terzis, Tramèr, 2025, « Defeating Prompt Injections by Design », https://arxiv.org/abs/2503.18813 ; Debenedetti, Zhang, Balunović, Beurer-Kellner, Fischer, Tramèr, 2024, « AgentDojo: A Dynamic Environment to Evaluate Prompt Injection Attacks and Defenses for LLM Agents », https://arxiv.org/abs/2406.13352
- Extrait lu : CaMeL : « LLM agents are vulnerable to prompt injection attacks when handling untrusted data. » ; d'après le résumé, CaMeL résout 77 % des tâches d'AgentDojo avec sécurité prouvable contre 84 % sans défense (chiffres paraphrasés par l'outil de lecture, verbatim non obtenu). AgentDojo : « We populate the environment with 97 realistic tasks » ; « 629 security test cases »
- Portée / limites : résumé seul lu pour les deux. Banc de tâches d'assistant (mail, banque, voyage), pas d'applications web arbitraires.
- En pratique : pour un agent maison, demander s'il existe un jeu de tests d'injection (documents piégés). À défaut, recommander d'en créer un sur le modèle d'AgentDojo.

### Vérifier l'implémentation des consignes d'Anthropic pour le contenu non fiable dans une application Claude
- Niveau de preuve : N3 (documentation officielle de l'éditeur)
- Source : Anthropic, consultée le 9 novembre 2026, « Mitigate jailbreaks and prompt injections », https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/mitigate-jailbreaks
- Extrait lu : « Deliver third-party content to Claude inside `tool_result` blocks, never in `system` prompts or plain user `text` blocks. » ; « Apply the principle of least privilege so that a successful injection can do minimal damage » ; « wrap third-party strings in a JSON object rather than concatenating them into free-form text. »
- Portée / limites : document de l'éditeur, sans mesure d'efficacité. Il recommande aussi un pré-filtrage par un petit modèle (Haiku) que Nasr et al. montrent contournable par un attaquant adaptatif : à traiter comme une couche, pas une barrière.
- En pratique : grep des appels `messages.create` : le contenu externe est-il concaténé dans `system` ou dans un texte utilisateur ? Est-il encodé en JSON ? L'agent a-t-il accès à des secrets dont la tâche n'a pas besoin ?

### Chiffrer le risque résiduel avec les mesures publiées par l'éditeur lui-même : environ 1 à 2 % de réussite d'attaque reste « un risque significatif »
- Niveau de preuve : N3 (mesure publiée par l'éditeur, attaquant interne « Best-of-N », méthode non reproductible de l'extérieur)
- Source : Anthropic, 24 novembre 2025, « Mitigating the risk of prompt injections in browser use » (page research), https://www.anthropic.com/research/prompt-injection-defenses
- Extrait lu : « A 1% attack success rate—while a significant improvement—still represents meaningful risk. » ; « prompt injection is far from a solved problem » ; graphique : Opus 4.5 de 8,0 % (modèle seul) à 1,4 % (protections améliorées), Sonnet 4.5 de 13,8 % à 1,9 %
- Portée / limites : usage navigateur, modèles de 2025, attaquant défini par l'éditeur. Ne dit rien d'une application tierce qui n'utilise pas ces protections.
- En pratique : ne jamais écrire « le modèle résiste aux injections » dans un rapport. Écrire : « le modèle réduit le taux mais ne l'annule pas ; l'impact doit être borné par l'architecture ».

### Chercher le canal d'exfiltration par rendu Markdown (image ou lien) dans toute interface qui affiche la sortie du modèle
- Niveau de preuve : N4 (veille de praticien, cas datés sur des produits réels)
- Source : Willison, page de tag mise à jour jusqu'en juillet 2026, « markdown-exfiltration », https://simonwillison.net/tags/markdown-exfiltration/
- Extrait lu : « an attacker tricks the bot into rendering a Markdown image that leaks data encoded in the URL to an external server. »
- Portée / limites : cas listés : Slack AI (20.08.2024), GitLab Duo (23.05.2025), Microsoft 365 Copilot « EchoLeak » (11.06.2025), Salesforce Agentforce « ForcedLeak » (26.09.2025), Google Antigravity (25.11.2025), Claude web_fetch (15.07.2026). Les détails de chaque cas n'ont pas été lus. Le patron de conception de Beurer-Kellner et al. cite le même risque (« exfiltrating sensitive information (e.g., via embedded links) »).
- En pratique : la sortie du modèle est-elle rendue en Markdown/HTML ? Les images externes sont-elles chargées automatiquement ? Une CSP `img-src` restrictive ou une liste blanche de domaines existe-t-elle ?

---

## 3. MCP et outils exposés aux agents

### Auditer un serveur ou client MCP contre la spécification en vigueur : version 2026-07-28
- Niveau de preuve : N1 (spécification du protocole)
- Source : Model Context Protocol, spécification « latest » (schéma 2026-07-28), consultée le 9 novembre 2026, https://modelcontextprotocol.io/specification/latest
- Extrait lu : « Tools represent arbitrary code execution and must be treated with appropriate caution. » ; « descriptions of tool behavior such as annotations should be considered untrusted, unless obtained from a trusted server. » ; « Hosts must obtain explicit user consent before invoking any tool »
- Portée / limites : la spécification dit elle-même que « MCP itself cannot enforce these security principles at the protocol level ». La version 2026-07-28 rend le protocole sans état ; les recommandations sur les identifiants de session renvoient à la version 2025-11-25.
- En pratique : noter la version de protocole annoncée par le serveur audité. Un serveur qui suit encore 2025-11-25 relève d'une autre page de bonnes pratiques.

### Refuser le « token passthrough » : un serveur MCP n'accepte que des jetons émis pour lui
- Niveau de preuve : N1
- Source : Model Context Protocol, 2026-07-28, « Security Best Practices », https://modelcontextprotocol.io/specification/2026-07-28/basic/security_best_practices
- Extrait lu : « MCP servers **MUST NOT** accept any tokens that were not explicitly issued for the MCP server. » ; « Token passthrough is explicitly forbidden in the authorization specification »
- Portée / limites : vise les serveurs MCP qui appellent une API en aval ; le contrôle repose sur la vérification de l'audience (RFC 9068 cité).
- En pratique : dans le code du serveur, chercher l'en-tête `Authorization` reçu puis réémis tel quel vers l'API en aval, et l'absence de vérification de `aud`.

### Pour un serveur MCP mandataire OAuth, exiger le consentement par client avant la redirection vers le tiers (confused deputy)
- Niveau de preuve : N1
- Source : idem, https://modelcontextprotocol.io/specification/2026-07-28/basic/security_best_practices
- Extrait lu : « MCP proxy servers **MUST** implement per-client consent and proper security controls » ; « Use exact string matching (not pattern matching or wildcards) » (validation de `redirect_uri`)
- Portée / limites : ne concerne que les serveurs mandataires avec identifiant client statique et enregistrement dynamique. Autres exigences de la même section : cookies `__Host-`, `Secure`, `HttpOnly`, `SameSite=Lax`, paramètre `state` à usage unique, protection anti-iframe de la page de consentement.
- En pratique : tester une redirection vers une `redirect_uri` modifiée ; vérifier que la page de consentement nomme le client, les portées et l'URI de retour.

### Vérifier la protection SSRF des clients MCP déployés côté serveur lors de la découverte OAuth
- Niveau de preuve : N1
- Source : idem, section « Server-Side Request Forgery (SSRF) »
- Extrait lu : « MCP clients deployed to a server **MUST** consider SSRF risks and implement appropriate mitigations when fetching OAuth-related URLs. » ; « Avoid implementing IP validation manually. Attackers exploit encoding tricks (octal, hex, IPv4-mapped IPv6) that custom parsers often miss. »
- Portée / limites : blocage des plages privées et de `169.254.0.0/16` recommandé en SHOULD ; mandataire de sortie (Smokescreen cité) ; attention au TOCTOU DNS.
- En pratique : une application web qui se connecte à des serveurs MCP choisis par l'utilisateur est un client SSRF : chercher les `fetch` de `resource_metadata`, `authorization_servers`, `token_endpoint` sans liste de blocage.

### Ne jamais accepter qu'un identifiant d'état MCP serve d'authentification
- Niveau de preuve : N1
- Source : idem, section « State Handle Hijacking »
- Extrait lu : « MCP servers **MUST NOT** treat possession of a state handle as authentication. »
- Portée / limites : la spécification recommande (SHOULD) des identifiants aléatoires et liés côté serveur à l'utilisateur du jeton vérifié (`<user_id>:<handle>`). C'est l'IDOR classique transposé aux outils.
- En pratique : un outil qui reçoit `cart_id` ou `workflow_id` vérifie-t-il que l'identifiant appartient à l'appelant ?

### Exiger, pour un serveur MCP local, l'affichage de la commande exacte, un consentement explicite et un bac à sable ; et des portées minimales
- Niveau de preuve : N1
- Source : idem, sections « Local MCP Server Compromise » et « Scope Minimization »
- Extrait lu : « Show the exact command that will be executed, without truncation (include arguments and parameters) » ; « Use the `stdio` transport to limit access to just the MCP client » ; erreurs courantes : « Using wildcard or omnibus scopes (`*`, `all`, `full-access`) »
- Portée / limites : les exigences de consentement visent le client qui propose la configuration en un clic ; celles de transport visent le serveur local. La section « OAuth Authorization URL Validation » ajoute : refuser `javascript:`, `data:`, `file:` et ne jamais ouvrir une URL par un shell.
- En pratique : un serveur MCP local exposé en HTTP sur `localhost` sans jeton = constat (rebinding DNS). Un serveur qui demande `admin:*` d'emblée = constat.

### Considérer les descriptions d'outils MCP comme une entrée non fiable : empoisonnement, « rug pull » et « shadowing »
- Niveau de preuve : N4 (éditeur de sécurité, démonstrations)
- Source : Beurer-Kellner, Fischer (Invariant Labs), 1er avril 2025, « MCP Security Notification: Tool Poisoning Attacks », https://invariantlabs.ai/blog/mcp-security-notification-tool-poisoning-attacks
- Extrait lu : « A Tool Poisoning Attack occurs when malicious instructions are embedded within MCP tool descriptions » ; « a malicious server can change the tool description after the client has already approved it. » ; « Clients should pin the version of the MCP server and its tools to prevent unauthorized changes »
- Portée / limites : article d'éditeur qui vend aussi des outils d'analyse. Le principe est confirmé par la spécification (descriptions « untrusted »).
- En pratique : la version des serveurs MCP tiers est-elle épinglée ? Les descriptions d'outils sont-elles visibles par l'utilisateur ? Plusieurs serveurs de provenances différentes partagent-ils la même session ?

### Ne pas conclure qu'un agent est sûr parce que chaque serveur MCP l'est : la faille peut être dans la composition
- Niveau de preuve : N4
- Source : Milanta, Beurer-Kellner (Invariant Labs), 26 mai 2025, « GitHub MCP Exploited: Accessing private repositories via MCP », https://invariantlabs.ai/blog/mcp-github-vulnerability
- Extrait lu : « create a malicious issue on the public repository » ; « leaking it in an autonomously-created PR in the public repository » ; « this is not a flaw in the GitHub MCP server code itself. »
- Portée / limites : démonstration unique ; illustre exactement les trois propriétés (dépôt privé, ticket public, création de PR).
- En pratique : auditer les jetons donnés à l'agent (portée multi-dépôts ?) et la politique « un dépôt par session » plutôt que le code du serveur seul.

### Pour un projet qui utilise Claude Code ou des connecteurs, vérifier permissions, bac à sable et provenance des serveurs MCP ; Anthropic n'audite pas les serveurs MCP
- Niveau de preuve : N3
- Source : Anthropic, consultée le 9 novembre 2026, « Security » (Claude Code), https://code.claude.com/docs/en/security
- Extrait lu : « Anthropic reviews connectors against its listing criteria before adding them to the Anthropic Directory, but does not security-audit or manage any MCP server. » ; « reviewing `.mcp.json` doesn't show every server a session can load » ; « While these protections significantly reduce risk, no system is completely immune to all attacks. »
- Portée / limites : la page décrit les modes de permission (Auto, Manual), le bac à sable Bash (isolation fichiers et réseau), la règle selon laquelle `curl`/`wget` ne sont pas auto-approuvés, et qu'une session `-p` n'affiche ni le dialogue de confiance ni l'approbation `.mcp.json`. La page « Sandboxing » n'a pas été ouverte.
- En pratique : dans un dépôt audité, lire `.mcp.json`, `.claude/settings.json` (règles `allow`/`deny`) et les hooks ; signaler une règle d'autorisation large (`Bash(*)`) ou un serveur MCP non épinglé.

---

## 4. Données sensibles envoyées à un LLM

### Citer la rétention des données de l'API Anthropic d'après la page officielle datée : suppression sous 30 jours par défaut, avec exceptions
- Niveau de preuve : N3
- Source : Anthropic Privacy Center, page datée du 1er juillet 2026, « How long do you store my organization's data? », https://privacy.claude.com/en/articles/7996866-how-long-do-you-store-my-organization-s-data
- Extrait lu : « we automatically delete inputs and outputs on our backend within 30 days of receipt or generation. » ; « We retain inputs and outputs for up to 2 years and trust and safety classification scores for up to 7 years » (contenu signalé comme violant la politique d'usage)
- Portée / limites : exceptions : services contrôlés par le client (Files API), accord de rétention nulle, application de la politique d'usage, obligations légales, retours d'utilisateur (5 ans). Les conditions commerciales elles-mêmes n'ont pas été lues. La règle change : recontrôler la page à chaque audit.
- En pratique : l'application envoie-t-elle au modèle des données dont la politique de confidentialité de l'application promet la non-conservation ? Les fichiers téléversés via Files API sont-ils supprimés par l'application ?

### Citer la politique d'entraînement d'après la page officielle : pas d'entraînement par défaut sur les produits commerciaux, sauf retour explicite ou opt-in
- Niveau de preuve : N3
- Source : Anthropic Privacy Center, page datée du 18 août 2026, « Is my data used for model training? », https://privacy.claude.com/en/articles/7996868-is-my-data-used-for-model-training
- Extrait lu : « By default, we will not use your inputs or outputs from our commercial products » ; « If you explicitly report feedback or bugs to us »
- Portée / limites : vaut pour Anthropic et ses produits commerciaux (API comprise) ; ne dit rien des autres fournisseurs ni des intermédiaires (passerelles, outils d'observabilité). Les offres grand public ont une politique distincte, non étudiée ici.
- En pratique : si l'application passe par un tiers (passerelle multi-modèles, journalisation LLM hébergée), sa politique de rétention compte autant que celle du fournisseur du modèle.

---

## 5. Un LLM comme détecteur de vulnérabilités : ce que mesurent les études

### Ne pas transposer les scores de détection des bancs classiques : sur des données réalistes, la performance s'effondre
- Niveau de preuve : N2 (ICSE 2025 ; PrimeVul : 6 968 fonctions vulnérables et 228 800 bénignes en C/C++ ; sept code LMs plus GPT-3.5 et GPT-4)
- Source : Ding, Fu, Ibrahim, Sitawarin, Chen, Alomair, Wagner, Ray, Chen, 2025, « Vulnerability Detection with Code Language Models: How Far Are We? », 2025 IEEE/ACM 47th ICSE, DOI 10.1109/ICSE55347.2025.00038 (métadonnées via Crossref) ; texte lu : https://arxiv.org/pdf/2403.18624 (v2)
- Extrait lu : « a state-of-the-art 7B model scored 68.26% F1 on BigVul but only 3.09% F1 on PRIMEVUL. Attempts to improve performance through advanced training techniques and larger models like GPT-3.5 and GPT-4 were unsuccessful, with results akin to random guessing in the most stringent settings. » ; « up to 18.9% test samples are leaked from the train set in some benchmarks. »
- Portée / limites : détection au niveau de la fonction isolée, langage C/C++, modèles de 2023-2024. Ne mesure pas un agent qui lit le dépôt et exécute du code.
- En pratique : un LLM qui classe une fonction « vulnérable / non vulnérable » sans contexte n'est pas une preuve. Exiger le chemin de données complet et, si possible, une reproduction.

### Se méfier du raisonnement d'un LLM auditeur : réponses non déterministes, explications fausses, code corrigé encore signalé vulnérable
- Niveau de preuve : N2 (IEEE S&P 2024 ; 228 scénarios de code, 8 LLM, C et Python)
- Source : Ullah, Han, Pujar, Pearce, Coskun, Stringhini, 2024, « LLMs Cannot Reliably Identify and Reason About Security Vulnerabilities (Yet?): A Comprehensive Evaluation, Framework, and Benchmarks », 2024 IEEE Symposium on Security and Privacy, DOI 10.1109/SP54263.2024.00210 (métadonnées via Crossref) ; texte lu : https://arxiv.org/pdf/2312.12575 (v3)
- Extrait lu : « all models analyzed have a high false positive rate (FPR), and flag code where vulnerabilities have been patched as still vulnerable. » ; « by merely changing function or variable names, or by the addition of library functions in the source code, these models can yield incorrect answers in 26% and 17% of cases, respectively. » ; « even when they correctly identify a vulnerability, the reasoning that LLMs provide for this decision is often incorrect »
- Portée / limites : modèles consultés le 7 octobre 2023 (GPT-4, PaLM2, CodeLlama…) ; les modèles de 2026 n'y figurent pas. Le constat de méthode (faux positifs sur code corrigé, raisonnement infidèle) reste la seule mesure contrôlée disponible dans ce corpus.
- En pratique : avant de signaler, vérifier que la protection (échappement, requête paramétrée, contrôle d'accès) n'existe pas déjà plus haut dans le chemin. Relancer l'analyse d'un constat douteux : une réponse qui change d'une passe à l'autre n'est pas un constat.

### Prévoir un fort taux de faux positifs même quand le LLM trouve une vraie faille, et trier en conséquence
- Niveau de preuve : N4 (retour d'expérience d'un chercheur, 100 exécutions)
- Source : Heelan, 22 mai 2025, « How I used o3 to find CVE-2025-37899, a remote zeroday vulnerability in the Linux kernel's SMB implementation », https://sean.heelan.io/2025/05/22/how-i-used-o3-to-find-cve-2025-37899-a-remote-zeroday-vulnerability-in-the-linux-kernels-smb-implementation/
- Extrait lu : « o3 finds the kerberos authentication vulnerability in the benchmark in 8 of the 100 runs » ; « and the remaining 28 reports are false positives. » ; « o3 finds the kerberos authentication vulnerability in 1 out of 100 runs with this larger number of input tokens » ; « the signal to noise ratio of ~1:50 »
- Portée / limites : un modèle (o3), un module noyau en C, un chercheur expert pour trier. Montre à la fois la capacité réelle et le bruit ; le rappel baisse quand le contexte grandit (8/100 puis 1/100).
- En pratique : réduire le contexte à un chemin précis plutôt que « tout le dépôt » ; présenter les pistes non confirmées dans une section séparée, jamais au même rang que les constats vérifiés.

### Rappeler que les LLM inventent aussi des failles et des faits de CVE, et que le coût retombe sur le mainteneur
- Niveau de preuve : N4 (mainteneur de curl ; 415 rapports HackerOne, dont 64 failles confirmées), cadré par un N1 (OWASP LLM09)
- Source : Stenberg, 2 janvier 2024, « The I in LLM stands for intelligence », https://daniel.haxx.se/blog/2024/01/02/the-i-in-llm-stands-for-intelligence/ ; et, pour le cadre, OWASP, 2024-2025, « LLM09:2025 Misinformation » (N1), https://genai.owasp.org/llmrisk/llm092025-misinformation/
- Extrait lu : « reeks of typical AI style hallucinations: it mixes and matches facts and details from old security issues » ; « There was no buffer overflow. » ; « The better the crap, the longer time and the more energy we have to spend on the report until we close it. » ; OWASP LLM09 : « Overreliance occurs when users place excessive trust in LLM-generated content, failing to verify its accuracy. »
- Portée / limites : deux cas détaillés (affirmation fausse sur CVE-2023-38545, faux débordement WebSocket) ; la statistique de 66 % de rapports non pertinents porte sur tout l'historique, pas seulement sur les rapports générés par IA. L'application de LLM09 à l'agent auditeur lui-même est une déduction, pas une affirmation d'OWASP.
- En pratique : toute mention de CVE dans le rapport doit être vérifiée contre l'avis de sécurité ou la base consultée pendant l'audit (identifiant, versions touchées, versions corrigées), sinon marquée « Non vérifié ».

### Reconnaître que des agents outillés trouvent de vraies failles, mais que les résultats restent expérimentaux et coûteux à valider
- Niveau de preuve : N3 (billet officiel de Google Project Zero)
- Source : The Big Sleep team (Google Project Zero et Google DeepMind), 1er novembre 2024, « From Naptime to Big Sleep: Using Large Language Models To Catch Vulnerabilities In Real-World Code », https://projectzero.google/2024/10/from-naptime-to-big-sleep.html (l'URL googleprojectzero.blogspot.com a répondu 503)
- Extrait lu : « an exploitable stack buffer underflow in SQLite » ; « we found this issue before it appeared in an official release, so SQLite users were not impacted » ; « The position of the Big Sleep team is that at present, it's likely that a target-specific fuzzer would be at least as effective (at finding vulnerabilities). »
- Portée / limites : une faille de sécurité mémoire, en C, avec débogueur et exécution. Les découvertes ultérieures de Big Sleep (2025) n'ont pas été vérifiées.
- En pratique : un LLM auditeur n'est pas un substitut aux outils déterministes (SAST, fuzzing, tests). Il les complète.

### Citer les résultats officiels de l'AIxCC pour ce que peuvent faire des systèmes autonomes complets, pas un LLM seul
- Niveau de preuve : N3 (communiqué officiel de la DARPA)
- Source : DARPA, 8 août 2025, « AI Cyber Challenge marks pivotal inflection point for cyber defense », https://www.darpa.mil/news/2025/aixcc-results
- Extrait lu : « competitors' systems discovered 54 unique synthetic vulnerabilities in the Final Competition's 63 challenges » ; « Competitors' CRSs analyzed more than 54 million lines of code. » ; « an average cost per competition task of about $152. »
- Portée / limites : vainqueur Team Atlanta, puis Trail of Bits et Theori ; 43 failles synthétiques corrigées ; 18 failles réelles découvertes et 11 correctifs. Systèmes complets (fuzzing, analyse statique et LLM), sur du C et du Java open source. aicyberchallenge.com a refusé l'accès (403).
- En pratique : la preuve de capacité vient de systèmes qui vérifient automatiquement leurs trouvailles. Un audit par LLM sans exécution ne peut pas se prévaloir de ces résultats.

### Structurer l'audit en hypothèses multiples et indépendantes, chacune vérifiable
- Niveau de preuve : N3 (méthode publiée par Google Project Zero)
- Source : Glazunov, Brand (Google Project Zero), 20 juin 2024, « Project Naptime: Evaluating Offensive Security Capabilities of Large Language Models », https://projectzero.google/2024/06/project-naptime.html
- Extrait lu : « vulnerability discovery tasks can be structured so that potential solutions can be verified automatically with absolute certainty » ; « We advocate instead for a sampling strategy that allows models to explore multiple hypotheses through multiple independent trajectories, enabled by integrating verification within the end-to end system. »
- Portée / limites : principes de conception d'un outil de recherche de failles (raisonnement, environnement interactif, outils spécialisés, vérification parfaite, échantillonnage), présentés par ses auteurs, sans étude contrôlée.
- En pratique : formuler chaque hypothèse (« si un attaquant envoie X sur la route Y… ») avec son critère de vérification (test, requête, lecture du contrôle d'accès) ; abandonner celles qui ne se vérifient pas.

---

## 6. Garde-fous de sortie et de consommation

### Traiter la sortie du modèle comme une entrée utilisateur non fiable : ni `eval`, ni SQL concaténé, ni HTML non échappé, ni chemin de fichier brut (LLM05)
- Niveau de preuve : N1
- Source : OWASP, 2024-2025, « LLM05:2025 Improper Output Handling », https://genai.owasp.org/llmrisk/llm052025-improper-output-handling/
- Extrait lu : « LLM output is entered directly into a system shell or similar function such as exec or eval » ; « LLM-generated SQL queries are executed without proper parameterization, leading to SQL injection. » ; « Treat the model as any other user, adopting a zero-trust approach » ; « Employ strict Content Security Policies (CSP) to mitigate the risk of XSS attacks from LLM-generated content. »
- Portée / limites : OWASP cite aussi la traversée de chemin et l'encodage selon le contexte. Combiné à LLM01, toute sortie peut être pilotée par un tiers.
- En pratique : grep `dangerouslySetInnerHTML`, `innerHTML`, `eval`, `exec`, `child_process`, requêtes SQL construites par concaténation, `fs` avec un chemin issu de la réponse du modèle. Le rendu Markdown passe-t-il par un assainisseur ?

### Exiger des plafonds de consommation : taille d'entrée, quotas par utilisateur, délais, sinon déni de portefeuille (LLM10)
- Niveau de preuve : N1
- Source : OWASP, 2024-2025, « LLM10:2025 Unbounded Consumption », https://genai.owasp.org/llmrisk/llm102025-unbounded-consumption/
- Extrait lu : « allows users to conduct excessive and uncontrolled inferences » ; « Implement strict input validation to ensure that inputs do not exceed reasonable size limits. » ; « Apply rate limiting and user quotas to restrict the number of requests » ; « Set timeouts and throttle processing for resource-intensive operations »
- Portée / limites : la page décrit le « Denial of Wallet » (abus du modèle de coût à l'usage). Elle ne fixe aucune valeur de seuil.
- En pratique : la route qui appelle le modèle est-elle authentifiée et limitée en débit ? `max_tokens` est-il plafonné côté serveur, et non fourni par le client ? Une boucle d'agent a-t-elle un nombre maximal d'itérations ? Une alerte de budget existe-t-elle chez le fournisseur ?

---

## Verdict sur les règles du profil

| Règle | Verdict | Motif sourcé |
|---|---|---|
| « Jamais de CVE, CVSS, ou convention OWASP sans en être certain. Si doute sur une version de lib touchée par une CVE, signale-le. » | **Soutenue, à préciser** | Les LLM mélangent des faits de vieilles failles pour produire de fausses affirmations de CVE (Stenberg 2024, N4) ; OWASP LLM09 définit la sur-confiance (N1). « Certain » n'est pas opérationnel pour un LLM, dont le raisonnement est souvent infidèle même quand la réponse est juste (Ullah et al. 2024, N2). Reformuler : « Tout identifiant CVE, score CVSS ou identifiant OWASP est vérifié contre la source consultée pendant l'audit (avis, base, page OWASP 2025) et cité avec son URL ; sinon marqué *Non vérifié*. » Ajouter : les identifiants OWASP LLM 2023 et 2025 diffèrent (LLM07, LLM08, LLM10). |
| « Ne jamais affirmer qu'un code est vulnérable sans avoir lu le chemin exact qui le rend exploitable. » | **Soutenue, à renforcer** | Les LLM signalent comme vulnérable du code déjà corrigé et changent d'avis quand on renomme des variables (Ullah et al. 2024, N2). Sur données réalistes, la détection au niveau de la fonction est proche du hasard (Ding et al. 2025, N2). Lire le chemin est nécessaire mais pas suffisant : Heelan (N4) mesure environ 1 vrai positif pour 50 rapports. Les systèmes qui réussissent vérifient par exécution (Naptime, Big Sleep, AIxCC ; N3). Ajouter : « confirmer par un test, une requête ou une preuve de concept quand c'est possible ; sinon classer en *piste à confirmer* ». |
| « Tu travailles par hypothèses concrètes : « si un attaquant fait X, qu'est-ce qui se passe ? » » | **Soutenue (appui indirect), à préciser** | Project Zero recommande d'explorer plusieurs hypothèses par trajectoires indépendantes, chacune vérifiée (Naptime 2024, N3). Nasr et al. 2025 (N2) montrent qu'il faut raisonner avec un attaquant **adaptatif** qui connaît la défense (« the attacker moves second »). Aucune étude ne mesure directement le gain de cette consigne pour un LLM auditeur : l'appui est méthodologique. Préciser : chaque hypothèse porte son critère de vérification, et l'attaquant connaît les défenses. |
| (Absence) Rien sur les applications qui appellent un LLM, exposent des outils ou utilisent MCP | **Contredite par l'état de l'art : lacune à combler** | Référentiels N1 dédiés (OWASP LLM 2025, OWASP Agentic 2026, spécification MCP 2026-07-28 avec exigences MUST/MUST NOT) ; injection indirecte établie (Greshake et al. 2023, N2) et non résolue (OWASP LLM01 ; Nasr et al. 2025 ; Anthropic 2025, N3). Ajouts proposés, chacun adossé à une entrée ci-dessus : (1) cartographier provenance du texte et actions atteignables ; (2) grille A/B/C des trois propriétés ; (3) autorisation dans le code de l'outil, jamais dans le prompt (LLM06, LLM07) ; (4) sortie du modèle = entrée non fiable (LLM05), y compris le rendu Markdown ; (5) plafonds de coût (LLM10) ; (6) contrôles MCP : pas de token passthrough, identifiants d'état liés à l'utilisateur, SSRF, versions épinglées, descriptions d'outils non fiables ; (7) données envoyées au fournisseur et politique de rétention citée d'après la page officielle datée ; (8) ne jamais conclure « protégé contre l'injection » parce qu'un filtre existe. |

---

## Mythes et affirmations contestées

- **« Un bon prompt système empêche l'injection. »** Contredit : OWASP LLM01 (« unclear if there are fool-proof methods ») et LLM07 (le prompt n'est pas un contrôle de sécurité) ; Nasr et al. 2025 contournent les défenses par prompt et par filtrage.
- **« Un détecteur d'injection qui bloque 95 % des attaques suffit. »** Contredit : Willison 2025 (en sécurité des applications web, 95 % est « very much a failing grade », N4) ; Nasr et al. 2025 : plus de 90 % de réussite contre Protect AI, PromptGuard et Model Armor, 71 % contre PIGuard sous attaque adaptative. Tension avec la doc Anthropic qui recommande ce filtrage : il reste utile comme couche, pas comme barrière.
- **« Le modèle récent résiste aux injections. »** À nuancer avec les chiffres de l'éditeur lui-même : environ 1,4 à 2,4 % de réussite résiduelle avec protections, pour un attaquant défini par l'éditeur (Anthropic, 24.11.2025), qui écrit que le problème est « far from a solved problem ».
- **« La règle des deux (ou la trifecta) suffit à sécuriser un agent. »** Contredit par son auteur : Meta écrit qu'elle « should not be viewed as sufficient ».
- **« Le serveur MCP officiel est sûr, donc l'agent l'est. »** Contredit : la fuite GitHub MCP ne venait pas d'une faille du serveur (Invariant Labs, 26.05.2025).
- **« Anthropic vérifie la sécurité des serveurs MCP de l'annuaire. »** Faux d'après la doc Claude Code : revue selon des critères de listage, mais « does not security-audit or manage any MCP server ».
- **« Les LLM sont devenus de bons détecteurs de vulnérabilités. »** Contesté. Pour : Big Sleep (SQLite), Heelan (CVE-2025-37899), AIxCC (54 des 63 failles synthétiques). Contre : PrimeVul (F1 de 3,09 %), Ullah (faux positifs élevés), Heelan (~1:50), et Big Sleep lui-même (un fuzzer ciblé « at least as effective »). Les succès viennent de systèmes outillés qui vérifient par exécution, surtout sur du C, pas d'une lecture de code par un LLM seul.
- **« L'API Anthropic conserve les données 7 jours. »** Affirmation trouvée chez un tiers (blog), contredite par la page officielle datée du 1er juillet 2026 : 30 jours, avec exceptions. Citer uniquement la page officielle, datée.
- **Ordre des auteurs de Greshake et al. 2023.** Crossref et arXiv placent Greshake en premier ; DBLP et Researchr (selon les résultats de recherche, non ouverts) placent Abdelnabi en premier. Les deux premiers auteurs sont signalés à contribution égale dans le PDF (astérisque). Citer « Greshake, Abdelnabi et al. ».

---

## Non vérifié

- Page ACM DL de Greshake et al. (403) et notice DBLP (bloquée) : lieu, pages et DOI pris dans l'API Crossref seulement.
- Lieu de publication revu par les pairs de Nasr et al. 2025, de Beurer-Kellner et al. 2025, de CaMeL et d'AgentDojo : seules les versions arXiv ont été lues (résumés seuls pour CaMeL et AgentDojo ; le chiffre 77 %/84 % de CaMeL vient d'une paraphrase de l'outil de lecture, pas d'un verbatim).
- PDF complets de l'OWASP Top 10 LLM 2025, de l'OWASP Top 10 for Agentic Applications 2026 et de « Agentic AI – Threats and Mitigations » (v1.0 et v1.1) : seuls les pages web et intitulés ont été lus ; contenu détaillé des risques ASI01–ASI10 non lu ; le principe « least agency » n'a pas été trouvé.
- Site aicyberchallenge.com (403) : résultats AIxCC pris sur darpa.mil uniquement.
- Découvertes de Big Sleep postérieures à novembre 2024 : non vérifiées.
- Conditions commerciales d'Anthropic (Commercial Terms) et politique d'accord de rétention nulle : non lues. Politiques des autres fournisseurs (OpenAI, Google, Mistral…) : non étudiées.
- Page « Sandboxing » de Claude Code : non ouverte (seule la page « Security » l'a été).
- Taux de faux positifs ou de CVE inventées par les LLM récents (2025-2026) sur un grand échantillon : aucune étude ouverte ne le mesure ; les données chiffrées disponibles datent de modèles 2023-2024 (Ullah, Ding) ou d'un seul cas (Heelan).
- Référentiel NIST sur l'apprentissage automatique adverse (AI 100-2) : non consulté.
- Détail des cas d'exfiltration Markdown listés par Willison (EchoLeak, ForcedLeak, etc.) : seule la page de tag a été lue.

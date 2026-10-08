# Delta Log — DevOps

Journal des écarts entre la **procédure prescrite** et la **réalité d'exécution**, avec le
correctif et la source impactée.

> **Règle d'or (T9)** : « If you have to adapt the procedure to make the test pass, the
> procedure has failed. » Une friction documentée et résolue vaut mieux qu'un succès non vérifié.

**État du sprint** : peu de frictions d'exécution (travail essentiellement de *setup* DevOps,
pas encore de déploiement). Les vraies frictions de **reproductibilité / cold-start** émergeront
quand le code applicatif tournera. Les entrées ci-dessous sont les écarts réels rencontrés.

| # | Action prescrite | Réalité exécutée (friction) | Correctif + impact |
|---|------------------|------------------------------|--------------------|
| 1 | Alertes CI → Discord via un **secret d'organisation** | Le secret d'org **ne résolvait pas** dans les repos privés (test → webhook vide) — limite GitHub Free | Investigation empirique → **décision : passer les repos publics** → le secret d'org fonctionne. Débloque aussi rulesets + minutes illimitées. |
| 2 | Brancher la CI puis merger la PR | Un contributeur a corrigé le lint **directement sur `main` en parallèle** → conflit de merge | PR réinitialisée sur `main` (uniquement le fichier appelant CI). **Révèle un besoin de synchro** avant de toucher les mêmes repos → cf. Retro. |

**Zone d'incertitude du sprint** (pas une friction, mais du temps de R&D) : **choix de l'orchestration**
(serveurs / machines / Kubernetes). Décision en cours — voir la roadmap.

<!-- Nouvelles entrées : au fil de l'eau, surtout aux tests de cold-start. -->

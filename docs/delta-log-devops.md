# Delta Log — DevOps (contributions d'Elarif)

> Mes frictions DevOps rencontrées pendant le travail d'infra/CI, à **apporter au Delta Log
> consolidé de l'équipe** (livrable équipe). Chaque entrée = écart entre la procédure prescrite
> et la réalité d'exécution, + le correctif.
>
> Règle d'or : « If you have to adapt the procedure to make the test pass, the procedure has failed. »

| # | Date | Action prescrite | Réalité exécutée (friction) | Correctif + impact |
|---|------|------------------|------------------------------|--------------------|
| D1 | 2026-11 | Alerter sur échec CI via Discord (notify unifié) | Le workflow `notify` était en **`startup_failure` sur les 9 dépôts** — le pattern `workflow_run → reusable cross-repo` n'avait **jamais été testé end-to-end** (la validation avait utilisé `workflow_dispatch`). Alerting cassé silencieusement depuis le 22/09. | Diagnostic (échec systémique), `notify.yml` rendu **autonome** (logique inline, plus d'appel reusable cross-repo), testé end-to-end sur un dépôt, puis **roulé sur les 9 dépôts**. Alerting rétabli. |
| D2 | 2026-09 | Brancher la CI sur `pawrise-data` via une Pull Request | Un contributeur a corrigé le lint **directement sur `main` en parallèle** → **conflit de merge** sur la PR. | PR réinitialisée sur `main` (uniquement le fichier appelant CI). Révèle un **besoin de synchro** avant de toucher aux mêmes dépôts. |
| D3 | 2026-09 | Alertes Discord via un **secret d'organisation** (un seul secret pour tous les dépôts) | Le secret d'org **ne résolvait pas** dans les dépôts privés (test → webhook vide) — **limite GitHub Free**. | Investigation empirique → **décision : passer les dépôts publics** → le secret d'org fonctionne, et ça débloque aussi rulesets + minutes Actions illimitées. |

<!-- Nouvelles entrées : au fil de l'eau, surtout aux tests de reproductibilité / cold-start. -->

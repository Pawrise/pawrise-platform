# ADR-0002 — CI centralisée via reusable workflows

- **Statut** : Accepté
- **Date** : 2026-09-16
- **Décideur** : Elarif (DevOps / Fullstack)

## Contexte
L'organisation compte plusieurs dépôts et plusieurs stacks (Rust, Python, Node…).
Dupliquer les définitions de CI dans chaque dépôt conduit à la divergence des pipelines
et multiplie le coût de maintenance à chaque évolution.

## Décision
Les workflows de CI sont définis **une seule fois** dans le dépôt `.github`
(`on: workflow_call`) et consommés par chaque dépôt via un fichier appelant minimal
(`uses: Pawrise/.github/.github/workflows/<x>.yml@<ref>`).

Workflows fournis : `secret-scan` (gitleaks), `python-ci` (détection uv/poetry/pip),
`rust-ci`, `node-ci`, `self-ci` (actionlint).

## Conséquences
- **Source unique** : une correction ou une amélioration de pipeline se propage
  immédiatement à tous les dépôts consommateurs.
- **Cohérence** des contrôles (lint, tests, scan de secrets) sur l'ensemble de l'organisation.
- Les dépôts consommateurs restent triviaux (~10 lignes), sans logique CI dupliquée.
- **Couplage à gérer** : ce partage impose une stratégie de versionnement — référencer un
  tag `@vN` plutôt que `@main` dès que les workflows deviennent critiques, afin qu'un
  changement central ne casse pas simultanément tous les dépôts.

## Alternatives écartées
- Pipeline complet dupliqué par dépôt : divergence et dette de maintenance inévitables
  à mesure que le nombre de dépôts augmente.

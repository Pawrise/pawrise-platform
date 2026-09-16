# ADR-0002 — CI centralisée via reusable workflows dans `.github`

- **Statut** : Accepté
- **Date** : 2026-09-16
- **Décideur** : Elarif (DevOps / Fullstack)

## Contexte
7+ repos, plusieurs stacks (Rust, Python, Node…). Copier-coller la CI dans chaque
repo entraîne divergence et maintenance multipliée.

## Décision
Écrire les workflows **une seule fois** dans le repo `.github` (`on: workflow_call`),
et n'ajouter dans chaque repo qu'un fichier `.github/workflows/ci.yml` de ~10 lignes
qui les appelle (`uses: Pawrise/.github/.github/workflows/<x>.yml@main`).

Workflows fournis : `secret-scan` (gitleaks), `python-ci` (auto-détecte uv/poetry/pip),
`rust-ci`, `node-ci`, et `self-ci` (actionlint pour valider les workflows eux-mêmes).

## Conséquences
- (+) Une seule source de vérité : un correctif CI profite à tous les repos.
- (+) Gratuit même en organisation privée sur GitHub Free.
- (−) Un peu plus abstrait à débuguer ; nécessite d'autoriser l'accès inter-repos
  (résolu en rendant `.github` public — cf. [ADR-0003](0003-branch-protection.md)).
- Versioning par tag `@vN` recommandé quand les workflows deviennent critiques.

## Alternatives écartées
- CI complète dupliquée par repo : divergence garantie à moyen terme.

# ADR-0001 — Workflow de contribution basé sur les Pull Requests

- **Statut** : Accepté
- **Date** : 2026-09-16
- **Décideur** : Elarif (DevOps / Fullstack)
- **Référence opérationnelle** : `Pawrise/.github` → `CONTRIBUTING.md` (fait foi)

## Contexte
L'organisation regroupe plusieurs dépôts et contributeurs, sur des stacks variées.
Il faut un workflow de contribution homogène, lisible et traçable, applicable
uniformément à tous les dépôts.

## Décision
Tout développement est réalisé dans une branche dédiée nommée `<type>/<description>`
(`feature/`, `fix/`, `refactor/`, `chore/`, `docs/`, `ci/`), puis intégré dans `main`
via une **Pull Request relue**. Les messages de commit suivent Conventional Commits.
Les modifications directes sur `main` sont proscrites.

La convention complète (nommage des branches, commits, critères de revue et de fusion)
est maintenue dans `CONTRIBUTING.md` du dépôt `.github` et fait référence.

## Conséquences
- Historique lisible et traçable ; chaque changement passe par une revue de code.
- `main` reste continuellement intégrable, ce qui s'aligne sur la cible de déploiement
  continu (la séparation des environnements se fait par configuration et tags d'images,
  côté GitOps, et non par des branches de longue durée).
- Chaque dépôt peut ajouter des règles spécifiques (embarqué, Python, frontend, infra)
  qui complètent cette base commune.

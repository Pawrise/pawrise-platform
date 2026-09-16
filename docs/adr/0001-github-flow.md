# ADR-0001 — Modèle de branches : GitHub Flow (sans `develop`)

- **Statut** : Accepté
- **Date** : 2026-09-16
- **Décideur** : Elarif (DevOps / Fullstack)

## Contexte
Plusieurs repos, équipe étudiante, cible de déploiement continu via GitOps (Argo CD).
Il faut un modèle de branches simple et compatible avec le CD.

## Décision
**GitHub Flow** : une seule branche longue `main`, des branches courtes
(`feature/*`, `fix/*`, `chore/*`…) mergées via Pull Request. **Pas** de branche
`develop` ni de GitFlow.

## Conséquences
- (+) Simple, peu de cérémonie, adapté à une petite équipe.
- (+) Compatible GitOps : la séparation dev/staging/prod se fait par **config + tags
  d'images** (Argo CD), pas par branches.
- (−) Pas de branche d'intégration partagée avant release (non nécessaire avec du CD).

## Alternatives écartées
- **GitFlow (`develop` + `release/*` + `hotfix/*`)** : pertinent pour des releases
  planifiées/versionnées livrées à des clients restant sur d'anciennes versions.
  Incompatible avec le déploiement continu et trop lourd pour le contexte.

# Rétrospective — DevOps

Analyse critique honnête du sprint : process, rituels, organisation.

## Ce qui a bien marché
- **CI centralisée** (reusable workflows dans `.github`) : gros gain de maintenance, un correctif
  se propage à tous les repos.
- **Décision de passer les repos publics** : a débloqué **gratuitement** rulesets + org secrets +
  minutes Actions illimitées (au lieu de payer GitHub Team).
- La **partie technique DevOps** elle-même s'est faite **sans accroc majeur**.

## Ce qui a coincé
- **Sprint mal cadré / improvisé** : aucune planification, scope défini « à la volée ».
- **Cause racine = surcharge** : **2 autres projets en parallèle + une période en entreprise**
  → attention dispersée, peu de temps dédié.
- **Rituels faibles** : une « daily » par semaine + points hebdo informels → cadence irrégulière.
- **Coordination** : du travail en parallèle non synchronisé (cf. conflit de merge, Delta Log #2).

## Plan d'action correctif
| Action | Responsable | Deadline |
|--------|-------------|----------|
| Planifier + **estimer** les tâches DevOps du prochain sprint (ETC) → rendre vélocité/PDR mesurables | Elarif | prochain sprint |
| Formaliser une **cadence de rituels** minimale (une vraie daily ou un point fixe hebdo) | Équipe | prochain sprint |
| **Caler le scope sur la charge réelle** (tenir compte des projets parallèles) | Équipe | prochain sprint |
| Définir un **point de synchro** avant de toucher aux mêmes repos | Équipe | prochain sprint |
| Explorer la **réutilisation du socle Kubernetes** d'un autre projet de l'équipe pour Pawrise | Elarif | phase infra |

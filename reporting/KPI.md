# KPI Dashboard — DevOps

Métriques quantifiables du sprint. **Pas de reporting cosmétique** : ce qui n'a pas été mesuré
est marqué comme tel, avec l'action corrective pour le rendre mesurable au prochain sprint.

## PDR — Procedural Drift Rate
> PDR = (actions manuelles non prescrites / actions prescrites) × 100

**Non mesurable ce sprint** : aucune procédure n'a été formalisée en amont → pas de *baseline*
à laquelle comparer. Cela dit, l'essentiel du travail est passé par des **commandes `gh`
scriptées et des reusable workflows** (donc fortement automatisé/reproductible).
→ **Action** : formaliser une procédure écrite au prochain sprint pour pouvoir calculer le PDR.

## Vélocité & tenue du planning
**Non estimé** : le sprint n'a pas été planifié (scope défini à la volée).
Temps réel passé : **quelques heures** (ordre de grandeur).
→ **Action** : estimer les tâches DevOps au prochain sprint (ETC) pour mesurer l'écart estimé/réel.

| Tâche | Estimé | Réel | Écart |
|-------|--------|------|-------|
| Setup CI / gouvernance | non estimé | ~qq heures | — |

## DevOps & qualité
| Indicateur | Valeur | Note |
|---|---|---|
| **CI en place** | ✅ 9 repos | secret-scan partout, CI complète sur `pawrise-data` |
| **Taux de réussite CI** | ✅ vert (`pawrise-data`) | pas d'échec persistant |
| **Couverture de tests** | **0 %** | aucun test écrit à ce stade |
| **Durée du cold-start** | **non mesurée** | pas encore de déploiement → à mesurer dès la 1ère image qui tourne |

# ADR-0003 — Protection de branche & repo `.github` public

- **Statut** : Accepté
- **Date** : 2026-09-16
- **Décideur** : Elarif (DevOps / Fullstack)

## Contexte
On veut protéger `main` (PR obligatoire, 1 approbation, CI verte avant merge).
Mais **GitHub Free bloque** les rulesets / branch protection sur les repos **privés**
(erreur 403 : « Upgrade to GitHub Pro or make this repository public »).

## Décision
- Rendre le repo **`.github` public** : il ne contient que des conventions (README,
  templates, workflows), **aucun secret** → débloque la protection **gratuitement**.
- Ruleset `protect-main` sur `.github` : PR obligatoire + **1 approbation** + threads
  résolus + check **`actionlint` obligatoire** + interdiction force-push/suppression.
  **Bypass admin** en mode `pull_request` (self-merge possible, push direct toujours interdit).
- Les repos **applicatifs restent privés** (protection de l'IP > protection de branche
  tant qu'on est en Free) → **gate « mou »** (convention « pas de merge en rouge »)
  en attendant **GitHub Team / Education**.

## Conséquences
- (+) Boucle complète et gratuite « PR → CI → approbation → merge » sur `.github`.
- (−) Pas de protection technique sur les repos privés tant qu'on n'est pas en Team/Education.

## Alternatives écartées
- Rendre **tous** les repos publics : exposerait le code métier et l'IP (backend,
  prompts assistant, firmware, config infra).
- Payer **GitHub Team** juste pour ça : à évaluer plus tard — piste **GitHub Education**
  (org en Team gratuitement) à explorer d'abord.

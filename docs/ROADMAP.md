# Pawrise Platform — Roadmap DevOps

Plan d'implémentation **incrémental** de l'infrastructure et de l'outillage Pawrise.

> **Philosophie** : on construit la plateforme au rythme du produit. Chaque brique
> répond à un besoin concret — pas de techno ajoutée « pour faire bien ». On ne
> déploie pas Kubernetes / Grafana avant d'avoir des applications réelles à faire
> tourner et à observer.

**Légende** : ✅ fait · ⏳ en cours · ⬜ à faire

---

## Phase 0 — Gouvernance & conventions
- ✅ Organisation GitHub `Pawrise`
- ✅ Repo `.github` : README, CONTRIBUTING, PR template, Issue Forms (bug/feature), conventions branches & commits
- ✅ Protection de `main` sur `.github` (ruleset : PR + 1 approbation, threads résolus, pas de force-push/suppression ; bypass admin en mode `pull_request`)
- ✅ Rulesets sur **tous** les repos (PR + CI verte + review + pas de force-push/suppression ; bypass admin). Débloqué en **passant les repos publics**.

## Phase 1 — CI (GitHub Actions) — ✅ terminée
- ✅ Reusable workflows centralisés dans `.github` : `secret-scan` (gitleaks), `python-ci` (auto-détecte uv/poetry/pip), `rust-ci`, `node-ci`, `self-ci` (actionlint)
- ✅ CI branchée sur `pawrise-data` → pipeline vert
- ✅ `secret-scan` activé sur **tous** les repos
- ✅ Renommé `master` → `main` sur tous les repos
- ✅ « CI verte obligatoire » dans les rulesets (check `secret-scan / gitleaks` requis)
- ✅ Alertes **Discord** unifiées (échec + recovery) sur tous les repos

## Phase 2 — Docker & Registry — *amorcée*
- ✅ Composant `docker-ci` prêt (hadolint → buildx multi-arch arm64 → **Trivy** → push **GHCR**)
- ⬜ Dockerfile de l'**app** `pawrise-data` (a déjà celui de la BDD) — **en pause**
- ⬜ Brancher `docker-ci` → premières images sur GHCR

## Phase 3 — Hébergement (version légère d'abord)
> Avant Kubernetes : un seul VPS suffit longtemps pour une petite équipe.
- ⬜ 1 VPS **Hetzner** + `docker-compose` (images GHCR) + **Traefik** (reverse proxy + TLS Let's Encrypt) + **UptimeRobot** (monitoring uptime — cf AMDEC T01)
- ⬜ **OpenTofu / Terraform** pour provisionner (⚠️ provider à trancher : **Hetzner** (archi) vs **Scaleway** (AMDEC) — RGPD OK les deux)

## Phase 4 — Kubernetes & GitOps *(quand la complexité le justifie vraiment)*
- ⬜ Cluster **kubeadm** sur Hetzner, bootstrap via **Ansible**
- ⬜ **Helm** charts (backend, assistant, data, vet-portal)
- ⬜ **Argo CD** (GitOps). Environnements dev/staging/prod = **config + tags d'images**, jamais des branches git.

## Phase 5 — Secrets, réseau, TLS
- ⬜ **SOPS + age** (secrets chiffrés dans Git)
- ⬜ **cert-manager** (certificats TLS automatiques)
- ⬜ **step-ca** (PKI interne des colliers)

## Phase 6 — Observabilité
- ⬜ **OpenTelemetry** (instrumentation)
- ⬜ **Prometheus** (métriques) · **Loki** (logs) · **Tempo** (traces)
- ⬜ **Grafana** (dashboards)

## Phase 7 — Durcissement & sécurité
- ⬜ Revue sécurité, scans, politiques réseau, hardening des nodes

---

## Déclencheurs — *quand démarrer chaque brique*

| Brique | Prérequis avant de commencer |
|---|---|
| Docker | un service tourne en local et est stable |
| GHCR | le Docker build passe en CI (vert) |
| Hetzner / VPS | ≥ 1 image à faire tourner en continu / besoin d'un staging partagé |
| Kubernetes | plusieurs services à orchestrer + besoin scaling/self-healing + bande passante ops |
| Observabilité | quelque chose tourne réellement en environnement et doit être surveillé |

---

## Journal des décisions

- **Modèle de branches** : GitHub Flow (`main` + branches `feature/*` courtes). **Pas** de `develop` / GitFlow — incompatible avec le déploiement continu GitOps. La séparation d'environnements se fait par config + Argo, pas par branches.
- **CI centralisée** : reusable workflows dans `.github`, appelés par ~10 lignes dans chaque repo. Versioning par tag `@vN` quand les workflows deviennent critiques.
- **`python-ci` agnostique** : auto-détecte uv/poetry/pip → aucune contrainte de gestionnaire imposée aux équipes.
- **Tous les repos rendus publics** : la protection IP était théorique pour un projet école (pas de concurrent/plagiat réel) → passer public débloque **gratuitement** rulesets + org secrets + minutes Actions illimitées (au lieu de payer GitHub Team). secret-scan vérifié vert partout avant la bascule.
- **Déploiement** : *build once, promote the same image* — la même image immuable traverse dev → staging → prod. La prod n'est **jamais** déployée automatiquement depuis `main` : promotion délibérée (tag de release `vX.Y.Z` ou PR de bump), c'est le garde-fou.
- **Kubernetes** : cible de l'archi, mais pas prioritaire. Étape intermédiaire VPS + docker-compose d'abord.

---

## Architecture cible (référence)

Chaîne complète : `Développeur → GitHub → GitHub Actions (CI) → GHCR → Argo CD (GitOps) → Helm → Kubernetes (kubeadm) ← Ansible ← Terraform/OpenTofu → Hetzner`.
Autour : Traefik · cert-manager · SOPS+age · step-ca. Observabilité : OpenTelemetry → Prometheus/Loki/Tempo → Grafana.

---

## Mise à jour — rétro de sprint

- Sprint réalisé **sans planification formelle**, dans un contexte de **surcharge** (2 projets en parallèle + période en entreprise).
- 💡 **Piste d'accélération infra** : l'équipe a un autre projet sur **Kubernetes**. Si le socle y est solide, le **réutiliser pour Pawrise** (charts Helm, config cluster) plutôt que repartir de zéro.
- **Prochain chantier** : IaC (OpenTofu Hetzner) — en attente de la décision **compte Hetzner vs local k3d vs crédits Student Pack**.

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
- ⏳ Rulesets sur les repos applicatifs — **bloqués par GitHub Free + repos privés**. Piste : **GitHub Education** (org en Team gratuitement). Sinon gate mou (convention « pas de merge en rouge »).

## Phase 1 — CI (GitHub Actions) — *en cours*
- ⏳ Reusable workflows centralisés dans `.github` : `secret-scan` (gitleaks), `python-ci` (auto-détecte uv/poetry/pip), `rust-ci`, `node-ci` — *PR #1*
- ⬜ Brancher la CI sur `pawrise-data` → **premier pipeline vert**
- ⬜ `secret-scan` activé sur **tous** les repos (même vides)
- ⬜ Renommer `master` → `main` sur tous les repos (alignement conventions)
- ⬜ Ajouter « CI verte obligatoire » aux rulesets (dépend de Team/Education)

## Phase 2 — Docker & Registry
- ⬜ Dockerfiles par service (`pawrise-data` en a déjà un)
- ⬜ CI phase 2 : sur merge `main` → build image + scan **Trivy** + push **GHCR**

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
- **`.github` rendu public** pour débloquer la protection de branche gratuitement (contenu = conventions uniquement). Les repos applicatifs restent **privés** (protection IP > protection de branche tant qu'on est en Free).
- **Déploiement** : *build once, promote the same image* — la même image immuable traverse dev → staging → prod. La prod n'est **jamais** déployée automatiquement depuis `main` : promotion délibérée (tag de release `vX.Y.Z` ou PR de bump), c'est le garde-fou.
- **Kubernetes** : cible de l'archi, mais pas prioritaire. Étape intermédiaire VPS + docker-compose d'abord.

---

## Architecture cible (référence)

Chaîne complète : `Développeur → GitHub → GitHub Actions (CI) → GHCR → Argo CD (GitOps) → Helm → Kubernetes (kubeadm) ← Ansible ← Terraform/OpenTofu → Hetzner`.
Autour : Traefik · cert-manager · SOPS+age · step-ca. Observabilité : OpenTelemetry → Prometheus/Loki/Tempo → Grafana.

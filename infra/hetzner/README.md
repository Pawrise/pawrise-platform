# Infrastructure Hetzner — OpenTofu / Terraform (Phase 3)

Provisionne le cluster Kubernetes Pawrise sur Hetzner Cloud (ARM, EU/RGPD) :
**1 control plane (CAX21) + 2 workers (CAX31)**, réseau privé, firewall, clé SSH.

## Ce que ça crée
- `hcloud_ssh_key` — clé SSH sur tous les nœuds
- `hcloud_network` + `subnet` — réseau privé `10.0.0.0/16` entre les nœuds
- `hcloud_firewall` — SSH (22), API Kubernetes (6443), HTTP/HTTPS (80/443)
- `hcloud_server` — 1 control plane + N workers (défaut 2), labellisés

## Utilisation
```bash
cp terraform.tfvars.example terraform.tfvars   # puis remplir token + clé SSH
tofu init
tofu plan      # aperçu (ne crée rien, ne coûte rien)
tofu apply     # crée l'infra (~52€/mois pour 3 nœuds)
tofu destroy   # détruit tout (arrête les frais)
```

## Prochaine étape (Phase 4)
L'output `ansible_inventory` alimentera l'**inventaire Ansible** qui installera
Kubernetes (containerd → kubeadm init → join → CNI) sur ces nœuds.

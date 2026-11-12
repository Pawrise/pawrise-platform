variable "hcloud_token" {
  description = "Token API Hetzner Cloud (Read & Write)"
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Datacenter Hetzner (EU, souveraineté RGPD)"
  type        = string
  default     = "nbg1" # Nuremberg
}

variable "control_plane_type" {
  description = "Type de serveur pour le control plane (ARM, moins cher)"
  type        = string
  default     = "cax21" # 4 vCPU / 8 Go
}

variable "worker_type" {
  description = "Type de serveur pour les workers (ARM)"
  type        = string
  default     = "cax31" # 8 vCPU / 16 Go
}

variable "worker_count" {
  description = "Nombre de noeuds workers"
  type        = number
  default     = 2
}

variable "ssh_public_key" {
  description = "Cle SSH publique deployee sur les noeuds"
  type        = string
}

output "control_plane_ip" {
  description = "IP publique du control plane (point d'entree du cluster)"
  value       = hcloud_server.control_plane.ipv4_address
}

output "worker_ips" {
  description = "IPs publiques des workers"
  value       = hcloud_server.worker[*].ipv4_address
}

# Alimentera directement l'inventaire Ansible (Phase 4)
output "ansible_inventory" {
  description = "Noeuds du cluster, pour l'inventaire Ansible"
  value = {
    control_plane = hcloud_server.control_plane.ipv4_address
    workers       = hcloud_server.worker[*].ipv4_address
  }
}

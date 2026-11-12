provider "hcloud" {
  token = var.hcloud_token
}

# Cle SSH deployee sur tous les noeuds
resource "hcloud_ssh_key" "default" {
  name       = "pawrise-k8s"
  public_key = var.ssh_public_key
}

# Reseau prive entre les noeuds du cluster
resource "hcloud_network" "cluster" {
  name     = "pawrise-cluster"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "cluster" {
  network_id   = hcloud_network.cluster.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

# Firewall : SSH + API Kubernetes + HTTP/HTTPS
resource "hcloud_firewall" "cluster" {
  name = "pawrise-cluster-fw"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "6443" # kube-apiserver
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

# Control plane
resource "hcloud_server" "control_plane" {
  name         = "pawrise-cp-1"
  server_type  = var.control_plane_type
  image        = "ubuntu-24.04"
  location     = var.location
  ssh_keys     = [hcloud_ssh_key.default.id]
  firewall_ids = [hcloud_firewall.cluster.id]

  network {
    network_id = hcloud_network.cluster.id
    ip         = "10.0.1.10"
  }

  labels = {
    role    = "control-plane"
    cluster = "pawrise"
  }

  depends_on = [hcloud_network_subnet.cluster]
}

# Workers
resource "hcloud_server" "worker" {
  count        = var.worker_count
  name         = "pawrise-worker-${count.index + 1}"
  server_type  = var.worker_type
  image        = "ubuntu-24.04"
  location     = var.location
  ssh_keys     = [hcloud_ssh_key.default.id]
  firewall_ids = [hcloud_firewall.cluster.id]

  network {
    network_id = hcloud_network.cluster.id
    ip         = "10.0.1.${count.index + 20}"
  }

  labels = {
    role    = "worker"
    cluster = "pawrise"
  }

  depends_on = [hcloud_network_subnet.cluster]
}

data "digitalocean_ssh_key" "ssh_key" {
  name = var.ssh_key_name
}

data "digitalocean_image" "code_server_image" {
  name = "code-server-${var.code_server_version}"
}

resource "digitalocean_droplet" "code_server" {
  name     = "code-server-${var.code_server_version}"
  image    = data.digitalocean_image.code_server_image.id
  region   = var.do_region
  size     = var.do_size
  ssh_keys = [data.digitalocean_ssh_key.ssh_key.fingerprint]
}

locals {
  code_server_domain = "code-${digitalocean_droplet.code_server.ipv4_address}.nip.io"
}

resource "local_file" "inventory_file" {
  filename        = "${path.module}/inventory.yaml"
  file_permission = "0644"

  content = templatefile("${path.module}/inventory.yaml.tftpl", {
    code_server_ip       = digitalocean_droplet.code_server.ipv4_address
    code_server_password = var.code_server_password
    code_server_domain   = local.code_server_domain
    ssh_user             = var.ssh_user
    ssh_private_key_file = var.ssh_private_key_file
  })
}
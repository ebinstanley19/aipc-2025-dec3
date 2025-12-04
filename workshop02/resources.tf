data "digitalocean_ssh_key" "my_key" {
  name = "Dev SSH Key"
}

resource "digitalocean_droplet" "code_server" {
  name     = "code-server"
  image    = var.DO_IMAGE
  region   = var.DO_REGION
  size     = var.DO_SIZE
  ssh_keys = [data.digitalocean_ssh_key.my_key.fingerprint]
}

resource "local_file" "inventory_file" {
  filename        = "inventory.yaml"
  file_permission = "0444"
  content = templatefile("${path.module}/inventory.yaml.tftpl", {
    code_server_ip       = digitalocean_droplet.code_server.ipv4_address
    code_server_password = var.code_server_password
  })
}

resource "local_file" "code_server_site" {
  filename        = "code-server.conf"
  file_permission = "0644"
  content = templatefile("${path.module}/code-server.conf.tftpl", {
    droplet_ip = digitalocean_droplet.code_server.ipv4_address
  })
}

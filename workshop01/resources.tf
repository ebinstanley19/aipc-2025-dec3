resource "docker_network" "bgg_net" {
  name = "bgg-net"
}

resource "docker_volume" "data_vol" {
  name = "data-vol"
}

resource "docker_container" "bgg_database" {
  name  = "bgg-database"
  image = docker_image.database_image.image_id
  mounts {
    target = "/var/lib/mysql"
    type   = "volume"
    source = docker_volume.data_vol.name
  }
  ports {
    internal = 3306
  }
  networks_advanced {
    name = docker_network.bgg_net.name
  }
}

resource "docker_container" "bgg_backend" {
  count = 3
  name  = "bgg-backend-${count.index + 1}"
  image = docker_image.application_image.image_id
  env = [
    "BGG_DB_USER=root",
    "BGG_DB_PASSWORD=${var.db_password}",
    "BGG_DB_HOST=${docker_container.bgg_database.name}"
  ]
  networks_advanced {
    name = docker_network.bgg_net.name
  }
  ports {
    internal = 5000
    external = 8080 + count.index
  }
}

resource "local_file" "nginx_conf" {
  filename        = "nginx.conf"
  file_permission = "0444"
  content = templatefile("${path.module}/nginx.conf.tftpl", {
    bggapp_names = docker_container.bgg_backend[*].name
    bggapp_ports = 5000
  })
}

resource "docker_container" "bgg_nginx_reverse_proxy" {
  name  = "bgg-nginx-reverse-proxy"
  image = docker_image.nginx_image.image_id
  ports {
    internal = 80
    external = 8443
  }
  mounts {
    target = "/etc/nginx/nginx.conf"
    type   = "bind"
    source = abspath(local_file.nginx_conf.filename)
  }
  networks_advanced {
    name = docker_network.bgg_net.name
  }
}

data "digitalocean_ssh_key" "my_key" {
  name = "Dev SSH Key"
}

resource "digitalocean_droplet" "ebindroplet" {
  name     = "ebin-droplet"
  image    = var.DO_IMAGE
  region   = var.DO_REGION
  size     = var.DO_SIZE
  ssh_keys = [data.digitalocean_ssh_key.my_key.fingerprint]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.SSH_PRIVATE_KEY_PATH)
    host        = self.ipv4_address
  }

  provisioner "file" {
    source      = "${path.module}/assets/"
    destination = "/tmp"
  }


  provisioner "remote-exec" {
    inline = [
      "apt update -y",
      "apt install nginx -y",
      "systemctl daemon-reload",
      "mkdir -p /var/www/html",
      "rm -rf /var/www/html/*",
      "sed -i \"s/Droplet IP address here/${self.ipv4_address}/g\" /tmp/index.html",
      "cp -r /tmp/index.html /tmp/hello.gif /var/www/html/",
      "systemctl enable nginx",
      "systemctl start nginx",
    ]
  }
}

output "ebin_ssh_key" {
  description = "Ebin's SSH Key Fingerprint"
  value       = data.digitalocean_ssh_key.my_key.fingerprint
}

output "ebin_droplet_ip" {
  description = "Ebin's Droplet IP Address"
  value       = digitalocean_droplet.ebindroplet.ipv4_address
}

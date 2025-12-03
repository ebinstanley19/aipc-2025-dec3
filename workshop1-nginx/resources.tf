data "digitalocean_ssh_key" "my_key" {
  name = "ssh_key"
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

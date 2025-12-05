source "digitalocean" "code_server" {
  api_token   = var.do_token
  image       = var.image_name
  region      = var.region
  size        = var.image_size
  ssh_username = var.ssh_username
  snapshot_name = "code-server-${var.code_server_version}"
}

build {
  name    = "code-server-golden-image"
  sources = [
    "source.digitalocean.code_server"
  ]

  provisioner "ansible" {
    playbook_file = "code-server-golden.yaml"
    
    extra_arguments = [
      "--extra-vars",
      "code_server_version=${var.code_server_version} code_server_arch=${var.code_server_arch}"
    ]
  }
}
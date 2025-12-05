output "code_server_domain" {
  description = "Domain name of the provisioned server (code-<ipv4>.nip.io)"
  value       = "code-${digitalocean_droplet.code_server.ipv4_address}.nip.io"
}

output "code_server_ip" {
  description = "IPv4 address of the provisioned code-server droplet"
  value       = digitalocean_droplet.code_server.ipv4_address
}

output "inventory_file" {
  description = "Path to the generated Ansible inventory file"
  value       = local_file.inventory_file.filename
}
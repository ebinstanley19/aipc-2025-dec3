variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "ssh_key_name" {
  description = "Name of existing SSH key in DigitalOcean"
  type        = string
}

variable "code_server_version" {
  description = "Version of code-server"
  type        = string
}

variable "code_server_password" {
  description = "Password for code-server"
  type        = string
  sensitive   = true
}

variable "ssh_user" {
  description = "SSH username to connect to droplet"
  type        = string
  default     = "root"
}

variable "ssh_private_key_file" {
  description = "Path to private key file for SSH"
  type        = string
}

variable "do_region" {
  description = "DigitalOcean region"
  type        = string
  default     = "sgp1"
}

variable "do_size" {
  description = "Droplet size"
  type        = string
  default     = "s-2vcpu-4gb"
}
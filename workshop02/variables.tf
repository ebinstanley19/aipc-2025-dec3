variable "DO_TOKEN" {
  type      = string
  sensitive = true
}
variable "DO_REGION" {
  type    = string
  default = "sgp1"
}

variable "DO_SIZE" {
  type    = string
  default = "s-2vcpu-4gb"
}

variable "DO_IMAGE" {
  type    = string
  default = "ubuntu-24-04-x64"
}

variable "SSH_PRIVATE_KEY_PATH" {
  description = "Path to your local private SSH key"
  type        = string
}

variable "code_server_password" {
  description = "Password for the code server"
  type        = string
}
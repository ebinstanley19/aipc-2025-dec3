variable "do_token" {
  type      = string
  sensitive = true
}

variable "region" {
  type    = string
  default = "sgp1"
}

variable "image_name" {
  type    = string
  default = "ubuntu-24-04-x64"
}

variable "image_size" {
  type    = string
  default = "s-2vcpu-4gb"
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "code_server_version" {
  type    = string
  default = "4.106.3"
}

variable "code_server_arch" {
  type    = string
  default = "linux-amd64"
}
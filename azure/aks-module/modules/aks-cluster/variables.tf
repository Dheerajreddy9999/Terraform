variable "aks_cluster_name" {
  type = string
}

variable "sku_tier" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "node_resource_group" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "node_count" {
  type = string
}

variable "vm_Size" {
  type = string
}

variable "os_disk_size_gb" {
  type = string
}

variable "max_count" {
  type = number
}

variable "min_count" {
  type = number
}

variable "enable_node_public_ip" {
  type = bool
}

variable "vnet_subnet_id" {
  type = string
}
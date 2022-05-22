variable "name" {
  description = "Name of the azure file sync instance"
  default     = "filesync"
}

variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = true
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = "rg-filesync"
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = "eastus2"
}

variable "resource_prefix" {
  description = "(Optional) Prefix to use for all resoruces created (Defaults to resource_group_name)"
  default     = ""
}

variable "virtual_network_name" {
    description = "(Optional) Indicates the name of vnet to limit access to (Reqired if limited access)"
    default     = ""
}

variable "virtual_network_resource_group_name" {
    description = "(Optional) Indicates the name of resource group that contains the vnet to limit access to (Reqired if limited access)"
    default     = ""
}

variable "subnet_name" {
    description = "(Optional) Indicates the name of subnet to limit access to (Reqired if limited access)"
    default     = ""
}

variable "storage_account_tier" {
    description = "(Optional) Indicates the storage tier to allocate"
    default     = "Standard"
}

variable "storage_account_replication_type" {
    description = "(Optional) Indicates the replication type to use for the storage account"
    default     = "LRS"
}

variable "storage_account_limit_access_to_subnets" {
    description = "(Optional) Indicates if access should be limited to specific subnets"
    default     = false
}

variable "storage_share_name" {
    description = "(Option) The name of the file share to create on the end point"
    default     = "files"
}

variable "storage_share_quota" {
    description = "(Optional) The quote to set on the file share"
    default     = 1024
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

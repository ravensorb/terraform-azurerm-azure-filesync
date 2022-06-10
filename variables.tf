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

variable "create_storage_account" {
  description = "(Optional) Indicate if the storage account should be created"
  default     = true
}

variable "storage_account_name" {
  description = "(Optional) Set of override the storage account name (blank using standard naming pattern)"
  default     = null
}

variable "storage_account_resource_group_name" {
  description = "(Optional) Resource Group that contains the Storage account to add shares to"
  default     = null
}

variable "storage_account_tier" {
    description = "(Optional) Indicates the storage tier to allocate"
    default     = "Standard"
}

# variable "storage_acccount_access_tier" {
#   description = "(Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot"
#   default     = "Hot"

#     validation {
#       condition     = contains(["Hot" ], var.storage_acccount_access_tier)
#       error_message = "The value must be set to a value of either Hot (cool is not supported)."
#     }
# }

variable "storage_account_replication_type" {
    description = "(Optional) Indicates the replication type to use for the storage account"
    default     = "LRS"

    validation {
      condition = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS" ], var.storage_account_replication_type)
      error_message = "The value must be set to a value of either LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
    }
}

variable "storage_account_limit_access_to_subnets" {
    description = "(Optional) Indicates if access should be limited to specific subnets"
    default     = false
}

variable "storage_account_authentication_type" {
  description = "(Optional) Indicates the type of authentication to enable (blank, AD, AADDS)"
  default     = ""
  validation {
    condition = contains([ "", "AD", "AADDS" ], var.storage_account_authentication_type )
    error_message = "The value must be set to a value of AD or AADDS."
  }
}

variable "storage_account_authentication_storage_sid" {
  description = "(Required for AD) Specifies the security identifier (SID) for Azure Storage."
  default     = null
}

variable "storage_account_authentication_domain_sid" {
  description = "(Required for AD) Specifies the security identifier (SID)."
  default     = null
}

variable "storage_account_authentication_domain_guid" {
  description = "(Required for AD) Specifies the domain GUID."
  default     = null
}

variable "storage_account_authentication_forest_name" {
  description = "(Required for AD) Specifies the Active Directory forest."
  default     = null
}

variable "storage_account_authentication_netbios_domain_name" {
  description = "(Required for AD) Specifies the NetBIOS domain name."
  default     = null
}

variable "storage_account_authentication_domain_name" {
  description = "(Optional) Indicates the name of the domain to use for authentication"
  default     = ""
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

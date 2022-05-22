# Azure File Sync Terraform module

Azure File Sync enables centralizing your organization's file shares in Azure Files, while keeping the flexibility, performance, and compatibility of a Windows file server. While some users may opt to keep a full copy of their data locally, Azure File Sync additionally has the ability to transform Windows Server into a quick cache of your Azure file share. You can use any protocol that's available on Windows Server to access your data locally, including SMB, NFS, and FTPS. You can have as many caches as you need across the world.

## Module Usage

```hcl
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "azure-filesync" {
  source  = "ravensorb/azure-filesync/azurerm"
  version = "1.0.0"

  # The name to use for this instance
  name                = "filesync"

  # A prefix to use for all resouyrces created (if left blank, the resource group name will be used)
  resource_prefix     = "shared-eastus2"

  # By default, this module will create a resource group, proivde the name here
  # to use an existing resource group, specify the existing resource group name, 
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG. 
  resource_group_name = "shared-eastus2-rg-filesync"
  
  # Location to deploy into
  location            = "eastus2"

  # Set to true to limit access to specific subnets.  
  # Note: requires settings virtual_network_name, virtual_network_resource_group_name, and subnet_net
  storage_account_limit_access_to_subnets = false
  # VNet and Subnet details
  # The vnet to use to deploy this into
  #virtual_network_name                = ""
  # The resource group name for vnet to use to deploy this into
  #virtual_network_resource_group_name = "" # Set to null to use the sameresource group 
  # The number of the subnet to use only needed if limited access to specific subnets
  #subnet_name                         = ""

  # Storage Account Settings
  storage_account_tier                    = "Standard"
  storage_account_replication_type        = "LRS"
  #storage_share_name                      = "filesync"
  storage_share_quota                     = "100GB"

  # Adding TAG's to your Azure resources (Required)
  tags = {
    CreatedBy   = "Shawn Anderson"
    CreatedOn   = "2022/05/20"
    CostCenter  = "IT"
    Environment = "PROD"
    Critical    = "YES"
    Location    = "eastus2"
    Solution    = "filesync"
    ServiceClass = "Gold"
  }
}

```

## Pre-requisites 
Note: these are only required if you are planning to limit network access to specific subnets

### Virtual network / Resource Group Name

You can create a new virtual network in the portal during this process, or use an existing virtual network to limit access to the service. If you are using an existing virtual network, make sure the existing virtual network has a subnet created as well

### Subnet

The subnet will be used to limit access to Azure File Sync.  This is useful in a traditional hub and spoke model deployment


## Requirements

Name | Version
-----|--------
terraform | >= 0.13
azurerm | >= 2.59.0

## Providers

| Name | Version |
|------|---------|
azurerm |>= 2.59.0

## Inputs

Name | Description | Type | Default
---- | ----------- | ---- | -------
`name`|Name of the azure file sync instance|`string`|`filesync`
`create_resource_group`|Whether to create resource group and use it for all networking resources|`boolean`|`true`
`resource_group_name`|A container that holds related resources for an Azure solution|`string`|`rg-filesync`
`location`|The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'|`string`|`eastus2`
`resource_prefix`|(Optional) Prefix to use for all resoruces created (Defaults to resource_group_name)|`string`|``
`virtual_network_name`|(Optional) Indicates the name of vnet to limit access to (Reqired if limited access)|`string`|``
`virtual_network_resource_group_name`|(Optional) Indicates the name of resource group that contains the vnet to limit access to (Reqired if limited access)|`string`|``
`subnet_name`|(Optional) Indicates the name of subnet to limit access to (Reqired if limited access)|`string`|``
`storage_account_tier`|(Optional) Indicates the storage tier to allocate|`string`|`Standard`
`storage_account_replication_type`|(Optional) Indicates the replication type to use for the storage account|`string`|`LRS`
`storage_account_limit_access_to_subnets`|(Optional) Indicates if access should be limited to specific subnets|`boolean`|`false`
`storage_share_name`|(Option) The name of the file share to create on the end point|`string`|`files`
`storage_share_quota`|(Optional) The quote to set on the file share|`int`|1024
`tags`|A map of tags to add to all resources|map(string)|`{}`

## Outputs

Name | Description
---- | -----------
`resource_group_name`|The name of the resource group in which resources are created
`resource_group_id`|The id of the resource group in which resources are created
`resource_group_location`|The location of the resource group in which resources are created
`virtual_network_name`|The name of the virtual network
`virtual_network_id`|The id of the virtual network
`storage_account_id`|The id of the storage account that was used/created
`storage_account_name`|The name of the storage account that was used/created
`storage_sync_id`|The id of the storage sync that was created
`storage_sync_name`|The name of the storage sync that was created
`storage_sync_group_id`|The id of the storage sync group that was created
`storage_sync_group_name`|The name of the storage sync group that was created
`storage_sync_cloud_endpoint_id`|The id of the storage sync cloud endpoint that was created
`storage_sync_cloud_endpoint_name`|The name of the storage sync cloud endpoint that was created
`storage_sync_cloud_endpoint_file_share_name`|The name of the storage sync cloud endpoint file share that was created

## Authors

Originally created by [Shawn Anderson](mailto:sanderson@eye-catcher.com)

## Other resources

* [Azure File Sync](https://docs.microsoft.com/en-us/azure/storage/file-sync/file-sync-introduction)
* [Terraform AzureRM Provider Documentation](https://www.terraform.io/docs/providers/azurerm/index.html)




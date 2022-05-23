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

## Create resource group

By default, this module will create a resource group and the name of the resource group to be given in an argument `resource_group_name`. If you want to use an existing resource group, specify the existing resource group name, and set the argument to `create_resource_group = false`.

> *If you are using an existing resource group, then this module uses the same resource group location to create all resources in this module.*

### Virtual network 

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
`storage_account_enable_aadds_authentication`|(Optional) Indicates if AADDS authentication should be enabled on the storage acconnt|`boolean`|`false`
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

## Recommended naming and tagging conventions

Well-defined naming and metadata tagging conventions help to quickly locate and manage resources. These conventions also help associate cloud usage costs with business teams via chargeback and show back accounting mechanisms.

> ### Resource naming

An effective naming convention assembles resource names by using important resource information as parts of a resource's name. For example, using these [recommended naming conventions](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging#example-names), a public IP resource for a production SharePoint workload is named like this: `pip-sharepoint-prod-westus-001`.

> ### Metadata tags

When applying metadata tags to the cloud resources, you can include information about those assets that couldn't be included in the resource name. You can use that information to perform more sophisticated filtering and reporting on resources. This information can be used by IT or business teams to find resources or generate reports about resource usage and billing.

The following list provides the recommended common tags that capture important context and information about resources. Use this list as a starting point to establish your tagging conventions.

Tag Name|Description|Key|Example Value|Required?
--------|-----------|---|-------------|---------|
Created By|Name Person responsible for approving costs related to this resource.|CreatedBy|{email}|Yes
Created On|Date when this application, workload, or service was first deployed.|CreatedOn|{date}|No
Cost Center|Accounting cost center associated with this resource.|CostCenter|{number}|Yes
Environment|Deployment environment of this application, workload, or service.|Environment|Prod, Dev, QA, Stage, Test|Yes
Critical|Indicates if this is a critical resource|Critical|Yes|Yes
Location|Indicates the location of this resource|Location|eastus2|No
Solution|Indicates the solution related to this resource|Solution|hub|No
Service Class|Service Level Agreement level of this application, workload, or service.|ServiceClass|Dev, Bronze, Silver, Gold|Yes

other tag recommendations could include

Tag Name|Description|Key|Example Value|Required?
--------|-----------|---|-------------|---------|
Project Name|Name of the Project for the infra is created. This is mandatory to create a resource names.|ProjectName|{Project name}|Yes
Application Name|Name of the application, service, or workload the resource is associated with.|ApplicationName|{app name}|Yes
Business Unit|Top-level division of your company that owns the subscription or workload the resource belongs to. In smaller organizations, this may represent a single corporate or shared top-level organizational element.|BusinessUnit|FINANCE, MARKETING,{Product Name},CORP,SHARED|Yes
Disaster Recovery|Business criticality of this application, workload, or service.|DR|Mission Critical, Critical, Essential|Yes
Owner Name|Owner of the application, workload, or service.|Owner|{email}|Yes
Requester Name|User that requested the creation of this application.|Requestor| {email}|Yes
End Date of the Project|Date when this application, workload, or service is planned to be retired.|EndDate|{date}|No

> This module allows you to manage the above metadata tags directly or as a variable using `variables.tf`. All Azure resources which support tagging can be tagged by specifying key-values in argument `tags`. Tag `ResourceName` is added automatically to all resources.

## Authors

Originally created by [Shawn Anderson](mailto:sanderson@eye-catcher.com)

## Other resources

* [Azure File Sync](https://docs.microsoft.com/en-us/azure/storage/file-sync/file-sync-introduction)
* [Terraform AzureRM Provider Documentation](https://www.terraform.io/docs/providers/azurerm/index.html)




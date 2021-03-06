#---------------------------------
# Local declarations
#---------------------------------
locals { 
  name                = var.name == "" ? "-filesync" : "-${var.name}"
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  resource_prefix     = var.resource_prefix == "" ? local.resource_group_name : var.resource_prefix
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)

  timeout_create  = "15m"
  timeout_update  = "15m"
  timeout_delete  = "15m"
  timeout_read    = "15m"
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "true"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = merge({ "ResourceName" = "${var.resource_group_name}" }, var.tags, )
}

#-------------------------------------
# Networking
#-------------------------------------

data "azurerm_virtual_network" "vnet" {
  count                 = var.storage_account_limit_access_to_subnets ? 1 : 0
  name                  = var.virtual_network_name
  resource_group_name   = var.virtual_network_resource_group_name == null ? var.resource_group_name : var.virtual_network_resource_group_name
}

## External Data References
data "azurerm_subnet" "snet" {
  count                 = var.storage_account_limit_access_to_subnets ? 1 : 0
  name                  = var.subnet_name
  resource_group_name   = element(data.azurerm_virtual_network.vnet.*.resource_group_name, 0)
  virtual_network_name  = element(data.azurerm_virtual_network.vnet.*.name, 0)
}

#-------------------------------------
## Storage Sync
#-------------------------------------
resource "azurerm_storage_sync" "filesync" {
  name                = "${local.resource_prefix}-sts${local.name}"
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = merge({ "ResourceName" = "${local.resource_prefix}-sts${local.name}" }, var.tags, )

  timeouts {
    create  = local.timeout_create
    delete  = local.timeout_delete
    read    = local.timeout_read
    update  = local.timeout_update
  }
}

## Storage Sync Groups
resource "azurerm_storage_sync_group" "filesync" {
  name            = "${local.resource_prefix}-stsg${local.name}"
  storage_sync_id = azurerm_storage_sync.filesync.id 
  
  depends_on = [
    azurerm_storage_sync.filesync
  ]

  timeouts {
    create  = local.timeout_create
    delete  = local.timeout_delete
    read    = local.timeout_read
  }
}

## Storage Accounts
data "azurerm_storage_account" "filesync" {
  count               = var.create_storage_account == false && var.storage_account_name != null ? 1 : 0
  name                = var.storage_account_name
  resource_group_name = var.storage_account_resource_group_name != null ? var.storage_account_resource_group_name : local.resource_group_name
}

resource "azurerm_storage_account" "filesync" {
  count                     = var.create_storage_account || var.storage_account_name == null ? 1 : 0

  name                      = var.storage_account_name != null ? var.storage_account_name : format("%sst%s", lower(replace(local.resource_prefix, "/[[:^alnum:]]/", "")), lower(replace(local.name, "/[[:^alnum:]]/", "")))
  resource_group_name      = local.resource_group_name
  location                 = local.location
  tags                     = merge({ "ResourceName" = format("%sst%s", lower(replace(local.resource_prefix, "/[[:^alnum:]]/", "")), lower(replace(local.name, "/[[:^alnum:]]/", ""))) }, var.tags, )
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  #access_tier              = var.storage_acccount_access_tier  
  
  dynamic "azure_files_authentication" {
    for_each = var.storage_account_authentication_type != "" ? [] : [1]
    content {
      directory_type = var.storage_account_authentication_type
      # dynamic "active_directory" {
      #   for_each = var.storage_account_authentication_type == "AADS" : [1] : []

      #   content {
      #     domain_name = var.storage_account_authentication_domain_name
      #   }
      # }

      dynamic "active_directory" {
        for_each = var.storage_account_authentication_type == "AD" ? [1] : []

        content {
          domain_name         = var.storage_account_authentication_domain_name
          storage_sid         = var.storage_account_authentication_storage_sid
          domain_sid          = var.storage_account_authentication_domain_sid
          domain_guid         = var.storage_account_authentication_domain_guid
          forest_name         = var.storage_account_authentication_forest_name
          netbios_domain_name = var.storage_account_authentication_netbios_domain_name
        }
      }
    }
  }

  timeouts {
    create  = local.timeout_create
    delete  = local.timeout_delete
    read    = local.timeout_read
    update  = local.timeout_update
  }
}

data "azuread_service_principal" "af_sasp" {
  #object_id = "07cdd199-8f98-4b25-9a89-e50b2b604a28" # Microsoft.StorageSync
  display_name = "Microsoft.StorageSync"
}

## Azure built-in roles
## https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
resource "azurerm_role_assignment" "ad_role_storageaccount" {
  scope                = element(concat(azurerm_storage_account.filesync.*.id, data.azurerm_storage_account.filesync.*.id, [""]), 0)
  role_definition_name = "Reader and Data Access"
  principal_id         = data.azuread_service_principal.af_sasp.id
}

# Storage Account Network rules
resource "azurerm_storage_account_network_rules" "filesync-netrules" {  
  count                       = var.storage_account_limit_access_to_subnets ? 1 : 0
  storage_account_id          = element(concat(azurerm_storage_account.filesync.*.id, data.azurerm_storage_account.filesync.*.id, [""]), 0)
  virtual_network_subnet_ids  = [ data.azurerm_subnet.snet.0.id ]
  default_action              = "Deny"
  
  bypass = [
    "Metrics",
    "Logging",
    "AzureServices"
  ]
}

## Storage Shares
resource "azurerm_storage_share" "filesync" {
  name                  = var.storage_share_name != null ? var.storage_share_name : "${local.resource_prefix}-ss${local.name}"
  storage_account_name  = element(concat(azurerm_storage_account.filesync.*.name, data.azurerm_storage_account.filesync.*.name, [""]), 0)
  quota                 = var.storage_share_quota
  
  depends_on = [
    azurerm_storage_account.filesync
  ]

  acl {
    id = "GhostedRecall"
    access_policy {
      permissions = "r"
    }
  }

  timeouts {
    create  = local.timeout_create
    delete  = local.timeout_delete
    read    = local.timeout_read
    update  = local.timeout_update
  }
}

## Storage Sync Cloud Endpoints
resource "azurerm_storage_sync_cloud_endpoint" "filesync" {
  name                  ="${local.resource_prefix}-stsce${local.name}"
  storage_sync_group_id = azurerm_storage_sync_group.filesync.id
  file_share_name       = azurerm_storage_share.filesync.name
  storage_account_id    = element(concat(azurerm_storage_account.filesync.*.id, data.azurerm_storage_account.filesync.*.id, [""]), 0)

  timeouts {
    create  = local.timeout_create
    delete  = local.timeout_delete
    read    = local.timeout_read
  }

  depends_on = [
    azurerm_storage_sync_group.filesync,
    azurerm_storage_share.filesync,
    azurerm_storage_account.filesync
  ]
}
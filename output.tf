output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.id, azurerm_resource_group.rg.*.id, [""]), 0)
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
}

# Vnet and Subnets
output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = element(concat(data.azurerm_virtual_network.vnet.*.name, [""]), 0)
}

output "virtual_network_id" {
  description = "The id of the virtual network"
  value       = element(concat(data.azurerm_virtual_network.vnet.*.id, [""]), 0)
}

output "storage_account_id" {
  description = "The id of the storage account that was used/created"
  value       = element(concat(data.azurerm_storage_account.filesync.*.id, azurerm_storage_account.filesync.*.id, [""]), 0) 
}

output "storage_account_name" {
  description = "The name of the storage account that was used/created"
  value       = element(concat(data.azurerm_storage_account.filesync.*.name, azurerm_storage_account.filesync.*.name, [""]), 0) 
}

output "storage_sync_id" {
  description = "The id of the storage sync that was created"
  value       = azurerm_storage_sync.filesync.id
}

output "storage_sync_name" {
  description = "The name of the storage sync that was created"
  value       = azurerm_storage_sync.filesync.name
}

output "storage_sync_group_id" {
  description = "The id of the storage sync group that was created"
  value       = azurerm_storage_sync_group.filesync.id
}

output "storage_sync_group_name" {
  description = "The name of the storage sync group that was created"
  value       = azurerm_storage_sync_group.filesync.name
}

output "storage_sync_cloud_endpoint_id" {
  description = "The id of the storage sync cloud endpoint that was created"
  value       = azurerm_storage_sync_cloud_endpoint.filesync.id
}

output "storage_sync_cloud_endpoint_name" {
  description = "The name of the storage sync cloud endpoint that was created"
  value       = azurerm_storage_sync_cloud_endpoint.filesync.name
}

output "storage_sync_cloud_endpoint_file_share_name" {
  description = "The name of the storage sync cloud endpoint file share that was created"
  value       = azurerm_storage_sync_cloud_endpoint.filesync.file_share_name
}

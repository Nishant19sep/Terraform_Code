data "azurerm_client_config" "kv_tenant_id" {
} #teneant _ id ko fetch karna hai, key vault k liye


resource "azurerm_key_vault" "key-vault" {
  name                        = var.kv_name
  location                    = var.kv_location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.kv_tenant_id.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
  sku_name = "standard"
}
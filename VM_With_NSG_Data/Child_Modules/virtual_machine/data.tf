data "azurerm_subnet" "subnet_id" {
  name                 = var.subent_name
  virtual_network_name = var.Vnet_name
  resource_group_name  = var.rg_name
}

data "azurerm_public_ip" "pip" {
  name                = var.pip_name
  resource_group_name = var.rg_name
}

data "azurerm_key_vault" "key" {
  name                = var.kv_name
  resource_group_name = var.rg_name
}

data "azurerm_key_vault_secret" "vm-un" {
  name         = var.vm_un
  key_vault_id = data.azurerm_key_vault.key.id
}

data "azurerm_key_vault_secret" "vm-pwd" {
  name         = var.vm_pwd
  key_vault_id = data.azurerm_key_vault.key.id
}

data "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  resource_group_name = var.rg_name
}
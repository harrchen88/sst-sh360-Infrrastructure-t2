provider "azurerm" {
  version = "=2.37.0"
  features {}
  #subscription_id = "b790cea2-2da4-4970-8873-597a3f49dd79"
  #client_id       = "3b62b28e-5d99-4f69-a536-f6261f9d4321"
  #client_secret   = ""
  #tenant_id       = "f0221375-1838-4778-9132-f56de3b29b1d"
}

# -
# - Create Resource Groups and assign mandatory tags
# -
resource "azurerm_resource_group" "this" {
  for_each = var.resource_groups
  name     = each.value["name"]
  location = each.value["location"]
  tags     = each.value["tags"]
}


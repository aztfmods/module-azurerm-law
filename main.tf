#----------------------------------------------------------------------------------------
# resourcegroups
#----------------------------------------------------------------------------------------

data "azurerm_resource_group" "rg" {
  for_each = var.laws

  name = each.value.resourcegroup
}

#----------------------------------------------------------------------------------------
# generate random id
#----------------------------------------------------------------------------------------

resource "random_string" "random" {
  length    = 3
  min_lower = 3
  special   = false
  numeric   = false
  upper     = false
}

#----------------------------------------------------------------------------------------
# workspaces
#----------------------------------------------------------------------------------------

resource "azurerm_log_analytics_workspace" "law" {
  for_each = var.laws

  name                = "log-${var.company}-${each.key}-${var.env}-${var.region}-${random_string.random.result}"
  resource_group_name = data.azurerm_resource_group.rg[each.key].name
  location            = data.azurerm_resource_group.rg[each.key].location
  sku                 = each.value.sku

  daily_quota_gb                     = try(each.value.daily_quota_gb, null)
  internet_ingestion_enabled         = try(each.value.internet_ingestion_enabled, true)
  internet_query_enabled             = try(each.value.internet_query_enabled, true)
  retention_in_days                  = try(each.value.retention, 30)
  reservation_capacity_in_gb_per_day = try(each.value.reservation_capacity_in_gb_per_day, null)
  allow_resource_only_permissions    = try(each.value.allow_resource_only_permissions, true)

}

#----------------------------------------------------------------------------------------
# solutions
#----------------------------------------------------------------------------------------

resource "azurerm_log_analytics_solution" "solution" {
  for_each = {
    for solution in local.workspace_solutions : "${solution.law_key}.${solution.solution_key}" => solution
  }

  solution_name         = each.value.solution_name
  location              = each.value.location
  resource_group_name   = each.value.resourcegroup
  workspace_resource_id = each.value.workspace_id
  workspace_name        = each.value.workspace_name

  plan {
    publisher = each.value.publisher
    product   = each.value.product
  }
}

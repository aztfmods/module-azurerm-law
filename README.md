![example workflow](https://github.com/aztfmods/module-azurerm-law/actions/workflows/validate.yml/badge.svg)

# Log Analytic Workspaces

Terraform module which creates log analytics resources on Azure.

The below features are made available:

- Multiple workspaces
- Multiple solutions on each workspace
- Terratest is used to validate different integrations in [examples](examples)

The below examples shows the usage when consuming the module:

## Usage: single log analytics workspace single solution

```hcl
module "rgs" {
  source = "github.com/aztfmods/module-azurerm-rg"
  groups = {
    laws = { name = "rg-laws-weu", location = "westeurope" }
  }
}

module "law" {
  source = "../../"
  depends_on = [module.rgs]
  laws = {
    law1 = {
      location      = module.rgs.groups.laws.location
      resourcegroup = module.rgs.groups.laws.name
      sku           = "PerGB2018"
      retention     = 30
      solutions     = ["ContainerInsights"]
    }
  }
}
```

## Usage: multiple log analytics workspace multiple solutions

```hcl
module "rgs" {
  source = "github.com/aztfmods/module-azurerm-rg"
  groups = {
    laws = { name = "rg-laws-weu", location = "westeurope" }
  }
}

module "law" {
  source = "../../"
  depends_on = [module.rgs]
  laws = {
    law1 = {
      location      = module.rgs.groups.laws.location
      resourcegroup = module.rgs.groups.laws.name
      sku           = "PerGB2018"
      retention     = 30
      solutions     = ["ContainerInsights", "VMInsights", "AzureActivity"]

    law2 = {
      location      = module.rgs.groups.laws.location
      resourcegroup = module.rgs.groups.laws.name
      sku           = "PerGB2018"
      retention     = 30
      solutions     = ["ContainerInsights"]
    }
  }
```

## Resources

| Name | Type |
| :-- | :-- |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_log_analytics_solution](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `laws` | describes log analytics related configuration | object | yes |

## Authors

Module is maintained by [Dennis Kool](https://github.com/dkooll) with help from [these awesome contributors](https://github.com/dkooll/terraform-azurerm-bastion/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/dkooll/terraform-azurerm-bastion/tree/master/LICENSE) for full details.

data "azurerm_role_definition" "deployment_env_user_role" {
    role_definition_id = "18e40d4e-8d2e-438d-97e1-9528336e149c"
}

data "azurerm_role_definition" "dev_center_project_owner_role" {
    role_definition_id = "8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
}

data "azurerm_role_definition" "dev_center_iam_role" {
    role_definition_id = "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
}

data "azurerm_role_definition" "dev_center_contributor_role" {
    role_definition_id = "b24988ac-6180-42a0-ab88-20f7382dd24c"
}

data "azurerm_subscription" "current_sub" {
    
}

resource "azurerm_resource_group" "deployment_env_rg" {
  name     = "${var.dev_center_name}-rg"
  location = var.location
}

resource "azurerm_dev_center" "dc" {
    name                = var.dev_center_name
    resource_group_name = azurerm_resource_group.deployment_env_rg.name
    location = azurerm_resource_group.deployment_env_rg.location
    identity {
        type = "SystemAssigned"
    }
}

resource "azurerm_dev_center_catalog" "dc_catalog" {
    name = "${var.dev_center_name}-catalog"
    resource_group_name = azurerm_resource_group.deployment_env_rg.name
    dev_center_id = azurerm_dev_center.dc.id
    catalog_github {
      uri = "https://github.com/ashishrajsrivastava/Architecting-and-Implementing-DevOps-for-Infrastructure-Management-in-Azure"
      branch = "main"
      path = "ch9/Environment-Definitions"
      key_vault_key_url = "https://adpdemokv.vault.azure.net/secrets/githubpat/3784727c1a49434baf51c8daf0a7b87a"
    }
}

resource "azurerm_dev_center_environment_type" "dc_env_type" {
    name = var.deployment_env_name_env_type
    dev_center_id = azurerm_dev_center.dc.id
}

resource "azurerm_dev_center_project" "dc_demo_project" {
    name = "${var.dev_center_name}-demo-project"
    location = azurerm_resource_group.deployment_env_rg.location
    dev_center_id = azurerm_dev_center.dc.id
    resource_group_name = azurerm_resource_group.deployment_env_rg.name
}

resource "azurerm_role_assignment" "role_assignment" {
    scope = azurerm_dev_center_project.dc_demo_project.id
    principal_id = var.userId
    role_definition_id = data.azurerm_role_definition.deployment_env_user_role.id
}

resource "azurerm_dev_center_project_environment_type" "dc_demo_project_env_type" {
    name = "${var.dev_center_name}-demo-project-${var.deployment_env_name_env_type}"
    location = azurerm_resource_group.deployment_env_rg.location
    deployment_target_id = data.azurerm_subscription.current_sub.id
    identity {
        type = "SystemAssigned"
    }
    dev_center_project_id = azurerm_dev_center_project.dc_demo_project.id
    creator_role_assignment_roles = [ data.azurerm_role_definition.dev_center_project_owner_role.role_definition_id ]
}

resource "azurerm_role_assignment" "dc_demo_iam_role_assignment" {
    scope = data.azurerm_subscription.current_sub.id
    principal_id = azurerm_dev_center.dc.identity[0].principal_id
    principal_type = "ServicePrincipal"
    role_definition_id = data.azurerm_role_definition.dev_center_iam_role.id
}

resource "azurerm_role_assignment" "dc_demo_contributor_role_assignment" {
    scope = data.azurerm_subscription.current_sub.id
    principal_id = azurerm_dev_center.dc.identity[0].principal_id
    principal_type = "ServicePrincipal"
    role_definition_id = data.azurerm_role_definition.dev_center_contributor_role.id
}
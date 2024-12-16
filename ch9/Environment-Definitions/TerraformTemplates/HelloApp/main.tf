resource "azurerm_container_app_environment" "ade_ace" {
  name                       = "${var.container_app_name}-ace"
  location                   = azurerm_resource_group.ade_ace_rg.location
}

resource "azurerm_container_app" "ade_aca" {
  name                         = "${var.container_app_name}"
  container_app_environment_id = azurerm_container_app_environment.ade_ace.id
  revision_mode                = "Single"

  template {
    container {
      name   = "${var.container_app_name}"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
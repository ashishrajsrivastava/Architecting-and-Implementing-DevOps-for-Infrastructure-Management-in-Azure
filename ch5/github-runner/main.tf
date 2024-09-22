module "github_runners" {
  source                                       = "Azure/avm-ptn-cicd-agents-and-runners/azurerm"
  version                                      = "~> 0.1.2"
  postfix                                      = "iac-book-runners"
  location                                     = "westeurope"
  version_control_system_type                  = "github"
  version_control_system_personal_access_token = var.github_pat
  version_control_system_organization          = var.github_org_name
  version_control_system_repository            = var.github_repo_name
  virtual_network_address_space                = "10.4.0.0/16"
}
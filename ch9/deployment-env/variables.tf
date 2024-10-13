variable "location" {
    description = "Azure location in which deployment environment resources will be created"
    default = "westeurope"
}

variable "dev_center_name" {
    description = "Name of the Dev Center"
    default = "sandbox-devcenter"
}

variable "deployment_env_name_env_type" {
    description = "Name of the deployment environment type"
    default = "sandbox"
}

variable "userId" {
    description = "User object ID is required to assign the necessary role permission to create an environment."
    default = "34244a1e-112c-407f-b3de-73c25a4df2a5"
}
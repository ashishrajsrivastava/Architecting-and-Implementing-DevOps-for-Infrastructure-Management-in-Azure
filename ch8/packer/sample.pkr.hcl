variable "var_1" {
    type        = string
    default     = "default-value"
    description = "description of the `foo` variable"
    sensitive   = false
}
locals {
    local_1 = "a-local-value"
}
source "azure-arm" "image-example" {
    // ...
}
build {
  sources = ["source.azure-arm.image-example"]
  provisioner "shell" {
    inline          = ["apt-get update"]
    inline_shebang  = "/bin/sh -x"
  }
  post-processor "shell-local" {
    inline = ["Successfully created the managed image."]
  }
}
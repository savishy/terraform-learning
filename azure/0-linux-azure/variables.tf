# https://www.terraform.io/docs/configuration/variables.html
variable "env" {}
variable "address_space" {}
variable "subnet_block" {}
variable "azure_client_id" {}
variable "azure_client_secret" {}
variable "azure_tenant_id" {}
variable "azure_subscription_id" {}
variable "arm_client_id" {}
variable "arm_client_secret" {}
variable "arm_tenant_id" {}
variable "arm_subscription_id" {}
variable "vm_name" { default = "TestVM" }
variable "vm_size" { default = "Standard_DS1_v2"}
variable "vm_version" { default = "16.04.0-LTS" }
variable "vm_distro" { default = "UbuntuServer" }
variable "vm_publisher" { default = "Canonical"}
variable "rg_name" { default = "TestRG" }
variable "location" { default = "north europe"}
variable "tfstorageaccount_rg_name" { default = "terraformstorage_rg" }
variable "tfstorageaccount_name" { default = "terraformstoragetest" }
variable "tfstorageaccount_container_name" { default = "tfstoragecontainer" }

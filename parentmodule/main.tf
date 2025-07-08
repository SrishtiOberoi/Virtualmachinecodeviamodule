 module "resource_groeup" {
    source = "../azurerm_resourcegroup"
 rg_name = "Oberoi1RG"
 rg_location = "indonesiacentral"
 }
module "virtualnetwork" {
    depends_on = [module.resource_groeup]
    source = "../azurerm_virtualnetwork"
 vnet_name = "oberoivnet"
vnet_location = "indonesiacentral"
rg_name = "Oberoi1RG"
   
}
module "Subnetfrontend"{
   depends_on = [module.virtualnetwork]
   source = "../azurerm_subnet"
   subnet_name = "frontendsnet1"
rg_name = "Oberoi1RG"
 vnet_name= "oberoivnet"
 adress_prefixes = ["10.0.7.0/24"]
}
module "backendsnet"{
   depends_on = [module.virtualnetwork]
   source = "../azurerm_subnet"
   subnet_name = "backendnet1"
rg_name = "Oberoi1RG"
 vnet_name= "oberoivnet"
 adress_prefixes = ["10.0.6.0/24"]
}
module "network_security_group"{
depends_on = [module.Subnetfrontend]
source = "../azurerm_networksecurity"
nsg_name = "frontendnsg"
nsg_location ="indonesiacentral"
rg_name ="Oberoi1RG"
}
module "network_securitybackend_group"{
depends_on = [module.backendsnet]
source = "../azurerm_networksecurity"
nsg_name = "backendnsg"
nsg_location ="indonesiacentral"
rg_name ="Oberoi1RG"
}
module "publicipfront" {
   depends_on = [module.resource_groeup]
   source = "../azurerm_publicip"
pip_name = "frontend9pip"
rg_name = "Oberoi1RG"
pip_location = "indonesiacentral"
}
module "publicipback" {
   depends_on = [module.resource_groeup]
   source = "../azurerm_publicip"
pip_name = "backend9pip"
rg_name = "Oberoi1RG"
pip_location = "indonesiacentral"
}
module "key_vault" {
   depends_on = [module.resource_groeup]
   source = "../azurerm_keyvault"
keyvault_name = "my-keyvault-123"
keyvault_location = "indonesiacentral"
rg_name = "Oberoi1RG"
}
module "keyvaultsecret1"{
   depends_on = [ module.key_vault]
   source ="../azurerm_keyvault_secret"
secret_name = "frontend-username"
secret_value = var.vm_id_secret
keyvault_name = "my-keyvault-123"
rg_name ="Oberoi1RG"
}
module "keyvaultsecret2"{
   depends_on = [ module.key_vault]
   source ="../azurerm_keyvault_secret"
secret_name = "frontend-password"
secret_value = var.vm_password
keyvault_name = "my-keyvault-123"
rg_name ="Oberoi1RG"
}
module "frontendvm9" {
   depends_on = [module.publicipfront, module.Subnetfrontend, module.network_security_group , module.keyvaultsecret1, module.keyvaultsecret2]
 source = "../azurerm_virtual_machine"
 vm_name = "frontendvm9" 
 rg_name = "Oberoi1RG"
vm_location = "indonesiacentral"
subnet_name = "frontendsnet1"
vnet_name = "oberoivnet"
pip_name = "frontend9pip"
keyvault_name = "my-keyvault-123"
admin_username = var.vm_id_secret
admin_password = var.vm_password
nic_name = "nicfrontend9"
ipconfig_name ="infra-frontend-nic"

}

  variable "subnet_name"{
    type = string
  }
  variable "rg_name" {
    type = string
  }
  variable "vnet_name" {
    type = string 
  }
  variable "adress_prefixes" {
    type = list(string)
  }
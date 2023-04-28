terraform {

    required_version = ">=0.13.0"

  required_providers {
    civo = {
        source = "civo/civo"
        version = "~> 1.0.13"
    }
  }
}

variable "civo_token" {
    type = string
  
}

provider "civo" {
  token = var.civo.token
#  region = "The region you decide on"

}
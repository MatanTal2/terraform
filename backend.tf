terraform {
  backend "azurerm" {
    storage_account_name = "terraformproj"
    container_name       = "containproj"
    key                  = "prod.terraform.tfstate"

    # rather than defining this inline, the SAS Token can also be sourced
    # from an Environment Variable - more information is available below.
    sas_token = "?sv=2020-08-04&ss=bfqt&srt=co&sp=rwdlacuptfx&se=2021-10-31T22:12:55Z&st=2021-10-17T13:12:55Z&spr=https&sig=AmS7wWJOUhlFR%2BhanrR586pKLB95eKC0fnO0tGDU6s4%3D"
  }
}

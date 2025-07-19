provider "azure" {
  }
resource "azure_resource_group" "rg_devs"
{
    name     = "rg-devs"
    location = "southbrazil"
}
variables {
    location
}
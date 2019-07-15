resource "azurerm_storage_account" "sa" {
  name                     = "${var.storage_account_name}"
  resource_group_name      = "${var.rg_name}"
  location                 = "${var.rg_location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "asp_fa" {
  name                = "${var.function_app_plan_name}"
  resource_group_name = "${var.rg_name}"
  location            = "${var.rg_location}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "fa" {
  name                      = "${var.function_app_name}"
  resource_group_name       = "${var.rg_name}"
  location                  = "${var.rg_location}"
  app_service_plan_id       = "${azurerm_app_service_plan.asp_fa.id}"
  storage_connection_string = "${azurerm_storage_account.sa.primary_connection_string}"
  version                   = "~2"
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY                  = "${var.ai_instrumentation_key}"
    AZURE_FUNCTION_PROXY_BACKEND_URL_DECODE_SLASHES = "True"
    BlobStorage                                     = "${azurerm_storage_account.sa.primary_connection_string}"
    BlobStorageContainer                            = "${var.blob_storage_container}"
    BlobStorageContainerPurchase                    = "${var.blob_storage_container}"
    Branch                                          = "master"
    Commit                                          = "0123456789ABCDEF"
    FUNCTIONS_WORKER_RUNTIME                        = "dotnet"
    ServiceName                                     = "api"
    ServiceVersion                                  = "0.0.0"
    WEBSITE_RUN_FROM_PACKAGE                        = "1"
  }
}

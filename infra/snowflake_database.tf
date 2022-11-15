resource "snowflake_warehouse" "warehouse" {
  name           = var.snowflake_warehouse
  warehouse_size = var.snowflake_warehouse_size

  auto_suspend = 60
}

resource "snowflake_database" "sf_dev_db" {
  name                        = "DEV"
  comment                     = "DEV database"
  data_retention_time_in_days = 3
}

resource "snowflake_schema" "sf_schema" {
  database = snowflake_database.sf_dev_db.name
  name     = "RAW_MOVIE"
  comment  = "Schema for RAW movie data"

  is_transient        = false
  is_managed          = false
  data_retention_days = 1
}

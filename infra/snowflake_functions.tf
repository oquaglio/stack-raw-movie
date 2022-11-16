#
# Transforms this:
# [
#   {
#     "name": "Genre",
#     "value": "Action"
#   },
#   {
#     "name": "Year",
#     "value": "1979"
#   }
# ]
#
# Into this:
#
# {
#  "Genre": "Action",
#  "Year": "1979"
# }
#
resource "snowflake_function" "get_name_value_func" {
  name     = "GET_NAME_VALUE"
  database = snowflake_schema.schema.database
  schema   = snowflake_schema.schema.name
  arguments {
    name = "JSON_ARRAY"
    type = "ARRAY"
  }
  comment     = "Function to get value from name"
  return_type = "OBJECT"
  language    = "javascript"
  statement   = "return JSON_ARRAY.reduce((o,i) => { o[i.name] = i.value; return o }, {})"
}

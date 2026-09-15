locals {
  payload = jsonencode({
    for key, value in {
      alias             = var.alias == "" ? null : var.alias
      enabled           = var.enabled
      schedule          = var.schedule
      timezone          = var.timezone
      email             = var.email
      slack             = var.slack
      teams             = var.teams
      sns               = var.sns
      exception_tag     = var.exception_tag
      custom_tags       = var.custom_tags
      long_runner_hours = var.long_runner_hours
    } : key => value if value != null
  })
}

resource "restapi_object" "account" {
  path           = "/accounts/${var.account_id}"
  create_method  = "PUT"
  update_method  = "PUT"
  destroy_method = "DELETE"
  read_method    = "GET"
  data           = local.payload
  id_attribute   = "account_id"
}

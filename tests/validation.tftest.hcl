# Variable checks. These runs plan only and must fail before any HTTP call.

provider "restapi" {
  uri                  = "https://127.0.0.1"
  write_returns_object = true
  headers = {
    Authorization = "Bearer unused"
    Content-Type  = "application/json"
  }
}

run "rejects_short_account_id" {
  command = plan

  variables {
    account_id = "123"
  }

  expect_failures = [var.account_id]
}

run "rejects_fifo_sns" {
  command = plan

  variables {
    account_id = "123456789012"
    sns = {
      topic_arn = "arn:aws:sns:eu-west-1:123456789012:findings.fifo"
    }
  }

  expect_failures = [var.sns]
}

run "rejects_bad_schedule" {
  command = plan

  variables {
    account_id = "123456789012"
    schedule   = "not a cron"
  }

  expect_failures = [var.schedule]
}

run "rejects_localtime" {
  command = plan

  variables {
    account_id = "123456789012"
    alias      = "prod <x>"
  }

  expect_failures = [var.alias]
}

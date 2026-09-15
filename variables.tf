variable "account_id" {
  type        = string
  description = "12-digit AWS account ID to register on unusd.cloud."

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "account_id must be 12 digits."
  }
}

variable "alias" {
  type        = string
  default     = ""
  description = "Dashboard friendly name. Not the IAM account alias (that is read-only as iam_alias after the role exists)."

  validation {
    condition     = length(var.alias) <= 64 && !can(regex("[<>]", var.alias))
    error_message = "alias must be at most 64 characters and cannot contain < or >."
  }
}

variable "enabled" {
  type        = bool
  default     = null
  description = "Whether unusd.cloud should scan this account. Omit for the org default on create (on), or to leave the current value on update."
}

variable "schedule" {
  type        = string
  default     = null
  description = "EventBridge cron (six fields) or disabled. Omit to keep org Team settings defaults."

  validation {
    condition     = var.schedule == null ? true : (lower(var.schedule) == "disabled" || length([for part in split(" ", var.schedule) : part if part != ""]) == 6)
    error_message = "schedule must be an EventBridge cron with 6 fields, or disabled."
  }
}

variable "timezone" {
  type        = string
  default     = null
  description = "IANA timezone such as Europe/Paris. Omit to keep org defaults."
}

variable "email" {
  type = object({
    enabled      = optional(bool)
    recipients   = optional(list(string))
    display_name = optional(string)
    subject      = optional(string)
  })
  default     = null
  description = "Email report settings. Omit to keep org defaults. At least one notify channel must stay on."
}

variable "slack" {
  type = object({
    enabled = optional(bool)
    webhook = optional(string)
  })
  default     = null
  sensitive   = true
  description = "Slack incoming webhook (hooks.slack.com). GET redacts the URL. Startup+."

  validation {
    condition     = var.slack == null ? true : (try(var.slack.webhook, null) == null || var.slack.webhook == "" || can(regex("^https://hooks\\.slack\\.com(:443)?/(services|workflows)/", var.slack.webhook)))
    error_message = "slack.webhook must be an https://hooks.slack.com/services/... or /workflows/... URL."
  }
}

variable "teams" {
  type = object({
    enabled = optional(bool)
    webhook = optional(string)
  })
  default     = null
  sensitive   = true
  description = "Microsoft Teams or Power Automate webhook. GET redacts the URL. Business+."
}

variable "sns" {
  type = object({
    enabled   = optional(bool)
    topic_arn = optional(string)
  })
  default     = null
  description = "Customer SNS topic ARN for JSON findings. Enterprise. FIFO topics are not supported."

  validation {
    condition     = var.sns == null ? true : (try(var.sns.topic_arn, null) == null || var.sns.topic_arn == "" || !endswith(var.sns.topic_arn, ".fifo"))
    error_message = "SNS FIFO topics are not supported."
  }
}

variable "exception_tag" {
  type        = string
  default     = null
  description = "Tag key that skips a resource during scans. Omit to keep org defaults."
}

variable "custom_tags" {
  type        = list(string)
  default     = null
  description = "Up to two tag keys copied into reports."

  validation {
    condition     = var.custom_tags == null ? true : length(var.custom_tags) <= 2
    error_message = "custom_tags accepts at most 2 keys."
  }
}

variable "long_runner_hours" {
  type        = number
  default     = null
  description = "Hours before a long-running instance is flagged. 1-168."

  validation {
    condition     = var.long_runner_hours == null ? true : (var.long_runner_hours >= 1 && var.long_runner_hours <= 168 && floor(var.long_runner_hours) == var.long_runner_hours)
    error_message = "long_runner_hours must be an integer between 1 and 168."
  }
}

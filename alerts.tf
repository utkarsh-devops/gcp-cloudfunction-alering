variable "alert_policy_display_name_active_instance" {
  default = "CloudFunction | Lower Active Instances Alert"
}

variable "cloud_function_name" {
  default = "function-1" // Replace with your function name
}

variable "threshold_value_activeinstance" {
  default = 1
}

variable "comparison_operator" {
  default = "COMPARISON_LT" // Can be changed to GT, EQ, etc. as needed
}

variable "duration" {
  default = "60s"
}

variable "notification_email" {
  default = "utkarshksharma@google.com"
}

variable "alert_policy_display_name_memory" {
  default = "CloudFunction | Low Memory Usage Alert"
}

variable "threshold_value_memory" {
  default = 60000000 // 60 MB in bytes
}

# variable "alert_policy_display_name_pendingrequest" {
#   default = "CloudFunction | High Pending Requests Alert"
# }

# variable "threshold_value_pendingrequest" {
#   default = 1
# }

variable "alert_policy_display_name_execution_count" {
  default = "CloudFunction | Low Execution Count Alert"
}

variable "threshold_value_execution_count" {
  default = 0.02
}

variable "alert_policy_display_name_lownetworkegress" {
  default = "CloudFunction | Low Network Egress Alert"
}

variable "threshold_value_lownetworkegress" {
  default = 0.2 // 0.2 bytes per second
}

variable "alert_policy_display_name_executiontime" {
  default = "CloudFunction | Low Execution Time Alert"
}

variable "threshold_value_executiontime" {
  default = 5 // 5 seconds
}

variable "alert_policy_display_name_instancecount" {
  default = "CloudFunction | Low Instance Count Alert"
}

variable "threshold_value_instancecount" {
  default = 1
}

resource "google_monitoring_alert_policy" "cloud_function_active_instances_alert" {
  display_name = var.alert_policy_display_name_active_instance
  combiner     = "OR"

  conditions {
    display_name = "Less Active Instances for CloudFunction"
    condition_threshold {
      filter          = "resource.type = \"cloud_function\" AND metric.type = \"cloudfunctions.googleapis.com/function/active_instances\" AND resource.labels.function_name = \"${var.cloud_function_name}\""
      comparison      = var.comparison_operator
      threshold_value = var.threshold_value_activeinstance
      duration        = var.duration
      trigger {
        count = 1
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email_channel.name
  ]
}

resource "google_monitoring_alert_policy" "cloud_function_low_memory_alert" {
  display_name = var.alert_policy_display_name_memory
  combiner     = "OR"

  conditions {
    display_name = "CloudFunction | Low Memory Usage"
    condition_threshold {
      filter          = "resource.type = \"cloud_function\" AND metric.type = \"cloudfunctions.googleapis.com/function/user_memory_bytes\" AND resource.labels.function_name = \"${var.cloud_function_name}\""
      comparison      = var.comparison_operator
      threshold_value = var.threshold_value_memory
      duration        = var.duration // Alert if condition persists for 60 seconds
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_PERCENTILE_99" // Use ALIGN_PERCENTILE_99 for DISTRIBUTION metrics
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email_channel.name
  ]
}

# resource "google_monitoring_alert_policy" "cloud_function_pending_requests_alert" {
#   display_name = var.alert_policy_display_name_pendingrequest
#   combiner     = "OR"

#   conditions {
#     display_name = "High Pending Requests for Cloud Function"
#     condition_threshold {
#       filter          = "resource.type = \"cloud_function\" AND metric.type = \"monitoring.googleapis.com/logging/user/pending_queue/pending_requests\" AND resource.labels.function_name = \"${var.cloud_function_name}\""
#       comparison      = "COMPARISON_GT" // Greater than
#       threshold_value = var.threshold_value_pendingrequest
#       duration        = "60s" // Alert if condition persists for 60 seconds
#       trigger {
#         count = 1
#       }
#       aggregations {
#         alignment_period   = "60s"
#         per_series_aligner = "ALIGN_RATE"
#       }

#     }
#   }
#   notification_channels = [
#     google_monitoring_notification_channel.email_channel.name
#   ]
# }

resource "google_monitoring_alert_policy" "cloud_function_low_execution_alert" {
  display_name = var.alert_policy_display_name_execution_count
  combiner     = "OR"

  conditions {
    display_name = "Low Execution Count for Cloud Function"
    condition_threshold {
      filter          = "resource.type = \"cloud_function\" AND metric.type = \"cloudfunctions.googleapis.com/function/execution_count\" AND resource.labels.function_name = \"${var.cloud_function_name}\""
      comparison      = "COMPARISON_LT" // Less than
      threshold_value = var.threshold_value_execution_count
      duration        = var.duration // Alert if condition persists for x seconds
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"        // Align over 1 minute
        per_series_aligner = "ALIGN_RATE" // Calculate the rate per minute
      }

    }
  }
  notification_channels = [
    google_monitoring_notification_channel.email_channel.name
  ]
}

resource "google_monitoring_alert_policy" "cloud_function_low_network_egress_alert" {
  display_name = var.alert_policy_display_name_lownetworkegress
  combiner     = "OR"

  conditions {
    display_name = "Low Network Egress for Cloud Function"
    condition_threshold {
      filter          = "resource.type = \"cloud_function\" AND metric.type = \"cloudfunctions.googleapis.com/function/network_egress\" AND resource.labels.function_name = \"${var.cloud_function_name}\""
      comparison      = "COMPARISON_LT" // Less than
      threshold_value = var.threshold_value_lownetworkegress
      duration        = var.duration // Alert if condition persists for x seconds
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email_channel.name
  ]
}

resource "google_monitoring_alert_policy" "cloud_function_low_execution_time_alert" {
  display_name = var.alert_policy_display_name_executiontime
  combiner     = "OR"

  conditions {
    display_name = "Low Execution Time for Cloud Function"
    condition_threshold {
      filter          = "resource.type = \"cloud_function\" AND metric.type = \"cloudfunctions.googleapis.com/function/execution_times\" AND resource.labels.function_name = \"${var.cloud_function_name}\""
      comparison      = "COMPARISON_LT" // Less than
      threshold_value = var.threshold_value_executiontime
      duration        = var.duration // Alert if condition persists for x seconds
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_PERCENTILE_99" // 99th percentile 
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email_channel.name
  ]
}

resource "google_monitoring_alert_policy" "cloud_function_low_instance_count_alert" {
  display_name = var.alert_policy_display_name_instancecount
  combiner     = "OR"

  conditions {
    display_name = "Low Instance Count for Cloud Function"
    condition_threshold {
      filter          = "resource.type = \"cloud_function\" AND metric.type = \"cloudfunctions.googleapis.com/function/instance_count\" AND resource.labels.function_name = \"${var.cloud_function_name}\""
      comparison      = "COMPARISON_LT" // Less than
      threshold_value = var.threshold_value_instancecount
      duration        = var.duration // Alert if condition persists for x seconds
      trigger {
        count = 1
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email_channel.name
  ]
}

resource "google_monitoring_notification_channel" "email_channel" {
  display_name = "Email notifications"
  type         = "email"
  labels = {
    email_address = var.notification_email
  }
}

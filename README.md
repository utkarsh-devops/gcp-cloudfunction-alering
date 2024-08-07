Google Cloud Function Monitoring with Alert Policies

This Terraform configuration creates a robust monitoring and alerting system for your Google Cloud Functions. It sets up several alert policies in Google Cloud Monitoring to proactively notify you of critical conditions related to your Cloud Functions, including:

Low Active Instances: Alerts when the number of active instances falls below a specified threshold.
Low Memory Usage: Alerts when memory consumption dips below a defined level.
Low Execution Count: Alerts if the function's execution count is lower than expected.
Low Network Egress: Alerts when the outgoing network traffic from the function is low.
Low Execution Time: Alerts if the function's execution time is unexpectedly short.
Low Instance Count: Alerts when the total instance count of the function is low.
(Optional) High Pending Requests: (Commented out) Alerts when the pending request queue grows too large.
Key Features

Customizable Alert Thresholds: Easily adjust the trigger values for each alert policy to match your function's performance characteristics.
Email Notifications: Receives alerts via email to your specified address.
Comprehensive Monitoring: Covers a wide range of metrics to provide a holistic view of function health.
Terraform Automation: Streamlines the setup and management of monitoring resources.
Prerequisites

Google Cloud Project: You need an active Google Cloud project.
Terraform: Ensure you have Terraform installed on your local machine.
Google Cloud SDK: Install and authenticate with the Google Cloud SDK.
Google Cloud Monitoring API: Enable the Cloud Monitoring API in your project.

Customize Variables:

Open the variables.tf file.
Update the following variables with your specific values:
cloud_function_name
threshold_value_activeinstance
threshold_value_memory
threshold_value_execution_count
threshold_value_lownetworkegress
threshold_value_executiontime
threshold_value_instancecount
notification_email

Additional Notes

Uncomment High Pending Requests: If you want to include the "High Pending Requests" alert, uncomment the relevant code block in the main.tf file.
Customize Alert Logic: Feel free to modify the filter conditions or aggregations within the alert policies to tailor them to your needs.
Metric Documentation: Refer to the official Google Cloud Monitoring documentation for details on the available metrics and their meaning.

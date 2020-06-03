sendSuccessSlackNotification() {
  local url=$(find_step_configuration_value "healthCheckUrl")
  local slackIntegrationName=$(get_integration_name --type "slackKey")
  if [ ! -z "$slackIntegrationName" ]; then
    local notifyOnSuccess=$(find_step_configuration_value "notifyOnSuccess")
    if [ -z "$notifyOnSuccess" ]; then
      notifyOnSuccess=false
    fi
    if [ "$notifyOnSuccess" == "true" ] && $success; then
      echo "Sending success notification"
      send_notification "$slackIntegrationName" --text "Health check $url succeeded"
    fi
  else
    echo "Slack integration is not added, skipping notification"
  fi
}

execute_command sendSuccessSlackNotification

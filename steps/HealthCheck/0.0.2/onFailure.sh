sendFailureSlackNotification() {
  local url=$(find_step_configuration_value "healthCheckUrl")
  local slackIntegrationName=$(get_integration_name --type "slackKey")
  if [ ! -z "$slackIntegrationName" ]; then
    local notifyOnFailure=$(find_step_configuration_value "notifyOnFailure")
    if [ -z "$notifyOnFailure" ]; then
      notifyOnFailure=true
    fi
    if [ "$notifyOnFailure" == "true" ] && ! $success; then
      echo "Sending failure notification"
      send_notification "$slackIntegrationName" --text "Health check $url failed"
    fi
  else
    echo "Slack integration is not added, skipping notification"
  fi
}

execute_command sendFailureSlackNotification

sendFailureSlackNotification() {
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
  fi
}

execute_command sendFailureSlackNotification

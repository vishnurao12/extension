checkHealth() {
  local success=true
  local url=$(find_step_configuration_value "healthCheckUrl")
  {
    local statusCode=$(curl --silent --output /dev/stderr --write-out "%{http_code}" "$url")
  } || exitCode=$?
  if test $statusCode -ne 200; then
    export success=false
    echo "Health check failed with statusCode: $statusCode & exitCode: $exitCode for url: $url"
  else
    echo "Health check succeeded"
  fi

  local slackIntegrationName=$(get_integration_name --type "slackKey")
  if [ ! -z "$slackIntegrationName" ]; then
    local notifyOnSuccess=$(find_step_configuration_value "notifyOnSuccess")
    if [ -z "$notifyOnSuccess" ]; then
      notifyOnSuccess=false
    fi
    local notifyOnFailure=$(find_step_configuration_value "notifyOnFailure")
    if [ -z "$notifyOnFailure" ]; then
      notifyOnFailure=true
    fi

    if [ "$notifyOnSuccess" == "true" ] && $success; then
      echo "Sending success notification"
      send_notification "$slackIntegrationName" --text "Health check $url succeeded" --color "#40be46"
    fi

    if [ "$notifyOnFailure" == "true" ] && ! $success; then
      echo "Sending failure notification"
      send_notification "$slackIntegrationName" --text "Health check $url failed" --color "#fc8675"
    fi
  fi

  $success
}

execute_command checkHealth

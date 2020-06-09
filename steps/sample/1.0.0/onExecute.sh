sample() {
  local foo=$(find_step_configuration_value "foo")
  echo "$step_name's foo value is $foo"
}

execute_command sample

resource_name=$1
test_input() {
  echo "resource name: $1"
  printenv
}

execute_command "test_input $resource_name"

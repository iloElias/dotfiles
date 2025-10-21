#!/bin/bash

source /opt/dotfiles/data/excluded-containers.sh

get_target_containers() {
  local ignore_excluded=${1:-false}

  mapfile -t all_containers < <(docker ps -a --format '{{.Names}}')

  local selected=()

  for container in "${all_containers[@]}"; do
    if [[ " ${EXCLUDED_CONTAINERS[*]} " =~ " ${container} " ]] && [[ $ignore_excluded == false ]]; then
      continue
    fi
    selected+=("$container")
  done

  printf '%s\n' "${selected[@]}"
}

#!/bin/bash

source /opt/dotfiles/data/excluded-containers.sh

containers=$(docker ps -a --format '{{.Names}}')

ignore_excluded=false

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --ignore-excluded|--ignore-exclude) ignore_excluded=true ;;
  esac
  shift
done

if [[ "$ignore_excluded" == true ]]; then
  /opt/dotfiles/scripts/stop-all-containers.sh --ignore-excluded
else
  /opt/dotfiles/scripts/stop-all-containers.sh
fi

for container in $containers; do
  excluded=false
  for excluded_container in "${EXCLUDED_CONTAINERS[@]}"; do
    if [[ "$excluded_container" == "$container" ]]; then
      excluded=true
      break
    fi
  done
  if [[ "$excluded" == false || "$ignore_excluded" == true ]]; then
    docker rm "$container"
  fi
done

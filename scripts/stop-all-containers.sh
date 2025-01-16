#!/bin/bash

source $HOME/dot-files/data/excluded-containers.sh

containers=$(docker ps -a --format '{{.Names}}')

for container in $containers; do
  excluded=false
  for excluded_container in "${EXCLUDED_CONTAINERS[@]}"; do
    if [[ "$excluded_container" == "$container" ]]; then
      excluded=true
      break
    fi
  done
  if [[ "$excluded" == false ]]; then
    docker stop $container
  fi
done

#!/bin/bash

source /opt/dotfiles/lib/utils.sh

ignore_excluded=false

for arg in "$@"; do
  case $arg in
    --ignore-excluded|--ignore-exclude) ignore_excluded=true ;;
  esac
done

/opt/dotfiles/scripts/stop-all-containers.sh ${ignore_excluded:+--ignore-excluded}

mapfile -t containers_to_remove < <(get_target_containers "$ignore_excluded")

if [[ ${#containers_to_remove[@]} -gt 0 ]]; then
  echo "Removendo contêineres: ${containers_to_remove[*]}"
  docker rm "${containers_to_remove[@]}"
else
  echo "Nenhum contêiner a ser removido."
fi

#!/bin/bash

source /opt/dotfiles/lib/utils.sh

ignore_excluded=false

for arg in "$@"; do
  case $arg in
    --ignore-excluded|--ignore-exclude) ignore_excluded=true ;;
  esac
done

mapfile -t containers_to_stop < <(get_target_containers "$ignore_excluded")

if [[ ${#containers_to_stop[@]} -gt 0 ]]; then
  echo "Parando contêineres: ${containers_to_stop[*]}"
  docker stop "${containers_to_stop[@]}"
else
  echo "Nenhum contêiner a ser parado."
fi

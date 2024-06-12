#!/usr/bin/env bash

PROGRAMS=(
  php8.1 
  php8.1-pgsql
  php8.1-curl
  php8.1-dev
)

sudo apt update -y

for nome_do_programa in ${PROGRAMS[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then
    apt install "$nome_do_programa" -y
  else
    echo "[Install] - $nome_do_programa"
  fi
done
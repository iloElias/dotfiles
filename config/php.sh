#!/usr/bin/env bash

PROGRAMS=(
  php
  php-common
  php-pgsql
  php-curl
  php-dev
  php-pdo
  php-mbstring
)

sudo apt update -y

for nome_do_programa in "${PROGRAMS[@]}"; do
  if ! dpkg -l | grep -q "${nome_do_programa}"; then
    sudo apt install "$nome_do_programa" -y
  else
    echo "[Install] - $nome_do_programa is already installed"
  fi
done

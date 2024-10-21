#!/usr/bin/env bash

PROGRAMS=(
  php8.3
  php8.3-common
  php8.3-pgsql
  php8.3-curl
  php8.3-dev
  php8.3-pdo
)

sudo apt update -y

for nome_do_programa in "${PROGRAMS[@]}"; do
  if ! dpkg -l | grep -q "${nome_do_programa}"; then
    sudo apt install "$nome_do_programa" -y
  else
    echo "[Install] - $nome_do_programa is already installed"
  fi
done

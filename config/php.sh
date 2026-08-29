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

echo "Install Composer v2.8.1"

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
php composer-setup.php
php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/local/bin/composer

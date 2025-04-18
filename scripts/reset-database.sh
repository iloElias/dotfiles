#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <service-name>"
  exit 1
fi

SERVICE="$1"
PG_CONTAINER="postgres"
PHP_CONTAINER="${SERVICE}-php-fpm"
PG_DATABASE="${SERVICE}_db"
PG_COMMAND="DROP DATABASE ${PG_DATABASE}"

if docker container inspect "$PG_CONTAINER" &>/dev/null; then
  echo "Dropping database ${PG_DATABASE} in container ${PG_CONTAINER}..."
  docker exec -it "$PG_CONTAINER" psql -U postgres -c "$PG_COMMAND"
  echo "Restarting container ${SERVICE}-${PG_CONTAINER}..."
  docker restart "${SERVICE}-${PG_CONTAINER}"
else
  echo "Container $PG_CONTAINER does not exist. Skipping Postgres actions..."
fi

if docker container inspect "$PHP_CONTAINER" &>/dev/null; then
  echo "Running migrations in container ${PHP_CONTAINER}..."
  docker exec -it "$PHP_CONTAINER" php artisan migrate
  docker exec -it "$PHP_CONTAINER" php artisan db:seed
else
  echo "Container $PHP_CONTAINER does not exist. Skipping PHP-FPM actions..."
fi

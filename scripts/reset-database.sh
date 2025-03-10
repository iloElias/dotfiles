#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <service-name>"
  exit 1
fi

SERVICE="$1"
PG_CONTAINER="${SERVICE}-postgres"
PHP_CONTAINER="${SERVICE}-php-fpm"

if docker container inspect "$PG_CONTAINER" > /dev/null 2>&1; then
  docker exec -it "$PG_CONTAINER" psql -U postgres -c "DROP DATABASE ${SERVICE}"
  docker restart "$PG_CONTAINER"
else
  echo "Container $PG_CONTAINER does not exist. Skipping Postgres commands..."
fi

if docker container inspect "$PHP_CONTAINER" > /dev/null 2>&1; then
  docker exec -it "$PHP_CONTAINER" php artisan migrate
else
  echo "Container $PHP_CONTAINER does not exist. Skipping PHP-FPM commands..."
fi

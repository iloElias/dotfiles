#!/usr/bin/env bash

set -euo pipefail

repo_dir="/home/murilo-elias/projects/simple-work-api"
compose_file="$repo_dir/docker-compose.yml"
image_name="pyapi:http-local"
container_name="pyapi-local"
network_name="simple-work-api_default"
painel_dir="/home/murilo-elias/projects/simple-work-painel"
painel_log="/tmp/simple-work-painel.log"
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

build_image_if_missing() {
    if docker image inspect "$image_name" >/dev/null 2>&1; then
        echo "[swapistart] Imagem já existe: $image_name"
        return 0
    fi

    echo "[swapistart] Imagem $image_name não encontrada. Construindo..."
    docker build -t "$image_name" -f- "$repo_dir" <<'EOF'
FROM python:3.8.3-slim AS base
RUN mkdir -p /img_root/app
COPY . /img_root/app/
RUN mv /img_root/app/shipping/* /img_root/ && \
    chmod +x /img_root/*.sh && \
    rm -rf /img_root/app/shipping && \
    rm -rf /img_root/app/docs && \
    rm -rf /img_root/app/migrations && \
    rm -rf /img_root/app/migrations-laboratory && \
    rm -rf /img_root/app/app

FROM python:3.8.3-slim
LABEL maintainer="Simple Agro Sistemas <devops@simpleagro.com.br>"
RUN mkdir /app
WORKDIR /app
COPY --from=base /img_root/ /
RUN python -m pip install pip --upgrade && \
    grep -v '^sa-migrate==' /app/requirements/base.txt > /tmp/base-no-private.txt && \
    python -m pip install --no-cache-dir -r /tmp/base-no-private.txt && \
    python -m pip install --no-cache-dir gunicorn
ENV PYTHONPATH=/app
EXPOSE 8000
CMD ["/start.sh"]
ENV VARIABLE_NAME=app
COPY app/. /app/app/
COPY migrations/. /app/migrations/
EOF
}

start_painel() {
    local node_version="16"

    if [ ! -d "$painel_dir" ]; then
        echo "[swapistart] Diretório do painel não encontrado: $painel_dir"
        return 0
    fi

    if [ -f "$painel_dir/.nvmrc" ]; then
        node_version=$(tr -d ' \n\r' < "$painel_dir/.nvmrc")
    fi

    local runner
    runner="export NVM_DIR=\"$NVM_DIR\"; [ -s \"$NVM_DIR/nvm.sh\" ] && . \"$NVM_DIR/nvm.sh\"; \
        nvm install $node_version >/tmp/simple-work-painel_nvm_install.log 2>&1 || true; \
        nvm use $node_version >/tmp/simple-work-painel_nvm_use.log 2>&1 || true; \
        cd \"$painel_dir\"; \
        npm rebuild node-sass >/tmp/simple-work-painel_npm_rebuild.log 2>&1 || true; \
        npm run dev"

    nohup bash -lc "$runner" >"$painel_log" 2>&1 &
    local pid=$!
    echo "[swapistart] Painel iniciado em background (PID $pid)."
    echo "[swapistart] URL do painel: http://localhost:8081"
    echo "[swapistart] Log do painel: $painel_log"
}

main() {
    if [ ! -d "$repo_dir" ]; then
        echo "[swapistart] Diretório não encontrado: $repo_dir" >&2
        exit 1
    fi

    if [ ! -f "$compose_file" ]; then
        echo "[swapistart] Arquivo não encontrado: $compose_file" >&2
        exit 1
    fi

    echo "[swapistart] Subindo Mongo via docker compose..."
    docker compose -f "$compose_file" up -d mongo

    build_image_if_missing

    echo "[swapistart] Reiniciando container da API..."
    docker rm -f "$container_name" >/dev/null 2>&1 || true

    docker run -d \
        --name "$container_name" \
        --network "$network_name" \
        -p 8000:8000 \
        -e APP_DEBUG=1 \
        -e MONGO_URL=mongodb://mongo:27017/test \
        -e APP_MODE=DEVELOPMENT \
        -e SKIP_AUTH=1 \
        -e API_SALES_URL=http://localhost \
        -e CACHE_ENABLED=0 \
        -e STREAM_CONSUMER_ENABLED=0 \
        -e STREAM_PUBLISHER_ENABLED=0 \
        -e PRE_START_PATH=/no-prestart.sh \
        -v "$repo_dir/app:/app/app" \
        -v "$repo_dir/migrations:/app/migrations" \
        "$image_name" >/tmp/simple-work-api_container_id.log

    echo "[swapistart] API iniciada em http://localhost:8000"
    echo "[swapistart] Swagger Work: http://localhost:8000/workapi/docs"
    echo "[swapistart] Logs: docker logs -f $container_name"

    start_painel
}

main "$@"

#!/usr/bin/env bash

set -euo pipefail

repo_dir="/home/murilo-elias/projects/simple-work-api"
base_projects_dir="/home/murilo-elias/projects"
shared_mongo_dir="$base_projects_dir/mongo"
image_name="pyapi:http-local"
work_container_name="pyapi-work-local"
lab_container_name="pyapi-lab-local"
router_container_name="pyapi-router-local"
legacy_container_name="pyapi-local"
network_name="swapi-local-net"
painel_dir="/home/murilo-elias/projects/simple-work-painel"
painel_log="/tmp/simple-work-painel.log"
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
mongo_url="${SWAPI_MONGO_URL:-mongodb://host.docker.internal:27017/test}"
lab_mongo_url="${SWAPI_LAB_MONGO_URL:-mongodb://host.docker.internal:27017/labdb}"
router_conf_file="/tmp/swapi-nginx.conf"

find_compose_file() {
    local dir="$1"
    local candidates=("docker-compose.yml" "docker-compose.yaml" "docker-compose.iml")
    for f in "${candidates[@]}"; do
        if [ -f "$dir/$f" ]; then
            echo "$dir/$f"
            return 0
        fi
    done
    return 1
}

start_shared_mongo() {
    local compose_file
    if compose_file=$(find_compose_file "$shared_mongo_dir"); then
        echo "[swapistart] Subindo Mongo compartilhado (mesmo do sastart): $compose_file"
        if ! docker compose -f "$compose_file" up -d 2>/tmp/swapistart_mongo_error.log; then
            echo "[swapistart] Falha ao subir Mongo compartilhado. Ver /tmp/swapistart_mongo_error.log" >&2
            sed -n '1,120p' /tmp/swapistart_mongo_error.log >&2 || true
        fi
    else
        echo "[swapistart] Compose do Mongo não encontrado em $shared_mongo_dir" >&2
    fi
}

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
ENV VARIABLE_NAME=app
COPY app/. /app/app/
COPY migrations/. /app/migrations/
CMD ["/start.sh"]
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

ensure_network() {
    docker network inspect "$network_name" >/dev/null 2>&1 || docker network create "$network_name" >/dev/null
}

write_router_conf() {
    cat > "$router_conf_file" <<EOF
server {
    listen 8000;
    server_name _;

    location = /workapi {
        return 301 /workapi/;
    }

    location = /labapi {
        return 301 /labapi/;
    }

    location /workapi/ {
        proxy_pass http://$work_container_name:8000/workapi/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /labapi/ {
        proxy_pass http://$lab_container_name:8000/labapi/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
}

start_api_containers() {
    echo "[swapistart] Reiniciando containers Work/Lab da API..."

    docker rm -f "$legacy_container_name" >/dev/null 2>&1 || true
    docker rm -f "$work_container_name" >/dev/null 2>&1 || true
    docker rm -f "$lab_container_name" >/dev/null 2>&1 || true
    docker rm -f "$router_container_name" >/dev/null 2>&1 || true

    docker run -d \
        --name "$work_container_name" \
        --network "$network_name" \
        --add-host host.docker.internal:host-gateway \
        -e VARIABLE_NAME=app \
        -e APP_DEBUG=1 \
        -e MONGO_URL="$mongo_url" \
        -e LAB_MONGO_URL="$lab_mongo_url" \
        -e APP_MODE=DEVELOPMENT \
        -e SKIP_AUTH=1 \
        -e API_SALES_URL=http://localhost \
        -e CACHE_ENABLED=0 \
        -e STREAM_CONSUMER_ENABLED=0 \
        -e STREAM_PUBLISHER_ENABLED=0 \
        -e PRE_START_PATH=/no-prestart.sh \
        -v "$repo_dir/app:/app/app" \
        -v "$repo_dir/migrations:/app/migrations" \
        "$image_name" >/tmp/simple-work-api_work_container_id.log

    docker run -d \
        --name "$lab_container_name" \
        --network "$network_name" \
        --add-host host.docker.internal:host-gateway \
        -e VARIABLE_NAME=lab_app \
        -e APP_DEBUG=1 \
        -e MONGO_URL="$mongo_url" \
        -e LAB_MONGO_URL="$lab_mongo_url" \
        -e APP_MODE=DEVELOPMENT \
        -e SKIP_AUTH=1 \
        -e API_SALES_URL=http://localhost \
        -e CACHE_ENABLED=0 \
        -e STREAM_CONSUMER_ENABLED=0 \
        -e STREAM_PUBLISHER_ENABLED=0 \
        -e PRE_START_PATH=/no-prestart.sh \
        -v "$repo_dir/app:/app/app" \
        -v "$repo_dir/migrations:/app/migrations" \
        "$image_name" >/tmp/simple-work-api_lab_container_id.log

    write_router_conf

    docker run -d \
        --name "$router_container_name" \
        --network "$network_name" \
        -p 8000:8000 \
        -v "$router_conf_file:/etc/nginx/conf.d/default.conf:ro" \
        nginx:alpine >/tmp/simple-work-api_router_container_id.log
}

main() {
    if [ ! -d "$repo_dir" ]; then
        echo "[swapistart] Diretório não encontrado: $repo_dir" >&2
        exit 1
    fi

    start_shared_mongo

    build_image_if_missing

    ensure_network
    start_api_containers

    echo "[swapistart] APIs Work e Lab iniciadas ao mesmo tempo em http://localhost:8000"
    echo "[swapistart] Swagger Work: http://localhost:8000/workapi/docs"
    echo "[swapistart] Swagger Lab: http://localhost:8000/labapi/docs"
    echo "[swapistart] Logs Work: docker logs -f $work_container_name"
    echo "[swapistart] Logs Lab: docker logs -f $lab_container_name"
    echo "[swapistart] Logs Router: docker logs -f $router_container_name"

    start_painel
}

main "$@"

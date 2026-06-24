#!/usr/bin/env bash

# Para parar os projetos do simpleagro: derruba o compose (se existir)
# e encerra processos cujo diretório de trabalho seja dos projetos.

set -euo pipefail

base_path="/home/murilo-elias/projects"

mongodb_path="/mongo"
adonis_path="/simpleagro-api-adonis"
painel_path="/simpleagro_paineladm"

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

kill_by_cwd() {
    local dir="$1"
    local found=0
    echo "[sastop] Procurando processos com cwd em $dir"
    for pid_path in /proc/[0-9]*; do
        pid=${pid_path#/proc/}
        if [ -L "$pid_path/cwd" ]; then
            cwd=$(readlink -f "$pid_path/cwd" 2>/dev/null || true)
            if [ "$cwd" = "$dir" ]; then
                found=1
                echo "[sastop] Enviando SIGTERM para PID $pid (cwd=$cwd)"
                kill -TERM "$pid" 2>/dev/null || true
            fi
        fi
    done

    # Aguarda alguns segundos e força se ainda existir
    sleep 2
    for pid_path in /proc/[0-9]*; do
        pid=${pid_path#/proc/}
        if [ -L "$pid_path/cwd" ]; then
            cwd=$(readlink -f "$pid_path/cwd" 2>/dev/null || true)
            if [ "$cwd" = "$dir" ]; then
                echo "[sastop] PID $pid ainda ativo; enviando SIGKILL"
                kill -KILL "$pid" 2>/dev/null || true
            fi
        fi
    done

    if [ "$found" -eq 0 ]; then
        echo "[sastop] Nenhum processo encontrado com cwd em $dir"
    fi
}

main() {
    # Stop docker compose if present
    compose_dir="$base_path$mongodb_path"
    if compose_file=$(find_compose_file "$compose_dir"); then
        echo "[sastop] Encontrado compose: $compose_file — derrubando containers..."
        if ! docker compose -f "$compose_file" down 2>/tmp/simpleagro_docker_compose_down_error.log; then
            echo "[sastop] Falha ao executar 'docker compose down'. Ver /tmp/simpleagro_docker_compose_down_error.log" >&2
            sed -n '1,200p' /tmp/simpleagro_docker_compose_down_error.log >&2 || true
        else
            echo "[sastop] Compose derrubado (se estava ativo)."
        fi
    else
        echo "[sastop] Nenhum arquivo docker-compose encontrado em $compose_dir, pulando compose down."
    fi

    # Kill node processes for projects
    kill_by_cwd "$base_path$adonis_path"
    kill_by_cwd "$base_path$painel_path"

    # Optional: remove temporary pid/log files
    rm -f /tmp/simpleagro_*.pid || true

    echo "[sastop] Operação concluída. Verifique logs em /tmp (se houver)."
}

main "$@"

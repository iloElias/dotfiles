#!/usr/bin/env bash

set -euo pipefail

work_container_name="pyapi-work-local"
lab_container_name="pyapi-lab-local"
router_container_name="pyapi-router-local"
legacy_container_name="pyapi-local"
painel_dir="/home/murilo-elias/projects/simple-work-painel"

kill_by_cwd() {
    local dir="$1"
    local found=0

    for pid_path in /proc/[0-9]*; do
        local pid=${pid_path#/proc/}
        if [ -L "$pid_path/cwd" ]; then
            local cwd
            cwd=$(readlink -f "$pid_path/cwd" 2>/dev/null || true)
            if [ "$cwd" = "$dir" ]; then
                found=1
                kill -TERM "$pid" 2>/dev/null || true
            fi
        fi
    done

    sleep 2

    for pid_path in /proc/[0-9]*; do
        local pid=${pid_path#/proc/}
        if [ -L "$pid_path/cwd" ]; then
            local cwd
            cwd=$(readlink -f "$pid_path/cwd" 2>/dev/null || true)
            if [ "$cwd" = "$dir" ]; then
                kill -KILL "$pid" 2>/dev/null || true
            fi
        fi
    done

    if [ "$found" -eq 1 ]; then
        echo "[swapistop] Processos do painel finalizados (cwd=$dir)."
    else
        echo "[swapistop] Nenhum processo do painel encontrado (cwd=$dir)."
    fi
}

main() {
    echo "[swapistop] Parando containers da API (work/lab/router)..."
    docker rm -f "$router_container_name" >/dev/null 2>&1 || true
    docker rm -f "$work_container_name" >/dev/null 2>&1 || true
    docker rm -f "$lab_container_name" >/dev/null 2>&1 || true
    docker rm -f "$legacy_container_name" >/dev/null 2>&1 || true

    echo "[swapistop] Parando processos do painel..."
    kill_by_cwd "$painel_dir"

    echo "[swapistop] Serviços parados."
}

main "$@"

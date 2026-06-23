#!/bin/bash

# Inicia os dois projetos Node usando a versão correta do Node (via nvm)
# - Adonis API: Node 12 -> `npm run start:dev`
# - Simpleagro Painel: Node 14 -> `npm run start`
# Se o projeto tiver `.nvmrc`, essa versão terá prioridade.

set -euo pipefail

base_path="/home/murilo-elias/projects"

mongodb_path="/mongo"
adonis_path="/simpleagro-api-adonis"
painel_path="/simpleagro_paineladm"

# Defaults (usados se não houver .nvmrc)
adonis_default_node="12"
painel_default_node="14"

NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

start_service() {
	local name="$1"; local dir="$2"; local default_node="$3"; local npm_cmd="$4"; local log="$5"

	if [ ! -d "$dir" ]; then
		echo "[start-simpleagro] diretório não encontrado: $dir" >&2
		return 1
	fi

	if [ -f "$dir/.nvmrc" ]; then
		node_version=$(cat "$dir/.nvmrc" | tr -d " \n\r")
	else
		node_version="$default_node"
	fi

	runner="export NVM_DIR=\"$NVM_DIR\"; [ -s \"$NVM_DIR/nvm.sh\" ] && . \"$NVM_DIR/nvm.sh\"; \
		echo \"[start-simpleagro][$name] Usando NVM_DIR=$NVM_DIR\"; \
		if nvm --version >/dev/null 2>&1; then \
			echo \"[start-simpleagro][$name] nvm disponível\"; \
		else \
			echo \"[start-simpleagro][$name] nvm não encontrado; continuando (pode falhar)\"; \
		fi; \
		nvm install $node_version >/tmp/simpleagro_nvm_${name}_install.log 2>&1 || true; \
		nvm use $node_version >/tmp/simpleagro_nvm_${name}_use.log 2>&1 || true; \
		echo \"[start-simpleagro][$name] node versão: \$(node -v 2>/dev/null || echo 'nenhuma')\"; \
		cd \"$dir\"; \n+        echo \"[start-simpleagro][$name] Executando: $npm_cmd\"; \
		$npm_cmd"

	nohup bash -lc "$runner" >"$log" 2>&1 &
	pid=$!
	echo "[start-simpleagro] Iniciado $name (node $node_version) em $dir — PID $pid — log: $log"
	echo "[start-simpleagro] Para depurar nvm: /tmp/simpleagro_nvm_${name}_install.log and /tmp/simpleagro_nvm_${name}_use.log"
}

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

main() {
	compose_dir="$base_path$mongodb_path"
	if compose_file=$(find_compose_file "$compose_dir"); then
		echo "[start-simpleagro] Encontrado compose: $compose_file — levantando containers..."
		if ! docker compose -f "$compose_file" up -d 2>/tmp/simpleagro_docker_compose_error.log; then
			echo "[start-simpleagro] Falha ao levantar containers com docker compose. Ver /tmp/simpleagro_docker_compose_error.log" >&2
			echo "[start-simpleagro] Saída do erro:" >&2
			sed -n '1,200p' /tmp/simpleagro_docker_compose_error.log >&2 || true
			echo "[start-simpleagro] Continuando sem interromper o script." >&2
		else
			echo "[start-simpleagro] Mongo levantado (compose: $compose_file)."
		fi
	else
		echo "[start-simpleagro] Nenhum arquivo docker-compose encontrado em $compose_dir, pulando Mongo."
	fi

	start_service "adonis" "$base_path$adonis_path" "$adonis_default_node" "npm run start:dev" "/tmp/simpleagro_adonis.log"

	start_service "painel" "$base_path$painel_path" "$painel_default_node" "npm run start" "/tmp/simpleagro_painel.log"

	echo "[start-simpleagro] Todos os serviços solicitados foram iniciados (logs em /tmp)."
}

main "$@"

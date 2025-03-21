#!/usr/bin/env bash

# alias

alias ll='ls -alF --color=auto --group-directories-first'
alias la='ls -A --color=auto --group-directories-first'
alias l='ls -CF --color=auto --group-directories-first'

alias update='/opt/dotfiles/config/update.sh'
alias update-rc='/opt/dotfiles/config/update-rc.sh'

alias ipecomposerup='cd /opt/sources/docker-v2/infra && docker compose up -d'
alias ipeclear='docker exec -it php74 bash -c "redis-cli flushall"'

alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

alias cls='clear'
alias ccat='pygmentize -g'
alias code='code-insiders'
alias nav='google-chrome'

alias here='/bin/gnome-terminal --working-directory=$(pwd)'
alias new="/bin/gnome-terminal --working-directory=\$HOME"

alias cdi='cd /opt/sources/'
alias cdipe='cd /opt/sources/'
alias cdm='cd /opt/mapdata/'
alias cdaf='cd /opt/agrofast/'
alias cds='cd /opt/services/'
alias cdd='cd /opt/dotfiles/'

E() {
  echo -n "Confirm action? (Y/n) "
  read confirm
  if [[ -z "$confirm" || "$confirm" =~ ^[Yy] ]]; then
    exit 0
  else
    echo "Canceled exit."
  fi
}
alias e='E'

alias agfcomposerup='cd /opt/agrofast/ && docker compose up -d'
alias files='xdg-open ./'

alias commit='git commit -m'
alias check='git checkout'
alias checkout='git checkout'
alias checkmaster='git checkout master'
alias gmaster='git checkout master'
alias gmain='git checkout main'
alias push='git push'
alias vpush='/opt/dotfiles/scripts/push-with-verifications.sh'
alias status='/opt/dotfiles/scripts/status-all-from-repo.sh'
alias pull='/opt/dotfiles/scripts/pull-all-from-repo.sh'
alias gadd='git add .'
alias clone='git clone'

myip() {
  /opt/dotfiles/scripts/my-ip.sh
}

alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'
alias up='docker compose up'
alias up-d='docker compose up -d'
alias up-b='docker compose up --build'
alias build='docker compose up --build'

# Comandos utilitários para desenvolvimento com docker
alias dbcls='/opt/dotfiles/scripts/reset-database.sh'

alias docker-stop-all='/opt/dotfiles/scripts/stop-all-containers.sh'
alias ds='docker-stop-all'
alias down='docker-stop-all'
alias docker-remove-all='/opt/dotfiles/scripts/remove-all-containers.sh'

# variables
export DOCKER_HOST=unix:///run/docker.sock
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH=$PATH:/usr/share/dotnet
export PATH=$PATH:~/godot
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

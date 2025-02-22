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

alias cls='clear'
alias code='code-insiders'
alias nav='google-chrome'
alias here='gnome-terminal'
alias cdi='cd /opt/sources/'
alias cdipe='cd /opt/sources/'

alias cdm='cd /opt/mapdata/'
alias agfcomposerup='cd /opt/agrofast/ && docker compose up -d'
alias cdaf='cd /opt/agrofast/'
alias files='xdg-open ./'

alias commit='git commit -m'
alias checkout='git checkout'
alias checkmaster='git checkout master'
alias push='git push'
alias pull='/opt/dotfiles/scripts/pull-all-from-repo.sh'
alias gadd='git add .'
alias clone='git clone'

myip() {
  hostname -I | awk '{print $1}'
}

alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'
alias up='docker compose up'
alias up-d='docker compose up -d'
alias detach='docker compose up -d'
alias up-b='docker compose up --build'
alias build='docker compose up --build'

# alias docker-stop-all='docker stop $(docker ps -q)'
alias docker-stop-all='/opt/dotfiles/scripts/stop-all-containers.sh'
alias down='docker-stop-all'
alias docker-remove-all='/opt/dotfiles/scripts/remove-all-containers.sh'

# variables
export DOCKER_HOST=unix:///run/docker.sock
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH=$PATH:/usr/share/dotnet
export PATH=$PATH:~/godot

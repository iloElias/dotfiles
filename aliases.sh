#!/usr/bin/env bash

# alias

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias update='$HOME/dot-files/config/update.sh'

alias ipecomposerup='cd /opt/sources/docker-v2/infra && docker compose up -d'
alias cls='clear'
alias code='code-insiders'
alias nav='google-chrome'
alias here='gnome-terminal'
alias cdi='cd /opt/sources/'
alias cdipe='cd /opt/sources/'

alias cdm='cd /opt/mapdata/'
alias checkmaster='git checkout master'
alias agfcomposerup='cd ~/source/projects/agrofast && docker compose up -d'
alias cdaf='cd ~/source/projects/agrofast/'
alias files='xdg-open ./'

alias commit='git commit -m'
alias push='git push'
alias pull='git pull'
alias gadd='git add .'
alias clone='git clone'

alias up='docker compose up'
alias up-d='docker compose up -d'
alias up-b='docker compose up --build'

# alias docker-stop-all='docker stop $(docker ps -q)'
alias docker-stop-all='$HOME/dot-files/scripts/stop-all-containers.sh'
alias down='docker-stop-all'
alias docker-remove-all='$HOME/dot-files/scripts/remove-all-containers.sh'

# variables
export DOCKER_HOST=unix:///run/docker.sock
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH=$PATH:/usr/share/dotnet
export PATH=$PATH:~/godot

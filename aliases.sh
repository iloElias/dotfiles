#!/usr/bin/env bash

# alias

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ipecomposerup='cd /opt/sources/docker-v2/infra && docker compose up -d'
alias cls='clear'
alias code='code-insiders'
alias nav='google-chrome'
alias here='gnome-terminal'
alias cdi='cd /opt/sources/'
alias cdipe='cd /opt/sources/'
alias checkmaster='git checkout master'
alias agfcomposerup='cd ~/source/projects/agrofast && docker compose up -d'
alias cdaf='cd ~/source/projects/agrofast/'
alias files='xdg-open ./'

# variables

export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH=$PATH:/usr/share/dotnet
export PATH=$PATH:~/godot

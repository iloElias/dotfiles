#!/usr/bin/env bash

source $HOME/dotfiles/lib/utils.sh

# alias

alias ll='ls -alF --color=auto --group-directories-first'
alias la='ls -A --color=auto --group-directories-first'
alias l='ls -CF --color=auto --group-directories-first'

alias update='$HOME/dotfiles/config/update.sh'
alias update-rc='$HOME/dotfiles/config/update-rc.sh'

alias ipecomposerup='cd /opt/sources/docker-v2/infra && docker compose --profile dev up -d && exit'
alias ipeclear='docker exec -it php74 bash -c "redis-cli flushall"'
alias iperedisip='docker inspect php74 | grep "IPAddress"'

alias sastart='$HOME/dotfiles/scripts/start-simpleagro.sh'
alias sastop='$HOME/dotfiles/scripts/stop-simpleagro.sh'
alias swapistart='$HOME/dotfiles/scripts/start-simple-work-api.sh'
alias swapistop='$HOME/dotfiles/scripts/stop-simple-work-api.sh'

alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

alias cls='clear'
alias clr='clear'
alias ccat='pygmentize -g'
alias code='code-insiders --disable-gpu'
alias nav='google-chrome'

alias here='/bin/gnome-terminal --working-directory=$(pwd)'
alias new="/bin/gnome-terminal --working-directory=\$HOME"

alias ccd='$HOME/dotfiles/scripts/custom-cd.sh'

alias cdi='$HOME/dotfiles/scripts/custom-cd.sh /opt/sources'
alias cdipe='cd /opt/sources/'
alias cdm='cd /opt/mapdata/'
alias cdaf='cd /opt/agrofast/'
alias cds='cd /opt/services/'
alias cdd='cd $HOME/dotfiles/'

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

alias agfcomposerup='cd /opt/agrofast/ && docker compose up -d && exit'
alias files='xdg-open ./'

# Display configuration
alias display='$HOME/dotfiles/scripts/display.sh'
alias fix-display='$HOME/dotfiles/scripts/fix-displays.sh'

alias gcusername='git config user.name iloElias'
alias gcwork='gcusername && git config user.email "muriloelias@ipeweb.com.br"'
alias gcpers='gcusername && git config user.email "murilo7456@gmail.com"'
alias commit='git commit -m'
alias check='git checkout'
alias checkout='git checkout'
alias checkmaster='git checkout master'
alias gmaster='git checkout master'
alias gmain='git checkout main'
alias push='git push'
alias vpush='$HOME/dotfiles/scripts/push-with-verifications.sh'
alias status='$HOME/dotfiles/scripts/status-all-from-repo.sh'
alias pull='$HOME/dotfiles/scripts/pull-all-from-repo.sh'
alias gadd='git add .'
alias clone='git clone'

alias myip='$HOME/dotfiles/scripts/my-ip.sh'

alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'
alias up='docker compose up'
alias up-d='docker compose up -d'
alias up-b='docker compose up --build'
alias build='docker compose up --build'
alias dexec='docker exec -it'

# Comandos utilitários para desenvolvimento com docker
alias dbcls='$HOME/dotfiles/scripts/reset-database.sh'

alias docker-stop-all='$HOME/dotfiles/scripts/stop-all-containers.sh'
alias ds='docker-stop-all'
alias down='docker-stop-all'
alias docker-remove-all='$HOME/dotfiles/scripts/remove-all-containers.sh'

# Comandos utilitários para checagem de processos
alias ports='netstat -tuln'

# variables
export DOCKER_HOST=unix:///run/docker.sock
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
export PATH=$PATH:/usr/share/dotnet
export PATH=$PATH:~/godot
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH=$PATH:/usr/local/go/bin
export CAPACITOR_ANDROID_STUDIO_PATH="$HOME/.local/share/JetBrains/Toolbox/apps/AndroidStudio/ch-0/242.23339.11.2421.12550806"

export ANDROID_HOME="$HOME/Android/Sdk"
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

export DOTNET_ROOT=/usr/lib/dotnet
export PATH=$PATH:$DOTNET_ROOT

export JAVA_HOME="/usr/lib/jvm/jdk-25.0.4.1+1"

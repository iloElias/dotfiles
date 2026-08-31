#!/usr/bin/env bash

sudo apt install nodejs npm

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/refs/heads/master/install.sh | bash

nvm install 23

node -v

npm -v

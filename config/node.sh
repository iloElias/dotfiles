#!/usr/bin/env bash

sudo apt isntall nodejs npm

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

nvm install 23

node -v

npm -v

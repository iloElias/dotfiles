#!/usr/bin/env bash

sudo apt isntall nodejs npm

sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

sudo nvm install 20

echo "Node version:"
node -v

echo "Npm version:"
npm -v
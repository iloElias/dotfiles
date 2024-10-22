#!/usr/bin/env bash

echo "-------------------------------------";
echo "|     Getting latests updates...    |";
echo "-------------------------------------";
./config/update.sh

echo "-------------------------------------";
echo "|        Installing Chrome...       |";
echo "-------------------------------------";
./config/php.sh

echo "-------------------------------------";
echo "|   Setting up the environment...   |";
echo "-------------------------------------";
./create-source.sh

echo "-------------------------------------";
echo "|         Installing PHP...         |";
echo "-------------------------------------";
./config/php.sh

echo "-------------------------------------";
echo "|       Installing Composer...      |";
echo "-------------------------------------";
./config/composer.sh

echo "-------------------------------------";
echo "|        Installing Docker...       |";
echo "-------------------------------------";
./config/docker.sh

echo "-------------------------------------";
echo "|         Installing Node...        |";
echo "-------------------------------------";
./config/node.sh

echo "-------------------------------------";
echo "|        Installing VSCode...       |";
echo "-------------------------------------";
./config/vscode.sh

echo "-------------------------------------";
echo "|       Setting up terminal...      |";
echo "-------------------------------------";
./config/jetbrains-toolbox.sh

echo "-------------------------------------";
echo "|       Setting up terminal...      |";
echo "-------------------------------------";
./config/terminal.sh

cp ./.inputrc ~/
bind -f ~/.inputrc

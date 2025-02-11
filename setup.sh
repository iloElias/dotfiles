#!/usr/bin/env bash

export DOTFILES=/opt/dotfiles

echo "-------------------------------------";
echo "|     Getting latests updates...    |";
echo "-------------------------------------";
$DOTFILES/config/update.sh

echo "-------------------------------------";
echo "|        Installing Chrome...       |";
echo "-------------------------------------";
$DOTFILES/config/php.sh

echo "-------------------------------------";
echo "|         Installing PHP...         |";
echo "-------------------------------------";
$DOTFILES/config/php.sh

echo "-------------------------------------";
echo "|       Installing Composer...      |";
echo "-------------------------------------";
$DOTFILES/config/composer.sh

echo "-------------------------------------";
echo "|        Installing Docker...       |";
echo "-------------------------------------";
$DOTFILES/config/docker.sh

echo "-------------------------------------";
echo "|         Installing Node...        |";
echo "-------------------------------------";
$DOTFILES/config/node.sh

echo "-------------------------------------";
echo "|        Installing VSCode...       |";
echo "-------------------------------------";
$DOTFILES/config/vscode.sh

echo "-------------------------------------";
echo "|       Setting up terminal...      |";
echo "-------------------------------------";
$DOTFILES/config/jetbrains-toolbox.sh

echo "-------------------------------------";
echo "|       Setting up terminal...      |";
echo "-------------------------------------";
$DOTFILES/config/terminal.sh

cp $DOTFILES/.inputrc ~/
bind -f $HOME/.inputrc

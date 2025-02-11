#!/usr/bin/env bash

export DOTFILES=/opt/dotfiles

$DOTFILES/config/update.sh

sudo apt install git curl zsh fonts-firacode

chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

mkdir $HOME/.fonts

cp /opt/dotfiles/fonts/MesloLGSNF.zip $HOME/.fonts/MesloLGSNF.zip

unzip $HOME/.fonts/MesloLGSNF.zip -d $HOME/.fonts

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

cp /opt/dotfiles/.zshrc $HOME/.zshrc

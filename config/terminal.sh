#!/usr/bin/env bash

export DOTFILES=$HOME/dotfiles

$DOTFILES/config/update.sh

sudo apt install git curl zsh fonts-firacode -y

read -r "change_shell?Change default shell to zsh? (y/N) "
[[ "$change_shell" =~ ^[Yy]$ ]] && chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

mkdir $HOME/.fonts

cp $HOME/dotfiles/fonts/MesloLGSNF.zip $HOME/.fonts/MesloLGSNF.zip

unzip $HOME/.fonts/MesloLGSNF.zip -d $HOME/.fonts

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

read -r "copy_zshrc?Substituir .zshrc do usuário? (y/N) "
[[ "$copy_zshrc" =~ ^[Yy]$ ]] && cp $HOME/.zshrc $HOME/dotfiles/temp/.zshrc && cp $HOME/dotfiles/.zshrc $HOME/.zshrc

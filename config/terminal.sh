#!/usr/bin/env bash

export DOTFILES=$HOME/dot-files

$DOTFILES/config/update.sh

sudo apt install git curl zsh fonts-firacode

chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

echo "
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions" >> $HOME/.zshrc

mkdir $HOME/.fonts

cp $HOME/dot-files/fonts/MesloLGSNF.zip $HOME/.fonts/MesloLGSNF.zip

unzip $HOME/.fonts/MesloLGSNF.zip -d $HOME/.fonts

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

cp $HOME/dot-files/.zshrc $HOME/.zshrc

gnome-session-quit --logout --no-prompt

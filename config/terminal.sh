#!/usr/bin/env bash

./update.sh

sudo apt install git curl zsh fonts-firacode

chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

echo "
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions" >>~/.zshrc

mkdir ~/.fonts

cp ~/dot-files/fonts/MesloLGSNF.zip ~/.fonts/MesloLGSNF.zip

unzip ~/.fonts/MesloLGSNF.zip -d ~/.fonts

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

cp ~/dot-files/.zshrc ~/.zshrc

gnome-session-quit --logout --no-prompt

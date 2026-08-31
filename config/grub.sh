#!/usr/bin/env bash

cd /tmp || (echo "Failed to change directory to /tmp" && exit 1)

git clone https://github.com/vinceliuice/Elegant-grub2-themes.git

cd Elegant-grub2-themes || (echo "Failed to change directory to /tmp/Elegant-grub2-themes" && exit 1)

sudo ./install.sh -b -t forest -p window -i left -c dark -s 1080p

cd "$HOME/dotfiles" || (echo "Failed to change directory to ~/dotfiles" && exit 1)

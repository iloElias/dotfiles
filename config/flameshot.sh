#!/usr/bin/env bash

sudo apt install flameshot

echo "Flameshot has been installed successfully."

echo "Run the command 'sudo nano /etc/gdm3/custom.conf' than uncomment the line 'WaylandEnable=false'"
echo "Now use 'flameshot gui' on settings to configure the application."
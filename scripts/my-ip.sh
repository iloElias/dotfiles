#!/bin/bash

echo "IP address: "
hostname -I | awk '{print $1}'
echo -e "\nQR code:"
qrencode -t ansiutf8 "http://$(hostname -I | awk '{print $1}')"
echo -e "\n"

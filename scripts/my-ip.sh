#!/bin/bash

# Retrieve the IP address
IP=$(hostname -I | awk '{print $1}')

# Use first argument as port (if provided)
PORT="$1"

echo "IP address: $IP"
if [ -n "$PORT" ]; then
  echo "Port: $PORT"
fi

echo -e "\nQR code:"
if [ -n "$PORT" ]; then
  qrencode -t ansiutf8 "http://${IP}:${PORT}"
else
  qrencode -t ansiutf8 "http://${IP}"
fi

echo -e "\n"

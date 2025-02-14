#!/bin/bash

git pull

if [ -d "./config" ] && [ -f "./config/pull.sh" ]; then
  bash "./config/pull.sh"
fi

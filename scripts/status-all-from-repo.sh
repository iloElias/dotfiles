#!/bin/bash

git status

if [ -d "./config" ] && [ -f "./config/status.sh" ]; then
  bash "./config/status.sh"
fi

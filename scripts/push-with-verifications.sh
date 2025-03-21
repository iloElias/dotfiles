#!/bin/bash

branch=$(git rev-parse --abbrev-ref HEAD)

if git ls-remote --exit-code --heads origin "$branch" &>/dev/null; then
  echo "Remote branch '$branch' exists. Pushing normally..."
  git push
else
  echo "Remote branch '$branch' does not exist. Pushing and setting upstream..."
  git push --set-upstream origin "$branch"
fi

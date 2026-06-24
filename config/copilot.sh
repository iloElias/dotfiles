#!/usr/bin/env bash

set -euo pipefail

DOTFILES=${DOTFILES:-/opt/dotfiles}

mkdir -p "$HOME/.copilot/instructions"
mkdir -p "$HOME/.copilot/skills"

cp -f "$DOTFILES/editors/copilot/instructions/"*.instructions.md "$HOME/.copilot/instructions/"

# Copy each skill directory so Copilot can discover SKILL.md by folder.
if [ -d "$DOTFILES/editors/copilot/skills" ]; then
  for skill_dir in "$DOTFILES/editors/copilot/skills"/*; do
    [ -d "$skill_dir" ] || continue
    skill_name=$(basename "$skill_dir")
    mkdir -p "$HOME/.copilot/skills/$skill_name"
    cp -Rf "$skill_dir/"* "$HOME/.copilot/skills/$skill_name/"
  done
fi

echo "Copilot global instructions and skills synced to $HOME/.copilot"

#!/bin/bash

base_path="$(pwd)"
prefix=""
open_in="vscode"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --cu)
      open_in="cursor"
      shift
      ;;
    *)
      if [[ -z "$base_path_set" ]]; then
        base_path="$1"
        base_path_set=1
      elif [[ -z "$prefix_set" ]]; then
        prefix="$1"
        prefix_set=1
      fi
      shift
      ;;
  esac
done

if ! command -v dialog &>/dev/null; then
  echo "The dialog utility is not installed."
  read -rp "Do you want to install it now? (Y/n): " answer
  if [[ -z "$answer" || "$answer" =~ ^[Yy]$ ]]; then
    if command -v apt-get &>/dev/null; then
      sudo apt-get update && sudo apt-get install -y dialog
    elif command -v yum &>/dev/null; then
      sudo yum install -y dialog
    else
      echo "No supported package manager found. Please install dialog manually."
      exit 1
    fi
    if ! command -v dialog &>/dev/null; then
      echo "Installation failed. Exiting."
      exit 1
    fi
  else
    echo "Dialog is required. Exiting."
    exit 1
  fi
fi

projects=()

for dir in "$base_path"/*; do
  if [ -d "$dir" ]; then
    base=$(basename "$dir")
    if [ -d "$dir/.git" ] || [ -f "$dir/.git" ]; then
      if [ -z "$prefix" ] || [[ "$base" == "$prefix"* ]]; then
        projects+=("$dir" "$base")
      fi
    else
      for sub in "$dir"/*; do
        if [ -d "$sub" ]; then
          sub_base=$(basename "$sub")
          if [ -d "$sub/.git" ] || [ -f "$sub/.git" ]; then
            if [ -z "$prefix" ] || [[ "$sub_base" == "$prefix"* ]]; then
              projects+=("$sub" "$sub_base")
            fi
          fi
        fi
      done
    fi
  fi
done

if [ ${#projects[@]} -eq 0 ]; then
  if [ -n "$prefix" ]; then
    echo "No projects found in $base_path starting with '$prefix'."
  else
    echo "No projects found in $base_path."
  fi
  exit 1
fi

temp_file=$(mktemp)

dialog --clear --title "Project Selection" \
  --menu "Select a project to work on:" 20 70 8 \
  "${projects[@]}" 2>"$temp_file"

ret_code=$?
selected_project=$(<"$temp_file")
rm -f "$temp_file"
cd "$selected_project" || exit

if [ $ret_code -eq 0 ] && [ -n "$selected_project" ]; then 
  cd "$selected_project" || exit

  dialog --clear --title "Open in Editor?" \
    --yesno "Open in $( [[ $open_in = "cursor" ]] && echo 'Cursor' || echo 'VSCode' )?" 5 40
  open_editor=$?

  if [ $open_editor -eq 0 ]; then
    if [[ "$open_in" = "cursor" ]]; then
      if command -v cursor &>/dev/null; then
        cursor .
      else
        echo "'cursor' editor is not installed or not found in PATH."
      fi
    else
      code-insiders .
    fi
  fi

  clear
fi

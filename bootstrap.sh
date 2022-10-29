#!/bin/bash

# TODO: check and create dependencies

declare -r XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"
declare -r XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

declare -r NVIM_CACHE_HOME="${NVIM_CACHE_HOME:-"$XDG_CACHE_HOME/nvim"}"
declare -r NVIM_CONFIG_DIR="${NVIM_CONFIG_DIR:-"$XDG_CONFIG_HOME/nvim"}"

declare -r NVIM_SWAP_DIR="${NVIM_SWAP_DIR:-"$NVIM_CACHE_HOME/swap"}"
declare -r NVIM_UNDO_DIR="${NVIM_UNDO_DIR:-"$NVIM_CACHE_HOME/undo"}"
declare -r NVIM_BACKUP_DIR="${NVIM_BACKUP_DIR:-"$NVIM_CACHE_HOME/backup"}"

declare -a __cache_dirs=(
  "$NVIM_SWAP_DIR"
  "$NVIM_UNDO_DIR"
  "$NVIM_BACKUP_DIR"
)

function detect_platform() {
  OS="$(uname -s)"
  case "$OS" in
    Linux)
      RECOMMEND_INSTALL="sudo apt inistall -y"
      ;;
    Darwin)
      RECOMMEND_INSTALL="brew install"
      ;;
    *)
      echo "OS $OS is not currently supported."
      exit 1
      ;;
  esac
}

function msg() {
  local text="$1"
  local div_width="80"
  printf "%${div_width}s\n" ' ' | tr ' ' -
  printf "%s\n" "$text"
}

function print_missing_dep_msg() {
  if [ "$#" -eq 1 ]; then
    echo "[ERROR]: Unable to find dependency [$1]"
    echo "Please install it first and re-run the installer. Try: $RECOMMEND_INSTALL $1"
  else
    local cmds
    cmds=$(for i in "$@"; do echo "$RECOMMEND_INSTALL $i"; done)
    printf "[ERROR]: Unable to find dependencies [%s]" "$@"
    printf "Please install any one of the dependencies and re-run the installer. Try: \n%s\n" "$cmds"
  fi
}

function check_neovim_min_version() {
  local verify_version_cmd='if !has("nvim-0.7") | cquit | else | quit | endif'

  # exit with an error if min_version not found
  if ! nvim --headless -u NONE -c "$verify_version_cmd"; then
    echo "[ERROR]: requires at least Neovim v0.7 or higher"
    exit 1
  fi
}

function check_system_deps() {
  if ! command -v git &>/dev/null; then
    print_missing_dep_msg "git"
    exit 1
  fi

  if ! command -v nvim &>/dev/null; then
    print_missing_dep_msg "neovim"
    exit 1
  fi

  check_neovim_min_version
}

function verify_cache_dirs() {
  for dir in "${__cache_dirs[@]}"; do
    if [ ! -d "$dir" ]; then
      mkdir -p "$dir"
      msg "Create cache directory:<$dir> complete."
    fi
  done
}

function main() {
  msg "Detecting platform for managing any additional neovim dependencies"
  detect_platform

  check_system_deps

  verify_cache_dirs
  msg "Nvim bootstrap had completed."
}

main

#!/bin/bash

declare -r XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

declare -r NVIM_CONFIG_DIR="${NVIM_CONFIG_DIR:-"$XDG_CONFIG_HOME/nvim"}"

declare -a __optional_deps=(
  "fd::fd"
  "fzf::fzf"
  "rg::ripgrep"
  "lazygit::lazygit"
)

function detect_platform() {
  OS="$(uname -s)"
  case "$OS" in
    Linux)
      if [ -f "/etc/arch-release" ] || [ -f "/etc/artix-release" ]; then
        RECOMMEND_INSTALL="sudo pacman -S"
      elif [ -f "/etc/fedora-release" ] || [ -f "/etc/redhat-release" ]; then
        RECOMMEND_INSTALL="sudo dnf install -y"
      elif [ -f "/etc/gentoo-release" ]; then
        RECOMMEND_INSTALL="emerge -tv"
      else # assume debian based
        RECOMMEND_INSTALL="sudo apt install -y"
      fi
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
  # local div_width="80"
  # printf "%${div_width}s\n" ' ' | tr ' ' -
  printf "%s\n" "$text"
}

function print_missing_dep_msg() {
  if [ "$#" -eq 1 ]; then
    echo "Unable to find dependency [$1]"
    echo "Please install it first and re-run the installer. Try: $RECOMMEND_INSTALL $1"
  else
    local cmds
    cmds=$(for i in "$@"; do echo "$RECOMMEND_INSTALL $i"; done)
    printf "Unable to find dependencies [%s]" "$@"
    printf "Please install any one of the dependencies and re-run the installer. Try: \n%s\n" "$cmds"
  fi
}

function check_neovim_min_version() {
  local verify_version_cmd='if !has("nvim-0.9") | cquit | else | quit | endif'

  # exit with an error if min_version not found
  if ! nvim --headless -u NONE -c "$verify_version_cmd"; then
    echo "[ERROR]: Requires at least Neovim v0.9 or higher"
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

function setup_nvim() {
  echo "Preparing Lazy setup"

  nvim -u "$NVIM_CONFIG_DIR/init.lua" --headless -c 'quitall'
}

function check_optional_deps() {
  for dep in "${__optional_deps[@]}"; do
    if ! command -v "${dep%%::*}" &>/dev/null; then
      print_missing_dep_msg "${dep##*::}"
    fi
  done
}

function main() {
  msg "Bootstrap..."

  detect_platform

  check_system_deps

  check_optional_deps

  setup_nvim

  msg "Nvim bootstrap had completed."
}

main

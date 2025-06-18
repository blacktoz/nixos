#! /bin/sh

USER_NAME="keiwop"
CFG_DIR=/_/etc/nixos
DOT_DIR=${CFG_DIR}/dotfiles
NIX_DIR=${CFG_DIR}/nix

echo -e "\n--------------------------------------------------------------------------------"
echo -e "nix_init: Linking configurations files where they are needed"

if [[ -d $NIX_DIR ]]; then
    echo "🔗 Stowing $NIX_DIR"
    stow --restow --dir="$NIX_DIR" --target=/etc/nixos/ .
fi

if [[ -d $DOT_DIR ]]; then
    echo "🔗 Stowing $DOT_DIR"
    sudo -u $USER_NAME stow --restow --dotfiles --dir="$DOT_DIR" --target=/home/$USER_NAME/ .
fi

echo -e "\n--------------------------------------------------------------------------------\n"

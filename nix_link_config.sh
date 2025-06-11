#! /bin/sh

USER="keiwop"
CFG_DIR=/_/etc/nixos
DOT_DIR=${CFG_DIR}/dotfiles
NIX_DIR=${CFG_DIR}/nix


if [[ -d $NIX_DIR ]]; then
    echo "Stowing $NIX_DIR"
    stow --restow --dir="$NIX_DIR" --target=/etc/nixos/ .
fi

if [[ -d $DOT_DIR ]]; then
    echo "Stowing $DOT_DIR"
    sudo -u $USER stow --restow --dotfiles --dir="$DOT_DIR" --target=/home/$USER/ .
fi

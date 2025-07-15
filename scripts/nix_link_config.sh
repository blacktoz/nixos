#! /bin/sh
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>


USER_NAME="keiwop"
CFG_DIR=/_/etc/nixos
DOT_DIR=${CFG_DIR}/dotfiles
NIX_DIR=${CFG_DIR}/nix

echo -e "\n--------------------------------------------------------------------------------\n"
echo -e "nix_init: Linking nixos configuration"

if [[ -d $NIX_DIR ]]; then
    echo "🔗 Stowing $NIX_DIR"
    stow --restow --no-folding --dir="$NIX_DIR" --target=/etc/nixos/ .
fi

echo -e "\nnix_init: Linking dotfiles"

if [[ -d $DOT_DIR ]]; then
    echo "🔗 Stowing $DOT_DIR"
    sudo -u $USER_NAME stow --restow --no-folding --dotfiles --dir="$DOT_DIR" --target=/home/$USER_NAME/ .
fi

echo -e "\n--------------------------------------------------------------------------------\n"

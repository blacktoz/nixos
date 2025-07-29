# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ pkgs, linked_paths }:

pkgs.writeShellScriptBin "link_config_files" ''
  #! /bin/sh

  handle_error(){
      if [ -z $1 ]; then
          printf "\n\n❌ Error: Empty source path\n"
          exit 1
      fi
      if [ -z $2 ]; then
          printf "\n\n❌ Error: Empty target path\n"
          exit 1
      fi
      if [ ! -d $1 ]; then
          printf "\n\n❌ Error: Source directory not found $1\n"
          exit 1
      fi
      printf "\n\n❌ Error: Failed to stow $1 <- $2\n"
      printf "Note: This script won't overwrite files already defined in $2\n"
      exit 1
  }

  printf "nix_init: Linking configuration files\n"

  ${
    builtins.concatStringsSep "\n" (
      builtins.map (
        path: let
          stow_cmd =
            (if path ? user && path.user != null && path.user != "root"
              then "sudo -u ${path.user} " else "")
            + "stow --restow --no-folding "
            + (if path ? dotfiles && path.dotfiles == true
              then "--dotfiles " else "")
            + "--dir='${path.source}' --target='${path.target}' .";
        in
          "printf '\\n🔗 Stowing ${path.source} <- ${path.target}\\n'\n"
          + stow_cmd + "\n"
          + "if [ $? -ne 0 ]; then handle_error ${path.source} ${path.target}; fi\n"
      ) linked_paths
    )
  }

  printf "\n\n✅ All files successfully linked\n"
''

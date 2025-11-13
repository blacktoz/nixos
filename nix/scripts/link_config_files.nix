# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ pkgs, linked_paths }:

pkgs.writeShellScriptBin "link_config_files" ''
  #! /bin/sh
  # SPDX-License-Identifier: GPL-3.0-or-later
  # Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>


  handle_error(){
      echo -e "\n❌ Error: Failed to stow $1 <- $2\n"
      echo "Note: This script won't overwrite files already defined in $2"
      exit 1
  }

  check_path(){
      if [ -z $1 ] || [ ! -d $1 ]; then
          echo -e "\n❌ Error: Directory not found -> $1\n"
          exit 1
      fi
  }


  printf "nix_init: Linking configuration files\n"

  ${ builtins.concatStringsSep "\n" ( builtins.map ( link:
    let
      link_as_user =  if link ? user && link.user != null && link.user != "root"
                      then "sudo -u ${link.user} "
                      else "";

      link_dotfiles = if link ? dotfiles && link.dotfiles == true
                      then " --dotfiles "
                      else " ";

      stow_cmd =  "${link_as_user}" +
                  "stow --restow --no-folding" +
                  "${link_dotfiles}" +
                  "--dir='${link.source}' --target='${link.target}' .";

      check_error_cmd = "if [ $? -ne 0 ]; then handle_error ${link.source} ${link.target}; fi";

      chown_as_user = if link ? user && link.user != null && link.user != "root"
                      then "chown -R ${link.user}:${link.user} ${link.target}"
                      else "";

    in
      ''
        echo -e "\n🔗 Stowing ${link.source} <- ${link.target}\n"
        check_path "${link.source}"
        if [ ! -e "${link.target}" ]; then
            mkdir -p ${link.target}
            ${chown_as_user}
        fi
        ${stow_cmd}
        ${check_error_cmd}
      ''
  ) linked_paths ) }

  printf "\n\n✅ All files successfully linked\n"
''

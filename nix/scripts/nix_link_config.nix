# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ pkgs, user_name, cfg_path }:

pkgs.stdenv.mkDerivation {
  name = "nix_link_config";
  version = "1.0";
  src = pkgs.lib.cleanSource "${cfg_path}/scripts/nix_link_config.sh";
  buildInputs = [ pkgs.stow ];
  buildCommand = ''
    mkdir -p $out/bin
    cp $src $out/bin/nix_link_config
    chmod +x $out/bin/nix_link_config
    substituteInPlace $out/bin/nix_link_config \
      --replace "USER_NAME=\"keiwop\"" "USER_NAME=\"${user_name}\"" \
      --replace "CFG_DIR=/_/etc/nixos" "CFG_DIR=\"${cfg_path}\""
  '';
}

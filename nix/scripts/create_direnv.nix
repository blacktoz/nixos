# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ pkgs, cfg_path }:

pkgs.stdenv.mkDerivation {
  name = "create_direnv";
  version = "1.0";
  src = pkgs.lib.cleanSource "${cfg_path}/scripts/create_direnv.sh";
  buildInputs = [ pkgs.direnv pkgs.findutils pkgs.gnused ];
  buildCommand = ''
    mkdir -p $out/bin
    cp $src $out/bin/create_direnv
    chmod +x $out/bin/create_direnv
    substituteInPlace $out/bin/create_direnv \
      --replace "SHELLS_PATH=\"/_/etc/nixos/nix/dev_shells\"" "SHELLS_PATH=\"${cfg_path}/nix/dev_shells\""
  '';
}

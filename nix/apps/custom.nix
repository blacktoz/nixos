# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ pkgs ? import <nixpkgs> {} }:

let
  termm = pkgs.callPackage ../packages/termm.nix { };                             # Get updated termm.nix from https://bitbucket.org/keiwop/termm_packaging
  kwin_focus_app = pkgs.callPackage ../packages/kwin_focus_app.nix { };           # Get updated kwin_focus_app.nix from https://bitbucket.org/keiwop/kwin_focus_app
  minichlink = pkgs.callPackage ../packages/minichlink.nix { };
  riscv32ec_toolchain = pkgs.callPackage ../packages/riscv32ec_toolchain.nix { };
  cursor = pkgs.callPackage ../packages/cursor.nix { };
  jellyfin_desktop = pkgs.callPackage ../packages/jellyfin_desktop.nix { };
in

{
  inherit termm kwin_focus_app minichlink riscv32ec_toolchain cursor jellyfin_desktop;
}

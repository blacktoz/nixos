# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ pkgs }:

let
  core = pkgs.callPackage ./apps/core.nix {};
  dev = pkgs.callPackage ./apps/dev.nix {};
  gui = pkgs.callPackage ./apps/gui.nix {};
  media = pkgs.callPackage ./apps/media.nix {};
  misc = pkgs.callPackage ./apps/misc.nix {};
  custom = pkgs.callPackage ./apps/custom.nix {};

  apps = rec {
    inherit core dev gui media misc custom;
    combine = app_groups: builtins.concatLists (map (group: apps.${group}) app_groups);
  };
in

apps

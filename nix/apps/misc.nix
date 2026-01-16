# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  # Misc packages
  f3
  sl
  cowsay
  fortune
  jellyfin-rpc
  android-tools
]

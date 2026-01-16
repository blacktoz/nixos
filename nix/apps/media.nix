# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  # Multimedia packages
  # jellyfin-media-player # Removed due to webkit vulnerabilities unpatched
  jellyfin-mpv-shim
  spotify
  audacity
  ffmpeg
  mkvtoolnix
  calibre

  (discord.override {
    withVencord = true; # can do this here too
  })

]

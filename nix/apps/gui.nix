# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  # GUI packages
  kdePackages.kate
  kdePackages.filelight
  vscodium
  gedit
  gparted
  evince
  cheese
  pulseview
  code-cursor
  gnome-calculator
  kicad-small
  gimp3

  # KDE
  kdePackages.kconfig
  kdotool

  # Hyprland
  wofi
  waybar
  hyprpaper
  networkmanagerapplet

  # Custom packages
  # termm
  # kwin_focus_app
]

# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  # GUI packages
  vscodium
  gedit
  gparted
  evince
  cheese
  pulseview
  gnome-calculator
  kicad-small
  gimp3
  inkscape
  vlc
  onlyoffice-desktopeditors
  heroic

  # Useful Utilities
  localsend
  libnotify
  simple-scan
  keepassxc


  # KDE
  kdePackages.kconfig
  kdotool
  kdePackages.kde-gtk-config
  kdePackages.kdeconnect-kde
  kdePackages.kate
  kdePackages.filelight
  kdePackages.qtstyleplugin-kvantum
  kdePackages.qtsvg
  kdePackages.qtimageformats
  kdePackages.qtmultimedia
  kdePackages.qt5compat
  kdePackages.qt6ct
  libsForQt5.qt5ct

  # Hyprland
  wofi
  waybar
  networkmanagerapplet
  kitty
  hyprpolkitagent
  hyprlock
  brightnessctl
  gammastep
  hypridle
  hyprpicker
  slurp
  grim
  swappy
  wl-clipboard
  pavucontrol
  libappindicator
  librsvg
  gdk-pixbuf
  adwaita-icon-theme
  papirus-icon-theme
  nwg-look
  playerctl
  grimblast
  satty
  ddcutil
  swww
  jq
  swaynotificationcenter
  bc
  anyrun



  # Themes
  (lib.hiPrio papirus-icon-theme)  # Icons
  papirus-folders     # Icons

  qogir-kde           # Plasma theme
  qogir-theme         # GTK theme

  bibata-cursors
]

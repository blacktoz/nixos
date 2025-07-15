# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    gcc
    gdb
    gnumake
    pkg-config
    udev
    libusb1
  ];


  shellHook = ''
    echo ""
    echo "Dev shell for `pwd` -> 🇨"
    echo "   • Language: C"
    echo "   • Version: $(gcc --version | head -n 1)"
    echo "   • Usage: gcc main.c"
    echo ""
  '';
}

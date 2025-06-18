# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    python3
    gtk4
    libadwaita
    gobject-introspection
    gtk4-layer-shell
    vte-gtk4

    (python3.withPackages (ps: with ps; [
      pygobject3
    ]))
  ];

  shellHook = ''
    export LD_PRELOAD=${pkgs.gtk4-layer-shell}/lib/libgtk4-layer-shell.so
    echo ""
    echo "Dev shell for `pwd` -> 🐍"
    echo "   • Language: Python GTK4"
    echo "   • Version: $(python3 --version)"
    echo "   • Usage: python3 -m waylayer.waylayer"
    echo ""
  '';
}

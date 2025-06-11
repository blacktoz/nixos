{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    gcc
    gdb
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

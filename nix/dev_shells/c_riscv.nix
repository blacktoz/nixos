{ pkgs ? import <nixpkgs> {} }:

let
  riscvPkgs = pkgs.pkgsCross.riscv32-embedded;
in
pkgs.mkShell {
  packages = with pkgs; [
    riscvPkgs.buildPackages.gcc
    riscvPkgs.buildPackages.gdb
    riscvPkgs.buildPackages.binutils
    riscvPkgs.newlib
    openocd
  ];


  shellHook = ''
    echo ""
    echo "Dev shell for `pwd` -> 🇨 ⚡️"
    echo "   • Language: C RISCV"
    echo "   • Version: $(riscv32-none-elf-gcc --version | head -n 1)"
    echo "   • Usage: riscv32-none-elf-gcc -march=rv32ec -mabi=ilp32e main.c"
    echo ""
  '';
}

{ pkgs ? import <nixpkgs> {} }:

let
  customCrossSystem = {
    config = "riscv32-none-elf";
    libc = "newlib-nano";
    gcc = {
      arch = "rv32ec";
      abi = "ilp32e";
    };
  };
  crossPkgs = import <nixpkgs> { crossSystem = customCrossSystem; };
in

pkgs.mkShell {
  nativeBuildInputs = [
    crossPkgs.buildPackages.gcc
    crossPkgs.buildPackages.binutils
  ];


  shellHook = ''
    echo ""
    echo "Dev shell for `pwd` -> 🇨"
    echo "   • Language: C RISCV"
    echo "   • Version: $(riscv32-none-elf-gcc --version | head -n 1)"
    echo "   • Usage: riscv32-none-elf-gcc -march=rv32ec -mabi=ilp32e main.c"
    echo ""
  '';
}

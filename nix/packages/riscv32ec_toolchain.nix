# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

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

pkgs.buildEnv {
  name = "riscv32ec-toolchain";

  paths = [
    crossPkgs.buildPackages.gcc
    crossPkgs.buildPackages.binutils
    pkgs.gnumake
  ];

  pathsToLink = [ "/bin" ];

  meta = {
    description = "Custom RISC-V toolchain for rv32ec with ilp32e ABI";
    license = pkgs.lib.licenses.gpl3;
  };
}

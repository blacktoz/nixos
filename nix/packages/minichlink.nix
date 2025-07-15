# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ pkgs ? import <nixpkgs> {} }:


pkgs.stdenv.mkDerivation rec {
  pname = "minichlink";
  version = "1.0-custom"; # Waiting for cnlohr to release a new version as latest one was incomplete and I cannot use master branch

  src = pkgs.fetchFromGitHub {
    owner = "cnlohr";
    repo = "ch32fun";
    # rev = "v${version}";
    rev = "21555f56402aa88d02842a03f9f9c1e42ad457f1";
    sha256 = "sha256-AuWFjJOlPVE75FJMgBkwqtNdU1vxkCmsqPH+AL8MujE=";
  };
  # src = pkgs.lib.cleanSource /_/git/ch32fun;

  buildInputs = [ 
    pkgs.gcc
    pkgs.libusb1
    pkgs.udev
  ];

  postPatch = ''
    substituteInPlace minichlink/99-minichlink.rules \
      --replace-fail "SUBSYSTEM==\"usb\"" "SUBSYSTEMS==\"usb\""
  '';

  buildPhase = ''
    cd minichlink
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp minichlink $out/bin/
    mkdir -p $out/lib/udev/rules.d
    cp minichlink.so $out/lib/
    cp 99-minichlink.rules $out/lib/udev/rules.d/
  '';

  meta = with pkgs.lib; {
    description = "Minimal programmer/debugger for WCH CH32V microcontrollers";
    homepage = "https://github.com/cnlohr/ch32fun";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

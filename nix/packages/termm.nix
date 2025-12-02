# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

# I install termm in my configuration.nix this way:
# environment.systemPackages = with pkgs; [
#   (pkgs.callPackage ./termm.nix {})
# ];

{ 
  lib,
  python3Packages,
  fetchgit,
  gobject-introspection,
  gtk3,
  vte,
  keybinder3,
  libwnck,
  libnotify,
  zsh,
  bash,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "termm";
  version = "0.5.2";
  format = "pyproject";

  src = fetchgit {
    url = "https://bitbucket.org/keiwop/termm.git";
    rev = "v${version}";
    sha256 = "00kx8m8hkf5wpsmf2sp5fn72s69v6fvb3i758dbk1ra6dhy94mcl";
  };
  # src = lib.cleanSource /_/src/python/termm;

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ] ++ (with python3Packages; [
    setuptools
    wheel
  ]);
  

  buildInputs = [
    gtk3
    vte
    keybinder3
    libwnck
    libnotify
    zsh
    bash
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    libsass
  ];

  doCheck = false;

  postInstall = ''
    python -c "from termm.termm import compile_scss; compile_scss()"
  '';

  # Allow the app to run on wayland
  preFixup = ''
    gappsWrapperArgs+=(--set GDK_BACKEND x11)
  '';

  meta = with lib; {
    description = "termm is a gtk3 drop-down terminal";
    homepage = "https://bitbucket.org/keiwop/termm.git";
    license = licenses.lgpl3Plus;
    maintainers = [ "keiwop.dev@gmail.com" ];
    platforms = platforms.linux;
  };
}

# Backport from unstable channel
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/video/jellyfin-media-player/default.nix

{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  ninja,
  libcec,
  SDL2,
  libXrandr,
  kdePackages,
}:

let
  mpvqt = kdePackages.mpvqt;
  qtbase = kdePackages.qtbase;
  qtdeclarative = kdePackages.qtdeclarative;
  qtwebchannel = kdePackages.qtwebchannel;
  qtwebengine = kdePackages.qtwebengine;
  wrapQtAppsHook = kdePackages.wrapQtAppsHook;
in

stdenv.mkDerivation rec {
  pname = "jellyfin-desktop";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-desktop";
    rev = "v${version}";
    hash = "sha256-tdjmOeuC3LFEIDSH8X9LG/myvE1FoxwR1zpDQRyaTkQ=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative
    qtwebchannel
    qtwebengine

    mpvqt

    # input sources
    libcec
    SDL2

    # frame rate switching
    libXrandr
  ];

  cmakeFlags = [
    "-DCHECK_FOR_UPDATES=OFF"
    "-DUSE_STATIC_MPVQT=OFF"
    # workaround for Qt cmake weirdness
    "-DQT_DISABLE_NO_DEFAULT_PATH_IN_QT_PACKAGES=ON"
  ];

  meta = {
    homepage = "https://github.com/jellyfin/jellyfin-desktop";
    description = "Jellyfin Desktop Client";
    license = with lib.licenses; [
      gpl2Only
      mit
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [
      jojosch
      kranzes
      paumr
    ];
    mainProgram = "jellyfinmediaplayer";
  };
}

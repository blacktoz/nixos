#! /bin/sh

set -e

nix-build /_/etc/nixos/nix/scripts/link_config_files.nix \
  --arg pkgs 'import <nixpkgs> {}' \
  --arg linked_paths '(import /_/etc/nixos/nix/paths.nix { user_name = "ryo"; machine_config = import /_/etc/nixos/nix/machine_config/nix-ryo.nix { pkgs = import <nixpkgs> {}; user_name = "ryo"; }; }).linked_paths'

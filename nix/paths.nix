# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ user_name, machine_config ? {} }:

let
  nixos_path = machine_config.nixos_path or "/_/etc/nixos";
  nix_config_path = machine_config.nix_config_path or "${nixos_path}/nix";
  dotfiles_path = machine_config.dotfiles_path or "${nixos_path}/dotfiles";

  machine_linked_paths = machine_config.linked_paths or [];
  default_linked_paths = [
    { name="nix_config"; source="${nix_config_path}"; target="/etc/nixos"; }
    { name="dotfiles"; source="${dotfiles_path}"; target="/home/${user_name}"; user="${user_name}"; dotfiles=true; }
  ];

  # Merging function for paths defined in machine config
  # TODO
  # FIXME: When removing a previously enabled stow from machine config, stow -R should be ran
  mergeLinkedPaths = base: overrides:
    let
      base_map = builtins.listToAttrs (map (x: { name = x.name; value = x; }) base);
      override_map = builtins.listToAttrs (map (x: { name = x.name; value = x; }) overrides);
      merged = base_map // override_map;
      filtered = builtins.filter (x: !(x ? remove && x.remove)) (builtins.attrValues merged);
    in
      filtered;
in
{
  inherit nixos_path nix_config_path dotfiles_path;
  linked_paths = mergeLinkedPaths default_linked_paths machine_linked_paths;
}

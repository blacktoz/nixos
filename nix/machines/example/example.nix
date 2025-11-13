# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ apps }:


let
  user_name = "keiwop";
  builder_addr = "arch-laptop";
  secrets = import ./secrets.nix;
in

{
  inherit user_name builder_addr; # More info about these variables in the README

  linked_paths = [
    { name="esphome"; source="/_/etc/docker/esphome"; target="/_/dkr/esphome"; user="${user_name}"; }
  ];

  module = { config, pkgs, ... }: {
    imports = [
      (import ./syncthing/syncthing.nix { user_name = user_name; secrets = secrets; })
    ];
  
    environment.systemPackages = with pkgs;
      apps.core
      ++ apps.dev
      ++ apps.gui
      ++ apps.media
      ++ apps.misc

      ++[
      apps.custom.termm
      apps.custom.minichlink
      apps.custom.riscv32ec_toolchain

      siril
    ];

    virtualisation.docker = {
      enable = true;
    };

    users.users.${user_name}.extraGroups = [ "dialout" "docker" ];
    services.udev.packages = [ apps.custom.minichlink ];
    services.udev.extraRules = ''
      # CH341a programmer
      SUBSYSTEM=="usb", ATTR{idVendor}=="1a86", ATTR{idProduct}=="5512", MODE="0660", GROUP="wheel"
    '';
  };
}

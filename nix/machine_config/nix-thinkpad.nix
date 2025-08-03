# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ pkgs, apps, user_name }:


let
  machine_apps = with pkgs; [
    apps.custom.termm
    # apps.custom.kwin_focus_app
    apps.custom.minichlink
    apps.custom.riscv32ec_toolchain
  ];
in

{
  nixos_path = /_/etc/nixos;
  linked_paths = [
    { name="caddy"; remove=true; }
    { name="pihole"; source = "/_/etc/docker/pihole"; target = "/_/dkr/pihole"; user="${user_name}"; }
  ];

  environment.systemPackages = apps.core
    ++ apps.dev
    ++ apps.gui
    ++ apps.media
    ++ apps.misc
    ++ machine_apps
  ;

  users.users.${user_name}.extraGroups = ["dialout"];
  services.udev.packages = [ apps.custom.minichlink ];
}

# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ apps }:


let
  user_name = "ryo";
  builder_addr = "arch-laptop";
  secrets = import ./secrets.nix;
in

{
  inherit user_name builder_addr;

  linked_paths = [
    { name="esphome"; source="/_/etc/docker/esphome"; target="/_/dkr/esphome"; user="${user_name}"; }
    { name="ha_dev"; source="/_/etc/docker/ha_dev"; target="/_/dkr/ha_dev"; user="${user_name}"; }
  ];

  module = { config, pkgs, ... }: {
    imports = [
      (import ./syncthing/syncthing.nix { user_name = user_name; secrets = secrets; })
    ];
  
    #############################################################################
    ### Apps ####################################################################
    #############################################################################

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
      apps.custom.jellyfin_desktop

      siril
    ];


    #############################################################################
    ### Services ################################################################
    #############################################################################

    services.displayManager.defaultSession = "plasma";

    users.users.${user_name}.extraGroups = [ "dialout" "docker" ];
    services.udev.packages = [ apps.custom.minichlink ];
    services.udev.extraRules = ''
      # CH341a programmer
      SUBSYSTEM=="usb", ATTR{idVendor}=="1a86", ATTR{idProduct}=="5512", MODE="0660", GROUP="wheel"
    '';

    virtualisation.docker = {
      enable = true;
    };

    services.printing.drivers = [ pkgs.samsung-unified-linux-driver ];


    fileSystems."/mnt/media" = {
      device = "/dev/disk/by-uuid/aff4f877-942e-49d4-9120-2c1fafabc92a";
      fsType = "ext4";
      options = [
        "rw"
        "nofail"
        "x-systemd.device-timeout=10s"
      ];
    };



    #############################################################################
    ### Locale ##################################################################
    #############################################################################

    time.timeZone = "Europe/Paris";

    console.keyMap = "us-acentos";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };

    services.xserver.xkb = {
      layout = "us";
      variant = "intl";
      options = "ctrl:nocaps";  # Remap CapsLock to Control
    };


    #############################################################################
    ### Laptop ##################################################################
    #############################################################################

    # powerManagement.powertop.enable = true;


    #############################################################################
    ### HW Specific #############################################################
    #############################################################################


    # Don't touch unless you go read about it
    system.stateVersion = "25.11";
  };
}

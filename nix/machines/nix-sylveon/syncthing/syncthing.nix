# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ user_name, secrets, ... }:


# Keys were generated with: nix-shell -p syncthing --run "syncthing generate --config ."
{
  services.syncthing = {
    enable = true;
    user = "${user_name}";
    configDir = "/home/${user_name}/.config/syncthing";
    key = toString ./key.pem;
    cert = toString ./cert.pem;
    openDefaultPorts = false;
    overrideDevices = true; # Only use devices declared in this file, deletes those added from webui
    overrideFolders = true;

    settings = {
      devices = {
        "arch-chikorita" = { id = "${secrets.syncthing_arch-chikorita_id}"; };
        "fermetagueulemerci" = { id = "${secrets.syncthing_fermetagueulemerci_id}"; };
        "nix-ryo" = { id = "${secrets.syncthing_nix-ryo_id}"; };
      };

      folders = {
        "etc" = {
          id = "etc";
          path = "/_/etc";
          ignorePerms = false;
          devices = [ "arch-chikorita" "fermetagueulemerci" "nix-ryo" ];
          ignorePatterns = [
            "local_config.nix"
          ];
        };

        "bkp" = {
          id = "bkp";
          path = "/_/bkp";
          ignorePerms = false;
          devices = [ "arch-chikorita" "fermetagueulemerci" "nix-ryo" ];
        };

        "src" = {
          id = "src";
          path = "/_/src";
          ignorePerms = false;
          devices = [ "arch-chikorita" "fermetagueulemerci" "nix-ryo" ];
        };

        "photos" = {
          id = "photos";
          path = "/_/photos";
          ignorePerms = false;
          devices = [ "arch-chikorita" "fermetagueulemerci" "nix-ryo" ];
          type = "receiveonly";
        };
      };

      gui = {
        user = "${user_name}";
        password = "${secrets.syncthing_password}";
      };
    };
  };

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
}

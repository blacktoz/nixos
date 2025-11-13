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
    openDefaultPorts = true;
    overrideDevices = true; # Only use devices declared in this file, deletes those added from webui
    overrideFolders = true;

    settings = {
      devices = {
        "machine1" = { id = "${secrets.syncthing_machine1_id}"; };
        "machine2" = { id = "${secrets.syncthing_machine2_id}"; };
      };

      folders = {
        "etc" = {
          id = "etc";
          path = "/_/etc";
          ignorePerms = false;
          devices = [ "machine1" "machine2" ];
          ignorePatterns = [
            "local_config.nix"
          ];
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

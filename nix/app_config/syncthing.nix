# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C): 2025 - keiwop <keiwop.dev@gmail.com>

{ user_name, host_name, cfg_path, secrets, ... }:


# Keys were generated with: nix-shell -p syncthing --run "syncthing generate --config ."
{
  services.syncthing = {
    enable = true;
    user = "${user_name}";
    configDir = "/home/${user_name}/.config/syncthing";
    key = "${cfg_path}/machines/${host_name}/syncthing/key.pem";
    cert = "${cfg_path}/machines/${host_name}/syncthing/cert.pem";
    openDefaultPorts = true;
    overrideDevices = true; # Only use devices declared in this file, deletes those added from webui
    overrideFolders = true;
    
    settings = {
      devices = {
        "nibbler" = { id = "${secrets.nibbler_id}"; };
        "zoidberg" = { id = "${secrets.zoidberg_id}"; };
        "nix-thinkpad" = { id = "${secrets.nix-thinkpad_id}"; };
        "arch-laptop" = { id = "${secrets.arch-laptop_id}"; };
        "win-desktop" = { id = "${secrets.win-desktop_id}"; };
      };

      folders = {
        "dev" = {
          id = "dev";
          path = "/_/dev";
          ignorePerms = false;
          devices = [ "nibbler" "zoidberg" "arch-laptop" ];
        };

        "etc" = {
          id = "etc";
          path = "/_/etc";
          ignorePerms = false;
          devices = [ "nibbler" "zoidberg" "arch-laptop" ];
        };

        "fun" = {
          id = "fun";
          path = "/_/fun";
          ignorePerms = false;
          devices = [ "nibbler" "zoidberg" "arch-laptop" "win-desktop" ];
        };

        "opt" = {
          id = "opt";
          path = "/_/opt";
          ignorePerms = false;
          devices = [ "nibbler" "zoidberg" "arch-laptop" ];
        };

        "src" = {
          id = "src";
          path = "/_/src";
          ignorePerms = false;
          devices = [ "nibbler" "zoidberg" "arch-laptop" ];
        };

        "usr" = {
          id = "usr";
          path = "/_/usr";
          ignorePerms = false;
          devices = [ "nibbler" "zoidberg" "arch-laptop" ];
        };
      };

      gui = {
        user = "${user_name}";
        password = "${secrets.syncthing_password}";
      };
    };
  };

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  
  # system.activationScripts.init_syncthing = {
  #   text = ''
  #     install -d -m 0755 -o ${user_name} -g ${user_name} /home/${user_name}/.local/state/syncthing
  #   '';
  # };
}

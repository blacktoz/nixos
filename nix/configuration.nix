
{ config, pkgs, ... }:

let
  user_name = "keiwop";
  host_name = "nix-thinkpad";
  cfg_path = "/_/etc/nixos";
  secrets = import ./secrets.nix;
in
{
  #############################################################################
  ### Imports #################################################################
  #############################################################################

  imports = [
    ./hardware-configuration.nix
    (import ./syncthing.nix { user_name = user_name; host_name = host_name; cfg_path = cfg_path; secrets = secrets; })
  ];


  #############################################################################
  ### Boot ####################################################################
  #############################################################################
  
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" "data=ordered" ];
  
  swapDevices = [
    {
      device = "/swap";
      size = 1024;
    }
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "elevator=noop" "mitigations=off" ];


  #############################################################################
  ### System packages #########################################################
  #############################################################################

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Core packages
    zsh-completions
    syncthing
    stow
    vim
    wget
    git
    tree
    screen
    tmux
    picocom
    nmap
    inetutils # traceroute + telnet
    hexedit
    fzf
    tldr

    # System monitoring
    pv
    iotop
    iftop
    iproute2  # ifstat
    htop
    btop
    lm_sensors
    dysk
    wavemon

    # GUI packages
    kdePackages.kate
    kdePackages.filelight
    vscodium
    gedit
    gparted
    evince
    cheese

    # Misc packages
    f3
    sl
    cowsay
    fortune

    # Development packages (more in dev_shells)
    (pkgs.callPackage ./termm.nix {})   # Get termm.nix from https://bitbucket.org/keiwop/termm_packaging
    nix-prefetch-git
    direnv
    pulseview
  ];

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };
  
  programs.direnv.enable = true;

  programs.firefox.enable = true;


  #############################################################################
  ### User configuration ######################################################
  #############################################################################

  users.mutableUsers = false;

  users.users.root = {
    hashedPassword = "${secrets.root_password}";
    shell = pkgs.zsh;
  };

  users.users.${user_name} = {
    isNormalUser = true;
    hashedPassword = "${secrets.user_password}";
    shell = pkgs.zsh;
    description = "${user_name}";
    group = "${user_name}";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      
    ];
  };

  users.groups.${user_name}.gid = 1000;
  
  security.sudo.wheelNeedsPassword = false;

  # system.activationScripts.copy_ssh_keys = ''
  #   mkdir -p "/home/${user_name}/.ssh"
  #   cp "${cfg_path}/${host_name}/ssh/*" "/home/${user_name}/.ssh/"
  #   chown -R "${user_name}:${user_name}" "/home/${user_name}/.ssh"
  # '';


  #############################################################################
  ### Services ################################################################
  #############################################################################

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PubkeyAuthentication = true;
    };
    extraConfig = ''
      Match Address 192.168.1.0/24
        PasswordAuthentication yes
      Match all
    '';
  };

  # Custom service that links the config files at boot time
  systemd.services."${user_name}-link-config" = {
    enable = true;
    description = "Links config files at boot time with stow";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      Environment = "PATH=/run/current-system/sw/bin:/usr/bin:/bin";
      ExecStart = "${cfg_path}/nix_link_config.sh";
    };
  };


  #############################################################################
  ### Networking ##############################################################
  #############################################################################

  networking.hostName = "${host_name}";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

  # networking.firewall.allowedTCPPorts = [ 22 8384 22000 ];
  # networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  networking.firewall.enable = false;


  #############################################################################
  ### Locale ##################################################################
  #############################################################################

  time.timeZone = "Europe/Paris";

  console.keyMap = "fr";

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


  #############################################################################
  ### Xorg ####################################################################
  #############################################################################
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };

  # Enable touchpad support (enabled by default in most desktopManager).
  # services.xserver.libinput.enable = true;


  #############################################################################
  ### Window Manager ##########################################################
  #############################################################################
  
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "keiwop";

  # Don't install all plasma6 packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    okular
  ];

  programs.hyprland.enable = true;

  # TODO
  # programs.dconf.profiles.user.databases = [ {
  #   settings."org/gnome/desktop/interface" = {
  #     gtk-theme = "Adwaita";
  #     icon-theme = "Flat-Remix";
  #     font-name = "Noto Sans Medium 11";
  #     document-font-name = "Noto Sans Medium 11";
  #     monospace-font-name = "Noto Sans Mono Medium 11";
  #   };
  # }];

  #############################################################################
  ### Fun stuff ###############################################################
  #############################################################################

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.samsung-unified-linux-driver ];
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #media-session.enable = true;
  };


  #############################################################################
  ### Misc ####################################################################
  #############################################################################

  services.thermald.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Don't touch unless you go read about it
  system.stateVersion = "25.05";

}

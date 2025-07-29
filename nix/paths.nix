
{ user_name, machine_config ? {} }:

let
  nixos_path = "/_/etc/nixos";
  nix_config_path = "${nixos_path}/nix";
  dotfiles_path = "${nixos_path}/dotfiles";
  docker_config_path = "/_/etc/docker";
  docker_install_path = "/_/dkr";

  default_linked_paths = [
    { name="nix_config"; source="${nix_config_path}"; target="/etc/nixos"; }
    { name="dotfiles"; source="${dotfiles_path}"; target="/home/${user_name}"; user="${user_name}"; dotfiles=true; }
    { name="caddy"; source="${docker_config_path}/caddy"; target="${docker_install_path}/caddy"; user="${user_name}"; }
    { name="ntfy"; source="${docker_config_path}/ntfy"; target="${docker_install_path}/ntfy"; user="${user_name}"; }
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

  machine_linked_paths = machine_config.linked_paths or [];
in
{
  inherit nixos_path nix_config_path dotfiles_path docker_config_path docker_install_path;
  linked_paths = mergeLinkedPaths default_linked_paths machine_linked_paths;
}

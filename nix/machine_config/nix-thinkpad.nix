
{ pkgs, user_name, ... }:


let
  docker_config_path = "/_/etc/docker";
  docker_install_path = "/_/dkr";

  minichlink = (pkgs.callPackage ../packages/minichlink.nix {});
  riscv32ec_toolchain = (pkgs.callPackage ../packages/riscv32ec_toolchain.nix {});
in
{
  environment.systemPackages = with pkgs; [
    minichlink
    riscv32ec_toolchain
  ];

  users.users.${user_name}.extraGroups = ["dialout"];
  services.udev.packages = [ minichlink ];
}

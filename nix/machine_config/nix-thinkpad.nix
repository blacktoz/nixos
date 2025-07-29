
{ pkgs, user_name }:


let
  minichlink = (pkgs.callPackage ../packages/minichlink.nix {});
  riscv32ec_toolchain = (pkgs.callPackage ../packages/riscv32ec_toolchain.nix {});
in
{
  nixos_path = /_/etc/nixos;
  linked_paths = [
    { name="caddy"; remove=true; }
    { name="pihole"; source = "/_/etc/docker/pihole"; target = "/_/dkr/pihole"; user="${user_name}"; }
  ];

  environment.systemPackages = with pkgs; [
    minichlink
    riscv32ec_toolchain
  ];

  users.users.${user_name}.extraGroups = ["dialout"];
  services.udev.packages = [ minichlink ];
}

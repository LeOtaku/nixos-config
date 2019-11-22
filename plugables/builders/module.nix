{ config, pkgs, ... }: {
  imports = [
    ../../modules/fleet.nix
  ];
  
  fleet = {
    machines = {
      "nixos-laptop.local".system = "x86_64-linux";
      "nixos-fujitsu.local".system = "x86_64-linux";
      "nixos-rpi.local".system = "aarch64-linux";
    };
    base = "/home/leo/.ssh";
  };

  nix.extraOptions = "builders-use-substitutes = true";
}
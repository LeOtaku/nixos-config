# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  # Default kernel modules 
  boot.initrd.availableKernelModules = [
    "xhci_pci" "nvme" "usb_storage" "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Enable basic NVIDIA support (needs testing)
  services.xserver.videoDrivers = [ "noveau" "intel" ];
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  boot.blacklistedKernelModules = [ "i915" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Filesystem (configured by nixos-install)
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a08f78e7-bc3b-4f1c-8332-d4c098f9cb78";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D9F0-DD1D";
    fsType = "vfat";
  };
    
  swapDevices = [
    { device = "/dev/disk/by-uuid/f2c44b27-e6d3-46ea-9db6-b581f184120b"; }
  ];

  # Other defaults
  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}

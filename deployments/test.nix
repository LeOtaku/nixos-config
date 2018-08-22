{
  network.description = "Web server";

  nixos-rpi =
    { config, pkgs, ... }:
    { 
      imports = [ 
        ../plugables/avahi/default.nix
        ../plugables/znc/default.nix
      ];

      services.nginx = {
        enable = true;
        virtualHosts."blog.example.com" = {
          enableACME = false;
          forceSSL = false;
          root = "${pkgs.callPackage /home/leo/site.nix {}}/";
        };
      };

      services.openssh.enable = true;
      services.openssh.permitRootLogin = "yes";

      services.avahi.enable = true;

      networking.firewall.allowedTCPPorts = [ 80 ];
      deployment.targetHost = "192.168.1.148";
       
      # NixOS wants to enable GRUB by default
      boot.loader.grub.enable = false;
      boot.loader.generic-extlinux-compatible.enable = true;
 
      #boot.kernelPackages = pkgs.linuxPackages_latest;
      
      # Needed for the virtual console to work on the RPi 3, as the default of 16M doesn't seem to be enough.
      boot.kernelParams = ["cma=32M"];
 
      # New broadcom drivers (wireless)
      #hardware.enableRedistributableFirmware = true;
      #hardware.firmware = [
      #  (pkgs.stdenv.mkDerivation {
      #   name = "broadcom-rpi3-extra";
      #   src = pkgs.fetchurl {
      #   url = "https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/54bab3d/brcm80211/brcm/brcmfmac43430-sdio.txt";
      #   sha256 = "19bmdd7w0xzybfassn7x4rb30l70vynnw3c80nlapna2k57xwbw7";
      #   };
      #   phases = [ "installPhase" ];
      #   installPhase = ''
      #   mkdir -p $out/lib/firmware/brcm
      #   cp $src $out/lib/firmware/brcm/brcmfmac43430-sdio.txt
      #   '';
      #   })
      #];
       
      # File systems configuration for using the installer's partition layout
      fileSystems = {
        "/boot" = {
          device = "/dev/disk/by-label/NIXOS_BOOT";
          fsType = "vfat";
        };
        "/" = {
          device = "/dev/disk/by-label/NIXOS_SD";
          fsType = "ext4";
        };
      };

      # !!! Adding a swap file is optional, but strongly recommended!
      swapDevices = [ { device = "/swapfile"; size = 1024; } ];

      nixpkgs.system = "aarch64-linux";
    };
}
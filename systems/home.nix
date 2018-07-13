# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{ 
  imports = [
    # Import plugable configurations
    ../plugables/avahi/default.nix
    ../plugables/openvpn/serverlist.nix
    ../plugables/transmission/default.nix
    # Enable throwaway account
    ../plugables/throwaway/default.nix
  ];

  services.netdata.enable = true;
  virtualisation.docker.enable = true;

  nix.nixPath = [
    "/etc/nixos/nixos-config"
    "nixpkgs=/etc/nixos/nixos-config/nixpkgs"
    "nixos=/etc/nixos/nixos-config/nixpkgs/nixos"
    "nixos-config=/etc/nixos/configuration.nix"
    "home-manager=/etc/nixos/nixos-config/modules/home-manager"
  ];

  nix.useSandbox = true;

  nixpkgs.overlays = [ (import ../pkgs) ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.memtest86.enable = true;

  # Override default nixos stuff
  boot.loader.grub.splashImage = null;
  boot.loader.grub.gfxmodeBios = "1366x768";
  boot.loader.timeout = 10;
  boot.plymouth.enable = true;

  # less verbose boot log
  boot.consoleLogLevel = 3;
  boot.kernelParams = [ "quiet" "udev.log_priority=3" ];
  boot.earlyVconsoleSetup = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager = {
    enable = true;
    packages = with pkgs; [ networkmanager_openvpn ];
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";
  
  nixpkgs.config.allowUnfree = true;
  # TODO: Move this to separate home manager file
  environment.systemPackages = with pkgs; [
    # Utils
    moreutils
    psmisc
    file
    tree
    stow
    ncdu
    cron
    wget
    curl
    aria
    # Terminal toys
    figlet
    toilet
    fortune
    cowsay
    lolcat
    neofetch
    # Terminal basics
    ranger
    nvi
    neovim
    micro
    kakoune
    # Monitors
    htop
    atop
    bmon
    # Browsers
    firefox
    lynx
    elinks
    w3m
    # Internet
    weechat
    # Terminal
    xterm
    rxvt_unicode
    tmux
    screen
    # Files
    sxiv
    imagemagick
    zathura
    mplayer
    vlc
    ffmpeg-full
    pandoc
    # Archives
    p7zip
    # Version control
    gitFull
    mercurial
    darcs
    bazaar
    cvs
    # Shells
    bash
    zsh
    fish
    dash
    elvish
    xonsh
  ];
  
  #TODO: fix fc cache in home-manager
  fonts.fonts = with pkgs; [
    gohufont
    terminus_font
    unifont
    siji
    google-fonts
    go-font
    lmmath
    tewi-font
    dina-font
    fira-code
    fira-mono
    roboto
  ];
  
  environment.variables = {
    EDITOR = [ "vim" ];
    TERMINAL = [ "urxvt" ];
    PAGER = [ "less" ];
    OH_MY_ZSH = [ "${pkgs.oh-my-zsh-custom}/share/oh-my-zsh" ];
    # TODO: find better solution for this
    NIXOS_DESCRIPTIVE_NAME = [ "home" ];
  };
  
  # List programs that need nix init
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # List simple services that you want to enable:
  services.upower.enable = true;
  powerManagement.enable = true;
  services.openssh.enable = true;
  services.cron.enable = false;

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ hplip gutenprint gutenprintBin splix ];

  # X11 windowing system.
  services.xserver.enable = true; 
  services.xserver.libinput.enable = true;
  services.xserver.displayManager.sddm = {
    enable = true;
    theme = "test";
    extraConfig = ''
      [Autologin]
      Relogin=false
      Session=
      User=

      [General]
      InputMethod=
      
      [Theme]
      ThemeDir=${pkgs.sddm_theme}/share/sddm/themes
    '';
  };

  # Sound
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.driSupport32Bit = true;

  # Firewall configuration
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable Virtualbox
  virtualisation.virtualbox.host = { 
    enable = true;
    #enableHardening = false; 
  };
  nixpkgs.config.virtualbox.enableExtensionPack = false;

  # Add wireshark permissions
  programs.wireshark = { 
    enable = true;
    package = pkgs.wireshark-gtk;
  };
  
  # Fix broken lid-suspend
  services.logind.lidSwitch = "ignore";
  services.acpid.enable = true;
  services.acpid.lidEventCommands = ''
    LID_STATE=/proc/acpi/button/lid/LID/state 
    if [[ $(${pkgs.gawk}/bin/awk '{print $2}' $LID_STATE) == 'closed' ]]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
}

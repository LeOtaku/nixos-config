# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{ 
  imports = [
    # Import plugable configurations
    ../plugables/avahi/default.nix
    ../plugables/transmission/default.nix
    ../modules/backup.nix
    ../plugables/email/postfix-queue.nix
  ];

  nix.useSandbox = true;
  nixpkgs.overlays = [ (import ../pkgs) ];

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

  # Networking
  networking.hostName = "nixos-old"; # Define your hostname.

  # manager settings are managed here
  networking.networkmanager.enable = false;
  networking.wireless.iwd.enable = false;
  networking.connman = {
    enable = true;
    enableVPN = true;
    extraConfig = ''
      [General]
      AllowHostnameUpdates=false
      PreferredTechnologies=ethernet,wifi
    '';
  };
  environment.etc."wpa_supplicant.conf".text = "";

  networking.nat.enable = true;
  networking.nat.internalInterfaces = ["ve-+"];
  networking.nat.externalInterface = "wlp3s0";

  # TODO: these will be removed when iwd support officially lands
  # environment.etc."wpa_supplicant.conf".text = ''
  # ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel
  # update_config=1
  # '';

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";
  
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Needed
    gitFull
    gitAndTools.gitRemoteGcrypt
    # NetworkManager
    networkmanagerapplet
    # Connman
    connman-gtk
    connman-ncurses
    # Networking
    iw
    iperf
    # Utils
    moreutils
    bc
    psmisc
    file
    tree
    stow
    ncdu
    cron
    wget
    curl
    rsync
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
    #neovim
    micro
    kakoune
    # Monitors
    htop
    atop
    bmon
    # Browsers
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
    imagemagick
    ffmpeg-full
    pandoc
    # Archives
    p7zip
    # Version control
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
  ];
  
  # TODO: fix fc cache in home-manager
  fonts.fonts = with pkgs; [ terminus_font siji ] ++
  [
    gohufont
    terminus_font
    unifont
    siji
    google-fonts
    go-font
    lmmath
    #tewi-font
    dina-font
    fira-code
    fira-mono
    #roboto
    emacs-all-the-icons-fonts
  ];
  
  environment.variables = {
    EDITOR = "vi";
    TERMINAL = "urxvt";
    SHELL = "zsh";
    PAGER = "less";
  };
  
  # List programs that need nix init
  programs.zsh.enable = true;
  programs.fish = {
    enable = false;
    vendor.completions.enable = false;
  };
  programs.light.enable = true;

  # List simple services that you want to enable:
  services.upower.enable = true;
  powerManagement.enable = true;
  services.openssh.enable = true;
  services.cron.enable = false;
  services.netdata.enable = true;

  # Geoclue2 for redshift
  services.geoclue2 = {
    enable = true;
    enableDemoAgent = false;
    geoProviderUrl = "https://location.services.mozilla.com/v1/geolocate?key=16674381-f021-49de-8622-3021c5942aff";
  };

  # Printing
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ hplip gutenprint gutenprintBin splix ];

  # Needed for home-manager to work
  services.dbus.packages = with pkgs; [ gnome3.dconf ];

  # X11 windowing system.
  services.xserver.enable = true; 
  services.xserver.libinput.enable = true;
  services.xserver.wacom.enable = true;

  # SDDM
  services.xserver.displayManager.sddm = {
    enable = true;
    theme = "haze";
    extraConfig = ''
      [Autologin]
      Relogin=false
      Session=
      User=

      [General]
      InputMethod=
      
      [Theme]
      ThemeDir=${pkgs.sddm-themes}/share/sddm/themes
    '';
  };

  # Sound
  hardware.pulseaudio.enable = true;

  # Steam
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.driSupport32Bit = true;

  # Firewall configuration
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable virtuaisation/container technologies
  virtualisation.virtualbox.host = { 
    enable = false;
    #enableHardening = false; 
  };
  nixpkgs.config.virtualbox.enableExtensionPack = false;

  virtualisation.docker.enable = true;
  services.flatpak.enable = true;

  # Add wireshark permissions
  programs.wireshark = { 
    enable = true;
    package = pkgs.wireshark-qt;
  };

  # Backup important directories
  backup = {
    enable = true;
    timer = [ "*-*-* 11:00" "*-*-* 22:00" ];
    repository = "rest:http://le0.gs:8000";
    passwordFile = "/etc/nixos/nixos-config/private/restic/default-repo-pass.txt";
    paths = [
      {
        path = "/home/leo";
        exclude = [
          ".local/share/flatpak"
          ".maildir/.notmuch"
        ];
      }
    ];
  };
  
  # Run locatedb every hour
  services.locate = {
    enable = true;
    interval = "hourly";
    localuser = "root";
  };

  # Fix broken lid-suspend
  services.logind.lidSwitch = "ignore";
  services.acpid.enable = true;
  services.acpid.logEvents = true;
  services.acpid.handlers = {
    "lid-close-suspend" = {
      event = "button/lid LID close";
      action = ''
      ${pkgs.systemd}/bin/loginctl lock-sessions
      sleep 2
      ${pkgs.systemd}/bin/systemctl suspend
      '';
    };
  };
}
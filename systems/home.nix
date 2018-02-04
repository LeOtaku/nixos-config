# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.memtest86.enable = true;

  #override default nixos stuff
  boot.loader.grub.splashImage = null;
  boot.loader.grub.gfxmodeBios = "1366x768";
  boot.loader.timeout = -1;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
    # Nixos
    nixUnstable
    nix-repl
    nox
    nix-index
    python2nix 
    nodePackages.node2nix
    # Games
    #factorio
    # fonts
    siji
    # Terminal Apps
    htop
    gtop
    figlet
    fortune
    cowsay
    lolcat
    cmatrix
    pulsemixer
    cava
    cli-visualizer
    ncmpcpp
    weechat
    canto-curses
    pamix
    ranger
    xfce.thunar
    gnome3.nautilus
    dolphin
    libqalculate
    # Graphical Apps
    xterm
    rxvt_unicode_with-plugins
    alacritty
    termite
    #urxvt_perls 
    firefox
    vscode
    steam
    feh
    surf
    zathura
    gnome3.gucharmap
    font-manager
    fontmatrix
    vlc
    gnome-mpv
    mpv
    # Utilities
    wget
    git
    xclip
    dmenu
    ncdu
    w3m
    elinks
    lynx
    bashmount
    psmisc
    efibootmgr
    tmux
    lxappearance-gtk3
    youtube-dl
    libnotify
    pandoc
    ffmpegthumbnailer
    p7zip
    exiftool
    poppler_utils
    mediainfo
    imagemagick
    transmission
    highlight
    unoconv
    discount
    # Other
    herbstluftwm
    sxhkd
    compton
    zsh
    oh-my-zsh
    polybar
    dzen2
    mpd
    mpc_cli
    # python
    python36Packages.eyeD3
    python36Packages.pygments
    # oh god no
    instant-markdown-d
    #bobthefish
    #((import ../pkgs/instant-markdown-d/default.nix) {}).package 
  ];
  
  environment.variables = {
    OH_MY_ZSH = [ "${pkgs.oh-my-zsh}/share/oh-my-zsh" ];
    EDITOR = [ "vim" ];
    TERMINAL = [ "urxvt" ];
    RANGER_LOAD_DEFAULT_RC = [ "FALSE" ];
  };

  # Some programs need SUID wrappeas, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:
  
  # Test Test
  programs.ibus.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true; 
 
  # Enable PulseAudio
  hardware.pulseaudio.enable = true;
  # For Steam
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.driSupport32Bit = true;
  
  # Enable touchpad support.
  services.xserver.libinput.enable = true;

}

{ config, lib, pkgs, ... }:

{
  ## Home manager configuration for this account
  programs.home-manager.enable = true;
  programs.home-manager.path = toString /etc/nixos/nixos-config/sources/links/home-manager;

  nixpkgs = {
    config = { allowUnfree = true; };
    overlays = [ (import ../pkgs/default.nix) ];
  };

  imports = [
    ../plugables/email/home-manager.nix
  ];
  
  home.packages = with pkgs; [
    # Dependencies
    lua
    # Text editors
    leovim
    vscode-with-extensions
    # File Manager
    ranger
    lf
    vifm
    clex
    emv
    fzf
    fzy
    # Office
    libreoffice-fresh
    scim
    libqalculate
    # Version control
    gitAndTools.hub
    gitAndTools.gitRemoteGcrypt
    gource
    # Browsers
    #mozilla.firefox-devedition-bin-unwrapped
    mozilla.firefox
    surf
    w3m
    elinks
    lynx
    # Mail
    neomutt
    notmuch
    dialog
    thunderbird
    # Chat
    weechat
    irssi
    #discord
    # Other Web
    rtv
    ddgr
    youtube-dl
    # Games
    #steam
    # Audio
    alsaUtils
    pulsemixer
    ncpamixer
    pavucontrol
    audacity
    mpd
    mpc_cli
    ncmpcpp
    cava
    cli-visualizer
    projectm
    freeciv_gtk
    # Images
    feh
    meh
    sxiv
    imagemagick
    pinta
    krita
    gimp
    inkscape
    gcolor3
    # PDF
    zathura
    evince
    # Video
    vlc
    mplayer
    mpv
    ffmpegthumbnailer
    ffmpeg-full
    #kdeApplications.kdenlive
    # Recording
    maim
    slop
    simplescreenrecorder
    screenkey
    asciinema
    # Ebook
    #calibre
    # Fonts
    gnome3.gucharmap
    font-manager
    fontmatrix
    # Other
    gcolor3
    lxappearance-gtk3
    # Systems
    tpacpi-bat
    acpi
    efibootmgr
    # Emulation
    wine
    # Terminal
    xterm
    urxvtWithExtensions
    tmux
    # Performance monitoring
    #python36Packages.glances
    htop
    atop
    gotop
    lshw
    hwinfo
    # Network utils
    wireshark-gtk
    nmap-graphical
    netcat-gnu
    speedtest-cli
    bmon
    vnstat
    iptables
    bind
    mtr
    liboping
    # Terminal toys
    figlet
    toilet
    fortune
    cowsay
    lolcat
    cmatrix
    pipes
    neofetch
    screenfetch
    tty-clock
    terminal-parrot
    #catimg
    libcaca
    # Xorg
    xsel
    xorg.xbacklight
    xorg.xwd
    xorg.xev
    xorg.xmodmap
    xorg.xinit
    xorg.xauth
    xdo
    xdotool
    xvkbd
    xautolock
    wmname
    wmctrl
    xclip
    libnotify
    inotifyTools
    # Base +
    aria
    exa
    fd
    ripgrep
    progress
    chroma
    jq
    most
    loc
    tokei
    rlwrap
    bvi
    direnv
    # ++
    reptyr
    fasd
    hyperfine
    thefuck
    bro
    tealdeer
    # Filesystems
    bashmount
    usbutils
    mtpfs
    libmtp
    # Archiving
    p7zip
    libarchive
    # Documents + Other
    pandoc
    #haskellPackages.pandoc
    #haskellPackages.pandoc-citeproc
    asciidoctor
    graphviz
    # Misc Filetype
    exiftool
    poppler_utils
    mediainfo
    atool
    highlight
    discount
    python36Packages.pygments
    id3v2
    # Torrent
    transmission-remote-gtk
    transmission-remote-cli
    # WMs
    _2bwm
    fvwm
    awesome
    openbox
    wmutils-core
    wmutils-opt
    # Other rice related
    sxhkd
    compton-git
    dmenu
    networkmanager_dmenu
    polybar
    dzen2
    dunst
    i3lock-color
    xss-lock
    # Webdev
    hugo
    # Nix
    nix-top
    nix-du
    nix-index
    nix-prefetch-scripts
  ];
  
  fonts.fontconfig.enableProfileFonts = true;

  home.sessionVariables = {
    TERMINAL = "urxvt";
    EDITOR = "vim";
    PAGER = "less";
    RANGER_LOAD_DEFAULT_RC = "FALSE";
  };
  
  home.keyboard.layout = "de";
  home.keyboard.variant = "nodeadkeys";
  #home.keyboard.options = "eurosign:e";
  
  xsession = {
    enable = true;
    #profileExtra = "";
    windowManager.command = "fvwm";
    initExtra = ''
    feh --bg-fill $HOME/.wallpaper
    compton -b
    polybar mail &
    polybar battery &
    urxvtd &
    mpd
    $HOME/.scripts/xmodmap.sh
    screen -d -m -S NcmpcppContainer "$HOME/.config/ncmpcpp/spawn-script"
    # Setup locksreen
    xset s 600 300
    xss-lock -- $HOME/.scripts/screenlock &
    '';
  };

  #services.compton = {
  #  enable = true;
  #  package = pkgs.compton-git;
  #  extraOptions = lib.readFile (config.xdg.configHome +  "/compton.conf");
  #};
  
  gtk = {
    enable = true;
    theme.package = pkgs.arc-theme;
    theme.name = "Arc-Darker";
    iconTheme.package = pkgs.gnome3.adwaita-icon-theme;
    iconTheme.name = "Adwaita";
    # theme.package = pkgs.adapta-gtk-theme;
    # theme.name = "Adapta-Eta";
    # iconTheme.package = pkgs.paper-icon-theme;
    # iconTheme.name = "Paper";
    gtk2 = {
      extraConfig = ''
        gtk-toolbar-style=GTK_TOOLBAR_ICONS
        gtk-toolbar-icon-size=GTK_ICON_SIZE_SMALL_TOOLBAR
      '';
      };
    gtk3 = {
      extraConfig = {
        gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_SMALL_TOOLBAR";
      };
      extraCss = ''
      .termite {
        padding: 15px;
      }
      '';
    };
  };
    
  programs.git = {
    enable = true;
    userName  = "LeOtaku";
    userEmail = "leo.gaskin@brg-feldkirchen.at";
  };

  programs.emacs.enable = false;
}

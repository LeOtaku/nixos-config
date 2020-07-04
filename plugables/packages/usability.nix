{ config, lib, pkgs, ... }:

{
  # Also needs the base utils
  imports = [
    ./base.nix
  ];

  environment.systemPackages = with pkgs; [
    # Nix Tools
    nix-top
    nix-diff
    nix-index
    nix-prefetch-scripts
    # Utils
    aria
    bvi
    ffsend
    emv
    entr
    fd
    gitAndTools.gitFull
    jq
    poppler_utils
    qrencode
    rclone
    ripgrep
    tokei
    # Multiplexer
    tmux
    screen
    # Text-mode utils
    ncdu
    htop
    libqalculate
    w3m
    rlwrap
    # Hardware
    hwinfo
    lshw
    stress
    s-tui
    pciutils
    # Networking
    dnsutils
    speedtest-cli
    iftop
    iperf
    nmap
  ];
}

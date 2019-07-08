self: super:

{
  # Custom packages
  catimg = super.callPackage ./catimg/default.nix { };
  chroma = super.callPackage ./chroma/default.nix { };
  n30f = super.callPackage ./n30f/default.nix { };
  sddm-themes = super.callPackage ./sddm/default.nix { };

  # Customized packages
  ncmpcpp = super.ncmpcpp.override {
    visualizerSupport = true;
    outputsSupport = true;
    clockSupport = true;
  };
  polybar = super.polybar.override {
    githubSupport = true;
    mpdSupport = true;
  };
  leovim = super.callPackage ./neovim/leovim.nix { };
  emacs-custom = super.callPackage ./emacs/default.nix { };
  sddm = super.sddm.overrideAttrs
  (old: { buildInputs = with super; [ qt5Full ] ++ old.buildInputs; });
  urxvtWithExtensions = super.rxvt_unicode_with-plugins.override {
    plugins = with super; [ urxvt_vtwheel urxvt_perls ];
  };
  sxiv = super.sxiv.override { conf = builtins.readFile ./sxiv/config.h; };

  # Mozilla
  mozilla = (import ../sources/links/nixpkgs-mozilla) self super;

  # Collections
  customVimPlugins = super.callPackage ./neovim/customPlugins.nix { };
}

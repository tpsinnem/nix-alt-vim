let
  pkgs = import <nixpkgs> {};
  neovim      = import ./neovim.nix;
  pathogenize = (import ./vim-pathogen.nix).pathogenize;
  idris-vim   = import ./idris-vim.nix;
  vim2hs      = import ./vim2.hs.nix;
  emptyVimrc  = pkgs.callPackage ./emptyVimrc.nix {};

  callpkg = pkgs.lib.callPackageWith (pkgs // pkgs.lua52Packages);

in
  pkgs.callPackage pathogenize { 
    callPackage = callpkg; 
    plugins = [idris-vim vim2hs];
    vim = neovim;
    baseVimrc = emptyVimrc; }


let
  pkgs        = import <nixpkgs> {};
  neovim      = import ./neovim.nix;
  pathogenize = (import ./vim-pathogen.nix).pathogenize;
  idrisVim    = pkgs.callPackage ./idris-vim.nix {};
  vim2hs      = pkgs.callPackage ./vim2hs.nix {};

  callpkg = pkgs.lib.callPackageWith (pkgs // pkgs.lua52Packages);

in
  pkgs.callPackage pathogenize { 
    callPackage = callpkg; 
    plugins = [idrisVim vim2hs];
    vim = neovim; }

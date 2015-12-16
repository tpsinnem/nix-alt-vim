let
  pkgs        = import <nixpkgs> {};
  luacallpkg  = pkgs.lib.callPackageWith (pkgs // pkgs.lua52Packages);

  neovim      = luacallpkg ./neovim.nix { vimAlias = true; };
  
  pathogenize = (import ./vim-pathogen.nix).pathogenize;

  idrisVim    = pkgs.callPackage ./idris-vim.nix {};
  vim2hs      = pkgs.callPackage ./vim2hs.nix {};


in
  pkgs.callPackage pathogenize { 
    plugins = [idrisVim vim2hs];
    vim = neovim; }

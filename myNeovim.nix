let
  pkgs        = import <nixpkgs> {};
  luacallpkg  = pkgs.lib.callPackageWith (pkgs // pkgs.lua52Packages);

  neovim      = luacallpkg vim/neovim.nix { vimAlias = true; };
  
  pathogenize = (import pathogen/default.nix).pathogenize;

  idrisVim    = pkgs.callPackage plugins/pathogen/idris-vim.nix {};
  vim2hs      = pkgs.callPackage plugins/pathogen/vim2hs.nix {};


in
  pkgs.callPackage pathogenize { 
    plugins = [idrisVim vim2hs];
    vim = neovim; }

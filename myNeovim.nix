let
  neovim      = import ./neovim.nix;
  pathogenize = (import ./vim-pathogen.nix).pathogenize;
  idris-vim   = import ./idris-vim.nix;
  vim2hs      = import ./vim2.hs.nix;

  pks = import <nixpkgs> {};
  callpkg = pks.lib.callPackageWith (pks // pks.lua52Packages);

in
  pks.callPackage pathogenize { 
    callPackage = callpkg; 
    plugins = [idris-vim vim2hs];
    vim = neovim; }


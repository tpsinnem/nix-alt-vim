{ stdenv, fetchgit }:

let label = "idris-vim-2015-12-08";

in {
  name = label;
  path =
    stdenv.mkDerivation {
      name = label;
      src = fetchgit {
        url     = "https://github.com/idris-hackers/idris-vim.git";
        rev     = "1f9bad6bc1d05b44e7555fe80472fbb7a542f47a";
        sha256  = "50cfb5a58a6c203c5f3695de61e9bc743e5dca71427e00c5cae86b4409debd3c";
      };
      installPhase = "cp -r . $out"; };
}

{ stdenv, fetchgit }:

  stdenv.mkDerivation {

        name = "vim2hs-2014-4-16";

        src = fetchgit {
          url     = "https://github.com/dag/vim2hs.git";
          rev     = "f2afd55704bfe0a2d66e6b270d247e9b8a7b1664";
          sha256  = "485fc58595bb4e50f2239bec5a4cbb0d8f5662aa3f744e42c110cd1d66b7e5b0";
        };
        installPhase = "cp -r . $out"; }

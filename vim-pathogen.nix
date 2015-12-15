rec {

  pathogen =
    { stdenv, fetchgit }:

      stdenv.mkDerivation {

        name = "vim-pathogen-2.3";

        src = fetchgit {
          url   = "git://github.com/tpope/vim-pathogen";
          rev   = "refs/tags/v2.3";
          sha256  = "f22cea3b646404bee3570b9fd7421b92da5546d0e5acca1873ff2d9ec0de059a";
        };
        installPhase = "cp -r . $out"; };


  pathogenize =
    { stdenv, fetchgit, callPackage, runCommand, writeText, buildEnv
    , baseVimrc, plugins, vim }:
    
      let
        pgen  = pathogen { inherit stdenv fetchgit; };

        plugs = buildEnv {  name  = "vim-pathogen-plugins";
                            paths = plugins; };

        pgenLines = writeText "vimrc-pathogen-lines" ''
                      let &rtp.=(empty(&rtp)?"":',')."${pgen}"
                      execute pathogen#infect('${plugs}')
                    '';
          
        rc    = runCommand "pathogen-vimrc" {} ''
                  cat ${baseVimrc} ${pgenLines} > $out
                '';
      in
        (callPackage vim {}) { baseVimrc = rc; };
        
}

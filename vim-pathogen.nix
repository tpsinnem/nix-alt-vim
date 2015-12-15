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
    { stdenv, fetchgit, callPackage, linkFarm, baseVimrc ? "", plugins, vim }:
    
      let
        pgen  = pathogen { inherit stdenv fetchgit; };

        plugs = linkFarm "vim-pathogen-plugins" plugins;

        rc    = baseVimrc +
                ''
                  let &rtp.=(empty(&rtp)?"":',')."${pgen}"
                  execute pathogen#infect('${plugs}/{}')
                '';
      in
        (callPackage vim {}) { baseVimrc = rc; };
        
}

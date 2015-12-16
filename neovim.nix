{ stdenv, fetchFromGitHub, cmake, gettext, glib, libmsgpack, libtermkey
, libtool, libuv, lpeg, lua, luajit, luaMessagePack, luabitop, ncurses, perl
, pkgconfig, unibilium, makeWrapper
, withJemalloc ? true, jemalloc

, vimAlias ? false }:

{ baseVimrc ? "" }:

with stdenv.lib;

let

  version = "0.1.1";

  # Note: this is NOT the libvterm already in nixpkgs, but some NIH silliness:
  neovimLibvterm = let version = "2015-11-06"; in stdenv.mkDerivation {
    name = "neovim-libvterm-${version}";

    src = fetchFromGitHub {
      sha256 = "0f9r0wnr9ajcdd6as24igmch0n8s1annycb9f4k0vg6fngwaypy9";
      rev = "04781d37ce5af3f580376dc721bd3b89c434966b";
      repo = "libvterm";
      owner = "neovim";
    };

    buildInputs = [ perl ];
    nativeBuildInputs = [ libtool ];

    makeFlags = [ "PREFIX=$(out)" ]
      ++ stdenv.lib.optional stdenv.isDarwin "LIBTOOL=${libtool}/bin/libtool";

    enableParallelBuilding = true;

    meta = {
      description = "VT220/xterm/ECMA-48 terminal emulator library";
      homepage = http://www.leonerd.org.uk/code/libvterm/;
      license = licenses.mit;
      maintainers = with maintainers; [ nckx ];
      platforms = platforms.unix;
    };
  };

  neovim = stdenv.mkDerivation {

    inherit baseVimrc;

    name = "neovim-${version}";

    src = fetchFromGitHub {
      sha256 = "0crswjslp687yp1cpn7nmm0j2sccqhcxryzxv1s81cgpai0fzf60";
      rev = "v${version}";
      repo = "neovim";
      owner = "neovim";
    };

    enableParallelBuilding = true;

    buildInputs = [
      glib
      libtermkey
      libuv
      luajit
      lua
      lpeg
      luaMessagePack
      luabitop
      libmsgpack
      ncurses
      neovimLibvterm
      unibilium
    ] ++ optional withJemalloc jemalloc;

    nativeBuildInputs = [
      cmake
      gettext
      makeWrapper
      pkgconfig
    ];

    LUA_CPATH="${lpeg}/lib/lua/${lua.luaversion}/?.so;${luabitop}/lib/lua/5.2/?.so";
    LUA_PATH="${luaMessagePack}/share/lua/5.1/?.lua";

    preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
      export DYLD_LIBRARY_PATH=${jemalloc}/lib
      substituteInPlace src/nvim/CMakeLists.txt --replace "    util" ""
    '';

    postInstall =
      ''
        echo "$baseVimrc" > $out/share/nvim/sysinit.vim
      ''
      + stdenv.lib.optionalString vimAlias ''
          ln -s $out/bin/nvim $out/bin/vim
      ''
      + stdenv.lib.optionalString stdenv.isDarwin ''
          echo patching $out/bin/nvim
          install_name_tool -change libjemalloc.1.dylib \
                    ${jemalloc}/lib/libjemalloc.1.dylib \
                    $out/bin/nvim
      '';

    meta = {
      description = "Vim text editor fork focused on extensibility and agility";
      longDescription = ''
        Neovim is a project that seeks to aggressively refactor Vim in order to:
        - Simplify maintenance and encourage contributions
        - Split the work between multiple developers
        - Enable the implementation of new/modern user interfaces without any
          modifications to the core source
        - Improve extensibility with a new plugin architecture
      '';
      homepage    = http://www.neovim.io;
      # "Contributions committed before b17d96 by authors who did not sign the
      # Contributor License Agreement (CLA) remain under the Vim license.
      # Contributions committed after b17d96 are licensed under Apache 2.0 unless
      # those contributions were copied from Vim (identified in the commit logs
      # by the vim-patch token). See LICENSE for details."
      license = with licenses; [ asl20 vim ];
      maintainers = with maintainers; [ manveru nckx garbas ];
      platforms   = platforms.unix;
    };
  };

in neovim 

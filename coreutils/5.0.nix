{ stage0env
, tcc
, make
, patch
, sed
, ...
}:
stage0env.override (final: prev: with final;
{
  pname = "coreutils";
  version = "5.0";

  buildInputs = [ tcc make patch sed ];

  src = builtins.fetchurl {
    url = "https://mirrors.kernel.org/gnu/${pname}/${name}.tar.bz2";
    sha256="c25b36b8af6e0ad2a875daf4d6196bd0df28a62be7dd252e5f99a4d5d7288d95";
  };

  patches = [
   ./patches/modechange.patch
   ./patches/mbstate.patch
   ./patches/ls-strcmp.patch
   ./patches/touch-getdate.patch
   ./patches/touch-dereference.patch
   ./patches/tac-uint64.patch
  ];

  configurePhase = ''
    # Patch and prepare
    cp lib/fnmatch_.h lib/fnmatch.h
    cp lib/ftw_.h lib/ftw.h
    cp lib/search_.h lib/search.h
    catm config.h

    # We will rebuild it
    rm src/false.c

    rm src/dircolors.h

    mkdir -p ''${out}/bin
  '';

  makefile = mk/main.mk;
})

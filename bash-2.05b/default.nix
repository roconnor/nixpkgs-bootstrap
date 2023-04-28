{ stage0env
, tcc
, libgetopt
, make
, patch
, heirloom-devtools
, ...
}:
stage0env.override (final: prev: with final;
{
  pname = "bash";
  version = "2.05b";

  src = builtins.fetchurl {
    url = "https://mirrors.kernel.org/gnu/${pname}/${name}.tar.gz";
    sha256="ba03d412998cc54bd0b0f2d6c32100967d3137098affdc2d32e6e7c11b163fe4";
  };

  buildInputs = [ tcc make patch heirloom-devtools.yacc ];

  patches = [ 
    patches/mes-libc.patch
    patches/tinycc.patch
    patches/missing-defines.patch
    patches/locale.patch
    patches/dev-tty.patch
  ];

  configurePhase = ''
    cp ${mk/main.mk} Makefile
    cp ${mk/builtins.mk} builtins/Makefile
    cp ${mk/common.mk} common.mk

    catm config.h
    catm include/version.h
    catm include/pipesize.h
    rm y.tab.c y.tab.h
  '';

  buildPhase = ''
    C_INCLUDE_PATH=${libgetopt}/include:''${C_INCLUDE_PATH}
    LIBRARY_PATH=${libgetopt}/lib:''${LIBRARY_PATH}

    # Unset the prefix to elimimate ''${prefix}/bin from bash's default search path.
    unset prefix
    make mkbuiltins
    cd builtins
    make libbuiltins.a
    cd ..
    make 
  '';

  installPhase = ''
    bindir=''${out}/bin
    mkdir -p ''${bindir}
    cp bash ''${bindir}
    chmod 755 ''${bindir}/bash
  '';
})

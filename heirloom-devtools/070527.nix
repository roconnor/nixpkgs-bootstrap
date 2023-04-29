{ stage0env
, tcc
, libgetopt
, make
, patch
, coreutils
, ...
}:
stage0env.override (final: prev: with final;
{
  pname = "heirloom-devtools";
  version = "070527";

  src = builtins.fetchurl {
    url = "http://downloads.sourceforge.net/project/heirloom/${pname}/${version}/${name}.tar.bz2";
    sha256="9f233d8b78e4351fe9dd2d50d83958a0e5af36f54e9818521458a08e058691ba";
  };

  buildInputs = [ tcc make patch coreutils "${builtins.placeholder "yacc"}" ];

  outputs = [ "yacc" "lex" ];

  patches = [
    patches/lex_remove_wchar.patch
    patches/yacc_remove_wchar.patch
  ];

  buildPhase = "";

  installPhase = ''
    mkdir -p ''${yacc}/bin ''${yacc}/lib

    C_INCLUDE_PATH=${libgetopt}/include:''${C_INCLUDE_PATH}
    LIBRARY_PATH=${libgetopt}/lib:''${LIBRARY_PATH}

    # Build yacc
    cd yacc
    make -f Makefile.mk CC=tcc AR=tcc\ -ar CFLAGS=-DMAXPATHLEN=100\ -DEILSEQ=84\ -DMB_LEN_MAX=100 LDFLAGS=-lgetopt\ -static RANLIB=true LIBDIR=''${yacc}/lib

    # Install yacc
    install yacc ''${yacc}/bin
    install -m 644 yaccpar ''${yacc}/lib

    mkdir -p ''${lex}/bin ''${lex}/lib

    # Build lex
    cd ../lex
    make -f Makefile.mk CC=tcc AR=tcc\ -ar CFLAGS=-DEILSEQ=84\ -DMB_LEN_MAX=100 LDFLAGS=-lgetopt\ -static RANLIB=true LEXDIR=''${lex}/lib

    # Install lex
    install lex ''${lex}/bin
    install libl.a ''${lex}/lib
    install -m 644 ncform ''${lex}/lib
  '';
  
  # yacc has a reference to $out/lib/yaccpar.
  # lex has a reference to $out/lib/ncform.
  allowedReferences = [ "lex" "yacc" ];
})

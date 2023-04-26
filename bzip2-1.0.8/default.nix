{ stage0
, tcc
, make
, patch
, src ? builtins.fetchurl { url = "https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz";
                            sha256="ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269";
                          }
}:
stage0.mkDerivation {
  pname = "bzip2";
  version = "1.0.8";

  buildInputs = [ tcc make patch ]; 

  inherit src;

  patches = [
    ./patches/mes-libc.patch
    ./patches/coreutils.patch
  ];

  buildPhase = ''
    make CC=tcc AR="tcc -ar" LDFLAGS="-static" bzip2
  '';

  installPhase = ''
    bindir=''${out}/bin
    mkdir -p ''${bindir}
    cp bzip2 ''${bindir}/bzip2
    cp bzip2 ''${bindir}/bunzip2
    chmod 755 ''${bindir}/bzip2
    chmod 755 ''${bindir}/bunzip2
  '';
}

{ stage0env
, mes
, tcc
, gzip
, tar
, make
, ...
}:
stage0env.override (final: prev: with final;
{
  pname = "bzip2";
  version = "1.0.8";
  src = builtins.fetchurl
    { url = "https://sourceware.org/pub/${pname}/${name}.tar.gz";
      sha256="ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269";
    };

  buildInputs = [ tcc ]; 

  unpackPhase = ''
    cp ${src} ${name}.tar.gz
    ${gzip}/bin/gunzip -d ${name}.tar.gz
    ${tar}/bin/tar xf ${name}.tar
    rm ${name}.tar ${name}.tar.gz
  '';

  patches = [
    ./patches/mes-libc.patch
    ./patches/coreutils.patch
  ];

  buildPhase = ''
    ${make}/bin/make CC=tcc AR="tcc -ar" LDFLAGS="-static" bzip2
  '';

  installPhase = ''
    bindir=''${out}/bin
    mkdir -p ''${bindir}
    cp bzip2 ''${bindir}/bzip2
    cp bzip2 ''${bindir}/bunzip2
    chmod 755 ''${bindir}/bzip2
    chmod 755 ''${bindir}/bunzip2
  '';

  # Can we some how strip these references?
  allowedReferences = [ mes mes.dev ];
})

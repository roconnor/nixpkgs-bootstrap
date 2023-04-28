{ stage1env
, mes
, CC
, ...
}:
stage1env.override (final: prev: with final;
{
  pname = "tcc";
  version = "0.9.27";
  src = builtins.fetchurl
    { url = "https://download.savannah.gnu.org/releases/tinycc/${name}.tar.bz2";
      sha256="de23af78fca90ce32dff2dd45b3432b2334740bb9bb7b05bf60fdbfc396ceb9c";
    };

  incdir="${mes.dev}/include";

  patches = [
    patches/ignore-duplicate-symbols.patch
    patches/ignore-static-inside-array.patch
    patches/static-link.patch
  ];

  configurePhase = ''
    # Create config.h
    touch config.h
  '';

  buildPhase = ''
    # Compile
    ${CC} \
      -v \
      -static \
      -o tcc \
      -D TCC_TARGET_I386=1 \
      -D CONFIG_TCCDIR=\"''${out}/lib/tcc\" \
      -D CONFIG_TCC_CRTPREFIX=\"''${out}/lib\" \
      -D CONFIG_TCC_ELFINTERP=\"/mes/loader\" \
      -D CONFIG_TCC_LIBPATHS=\"''${out}/lib:''${out}/lib/tcc\" \
      -D CONFIG_TCC_SYSINCLUDEPATHS=\"${incdir}\" \
      -D TCC_LIBGCC=\"''${out}/lib/libc.a\" \
      -D CONFIG_TCC_STATIC=1 \
      -D CONFIG_USE_LIBGCC=1 \
      -D TCC_VERSION=\"0.9.27\" \
      -D ONE_SOURCE=1 \
      tcc.c

    ${CC} -c -D HAVE_CONFIG_H=1 lib/libtcc1.c
    ${CC} -ar cr libtcc1.a libtcc1.o
  '';

  installPhase = '' 
    install -D libtcc1.a "''${out}/lib/tcc/libtcc1.a"
    install -D tcc "''${out}/bin/tcc"
  '';

  # allowedReferences = [ "out" mes mes.dev ];
})

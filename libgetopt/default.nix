{ stage0env
, mes
, tcc
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "libgetopt";

  MES_PREFIX="${mes}/share/${mes.name}";

  unpackPhase = ''
    mkdir ${name}
  '';

  buildPhase = ''
    ${tcc}/bin/tcc -c -D HAVE_CONFIG_H=1 -I ${MES_PREFIX}/include ${MES_PREFIX}/lib/posix/getopt.c
    ${tcc}/bin/tcc -ar cr libgetopt.a getopt.o
  '';

  installPhase = ''
    libdir=''${out}/lib
    incdir=''${out}/include
    mkdir -p ''${libdir} ''${incdir}
    cp libgetopt.a ''${libdir}/libgetopt.a
    cp ${MES_PREFIX}/include/getopt.h ''${incdir}/getopt.h
  '';

  allowedReferences = [ mes ];
})

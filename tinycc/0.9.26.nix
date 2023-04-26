{ stage0env
, mes
, ...
}:
stage0env.override (final: prev: with final;
{
  pname = "tcc";
  version = "0.9.26-1136-g5bba73cc";
  src = builtins.fetchurl
    { url = "https://lilypond.org/janneke/${pname}/${name}.tar.gz";
      sha256="23cacd448cff2baf6ed76c2d1e2d654ff4e557046e311dfb6be7e1c631014ef8";
    };

  MES_PREFIX="${mes}/share/${mes.name}";
  GUILE_LOAD_PATH="${MES_PREFIX}/mes/module:${MES_PREFIX}/module:${mes}/share/${mes.NYACC_PKG}/module";
  
  MES_BIN="${mes}/bin";
  MES_LIB="${mes}/lib";
  MES="${mes}/bin/mes";
  incdir="${mes.dev}/include";

  buildCommandPath = ./tcc-0.9.26.kaem;

  allowedReferences = [ "out" mes mes.dev ];
})

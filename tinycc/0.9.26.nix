{ stage0env
, simple-patch
, mes
, ...
}:
stage0env.override (final: prev: with final;
{
  pname = "tcc";
  version = "0.9.26-1147-gee75a10c";
  src = builtins.fetchurl
    { url = "https://lilypond.org/janneke/${pname}/${name}.tar.gz";
      sha256="6b8cbd0a5fed0636d4f0f763a603247bc1935e206e1cc5bda6a2818bab6e819f";
    };

  MES_PREFIX="${mes}/share/${mes.name}";
  GUILE_LOAD_PATH="${MES_PREFIX}/mes/module:${MES_PREFIX}/module:${mes}/share/${mes.NYACC_PKG}/module";
  
  buildInputs = [ simple-patch ];
  simple_patches = ./simple-patches;

  ARCH="x86";
  MES_SOURCE=MES_PREFIX;
  MES_BIN="${mes}/bin";
  MES_LIB="${mes}/lib";
  MES="${mes}/bin/mes-m2";
  TCC_PKG=name;
  INCDIR="${mes.dev}/include";

  buildCommandPath = ./tcc-0.9.26.kaem;

  allowedReferences = [ "out" mes mes.dev ];
})

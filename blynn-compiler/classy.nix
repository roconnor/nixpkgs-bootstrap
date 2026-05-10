{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-classy";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm --raw ${blynn-compiler.typically} -pb ${blynn-compiler.typically} -lf ${src/classy.hs} -o ''${out}
  '';
})

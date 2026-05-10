{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-barely";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm --raw ${blynn-compiler.barely-0} -pb ${blynn-compiler.barely-0} -lf ${src/barely.hs} -o ''${out}
  '';
})

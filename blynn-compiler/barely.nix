{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-barely";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm -l ${blynn-compiler.barely-1} -lf ${src/barely.hs} -o ''${out}
  '';
})

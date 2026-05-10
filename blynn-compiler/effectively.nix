{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-effectively";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm -l ${blynn-compiler.barely} -lf ${src/effectively.hs} -o ''${out}
  '';
})

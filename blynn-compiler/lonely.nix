{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-lonely";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm -l ${blynn-compiler.effectively} -lf ${src/lonely.hs} -o ''${out}
  '';
})

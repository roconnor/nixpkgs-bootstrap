{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-typically";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm --raw ${blynn-compiler.fixity} -pb ${blynn-compiler.fixity} -lf ${src/typically.hs} -o ''${out}
  '';
})

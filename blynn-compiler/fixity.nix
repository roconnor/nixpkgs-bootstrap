{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-fixity";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm --raw ${blynn-compiler.parity} -pb ${blynn-compiler.parity} -lf ${src/fixity.hs} -o ''${out}
  '';
})

{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-algebraically";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm --raw ${blynn-compiler.binary} -pb ${blynn-compiler.binary} -lf ${src/algebraically} -o ''${out}
  '';
})

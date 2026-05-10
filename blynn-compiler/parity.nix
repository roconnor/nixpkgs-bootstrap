{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-parity";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm --raw ${blynn-compiler.algebraically} -pb ${blynn-compiler.algebraically} -lf ${src/parity.hs} -o ''${out}
  '';
})

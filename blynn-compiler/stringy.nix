{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-stringy";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm --raw ${blynn-compiler.semantically} -pb ${blynn-compiler.semantically} -lf ${src/stringy} -o ''${out}
  '';
})

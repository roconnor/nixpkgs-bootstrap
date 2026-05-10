{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-semantically";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm --raw ${blynn-compiler.singularity} -pb ${blynn-compiler.singularity} -lf ${src/semantically} -o ''${out}
  '';
})

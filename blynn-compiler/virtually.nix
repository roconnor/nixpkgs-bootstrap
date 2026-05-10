{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-virtually";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm -f ${src/virtually.hs} --foreign 2 --raw ${blynn-compiler.uniquely} --rts_c run -o ''${out}
  '';
})

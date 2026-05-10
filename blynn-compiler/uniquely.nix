{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-uniquely";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm -f ${src/uniquely.hs} --foreign 2 --raw ${blynn-compiler.mutually} --rts_c run -o ''${out}
  '';
})

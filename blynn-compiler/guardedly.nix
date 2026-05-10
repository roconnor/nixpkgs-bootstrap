{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-guardedly";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm -f ${src/guardedly.hs} --raw ${blynn-compiler.patty} --rts_c run -o ''${out}
  '';
})

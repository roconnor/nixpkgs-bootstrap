{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-patty";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm -f ${src/patty.hs} --raw ${blynn-compiler.lonely} --rts_c run -o ''${out}
  '';
})

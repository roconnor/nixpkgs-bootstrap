{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-mutually";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm -f ${src/mutually.hs} --foreign 2 --raw ${blynn-compiler.assembly} --rts_c run -o ''${out}
  '';
})

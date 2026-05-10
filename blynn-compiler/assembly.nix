{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-assembly";

  buildCommand = ''
    ${blynn-compiler.vm}/bin/vm -f ${src/assembly.hs} --raw ${blynn-compiler.guardedly} --rts_c run -o ''${out}
  '';
})

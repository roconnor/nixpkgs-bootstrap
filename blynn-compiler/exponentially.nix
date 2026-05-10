{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-exponentially";

  buildCommand = ''
	  ${blynn-compiler.pack_blobs}/bin/pack_blobs -f ${src/blob/exponentially.source} -o exponentially
    ${blynn-compiler.vm}/bin/vm --raw ${blynn-compiler.parenthetically} -pb ${blynn-compiler.parenthetically} -lf exponentially -o ''${out}
  '';
})

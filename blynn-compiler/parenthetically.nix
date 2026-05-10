{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-parenthetically";

  buildCommand = ''
	  ${blynn-compiler.pack_blobs}/bin/pack_blobs -f ${src/blob/parenthetically.source} -o parenthetically
    ${blynn-compiler.vm}/bin/vm --raw ${src/blob/root} -pb ${src/blob/root} -lf parenthetically -o ''${out}
  '';
})

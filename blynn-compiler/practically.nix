{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-practically";

  buildCommand = ''
	  ${blynn-compiler.pack_blobs}/bin/pack_blobs -f ${src/blob/practically.source} -o practically
    ${blynn-compiler.vm}/bin/vm --raw ${blynn-compiler.exponentially} -pb ${blynn-compiler.exponentially} -lf practically -o ''${out}
  '';
})

{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "blynn-compiler-singularity";

  buildCommand = ''
	  ${blynn-compiler.pack_blobs}/bin/pack_blobs -f ${src/blob/singularity.source} -o singularity
    ${blynn-compiler.vm}/bin/vm --raw ${blynn-compiler.practically} -pb ${blynn-compiler.practically} -lf singularity -o ''${out}
  '';
})

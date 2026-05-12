{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
assert builtins.elem prev.system ["i686-linux" "x86_64-linux"];
let ARCH="x86";
in {
  name = "blynn-compiler-pack_blobs";

  buildCommand = ''
    mkdir -p ''${out}/bin

    # Compile to assembly pack_blobs.c
    M2-Mesoplanet --architecture ${ARCH} -f ${src/pack_blobs.c} -o ''${out}/bin/pack_blobs
  '';
})

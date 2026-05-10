{ stage0env
, blynn-compiler
, ...
}:
stage0env.override (final: prev: with final;
assert builtins.elem prev.system ["i686-linux" "x86_64-linux"];
let ARCH="x86";
    BLOOD_FLAG=" ";
    BASE_ADDRESS="0x08048000";
    ENDIAN_FLAG="--little-endian";
    EXE_SUFFIX="";
in {
  name = "blynn-compiler-marginally";

  buildCommand = ''
    mkdir -p ''${out}/src
    ${blynn-compiler.vm}/bin/vm -f ${src/marginally.hs} --foreign 2 --raw ${blynn-compiler.virtually} --rts_c run -o ''${out}/src/marginally.c

    mkdir -p ''${out}/bin

    # Compile to assembly marginally.c
    M2-Planet --architecture ${ARCH} \
      -f ${../stage0/M2libc/sys/types.h} \
      -f ${../stage0/M2libc/stddef.h} \
      -f ${../stage0/M2libc/${ARCH}/linux/unistd.c} \
      -f ${../stage0/M2libc/${ARCH}/linux/fcntl.c} \
      -f ${../stage0/M2libc/fcntl.c} \
      -f ${../stage0/M2libc/${ARCH}/linux/sys/stat.c} \
      -f ${../stage0/M2libc/stdlib.c} \
      -f ${../stage0/M2libc/stdio.h} \
      -f ${../stage0/M2libc/stdio.c} \
      -f ${../stage0/M2libc/bootstrappable.c} \
      -f ''${out}/src/marginally.c \
      --debug \
      -o marginally.M1

    # Create dwarf stubs for marginally
    blood-elf -f marginally.M1 ${ENDIAN_FLAG} ${BLOOD_FLAG} -o marginally-footer.M1

    # Convert to hex2 linker format
    M1 -f ${../stage0/M2libc/${ARCH}/${ARCH}_defs.M1} \
      -f ${../stage0/M2libc/${ARCH}/libc-full.M1} \
      -f marginally.M1 \
      -f marginally-footer.M1 \
      ${ENDIAN_FLAG} \
      --architecture ${ARCH} \
      -o marginally.hex2

    # Link into final static binary
    hex2 -f ${../stage0/M2libc/${ARCH}/ELF-${ARCH}-debug.hex2} \
      -f marginally.hex2 \
      ${ENDIAN_FLAG} \
      --architecture ${ARCH} \
      --base-address ${BASE_ADDRESS} \
      -o ''${out}/bin/marginally
  '';
})

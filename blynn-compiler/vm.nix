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
  name = "blynn-compiler-vm";

  buildCommand = ''
    mkdir -p ''${out}/bin

    # Compile to assembly vm.c
    M2-Planet --architecture ${ARCH} \
      -f ${../stage0/M2libc/sys/types.h} \
      -f ${../stage0/M2libc/stddef.h} \
      -f ${../stage0/M2libc/sys/utsname.h} \
      -f ${../stage0/M2libc/${ARCH}/linux/unistd.c} \
      -f ${../stage0/M2libc/${ARCH}/linux/fcntl.c} \
      -f ${../stage0/M2libc/fcntl.c} \
      -f ${../stage0/M2libc/${ARCH}/linux/sys/stat.c} \
      -f ${../stage0/M2libc/ctype.c} \
      -f ${../stage0/M2libc/stdlib.c} \
      -f ${../stage0/M2libc/stdarg.h} \
      -f ${../stage0/M2libc/stdio.h} \
      -f ${../stage0/M2libc/stdio.c} \
      -f ${../stage0/M2libc/bootstrappable.c} \
      -f ${src/vm.c} \
      --debug \
      -o vm.M1

    # Create dwarf stubs for vm
    blood-elf -f vm.M1 ${ENDIAN_FLAG} ${BLOOD_FLAG} -o vm-footer.M1

    # Convert to hex2 linker format
    M1 -f ${../stage0/M2libc/${ARCH}/${ARCH}_defs.M1} \
      -f ${../stage0/M2libc/${ARCH}/libc-full.M1} \
      -f vm.M1 \
      -f vm-footer.M1 \
      ${ENDIAN_FLAG} \
      --architecture ${ARCH} \
      -o vm.hex2

    # Link into final static binary
    hex2 -f ${../stage0/M2libc/${ARCH}/ELF-${ARCH}-debug.hex2} \
      -f vm.hex2 \
      ${ENDIAN_FLAG} \
      --architecture ${ARCH} \
      --base-address ${BASE_ADDRESS} \
      -o ''${out}/bin/vm
  '';
})

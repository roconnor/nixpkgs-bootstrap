{ system ? builtins.currentSystem
, lib
, stage0-seed-bin
, ...
}:
assert builtins.elem system ["i686-linux" "x86_64-linux"];
let ARCH="x86";
    BLOOD_FLAG=" ";
    BASE_ADDRESS="0x08048000";
    ENDIAN_FLAG="--little-endian";
    OPERATING_SYSTEM="Linux";
    EXE_SUFFIX="";

    mescc-tools-seed-kaem = builtins.toFile "mescc-tools-seed-kaem.kaem" ''
    #! /usr/bin/env bash
    # Mes --- Maxwell Equations of Software
    # Copyright © 2017,2019 Jan Nieuwenhuizen <janneke@gnu.org>
    # Copyright © 2017,2019 Jeremiah Orians
    #
    # This file is part of Mes.
    #
    # Mes is free software; you can redistribute it and/or modify it
    # under the terms of the GNU General Public License as published by
    # the Free Software Foundation; either version 3 of the License, or (at
    # your option) any later version.
    #
    # Mes is distributed in the hope that it will be useful, but
    # WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.
    #
    # You should have received a copy of the GNU General Public License
    # along with Mes.  If not, see <http://www.gnu.org/licenses/>.
    
    
    
    # Can also be run by kaem or any other shell of your personal choice
    # To run in kaem simply: kaem --verbose --strict
    # Warning all binaries prior to the use of blood-elf will not be readable by
    # Objdump, you may need to use ndism or gdb to view the assembly in the binary.
    
    
    
    ###############################################i
    # Phase-0 Build hex0 from bootstrapped binary #
    ###############################################
    ${stage0-seed-bin}/hex0-seed ${stage0-posix-x86/hex0_x86.hex0} hex0
    # hex0 should have the exact same checksum as hex0-seed as they are both supposed
    # to be built from hex0_x86.hex0 and by definition must be identical

    
    #########################################
    # Phase-0b Build minimal kaem from hex0 #
    #########################################
    ./hex0 ${stage0-posix-x86/kaem-minimal.hex0} kaem-0
    # for checksum validation reasons

    ./kaem-0 ${mescc-tools-mini-kaem}
    '';

    mescc-tools-mini-kaem = builtins.toFile "mescc-tools-mini-kaem.kaem" ''
    #! /usr/bin/env bash
    # Mes --- Maxwell Equations of Software
    # Copyright © 2017,2019 Jan Nieuwenhuizen <janneke@gnu.org>
    # Copyright © 2017,2019 Jeremiah Orians
    #
    # This file is part of Mes.
    #
    # Mes is free software; you can redistribute it and/or modify it
    # under the terms of the GNU General Public License as published by
    # the Free Software Foundation; either version 3 of the License, or (at
    # your option) any later version.
    #
    # Mes is distributed in the hope that it will be useful, but
    # WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.
    #
    # You should have received a copy of the GNU General Public License
    # along with Mes.  If not, see <http://www.gnu.org/licenses/>.



    # Can also be run by kaem or any other shell of your personal choice
    # To run in kaem simply: kaem --verbose --strict
    # Warning all binaries prior to the use of blood-elf will not be readable by
    # Objdump, you may need to use ndism or gdb to view the assembly in the binary.


    #################################
    # Phase-1 Build hex1 from hex0  #
    #################################
    ./hex0 ${stage0-posix-x86/hex1_x86.hex0} hex1
    # hex1 adds support for single character labels and is available in various forms
    # in mescc-tools/x86_bootstrap to allow you various ways to verify correctness


    #################################
    # Phase-2 Build hex2 from hex1  #
    #################################
    ./hex1 ${stage0-posix-x86/hex2_x86.hex1} hex2-0
    # hex2 adds support for long labels and absolute addresses thus allowing it
    # to function as an effective linker for later stages of the bootstrap
    # This is a minimal version which will be used to bootstrap a much more advanced
    # version in a later stage.

    #################################
    # Phase-2b Build catm from hex2 #
    #################################
    ./hex2-0 ${stage0-posix-x86/catm_x86.hex2} catm
    # catm removes the need for cat or shell support for redirection by providing
    # equivalent functionality via catm output_file input1 input2 ... inputN

    ###############################
    # Phase-3 Build M0 from hex2  #
    ###############################
    ./catm M0.hex2 ${stage0-posix-x86/ELF-i386.hex2} ${stage0-posix-x86/M0_x86.hex2}
    ./hex2-0 M0.hex2 M0
    # M0 is the architecture specific version of M1 and is by design single
    # architecture only and will be replaced by the C code version of M1

    ###################################
    # Phase-4 Build cc_x86 from M0    #
    ###################################
    ./M0 ${stage0-posix-x86/cc_x86.M1} cc_x86-0.hex2
    ./catm cc_x86-1.hex2 ${stage0-posix-x86/ELF-i386.hex2} cc_x86-0.hex2
    ./hex2-0 cc_x86-1.hex2 cc_x86

    #########################################
    # Phase-5 Build M2-Planet from cc_x86   #
    #########################################
    catm M2-0.c \
	${M2libc/${ARCH}/linux/bootstrap.c} \
	${M2-Planet/cc.h} \
	${M2libc/bootstrappable.c} \
	${M2-Planet/cc_globals.c} \
	${M2-Planet/cc_reader.c} \
	${M2-Planet/cc_strings.c} \
	${M2-Planet/cc_types.c} \
	${M2-Planet/cc_core.c} \
	${M2-Planet/cc_macro.c} \
	${M2-Planet/cc.c}
    cc_x86 M2-0.c M2-0.M1
    catm M2-0-0.M1 ${stage0-posix-x86/x86_defs.M1} ${stage0-posix-x86/libc-core.M1} M2-0.M1
    M0 M2-0-0.M1 M2-0.hex2
    catm M2-0-0.hex2 ${stage0-posix-x86/ELF-i386.hex2} M2-0.hex2
    hex2-0 M2-0-0.hex2 M2

    #############################################
    # Phase-6 Build blood-elf-0 from C sources  #
    #############################################
    M2 --architecture x86 \
	-f ${M2libc/${ARCH}/linux/bootstrap.c} \
	-f ${M2libc/bootstrappable.c} \
	-f ${mescc-tools/stringify.c} \
	-f ${mescc-tools/blood-elf.c} \
	--bootstrap-mode \
	-o blood-elf-0.M1
    catm blood-elf-0-0.M1 ${M2libc/${ARCH}/x86_defs.M1} ${M2libc/${ARCH}/libc-core.M1} blood-elf-0.M1
    M0 blood-elf-0-0.M1 blood-elf-0.hex2
    catm blood-elf-0-0.hex2 ${M2libc/${ARCH}/ELF-x86.hex2} blood-elf-0.hex2
    hex2-0 blood-elf-0-0.hex2 blood-elf-0
 
    #####################################
    # Phase-7 Build M1-0 from C sources #
    #####################################
    M2 --architecture ${ARCH} \
 	-f ${M2libc/${ARCH}/linux/bootstrap.c} \
 	-f ${M2libc/bootstrappable.c} \
 	-f ${mescc-tools/stringify.c} \
 	-f ${mescc-tools/M1-macro.c} \
 	--bootstrap-mode \
 	--debug \
 	-o M1-macro-0.M1
 
    blood-elf-0 -f M1-macro-0.M1 ${ENDIAN_FLAG} -o M1-macro-0-footer.M1
    catm M1-macro-0-0.M1 ${M2libc/${ARCH}/x86_defs.M1} ${M2libc/${ARCH}/libc-core.M1} M1-macro-0.M1 M1-macro-0-footer.M1
    M0 M1-macro-0-0.M1 M1-macro-0.hex2
    catm M1-macro-0-0.hex2 ${M2libc/${ARCH}/ELF-x86-debug.hex2} M1-macro-0.hex2
    hex2-0 M1-macro-0-0.hex2 M1-0
 
    #######################################
    # Phase-8 Build hex2-1 from C sources #
    #######################################
    M2 --architecture ${ARCH} \
	-f ${M2libc/sys/types.h} \
	-f ${M2libc/stddef.h} \
	-f ${M2libc/${ARCH}/linux/unistd.c} \
	-f ${M2libc/${ARCH}/linux/fcntl.c} \
	-f ${M2libc/fcntl.c} \
	-f ${M2libc/${ARCH}/linux/sys/stat.c} \
	-f ${M2libc/stdlib.c} \
	-f ${M2libc/stdio.h} \
	-f ${M2libc/stdio.c} \
	-f ${M2libc/bootstrappable.c} \
	-f ${mescc-tools/hex2.h} \
	-f ${mescc-tools/hex2_linker.c} \
	-f ${mescc-tools/hex2_word.c} \
	-f ${mescc-tools/hex2.c} \
	--debug \
	-o hex2_linker-0.M1

    blood-elf-0 -f hex2_linker-0.M1 ${ENDIAN_FLAG} -o hex2_linker-0-footer.M1

    M1-0 --architecture ${ARCH} \
	${ENDIAN_FLAG} \
	-f ${M2libc/${ARCH}/x86_defs.M1} \
	-f ${M2libc/${ARCH}/libc-full.M1} \
	-f hex2_linker-0.M1 \
	-f hex2_linker-0-footer.M1 \
	-o hex2_linker-0.hex2

    catm hex2_linker-0-0.hex2 ${M2libc/${ARCH}/ELF-x86-debug.hex2} hex2_linker-0.hex2

    hex2-0 hex2_linker-0-0.hex2 hex2-1

    ###################################
    # Phase-9 Build M1 from C sources #
    ###################################
    M2 --architecture ${ARCH} \
	-f ${M2libc/sys/types.h} \
	-f ${M2libc/stddef.h} \
	-f ${M2libc/${ARCH}/linux/fcntl.c} \
	-f ${M2libc/fcntl.c} \
	-f ${M2libc/${ARCH}/linux/unistd.c} \
	-f ${M2libc/string.c} \
	-f ${M2libc/stdlib.c} \
	-f ${M2libc/stdio.h} \
	-f ${M2libc/stdio.c} \
	-f ${M2libc/bootstrappable.c} \
	-f ${mescc-tools/stringify.c} \
	-f ${mescc-tools/M1-macro.c} \
	--debug \
	-o M1-macro-1.M1

    blood-elf-0 -f M1-macro-1.M1 ${ENDIAN_FLAG} -o M1-macro-1-footer.M1

    M1-0 --architecture ${ARCH} \
	${ENDIAN_FLAG} \
	-f ${M2libc/${ARCH}/x86_defs.M1} \
	-f ${M2libc/${ARCH}/libc-full.M1} \
	-f M1-macro-1.M1 \
	-f M1-macro-1-footer.M1 \
	-o M1-macro-1.hex2

    hex2-1 --architecture ${ARCH} \
	${ENDIAN_FLAG} \
	--base-address ${BASE_ADDRESS} \
	-f ${M2libc/${ARCH}/ELF-x86-debug.hex2} \
	-f M1-macro-1.hex2 \
	-o M1

    ######################################
    # Phase-10 Build hex2 from C sources #
    ######################################
    M2 --architecture ${ARCH} \
	-f ${M2libc/sys/types.h} \
	-f ${M2libc/stddef.h} \
	-f ${M2libc/${ARCH}/linux/unistd.c} \
	-f ${M2libc/${ARCH}/linux/fcntl.c} \
	-f ${M2libc/fcntl.c} \
	-f ${M2libc/${ARCH}/linux/sys/stat.c} \
	-f ${M2libc/stdlib.c} \
	-f ${M2libc/stdio.h} \
	-f ${M2libc/stdio.c} \
	-f ${M2libc/bootstrappable.c} \
	-f ${mescc-tools/hex2.h} \
	-f ${mescc-tools/hex2_linker.c} \
	-f ${mescc-tools/hex2_word.c} \
	-f ${mescc-tools/hex2.c} \
	--debug \
	-o hex2_linker-2.M1

    blood-elf-0 -f hex2_linker-2.M1 ${ENDIAN_FLAG} -o hex2_linker-2-footer.M1

    M1 --architecture ${ARCH} \
	${ENDIAN_FLAG} \
	-f ${M2libc/${ARCH}/x86_defs.M1} \
	-f ${M2libc/${ARCH}/libc-full.M1} \
	-f hex2_linker-2.M1 \
	-f hex2_linker-2-footer.M1 \
	-o hex2_linker-2.hex2

    hex2-1 --architecture ${ARCH} \
	${ENDIAN_FLAG} \
	--base-address ${BASE_ADDRESS} \
	-f ${M2libc/${ARCH}/ELF-x86-debug.hex2} \
	-f hex2_linker-2.hex2 \
	-o hex2

    #####################################
    # Phase-11 Build kaem from C sources#
    #####################################
    M2 --architecture ${ARCH} \
	-f ${M2libc/sys/types.h} \
	-f ${M2libc/stddef.h} \
	-f ${M2libc/string.c} \
	-f ${M2libc/${ARCH}/linux/unistd.c} \
	-f ${M2libc/${ARCH}/linux/fcntl.c} \
	-f ${M2libc/fcntl.c} \
	-f ${M2libc/stdlib.c} \
	-f ${M2libc/stdio.h} \
	-f ${M2libc/stdio.c} \
	-f ${M2libc/bootstrappable.c} \
	-f ${mescc-tools/Kaem/kaem.h} \
	-f ${mescc-tools/Kaem/variable.c} \
	-f ${mescc-tools/Kaem/kaem_globals.c} \
	-f ${mescc-tools/Kaem/kaem.c} \
	--debug \
	-o kaem.M1

    blood-elf-0 -f kaem.M1 ${ENDIAN_FLAG} -o kaem-footer.M1

    M1 --architecture ${ARCH} \
	${ENDIAN_FLAG} \
	-f ${M2libc/${ARCH}/x86_defs.M1} \
	-f ${M2libc/${ARCH}/libc-full.M1} \
	-f kaem.M1 \
	-f kaem-footer.M1 \
	-o kaem.hex2

    hex2 --architecture ${ARCH} \
	${ENDIAN_FLAG} \
	-f ${M2libc/${ARCH}/ELF-x86-debug.hex2} \
	-f kaem.hex2 \
	--base-address ${BASE_ADDRESS} \
	-o kaem

    kaem --verbose --strict --file ${mescc-tools-full-kaem}
    kaem --verbose --strict --file ${mescc-tools-extra}
    kaem --verbose --strict --file ${install}
    kaem --verbose --strict --file ${check}
    '';

    mescc-tools-full-kaem = builtins.toFile "mescc-tools-full-kaem.kaem" ''
    #!/usr/bin/env bash
    # Mes --- Maxwell Equations of Software
    # Copyright © 2017,2019 Jan Nieuwenhuizen <janneke@gnu.org>
    # Copyright © 2017,2019 Jeremiah Orians
    #
    # This file is part of Mes.
    #
    # Mes is free software; you can redistribute it and/or modify it
    # under the terms of the GNU General Public License as published by
    # the Free Software Foundation; either version 3 of the License, or (at
    # your option) any later version.
    #
    # Mes is distributed in the hope that it will be useful, but
    # WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.
    #
    # You should have received a copy of the GNU General Public License
    # along with Mes.  If not, see <http://www.gnu.org/licenses/>.


    ###############################################
    # Phase-12 Build M2-Mesoplanet from M2-Planet #
    ###############################################

    ./M2 --architecture ${ARCH} \
	-f ${M2libc/sys/types.h} \
	-f ${M2libc/stddef.h} \
	-f ${M2libc/${ARCH}/linux/fcntl.c} \
	-f ${M2libc/fcntl.c} \
	-f ${M2libc/${ARCH}/linux/unistd.c} \
	-f ${M2libc/${ARCH}/linux/sys/stat.c} \
	-f ${M2libc/stdlib.c} \
	-f ${M2libc/stdio.h} \
	-f ${M2libc/stdio.c} \
	-f ${M2libc/string.c} \
	-f ${M2libc/bootstrappable.c} \
	-f ${M2-Mesoplanet/cc.h} \
	-f ${M2-Mesoplanet/cc_globals.c} \
	-f ${M2-Mesoplanet/cc_env.c} \
	-f ${M2-Mesoplanet/cc_reader.c} \
	-f ${M2-Mesoplanet/cc_spawn.c} \
	-f ${M2-Mesoplanet/cc_core.c} \
	-f ${M2-Mesoplanet/cc_macro.c} \
	-f ${M2-Mesoplanet/cc.c} \
	--debug \
	-o M2-Mesoplanet-1.M1

    ./blood-elf-0 ${ENDIAN_FLAG} ${BLOOD_FLAG} -f M2-Mesoplanet-1.M1 -o M2-Mesoplanet-1-footer.M1

    ./M1 --architecture ${ARCH} \
	${ENDIAN_FLAG} \
	-f ${M2libc/${ARCH}/${ARCH}_defs.M1} \
	-f ${M2libc/${ARCH}/libc-full.M1} \
	-f M2-Mesoplanet-1.M1 \
	-f M2-Mesoplanet-1-footer.M1 \
	-o M2-Mesoplanet-1.hex2

    ./hex2 --architecture ${ARCH} \
	${ENDIAN_FLAG} \
	--base-address ${BASE_ADDRESS} \
	-f ${M2libc/${ARCH}/ELF-${ARCH}-debug.hex2} \
	-f M2-Mesoplanet-1.hex2 \
	-o M2-Mesoplanet

     #################################################
     # Phase-13 Build final blood-elf from C sources #
     #################################################

     ./M2 --architecture ${ARCH} \
	-f ${M2libc/sys/types.h} \
	-f ${M2libc/stddef.h} \
	-f ${M2libc/${ARCH}/linux/fcntl.c} \
	-f ${M2libc/fcntl.c} \
	-f ${M2libc/${ARCH}/linux/unistd.c} \
	-f ${M2libc/stdlib.c} \
	-f ${M2libc/stdio.h} \
	-f ${M2libc/stdio.c} \
	-f ${M2libc/bootstrappable.c} \
	-f ${mescc-tools/stringify.c} \
	-f ${mescc-tools/blood-elf.c} \
	--debug \
	-o blood-elf-1.M1

    ./blood-elf-0 ${BLOOD_FLAG} ${ENDIAN_FLAG} -f blood-elf-1.M1 -o blood-elf-1-footer.M1
    ./M1 --architecture ${ARCH} \
	${ENDIAN_FLAG} \
	-f ${M2libc/${ARCH}/${ARCH}_defs.M1} \
	-f ${M2libc/${ARCH}/libc-full.M1} \
	-f blood-elf-1.M1 \
	-f blood-elf-1-footer.M1 \
	-o blood-elf-1.hex2

    ./hex2 --architecture ${ARCH} \
	${ENDIAN_FLAG} \
	--base-address ${BASE_ADDRESS} \
	-f ${M2libc/${ARCH}/ELF-${ARCH}-debug.hex2} \
	-f blood-elf-1.hex2 \
	-o blood-elf

    #############################################
    # Phase-14 Build get_machine from C sources #
    #############################################

    ./M2 --architecture ${ARCH} \
	-f ${M2libc/sys/types.h} \
	-f ${M2libc/stddef.h} \
	-f ${M2libc/${ARCH}/linux/unistd.c} \
	-f ${M2libc/${ARCH}/linux/fcntl.c} \
	-f ${M2libc/fcntl.c} \
	-f ${M2libc/stdlib.c} \
	-f ${M2libc/stdio.h} \
	-f ${M2libc/stdio.c} \
	-f ${M2libc/bootstrappable.c} \
	-f ${mescc-tools/get_machine.c} \
	--debug \
	-o get_machine.M1

    ./blood-elf ${BLOOD_FLAG} ${ENDIAN_FLAG} -f get_machine.M1 -o get_machine-footer.M1

    ./M1 --architecture ${ARCH} \
	${ENDIAN_FLAG} \
	-f ${M2libc/${ARCH}/${ARCH}_defs.M1} \
	-f ${M2libc/${ARCH}/libc-full.M1} \
	-f get_machine.M1 \
	-f get_machine-footer.M1 \
	-o get_machine.hex2

    ./hex2 --architecture ${ARCH} \
	${ENDIAN_FLAG} \
	--base-address ${BASE_ADDRESS} \
	-f ${M2libc/${ARCH}/ELF-${ARCH}-debug.hex2} \
	-f get_machine.hex2 \
	-o get_machine

    ############################################
    # Phase-15 Build M2-Planet from M2-Planet  #
    ############################################

    ./M2 --architecture ${ARCH} \
	-f ${M2libc/sys/types.h} \
	-f ${M2libc/stddef.h} \
	-f ${M2libc/${ARCH}/linux/unistd.c} \
	-f ${M2libc/${ARCH}/linux/fcntl.c} \
	-f ${M2libc/fcntl.c} \
	-f ${M2libc/stdlib.c} \
	-f ${M2libc/stdio.h} \
	-f ${M2libc/stdio.c} \
	-f ${M2libc/bootstrappable.c} \
	-f ${M2-Planet/cc.h} \
	-f ${M2-Planet/cc_globals.c} \
	-f ${M2-Planet/cc_reader.c} \
	-f ${M2-Planet/cc_strings.c} \
	-f ${M2-Planet/cc_types.c} \
	-f ${M2-Planet/cc_core.c} \
	-f ${M2-Planet/cc_macro.c} \
	-f ${M2-Planet/cc.c} \
	--debug \
	-o M2-1.M1

    ./blood-elf ${ENDIAN_FLAG} ${BLOOD_FLAG} -f M2-1.M1 -o M2-1-footer.M1

    ./M1 --architecture ${ARCH} \
	${ENDIAN_FLAG} \
	-f ${M2libc/${ARCH}/${ARCH}_defs.M1} \
	-f ${M2libc/${ARCH}/libc-full.M1} \
	-f M2-1.M1 \
	-f M2-1-footer.M1 \
	-o M2-1.hex2

    ./hex2 --architecture ${ARCH} \
	${ENDIAN_FLAG} \
	--base-address ${BASE_ADDRESS} \
	-f ${M2libc/${ARCH}/ELF-${ARCH}-debug.hex2} \
	-f M2-1.hex2 \
	-o M2-Planet
    '';

    mescc-tools-extra = builtins.toFile "mescc-tools-extra.kaem" ''
    set -ex

    M2LIBC_PATH=${./M2libc}
    PATH=.

    alias CC="./M2-Mesoplanet${EXE_SUFFIX} --operating-system ${OPERATING_SYSTEM} --architecture ${ARCH} -f"

    CC ${mescc-tools-extra/sha256sum.c} -o sha256sum${EXE_SUFFIX}
    CC ${mescc-tools-extra/match.c} -o match${EXE_SUFFIX}
    CC ${mescc-tools-extra/mkdir.c} -o mkdir${EXE_SUFFIX}
    CC ${mescc-tools-extra/untar.c} -o untar${EXE_SUFFIX}
    CC ${mescc-tools-extra/ungz.c} -o ungz${EXE_SUFFIX}
    CC ${mescc-tools-extra/unbz2.c} -o unbz2${EXE_SUFFIX}
    CC ${mescc-tools-extra/catm.c} -o catm${EXE_SUFFIX}
    CC ${mescc-tools-extra/cp.c} -o cp${EXE_SUFFIX}
    CC ${mescc-tools-extra/chmod.c} -o chmod${EXE_SUFFIX}
    CC ${mescc-tools-extra/rm.c} -o rm${EXE_SUFFIX}
    CC ${mescc-tools-extra/replace.c} -o replace${EXE_SUFFIX}
    '';

    install = builtins.toFile "install.kaem" ''
    bin=''${out}
    ./mkdir -p ''${bin}/bin

    ./cp blood-elf ''${bin}/bin
    ./chmod 555 ''${bin}/bin/blood-elf
    ./cp catm ''${bin}/bin
    ./chmod 555 ''${bin}/bin/catm
    ./cp chmod ''${bin}/bin
    ./chmod 555 ''${bin}/bin/chmod
    ./cp cp ''${bin}/bin
    ./chmod 555 ''${bin}/bin/cp
    ./cp get_machine ''${bin}/bin
    ./chmod 555 ''${bin}/bin/get_machine
    ./cp hex2 ''${bin}/bin
    ./chmod 555 ''${bin}/bin/hex2
    ./cp kaem ''${bin}/bin
    ./chmod 555 ''${bin}/bin/kaem
    ./cp M1 ''${bin}/bin
    ./chmod 555 ''${bin}/bin/M1
    ./cp M2-Mesoplanet ''${bin}/bin
    ./chmod 555 ''${bin}/bin/M2-Mesoplanet
    ./cp M2-Planet ''${bin}/bin
    ./chmod 555 ''${bin}/bin/M2-Planet
    ./cp match ''${bin}/bin
    ./chmod 555 ''${bin}/bin/match
    ./cp mkdir ''${bin}/bin
    ./chmod 555 ''${bin}/bin/mkdir
    ./cp replace ''${bin}/bin
    ./chmod 555 ''${bin}/bin/replace
    ./cp rm ''${bin}/bin
    ./chmod 555 ''${bin}/bin/rm
    ./cp sha256sum ''${bin}/bin
    ./chmod 555 ''${bin}/bin/sha256sum
    ./cp ungz ''${bin}/bin
    ./chmod 555 ''${bin}/bin/ungz
    ./cp unbz2 ''${bin}/bin
    ./chmod 555 ''${bin}/bin/unbz2
    ./cp untar ''${bin}/bin
    ./chmod 555 ''${bin}/bin/untar
    '';

    check = builtins.toFile "check.kaem" ''
    cd ''${out}
    ./bin/sha256sum \
      bin/blood-elf \
      bin/catm \
      bin/chmod \
      bin/cp \
      bin/get_machine \
      bin/hex2 \
      bin/kaem \
      bin/M1 \
      bin/M2-Mesoplanet \
      bin/M2-Planet \
      bin/match \
      bin/mkdir \
      bin/replace \
      bin/rm \
      bin/sha256sum \
      bin/ungz \
      bin/unbz2 \
      bin/untar
    '';
in lib.fixDerivation (final:
{
  inherit system ARCH BASE_ADDRESS;
  name = "stage0-${ARCH}";
    
  builder = "${stage0-seed-bin}/kaem-seed";
  args = [ mescc-tools-seed-kaem ];
    
#  outputHashMode = "recursive";
#  outputHashAlgo = "sha256";
#  outputHash = "d6Aa2/CxUhu29ZA+W0lodZfudfCFwf7rgSaTTm8yHe4=";
    
  allowedReferences = [];
})

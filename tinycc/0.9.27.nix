{ stage0env
, mes
, tcc
, ...
}:
stage0env.override (final: prev: with final;
{
  pname = "tcc";
  version = "0.9.27";
  src = builtins.fetchurl
    { url = "https://download.savannah.gnu.org/releases/tinycc/${name}.tar.bz2";
      sha256="de23af78fca90ce32dff2dd45b3432b2334740bb9bb7b05bf60fdbfc396ceb9c";
    };

  buildInputs = [ tcc ];

  MES_PREFIX="${mes}/share/${mes.name}";
  incdir="${mes.dev}/include";

  configurePhase = ''
    # Create config.h
    catm config.h
  '';

  buildPhase = ''
    # Compile
    tcc \
      -v \
      -static \
      -o tcc \
      -D TCC_TARGET_I386=1 \
      -D CONFIG_TCCDIR=\"''${out}/lib/tcc\" \
      -D CONFIG_TCC_CRTPREFIX=\"''${out}/lib\" \
      -D CONFIG_TCC_ELFINTERP=\"/mes/loader\" \
      -D CONFIG_TCC_LIBPATHS=\"''${out}/lib:''${out}/lib/tcc\" \
      -D CONFIG_TCC_SYSINCLUDEPATHS=\"${incdir}\" \
      -D TCC_LIBGCC=\"''${out}/lib/libc.a\" \
      -D CONFIG_TCC_STATIC=1 \
      -D CONFIG_USE_LIBGCC=1 \
      -D TCC_VERSION=\"0.9.27\" \
      -D ONE_SOURCE=1 \
      tcc.c

    ./tcc -version
  '';

  installPhase = '' 
    bindir=''${out}/bin
    libdir=''${out}/lib
    mkdir -p ''${bindir} ''${libdir}/tcc

    cp tcc ''${bindir}
    chmod 755 ''${bindir}/tcc

    # Recompile the mes C library

    # Create unified libc file
    catm unified-libc.c ${MES_PREFIX}/lib/ctype/isalnum.c ${MES_PREFIX}/lib/ctype/isalpha.c ${MES_PREFIX}/lib/ctype/isascii.c ${MES_PREFIX}/lib/ctype/iscntrl.c ${MES_PREFIX}/lib/ctype/isdigit.c ${MES_PREFIX}/lib/ctype/isgraph.c ${MES_PREFIX}/lib/ctype/islower.c ${MES_PREFIX}/lib/ctype/isnumber.c ${MES_PREFIX}/lib/ctype/isprint.c ${MES_PREFIX}/lib/ctype/ispunct.c ${MES_PREFIX}/lib/ctype/isspace.c ${MES_PREFIX}/lib/ctype/isupper.c ${MES_PREFIX}/lib/ctype/isxdigit.c ${MES_PREFIX}/lib/ctype/tolower.c ${MES_PREFIX}/lib/ctype/toupper.c ${MES_PREFIX}/lib/dirent/closedir.c ${MES_PREFIX}/lib/dirent/__getdirentries.c ${MES_PREFIX}/lib/dirent/opendir.c ${MES_PREFIX}/lib/dirent/readdir.c ${MES_PREFIX}/lib/linux/access.c ${MES_PREFIX}/lib/linux/brk.c ${MES_PREFIX}/lib/linux/chdir.c ${MES_PREFIX}/lib/linux/chmod.c ${MES_PREFIX}/lib/linux/clock_gettime.c ${MES_PREFIX}/lib/linux/close.c ${MES_PREFIX}/lib/linux/dup2.c ${MES_PREFIX}/lib/linux/dup.c ${MES_PREFIX}/lib/linux/execve.c ${MES_PREFIX}/lib/linux/fcntl.c ${MES_PREFIX}/lib/linux/fork.c ${MES_PREFIX}/lib/linux/fsync.c ${MES_PREFIX}/lib/linux/fstat.c ${MES_PREFIX}/lib/linux/_getcwd.c ${MES_PREFIX}/lib/linux/getdents.c ${MES_PREFIX}/lib/linux/getegid.c ${MES_PREFIX}/lib/linux/geteuid.c ${MES_PREFIX}/lib/linux/getgid.c ${MES_PREFIX}/lib/linux/getpid.c ${MES_PREFIX}/lib/linux/getppid.c ${MES_PREFIX}/lib/linux/getrusage.c ${MES_PREFIX}/lib/linux/gettimeofday.c ${MES_PREFIX}/lib/linux/getuid.c ${MES_PREFIX}/lib/linux/ioctl.c ${MES_PREFIX}/lib/linux/ioctl3.c ${MES_PREFIX}/lib/linux/kill.c ${MES_PREFIX}/lib/linux/link.c ${MES_PREFIX}/lib/linux/lseek.c ${MES_PREFIX}/lib/linux/lstat.c ${MES_PREFIX}/lib/linux/malloc.c ${MES_PREFIX}/lib/linux/mkdir.c ${MES_PREFIX}/lib/linux/mknod.c ${MES_PREFIX}/lib/linux/nanosleep.c ${MES_PREFIX}/lib/linux/_open3.c ${MES_PREFIX}/lib/linux/pipe.c ${MES_PREFIX}/lib/linux/_read.c ${MES_PREFIX}/lib/linux/readlink.c ${MES_PREFIX}/lib/linux/rename.c ${MES_PREFIX}/lib/linux/rmdir.c ${MES_PREFIX}/lib/linux/setgid.c ${MES_PREFIX}/lib/linux/settimer.c ${MES_PREFIX}/lib/linux/setuid.c ${MES_PREFIX}/lib/linux/signal.c ${MES_PREFIX}/lib/linux/sigprogmask.c ${MES_PREFIX}/lib/linux/symlink.c ${MES_PREFIX}/lib/linux/stat.c ${MES_PREFIX}/lib/linux/time.c ${MES_PREFIX}/lib/linux/unlink.c ${MES_PREFIX}/lib/linux/waitpid.c ${MES_PREFIX}/lib/linux/x86-mes-gcc/_exit.c ${MES_PREFIX}/lib/linux/x86-mes-gcc/syscall.c ${MES_PREFIX}/lib/linux/x86-mes-gcc/_write.c ${MES_PREFIX}/lib/math/ceil.c ${MES_PREFIX}/lib/math/fabs.c ${MES_PREFIX}/lib/math/floor.c ${MES_PREFIX}/lib/mes/abtod.c ${MES_PREFIX}/lib/mes/abtol.c ${MES_PREFIX}/lib/mes/__assert_fail.c ${MES_PREFIX}/lib/mes/assert_msg.c ${MES_PREFIX}/lib/mes/__buffered_read.c ${MES_PREFIX}/lib/mes/cast.c ${MES_PREFIX}/lib/mes/dtoab.c ${MES_PREFIX}/lib/mes/eputc.c ${MES_PREFIX}/lib/mes/eputs.c ${MES_PREFIX}/lib/mes/fdgetc.c ${MES_PREFIX}/lib/mes/fdgets.c ${MES_PREFIX}/lib/mes/fdputc.c ${MES_PREFIX}/lib/mes/fdputs.c ${MES_PREFIX}/lib/mes/fdungetc.c ${MES_PREFIX}/lib/mes/globals.c ${MES_PREFIX}/lib/mes/itoa.c ${MES_PREFIX}/lib/mes/ltoab.c ${MES_PREFIX}/lib/mes/ltoa.c ${MES_PREFIX}/lib/mes/__mes_debug.c ${MES_PREFIX}/lib/mes/mes_open.c ${MES_PREFIX}/lib/mes/ntoab.c ${MES_PREFIX}/lib/mes/oputc.c ${MES_PREFIX}/lib/mes/oputs.c ${MES_PREFIX}/lib/mes/search-path.c ${MES_PREFIX}/lib/mes/ultoa.c ${MES_PREFIX}/lib/mes/utoa.c ${MES_PREFIX}/lib/posix/alarm.c ${MES_PREFIX}/lib/posix/buffered-read.c ${MES_PREFIX}/lib/posix/execl.c ${MES_PREFIX}/lib/posix/execlp.c ${MES_PREFIX}/lib/posix/execv.c ${MES_PREFIX}/lib/posix/execvp.c ${MES_PREFIX}/lib/posix/getcwd.c ${MES_PREFIX}/lib/posix/getenv.c ${MES_PREFIX}/lib/posix/isatty.c ${MES_PREFIX}/lib/posix/mktemp.c ${MES_PREFIX}/lib/posix/open.c ${MES_PREFIX}/lib/posix/raise.c ${MES_PREFIX}/lib/posix/sbrk.c ${MES_PREFIX}/lib/posix/setenv.c ${MES_PREFIX}/lib/posix/sleep.c ${MES_PREFIX}/lib/posix/unsetenv.c ${MES_PREFIX}/lib/posix/wait.c ${MES_PREFIX}/lib/posix/write.c ${MES_PREFIX}/lib/stdio/clearerr.c ${MES_PREFIX}/lib/stdio/fclose.c ${MES_PREFIX}/lib/stdio/fdopen.c ${MES_PREFIX}/lib/stdio/feof.c ${MES_PREFIX}/lib/stdio/ferror.c ${MES_PREFIX}/lib/stdio/fflush.c ${MES_PREFIX}/lib/stdio/fgetc.c ${MES_PREFIX}/lib/stdio/fgets.c ${MES_PREFIX}/lib/stdio/fileno.c ${MES_PREFIX}/lib/stdio/fopen.c ${MES_PREFIX}/lib/stdio/fprintf.c ${MES_PREFIX}/lib/stdio/fputc.c ${MES_PREFIX}/lib/stdio/fputs.c ${MES_PREFIX}/lib/stdio/fread.c ${MES_PREFIX}/lib/stdio/freopen.c ${MES_PREFIX}/lib/stdio/fscanf.c ${MES_PREFIX}/lib/stdio/fseek.c ${MES_PREFIX}/lib/stdio/ftell.c ${MES_PREFIX}/lib/stdio/fwrite.c ${MES_PREFIX}/lib/stdio/getc.c ${MES_PREFIX}/lib/stdio/getchar.c ${MES_PREFIX}/lib/stdio/perror.c ${MES_PREFIX}/lib/stdio/printf.c ${MES_PREFIX}/lib/stdio/putc.c ${MES_PREFIX}/lib/stdio/putchar.c ${MES_PREFIX}/lib/stdio/remove.c ${MES_PREFIX}/lib/stdio/snprintf.c ${MES_PREFIX}/lib/stdio/sprintf.c ${MES_PREFIX}/lib/stdio/sscanf.c ${MES_PREFIX}/lib/stdio/ungetc.c ${MES_PREFIX}/lib/stdio/vfprintf.c ${MES_PREFIX}/lib/stdio/vfscanf.c ${MES_PREFIX}/lib/stdio/vprintf.c ${MES_PREFIX}/lib/stdio/vsnprintf.c ${MES_PREFIX}/lib/stdio/vsprintf.c ${MES_PREFIX}/lib/stdio/vsscanf.c ${MES_PREFIX}/lib/stdlib/abort.c ${MES_PREFIX}/lib/stdlib/abs.c ${MES_PREFIX}/lib/stdlib/alloca.c ${MES_PREFIX}/lib/stdlib/atexit.c ${MES_PREFIX}/lib/stdlib/atof.c ${MES_PREFIX}/lib/stdlib/atoi.c ${MES_PREFIX}/lib/stdlib/atol.c ${MES_PREFIX}/lib/stdlib/calloc.c ${MES_PREFIX}/lib/stdlib/__exit.c ${MES_PREFIX}/lib/stdlib/exit.c ${MES_PREFIX}/lib/stdlib/free.c ${MES_PREFIX}/lib/stdlib/mbstowcs.c ${MES_PREFIX}/lib/stdlib/puts.c ${MES_PREFIX}/lib/stdlib/qsort.c ${MES_PREFIX}/lib/stdlib/realloc.c ${MES_PREFIX}/lib/stdlib/strtod.c ${MES_PREFIX}/lib/stdlib/strtof.c ${MES_PREFIX}/lib/stdlib/strtol.c ${MES_PREFIX}/lib/stdlib/strtold.c ${MES_PREFIX}/lib/stdlib/strtoll.c ${MES_PREFIX}/lib/stdlib/strtoul.c ${MES_PREFIX}/lib/stdlib/strtoull.c ${MES_PREFIX}/lib/string/bcmp.c ${MES_PREFIX}/lib/string/bcopy.c ${MES_PREFIX}/lib/string/bzero.c ${MES_PREFIX}/lib/string/index.c ${MES_PREFIX}/lib/string/memchr.c ${MES_PREFIX}/lib/string/memcmp.c ${MES_PREFIX}/lib/string/memcpy.c ${MES_PREFIX}/lib/string/memmem.c ${MES_PREFIX}/lib/string/memmove.c ${MES_PREFIX}/lib/string/memset.c ${MES_PREFIX}/lib/string/rindex.c ${MES_PREFIX}/lib/string/strcat.c ${MES_PREFIX}/lib/string/strchr.c ${MES_PREFIX}/lib/string/strcmp.c ${MES_PREFIX}/lib/string/strcpy.c ${MES_PREFIX}/lib/string/strcspn.c ${MES_PREFIX}/lib/string/strdup.c ${MES_PREFIX}/lib/string/strerror.c ${MES_PREFIX}/lib/string/strlen.c ${MES_PREFIX}/lib/string/strlwr.c ${MES_PREFIX}/lib/string/strncat.c ${MES_PREFIX}/lib/string/strncmp.c ${MES_PREFIX}/lib/string/strncpy.c ${MES_PREFIX}/lib/string/strpbrk.c ${MES_PREFIX}/lib/string/strrchr.c ${MES_PREFIX}/lib/string/strspn.c ${MES_PREFIX}/lib/string/strstr.c ${MES_PREFIX}/lib/string/strupr.c ${MES_PREFIX}/lib/stub/atan2.c ${MES_PREFIX}/lib/stub/bsearch.c ${MES_PREFIX}/lib/stub/chown.c ${MES_PREFIX}/lib/stub/__cleanup.c ${MES_PREFIX}/lib/stub/cos.c ${MES_PREFIX}/lib/stub/ctime.c ${MES_PREFIX}/lib/stub/exp.c ${MES_PREFIX}/lib/stub/fpurge.c ${MES_PREFIX}/lib/stub/freadahead.c ${MES_PREFIX}/lib/stub/frexp.c ${MES_PREFIX}/lib/stub/getgrgid.c ${MES_PREFIX}/lib/stub/getgrnam.c ${MES_PREFIX}/lib/stub/getlogin.c ${MES_PREFIX}/lib/stub/getpgid.c ${MES_PREFIX}/lib/stub/getpgrp.c ${MES_PREFIX}/lib/stub/getpwnam.c ${MES_PREFIX}/lib/stub/getpwuid.c ${MES_PREFIX}/lib/stub/gmtime.c ${MES_PREFIX}/lib/stub/ldexp.c ${MES_PREFIX}/lib/stub/localtime.c ${MES_PREFIX}/lib/stub/log.c ${MES_PREFIX}/lib/stub/mktime.c ${MES_PREFIX}/lib/stub/modf.c ${MES_PREFIX}/lib/stub/mprotect.c ${MES_PREFIX}/lib/stub/pclose.c ${MES_PREFIX}/lib/stub/popen.c ${MES_PREFIX}/lib/stub/pow.c ${MES_PREFIX}/lib/stub/rand.c ${MES_PREFIX}/lib/stub/rewind.c ${MES_PREFIX}/lib/stub/setbuf.c ${MES_PREFIX}/lib/stub/setgrent.c ${MES_PREFIX}/lib/stub/setlocale.c ${MES_PREFIX}/lib/stub/setvbuf.c ${MES_PREFIX}/lib/stub/sigaction.c ${MES_PREFIX}/lib/stub/sigaddset.c ${MES_PREFIX}/lib/stub/sigblock.c ${MES_PREFIX}/lib/stub/sigdelset.c ${MES_PREFIX}/lib/stub/sigemptyset.c ${MES_PREFIX}/lib/stub/sigsetmask.c ${MES_PREFIX}/lib/stub/sin.c ${MES_PREFIX}/lib/stub/sys_siglist.c ${MES_PREFIX}/lib/stub/system.c ${MES_PREFIX}/lib/stub/sqrt.c ${MES_PREFIX}/lib/stub/strftime.c ${MES_PREFIX}/lib/stub/times.c ${MES_PREFIX}/lib/stub/ttyname.c ${MES_PREFIX}/lib/stub/umask.c ${MES_PREFIX}/lib/stub/utime.c ${MES_PREFIX}/lib/x86-mes-gcc/setjmp.c

    # Recompile libc: crt{1,n,i}, libtcc.a, libc.a
    ''${bindir}/tcc -c -D HAVE_CONFIG_H=1 -I ${incdir} -I ${incdir}/linux/x86 -o ''${libdir}/crt1.o ${MES_PREFIX}/lib/linux/x86-mes-gcc/crt1.c
    ''${bindir}/tcc -c -D HAVE_CONFIG_H=1 -I ${incdir} -I ${incdir}/linux/x86 -o ''${libdir}/crtn.o ${MES_PREFIX}/lib/linux/x86-mes-gcc/crtn.c
    ''${bindir}/tcc -c -D HAVE_CONFIG_H=1 -I ${incdir} -I ${incdir}/linux/x86 -o ''${libdir}/crti.o ${MES_PREFIX}/lib/linux/x86-mes-gcc/crti.c
#    ''${bindir}/tcc -c -D HAVE_CONFIG_H=1 -D HAVE_LONG_LONG_STUB=1 -I ${incdir} -I ${incdir}/linux/x86 ${MES_PREFIX}/lib/libtcc1.c
    ''${bindir}/tcc -c -D TCC_TARGET_I386=1 lib/libtcc1.c
    ''${bindir}/tcc -ar cr ''${libdir}/tcc/libtcc1.a libtcc1.o
    ''${bindir}/tcc -c -D HAVE_CONFIG_H=1 -I ${incdir} -I ${incdir}/linux/x86 -o unified-libc.o unified-libc.c
    ''${bindir}/tcc -ar cr ''${libdir}/libc.a unified-libc.o

    # Also recompile getopt, we don't need to do this during the boot* stages
    # because nothing is linked against it
    ''${bindir}/tcc -c -D HAVE_CONFIG_H=1 -I ${incdir} -I ${incdir}/linux/x86  ${MES_PREFIX}/lib/posix/getopt.c
    ''${bindir}/tcc -ar cr ''${libdir}/libgetopt.a getopt.o
  '';

  allowedReferences = [ "out" mes mes.dev ];
})

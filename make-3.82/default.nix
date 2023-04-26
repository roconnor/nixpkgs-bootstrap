{ stage0env
, tcc
, ...
}:
stage0env.override (final: prev: with final;
{
  pname = "make";
  version = "3.82";
  src = builtins.fetchurl
    { url = "https://mirrors.kernel.org/gnu/${pname}/${pname}-${version}.tar.bz2";
      sha256="e2c1a73f179c40c71e2fe8abf8a8a0688b8499538512984da4a76958d0402966";
    };

  buildInputs = [ tcc ]; 

  configurePhase = ''
    catm config.h

    # Prepare
    cp ${files/putenv_stub.c} putenv_stub.c
  '';

  buildPhase = ''
    # Compile
    tcc -c getopt.c
    tcc -c getopt1.c
    tcc -c -I. -Iglob -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DHAVE_STDINT_H ar.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DHAVE_FCNTL_H arscan.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DFILE_TIMESTAMP_HI_RES=0 commands.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DSCCS_GET=\"/nullop\" default.c
    tcc -c -I. -Iglob -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DHAVE_DIRENT_H dir.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART expand.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DFILE_TIMESTAMP_HI_RES=0 file.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -Dvfork=fork function.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART implicit.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DHAVE_DUP2 -DHAVE_STRCHR -Dvfork=fork job.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DLOCALEDIR=\"/fake-locale\" -DPACKAGE=\"fake-make\" -DHAVE_MKTEMP -DHAVE_GETCWD main.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DHAVE_STRERROR -DHAVE_VPRINTF -DHAVE_ANSI_COMPILER -DHAVE_STDARG_H misc.c
    tcc -c -I. -Iglob -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DINCLUDEDIR=\"\" read.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART -DFILE_TIMESTAMP_HI_RES=0 -DHAVE_FCNTL_H -DLIBDIR=\"\" remake.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART rule.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART signame.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART strcache.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART variable.c
    tcc -c -I. -DVERSION=\"3.82\" version.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART vpath.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART hash.c
    tcc -c -I. -DHAVE_INTTYPES_H -DHAVE_SA_RESTART remote-stub.c
    tcc -c -DHAVE_FCNTL_H getloadavg.c
    tcc -c -Iglob -DSTDC_HEADERS glob/fnmatch.c
    tcc -c -Iglob -DHAVE_STRDUP -DHAVE_DIRENT_H glob/glob.c
    tcc -c putenv_stub.c

    # Link
    tcc -static -o make getopt.o getopt1.o ar.o arscan.o commands.o default.o dir.o expand.o file.o function.o implicit.o job.o main.o misc.o read.o remake.o rule.o signame.o strcache.o variable.o version.o vpath.o hash.o remote-stub.o getloadavg.o fnmatch.o glob.o putenv_stub.o
  '';

  installPhase = ''
    bindir=''${out}/bin
    mkdir -p ''${bindir}
    cp make ''${bindir}
    chmod 755 ''${bindir}/make
  '';
})

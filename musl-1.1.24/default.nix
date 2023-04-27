{ stage1env
, tcc
, make
, sed
, bash
, ...
}:
stage1env.override (final: prev: with final;
{
  pname = "musl";
  version = "1.1.24";

  src = builtins.fetchurl {
    url = "https://musl.libc.org/releases/${name}.tar.gz";
    sha256="1370c9a812b2cf2a7d92802510cca0058cc37e66a7bedd70051f0a34015022a3";
  };

  buildInputs = [ tcc make sed ];

  patches = [
    patches/avoid_set_thread_area.patch
    patches/avoid_sys_clone.patch
    patches/fenv.patch
    patches/makefile.patch
    patches/musl_weak_symbols.patch
    patches/set_thread_area.patch
    patches/sigsetjmp.patch
    patches/stdio_flush_on_exit.patch
    patches/va_list.patch
  ];

  configurePhase = ''
    rm -rf src/complex

    mkdir -p $out/bin $out/lib/i386-unknown-linux-musl $out/include/musl
 
    CC=tcc ./configure \
      --host=i386 \
      --disable-shared \
      --prefix="''${out}" \
      --libdir="''${out}/lib/i386-unknown-linux-musl" \
      --includedir="''${out}/include/musl"

    cat config.mak
  '';

  buildPhase = ''
    echo ${tcc}
    make CROSS_COMPILE= AR="tcc -ar" RANLIB=true CFLAGS="-DSYSCALL_NO_TLS"
  '';
})

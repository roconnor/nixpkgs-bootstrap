{ stage0env
, tcc
, make
, ...
}:
stage0env.override (final: prev: with final;
{
  pname = "sed";
  version = "4.0.9";

  src = builtins.fetchurl {
    url = "https://mirrors.kernel.org/gnu/${pname}/${name}.tar.gz";
    sha256="c365874794187f8444e5d22998cd5888ffa47f36def4b77517a808dec27c0600";
  };

  buildInputs = [ tcc make ]; 

  configurePhase = ''
    catm config.h
  '';

  LIBC = "mes";
  makefile = mk/main.mk;

  installPhase = ''
    bindir=''${out}/bin
    mkdir -p ''${bindir}
    cp sed/sed ''${bindir}
    chmod 755 ''${bindir}/sed
  '';
})

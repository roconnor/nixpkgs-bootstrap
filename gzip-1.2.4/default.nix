{ stage0env
, tcc
, make
, ...
}:
stage0env.override (final: prev: with final;
{
  pname = "gzip";
  version = "1.2.4";

  src = builtins.fetchurl
    { url = "https://mirrors.kernel.org/gnu/${pname}/${name}.tar.gz";
      sha256="1ca41818a23c9c59ef1d5e1d00c0d5eaa2285d931c0fb059637d7c0cc02ad967";
    };

  buildInputs = [ tcc make ]; 

  configurePhase = ''
    catm gzip.c.new ${./files/stat_override.c} gzip.c
    cp gzip.c.new gzip.c
  '';

  makefile = mk/main.mk;

  installPhase = ''
    bindir=''${out}/bin
    mkdir -p ''${bindir}
    cp gzip ''${bindir}/gzip
    cp gzip ''${bindir}/gunzip
    chmod 755 ''${bindir}/gzip
    chmod 755 ''${bindir}/gunzip
  '';
})

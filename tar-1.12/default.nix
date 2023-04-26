{ stage0env
, tcc
, make
, ...
}:
stage0env.override (final: prev: with final;
{
  pname = "tar";
  version = "1.12";

  src = builtins.fetchurl {
    url = "https://mirrors.kernel.org/gnu/${pname}/${name}.tar.gz";
    sha256="c6c37e888b136ccefab903c51149f4b7bd659d69d4aea21245f61053a57aa60a";
  };

  buildInputs = [ tcc make ];

  configurePhase = ''
    cp ${./files/getdate_stub.c} lib/getdate_stub.c
    catm src/create.c.new ${./files/stat_override.c} src/create.c
    cp src/create.c.new src/create.c
  '';

  makefile = mk/main.mk;

  installPhase = ''
    bindir=''${out}
    mkdir -p ''${bindir}
    cp tar ''${bindir}
    chmod 755 ''${bindir}/tar
  '';
})

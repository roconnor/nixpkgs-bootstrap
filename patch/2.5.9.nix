{ stage0env
, tcc
, make
, ...
}:
stage0env.override (final: prev: with final;
{
  pname = "patch";
  version = "2.5.9";

  src = builtins.fetchurl {
    url = "https://mirrors.kernel.org/gnu/${pname}/${name}.tar.gz";
    sha256="ecb5c6469d732bcf01d6ec1afe9e64f1668caba5bfdb103c28d7f537ba3cdb8a";
  };

  buildInputs = [ tcc make ]; 

  configurePhase = ''
    catm config.h
    catm patchlevel.h
  '';

  makefile = mk/main.mk;

  installPhase = ''
    bindir=''${out}/bin
    mkdir -p ''${bindir}
    cp patch ''${bindir}
    chmod 755 ''${bindir}/patch
  '';
})

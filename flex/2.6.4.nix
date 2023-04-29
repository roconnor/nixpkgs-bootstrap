{ stage1env
, tcc
, m4
, sed
, flex
, yacc
, ...
}:
stage1env.override (final: prev: with final;
{
  pname = "flex";
  version = "2.6.4";

  src = builtins.fetchurl {
    url = "https://github.com/westes/${pname}/releases/download/v${version}/${name}.tar.gz";
    sha256="e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995";
  };

  sourceRoot = "${name}/src";

  buildInputs = [ tcc m4 sed flex yacc ];

  configurePhase = ''
    touch config.h
    rm parse.c parse.h scan.c skel.c
  '';

  makefile = mk/${version}.mk;

  meta = with lib; {
    homepage = "https://github.com/westes/flex";
    description = "A fast lexical analyser generator";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
})

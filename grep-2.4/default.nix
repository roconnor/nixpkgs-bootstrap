{ stage1env
, tcc
, make
, bash
, ...
}:
stage1env.override (final: prev: with final;
{
  pname = "grep";
  version = "2.4";

  src = builtins.fetchurl {
    url = "https://mirrors.kernel.org/gnu/${pname}/${name}.tar.gz";
    sha256="a32032bab36208509466654df12f507600dfe0313feebbcd218c32a70bf72a16";
  };

  buildInputs = [ tcc make ];

  makefile = mk/main.mk;
})

{ stage1env
, tcc
, ...
}:
stage1env.override (final: prev: with final;
{
  pname = "m4";
  version = "1.4.7";

  src = builtins.fetchurl {
    url = "https://mirrors.kernel.org/gnu/${pname}/${name}.tar.gz";
    sha256="093c993767f563a11e41c1cf887f4e9065247129679d4c1e213d0544d16d8303";
  };

  buildInputs = [ tcc ];

  makefile = mk/main.mk;
})

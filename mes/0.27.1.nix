{ stage0env
, simple-patch
, nyacc-tar-gz ? builtins.fetchurl { url = "https://archive.org/download/live-bootstrap-sources/nyacc-1.00.2-lb1.tar.gz";
                                     sha256="708c943f89c972910e9544ee077771acbd0a2c0fc6d33496fe158264ddb65327";
                                   }
, ...
}: stage0env.override (final: prev: with final;
{
  pname = "mes";
  version = "0.27.1";

  src = builtins.fetchurl
        { url = "https://mirrors.kernel.org/gnu/${pname}/${name}.tar.gz";
          sha256="183a40ea47ea49f8a1e3bd1b9d12e676374d64d63bc79e7bc1ae7d673dfdf25d";
        };
  outputs = [ "out" "dev" ];

  buildInputs = [ simple-patch ];
  simple_patches = ./simple-patches;
  files = ./files;

  ARCH="x86";
  NYACC_PKG="nyacc-1.00.2";
  NYACC_TAR_GZ=nyacc-tar-gz;
  MES_VERSION=version;
  MES_PKG=name;
  MES_PKG_DIR=MES_PKG;
  buildCommandPath = ./mes-0.27.1.kaem;

  allowedReferences = [ "out" ];
})

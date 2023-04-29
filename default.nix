let lib = import ./lib.nix;
in lib.fix
(final: with final;
{ inherit lib;
  callPackage = lib.callWithScope final;
  stage0-seed-bin = builtins.path {
    path = ./stage0-seed-x86/bin;
    sha256 = "caf977390da2f94e173c86c1fc6015a0ffd6ba649954d59015a91b73e3cefb07";
  };
  stage0 = callPackage ./stage0 { inherit stage0-seed-bin; };
  stage0env = callPackage ./stage0/std-derivation.nix {};
  stage0-seed = callPackage ./stage0/seed.nix {};
  mes = callPackage ./mes-0.24.2 {};
  "tcc-0.9.26" = callPackage ./tinycc/0.9.26.nix {};
  tcc-mes = callPackage ./tinycc/0.9.27-pass1.nix { CC = "${final."tcc-0.9.26"}/bin/tcc"; };
  libgetopt = callPackage ./libgetopt { tcc = tcc-mes; };
  make = callPackage ./make-3.82 { tcc = tcc-mes; };
  gzip = callPackage ./gzip-1.2.4 { tcc = tcc-mes; };
  tar = callPackage ./tar-1.12 { tcc = tcc-mes; };
  bzip2 = callPackage ./bzip2-1.0.8 { tcc = tcc-mes; };
  sed = callPackage ./sed-4.0.9 { tcc = tcc-mes; };
  patch = callPackage ./patch-2.5.9 { tcc = tcc-mes; };
  coreutils = callPackage ./coreutils-5.0 { tcc = tcc-mes; };
  heirloom-devtools = callPackage ./heirloom-devtools-070527 { tcc = tcc-mes; };
  bash = callPackage ./bash-2.05b { tcc = tcc-mes; };

  stage1env = callPackage ./stage1env { tcc = tcc-mes; };
  tcc-unwrapped = callPackage ./tinycc/0.9.27.nix { CC = "${final."tcc-0.9.26"}/bin/tcc"; };
  tcc-musl0 = callPackage ./tinycc/wrapped.nix
    rec
      { tcc = tcc-unwrapped;
        libc = callPackage ./musl-1.1.24 { inherit tcc; };
      };
  tcc-musl = callPackage ./tinycc/wrapped.nix
    rec 
      { tcc = callPackage ./tinycc/0.9.27.nix { CC = "${tcc-musl0}/bin/tcc"; };
        libc = callPackage ./musl-1.1.24 { inherit tcc; };
      };
  grep = callPackage ./grep-2.4 { tcc = tcc-musl; };
})

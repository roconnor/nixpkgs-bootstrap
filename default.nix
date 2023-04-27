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
  tcc = callPackage ./tinycc/0.9.27.nix { tcc = final."tcc-0.9.26"; };
  make = callPackage ./make-3.82 {};
  gzip = callPackage ./gzip-1.2.4 {};
  tar = callPackage ./tar-1.12 {};
  bzip2 = callPackage ./bzip2-1.0.8 {};
  sed = callPackage ./sed-4.0.9 {};
  patch = callPackage ./patch-2.5.9 {};
  coreutils = callPackage ./coreutils-5.0 {};
  heirloom-devtools = callPackage ./heirloom-devtools-070527 {};
  bash = callPackage ./bash-2.05b {};

  stage1env = callPackage ./stage1env {};
  tcc-pass2 = callPackage ./tinycc/0.9.27-pass2.nix { tcc = final."tcc-0.9.26"; };
  musl = callPackage ./musl-1.1.24 { tcc = tcc-pass2; };
})

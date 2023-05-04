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
  mes = callPackage ./mes/0.24.2.nix {};
  "tcc-0.9.26" = callPackage ./tinycc/0.9.26.nix {};
  tcc-mes = callPackage ./tinycc/0.9.27-pass1.nix { CC = "${final."tcc-0.9.26"}/bin/tcc"; };
  libgetopt = callPackage ./libgetopt { tcc = tcc-mes; };
  make = callPackage ./make/3.82.nix { tcc = tcc-mes; };
  gzip = callPackage ./gzip/1.2.4.nix { tcc = tcc-mes; };
  tar = callPackage ./tar/1.12.nix { tcc = tcc-mes; };
  bzip2 = callPackage ./bzip2/1.0.8.nix { tcc = tcc-mes; };
  sed = callPackage ./sed/4.0.9.nix { tcc = tcc-mes; };
  patch = callPackage ./patch/2.5.9.nix { tcc = tcc-mes; };
  coreutils = callPackage ./coreutils/5.0.nix { tcc = tcc-mes; };
  heirloom-devtools = callPackage ./heirloom-devtools/070527.nix { tcc = tcc-mes; };
  bash = callPackage ./bash/2.05b.nix { tcc = tcc-mes; };

  stage1env = callPackage ./stage1env { };
  tcc-unwrapped = callPackage ./tinycc/0.9.27.nix { CC = "${final."tcc-0.9.26"}/bin/tcc"; };
  tcc-musl0 = callPackage ./tinycc/wrapped.nix
    rec
      { tcc = tcc-unwrapped;
        libc = callPackage ./musl/1.1.24.nix { inherit tcc; };
      };
  tcc-musl1 = callPackage ./tinycc/wrapped.nix
    rec 
      { tcc = callPackage ./tinycc/0.9.27.nix { CC = "${tcc-musl0}/bin/tcc"; };
        libc = callPackage ./musl/1.1.24.nix { inherit tcc; };
      };
  tcc-musl2 = callPackage ./tinycc/wrapped.nix
    rec 
      { tcc = callPackage ./tinycc/0.9.27.nix { CC = "${tcc-musl1}/bin/tcc"; };
        # musl reaches its fixed point before tcc does.
        libc = (callPackage ./musl/1.1.24.nix { inherit tcc; }).override (final: prev: { outputHash = "W9lfO0Th74Wq2lynD7iWLUymV+SA1OJ1h26cJCM/aY8="; });
      };
  tcc-musl3 = callPackage ./tinycc/wrapped.nix
    rec 
      { tcc = callPackage ./tinycc/0.9.27.nix { CC = "${tcc-musl2}/bin/tcc"; };
        libc = (callPackage ./musl/1.1.24.nix { inherit tcc; }).override (final: prev: { outputHash = "W9lfO0Th74Wq2lynD7iWLUymV+SA1OJ1h26cJCM/aY8="; });
      };
  tcc-musl4 = callPackage ./tinycc/wrapped.nix
    rec 
      { tcc = callPackage ./tinycc/0.9.27.nix { CC = "${tcc-musl3}/bin/tcc"; };
        libc = callPackage ./musl/1.1.24.nix { inherit tcc; };
      };
  tcc-musl = tcc-musl3; # This is the fixed point of tcc and musl.
  m4 = callPackage ./m4/1.4.7.nix { tcc = tcc-musl; };
  grep = callPackage ./grep/2.4.nix { tcc = tcc-musl; };
  "flex-2.5.11" = callPackage ./flex/2.5.11.nix { lex = heirloom-devtools.lex; };
  flex = callPackage ./flex/2.6.4.nix { tcc = tcc-musl; yacc = heirloom-devtools.yacc; flex = final."flex-2.5.11"; };
  bison-pass1 = callPackage ./bison/3.4.1.nix { tcc = tcc-musl; bison = null; mkBison = ''
    cp ${bison/files/parse-gram.c} src/parse-gram.c
    cp ${bison/files/parse-gram.h} src/parse-gram.h
  ''; };
  bison-pass2 = callPackage ./bison/3.4.1.nix { tcc = tcc-musl; bison = bison-pass1; mkBison = ''
    cp ${bison/files/parse-gram.y} src/parse-gram.y
  ''; };
  bison-pass3 = callPackage ./bison/3.4.1.nix { tcc = tcc-musl; bison = bison-pass2; };
  bison-pass4 = callPackage ./bison/3.4.1.nix { tcc = tcc-musl; bison = bison-pass3; };
  bison = bison-pass3;
  gawk = callPackage ./gawk/3.0.4.nix { tcc = tcc-musl; yacc = heirloom-devtools.yacc; };
})

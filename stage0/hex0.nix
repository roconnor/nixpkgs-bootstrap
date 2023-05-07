{ system ? "i686-linux"
, lib
, hex0
, ...
}:
assert builtins.elem system ["i686-linux" "x86_64-linux"];
lib.fixDerivation (final: with final;
{
  inherit system;
  ARCH = "x86";
  name = "hex0-${ARCH}";
    
  builder = hex0;
  args = [ stage0-posix-x86/hex0_${ARCH}.hex0 (builtins.placeholder "out") ];

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "QU3RPGy51W7M2xnfFY1IqruKzusrSLU+L190ztN6JW8=";
    
  allowedReferences = [];
})

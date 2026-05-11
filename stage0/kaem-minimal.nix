{ system ? "i686-linux"
, lib
, hex0
, ...
}:
assert builtins.elem system ["i686-linux" "x86_64-linux"];
lib.fixDerivation (final:
{
  inherit system;
  name = "kaem-minimal";
    
  builder = hex0;
  args = [ stage0-posix-x86/kaem-minimal.hex0 (builtins.placeholder "out") ];

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "DriflFU5fy8R6Rm0m1b31Vl98q855+Gt/Sv+r5ubGNM=";
    
  allowedReferences = [];
})

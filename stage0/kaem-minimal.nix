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
  outputHash = "lCJQahg9TY52XYCUQEXuKMrTwPJTwFdsJUfL11oUTbg=";
    
  allowedReferences = [];
})

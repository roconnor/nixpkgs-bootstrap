{ lib
, stage0
, make
, patch
, ...
}: lib.fixDerivation (final:
let dispatch = builtins.toFile "builder.kaem" ''
  if match x''${buildCommandPath} x; then
     exec kaem --strict --file ${./default-builder.kaem}
  fi
  exec kaem --strict --file ''${buildCommandPath}
  '';
in {
  inherit (stage0) system;
  name = "${final.pname}-${final.version}";
 
  SHELL = "${stage0}/bin/kaem";
  builder = final.SHELL;
  args = [ "--strict" "--file" dispatch ];

  buildInputs = [];

  PATH = lib.mkPath "bin" (final.buildInputs ++ [ stage0 ]);
  LIBRARY_PATH = lib.mkPath "lib" final.buildInputs;
  C_INCLUDE_PATH = lib.mkPath "include" final.buildInputs;

  passAsFile = [ "buildCommand" "unpackPhase" "patchPhase" "configurePhase" "buildPhase" "installPhase" ];

  unpackPhase = lib.optional (!final?buildCommand && !final?buildCommandPath) ''
    if ${stage0}/bin/ungz --file ${final.src} --output ${final.name}.tar; fi
    if ${stage0}/bin/unbz2 --file ${final.src} --output ${final.name}.tar.tmp; then
      ${stage0}/bin/cp ${final.name}.tar.tmp ${final.name}.tar
      ${stage0}/bin/rm ${final.name}.tar.tmp
    fi
    ${stage0}/bin/untar --file ${final.name}.tar
    ${stage0}/bin/rm ${final.name}.tar
  '';

  patches = [];

  patchPhase = lib.optional (final.patches != []) (builtins.concatStringsSep "\n"
       (builtins.map (file: "${patch}/bin/patch -Np0 -i ${file}") final.patches ++ [""])) ;

  buildPhase = lib.optional (!final?buildCommand && !final?buildCommandPath) ''
    ${make}/bin/make ${if final?makefile then "-f ${final.makefile}" else ""}
  '';

  installPhase = lib.optional (!final?buildCommand && !final?buildCommandPath) ''
    ${make}/bin/make ${if final?makefile then "-f ${final.makefile}" else ""} install
  '';

  # Stage0 builds are mostly static binaries.
  # Please explicity override for those cases where it is not.
  allowedReferences = [];
})

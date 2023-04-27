{ lib
, make
, patch
, gzip
, bzip2
, tar
, sed
, coreutils
, bash
, ...
}: 
lib.fixDerivation (final:
{
  inherit (bash) system;
  name = "${final.pname}-${final.version}";
 
  SHELL = "${bash}/bin/bash";
  builder = final.SHELL;
  args = [ "-e" ./default-builder.sh ];

  buildInputs = [];

  PATH = builtins.concatStringsSep ":" (builtins.map (pkg: "${pkg}/bin") (final.buildInputs ++ [ coreutils ]));

  phases = [ "unpackPhase" "patchPhase" "configurePhase" "buildPhase" "installPhase" ];
 
  unpackPhase = '' 
    case "${final.src}" in
      *.tar.gz)
        ${gzip}/bin/gunzip -c ${final.src} | ${tar}/bin/tar xf -
        ;;
      *.tar.bz2)
        ${bzip2}/bin/bunzip2 -c ${final.src} | ${tar}/bin/tar xf -
        ;;
    esac
  '';

  patches = [];

  patchPhase = if [] == final.patches then null else builtins.concatStringsSep "\n"
       (builtins.map (file: "${patch}/bin/patch -Np0 -i ${file}") final.patches ++ [""]);

  buildPhase = ''
    ${make}/bin/make ${if final?makefile then "-f ${final.makefile}" else ""}
  '';

  installPhase = ''
    ${make}/bin/make ${if final?makefile then "-f ${final.makefile}" else ""} install
  '';

  # Stage1 builds are mostly static binaries.
  # Please explicity override for those cases where it is not.
  # allowedReferences = [];
})

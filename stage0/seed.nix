{ stage0
, stage0env
, ...
}:
stage0env.override (final: prev: with final;
{
  name = "stage0-seed-${stage0.ARCH}";

  buildCommand = ''
    set -xe

    bindir=''${out}/bin
    mkdir -p ''${bindir}

    ###############################################
    # Phase-0 Build hex0 from bootstrapped binary #
    ###############################################
    hex2 -f ${stage0-posix-x86/hex0_x86.hex0} -o ''${bindir}/hex0-seed
    
    #########################################
    # Phase-0b Build minimal kaem from hex0 #
    #########################################
    hex2 -f ${stage0-posix-x86/kaem-minimal.hex0} -o ''${bindir}/kaem-seed
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "2329X9b74tZ8/HyLClhRcnAwcnRHemKz2GoPFedsV2o=";

  allowedReferences = [];
  preferLocalBuild = true;
})

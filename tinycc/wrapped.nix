{ stage1env
, tcc
, libc
, bash
, ...
}:
stage1env.override (final: prev: with final;
{
  pname = "tcc-wrapped";
  version = tcc.version;

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    cat <<EOF > tcc
    #!${bash}/bin/bash
    if [ "\$1" != "-ar" ]; then
      exec ${tcc}/bin/tcc -B''${out} "\$@"
    else
      exec ${tcc}/bin/tcc "\$@"
    fi
    EOF

    chmod 755 tcc
  '';

  installPhase = '' 
    install -D tcc "''${out}/bin/tcc"
    cp -R ${libc}/include ''${out}/
    mkdir -p ''${out}/lib
    cp ${libc}/lib/* ''${out}/lib/
    install -D ${tcc}/lib/tcc/libtcc1.a "''${out}/lib/tcc/libtcc1.a"
  '';

  allowedReferences = [ "out" bash tcc libc ];
})

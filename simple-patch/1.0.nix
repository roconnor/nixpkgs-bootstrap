{ stage0env
, ...
}: stage0env.override (final: prev: with final;
{
  pname = "simple-patch";
  version = "1.0";

  ARCH="x86";
  buildCommand = ''
    # SPDX-FileCopyrightText: 2023 Samuel Tyler <samuel@samuelt.me>
    #
    # SPDX-License-Identifier: GPL-3.0-or-later

    set -ex
    PREFIX=''${out}
    BINDIR=''${PREFIX}/bin
    mkdir -p ''${BINDIR}

    M2-Mesoplanet --architecture ${ARCH} -f ${src/simple-patch.c} -o ''${BINDIR}/simple-patch

    # Checksums
    sha256sum \
        ''${BINDIR}/simple-patch
  '';
})

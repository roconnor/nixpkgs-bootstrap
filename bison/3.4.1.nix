{ stage1env
, tcc
, bison
, sed
, flex
, m4
, mkBison ? ""
, ...
}:
stage1env.override (final: prev: with final;
{
  pname = "bison";
  version = "3.4.1";

  src = builtins.fetchurl {
    url = "https://mirrors.kernel.org/gnu/${pname}/${name}.tar.gz";
    sha256="7007fc89c216fbfaff5525359b02a7e5b612694df5168c74673f67055f015095";
  };

  buildInputs = [ tcc bison sed flex m4 ];

  patches = [ patches/fseterr.patch patches/missing-includes.patch ];

  configurePhase = ''
    mv lib/textstyle.in.h lib/textstyle.h

    # Remove pre-generated flex/bison files
    rm src/parse-gram.c src/parse-gram.h
    rm src/scan-code.c
    rm src/scan-gram.c
    rm src/scan-skel.c

    ${mkBison}

    cat <<EOF > config.h
    // SPDX-FileCopyrightText: 2020 Andrius Štikonas <andrius@stikonas.eu>
    // SPDX-FileCopyrightText: 2021 fosslinux <fosslinux@aussies.space>
    
    // SPDX-License-Identifier: GPL-3.0-or-later
    
    #define HAVE_DECL_PROGRAM_INVOCATION_SHORT_NAME 1
    #define HAVE_DECL_STRERROR_R 1
    #define HAVE_GETTIMEOFDAY 1
    #define HAVE_PIPE 1
    #define HAVE_SNPRINTF 1
    #define HAVE_STDINT_H 1
    #define HAVE_UNISTD_H 1
    #define M4 "${m4}/bin/m4"
    #define M4_GNU_OPTION ""
    #define PACKAGE "bison"
    #define PACKAGE_BUGREPORT "bug-bison@gnu.org"
    #define PACKAGE_COPYRIGHT_YEAR 2019
    #define PACKAGE_NAME "GNU Bison"
    #define PACKAGE_STRING "GNU Bison 3.4.1"
    #define PACKAGE_URL "http://www.gnu.org/software/bison/"
    #define PACKAGE_VERSION "3.4.1"
    #define VERSION "3.4.1"
    #define PROMOTED_MODE_T mode_t
    #define _GNU_SOURCE 1
    #define _Noreturn
    #define _GL_ASYNC_SAFE
    #define _GL_EXTERN_INLINE extern inline
    #define _GL_INLINE_HEADER_BEGIN
    #define _GL_INLINE_HEADER_END
    #define _GL_UNUSED
    #define _GL_UNUSED_LABEL
    #define _GL_ATTRIBUTE_PURE
    #define _GL_ATTRIBUTE_CONST
    #define _GL_ATTRIBUTE_MALLOC
    #define _GL_ATTRIBUTE_FORMAT_PRINTF(x, y)
    #define _GL_ARG_NONNULL(x)
    #ifndef _GL_INLINE
    #define _GL_INLINE static inline
    #endif
    EOF
    cat <<EOF > configmake.h
    #define LOCALEDIR "$out/share/locale"
    #define PKGDATADIR "$out/share/bison"
    EOF

    cp ${mk/lib.mk} lib/Makefile
    cp ${mk/src.mk} src/Makefile
  '';

  makefile = mk/main.mk;

  # tcc is included because binary is not stripped?
  allowedReferences = [ "out" m4 tcc ];

  meta = {
    homepage = "https://www.gnu.org/software/bison/";
    description = "Yacc-compatible parser generator";
    license = lib.licenses.gpl3Plus;

    longDescription = ''
      Bison is a general-purpose parser generator that converts an
      annotated context-free grammar into an LALR(1) or GLR parser for
      that grammar.  Once you are proficient with Bison, you can use
      it to develop a wide range of language parsers, from those used
      in simple desk calculators to complex programming languages.

      Bison is upward compatible with Yacc: all properly-written Yacc
      grammars ought to work with Bison with no change.  Anyone
      familiar with Yacc should be able to use Bison with little
      trouble.  You need to be fluent in C or C++ programming in order
      to use Bison.
    '';

    platforms = lib.platforms.unix;
  };
})

{ stage1env
, tcc
, yacc
, ...
}:
stage1env.override (final: prev: with final;
{
  pname = "gawk";
  version = "3.0.4";

  src = builtins.fetchurl {
    url = "https://mirrors.kernel.org/gnu/${pname}/${name}.tar.gz";
    sha256="5cc35def1ff4375a8b9a98c2ff79e95e80987d24f0d42fdbb7b7039b3ddb3fb0";
  };

  patchPhase = ''
    rm awktab.c
  '';

  buildInputs = [ tcc yacc ];

  makefile = mk/main.mk;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/gawk/";
    description = "GNU implementation of the Awk programming language";
    longDescription = ''
      Many computer users need to manipulate text files: extract and then
      operate on data from parts of certain lines while discarding the rest,
      make changes in various text files wherever certain patterns appear,
      and so on.  To write a program to do these things in a language such as
      C or Pascal is a time-consuming inconvenience that may take many lines
      of code.  The job is easy with awk, especially the GNU implementation:
      Gawk.

      The awk utility interprets a special-purpose programming language that
      makes it possible to handle many data-reformatting jobs with just a few
      lines of code.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = [ ];
  };
})

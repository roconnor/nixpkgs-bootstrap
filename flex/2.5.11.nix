{ lex
, flex
, ...
}:
(flex.overrideArgs { m4 = null; flex = lex; }).override (final: prev: with final;
{
  version = "2.5.11";

  src = builtins.fetchurl {
    url = "http://download.nust.na/pub2/openpkg1/sources/DST/${pname}/${name}.tar.gz";
    sha256="bc79b890f35ca38d66ff89a6e3758226131e51ccbd10ef78d5ff150b7bd73689";
  };

  sourceRoot = "";

  patches = [ patches/scan_l.patch patches/yyin.patch ];

  patchPhase = ''
    ${prev.patchPhase}
    cp ${files/scan.lex.l} scan.lex.l
  '';
})

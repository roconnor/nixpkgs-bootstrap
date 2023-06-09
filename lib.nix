let
  asFunction = v: if builtins.isAttrs v then _: v
                  else if builtins.isPath v then import v
                  else v;
  extend = classOrExt: extension: final: 
    let prev0 = classOrExt final;
        mkExtension = prev: prev // (extension final prev);
     in if builtins.isFunction prev0
        then prevprev: mkExtension (prevprev // (prev0 prevprev))
        else mkExtension prev0;
  fix = class: let final = class final; in final // { _class = class; override = ext: fix (extend class ext); };
  fixDerivation = class: let preFinal = class final;
                             final = derivation (removeAttrs preFinal [ "meta" "passthru" ]); # At the moment we simply toss away meta.
                         in final // (if (final?passthru) then final.passsthru else {})
                                  // { inherit (final) passthru; _class = class; override = ext: fixDerivation (extend class ext); };
in fix
(final: with final;
let
  callWithOverride = f:
    let callWithOverrideF = ext:
      let noExt = ext == null;
          _uncall = args:
            let fargs = f args;
                result = if noExt then fargs else fargs.override ext;
             in result // { inherit _uncall;
                            overrideArgs = newArgs: _uncall (args // newArgs);
                          }
                       // (if result?override then # We assume that if (f args) has an override field for some args, then it has an override field for all args.
                          { override = ext2: callWithOverrideF (if noExt then ext2 else extend ext ext2) args;}
                          else {});
      in _uncall;
    in callWithOverrideF;
in {
  inherit asFunction extend fix fixDerivation;

  call = f: callWithOverride f null;

  withScope = scope: f: args: asFunction f (scope // args);

  callWithScope = scope: f: call (withScope scope f);

  optional = b: s: if b then s else "";

  mkPath = subdir: pkgs: builtins.concatStringsSep ":"
   (builtins.map (pkg: "${pkg}/${subdir}") (builtins.filter (x: x != null) pkgs));
})

let
  asFunction = v: if builtins.isAttrs v then _: v
                  else if builtins.isPath v then import v
                  else v;
  compose = f: g: x: f (g x);
  extend = classOrExt: extension: final: 
    let prev0 = classOrExt final;
        mkExtension = prev: prev // (extension final prev);
     in if builtins.isFunction prev0
        then compose mkExtension prev0
        else mkExtension prev0;
  fix = class0: let class = class0; final = class final; in final // { _class = class; override = compose fix (extend class); };
  fixDerivation = class0: let class = class0; final = derivation (class final); in final // { _class = class; override = compose fixDerivation (extend class); };
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
                       // optional (result?override) # We assume that if (f args) has an override field for some args, then it has an override field for all args.
                          { override = ext2: callWithOverrideF (if noExt then ext2 else extend ext ext2) args;};
      in _uncall;
    in callWithOverrideF;
in {
  inherit asFunction compose extend fix fixDerivation;

  call = f: callWithOverride f null;

  withScope = scope: f: args: asFunction f (scope // args);

  callWithScope = scope: f: call (withScope scope f);

  optional = b: s: if b then s else null;
})

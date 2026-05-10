{ pkgs } : with pkgs;
{ pack_blobs = callPackage ./pack_blobs.nix {};
  vm = callPackage ./vm.nix {};
  parenthetically = callPackage ./parenthetically.nix {};
  exponentially = callPackage ./exponentially.nix {};
  practically = callPackage ./practically.nix {};
  singularity = callPackage ./singularity.nix {};
  semantically = callPackage ./semantically.nix {};
  stringy = callPackage ./stringy.nix {};
  binary = callPackage ./binary.nix {};
  algebraically = callPackage ./algebraically.nix {};
  parity = callPackage ./parity.nix {};
  fixity = callPackage ./fixity.nix {};
  typically = callPackage ./typically.nix {};
  classy = callPackage ./classy.nix {};
  barely-0 = callPackage ./barely-0.nix {};
  barely-1 = callPackage ./barely-1.nix {};
  barely = callPackage ./barely.nix {}; # identical output to barely-1
  effectively = callPackage ./effectively.nix {};
  lonely = callPackage ./lonely.nix {};
  patty = callPackage ./patty.nix {};
  guardedly = callPackage ./guardedly.nix {};
  assembly = callPackage ./assembly.nix {};
  mutually = callPackage ./mutually.nix {};
  uniquely = callPackage ./uniquely.nix {};
  virtually = callPackage ./virtually.nix {};
  marginally = callPackage ./marginally.nix {};
}

self@{inputs, ...}:
let
  inherit (inputs) liqwid-nix;
in
(liqwid-nix.buildProject
  {
    inherit inputs;
    src = ./.;
  }
  [
    liqwid-nix.haskellProject
    liqwid-nix.plutarchProject
    (liqwid-nix.addDependencies [
      "${inputs.ply}/ply-core"
      "${inputs.ply}/ply-plutarch"
      "${inputs.liqwid-plutarch-extra}"
      "${inputs.plutarch-numeric}"
    ])
    (liqwid-nix.enableFormatCheck [
      "-XQuasiQuotes"
      "-XTemplateHaskell"
      "-XTypeApplications"
      "-XImportQualifiedPost"
      "-XPatternSynonyms"
      "-XOverloadedRecordDot"
    ])
    liqwid-nix.enableLintCheck
    liqwid-nix.enableCabalFormatCheck
    liqwid-nix.enableNixFormatCheck
    liqwid-nix.addBuildChecks
  ]
).toFlake

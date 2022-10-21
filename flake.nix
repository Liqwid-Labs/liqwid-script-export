{
  description = "liqwid-script-export";

  inputs = {
    nixpkgs.follows = "plutarch/nixpkgs";
    nixpkgs-latest.url = "github:NixOS/nixpkgs?rev=cf63df0364f67848083ff75bc8ac9b7ca7aa5a01";
    # temporary fix for nix versions that have the transitive follows bug
    # see https://github.com/NixOS/nix/issues/6013
    nixpkgs-2111 = { url = "github:NixOS/nixpkgs/nixpkgs-21.11-darwin"; };

    haskell-nix-extra-hackage.follows = "plutarch/haskell-nix-extra-hackage";
    haskell-nix.follows = "plutarch/haskell-nix";
    iohk-nix.follows = "plutarch/iohk-nix";
    haskell-language-server.follows = "plutarch/haskell-language-server";

    # Plutarch and its friends
    plutarch = {
      url = "github:Plutonomicon/plutarch-plutus?ref=staging";

      inputs.emanote.follows =
        "plutarch/haskell-nix/nixpkgs-unstable";
      inputs.nixpkgs.follows =
        "plutarch/haskell-nix/nixpkgs-unstable";
    };

    ply.url = "github:mlabs-haskell/ply?ref=master";

    liqwid-nix.url = "github:Liqwid-Labs/liqwid-nix";
    liqwid-plutarch-extra.url = "github:Liqwid-Labs/liqwid-plutarch-extra";
    plutarch-numeric.url =
      "github:liqwid-labs/plutarch-numeric?ref=main";


    # liqwid-script-import

    ctl = {
      type = "github";
      owner = "Plutonomicon";
      repo = "cardano-transaction-lib";
      rev = "39fc516c7c837401427b46637dacd9c7ada6274d";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      defaultSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      perSystem = nixpkgs.lib.genAttrs defaultSystems;
    in
    {
      liqwid-script-import = {
        flake = (import ./liqwid-script-import/flake.nix) { inherit inputs; };
      };
      liqwid-script-export = {
        flake = (import ./liqwid-script-export/flake.nix) { inherit inputs; };
      };

      devShells = perSystem (system: rec {
        default = liqwid-script-export;
        liqwid-script-import = self.liqwid-script-import.flake.devShell.${system};
        liqwid-script-export = self.liqwid-script-export.flake.devShell.${system};
      });
    };
}

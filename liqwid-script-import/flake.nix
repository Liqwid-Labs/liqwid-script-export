self@{inputs, ...}:
let
  inherit (inputs) ctl nixpkgs;

  defaultSystems =
    [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
  perSystem = nixpkgs.lib.genAttrs defaultSystems;

  nixpkgsFor = system: import nixpkgs {
    inherit system;
    overlays = [
      ctl.overlays.purescript
      ctl.overlays.ctl-server
      ctl.overlays.runtime
    ];
  };

  psProjectFor = system:
    let
      pkgs = nixpkgsFor system;
      src = self;
    in
      pkgs.purescriptProject {
        inherit pkgs src;
        packageJson = ./package.json;
        packageLock = ./package-lock.json;

        strictComp = false;

        projectName = "liqwid-script-import";

        nodejs = pkgs.nodejs-14_x;

        spagoPackages = ./spago-packages.nix;

        shell = {
          packages = with pkgs; [
            fd
            self.liqwid-script-export.flake.packages.${system}."liqwid-script-export:exe:export-example"
          ];

          shellHook = "";

          inputsFrom = [ ];

          formatter = "purs-tidy";

          pursls = true;
        };
      };
  ctlRuntimeConfig = {
    network = {
      name = "preview";
      magic = 2;
    };
    datumCache = {
      blockFetcher = {
        firstBlock = {
          slot = 3158571;
          id = "2daa84a316685456e8d04ee102b4a0d7fd238a87f1d52574f92a3ab183b9fab4";
        };
      };
    };
  };
in
{
  packages = perSystem (system: {
    liqwid-script-import = (psProjectFor system).buildPursProject {
      sources = ["src"];
    };
  });

  checks = perSystem (system:
    let pkgs = nixpkgsFor system;
    in
      {
        liqwid-script-import = (psProjectFor system).runPursTest {
          sources = [ "src" ];
        };
        formatting-check = pkgs.runCommand "formatting-check"
          {
            nativeBuildInputs = [ pkgs.easy-ps.purs-tidy pkgs.fd ];
          } ''
                      cd ${self}
                                  purs-tidy check $(fd -epurs)
                                              touch $out
                                                        '';
      });

  check = perSystem (system:
    (nixpkgsFor system).runCommand "combined-test"
      {
        checksss = builtins.attrValues self.checks.${system};
      } ''
                echo $checksss
                          touch $out
                                  '');

  devShell = perSystem (system: (psProjectFor system).devShell);
}

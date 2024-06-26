{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs }:
    let
      forEachSystem = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
      {
        packages = forEachSystem (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
            {
              default = pkgs.stdenvNoCC.mkDerivation {
                name = "seafield-battery";
                src = ./.;
                nativeBuildInputs = [
                  pkgs.wireviz
                ];
                buildPhase = ''
                  wireviz seafield-bms-wiring-harness.yml
                '';
                installPhase = ''
                  mkdir -p $out
                  cp seafield-bms-wiring-harness.* $out/
                '';
              };
            }
        );
      };
}

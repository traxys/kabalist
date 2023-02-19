{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.android-nixpkgs.url = "github:tadfisher/android-nixpkgs";
  inputs.naersk.url = "github:nix-community/naersk";
  inputs.rust-overlay.url = "github:oxalica/rust-overlay";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    android-nixpkgs,
    rust-overlay,
    naersk,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          android_sdk.accept_license = true;
        };
        overlays = [
          (import rust-overlay)
          (final: prev: {
            rust-bin-wasm = prev.rust-bin.stable.latest.default.override {
              targets = ["wasm32-unknown-unknown"];
            };
          })
          (final: prev: {
            rustPlatformWithWasm = prev.callPackage ({
              makeRustPlatform,
              rust-bin-wasm,
            }:
              makeRustPlatform {
                rustc = rust-bin-wasm;
                cargo = rust-bin-wasm;
              }) {};
          })
        ];
      };

      openapi-generator-cli = pkgs.fetchurl {
        url = "https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/6.0.0/openapi-generator-cli-6.0.0.jar";
        sha256 = "sha256-DLimlQ/JuMag4WGysYJ/vdglNw6nu0QP7vDT66LEKT4=";
      };
      naersk' = pkgs.callPackage naersk {
        cargo = pkgs.rust-bin-wasm;
        rustc = pkgs.rust-bin-wasm;
      };
    in {
      packages = {
        cli = naersk'.buildPackage {
          cargoBuildOptions = opts: opts ++ ["--package=kabalist_cli"];
          root = ./.;

          postInstall = ''
            mv $out/bin/kabalist_cli $out/bin/kabalist
          '';
        };
        admin = naersk'.buildPackage {
          cargoBuildOptions = opts: opts ++ ["--package=kb_admin"];
          root = ./.;
        };
        server = naersk'.buildPackage {
          cargoBuildOptions = opts: opts ++ ["--package=kabalist_api"];
          root = ./.;
        };
      };
      devShell = with pkgs;
        mkShell {
          nativeBuildInputs = [pkgs.bashInteractive];

          DATABASE_URL = "postgres://traxys/list?host=/var/run/postgresql";
          LIST_URL = "http://localhost:8080/api";

          buildInputs = [
            # Flutter
            (android-nixpkgs.sdk."${system}" (sdkPkgs:
              with sdkPkgs; [
                cmdline-tools-latest
                build-tools-29-0-2
                platform-tools
                platforms-android-30
                platforms-android-31
                emulator
              ]))

            flutter
            jdk8
            dart
            (pkgs.writeShellApplication {
              name = "openapi-generator-cli";
              text = ''
                ${pkgs.jdk11}/bin/java -jar ${openapi-generator-cli} "$@"
              '';
            })

            # Rust
            rust-bin-wasm

            # Web
            trunk
            wasm-bindgen-cli

            # Docker
            docker-compose
          ];
        };
    });
}

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
        url = "https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/7.9.0/openapi-generator-cli-7.9.0.jar";
        sha256 = "sha256-8Mt4OaLq2QQLIEUZsD8Uc7OcdyX9H0MTS7VQUVyz2+4=";
      };
      naersk' = pkgs.callPackage naersk {
        cargo = pkgs.rust-bin-wasm;
        rustc = pkgs.rust-bin-wasm;
      };

      web = {
        pkgs,
        rustPlatformWithWasm,
        trunk,
        stdenv,
        cargo,
        wasm-bindgen-cli,
        ...
      }:
        stdenv.mkDerivation {
          pname = "kabalist-web";
          version = "master";

          cargoDeps = rustPlatformWithWasm.importCargoLock {
            lockFile = ./Cargo.lock;
          };

          nativeBuildInputs = [
            trunk
            wasm-bindgen-cli
            rustPlatformWithWasm.cargoSetupHook
            rustPlatformWithWasm.cargoBuildHook
          ];

          src = ./.;
          XDG_CACHE_HOME = "/build/cache";
          TRUNK_TOOLS_WASM_BINDGEN = "${wasm-bindgen-cli.version}";

          buildPhase = ''
            runHook preBuild

            cd web
            trunk build --release

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            cp -R dist $out

            runHook postInstall
          '';
        };

      webPkg = pkgs.callPackage web {};
      serverPkg = naersk'.buildPackage {
        cargoBuildOptions = opts: opts ++ ["--package=kabalist_api"];
        root = ./.;
        postInstall = ''
          mkdir -p $out/share
          cp -r api/public $out/share
        '';
      };
    in {
      nixosModule = import ./nixos/kabalist.nix {
        kabalist-web = webPkg;
        kabalist-server = serverPkg;
      };
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
        server = serverPkg;
        web = webPkg;
      };
      devShell = with pkgs;
        mkShell rec {
          nativeBuildInputs = [pkgs.bashInteractive];

          LIST_URL = "http://localhost:8080";

          shellHook = ''
            export DATABASE_URL="postgres://$(whoami)/list?host=/var/run/postgresql"
            export KABALIST_DATABASE_URL="$DATABASE_URL"
          '';

          buildInputs = [
            # Flutter
            (android-nixpkgs.sdk."${system}" (sdkPkgs:
              with sdkPkgs; [
                cmdline-tools-latest
                build-tools-34-0-0
                build-tools-33-0-1
                platform-tools
                platforms-android-34
                emulator
                system-images-android-34-default-x86-64
                ndk-25-1-8937393
              ]))

            flutter
            jdk17
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

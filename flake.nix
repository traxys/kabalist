{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.android-nixpkgs.url = "github:tadfisher/android-nixpkgs";
  inputs.rust-overlay.url = "github:oxalica/rust-overlay";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    android-nixpkgs,
    rust-overlay,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          android_sdk.accept_license = true;
        };
        overlays = [(import rust-overlay)];
      };
    in {
      devShell = with pkgs;
        mkShell {
          nativeBuildInputs = [pkgs.bashInteractive];

		  DATABASE_URL="postgres://traxys:traxys@localhost/list";

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

			# Rust
            (rust-bin.stable.latest.default.override {
              targets = ["wasm32-unknown-unknown"];
            })

			# Web
			trunk
			wasm-bindgen-cli
          ];
        };
    });
}

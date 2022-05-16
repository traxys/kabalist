{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.android-nixpkgs.url = "github:tadfisher/android-nixpkgs";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    android-nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          android_sdk.accept_license = true;
        };
      };
    in {
      devShell = with pkgs;
        mkShell {
          nativeBuildInputs = [pkgs.bashInteractive];
          buildInputs = [
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
          ];
        };
    });
}

{ pkgs ? import <nixpkgs> { config.android_sdk.accept_license = true; } }:

let
  android = pkgs.androidenv.composeAndroidPackages {
    includeEmulator = false;
    platformVersions = [ "30" ];
	buildToolsVersions = ["29.0.2"];
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    flutter
    android.platform-tools
    jdk8
	dart
  ];

  ANDROID_HOME = "${android.androidsdk}/libexec/android-sdk";
  ANDROID_SDK_ROOT="${android.androidsdk}/libexec/android-sdk";
  JAVA_HOME = pkgs.jdk8;
  ANDROID_AVD_HOME = (toString ./.) + "/.android/avd";
  DART_SDK = "${pkgs.dart}/bin";
}

{pkgs}: {
  channel = "unstable";
  packages = [
    pkgs.flutter
    pkgs.nodePackages.firebase-tools
    pkgs.jdk17
    pkgs.unzip
  ];
  idx.extensions = [
    "Dart-Code.dart-code"
    "Dart-Code.flutter"
    "eamodio.gitlens"
  ];
  idx.previews = {
    previews = {
      android = {
        command = [
          "flutter"
          "run"
          "--machine"
          "-d"
          "android"
          "-d"
          "emulator-5554"
        ];
        manager = "flutter";
      };
    };
  };
}
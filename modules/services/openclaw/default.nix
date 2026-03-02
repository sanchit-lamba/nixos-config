# OpenClaw - installed via flake
#
# OpenClaw is built from the flake input defined in flake.nix.
# The package is built from source using the upstream repository.
{
  pkgs,
  inputs,
  ...
}: let
  openclaw = pkgs.stdenv.mkDerivation {
    pname = "openclaw";
    version = "unstable";
    src = inputs.openclaw;

    nativeBuildInputs = with pkgs; [
      cmake
      pkg-config
    ];

    buildInputs = with pkgs; [
      SDL2
      SDL2_mixer
      SDL2_ttf
      SDL2_image
      SDL2_gfx
      tinyxml-2
      zlib
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
    ];

    meta = with pkgs.lib; {
      description = "Open source reimplementation of Captain Claw";
      homepage = "https://github.com/pjasicek/OpenClaw";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  };
in {
  environment.systemPackages = [
    openclaw
  ];
}

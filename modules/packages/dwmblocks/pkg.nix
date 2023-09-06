{ stdenv, pkgs, libX11, libXinerama, libXft, myFlakeVersion }:
with pkgs.lib;

stdenv.mkDerivation rec {
  name = "local-dwmblocks-${version}";
  version = "1.0.0-pedrohms-${myFlakeVersion}";

  src = pkgs.fetchFromGitHub {
    name  = "1.0.0-${myFlakeVersion}";
    owner = "pedrohms";
    repo  = "dwmblocks";
    rev   = "992222857d50ab371f29636f1243530acef28e6d";
    sha256 = "ihIN6MBzTXTgMqQeiUW2tpsxEYU/a+16prelzaCFU6Y=";
  };

  # unpackPhase = ''tar -xf $src'';
  
  buildInputs = [ libX11 libXinerama libXft ];

  buildPhase  = ''make'';

  installPhase = ''make PREFIX=$out DESTDIR="" install'';
}

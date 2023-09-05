{ stdenv, pkgs, libX11, libXinerama, libXft, myFlakeVersion }:
with pkgs.lib;

stdenv.mkDerivation rec {
  name = "local-dwm-${version}";
  version = "6.4.0-pedrohms-${myFlakeVersion}";

  src = pkgs.fetchFromGitHub {
    name  = "6.4.0-050920231255-${myFlakeVersion}";
    owner = "pedrohms";
    repo  = "dwm";
    rev   = "49f08df2bc513875ea1d0c7d127926a266e66a47";
    sha256 = "9oNPQGEyKP2EZ/xOWMEuNkBah3nMcArwl7l/q1ZY7zU=";
  };

  # unpackPhase = ''tar -xf $src'';
  
  buildInputs = [ libX11 libXinerama libXft ];

  buildPhase  = ''make'';

  installPhase = ''make PREFIX=$out DESTDIR="" install'';
}

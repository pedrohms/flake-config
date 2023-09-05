{ stdenv, pkgs, libX11, libXinerama, libXft, myFlakeVersion }:
with pkgs.lib;

stdenv.mkDerivation rec {
  name = "local-dwm-${version}";
  version = "6.4.0-pedrohms-${myFlakeVersion}";

  src = pkgs.fetchFromGitHub {
    name  = "6.4.0-050920231255-${myFlakeVersion}";
    owner = "pedrohms";
    repo  = "dwm";
    rev   = "724c473cd9ee370cb8a1816f4a77fd481b310dca";
    sha256 = "3Ain09p+vWXNNmUHIzx5JKbP4ngLlTmw01JTq8duPWg=";
  };

  # unpackPhase = ''tar -xf $src'';
  
  buildInputs = [ libX11 libXinerama libXft ];

  buildPhase  = ''make'';

  installPhase = ''make PREFIX=$out DESTDIR="" install'';
}

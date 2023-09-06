{ stdenv, pkgs, libX11, libXinerama, libXft, myFlakeVersion }:
with pkgs.lib;

stdenv.mkDerivation rec {
  name = "local-dwm-${version}";
  version = "6.4.0-pedrohms-${myFlakeVersion}";

  src = pkgs.fetchFromGitHub {
    name  = "6.4.0-050920231255-${myFlakeVersion}";
    owner = "pedrohms";
    repo  = "dwm";
    rev   = "954028973f7a9395ae9a61362b44e154efefd91c";
    sha256 = "rjsnXP/EMq3N9eJgaKTavl2vSz+N61uVxtjbHn9y1Aw=";
  };

  # unpackPhase = ''tar -xf $src'';
  
  buildInputs = [ libX11 libXinerama libXft ];

  buildPhase  = ''make'';

  installPhase = ''make PREFIX=$out DESTDIR="" install'';
}

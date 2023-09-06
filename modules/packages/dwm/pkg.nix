{ stdenv, pkgs, libX11, libXinerama, libXft, myFlakeVersion }:
with pkgs.lib;

stdenv.mkDerivation rec {
  name = "local-dwm-${version}";
  version = "6.4.0-pedrohms-${myFlakeVersion}";

  src = pkgs.fetchFromGitHub {
    name  = "6.4.0-050920231255-${myFlakeVersion}";
    owner = "pedrohms";
    repo  = "dwm";
    rev   = "2227d4956b40fb31a7e4430be3236d45175fe6ff";
    sha256 = "YYq0DMLo6FjnNBAVS1+rL8Gc2qbIKBbzCdRtCcp0V7A=";
  };

  # unpackPhase = ''tar -xf $src'';
  
  buildInputs = [ libX11 libXinerama libXft ];

  buildPhase  = ''make'';

  installPhase = ''make PREFIX=$out DESTDIR="" install'';
}

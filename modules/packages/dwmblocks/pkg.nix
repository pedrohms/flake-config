{ stdenv, pkgs, libX11, libXinerama, libXft, myFlakeVersion }:
with pkgs.lib;

stdenv.mkDerivation rec {
  name = "local-dwmblocks-${version}";
  version = "1.0.0-pedrohms-${myFlakeVersion}";

  src = pkgs.fetchFromGitHub {
    name  = "1.0.0-${myFlakeVersion}";
    owner = "pedrohms";
    repo  = "dwmblocks";
    rev   = "7c1742bf2c813b64c5b1864bfe9eebc9d1126efb";
    sha256 = "nGFRMoeKTjKnyAxxEMrb1zOXRjuBVwlUW1YKGAxtLXs=";
  };

  # unpackPhase = ''tar -xf $src'';
  
  buildInputs = [ libX11 libXinerama libXft ];

  buildPhase  = ''make'';

  installPhase = ''make PREFIX=$out DESTDIR="" install'';
}

{ stdenv, pkgs, libX11, libXinerama, libXft, myFlakeVersion }:
with pkgs.lib;

stdenv.mkDerivation rec {
  name = "local-dwm-${version}";
  version = "6.4.0-pedrohms-${myFlakeVersion}";

  src = pkgs.fetchFromGitHub {
    name  = "6.4.0-050920231255-${myFlakeVersion}";
    owner = "pedrohms";
    repo  = "dwm";
    rev   = "91f7e06d378c80625b3cf0f5441db2317077f814";
    sha256 = "/W+mMoZv8VfVk1URbPCW5LDFGFcJa4929VdgVvWAOog=";
  };

  # unpackPhase = ''tar -xf $src'';
  
  buildInputs = [ libX11 libXinerama libXft ];

  buildPhase  = ''make'';

  installPhase = ''make PREFIX=$out DESTDIR="" install'';
}

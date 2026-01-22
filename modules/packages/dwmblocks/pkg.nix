{ stdenv, pkgs, libX11, libXinerama, libXft, myFlakeVersion }:
with pkgs.lib;

stdenv.mkDerivation rec {
  name = "local-dwmblocks-${version}";
  version = "1.0.0-pedrohms-${myFlakeVersion}";

  src = pkgs.fetchFromGitHub {
    name  = "1.0.0-${myFlakeVersion}";
    owner = "pedrohms";
    repo  = "dwmblocks";
    rev   = "cf4ebac6f85aee0a114ddc5b4f951aee1b363aa2";
    sha256 = "pLjBEzlc94Ip50DhW5b1QXENHY1Q58uzaiIxRVvEo3w=";
  };

  # unpackPhase = ''tar -xf $src'';
  
  buildInputs = [ libX11 libXinerama libXft ];

  buildPhase  = ''make'';

  installPhase = ''make PREFIX=$out DESTDIR="" install'';
}

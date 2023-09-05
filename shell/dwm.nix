with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "local-dwm-${version}";
  version = "6.5.1";

  src = pkgs.fetchFromGitHub {
    name  = "6.5.2";
    owner = "pedrohms";
    repo  = "dwm";
    rev   = "main";
    sha256 = "RutLhcDb7+vCwl/CtehirJjnyRThOuNdomBtgABrK+A=";
  };

  # unpackPhase = ''tar -xf $src'';
  
  buildInputs = [ xorg.libX11 xorg.libXinerama xorg.libXft ];

  buildPhase  = ''make'';

  installPhase = ''make PREFIX=$out DESTDIR="" install'';
}

with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "local-dwm-${version}";
  version = "6.5.1.1";
  src = /home/framework/ghq/git.suckless.org/dwm;
  # src = /home/vmuser/ghq/github.com/pedrohms/dwm;

  buildInputs = [ xorg.libX11 xorg.libXinerama xorg.libXft ];
  
  unpackPhase = ''cp -r $src/* .'';

  buildPhase  = ''
  make
  '';

  installPhase = ''make PREFIX=$out DESTDIR="" install'';
}

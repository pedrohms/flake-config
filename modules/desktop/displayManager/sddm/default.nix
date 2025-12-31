#  Lightdm configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./displayManager
#               └─ ./lightdm
#                   └─ default.nix *
#

{ inputs, config, lib, pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true; # Necessário para temas baseados em Qt6/Plasma 6
    
    # Força o uso do SDDM versão Qt6 (do ecossistema Plasma 6)
    package = pkgs.kdePackages.sddm;

    # Define o tema para o padrão do Plasma
    theme = "breeze";

    # Aqui está o pulo do gato: instalar as dependências visuais sem o desktop inteiro
    extraPackages = with pkgs.kdePackages; [
      breeze        # O estilo visual
      breeze-icons  # Os ícones
      qtsvg         # Renderização de vetores (essencial para o tema não quebrar)
      qtmultimedia  # Necessário para alguns componentes animados
      qt5compat     # Camada de compatibilidade usada por alguns scripts de tema
      plasma-workspace-wallpapers # (Opcional) Se quiser os wallpapers oficiais
    ];
  };

  # Garante que os ícones e temas estejam no path do sistema
  environment.systemPackages = with pkgs.kdePackages; [
    breeze
    breeze-icons
  ];
}

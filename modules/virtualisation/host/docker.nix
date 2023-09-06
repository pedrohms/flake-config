{ config, pkgs, user, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      rootless = { 
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  users.groups.docker.members = [ "${user}" ];

  #environment = {
  #  interactiveShellInit = ''
  #    alias rtmp='docker start nginx-rtmp'
  #  '';                                                           # Alias to easily start container
  #};

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}

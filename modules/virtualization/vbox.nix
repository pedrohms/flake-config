{ config, pkgs, user, ... }:

{
  virtualisation = {
    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
    };
  };

  users.groups.vboxusers.members = [ "${user}" ];
}

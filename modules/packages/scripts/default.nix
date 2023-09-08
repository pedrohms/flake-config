{ stdenv, pkgs, inputs, myFlakeVersion, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
  ph-volume-status = pkgs.writeShellScriptBin "ph-volume-status" ''
    vol="$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"
    echo "''${vol}% "
  '';
in
{
  environment = {
    systemPackages = with pkgs; [
      nvidia-offload
      ph-volume-status
    ];
  };
}

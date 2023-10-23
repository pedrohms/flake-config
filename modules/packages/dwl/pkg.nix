{ pkgs, patches, dwl-source, cmd, ... }:
pkgs.dwl.overrideAttrs
  (finalAttrs: previousAttrs: {
    src = dwl-source;
    inherit patches;
    postPatch =
      let
        configFile = ../dwl-config.h;
      in
      ''
        cp ${configFile} config.def.h
        substituteInPlace ./config.def.h --replace "@FUZZEL_TIMER" "${cmd.fuzzel_timer}"
        substituteInPlace ./config.def.h --replace "@TERMINAL" "${cmd.terminal}"
      '';
  })

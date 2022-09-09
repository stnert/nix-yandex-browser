{ config, lib, ... }:

with lib;

let
  cfg = config.programs.yandex-browser;
  cfgChromium = config.programs.chromium;

  defaultProfile = filterAttrs (k: v: v != null) {
    HomepageLocation = cfgChromium.homepageLocation;
    DefaultSearchProviderEnabled = cfgChromium.defaultSearchProviderEnabled;
    DefaultSearchProviderSearchURL = cfgChromium.defaultSearchProviderSearchURL;
    DefaultSearchProviderSuggestURL = cfgChromium.defaultSearchProviderSuggestURL;
    ExtensionInstallForcelist = cfgChromium.extensions;
  };
in

{
  ###### interface

  options = {
    programs.yandex-browser = {
      enable = mkEnableOption "<command>chromium</command> policies";
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    environment.etc."opt/yandex/browser/policies/managed/default.json".text = builtins.toJSON defaultProfile;
    environment.etc."opt/yandex/browser/policies/managed/extra.json".text = builtins.toJSON cfgChromium.extraOpts;
  };
}
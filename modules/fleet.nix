{ lib, pkgs, config, options, ... }:
with lib;
let
  cfg = config.fleet;
  localHostName = config.networking.hostName;
  # Filter machines
  thisMachine = machines: getAttr localHostName machines;
  otherMachines = machines:
    filterAttrs (n: _: n != localHostName) machines;
  # Generate build machines
  buildMachines = machines: mapAttrsToList buildMachine (otherMachines machines);
  buildMachine = name:
    { hostName, systems, maxJobs, speedFactor, supportedFeatures
    , mandatoryFeatures }:
    if name == localHostName then
      null
    else {
      sshUser = "fleet-builder";
      sshKey = "/home/fleet-builder/.ssh/id_rsa";
      inherit hostName systems maxJobs speedFactor;
      inherit supportedFeatures mandatoryFeatures;
    };
in {
  options.fleet = {
    enable = mkEnableOption "fleet managed network configuration";
    base = mkOption {
      type = types.str;
      description = "Base dir where SSH keys are found.";
    };
    machines = mkOption {
      description = "Definition of fleet machines.";
      type = with types;
        attrsOf (submodule ({ config, ... }: {
          options = {
            hostName = mkOption {
              type = str;
              description = "Hostname or IP used to connect to the given machine.";
              default = localHostName + ".local";
            };
            systems = mkOption {
              type = listOf str;
              description = "Lost of system types supported by the given machine.";
            };
            maxJobs = mkOption {
              type = int;
              default = 4;
              description =
                "Maximum number of jobs to be run in parallel on the given machine.";
            };
            speedFactor = mkOption {
              type = int;
              default = 4;
              description =
                "Relative weight of the compute strength of the given machine.";
            };
            supportedFeatures = mkOption {
              type = listOf str;
              default = [ ];
              description = "List of supported features of the given machine.";
            };
            mandatoryFeatures = mkOption {
              type = listOf str;
              default = [ ];
              description = "List of mandatory features of the given machine.";
            };
          };
        }));
    };
  };

  config = lib.mkIf (cfg.enable == true) ({
    users.users.fleet-builder = {
      isNormalUser = true;
      extraGroups = [ ];
    };
    nix = {
      trustedUsers = [ "fleet-builder" ];
      distributedBuilds = true;
      buildMachines = buildMachines cfg.machines;
      extraOptions = "builders-use-substitutes = true";
    };
  } // (
    # Only offer deployment options if Morph is used
    if hasAttr "deployment" options then {
      deployment = {
        targetHost = (thisMachine cfg.machines).hostName;
        substituteOnDestination = true;
        secrets = {
          "fleet-builder-id_rsa" = {
            source = "${cfg.base}/id_rsa";
            destination = "/home/fleet-builder/.ssh/id_rsa";
            owner.user = "fleet-builder";
            owner.group = "nogroup";
            action =
              [ "chown" "fleet-builder:nogroup" "/home/fleet-builder/.ssh" ];
          };
          "fleet-builder-id_rsa_pub" = {
            source = "${cfg.base}/id_rsa.pub";
            destination = "/home/fleet-builder/.ssh/id_rsa.pub";
            owner.user = "fleet-builder";
            owner.group = "nogroup";
          };
          "fleet-builder-authorized_keys" = {
            source = "${cfg.base}/id_rsa.pub";
            destination = "/home/fleet-builder/.ssh/authorized_keys";
            owner.user = "fleet-builder";
            owner.group = "nogroup";
          };
        };
      };
    } else
      { }));
}

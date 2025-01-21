{
  kabalist-web,
  kabalist-server,
}: {
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.services.kabalist = {
    enable = mkEnableOption "kabalist, a shared list manager";

    package = mkOption {
      type = types.package;
      default = kabalist-server;
    };

    port = mkOption {
      type = types.port;
      default = 8080;
    };

    user = mkOption {
      type = types.str;
      default = "kabalist";
    };

    expiry = mkOption {
      type = types.int;
      default = 1000000;
      description = "Expiry time of tokens in ms";
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
    };

    enableFrontend = mkEnableOption "kabalist web application";
  };

  config = let
    cfg = config.services.kabalist;
  in
    mkIf cfg.enable {
      systemd.services.kabalist = {
        description = "kabalist";
        after = ["network.target" "postgresql.service"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = "kabalist";
          ExecStart = "${cfg.package}/bin/kabalist_api";
          EnvironmentFile = optional (cfg.environmentFile != null) cfg.environmentFile;
          # Security
          NoNewPrivileges = true;
          # Sandboxing
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = ["AF_UNIX AF_INET AF_INET6"];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          PrivateMounts = true;
        };

        environment =
          {
            KABALIST_PORT = toString cfg.port;
            KABALIST_DATABASE_URL = "postgres://${cfg.user}/kabalist?host=/var/run/postgresql";
            KABALIST_EXP = toString cfg.expiry;
          }
          // lib.optionalAttrs cfg.enableFrontend {
            KABALIST_FRONTEND = "${kabalist-web}";
          };
      };

      services.postgresql = {
        ensureUsers = [
          {
            name = cfg.user;
            ensureDBOwnership = true;
          }
        ];
        ensureDatabases = ["kabalist"];
      };

      users.users = mkIf (cfg.user == "kabalist") {
        kabalist = {
          description = "Kabalist Service";
          group = "kabalist";
          isSystemUser = true;
        };
      };
      users.groups.kabalist = {};
    };
}

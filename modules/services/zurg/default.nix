# Zurg Real-Debrid WebDAV gateway + rclone mount
#
# Setup:
#   1. Replace YOUR_REALDEBRID_API_TOKEN in /etc/zurg/config.yml after first deploy
#   2. The rclone mount will expose Real-Debrid content at /mnt/zurg
#   3. Plex libraries should point to /mnt/zurg and /media/cache
{
  pkgs,
  lib,
  config,
  ...
}: let
  # Zurg binary - update version/hash when upgrading
  zurg = pkgs.stdenv.mkDerivation rec {
    pname = "zurg";
    version = "0.9.3-hotfix.11";

    src = pkgs.fetchzip {
      url = "https://github.com/debridmediamanager/zurg-testing/releases/download/v${version}/zurg-v${version}-linux-amd64.zip";
      hash = lib.fakeHash; # Replace with actual hash on first build: nix-prefetch-url --unpack <url>
    };

    installPhase = ''
      mkdir -p $out/bin
      cp zurg $out/bin/zurg
      chmod +x $out/bin/zurg
    '';
  };
in {
  # Static user for zurg service
  users.users.zurg = {
    isSystemUser = true;
    group = "zurg";
    home = "/var/lib/zurg";
  };
  users.groups.zurg = {};

  # Zurg configuration template
  # The actual config with the API token should be placed at /etc/zurg/config.yml
  # with restricted permissions (0600) after deployment.
  # Get your token at: https://real-debrid.com/apitoken
  #
  # Example config.yml:
  #   token: YOUR_REALDEBRID_API_TOKEN
  #   host: "0.0.0.0"
  #   port: 9999
  #   concurrent_workers: 32
  #   check_for_changes_every_secs: 10
  #   retain_rd_torrent_name: true
  #   auto_delete_rar_torrents: true

  systemd.tmpfiles.rules = [
    "d /etc/zurg 0750 zurg zurg -"
  ];

  # rclone config for mounting zurg's WebDAV
  environment.etc."rclone/rclone.conf".text = ''
    [zurg]
    type = webdav
    url = http://localhost:9999/dav
    vendor = other
  '';

  # Zurg systemd service
  systemd.services.zurg = {
    description = "Zurg Real-Debrid WebDAV Server";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${zurg}/bin/zurg --config /etc/zurg/config.yml";
      Restart = "always";
      RestartSec = 5;
      User = "zurg";
      Group = "zurg";
      StateDirectory = "zurg";
      CacheDirectory = "zurg";
    };
  };

  # rclone mount for Zurg WebDAV
  systemd.services.rclone-zurg = {
    description = "rclone mount for Zurg WebDAV";
    after = ["zurg.service"];
    requires = ["zurg.service"];
    wantedBy = ["multi-user.target"];

    path = [pkgs.fuse pkgs.fuse3];

    serviceConfig = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /mnt/zurg";
      ExecStart = lib.concatStringsSep " " [
        "${pkgs.rclone}/bin/rclone mount zurg: /mnt/zurg"
        "--config /etc/rclone/rclone.conf"
        "--allow-other"
        "--dir-cache-time 10s"
        "--vfs-cache-mode full"
        "--vfs-cache-max-size 50G"
        "--vfs-read-ahead 128M"
        "--buffer-size 64M"
        "--log-level INFO"
      ];
      ExecStop = "/run/wrappers/bin/fusermount -uz /mnt/zurg";
      Restart = "always";
      RestartSec = 10;
      Environment = ["PATH=${lib.makeBinPath [pkgs.fuse pkgs.fuse3]}"];
    };
  };

  # Allow FUSE mounts with allow-other
  programs.fuse.userAllowOther = true;

  environment.systemPackages = with pkgs; [
    rclone
    fuse
    fuse3
  ];
}

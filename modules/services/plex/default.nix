# Plex Media Server
{
  pkgs,
  config,
  ...
}: {
  services.plex = {
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/plex";
  };

  # Create media and cache directories
  systemd.tmpfiles.rules = [
    "d /media/plex 0755 plex plex -"
    "d /media/plex/movies 0755 plex plex -"
    "d /media/plex/tv 0755 plex plex -"
    "d /media/cache 0755 plex plex -"
    "d /media/cache/movies 0755 plex plex -"
    "d /media/cache/tv 0755 plex plex -"
  ];

  # Plex needs access to the zurg mount and cache
  users.users.plex.extraGroups = ["fuse"];
}

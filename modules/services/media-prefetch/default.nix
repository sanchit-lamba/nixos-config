# Media prefetch/cache service
#
# Monitors Plex for active playback and prefetches:
#   - Next 2 episodes when watching a TV series
#   - Remainder of a movie file when playback begins
#
# Content is cached locally at /media/cache for fast access
{
  pkgs,
  lib,
  config,
  ...
}: let
  prefetchScript = pkgs.writeShellApplication {
    name = "plex-prefetch";
    runtimeInputs = with pkgs; [curl jq rclone coreutils];
    text = ''
      PLEX_URL="http://localhost:32400"
      PLEX_TOKEN_FILE="/var/lib/plex-prefetch/token"
      CACHE_DIR="/media/cache"
      RCLONE_CONFIG="/etc/rclone/rclone.conf"
      ZURG_MOUNT="/mnt/zurg"
      PREFETCH_EPISODES=2
      LOCK_DIR="/var/lib/plex-prefetch/locks"

      mkdir -p "$LOCK_DIR"

      if [ ! -f "$PLEX_TOKEN_FILE" ]; then
        echo "ERROR: Plex token not found at $PLEX_TOKEN_FILE"
        echo "Create the file with your Plex token: echo 'YOUR_TOKEN' > $PLEX_TOKEN_FILE"
        exit 1
      fi

      PLEX_TOKEN=$(cat "$PLEX_TOKEN_FILE")

      get_sessions() {
        curl -s "$PLEX_URL/status/sessions" \
          -H "X-Plex-Token: $PLEX_TOKEN" \
          -H "Accept: application/json" 2>/dev/null || echo "{}"
      }

      prefetch_file() {
        local src="$1"
        local dst="$2"
        local lock_file="$LOCK_DIR/$(echo "$dst" | md5sum | cut -d' ' -f1)"

        # Skip if already cached or in progress
        if [ -f "$dst" ] || [ -f "$lock_file" ]; then
          return 0
        fi

        touch "$lock_file"
        echo "Prefetching: $src -> $dst"
        mkdir -p "$(dirname "$dst")"

        if rclone copy --config "$RCLONE_CONFIG" "zurg:$src" "$(dirname "$dst")" --progress 2>/dev/null; then
          echo "Cached: $dst"
        else
          echo "Failed to cache: $src"
        fi
        rm -f "$lock_file"
      }

      prefetch_next_episodes() {
        local show_key="$1"
        local current_episode_index="$2"

        # Get all episodes in the season
        episodes=$(curl -s "$PLEX_URL$show_key?X-Plex-Token=$PLEX_TOKEN" \
          -H "Accept: application/json" 2>/dev/null)

        echo "$episodes" | jq -r --argjson idx "$current_episode_index" \
          --argjson count "$PREFETCH_EPISODES" \
          '.MediaContainer.Metadata // [] |
           sort_by(.index) |
           [.[] | select(.index > $idx)] |
           .[0:$count] |
           .[].Media[0].Part[0].file // empty' | while read -r file_path; do
          if [ -n "$file_path" ]; then
            # Convert absolute path to relative path within zurg mount
            relative_path="''${file_path#$ZURG_MOUNT/}"
            cache_path="$CACHE_DIR/tv/$relative_path"
            prefetch_file "$relative_path" "$cache_path" &
          fi
        done
      }

      prefetch_movie() {
        local file_path="$1"
        if [ -n "$file_path" ]; then
          relative_path="''${file_path#$ZURG_MOUNT/}"
          cache_path="$CACHE_DIR/movies/$relative_path"
          prefetch_file "$relative_path" "$cache_path" &
        fi
      }

      echo "Plex prefetch service started - polling for active sessions..."

      while true; do
        sessions=$(get_sessions)
        session_count=$(echo "$sessions" | jq -r '.MediaContainer.size // 0')

        if [ "$session_count" -gt 0 ]; then
          echo "$sessions" | jq -c '.MediaContainer.Metadata // [] | .[]' | while read -r session; do
            media_type=$(echo "$session" | jq -r '.type // empty')
            file_path=$(echo "$session" | jq -r '.Media[0].Part[0].file // empty')

            case "$media_type" in
              episode)
                episode_index=$(echo "$session" | jq -r '.index // 0')
                season_key=$(echo "$session" | jq -r '.parentKey // empty')
                if [ -n "$season_key" ]; then
                  echo "TV playback detected: episode $episode_index - prefetching next $PREFETCH_EPISODES episodes"
                  prefetch_next_episodes "$season_key/children" "$episode_index"
                fi
                ;;
              movie)
                echo "Movie playback detected - caching full file"
                prefetch_movie "$file_path"
                ;;
            esac
          done
        fi

        # Poll every 30 seconds
        sleep 30
      done
    '';
  };
in {
  # Prefetch service state directory
  systemd.tmpfiles.rules = [
    "d /var/lib/plex-prefetch 0750 root root -"
    "d /var/lib/plex-prefetch/locks 0750 root root -"
  ];

  systemd.services.plex-prefetch = {
    description = "Plex Media Prefetch/Cache Service";
    after = ["plex.service" "rclone-zurg.service"];
    wants = ["plex.service" "rclone-zurg.service"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${prefetchScript}/bin/plex-prefetch";
      Restart = "always";
      RestartSec = 30;
      StateDirectory = "plex-prefetch";
    };
  };

  # Periodic cache cleanup - remove files older than 7 days
  systemd.services.plex-cache-cleanup = {
    description = "Clean up old prefetched media cache";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.findutils}/bin/find /media/cache -type f -mtime +7 -delete";
    };
  };

  systemd.timers.plex-cache-cleanup = {
    description = "Weekly media cache cleanup";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };
}

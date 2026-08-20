#!/usr/bin/env python3
"""
spotify_player player_event_hook_command target.

spotify_player's own built-in enable_notify/notify_format never produces a
visible macOS banner here (no attempt shows up in the unified log at all when
a track changes), a known rough edge in its macOS notification backend. This
re-implements "notify on track change" via terminal-notifier instead, using
spotify_player's own `get key playback` for title/artist/album art (rather
than macOS's MediaRemote info, which spotify_player -- having no .app bundle
-- can't fully populate) so the notification can show real album art.

Invoked by spotify_player as: notify.py <Changed|Playing|Paused|EndOfTrack> <track_id> [position_ms]
"""
import json
import subprocess
import sys
import urllib.request

ARTWORK_PATH = "/tmp/spotify_player_artwork.jpg"


def main() -> None:
    event = sys.argv[1] if len(sys.argv) > 1 else ""
    if event != "Changed":
        return

    try:
        raw = subprocess.run(
            ["spotify_player", "get", "key", "playback"],
            capture_output=True, text=True, timeout=3, check=True,
        ).stdout
        data = json.loads(raw)
        item = data.get("item") or {}
        title = item.get("name") or ""
        artists = ", ".join(a["name"] for a in item.get("artists", []))
        images = sorted(
            item.get("album", {}).get("images", []),
            key=lambda i: i.get("width", 0),
        )
    except Exception:
        return

    if not title:
        return

    args = [
        "terminal-notifier",
        "-title", title,
        "-message", artists,
        "-group", "spotify_player",
    ]

    # smallest image that's still reasonably crisp as a notification thumbnail
    art_url = next((i["url"] for i in images if i.get("width", 0) >= 300), None) \
        or (images[-1]["url"] if images else None)
    if art_url:
        try:
            urllib.request.urlretrieve(art_url, ARTWORK_PATH)
            args += ["-contentImage", ARTWORK_PATH, "-appIcon", ARTWORK_PATH]
        except Exception:
            pass

    subprocess.run(args)


if __name__ == "__main__":
    main()

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

On auto-advance (a track ending naturally, as opposed to a manual skip/back),
this hook fires before spotify_player's own playback-state cache has caught
up to the new track_id, so an immediate `get key playback` still returns the
previous track. `get key playback` is polled until its item.id matches the
track_id the hook was invoked with (falling back to whatever it last saw if
that never happens) instead of trusting the first read.
"""
import json
import subprocess
import sys
import time
import urllib.request

ARTWORK_PATH = "/tmp/spotify_player_artwork.jpg"
POLL_ATTEMPTS = 6
POLL_INTERVAL_SECS = 0.25


def fetch_playback_item(expected_track_id: str) -> dict:
    item = {}
    for _ in range(POLL_ATTEMPTS):
        try:
            raw = subprocess.run(
                ["spotify_player", "get", "key", "playback"],
                capture_output=True, text=True, timeout=3, check=True,
            ).stdout
            item = json.loads(raw).get("item") or {}
        except Exception:
            item = {}

        if not expected_track_id or item.get("id") == expected_track_id:
            break
        time.sleep(POLL_INTERVAL_SECS)
    return item


def main() -> None:
    event = sys.argv[1] if len(sys.argv) > 1 else ""
    if event != "Changed":
        return

    track_id = sys.argv[2] if len(sys.argv) > 2 else ""
    item = fetch_playback_item(track_id)
    title = item.get("name") or ""
    artists = ", ".join(a["name"] for a in item.get("artists", []))
    images = sorted(
        item.get("album", {}).get("images", []),
        key=lambda i: i.get("width", 0),
    )

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
            args += ["-contentImage", ARTWORK_PATH]
        except Exception:
            pass

    subprocess.run(args)


if __name__ == "__main__":
    main()

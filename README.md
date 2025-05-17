# Blog-Scripts

## Loop

Runs a command in a constant loop and logs the timestamp to elapsed.txt and timestamp.txt. Useful for testing how long the battery will last with certain commands.

### Livi
    
```bash
WAYLAND_DISPLAY=wayland-0 ./loop.sh --command "livi" --flatpak "org.sigxcpu.Livi" --args "~/Videos/Short_720p.mp4" --delay 5 --timeout 30 --name "livi_720p_h264"
```

### MPV

```bash
WAYLAND_DISPLAY=wayland-0 ./loop.sh --command "mpv" --args "~/Videos/Short_720p.mp4" --delay 5 --timeout 30 --name "mpv_720p_h264"
```

### Screen time
    
```bash
./loop.sh --command "sleep" --args "60" --delay 5 --timeout 50 --name "screen_time"
```

### Standby
```bash
./loop.sh --command "sleep" --args "1800" --delay 5 --timeout 1790 --name "standby"
```

### Stress

```bash
./loop.sh --command "stress" --args "-c 4" --delay 60 --timeout 0
```

## Generate 24 hour video clip

While you can loop the video player command, this isnt possible with the firefox video player test so instead we generate a 24 hour long video file from the short videos looped.

```bash
ffmpeg -stream_loop 2500 -i Short_1080p.mp4 -c copy Long_1080p.mp4
```

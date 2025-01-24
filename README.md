# Blog-Scripts

## Loop

Runs a command in a constant loop and logs the timestamp to elapsed.txt and timestamp.txt. Useful for testing how long the battery will last with certain commands.

### Livi
    
```bash
DISPLAY=:0 ./loop.sh --command "livi" --flatpak "org.sigxcpu.Livi" --args "Videos/Short_720p.mkv" --delay 5 --timeout 30 --name "livi_720p_h264"
```

### MPV

```bash
DISPLAY=:0 ./loop.sh --command "mpv" --args "~/Videos/Short_720p.mkv" --delay 5 --timeout 30 --name "mpv_720p_h264"
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

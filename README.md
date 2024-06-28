# Blog-Scripts

## Loop

Runs a command in a constant loop and logs the timestamp to elapsed.txt and timestamp.txt. Useful for testing how long the battery will last with certain commands.

### Livi
    
    ```bash
    DISPLAY=:0 ./loop.sh --command "livi" --flatpak "org.sigxcpu.Livi" --args "VIDEO.MKV" --delay 5 --timeout 30
    ```

### MPV

    ```bash
    DISPLAY=:0 ./loop.sh --command "mpv" --args "VIDEO.MKV" --delay 5 --timeout 30
    ```

### Screen time
    
    ```bash
    ./loop.sh --command "sleep" --args "60"" --delay 5 --timeout 50
    ```

### Stress

    ```bash
    ./loop.sh --command "stress" --args "-c 4" --delay 60 --timeout 0
    ```

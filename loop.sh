#!/usr/bin/env bash

# This script will loop a command so it is constantly executed.

set -euo pipefail

# Function to display an error message and exit
die() {
    printf '%s\n' "$1" >&2
    exit 1
}

trap "exit" INT

log_timestamp() {
    # Log time to file
    date >> timestamps.txt

    # Calculate the time elapsed
    END=$(date +%s)
    ELAPSED=$((END-START))

    echo "Elapsed time: $ELAPSED seconds " > elapsed.txt
}

# Default values
TIMEOUT=0
FLATPAK=""
DELAY=5
COMMAND=""
ARGS=""
SELF=$$
START=$(date +%s)

# Parse command-line options
while :; do
    case "${1-}" in
        -h | -\? | --help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  -h, --help           Display this help message."
            echo "  -t, --timeout        Timeout for the command in seconds. Default: 0 (no timeout)."
            echo "  -d, --delay          Delay between command executions in seconds. Default: 5."
            echo "                          If timeout is 0, this is the time between checks."
            echo "  --flatpak            Flatpak application string. Default: none."
            echo "                          Requires also setting command with program name."
            echo "  -c, --command        Command to run."
            echo "  -a, --args           Arguments for the command."
            exit 0
            ;;
        -t | --timeout)
            TIMEOUT="${2-}"
            if [[ -z "$TIMEOUT" ]]; then
                die "ERROR: $1 requires a non-empty option argument."
            fi
            shift
            ;;
        --flatpak)
            FLATPAK="${2-}"
            if [[ -z "$FLATPAK" ]]; then
                die "ERROR: $1 requires a non-empty option argument."
            fi
            shift
            ;;
        -c | --command)
            COMMAND="${2-}"
            if [[ -z "$COMMAND" ]]; then
                die "ERROR: $1 requires a non-empty option argument."
            fi
            shift
            ;;
        -a | --args)
            ARGS="${2-}"
            if [[ -z "$ARGS" ]]; then
                die "ERROR: $1 requires a non-empty option argument."
            fi
            shift
            ;;
        -d | --delay)
            DELAY="${2-}"
            if [[ -z "$DELAY" ]]; then
                die "ERROR: $1 requires a non-empty option argument."
            fi
            shift
            ;;
        --)
            shift
            break
            ;;
        -?*)
            die "ERROR: Unknown option: $1"
            ;;
        *)
            break
            ;;
    esac
    shift
done

# Ensure a command is set
if [[ -z "$COMMAND" ]]; then
    die "ERROR: No command specified. Use -l or another command option."
fi

# Initial timestamp to file
date > timestamps.txt

while true; do
    if [ -n "$FLATPAK" ]
    then
        flatpak run --user "$FLATPAK" $ARGS &
    else
        $COMMAND $ARGS &
    fi

    while true; do
        # Get the PID of the command, do not fail if the command is not found
        PID=$(pgrep -f "$COMMAND $ARGS" || true)
        # Remove the PID of the script itself
        PID=$(echo $PID | sed "s/$SELF//")

        # If the PID is not empty, break the loop
        if [ -n "$PID" ]
        then
            echo "PID: $PID"
            break
        fi
        sleep 1
    done

    if [ "$TIMEOUT" -eq 0 ]
    then
        # Check if the command is still running
        while true
        do
            # If the PID is empty, break the loop
            if ! ps -p $PID > /dev/null
            then
                break
            fi
        
            log_timestamp

            sleep "$DELAY"
        done
    else
        # let the command finish unless the timeout is reached
        for (( i=0; i<"$TIMEOUT"; i++ ))
        do
            if ! ps -p $PID > /dev/null
            then
                break
            fi

            sleep 1
        done

        # Kill PID if it is still running
        echo "Killing PID: $PID"
        kill $PID || true
    fi

    # Log the timestamp
    log_timestamp

    # Wait for the delay
    sleep "$DELAY"
    
done

#!/usr/bin/env bash

# This script will loop a command so it is constantly executed.

set -euo pipefail

# Function to display an error message and exit
die() {
    printf '%s\n' "$1" >&2
    exit 1
}

# Trap to exit on interrupt signal
trap "exit" INT

# Default values
TIMEOUT=0
FLATPAK=0
DELAY=3
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
            echo "  -t, --timeout <seconds>    Set a timeout for the command execution."
            echo "  -l, --livi <args>          Run the livi command with specified arguments."
            echo "  --flatpak                  Run the command using flatpak."
            echo "  -c, --command <command>    Run the specified command."
            echo "  -a, --args <args>          Arguments for the command."
            echo "  -h, --help                 Show this help message."
            exit 0
            ;;
        -t | --timeout)
            TIMEOUT="${2-}"
            if [[ -z "$TIMEOUT" ]]; then
                die "ERROR: $1 requires a non-empty option argument."
            fi
            shift
            ;;
        -l | --livi)
            COMMAND="livi"
            ARGS="${2-}"
            if [[ -z "$ARGS" ]]; then
                die "ERROR: $1 requires a non-empty option argument."
            fi
            shift
            ;;
        --flatpak)
            FLATPAK=1
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
    if [ "$FLATPAK" -eq 1 ]
    then
        if [ "$COMMAND" == "livi" ]
        then
            flatpak run --user org.sigxcpu.Livi $ARGS &
        fi
    else
        $COMMAND $ARGS &
    fi

    while true; do
        PID=$(pgrep -f "$COMMAND $ARGS")
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
        # Wait for the command to finish
        wait $PID
    else
        # let the command finish unless the timeout is reached
        for (( i=0; i<"$TIMEOUT"; i++ ))
        do
            if [ "$FLATPAK" -eq 0 ]
            then
                if ! ps -p $PID > /dev/null
                then
                    break
                fi
            fi

            sleep 1
        done

        # Kill PID if it is still running
        kill $PID || true
    fi

    # Log time to file
    date >> timestamps.txt

    # Calculate the time elapsed
    END=$(date +%s)
    ELAPSED=$((END-START))

    echo "Elapsed time: $ELAPSED seconds " > elapsed.txt

    # Wait for the delay
    sleep $DELAY
    
done

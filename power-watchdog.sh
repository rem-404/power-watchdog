#!/bin/bash

# ==============================================================================
# CONFIGURATION
# ==============================================================================
TARGETS=("192.168.X.XX" "192.168.X.XX") # Non-UPS-backed reference IPs
FAIL_THRESHOLD=2                        # Number of consecutive failures allowed
SLEEP_INTERVAL=120                      # Heartbeat interval in seconds


# ==============================================================================
# INITIALIZATION
# ==============================================================================
FAIL_COUNT=0

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}


# ==============================================================================
# MONITORING LOOP
# ==============================================================================
while true; do
    ALL_DOWN=true

    for TARGET in "${TARGETS[@]}"; do
        if ping -c 1 -W 1 $TARGET > /dev/null; then
            ALL_DOWN=false
            break
        fi
    done

    if $ALL_DOWN; then
        ((FAIL_COUNT++))
        log "All targets unreachable ($FAIL_COUNT/$FAIL_THRESHOLD)"
    else
        FAIL_COUNT=0
        log "At least one target reachable" # this is a little bit chatty, delete it for a cleaner log
    fi

    if [ $FAIL_COUNT -ge $FAIL_THRESHOLD ]; then
        log "Power outage. Initiating shutdown..."
        shutdown -h now
    fi

    sleep $SLEEP_INTERVAL
done

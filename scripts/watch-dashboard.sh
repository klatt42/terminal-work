#!/bin/bash
# Continuous Dashboard Monitor
# Runs session-monitor.sh every 3 seconds to keep dashboard live

MONITOR_SCRIPT="$HOME/projects/terminal-work/scripts/session-monitor.sh"
INTERVAL=3

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     DASHBOARD LIVE MONITOR - Running continuously             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "Updating dashboard data every ${INTERVAL} seconds..."
echo "Press Ctrl+C to stop"
echo ""

# Trap Ctrl+C to exit gracefully
trap 'echo ""; echo "Dashboard monitor stopped."; exit 0' INT

# Initial update
"$MONITOR_SCRIPT" > /dev/null 2>&1
echo "✓ Initial data collected at $(date +%H:%M:%S)"

# Continuous updates
while true; do
    sleep $INTERVAL
    "$MONITOR_SCRIPT" > /dev/null 2>&1
    echo "✓ Updated at $(date +%H:%M:%S)"
done

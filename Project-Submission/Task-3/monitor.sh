#!/bin/bash
# =============================================================================
# monitor.sh — Container Resource Monitor
# Captures CPU and memory usage of the running Docker container
# with timestamps. Logs stored in /opt/container-monitor/logs/
# Intended to be run via cron every minute.
# =============================================================================

# --- Configuration ---
CONTAINER_NAME="my-webapp"
LOG_DIR="/opt/container-monitor/logs"
LOG_FILE="$LOG_DIR/monitor_$(date +%Y-%m-%d).log"

# --- Ensure log directory exists ---
mkdir -p "$LOG_DIR"

# --- Get current timestamp ---
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# --- Check if container is running ---
CONTAINER_STATUS=$(docker inspect --format='{{.State.Status}}' "$CONTAINER_NAME" 2>/dev/null)

if [ "$CONTAINER_STATUS" != "running" ]; then
    echo "[$TIMESTAMP] WARNING: Container '$CONTAINER_NAME' is not running (status: ${CONTAINER_STATUS:-not found})" >> "$LOG_FILE"
    exit 1
fi

# --- Capture stats (no-stream = single snapshot) ---
STATS=$(docker stats --no-stream --format "{{.CPUPerc}},{{.MemUsage}},{{.MemPerc}}" "$CONTAINER_NAME" 2>/dev/null)

if [ -z "$STATS" ]; then
    echo "[$TIMESTAMP] ERROR: Failed to retrieve stats for container '$CONTAINER_NAME'" >> "$LOG_FILE"
    exit 1
fi

# --- Parse stats ---
CPU=$(echo "$STATS" | cut -d',' -f1)
MEM_USAGE=$(echo "$STATS" | cut -d',' -f2)
MEM_PERC=$(echo "$STATS" | cut -d',' -f3)

# --- Write to log file ---
echo "[$TIMESTAMP] CONTAINER: $CONTAINER_NAME | CPU: $CPU | MEM: $MEM_USAGE ($MEM_PERC)" >> "$LOG_FILE"

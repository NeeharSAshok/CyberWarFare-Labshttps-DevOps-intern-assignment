#!/bin/bash
# =============================================================================
# verify_permissions.sh
# Verifies ownership and access control on the monitoring directory.
# Run as root: sudo bash verify_permissions.sh
# =============================================================================

MONITOR_USER="monitor"
MONITOR_DIR="/opt/container-monitor"
TEST_FILE="$MONITOR_DIR/logs/test_access.tmp"

echo "============================================="
echo "  Access Control Verification Report"
echo "============================================="
echo ""

echo "--- Directory ownership and permissions ---"
ls -ld "$MONITOR_DIR"
ls -ld "$MONITOR_DIR/logs"
echo ""

echo "--- User info ---"
id "$MONITOR_USER" 2>/dev/null || echo "User '$MONITOR_USER' does not exist!"
echo ""

echo "--- Test 1: monitor user CAN write to logs ---"
sudo -u "$MONITOR_USER" touch "$TEST_FILE" 2>/dev/null && \
    echo "✅ PASS: monitor user can write to logs directory." || \
    echo "❌ FAIL: monitor user cannot write to logs directory."
sudo -u "$MONITOR_USER" rm -f "$TEST_FILE" 2>/dev/null

echo ""
echo "--- Test 2: monitor user CAN read logs directory ---"
sudo -u "$MONITOR_USER" ls "$MONITOR_DIR/logs" &>/dev/null && \
    echo "✅ PASS: monitor user can read logs directory." || \
    echo "❌ FAIL: monitor user cannot read logs directory."

echo ""
echo "--- Test 3: other users CANNOT access monitoring directory ---"
# Try as the current non-root user (e.g., devops)
CURRENT_USER=$(logname 2>/dev/null || echo "$SUDO_USER")
if [ -n "$CURRENT_USER" ] && [ "$CURRENT_USER" != "root" ]; then
    sudo -u "$CURRENT_USER" ls "$MONITOR_DIR" &>/dev/null && \
        echo "❌ FAIL: user '$CURRENT_USER' CAN access '$MONITOR_DIR' (should be restricted)." || \
        echo "✅ PASS: user '$CURRENT_USER' cannot access '$MONITOR_DIR'."
else
    echo "⚠ Skipped: Could not determine a non-root user to test with."
fi

echo ""
echo "--- Cron jobs for monitor user ---"
sudo crontab -u "$MONITOR_USER" -l 2>/dev/null || echo "(No cron jobs set for monitor user)"

echo ""
echo "============================================="
echo "  Verification complete."
echo "============================================="

#!/bin/bash
# =============================================================================
# setup_monitor_user.sh
# Creates a dedicated monitoring user, sets up the monitoring directory,
# assigns ownership, and restricts access to other users.
# Run as root: sudo bash setup_monitor_user.sh
# =============================================================================

set -e  # Exit on any error

MONITOR_USER="monitor"
MONITOR_DIR="/opt/container-monitor"

echo "=== Step 1: Create dedicated monitoring user ==="
if id "$MONITOR_USER" &>/dev/null; then
    echo "User '$MONITOR_USER' already exists, skipping creation."
else
    # Create system user with no login shell (security best practice)
    useradd --system --no-create-home --shell /usr/sbin/nologin "$MONITOR_USER"
    echo "User '$MONITOR_USER' created."
fi

echo ""
echo "=== Step 2: Create monitoring directory ==="
mkdir -p "$MONITOR_DIR/logs"
echo "Directory '$MONITOR_DIR' created."

echo ""
echo "=== Step 3: Assign ownership to monitoring user ==="
chown -R "$MONITOR_USER":"$MONITOR_USER" "$MONITOR_DIR"
echo "Ownership of '$MONITOR_DIR' assigned to '$MONITOR_USER'."

echo ""
echo "=== Step 4: Set permissions ==="
# Owner (monitor): full access (rwx)
# Group: no access
# Others: no access
chmod 700 "$MONITOR_DIR"
chmod 700 "$MONITOR_DIR/logs"
echo "Permissions set: 700 on '$MONITOR_DIR' and '$MONITOR_DIR/logs'."

echo ""
echo "=== Step 5: Allow monitor user to run docker stats (sudoers) ==="
SUDOERS_FILE="/etc/sudoers.d/monitor-docker"
cat > "$SUDOERS_FILE" << EOF
# Allow monitor user to run docker stats without password
$MONITOR_USER ALL=(ALL) NOPASSWD: /usr/bin/docker stats *, /usr/bin/docker inspect *
EOF
chmod 440 "$SUDOERS_FILE"
echo "Sudoers entry created at $SUDOERS_FILE."

echo ""
echo "=== Step 6: Update cron job to run as monitor user ==="
echo "Add the following line to root's crontab (sudo crontab -e):"
echo ""
echo "  * * * * * sudo -u $MONITOR_USER /opt/container-monitor/monitor.sh"
echo ""
echo "OR use the monitor user's own crontab:"
echo "  sudo crontab -u $MONITOR_USER -e"
echo "  Then add: * * * * * /opt/container-monitor/monitor.sh"

echo ""
echo "=== Setup complete! ==="
echo "Run verification with: bash verify_permissions.sh"

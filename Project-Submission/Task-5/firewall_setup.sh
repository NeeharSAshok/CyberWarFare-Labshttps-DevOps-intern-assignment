#!/bin/bash
# =============================================================================
# firewall_setup.sh
# Configures UFW firewall rules:
#   - SSH (port 22): allowed ONLY from a specific IP
#   - HTTP (port 80): allowed from anywhere
#   - Port 8000: allowed from anywhere (Docker web app)
#   - All other incoming traffic: denied by default
#
# Usage: sudo bash firewall_setup.sh <YOUR_SSH_IP>
# Example: sudo bash firewall_setup.sh 192.168.1.50
# =============================================================================

set -e

# --- Validate argument ---
if [ -z "$1" ]; then
    echo "Usage: sudo bash firewall_setup.sh <YOUR_SSH_IP>"
    echo "Example: sudo bash firewall_setup.sh 192.168.1.50"
    exit 1
fi

SSH_ALLOWED_IP="$1"

echo "=== Installing UFW ==="
apt-get install -y ufw

echo ""
echo "=== Resetting UFW to clean state ==="
ufw --force reset

echo ""
echo "=== Setting default policies ==="
ufw default deny incoming
ufw default allow outgoing
echo "Default: deny all incoming, allow all outgoing."

echo ""
echo "=== Rule 1: Allow SSH only from $SSH_ALLOWED_IP ==="
ufw allow from "$SSH_ALLOWED_IP" to any port 22 proto tcp
echo "SSH access permitted from $SSH_ALLOWED_IP only."

echo ""
echo "=== Rule 2: Allow HTTP (port 80) from anywhere ==="
ufw allow 80/tcp
echo "HTTP access allowed."

echo ""
echo "=== Rule 3: Allow port 8000 (Docker web app) from anywhere ==="
ufw allow 8000/tcp
echo "Port 8000 allowed."

echo ""
echo "=== Enabling UFW ==="
ufw --force enable

echo ""
echo "=== Current UFW Status ==="
ufw status verbose

echo ""
echo "=== Firewall configuration complete! ==="
echo "SSH is restricted to: $SSH_ALLOWED_IP"
echo "HTTP (80) and app port (8000) are open."

# Task 5: Firewall Configuration with UFW

## Objective
Install and configure UFW (Uncomplicated Firewall) to:
- Allow SSH **only from a specific IP address**
- Allow HTTP traffic (port 80)
- Allow traffic on port 8000 (Docker web app)
- Deny all other incoming traffic by default

---

## Files
| File | Description |
|---|---|
| `firewall_setup.sh` | Automated script to configure all UFW rules |

---

## Steps

### 1. Install UFW
```bash
sudo apt update
sudo apt install -y ufw
```

Verify installation:
```bash
ufw --version
```

---

### 2. Set Default Policies
Deny all incoming and allow all outgoing traffic by default:
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

This ensures that only explicitly allowed ports are accessible.

---

### 3. Allow SSH Only from a Specific IP
Replace `192.168.1.50` with your actual trusted IP address:
```bash
sudo ufw allow from 192.168.1.50 to any port 22 proto tcp
```

> ⚠️ **Important**: Set this rule BEFORE enabling UFW. If you forget and enable UFW first without this rule, you will lose SSH access to the server.

---

### 4. Allow HTTP Access (Port 80)
```bash
sudo ufw allow 80/tcp
```

---

### 5. Allow Port 8000 (Docker Web App)
```bash
sudo ufw allow 8000/tcp
```

---

### 6. Enable the Firewall
```bash
sudo ufw enable
```

Type `y` when prompted to confirm.

---

### 7. Verify the Configuration
```bash
sudo ufw status verbose
```

Expected output:
```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    192.168.1.50
80/tcp                     ALLOW IN    Anywhere
8000/tcp                   ALLOW IN    Anywhere
80/tcp (v6)                ALLOW IN    Anywhere (v6)
8000/tcp (v6)              ALLOW IN    Anywhere (v6)
```

---

### 8. Test the Rules

**Test SSH (from allowed IP):**
```bash
# From 192.168.1.50 — should succeed
ssh devops@<server-ip>
```

**Test SSH (from a different IP):**
```bash
# From any other machine — should time out or be refused
ssh devops@<server-ip>
```

**Test HTTP:**
```bash
curl http://<server-ip>:80
```

**Test port 8000:**
```bash
curl http://<server-ip>:8000
```

---

## Using the Setup Script
To apply all rules automatically:
```bash
sudo bash firewall_setup.sh 192.168.1.50
```

Replace `192.168.1.50` with your trusted SSH IP address.

---

## Additional UFW Commands Reference
```bash
# View rules with numbers
sudo ufw status numbered

# Delete a specific rule by number
sudo ufw delete <rule-number>

# Disable firewall temporarily
sudo ufw disable

# Reset all rules
sudo ufw reset

# Allow a specific IP to access everything
sudo ufw allow from 192.168.1.50

# Block a specific IP
sudo ufw deny from 10.0.0.5
```

---

## Expected Outcome
- UFW enabled with default deny-incoming policy
- SSH access restricted to one specific IP
- HTTP (port 80) and app port 8000 accessible from anywhere
- All other ports blocked

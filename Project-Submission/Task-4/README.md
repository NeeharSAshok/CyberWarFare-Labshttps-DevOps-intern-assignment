# Task 4: Secure Monitoring Logs with Dedicated User

## Objective
Create a dedicated `monitor` user, set up the monitoring directory at `/opt/container-monitor`, assign ownership to that user, grant full access to the monitor user, and restrict all other users from accessing it.

---

## Files
| File | Description |
|---|---|
| `setup_monitor_user.sh` | Script to create user, directory, and set permissions |
| `verify_permissions.sh` | Script to verify access control is working correctly |

---

## Steps

### 1. Create the Dedicated Monitoring User
```bash
sudo useradd --system --no-create-home --shell /usr/sbin/nologin monitor
```

Flags explained:
- `--system` — Creates a system account (no home directory by default, lower UID range)
- `--no-create-home` — No home directory needed
- `--shell /usr/sbin/nologin` — Prevents interactive login for security

Verify the user was created:
```bash
id monitor
getent passwd monitor
```

---

### 2. Create the Monitoring Directory
```bash
sudo mkdir -p /opt/container-monitor/logs
```

---

### 3. Assign Ownership to the Monitor User
```bash
sudo chown -R monitor:monitor /opt/container-monitor
```

The `-R` flag applies ownership recursively to all subdirectories and files.

---

### 4. Set Permissions — Full Access for Monitor, None for Others
```bash
sudo chmod 700 /opt/container-monitor
sudo chmod 700 /opt/container-monitor/logs
```

Permission breakdown:
| Who | Permission | Meaning |
|---|---|---|
| Owner (monitor) | `7` (rwx) | Read, write, execute |
| Group | `0` (---) | No access |
| Others | `0` (---) | No access |

---

### 5. Grant Monitor User Docker Access (for stats script)
Since the monitor user needs to run `docker` commands, add a targeted sudoers rule:
```bash
sudo visudo -f /etc/sudoers.d/monitor-docker
```

Add this content:
```
monitor ALL=(ALL) NOPASSWD: /usr/bin/docker stats *, /usr/bin/docker inspect *
```

Save and exit. This allows the monitor user to run only the specific docker commands needed — no full sudo.

---

### 6. Update the Monitor Script to Run as Monitor User
Update the cron job to execute as the monitor user:
```bash
sudo crontab -u monitor -e
```

Add:
```cron
* * * * * /opt/container-monitor/monitor.sh
```

Also update the script itself so it runs as the monitor user. If you set up the cron under the monitor user, no sudo is needed.

---

### 7. Verify Access Control
Run the verification script:
```bash
sudo bash /home/devops/Project-Submission/Task-4/verify_permissions.sh
```

Or verify manually:

**Check ownership and permissions:**
```bash
ls -ld /opt/container-monitor
ls -ld /opt/container-monitor/logs
```

Expected output:
```
drwx------ 3 monitor monitor 4096 Nov  1 14:00 /opt/container-monitor
drwx------ 2 monitor monitor 4096 Nov  1 14:00 /opt/container-monitor/logs
```

**Verify monitor user can write:**
```bash
sudo -u monitor touch /opt/container-monitor/logs/test.tmp && echo "Access OK" && sudo -u monitor rm /opt/container-monitor/logs/test.tmp
```

**Verify other users cannot access:**
```bash
sudo -u devops ls /opt/container-monitor
# Expected: Permission denied
```

---

## Expected Outcome
- `monitor` system user created
- `/opt/container-monitor` owned by `monitor:monitor`
- Permissions `700` — only the `monitor` user has access
- Other users (including `devops`) get `Permission denied`
- Cron job runs monitoring script as the `monitor` user

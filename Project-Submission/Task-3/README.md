# Task 3: Container Resource Monitoring with Cron Automation

## Objective
Create a monitoring script that captures CPU and memory usage of the running Docker container with timestamps, stores logs in `/opt/container-monitor/logs/`, and automates execution every minute via cron.

---

## Files
| File | Description |
|---|---|
| `monitor.sh` | Bash script that captures container stats and logs them |

---

## Steps

### 1. Create the Monitoring Directory
```bash
sudo mkdir -p /opt/container-monitor/logs
```

### 2. Deploy the Monitoring Script
Copy the script to a system location:
```bash
sudo cp monitor.sh /opt/container-monitor/monitor.sh
sudo chmod +x /opt/container-monitor/monitor.sh
```

---

### 3. Test the Script Manually
```bash
sudo /opt/container-monitor/monitor.sh
```

Check the log was created:
```bash
ls /opt/container-monitor/logs/
cat /opt/container-monitor/logs/monitor_$(date +%Y-%m-%d).log
```

Expected log output:
```
[2024-11-01 14:32:01] CONTAINER: my-webapp | CPU: 0.02% | MEM: 3.45MiB / 1.944GiB (0.17%)
[2024-11-01 14:33:01] CONTAINER: my-webapp | CPU: 0.01% | MEM: 3.47MiB / 1.944GiB (0.17%)
```

---

### 4. Set Up the Cron Job
Open the crontab editor (as root, since logs go to `/opt/`):
```bash
sudo crontab -e
```

Add this line at the bottom:
```cron
* * * * * /opt/container-monitor/monitor.sh
```

Save and exit (Ctrl+O, Enter, Ctrl+X in nano).

Verify the cron job was saved:
```bash
sudo crontab -l
```

---

### 5. Verify Automation is Working
Wait a minute or two, then check the log file:
```bash
cat /opt/container-monitor/logs/monitor_$(date +%Y-%m-%d).log
```

You should see new entries appearing every minute with incrementing timestamps.

You can also watch logs in real-time:
```bash
tail -f /opt/container-monitor/logs/monitor_$(date +%Y-%m-%d).log
```

---

## Script Details

### How It Works
1. Checks if the container (`my-webapp`) is running
2. Runs `docker stats --no-stream` to get a single snapshot of resource usage
3. Parses CPU percentage, memory usage (used/total), and memory percentage
4. Appends a timestamped log line to `/opt/container-monitor/logs/monitor_YYYY-MM-DD.log`
5. Creates a new log file per day (automatic log rotation by date)

### Log Format
```
[YYYY-MM-DD HH:MM:SS] CONTAINER: <name> | CPU: <cpu%> | MEM: <used> / <total> (<mem%>)
```

### Error Handling
- If the container is not running, logs a `WARNING` message
- If stats cannot be retrieved, logs an `ERROR` message

---

## Expected Outcome
- `/opt/container-monitor/logs/` contains daily log files
- Logs update automatically every minute
- Each entry has a timestamp, CPU usage, and memory usage

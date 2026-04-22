# DevOps Internship Assignment — Project Submission

## Overview
This repository contains the complete solution for the DevOps Intern assignment. It covers secure server setup, containerized application deployment, automated monitoring, access control, and firewall configuration.

---

## Repository Structure
```
Project-Submission/
├── Task-1/
│   ├── README.md               # SSH setup and key-based auth guide
│   └── sshd_config_snippet     # Key SSH daemon configuration directives
├── Task-2/
│   ├── README.md               # Docker install and container deployment guide
│   ├── Dockerfile              # Docker image definition (nginx + custom page)
│   └── index.html              # Custom web page served on port 8000
├── Task-3/
│   ├── README.md               # Monitoring script setup and cron guide
│   └── monitor.sh              # Bash script to log container CPU/memory
├── Task-4/
│   ├── README.md               # User creation and permission setup guide
│   ├── setup_monitor_user.sh   # Script to create user and set permissions
│   └── verify_permissions.sh  # Script to verify access control
├── Task-5/
│   ├── README.md               # UFW firewall configuration guide
│   └── firewall_setup.sh       # Automated UFW rule setup script
└── README.md                   # This file
```

---

## Task Summary

| Task | Description | Key Outcome |
|------|-------------|-------------|
| **Task 1** | SSH key-based authentication | Passwordless secure server access |
| **Task 2** | Docker + web app deployment | App accessible at `http://<ip>:8000` |
| **Task 3** | Container monitoring + cron | Auto CPU/memory logs every minute |
| **Task 4** | Dedicated monitor user + permissions | Logs secured with `700` access control |
| **Task 5** | UFW firewall rules | SSH restricted; ports 80 & 8000 open |

---

## Quick Start Guide

### Prerequisites
- Ubuntu 22.04 LTS server (VM or cloud instance)
- `sudo` access on the server
- SSH client on your local machine

### Execution Order
Follow tasks in order since each builds on the previous:

```
Task 1 → Task 2 → Task 3 → Task 4 → Task 5
```

---

## Task 1 — SSH Key Authentication
```bash
# On local machine
ssh-keygen -t ed25519 -C "devops-intern" -f ~/.ssh/devops_key
ssh-copy-id -i ~/.ssh/devops_key.pub devops@<server-ip>

# On server — disable password auth
sudo nano /etc/ssh/sshd_config
# Set: PasswordAuthentication no
sudo systemctl restart ssh
```

---

## Task 2 — Docker Web App
```bash
# Install Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Build and run
cd Task-2/
docker build -t webapp:v1 .
docker run -d --name my-webapp -p 8000:8000 webapp:v1

# Test
curl http://localhost:8000
```

---

## Task 3 — Container Monitoring
```bash
# Deploy script
sudo mkdir -p /opt/container-monitor/logs
sudo cp Task-3/monitor.sh /opt/container-monitor/monitor.sh
sudo chmod +x /opt/container-monitor/monitor.sh

# Add cron job (every minute)
sudo crontab -e
# Add: * * * * * /opt/container-monitor/monitor.sh

# Watch logs
tail -f /opt/container-monitor/logs/monitor_$(date +%Y-%m-%d).log
```

---

## Task 4 — Access Control
```bash
# Run setup script
sudo bash Task-4/setup_monitor_user.sh

# Verify permissions
sudo bash Task-4/verify_permissions.sh
```

---

## Task 5 — Firewall
```bash
# Run firewall setup (replace IP with your actual SSH IP)
sudo bash Task-5/firewall_setup.sh 192.168.1.50

# Verify
sudo ufw status verbose
```

---

## Technologies Used
- **OS**: Ubuntu 22.04 LTS
- **Container Runtime**: Docker CE
- **Web Server**: nginx:alpine (inside container)
- **Scripting**: Bash
- **Scheduling**: cron
- **Firewall**: UFW (Uncomplicated Firewall)
- **Auth**: OpenSSH with Ed25519 keys

# DevOps Internship Assignment

## Description

This repository presents the complete solution for a DevOps Internship technical 
assignment focused on real-world infrastructure tasks. The project demonstrates 
hands-on experience with Linux server administration, containerized application 
deployment, automated system monitoring, user access control, and network-level 
security configuration.

The assignment is divided into five structured tasks, each contained in its own 
directory with a dedicated README, all relevant configuration files, and automation 
scripts. Every task reflects a core competency expected of a working DevOps engineer 
— from securing remote access and deploying applications inside containers, to 
automating operational workflows and hardening the server against unauthorized access.

### What This Project Covers

**Secure Remote Access** — The server is configured for SSH key-based authentication 
using Ed25519 encryption. Password-based login is fully disabled, ensuring that only 
authorized users with the correct private key can access the system remotely.

**Containerized Web Application** — Docker is installed and used to build a custom 
nginx image that serves a personalized web page. The containerized application is 
deployed and exposed on port 8000, accessible from any browser using the server's 
IP address.

**Automated Container Monitoring** — A bash script captures real-time CPU and memory 
usage from the running Docker container, appending timestamped entries to daily log 
files. The script runs automatically every minute via a cron job, enabling continuous 
monitoring without manual intervention.

**Access Control & Log Security** — A dedicated system user is created solely for 
monitoring operations. The monitoring directory is locked down with strict file 
permissions, granting full access only to the monitor user while denying all others, 
protecting sensitive log data from unauthorized access.

**Firewall Configuration** — UFW is configured with a minimal and secure rule set. 
SSH is restricted to a single trusted IP address, while HTTP and the application 
port 8000 remain accessible. All other incoming traffic is blocked by default.

Each task is fully documented with step-by-step commands, configuration details, 
and the relevant files used — making this repository a clean and reproducible 
reference for foundational DevOps practices.

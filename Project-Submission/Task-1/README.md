# Task 1: Server Setup and SSH Configuration

## Objective
Provision a Linux server (local VM), configure SSH connectivity, and implement passwordless authentication using SSH key-based login.

---

## Prerequisites
- A Linux VM (Ubuntu 22.04 LTS recommended) provisioned via VirtualBox / VMware
- OpenSSH server installed on the VM
- SSH client on your local machine

---

## Steps

### 1. Provision the Linux VM
Install Ubuntu Server 22.04 on VirtualBox or VMware. During setup:
- Set a hostname (e.g., `devops-server`)
- Create a user (e.g., `devops`)
- Enable OpenSSH server during installation

Or install SSH manually after boot:
```bash
sudo apt update && sudo apt install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
```

Verify SSH is running:
```bash
sudo systemctl status ssh
```

Check the VM's IP address:
```bash
ip a
# Note the inet address on eth0 or enp0s3, e.g., 192.168.1.100
```

---

### 2. Generate SSH Key Pair on Local Machine
Run this on your **local machine** (not the server):
```bash
ssh-keygen -t ed25519 -C "devops-intern" -f ~/.ssh/devops_key
```
- This creates `~/.ssh/devops_key` (private key) and `~/.ssh/devops_key.pub` (public key)
- When prompted for a passphrase, press Enter for no passphrase (passwordless)

---

### 3. Copy Public Key to the Server
```bash
ssh-copy-id -i ~/.ssh/devops_key.pub devops@192.168.1.100
```
Enter the user's password when prompted. This appends the public key to `~/.ssh/authorized_keys` on the server.

Alternatively, do it manually:
```bash
# On the server
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# On local machine, copy key content
cat ~/.ssh/devops_key.pub

# Paste the output into the server's authorized_keys
echo "paste-key-here" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

---

### 4. Configure SSH Client (Local Machine)
Add an entry to `~/.ssh/config` for convenience:
```
Host devops-server
    HostName 192.168.1.100
    User devops
    IdentityFile ~/.ssh/devops_key
    IdentitiesOnly yes
```

---

### 5. Disable Password Authentication on the Server (Hardening)
Edit the SSH daemon config:
```bash
sudo nano /etc/ssh/sshd_config
```

Set or confirm these values:
```
PasswordAuthentication no
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
PermitRootLogin no
```

Restart SSH to apply:
```bash
sudo systemctl restart ssh
```

---

### 6. Test Passwordless Login
From your local machine:
```bash
ssh devops-server
# OR
ssh -i ~/.ssh/devops_key devops@192.168.1.100
```

You should log in **without being prompted for a password**.

---

## Expected Outcome
- SSH key pair generated on local machine
- Public key deployed to server's `~/.ssh/authorized_keys`
- Password authentication disabled on the server
- Passwordless SSH login confirmed

---

## Relevant Files
| File | Description |
|---|---|
| `~/.ssh/devops_key` | Private key (local machine, keep secret) |
| `~/.ssh/devops_key.pub` | Public key (copied to server) |
| `/etc/ssh/sshd_config` | SSH daemon configuration on server |
| `~/.ssh/config` | SSH client config for easy access |

# Task 2: Docker Installation and Application Deployment

## Objective
Install Docker, create a Dockerfile to serve a custom `index.html`, build an image, run a container, and expose it on port 8000.

---

## Steps

### 1. Install Docker on the Server
```bash
# Update package index
sudo apt update

# Install dependencies
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Enable and start Docker:
```bash
sudo systemctl enable docker
sudo systemctl start docker
```

Add your user to the docker group (to run docker without sudo):
```bash
sudo usermod -aG docker $USER
newgrp docker
```

Verify installation:
```bash
docker --version
docker run hello-world
```

---

### 2. Create Project Files
Create the working directory:
```bash
mkdir -p ~/webapp && cd ~/webapp
```

Create the `index.html` (see `index.html` in this task folder).

Create the `Dockerfile` (see `Dockerfile` in this task folder).

---

### 3. Build the Docker Image
```bash
cd ~/webapp
docker build -t webapp:v1 .
```

Verify the image was created:
```bash
docker images
```

Expected output:
```
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
webapp       v1        <id>           X seconds ago   ~23MB
```

---

### 4. Run the Container
```bash
docker run -d \
  --name my-webapp \
  -p 8000:8000 \
  --restart unless-stopped \
  webapp:v1
```

Flags:
- `-d` — Run in detached (background) mode
- `--name my-webapp` — Name the container
- `-p 8000:8000` — Map host port 8000 to container port 8000
- `--restart unless-stopped` — Auto-restart on reboot

---

### 5. Verify the Container is Running
```bash
docker ps
```

Expected output:
```
CONTAINER ID   IMAGE      COMMAND                  CREATED        STATUS        PORTS                    NAMES
<id>           webapp:v1  "nginx -g 'daemon of…"   X seconds ago  Up X seconds  0.0.0.0:8000->8000/tcp   my-webapp
```

Test locally:
```bash
curl http://localhost:8000
```

From your local machine browser:
```
http://192.168.1.100:8000
```

---

### 6. Useful Docker Commands
```bash
# View container logs
docker logs my-webapp

# Stop the container
docker stop my-webapp

# Start the container
docker start my-webapp

# Remove the container
docker rm my-webapp

# Remove the image
docker rmi webapp:v1
```

---

## Expected Outcome
- Docker installed and running
- Custom `index.html` served via nginx inside a container
- Application accessible at `http://<server-ip>:8000`

---

## Relevant Files
| File | Description |
|---|---|
| `Dockerfile` | Instructions to build the Docker image |
| `index.html` | Custom webpage served by the container |

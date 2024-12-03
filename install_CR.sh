#!/bin/bash

# Install Containerd
# Add Docker's official GPG key to verify Docker packages
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Create the keyrings directory and download Docker's GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker's repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update Apt package list to include Docker repository
sudo apt-get update

# Install Containerd
sudo apt-get install -y containerd.io

# Post-installation steps (optional, uncomment to create docker group and add user)
# sudo groupadd docker
# sudo usermod -aG docker $USER
# newgrp docker

# Install CNI plugins for Kubernetes networking
VERSION=1.6.1
wget https://github.com/containernetworking/plugins/releases/download/v$VERSION/cni-plugins-linux-amd64-v$VERSION.tgz

# Extract the CNI plugins to the appropriate directory
mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v$VERSION.tgz

# Generate the default containerd configuration file
containerd config default > /etc/containerd/config.toml

# Configure containerd to use the systemd cgroup driver in the containerd configuration file
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Add containerd runtime configuration to crictl.yaml
echo -e "runtime-endpoint: unix:///run/containerd/containerd.sock\nimage-endpoint: unix:///run/containerd/containerd.sock" | sudo tee -a /etc/crictl.yaml

# Create containerd group and add the current user to the containerd group
sudo groupadd containerd
sudo usermod -aG containerd $USER
newgrp containerd

# Restart containerd to apply all configuration changes
sudo systemctl restart containerd

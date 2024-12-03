#!/bin/bash

# Update system packages
apt-get update

# Install required dependencies for Kubernetes (apt-transport-https, ca-certificates, curl, and gpg)
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# If the directory `/etc/apt/keyrings` does not exist, create it before running the curl command
# Uncomment the line below if necessary:
# sudo mkdir -p -m 755 /etc/apt/keyrings

# Add the Kubernetes GPG key for package verification
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add the Kubernetes APT repository to your system's source list (this will overwrite any existing configuration in /etc/apt/sources.list.d/kubernetes.list)
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update the package list again after adding the Kubernetes repository
sudo apt-get update

# Install Kubernetes components (kubelet, kubeadm, kubectl) and mark them on hold to prevent updates
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Enable and start the kubelet service
sudo systemctl enable --now kubelet

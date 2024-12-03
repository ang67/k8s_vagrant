#!/bin/bash

# Disable swap to ensure Kubernetes works properly (as swap is not supported by Kubernetes)
sudo swapoff -a

# Enable the necessary kernel modules for Kubernetes networking
sudo modprobe br_netfilter

# Configure the system to allow IPv4 forwarding (required for Kubernetes networking)
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf

# Configure the system to allow bridge traffic to be processed by iptables (required for Kubernetes networking)
echo "net.bridge.bridge-nf-call-iptables = 1" | sudo tee -a /etc/sysctl.conf

# Apply the sysctl settings to take effect immediately
sudo sysctl -p

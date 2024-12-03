Vagrant.configure("2") do |config|
  # Common configuration for all virtual machines (VMs)
  config.vm.box = "ubuntu/focal64"  # Base box for Ubuntu 20.04 (Focal Fossa)
  
  # Configure VirtualBox provider settings
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"  # Allocate 4 GB of RAM for each VM
    vb.cpus = 2         # Allocate 2 CPUs for each VM
  end

  # Define the Master Node (Control Plane)
  config.vm.define "master" do |master|
    master.vm.hostname = "k8s-master"  # Set the hostname for the master node
    master.vm.network "public_network", ip: "192.168.1.200"  # Set the master node's IP address (update with your actual network IP)
    master.vm.network "forwarded_port", guest: 6443, host: 6443  # Forward port 6443 (Kubernetes API server)
    
    # Provision the master node with necessary scripts
    master.vm.provision "shell", path: "prerequisites.sh"  # Install prerequisites
    master.vm.provision "shell", path: "install_CR.sh"    # Install container runtime (e.g., containerd)
    master.vm.provision "shell", path: "setup_k8s.sh"      # Set up Kubernetes on the master node
  end

  # Define Worker Nodes (2 nodes in this example)
  (1..2).each do |i|
    config.vm.define "worker#{i}" do |worker|
      worker.vm.hostname = "k8s-worker#{i}"  # Set the hostname for each worker node
      worker.vm.network "private_network", ip: "192.168.56.#{10 + i}"  # Set IP for each worker node in the private network
      
      # Provision each worker node with necessary scripts
      worker.vm.provision "shell", path: "prerequisites.sh"  # Install prerequisites
      worker.vm.provision "shell", path: "install_CR.sh"    # Install container runtime
      worker.vm.provision "shell", path: "setup_k8s.sh"      # Set up Kubernetes on the worker node
    end
  end
end


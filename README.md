# K8s_vagrant 🚀

*Estimated reading time: 7 minutes* ⏱️

This Kubernetes cluster is powered by **kubeadm** and managed using **Vagrant** virtual machines. 🎉

## Tools Used 🛠️

- **Kubernetes**: kubeadm
- **Container Runtime**: containerd
- **CNI Plugin**: Calico 🌱

## Architecture 🏗️

- **1 Control Plane Node**: Connected to the public network, accessible from the host 🌍
- **2 Worker Nodes**: Connected to a private network 🔒

## Prerequisites 📋

Before starting, make sure the following are installed:

- **VirtualBox**: [Download and install VirtualBox](https://www.virtualbox.org/) 💻
- **Vagrant**: [Download and install Vagrant](https://www.vagrantup.com/) ⚙️

## Setting Up the Vagrant Environment 🛠️

1. **Initialize the Vagrant environment**:

    ```shell
    vagrant init
    ```

   This will create a `Vagrantfile` in your current directory, which you can edit to define the configuration of your virtual machines.

2. **Start the Vagrant machines**:

    ```shell
    vagrant up
    ```

   This will start and provision your Vagrant virtual machines based on the configuration in the `Vagrantfile`. 🌱

   > You can modify the `Vagrantfile` to suit your needs (e.g., increase worker nodes, customize resources, etc.). 📝

## Setting Up the Cluster with kubeadm ⚡

1. **SSH into the master (control plane) node**:

    ```shell
    vagrant ssh master
    ```

2. **Initialize the Kubernetes control plane node** with the following command:

    ```shell
    sudo kubeadm init --apiserver-advertise-address=192.168.1.200 --pod-network-cidr=192.168.0.0/16
    ```

   > The last output displays useful commands for the next steps. Save it!

3. **Configure `kubectl` for your user** on the control plane node:

    ```shell
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```

4. **Install the Calico CNI plugin**:
    [Quickstart for Calico on Kubernetes](https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart)

    ```shell
    CALICO_VERSION=3.29.1
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v$CALICO_VERSION/manifests/tigera-operator.yaml
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v$CALICO_VERSION/manifests/custom-resources.yaml
    ```

   > You can choose a different CNI plugin if needed.

5. **Verify that Calico is installed correctly** by checking the pods:

    ```shell
    watch kubectl get pods -n calico-system
    ```

6. **Remove the control plane taint** to allow scheduling pods on the control plane node **[Optional]**:

    ```shell
    kubectl taint nodes --all node-role.kubernetes.io/control-plane-
    ```

7. Follow the instructions displayed after running the `kubeadm init` command to configure and join your worker nodes. 📝

## Joining Worker Nodes 🧑‍💻

For each worker node, perform the following steps:

1. **SSH into the worker node** (e.g., `worker1`):

    ```shell
    vagrant ssh worker1
    ```

2. On the worker node, **run the `kubeadm join` command** that was displayed during the `kubeadm init` process on the control plane node:

    ```shell
    sudo kubeadm join <your-kubeadm-join-command>
    ```

Repeat steps 1 and 2 for the remaining worker nodes. 🔄

## Log in to the Master and Access Your Cluster 🎉

Once the nodes are joined, you can log in to the master node and enjoy your Kubernetes setup!

### Accessing Kubernetes from the Host 🖥️

Your cluster is accessible from the host. To manage it using `kubectl` on your host machine, **copy the kubeconfig** from the Vagrant master node and configure it:

1. **Copy the kubeconfig file** from the master node:
   
    ```shell
    vagrant ssh master
    sudo cat /etc/kubernetes/admin.conf
    ```

2. **Set the `KUBECONFIG` environment variable** on your host:

    ```shell
    export KUBECONFIG=/path/to/config
    ```

   > Replace `/path/to/config` with the actual path to the `admin.conf` file you copied.
    ```shell
    $ kubectl get nodes
      NAME          STATUS   ROLES           AGE   VERSION
      k8s-master    Ready    control-plane   20m   v1.31.3
      k8s-worker1   Ready    <none>          12m   v1.31.3
      k8s-worker2   Ready    <none>          11m   v1.31.3
    ```
---

Happy Kuberneting! 🐳🎉

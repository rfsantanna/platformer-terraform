sleep 10
sudo apt update -y

sudo apt install docker.io -y
echo 'deb  http://apt.kubernetes.io/  kubernetes-xenial  main' | sudo tee /etc/apt/sources.list.d/kubernetes.list

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt update -y

sudo apt-get install -y kubeadm=1.20.1-00 kubelet=1.20.1-00 kubectl=1.20.1-00
sudo apt-mark hold kubelet kubeadm kubectl


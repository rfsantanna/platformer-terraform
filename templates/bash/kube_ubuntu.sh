apt update -y

apt install docker.io -y
echo 'deb  http://apt.kubernetes.io/  kubernetes-xenial  main' > /etc/apt/sources.list.d/kubernetes.list

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

apt update -y

apt-get install -y kubeadm=1.20.1-00 kubelet=1.20.1-00 kubectl=1.20.1-00
apt-mark hold kubelet kubeadm kubectl


curl https://docs.projectcalico.org/manifests/calico.yaml -O


cat > kubeadm-config.yaml <<EOF 
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: 1.20.1
controlPlaneEndpoint: "k8scp:6443"
networking:
  podSubnet: 192.168.0.0/16
EOF

kubeadm init --config=kubeadm-config.yaml --upload-certs | tee kubeadm-init.out

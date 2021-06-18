#!/bin/bash

rkeIns() {
    #wget https://github.com/rancher/rke/releases/download/v1.0.14/rke_linux-amd64
    wget --no-check-certificate https://tool.auggieme.top/share/rke1/rke_linux-amd64
    mv rke_linux-amd64  rke
    mv rke /usr/bin/
    chmod +x /usr/bin/rke
    rke --version
}

kubectlIns() {
    #curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
    wget --no-check-certificate https://tool.auggieme.top/share/rke1/kubectl
    chmod +x kubectl
    mv kubectl /usr/bin/
    kubectl version --client
}

rkeIns
kubectlIns
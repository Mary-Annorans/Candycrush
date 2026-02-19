#!/bin/bash
set -e

echo "=== Updating system ==="
sudo apt update

echo "=== Installing base dependencies ==="
sudo apt install -y \
  ca-certificates \
  curl \
  wget \
  gnupg \
  lsb-release \
  unzip

# ------------------------------------------------------------
# Java 17 (Eclipse Temurin)
# ------------------------------------------------------------
echo "=== Installing Java 17 (Temurin) ==="
sudo mkdir -p /etc/apt/keyrings

wget -O- https://packages.adoptium.net/artifactory/api/gpg/key/public \
| sudo tee /etc/apt/keyrings/adoptium.asc > /dev/null

echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(lsb_release -cs) main" \
| sudo tee /etc/apt/sources.list.d/adoptium.list

sudo apt update
sudo apt install -y temurin-17-jdk

# ------------------------------------------------------------
# Trivy
# ------------------------------------------------------------
echo "=== Installing Trivy ==="
sudo mkdir -p /usr/share/keyrings

wget -qO- https://aquasecurity.github.io/trivy-repo/deb/public.key \
| gpg --dearmor \
| sudo tee /usr/share/keyrings/trivy.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -cs) main" \
| sudo tee /etc/apt/sources.list.d/trivy.list

sudo apt update
sudo apt install -y trivy

# ------------------------------------------------------------
# Terraform
# ------------------------------------------------------------
echo "=== Installing Terraform ==="
wget -O- https://apt.releases.hashicorp.com/gpg \
| sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
| sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt install -y terraform

# ------------------------------------------------------------
# kubectl
# ------------------------------------------------------------
echo "=== Installing kubectl ==="
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# ------------------------------------------------------------
# AWS CLI v2
# ------------------------------------------------------------
echo "=== Installing AWS CLI v2 ==="
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

# ------------------------------------------------------------
# Node.js 18 LTS
# ------------------------------------------------------------
echo "=== Installing Node.js 18 LTS ==="
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
| sudo gpg --dearmor -o /usr/share/keyrings/nodesource-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/nodesource-archive-keyring.gpg] https://deb.nodesource.com/node_18.x $(lsb_release -cs) main" \
| sudo tee /etc/apt/sources.list.d/nodesource.list

sudo apt update
sudo apt install -y nodejs

# ------------------------------------------------------------
# Versions check
# ------------------------------------------------------------
echo "=== Installed Versions ==="
java --version
trivy --version
terraform --version
kubectl version --client
aws --version
node -v
npm -v

echo "=== Setup complete ==="

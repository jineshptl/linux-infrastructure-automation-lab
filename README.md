# Linux Infrastructure Automation Lab

Linux lab on an Apple Silicon MacBook using VirtualBox, Ubuntu Server ARM64, Ansible, Terraform, Docker, Prometheus and Grafana.

## 1. Repository setup

```bash
git init
mkdir -p ansible/playbooks terraform scripts monitoring docs/screenshots
git branch -M main
git remote add origin <your-repo-url>
git push -u origin main
```

## 2. VirtualBox network

```bash
VBoxManage hostonlynet add --name=HostNetwork --netmask=255.255.255.0 --lower-ip=192.168.56.1 --upper-ip=192.168.56.199 --enable
```

| Host | IP |
|---|---|
| Mac | 192.168.56.1 |
| app01 | 192.168.56.11 |
| monitor01 | 192.168.56.12 |

## 3. Ubuntu Server ISO (ARM64)

```bash
cd ~/Downloads
curl -LO https://cdimage.ubuntu.com/releases/24.04/release/ubuntu-24.04.4-live-server-arm64.iso
```

## 4. Automation tools (macOS)

```bash
brew install ansible
ansible --version
```

```bash
brew install hashicorp/tap/terraform
terraform --version
```

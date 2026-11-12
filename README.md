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

## 5. Create app01 VM

Open VirtualBox > **New**, then set:

| Setting | Value |
|---|---|
| VM Name | app01 |
| ISO Image | ubuntu-24.04.4-live-server-arm64.iso |
| Unattended install | User Name `jinesh`, Host Name `app01`, Domain `lab.local` |
| Memory | 2048 MB |
| CPUs | 2 |
| Disk | 20 GB |

Click **Finish**. Ubuntu installs automatically (10-20 minutes) and ends at the `app01 login:` prompt.

## 6. Add host-only network to app01

Shut down the VM:

```bash
sudo shutdown now
```

VirtualBox > app01 > **Settings** > **Network** > **Adapter 2**:

| Setting | Value |
|---|---|
| Enable Network Adapter | Yes |
| Attached to | Host-only Network |
| Name | HostNetwork |

Start app01 and check the new interface:

```bash
ip a
```

| Interface | Network | IP |
|---|---|---|
| enp0s8 | NAT (internet) | 10.0.2.15 |
| enp0s9 | HostNetwork | none yet |

## 7. Static IP and SSH for app01

Inside app01, create the network file:

```bash
sudo nano /etc/netplan/60-hostonly.yaml
```

```yaml
network:
  version: 2
  ethernets:
    enp0s9:
      addresses: [<app01-ip>/24]
```

Apply it:

```bash
sudo chmod 600 /etc/netplan/60-hostonly.yaml
sudo netplan apply
ip a show enp0s9
```

Install and start SSH:

```bash
sudo apt update
sudo apt install -y openssh-server
sudo systemctl enable --now ssh
systemctl status ssh
```

From the Mac, connect:

```bash
ping -c 2 <app01-ip>
ssh <username>@<app01-ip>
```

Confirm you are on the right VM:

```bash
hostname
```

Expected output: `app01`

## 8. SSH key login

On the Mac, create a key and copy it to app01:

```bash
ssh-keygen -t ed25519 -C "infrastructure-lab" -f ~/.ssh/id_ed25519 -N ""
ssh-copy-id -i ~/.ssh/id_ed25519.pub <username>@<app01-ip>
```

Log in without a password:

```bash
ssh <username>@<app01-ip>
hostname
```

Expected output: `app01`

## 9. Ansible connection test

Create `ansible/inventory.ini`:

```ini
[app]
app01 ansible_host=<app01-ip>

[all:vars]
ansible_user=<username>
ansible_python_interpreter=/usr/bin/python3
```

Create `ansible/ansible.cfg`:

```ini
[defaults]
inventory = inventory.ini
```

Test:

```bash
cd ansible
ansible all -m ping
```

Expected output: `"ping": "pong"`

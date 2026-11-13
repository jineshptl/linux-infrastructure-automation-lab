# Troubleshooting Log

## 1. Ansible host unreachable

**Symptom:** `ansible all -m ping` returned `UNREACHABLE` for app01 with `Operation timed out`.

**Cause:** The app01 VM was powered off.

**Fix:**

```bash
VBoxManage list runningvms
VBoxManage startvm app01 --type headless
ansible all -m ping
```

## 2. Website down after reboot

**Symptom:** `curl http://<app01-ip>:8080` failed after app01 restarted.

**Cause:** The Nginx container had no restart policy (`restart = "no"`), so it stopped when the VM shut down.

**Fix:** Added `restart = "unless-stopped"` to `terraform/main.tf` and ran `terraform apply`. The container now starts automatically after a reboot.

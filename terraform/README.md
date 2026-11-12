
## 12. Deploy Nginx with Terraform

Create `terraform/main.tf`:

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0"
    }
  }
}

provider "docker" {
  host     = "ssh://<username>@<app01-ip>:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

resource "docker_container" "web" {
  name  = "infrastructure-lab-web"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = 8080
  }
}
```

Deploy:

```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply
```

Type `yes` when asked. Expected: `Apply complete! Resources: 2 added`

Test:

```bash
curl http://<app01-ip>:8080
```

Expected output: `Welcome to nginx!`

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0"
    }
  }
}

provider "docker" {
  host     = "ssh://jinesh@192.168.56.11:22"
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

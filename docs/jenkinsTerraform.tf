terraform {
 required_providers {
  docker = {
   source = "kreuzwerker/docker"
   version = "~>3.0.1"
  }
 }
}

provider "docker" {}

resource "docker_image" "docker:dind" {
 name = "docker:dind"
 keep_locally = false
}

resource "docker_image" "myjenkins-blueocean" {
 name = "myjenkins-blueocean"
 keep_locally = false
}

resource "docker_volume" "my_volume" {
 name = "my_volume"
}

resource "docker_network" "jenkins" {
 name = "jenkins"
}

resource "docker_container" "docker:dind" {
 image = docker_image.docker:dind.image_id
 name = "jenkins-docker"
 privileged = true
 ports {
  internal = 2376
  external = 2376
 }
 volumes {
  volume_name = docker_volume.my_volume.name
  container_path = "/certs/client"
 }
 networks_advanced {
  name = docker_network.jenkins.name
 }
}

resource "docker_container" "myjenkins-blueocean" {
 image = docker_image.docker:dind.image_id
 name = "jenkins-blueocean"
 privileged = true
 ports {
  internal = 8080
  external = 8080
 }
 ports {
  internal = 50000
  external = 50000
 }
 volumes {
  volume_name = docker_volume.my_volume.name
  container_path = "/var/jenkins_home"
 }
 networks_advanced {
  name = docker_network.jenkins.name
 }
}

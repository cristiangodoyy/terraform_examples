variable "path" {default = "/home/cristian/Development/Projects/udemy/terraform/credentials"}

provider "google" {
    project = "directed-galaxy-416514"
    region = "southamerica-west1-a"
    credentials = "${file("${var.path}/secrets.json")}"
}

provider "google-beta" {
    project = "directed-galaxy-416514"
    region = "southamerica-west1-a"
    credentials = "${file("${var.path}/secrets.json")}"
}
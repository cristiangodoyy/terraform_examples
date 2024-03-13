resource "google_compute_instance" "default" {
  count = "${length(var.name_count)}" //sino esta count no podemos crear multiples instancias
  name = "list-${count.index+1}"
  machine_type = "${var.machine_type["dev"]}"
  zone = "southamerica-west1-a"

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"
  }

  service_account {
    scopes = [ "userinfo-email", "compute-ro", "storage-ro" ]
  }
  /* el plan va a retornar lo siguiente para el scope:
  scopes = [
    + "https://www.googleapis.com/auth/compute.readonly",
    + "https://www.googleapis.com/auth/devstorage.read_only",
    + "https://www.googleapis.com/auth/userinfo.email",
  ]
  */
}

// Outputs

/*
Con .*. creamos multiples instancias

Terraform will perform the following actions:

  # google_compute_instance.default[0] will be created
  + resource "google_compute_instance" "default" {
  }

  # google_compute_instance.default[1] will be created
  + resource "google_compute_instance" "default" {
  }

  # google_compute_instance.default[2] will be created
  + resource "google_compute_instance" "default" {
  }
*/
output "machine_type" { value = "${google_compute_instance.default.*.machine_type}"}
output "name" { value = "${google_compute_instance.default.*.name}"}
output "zone" { value = "${google_compute_instance.default.*.zone}"}

output "instance_id" { value = "${join(",",google_compute_instance.default.*.id)}" }
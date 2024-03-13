resource "google_compute_instance" "default" {
  count = "1" //sino esta count no podemos crear multiples instancias
  name = "first-${count.index+1}"
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

  depends_on = [google_compute_instance.second]
}

resource "google_compute_instance" "second" {
  count = "1" //sino esta count no podemos crear multiples instancias
  name = "second-${count.index+1}"
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

output "machine_type_defult" { value = "${google_compute_instance.default.*.machine_type}"}
output "name_defult" { value = "${google_compute_instance.default.*.name}"}
output "zone_defult" { value = "${google_compute_instance.default.*.zone}"}


output "machine_type_second" { value = "${google_compute_instance.second.*.machine_type}"}
output "name_second" { value = "${google_compute_instance.second.*.name}"}
output "zone_second" { value = "${google_compute_instance.second.*.zone}"}
# output "instance_id" { value = "${join(",",google_compute_instance.default.id)}" }
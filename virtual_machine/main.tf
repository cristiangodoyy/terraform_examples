resource "google_compute_instance" "default" {
  count = "${var.machine_count}" //sino esta count no podemos crear multiples instancias
  name = "first-${count.index+1}"
  machine_type = "${var.machine_type["dev"]}"
  zone = "southamerica-west1-a"
  can_ip_forward = "false"
  description = "This is our Virtual Machine"
  tags = ["allow-http", "allow-https"]  # Firewall
  
  labels = {
    name = "first-${count.index+1}"
    machine_type = "${var.machine_type["dev"]}"
  }

  boot_disk {
    initialize_params {
      image = var.image
      size = "20"
    }
  }

  network_interface {
    network = "default"
  }

  metadata = {
    size = "20"
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = [ "userinfo-email", "compute-ro", "storage-ro" ]
  }
}

resource "google_compute_disk" "default" {  // 17. Volumes
  name = "test-disk"
  type = "pd-ssd"
  zone = "southamerica-west1-a"
  size = "10"
}

resource "google_compute_attached_disk" "default" {  // 17. Volumes
  disk = "${google_compute_disk.default.self_link}"
  instance = "${google_compute_instance.default[0].self_link}"
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

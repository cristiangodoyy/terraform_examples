variable "image" {
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "machine_type" {
  type = map(string)
  default = {
    dev = "n2-standard-2"
    prod = "production_box_wont_work"
  }
}

variable "machine_count" {
  default = "1"
}

// Lists, Count & Length
variable "name_count" { default = ["server1", "server2", "server3"] }

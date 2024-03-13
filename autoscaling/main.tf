# Auto scaling has different sort of, techiniques and different components that it needs for it to work

# 1. Instance template > describe instance
# 2. Healt check >  Auto scaling policy (when to scale)
# 3. Group manager > manages the nodes 
# 4. Auto scale policy > How many instances do you require


# 1. Instance template > describe instance
resource "google_compute_instance_template" "instance_template" {
    count = 1
    name = "udemy-server-${count.index+1}"
    description = "This is autoscaling template"

    labels = {
        environment = "production"
        name = "udemy-server-${count.index+1}"
    }

    instance_description = "This is an instance that has been auto scaled"
    machine_type = "n1-standard-1"
    can_ip_forward = "false"
    
    scheduling {
      automatic_restart = true
      on_host_maintenance = "MIGRATE"
    }

    disk {
      source_image = "ubuntu-os-cloud/ubuntu-2204-lts"
      auto_delete = true
      boot = true

    }

    disk {
      auto_delete = false
      disk_size_gb = 10
      mode = "READ_WRITE"
      type = "PERSISTENT"
    }

    network_interface {
      network = "default"
    }

    metadata = {
      foo = "bar"
    }

    service_account {
        scopes = [ "userinfo-email", "compute-ro", "storage-ro" ]
    }
}

# 2. Healt check >  Auto scaling policy (when to scale)
resource "google_compute_health_check" "health" {
    count = 1
    name = "udemy"
    check_interval_sec = 5
    timeout_sec = 5
    healthy_threshold = 2
    unhealthy_threshold = 10

    http2_health_check {
      request_path = "/alive.jsp"
      port = 8080
    }
}

# 3. Group manager > manages the nodes 
resource "google_compute_region_instance_group_manager" "instance_group_manager" {
    name = "instance-group-manager"
    base_instance_name = "instance-group-manager"
    region = "southamerica-west1"

    version {
        instance_template = "${google_compute_instance_template.instance_template[0].self_link}"
    }

    auto_healing_policies {
        health_check      = google_compute_health_check.health[0].self_link
        initial_delay_sec = 300
    }
}

# 4. Auto scale policy > How many instances do you require
resource "google_compute_region_autoscaler" "autoscaler" {
    count = 1
    name = "autoscaler"
    project = "directed-galaxy-416514"
    region = "southamerica-west1"
    target = google_compute_region_instance_group_manager.instance_group_manager.self_link

    autoscaling_policy {
      max_replicas = 2
      min_replicas = 1
      cooldown_period = 60
      
      cpu_utilization {
        target = 0.8
      }
    }
  
}
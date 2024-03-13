resource "google_compute_firewall" "allow_http" {  // 16. Firewalls rules
    name = "allow-http"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["80"]
    }

    source_tags = ["web"]
    target_tags = [ "allow-http" ]
}

resource "google_compute_firewall" "allow_https" {  // 16. Firewalls rules
    name = "allow-https"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["443"]
    }

    source_tags = ["web"]
    target_tags = [ "allow-https" ]
}
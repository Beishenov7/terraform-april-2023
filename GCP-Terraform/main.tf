terraform {
    required_version = ">= 0.12"
}

provider google {
    region = "us-central1"
}

resource "google_project_service" "project" {
  project = "divine-beanbag-393116"
  service   = "compute.googleapis.com"
  lifecycle {
    ignore_changes = [
      disable_dependent_services,
    ]
}
}

resource "google_compute_network" "vpc_network" {
  depends_on = [ google_project_service.project ]
  name = "my-vpc"
  project = "divine-beanbag-393116"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet-1" {
  depends_on = [ google_project_service.project ]
  name          = "subnet-1"
  ip_cidr_range = "10.1.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_subnetwork" "subnet-2" {
  depends_on = [ google_project_service.project ]
  name          = "subnet-2"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
}


resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = google_compute_network.vpc_network.name
  
  destination_ranges = [ "0.0.0.0/0" ]
  source_ranges = [ "0.0.0.0/0" ]

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet-1.name

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = file("wordpress.sh")
}
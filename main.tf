provider "google" {
    credentials = file(mygcp-creds.json) #Yur service-key file
    project = "Your project ID"
    zone = "northamerica-northeast1-a"
}

resource "google_compute_instance" "terraform_test2" {
  name = "terraform-gcp-2"
  mashine_type = "e2-small"
  boot_disk {
    initialize_params {
        image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "default"
  }
}
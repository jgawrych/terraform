// Configure the Google Cloud provider
provider "google" {
 credentials = file("idyllic-silo-272016-c4607b0af2b8.json")
 project     = "idyllic-silo-272016"
 region      = "northamerica-northeast1"
}
// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}
// A single Compute Engine instance and added ssh access
resource "google_compute_instance" "default" {
 name         = "testing-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "northamerica-northeast1-a"
 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }
 metadata = {
   ssh-keys = "jason_gawrych:${file("~/.ssh/[my-ssh-key].pub")}"
}
// Make sure flask is installed on all new instances for later steps
 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip in$
 network_interface {
   network = "default"
   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}

// A variable for extracting the external IP address of the instance
output "ip" {
 value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip

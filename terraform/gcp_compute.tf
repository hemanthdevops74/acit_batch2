/*
 * Copyright 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


/*
 * Terraform compute resources for GCP.
 * Acquire all zones and choose one randomly.
 */

data "google_compute_zones" "available" {
  region = "${var.gcp_region}"
}

resource "google_compute_address" "gcp-ip" {
  name = "gcp-vm-ip-${var.gcp_region}"
  region = "${var.gcp_region}"
}

resource "google_compute_instance" "gcp-vm1" {
  name         = "gcp-vm1-${var.gcp_region}"
  machine_type = "${var.gcp_instance_type}"
  zone         = "${data.google_compute_zones.available.names[0]}"

  boot_disk {
    initialize_params {
      image = "${var.gcp_disk_image}"
    }
  }

  scheduling {
      automatic_restart = false
      preemptible = true
  }

  tags=["gcp-vm1"]

  network_interface {
    subnetwork = "${google_compute_subnetwork.gcp-subnet1.name}"
    network_ip = "${var.gcp_vm1_address}"

  

    access_config {
      # Static IP
      #nat_ip = "${google_compute_address.gcp-ip.address}"
    }
  }
}



resource "google_compute_instance" "gcp-vm2" {
  name         = "gcp-vm2-${var.gcp_region}"
  machine_type = "${var.gcp_instance_type}"
  zone         = "${data.google_compute_zones.available.names[0]}"

  boot_disk {
    initialize_params {
      image = "${var.gcp_disk_image}"
    }
  }

  scheduling {
      automatic_restart = false
      preemptible = true
  }

  tags=["gcp-vm2"]

  network_interface {
    subnetwork = "${google_compute_subnetwork.gcp-subnet1.name}"
    network_ip = "${var.gcp_vm2_address}"

  
    access_config {
      # Static IP
      #nat_ip = "${google_compute_address.gcp-ip.address}"
    }
  }
}



  resource "google_compute_instance" "gcp-vm3" {
  name         = "gcp-vm3-${var.gcp_region}"
  machine_type = "${var.gcp_instance_type}"
  zone         = "${data.google_compute_zones.available.names[0]}"

  boot_disk {
    initialize_params {
      image = "${var.gcp_disk_image}"
    }
  }

  scheduling {
      automatic_restart = false
      preemptible = true
  }

  tags=["gcp-vm3"]
  network_interface {
    subnetwork = "${google_compute_subnetwork.gcp-subnet2.name}"
    network_ip = "${var.gcp_vm3_address}"

  
    access_config {
      # Static IP
      #nat_ip = "${google_compute_address.gcp-ip.address}"
    }
  }
  }



  resource "google_compute_instance" "gcp-vm4" {
  name         = "gcp-vm4-${var.gcp_region}"
  machine_type = "${var.gcp_instance_type}"
  zone         = "${data.google_compute_zones.available.names[0]}"

  boot_disk {
    initialize_params {
      image = "${var.gcp_disk_image}"
    }
  }
  scheduling {
      automatic_restart = false
      preemptible = true
  }

  tags=["gcp-vm4"]
  network_interface {
    subnetwork = "${google_compute_subnetwork.gcp-subnet3.name}"
    network_ip = "${var.gcp_vm4_address}"

  
    access_config {
      # Static IP
      #nat_ip = "${google_compute_address.gcp-ip.address}"
    }
  }
  
  # metadata_startup_script = "${replace("${replace("${file("vm_userdata.sh")}", "<EXT_IP>", "${aws_eip.aws-ip.public_ip}")}", "<INT_IP>", "${var.aws_vm_address}")}"
  }

output "gcp_vm1_ip" {
  description = "The private IP address of GCP VM1"
  value       = google_compute_instance.gcp-vm1.network_interface[0].network_ip
}

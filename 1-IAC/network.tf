# Creating a VPC
resource "google_compute_network" "i27-ecommerce-vpc" {
  name = var.vpc_name # the name of the vpc created in google cloud
  auto_create_subnetworks = false 
}

# Create Multiple Subnets 
resource "google_compute_subnetwork" "i27-ecommerce-subnets" {
  count = length(var.subnets)
  name = var.subnets[count.index].name
  ip_cidr_range = var.subnets[count.index].ip_cidr_range
  region = var.subnets[count.index].subnet_region
  network = google_compute_network.i27-ecommerce-vpc.self_link
}

# resource "google_compute_subnetwork" "bout-subnet-1" {
#   name = "subnet-1"
#   network = google_compute_network.i27-ecommerce-vpc.id
#   region = "us-central1"
#   ip_cidr_range = "10.5.0.0/16"
# }

# resource "google_compute_subnetwork" "bout-subnet-2" {
#   name = "subnet-2"
#   network = google_compute_network.i27-ecommerce-vpc.id
#   region = "us-central1"
#   ip_cidr_range = "10.6.0.0/16"
# }


# Create Firewalls 
# port numbers: 22, 8080, 9000, 80
# allow/deny,
# protocols
# source_ranges
resource "google_compute_firewall" "i27-ecommerce-fw" {
  name = "i27-allow-ssh-http-jenkins-ports"
  network = google_compute_network.i27-ecommerce-vpc.name
  dynamic "allow" {
    for_each = var.ports
    content {
      protocol = "tcp"
      ports = [allow.value]
    }
  }
  source_ranges = var.source_ranges
}



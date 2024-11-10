# Create multiple VM's 
# Jenkinsmaster, slave , sonar, docker.
# Install inital packages using Provisoners 

# Generate an SSH Keypair
resource "tls_private_key" "i27-ecommerce-key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

# Save the Private Key to local file
resource "local_file" "i27-ecommerce-key" {
    content = tls_private_key.i27-ecommerce-key.private_key_pem
  filename = "${path.module}/id_rsa"
}

# Save the Public key to local file 
resource "local_file" "i27-ecommerce-key-pub" {
  content = tls_private_key.i27-ecommerce-key.public_key_openssh
  filename = "${path.module}/id_rsa.pub"
}

# Create Multiple Instances of GCE for our i27 Infra
resource "google_compute_instance" "tf-vm-instance" {
  for_each = var.instances #each.key and each.value
  name = each.key
  machine_type = each.value.instance_type
  zone = each.value.zone
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_image.self_link
      size = 10
      type = "pd-standard"
    }
  }
    # network Interface block
  network_interface {
    network = google_compute_network.i27-ecommerce-vpc.name
    subnetwork = each.value.subnet
    access_config {
      // Ephemral IP 
    }
  }

  # Metadata for the instance to have the ssh key
  # public key to be stroed in the respective vms
  metadata = {
    ssh-keys = "${var.vm_user}:${tls_private_key.i27-ecommerce-key.public_key_openssh}"
  }
  
  # Connection Block to connect to the instances
  connection {
    host = self.network_interface[0].access_config[0].nat_ip
    type = "ssh"
    user = var.vm_user
    private_key = tls_private_key.i27-ecommerce-key.private_key_pem
    # sshk-keygen -t rsa -f location -C admin_
  }

  # Provisioner block to copy local file to remote machines
  provisioner "file" {
    # here, each.key will be the gce vm name, in our case it can be ansible, jenkins-master, etc
    source =  each.key == "ansible" ? "ansible.sh" : "empty.sh"  # ansible.sh
    destination = each.key == "ansible" ? "/home/${var.vm_user}/ansible.sh" : "/home/${var.vm_user}/empty.sh"
  }

  # Provisioner block to execute on the remote machine
  provisioner "remote-exec" {
    inline = [ 
        each.key == "ansible" ? "chmod +x /home/${var.vm_user}/ansible.sh && /home/${var.vm_user}/ansible.sh" : "echo 'Not an Ansible Instance'"
     ]
  }

  provisioner "file" {
    #source = tls_private_key.i27-ecommerce-key.private_key_pem
    source = "${path.module}/id_rsa"
    destination = "/home/${var.vm_user}/ssh-key"
  }


}


# Data Block for image
data "google_compute_image" "ubuntu_image" {
  family  = "ubuntu-2004-lts"
  project = "ubuntu-os-cloud"
}
# Display outputs of all the infra created 

output "instance_ips" {
  value = {
    for instance in google_compute_instance.tf-vm-instance :
    instance.name => {
        public_ip = instance.network_interface.0.access_config[0].nat_ip 
        private_ip = instance.network_interface[0].network_ip
    }
  }
}


# Public ip of ansible
output "ansible_instance_public_ip" {
  value = google_compute_instance.tf-vm-instance["ansible"].network_interface.0.access_config[0].nat_ip 
}

# Private ip of ansible
output "ansible_instance_private_ip" {
  value = google_compute_instance.tf-vm-instance["ansible"].network_interface[0].network_ip
}

# Public ip of jenkins-master
output "jenkins_instance_public_ip" {
  value = google_compute_instance.tf-vm-instance["jenkins-master"].network_interface.0.access_config[0].nat_ip 
}

# private ip of jenkins-master
output "jenkins_instance_private_ip" {
  value = google_compute_instance.tf-vm-instance["ansible"].network_interface[0].network_ip
}

# Output to provide ssh command for beter readability

# ssh -i id_rsa admin_@publicicofansible

output "ansible_ssh_command" {
  value = "To connect to ansible, use this command: ssh -i id_rsa ${var.vm_user}@${google_compute_instance.tf-vm-instance["ansible"].network_interface.0.access_config[0].nat_ip}"
}

output "jenkins_ssh_command" {
  value = "To connect to Jenkins Master, use this command: ssh -i id_rsa ${var.vm_user}@${google_compute_instance.tf-vm-instance["jenkins-master"].network_interface.0.access_config[0].nat_ip}"
}
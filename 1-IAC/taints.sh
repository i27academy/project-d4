for instance in $(terraform state list | grep -i 'google_compute_instance.tf-vm-instance'); do
  terraform taint $instance
done
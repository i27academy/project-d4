# Passing values to the varaibles


# Jenkins-Master, ansible, Jenkins-slave 
# Sonarqube 
# GKE

project_id = "future-depth-439107-m2"

vpc_name = "i27-ecommerce-vpc"

subnets = [ 
    {
        name = "i27-ecommerce-central-subnet"
        ip_cidr_range = "10.1.0.0/16"
        subnet_region = "us-central1"
    },
    {
        name = "i27-ecommerce-east-subnet"
        ip_cidr_range = "10.2.0.0/16"
        subnet_region = "us-east1"
    }
]

source_ranges = [ "0.0.0.0/0", "136.185.218.250/32" ]

ports = [ 80, 443, 22, 8080, 9000, 5761, 6761, 7761, 8761 ]


instances = {
    "ansible" = {
        instance_type = "e2-medium"
        zone = "us-central1-a"
        subnet = "i27-ecommerce-central-subnet"
    },
    "jenkins-master" = {
        instance_type = "e2-medium"
        zone = "us-east1-b"
        subnet = "i27-ecommerce-east-subnet"
    },
    "jenkins-slave" = {
        instance_type = "e2-medium"
        zone = "us-east1-b"
        subnet = "i27-ecommerce-east-subnet"
    },
    "sonarqube" = {
        instance_type = "e2-medium"
        zone = "us-central1-a"
        subnet = "i27-ecommerce-central-subnet"
    },
    "dockerserver" = {
        instance_type = "e2-medium"
        zone = "us-east1-b"
        subnet = "i27-ecommerce-east-subnet"
    }
}


vm_user = "krish"

node_count = 1
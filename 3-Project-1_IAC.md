
# Project 1: Infrastructure as Code (IaC) for i27 Ecommerce Project 🚀

## Overview 📚
This is the **first step** in the **i27 Ecommerce project**. Before we begin deploying our microservices and implementing CI/CD pipelines, we’ll need to create the necessary infrastructure. In this project, we use **Terraform** to automate the setup of **Google Cloud Platform (GCP)** resources required for the i27 Ecommerce platform.

This project lays the **foundation** for all future deployments, allowing us to create a **scalable** and **secure** infrastructure for our ecommerce application. By the end of this project, you’ll have a fully automated, production-grade environment ready for the next steps in the ecommerce journey.

---

## Why This Step is Crucial for the i27 Ecommerce Project ⚙️:
1. **Automated and Reusable**: 🚀 By automating the entire infrastructure setup with **Terraform**, we ensure **consistency**, **scalability**, and the ability to recreate environments easily (for staging, production, etc.).
2. **Real-World Application**: 📚 The infrastructure we’re building reflects the requirements of a real-world ecommerce application, including high availability, security, and scalability.
3. **Foundation for Microservices**: This project sets up the **networking**, **compute instances**, and **database** required for hosting the ecommerce microservices. Future steps will build on this foundation to deploy and manage our applications.

---

## Project Goals for i27 Ecommerce 🎯
In this project, you will:
- Create a custom **VPC** to secure and isolate your ecommerce services.
- Configure **subnets** to host different services like **Jenkins**, **SonarQube**, and **Docker**.
- Set up **firewall rules** to allow secure access to services over specific ports.
- Provision **Compute Engine instances** that will host critical services like Jenkins and Docker.
- Create a **Cloud SQL database** for storing application data.
- Set up a **Kubernetes cluster (GKE)** to host containerized versions of our microservices.

---

## Concepts Covered in This Terraform Project 🌍

### 1. VPC and Subnet Creation for Ecommerce 🛠️:
- **Custom VPC**: 🌐 We’ll create a dedicated **VPC** for the ecommerce platform, ensuring all services are isolated from external traffic.
- **Subnets**: Different services require different levels of access and security. For example:
  - A **general subnet** will host services like **Jenkins** and **Docker**.
  - A dedicated **subnet for SonarQube** ensures network isolation for our code quality service.

### 2. Firewall Rules 🔐:
- **Dynamic Port Configuration**: We’ll configure firewall rules to allow secure traffic for services like **SSH**, **HTTP**, and **SonarQube**.
- **Secure Access**: By controlling which ports are open and which IP ranges are allowed, we’ll secure our infrastructure from unauthorized access.

### 3. SSH Key Management 🔑:
- **Secure VM Access**: 🚀 We will dynamically generate **SSH keys** using Terraform’s **TLS provider** to securely manage access to the VMs.

### 4. Provisioning Compute Instances for the i27 Ecommerce Platform 🖥️:
- **Jenkins Master and Slave Instances**: Terraform will provision dedicated instances for **Jenkins**.
- **SonarQube Instance**: SonarQube will run on its own instance and subnet.
- **Ansible and Docker Instances**: Additional VMs will be created to host **Ansible** and **Docker**.

### 5. Cloud SQL Database 🗄️:
- **Managed MySQL Database**: A **Cloud SQL instance** will be created for storing backend data.

### 6. Google Kubernetes Engine (GKE) 🛡️:
- **Kubernetes Cluster Setup**: Terraform will provision a **GKE cluster** to host containerized microservices.

### 7. Infrastructure Outputs 📝:
- We will output key information such as the **public and private IP addresses** of the VMs.

---

## Resources Provisioned in This Project 💻

1. **VPC**: A custom VPC that isolates ecommerce traffic.
2. **Subnets**:
   - General subnet for **Jenkins** and **Docker**.
   - Dedicated subnet for **SonarQube**.
3. **Firewall Rules**:
   - Allowing traffic on essential ports (HTTP, SSH, Jenkins, SonarQube).
4. **Compute Engine Instances**:
   - VMs for **Jenkins**, **SonarQube**, **Docker**, and **Ansible**.
5. **Cloud SQL Database**:
   - A managed **Cloud SQL (MySQL)** instance.
6. **Kubernetes Cluster (GKE)**:
   - A Kubernetes cluster for deploying microservices.

---

## Complexity Implemented in the i27 Ecommerce Infrastructure 🌟:

- **Conditional Logic**: 🚦 Terraform’s **conditional logic** applies different configurations for each service.
- **Dynamic Blocks**: 📦 Used to configure firewall rules for each service.
- **SSH Key Management**: Leveraging Terraform’s **TLS provider** for secure SSH access.
- **Provisioners**: 🔄 **Terraform provisioners** automatically configure VMs with services like Jenkins, Docker, and Ansible.
- **GKE and Cloud SQL**: Provisioning **Kubernetes clusters** and **Cloud SQL databases** for scalable, reliable applications.

---

## Learning Outcomes 🏆:
By the end of this project, you will:
- Understand how to provision and manage infrastructure using **Terraform**.
- Automate instance setup using **Terraform provisioners** and **Ansible**.
- Create and secure a **Cloud SQL database** for backend services.
- Set up a **GKE cluster** to host microservices.

---

## Next Step: Project 2 - Ansible Configuration Management with Playbooks 🛠️

In **Project 2**, we will configure our provisioned infrastructure using **Ansible playbooks**. This will allow us to automate the installation and setup of critical software like **Jenkins**, **SonarQube**, and **Docker** on our VMs. We will also learn how to manage configurations across multiple environments, ensuring consistency and scalability.

Stay tuned for **Project 2** where we’ll dive into configuration management using **Ansible**!


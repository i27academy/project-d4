
# Company Flow: Gathering Requirements for DevOps Implementation

## Company Overview: i27Academy
i27Academy is a consulting company specializing in cloud and DevOps solutions. Currently, the company is managing three major projects:
1. **I27 Ecommerce**
2. **I27 Banking**
3. **I27 Education**

The **I27 Ecommerce** project is the top priority, with other projects scheduled to start later. The DevOps team is responsible for setting up scalable, automated infrastructure and ensuring smooth deployments for **I27 Ecommerce**.

## Scenario: DevOps Team Engagement
The newly formed DevOps team is tasked with implementing end-to-end automation for the **I27 Ecommerce** project. During the initial meeting with stakeholders (business owners, architects, product managers, developers, and the DevOps team), the following key goals and requirements were established:

1. **Business Objective**: Deploy the Ecommerce platform within one month to meet a tight market deadline.
2. **Infrastructure**: The platform will be hosted on **Google Cloud Platform (GCP)**, but the company will also utilize **AWS** in the future. Infrastructure must be provisioned using **Terraform** as the Infrastructure as Code (IaC) tool.
3. **Tech Stack**: 
   - **Frontend**: React
   - **Backend**: Java Spring Boot microservices
   - **Database**: MySQL, hosted on **Cloud SQL** (GCP’s managed MySQL service), which is part of the Terraform-managed infrastructure.

4. **DevOps Implementation**: 
   - The infrastructure and application must be automated, scalable, and deployed using **CI/CD pipelines**.
   - A separate repository will be maintained for **infrastructure** and **Ansible** code, with **MySQL (Cloud SQL)** provisioned through IaC only, excluding Ansible from database management.

---

## Phase 1: Requirements Gathering

In the first phase, the DevOps team held a meeting with all relevant stakeholders to discuss the technical needs for the **I27 Ecommerce** project.

### Key Takeaways:
1. **Cloud Platform**: 
   - Initially, **GCP** will be the chosen platform for this project, though **AWS** will be used in future projects.
   - Infrastructure setup will be done using **Terraform** to manage resources like Jenkins, SonarQube, Docker, Kubernetes and Cloud SQL etc.

2. **Configuration Management**: 
   - All software, dependencies, and configurations (except MySQL) will be managed using **Ansible**.
   - **Ansible** will configure Jenkins master and slave instances, SonarQube, and Docker using Playbooks.

3. **Repository Management**: 
   - **GitHub** will be used for version control.
   - Repositories will be split between **application source code** and **infrastructure/Ansible code**.
   - The **master/main branch** in each repository will be protected to enforce review policies regarding merges and all.

4. **CI/CD Pipelines**:
   - **Jenkins Pipelines** will be used for automating build, test, and deployment processes.
   - **Shared libraries** will be implemented to ensure pipeline reusability across different projects.
   - Jenkins will automate deployments using **Terraform** to provision infrastructure and **Ansible** for configuration management.

5. **Build and Artifact Storage**:
   - **Maven** and **npm** will be used to build the backend (Java microservices) and frontend (React) code, respectively.
   - Artifacts and Docker images will be stored in **JFrog Artifactory**.

6. **Containerization and Orchestration**:
   - **Docker** will be used to containerize the services.
   - **Kubernetes (GKE)** will be responsible for orchestration, ensuring the scalability of containers.
   - **Helm** will be used to deploy and manage Kubernetes applications efficiently.

7. **Code Quality**:
   - **SonarQube** will be integrated into the pipeline for static code analysis, ensuring that the application meets the organization’s quality gates before deployment.

8. **Monitoring and Alerting**:
   - **Prometheus** will be set up to collect metrics, and **Grafana** will be used for real-time visualization and alerting.

---

## Phase 2: Actionable Steps

### Infrastructure Setup:
- **Cloud Provider**: GCP (with future AWS expansion)
- **Terraform** will provision the following infrastructure:
  - Instances for **Jenkins Master**, **Jenkins Slave**, **SonarQube**, and **Docker**.
  - **Cloud SQL** will be provisioned via Terraform for MySQL, and it will not be managed by Ansible.
  - **GKE** will be provisoned for applciation deployment

### Repositories:
- **Application Code**: The development team will maintain separate repositories for the following applications:
  - **I27-Eureka** (Service Discovery)
  - **I27-Products** (Product Catalog Service)
  - **I27-User** (User Management Service)
  - **I27-Clothing-App** (React frontend)

- **Infrastructure Code**: A dedicated repository will hold:
  - **Terraform code** for provisioning GCP resources and Cloud SQL.
  - **Ansible playbooks** for configuring Jenkins, SonarQube, and Docker environments.
  - **Jenkins Pipelines** For you CICD implementation

### CI/CD Pipeline:
- **Jenkins Pipelines** will automate the entire build and deployment process.
- **Shared libraries** will be used in Jenkins to modularize and reuse pipeline logic across multiple repositories.
- The pipelines will include steps to:
  - Build the backend (Java Spring Boot) using **Maven**.
  - Build the frontend (React) using **npm**.
  - Run static code analysis with **SonarQube**.
  - Create and push **Docker images** to **JFrog Artifactory**.
  - Deploy the containers to **GKE** using Helm.

### Configuration Management:
- **Ansible** will configure all necessary software on the Jenkins, SonarQube, and Docker instances.
- **MySQL** will be handled via **Cloud SQL**, provisioned using Terraform, and excluded from Ansible management.

### Kubernetes and Helm:
- **Kubernetes (GKE)** will be used to orchestrate the application, ensuring automatic scaling of containers.
- **Helm** charts will be employed to manage application deployments on Kubernetes, simplifying version control and updates.

### Monitoring:
- **Prometheus** will collect real-time metrics from Kubernetes and applications.
- **Grafana** will be used for building dashboards and setting up alerts.

---

## Next Steps:
1. **Create the necessary GitHub repositories** for application source code and infrastructure (Terraform and Ansible).
2. **Set up Terraform scripts** to provision Jenkins, SonarQube, Docker, and Cloud SQL on GCP.
3. **Configure Jenkins Pipelines with shared libraries** to automate builds, deployments, and testing.
4. **Automate the configuration** of instances (except Cloud SQL) using Ansible.
5. **Deploy the application** onto Kubernetes using Helm, with Prometheus and Grafana for monitoring.

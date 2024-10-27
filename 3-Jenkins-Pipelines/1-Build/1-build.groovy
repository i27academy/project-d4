// This Jenkinsfile is for Eureka Deployment 

pipeline {
    agent {
        label 'k8s-slave'
    }
    tools {
        maven 'Maven-3.8.8'
        jdk 'JDK-17'
    }
    environment {
        APPLICATION_NAME = "eureka" 
    }
    stages {
        stage ('Build') {
            steps {
                echo "Building the ${env.APPLICATION_NAME} Application"
                sh 'mvn clean package -DskipTests=true'
            }
        }
    }
}















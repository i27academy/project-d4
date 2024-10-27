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
        SONAR_TOKEN = credentials('sonar_creds')
        SONAR_URL = "http://34.55.191.104:9000"
        // https://www.jenkins.io/doc/pipeline/steps/pipeline-utility-steps/#readmavenpom-read-a-maven-project-file
        // If any errors with readMavenPom, make sure pipeline-utility-steps plugin is installed in your jenkins, if not do install it
        // http://34.139.130.208:8080/scriptApproval/
        POM_VERSION = readMavenPom().getVersion()
        POM_PACKAGING = readMavenPom().getPackaging()
        DOCKER_HUB = "docker.io/i27devopsb4"
        DOCKER_CREDS = credentials('dockerhub_creds') //username and password
    }
    stages {
        stage ('Build') {
            steps {
                script {
                    buildApp().call()
                }
            }
        }
        stage ('Sonar') {
            steps {
                echo "Starting Sonar Scans"
                withSonarQubeEnv('SonarQube'){ // The name u saved in system under manage jenkins
                    sh """
                    mvn  sonar:sonar \
                        -Dsonar.projectKey=i27-eureka \
                        -Dsonar.host.url=${env.SONAR_URL} \
                        -Dsonar.login=${SONAR_TOKEN}
                    """
                }
                timeout (time: 2, unit: 'MINUTES'){
                    waitForQualityGate abortPipeline: true
                }

            }
        }
        stage ('Docker Build and Push') {
            steps { 
                script {
                    dockerBuildAndPush().call()
                }
            } 
        }
        stage ('Deploy to Dev') {
            steps {
                script {
                    //envDeploy, hostPort, contPort)
                    dockerDeploy('dev', '5761', '8761').call()
                }
            }
        }
        stage ('Deploy to Test') {
            steps {
                script {
                    //envDeploy, hostPort, contPort)
                    dockerDeploy('tst', '6761', '8761').call()
                }
            }
        }
        stage ('Deploy to Stage') {
            steps {
                script {
                    //envDeploy, hostPort, contPort)
                    dockerDeploy('stg', '7761', '8761').call()
                }

            }
        }
        stage ('Deploy to Prod') {
            steps {
                script {
                    //envDeploy, hostPort, contPort)
                    dockerDeploy('prd', '8761', '8761').call()
                }
            }
        }
    }
}


// Method for Maven Build
def buildApp() {
    return {
        echo "Building the ${env.APPLICATION_NAME} Application"
        sh 'mvn clean package -DskipTests=true'
    }
}

// Method for Docker build and Push
def dockerBuildAndPush(){
    return {
        echo "************************* Building Docker image*************************"
        pwd
        ls -la
        cp ${WORKSPACE}/target/i27-${env.APPLICATION_NAME}-${env.POM_VERSION}.${env.POM_PACKAGING} ./.cicd
        ls -la ./.cicd
        sh "docker build --no-cache --build-arg JAR_SOURCE=i27-${env.APPLICATION_NAME}-${env.POM_VERSION}.${env.POM_PACKAGING} -t ${env.DOCKER_HUB}/${env.APPLICATION_NAME}:${GIT_COMMIT} ./.cicd"
        echo "************************ Login to Docker Registry ************************"
        sh "docker login -u ${DOCKER_CREDS_USR} -p ${DOCKER_CREDS_PSW}"
        sh "docker push ${env.DOCKER_HUB}/${env.APPLICATION_NAME}:${GIT_COMMIT}"
    }
}


// Method for deploying containers in diff env
def dockerDeploy(envDeploy, hostPort, contPort){
    return {
        echo "Deploying to $envDeploy Environmnet"
            withCredentials([usernamePassword(credentialsId: 'maha_ssh_docker_server_creds', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                script {
                    sh "sshpass -p '$PASSWORD' -v ssh -o StrictHostKeyChecking=no $USERNAME@$dev_ip \"docker pull ${env.DOCKER_HUB}/${env.APPLICATION_NAME}:${GIT_COMMIT}\""
                    try {
                        // Stop the Container
                        sh "sshpass -p '$PASSWORD' -v ssh -o StrictHostKeyChecking=no $USERNAME@$dev_ip docker stop ${env.APPLICATION_NAME}-$envDeploy"
                        // Remove the Container
                        sh "sshpass -p '$PASSWORD' -v ssh -o StrictHostKeyChecking=no $USERNAME@$dev_ip docker rm ${env.APPLICATION_NAME}-$envDeploy"
                    }
                    catch(err) {
                        echo "Error Caught: $err"
                    }

                    // Create the container
                    sh "sshpass -p '$PASSWORD' -v ssh -o StrictHostKeyChecking=no $USERNAME@$dev_ip docker run -dit --name ${env.APPLICATION_NAME}-$envDeploy -p $hostPort:$contPort ${env.DOCKER_HUB}/${env.APPLICATION_NAME}:${GIT_COMMIT}"
                }   
            }
    }
}




// Eureka 
// continer port" 8761

// dev hp: 5761
// tst hp: 6761
// stg hp: 7761
// prod hp: 8761
















//withCredentials([usernameColonPassword(credentialsId: 'mylogin', variable: 'USERPASS')])

// https://docs.sonarsource.com/sonarqube/9.9/analyzing-source-code/scanners/jenkins-extension-sonarqube/#jenkins-pipeline

// sshpass -p password ssh -o StrictHostKeyChecking=no username@dockerserverip
 

 //usernameVariable : String
// Name of an environment variable to be set to the username during the build.
// passwordVariable : String
// Name of an environment variable to be set to the password during the build.
// credentialsId : String
// Credentials of an appropriate type to be set to the variable.
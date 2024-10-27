// Method to print Hello Mr Siva 
// Siva name should be dynamically passed

def example(name) {
    return {
        echo "Hello Mr $name"
    }

}


pipeline {
    agent {
        label 'k8s-slave'
    }
    stages {
        stage ('Siva Stage') {
            steps {
                script {
                    example('siva').call()
                }
            }
        }
        stage ('John Stage') {
            steps {
                script {
                    example('John').call()
                }
            }
        }
    }
}



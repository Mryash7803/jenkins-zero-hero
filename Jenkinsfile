pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Pulling code from GitHub...'
                // Jenkins does the "git checkout" automatically in this mode!
                sh 'ls -la' // List files to prove we are inside the repo
            }
        }
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'echo "Compiling code..."'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
                sh 'echo "All tests passed!"'
            }
        }
    }
}

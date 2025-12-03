pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Verify Docker') {
            steps {
                echo 'Checking Docker version...'
                sh 'docker --version' 
            }
        }
        stage('Build Image') {
            steps {
                echo 'Building Docker Image...'
                // This builds the image using the Dockerfile you added in Level 3
                sh 'docker build -t my-app:v1 .'
            }
        }
    }
}



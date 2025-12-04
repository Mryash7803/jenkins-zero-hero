pipeline {
    agent any
    
    environment {
        // REPLACE THIS WITH YOUR DOCKER HUB USERNAME
        DOCKERHUB_USERNAME = 'mryashdoc' 
        IMAGE_NAME = 'my-app'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Image') {
            steps {
                echo 'Building Docker Image...'
                // We tag it with the specific Build Number so every build is unique
                sh "docker build -t $DOCKERHUB_USERNAME/$IMAGE_NAME:$IMAGE_TAG ."
                // We also tag it 'latest' for convenience
                sh "docker build -t $DOCKERHUB_USERNAME/$IMAGE_NAME:latest ."
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing Image...'
                // This block securely injects your username/password into the environment
                withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push $DOCKERHUB_USERNAME/$IMAGE_NAME:$IMAGE_TAG"
                    sh "docker push $DOCKERHUB_USERNAME/$IMAGE_NAME:latest"
                }
            }
        }
    }
    
    post {
        always {
            // Cleanup: Remove the image from local Jenkins storage to save space
            sh "docker logout"
        }
    }
}



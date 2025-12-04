pipeline {
    agent any
    
    environment {
        // REPLACE THIS WITH YOUR DOCKER HUB USERNAME
        DOCKERHUB_USERNAME = 'mryashdoc' 
        IMAGE_NAME = 'my-app'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        CONTAINER_NAME = 'my-prod-website'
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

        stage('Deploy to Server') {
            steps {
                echo 'Deploying to Local Server...'
                script {
                    // 1. Stop the old container (if running)
                    // "|| true" prevents the pipeline from failing if the container doesn't exist yet
                    sh "docker stop $CONTAINER_NAME || true"
                    
                    // 2. Remove the old container
                    sh "docker rm $CONTAINER_NAME || true"
                    
                    // 3. Run the new container on Port 8090
                    sh "docker run -d -p 8090:80 --name $CONTAINER_NAME $DOCKERHUB_USERNAME/$IMAGE_NAME:latest"
                }
            }
        }
    }
}

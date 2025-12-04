pipeline {
    agent any

    environment {
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
                sh "docker build -t $DOCKERHUB_USERNAME/$IMAGE_NAME:$IMAGE_TAG ."
                sh "docker build -t $DOCKERHUB_USERNAME/$IMAGE_NAME:latest ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing Image...'
                withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push $DOCKERHUB_USERNAME/$IMAGE_NAME:$IMAGE_TAG"
                    sh "docker push $DOCKERHUB_USERNAME/$IMAGE_NAME:latest"
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    input message: 'Deploy to Production?', ok: 'Yes, Go Ahead'
                    echo 'Deploying To Production Server...'

                    // Stop old container if running
                    sh "docker stop $CONTAINER_NAME || true"

                    // Remove old container
                    sh "docker rm $CONTAINER_NAME || true"

                    // Run new container on port 8090
                    sh "docker run -d -p 8090:80 --name $CONTAINER_NAME $DOCKERHUB_USERNAME/$IMAGE_NAME:$IMAGE_TAG"
                }
            }
        }
    }

    post {
        success {
            mail(
                to: 'yashsingar7@gmail.com',
                subject: "SUCCESS: Jenkins Build #${env.BUILD_NUMBER}",
                body: "Great News! Build #${env.BUILD_NUMBER} for ${env.JOB_NAME} was successful!\n\nView build: ${env.BUILD_URL}"
            )
        }

        failure {
            mail(
                to: 'yashsingar7@gmail.com',
                subject: "FAILURE: Jenkins Build #${env.BUILD_NUMBER}",
                body: "Alert! Build #${env.BUILD_NUMBER} for ${env.JOB_NAME} has failed!\n\nView details: ${env.BUILD_URL}"
            )
        }
    }
}


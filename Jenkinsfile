pipeline {
    agent any
    
    environment {
        // --- CONFIGURATION ---
        // 1. REPLACE WITH YOUR DOCKER HUB USERNAME
        DOCKERHUB_USERNAME = 'your-dockerhub-username' 
        
        IMAGE_NAME = 'my-app'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        CONTAINER_NAME = 'my-prod-website'
        
        // 2. REPLACE WITH YOUR EMAIL ADDRESS
        USER_EMAIL = 'your-email@gmail.com'
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
                // Build the image tagged with the build number
                sh "docker build -t ${env.DOCKERHUB_USERNAME}/${env.IMAGE_NAME}:${env.IMAGE_TAG} ."
                // Also tag it 'latest' for the production deployment
                sh "docker build -t ${env.DOCKERHUB_USERNAME}/${env.IMAGE_NAME}:latest ."
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing to Registry...'
                // We use the 'docker-hub-repo' credentials ID we created in Jenkins
                withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh "echo ${env.DOCKER_PASS} | docker login -u ${env.DOCKER_USER} --password-stdin"
                    sh "docker push ${env.DOCKERHUB_USERNAME}/${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                    sh "docker push ${env.DOCKERHUB_USERNAME}/${env.IMAGE_NAME}:latest"
                }
            }
        }
        
        stage('Deploy to Server') {
            // This stage ONLY runs on the 'main' branch
            when {
                branch 'main'
            }
            steps {
                script {
                    // Manual Approval Gate
                    input message: 'Deploy to Production?', ok: 'Yes, Go Ahead!'
                    
                    echo 'Deploying to Production Server...'
                    
                    // 1. Stop the old container (if running)
                    sh "docker stop ${env.CONTAINER_NAME} || true"
                    
                    // 2. Remove the old container
                    sh "docker rm ${env.CONTAINER_NAME} || true"
                    
                    // 3. Run the new container on Port 8090
                    sh "docker run -d -p 8090:80 --name ${env.CONTAINER_NAME} ${env.DOCKERHUB_USERNAME}/${env.IMAGE_NAME}:latest"
                }
            }
        }
    }
    
    post {
        success {
            mail body: "Great News! Build #${env.BUILD_NUMBER} for ${env.JOB_NAME} was SUCCESSFUL.\n\nCheck the dashboard here: ${env.BUILD_URL}",
                     subject: "SUCCESS: Jenkins Build #${env.BUILD_NUMBER}",
                     to: "${env.USER_EMAIL}"
        }
        failure {
            mail body: "Alert! Build #${env.BUILD_NUMBER} for ${env.JOB_NAME} FAILED.\n\nPlease check logs here: ${env.BUILD_URL}",
                     subject: "FAILURE: Jenkins Build #${env.BUILD_NUMBER}",
                     to: "${env.USER_EMAIL}"
        }
        always {
            // Cleanup: Log out of Docker to be safe
            sh "docker logout"
        }
    }
}

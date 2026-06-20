pipeline {
    agent any // Run on any available build machine
    options {
        timestamps() // Add timestamps to console logs
        disableConcurrentBuilds() // Prevent overlapping runs
        timeout(time: 30, unit: 'MINUTES') // Auto-abort if pipeline hangs
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/tanmayakrout/hello-jenkins.git'
                // checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                bat '"C:\\Program Files\\Git\\bin\\bash.exe" ./build.sh' 
                // build.sh should run docker build
            }
        }
        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    bat '"C:\\Program Files\\Git\\bin\\bash.exe" ./push.sh'
                    // push.sh should run docker push to your registry
                }
            }
        }
        stage('Deploy to Kubernetes') {
            environment {
                KUBECONFIG = 'C:\\Users\\MY PC\\.kube\\config'
            }
            steps {
                bat 'kubectl apply -f k8s/deployment.yaml'
                // deployment.yaml defines your Kubernetes Deployment
            }
        }
    }
    post {
        success {
            echo "✅ Pipeline completed successfully: Docker built, pushed, and deployed to Kubernetes!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs for details."
        }
    }
}

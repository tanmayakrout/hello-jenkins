pipeline {
    agent any // Run on any available build machine
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/tanmayakrout/hello-jenkins.git'
                // checkout scm
            }
        }
        stage('Build & Test Docker') {
            steps {
                bat '"C:\\Program Files\\Git\\bin\\bash.exe" ./build.sh' //sh for Linux and bat for Windows
            }
        }
    }
    post {
        success {
            echo "Docker build & run successful!"
        }
        failure {
            echo "Something went wrong."
        }
    }
}

pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/tanmayakrout/hello-jenkins.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Building project...'
                sh 'echo "Hello Jenkins Build" > hello.txt'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'cat hello.txt'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying...'
                sh './deploy.sh'
            }
        }
    }
}

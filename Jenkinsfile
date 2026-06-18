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
                bat '"C:\\Program Files\\Git\\bin\\bash.exe" -c "echo Hello Jenkins Build > hello.txt"'
            }
        }

        stage('Test') {
            steps {
                bat '"C:\\Program Files\\Git\\bin\\bash.exe" -c "cat hello.txt"'
            }
        }

        stage('Deploy') {
            steps {
                bat '"C:\\Program Files\\Git\\bin\\bash.exe" deploy.sh'
            }
        }

    }
}

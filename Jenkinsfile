pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps { git 'https://github.com/your-org/hello-jenkins.git' }
    }
    stage('Deploy') {
      steps { sh 'chmod +x deploy.sh && ./deploy.sh' }
    }
  }
}

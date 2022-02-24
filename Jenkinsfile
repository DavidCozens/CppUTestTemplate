pipeline {
  agent {
    docker {
      image 'davidcozens/cpputest:4'
      registryCredentialsId 'dockerhub'
    }
  }
  stages {
    stage('build') {
      steps{
        sh 'make -j ci_run'
      }
    }
  }
  post {
    always {
      junit 'cpputest*.xml'
    }
    cleanup {
      cleanWs()
    }
  }
}

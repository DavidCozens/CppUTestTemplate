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
      xunit thresholds: [failed(failureThreshold: '0')], tools: [JUnit(excludesPattern: '', pattern: 'cpputest_*.xml', stopProcessingIfError: true)]
    }
    cleanup {
      cleanWs()
    }
  }
}

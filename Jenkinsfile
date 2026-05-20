pipeline {
    agent any 

    stages { 
        stage('SCM Checkout') {
            steps{
           git branch: 'feature/update_labs_sonar', url: 'https://github.com/cheikht1/lecloudfacile-devops-labs.git'
            }
        }
        // run sonarqube test
        stage('Run Sonarqube') {
            environment {
                scannerHome = tool 'sonar-lcf';
            }
            steps {
              withSonarQubeEnv(credentialsId: 'sonar', installationName: 'Sonar') {
                sh "${scannerHome}/bin/sonar-scanner"
              }
            }
        }
    }
}
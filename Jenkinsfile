pipeline {
    agent any 

    stages { 
        stage('SCM Checkout') {
            steps{
           git branch: 'main', url: 'VOTRE_URL_GIT.git'
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
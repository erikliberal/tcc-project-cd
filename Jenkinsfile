#!/usr/bin/env groovy

def verificaUpload(podeFazerUpload){
  if ( podeFazerUpload ) {
      echo 'pode fazer'
  } else {
      echo 'não pode fazer'
  }
}

pipeline {
    agent none

    stages {
        stage('Build') {
          agent any
          tools {
              maven 'maven'
          }
          steps {
              sh 'mvn clean install'
          }
        }
        stage('Aguardando aprovação'){
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    input message: 'Aprovar', parameters: [text(defaultValue: '-', description: '', name: 'justificativa'), booleanParam(defaultValue: false, description: '', name: 'aprovado')]
                }
            }
        }
        stage('Após aprovação'){
            steps {
              verificaUpload(params.aprovado)
            }
        }
    }

    post {
        always {
            echo "Ultima build durou ${currentBuild.durationString}"
        }
        success {
            echo "Aprovado por ${params.aprovador} Justificativa \'${params.justificativa}\'"
        }
        failure {
            echo "Rejeitado por ${params.aprovador} Justificativa \'${params.justificativa}\'"
        }
        unstable {
            echo 'unstable'
        }
        changed {
            echo 'changed'
        }
    }
}

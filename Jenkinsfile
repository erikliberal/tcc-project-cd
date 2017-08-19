#!/usr/bin/env groovy

def verificaAprovacao(aprovado, submitter, justificativa){
  echo "$aprovado, $submitter, $justificativa"
  if ( aprovado ) {
      echo "Aprovado por $submitter devido a [$justificativa]"
  } else {
      error "Rejeitado por $submitter devido a [$justificativa]"
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
              sh 'mvn install'
          }
        }
        stage('Aguardando aprovação de testes manuais'){
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    input message: 'Aprovar', submitterParameter: 'submitter', parameters: [
                        text(defaultValue: '-', description: '', name: 'justificativa'),
                        booleanParam(defaultValue: false, description: '', name: 'aprovado')
                    ]
                }
            }
        }
        stage('Verifica aprovação') {
            steps {
              echo "$params.aprovado, $params.submitter, $params.justificativa"
              verificaAprovacao(params.aprovado, params.submitter, params.justificativa)
            }
        }
    }

    post {
        always {
            echo "Ultima build durou ${currentBuild.durationString}"
        }
        success {
            echo "Aprovado por ${params.submitter} Justificativa \'${params.justificativa}\'"
        }
        failure {
            echo "Rejeitado por ${params.submitter} Justificativa \'${params.justificativa}\'"
        }
        unstable {
            echo 'unstable'
        }
        changed {
            echo 'changed'
        }
    }
}

#!/usr/bin/env groovy

def verificaAprovacao(aprovacao){
  if (aprovacao.aprovado){
    echo "Build aprovado por $aprovacao.submitter com a justificativa [$aprovacao.justificativa]"
  } else {
    error "Build rejeitado por $aprovacao.submitter com a justificativa [$aprovacao.justificativa]"
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
        stage('Aguardando aprovação de testes manuais'){
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    verificaAprovacao(input(message: 'Aprovar', submitterParameter: 'submitter', parameters: [
                        text(defaultValue: '-', description: '', name: 'justificativa'),
                        booleanParam(defaultValue: false, description: '', name: 'aprovado')
                    ]))
                }
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

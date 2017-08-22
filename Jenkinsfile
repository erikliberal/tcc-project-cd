#!/usr/bin/env groovy

def verificaAprovacao(aprovacao){
  if (!aprovacao.aprovado){
    echo "Criar ticket de erro no issue tracker com a justificativa"
    error "Build rejeitado por $aprovacao.submitter com a justificativa [$aprovacao.justificativa]"
  } else {
  }
}

pipeline {
    agent none
    stages {
        stage ('Compilação e testes unitários') {
          agent any
          tools {
              maven 'maven'
          }
          steps {
              sh 'mvn clean test -Pcheck'
          }
        }
        stage('Build') {
          agent any
          tools {
              maven 'maven'
          }
          steps {
              sh 'mvn clean deploy'
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
        unstable {
            echo 'unstable'
        }
        changed {
            echo 'changed'
        }
    }
}

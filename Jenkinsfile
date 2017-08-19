#!/usr/bin/env groovy

verificaAprovacao(aprovado, submitter, justificativa){
  if ( aprovado ) {
      echo "Aprovado por $submitter devido a [$justificativa]"
  } else {
      echo "Rejeitado por $submitter devido a [$justificativa]"
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
            parameters {
                string(name: 'justificativa', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?'),
                booleanParam(name: 'aprovado', defaultValue: false, description: '')
            }
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    input message: 'Aprovar', submitterParameter: 'submitter', parameters: [
                        text(defaultValue: '-', description: '', name: 'justificativa'),
                        booleanParam(defaultValue: false, description: '', name: 'aprovado')
                    ]
                    verificaAprovacao(params.aprovado, params.submitter, params.justificativa)
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

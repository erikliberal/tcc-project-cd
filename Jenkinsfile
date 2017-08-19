#!/usr/bin/env groovy

def verificaAprovacao(aprovado, submitter, justificativa){
  echo "$aprovado, $submitter, $justificativa"
  if ( aprovado ) {
      echo "Aprovado por $submitter devido a [$justificativa]"
  } else {
      error "Rejeitado por $submitter devido a [$justificativa]"
  }
}

stage('Build') {
  node('agent && linux') {
    tool name: 'maven', type: 'maven' {
      sh 'mvn install'
    }
  }
}

stage('Aguardando aprovação de testes manuais'){
    timeout(time: 1, unit: 'HOURS') {
        input message: 'Aprovar', submitterParameter: 'submitter', parameters: [
            text(defaultValue: '-', description: '', name: 'justificativa'),
            booleanParam(defaultValue: false, description: '', name: 'aprovado')
        ]
        echo "${params.aprovado}, ${params.submitter}, ${params.justificativa}"
    }
}

stage('Verifica aprovação') {
    node {
      tool name: 'Default', type: 'git'
      git status
    }

    params.entrySet().each{key,value->println "[$key] $value"}
    echo "${params.aprovado}, ${params.submitter}, ${params.justificativa}"
    verificaAprovacao(params.aprovado, params.submitter, params.justificativa)
}

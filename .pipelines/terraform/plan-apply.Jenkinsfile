// run plan and apply for all terraform resources

pipeline {
  agent {
    label "node-b"
  }
  environment {
        OP_CONNECT_TOKEN = credentials('jenkinsci-1password-connect-token')
    }
  stages {
    stage('auth0') {
      steps {
        sshagent(['jenkinsci-ssh-key']) {
          sh(
            script: """
              cd terraform/resources/auth0
              op inject -i accounts.yaml.tpl -o accounts.yaml --force
              op run --env-file="./environment" -- terraform init
              op run --env-file="./environment" -- terraform apply -auto-approve
            """
          )
        }
      }
    }
  }
}


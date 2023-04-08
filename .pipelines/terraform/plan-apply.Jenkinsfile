// run plan and apply for all terraform resources

pipeline {
  agent {
    label "node-b"
  }
  environment {
        OP_CONNECT_TOKEN = credentials('jenkinsci-1password-connect-token')
        TF_TOKEN_app_terraform_io = credentials('jenkinsci-terraform-cloud-token')
    }
  stages {
    stage('auth0') {
      steps {
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
    stage('aws root global') {
      steps {
        sh(
          script: """
            cd terraform/resources/aws/root/global
            op run --env-file="./environment" -- terraform init
            op run --env-file="./environment" -- terraform apply -auto-approve
          """
        )
      }
    }
    stage('aws root eu-central-1') {
      steps {
        sh(
          script: """
            cd terraform/resources/aws/root/eu-central-1
            op inject -i secrets.yaml.tpl -o secrets.yaml --force
            op run --env-file="./environment" -- terraform init
            op run --env-file="./environment" -- terraform apply -auto-approve
          """
        )
      }
    }
    stage('aws root us-east-1') {
      steps {
        sh(
          script: """
            cd terraform/resources/aws/root/us-east-1
            op run --env-file="./environment" -- terraform init
            op run --env-file="./environment" -- terraform apply -auto-approve
          """
        )
      }
    }
    stage('home mikrotik') {
      steps {
        sh(
          script: """
            cd terraform/resources/home/mikrotik
            op run --env-file="./environment" -- terraform init
            op run --env-file="./environment" -- terraform apply -auto-approve
          """
        )
      }
    }
    stage('home pi-hole') {
      steps {
        sh(
          script: """
            cd terraform/resources/home/pi-hole
            op run --env-file="./environment" -- terraform init
            op run --env-file="./environment" -- terraform apply -auto-approve
          """
        )
      }
    }
    stage('home node-a') {
      steps {
        sh(
          script: """
            cd terraform/resources/home/node-a
            op run --env-file="./environment" -- terraform init
            op run --env-file="./environment" -- terraform apply -auto-approve
          """
        )
      }
    }
    stage('home node-b') {
      steps {
        sh(
          script: """
            cd terraform/resources/home/node-b
            op run --env-file="./environment" -- terraform init
            op run --env-file="./environment" -- terraform apply -auto-approve
          """
        )
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}


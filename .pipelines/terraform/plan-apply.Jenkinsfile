// run plan and apply for all terraform resources

pipeline {
  agent {
    label "node-b"
  }
  triggers {
      // every tuesday morning
      cron('H 3 * * 2')
  }
  environment {
    OP_CONNECT_TOKEN = credentials('jenkinsci-1password-connect-token')
    TF_TOKEN_app_terraform_io = credentials('jenkinsci-terraform-cloud-token')
  }
  parameters {
    booleanParam(defaultValue: true, name: 'AUTH0', description: 'Run terraform for terraform/resources/auth0')
    booleanParam(defaultValue: true, name: 'AWS_ROOT_GLOBAL', description: 'Run terraform for terraform/resources/aws/root/global')
    booleanParam(defaultValue: true, name: 'AWS_ROOT_EU_CENTRAL_1', description: 'Run terraform for terraform/resources/aws/root/eu-central-1')
    booleanParam(defaultValue: true, name: 'AWS_ROOT_US_EAST_1', description: 'Run terraform for terraform/resources/aws/root/us-east-1')
    booleanParam(defaultValue: true, name: 'HOME_MIKROTIK', description: 'Run terraform for terraform/resources/home/mikrotik')
    booleanParam(defaultValue: true, name: 'HOME_PI_HOLE', description: 'Run terraform for terraform/resources/home/pi-hole')
    booleanParam(defaultValue: true, name: 'HOME_NODE_A', description: 'Run terraform for terraform/resources/home/node-a')
    booleanParam(defaultValue: true, name: 'HOME_NODE_B', description: 'Run terraform for terraform/resources/home/node-b')
  }
  stages {
    stage('auth0') {
      when {
        expression { params.AUTH0 }
      }
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
      when {
        expression { params.AWS_ROOT_GLOBAL }
      }
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
      when {
        expression { params.AWS_ROOT_EU_CENTRAL_1 }
      }
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
      when {
        expression { params.AWS_ROOT_US_EAST_1 }
      }
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
      when {
        expression { params.HOME_MIKROTIK }
      }
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
    // disabling pi-hole, it seems pi hole breaks when terraform changes are applied and the dns resolver needs to be restarted,
    // stage('home pi-hole') {
    //   when {
    //     expression { params.HOME_PI_HOLE }
    //   }
    //   steps {
    //     sh(
    //       script: """
    //         cd terraform/resources/home/pi-hole
    //         op run --env-file="./environment" -- terraform init
    //         op run --env-file="./environment" -- terraform apply -auto-approve
    //       """
    //     )
    //   }
    // }
    stage('home node-a') {
      when {
        expression { params.HOME_NODE_A }
      }
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
      when {
        expression { params.HOME_NODE_B }
      }
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


// reboot plex server

pipeline {
  agent {
    label "node-b"
  }
  environment {
    OP_CONNECT_TOKEN = credentials('jenkinsci-1password-connect-token')
  }
  stages {
    stage('Reboot plex server') {
      steps {
        sshagent(['jenkinsci-ssh-key']) {
          sh(
            script: """
              cd ansible
              ANSIBLE_HOST_KEY_CHECKING=False op run --env-file="./environment" -- ansible-playbook -i jenkins.ini playbook/reboot-plex.yaml
            """
          )
        }
      }
    }
  }
}


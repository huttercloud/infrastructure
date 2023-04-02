// reboot plex server

pipeline {
    agent {
      label "node-b"
    }
    stages {
        stage('Reboot plex server') {
            steps {
              sshagent(['jenkinsci-ssh-key']) {
                sh(
                  script: """
                    cd ansible
                    ansible-playbook -i inventory.ini playbook/reboot-plex.yaml
                  """
                )
              }
            }
        }
    }
}


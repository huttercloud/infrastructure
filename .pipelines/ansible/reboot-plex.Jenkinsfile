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
                    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i jenkins.ini playbook/reboot-plex.yaml
                  """
                )
              }
            }
        }
    }
}


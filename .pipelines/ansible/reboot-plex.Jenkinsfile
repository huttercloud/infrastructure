// reboot plex server

pipeline {
    agent {
      label "node-b"
    }
    stages {
        stage('Reboot plex server') {
            steps {
                sh(
                  script: """
                    pwd
                    id
                    ip addr
                    /var/lib/jenkins/venv/bin/ansible-playbook --help
                  """
                )
                ansiblePlaybook credentialsId: 'plex-ssh-key', inventory: 'ansible/inventory.ini', playbook: 'ansible/playbook/reboot-plex.yaml'
            }
        }
    }
}

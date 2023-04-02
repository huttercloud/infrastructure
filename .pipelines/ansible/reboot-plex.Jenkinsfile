// reboot plex server

pipeline {
    agent {
      label "node-b"
    }
    stages {
        stage('Reboot plex server') {
            steps {
                ansiblePlaybook credentialsId: 'plex-ssh-key', inventory: 'ansible/inventory.ini', playbook: 'ansible/playbook/reboot-plex.yaml'
            }
        }
    }
}

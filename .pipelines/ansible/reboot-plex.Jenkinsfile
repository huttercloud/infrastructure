// reboot plex server

pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: shell
    image: ubuntu
    command:
    - sleep
    args:
    - infinity
'''
            defaultContainer 'shell'
        }
    }
    stages {
        stage('Reboot plex server') {
            steps {
                ansiblePlaybook credentialsId: 'plex-ssh-key', inventory: 'ansible/inventory.ini', playbook: 'ansible/playbook/reboot-plex.yaml'
            }
        }
    }
}

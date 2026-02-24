// upgrade all nodes and plex server

pipeline {
  agent none
  triggers {
      // every first of the month at 3 AM
      cron('H 3 1 * *')
  }
  environment {
    OP_CONNECT_TOKEN = credentials('jenkinsci-1password-connect-token')
  }
  parameters {
    booleanParam(defaultValue: true, name: 'NODE_A', description: 'Patch node-a')
    booleanParam(defaultValue: true, name: 'NODE_B', description: 'Patch node-b')
    booleanParam(defaultValue: true, name: 'PLEX', description: 'Patch plex')
  }
  stages {
    stage('Patch node-a.hutter.cloud') {
      agent {
        label "node-b"
      }
      when {
        expression { params.NODE_A }
      }
      steps {
        sshagent(['jenkinsci-ssh-key']) {
          sh(
            script: """
              cd ansible
              ANSIBLE_HOST_KEY_CHECKING=False op run --env-file="./environment" -- ansible-playbook -i jenkins.ini --limit node-a.hutter.cloud playbook/upgrade-systems.yaml
            """
          )
          // wait a little while to ensure services on node-a are back
          sleep(time: 60)
        }
      }
    }
    stage('Patch node-b.hutter.cloud') {
      agent {
        label 'node-a'
      }
      when {
        expression { params.NODE_B }
      }
      steps {
        sshagent(['jenkinsci-ssh-key']) {
          sh(
            script: """
              cd ansible
              ANSIBLE_HOST_KEY_CHECKING=False op run --env-file="./environment" -- ansible-playbook -i jenkins.ini --limit node-b.hutter.cloud playbook/upgrade-systems.yaml
            """
          )
        }
      }
    }
    stage('Patch plex.hutter.cloud') {
      agent {
        label "node-b"
      }
      when {
        expression { params.PLEX }
      }
      steps {
        sshagent(['jenkinsci-ssh-key']) {
          sh(
            script: """
              cd ansible
              ANSIBLE_HOST_KEY_CHECKING=False op run --env-file="./environment" -- ansible-playbook -i jenkins.ini --limit plex.hutter.cloud playbook/upgrade-systems.yaml
            """
          )
        }
      }
    }
  }
}

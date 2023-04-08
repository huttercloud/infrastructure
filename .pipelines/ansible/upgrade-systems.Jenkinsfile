// upgrade all nodes and plex server

pipeline {
  agent none
  triggers {
      // every first of the month at 3 AM
      cron('H 3 1 * *')
  }
  parameters {
    booleanParam(defaultValue: true, name: 'NODE_A', description: 'Patch node-a')
    booleanParam(defaultValue: true, name: 'NODE_B', description: 'Patch node-b')
    booleanParam(defaultValue: true, name: 'NODE_C', description: 'Patch node-c')
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
              ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i jenkins.ini --limit node-a.hutter.cloud playbook/upgrade-systems.yaml
            """
          )
        }
      }
    }
    stage('Patch node-b.hutter.cloud') {
      agent {
        // patch node-b not from node-b ....
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
              ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i jenkins.ini --limit node-b.hutter.cloud playbook/upgrade-systems.yaml
            """
          )
        }
      }
    }
    stage('Patch node-c.hutter.cloud') {
      agent {
        label "node-b"
      }
      when {
        expression { params.NODE_C }
      }
      steps {
        sshagent(['jenkinsci-ssh-key']) {
          sh(
            script: """
              cd ansible
              ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i jenkins.ini --limit node-c.hutter.cloud playbook/upgrade-systems.yaml
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
              ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i jenkins.ini --limit plex.hutter.cloud playbook/upgrade-systems.yaml
            """
          )
        }
      }
    }
  }
}

// upgrade all nodes and plex server

pipeline {
  agent none
  parameters {
    booleanParam(defaultValue: true, name: 'NODE_A', description: 'Configure node-a')
    booleanParam(defaultValue: true, name: 'NODE_B', description: 'Configure node-b')
    booleanParam(defaultValue: true, name: 'NODE_C', description: 'Configure node-c')
    booleanParam(defaultValue: true, name: 'PLEX', description: 'Configure plex')
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
              ANSIBLE_HOST_KEY_CHECKING=False op run --env-file="./environment" -- ansible-playbook -i jenkins.ini playbook/node-a.yaml
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
              ANSIBLE_HOST_KEY_CHECKING=False op run --env-file="./environment" -- ansible-playbook -i jenkins.ini playbook/node-b.yaml
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
              ANSIBLE_HOST_KEY_CHECKING=False op run --env-file="./environment" -- ansible-playbook -i jenkins.ini playbook/node-c.yaml
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
              ANSIBLE_HOST_KEY_CHECKING=False op run --env-file="./environment" -- ansible-playbook -i jenkins.ini playbook/plex.yaml
            """
          )
        }
      }
    }
  }
}


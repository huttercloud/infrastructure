# hutter.cloud infrastructure



## installation
1. setup virtualenv for ansible, ensure terraform 1.3 is installed
1. install ubuntu on nucs
2. run the corresponding ansible playbooks `cd ansible; ansible-playbook -i inventory.ini playbook/node-a.yaml `
3. apply terraform code for node-a and node-b `cd terraform/home/node-a 
4. ...
5. 

# terraform

- remote state is stored in terraform cloud (run `terraform login`)
- credentials for the different environments are stored in 1password.
- the credentials are stored in the root level env file


## using terraform with one password
```bash
# example execution for mikrotik
cd terraform/home/mikrotik
op run --env-file="./environment" -- terraform apply
```

## node-a

one of the old nucs. this system will mainly serve pi-hole and handle http/s redirects
- hostname: node-a.hutter.cloud
- ip address: 192.168.30.61
- username: node

### setup 
- install ubuntu server with `openssh`
- add public ssh key to the system `ssh-copy-id -i .ssh/id_rsa.home node@192.168.30.61`
- allow node user full sudo rights without password (for ansible) `sudo /bin/sh -c "echo 'node ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/node"`
- change password of user



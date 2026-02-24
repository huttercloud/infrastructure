#
# simple makefile to make running ansible and tf commands easier
#

.PHONY: ansible ansible-node-a ansible-node-b ansible-plex
.PHONY: terraform terraform-%

# setup python virtualenv

venv:
	python3 -m venv venv

requirements: requirements.txt
	venv/bin/pip3 install -r requirements.txt

# ansible targets
ansible: ansible-node-a ansible-node-b ansible-plex


ansible-upgrade-systems:
	cd ansible; op run --env-file="./environment" -- ../venv/bin/ansible-playbook -i inventory.ini playbook/upgrade-systems.yaml

ansible-node-a:
	cd ansible; op run --env-file="./environment" -- ../venv/bin/ansible-playbook -i inventory.ini playbook/node-a.yaml

ansible-node-b:
	cd ansible; op run --env-file="./environment" -- ../venv/bin/ansible-playbook -i inventory.ini playbook/node-b.yaml

# terraform targes

terraform: terraform-auth0 terraform-aws-root-global terraform-aws-root-eu-central-1

terraform-auth0:
	cd terraform/resources/auth0; op inject -i accounts.yaml.tpl -o accounts.yaml --force
	cd terraform/resources/auth0; op run --env-file="./environment" -- terraform apply -auto-approve
terraform-aws-root-global:
	cd terraform/resources/aws/root/global; op run --env-file="./environment" -- terraform apply -auto-approve
terraform-aws-root-eu-central-1:
	cd terraform/resources/aws/root/eu-central-1; op inject -i secrets.yaml.tpl -o secrets.yaml --force
	cd terraform/resources/aws/root/eu-central-1; op run --env-file="./environment" -- terraform apply -auto-approve
terraform-aws-root-us-east-1:
	cd terraform/resources/aws/root/us-east-1; op run --env-file="./environment" -- terraform apply -auto-approve

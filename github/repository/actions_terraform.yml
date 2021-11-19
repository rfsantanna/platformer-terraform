
name: 'platformer-pipeline'

on:
  workflow_dispatch:
    branches:
    - main
  push:
    branches:
    - main
    paths:
    - .platformer/*

env:
  RUN_ANSIBLE: false
%{ for variable, value in pipeline_vars ~}
  ${variable}: "${value}"
%{ endfor ~}
  ARM_CLIENT_SECRET: $${{ secrets.AZ_APPSECRET }} 
  WORKSPACE: default

jobs:
  terraform:
    name: 'Terraform+Ansible'
    runs-on: ubuntu-latest
    environment: platformer
    defaults:
      run:
        working-directory: ./.platformer
    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Setup Terraform
      run: |
        curl -s https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip -o terraform.zip
        sudo unzip -o terraform.zip -d /usr/bin

    - name: Terraform Init
      run: terraform init 

    - name: Terraform Workspace
      run: terraform workspace select $WORKSPACE || terraform workspace new $WORKSPACE

    - name: Terraform Plan 
      run: terraform plan -out=tfplan 

    - name: Terraform Apply 
      if: github.event_name == 'push'
      run: terraform apply -auto-approve tfplan

    - name: Run Ansible
      working-directory: ./ansible
      if: env.RUN_ANSIBLE == true && github.event_name == 'push'
      env:
        ANSIBLE_PYTHON_INTERPRETER: /usr/bin/python3
        ANSIBLE_HOST_KEY_CHECKING: false
        ANSIBLE_SSH_EXTRA_ARGS: "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
        ANSIBLE_COLLECTIONS_PATHS: ./
        ANSIBLE_ROLES_PATH: ./ansible_roles
        ANSIBLE_PIPELINING: 1
        ANSIBLE_SSH_RETRIES: 3
        ANSIBLE_TIMEOUT: 20
      run: |
          #!/bin/bash
          echo ":: Generating ansible inventory with terraform output"
          terraform output ansible_inventory | grep -v '^<*EOT$' > ansible-inventory.yml
          echo ":: Check connection on ansible hosts"
          ansible -o -i ansible-inventory.yml -m wait_for_connection all
          #ansible-galaxy install -r ansible/requirements.yml --force
          IFS=","
          for playbook in "ansible/playbook.yaml"
          do
            echo ":: Running playbook - $playbook"
            ansible-playbook -i ansible-inventory.yml $playbook 
          done
          rm -f ansible-inventory.yml 2> /dev/null


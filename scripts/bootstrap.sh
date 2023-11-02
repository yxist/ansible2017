#!/bin/sh
ansible-playbook -i inventories/bootstrap.inv playbooks/bootstrap.yml --ask-vault-pass -k -vvv

#!/bin/bash
sudo labauto ansible
ansible-pull -i localhost, -U https://github.com/bk1607/learn-ansible roboshop/roboshop.yml -e role_name=${name} -e env=${env} > /var/log/ansible.log
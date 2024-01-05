#!/bin/bash
ansible-pull -i localhost, -U https://github.com/bk1607/learn-ansible roboshop/roboshop.yml -e role_name=${var.name} -e env=${var.env} > /var/log/ansible.log
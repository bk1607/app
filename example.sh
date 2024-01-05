#!/bin/bash
ansible-pull -i locahost, -U https://github.com/bk1607/learn-ansible/roboshop roboshop.yml -e role_name=${name} -e env=${env}
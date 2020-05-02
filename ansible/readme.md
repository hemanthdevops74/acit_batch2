#URL for Ansible Commands
https://www.digitalocean.com/community/cheatsheets/how-to-use-ansible-cheat-sheet-guide

# Command to check connectivity between Ansible and its nodes
ansible all -m ping

# Command to list tasks in an Ansible Playbook without actually executing them
ansible-playbook web_depl.yml --list-tasks

#Command to run playbook to un-install Python Flask and mysql
ansible-playbook uninstallpysql.yml -i inventory.txt --ask-become-pass

#Command to run playbook to install Python Flask and mysql
ansible-playbook web_depl.yml -i inventory.txt --ask-become-pass

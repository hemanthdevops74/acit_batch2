# Ansible installation steps for Ubuntu (to be executed on master)
	sudo apt-add-repository ppa:ansible/ansible
	sudo apt-get update
	sudo apt-get install ansible -y
	#Install Python
	sudo apt-get install python -y

# Commands to enable Ansible master to connect to nodes
	ssh-keygen   #generate ssh key
	cat ~/.ssh/id_rsa.pub  #cat the public key and copy the contents to clipboard
	sudo nano ~/.ssh/authorized_keys  #to be executed in target node
	Paste the key contents from clipboard to the authorized_keys and save the file

# URL for Ansible Commands
https://www.digitalocean.com/community/cheatsheets/how-to-use-ansible-cheat-sheet-guide

# Command to check connectivity between Ansible and its nodes
ansible all -m ping

# Command to list tasks in an Ansible Playbook without actually executing them
ansible-playbook web_depl.yml --list-tasks

# Command to run playbook to un-install Python Flask and mysql
ansible-playbook uninstallpysql.yml -i inventory.txt --ask-become-pass

# Command to run playbook to install Python Flask and mysql
ansible-playbook web_depl.yml -i inventory.txt --ask-become-pass

# Commands to test Python Flask Application (IP is the target server ip)
curl http://10.128.0.9:5000
curl http://10.128.0.9:5000/how%20are%20you


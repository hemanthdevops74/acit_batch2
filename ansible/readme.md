#Command to run playbook to un-install Python Flask and mysql
ansible-playbook uninstallpysql.yml -i inventory.txt --ask-become-pass

#Command to run playbook to install Python Flask and mysql
ansible-playbook web_depl.yml -i inventory.txt --ask-become-pass

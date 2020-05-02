ansible-playbook uninstallpysql.yml -i inventory.txt --ask-become-pass

ansible-playbook web_depl.yml -i inventory.txt --ask-become-pass

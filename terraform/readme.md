# Install steps Terraform on Ubuntu
	sudo apt-get install wget unzip  #install wget and unzip utilities
	export VER="0.12.24"   #specify latest version
	wget https://releases.hashicorp.com/terraform/${VER}/terraform_${VER}_linux_amd64.zip
	unzip terraform_${VER}_linux_amd64.zip
	sudo mv terraform /usr/local/bin/
	terraform -v
	

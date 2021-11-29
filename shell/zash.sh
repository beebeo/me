#!/bin/bash

# create alias
if ! grep -q 'zash' ~/.bashrc
then
	chmod u+x,g+x zash.sh
	echo "alias zash='/root/zash.sh'" >> ~/.bashrc
fi

# intall git & create ssh key
install_git() {
	clear
	yum install git -y
	read -p "Enter file in which to save the key: " FILE_NAME
	ssh-keygen -t rsa -b 4096 -f /root/.ssh/$FILE_NAME
	clear
	echo "==================== COPY SSH KEY to your github ===================="
	echo -e
	cat /root/.ssh/$FILE_NAME.pub
	echo -e
	if ! grep -q 'ssh-agent' ~/.bashrc
	then
		echo 'eval `ssh-agent -s`' >> ~/.bashrc
	fi
	echo 'ssh-add /root/.ssh/'$FILE_NAME >> ~/.bashrc
	eval `ssh-agent -s`
	ssh-add /root/.ssh/$FILE_NAME
	bash -i
}

# install docker
install_docker() {
	clear
	echo "Installing Docker ..."
	sleep 1
	curl -sSL https://get.docker.com/| sudo sh
	sudo usermod -aG docker `whoami`
	systemctl start docker.service
	systemctl enable docker.service

	echo "Installing Docker Compose ..."
	sleep 1
	sudo curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose

	sleep 1
	echo "Check version Docker Engine & Docker Compose"
	docker version
	docker-compose --version
}

# setup ssh key login vps
setup_ssh_key() {
	clear
	read -p "Please enter your public key: " PUBLIC_KEY
	read -p 'Enter new port SSH (number): ' PORT

	mkdir -p ~/.ssh
	chmod 700 ~/.ssh
	echo $PUBLIC_KEY >> ~/.ssh/authorized_keys
	chmod 600 ~/.ssh/authorized_keys

	sed -i "s/\#Port 22/Port $PORT/g" /etc/ssh/sshd_config
	sed -i 's/\PubkeyAuthentication no/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
	sed -i 's/\#PubkeyAuthentication/PubkeyAuthentication/g' /etc/ssh/sshd_config
	sed -i 's/\PermitEmptyPasswords yes/PermitEmptyPasswords no/g' /etc/ssh/sshd_config
	sed -i 's/\#PermitEmptyPasswords/PermitEmptyPasswords/g' /etc/ssh/sshd_config
	sed -i 's/.ssh\/authorized_keys/~\/.ssh\/authorized_keys/g' /etc/ssh/sshd_config
	sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
	sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

	firewall-cmd --add-port=$PORT/tcp --permanent
	firewall-cmd --reload
	sudo semanage port -a -t ssh_port_t -p tcp $PORT
	sudo systemctl reload sshd.service

	clear
	hostname=`hostname`
	ip_server=`hostname -I`
	echo "Edit SSH Config File:			sudo nano ~/.ssh/config"
	echo ""
	echo "Host " $hostname
	echo "	User root"
	echo "	Port " $PORT
	echo "	HostName " $ip_server
	echo "	IdentityFile PRIVATE_KEY"
}

# setup
if [ "$1" == "setup" ]; then
	setup_ssh_key
fi

# install
if [ "$1" == "install" ]; then
	[ "$2" == "git" ] && install_git
	[ "$2" == "docker" ] && install_docker
fi

# update
if [ "$1" == "pull" ]; then
	[ ! -d ".git" ] && { echo "not a git repository (or any of the parent directories): .git"; exit; }
	[ ! -f "docker-compose.yml" ] && { echo "not a docker-compose file"; exit; }

	git pull
	docker-compose build
	docker-compose up -d
	docker system prune
fi

# no command
if [ "$1" == "" ]; then
	clear
	echo "zash <command>"
	echo ""
	echo "Usage:"
	echo "	zash setup                      setup login ssh with private key and change port ssh"
	echo "	zash install git                install git and ssh key"
	echo "	zash install docker             install docker"
	echo "	zash pull                       git pull and docker rebuild to project"
fi

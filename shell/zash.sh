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
	echo "	zash install git                install git and ssh key to vps"
	echo "	zash install docker             install docker to vps"
	echo "	zash pull                       git pull and docker rebuild to project"
fi

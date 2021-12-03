#!/bin/bash
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# assuming the system is Debian
printf "${GREEN}Installing vim, tmux, and git${NC}\n"
sudo apt-get update
sudo apt-get install vim -y
sudo apt-get install tmux -y
sudo apt-get install git -y


printf "${GREEN}Pulling config files to home directory${NC}\n"
wget https://raw.githubusercontent.com/efemarai/sapphire/main/home/.vimrc -P ~
wget https://raw.githubusercontent.com/efemarai/sapphire/main/home/.tmux.conf -P ~


printf "${GREEN}Configuring git authorization${NC}\n"
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
printf "${YELLOW}Here is the generated public key: add it to your github account${NC}\n"
cat ~/.ssh/id_ed25519.pub
printf "${YELLOW}... then, press [Enter] to continue...${NC}\n"
read


printf "${GREEN}Installing docker${NC}\n"
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor \
  -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y


printf "${GREEN}Installing docker-compose${NC}\n"
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose


printf "${GREEN}Removing self${NC}\n"
rm docker_and_auth-ized_git.sh


printf "${GREEN}Starting tmux${NC}\n"
tmux

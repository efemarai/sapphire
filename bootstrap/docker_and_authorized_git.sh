#!/bin/bash
# To get and run this script, do this:
<<code
wget https://raw.githubusercontent.com/efemarai/sapphire/main/bootstrap/docker_and_authorized_git.sh
chmod +x docker_and_authorized_git.sh
. docker_and_authorized_git.sh
code
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Exports an environment variable to ~/.bashrc
# $1 is the name of the env var
# $2 is the value to be exported
# $3 (optional) is a string that will be prepended as a comment
export_env_var () {
  if  [ -n "$3" ]
  then
    echo "" >> ~/.bashrc
    echo "# $3" >> ~/.bashrc
  fi
  echo "export $1=$2" >> ~/.bashrc
}


if [ -n "$SAPPHIRE_BOOTSTRAP_COMPLETED" ]
then
  printf "${GREEN}Bootstrap script has already been run successfully.${NC}\n"
  printf "${GREEN}Unset SAPPHIRE_BOOTSTRAP_COMPLETED to force running it again.${NC}\n"
  exit 1
fi


# assuming the system is Debian
printf "${GREEN}Installing git, htop, make, tmux, unzip, vim, and wget${NC}\n"
sudo apt-get update
sudo apt-get install git -y
sudo apt-get install htop -y
sudo apt-get install make -y
sudo apt-get install tmux -y
sudo apt-get install unzip -y
sudo apt-get install vim-gtk -y # gtk to include python support
sudo apt-get install wget -y


printf "${GREEN}Pulling config files to home directory${NC}\n"
wget https://raw.githubusercontent.com/efemarai/sapphire/main/home/.vimrc -P ~
wget https://raw.githubusercontent.com/efemarai/sapphire/main/home/.tmux.conf -P ~

printf "${GREEN}Installing tmux plugin manager${NC}\n"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

printf "${GREEN}Installing vim plugins${NC}\n"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall


printf "${GREEN}Configuring git authorization${NC}\n"
# first, allow the instance to read the repo programatically
printf "${YELLOW}Please, generate a 'repo-read' access token for git.\n"
printf "(See https://github.com/settings/tokens):${NC} "
read gitkey
export_env_var "GIT_KEY" "$gitkey"

# then, allow the instance to access github
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
printf "${YELLOW}A public key was generated: please, add it to your github account${NC}\n"
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
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
export_env_var "DOCKER_BUILDKIT" "1"

sudo usermod -aG docker $USER

printf "${GREEN}Installing docker-compose${NC}\n"
sudo curl\
  -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)"\
  -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
export_env_var "COMPOSE_DOCKER_CLI_BUILD" "1"


printf "${GREEN}Removing self${NC}\n"
rm docker_and_authorized_git.sh


export_env_var\
  "SAPPHIRE_BOOTSTRAP_COMPLETED" "1"\
  "Setting this var to anything will prevent the bootstrap script from running again"


printf "${GREEN}Please login again, so that changes to group memeberships can take place${NC}\n"


unset RED
unset YELLOW
unset GREEN
unset NC

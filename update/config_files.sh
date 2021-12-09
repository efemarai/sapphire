#!/bin/bash
# To get and run this script, do this:
<<code
wget https://raw.githubusercontent.com/efemarai/sapphire/main/update/config_files.sh
chmod +x config_files.sh
. config_files.sh
code
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color


printf "${GREEN}Pulling config files to home directory${NC}\n"
wget https://raw.githubusercontent.com/efemarai/sapphire/main/home/.vimrc -P ~
wget https://raw.githubusercontent.com/efemarai/sapphire/main/home/.tmux.conf -P ~


unset RED
unset YELLOW
unset GREEN
unset NC

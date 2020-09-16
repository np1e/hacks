#!/bin/bash

git pull origin master

if which lsb_release; then
    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get -y install $(cat $(lsb_release -i -s)-$(lsb_release -r -s)-packages.txt)
fi

# install python packages
pip3 install --user awscli awsebcli virtualenv pipenv aws-shell
pip3 install --upgrade pip

# install zsh and oh-my-zsh
touch $HOME/.zshrc
sudo apt-get -y install zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
nvm install node

if [[ ! -d ~/.ssh ]]; then
    mkdir -p ~/.ssh
fi

if [[ ! -e ~/.ssh/sneak.keys ]]; then
    cd ~/.ssh && \
    wget https://github.com/np1e.keys && \
    cat *.keys > authorized_keys
fi

# setup dev directory structure and install config files
if [[ ! -e $HOME/dev/dotfiles ]]; then
    git clone https://github.com/np1e/dotfiles.git $HOME/dev/dotfiles
    ln -s $HOME/dev/dotfiles $HOME/dotfiles
fi
cd $HOME/dev/dotfiles
source bootstrap.sh --force


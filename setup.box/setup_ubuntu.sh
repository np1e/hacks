#!/bin/sh

if which lsb_release; then
    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get -y install $(cat $(lsb_release -i -s)-$(lsb_release -r -s)-packages.txt)
fi

# install python packages
pip3 install --user awscli awsebcli virtualenv pipenv aws-shell
pip3 install --upgrade pip

# install zsh and oh-my-zsh
printf 'n\n' | sudo apt-get -y install zsh
sudo chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
nvm install node


# setup dev directory structure and install config files
mkdir $HOME/dev
git clone https://github.com/np1e/dotfiles.git $HOME/dev
ln -s $HOME/dev/dotfiles $HOME/dotfiles
source $HOME/dev/dotfiles/bootstrap.sh

exec zsh


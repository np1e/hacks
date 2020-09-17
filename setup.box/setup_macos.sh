#!/bin/sh

# install Homebrew package manager
CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

if which brew >/dev/null 2>&1 ; then
    BREW_PREFIX=$(brew --prefix)
    brew update
    brew upgrade

    # install packages and apps
    brew install $(cat MacOS-packages.txt)
    brew cask install $(cat MacOS-casks.txt)
    ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"
fi

# install oh-my-zsh
if ! which zsh >/dev/null 2>&1 ; then
    brew install zsh
    chsh -s $(which zsh)
fi
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo 'source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme' >>! ~/.zshrc


# install python via pyenv
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
pyenv init -
pyenv install 2.7
pyenv install 3.7
pyenv global 3.7
pyenv rehash

if pip --version; then
    pip install virtualenv
    pip install --user awscli awsebcli virtualenv pipenv aws-shell
    pip install --upgrade pip
fi

if pip3 --version; then
    pip3 install virtualenv
    pip3 install --user awscli awsebcli virtualenv pipenv aws-shell
    pip3 install --upgrade pip
fi

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
cd $HOME/dev/dotfiles && git pull origin master
chmod u+x bootstrap.sh
./bootstrap.sh --force

brew cleanup
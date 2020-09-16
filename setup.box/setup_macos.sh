#!/bin/sh

# install Homebrew package manager
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

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
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)

echo 'source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme' >>! ~/.zshrc

# setup dev directory structure and install config files
mkdir $HOME/dev
git clone https://github.com/np1e/dotfiles.git $HOME/dev
ln -s $HOME/dev/dotfiles $HOME/dotfiles
source $HOME/dev/dotfiles/bootstrap.sh

echo 'eval "$(pyenv init -)"' >> ~/.zshrc
pyenv init -
pyenv install 2.7
pyenv install 3.7
pyenv global 3.7
pyenv rehash

if pip --version; then
    pip install virtualenv
fi

if pip3 --version; then
    pip3 install virtualenv
fi


brew cleanup
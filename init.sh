#!/bin/bash

# create dirs
mkdir -p $HOME/repos
mkdir -p $HOME/bin

cd $HOME

# pyenv 
git clone git://github.com/yyuu/pyenv.git ~/.pyenv

## cpanminus
curl https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm | perl - -l ~/perl5 App::cpanminus local::lib
eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`

# dotfiles
cd $HOME
git clone https://github.com/dakl/dotfiles.git
cd dotfiles
source bootstrap.sh --force

# python 2.7.8
pyenv install 2.7.8

## verticalize
git clone https://github.com/lindenb/verticalize.git $HOME/repos/verticalize
cd $HOME/repos/verticalize
make
cd $HOME/bin
ln -s $HOME/repos/verticalize/verticalize

## bumpversion
pip install --upgrade bumpversion

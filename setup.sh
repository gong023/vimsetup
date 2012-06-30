#!/bin/sh
ORIGIN=$(pwd)
mkdir -p $HOME/tmp/vimsetup
WORKSPACE=$HOME/tmp/vimsetup
which vim > ${WORKSPACE}/command.list
which vi >> ${WORKSPACE}/command.list

while read line 
do
    cp $line ${WORKSPACE}
done <${WORKSPACE}/command.list

cd ${WORKSPACE}
wget ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2
tar jxvf vim-7.3.tar.bz2
cd vim73
sudo ./configure --enable-multibyte --enable-xim --enable-fontset --enable-perlinterp --enable-rubyinterp --enable-pythoninterp --disable-selinux --disable-gui
sudo make
sudo make install

if [ ! -a ./src/vim ]; then
    echo "sorry.make vim7.3 failed"
    exit 1
fi

while read line 
do
    cp ./src/vim $line 
done <${WORKSPACE}/command.list

cp -r $HOME/.vim/ ${WORKSPACE}
cp $HOME/.vimrc ${WORKSPACE}

cp ${ORIGIN}/vimsetup/.vimrc $HOME/
mkdir -p $HOME/.vim/bundle
cd $HOME/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim.git 
git clone https://github.com/Shougo/vimproc.git
cd vimproc
make -f make_unix.mak

rm ${WORKSPACE}/command.list
cd ${ORIGIN}

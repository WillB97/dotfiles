#! /bin/bash
mkdir -p ~/.vim/autoload
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

mkdir -p ~/.vim/bundle
cd ~/.vim/bundle/
git clone https://github.com/vim-airline/vim-airline
git clone https://github.com/tpope/vim-surround.git
git clone https://github.com/tpope/vim-commentary.git
git clone https://github.com/tpope/vim-repeat.git
git clone git://github.com/nachumk/systemverilog.vim


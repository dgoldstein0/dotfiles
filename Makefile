~/.vimrc:
	ln -s ~/settings_files/vimrc ~/.vimrc

~/.vim:
	mkdir ~/.vim

install_coffeevim: ~/.vim
	bash -c "cd ~/.vim; unzip ~/settings_files/vim-coffee-script-v002.zip"

~/.inputrc:
	ln -s ~/settings_files/inputrc ~/.inputrc

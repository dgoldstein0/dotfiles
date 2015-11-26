~/.vimrc:
	ln -s ~/settings_files/vimrc ~/.vimrc

~/.vim:
	ln -s ~/settings_files/.vim ~/.vim

~/.inputrc:
	ln -s ~/settings_files/inputrc ~/.inputrc

# only run this once
install_gitconfig:
	echo -e "[include]\n\tpath = settings_files/gitconfig" >> ~/.gitconfig

# only run this once
install_hgrc:
	echo -e "\n%include settings_files/hgrc\n" >> ~/.hgrc

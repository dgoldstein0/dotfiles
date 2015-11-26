~/.vimrc:
	ln -s ~/settings_files/vimrc ~/.vimrc

~/.vim:
	symlink.sh $(HOME)/settings_files/.vim/ $(HOME)/.vim/ $(HOME)/vimfiles/

~/.inputrc:
	ln -s ~/settings_files/inputrc ~/.inputrc

# only run this once
install_gitconfig:
	echo -e "[include]\n\tpath = settings_files/gitconfig" >> ~/.gitconfig

# only run this once
install_hgrc:
	echo -e "\n%include settings_files/hgrc\n" >> ~/.hgrc

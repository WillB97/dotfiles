#!/bin/bash
printout=""

if [[ $1 == "-l" ]]; then
	echo printing only
	printout="1"
fi

function backup_and_link() {
	if [[ "$3" == "sudo" ]]; then # handle sudo
		ELEV="sudo "
	else
		ELEV=""
	fi

	if [[ $printout == "1" ]]; then 
		echo '#' ${ELEV} ln -s "$PWD/$1" "${2%/}"
	else
		echo "Linking $1 out to $2"
		if [[ -d "$2" ]] || [[ -f "$2" ]]; then # if file or folder exists
			${ELEV} mv "${2%/}" "${2%/}.old" # move to .old
		else
			${ELEV} mkdir -p "$(dirname $2)"
		fi
		${ELEV} ln -s "$PWD/$1" "${2%/}" # create symlink
	fi
}
function sudo_replace() {
	ELEV="sudo "
	if [[ $printout == "1" ]]; then 
		echo '#' ${ELEV} cp "$PWD/$1" "${2%/}"
	else
		echo "Copying $1 to $2"
		if [[ -d "$2" ]] || [[ -f "$2" ]]; then # if file or folder exists
			${ELEV} mv "${2%/}" "${2%/}.old" # move to .old
		else
			${ELEV} mkdir -p "$(dirname $2)"
		fi
		${ELEV} cp "$PWD/$1" "${2%/}" # create symlink
	fi
}

cd "$(dirname $0)"

backup_and_link gitignore ~/.gitignore
backup_and_link gitmessage ~/.gitmessage
backup_and_link taskrc ~/.taskrc
backup_and_link tmux.conf ~/.tmux.conf
backup_and_link zsh-plugins/ ~/.oh-my-zsh/custom/
backup_and_link vimrc ~/.vimrc
backup_and_link zshrc ~/.zshrc

if [[ `uname` == "Darwin" ]]; then
	backup_and_link latexmkrc_mac ~/.latexmkrc
else
	backup_and_link rsync_exclude ~/.rsync_exclude
	backup_and_link latexmkrc_linux ~/.latexmkrc
	backup_and_link i3blocks.conf ~/.i3blocks.conf
	backup_and_link rofi.conf ~/.config/rofi/config
	backup_and_link i3.conf ~/.config/i3/config
	backup_and_link i3blocks/ ~/.config/i3blocks/
	backup_and_link bat.conf ~/.config/bat/config
	backup_and_link pulse/client.conf ~/.config/pulse/client.conf
	backup_and_link pulse/daemon.conf ~/.config/pulse/daemon.conf
	backup_and_link pulse/default.pa ~/.config/pulse/default.pa
	backup_and_link profile ~/.profile

	sudo_replace resume@.service /etc/systemd/system/resume@.service
	sudo_replace suspend@.service /etc/systemd/system/suspend@.service
	if [[ $printout == "1" ]]; then
		echo "# sudo systemctl enable resume@$USER"
		echo "# sudo systemctl enable suspend@$USER"
	else
		sudo systemctl enable resume@$USER
		sudo systemctl enable suspend@$USER
	fi
	sudo_replace 30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
	sudo_replace 99-USBasp.rules /etc/udev/rules.d/99-USBasp.rules
fi

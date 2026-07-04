#!/bin/bash

function headerInfo() {
	echo "--------------$1------------\n"
}

root_dir="$(dirname "$(realpath "$0")")"

mkdir -p ~/.config

printf "Creating symlinks to config files\n"

# Configuring zsh
printf "{.zshrc}\n"
if [ ! -f ~/.zshrc ]; then
	printf "Creating symlink for {~/.zshrc} -> {config/.zshrc}\n"
	ln -s ~/pcBootstrap/config/.zshrc ~/.zshrc
else
	printf "{~/.zshrc} already exists\n"
fi

# Make zsh the default bash
desired_shell="zsh"
default_shell=$(getent passwd $USER)
default_shell=$(getent passwd $USER | cut -d : -f 7)
if [[ $default_shell == *"${desired_shell}"* ]]; then
	printf "Already running {${desired_shell}}\n"
else
	printf "Attempting to change default shell.\n"
	chsh -s $(which ${desired_shell})
fi


headerInfo "starship"
printf "{.config/starship.toml}\n"
if [ ! -f ~/.config/starship.toml ]; then
	printf "Creating symlink for {~/.config/starship.toml} -> {config/starship.toml}\n"
	ln -s ~/pcBootstrap/config/starship.toml ~/.config/starship.toml
else
	printf "{~/.config/starship.toml} already exists\n"
fi

headerInfo "tmux"
printf "{.tmux.conf}\n"
if [ ! -f ~/.tmux.conf ]; then
	printf "Creating symlink for {~/.tmux.conf} -> {config/tmux.conf}\n"
	ln -s ~/pcBootstrap/config/tmux.conf ~/.tmux.conf
else
	printf "{~/.tmux.conf} already exists\n"
fi

headerInfo "nvim"
printf "Configuring nvim in {.config/nvim}\n"
if [ ! -f ~/.config/nvim ]; then
	printf "Creating symlink for {~/.config/nvim} -> {config/nvim}\n"
	ln -s ~/pcBootstrap/config/nvim ~/.config/nvim
else
	printf "{~/.config/nvim} already exists\n"
fi

headerInfo "ssh"
if [ ! -f ~/.ssh/id_ed25519 ]; then
	ssh-keygen -t ed25519 -C "maxspahn3@yahoo.de"
	if [ -z "$SSH_AUTH_SOCK" ]; then
		eval "$(ssh-agent -s)"
	fi
	ssh-add "~/.ssh/id_ed25519"
	cat ~/.ssh/id_ed25519 | xclip -selection clipboard
	printf "Added ssh key and added public key to clipboard"
else
	printf "{~/.ssh/id_ed25519.pub} already exists\n"
fi



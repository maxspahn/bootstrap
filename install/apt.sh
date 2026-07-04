#!/bin/bash

headerInfo () {
	echo "---------Installing $1--------"
}

root_dir="$(dirname "$(realpath "$0")")"

package_list_file_apt="${root_dir}/packages"
package_list_file_curl="${root_dir}/linux_x86_64/packages"

printf "Using apt to install packages from ${package_list_file_apt}\n"

while read p; do
	headerInfo "${p}"
	if dpkg -s $p >/dev/null 2>&1; then
		printf "Package {$p} found using dpkg\n"
		printf "Skipping installation.\n"
	else
		install_command="sudo apt install -y $p"
		printf "Installation of package using {$install_command}"
		$install_command
		printf "Done installing $p\n"
	fi
done <${package_list_file_apt}

tmp_dir="$root_dir/temp"
mkdir -p $tmp_dir

# Install latest stable neovim
# package_name=${p% *}
# package_address=${p#* }
headerInfo "nvim"
package_name="nvim"
package_location="$(which $package_name)"
package_address="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
neovim_tar_location="neovim.tar.gz"
if [ $package_location ]; then
  printf "Package {$package_name} found in {$package_location}\n"
  printf "Skipping installation.\n"
else
	cd $tmp_dir
	wget -O $neovim_tar_location $package_address
	tar -xvf $neovim_tar_location -C ~/.local/
	echo "Setting up symlink"
	ln -sf ~/.local/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
fi

rm -rf tmp_dir


headerInfo "Nerdfonts"
# Check if font is already installed
font_name="FiraCode Nerd Font"
if fc-list | grep -q "$font_name"; then
  echo "$font_name is already installed."
else
	# Download and install FiraCode Nerd Font
	font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
	temp_dir=$(mktemp -d)
	printf "Getting font\n"
	wget "$font_url" -O "$temp_dir/FiraCode.zip"
	unzip "$temp_dir/FiraCode.zip" -d "$temp_dir"

	# Install font for current user
	mkdir -p ~/.local/share/fonts
	cp "$temp_dir"/*.ttf ~/.local/share/fonts/

	# Update font cache
	fc-cache -fv

	echo "FiraCode Nerd Font installed successfully."
fi

headerInfo "starship"
package_name="starship"
package_location="$(which $package_name)"
if [ $package_location ]; then
	printf "Package {$package_name} found in {$package_location}\n"
	printf "Skipping installation.\n"
else
	curl -sS https://starship.rs/install.sh | sh
fi

headerInfo "pyenv"
package_name="pyenv"
package_location="$(which $package_name)"
if [ $package_location ]; then
	printf "Package {$package_name} found in {$package_location}\n"
	printf "Skipping installation.\n"
else
	curl -fsSL https://pyenv.run | bash
fi

headerInfo "node/npm"
package_name="node"
package_location="$(which $package_name)"
if [ $package_location ]; then
	printf "Package {$package_name} found in {$package_location}\n"
	printf "Skipping installation.\n"
else
	# Download and install nvm:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash

	# in lieu of restarting the shell
	\. "$HOME/.nvm/nvm.sh"

	# Download and install Node.js:
	nvm install 24

	# Verify the Node.js version:
	node -v # Should print "v24.18.0".

	# Verify npm version:
	npm -v # Should print "11.16.0".
fi

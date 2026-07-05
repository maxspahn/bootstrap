#!/bin/bash

headerInfo () {
	echo "---------Installing $1--------"
}

root_dir="$(dirname "$(realpath "$0")")"

package_list_file_apt="${root_dir}/apt_packages"

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


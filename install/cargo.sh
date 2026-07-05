#!/bin/bash

headerInfo () {
	echo "---------Installing $1--------"
}

root_dir="$(dirname "$(realpath "$0")")"

package_list_file_cargo="${root_dir}/cargo_packages"

printf "Using cargo to install rust packages from ${package_list_file_cargo}\n"

while read p; do
	headerInfo "${p}"
	if cargo install --list | grep -q $p; then
		printf "Package {$p} found using cargo install --list\n"
		printf "Skipping installation.\n"
	else
		install_command="cargo install --locked $p"
		printf "Installation of package using {$install_command}"
		$install_command
		printf "Done installing $p\n"
	fi
done <${package_list_file_cargo}


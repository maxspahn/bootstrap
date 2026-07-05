#!/bin/bash

headerInfo () {
	echo "---------Installing $1--------"
}

root_dir="$(dirname "$(realpath "$0")")"

package_list_file_npm="${root_dir}/npm_packages"

printf "Using cargo to install rust packages from ${package_list_file_npm}\n"

while read p; do
	headerInfo "${p}"
	if npm list -g | grep -q $p; then
		printf "Package {$p} found using npm list -g\n"
		printf "Skipping installation.\n"
	else
		install_command="npm install -g $p"
		printf "Installation of package using {$install_command}"
		$install_command
		printf "Done installing $p\n"
	fi
done <${package_list_file_npm}


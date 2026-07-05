# !/bin/bash
#
call_install() {
	echo "Calling install script ${1}"
	bash $1
}


echo "Starting Installation."

install_dir="$(dirname "$(realpath "$0")")"

echo "Executing installation from ${install_dir}"

apt_install_script="${install_dir}/apt.sh"

call_install ${apt_install_script}

manual_install_script="${install_dir}/manual.sh"

call_install ${manual_install_script}

cargo_install_script="${install_dir}/cargo.sh"

call_install ${cargo_install_script}

npm_install_script="${install_dir}/npm.sh"

call_install ${npm_install_script}


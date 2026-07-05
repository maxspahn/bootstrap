#!/bin/bash

echo "Starting Bootstrapping."

root_dir="$(dirname "$(realpath "$0")")"

echo "Executing bootstrap from ${root_dir}"

mkdir -p ~/.local/bin

printf "Start Installing....\n"

install_script="${root_dir}/install/install.sh"

bash "${install_script}"

echo "Done Installing.\n"

printf "Start Configuring...\n"

config_script="${root_dir}/config/config.sh"

bash "${config_script}"


printf "Done Configuring\n"




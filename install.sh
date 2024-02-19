#!/bin/bash

# Verifica si se proporciona la versión como argumento
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <version> [--force]"
    exit 1
fi

version="$1"
force=false

# Verificar si se proporciona la opción --force
if [ "$#" -eq 2 ] && [ "$2" == "--force" ]; then
    force=true
fi

core_url="http://swd.cl/cod1/bin/core.zip"
version_url="http://swd.cl/cod1/bin/${version}.zip"
main_folder="main"
installation_info_file="installation_info.txt"

# Verificar permisos de escritura
if [ ! -w "$main_folder" ]; then
    echo "You don't have enough permissions over $main_folder folder."
    exit 1
fi

# Crear carpeta main si no existe
mkdir -p $main_folder

# Verificar si se debe forzar la instalación del core
if [ "$force" == "true" ]; then
    echo "Forcing installation and download..."
    echo "Downloading core files..."
    wget -q --show-progress $core_url -O core.zip
    unzip -oq core.zip && cp core/* main/
    rm -rf core core.zip
    echo "Core installed" > "$installation_info_file"
else
    # Solo descargar el core si no está instalado
    if [ ! -f "$installation_info_file" ]; then
        echo "Downloading core files..."
        wget -q --show-progress $core_url -O core.zip
        unzip -oq core.zip && cp core/* main/
        rm -rf core core.zip
        echo "Core installed" > "$installation_info_file"
    fi
fi

# Verificar si la versión está instalada
if [ "$force" == "true" ] || ( [ -f "$installation_info_file" ] && ! grep -q "Version $version installed" "$installation_info_file" ); then
    echo "Forcing download of version ${version} files..."
    wget -q --show-progress $version_url -O ${version}.zip

    if [ -f "${version}.zip" ]; then
        echo "Installing base files of version ${version}"
        unzip -oq ${version}.zip && cp ${version}/* main/
        rm -rf ${version}*
        sed -i "/^Version/c\Version $version installed" "$installation_info_file"
    else
        echo "Error downloading version ${version}."
    fi
else
    echo "Version $version is already installed."
fi

echo "Installation completed successfully."

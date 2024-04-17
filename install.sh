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


# Verifica si el core esta instalado. O si force es true.
if [ ! -f "$installation_info_file" -o "$force" == "true"  ]; then

    # If installing core, removes any installed version
    #if [ "$force" == "true" ]; then
        echo "Removing core & any installed version"

        rm -rf main/pak*
        rm -rf main/loc*
        rm -rf cod_lnxded
        rm -rf installation_info.txt
    #fi

    echo "Downloading core files..."
    wget -q --show-progress $core_url -O core.zip

    echo "Installing core files..."
    unzip -oq core.zip && cp core/* main/

    # Removing remaining .zip
    rm -rf core core.zip

    echo "Core installed" > "$installation_info_file"
else
    echo "Core is already installed."
fi




# Verificar si la versión está instalada
if [ "$force" == "true" ] || ( [ -f "$installation_info_file" ] && ! grep -q "Version $version installed" "$installation_info_file" ); then
#    # Removes any existing version.
#    rm -rf main/pak*
#    rm -rf main/loc*

    echo "Downloading files of version ${version}..."
    wget -q --show-progress $version_url -O ${version}.zip

    echo "Installing base files of version ${version}"
    unzip -oq ${version}.zip && cp -r ${version}/* ./ && rm -r ${version} && rm ${version}.zip

    chmod +x cod_lnxded

    #unzip -oq ${version}.zip && cp -r ${version}/* main/ && cp main/cod_lnxded cod_lnxded
    #chmod +x cod_lnxded
    #sudo cp -r 1.5/* .
    #rm -rf ${version}*

    sed -i "/^Version/c\Version $version installed" "$installation_info_file"
else
    echo "Version $version is already installed."
fi

echo "Installation completed successfully."

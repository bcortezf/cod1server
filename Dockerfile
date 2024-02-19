FROM i386/debian:buster

# Establecer el directorio de trabajo
WORKDIR /data/myserver

# Agregar las dependencias en tiempo de ejecución de codextended lib
RUN apt-get update && \
    apt-get -y install curl libidn11 libssh2-1 libmariadb3 librtmp1 libldap-2.4-2 libgssapi-krb5-2 libstdc++5 && \
    ln -s /usr/lib/i386-linux-gnu/librtmp.so.1 /usr/lib/i386-linux-gnu/librtmp.so.0

# Lista de nombres de archivos a descargar
ARG FILE_LIST="pak6.pk3"

# Mensaje informativo durante la construcción de la imagen
RUN echo "Downloading basefiles"

# Crear el directorio 'main'
RUN mkdir -p /data/myserver/main

# Descargar archivos desde la URL proporcionada y moverlos a la carpeta 'main'
RUN for FILE in $FILE_LIST; do \
        echo "Downloading $FILE;" && \
        curl -O https://de.dvotx.org/dump/cod1/basefiles/$FILE && \
        mv $FILE /data/myserver/main/$FILE; \
done

# Verificar que los archivos se hayan descargado correctamente
RUN ls -l main

# Exponer los puertos necesarios
EXPOSE 20500/udp 20510/udp 28960/tcp 28960/udp

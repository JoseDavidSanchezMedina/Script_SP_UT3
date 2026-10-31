#!/bin/bash

# Crearemos tres variables, la primera será donde se almacenarán las copias de seguridad como pide el ejercicio.
# La segunda variable almacenará una marca para poder saber cual eliminar luego.
# La tercera variable almacenará el nombre asi como la fecha con el numero de semana del año (+%V)
destino="/bacjosedavids"
marca="$destino/.ultima_total"
nombre="$destino/CopDifSem-$(date +%V).tar.gz"

# Luego con el siguiente if comprobamos que existe la marca que creamos cuando creamos la copia de seguridad, si existe con --newer-mtime lo que estamos haciendo es
# comprimir los datos con una fecha posterior a la de la marca. Si no existe una marca se copiará una completa.
# El 2>/dev/null se utiliza para silenciar los errores que pueda haber a la hora de cla copia de seguridad.
if [[ -f "$marca" ]]; then
    tar -czf "$nombre" --newer-mtime="$(date -r "$marca" '+%Y-%m-%d %H:%M:%S')" /home 2>/dev/null
else

    tar -czf "$nombre" /home 2>/dev/null
fi


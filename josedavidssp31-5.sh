#!/bin/bash

# Con el if comprobamos de que el que esté ejecutando sea el usuario root.
if [ "$EUID" -ne 0 ]; then
    echo "Error: Debes ejecutar este script con sudo o como root."
    exit 1
fi

# Creamos una variable que almacenará la ruta  donde se guardará el informe final
informe="informe_errores_sistema.txt"

# Con los siguientes echos lo que estoy haciendo es crear una especie de cabecera antes de que se vuelquen los datos del log.
echo "Fecha del informe: $(date)" > "$informe"
echo "==================================================" >> "$informe"
echo "" >> "$informe"

# Usaremos un bucle for para reccorrer todos los elementos que hay dentro de /var/log
for fichero in /var/log/*; do

# Dentro del bucle con el siguiente if nos aseguramos de que sea un fichero normal (y no otro directorio)
    if [ -f "$fichero" ]; then

# Creamos la variable coincidencia para almacenar lo que nos pide el ejercicio (error y fail) esto lo encontraremos filtrando con grep -i (ignora si son mayúsculas o minúsculas)
# y -E para poder buscar las dos palabras con |
# El 2>/dev/null se usa para ocultar los mensajes de error que nos pueda generar al leer el archivo de permisos denagados.
        coincidencias=$(grep -i -E "error|fail" "$fichero" 2>/dev/null)

# Con el siguiente if estamos buscando si la variable coincidencia tiene texto (-n), si lo tiene lo almacena dentro del informe.
        if [[ -n "$coincidencias" ]]; then
            echo "=====================================================================================" >> "$informe"
            echo "FICHERO DE ORIGEN: $fichero" >> "$informe"
            echo "====================================================================================" >> "$informe"
            echo "$coincidencias" >> "$informe"
            echo "" >> "$informe"
        fi

    fi
done
echo "Informe generado"

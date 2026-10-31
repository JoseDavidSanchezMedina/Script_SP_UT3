#!/bin/bash

# Crearemos dos variables una será para almacenar el umbral de 80% que pide el ejercicio, esto luego solo compararemos si el porcentaje es mayor que este umbral.
# La segunda variable será donde se guarde el log de la alerta cuando se supere el umbral.
umbral=1
registro="/var/log/disco_josedavids.log"


# df es el comando básico para ver el espacio en disco por lo que lo usaremos.  -P da una línea por partición; -x excluye sistemas virtuales (tmpfs, etc.) o temporales como los de la memoria RAM
# tail -n +2 quita la cabecera para ver los datos reales (limpios) 
# El while read -r va leyendo linea por linea y almacenando los valores en als variables sf, bloques, usado, libre, uso, montaje
df -P -x tmpfs -x devtmpfs -x squashfs | tail -n +2 | while read -r sf bloques usado libre uso montaje; do
    porcentaje=${uso%\%}     # %/% nos ayuuda a quitar el símbolo % para poder comparar números en el if

# Con el if comparamos el valor que nos da el procentaje con el umbral que establecimos. Una vez comparado si es mayor que el umbral escribirá la fecha, la partición, el uso en la ruta que esta
# en la variable registro.
    if [[ "$porcentaje" -gt "$umbral" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Partición: $montaje ($sf) - Uso: $porcentaje%" >> "$registro"
    fi
done

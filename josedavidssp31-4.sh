#!/bin/bash
# En la variable fichero guardamos programa.txt que debe estar en la misma carpeta que el script.
fichero="programas.txt"

# Con el if buscamos si el usuario que ejecuta el script sea root ($EUID -ne 0), si no lo es saldrá del sccript (exit 1).
if [[ "$EUID" -ne 0 ]]; then
    echo "Ejecuta el script con sudo."
    exit 1
fi

# Con este if lo que estamos buscando es que el fichero programa.txt exista, si no existe saldrá del script.
if [[ ! -f "$fichero" ]]; then
    echo "No existe el fichero $fichero"
    exit 1
fi

# Con while read -r programa lo que estamos haciendo es leer el fichero linea por linea y guardandolo en la variable programa. Con -r evitamos errores de caracteres o barras invertidos.
# Con la opción -n programa nos aseguramos de que el fichero se lea al 100% aunqeu el fichero no tenga un salto de linea al final.
while read -r programa || [[ -n "$programa" ]]; do

# Con -z se comprueba si la variable programa tiene lineas vacias y se las salta con && continue
    [[ -z "$programa" ]] && continue

# dpkg -s comprueba si el paquete está instalado. Con /dev/null hará la comprobación de forma silenciosa
# Con apt remove lo eliminamos.
    if dpkg -s "$programa" &>/dev/null; then
        echo " Desinstalando $programa ..."
        apt remove -y "$programa"
        echo "   $programa desinstalado."
    else
# No se detiene: avisa y pasa a la siguiente linea para la eliminación.
        echo "$programa no está instalado. Paso al siguiente."
    fi

done < "$fichero"
echo "Proceso terminado."
